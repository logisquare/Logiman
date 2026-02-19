<%@ WebHandler Language="C#" Class="MisStatHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Data;
using System.IO;
using DocumentFormat.OpenXml.Spreadsheet;

///================================================================
/// <summary>
/// FileName        : MisStatHandler.ashx
/// Description     : 경영정보시스템
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-12-26
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class MisStatHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/MIS/IntegrationChart"; //필수

    // 메소드 리스트
    private const string MethodIntegrationChartMonthlyList      = "IntegrationChartMonthlyList";
    private const string MethodIntegrationChartMonthlyExcelList = "IntegrationChartMonthlyExcelList";
    private const string MethodIntegrationChartDailyList        = "IntegrationChartDailyList";
    private const string MethodIntegrationChartDailyExcelList   = "IntegrationChartDailyExcelList";
    private const string MethodStatOrderClientMonthlyList       = "StatOrderClientMonthlyList";
    private const string MethodStatOrderClientDailyList         = "StatOrderClientDailyList";
    private const string MethodStatOrderAgentMonthlyList        = "StatOrderAgentMonthlyList";
    private const string MethodStatOrderAgentDailyList          = "StatOrderAgentDailyList";
    private const string MethodMonthList                        = "MonthList"; //월 목록 + 워킹데이
    private const string MethodDailyList                        = "DailyList"; //월 목록 + 워킹데이

    MisStatDasServices     objMisStatDasServices = new MisStatDasServices();

    private   string       strCallType           = string.Empty;

    private   string       strCenterCode       = string.Empty;
    private   string       strClientCode       = string.Empty;
    private   string       strSearchYMD        = string.Empty;
    private   string       strOrderItemCodes   = string.Empty;
    private   string       strClientName       = string.Empty;
    private   string       strAgentCode        = string.Empty;
    private   string       strAgentName        = string.Empty;
    private   string       strAccessCenterCode = string.Empty;
    private   string       strDateType         = string.Empty;
    private   string       strDateFrom         = string.Empty;
    private   string       strDateTo           = string.Empty;
    protected List<String> ListSeriesData      = new List<String>();

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodIntegrationChartMonthlyList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodIntegrationChartMonthlyExcelList,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodIntegrationChartDailyList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodIntegrationChartDailyExcelList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatOrderClientMonthlyList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatOrderClientDailyList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatOrderAgentMonthlyList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatOrderAgentDailyList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodMonthList,                          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDailyList,                          MenuAuthType.ReadOnly);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType  = SiteGlobal.GetRequestForm("CallType");

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

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("MisStatHandler");
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
            strClientCode       = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strSearchYMD        = Utils.IsNull(SiteGlobal.GetRequestForm("SearchYMD"), "");
            strOrderItemCodes   = Utils.IsNull(SiteGlobal.GetRequestForm("OrderItemCodes"), "");
            strClientName       = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");
            strAgentCode        = Utils.IsNull(SiteGlobal.GetRequestForm("AgentCode"), "");
            strAgentName        = Utils.IsNull(SiteGlobal.GetRequestForm("AgentName"), "");
            strAccessCenterCode = Utils.IsNull(SiteGlobal.GetRequestForm("AccessCenterCode"), "");
            strDateType         = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "");
            strDateFrom         = Utils.IsNull(SiteGlobal.GetRequestForm("DateFrom"), "");
            strDateTo           = Utils.IsNull(SiteGlobal.GetRequestForm("DateTo"), "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
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
                case MethodIntegrationChartMonthlyList:
                    GetIntegrationChartMonthlyList();
                    break;
                case MethodIntegrationChartMonthlyExcelList:
                    GetIntegrationChartMonthlyExcelList();
                    break;
                case MethodIntegrationChartDailyList:
                    GetIntegrationChartDailyList();
                    break;
                case MethodIntegrationChartDailyExcelList:
                    GetIntegrationChartDailyExcelList();
                    break;
                case MethodMonthList:
                    GetMonthList();
                    break;
                case MethodStatOrderClientMonthlyList:
                    GetClientMonthlyList();
                    break;
                case MethodStatOrderClientDailyList:
                    GetClientDailyList();
                    break;
                case MethodStatOrderAgentMonthlyList:
                    GetAgentMonthlyList();
                    break;
                case MethodStatOrderAgentDailyList:
                    GetAgentDailyList();
                    break;
                case MethodDailyList:
                    GetDailyList();
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

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 전체 (월별)
    /// </summary>
    protected void GetIntegrationChartMonthlyList()
    {
        ReqStatOrderList                      lo_objReqStatOrderList = null;
        ServiceResult<ResStatOrderList>       lo_objResStatOrderList = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SearchYMD        = strSearchYMD,
                OrderItemCodes   = strOrderItemCodes,
                ClientName       = strClientName,
                AgentName        = strAgentName,
                AccessCenterCode = strAccessCenterCode
            };

            lo_objResStatOrderList = objMisStatDasServices.GetStatOrderTotalMonthList(lo_objReqStatOrderList);

            //현재 처리 중인 기준 년/월 보관
            string           currentYYMM     = string.Empty;
            ResStatOrderList currentYYMMData = null;

            foreach (StatOrderGridModel item in lo_objResStatOrderList.data.data ) {
                //현재 처리 중인 년도와 다른 년도가 들어오면, 처리된 data 
                if ((!currentYYMM.Equals(item.YY) && strDateType.Equals("M")) ||
                     (!currentYYMM.Equals(item.MM) && strDateType.Equals("D")))
                {
                    //저장된 data가 있으면 해당 값을 json string으로 deserialize 시켜서 client에서 사용할 변수에 추가
                    if (currentYYMMData != null && currentYYMMData.data.Count > 0)
                    {
                        ListSeriesData.Add(JsonConvert.SerializeObject(currentYYMMData));
                    }

                    //신규 년/월 처리를 위한 초기화
                    currentYYMMData = null;
                    if (strDateType.Equals("M"))
                    {
                        currentYYMM     = item.YY;
                        currentYYMMData = new ResStatOrderList(item.YY + "년");
                    }
                    else
                    {
                        currentYYMM     = item.MM;
                        currentYYMMData = new ResStatOrderList(item.MM + "월");
                    }
                }

                currentYYMMData.data.Add(item);
            }

            if (currentYYMMData != null && currentYYMMData.data.Count > 0)
            {
                ListSeriesData.Add(JsonConvert.SerializeObject(currentYYMMData));
            }
            objResMap.strResponse = JsonConvert.SerializeObject(ListSeriesData);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 전체 (월별) 엑셀 다운로드
    /// </summary>
    protected void GetIntegrationChartMonthlyExcelList()
    {
        ReqStatOrderList                lo_objReqStatOrderList = null;
        ServiceResult<ResStatOrderList> lo_objResStatOrderList = null;

        string       lo_strFileName    = "";
        SpreadSheet  lo_objExcel       = null;
        DataTable    lo_dtData         = null;
        MemoryStream lo_outputStream   = null;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SearchYMD        = strSearchYMD,
                OrderItemCodes   = strOrderItemCodes,
                ClientName       = strClientName,
                AgentName        = strAgentName,
                AccessCenterCode = strAccessCenterCode
            };

            lo_objResStatOrderList    = objMisStatDasServices.GetStatOrderTotalMonthList(lo_objReqStatOrderList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("년", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("월", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("날짜", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("건수", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("매출", typeof(Int64)));

            lo_dtData.Columns.Add(new DataColumn("매입", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("매입배분(월대차량)", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("빠른입금 수수료", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("수익", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("수익률", typeof(Double)));

            lo_dtData.Columns.Add(new DataColumn("누적 건수", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 매출", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 매입", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 매입배분(월대차량)", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 빠른입금 수수료", typeof(Int64)));

            lo_dtData.Columns.Add(new DataColumn("누적 수익", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 수익률", typeof(Double)));

            foreach (var row in lo_objResStatOrderList.data.data)
            {
                lo_dtData.Rows.Add(row.YY, row.MM, row.target_date, row.order_count, row.sales_amount
                                  ,row.purchase_amount, row.monthly_purchase_amount, row.centerfee_amount, row.profit_amount, row.return_on_sales.ToDouble()
                                  ,row.order_count_cumulative, row.sales_amount_cumulative, row.purchase_amount_cumulative, row.monthly_purchase_amount_cumulative, row.centerfee_amount_cumulative
                                  ,row.profit_amount_cumulative, row.return_on_sales_cumulative.ToDouble());
            }

            lo_objExcel = new SpreadSheet {SheetName = "MonthlyChartData"};

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
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.0");

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
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 전체 (일별)
    /// </summary>
    protected void GetIntegrationChartDailyList()
    {
        ReqStatOrderList                lo_objReqStatOrderList = null;
        ServiceResult<ResStatOrderList> lo_objResStatOrderList = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SearchYMD        = strSearchYMD,
                OrderItemCodes   = strOrderItemCodes,
                ClientName       = strClientName,
                AgentName        = strAgentName,
                AccessCenterCode = strAccessCenterCode
            };

            lo_objResStatOrderList = objMisStatDasServices.GetStatOrderTotalDailyList(lo_objReqStatOrderList);

            //현재 처리 중인 기준 년/월 보관
            string           currentYYMM     = string.Empty;
            ResStatOrderList currentYYMMData = null;

            foreach (StatOrderGridModel item in lo_objResStatOrderList.data.data ) {
                //현재 처리 중인 년도와 다른 년도가 들어오면, 처리된 data 
                if ((!currentYYMM.Equals(item.YY) && strDateType.Equals("M")) ||
                     (!currentYYMM.Equals(item.MM) && strDateType.Equals("D")))
                {
                    //저장된 data가 있으면 해당 값을 json string으로 deserialize 시켜서 client에서 사용할 변수에 추가
                    if (currentYYMMData != null && currentYYMMData.data.Count > 0)
                    {
                        ListSeriesData.Add(JsonConvert.SerializeObject(currentYYMMData));
                    }

                    //신규 년/월 처리를 위한 초기화
                    currentYYMMData = null;
                    if (strDateType.Equals("M"))
                    {
                        currentYYMM     = item.YY;
                        currentYYMMData = new ResStatOrderList(item.YY + "년");
                    }
                    else
                    {
                        currentYYMM     = item.MM;
                        currentYYMMData = new ResStatOrderList(item.MM + "월");
                    }
                }

                currentYYMMData.data.Add(item);
            }

            if (currentYYMMData != null && currentYYMMData.data.Count > 0)
            {
                ListSeriesData.Add(JsonConvert.SerializeObject(currentYYMMData));
            }
            objResMap.strResponse = JsonConvert.SerializeObject(ListSeriesData);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 전체 (일별) 엑셀 다운로드
    /// </summary>
    protected void GetIntegrationChartDailyExcelList()
    {
        ReqStatOrderList                lo_objReqStatOrderList = null;
        ServiceResult<ResStatOrderList> lo_objResStatOrderList = null;

        string       lo_strFileName    = "";
        SpreadSheet  lo_objExcel       = null;
        DataTable    lo_dtData         = null;
        MemoryStream lo_outputStream   = null;
        byte[]       lo_Content        = null;
        int          lo_intColumnIndex = 0;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SearchYMD        = strSearchYMD,
                OrderItemCodes   = strOrderItemCodes,
                ClientName       = strClientName,
                AgentName        = strAgentName,
                AccessCenterCode = strAccessCenterCode
            };

            lo_objResStatOrderList    = objMisStatDasServices.GetStatOrderTotalDailyList(lo_objReqStatOrderList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("년", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("월", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("날짜", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("건수", typeof(Int64)));

            lo_dtData.Columns.Add(new DataColumn("매출", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("매입", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("매입배분(월대차량)", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("빠른입금 수수료", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("수익", typeof(Int64)));

            lo_dtData.Columns.Add(new DataColumn("수익률", typeof(Double)));
            lo_dtData.Columns.Add(new DataColumn("누적 건수", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 매출", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 매입", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 매입배분(월대차량)", typeof(Int64)));

            lo_dtData.Columns.Add(new DataColumn("누적 빠른입금 수수료", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 수익", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("누적 수익률", typeof(Double)));

            foreach (var row in lo_objResStatOrderList.data.data)
            {
                lo_dtData.Rows.Add(row.YY, row.MM, row.DD, row.target_date, row.order_count
                                  ,row.sales_amount, row.purchase_amount, row.monthly_purchase_amount, row.centerfee_amount, row.profit_amount
                                  ,row.return_on_sales.ToDouble(), row.order_count_cumulative, row.sales_amount_cumulative, row.purchase_amount_cumulative, row.monthly_purchase_amount_cumulative
                                  ,row.centerfee_amount_cumulative, row.profit_amount_cumulative, row.return_on_sales_cumulative.ToDouble());
            }

            lo_objExcel = new SpreadSheet {SheetName = "DailyChartData"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.0");

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
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 (월별)
    /// </summary>
    protected void GetClientMonthlyList()
    {
        ReqStatOrderList                      lo_objReqStatOrderList     = null;
        ServiceResult<ResponseClientGrouping> lo_objResultClientGrouping = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SearchYMD        = strSearchYMD,
                ClientCode       = strClientCode.ToInt64(),
                OrderItemCodes   = strOrderItemCodes,
                ClientName       = strClientName,
                AgentName        = strAgentName,
                AccessCenterCode = strAccessCenterCode
            };

            lo_objResultClientGrouping = objMisStatDasServices.GetStatOrderClientMonthlyList(lo_objReqStatOrderList);

            long lo_intCurrentClientCode = 0;

            if (lo_objResultClientGrouping != null && lo_objResultClientGrouping.data != null) {
                ChartStruct  chartStruct  = new ChartStruct();
                ChartItem    chartItem    = null;
                ChartData    chartData    = null;
                ChartSubData chartSubData = null;

                foreach (ResultDataClientGrouping item in lo_objResultClientGrouping.data.data)
                {
                    //현재 처리 중인 고객사와 다른 고객사가 들어오면, 처리된 data 저장한 후 비교 값 초기화 
                    if (!lo_intCurrentClientCode.Equals(item.client_code))
                    {
                        if (chartItem != null)
                        {
                            chartData.ItemValues = chartSubData;
                            chartItem.ItemData   = chartData;
                            chartStruct.ChartItems.Add(chartItem);
                        }

                        //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                        chartItem    = new ChartItem("_"+item.client_code);
                        chartData    = new ChartData(item.client_name, item.order_count_cumulative, item.profit_amount_cumulative, item.return_on_sales_cumulative, item.sales_amount_cumulative, item.purchase_amount_cumulative, item.monthly_purchase_amount_cumulative, item.centerfee_amount_cumulative);
                        chartSubData = new ChartSubData();
                    }

                    chartData.TickValues.Add(item.YY + "-" + item.MM);
                    chartSubData.OrderCount.Add(item.order_count);
                    chartSubData.OrderCountSum.Add(item.order_count_cumulative);
                    chartSubData.ProfitAmount.Add(item.profit_amount);
                    chartSubData.ProfitAmountSum.Add(item.profit_amount_cumulative);
                    chartSubData.ReturnOnSales.Add(item.return_on_sales);
                    chartSubData.ReturnOnSalesSum.Add(item.return_on_sales_cumulative);
                    chartSubData.SalesAmount.Add(item.sales_amount);
                    chartSubData.SalesAmountSum.Add(item.sales_amount_cumulative);
                    chartSubData.PurchaseAmount.Add(item.purchase_amount);
                    chartSubData.PurchaseAmountSum.Add(item.purchase_amount_cumulative);
                    chartSubData.MonthlyPurchaseAmount.Add(item.monthly_purchase_amount);
                    chartSubData.MonthlyPurchaseAmountSum.Add(item.monthly_purchase_amount_cumulative);
                    chartSubData.CenterFeeAmount.Add(item.centerfee_amount);
                    chartSubData.CenterFeeAmountSum.Add(item.centerfee_amount_cumulative);

                    lo_intCurrentClientCode = item.client_code;
                } //end foreach

                //최종 data에 추가되지 않은 마지막 레코드 입력
                if (chartItem != null && chartSubData.OrderCount != null && chartSubData.OrderCount.Count > 0)
                {
                    chartData.ItemValues = chartSubData;
                    chartItem.ItemData   = chartData;
                    chartStruct.ChartItems.Add(chartItem);
                }

                objResMap.strResponse = JsonConvert.SerializeObject(chartStruct);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 현황 - 고객사 (일별)
    /// </summary>
    protected void GetClientDailyList()
    {
        ReqStatOrderList                      lo_objReqStatOrderList     = null;
        ServiceResult<ResponseClientGrouping> lo_objResultClientGrouping = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SearchYMD        = strSearchYMD,
                OrderItemCodes   = strOrderItemCodes,
                ClientName       = strClientName,
                AgentName        = strAgentName,
                AccessCenterCode = strAccessCenterCode
            };

            lo_objResultClientGrouping = objMisStatDasServices.GetStatOrderClientDailyList(lo_objReqStatOrderList);

            long lo_intCurrentClientCode = 0;

            if (lo_objResultClientGrouping != null && lo_objResultClientGrouping.data != null) {
                ChartStruct  chartStruct  = new ChartStruct();
                ChartItem    chartItem    = null;
                ChartData    chartData    = null;
                ChartSubData chartSubData = null;

                foreach (ResultDataClientGrouping item in lo_objResultClientGrouping.data.data)
                {
                    //현재 처리 중인 고객사와 다른 고객사가 들어오면, 처리된 data 저장한 후 비교 값 초기화 
                    if (!lo_intCurrentClientCode.Equals(item.client_code))
                    {
                        if (chartItem != null)
                        {
                            chartData.ItemValues = chartSubData;
                            chartItem.ItemData   = chartData;
                            chartStruct.ChartItems.Add(chartItem);
                        }

                        //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                        chartItem    = new ChartItem("_"+item.client_code.ToString());
                        chartData    = new ChartData(item.client_name, item.order_count_cumulative, item.profit_amount_cumulative, item.return_on_sales_cumulative, item.sales_amount_cumulative, item.purchase_amount_cumulative, item.monthly_purchase_amount_cumulative, item.centerfee_amount_cumulative);
                        chartSubData = new ChartSubData();
                    }

                    chartData.TickValues.Add(item.YY + "-" + item.MM + "-" + item.DD);
                    chartSubData.OrderCount.Add(item.order_count);
                    chartSubData.OrderCountSum.Add(item.order_count_cumulative);
                    chartSubData.ProfitAmount.Add(item.profit_amount);
                    chartSubData.ProfitAmountSum.Add(item.profit_amount_cumulative);
                    chartSubData.ReturnOnSales.Add(item.return_on_sales);
                    chartSubData.ReturnOnSalesSum.Add(item.return_on_sales_cumulative);
                    chartSubData.SalesAmount.Add(item.sales_amount);
                    chartSubData.SalesAmountSum.Add(item.sales_amount_cumulative);
                    chartSubData.PurchaseAmount.Add(item.purchase_amount);
                    chartSubData.PurchaseAmountSum.Add(item.purchase_amount_cumulative);
                    chartSubData.MonthlyPurchaseAmount.Add(item.monthly_purchase_amount);
                    chartSubData.MonthlyPurchaseAmountSum.Add(item.monthly_purchase_amount_cumulative);
                    chartSubData.CenterFeeAmount.Add(item.centerfee_amount);
                    chartSubData.CenterFeeAmountSum.Add(item.centerfee_amount_cumulative);

                    lo_intCurrentClientCode = item.client_code;
                } //end foreach

                //최종 data에 추가되지 않은 마지막 레코드 입력
                if (chartItem != null && chartSubData.OrderCount != null && chartSubData.OrderCount.Count > 0)
                {
                    chartData.ItemValues = chartSubData;
                    chartItem.ItemData   = chartData;
                    chartStruct.ChartItems.Add(chartItem);
                }

                objResMap.strResponse = JsonConvert.SerializeObject(chartStruct);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 담당자 (월별)
    /// </summary>
    protected void GetAgentMonthlyList()
    {
        ReqStatOrderList                     lo_objReqStatOrderList    = null;
        ServiceResult<ResponseAgentGrouping> lo_objResultAgentGrouping = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SearchYMD        = strSearchYMD,
                OrderItemCodes   = strOrderItemCodes,
                AgentCode        = strAgentCode,
                AgentName        = strAgentName,
                AccessCenterCode = strAccessCenterCode
            };

            lo_objResultAgentGrouping = objMisStatDasServices.GetStatOrderAgentMonthlyList(lo_objReqStatOrderList);

            string lo_strAgentCode = "";

            if (lo_objResultAgentGrouping != null && lo_objResultAgentGrouping.data != null) {
                ChartStruct  chartStruct  = new ChartStruct();
                ChartItem    chartItem    = null;
                ChartData    chartData    = null;
                ChartSubData chartSubData = null;

                foreach (ResultDataAgentGrouping item in lo_objResultAgentGrouping.data.data)
                {
                    //현재 처리 중인 고객사와 다른 고객사가 들어오면, 처리된 data 저장한 후 비교 값 초기화 
                    if (!lo_strAgentCode.Equals(item.agent_code))
                    {
                        if (chartItem != null)
                        {
                            chartData.ItemValues = chartSubData;
                            chartItem.ItemData   = chartData;
                            chartStruct.ChartItems.Add(chartItem);
                        }

                        //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                        chartItem    = new ChartItem("_"+item.agent_code);
                        chartData    = new ChartData(item.agent_name, item.order_count_cumulative, item.profit_amount_cumulative, item.return_on_sales_cumulative, item.sales_amount_cumulative, item.purchase_amount_cumulative, item.monthly_purchase_amount_cumulative, item.centerfee_amount_cumulative);
                        chartSubData = new ChartSubData();
                    }

                    chartData.TickValues.Add(item.YY + "-" + item.MM);
                    chartSubData.OrderCount.Add(item.order_count);
                    chartSubData.OrderCountSum.Add(item.order_count_cumulative);
                    chartSubData.ProfitAmount.Add(item.profit_amount);
                    chartSubData.ProfitAmountSum.Add(item.profit_amount_cumulative);
                    chartSubData.ReturnOnSales.Add(item.return_on_sales);
                    chartSubData.ReturnOnSalesSum.Add(item.return_on_sales_cumulative);
                    chartSubData.SalesAmount.Add(item.sales_amount);
                    chartSubData.SalesAmountSum.Add(item.sales_amount_cumulative);
                    chartSubData.PurchaseAmount.Add(item.purchase_amount);
                    chartSubData.PurchaseAmountSum.Add(item.purchase_amount_cumulative);
                    chartSubData.MonthlyPurchaseAmount.Add(item.monthly_purchase_amount);
                    chartSubData.MonthlyPurchaseAmountSum.Add(item.monthly_purchase_amount_cumulative);
                    chartSubData.CenterFeeAmount.Add(item.centerfee_amount);
                    chartSubData.CenterFeeAmountSum.Add(item.centerfee_amount_cumulative);

                    lo_strAgentCode = item.agent_code;
                } //end foreach

                //최종 data에 추가되지 않은 마지막 레코드 입력
                if (chartItem != null && chartSubData.OrderCount != null && chartSubData.OrderCount.Count > 0)
                {
                    chartData.ItemValues = chartSubData;
                    chartItem.ItemData   = chartData;
                    chartStruct.ChartItems.Add(chartItem);
                }

                objResMap.strResponse = JsonConvert.SerializeObject(chartStruct);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9409;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 담당자 (일별)
    /// </summary>
    protected void GetAgentDailyList()
    {
        ReqStatOrderList                     lo_objReqStatOrderList     = null;
        ServiceResult<ResponseAgentGrouping> lo_objResultAgentGrouping = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                SearchYMD        = strSearchYMD,
                OrderItemCodes   = strOrderItemCodes,
                AgentCode        = strAgentCode,
                AgentName        = strAgentName,
                AccessCenterCode = strAccessCenterCode
            };

            lo_objResultAgentGrouping = objMisStatDasServices.GetStatOrderAgentDailyList(lo_objReqStatOrderList);

            string lo_strAgentCode = "";

            if (lo_objResultAgentGrouping != null && lo_objResultAgentGrouping.data != null) {
                ChartStruct  chartStruct  = new ChartStruct();
                ChartItem    chartItem    = null;
                ChartData    chartData    = null;
                ChartSubData chartSubData = null;

                foreach (ResultDataAgentGrouping item in lo_objResultAgentGrouping.data.data)
                {
                    //현재 처리 중인 고객사와 다른 고객사가 들어오면, 처리된 data 저장한 후 비교 값 초기화 
                    if (!lo_strAgentCode.Equals(item.agent_code))
                    {
                        if (chartItem != null)
                        {
                            chartData.ItemValues = chartSubData;
                            chartItem.ItemData   = chartData;
                            chartStruct.ChartItems.Add(chartItem);
                        }

                        //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                        chartItem    = new ChartItem("_"+item.agent_code);
                        chartData    = new ChartData(item.agent_name, item.order_count_cumulative, item.profit_amount_cumulative, item.return_on_sales_cumulative, item.sales_amount_cumulative, item.purchase_amount_cumulative, item.monthly_purchase_amount_cumulative, item.centerfee_amount_cumulative);
                        chartSubData = new ChartSubData();
                    }

                    chartData.TickValues.Add(item.YY + "-" + item.MM + "-" + item.DD);
                    chartSubData.OrderCount.Add(item.order_count);
                    chartSubData.OrderCountSum.Add(item.order_count_cumulative);
                    chartSubData.ProfitAmount.Add(item.profit_amount);
                    chartSubData.ProfitAmountSum.Add(item.profit_amount_cumulative);
                    chartSubData.ReturnOnSales.Add(item.return_on_sales);
                    chartSubData.ReturnOnSalesSum.Add(item.return_on_sales_cumulative);
                    chartSubData.SalesAmount.Add(item.sales_amount);
                    chartSubData.SalesAmountSum.Add(item.sales_amount_cumulative);
                    chartSubData.PurchaseAmount.Add(item.purchase_amount);
                    chartSubData.PurchaseAmountSum.Add(item.purchase_amount_cumulative);
                    chartSubData.MonthlyPurchaseAmount.Add(item.monthly_purchase_amount);
                    chartSubData.MonthlyPurchaseAmountSum.Add(item.monthly_purchase_amount_cumulative);
                    chartSubData.CenterFeeAmount.Add(item.centerfee_amount);
                    chartSubData.CenterFeeAmountSum.Add(item.centerfee_amount_cumulative);

                    lo_strAgentCode = item.agent_code;
                } //end foreach

                //최종 data에 추가되지 않은 마지막 레코드 입력
                if (chartItem != null && chartSubData.OrderCount != null && chartSubData.OrderCount.Count > 0)
                {
                    chartData.ItemValues = chartSubData;
                    chartItem.ItemData   = chartData;
                    chartStruct.ChartItems.Add(chartItem);
                }

                objResMap.strResponse = JsonConvert.SerializeObject(chartStruct);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9410;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 월별 리스트
    /// </summary>
    protected void GetMonthList()
    {
        ReqMonthList                lo_objReqMonthList = null;
        ServiceResult<ResMonthList> lo_objResMonthList = null;

        try
        {
            lo_objReqMonthList = new ReqMonthList
            {
                DateFrom = strDateFrom + "01",
                DateTo   = strDateTo + "12"
            };

            lo_objResMonthList    = objMisStatDasServices.GetMonthList(lo_objReqMonthList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResMonthList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 일별 리스트
    /// </summary>
    protected void GetDailyList()
    {
        ReqMonthList                lo_objReqMonthList = null;
        ServiceResult<ResMonthList> lo_objResMonthList = null;

        try
        {
            lo_objReqMonthList = new ReqMonthList
            {
                DateFrom = strDateFrom + "01",
                DateTo   = strDateTo + "31"
            };

            lo_objResMonthList    = objMisStatDasServices.GetDailyList(lo_objReqMonthList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResMonthList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9412;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MisStatHandler", "Exception",
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
        catch (Exception)
        {
            // ignored
        }
    }
}