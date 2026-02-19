<%@ WebHandler Language="C#" Class="PurchaseClosingBillHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : PurchaseClosingBillHandler.ashx
/// Description     : 매입마감현황 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class PurchaseClosingBillHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingPurchase/PurchaseClosingList"; //필수

    // 메소드 리스트
    private const string MethodPurchaseClosingList   = "PurchaseClosingList";      //매입 전표 목록
    private const string MethodPurchaseClosingCnl    = "PurchaseClosingCancel";    //매입 마감 취소
    private const string MethodHometaxList           = "HometaxList";              //계산서 목록
    private const string MethodHometaxItemList       = "HometaxItemList";          //계산서 비용 목록
    private const string MethodHometaxPreMatchingCnl = "HometaxPreMatchingCancel"; //계산서 매칭

    PurchaseDasServices    objPurchaseDasServices    = new PurchaseDasServices();
    CargopayDasServices    objCargopayDasServices    = new CargopayDasServices();
    private HttpContext    objHttpContext            = null;

    private string strCallType             = string.Empty;
    private string strCenterCode           = string.Empty;
    private string strPurchaseClosingSeqNo = string.Empty;
    private string strNtsConfirmNum        = string.Empty;
    private string strBillWrite            = string.Empty;
    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPurchaseClosingList,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseClosingCnl,    MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodHometaxList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodHometaxItemList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodHometaxPreMatchingCnl, MenuAuthType.ReadWrite);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        objHttpContext = context;

        try
        {
            strCallType  = SiteGlobal.GetRequestForm("CallType");

            //1.Request
            GetData();
            if (!objResMap.RetCode.Equals(0))
            {
                return;
            }

            //2.처리
            Process();
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9401;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingBillHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("PurchaseClosingBillHandler");
        }
    }

    ///------------------------------
    /// <summary>
    /// 파라미터 데이터 설정
    /// </summary>
    ///------------------------------
    private void GetData()
    {
        try
        {
            strCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),           "0");
            strPurchaseClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseClosingSeqNo"), "0");
            strBillWrite            = SiteGlobal.GetRequestForm("BillWrite");
            strNtsConfirmNum        = SiteGlobal.GetRequestForm("NtsConfirmNum");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingBillHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    ///------------------------------
    /// <summary>
    /// 실행 메소드 처리함수
    /// </summary>
    ///------------------------------
    private void Process()
    {
        try
        {
            switch (strCallType)
            {
                case MethodPurchaseClosingList:
                    GetPurchaseClosingList();
                    break;
                case MethodPurchaseClosingCnl:
                    SetPurchaseClosingCnl();
                    break;
                case MethodHometaxList:
                    GetHometaxList();
                    break;
                case MethodHometaxItemList:
                    GetHometaxItemList();
                    break;
                case MethodHometaxPreMatchingCnl:
                    SetHometaxPreMatchingCnl();
                    break;
                default:
                    objResMap.RetCode = 9500;
                    objResMap.ErrMsg  = "Wrong Method" + strCallType;
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9403;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingBillHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매입 전표 목록
    /// </summary>
    protected void GetPurchaseClosingList()
    {
        ReqPurchaseClosingList                lo_objReqPurchaseClosingList = null;
        ServiceResult<ResPurchaseClosingList> lo_objResPurchaseClosingList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo) || strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingList = new ReqPurchaseClosingList
            {
                PurchaseClosingSeqNo  = strPurchaseClosingSeqNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                AccessCenterCode      = objSes.AccessCenterCode
            };

            lo_objResPurchaseClosingList = objPurchaseDasServices.GetPurchaseClosingList(lo_objReqPurchaseClosingList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감 취소
    /// </summary>
    protected void SetPurchaseClosingCnl()
    {
        ReqPurchaseClosingCnl lo_objReqPurchaseClosingCnl = null;
        ServiceResult<bool>   lo_objResPurchaseClosingCnl = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingCnl = new ReqPurchaseClosingCnl
            {
                CenterCode            = strCenterCode.ToInt(),
                PurchaseClosingSeqNos = strPurchaseClosingSeqNo,
                ChkPermFlag           = "Y",
                CnlAdminID            = objSes.AdminID,
                CnlAdminName          = objSes.AdminName
            };

            lo_objResPurchaseClosingCnl = objPurchaseDasServices.SetPurchaseClosingCnl(lo_objReqPurchaseClosingCnl);
            objResMap.RetCode           = lo_objResPurchaseClosingCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseClosingCnl.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 계산서 매칭 취소
    /// </summary>
    protected void SetHometaxPreMatchingCnl()
    {
        ReqPreMatchingDel             lo_objReqPreMatchingDel             = null;
        ServiceResult<bool>           lo_objResPreMatchingDel             = null;
        ReqPurchaseClosingBillInfoUpd lo_objReqPurchaseClosingBillInfoUpd = null;
        ServiceResult<bool>           lo_objResPurchaseClosingBillInfoUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo) || strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNtsConfirmNum))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPreMatchingDel = new ReqPreMatchingDel
            {
                CENTER_CODE    = strCenterCode.ToInt(),
                CLOSING_SEQ_NO = strPurchaseClosingSeqNo
            };

            lo_objResPreMatchingDel = objCargopayDasServices.SetPreMatchingDel(lo_objReqPreMatchingDel);
            objResMap.RetCode       = lo_objResPreMatchingDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = "계산서 매칭 삭제에 실패했습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqPurchaseClosingBillInfoUpd = new ReqPurchaseClosingBillInfoUpd
            {
                CenterCode            = strCenterCode.ToInt(),
                PurchaseClosingSeqNos = strPurchaseClosingSeqNo,
                BillStatus            = 1,
                BillKind              = 99,
                BillWrite             = strBillWrite,
                ChkPermFlag           = "Y",
                UpdAdminID            = objSes.AdminID,
                UpdAdminName          = objSes.AdminName
            };

            lo_objResPurchaseClosingBillInfoUpd = objPurchaseDasServices.SetPurchaseClosingBillInfoUpd(lo_objReqPurchaseClosingBillInfoUpd);
            objResMap.RetCode                   = lo_objResPurchaseClosingBillInfoUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseClosingBillInfoUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 계산서 목록 조회
    /// </summary>
    protected void GetHometaxList()
    {
        ReqApproveHometaxApiList                lo_objReqApproveHometaxApiList = null;
        ServiceResult<ResApproveHometaxApiList> lo_objResApproveHometaxApiList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNtsConfirmNum))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqApproveHometaxApiList = new ReqApproveHometaxApiList
            {
                CENTER_CODE     = strCenterCode.ToInt(),
                NTS_CONFIRM_NUM = strNtsConfirmNum
            };

            lo_objResApproveHometaxApiList = objCargopayDasServices.GetApproveHometaxApiList(lo_objReqApproveHometaxApiList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResApproveHometaxApiList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 계산서 비용 목록 조회
    /// </summary>
    protected void GetHometaxItemList()
    {
        ServiceResult<ResApproveHometaxItemList> lo_objResApproveHometaxItemList = null;

        if (string.IsNullOrWhiteSpace(strNtsConfirmNum))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResApproveHometaxItemList = objCargopayDasServices.GetApproveHometaxItemList(strNtsConfirmNum);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResApproveHometaxItemList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    #endregion


    ///--------------------------------------------
    /// <summary>
    /// 페이지 기본 Json 응답 출력
    /// </summary>
    ///--------------------------------------------
    public override void WriteJsonResponse(string strLogFileName)
    {
        try
        {
            base.WriteJsonResponse(strLogFileName);
        }
        catch
        {
        }
    }
}