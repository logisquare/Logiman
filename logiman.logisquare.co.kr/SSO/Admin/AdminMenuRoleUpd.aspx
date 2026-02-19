<%@ Page Title="" Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="AdminMenuRoleUpd.aspx.cs" Inherits="SSO.Admin.AdminMenuRoleUpd" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" runat="server">
    <script src="/SSO/Admin/Proc/AdminMenuRoleUpd.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidMode" />
    <asp:HiddenField runat="server" ID="hidMenuRoleNo" />

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table id="headtable" class="popup_table">
                    <tr>
                        <td style="width:30%">메뉴 역할명</td>
                        <td><asp:TextBox runat="server" ID="MenuRoleName" Width="98%" CssClass="type_01"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>사용 여부</td>
                        <td><asp:DropDownList runat="server" ID="DDLUseFlag" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                    </tr>
                </table>

                <div style="text-align:center;margin-top:10px;margin-bottom:10px">
                    <ul><li><button type="button" class="btn_01" onclick="javascript:SaveAll();"><asp:Label runat="server" ID="lblMode" style="color:#fff;font-weight:200;font-size:15px"></asp:Label></button></li></ul>
                </div>

                <asp:GridView ID="repList" runat="server" class="popup_table" AutoGenerateColumns="false" EnableViewState="false" OnRowDataBound="OnRowDataBound" DataKeyNames="MenuNo">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <%#Convert.ToInt32(Eval("Depth")).Equals(1) ? ("<span style=\"font-weight:bold\">"+ Server.HtmlEncode(Eval("MenuGroupKindM").ToString())  + " &gt; " + Server.HtmlEncode(Eval("MenuName").ToString()) +"</span>") : "<span style=\"margin-left:30px\">- "+ Server.HtmlEncode(Eval("MenuName").ToString()) +"</span>"%>
                                <%#Convert.ToInt32(Eval("UseStateCode")).Equals(3) || Convert.ToInt32(Eval("UseStateCode")).Equals(4) ? "<span style=\"color:blue\">(팝업)</span>" : "" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <input type="checkbox" name="add" id="add_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:chkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','add');" <asp:Literal ID="addChk" runat="server" EnableViewState="false"/>/>
                                <label for="add_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <input type="checkbox" name="remove" id="remove_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:chkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','remove');" <asp:Literal ID="removeChk" runat="server" EnableViewState="false" /> /> 
                                <label for="remove_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <input type="checkbox" name="all" id="all_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:chkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','all');" <asp:Literal ID="allChk" runat="server"  EnableViewState="false"/> /> 
                                <label for="all_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <input type="checkbox" name="ro" id="ro_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:chkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','ro');" <asp:Literal ID="roChk" runat="server" EnableViewState="false" />/> 
                                <label for="ro_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <input type="checkbox" name="rw" id="rw_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" onclick="javascript:chkRoleType('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','rw');" <asp:Literal ID="rwChk" runat="server" EnableViewState="false" />/> 
                                <label for="rw_<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>_<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>"><span></span></label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
