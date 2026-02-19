<%@ WebHandler Language="C#" Class="SaleClosingHandler" %>
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
/// FileName        : SaleClosingHandler.ashx
/// Description     : 매출마감현황 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-08-31
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SaleClosingHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingSale/SaleClosingList"; //필수

    // 메소드 리스트
    private const string MethodSaleClosingList           = "SaleClosingList";           //매출 거래처 목록
    private const string MethodSaleClosingListExcel      = "SaleClosingListExcel";      //매출 거래처 엑셀
    private const string MethodSaleClosingOrderList      = "SaleClosingOrderList";      //매출 오더 목록
    private const string MethodSaleClosingOrderListExcel = "SaleClosingOrderListExcel"; //매출 오더 엑셀
    private const string MethodSaleClosingNoteUpd        = "SaleClosingNoteUpdate";     //매출 마감 메모 수정
    private const string MethodSaleClosingBillEtcUpd     = "SaleClosingBillEtcUpdate";  //매출 마감 별도 발행
    private const string MethodSaleClosingBillEtcCnl     = "SaleClosingBillEtcCancel";  //매출 마감 별도 취소
    private const string MethodClientChargeList          = "ClientChargeList";          //고객사 담당자 조회
    private const string MethodSaleClosingBillCnlSU      = "SaleClosingBillCancelSU";   //매출 마감 발행 취소 (관리자)
    private const string MethodClientCsList              = "ClientCsList";              //거래처담당조회

    SaleDasServices     objSaleDasServices     = new SaleDasServices();
    ClientDasServices   objClientDasServices   = new ClientDasServices();
    ClientCsDasServices objClientCsDasServices = new ClientCsDasServices();
    private HttpContext objHttpContext         = null;

    private string strCallType              = string.Empty;
    private int    intPageSize              = 0;
    private int    intPageNo                = 0;
    private string strCenterCode            = string.Empty;
    private string strClosingKind           = string.Empty;
    private string strDateType              = string.Empty;
    private string strDateFrom              = string.Empty;
    private string strDateTo                = string.Empty;
    private string strOrderLocationCodes    = string.Empty;
    private string strDeliveryLocationCodes = string.Empty;
    private string strPayClientName         = string.Empty;
    private string strClosingAdminName      = string.Empty;
    private string strSaleClosingSeqNo      = string.Empty;
    private string strNote                  = string.Empty;
    private string strSaleClosingSeqNos     = string.Empty;
    private string strBillStatus            = string.Empty;
    private string strBillKind              = string.Empty;
    private string strBillWrite             = string.Empty;
    private string strBillYMD               = string.Empty;
    private string strClientCode            = string.Empty;
    private string strChargeName            = string.Empty;
    private string strChargeOrderFlag       = string.Empty;
    private string strChargePayFlag         = string.Empty;
    private string strChargeBillFlag        = string.Empty;
    private string strPayChargeName         = string.Empty;
    private string strPayChargeCell         = string.Empty;
    private string strPayOrgAmt             = string.Empty;
    private string strPayClientCode         = string.Empty;
    private string strPayClientCorpNo       = string.Empty;
    private string strPayClientCeoName      = string.Empty;
    private string strCenterName            = string.Empty;
    private string strPickupYMDTo           = string.Empty;
    private string strOrderCnt              = string.Empty;
    private string strCsAdminType           = string.Empty;
    private string strCsAdminID             = string.Empty;
    private string strCsAdminName           = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodSaleClosingList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSaleClosingListExcel,      MenuAuthType.All);
        objMethodAuthList.Add(MethodSaleClosingOrderList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSaleClosingOrderListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodSaleClosingNoteUpd,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSaleClosingBillEtcUpd,     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSaleClosingBillEtcCnl,     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientChargeList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSaleClosingBillCnlSU,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientCsList,              MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("SaleClosingHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SaleClosingHandler");
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
            strCenterCode            = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),  "0");
            strClosingKind           = Utils.IsNull(SiteGlobal.GetRequestForm("ClosingKind"), "0");
            strDateType              = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),    "0");
            strDateFrom              = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes    = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strDeliveryLocationCodes = SiteGlobal.GetRequestForm("DeliveryLocationCodes");
            strPayClientName         = SiteGlobal.GetRequestForm("PayClientName");
            strClosingAdminName      = SiteGlobal.GetRequestForm("ClosingAdminName");
            strSaleClosingSeqNo      = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"), "0");
            strNote                  = SiteGlobal.GetRequestForm("Note");
            strSaleClosingSeqNos     = SiteGlobal.GetRequestForm("SaleClosingSeqNos");
            strBillStatus            = Utils.IsNull(SiteGlobal.GetRequestForm("BillStatus"), "1");
            strBillKind              = Utils.IsNull(SiteGlobal.GetRequestForm("BillKind"),   "99");
            strBillWrite             = SiteGlobal.GetRequestForm("BillWrite");
            strBillYMD               = SiteGlobal.GetRequestForm("BillYMD");
            strClientCode            = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0"); //검색용
            strChargeName            = SiteGlobal.GetRequestForm("ChargeName");
            strChargeOrderFlag       = SiteGlobal.GetRequestForm("ChargeOrderFlag");
            strChargePayFlag         = SiteGlobal.GetRequestForm("ChargePayFlag");
            strChargeBillFlag        = SiteGlobal.GetRequestForm("ChargeBillFlag");
            strPayChargeName         = SiteGlobal.GetRequestForm("PayChargeName");
            strPayChargeCell         = SiteGlobal.GetRequestForm("PayChargeCell");
            strPayOrgAmt             = Utils.IsNull(SiteGlobal.GetRequestForm("PayOrgAmt"),     "0");
            strPayClientCode         = Utils.IsNull(SiteGlobal.GetRequestForm("PayClientCode"), "0");
            strPayClientCorpNo       = SiteGlobal.GetRequestForm("PayClientCorpNo");
            strPayClientCeoName      = SiteGlobal.GetRequestForm("PayClientCeoName");
            strCenterName            = SiteGlobal.GetRequestForm("CenterName");
            strPickupYMDTo           = SiteGlobal.GetRequestForm("PickupYMDTo");
            strOrderCnt              = Utils.IsNull(SiteGlobal.GetRequestForm("OrderCnt"),    "0");
            strCsAdminType           = Utils.IsNull(SiteGlobal.GetRequestForm("CsAdminType"), "0");
            strCsAdminID             = SiteGlobal.GetRequestForm("CsAdminID");
            strCsAdminName           = SiteGlobal.GetRequestForm("CsAdminName");

            strDateFrom    = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo      = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
            strBillWrite   = string.IsNullOrWhiteSpace(strBillWrite) ? strBillWrite : strBillWrite.Replace("-", "");
            strBillYMD     = string.IsNullOrWhiteSpace(strBillYMD) ? strBillYMD : strBillYMD.Replace("-",         "");
            strPickupYMDTo = string.IsNullOrWhiteSpace(strPickupYMDTo) ? strPickupYMDTo : strPickupYMDTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleClosingHandler", "Exception",
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
                case MethodSaleClosingList:
                    GetSaleClosingList();
                    break;;
                case MethodSaleClosingListExcel:
                    GetSaleClosingListExcel();
                    break;
                case MethodSaleClosingOrderList:
                    GetSaleClosingOrderList();
                    break;
                case MethodSaleClosingOrderListExcel:
                    GetSaleClosingOrderListExcel();
                    break;
                case MethodSaleClosingNoteUpd:
                    SetSaleClosingNoteUpd();
                    break;
                case MethodSaleClosingBillEtcUpd:
                    SetSaleClosingBillEtcUpd();
                    break;
                case MethodSaleClosingBillEtcCnl:
                    SetSaleClosingBillEtcCnl();
                    break;
                case MethodClientChargeList:
                    GetClientChargeList();
                    break;
                case MethodSaleClosingBillCnlSU:
                    SetSaleClosingBillCnlSU();
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

            SiteGlobal.WriteLog("SaleClosingHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매출 전표 목록
    /// </summary>
    protected void GetSaleClosingList()
    {
        ReqSaleClosingList                lo_objReqSaleClosingList = null;
        ServiceResult<ResSaleClosingList> lo_objResSaleClosingList = null;

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
            lo_objReqSaleClosingList = new ReqSaleClosingList
            {
                SaleClosingSeqNo      = strSaleClosingSeqNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                ClosingKind           = strClosingKind.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                CsAdminID             = strCsAdminID,
                PayClientName         = strPayClientName,
                ClosingAdminName      = strClosingAdminName,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResSaleClosingList = objSaleDasServices.GetSaleClosingList(lo_objReqSaleClosingList);
            objResMap.strResponse    = "[" + JsonConvert.SerializeObject(lo_objResSaleClosingList) + "]";
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

    /// <summary>
    /// 매출 전표 목록 엑셀
    /// </summary>
    protected void GetSaleClosingListExcel()
    {
        ReqSaleClosingList                lo_objReqSaleClosingList = null;
        ServiceResult<ResSaleClosingList> lo_objResSaleClosingList = null;
        string                            lo_strFileName           = "";
        SpreadSheet                       lo_objExcel              = null;
        DataTable                         lo_dtData                = null;
        MemoryStream                      lo_outputStream          = null;
        byte[]                            lo_Content               = null;
        int                               lo_intColumnIndex        = 0;

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
            lo_objReqSaleClosingList = new ReqSaleClosingList
            {
                SaleClosingSeqNo      = strSaleClosingSeqNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                ClosingKind           = strClosingKind.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                CsAdminID             = strCsAdminID,
                PayClientName         = strPayClientName,
                ClosingAdminName      = strClosingAdminName,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResSaleClosingList = objSaleDasServices.GetSaleClosingList(lo_objReqSaleClosingList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전표번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("거래처명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("업무담당",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("매출합계",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("청구방식",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발행상태",  typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("발행구분",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서작성일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서발행일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서수취이메일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("카드청구상태",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("카드청구일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감자",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감일시",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("메모",       typeof(string)));

            foreach (var row in lo_objResSaleClosingList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.SaleClosingSeqNo,row.ClientCorpNo,row.CsAdminNames,row.ClientName
                                ,row.OrgAmt,row.SupplyAmt,row.TaxAmt,row.ClosingKindM,row.BillStatusM
                                ,row.BillKindM,row.BillWrite,row.BillYMD,row.BillChargeEmail,row.PayStatusM
                                ,row.PayYMD,row.ClosingAdminName,row.ClosingDate,row.Note);
            }

            lo_objExcel = new SpreadSheet {SheetName = "SaleClosingList"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
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

            SiteGlobal.WriteLog("SaleClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 전표 오더 목록
    /// </summary>
    protected void GetSaleClosingOrderList()
    {
        ReqSaleClosingOrderList                lo_objReqSaleClosingOrderList = null;
        ServiceResult<ResSaleClosingOrderList> lo_objResSaleClosingOrderList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo) || strSaleClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingOrderList = new ReqSaleClosingOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResSaleClosingOrderList = objSaleDasServices.GetSaleClosingOrderList(lo_objReqSaleClosingOrderList);
            objResMap.strResponse         = "[" + JsonConvert.SerializeObject(lo_objResSaleClosingOrderList) + "]";
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

    /// <summary>
    /// 매출 전표 오더 엑셀
    /// </summary>
    protected void GetSaleClosingOrderListExcel()
    {
        ReqSaleClosingOrderList                lo_objReqSaleClosingOrderList = null;
        ServiceResult<ResSaleClosingOrderList> lo_objResSaleClosingOrderList = null;
        string                                 lo_strFileName                = "";
        SpreadSheet                            lo_objExcel                   = null;
        DataTable                              lo_dtData                     = null;
        MemoryStream                           lo_outputStream               = null;
        byte[]                                 lo_Content                    = null;
        int                                    lo_intColumnIndex             = 0;
        double                                 lo_intSumAmt                  = 0;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo) || strSaleClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingOrderList = new ReqSaleClosingOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResSaleClosingOrderList = objSaleDasServices.GetSaleClosingOrderList(lo_objReqSaleClosingOrderList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감여부",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구방식",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전표번호",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감자",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",    typeof(string)));
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

            foreach (var row in lo_objResSaleClosingOrderList.data.list)
            {
                lo_intSumAmt = row.AdvanceSupplyAmt3 + row.SaleOrgAmt;
                lo_dtData.Rows.Add(row.CenterName,row.OrderNo,row.ClosingFlag,row.ClosingKindM,row.SaleClosingSeqNo
                    ,row.ClosingAdminName,row.ClosingDate,row.OrderItemCodeM,row.OrderLocationCodeM,row.OrderClientName
                    ,row.PayClientName,row.PayClientChargeName,row.PayClientChargeLocation,row.ConsignorName,row.PickupYMD
                    ,row.PickupPlace,row.GetYMD,row.GetPlace,row.SaleCarryoverFlag,row.Nation
                    ,row.Hawb,row.Mawb,row.Volume,row.CBM,row.Weight
                    ,row.SaleOrgAmt,row.SaleSupplyAmt,row.SaleTaxAmt,row.AdvanceSupplyAmt3,lo_intSumAmt
                    ,row.CarNo);
            }

            lo_objExcel = new SpreadSheet {SheetName = "SaleClosingOrderList"};

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

            SiteGlobal.WriteLog("SaleClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 마감 메모 등록
    /// </summary>
    protected void SetSaleClosingNoteUpd()
    {
        ReqSaleClosingNoteUpd lo_objReqSaleClosingNoteUpd = null;
        ServiceResult<bool>   lo_objResSaleClosingNoteUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo) || strSaleClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingNoteUpd = new ReqSaleClosingNoteUpd
            {
                CenterCode       = strCenterCode.ToInt(),
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                Note             = strNote,
                UpdAdminID       = objSes.AdminID,
                UpdAdminName     = objSes.AdminName
            };

            lo_objResSaleClosingNoteUpd = objSaleDasServices.SetSaleClosingNoteUpd(lo_objReqSaleClosingNoteUpd);
            objResMap.RetCode           = lo_objResSaleClosingNoteUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleClosingNoteUpd.result.ErrorMsg;
            }
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

    /// <summary>
    /// 매출 마감 별도 발행
    /// </summary>
    protected void SetSaleClosingBillEtcUpd()
    {
        ReqSaleClosingBillInfoUpd lo_objReqSaleClosingBillInfoUpd = null;
        ServiceResult<bool>       lo_objResSaleClosingBillInfoUpd = null;
        strBillStatus = "3";

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

        if (string.IsNullOrWhiteSpace(strBillWrite))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strBillKind) || strBillKind.Equals("99"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingBillInfoUpd = new ReqSaleClosingBillInfoUpd
            {
                CenterCode        = strCenterCode.ToInt(),
                SaleClosingSeqNos = strSaleClosingSeqNos,
                BillKind          = strBillKind.ToInt(),
                BillStatus        = strBillStatus.ToInt(),
                BillWrite         = strBillWrite,
                BillYMD           = strBillYMD,
                BillAdminID       = objSes.AdminID,
                BillAdminName     = objSes.AdminName
            };

            lo_objResSaleClosingBillInfoUpd = objSaleDasServices.SetSaleClosingBillInfoUpd(lo_objReqSaleClosingBillInfoUpd);
            objResMap.RetCode               = lo_objResSaleClosingBillInfoUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleClosingBillInfoUpd.result.ErrorMsg;
            }
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

    /// <summary>
    /// 매출 마감 별도 발행 취소
    /// </summary>
    protected void SetSaleClosingBillEtcCnl()
    {
        ReqSaleClosingBillInfoUpd lo_objReqSaleClosingBillInfoUpd = null;
        ServiceResult<bool>       lo_objResSaleClosingBillInfoUpd = null;
        strBillKind   = "99";
        strBillStatus = "1";
        strBillWrite  = string.Empty;
        strBillYMD    = string.Empty;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNos))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingBillInfoUpd = new ReqSaleClosingBillInfoUpd
            {
                CenterCode        = strCenterCode.ToInt(),
                SaleClosingSeqNos = strSaleClosingSeqNos,
                BillKind          = strBillKind.ToInt(),
                BillStatus        = strBillStatus.ToInt(),
                BillWrite         = strBillWrite,
                BillYMD           = strBillYMD,
                BillAdminID       = objSes.AdminID,
                BillAdminName     = objSes.AdminName
            };

            lo_objResSaleClosingBillInfoUpd = objSaleDasServices.SetSaleClosingBillInfoUpd(lo_objReqSaleClosingBillInfoUpd);
            objResMap.RetCode               = lo_objResSaleClosingBillInfoUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleClosingBillInfoUpd.result.ErrorMsg;
            }
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

    /// <summary>
    /// 담당자 검색
    /// </summary>
    protected void GetClientChargeList()
    {
        ReqClientSearchList                lo_objReqClientSearchList = null;
        ServiceResult<ResClientSearchList> lo_objResClientSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strChargeName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientSearchList = new ReqClientSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                UseFlag          = "Y",
                ChargeName       = strChargeName,
                ChargeOrderFlag  = strChargeOrderFlag,
                ChargePayFlag    = strChargePayFlag,
                ChargeUseFlag    = "Y",
                ChargeBillFlag   = strChargeBillFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientSearchList = objClientDasServices.GetClientSearchList(lo_objReqClientSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResClientSearchList) + "]";
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

    /// <summary>
    /// 관리자 계산서 발행 취소
    /// </summary>
    protected void SetSaleClosingBillCnlSU()
    {
        ReqSaleClosingBillCnl                lo_objReqSaleClosingBillCnl = null;
        ServiceResult<ResSaleClosingBillCnl> lo_objResSaleClosingBillCnl = null;

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

        if (objSes.GradeCode > 4)
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "취소할 수 있는 권한이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingBillCnl = new ReqSaleClosingBillCnl
            {
                CenterCode        = strCenterCode.ToInt(),
                SaleClosingSeqNos = strSaleClosingSeqNos,
                AdminID           = objSes.AdminID
            };

            lo_objResSaleClosingBillCnl = objSaleDasServices.SetSaleClosingBillCnl(lo_objReqSaleClosingBillCnl);
            objResMap.RetCode           = lo_objResSaleClosingBillCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleClosingBillCnl.result.ErrorMsg;
                return;
            }

            objResMap.Add("TotalCnt",  lo_objResSaleClosingBillCnl.data.TotalCnt);
            objResMap.Add("CancelCnt", lo_objResSaleClosingBillCnl.data.CancelCnt);
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
            // ignored
        }
    }
}