<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AutomaticChart.aspx.cs" Inherits="MIS.Automatic.AutomaticChart" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/d3.v4.min.js"></script>
    <script src="/js/lib/billboard.min.js"></script>
    <script src="/MIS/Proc/MISCommon.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/MIS/Automatic/Proc/AutomaticChart.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <link rel="stylesheet" href="/MIS/css/insight.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <script>
        $(document).ready(function () {
            $("#SearchText").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnSearchData();
                    return;
                }
            });
        });
    </script>
    <style>
        .bb-chart-arc text { fill: #000 !important; font-weight: bold;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="OrderItemCode"/>
    <asp:HiddenField runat="server" ID="PreMonFromYMD"/>
    <asp:HiddenField runat="server" ID="PreMonToYMD"/>
    
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To"/>
                <asp:DropDownList runat="server" ID="SearchType" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="SearchText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                <button type="button" runat="server" ID="BtnListSearch" onclick="fnSearchData();" class="btn_01">조회</button>
            </div>
            <div class="char_area">
                <h1>자동운임 전체 적용현황 <button type="button" onclick="fnChartLayerMove(1, this);"><img src="/images/icon/up_arr.png" class="img1" style="width: 30px;"/></button></h1>
                <ul class="auto_chart_ul sec1">
                    <li>
                        <dl>
                            <dt class="SelectedDate"></dt>
                            <dd id="RateTextData"></dd>
                        </dl>
                        <div id="PieChartSelectedDate"></div>
                    </li>
                    <li>
                        <dl>
                            <dt class="preWDate"></dt>
                        </dl>
                        <div id="PieChartLastWeekDate"></div>
                    </li>
                    <li>
                        <dl>
                            <dt class="preMDateSearch"></dt>
                        </dl>
                        <div id="PieChartLastMonthDate"></div>
                    </li>
                </ul>
            </div>
            
            <div class="char_area">
                <h1>자동운임 전체 오더현황 <button type="button" onclick="fnChartLayerMove(2, this);"><img src="/images/icon/up_arr.png" class="img2" style="width: 30px;"/></button></h1>
                <ul class="auto_chart_ul sec2">
                    <li>
                        <dl>
                            <dt class="SelectedDate"></dt>
                            <dd id="BarRateTextData"></dd>
                        </dl>
                        <div id="BarChartSelectedDate" style="margin-top: 20px;"></div>
                        <div class="rate_data rate_data1"></div>
                    </li>
                    <li>
                        <dl>
                            <dt class="preWDate"></dt>
                        </dl>
                        <div id="BarChartLastWeekDate"></div>
                        <div class="rate_data rate_data2"></div>
                    </li>
                    <li>
                        <dl>
                            <dt class="preMDate"></dt>
                        </dl>
                        <div id="BarChartLastMonthDate"></div>
                        <div class="rate_data rate_data3"></div>
                    </li>
                </ul>
            </div>
            
            <div class="char_area">
                <h1>자동운임 적용 오더현황 <button type="button" onclick="fnChartLayerMove(3, this);"><img src="/images/icon/up_arr.png" class="img3" style="width: 30px;"/></button></h1>
                <ul class="auto_chart_ul sec3">
                    <li>
                        <dl>
                            <dt class="SelectedDate"></dt>
                            <dd id="BarAppliedRateTextData"></dd>
                        </dl>
                        <div id="BarChartAppliedSelectedDate"></div>
                        <div class="rate_applied_data1"></div>
                    </li>
                    <li>
                        <dl>
                            <dt class="preWDate"></dt>
                        </dl>
                        <div id="BarChartAppliedLastWeekDate"></div>
                        <div class="rate_applied_data2"></div>
                    </li>
                    <li>
                        <dl>
                            <dt class="preMDate"></dt>
                        </dl>
                        <div id="BarChartAppliedLastMonthDate"></div>
                        <div class="rate_applied_data3"></div>
                    </li>
                </ul>
            </div>
            
            <div class="char_area">
                <h1>자동운임 미적용 오더현황 <button type="button" onclick="fnChartLayerMove(4, this);"><img src="/images/icon/up_arr.png" class="img4" style="width: 30px;"/></button></h1>
                <ul class="auto_chart_ul sec4">
                    <li>
                        <dl>
                            <dt class="SelectedDate"></dt>
                            <dd id="BarUnAppliedRateTextData"></dd>
                        </dl>
                        <div id="BarChartUnAppliedSelectedDate"></div>
                        <div class="rate_unapplied_data1"></div>
                    </li>
                    <li>
                        <dl>
                            <dt class="preWDate"></dt>
                        </dl>
                        <div id="BarChartUnAppliedLastWeekDate"></div>
                        <div class="rate_unapplied_data2"></div>
                    </li>
                    <li>
                        <dl>
                            <dt class="preMDate"></dt>
                        </dl>
                        <div id="BarChartUnAppliedLastMonthDate"></div>
                        <div class="rate_unapplied_data3"></div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>
