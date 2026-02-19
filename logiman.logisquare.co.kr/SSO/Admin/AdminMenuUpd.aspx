<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminMenuUpd.aspx.cs" Inherits="SSO.Admin.AdminMenuUpd" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" runat="server">
      <script src="/SSO/Admin/Proc/AdminMenuIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
      <script type="text/javascript">
         
      </script>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidMode" />
    <asp:HiddenField runat="server" ID="hidMenuGroupNo" />
    <asp:HiddenField runat="server" ID="hidMenuNo" />
    <asp:HiddenField runat="server" ID="hidMenuSort" />

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table id="maintable" class="popup_table">
                    <colgroup>
                        <col style="width:200px;"/>
                        <col style="width:auto;"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th style="width:30%">메뉴 그룹명</th>
                            <td><asp:Label runat="server" ID="MenuGroupName"></asp:Label></td>
                        </tr>
                        <tr>
                            <th style="width:30%">메뉴 명</th>
                            <td><asp:TextBox runat="server" ID="MenuName" class="type_01" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th style="width:30%">메뉴 링크</th>
                            <td><asp:TextBox runat="server" ID="MenuLink" class="type_01" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th style="width:30%">메뉴 설명</th>
                            <td><asp:TextBox runat="server" ID="MenuDesc" class="type_01" Width="100%"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th style="width:30%">메뉴 유형</th>
                            <td class="lft"><asp:DropDownList runat="server" ID="DDLUseStateCode" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div style="text-align:center;margin-top:10px">
                <ul><li><button type="button" class="btn_01" onclick="javascript:fnInsAdminMenu();"><asp:Label runat="server" ID="lblMode" style="color:#fff;font-weight:200;font-size:15px"></asp:Label></button></li></ul>
            </div>
        </div>
    </div>
</asp:Content>
