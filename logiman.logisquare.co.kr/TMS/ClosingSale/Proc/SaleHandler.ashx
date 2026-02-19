<%@ WebHandler Language="C#" Class="SaleHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Data;
using System.IO;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : SaleHandler.ashx
/// Description     : 매출마감 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-08-29
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SaleHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingSale/SaleList"; //필수

    // 메소드 리스트
    private const string MethodSaleClientList           = "SaleClientList";           //매출 거래처 목록
    private const string MethodSaleClientListExcel      = "SaleClientListExcel";      //매출 거래처 엑셀
    private const string MethodSaleClientOrderList      = "SaleClientOrderList";      //매출 오더 목록
    private const string MethodSaleClientOrderListExcel = "SaleClientOrderListExcel"; //매출 오더 엑셀
    private const string MethodSaleClosingIns           = "SaleClosingInsert";        //매출 마감
    private const string MethodSaleClosingCnl           = "SaleClosingCancel";        //매출 마감 취소
    private const string MethodSaleCarryoverUpd         = "SaleCarryoverUpdate";      //이월
    private const string MethodSaleCarryoverDel         = "SaleCarryoverDelete";      //이월취소
    private const string MethodClientCsList             = "ClientCsList";             //거래처담당조회

    SaleDasServices     objSaleDasServices     = new SaleDasServices();
    ClientCsDasServices objClientCsDasServices = new ClientCsDasServices();
    private HttpContext objHttpContext         = null;

    private string strCallType                = string.Empty;
    private int    intPageSize                = 0;
    private int    intPageNo                  = 0;
    private string strCenterCode              = string.Empty;
    private string strDateType                = string.Empty;
    private string strDateFrom                = string.Empty;
    private string strDateTo                  = string.Empty;
    private string strOrderLocationCodes      = string.Empty;
    private string strDeliveryLocationCodes   = string.Empty;
    private string strOrderItemCodes          = string.Empty;
    private string strOrderClientName         = string.Empty;
    private string strPayClientCode           = string.Empty;
    private string strPayClientName           = string.Empty;
    private string strPayClientChargeName     = string.Empty;
    private string strPayClientChargeLocation = string.Empty;
    private string strConsignorName           = string.Empty;
    private string strHawb                    = string.Empty;
    private string strClosingFlag             = string.Empty;
    private string strOrderNos1               = string.Empty;
    private string strOrderNos2               = string.Empty;
    private string strOrderNos3               = string.Empty;
    private string strOrderNos4               = string.Empty;
    private string strOrderNos5               = string.Empty;
    private string strSaleClosingSeqNos       = string.Empty;
    private string strSaleOrgAmt              = string.Empty;
    private string strCsAdminType             = string.Empty;
    private string strCsAdminID               = string.Empty;
    private string strCsAdminName             = string.Empty;
    private string strCarryOverFlag           = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodSaleClientList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSaleClientListExcel,      MenuAuthType.All);
        objMethodAuthList.Add(MethodSaleClientOrderList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSaleClientOrderListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodSaleClosingIns,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSaleClosingCnl,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSaleCarryoverUpd,         MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSaleCarryoverDel,         MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientCsList,             MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("SaleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SaleHandler");
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
            strCenterCode              = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType                = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom                = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                  = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes      = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strDeliveryLocationCodes   = SiteGlobal.GetRequestForm("DeliveryLocationCodes");
            strOrderItemCodes          = SiteGlobal.GetRequestForm("OrderItemCodes");
            strOrderClientName         = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("PayClientCode"), "0");
            strPayClientName           = SiteGlobal.GetRequestForm("PayClientName");
            strPayClientChargeName     = SiteGlobal.GetRequestForm("PayClientChargeName");
            strPayClientChargeLocation = SiteGlobal.GetRequestForm("PayClientChargeLocation");
            strConsignorName           = SiteGlobal.GetRequestForm("ConsignorName");
            strHawb                    = SiteGlobal.GetRequestForm("Hawb");
            strClosingFlag             = SiteGlobal.GetRequestForm("ClosingFlag");
            strOrderNos1               = SiteGlobal.GetRequestForm("OrderNos1");
            strOrderNos2               = SiteGlobal.GetRequestForm("OrderNos2");
            strOrderNos3               = SiteGlobal.GetRequestForm("OrderNos3");
            strOrderNos4               = SiteGlobal.GetRequestForm("OrderNos4");
            strOrderNos5               = SiteGlobal.GetRequestForm("OrderNos5");
            strSaleClosingSeqNos       = SiteGlobal.GetRequestForm("SaleClosingSeqNos");
            strSaleOrgAmt              = Utils.IsNull(SiteGlobal.GetRequestForm("SaleOrgAmt"),  "0");
            strCsAdminType             = Utils.IsNull(SiteGlobal.GetRequestForm("CsAdminType"), "0");
            strCsAdminID               = SiteGlobal.GetRequestForm("CsAdminID");
            strCsAdminName             = SiteGlobal.GetRequestForm("CsAdminName");
            strCarryOverFlag           = SiteGlobal.GetRequestForm("CarryOverFlag");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleHandler", "Exception",
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
                case MethodSaleClientList:
                    GetSaleClientList();
                    break;;
                case MethodSaleClientListExcel:
                    GetSaleClientListExcel();
                    break;
                case MethodSaleClientOrderList:
                    GetSaleClientOrderList();
                    break;
                case MethodSaleClientOrderListExcel:
                    GetSaleClientOrderListExcel();
                    break;
                case MethodSaleClosingIns:
                    SetSaleClosingIns();
                    break;
                case MethodSaleClosingCnl:
                    SetSaleClosingCnl();
                    break;
                case MethodSaleCarryoverUpd:
                    SetSaleCarryoverUpd();
                    break;
                case MethodSaleCarryoverDel:
                    SetSaleCarryoverDel();
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

            SiteGlobal.WriteLog("SaleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매출 거래처 목록
    /// </summary>
    protected void GetSaleClientList()
    {
        ReqSaleClientList                lo_objReqSaleClientList = null;
        ServiceResult<ResSaleClientList> lo_objResSaleClientList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClientList = new ReqSaleClientList
            {
                CenterCode            = strCenterCode.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                OrderClientName       = strOrderClientName,
                PayClientName         = strPayClientName,
                PayClientChargeName   = strPayClientChargeName,
                CsAdminID             = strCsAdminID,
                ConsignorName         = strConsignorName,
                Hawb                  = strHawb,
                ClosingFlag           = strClosingFlag,
                CarryOverFlag         = strCarryOverFlag,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo,
            };

            lo_objResSaleClientList = objSaleDasServices.GetSaleClientList(lo_objReqSaleClientList);
            objResMap.strResponse   = "[" + JsonConvert.SerializeObject(lo_objResSaleClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 거래처 엑셀
    /// </summary>
    protected void GetSaleClientListExcel()
    {
        ReqSaleClientList                lo_objReqSaleClientList = null;
        ServiceResult<ResSaleClientList> lo_objResSaleClientList = null;
        string                           lo_strFileName          = "";
        SpreadSheet                      lo_objExcel             = null;
        DataTable                        lo_dtData               = null;
        MemoryStream                     lo_outputStream         = null;
        byte[]                           lo_Content              = null;
        int                              lo_intColumnIndex       = 0;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClientList = new ReqSaleClientList
            {
                CenterCode            = strCenterCode.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                OrderClientName       = strOrderClientName,
                PayClientName         = strPayClientName,
                PayClientChargeName   = strPayClientChargeName,
                CsAdminID             = strCsAdminID,
                ConsignorName         = strConsignorName,
                Hawb                  = strHawb,
                ClosingFlag           = strClosingFlag,
                CarryOverFlag         = strCarryOverFlag,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo,
            };

            lo_objResSaleClientList = objSaleDasServices.GetSaleClientList(lo_objReqSaleClientList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("거래처명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("합계",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("오더수",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("이월건수",  typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("마감건수",  typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("거래처상태", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("마감구분", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("결제일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("거래상태", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("과세구분", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("업무담당", typeof(string)));

            foreach (var row in lo_objResSaleClientList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.PayClientName,row.PayClientCorpNo,row.SaleSupplyAmt,row.SaleTaxAmt
                                ,row.SaleOrgAmt,row.OrderCnt,row.CarryoverCnt,row.ClosingOrderCnt,row.ClientStatusM
                                ,row.ClientClosingTypeM,row.ClientPayDay,row.ClientBusinessStatusM,row.ClientTaxKindM,row.CsAdminNames);
            }

            lo_objExcel = new SpreadSheet {SheetName = "SaleClientList"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetFontSize(10, 18);
            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);
            lo_Content = lo_outputStream.ToArray();

            lo_strFileName = $"{lo_objExcel.SheetName}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + lo_strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 오더 목록
    /// </summary>
    protected void GetSaleClientOrderList()
    {
        ReqSaleClientOrderList                lo_objReqSaleClientOrderList = null;
        ServiceResult<ResSaleClientOrderList> lo_objResSaleClientOrderList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClientOrderList = new ReqSaleClientOrderList
            {
                CenterCode              = strCenterCode.ToInt(),
                PayClientCode           = strPayClientCode.ToInt64(),
                DateType                = strDateType.ToInt(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                DeliveryLocationCodes   = strDeliveryLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderClientName         = strOrderClientName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                Hawb                    = strHawb,
                ClosingFlag             = strClosingFlag,
                CarryOverFlag           = strCarryOverFlag,
                AccessCenterCode        = objSes.AccessCenterCode
            };

            lo_objResSaleClientOrderList = objSaleDasServices.GetSaleClientOrderList(lo_objReqSaleClientOrderList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResSaleClientOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 오더 엑셀
    /// </summary>
    protected void GetSaleClientOrderListExcel()
    {
        ReqSaleClientOrderList                lo_objReqSaleClientOrderList = null;
        ServiceResult<ResSaleClientOrderList> lo_objResSaleClientOrderList = null;
        string                                lo_strFileName               = "";
        SpreadSheet                           lo_objExcel                  = null;
        DataTable                             lo_dtData                    = null;
        MemoryStream                          lo_outputStream              = null;
        byte[]                                lo_Content                   = null;
        int                                   lo_intColumnIndex            = 0;
        double                                lo_intSumAmt                 = 0;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClientOrderList = new ReqSaleClientOrderList
            {
                CenterCode              = strCenterCode.ToInt(),
                PayClientCode           = strPayClientCode.ToInt64(),
                DateType                = strDateType.ToInt(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                DeliveryLocationCodes   = strDeliveryLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderClientName         = strOrderClientName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                Hawb                    = strHawb,
                ClosingFlag             = strClosingFlag,
                CarryOverFlag           = strCarryOverFlag,
                AccessCenterCode        = objSes.AccessCenterCode
            };

            lo_objResSaleClientOrderList = objSaleDasServices.GetSaleClientOrderList(lo_objReqSaleClientOrderList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사명", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감여부", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구방식", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서발행상태", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전표번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감자",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",  typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("발주처명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)담당자", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구사업장",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("이월여부",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("목적국",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("H/AWB",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("M/AWB",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총수량",    typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총부피",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총중량",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("매출합계",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("선급금",    typeof(double)));

            lo_dtData.Columns.Add(new DataColumn("매출+선급금", typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("차량번호",   typeof(string)));

            foreach (var row in lo_objResSaleClientOrderList.data.list)
            {
                lo_intSumAmt = row.AdvanceSupplyAmt3 + row.SaleOrgAmt;
                lo_dtData.Rows.Add(row.CenterName,row.OrderNo,row.ClosingFlag,row.ClosingKindM,row.BillStatus
                     ,row.SaleClosingSeqNo,row.ClosingAdminName,row.ClosingDate,row.OrderItemCodeM,row.OrderLocationCodeM
                     ,row.OrderClientName,row.PayClientName,row.PayClientChargeName,row.PayClientChargeLocation,row.ConsignorName
                     ,row.PickupYMD,row.PickupPlace,row.GetYMD,row.GetPlace,row.SaleCarryoverFlag
                     ,row.Nation,row.Hawb,row.Mawb,row.Volume,row.CBM
                     ,row.Weight,row.SaleOrgAmt,row.SaleSupplyAmt,row.SaleTaxAmt,row.AdvanceSupplyAmt3
                     ,lo_intSumAmt,row.CarNo);
            }

            lo_objExcel = new SpreadSheet {SheetName = "SaleClientOrderList"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetFontSize(10, 18);
            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);
            lo_Content = lo_outputStream.ToArray();

            lo_strFileName = $"{lo_objExcel.SheetName}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + lo_strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 마감
    /// </summary>
    protected void SetSaleClosingIns()
    {
        ReqSaleClosingIns                lo_objReqSaleClosingIns = null;
        ServiceResult<ResSaleClosingIns> lo_objResSaleClosingIns = null;
        int                              lo_intClosingKind       = 1;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos1) && string.IsNullOrWhiteSpace(strOrderNos2) && string.IsNullOrWhiteSpace(strOrderNos3) && string.IsNullOrWhiteSpace(strOrderNos4) && string.IsNullOrWhiteSpace(strOrderNos5))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingIns = new ReqSaleClosingIns
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNos1        = strOrderNos1,
                OrderNos2        = strOrderNos2,
                OrderNos3        = strOrderNos3,
                OrderNos4        = strOrderNos4,
                OrderNos5        = strOrderNos5,
                SaleOrgAmt       = strSaleOrgAmt.ToDouble(),
                ClosingKind      = lo_intClosingKind,
                ClosingAdminID   = objSes.AdminID,
                ClosingAdminName = objSes.AdminName
            };

            lo_objResSaleClosingIns = objSaleDasServices.SetSaleClosingIns(lo_objReqSaleClosingIns);
            objResMap.RetCode         = lo_objResSaleClosingIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleClosingIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SaleClosingSeqNo",   lo_objResSaleClosingIns.data.SaleClosingSeqNo.ToString());
                objResMap.Add("SaleOrgAmt", lo_objResSaleClosingIns.data.SaleOrgAmt);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 마감 취소
    /// </summary>
    protected void SetSaleClosingCnl()
    {
        ReqSaleClosingCnl   lo_objReqSaleClosingCnl = null;
        ServiceResult<bool> lo_objResSaleClosingCnl = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingCnl = new ReqSaleClosingCnl
            {
                CenterCode        = strCenterCode.ToInt(),
                SaleClosingSeqNos = strSaleClosingSeqNos,
                CnlAdminID        = objSes.AdminID,
                CnlAdminName      = objSes.AdminName
            };

            lo_objResSaleClosingCnl = objSaleDasServices.SetSaleClosingCnl(lo_objReqSaleClosingCnl);
            objResMap.RetCode         = lo_objResSaleClosingCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleClosingCnl.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 이월 등록
    /// </summary>
    protected void SetSaleCarryoverUpd()
    {
        ReqSaleCarryoverUpd                lo_objReqSaleCarryoverUpd = null;
        ServiceResult<ResSaleCarryoverUpd> lo_objResSaleCarryoverUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos1) && string.IsNullOrWhiteSpace(strOrderNos2) && string.IsNullOrWhiteSpace(strOrderNos3) && string.IsNullOrWhiteSpace(strOrderNos4) && string.IsNullOrWhiteSpace(strOrderNos5))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleCarryoverUpd = new ReqSaleCarryoverUpd
            {
                CenterCode   = strCenterCode.ToInt(),
                OrderNos1    = strOrderNos1,
                OrderNos2    = strOrderNos2,
                OrderNos3    = strOrderNos3,
                OrderNos4    = strOrderNos4,
                OrderNos5    = strOrderNos5,
                UpdAdminID   = objSes.AdminID,
                UpdAdminName = objSes.AdminName
            };

            lo_objResSaleCarryoverUpd = objSaleDasServices.SetSaleCarryoverUpd(lo_objReqSaleCarryoverUpd);
            objResMap.RetCode         = lo_objResSaleCarryoverUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleCarryoverUpd.result.ErrorMsg;
                return;
            }

            objResMap.Add("TotalCnt",   lo_objResSaleCarryoverUpd.data.TotalCnt);
            objResMap.Add("SuccessCnt", lo_objResSaleCarryoverUpd.data.SuccessCnt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 이월 취삭제
    /// </summary>
    protected void SetSaleCarryoverDel()
    {
        ReqSaleCarryoverDel                lo_objReqSaleCarryoverDel = null;
        ServiceResult<ResSaleCarryoverDel> lo_objResSaleCarryoverDel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos1) && string.IsNullOrWhiteSpace(strOrderNos2) && string.IsNullOrWhiteSpace(strOrderNos3) && string.IsNullOrWhiteSpace(strOrderNos4) && string.IsNullOrWhiteSpace(strOrderNos5))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleCarryoverDel = new ReqSaleCarryoverDel
            {
                CenterCode   = strCenterCode.ToInt(),
                OrderNos1    = strOrderNos1,
                OrderNos2    = strOrderNos2,
                OrderNos3    = strOrderNos3,
                OrderNos4    = strOrderNos4,
                OrderNos5    = strOrderNos5,
                DelAdminID   = objSes.AdminID,
                DelAdminName = objSes.AdminName
            };

            lo_objResSaleCarryoverDel = objSaleDasServices.SetSaleCarryoverDel(lo_objReqSaleCarryoverDel);
            objResMap.RetCode         = lo_objResSaleCarryoverDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleCarryoverDel.result.ErrorMsg;
                return;
            }

            objResMap.Add("TotalCnt",   lo_objResSaleCarryoverDel.data.TotalCnt);
            objResMap.Add("SuccessCnt", lo_objResSaleCarryoverDel.data.SuccessCnt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleHandler", "Exception",
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

            SiteGlobal.WriteLog("SaleClosingHandler", "Exception",
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