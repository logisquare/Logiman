using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;

namespace TMS.CarMap
{
    public partial class CarMapControlDetail : PageBase
    {
        public string strMarker = $"new daum.maps.LatLng({SiteGlobal.LOGIMAN_ADDR_LAT}, {SiteGlobal.LOGIMAN_ADDR_LNG})";

        CarMapDasServices objCarMapDasServices = new CarMapDasServices();

        public string strCenterCode      = string.Empty;
        public string strCarInfo         = string.Empty;
        public string strYmd             = string.Empty;
        public string strLocInfo         = string.Empty;
        public string strElapsedTimeInfo = string.Empty;
        public string strMarkerDt        = string.Empty;
        public string strCenterLocation  = string.Empty;
        public string strShowMapStr      = string.Empty;
        public string strMapErrorMsg     = string.Empty;

        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadWrite;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            int lo_intRetVal = 0;

            try
            {
                strCenterCode       = SiteGlobal.GetRequestForm("CenterCode");
                strCarInfo          = SiteGlobal.GetRequestForm("carinfo");
                strYmd              = SiteGlobal.GetRequestForm("Ymd");
                HidShowType.Value   = SiteGlobal.GetRequestForm("showtype");
                HidDriverCell.Value = SiteGlobal.GetRequestForm("DriverCell");

                switch (HidShowType.Value)
                {
                    case "2":
                        // 전체차량 조회
                        DisplayDataAllGPS();
                        break;
                    case "3":
                        // 현재위치 조회
                        DisplayDataGpsNow();
                        break;
                    default:
                        // GPS 이동경로 표시(기본)
                        DisplayDataGPS();
                        break;
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9101;
                SiteGlobal.WriteLog("CarMapControlDetail", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    lo_intRetVal);
            }
        }

