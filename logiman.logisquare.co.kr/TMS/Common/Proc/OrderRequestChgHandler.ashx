<%@ WebHandler Language="C#" Class="OrderRequestChgHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : OrderRequestChgHandler.ashx
/// Description     : 정보망 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-08-18
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderRequestChgHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/WebOrderRequestChgList"; //필수

    // 메소드 리스트
    private const string MethodOrderRequestChgList      = "OrderRequestChgList";       //수정 요청사항 조회
    private const string MethodOrderRequestChgUpd       = "OrderRequestChgUpd";        //수정 요청사항 취소 처리

    WebOrderDasServices    objWebOrderDasServices    = new WebOrderDasServices();

    private HttpContext objHttpContext          = null;
    private string      strCallType             = string.Empty;
    private int         intPageSize             = 0;
    private int         intPageNo               = 0;
    private string      strCenterCode           = string.Empty;
    private string      strOrderNo              = string.Empty;
    private string      strDateFrom             = string.Empty;
    private string      strDateTo               = string.Empty;
    private string      strChgSeqNo             = string.Empty;
    private string      strOrderClientCode      = string.Empty;
    private string      strChgStatus            = string.Empty;
    private string      strListType             = string.Empty;
    private string      strMyChargeFlag         = string.Empty;
    private string      strChgReqContent        = string.Empty;
    private string      strChgMessage           = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderRequestChgList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderRequestChgUpd,         MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("OrderRequestChg", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderRequestChg");
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
            strCenterCode            = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderNo               = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strChgSeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("ChgSeqNo"),    "0");
            strOrderClientCode       = Utils.IsNull(SiteGlobal.GetRequestForm("OrderClientCode"),    "0");
            strChgStatus             = Utils.IsNull(SiteGlobal.GetRequestForm("ChgStatus"),    "0");
            strListType              = Utils.IsNull(SiteGlobal.GetRequestForm("ListType"),    "0");
            strMyChargeFlag          = Utils.IsNull(SiteGlobal.GetRequestForm("MyChargeFlag"),    "");
            strDateFrom              = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                = SiteGlobal.GetRequestForm("DateTo");
            strDateFrom              = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo                = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
            strChgReqContent         = Utils.IsNull(SiteGlobal.GetRequestForm("ChgReqContent"),    "");
            strChgMessage            = Utils.IsNull(SiteGlobal.GetRequestForm("ChgMessage"),    "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderRequestChg", "Exception",
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
                case MethodOrderRequestChgList:
                    GetOrderRequestChgList();
                    break;
                case MethodOrderRequestChgUpd:
                    SetOrderRequestChgUpd();
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

            SiteGlobal.WriteLog("OrderRequestChg", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 수정요청 조회
    /// </summary>
    protected void GetOrderRequestChgList()
    {
        ReqOrderRequestChgList                lo_objReqOrderRequestChgList = null;
        ServiceResult<ResOrderRequestChgList> lo_objResOrderRequestChgList = null;

        try
        {
            lo_objReqOrderRequestChgList = new ReqOrderRequestChgList
            {
                ChgSeqNo            = strChgSeqNo.ToInt64(),
                CenterCode          = strCenterCode.ToInt(),
                OrderNo             = strOrderNo.ToInt64(),
                OrderClientCode     = strOrderClientCode.ToInt(),
                ChgStatus           = strChgStatus.ToInt(),

                ListType            = strListType.ToInt(),
                DateFrom            = strDateFrom,
                DateTo              = strDateTo,
                MyChargeFlag        = strMyChargeFlag,
                AdminID             = objSes.AdminID,

                AccessCenterCode    = objSes.AccessCenterCode,
                PageSize            = intPageSize,
                PageNo              = intPageNo,
            };

            lo_objResOrderRequestChgList = objWebOrderDasServices.GetOrderRequestWeborderChgList(lo_objReqOrderRequestChgList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderRequestChgList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderRequestChg", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 웹수정요청 취소
    /// </summary>
    protected void SetOrderRequestChgUpd()
    {
        WebOrderModel                lo_objWebOrderModel  = null;
        ServiceResult<WebOrderModel> lo_objResWebOrderModel = null;

        if (string.IsNullOrWhiteSpace(strChgSeqNo) || strChgSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objWebOrderModel = new WebOrderModel
            {
                ChgSeqNo        = strChgSeqNo.ToInt64(),
                ChgReqContent   = strChgReqContent,
                ChgMessage      = strChgMessage,
                ChgStatus       = strChgStatus.ToInt(),
                RegAdminID      = objSes.AdminID,
                RegAdminName    = objSes.AdminName
            };

            lo_objResWebOrderModel = objWebOrderDasServices.SetWebOrderRequestChgUpd(lo_objWebOrderModel);

            objResMap.RetCode             = lo_objResWebOrderModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResWebOrderModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderRequestChg", "Exception",
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