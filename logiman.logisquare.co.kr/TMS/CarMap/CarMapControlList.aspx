<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CarMapControlList.aspx.cs" Inherits="TMS.CarMap.CarMapControlList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/CarMap/Proc/CarMapControlList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#DateFrom").datepicker({
                dateFormat: "yy-mm-dd"
            });
            $("#DateFrom").datepicker("setDate", GetDateToday("-"));

            $("#BtnListSearch").on("click", function () {
                fnMoveToPage(1, 60);
                return;
            });

            //전체차량조회
            $("#BtnAllCarList").on("click", function (e) {
                CallDriverRoadView("", "", "", 2);
                return false;
            });
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidCarNo" />
    <asp:HiddenField runat="server" ID="HidDriverCell" />
    <asp:HiddenField runat="server" ID="HidCarDivType" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                    <asp:DropDownList runat="server" ID="CarDivType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DriverCell" class="type_01" AutoPostBack="false" placeholder="기사휴대폰"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnAllCarList" class="btn_01">전체차량조회</button>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left" style="width:55%;">
                    <h1>차량리스트</h1>
                    <div style="float: left; margin: 2px 0 0 5px;">
                        <strong id="GridResult" style="display: inline-block;"></strong>
                        <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    </div>
                </li>
                <li class="right" style="width:45%; text-align: left;">
                    <h1>오더내역</h1>
                    <div style="float: left; margin: 2px 0 0 5px;">
                        <strong id="GridResult2" style="display: inline-block;"></strong>
                        <strong id="GridDataInfo2" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    </div>
                </li>
            </ul>
            <div class="grid_type_03">
                <div class="left" style="width:55%;">
                    <div id="GPSDriverListGrid"></div>
                </div>
                <div class="right" style="width:45%;">
                    <div id="DriverOrderListGrid"></div>
                </div>
            </div>
        </div>
	</div>
</asp:Content>