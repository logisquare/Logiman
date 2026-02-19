<%@ WebHandler Language="C#" Class="InoutPayHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : InoutPayHandler.ashx
/// Description     : 오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-20
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class InoutPayHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Inout/InoutPayList"; //필수

    // 메소드 리스트
    private const string MethodPayItemCodeList = "PayItemCodeList"; //비용항목코드
    private const string MethodInoutPayList    = "InoutPayList";    //수출입 비용내역서
    private const string MethodClientCsList    = "ClientCsList";    //업무담당조회

    OrderDasServices    objOrderDasServices    = new OrderDasServices();
    ClientCsDasServices objClientCsDasServices = new ClientCsDasServices();
    private HttpContext objHttpContext         = null;

    private string strCallType           = string.Empty;
    private int    intPageSize           = 0;
    private int    intPageNo             = 0;
    private string strCenterCode         = string.Empty;
    private string strDateType           = string.Empty;
    private string strDateFrom           = string.Empty;
    private string strDateTo             = string.Empty;
    private string strOrderLocationCodes = string.Empty;
    private string strOrderItemCodes     = string.Empty;
    private string strSearchClientType   = string.Empty;
    private string strSearchClientText   = string.Empty;
    private string strOrderNo            = string.Empty;
    private string strPayType            = string.Empty;
    private string strOrderClientName    = string.Empty;
    private string strPayClientName      = string.Empty;
    private string strConsignorName      = string.Empty;
    private string strCsAdminType        = string.Empty;
    private string strCsAdminID          = string.Empty;
    private string strCsAdminName        = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPayItemCodeList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutPayList,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientCsList,    MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("InoutPayHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("InoutPayHandler");
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
            strOrderLocationCodes = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes     = SiteGlobal.GetRequestForm("OrderItemCodes");
            strSearchClientType   = Utils.IsNull(SiteGlobal.GetRequestForm("SearchClientType"), "0");
            strSearchClientText   = SiteGlobal.GetRequestForm("SearchClientText");
            strOrderNo            = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "0");
            strPayType            = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"), "1");
            strOrderClientName    = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientName      = SiteGlobal.GetRequestForm("PayClientName");
            strConsignorName      = SiteGlobal.GetRequestForm("ConsignorName");
            strCsAdminType        = Utils.IsNull(SiteGlobal.GetRequestForm("CsAdminType"), "0");
            strCsAdminID          = SiteGlobal.GetRequestForm("CsAdminID");
            strCsAdminName        = SiteGlobal.GetRequestForm("CsAdminName");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutPayHandler", "Exception",
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
                case MethodPayItemCodeList:
                    GetPayItemCodeList();
                    break;
                case MethodInoutPayList:
                    GetInoutPayList();
                    break;
                case MethodClientCsList:
                    GetClientCsList();
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

            SiteGlobal.WriteLog("InoutPayHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    protected void GetPayItemCodeList()
    {
        string    lo_strGroupCode = "OP";
        string    lo_strGroupName = string.Empty;
        DataTable lo_objCodeTable = null;

        try
        {
            lo_objCodeTable = Utils.GetItemList(objHttpContext, lo_strGroupCode, objSes.AccessCenterCode, null, out lo_strGroupName);

            if (lo_objCodeTable == null)
            {
                objResMap.RetCode = 9001;
                objResMap.ErrMsg  = "비용항목 정보를 불러오는데 실패했습니다.";
                return;
            }
            
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objCodeTable) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 비용내역서
    /// </summary>
    protected void GetInoutPayList()
    {
        ReqOrderPayStatementList                       lo_objReqOrderPayStatementList        = null;
        ServiceResult<ResOrderPayStatementList>        lo_objResOrderPayStatementList        = null;
        ReqOrderPayStatementPayItemList                lo_objReqOrderPayStatementPayItemList = null;
        ServiceResult<ResOrderPayStatementPayItemList> lo_objResOrderPayStatementPayItemList = null;
        int                                            lo_intListType                        = 2;
        OrderPayStatementGridModel                     lo_objOrderPayStatementGridModel      = null;

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

            lo_objReqOrderPayStatementPayItemList = new ReqOrderPayStatementPayItemList
            {
                CenterCode         = strCenterCode.ToInt(),
                OrderNo            = strOrderNo.ToInt64(),
                ListType           = lo_intListType,
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                OrderClientName    = strOrderClientName,
                PayClientName      = strPayClientName,
                ConsignorName      = strConsignorName,
                PayType            = strPayType.ToInt(),
                CsAdminID          = strCsAdminID,
                AccessCenterCode   = objSes.AccessCenterCode
            };
                
            lo_objResOrderPayStatementPayItemList = objOrderDasServices.GetOrderPayStatementPayItemList(lo_objReqOrderPayStatementPayItemList);

            lo_objReqOrderPayStatementList = new ReqOrderPayStatementList
            {
                CenterCode         = strCenterCode.ToInt(),
                OrderNo            = strOrderNo.ToInt64(),
                ListType           = lo_intListType,
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                OrderClientName    = strOrderClientName,
                PayClientName      = strPayClientName,
                ConsignorName      = strConsignorName,
                PayType            = strPayType.ToInt(),
                CsAdminID          = strCsAdminID,
                AccessCenterCode   = objSes.AccessCenterCode
            };

            lo_objResOrderPayStatementList = objOrderDasServices.GetOrderPayStatementList(lo_objReqOrderPayStatementList, lo_objResOrderPayStatementPayItemList.data.RecordCnt > 0 ? lo_objResOrderPayStatementPayItemList.data.list : null);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderPayStatementList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 업체담당자 검색
    /// </summary>
    protected void GetClientCsList()
    {
        ReqClientCsSearchList                lo_objReqClientCsSearchList = null;
        ServiceResult<ResClientCsSearchList> lo_objResClientCsSearchList = null;

        if (string.IsNullOrWhiteSpace(strCsAdminID) && string.IsNullOrWhiteSpace(strCsAdminName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientCsSearchList = new ReqClientCsSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                CsAdminType      = strCsAdminType.ToInt(),
                CsAdminID        = strCsAdminID,
                CsAdminName      = strCsAdminName,
                DelFlag          = "N",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientCsSearchList = objClientCsDasServices.GetClientCsSearchList(lo_objReqClientCsSearchList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResClientCsSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutHandler", "Exception",
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