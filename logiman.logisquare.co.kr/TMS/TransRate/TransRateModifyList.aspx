<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="TransRateModifyList.aspx.cs" Inherits="TMS.TransRate.TransRateModifyList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/TransRate/Proc/TransRateModifyList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
    <asp:HiddenField runat="server" ID="TransSeqNo" />
    <asp:HiddenField runat="server" ID="CenterCode" />
    <asp:HiddenField runat="server" ID="RateType" />
    <asp:HiddenField runat="server" ID="RateRegKind" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <asp:TextBox runat="server" ID="CenterName" class="type_01" ReadOnly="True" AutoPostBack="false" placeholder="회원사명"/>
                        <asp:TextBox runat="server" ID="RateTypeM" class="type_01" ReadOnly="True" AutoPostBack="false" placeholder="요율표 구분"/>
                        <asp:TextBox runat="server" ID="FTLFlagM" class="type_01" ReadOnly="True" AutoPostBack="false" placeholder="운송 구분"/>
                        <asp:TextBox runat="server" ID="TransRateName" class="type_01" ReadOnly="True" AutoPostBack="false" placeholder="요율표명"/>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <button type="button" class="btn_02 download" onclick="fnGridExportAs(GridID, 'xlsx', '요율표 수정내역', '요율표 수정내역');">엑셀다운로드</button>
                    </div>
                </div>
                <div class="grid_list">
                    <div id="TransRateModifyListGrid"></div>
			        <div id="page"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>