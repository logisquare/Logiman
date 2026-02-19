<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CarPossessPerformance.aspx.cs" Inherits="MIS.ExclusiveCar.CarPossessPerformance" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/d3.v4.min.js"></script>
    <script src="/js/lib/billboard.min.js"></script>
    <script src="/MIS/Proc/MISCommon.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/MIS/ExclusiveCar/Proc/CarPossessPerformance.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <link rel="stylesheet" href="/MIS/css/insight.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <style>
        .bb-chart-arc text { fill: #fff; font-weight: bold;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="OrderItemCode"/>
    
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateYear" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateMonth" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                
                <button type="button" runat="server" ID="BtnListSearch" onclick="fnSearchData();" class="btn_01">조회</button>
            </div>
            <div class="char_area">
                <h1>차량 사용 실적</h1>
                <div class="char_list" style="height: 360px;">
                    <ul class="chart_triple">
                        <li>
                            <h2 class="tc">오더 건수</h2>
                            <div id="OrderCountChart"></div>
                        </li>
                        <li>
                            <h2 class="tc">매출</h2>
                            <div id="SalesChart"></div>
                        </li>
                        <li>
                            <h2 class="tc">매입</h2>
                            <div id="PurchaseChart"></div>
                        </li>
                    </ul>
                </div>
                <h1>전담차량 사용 실적</h1>
                <div class="char_list">
                    <div class="left">
                        <h2 class="tc">매출 이익</h2>
                        <div id="SalesProfitChart"></div>
                    </div>
                    <div class="right">
                        <h2 class="tc">수익률</h2>
                        <div id="ProfitRateChart" style="width: 800px;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
