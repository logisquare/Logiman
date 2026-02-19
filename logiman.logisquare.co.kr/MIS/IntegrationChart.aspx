<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IntegrationChart.aspx.cs" Inherits="MIS.IntegrationChart" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/d3.v4.min.js"></script>
    <script src="/js/lib/billboard.min.js"></script>
    <script src="/MIS/Proc/MISCommon.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/MIS/Proc/IntegrationChart.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <link rel="stylesheet" href="/MIS/css/insight.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <script>
        $(document).ready(function () {
            $("#BtnListSearch").on("click", function () {
                if ($("#CenterCode").val() === "") {
                    fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                } else {
                    fnCallDataList(1);
                    return;
                }
            });

            $("#DateType").on("change", function () {
                if ($(this).val() === "D") {
                    $("#DateMonth").show();
                } else {
                    $("#DateMonth").hide();
                }
            });

            $("#BtnSaveExcel").on("click", function () {
                var ItemCode = [];
                var strCallType = "";
                var SearchYMD = "";

                if ($("#DateType").val() === "M") {
                    intTIckCount = 12;
                    SearchYMD = $("#DateYear").val();
                    strCallType = "IntegrationChartMonthlyExcelList";
                } else {
                    intTIckCount = 31;
                    SearchYMD = $("#DateYear").val() + $("#DateMonth").val();
                    strCallType = "IntegrationChartDailyExcelList";
                }

                $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() !== "") {
                        ItemCode.push($(el).val());
                    }
                });

                var objParam = {
                    CallType: strCallType,
                    CenterCode: $("#CenterCode").val(),
                    ClientName: $("#ClientName").val(),
                    SearchYMD: SearchYMD,
                    OrderItemCodes: ItemCode.join(","),
                    AgentName: $("#AgentName").val(),
                    DateType: $("#DateType").val()
                };

                $.fileDownload("/MIS/Proc/MisStatHandler.ashx", {
                    httpMethod: "POST",
                    data: objParam,
                    prepareCallback: function () {
                        UTILJS.Ajax.fnAjaxBlock();
                    },
                    successCallback: function (url) {
                        $.unblockUI();
                        fnDefaultAlert("엑셀을 다운로드 하였습니다.", "success");
                    },
                    failCallback: function (html, url) {
                        console.log(url);
                        console.log(html);
                        $.unblockUI();
                        fnDefaultAlert("나중에 다시 시도해 주세요.");
                    }
                });
            });
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                <div id="DivOrderItemCode" class="DivSearchConditions">
                    <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                </div>
                <asp:TextBox runat="server" ID="ClientName" class="type_01" AutoPostBack="false" placeholder="고객사"/>
                <asp:TextBox runat="server" ID="AgentName" class="type_01" AutoPostBack="false" placeholder="담당자"/>
                <asp:DropDownList runat="server" ID="DateType" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateYear" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateMonth" CssClass="type_01" AutoPostBack="false" style="display:none;"></asp:DropDownList>
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
                &nbsp;&nbsp;
                <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운</button>
            </div>
            <div class="char_area">
                <h1>매출(월별/누적)</h1>
                <div class="char_list">
                    <div class="left">
                        <div id="div_chart_sales" style="width: 100%; height:370px;"></div>
                    </div>
                    <div class="right">
                        <div id="div_chart_sales_cumulative" style="width: 100%; height:370px;"></div>
                    </div>
                </div>

                <h1>이익(월별/누적)</h1>
                <div class="char_list">
                    <div class="left">
                        <div id="div_chart_profit" style="width: 100%; height:370px;"></div>
                    </div>
                    <div class="right">
                        <div id="div_chart_profit_cumulative" style="width: 100%; height:370px;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
