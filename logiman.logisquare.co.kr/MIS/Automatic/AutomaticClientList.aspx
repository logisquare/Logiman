<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AutomaticClientList.aspx.cs" Inherits="MIS.Automatic.AutomaticClientList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/d3.v4.min.js"></script>
    <script src="/js/lib/billboard.min.js"></script>
    <script src="/MIS/Automatic/Proc/AutomaticClientList.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        
        $(document).ready(function () {
            $("#BtnListSearch").on("click", function () {
                if ($("#CenterCode").val() === "") {
                    fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                    return;
                }
                if ($("#DateFrom").val() > $("#DateTo").val()) {
                    fnDefaultAlert("조회 종료 시간은 조회 시작 시간보다 이전일 수 없습니다.", "warning");
                    return;
                }
                if ($("#DateType").val() === "M") {
                    if (fnGetMonthTerm($("#DateFrom").val() + "-01", $("#DateTo").val() + "-01") > 24) {
                        fnDefaultAlert("조회 기간은 2년 이하로만 설정 가능합니다.", "warning");
                        return;
                    }
                } else {
                    if (fnGetDateTerm($("#DateFrom").val(), $("#DateTo").val()) > 60) {
                        fnDefaultAlert("조회 기간은 60일 이하로만 설정 가능합니다.", "warning");
                        return;
                    }
                }

                fnCallData();
                return;
            });

            $("#BtnSaveExcel").on("click", function () {
                var dtNow = new Date();
                var fileName = "자동운임_고객사별현황_" + dtNow.getHours() + dtNow.getMinutes() + dtNow.getSeconds();
                fnGridExportAs('#ClientChartGrid', 'xlsx', fileName, fileName);
            });
        });
    </script>
    <style>
        .my_a_tag {color:#0094ff; font-weight:500; text-decoration:underline !important;}
        .aui-grid-my-column-right {text-align:right;}
        .grid-header-holiday-color div span {color:red !important;}
        .ui-datepicker-div-hide-days table {display: none;}
        .ui-datepicker .ui-datepicker-buttonpane button.ui-datepicker-current { display: none; }
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
                <asp:DropDownList runat="server" ID="DateType" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From" autocomplete="off"/>
                <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To" autocomplete="off"/>
                <asp:TextBox runat="server" ID="ClientName" class="type_01" AutoPostBack="false" placeholder="고객사"/>
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
                <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운</button>
            </div>
            <div class="char_area">
                <h1>고객사 매출-이익</h1>
                <div class="char_list">
                    <div class="gridWrap">
                        <div id="ClientChartGrid"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
