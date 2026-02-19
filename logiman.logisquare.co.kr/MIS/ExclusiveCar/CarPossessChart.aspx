<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CarPossessChart.aspx.cs" Inherits="MIS.ExclusiveCar.CarPossessChart" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/d3.v4.min.js"></script>
    <script src="/js/lib/billboard.min.js"></script>
    <script src="/MIS/Proc/MISCommon.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/MIS/ExclusiveCar/Proc/CarPossessChart.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <link rel="stylesheet" href="/MIS/css/insight.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <style>
        .bb-chart-arc text { fill: #fff; font-weight: bold;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateYear" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateMonth" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                
                <button type="button" runat="server" ID="BtnListSearch" onclick="fnSearchData();" class="btn_01">조회</button>
            </div>
            <div class="char_area">
                <div class="char_list">
                    <div class="left" style="padding-top: 0px;">
                        <h1>전담차량 보유 현황</h1>
                        <div id="CarPossessPieChart" class="grid_body" style="width: 100%; height:370px;"></div>
                    </div>
                    <div class="right" style="padding-top: 0px;">
                        <h1>전담차량 월별 현황</h1>
                        <div id="CarPossessLineChart" class="grid_body" style="width: 100%; height:370px;"></div>
                    </div>
                </div>

                <h1>전담차량 보유 상세 현황</h1>
                <div class="grid_list">
                    <div id="CarPossessListGrid"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
