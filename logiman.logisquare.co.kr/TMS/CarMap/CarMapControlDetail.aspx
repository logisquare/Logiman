<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="CarMapControlDetail.aspx.cs" Inherits="TMS.CarMap.CarMapControlDetail" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%=SiteGlobal.KAKAO_APP_KEY%>"></script>  
    
    <script type="text/javascript">
        var map, mapContainer, map, polyline, linePath;

        document.domain = 'cargomanager.co.kr';

        $(document).ready(function () {
            SetInitData();

            mapContainer = document.getElementById('map'), // 지도를 표시할 div 
                mapOption = {
                    center: <%=strCenterLocation%>, // 지도의 중심좌표
                    level: 3 // 지도의 확대 레벨
                };

            map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

            if ($("#HidShowType").val() != "1") {
                $("#trDetailInfo").hide();
            }

            if ($("#HidShowType").val() == "3") {
                ShowGpsMarker();
            } else {
                ShowGpsPolyLine();
            }
        });

        function SetInitData() {
            if ($("#HidErrorFlag").val() == "Y") {
                $("#map").css("display", "none");
                $("#divErrMsg").css("display", "");
            }
            else {
                $("#map").css("display", "");
                $("#divErrMsg").css("display", "none");
            }
        }

        function ShowGpsPolyLine() {
            <%=strShowMapStr%>
        }

        function ShowGpsMarker() {
            mapContainer = document.getElementById('map'), // 지도를 표시할 div 
                mapOption = {
                    center: <%=strMarker%>, // 지도의 중심좌표
                    level: 8 // 지도의 확대 레벨
                };

            map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

            var marker, infoWindow, startPosition, endPosition, infoText;
            startPosition = <%=strMarker%>;
            marker = new daum.maps.Marker({ position: startPosition });
            marker.setMap(map);


            infoText = '<div style="padding:5px;font-size:13px;font-weight:bold">마지막 위치</div><div style="padding-bottom:5px;font-size:11px">시간 : <%=strMarkerDt%></div>';
            infoWindow = new daum.maps.InfoWindow({ position: startPosition, content: infoText });
            infoWindow.open(map, marker);
        }
    </script>

</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="HidErrorFlag"/>
    <asp:HiddenField runat="server" ID="HidShowType"/>
    <asp:HiddenField runat="server" ID="HidDriverCell"/>

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:auto;"/>
                        <col style="width:auto;"/>
                        <col style="width:auto;"/>
                        <col style="width:auto;"/>
                    </colgroup>
                    <tr>
                        <th>차량정보</th>
                        <td style="text-align:left;"><asp:Label runat="server"><%=Server.HtmlEncode(strCarInfo)%></asp:Label></td>
                        <th>조회일자</th>
                        <td style="text-align:left;"><asp:Label runat="server"><%=Server.HtmlEncode(strYmd)%></asp:Label></td>
                    </tr>
                    <tr id="trDetailInfo">
                        <th>이동거리</th>
                        <td style="text-align:left;"><asp:Label runat="server"><%=Server.HtmlEncode(strLocInfo)%></asp:Label></td>
                        <th>총 운행시간</th>
                        <td style="text-align:left;"><asp:Label runat="server"><%=Server.HtmlEncode(strElapsedTimeInfo)%></asp:Label></td>
                    </tr>
                </table>
                <div id="map" class="map_area" style="width:100%; height:680px;">
                </div>
                <div id="divErrMsg" style="display:none;font-size:18px;font-weight:bold;margin-top:10px;text-align:center">
                    <%=Server.HtmlEncode(strMapErrorMsg) %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
