<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="AutomaticAgentDetail.aspx.cs" Inherits="MIS.Automatic.AutomaticAgentDetail" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/d3.v4.min.js"></script>
    <script src="/js/lib/billboard.min.js"></script>
    <script src="/MIS/Proc/MISCommon.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/MIS/Automatic/Proc/AutomaticAgentDetail.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <link rel="stylesheet" href="/MIS/css/insight.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <script type="text/javascript">
        $(document).ready(function () {
            $("#BtnSaveExcel").on("click", function () {
                var dtNow = new Date();
                var fileName = "자동운임_담당자별상세_" + dtNow.getHours() + dtNow.getMinutes() + dtNow.getSeconds();
                fnGridExportAs('#AgentChartDetailGrid', 'xlsx', fileName, fileName);
            });
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="DateType" />
    <asp:HiddenField runat="server" ID="DateFrom" />
    <asp:HiddenField runat="server" ID="DateTo" />
    <asp:HiddenField runat="server" ID="CenterCode" />
    <asp:HiddenField runat="server" ID="AgentCode" />
    <asp:HiddenField runat="server" ID="OrderItemCode" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control" style="padding:10px; border-radius:10px;">
                <h1 class="dash_title_02" style="display: inline-block; margin-right: 10px;" id="AgentName" runat="server"></h1>
                <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운</button>
                <div class="gridWrap">
                    <div id="AgentChartDetailGrid"></div>
                </div>
                <div class="char_area">
                    <h1>적용률 현황</h1>
                    <div class="char_list">
                        <div id="AgentDeatilChart" style="width: 100%; height:370px;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>