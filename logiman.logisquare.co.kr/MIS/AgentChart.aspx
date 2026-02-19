<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AgentChart.aspx.cs" Inherits="MIS.AgentChart" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/d3.v4.min.js"></script>
    <script src="/js/lib/billboard.min.js"></script>
    <script src="/MIS/Proc/AgentChart.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        var tableColListJson = [];

        $(document).ready(function () {
            fnDateTypeChange();
            $("#BtnListSearch").on("click", function () {
                if ($("#CenterCode").val() === "") {
                    fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                } else {
                    fnCallData();
                    return;
                }
            });

            $("#BtnSaveExcel").on("click", function () {
                var dtNow = new Date();
                var fileName = "경영정보_담당자별내역_" + dtNow.getHours() + dtNow.getMinutes() + dtNow.getSeconds();
                fnGridExportAs('#AgentChartGrid', 'xlsx', fileName, fileName);
            });
        });

        function fnDateTypeChange() {
            $("#DateType").on("change", function () {
                if ($(this).val() === "D") {
                    $("#DateMonth").show();
                    dataKeyColumn = "D";
                    barMaxWidth = 10;
                } else {
                    $("#DateMonth").hide();
                    dataKeyColumn = "M";
                    barMaxWidth = 20;
                }
            });
        }
    </script>
    <style>
        .my_a_tag {color:#0094ff; font-weight:500; text-decoration:underline !important;}
        .aui-grid-my-column-right {text-align:right;}
        .grid-header-holiday-color div span {color:red !important;}
    </style>
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
                <asp:TextBox runat="server" ID="AgentName" class="type_01" AutoPostBack="false" placeholder="담당자"/>
                <asp:DropDownList runat="server" ID="DateType" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateYear" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateMonth" CssClass="type_01" AutoPostBack="false" style="display:none;"></asp:DropDownList>
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
                <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운</button>
            </div>
            <div class="char_area">
                <h1>담당자 매출-이익</h1>
                <div class="char_list">
                    <div class="gridWrap">
                        <div id="AgentChartGrid"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
