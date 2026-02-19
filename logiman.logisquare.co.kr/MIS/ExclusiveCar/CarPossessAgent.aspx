<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CarPossessAgent.aspx.cs" Inherits="MIS.ExclusiveCar.CarPossessAgent" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/d3.v4.min.js"></script>
    <script src="/js/lib/billboard.min.js"></script>
    <script src="/MIS/Proc/MISCommon.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/MIS/ExclusiveCar/Proc/CarPossessAgent.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <link rel="stylesheet" href="/MIS/css/insight.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <script>
        $(document).ready(function () {
            $("#AgentName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnSearchData();
                    return;
                }
            });
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="OrderItemCode"/>
    
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To"/>
                <asp:TextBox runat="server" ID="AgentName" class="type_01" AutoPostBack="false" placeholder="담당자"/>
                <button type="button" runat="server" ID="BtnListSearch" onclick="fnSearchData();" class="btn_01">조회</button>

                &nbsp;&nbsp;&nbsp;&nbsp;
                <button type="button" onclick="fnGridExportAs(GridID, 'xlsx', '차량구분별 담당자 실적', '차량구분별 담당자 실적');" class="btn_02 download">엑셀다운로드</button>
            </div>
            <div class="char_area">
                <h1>전담차량 담당별 사용실적</h1>
                <div class="grid_list">
                    <div id="CarPossessChargeListGrid"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