        protected void DisplayDataGPS()
        {
            ReqCarMapList             lo_objReqCarMapList = null;
            ServiceResult<ResGpsList> lo_objResGpsList    = null;

            int      lo_intLoop          = 0;
            string   lo_strokeOpacity    = "1";
            string   lo_strLocation      = "";
            string   lo_strStartLocation = "";
            string   lo_strStartTm       = "";
            string   lo_strEndLocation   = "";
            string   lo_strEndTm         = "";
            string[] lo_arrLocation      = new string[10000];
            string[] lo_arrStartLocation = new string[10000];
            string[] lo_arrStartTm       = new string[10000];
            string[] lo_arrEndLocation   = new string[10000];
            string[] lo_arrEndTm         = new string[10000];

            try
            {
                lo_objReqCarMapList = new ReqCarMapList
                {
                    AuthTel        = HidDriverCell.Value,
                    DateFrom       = strYmd.Replace("-", ""),
                    DateTo         = strYmd.Replace("-", ""),
                    MaxLinearMeter = 1000,
                    MaxMinutes     = 600
                };

                lo_objResGpsList = objCarMapDasServices.GetGPSList(lo_objReqCarMapList);

                if (lo_objResGpsList.result.ErrorCode.IsFail())
                {
                    strCenterLocation  = $"new daum.maps.LatLng({SiteGlobal.LOGIMAN_ADDR_LAT}, {SiteGlobal.LOGIMAN_ADDR_LNG})";
                    strMapErrorMsg     = "GSP 정보 조회 중 오류가 발생했습니다.";
                    strLocInfo         = "0 Km ";
                    strElapsedTimeInfo = "0 분 ";
                    HidErrorFlag.Value = "Y";

                    return;
                }

                strLocInfo         = StringExtensions.ConvertMoneyFormat(lo_objResGpsList.data.TotalDistance / 1000) + " Km ";
                strElapsedTimeInfo = lo_objResGpsList.data.TotalElapsedTime;

                int lo_intTotalGPSCnt = 1;

                if (lo_objResGpsList.data.RecordCnt > 0)
                {
                    foreach (var row in lo_objResGpsList.data.list)
                    {
                        if (lo_intLoop > 0 && row.StartFlag.Equals("Y"))
                        {
                            lo_arrLocation[lo_intTotalGPSCnt - 1]      = lo_strLocation;
                            lo_arrStartLocation[lo_intTotalGPSCnt - 1] = lo_strStartLocation;
                            lo_arrStartTm[lo_intTotalGPSCnt - 1]       = lo_strStartTm;
                            lo_arrEndLocation[lo_intTotalGPSCnt - 1]   = lo_strEndLocation;
                            lo_arrEndTm[lo_intTotalGPSCnt - 1]         = lo_strEndTm;

                            lo_strLocation = lo_strStartLocation = lo_strStartTm = lo_strEndLocation = lo_strEndTm = "";
                            lo_intTotalGPSCnt++;
                        }

                        if (!string.IsNullOrWhiteSpace(lo_strLocation))
                        {
                            lo_strLocation += ",";
                        }
                        else
                        {
                            lo_strStartLocation = $"new daum.maps.LatLng({row.GLAT}, {row.GLNG})";
                            lo_strStartTm       = row.RegDate;
                        }

                        lo_strLocation    += $"new daum.maps.LatLng({row.GLAT},{row.GLNG})";
                        lo_strEndLocation =  $"new daum.maps.LatLng({row.GLAT}, {row.GLNG})";
                        lo_strEndTm       =  row.RegDate;


                        if ((lo_objResGpsList.data.RecordCnt / 2) == lo_intLoop)
                        {
                            strCenterLocation = $"new daum.maps.LatLng({row.GLAT}, {row.GLNG})";
                        }

                        lo_intLoop++;
                    }

                    if (!string.IsNullOrWhiteSpace(lo_strLocation))
                    {
                        lo_arrLocation[lo_intTotalGPSCnt - 1]      = lo_strLocation;
                        lo_arrStartLocation[lo_intTotalGPSCnt - 1] = lo_strStartLocation;
                        lo_arrStartTm[lo_intTotalGPSCnt - 1]       = lo_strStartTm;
                        lo_arrEndLocation[lo_intTotalGPSCnt - 1]   = lo_strEndLocation;
                        lo_arrEndTm[lo_intTotalGPSCnt - 1]         = lo_strEndTm;
                    }
                    
                    strShowMapStr = "";
                    for (lo_intLoop = 0; lo_intLoop < lo_intTotalGPSCnt; lo_intLoop++)
                    {
                        // 선을 구성하는 좌표 배열입니다. 이 좌표들을 이어서 선을 표시합니다
                        strShowMapStr += $"linePath{lo_intLoop} = [{lo_arrLocation[lo_intLoop]}];";

                        // 지도에 표시할 선을 생성합니다
                        //path : 선을 구성하는 좌표배열 입니다
                        //strokeWeight : 선의 두께 입니다
                        //strokeColor : 선의 색깔입니다.
                        //lo_strokeOpacity : 선의 불투명도입니다. 1에서 0사이의 값이며 0에 가까울수록 투명합니다.
                        //strokeStyle : 선의 스타일입니다.

                        // lo_strokeOpacity = "0"; // 지도에 선을 표시하지 않음

                        strShowMapStr += $"polyline = new daum.maps.Polyline({{path: linePath{lo_intLoop}, strokeWeight: 4, strokeColor: '#262626',strokeOpacity: {lo_strokeOpacity}, strokeStyle: 'solid'}});";

                        // 지도에 선을 표시합니다 
                        strShowMapStr += "polyline.setMap(map);";

                        strShowMapStr += $"var marker{lo_intTotalGPSCnt}, infoWindow{lo_intTotalGPSCnt}, startPosition{lo_intTotalGPSCnt}, endPosition{lo_intTotalGPSCnt}, infoText{lo_intTotalGPSCnt};";
                        strShowMapStr += $"startPosition{lo_intTotalGPSCnt} = {lo_arrStartLocation[lo_intLoop]};";
                        strShowMapStr += $"marker{lo_intTotalGPSCnt} = new daum.maps.Marker({{ position:  startPosition{lo_intTotalGPSCnt} }});";
                        strShowMapStr += $"marker{lo_intTotalGPSCnt}.setMap(map);";
                        strShowMapStr += $"infoText{lo_intTotalGPSCnt} = '<div style=\"padding:0px;font-size:13px;font-weight:bold\">시작 위치</div><div style=\"padding-bottom:5px;font-size:11px\">시간: {lo_arrStartTm[lo_intLoop]} </div>';";
                        strShowMapStr += $"infoWindow{lo_intTotalGPSCnt} = new daum.maps.InfoWindow({{ position: startPosition{lo_intTotalGPSCnt}, content: infoText{lo_intTotalGPSCnt} }});";
                        strShowMapStr += $"infoWindow{lo_intTotalGPSCnt}.open(map, marker{lo_intTotalGPSCnt});";
                        strShowMapStr += $"endPosition{lo_intTotalGPSCnt} = {lo_arrEndLocation[lo_intLoop]};";
                        strShowMapStr += $"marker{lo_intTotalGPSCnt} = new daum.maps.Marker({{ position:  endPosition{lo_intTotalGPSCnt} }});";
                        strShowMapStr += $"marker{lo_intTotalGPSCnt}.setMap(map);";
                        strShowMapStr += $"infoText{lo_intTotalGPSCnt} = '<div style=\"padding:0px;font-size:13px;font-weight:bold\">마지막 위치</div><div style=\"padding-bottom:5px;font-size:11px\">시간: {lo_arrEndTm[lo_intLoop]} </div>';";
                        strShowMapStr += $"infoWindow{lo_intTotalGPSCnt} = new daum.maps.InfoWindow({{ position: endPosition{lo_intTotalGPSCnt}, content: infoText{lo_intTotalGPSCnt} }});";
                        strShowMapStr += $"infoWindow{lo_intTotalGPSCnt}.open(map, marker{lo_intTotalGPSCnt});";
                    }

                    strShowMapStr += "var bounds = new daum.maps.LatLngBounds();";
                    for (lo_intLoop = 0; lo_intLoop < lo_intTotalGPSCnt; lo_intLoop++)
                    {
                        strShowMapStr += $"for (var i = 0; i < linePath{lo_intLoop}.length; i++) {{ bounds.extend(linePath{lo_intLoop}[i]); }}";
                        strShowMapStr += "map.setBounds(bounds);";
                    }
                }
                else
                {
                    strCenterLocation  = $"new daum.maps.LatLng({SiteGlobal.LOGIMAN_ADDR_LAT}, {SiteGlobal.LOGIMAN_ADDR_LNG})";
                    strMapErrorMsg     = "GPS 수신 정보가 없습니다.";
                    HidErrorFlag.Value = "Y";
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                                    "CarMapControlDetail",
                                    "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9102);
            }
        }

        protected void DisplayDataAllGPS()
        {
            ReqCarMapList             lo_objReqCarMapList = null;
            ServiceResult<ResGpsList> lo_objResGpsList    = null;

            int      lo_intLoop            = 0;
            int      lo_intTotalGPSCnt     = 0;
            string   lo_strLocation        = "";
            string   lo_strStartLocation   = "";
            string   lo_strStartTm         = "";
            string   lo_strEndLocation     = "";
            string   lo_strEndTm           = "";
            string   lo_strDriverName      = "";
            string   lo_strDriverCell      = "";
            string   lo_strCarNo           = "";
            string   lo_strOperationState  = "";
            string   lo_strOperationStateM = "";
            string[] lo_arrLocation        = new string[10000];
            string[] lo_arrStartLocation   = new string[10000];
            string[] lo_arrStartTm         = new string[10000];
            string[] lo_arrEndLocation     = new string[10000];
            string[] lo_arrEndTm           = new string[10000];
            string[] lo_arrDriverName      = new string[10000];
            string[] lo_arrDriverCell      = new string[10000];
            string[] lo_arrCarNo           = new string[10000];
            string[] lo_arrOperationState  = new string[10000];
            string[] lo_arrOperationStateM = new string[10000];
            string   lo_strTotalCarsFlag   = "Y";

            strCarInfo         = "-";
            strLocInfo         = "-";
            strElapsedTimeInfo = "-";

            try
            {
                lo_objReqCarMapList = new ReqCarMapList
                {
                    CenterCode    = strCenterCode.ToInt(),
                    YMD           = strYmd.Replace("-", ""),
                    TotalCarsFlag = lo_strTotalCarsFlag
                };

                lo_objResGpsList = objCarMapDasServices.GetGPSDayAllCarsList(lo_objReqCarMapList);

                if (lo_objResGpsList.result.ErrorCode.IsFail())
                {
                    strCenterLocation  = $"new daum.maps.LatLng({SiteGlobal.LOGIMAN_ADDR_LAT}, {SiteGlobal.LOGIMAN_ADDR_LNG})";
                    strMapErrorMsg     = "GSP 정보 조회 중 오류가 발생했습니다.";
                    HidErrorFlag.Value = "Y";
                    return;
                }

                strCarInfo        = lo_objResGpsList.data.RecordCnt + " 대 ";
                lo_intTotalGPSCnt = 1;

                if (lo_objResGpsList.data.RecordCnt > 0)
                {
                    foreach (var row in lo_objResGpsList.data.list)
                    {
                        if (lo_intLoop > 0 && row.StartFlag.Equals("Y"))
                        {
                            lo_arrLocation[lo_intTotalGPSCnt - 1]        = lo_strLocation;
                            lo_arrStartLocation[lo_intTotalGPSCnt - 1]   = lo_strStartLocation;
                            lo_arrStartTm[lo_intTotalGPSCnt - 1]         = lo_strStartTm;
                            lo_arrEndLocation[lo_intTotalGPSCnt - 1]     = lo_strEndLocation;
                            lo_arrEndTm[lo_intTotalGPSCnt - 1]           = lo_strEndTm;
                            lo_arrDriverName[lo_intTotalGPSCnt - 1]      = lo_strDriverName;
                            lo_arrDriverCell[lo_intTotalGPSCnt - 1]      = lo_strDriverCell;
                            lo_arrCarNo[lo_intTotalGPSCnt - 1]           = lo_strCarNo;
                            lo_arrOperationState[lo_intTotalGPSCnt - 1]  = lo_strOperationState;
                            lo_arrOperationStateM[lo_intTotalGPSCnt - 1] = lo_strOperationStateM;

                            lo_strLocation = lo_strStartLocation = lo_strStartTm = lo_strEndLocation = lo_strEndTm = "";
                            lo_intTotalGPSCnt++;
                        }

                        if (!string.IsNullOrWhiteSpace(lo_strLocation))
                        {
                            lo_strLocation += ",";
                        }
                        else
                        {
                            lo_strStartLocation = $"new daum.maps.LatLng({row.GLAT}, {row.GLNG})";
                            lo_strStartTm       = row.RegDate;
                        }

                        lo_strLocation    += $"new daum.maps.LatLng({row.GLAT}, {row.GLNG})";
                        lo_strEndLocation =  $"new daum.maps.LatLng({row.GLAT}, {row.GLNG})";

                        lo_strEndTm      = row.RegDate;
                        lo_strDriverName = row.DriverName;
                        lo_strDriverCell = row.DriverCell;
                        lo_strCarNo      = row.CarNo;

                        if ((lo_objResGpsList.data.RecordCnt / 2) == lo_intLoop)
                        {
                            strCenterLocation = $"new daum.maps.LatLng({row.GLAT}, {row.GLNG})";
                        }

                        lo_intLoop++;
                    }
                    if (!string.IsNullOrWhiteSpace(lo_strLocation))
                    {
                        lo_arrLocation[lo_intTotalGPSCnt - 1]        = lo_strLocation;
                        lo_arrStartLocation[lo_intTotalGPSCnt - 1]   = lo_strStartLocation;
                        lo_arrStartTm[lo_intTotalGPSCnt - 1]         = lo_strStartTm;
                        lo_arrEndLocation[lo_intTotalGPSCnt - 1]     = lo_strEndLocation;
                        lo_arrEndTm[lo_intTotalGPSCnt - 1]           = lo_strEndTm;
                        lo_arrDriverName[lo_intTotalGPSCnt - 1]      = lo_strDriverName;
                        lo_arrDriverCell[lo_intTotalGPSCnt - 1]      = lo_strDriverCell;
                        lo_arrCarNo[lo_intTotalGPSCnt - 1]           = lo_strCarNo;
                        lo_arrOperationState[lo_intTotalGPSCnt - 1]  = lo_strOperationState;
                        lo_arrOperationStateM[lo_intTotalGPSCnt - 1] = lo_strOperationStateM;
                    }

                    strShowMapStr = "";

                    for (lo_intLoop = 0; lo_intLoop < lo_intTotalGPSCnt; lo_intLoop++)
                    {
                        // 선을 구성하는 좌표 배열입니다. 이 좌표들을 이어서 선을 표시합니다
                        strShowMapStr += $"linePath{lo_intLoop} = [{lo_arrLocation[lo_intLoop]}];";

                        // 지도에 표시할 선을 생성합니다
                        //path : 선을 구성하는 좌표배열 입니다
                        //strokeWeight : 선의 두께 입니다
                        //strokeColor : 선의 색깔입니다.
                        //strokeOpacity : 선의 불투명도입니다. 1에서 0사이의 값이며 0에 가까울수록 투명합니다.
                        //strokeStyle : 선의 스타일입니다.
                        strShowMapStr += $"polyline = new daum.maps.Polyline({{path: linePath{lo_intLoop}, strokeWeight: 4, strokeColor: '#262626',strokeOpacity: 1, strokeStyle: 'solid'}});";

                        // 지도에 선을 표시합니다 
                        strShowMapStr += "polyline.setMap(map);";
                        strShowMapStr += $"var marker{lo_intLoop}, infoWindow{lo_intLoop}, infoWindow_1{lo_intLoop}, endPosition{lo_intLoop}, infoText{lo_intLoop}, infoText1_{lo_intLoop}, mover{lo_intLoop} ;";
                        strShowMapStr += $"endPosition{lo_intLoop} = {lo_arrEndLocation[lo_intLoop]};";
                        strShowMapStr += $"marker{lo_intLoop} = new daum.maps.Marker({{ position:  endPosition{lo_intLoop} }});";
                        strShowMapStr += $"marker{lo_intLoop}.setMap(map);";
                        strShowMapStr += $"infoText{lo_intLoop} = '<div style=\"padding:5px;font-size:13px;font-weight:bold\">기사명 : {lo_arrDriverName[lo_intLoop]}</div><div style=\"padding:0px 0px 5px 5px; font-size:12px\">차량번호 : {lo_arrCarNo[lo_intLoop]} </div><div style=\"padding:0px 0px 5px 5px; font-size:12px\">연락처 : {lo_arrDriverCell[lo_intLoop]} </div><div style=\"padding:0px 0px 10px 5px;font-size:12px\">운행상태 : {lo_arrOperationStateM[lo_intLoop]} </div><div style=\"padding:0px 0px 10px 5px;font-size:12px\">시간 : {lo_arrEndTm[lo_intLoop]} </div>';";
                        strShowMapStr += lo_arrOperationState[lo_intLoop].Equals("2")
                            ? $"infoText1_{lo_intLoop} = '<div style=\"padding:5px;font-size:13px;font-weight:bold;color:red\">차랑정보 : {lo_arrDriverName[lo_intLoop]}<BR>({lo_arrDriverCell[lo_intLoop]})</div>';"
                            : $"infoText1_{lo_intLoop} = '<div style=\"padding:5px;font-size:13px;font-weight:bold;\">차랑정보 : {lo_arrDriverName[lo_intLoop]}<BR>({lo_arrDriverCell[lo_intLoop]})</div>';";
                        strShowMapStr += $"infoWindow{lo_intLoop} = new daum.maps.InfoWindow({{ position: endPosition{lo_intLoop}, content: infoText{lo_intLoop} }});";
                        strShowMapStr += $"infoWindow1_{lo_intLoop} = new daum.maps.InfoWindow({{ position: endPosition{lo_intLoop}, content: infoText1_{lo_intLoop} }});";
                        strShowMapStr += $"mover{lo_intLoop} = new daum.maps.event.addListener(marker{lo_intLoop}, 'mouseover', function(){{ infoWindow{lo_intLoop}.open(map, marker{lo_intLoop}); }});";
                        strShowMapStr += $"mover{lo_intLoop} = new daum.maps.event.addListener(marker{lo_intLoop}, 'mouseout', function(){{ infoWindow{lo_intLoop}.close(); }});";
                        strShowMapStr += $"infoWindow1_{lo_intLoop}.open(map, marker{lo_intLoop});";
                    }

                    strShowMapStr += "var bounds = new daum.maps.LatLngBounds();";

                    for (lo_intLoop = 0; lo_intLoop < lo_intTotalGPSCnt; lo_intLoop++)
                    {
                        strShowMapStr += $"for (var i = 0; i < linePath{lo_intLoop}.length; i++) {{ bounds.extend(linePath{lo_intLoop}[i]); }}";
                        strShowMapStr += "map.setBounds(bounds);";
                    }
                }
                else
                {
                    strCenterLocation  = $"new daum.maps.LatLng({SiteGlobal.LOGIMAN_ADDR_LAT}, {SiteGlobal.LOGIMAN_ADDR_LNG})";
                    strMapErrorMsg     = "GPS 수신 정보가 없습니다.";
                    HidErrorFlag.Value = "Y";
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                                    "CarMapControlDetail",
                                    "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9103);
            }
        }

        protected void DisplayDataGpsNow()
        {
            ReqCarMapList          lo_objReqCarMapList = null;
            ServiceResult<GpsInfo> lo_objResGpsInfo    = null;

            try
            {
                lo_objReqCarMapList = new ReqCarMapList
                {
                    AuthTel = HidDriverCell.Value,
                    YMD     = strYmd.Replace("-", ""),
                    RegDate = string.Empty
                };

                lo_objResGpsInfo = objCarMapDasServices.GetGpsLastLocation(lo_objReqCarMapList);

                if (lo_objResGpsInfo.result.ErrorCode.IsFail())
                {
                    strCenterLocation = $"new daum.maps.LatLng({SiteGlobal.LOGIMAN_ADDR_LAT}, {SiteGlobal.LOGIMAN_ADDR_LNG})";
                    strMapErrorMsg     = "GSP 정보 조회 중 오류가 발생했습니다.";
                    strLocInfo         = "0 Km ";
                    strElapsedTimeInfo = "0 분 ";
                    HidErrorFlag.Value = "Y";
                    return;
                }

                if (lo_objResGpsInfo.data.Exists.Equals("N"))
                {
                    strCenterLocation = $"new daum.maps.LatLng({SiteGlobal.LOGIMAN_ADDR_LAT}, {SiteGlobal.LOGIMAN_ADDR_LNG})";
                    strMapErrorMsg     = "GSP 정보가 존재하지 않습니다.";
                    strLocInfo         = "0 Km ";
                    strElapsedTimeInfo = "0 분 ";
                    HidErrorFlag.Value = "Y";
                    return;
                }

                strCenterLocation = $"new daum.maps.LatLng({lo_objResGpsInfo.data.Lat}, {lo_objResGpsInfo.data.Lng})";
                strMarker         = $"new daum.maps.LatLng({lo_objResGpsInfo.data.Lat}, {lo_objResGpsInfo.data.Lng})";
                strMarkerDt       = lo_objResGpsInfo.data.RegDate;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                                    "CarMapControlDetail",
                                    "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9104);
            }
        }
    }
}