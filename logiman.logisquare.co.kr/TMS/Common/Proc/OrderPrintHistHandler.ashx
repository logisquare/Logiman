<%@ WebHandler Language="C#" Class="OrderPrintHistHandler" %>
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
/// FileName        : OrderPrintHistHandler.ashx
/// Description     : 내역서 발송내역 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2023-11-29
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderPrintHistHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/OrderPrintHistList"; //필수

    // 메소드 리스트
    private const string MethodOrderPrintHistList = "OrderPrintHistList"; //정보망 조회

    OrderDispatchDasServices objOrderDispatchDasServices = new OrderDispatchDasServices();

    private HttpContext objHttpContext      = null;
    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;
    private string      strSeqNo            = string.Empty;
    private string      strCenterCode       = string.Empty;
    private string      strOrderNo          = string.Empty;
    private string      strSaleClosingSeqNo = string.Empty;
    private string      strRecName          = string.Empty;
    private string      strSendName         = string.Empty;
    private string      strSearchType       = string.Empty;
    private string      strSearchText       = string.Empty;
    private string      strDateFrom         = string.Empty;
    private string      strDateTo           = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderPrintHistList,      MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("OrderPrintHistHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderPrintHistHandler");
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
            strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strSeqNo            = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"), "0");
            strOrderNo          = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "0");
            strSaleClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"), "0");
            strRecName          = Utils.IsNull(SiteGlobal.GetRequestForm("RecName"), "");
            strSendName         = Utils.IsNull(SiteGlobal.GetRequestForm("SendName"), "");
            strSearchType       = Utils.IsNull(SiteGlobal.GetRequestForm("SearchType"),  "");
            strSearchText       = Utils.IsNull(SiteGlobal.GetRequestForm("SearchText"),  "");
            strDateFrom         = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo           = SiteGlobal.GetRequestForm("DateTo");
            strDateFrom         = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo           = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderPrintHistHandler", "Exception",
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
                case MethodOrderPrintHistList:
                    GetOrderPrintHistList();
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

            SiteGlobal.WriteLog("OrderPrintHistHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 정보망 조회
    /// </summary>
    protected void GetOrderPrintHistList()
    {
        ReqPrintHistory                lo_objReqPrintHistory = null;
        ServiceResult<ResPrintHistory> lo_objResPrintHistory = null;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "RecName":
                    strRecName = strSearchText;
                    break;
                case "SendName":
                    strSendName = strSearchText;
                    break;
            }
        }

        try
        {
            lo_objReqPrintHistory = new ReqPrintHistory
            {
                SeqNo            = strSeqNo.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                RecName          = strRecName,
                SendName         = strSendName,
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResPrintHistory = objOrderDispatchDasServices.GetOrderPrintHistList(lo_objReqPrintHistory);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPrintHistory) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            /*SiteGlobal.WriteLog("OrderPrintHistHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);*/
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