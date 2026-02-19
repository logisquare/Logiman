<%@ WebHandler Language="C#" Class="SQIHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using System;
using System.Web;
using CommonLibrary.Extensions;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : SQIHandler.ashx
/// Description     : 오더 SQI Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemSQIHandler
/// Author          : sybyun96@logislab.com, 2022-08-11
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SQIHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/SQIList"; //필수

    // 메소드 리스트
    private const string MethodOrderList      = "OrderList";        //오더정보
    private const string MethodSQIItemList    = "SQIItemList";      //서비스이슈 유형 리스트
    private const string MethodSQIList        = "SQIList";          //서비스이슈 리스트
    private const string MethodSQIIns         = "SQIInsert";        //서비스이슈 등록
    private const string MethodSQIUpd         = "SQIUpdate";        //서비스이슈 수정
    private const string MethodSQIDel         = "SQIDelete";        //서비스이슈 삭제
    private const string MethodSQICommentList = "SQICommentList";   //댓글 리스트 
    private const string MethodSQICommentIns  = "SQICommentInsert"; //댓글 등록
    private const string MethodSQICommentDel  = "SQICommentDelete"; //댓글 삭제

    OrderDasServices     objOrderDasServices     = new OrderDasServices();
    ContainerDasServices objContainerDasServices = new ContainerDasServices();

    private string strCallType           = string.Empty;
    private int    intPageSize           = 0;
    private int    intPageNo             = 0;
    private string strCenterCode         = string.Empty;
    private string strOrderNo            = string.Empty;
    private string strSQISeqNo           = string.Empty;
    private string strItemSeqNo          = string.Empty;
    private string strOrderItemCode      = string.Empty;
    private string strYMD                = string.Empty;
    private string strDetail             = string.Empty;
    private string strTeam               = string.Empty;
    private string strContents           = string.Empty;
    private string strAction             = string.Empty;
    private string strCause              = string.Empty;
    private string strFollowUp           = string.Empty;
    private string strCost               = string.Empty;
    private string strMeasure            = string.Empty;
    private string strDelFlag            = string.Empty;
    private string strItemNo             = string.Empty;
    private string strOrderClientName    = string.Empty;
    private string strPayClientName      = string.Empty;
    private string strConsignorName      = string.Empty;
    private string strPickupYMD          = string.Empty;
    private string strPickupHM           = string.Empty;
    private string strPickupPlace        = string.Empty;
    private string strGetYMD             = string.Empty;
    private string strGetHM              = string.Empty;
    private string strGetPlace           = string.Empty;
    private string strDateFrom           = string.Empty;
    private string strDateTo             = string.Empty;
    private string strOrderLocationCodes = string.Empty;
    private string strOrderItemCodes     = string.Empty;
    private string strOrderType          = string.Empty;
    private string strCommentSeqNo       = string.Empty;
    private string strSearchClientType   = string.Empty;
    private string strSearchClientText   = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSQIItemList,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSQIList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSQIIns,         MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSQIUpd,         MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSQIDel,         MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSQICommentList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSQICommentIns,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSQICommentDel,  MenuAuthType.ReadWrite);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType = SiteGlobal.GetRequestForm("CallType");
            intPageSize = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo   = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

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

            SiteGlobal.WriteLog("SQIHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SQIHandler");
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
            strCenterCode         = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),    "0");
            strOrderNo            = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),       "0");
            strSQISeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("SQISeqNo"),      "0");
            strItemSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("ItemSeqNo"),     "0");
            strOrderItemCode      = SiteGlobal.GetRequestForm("OrderItemCode");
            strYMD                = SiteGlobal.GetRequestForm("YMD");
            strDetail             = SiteGlobal.GetRequestForm("Detail");
            strTeam               = SiteGlobal.GetRequestForm("Team");
            strContents           = SiteGlobal.GetRequestForm("Contents");
            strAction             = SiteGlobal.GetRequestForm("Action");
            strCause              = SiteGlobal.GetRequestForm("Cause");
            strFollowUp           = SiteGlobal.GetRequestForm("FollowUp");
            strCost               = SiteGlobal.GetRequestForm("Cost");
            strMeasure            = SiteGlobal.GetRequestForm("Measure");
            strDelFlag            = SiteGlobal.GetRequestForm("DelFlag");
            strOrderClientName    = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientName      = SiteGlobal.GetRequestForm("PayClientName");
            strConsignorName      = SiteGlobal.GetRequestForm("ConsignorName");
            strPickupYMD          = SiteGlobal.GetRequestForm("PickupYMD");
            strPickupHM           = SiteGlobal.GetRequestForm("PickupHM");
            strPickupPlace        = SiteGlobal.GetRequestForm("PickupPlace");
            strGetYMD             = SiteGlobal.GetRequestForm("GetYMD");
            strGetHM              = SiteGlobal.GetRequestForm("GetHM");
            strGetPlace           = SiteGlobal.GetRequestForm("GetPlace");
            strDateFrom           = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo             = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes     = SiteGlobal.GetRequestForm("OrderItemCodes");
            strOrderType          = Utils.IsNull(SiteGlobal.GetRequestForm("OrderType"),    "1");
            strCommentSeqNo       = Utils.IsNull(SiteGlobal.GetRequestForm("CommentSeqNo"), "0");
            strSearchClientType   = SiteGlobal.GetRequestForm("SearchClientType");
            strSearchClientText   = SiteGlobal.GetRequestForm("SearchClientText");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SQIHandler", "Exception",
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
                case MethodOrderList:
                    GetOrderList();
                    break;
                case MethodSQIItemList:
                    GetSQIItemList();
                    break;
                case MethodSQIList:
                    GetSQIList();
                    break;
                case MethodSQIIns:
                    SetSQIIns();
                    break;
                case MethodSQIUpd:
                    SetSQIUpd();
                    break;
                case MethodSQIDel:
                    SetSQIDel();
                    break;
                case MethodSQICommentList:
                    GetSQICommentList();
                    break;
                case MethodSQICommentIns:
                    SetSQICommentIns();
                    break;
                case MethodSQICommentDel:
                    SetSQICommentDel();
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

            SiteGlobal.WriteLog("SQIHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 오더조회
    /// </summary>
    protected void GetOrderList()
    {
        ReqOrderList                    lo_objReqOrderList     = null;
        ServiceResult<ResOrderList>     lo_objResOrderList     = null;
        ReqContainerList                lo_objReqContainerList = null;
        ServiceResult<ResContainerList> lo_objResContainerList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderType) || strOrderType.Equals("0") || (strOrderType.Equals("1") && strOrderType.Equals("2") && strOrderType.Equals("3")&& strOrderType.Equals("4")))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strOrderType.Equals("1") || strOrderType.Equals("2") || strOrderType.Equals("3")) //내수, 수출입
        {
            try
            {
                lo_objReqOrderList = new ReqOrderList
                {
                    CenterCode       = strCenterCode.ToInt(),
                    OrderNo          = strOrderNo.ToInt64(),
                    AdminID          = objSes.AdminID,
                    AccessCenterCode = objSes.AccessCenterCode,
                    PageSize         = intPageSize,
                    PageNo           = intPageNo
                };

                lo_objResOrderList = objOrderDasServices.GetOrderList(lo_objReqOrderList);

                objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("SQIHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }
        }
        else if (strOrderType.Equals("4")) //컨테이너
        {
            try
            {
                lo_objReqContainerList = new ReqContainerList
                {
                    CenterCode              = strCenterCode.ToInt(),
                    OrderNo                 = strOrderNo.ToInt64(),
                    AdminID                 = objSes.AdminID,
                    AccessCenterCode        = objSes.AccessCenterCode,
                    PageSize                = intPageSize,
                    PageNo                  = intPageNo
                };

                lo_objResContainerList = objContainerDasServices.GetContainerList(lo_objReqContainerList);

                objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResContainerList) + "]";
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("SQIHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }
        }
    }

    /// <summary>
    /// 서비스 이슈 유형 목록
    /// </summary>
    protected void GetSQIItemList()
    {
        ReqOrderSQIItemList                lo_objReqOrderSQIItemList = null;
        ServiceResult<ResOrderSQIItemList> lo_objResOrderSQIItemList = null;
        strDelFlag = "N";

        try
        {
            lo_objReqOrderSQIItemList = new ReqOrderSQIItemList
            {
                CenterCode         = strCenterCode.ToInt(),
                ItemSeqNo          = strItemSeqNo.ToInt64(),
                OrderItemCode      = strOrderItemCode,
                DelFlag            = strDelFlag,
                AccessCenterCode   = objSes.AccessCenterCode,
                PageSize           = intPageSize,
                PageNo             = intPageNo
            };

            lo_objResOrderSQIItemList = objOrderDasServices.GetOrderSQIItemList(lo_objReqOrderSQIItemList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderSQIItemList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SQIHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 서비스 이슈 목록
    /// </summary>
    protected void GetSQIList()
    {
        ReqOrderSQIList                lo_objReqOrderSQIList = null;
        ServiceResult<ResOrderSQIList> lo_objResOrderSQIList = null;
        strDelFlag = "N";

        strOrderClientName = string.Empty;
        strPayClientName   = string.Empty;
        strConsignorName   = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchClientType) && !string.IsNullOrWhiteSpace(strSearchClientText))
        {
            switch (strSearchClientType)
            {
                case "1":
                    strOrderClientName = strSearchClientText;
                    break;
                case "2":
                    strPayClientName = strSearchClientText;
                    break;
                case "3":
                    strConsignorName = strSearchClientText;
                    break;
            }
        }

        try
        {
            lo_objReqOrderSQIList = new ReqOrderSQIList
            {
                SQISeqNo           = strSQISeqNo.ToInt64(),
                CenterCode         = strCenterCode.ToInt(),
                OrderNo            = strOrderNo.ToInt64(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                OrderClientName    = strOrderClientName,
                PayClientName      = strPayClientName,
                ConsignorName      = strConsignorName,
                OrderType          = strOrderType.ToInt(),
                DelFlag            = strDelFlag,
                AccessCenterCode   = objSes.AccessCenterCode,
                PageSize           = intPageSize,
                PageNo             = intPageNo
            };

            lo_objResOrderSQIList = objOrderDasServices.GetOrderSQIList(lo_objReqOrderSQIList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderSQIList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SQIHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 서비스 이슈 등록
    /// </summary>
    protected void SetSQIIns()
    {
        OrderSQIModel                lo_objOrderSQIModel  = null;
        ServiceResult<OrderSQIModel> lo_objResOrderSQIIns = null;
        strYMD = string.IsNullOrWhiteSpace(strYMD) ? strYMD : strYMD.Replace("-", string.Empty);

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strItemSeqNo) || strItemSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strYMD))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strTeam))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strContents))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objOrderSQIModel = new OrderSQIModel
            {
                CenterCode   = strCenterCode.ToInt(),
                OrderNo      = strOrderNo.ToInt64(),
                ItemSeqNo    = strItemSeqNo.ToInt64(),
                YMD          = strYMD,
                Detail       = strDetail,
                Team         = strTeam,
                Contents     = strContents,
                Action       = strAction,
                Cause        = strCause,
                FollowUp     = strFollowUp,
                Cost         = strCost,
                Measure      = strMeasure,
                RegAdminID   = objSes.AdminID,
                RegAdminName = objSes.AdminName
            };

            lo_objResOrderSQIIns = objOrderDasServices.SetOrderSQIIns(lo_objOrderSQIModel);
                
            objResMap.RetCode = lo_objResOrderSQIIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderSQIIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SQISeqNo",    lo_objResOrderSQIIns.data.SQISeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SQIHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 서비스 이슈 수정
    /// </summary>
    protected void SetSQIUpd()
    {
        OrderSQIModel       lo_objOrderSQIModel  = null;
        ServiceResult<bool> lo_objResOrderSQIUpd = null;
        strYMD = string.IsNullOrWhiteSpace(strYMD) ? strYMD : strYMD.Replace("-", string.Empty);

        if (string.IsNullOrWhiteSpace(strSQISeqNo) || strSQISeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strItemSeqNo) || strItemSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strYMD))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strTeam))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strContents))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objOrderSQIModel = new OrderSQIModel
            {
                SQISeqNo     = strSQISeqNo.ToInt64(),
                CenterCode   = strCenterCode.ToInt(),
                OrderNo      = strOrderNo.ToInt64(),
                ItemSeqNo    = strItemSeqNo.ToInt64(),
                YMD          = strYMD,
                Detail       = strDetail,
                Team         = strTeam,
                Contents     = strContents,
                Action       = strAction,
                Cause        = strCause,
                FollowUp     = strFollowUp,
                Cost         = strCost,
                Measure      = strMeasure,
                UpdAdminID   = objSes.AdminID,
                UpdAdminName = objSes.AdminName
            };

            lo_objResOrderSQIUpd = objOrderDasServices.SetOrderSQIUpd(lo_objOrderSQIModel);
                
            objResMap.RetCode = lo_objResOrderSQIUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderSQIUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SQIHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 서비스 이슈 삭제
    /// </summary>
    protected void SetSQIDel()
    {
        OrderSQIModel       lo_objOrderSQIModel  = null;
        ServiceResult<bool> lo_objResOrderSQIDel = null;

        if (string.IsNullOrWhiteSpace(strSQISeqNo) || strSQISeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objOrderSQIModel = new OrderSQIModel
            {
                SQISeqNo     = strSQISeqNo.ToInt64(),
                CenterCode   = strCenterCode.ToInt(),
                OrderNo      = strOrderNo.ToInt64(),
                DelAdminID   = objSes.AdminID,
                DelAdminName = objSes.AdminName
            };

            lo_objResOrderSQIDel = objOrderDasServices.SetOrderSQIDel(lo_objOrderSQIModel);
                
            objResMap.RetCode = lo_objResOrderSQIDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderSQIDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SQIHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 서비스 이슈 댓글 목록
    /// </summary>
    protected void GetSQICommentList()
    {
        ReqOrderSQICommentList                lo_objReqOrderSQICommentList = null;
        ServiceResult<ResOrderSQICommentList> lo_objResOrderSQICommentList = null;
        strDelFlag = "N";

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        if (string.IsNullOrWhiteSpace(strSQISeqNo) || strSQISeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderSQICommentList = new ReqOrderSQICommentList
            {
                SQISeqNo           = strSQISeqNo.ToInt64(),
                CenterCode         = strCenterCode.ToInt(),
                DelFlag            = strDelFlag,
                AccessCenterCode   = objSes.AccessCenterCode,
                PageSize           = intPageSize,
                PageNo             = intPageNo
            };

            lo_objResOrderSQICommentList = objOrderDasServices.GetOrderSQICommentList(lo_objReqOrderSQICommentList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderSQICommentList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SQICommentHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 서비스 이슈 댓글 등록
    /// </summary>
    protected void SetSQICommentIns()
    {

        OrderSQICommentModel                lo_objOrderSQICommentModel  = null;
        ServiceResult<OrderSQICommentModel> lo_objResOrderSQICommentIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        if (string.IsNullOrWhiteSpace(strSQISeqNo) || strSQISeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strContents))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objOrderSQICommentModel = new OrderSQICommentModel
            {
                CenterCode   = strCenterCode.ToInt(),
                SQISeqNo     = strSQISeqNo.ToInt64(),
                Contents     = strContents,
                RegAdminID   = objSes.AdminID,
                RegAdminName = objSes.AdminName
            };

            lo_objResOrderSQICommentIns = objOrderDasServices.SetOrderSQICommentIns(lo_objOrderSQICommentModel);
                
            objResMap.RetCode = lo_objResOrderSQICommentIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderSQICommentIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("CommentSeqNo", lo_objResOrderSQICommentIns.data.CommentSeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SQIHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 서비스 이슈 댓글 삭제
    /// </summary>
    protected void SetSQICommentDel()
    {
        OrderSQICommentModel lo_objOrderSQICommentModel  = null;
        ServiceResult<bool>  lo_objResOrderSQICommentDel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSQISeqNo) || strSQISeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCommentSeqNo) || strCommentSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objOrderSQICommentModel = new OrderSQICommentModel
            {
                CenterCode   = strCenterCode.ToInt(),
                SQISeqNo     = strOrderNo.ToInt64(),
                CommentSeqNo = strCommentSeqNo.ToInt64(),
                DelAdminID   = objSes.AdminID,
                DelAdminName = objSes.AdminName
            };

            lo_objResOrderSQICommentDel = objOrderDasServices.SetOrderSQICommentDel(lo_objOrderSQICommentModel);
                
            objResMap.RetCode = lo_objResOrderSQICommentDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderSQICommentDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SQIHandler", "Exception",
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