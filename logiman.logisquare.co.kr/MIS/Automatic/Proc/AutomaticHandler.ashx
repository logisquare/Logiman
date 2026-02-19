<%@ WebHandler Language="C#" Class="AutomaticHandler" %>
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
/// FileName        : AutomaticHandler.ashx
/// Description     : 경영정보시스템 - 자동운임
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2023-02-06
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class AutomaticHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/MIS/Automatic/AutomaticChart"; //필수

    // 메소드 리스트
    private const string MethodAutomaticSummaryList           = "AutomaticSummaryList";
    private const string MethodStatTransRateClientMonthlyList = "StatTransRateClientMonthlyList";
    private const string MethodStatTransRateClientDailyList   = "StatTransRateClientDailyList";
    private const string MethodStatTransRateAgentMonthlyList  = "StatTransRateAgentMonthlyList";
    private const string MethodStatTransRateAgentDailyList    = "StatTransRateAgentDailyList";
    private const string MethodMonthList                      = "MonthList";
    private const string MethodDailyList                      = "DailyList";

    MisStatDasServices objMisStatDasServices = new MisStatDasServices();

    private   string       strCallType       = string.Empty;
    private   string       strCenterCode     = string.Empty;
    private   string       strSearchYMD      = string.Empty;
    private   string       strSearchText     = string.Empty;
    private   string       strSearchType     = string.Empty;  
    private   string       strGroupType      = string.Empty;  
    private   string       strOrderItemCodes = string.Empty;
    private   string       strClientCode     = string.Empty;
    private   string       strClientName     = string.Empty;
    private   string       strAgentName      = string.Empty;
    private   string       strAgentCode      = string.Empty;
    private   string       strDateType       = string.Empty;
    private   string       strDateFrom       = string.Empty;
    private   string       strDateTo         = string.Empty;
    private   string       strConsignorName  = string.Empty;
    private   string       strPreMonFromYMD  = string.Empty;
    private   string       strPreMonToYMD    = string.Empty;
    private   string       strListType       = string.Empty;
    protected List<String> ListSeriesData    = new List<String>();

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAutomaticSummaryList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatTransRateClientMonthlyList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatTransRateClientDailyList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatTransRateAgentMonthlyList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatTransRateAgentDailyList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodMonthList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDailyList,            MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AutomaticHandler");
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
            strCenterCode     = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strSearchYMD      = Utils.IsNull(SiteGlobal.GetRequestForm("SearchYMD"), "").Replace("-", "");
            strOrderItemCodes = Utils.IsNull(SiteGlobal.GetRequestForm("OrderItemCodes"), "");
            strClientCode     = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strClientName     = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");
            strAgentName      = Utils.IsNull(SiteGlobal.GetRequestForm("AgentName"), "");
            strDateType       = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "");
            strDateFrom       = Utils.IsNull(SiteGlobal.GetRequestForm("DateFrom"), "").Replace("-", "");
            strDateTo         = Utils.IsNull(SiteGlobal.GetRequestForm("DateTo"), "").Replace("-", "");
            strSearchType     = Utils.IsNull(SiteGlobal.GetRequestForm("SearchType"), "");
            strGroupType      = Utils.IsNull(SiteGlobal.GetRequestForm("GroupType"), "1");
            strSearchText     = Utils.IsNull(SiteGlobal.GetRequestForm("SearchText"), "");
            strConsignorName  = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorName"), "");
            strPreMonFromYMD  = Utils.IsNull(SiteGlobal.GetRequestForm("PreMonFromYMD"), "");
            strPreMonToYMD    = Utils.IsNull(SiteGlobal.GetRequestForm("PreMonToYMD"), "");
            strListType       = Utils.IsNull(SiteGlobal.GetRequestForm("ListType"), "0");
            strAgentCode      = Utils.IsNull(SiteGlobal.GetRequestForm("AgentCode"), "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
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
                case MethodAutomaticSummaryList:
                    GetAutomaticSummaryList();
                    break;
                case MethodStatTransRateClientMonthlyList:
                    GetStatTransRateClientMonthlyList();
                    break;
                case MethodStatTransRateClientDailyList:
                    GetStatTransRateClientDailyList();
                    break;
                case MethodStatTransRateAgentMonthlyList:
                    GetStatTransRateAgentMonthlyList();
                    break;
                case MethodStatTransRateAgentDailyList:
                    GetStatTransRateAgentDailyList();
                    break;
                case MethodMonthList:
                    GetMonthList();
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

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 전체 (월별)
    /// </summary>
    protected void GetAutomaticSummaryList()
    {
        ReqStatTransRateSummaryList                lo_obReqStatTransRateSummaryList  = null;
        ServiceResult<ResStatTransRateSummaryList> lo_objResStatTransRateSummaryList = null;
            
        try
        {
            switch (strSearchType)
            {
                case "Charge":
                    strAgentName        = strSearchText;
                    break;
                case "Client":
                    strClientName       = strSearchText;
                    break;
            }

            lo_obReqStatTransRateSummaryList = new ReqStatTransRateSummaryList
            {
                FromYMD        = strDateFrom,
                ToYMD          = strDateTo,
                PreMonFromYMD  = strPreMonFromYMD,
                PreMonToYMD    = strPreMonToYMD,
                CenterCode     = strCenterCode.ToInt(),

                OrderItemCodes = strOrderItemCodes,
                ClientName     = strClientName,
                AgentName        = strAgentName,
                ConsignorName    = strConsignorName,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResStatTransRateSummaryList = objMisStatDasServices.GetTransRateSummaryList(lo_obReqStatTransRateSummaryList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResStatTransRateSummaryList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 전체 (고객사별 현황)
    /// </summary>
    protected void GetStatTransRateClientMonthlyList()
    {
        ReqStatOrderList                      lo_objReqStatOrderList     = null;
        ServiceResult<ResponseClientGrouping> lo_objResultClientGrouping = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                ListType       = strListType.ToInt(),
                DateFrom       = strDateFrom,
                DateTo         = strDateTo,
                CenterCode     = strCenterCode.ToInt(),
                OrderItemCodes = strOrderItemCodes,

                ClientCode      =  strClientCode.ToInt64(), 
                ClientName       = strClientName,
                AgentName        = strAgentName,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResultClientGrouping = objMisStatDasServices.GetStatTransRateClientMonthlyList(lo_objReqStatOrderList);

            long lo_intCurrentClientCode = 0;

            if (lo_objResultClientGrouping != null && lo_objResultClientGrouping.data != null) {
                ChartStruct  chartStruct  = new ChartStruct();
                ChartItem    chartItem    = null;
                ChartNewData chartData    = null;
                ChartNewSubData chartSubData = null;

                foreach (ResultDataClientGrouping item in lo_objResultClientGrouping.data.data)
                {
                    //현재 처리 중인 고객사와 다른 고객사가 들어오면, 처리된 data 저장한 후 비교 값 초기화 
                    if (strListType.ToInt().Equals(1))
                    {
                        if (!lo_intCurrentClientCode.Equals(item.client_code))
                        {
                            if (chartItem != null)
                            {
                                chartData.ItemValues  = chartSubData;
                                chartItem.ItemNewData = chartData;
                                chartStruct.ChartItems.Add(chartItem);
                            }

                            //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                            chartItem    = new ChartItem("_" + item.client_code);
                            chartData    = new ChartNewData(item.client_name, item.center_code, item.order_count_cumulative, item.total_order_count_cumulative, item.applied_order_count_cumulative, item.Unapplied_order_count_cumulative);
                            chartSubData = new ChartNewSubData();
                        }
                    }
                    else
                    {
                        if (!lo_intCurrentClientCode.Equals(item.consignor_code))
                        {
                            if (chartItem != null)
                            {
                                chartData.ItemValues  = chartSubData;
                                chartItem.ItemNewData = chartData;
                                chartStruct.ChartItems.Add(chartItem);
                            }

                            //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                            chartItem    = new ChartItem("_" + item.consignor_code);
                            chartData    = new ChartNewData(item.consignor_name, item.center_code, item.order_count_cumulative, item.total_order_count_cumulative, item.applied_order_count_cumulative, item.Unapplied_order_count_cumulative);
                            chartSubData = new ChartNewSubData();
                        }
                    }

                    chartData.TickValues.Add(item.YY + "-" + item.MM);
                    chartSubData.order_count.Add(item.order_count);
                    chartSubData.order_count_cumulative.Add(item.order_count_cumulative);

                    chartSubData.applied_order_count.Add(item.applied_order_count);
                    chartSubData.applied_order_count_cumulative.Add(item.applied_order_count_cumulative);

                    chartSubData.Unapplied_order_count.Add(item.Unapplied_order_count);
                    chartSubData.Unapplied_order_count_cumulative.Add(item.Unapplied_order_count_cumulative);

                    chartSubData.apply_rate.Add(item.apply_rate);

                    if (strListType.ToInt().Equals(1))
                    {
                        lo_intCurrentClientCode = item.client_code;
                    }
                    else
                    {
                        lo_intCurrentClientCode = item.consignor_code;
                    }
                } //end foreach

                
                //최종 data에 추가되지 않은 마지막 레코드 입력
                if (chartItem != null)
                {
                    chartData.ItemValues  = chartSubData;
                    chartItem.ItemNewData = chartData;
                    chartStruct.ChartItems.Add(chartItem);
                }
                
                objResMap.strResponse = JsonConvert.SerializeObject(chartStruct);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 전체 (고객사별 현황 일별)
    /// </summary>
    protected void GetStatTransRateClientDailyList()
    {
        ReqStatOrderList                      lo_objReqStatOrderList     = null;
        ServiceResult<ResponseClientGrouping> lo_objResultClientGrouping = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                ListType       = strListType.ToInt(),
                DateFrom       = strDateFrom,
                DateTo         = strDateTo,
                CenterCode     = strCenterCode.ToInt(),
                OrderItemCodes = strOrderItemCodes,

                ClientCode       = strClientCode.ToInt64(),
                ClientName       = strClientName,
                AgentName        = strAgentName,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResultClientGrouping = objMisStatDasServices.GetStatTransRateClientDailyList(lo_objReqStatOrderList);

            long lo_intCurrentClientCode = 0;

            if (lo_objResultClientGrouping != null && lo_objResultClientGrouping.data != null) {
                ChartStruct  chartStruct  = new ChartStruct();
                ChartItem    chartItem    = null;
                ChartNewData chartData    = null;
                ChartNewSubData chartSubData = null;

                foreach (ResultDataClientGrouping item in lo_objResultClientGrouping.data.data)
                {
                    if (strListType.ToInt().Equals(1))
                    {
                        if (!lo_intCurrentClientCode.Equals(item.client_code))
                        {
                            if (chartItem != null)
                            {
                                chartData.ItemValues  = chartSubData;
                                chartItem.ItemNewData = chartData;
                                chartStruct.ChartItems.Add(chartItem);
                            }

                            //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                            chartItem    = new ChartItem("_" + item.client_code);
                            chartData    = new ChartNewData(item.client_name, item.center_code, item.order_count_cumulative, item.total_order_count_cumulative, item.applied_order_count_cumulative, item.Unapplied_order_count_cumulative);
                            chartSubData = new ChartNewSubData();
                        }
                    }
                    else
                    {
                        if (!lo_intCurrentClientCode.Equals(item.consignor_code))
                        {
                            if (chartItem != null)
                            {
                                chartData.ItemValues  = chartSubData;
                                chartItem.ItemNewData = chartData;
                                chartStruct.ChartItems.Add(chartItem);
                            }

                            //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                            chartItem    = new ChartItem("_" + item.consignor_code);
                            chartData    = new ChartNewData(item.consignor_name, item.center_code, item.order_count_cumulative, item.total_order_count_cumulative, item.applied_order_count_cumulative, item.Unapplied_order_count_cumulative);
                            chartSubData = new ChartNewSubData();
                        }
                    }

                    chartData.TickValues.Add(item.YY + "-" + item.MM + "-" + item.DD);
                    chartSubData.order_count.Add(item.order_count);
                    chartSubData.order_count_cumulative.Add(item.order_count_cumulative);

                    chartSubData.applied_order_count.Add(item.applied_order_count);
                    chartSubData.applied_order_count_cumulative.Add(item.applied_order_count_cumulative);

                    chartSubData.Unapplied_order_count.Add(item.Unapplied_order_count);
                    chartSubData.Unapplied_order_count_cumulative.Add(item.Unapplied_order_count_cumulative);

                    chartSubData.apply_rate.Add(item.apply_rate);

                    if (strListType.ToInt().Equals(1))
                    {
                        lo_intCurrentClientCode = item.client_code;
                    }
                    else
                    {
                        lo_intCurrentClientCode = item.consignor_code;
                    }
                } //end foreach

                
                //최종 data에 추가되지 않은 마지막 레코드 입력
                if (chartItem != null)
                {
                    chartData.ItemValues  = chartSubData;
                    chartItem.ItemNewData = chartData;
                    chartStruct.ChartItems.Add(chartItem);
                }
                
                objResMap.strResponse = JsonConvert.SerializeObject(chartStruct);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
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
                DateFrom = strDateFrom,
                DateTo   = strDateTo
            };

            lo_objResMonthList    = objMisStatDasServices.GetMonthList(lo_objReqMonthList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResMonthList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9409;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
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
                DateFrom = strDateFrom,
                DateTo   = strDateTo
            };

            lo_objResMonthList    = objMisStatDasServices.GetDailyList(lo_objReqMonthList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResMonthList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9410;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 월별 (담당자병 현황)
    /// </summary>
    protected void GetStatTransRateAgentMonthlyList()
    {
        ReqStatOrderList                      lo_objReqStatOrderList     = null;
        ServiceResult<ResponseClientGrouping> lo_objResultAgentGrouping = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                ListType       = strListType.ToInt(),
                DateFrom       = strDateFrom,
                DateTo         = strDateTo,
                CenterCode     = strCenterCode.ToInt(),
                OrderItemCodes = strOrderItemCodes,

                ClientName       = strClientName,
                AgentCode        = strAgentCode,
                AgentName        = strAgentName,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResultAgentGrouping = objMisStatDasServices.GetStatTransRateAgentMonthlyList(lo_objReqStatOrderList);

            string lo_strCurrentAgentCode = "";
            long lo_intCurrentClientCode = 0;
            long lo_intCurrentConsignorCode = 0;

            if (lo_objResultAgentGrouping != null && lo_objResultAgentGrouping.data != null) {
                ChartStruct  chartStruct  = new ChartStruct();
                ChartItem    chartItem    = null;
                ChartNewData chartData    = null;
                ChartNewSubData chartSubData = null;

                foreach (ResultDataClientGrouping item in lo_objResultAgentGrouping.data.data)
                {
                    if (strListType.ToInt().Equals(1))
                    {
                        if (!lo_strCurrentAgentCode.Equals(item.agent_code))
                        {
                            if (chartItem != null)
                            {
                                chartData.ItemValues  = chartSubData;
                                chartItem.ItemNewData = chartData;
                                chartStruct.ChartItems.Add(chartItem);
                            }

                            //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                            chartItem    = new ChartItem("_" + item.agent_code);
                            chartData    = new ChartNewData(item.agent_name, item.center_code, item.order_count_cumulative, item.total_order_count_cumulative, item.applied_order_count_cumulative, item.Unapplied_order_count_cumulative);
                            chartSubData = new ChartNewSubData();
                        }
                    }
                    else
                    {
                        if (!lo_intCurrentClientCode.Equals(item.client_code) || !lo_intCurrentConsignorCode.Equals(item.consignor_code))
                        {
                            if (chartItem != null)
                            {
                                chartData.ItemValues  = chartSubData;
                                chartItem.ItemNewData = chartData;
                                chartStruct.ChartItems.Add(chartItem);
                            }

                            //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                            chartItem    = new ChartItem("_" + item.client_code + item.consignor_code);
                            chartData    = new ChartNewData(item.client_name + "<br>("+ item.consignor_name +")", item.center_code, item.order_count_cumulative, item.total_order_count_cumulative, item.applied_order_count_cumulative, item.Unapplied_order_count_cumulative);
                            chartSubData = new ChartNewSubData();
                        }
                    }

                    //현재 처리 중인 고객사와 다른 고객사가 들어오면, 처리된 data 저장한 후 비교 값 초기화 
                    

                    chartData.TickValues.Add(item.YY + "-" + item.MM);
                    chartSubData.order_count.Add(item.order_count);
                    chartSubData.order_count_cumulative.Add(item.order_count_cumulative);

                    chartSubData.applied_order_count.Add(item.applied_order_count);
                    chartSubData.applied_order_count_cumulative.Add(item.applied_order_count_cumulative);

                    chartSubData.Unapplied_order_count.Add(item.Unapplied_order_count);
                    chartSubData.Unapplied_order_count_cumulative.Add(item.Unapplied_order_count_cumulative);

                    chartSubData.apply_rate.Add(item.apply_rate);

                    if (strListType.ToInt().Equals(1))
                    {
                        lo_strCurrentAgentCode = item.agent_code;
                    }
                    else
                    {
                        lo_intCurrentClientCode    = item.client_code;
                        lo_intCurrentConsignorCode = item.consignor_code;
                    }
                    
                } //end foreach

                
                //최종 data에 추가되지 않은 마지막 레코드 입력
                if (chartItem != null)
                {
                    chartData.ItemValues  = chartSubData;
                    chartItem.ItemNewData = chartData;
                    chartStruct.ChartItems.Add(chartItem);
                }
                
                objResMap.strResponse = JsonConvert.SerializeObject(chartStruct);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9412;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 일별 (담당자병 현황)
    /// </summary>
    protected void GetStatTransRateAgentDailyList()
    {
        ReqStatOrderList                      lo_objReqStatOrderList     = null;
        ServiceResult<ResponseClientGrouping> lo_objResultAgentGrouping = null;

        try
        {
            lo_objReqStatOrderList = new ReqStatOrderList
            {
                ListType       = strListType.ToInt(),
                DateFrom       = strDateFrom,
                DateTo         = strDateTo,
                CenterCode     = strCenterCode.ToInt(),
                OrderItemCodes = strOrderItemCodes,

                ClientName       = strClientName,
                AgentCode        = strAgentCode,
                AgentName        = strAgentName,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResultAgentGrouping = objMisStatDasServices.GetStatTransRateAgentDaillyList(lo_objReqStatOrderList);

            string lo_strCurrentAgentCode     = "";
            long   lo_intCurrentClientCode    = 0;
            long   lo_intCurrentConsignorCode = 0;

            if (lo_objResultAgentGrouping != null && lo_objResultAgentGrouping.data != null) {
                ChartStruct  chartStruct  = new ChartStruct();
                ChartItem    chartItem    = null;
                ChartNewData chartData    = null;
                ChartNewSubData chartSubData = null;

                foreach (ResultDataClientGrouping item in lo_objResultAgentGrouping.data.data)
                {
                    if (strListType.ToInt().Equals(1))
                    {
                        if (!lo_strCurrentAgentCode.Equals(item.agent_code))
                        {
                            if (chartItem != null)
                            {
                                chartData.ItemValues  = chartSubData;
                                chartItem.ItemNewData = chartData;
                                chartStruct.ChartItems.Add(chartItem);
                            }

                            //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                            chartItem    = new ChartItem("_" + item.agent_code);
                            chartData    = new ChartNewData(item.agent_name, item.center_code, item.order_count_cumulative, item.total_order_count_cumulative, item.applied_order_count_cumulative, item.Unapplied_order_count_cumulative);
                            chartSubData = new ChartNewSubData();
                        }
                    }
                    else
                    {
                        if (!lo_intCurrentClientCode.Equals(item.client_code) || !lo_intCurrentConsignorCode.Equals(item.consignor_code))
                        {
                            if (chartItem != null)
                            {
                                chartData.ItemValues  = chartSubData;
                                chartItem.ItemNewData = chartData;
                                chartStruct.ChartItems.Add(chartItem);
                            }

                            //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                            chartItem    = new ChartItem("_" + item.client_code + item.consignor_code);
                            chartData    = new ChartNewData(item.client_name + "<br>("+ item.consignor_name +")", item.center_code, item.order_count_cumulative, item.total_order_count_cumulative, item.applied_order_count_cumulative, item.Unapplied_order_count_cumulative);
                            chartSubData = new ChartNewSubData();
                        }
                    }

                    //현재 처리 중인 고객사와 다른 고객사가 들어오면, 처리된 data 저장한 후 비교 값 초기화 
                    chartData.TickValues.Add(item.YY + "-" + item.MM + "-" + item.DD);
                    chartSubData.order_count.Add(item.order_count);
                    chartSubData.order_count_cumulative.Add(item.order_count_cumulative);

                    chartSubData.applied_order_count.Add(item.applied_order_count);
                    chartSubData.applied_order_count_cumulative.Add(item.applied_order_count_cumulative);

                    chartSubData.Unapplied_order_count.Add(item.Unapplied_order_count);
                    chartSubData.Unapplied_order_count_cumulative.Add(item.Unapplied_order_count_cumulative);

                    chartSubData.apply_rate.Add(item.apply_rate);

                    if (strListType.ToInt().Equals(1))
                    {
                        lo_strCurrentAgentCode = item.agent_code;
                    }
                    else
                    {
                        lo_intCurrentClientCode    = item.client_code;
                        lo_intCurrentConsignorCode = item.consignor_code;
                    }
                    
                } //end foreach

                
                //최종 data에 추가되지 않은 마지막 레코드 입력
                if (chartItem != null)
                {
                    chartData.ItemValues  = chartSubData;
                    chartItem.ItemNewData = chartData;
                    chartStruct.ChartItems.Add(chartItem);
                }
                
                objResMap.strResponse = JsonConvert.SerializeObject(chartStruct);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9413;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AutomaticHandler", "Exception",
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