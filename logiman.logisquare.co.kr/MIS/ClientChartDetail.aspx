<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ClientChartDetail.aspx.cs" Inherits="MIS.ClientChartDetail" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/d3.v4.min.js"></script>
    <script src="/js/lib/billboard.min.js"></script>
    <script src="/MIS/Proc/MISCommon.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/MIS/Proc/ClientChartDetail.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <link rel="stylesheet" href="/MIS/css/insight.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <script type="text/javascript">
        var tableColListJson = [];
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="CenterCode" />
    <asp:HiddenField runat="server" ID="ClientCode" />
    <asp:HiddenField runat="server" ID="OrderItemCodes" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control" style="background:#e7eaf0; padding:10px; border-radius:10px;">
                <h1 class="dash_title_02" id="ClientName" runat="server"></h1>
                <div class="data_list">
                    <div class="search" style="text-align:right;">
                        <asp:DropDownList runat="server" ID="DateYear" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                        <button type="button" class="btn_01" onclick="fnCallData();">조회</button>
                    </div>
                </div>
                <div class="gridWrap">
                    <div id="ClientChartDetailGrid"></div>
                </div>
                <div class="char_area">
                    <h1>건수/매출</h1>
                    <div class="char_list">
                        <div class="left">
                            <div id="div_chart_order_count_specific" style="width: 100%; height:370px;"></div>
                        </div>
                        <div class="right">
                            <div id="div_chart_sales_amount_specific" style="width: 100%; height:370px;"></div>
                        </div>
                    </div>

                    <h1>이익/이익률</h1>
                    <div class="char_list">
                        <div class="left">
                            <div id="div_chart_profit_amount_specific" style="width: 100%; height:370px;"></div>
                        </div>
                        <div class="right">
                            <div id="div_chart_return_on_sales_specific" style="width: 100%; height:370px;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>