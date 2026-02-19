<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="AdminMenuAccessUpd.aspx.cs" Inherits="SSO.Admin.AdminMenuAccessUpd" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    
    <script src="/SSO/Admin/Proc/AdminMenuAccessUpd.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>

    <style>
        div.popup_control table.popup_table {border-top:0px;}
        div.popup_control table.popup_table tbody th {position:sticky; top:0px; z-index:10; text-align: center;}
        div#divAccessList {height:656px; overflow-y:auto; border-top:2px solid #e1e6ea;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidMode" />
    <asp:HiddenField runat="server" ID="hidAdminID" />
    <asp:HiddenField runat="server" ID="hidGradeCode" />
    
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="menu_header">
                    <table id="headtable" class="popup_table">
                        <tr>
                            <th style="width:30%">관리자 아이디</th>
                            <td><asp:Label runat="server" ID="AdminID"></asp:Label></td>
                        </tr>
                        <tr>
                            <th style="width:30%">접근 방법</th>
                            <td>
                            <asp:RadioButton ID="AccessTypeMenu" runat="server" GroupName="AccessType" Checked="true" onclick="javascript:fnToggleMenu('1');" />
                            <label for="AccessTypeMenu"><span></span>개별 메뉴</label>
                            <asp:RadioButton ID="AccessTypeRole" runat="server" GroupName="AccessType" onclick="javascript:fnToggleMenu('2');" />
                            <label for="AccessTypeRole"><span></span> 메뉴 역할</label>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align:center;margin-top:10px;margin-bottom:10px">
                        <ul><li><button type="button" class="btn_01" id="BtnSaveAll" onclick="javascript:fnSaveAll();"></button></li></ul>
                    </div>
                </div>
                <div id="divAccessList">
                    <asp:GridView ID="repAccessList" runat="server" class="popup_table" AutoGenerateColumns="false" EnableViewState="false" OnRowDataBound="OnRowDataBound_AccessList" DataKeyNames="MenuNo">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%#Convert.ToInt32(Eval("Depth")).Equals(1) ? "<span style=\"font-weight:bold\">"+ Server.HtmlEncode(Eval("MenuName").ToString()) +"</span>" : "<span style=\"margin-left:30px\">- "+Eval("MenuName")+"</span>"%>
                                    <%#Convert.ToInt32(Eval("UseStateCode")).Equals(3) || Convert.ToInt32(Eval("UseStateCode")).Equals(4) ? "<span style=\"color:blue\">(팝업)</span>" : "" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <input type="checkbox" name="add" id="add_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:fnChkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','add');" <asp:Literal ID="addChk" runat="server" EnableViewState="false"/> />
                                    <label for="add_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <input type="checkbox" name="remove" id="remove_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:fnChkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','remove');" <asp:Literal ID="removeChk" runat="server" EnableViewState="false" /> />
                                    <label for="remove_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <input type="checkbox" name="all" id="all_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:fnChkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','all');" <asp:Literal ID="allChk" runat="server"  EnableViewState="false"/> />
                                    <label for="all_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <input type="checkbox" name="rw" id="rw_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:fnChkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','rw');" <asp:Literal ID="rwChk" runat="server" EnableViewState="false" /> />
                                    <label for="rw_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <input type="checkbox" name="ro" id="ro_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:fnChkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','ro');" <asp:Literal ID="roChk" runat="server" EnableViewState="false" /> />
                                    <label for="ro_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <div id="divRoleList" style="display:none">
                    <asp:GridView ID="repRoleList" runat="server" class="popup_table" AutoGenerateColumns="false" EnableViewState="false" OnRowDataBound="OnRowDataBound_RoleList" DataKeyNames="MenuRoleNo">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Server.HtmlEncode(Eval("MenuRoleName").ToString())%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <input type="checkbox" name="addrole" id="addrole_<%# Server.HtmlEncode(Eval("MenuRoleNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuRoleNo").ToString())%>" <asp:Literal ID="addRollChk" runat="server" EnableViewState="false"/> />
                                    <label for="addrole_<%# Server.HtmlEncode(Eval("MenuRoleNo").ToString())%>"><span></span></label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <input type="checkbox" name="removerole" id="removerole_<%# Server.HtmlEncode(Eval("MenuRoleNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuRoleNo").ToString())%>" <asp:Literal ID="removeRollChk" runat="server" EnableViewState="false"/> />
                                    <label for="removerole_<%# Server.HtmlEncode(Eval("MenuRoleNo").ToString())%>"><span></span></label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>