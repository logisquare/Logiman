using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;

namespace TMS.Wnd
{
    public partial class WmsGpsDetail : PageBase
    {
        public string strMarker = $"new daum.maps.LatLng({SiteGlobal.LOGIMAN_ADDR_LAT}, {SiteGlobal.LOGIMAN_ADDR_LNG})";

        AppGpsDasServices objAppGpsDasServices = new AppGpsDasServices();

        public string strLocInfo         = string.Empty;
        public string strElapsedTimeInfo = string.Empty;
        public string strMarkerDt        = string.Empty;
        public string strCenterLocation  = string.Empty;
        public string strShowMapStr      = string.Empty;
        public string strMapErrorMsg     = string.Empty;
        public string strYMD             = string.Empty;

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
                HidYMD.Value      = SiteGlobal.GetRequestForm("YMD");
                HidMobileNo.Value = SiteGlobal.GetRequestForm("MobileNo");
                strYMD            = HidYMD.Value;

                DisplayDataGPS();
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9101;
                SiteGlobal.WriteLog("WmsGpsDetail", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    lo_intRetVal);
            }
        }

        protected void DisplayDataGPS()
        {
            ReqAppGpsList                lo_objReqAppGpsList = null;
            ServiceResult<ResAppGpsList> lo_objResAppGpsList = null;

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
                lo_objReqAppGpsList = new ReqAppGpsList
                {
                    MobileNo       = HidMobileNo.Value,
                    DateFrom       = HidYMD.Value.Replace("-", ""),
                    DateTo         = HidYMD.Value.Replace("-", ""),
                    MaxLinearMeter = 1000,
                    MaxMinutes     = 600
                };

                lo_objResAppGpsList = objAppGpsDasServices.GetAppGpsList(lo_objReqAppGpsList);

                if (lo_objResAppGpsList.result.ErrorCode.IsFail())
                {
                    strCenterLocation  = $"new daum.maps.LatLng({SiteGlobal.LOGIMAN_ADDR_LAT}, {SiteGlobal.LOGIMAN_ADDR_LNG})";
                    strMapErrorMsg     = "GSP 정보 조회 중 오류가 발생했습니다.";
                    strLocInfo         = "0 Km ";
                    strElapsedTimeInfo = "0 분 ";
                    HidErrorFlag.Value = "Y";

                    return;
                }

                strLocInfo = StringExtensions.ConvertMoneyFormat(lo_objResAppGpsList.data.TotalDistance / 1000) + " Km ";
                strElapsedTimeInfo = lo_objResAppGpsList.data.TotalElapsedTime;

                int lo_intTotalGPSCnt = 1;

                if (lo_objResAppGpsList.data.RecordCnt > 0)
                {
                    foreach (var row in lo_objResAppGpsList.data.list)
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
                            lo_strStartLocation = $"new daum.maps.LatLng({row.GpsLocationLat}, {row.GpsLocationLng})";
                            lo_strStartTm       = row.RegDate;
                        }

                        lo_strLocation    += $"new daum.maps.LatLng({row.GpsLocationLat},{row.GpsLocationLng})";
                        lo_strEndLocation =  $"new daum.maps.LatLng({row.GpsLocationLat}, {row.GpsLocationLng})";
                        lo_strEndTm       =  row.RegDate;


                        if ((lo_objResAppGpsList.data.RecordCnt / 2) == lo_intLoop)
                        {
                            strCenterLocation = $"new daum.maps.LatLng({row.GpsLocationLat}, {row.GpsLocationLng})";
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
                                    "WmsGpsDetail",
                                    "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9102);
            }
        }
    }
}