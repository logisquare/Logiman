<%@ WebHandler Language="C#" Class="InoutUpsHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : InoutUpsHandler.ashx
/// Description     : 오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2023-06-23
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class InoutUpsHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Inout/InoutUpsList"; //필수

    // 메소드 리스트
    private const string MethodPayItemCodeList   = "PayItemCodeList";   //비용항목코드
    private const string MethodInoutUpsList      = "InoutUpsList";      //UPS내역서
    private const string MethodInoutUpsExcelList = "InoutUpsExcelList"; //수출/입 내역서
        
    OrderDasServices    objOrderDasServices = new OrderDasServices();
    private HttpContext objHttpContext      = null;

    private string strCallType             = string.Empty;
    private int    intPageSize             = 0;
    private int    intPageNo               = 0;
    private string strCenterCode           = string.Empty;
    private string strDateType             = string.Empty;
    private string strDateFrom             = string.Empty;
    private string strDateTo               = string.Empty;
    private string strOrderLocationCodes   = string.Empty;
    private string strOrderItemCodes       = string.Empty;
    private string strSearchClientType     = string.Empty;
    private string strSearchClientText     = string.Empty;
    private string strOrderNos             = string.Empty;
    private string strOrderNo              = string.Empty;
    private string strPayType              = string.Empty;
    private string strOrderClientName      = string.Empty;
    private string strPayClientCode        = string.Empty;
    private string strPayClientName        = string.Empty;
    private string strConsignorName        = string.Empty;
    private string strCsAdminID            = string.Empty;
    private string strCsAdminName          = string.Empty;
    private string strPayClientChargeNames = string.Empty;
    private string strOrderItemCodeM       = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPayItemCodeList,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutUpsList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutUpsExcelList, MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("InoutUpsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("InoutUpsHandler");
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
            strCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType             = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom             = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo               = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes   = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes       = SiteGlobal.GetRequestForm("OrderItemCodes");
            strSearchClientType     = Utils.IsNull(SiteGlobal.GetRequestForm("SearchClientType"), "0");
            strSearchClientText     = SiteGlobal.GetRequestForm("SearchClientText");
            strOrderNos             = SiteGlobal.GetRequestForm("OrderNos");
            strOrderNo              = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "0");
            strPayType              = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"), "1");
            strOrderClientName      = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientCode        = SiteGlobal.GetRequestForm("PayClientCode");
            strPayClientName        = SiteGlobal.GetRequestForm("PayClientName");
            strConsignorName        = SiteGlobal.GetRequestForm("ConsignorName");
            strCsAdminID            = SiteGlobal.GetRequestForm("CsAdminID");
            strCsAdminName          = SiteGlobal.GetRequestForm("CsAdminName");
            strPayClientChargeNames = SiteGlobal.GetRequestForm("PayClientChargeNames");
            strOrderItemCodeM       = SiteGlobal.GetRequestForm("OrderItemCodeM");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", string.Empty);
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", string.Empty);

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutUpsHandler", "Exception",
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
                case MethodInoutUpsList:
                    GetInoutUpsList();
                    break;
                case MethodInoutUpsExcelList:
                    GetInoutUpsExcelList();
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

            SiteGlobal.WriteLog("InoutUpsHandler", "Exception",
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

            SiteGlobal.WriteLog("InoutUpsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 비용내역서
    /// </summary>
    protected void GetInoutUpsList()
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

        try
        {

            lo_objReqOrderPayStatementPayItemList = new ReqOrderPayStatementPayItemList
            {
                CenterCode         = strCenterCode.ToInt(),
                OrderNos           = strOrderNos,
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
                PayClientCode      = strPayClientCode.ToInt64(),
                AccessCenterCode   = objSes.AccessCenterCode
            };
                
            lo_objResOrderPayStatementPayItemList = objOrderDasServices.GetOrderClientStatementPayItemList(lo_objReqOrderPayStatementPayItemList);

            lo_objReqOrderPayStatementList = new ReqOrderPayStatementList
            {
                CenterCode          = strCenterCode.ToInt(),
                OrderNo             = strOrderNo.ToInt64(),
                ListType            = lo_intListType,
                DateType            = strDateType.ToInt(),
                DateFrom            = strDateFrom,
                DateTo              = strDateTo,
                OrderLocationCodes  = strOrderLocationCodes,
                OrderItemCodes      = strOrderItemCodes,
                OrderClientName     = strOrderClientName,
                PayClientName       = strPayClientName,
                ConsignorName       = strConsignorName,
                PayType             = strPayType.ToInt(),
                PayClientCode       = strPayClientCode.ToInt64(),
                AccessCenterCode    = objSes.AccessCenterCode
            };
                
            lo_objResOrderPayStatementList = objOrderDasServices.GetOrderClientStatementList(lo_objReqOrderPayStatementList, lo_objResOrderPayStatementPayItemList.data.RecordCnt > 0 ? lo_objResOrderPayStatementPayItemList.data.list : null, 1);
            objResMap.strResponse          = "[" + JsonConvert.SerializeObject(lo_objResOrderPayStatementList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutUpsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetInoutUpsExcelList()
    {
        SpreadSheet                             lo_objExcel                    = null;
        MemoryStream                            lo_outputStream                = null;
        DataTable                               lo_dtData                      = null;
        DataTable                               lo_dtDataInfo                  = null;
        ReqOrderPayStatementList                lo_objReqOrderPayStatementList = null;
        ServiceResult<ResOrderPayStatementList> lo_objResOrderPayStatementList = null;
        string                                  lo_strFileName                 = string.Empty;
        byte[]                                  lo_Content                     = null;
        string[]                                lo_strArrPayClientChargeName   = strPayClientChargeNames.Split(',');
        int                                     lo_intListType                 = 2;
        int                                     lo_intColumnIndex              = 0;
        string                                  lo_strTotalSupplyAmt           = string.Empty;
        string                                  lo_strTotalArrivalSupplyAmt    = string.Empty;
        string                                  lo_strTotalTaxAmt              = string.Empty;
        string                                  lo_strTotalOrgAmt              = string.Empty;

        try
        {
            lo_dtData     = new DataTable();
            lo_dtDataInfo = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("UPS 담당자", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("거래일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지역",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지역",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총 수량",    typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총 부피",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총 중량",    typeof(double)));

            lo_dtData.Columns.Add(new DataColumn("H/AWB NO", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("운임",       typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("도착보고료",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("비고",       typeof(string)));

            lo_dtDataInfo.Columns.Add(new DataColumn("거래명세서(" + strOrderItemCodeM + ")", typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty,                       typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty,                       typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty,                       typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty,                       typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty,                       typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty,                       typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty,                       typeof(int)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty,                       typeof(double)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty,                       typeof(double)));

            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(double)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(double)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));

            if (lo_strArrPayClientChargeName.Length > 0)
            {
                for (var i = 0; i < lo_strArrPayClientChargeName.Length; i++)
                {
                    lo_intColumnIndex           = 0;

                    lo_dtDataInfo.Rows.Clear();
                    lo_dtData.Rows.Clear();
                        
                    if (lo_objExcel == null)
                    {
                        lo_objExcel = new SpreadSheet { SheetName = lo_strArrPayClientChargeName[0] };
                    }
                    else
                    {
                        lo_objExcel.AddWorkSheet(lo_strArrPayClientChargeName[i]);
                    }

                    lo_objReqOrderPayStatementList = new ReqOrderPayStatementList
                    {
                        CenterCode          = strCenterCode.ToInt(),
                        OrderNos            = strOrderNos,
                        ListType            = lo_intListType,
                        DateType            = strDateType.ToInt(),
                        DateFrom            = strDateFrom,
                        DateTo              = strDateTo,
                        OrderLocationCodes  = strOrderLocationCodes,
                        OrderItemCodes      = strOrderItemCodes,
                        OrderClientName     = strOrderClientName,
                        PayClientName       = strPayClientName,
                        ConsignorName       = strConsignorName,
                        PayType             = strPayType.ToInt(),
                        PayClientChargeName = lo_strArrPayClientChargeName[i],
                        AccessCenterCode    = objSes.AccessCenterCode
                    };

                    lo_objResOrderPayStatementList = objOrderDasServices.GetOrderClientStatementList(lo_objReqOrderPayStatementList, null, 1);
                    lo_strTotalSupplyAmt           = lo_objResOrderPayStatementList.data.TotalSupplyAmt.ToString("##,###");
                    lo_strTotalArrivalSupplyAmt    = lo_objResOrderPayStatementList.data.TotalArrivalSupplyAmt.ToString("##,###");
                    lo_strTotalTaxAmt              = lo_objResOrderPayStatementList.data.TotalTaxAmt.ToString("##,###");
                    lo_strTotalOrgAmt              = lo_objResOrderPayStatementList.data.TotalOrgAmt.ToString("##,###");

                    lo_strTotalSupplyAmt        = string.IsNullOrWhiteSpace(lo_strTotalSupplyAmt) ? "0" : lo_strTotalSupplyAmt;
                    lo_strTotalArrivalSupplyAmt = string.IsNullOrWhiteSpace(lo_strTotalArrivalSupplyAmt) ? "0" : lo_strTotalArrivalSupplyAmt;
                    lo_strTotalTaxAmt           = string.IsNullOrWhiteSpace(lo_strTotalTaxAmt) ? "0" : lo_strTotalTaxAmt;
                    lo_strTotalOrgAmt           = string.IsNullOrWhiteSpace(lo_strTotalOrgAmt) ? "0" : lo_strTotalOrgAmt;

                    foreach (var row in lo_objResOrderPayStatementList.data.list)
                    {
                        lo_dtData.Rows.Add(row.PayClientChargeName, Utils.DateFormatter(row.PickupYMD, "yyyymmdd", "yyyy-mm-dd", row.PickupYMD), row.OrderItemCodeM,row.ConsignorName,row.PickupPlaceFullAddr
                                          ,row.GetPlace, row.GetPlaceFullAddr, row.Volume, row.CBM, row.Weight
                                          ,row.Hawb, row.TotalSupplyAmt, row.ArrivalSupplyAmt, row.Mawb);

                    }
                    
                    lo_dtDataInfo.Rows.Add("청구처 : 유피에스에스씨에스코리아", "", "", "", "", "", $"DATE : {Utils.DateFormatter(strDateFrom, "yyyymmdd", "yyyy-mm-dd", strDateFrom)} ~ {Utils.DateFormatter(strDateTo, "yyyymmdd", "yyyy-mm-dd", strDateTo)}");
                    lo_dtDataInfo.Rows.Add("운 임",                             "", "", "", "", "", lo_strTotalSupplyAmt);
                    lo_dtDataInfo.Rows.Add("도 착 보 고 료",                    "", "", "", "", "", lo_strTotalArrivalSupplyAmt);
                    lo_dtDataInfo.Rows.Add("부 가 세",                          "", "", "", "", "", lo_strTotalTaxAmt);
                    lo_dtDataInfo.Rows.Add("합 계",                             "", "", "", "", "", lo_strTotalOrgAmt);
                    
                    lo_objExcel.FreezeCell(1);
                    lo_objExcel.MergeColumn(1, 1, 1, 14);

                    lo_objExcel.MergeColumn(2, 1, 2,  6);
                    lo_objExcel.MergeColumn(2, 7, 2,  14);

                    lo_objExcel.MergeColumn(3, 1, 3,  6);
                    lo_objExcel.MergeColumn(3, 7, 3,  14);

                    lo_objExcel.MergeColumn(4, 1, 4, 6);
                    lo_objExcel.MergeColumn(4, 7, 4, 14);

                    lo_objExcel.MergeColumn(5, 1, 5, 6);
                    lo_objExcel.MergeColumn(5, 7, 5, 14);

                    lo_objExcel.MergeColumn(6, 1, 6,  6);
                    lo_objExcel.MergeColumn(6, 7, 6,  14);

                    lo_objExcel.InsertDataTable(lo_dtDataInfo, true, 1, 1, true, true, System.Drawing.Color.AliceBlue, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
                    lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

                    lo_objExcel.InsertDataTable(lo_dtData, true, 8, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
                    lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty, HorizontalAlignmentValues.Left);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty, HorizontalAlignmentValues.Left);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty, HorizontalAlignmentValues.Left);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty, HorizontalAlignmentValues.Left);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty, HorizontalAlignmentValues.Left);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty, HorizontalAlignmentValues.Left);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty, HorizontalAlignmentValues.Left);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0",      HorizontalAlignmentValues.Right);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##",   HorizontalAlignmentValues.Right);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##",   HorizontalAlignmentValues.Right);

                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty, HorizontalAlignmentValues.Left);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0",      HorizontalAlignmentValues.Right);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0",      HorizontalAlignmentValues.Right);
                    lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty, HorizontalAlignmentValues.Left);

                    lo_objExcel.SetFontSize(10, 18);
                    lo_objExcel.SetAutoFitRow(lo_strArrPayClientChargeName[i]);
                    lo_objExcel.SetAutoFitColumn(lo_strArrPayClientChargeName[i]);
                }
            }

            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);

            lo_Content = lo_outputStream.ToArray();

            lo_strFileName = $"UPS수출입내역서_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + lo_strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9203;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutUpsHandler", "Exception",
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