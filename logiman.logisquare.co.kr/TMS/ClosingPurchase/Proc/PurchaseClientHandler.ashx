<%@ WebHandler Language="C#" Class="PurchaseClientHandler" %>
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
/// FileName        : PurchaseClientHandler.ashx
/// Description     : 매입마감 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-10-26
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class PurchaseClientHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingPurchase/PurchaseClientList"; //필수

    // 메소드 리스트
    private const string MethodPurchaseClientList         = "PurchaseClientList";         //매입 거래처 목록
    private const string MethodPurchaseClientListExcel    = "PurchaseClientListExcel";    //매입 거래처 엑셀
    private const string MethodPurchaseClientPayList      = "PurchaseClientPayList";      //매입 비용 목록
    private const string MethodPurchaseClientPayListExcel = "PurchaseClientPayListExcel"; //매입 비용 엑셀
    private const string MethodPurchaseClosingIns         = "PurchaseClosingInsert";      //매입 마감
    private const string MethodPurchaseClosingCnl         = "PurchaseClosingCancel";      //매입 마감 취소

    PurchaseDasServices    objPurchaseDasServices    = new PurchaseDasServices();
    private HttpContext    objHttpContext            = null;

    private string strCallType             = string.Empty;
    private int    intPageSize             = 0;
    private int    intPageNo               = 0;
    private string strCenterCode           = string.Empty;
    private string strDateType             = string.Empty;
    private string strDateFrom             = string.Empty;
    private string strDateTo               = string.Empty;
    private string strOrderLocationCodes   = string.Empty;
    private string strOrderItemCodes       = string.Empty;
    private string strClientCode           = string.Empty;
    private string strClientName           = string.Empty;
    private string strClientCorpNo         = string.Empty;
    private string strClosingFlag          = string.Empty;
    private string strPurchaseOrgAmt       = string.Empty;
    private string strPurchaseSeqNos1      = string.Empty;
    private string strPurchaseSeqNos2      = string.Empty;
    private string strPurchaseSeqNos3      = string.Empty;
    private string strPurchaseSeqNos4      = string.Empty;
    private string strPurchaseSeqNos5      = string.Empty;
    private string strDeductAmt            = string.Empty;
    private string strDeductReason         = string.Empty;
    private string strNote                 = string.Empty;
    private string strPurchaseClosingSeqNo = string.Empty;
    
    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPurchaseClientList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseClientListExcel,    MenuAuthType.All);
        objMethodAuthList.Add(MethodPurchaseClientPayList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseClientPayListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodPurchaseClosingIns,         MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPurchaseClosingCnl,         MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("PurchaseClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("PurchaseClientHandler");
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
            strDateType              = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom              = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes    = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes        = SiteGlobal.GetRequestForm("OrderItemCodes");
            strClientCode               = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strClientName               = SiteGlobal.GetRequestForm("ClientName");
            strClientCorpNo             = SiteGlobal.GetRequestForm("ClientCorpNo");
            strClosingFlag           = SiteGlobal.GetRequestForm("ClosingFlag");
            strPurchaseOrgAmt        = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseOrgAmt"), "0");
            strPurchaseSeqNos1       = SiteGlobal.GetRequestForm("PurchaseSeqNos1");
            strPurchaseSeqNos2       = SiteGlobal.GetRequestForm("PurchaseSeqNos2");
            strPurchaseSeqNos3       = SiteGlobal.GetRequestForm("PurchaseSeqNos3");
            strPurchaseSeqNos4       = SiteGlobal.GetRequestForm("PurchaseSeqNos4");
            strPurchaseSeqNos5       = SiteGlobal.GetRequestForm("PurchaseSeqNos5");
            strDeductAmt             = Utils.IsNull(SiteGlobal.GetRequestForm("DeductAmt"),   "0");
            strDeductReason          = SiteGlobal.GetRequestForm("DeductReason");
            strNote                  = SiteGlobal.GetRequestForm("Note");
            strPurchaseClosingSeqNo  = SiteGlobal.GetRequestForm("PurchaseClosingSeqNo");

            strDateFrom  = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo    = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClientHandler", "Exception",
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
                case MethodPurchaseClientList:
                    GetPurchaseClientList();
                    break;;
                case MethodPurchaseClientListExcel:
                    GetPurchaseClientListExcel();
                    break;
                case MethodPurchaseClientPayList:
                    GetPurchaseClientPayList();
                    break;
                case MethodPurchaseClientPayListExcel:
                    GetPurchaseClientPayListExcel();
                    break;
                case MethodPurchaseClosingIns:
                    SetPurchaseClosingIns();
                    break;
                case MethodPurchaseClosingCnl:
                    SetPurchaseClosingCnl();
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

            SiteGlobal.WriteLog("PurchaseClientHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매입 거래처 목록
    /// </summary>
    protected void GetPurchaseClientList()
    {
        ReqPurchaseClientList                lo_objReqPurchaseClientList = null;
        ServiceResult<ResPurchaseClientList> lo_objResPurchaseClientList = null;

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
            lo_objReqPurchaseClientList = new ReqPurchaseClientList
            {
                CenterCode         = strCenterCode.ToInt(),
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                ClosingFlag        = strClosingFlag,
                ClientName         = strClientName,
                ClientCorpNo       = strClientCorpNo,
                AccessCenterCode   = objSes.AccessCenterCode,
                PageSize           = intPageSize,
                PageNo             = intPageNo
            };

            lo_objResPurchaseClientList = objPurchaseDasServices.GetPurchaseClientList(lo_objReqPurchaseClientList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 거래처 엑셀
    /// </summary>
    protected void GetPurchaseClientListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqPurchaseClientList                lo_objReqPurchaseClientList = null;
        ServiceResult<ResPurchaseClientList> lo_objResPurchaseClientList = null;
        string                               lo_strFileName              = "";
        SpreadSheet                          lo_objExcel                 = null;
        DataTable                            lo_dtData                   = null;
        MemoryStream                         lo_outputStream             = null;
        byte[]                               lo_Content                  = null;
        int                                  lo_intColumnIndex           = 0;

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
            lo_objReqPurchaseClientList = new ReqPurchaseClientList
            {
                CenterCode         = strCenterCode.ToInt(),
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                ClientName         = strClientName,
                ClientCorpNo       = strClientCorpNo,
                ClosingFlag        = strClosingFlag,
                AccessCenterCode   = objSes.AccessCenterCode,
                PageSize           = intPageSize,
                PageNo             = intPageNo
            };

            lo_objResPurchaseClientList = objPurchaseDasServices.GetPurchaseClientList(lo_objReqPurchaseClientList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업자번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("매입합계",     typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("비용건수",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("마감비용건수", typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("사업자상태",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("결제일",  typeof(string)));
                
            lo_dtData.Columns.Add(new DataColumn("과세구분",   typeof(string)));

            foreach (var row in lo_objResPurchaseClientList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.ClientName,row.ClientCorpNo,row.PurchaseOrgAmt,row.PurchaseSupplyAmt
                                ,row.PurchaseTaxAmt,row.PurchaseCnt,row.ClosingPurchaseCnt,row.ClientStatusM,row.ClientPayDay
                                ,row.ClientTaxKindM);
            }
            

            lo_objExcel = new SpreadSheet {SheetName = "PurchaseClientList"};

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

            SiteGlobal.WriteLog("PurchaseClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 비용 목록
    /// </summary>
    protected void GetPurchaseClientPayList()
    {
        ReqPurchaseClientPayList                lo_objReqPurchaseClientPayList = null;
        ServiceResult<ResPurchaseClientPayList> lo_objResPurchaseClientPayList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
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
            lo_objReqPurchaseClientPayList = new ReqPurchaseClientPayList
            {
                CenterCode         = strCenterCode.ToInt(),
                ClientCode         = strClientCode.ToInt64(),
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                ClientName         = strClientName,
                ClientCorpNo       = strClientCorpNo,
                ClosingFlag        = strClosingFlag,
                AccessCenterCode   = objSes.AccessCenterCode
            };

            lo_objResPurchaseClientPayList = objPurchaseDasServices.GetPurchaseClientPayList(lo_objReqPurchaseClientPayList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseClientPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 비용 엑셀
    /// </summary>
    protected void GetPurchaseClientPayListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;
            
        ReqPurchaseClientPayList                lo_objReqPurchaseClientPayList = null;
        ServiceResult<ResPurchaseClientPayList> lo_objResPurchaseClientPayList = null;
        string                                  lo_strFileName                 = "";
        SpreadSheet                             lo_objExcel                    = null;
        DataTable                               lo_dtData                      = null;
        MemoryStream                            lo_outputStream                = null;
        byte[]                                  lo_Content                     = null;
        int                                     lo_intColumnIndex              = 0;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
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
            lo_objReqPurchaseClientPayList = new ReqPurchaseClientPayList
            {
                CenterCode         = strCenterCode.ToInt(),
                ClientCode         = strClientCode.ToInt64(),
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                ClientName         = strClientName,
                ClientCorpNo       = strClientCorpNo,
                ClosingFlag        = strClosingFlag,
                AccessCenterCode   = objSes.AccessCenterCode
            };

            lo_objResPurchaseClientPayList = objPurchaseDasServices.GetPurchaseClientPayList(lo_objReqPurchaseClientPayList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감여부",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서발행상태", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전표번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감자",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처명",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("청구처명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총수량",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총부피",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총중량",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총길이",   typeof(double)));

            lo_dtData.Columns.Add(new DataColumn("매입합계",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",   typeof(double)));
            
            foreach (var row in lo_objResPurchaseClientPayList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.OrderNo,row.ClosingFlag,row.BillStatusM,row.PurchaseClosingSeqNo
                     ,row.ClosingAdminName,row.ClosingDate,row.OrderItemCodeM,row.OrderLocationCodeM,row.OrderClientName
                     ,row.PayClientName,row.ConsignorName,row.PickupYMD,row.PickupPlace,row.GetYMD
                     ,row.GetPlace,row.Volume,row.CBM,row.Weight,row.Length
                     ,row.PurchaseOrgAmt,row.PurchaseSupplyAmt,row.PurchaseTaxAmt);
            }
            
            lo_objExcel = new SpreadSheet {SheetName = "PurchaseClientPayList"};

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
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

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

            SiteGlobal.WriteLog("PurchaseClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감
    /// </summary>
    protected void SetPurchaseClosingIns()
    {
        ReqPurchaseClosingClientIns                lo_objReqPurchaseClosingClientIns = null;
        ServiceResult<ResPurchaseClosingClientIns> lo_objResPurchaseClosingClientIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseSeqNos1) && string.IsNullOrWhiteSpace(strPurchaseSeqNos2) && string.IsNullOrWhiteSpace(strPurchaseSeqNos3) && string.IsNullOrWhiteSpace(strPurchaseSeqNos4) && string.IsNullOrWhiteSpace(strPurchaseSeqNos5))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objReqPurchaseClosingClientIns = new ReqPurchaseClosingClientIns
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt64(),
                PurchaseSeqNos1  = strPurchaseSeqNos1,
                PurchaseSeqNos2  = strPurchaseSeqNos2,
                PurchaseSeqNos3  = strPurchaseSeqNos3,
                PurchaseSeqNos4  = strPurchaseSeqNos4,
                PurchaseSeqNos5  = strPurchaseSeqNos5,
                PurchaseOrgAmt   = strPurchaseOrgAmt.ToDouble(),
                DeductAmt        = strDeductAmt.ToDouble(),
                DeductReason     = strDeductReason,
                Note             = strNote,
                ClosingAdminID   = objSes.AdminID,
                ClosingAdminName = objSes.AdminName
            };
                
            lo_objResPurchaseClosingClientIns = objPurchaseDasServices.SetPurchaseClosingClientIns(lo_objReqPurchaseClosingClientIns);
            objResMap.RetCode           = lo_objResPurchaseClosingClientIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseClosingClientIns.result.ErrorMsg;
                return;
            }

            objResMap.Add("PurchaseClosingSeqNo", lo_objResPurchaseClosingClientIns.data.PurchaseClosingSeqNo.ToString());
            objResMap.Add("PurchaseOrgAmt",       lo_objResPurchaseClosingClientIns.data.PurchaseOrgAmt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClientHandler", "Exception",
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

            SiteGlobal.WriteLog("PurchaseClientHandler", "Exception",
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