<%@ WebHandler Language="C#" Class="OrderAmtConfirmHandler" %>
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
/// FileName        : OrderAmtConfirmHandler.ashx
/// Description     : 오더 비용 수정 승인 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2024-05-03
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderAmtConfirmHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/OrderAmtConfirmList"; //필수

    // 메소드 리스트
    private const string MethodAmtRequestList      = "AmtRequestList";         //요청 목록
    private const string MethodAmtRequestStatusUpd = "AmtRequestStatusUpdate"; //요청 승인/반려

    OrderDasServices    objOrderDasServices = new OrderDasServices();
    private HttpContext objHttpContext      = null;

    private string strCallType      = string.Empty;
    private int    intPageSize      = 0;
    private int    intPageNo        = 0;
    private string strCenterCode    = string.Empty;
    private string strListType      = string.Empty;
    private string strDateType      = string.Empty;
    private string strDateFrom      = string.Empty;
    private string strDateTo        = string.Empty;
    private string strMyChargeFlag  = string.Empty;
    private string strMyOrderFlag   = string.Empty;
    private string strPayClientName = string.Empty;
    private string strConsignorName = string.Empty;
    private string strReqStatus     = string.Empty;
    private string strPayType       = string.Empty;
    private string strCarNo         = string.Empty;
    private string strOrderNo       = string.Empty;
    private string strSeqNo         = string.Empty;
    
    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAmtRequestList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAmtRequestStatusUpd, MenuAuthType.ReadWrite);

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
            intPageSize  = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo    = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

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

            SiteGlobal.WriteLog("OrderAmtConfirmHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderAmtConfirmHandler");
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
            strCenterCode    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strListType      = Utils.IsNull(SiteGlobal.GetRequestForm("ListType"),   "0");
            strOrderNo       = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strDateType      = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom      = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo        = SiteGlobal.GetRequestForm("DateTo");
            strMyChargeFlag  = SiteGlobal.GetRequestForm("MyChargeFlag");
            strMyOrderFlag   = SiteGlobal.GetRequestForm("MyOrderFlag");
            strPayClientName = SiteGlobal.GetRequestForm("PayClientName");
            strConsignorName = SiteGlobal.GetRequestForm("ConsignorName");
            strCarNo         = SiteGlobal.GetRequestForm("CarNo");
            strPayType       = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"),   "0");
            strReqStatus     = Utils.IsNull(SiteGlobal.GetRequestForm("ReqStatus"), "0");
            strSeqNo         = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),     "0");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderAmtConfirmHandler", "Exception",
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
                case MethodAmtRequestList:
                    GetAmtRequestList();
                    break;
                case MethodAmtRequestStatusUpd:
                    SetAmtRequestStatusUpd();
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

            SiteGlobal.WriteLog("OrderAmtConfirmHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 수출입 오더 현황 목록
    /// </summary>
    protected void GetAmtRequestList()
    {
        ReqOrderAmtRequestList                lo_objReqOrderAmtRequestList = null;
        ServiceResult<ResOrderAmtRequestList> lo_objResOrderAmtRequestList = null;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderAmtRequestList = new ReqOrderAmtRequestList
            {
                OrderNo          = strOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                ListType         = strListType.ToInt(),
                PayType          = strPayType.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                ConsignorName    = strConsignorName,
                PayClientName    = strPayClientName,
                CarNo            = strCarNo,
                MyChargeFlag     = strMyChargeFlag,
                MyOrderFlag      = strMyOrderFlag,
                ReqStatus        = strReqStatus.ToInt(),
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo,
            };
                
            lo_objResOrderAmtRequestList = objOrderDasServices.GetOrderAmtRequestList(lo_objReqOrderAmtRequestList);
            objResMap.strResponse        = "[" + JsonConvert.SerializeObject(lo_objResOrderAmtRequestList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticAmtRequestHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
        
    /// <summary>
    /// 비용 수정요청 승인/반려
    /// </summary>
    protected void SetAmtRequestStatusUpd()
    {
        ReqOrderAmtRequestStatusUpd lo_objReqOrderAmtRequestStatusUpd = null;
        ServiceResult<bool>         lo_objResOrderAmtRequestStatusUpd = null;
            
        if (string.IsNullOrWhiteSpace(strSeqNo) || strSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        if (string.IsNullOrWhiteSpace(strReqStatus) || (!strReqStatus.Equals("2") && !strReqStatus.Equals("3")))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderAmtRequestStatusUpd = new ReqOrderAmtRequestStatusUpd
            {
                SeqNo        = strSeqNo.ToInt(),
                ReqStatus    = strReqStatus.ToInt(),
                UpdAdminID   = objSes.AdminID,
                UpdAdminName = objSes.AdminName
            };
                
            lo_objResOrderAmtRequestStatusUpd = objOrderDasServices.SetOrderAmtRequestStatusUpd(lo_objReqOrderAmtRequestStatusUpd);
            objResMap.RetCode                 = lo_objResOrderAmtRequestStatusUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderAmtRequestStatusUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderAmtConfirmHandler", "Exception",
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