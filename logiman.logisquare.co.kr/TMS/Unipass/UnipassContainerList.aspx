<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="UnipassContainerList.aspx.cs" Inherits="TMS.Unipass.UnipassContainerList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Unipass/Proc/UnipassContainerList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="cargMtNo" />
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control" style="padding-bottom: 30px;">
                <h1 class="title">컨테이너 내역</h1>
                <div class="grid_list">
                    <div id="UnipassContainerListGrid"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
