<%@ WebHandler Language="C#" Class="AdvanceHandler" %>
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
/// FileName        : AdvanceHandler.ashx
/// Description     : 선급/예수관리 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-22
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class AdvanceHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingAdvance/AdvanceList"; //필수

    // 메소드 리스트
    private const string MethodAdvanceList         = "AdvanceList";         //선급 / 예수 목록
    private const string MethodAdvanceListExcel    = "AdvanceListExcel";    //선급 / 예수 엑셀
    private const string MethodClientList          = "ClientList";          //고객사 조회
    private const string MethodPayDepositList      = "PayDepositList";      //입금 내역
    private const string MethodPayDepositListExcel = "PayDepositListExcel"; //입금 내역 엑셀
    private const string MethodPayDepositInsert    = "PayDepositInsert";    //입금 등록
    private const string MethodPayDepositDelete    = "PayDepositDelete";    //입금 삭제

    DepositDasServices  objDepositDasServices = new DepositDasServices();
    ClientDasServices   objClientDasServices  = new ClientDasServices();
    private HttpContext objHttpContext        = null;

    private string strCallType                = string.Empty;
    private int    intPageSize                = 0;
    private int    intPageNo                  = 0;
    private string strCenterCode              = string.Empty;
    private string strDateType                = string.Empty;
    private string strDateFrom                = string.Empty;
    private string strDateTo                  = string.Empty;
    private string strPayType                 = string.Empty;
    private string strOrderLocationCodes      = string.Empty;
    private string strOrderItemCodes          = string.Empty;
    private string strSearchClientType        = string.Empty;
    private string strSearchClientText        = string.Empty;
    private string strSearchChargeType        = string.Empty;
    private string strSearchChargeText        = string.Empty;
    private string strDepositClientName       = string.Empty;
    private string strDepositNote             = string.Empty;
    private string strOrderClientName         = string.Empty;
    private string strOrderClientChargeName   = string.Empty;
    private string strPayClientName           = string.Empty;
    private string strPayClientChargeName     = string.Empty;
    private string strPayClientChargeLocation = string.Empty;
    private string strConsignorName           = string.Empty;
    private string strAcceptAdminName         = string.Empty;
    private string strDepositClosingSeqNo     = string.Empty;
    private string strOrderNo                 = string.Empty;
    private string strClientCode              = string.Empty; //검색용
    private string strClientName              = string.Empty;
    private string strChargeName              = string.Empty;
    private string strChargeOrderFlag         = string.Empty;
    private string strChargePayFlag           = string.Empty;
    private string strChargeBillFlag          = string.Empty;
    private string strClientFlag              = string.Empty;
    private string strChargeFlag              = string.Empty;
    private string strDepositYMD              = string.Empty;
    private string strDepositAmt              = string.Empty;
    private string strAdvanceSeqNos           = string.Empty;
    private string strDepositClosingSeqNos    = string.Empty;
    private string strDepositTypes            = string.Empty;
    private string strOrgAmt                  = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAdvanceList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAdvanceListExcel,    MenuAuthType.All);
        objMethodAuthList.Add(MethodClientList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPayDepositList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPayDepositListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodPayDepositInsert,    MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPayDepositDelete,    MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AdvanceHandler");
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
            strPayType                 = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"), "0");
            strOrderLocationCodes      = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes          = SiteGlobal.GetRequestForm("OrderItemCodes");
            strSearchClientType        = SiteGlobal.GetRequestForm("SearchClientType");
            strSearchClientText        = SiteGlobal.GetRequestForm("SearchClientText");
            strSearchChargeType        = SiteGlobal.GetRequestForm("SearchChargeType");
            strSearchChargeText        = SiteGlobal.GetRequestForm("SearchChargeText");
            strOrderClientName         = SiteGlobal.GetRequestForm("OrderClientName");
            strOrderClientChargeName   = SiteGlobal.GetRequestForm("OrderClientChargeName");
            strPayClientName           = SiteGlobal.GetRequestForm("PayClientName");
            strPayClientChargeName     = SiteGlobal.GetRequestForm("PayClientChargeName");
            strPayClientChargeLocation = SiteGlobal.GetRequestForm("PayClientChargeLocation");
            strConsignorName           = SiteGlobal.GetRequestForm("ConsignorName");
            strAcceptAdminName         = SiteGlobal.GetRequestForm("AcceptAdminName"); 
            strDepositClosingSeqNo     = Utils.IsNull(SiteGlobal.GetRequestForm("DepositClosingSeqNo"), "0");
            strOrderNo                 = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),             "0");
            strClientCode              = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"),          "0"); //검색용
            strClientName              = SiteGlobal.GetRequestForm("ClientName");
            strChargeName              = SiteGlobal.GetRequestForm("ChargeName");
            strChargeOrderFlag         = SiteGlobal.GetRequestForm("ChargeOrderFlag");
            strChargePayFlag           = SiteGlobal.GetRequestForm("ChargePayFlag");
            strChargeBillFlag          = SiteGlobal.GetRequestForm("ChargeBillFlag");
            strClientFlag              = SiteGlobal.GetRequestForm("ClientFlag");
            strChargeFlag              = SiteGlobal.GetRequestForm("ChargeFlag");
            strDepositYMD              = SiteGlobal.GetRequestForm("DepositYMD");
            strDepositAmt              = Utils.IsNull(SiteGlobal.GetRequestForm("DepositAmt"), "0");
            strAdvanceSeqNos           = SiteGlobal.GetRequestForm("AdvanceSeqNos");
            strDepositClosingSeqNos    = SiteGlobal.GetRequestForm("DepositClosingSeqNos");
            strDepositTypes            = SiteGlobal.GetRequestForm("DepositTypes");
            strOrgAmt                  = Utils.IsNull(SiteGlobal.GetRequestForm("OrgAmt"), "0");

            strDateFrom   = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo     = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
            strDepositYMD = string.IsNullOrWhiteSpace(strDepositYMD) ? strDepositYMD : strDepositYMD.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
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
                case MethodAdvanceList:
                    GetAdvanceList();
                    break;
                case MethodAdvanceListExcel:
                    GetAdvanceListExcel();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodPayDepositList:
                    GetPayDepositList();
                    break;
                case MethodPayDepositListExcel:
                    GetPayDepositListExcel();
                    break;
                case MethodPayDepositInsert:
                    SetPayDepositInsert();
                    break;
                case MethodPayDepositDelete:
                    SetPayDepositDelete();
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

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 선급 / 예수 목록
    /// </summary>
    protected void GetAdvanceList()
    {
        ReqOrderAdvanceList                lo_objReqOrderAdvanceList = null;
        ServiceResult<ResOrderAdvanceList> lo_objResOrderAdvanceList = null;

        if (strDepositClosingSeqNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
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

        strOrderClientChargeName   = string.Empty;
        strPayClientChargeName     = string.Empty;
        strPayClientChargeLocation = string.Empty;
        strAcceptAdminName         = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchChargeType) && !string.IsNullOrWhiteSpace(strSearchChargeText))
        {
            switch (strSearchChargeType)
            {
                case "1":
                    strOrderClientChargeName = strSearchChargeText;
                    break;
                case "2":
                    strPayClientChargeName = strSearchChargeText;
                    break;
                case "3":
                    strPayClientChargeLocation = strSearchChargeText;
                    break;
                case "4":
                    strAcceptAdminName = strSearchChargeText;
                    break;
            }
        }

        try
        {
            lo_objReqOrderAdvanceList = new ReqOrderAdvanceList
            {
                DepositClosingSeqNo     = strDepositClosingSeqNo.ToInt64(),
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                PayType                 = strPayType.ToInt(),
                DateType                = strDateType.ToInt(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderClientName         = strOrderClientName,
                OrderClientChargeName   = strOrderClientChargeName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                AcceptAdminName         = strAcceptAdminName,
                OrgAmt                  = strOrgAmt.ToDouble(),
                ClientName              = strClientName,
                DepositClientName       = strDepositClientName,
                DepositAmt              = strDepositAmt.ToDouble(),
                DepositNote             = strDepositNote,
                AccessCenterCode        = objSes.AccessCenterCode,
                PageSize                = intPageSize,
                PageNo                  = intPageNo,
            };

            lo_objResOrderAdvanceList = objDepositDasServices.GetOrderAdvanceList(lo_objReqOrderAdvanceList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderAdvanceList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 선급 / 예수 목록 엑셀
    /// </summary>
    protected void GetAdvanceListExcel()
    {
        ReqOrderAdvanceList                lo_objReqOrderAdvanceList = null;
        ServiceResult<ResOrderAdvanceList> lo_objResOrderAdvanceList = null;
        string                             lo_strFileName            = "";
        SpreadSheet                        lo_objExcel               = null;
        DataTable                          lo_dtData                 = null;
        MemoryStream                       lo_outputStream           = null;
        byte[]                             lo_Content                = null;
        int                                lo_intColumnIndex         = 0;
            
        if (strDepositClosingSeqNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
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

        strOrderClientChargeName   = string.Empty;
        strPayClientChargeName     = string.Empty;
        strPayClientChargeLocation = string.Empty;
        strAcceptAdminName         = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchChargeType) && !string.IsNullOrWhiteSpace(strSearchChargeText))
        {
            switch (strSearchChargeType)
            {
                case "1":
                    strOrderClientChargeName = strSearchChargeText;
                    break;
                case "2":
                    strPayClientChargeName = strSearchChargeText;
                    break;
                case "3":
                    strPayClientChargeLocation = strSearchChargeText;
                    break;
                case "4":
                    strAcceptAdminName = strSearchChargeText;
                    break;
            }
        }

        try
        {
            lo_objReqOrderAdvanceList = new ReqOrderAdvanceList
            {
                DepositClosingSeqNo     = strDepositClosingSeqNo.ToInt64(),
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                PayType                 = strPayType.ToInt(),
                DateType                = strDateType.ToInt(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderClientName         = strOrderClientName,
                OrderClientChargeName   = strOrderClientChargeName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                AcceptAdminName         = strAcceptAdminName,
                OrgAmt                  = strOrgAmt.ToDouble(),
                ClientName              = strClientName,
                DepositClientName       = strDepositClientName,
                DepositAmt              = strDepositAmt.ToDouble(),
                DepositNote             = strDepositNote,
                AccessCenterCode        = objSes.AccessCenterCode,
                PageSize                = intPageSize,
                PageNo                  = intPageNo,
            };

            lo_objResOrderAdvanceList = objDepositDasServices.GetOrderAdvanceList(lo_objReqOrderAdvanceList);

            lo_dtData = new DataTable();
                
            lo_dtData.Columns.Add(new DataColumn("회원사명",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금여부",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금구분",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금일",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금업체명",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금비고",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금등록일",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금등록자",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("비용구분",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",       typeof(string)));
                
            lo_dtData.Columns.Add(new DataColumn("상품",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)담당자",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구사업장",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("H/AWB",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("CNTR No", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("업체명",     typeof(string)));
                
            lo_dtData.Columns.Add(new DataColumn("항목",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("합계금액", typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액", typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("접수일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수자명", typeof(string)));
            
            foreach (var row in lo_objResOrderAdvanceList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.ClosingFlag,row.DepositTypeM,row.DepositYMD,row.DepositClientName
                ,row.DepositNote,row.ClosingDate,row.ClosingAdminName,row.PayTypeM,row.OrderNo
                ,row.OrderItemCodeM,row.OrderLocationCodeM,row.PayClientName,row.PayClientChargeName,row.PayClientChargeLocation
                ,row.ConsignorName,row.PickupYMD,row.Hawb,row.CntrNo,row.ClientName
                ,row.ItemNameM,row.AdvanceOrgAmt,row.AdvanceSupplyAmt,row.AdvanceTaxAmt,row.AcceptDate
                ,row.AcceptAdminName);
            }
            
            lo_objExcel = new SpreadSheet {SheetName = "AdvanceList"};

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
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
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

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 목록
    /// </summary>
    protected void GetClientList()
    {
        ReqClientSearchList                lo_objReqClientSearchList = null;
        ServiceResult<ResClientSearchList> lo_objResClientSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientName))
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
                ClientName       = strClientName,
                UseFlag          = "Y",
                ChargeOrderFlag  = strChargeOrderFlag,
                ChargePayFlag    = strChargePayFlag,
                ChargeBillFlag   = strChargeBillFlag,
                ChargeUseFlag    = "Y",
                ClientFlag       = strClientFlag,
                ChargeFlag       = strChargeFlag,
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

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 내역
    /// </summary>
    protected void GetPayDepositList()
    {
        ReqPayDepositList                lo_objReqPayDepositList = null;
        ServiceResult<ResPayDepositList> lo_objResPayDepositList = null;

        if (strDepositClosingSeqNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        strDepositTypes = "1,2";

        try
        {
            lo_objReqPayDepositList = new ReqPayDepositList
            {
                DepositClosingSeqNo = strDepositClosingSeqNo.ToInt64(),
                CenterCode          = strCenterCode.ToInt(),
                ClientCode          = strClientCode.ToInt64(),
                ClientName          = strClientName,
                DepositAmt          = strDepositAmt.ToDouble(),
                DepositTypes        = strDepositTypes,
                DateFrom            = strDateFrom,
                DateTo              = strDateTo,
                Note                = strDepositNote,
                AccessCenterCode    = objSes.AccessCenterCode,
                PageSize            = intPageSize,
                PageNo              = intPageNo,
            };

            lo_objResPayDepositList = objDepositDasServices.GetPayDepositList(lo_objReqPayDepositList);
            objResMap.strResponse   = "[" + JsonConvert.SerializeObject(lo_objResPayDepositList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 내역 엑셀
    /// </summary>
    protected void GetPayDepositListExcel()
    {
        ReqPayDepositList                lo_objReqPayDepositList = null;
        ServiceResult<ResPayDepositList> lo_objResPayDepositList = null;
        string                           lo_strFileName          = "";
        SpreadSheet                      lo_objExcel             = null;
        DataTable                        lo_dtData               = null;
        MemoryStream                     lo_outputStream         = null;
        byte[]                           lo_Content              = null;
        int                              lo_intColumnIndex       = 0;

        if (strDepositClosingSeqNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        strDepositTypes = "1,2";

        try
        {
            lo_objReqPayDepositList = new ReqPayDepositList
            {
                DepositClosingSeqNo = strDepositClosingSeqNo.ToInt64(),
                CenterCode          = strCenterCode.ToInt(),
                ClientCode          = strClientCode.ToInt64(),
                ClientName          = strClientName,
                DepositTypes        = strDepositTypes,
                DateFrom            = strDateFrom,
                DateTo              = strDateTo,
                Note                = strDepositNote,
                AccessCenterCode    = objSes.AccessCenterCode,
                PageSize            = intPageSize,
                PageNo              = intPageNo,
            };

            lo_objResPayDepositList = objDepositDasServices.GetPayDepositList(lo_objReqPayDepositList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금전표번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금구분",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금액",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("입금업체명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금비고",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금등록일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금등록자",  typeof(string)));
            
            foreach (var row in lo_objResPayDepositList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.DepositClosingSeqNo,row.DepositTypeM,row.InputYMD,row.Amt
                    ,row.ClientName,row.Note,row.RegDate,row.RegAdminName);
            }
            
            lo_objExcel = new SpreadSheet {SheetName = "PayDepositList"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);
                
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
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

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 등록
    /// </summary>
    protected void SetPayDepositInsert()
    {
        PayDepositModel                lo_objPayDepositModel  = null;
        ServiceResult<PayDepositModel> lo_objResPayDepositIns = null;
        int                            lo_intDepositType      = 0;
            
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
            
        if (string.IsNullOrWhiteSpace(strPayType) || strPayType.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        if (string.IsNullOrWhiteSpace(strDepositYMD))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        if (string.IsNullOrWhiteSpace(strAdvanceSeqNos))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        if (string.IsNullOrWhiteSpace(strDepositAmt) || strDepositAmt.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        lo_intDepositType = strPayType.Equals("3") ? 1 : 2;

        try
        {
            lo_objPayDepositModel = new PayDepositModel
            {
                CenterCode    = strCenterCode.ToInt(),
                ClientCode    = strClientCode.ToInt64(),
                ClientName    = strClientName,
                AdvanceSeqNos = strAdvanceSeqNos,
                DepositType   = lo_intDepositType,      
                InputYMD      = strDepositYMD,
                Amt           = strDepositAmt.ToDouble(),
                Note          = strDepositNote,
                RegAdminID    = objSes.AdminID,
                RegAdminName  = objSes.AdminName
            };

            lo_objResPayDepositIns = objDepositDasServices.SetPayDepositIns(lo_objPayDepositModel);
            objResMap.RetCode      = lo_objResPayDepositIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayDepositIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("DepositClosingSeqNo", lo_objResPayDepositIns.data.DepositClosingSeqNo.ToString());
                objResMap.Add("DepositSeqNo",        lo_objResPayDepositIns.data.DepositSeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 삭제
    /// </summary>
    protected void SetPayDepositDelete()
    {
        
        PayDepositModel     lo_objPayDepositModel  = null;
        ServiceResult<bool> lo_objResPayDepositDel = null;
            
        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        if (string.IsNullOrWhiteSpace(strDepositClosingSeqNos))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objPayDepositModel = new PayDepositModel
            {
                CenterCode           = strCenterCode.ToInt(),
                DepositClosingSeqNos = strDepositClosingSeqNos,
                DelAdminID           = objSes.AdminID,
                DelAdminName         = objSes.AdminName
            };

            lo_objResPayDepositDel = objDepositDasServices.SetPayDepositDel(lo_objPayDepositModel);
            objResMap.RetCode      = lo_objResPayDepositDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayDepositDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdvanceHandler", "Exception",
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