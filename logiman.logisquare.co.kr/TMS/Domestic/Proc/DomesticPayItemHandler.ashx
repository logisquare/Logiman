<%@ WebHandler Language="C#" Class="DomesticPayItemHandler" %>
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
/// FileName        : DomesticPayItemHandler.ashx
/// Description     : 오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2025-04-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class DomesticPayItemHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Domestic/DomesticPayItemList"; //필수

    // 메소드 리스트
    private const string MethodDomesticPayItemList = "DomesticPayItemList"; //내수 비용항목내역서
        
    OrderDasServices    objOrderDasServices = new OrderDasServices();
    private HttpContext objHttpContext      = null;
        
    private string strCallType           = string.Empty;
    private int    intPageSize           = 0;
    private int    intPageNo             = 0;
    private string strCenterCode         = string.Empty;
    private string strDateType           = string.Empty;
    private string strDateFrom           = string.Empty;
    private string strDateTo             = string.Empty;
    private string strSearchClientType   = string.Empty;
    private string strSearchClientText   = string.Empty;
    private string strOrderNo            = string.Empty;
    private string strPayItemCode        = string.Empty;
    private string strDispatchType       = string.Empty;
    private string strCarNo              = string.Empty;
    private string strOrderClientName    = string.Empty;
    private string strPayClientName      = string.Empty;
    private string strConsignorName      = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodDomesticPayItemList, MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("DomesticPayItemHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("DomesticPayItemHandler");
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
            strCenterCode         = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType           = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom           = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo             = SiteGlobal.GetRequestForm("DateTo");
            strSearchClientType   = Utils.IsNull(SiteGlobal.GetRequestForm("SearchClientType"), "0");
            strSearchClientText   = SiteGlobal.GetRequestForm("SearchClientText");
            strOrderNo            = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "0");
            strPayItemCode        = SiteGlobal.GetRequestForm("PayItemCode");
            strDispatchType       = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchType"), "0");
            strCarNo              = SiteGlobal.GetRequestForm("CarNo");
            strOrderClientName    = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientName      = SiteGlobal.GetRequestForm("PayClientName");
            strConsignorName      = SiteGlobal.GetRequestForm("ConsignorName");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticPayItemHandler", "Exception",
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
                case MethodDomesticPayItemList:
                    GetDomesticPayItemList();
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

            SiteGlobal.WriteLog("DomesticPayItemHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// 수출입 비용항목리스트
    /// </summary>
    protected void GetDomesticPayItemList()
    {
        ReqOrderPayItemStatementList                lo_objReqOrderPayItemStatementList = null;
        ServiceResult<ResOrderPayItemStatementList> lo_objResOrderPayItemStatementList = null;
        int                                         lo_intListType                     = 1;

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

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
            lo_objReqOrderPayItemStatementList = new ReqOrderPayItemStatementList
            {
                OrderNo          = strOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                ListType         = lo_intListType,
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                OrderClientName  = strOrderClientName,
                PayClientName    = strPayClientName,
                ConsignorName    = strConsignorName,
                PayItemCode      = strPayItemCode,
                DispatchType     = strDispatchType.ToInt(),
                CarNo            = strCarNo,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResOrderPayItemStatementList = objOrderDasServices.GetOrderPayItemStatementList(lo_objReqOrderPayItemStatementList);
            objResMap.strResponse              = "[" + JsonConvert.SerializeObject(lo_objResOrderPayItemStatementList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticPayItemHandler", "Exception",
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