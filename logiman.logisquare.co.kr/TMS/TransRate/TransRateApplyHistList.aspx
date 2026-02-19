<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="TransRateApplyHistList.aspx.cs" Inherits="TMS.TransRate.TransRateApplyHistList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/TransRate/Proc/TransRateApplyHistList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        .my-column-new {background: #FFEBFE; font-weight: bold; text-align: right;}
        .my-column-new2 {background: #FFEBFE; font-weight: bold;}
        .aui-grid-my-column-right {text-align: right;}
        .my-header-column-new span { color:#ff0000}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="ApplySeqNo" />
    <asp:HiddenField runat="server" ID="CenterCode" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <asp:TextBox runat="server" ID="CenterName" class="type_01" ReadOnly="True" AutoPostBack="false" placeholder="회원사명"/>
                        <asp:TextBox runat="server" ID="ClientName" class="type_01" ReadOnly="True" AutoPostBack="false" placeholder="고객사명"/>
                        <asp:TextBox runat="server" ID="ConsignorName" class="type_01" ReadOnly="True" AutoPostBack="false" placeholder="화주명"/>
                        <asp:TextBox runat="server" ID="OrderItemCodeM" class="type_01" ReadOnly="True" AutoPostBack="false" placeholder="상품"/>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <button type="button" class="btn_02 download" onclick="fnGridExportAs(GridID, 'xlsx', '요율표 적용관리 수정내역', '요율표 적용관리 수정내역');">엑셀다운로드</button>
                    </div>
                </div>
                <div class="grid_list">
                    <div id="TransRateApplyHistListGrid"></div>
			        <div id="page"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>