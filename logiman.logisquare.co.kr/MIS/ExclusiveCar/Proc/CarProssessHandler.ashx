<%@ WebHandler Language="C#" Class="CarProssessHandler" %>
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
using System.Linq;
using DocumentFormat.OpenXml.Spreadsheet;

///================================================================
/// <summary>
/// FileName        : CarProssessHandler.ashx
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
public class CarProssessHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/MIS/ExclusiveCar/CarPossessChart"; //필수

    // 메소드 리스트
    private const string MethodStatCarDispatchAgentList  = "StatCarDispatchAgentList";
    private const string MethodStatCarDispatchClientList = "StatCarDispatchClientList";
    private const string MethodStatCarDivTypeList        = "StatCarDivTypeList";
    private const string MethodMonthPrevList             = "MonthPrevList";
    private const string MethodCarDispatchList           = "CarDispatchList";

    MisStatDasServices objMisStatDasServices = new MisStatDasServices();

    private   string       strCallType         = string.Empty;
    private   string       strCenterCode       = string.Empty;
    private   string       strSearchYM         = string.Empty;
    private   string       strSearchText       = string.Empty;
    private   string       strSearchType       = string.Empty;  
    private   string       strOrderItemCodes   = string.Empty;
    private   string       strClientName       = string.Empty;
    private   string       strAgentName        = string.Empty;
    private   string       strDateFrom         = string.Empty;
    private   string       strDateTo           = string.Empty;
    private   string       strConsignorName    = string.Empty;
    protected List<String> ListSeriesData      = new List<String>();

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodStatCarDispatchAgentList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatCarDispatchClientList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodStatCarDivTypeList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodMonthPrevList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarDispatchList,        MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("CarProssessHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CarProssessHandler");
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
            strSearchYM         = Utils.IsNull(SiteGlobal.GetRequestForm("SearchYM"), "").Replace("-", "");
            strOrderItemCodes   = Utils.IsNull(SiteGlobal.GetRequestForm("OrderItemCodes"), "");
            strClientName       = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");
            strAgentName        = Utils.IsNull(SiteGlobal.GetRequestForm("AgentName"), "");
            strDateFrom         = Utils.IsNull(SiteGlobal.GetRequestForm("DateFrom"), "").Replace("-", "");
            strDateTo           = Utils.IsNull(SiteGlobal.GetRequestForm("DateTo"), "").Replace("-", "");
            strSearchType       = Utils.IsNull(SiteGlobal.GetRequestForm("SearchType"), "");
            strSearchText       = Utils.IsNull(SiteGlobal.GetRequestForm("SearchText"), "");
            strConsignorName    = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorName"), "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarProssessHandler", "Exception",
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
                case MethodStatCarDispatchAgentList:
                    GetStatCarDispatchAgentList();
                    break;
                case MethodStatCarDispatchClientList:
                    GetStatCarDispatchClientList();
                    break;
                case MethodStatCarDivTypeList:
                    GetStatCarDivTypeList();
                    break;
                case MethodMonthPrevList:
                    GetMonthPrevList();
                    break;
                case MethodCarDispatchList:
                    GetCarDispatchList();
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

            SiteGlobal.WriteLog("CarProssessHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 담당자별 
    /// </summary>
    protected void GetStatCarDispatchAgentList()
    {
        ReqStatCarDispatchList                lo_obReqStatCarDispatchList  = null;
        ServiceResult<ResStatCarDispatchList> lo_objResStatCarDispatchList = null;
            
        try
        {
            lo_obReqStatCarDispatchList = new ReqStatCarDispatchList
            {
                CenterCode       = strCenterCode.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                OrderItemCodes   = strOrderItemCodes,
                AgentName        = strAgentName,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResStatCarDispatchList = objMisStatDasServices.GetStatCarDispatchAgentList(lo_obReqStatCarDispatchList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResStatCarDispatchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarProssessHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사별 
    /// </summary>
    protected void GetStatCarDispatchClientList()
    {
        ReqStatCarDispatchList                lo_obReqStatCarDispatchList  = null;
        ServiceResult<ResStatCarDispatchList> lo_objResStatCarDispatchList = null;
        
        switch (strSearchType)
        {
            case "Client":
                strClientName = strSearchText;
                break;
            case "Consignor":
                strConsignorName = strSearchText;
                break;
        }
        
        try
        {
            lo_obReqStatCarDispatchList = new ReqStatCarDispatchList
            {
                CenterCode       = strCenterCode.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                OrderItemCodes   = strOrderItemCodes,
                ClientName       = strClientName,
                ConsignorName    = strConsignorName,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResStatCarDispatchList = objMisStatDasServices.GetStatCarDispatchClientList(lo_obReqStatCarDispatchList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResStatCarDispatchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarProssessHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetStatCarDivTypeList()
    {
        ReqStatCarDivTypeList                lo_obReqStatCarDivTypeList  = null;
        ServiceResult<ResStatCarDivTypeList> lo_objResStatCarDivTypeList = null;
        
        try
        {
            lo_obReqStatCarDivTypeList = new ReqStatCarDivTypeList()
            {
                SearchYM         =   strSearchYM,
                CenterCode       = strCenterCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResStatCarDivTypeList = objMisStatDasServices.GetStatCarDivTypeList(lo_obReqStatCarDivTypeList);
            
            long lo_intCenterCode = 0;

            if (lo_objResStatCarDivTypeList != null && lo_objResStatCarDivTypeList.data != null) {
                CarDivChartStruct  chartStruct  = new CarDivChartStruct();
                CarDivChartItem    chartItem    = null;
                CarDivChartData    chartData    = null;
                CarDivChartSubData chartSubData = null;

                foreach (ResultStatCarDivTypeList item in lo_objResStatCarDivTypeList.data.list)
                {
                    //현재 처리 중인 고객사와 다른 고객사가 들어오면, 처리된 data 저장한 후 비교 값 초기화 
                    if (!lo_intCenterCode.Equals(item.CenterCode))
                    {
                        if (chartItem != null)
                        {
                            chartData.ItemValues = chartSubData;
                            chartItem.ItemData   = chartData;
                            chartStruct.ChartItems.Add(chartItem);
                        }

                        //숫자형태의 key인 경우 javascript에서 자동으로 sort를 하므로 이를 방지하기 위해 key에 underscore를 붙임.
                        chartItem    = new CarDivChartItem("_"+item.CenterCode);
                        chartData    = new CarDivChartData(item.CenterName, lo_objResStatCarDivTypeList.data.CarDivType1Cnt, lo_objResStatCarDivTypeList.data.CarDivType4Cnt, lo_objResStatCarDivTypeList.data.CarDivType6Cnt, lo_objResStatCarDivTypeList.data.CarDivType1UseCarCnt, lo_objResStatCarDivTypeList.data.CarDivType4UseCarCnt, lo_objResStatCarDivTypeList.data.CarDivType6UseCarCnt);
                        chartSubData = new CarDivChartSubData();
                    }

                    chartData.TickValues.Add(item.YY + "-" + item.MM);
                    chartSubData.CarDivType1Cnt.Add(item.CarDivType1Cnt);
                    chartSubData.CarDivType4Cnt.Add(item.CarDivType4Cnt);
                    chartSubData.CarDivType6Cnt.Add(item.CarDivType6Cnt);
                    chartSubData.TotalCnt.Add(item.TotCarDivTypeCnt);

                    chartSubData.CarDivType1UseCarCnt.Add(item.CarDivType1UseCarCnt);
                    chartSubData.CarDivType4UseCarCnt.Add(item.CarDivType4UseCarCnt);
                    chartSubData.CarDivType6UseCarCnt.Add(item.CarDivType6UseCarCnt);
                    chartSubData.TotCarDivTypeUseCarCnt.Add(item.TotCarDivTypeUseCarCnt);

                    lo_intCenterCode = item.CenterCode;
                } //end foreach

                //최종 data에 추가되지 않은 마지막 레코드 입력
                if (chartItem != null)
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
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarProssessHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 월별 리스트
    /// </summary>
    protected void GetMonthPrevList()
    {
        ReqMonthList                lo_objReqMonthList = null;
        ServiceResult<ResMonthList> lo_objResMonthList = null;

        try
        {
            lo_objReqMonthList = new ReqMonthList
            {
                DateFrom = strDateFrom,
            };

            lo_objResMonthList    = objMisStatDasServices.GetMonthPrevList(lo_objReqMonthList);
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
    /// 전담차량 사용실적
    /// </summary>
    protected void GetCarDispatchList()
    {
        ReqStatCarDispatchList                lo_obReqStatCarDispatchList  = null;
        ServiceResult<ResStatCarDispatchList> lo_objResStatCarDispatchList = null;
            
        try
        {
            lo_obReqStatCarDispatchList = new ReqStatCarDispatchList
            {
                CenterCode     = strCenterCode.ToInt(),
                OrderItemCodes = strOrderItemCodes,
                SearchYM       =   strSearchYM,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResStatCarDispatchList = objMisStatDasServices.GetStatCarDispatchList(lo_obReqStatCarDispatchList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResStatCarDispatchList) + "]";
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