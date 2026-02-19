<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ServerIPIns.aspx.cs" Inherits="SSO.Server.ServerIPIns" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="./Proc/ServerIPIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidMode" />
    <asp:HiddenField runat="server" ID="hidServerType" />
    <asp:HiddenField runat="server" ID="hidCenterCode" />
    <asp:HiddenField runat="server" ID="hidAllowIPAddr" />

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table id="maintable" class="popup_table" style="display:none; border-top:0px;">
                    <colgroup>
                        <col style="width:180px"/>
                        <col style="width:auto;"/>
                    </colgroup>
                    <tr>
                        <th style="width:150px"><span style="color:#f00">*</span> 서버 유형</th>
                        <td class="lft"><asp:DropDownList runat="server" ID="ServerType" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                    </tr>
                    <tr id="trCenterCode">
                        <th><span style="color:#f00">*</span> 운송사</th>
                        <td class="lft"><asp:DropDownList runat="server" ID="CenterCode" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <th style="width:150px"><span style="color:#f00">*</span> IP</th>
                        <td class="lft"><asp:TextBox runat="server" ID="AllowIPAddr" Width="233px" class="type_01" MaxLength="50" placeholder="필수입력" title="필수입력"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px">IP 설명</th>
                        <td class="lft"><asp:TextBox runat="server" ID="AllowIPDesc" Width="233px" class="type_01" MaxLength="50" placeholder="IP 설명"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px"><span style="color:#f00">*</span> 사용 여부</th>
                        <td class="lft"><asp:DropDownList runat="server" ID="UseFlag" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                    </tr>
                </table>
            </div>
            <div style="text-align:center;margin-top:10px">
                <ul><li><button type="button" class="btn_01" onclick="javascript:fnInsServerIP();"><asp:Label runat="server" ID="lblMode" style="color:#fff;font-weight:200;font-size:15px">저장</asp:Label></button></li></ul>
            </div>
        </div>
    </div>
</asp:Content>
