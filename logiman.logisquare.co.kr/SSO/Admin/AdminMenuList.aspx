<%@ Page Language="C#" EnableEventValidation="false"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminMenuList.aspx.cs" Inherits="SSO.Admin.AdminMenuList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
     <script src="/SSO/Admin/Proc/AdminMenuList.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
     <script type="text/javascript">
         

         function fnReloadPageNotice(msg) {
             $("#hidDisplayMode").val("Y");
             $("#hidErrMsg").val(msg);
             __doPostBack("", "");
         }

     </script>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" id="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidDisplayMode"/>
    <div id="contents">
        <div class="data_list">
            <div class="search">
               <asp:DropDownList runat="server" ID="DDLMenuGroup" class="type_01" AutoPostBack="false" width="25%"></asp:DropDownList>
            </div>  
        </div>

        <div class="grid_list">
            <div id="ListView" style="display:none">
            <div class="list_control">
                <table id="maintable" class="list_table" style="">
                    <colgroup>
                        <col style="" />
                        <col style="" />
                        <col style="width:100px" />
                        <col style="" />
                        <col style="" />
                        <col style="" />
                        <col style="" />
                        <col style="" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>메뉴명</th>
                            <th>링크</th>
                            <th>출력순서</th>
                            <th>설명</th>
                            <th>상태</th>
                            <th>등록일시</th>
                            <th>수정일시</th>
                            <th>작업</th>
                        </tr>
                    </thead>
                    <tbody id="main-tbody">
                        <!-- DISPLAY LIST START -->
                        <asp:Repeater ID="repList" runat="server" EnableViewState="false">
                            <ItemTemplate>
                                <tr class="tablelist">
                                    <td>
                                        <input type="hidden" name="menuno" id="menuno_<%# Server.HtmlEncode(Eval("MenuSort").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>" />
                                        <%# Server.HtmlEncode(Eval("MenuName").ToString())%>
                                    </td>
                                    <td><%# Server.HtmlEncode(Eval("MenuLink").ToString())%></td>
                                    <td>
                                        <select name="menusort" id="menusort_<%# Server.HtmlEncode(Eval("MenuSort").ToString())%>" onchange="fnChgSort('menusort', this, '<%# Server.HtmlEncode(Eval("MenuSort").ToString())%>');"></select>
						                <script type="text/javascript">
							                fnGetSortDDLB('menusort_<%# Server.HtmlEncode(Eval("MenuSort").ToString())%>', <%# Server.HtmlEncode(Eval("MenuSort").ToString())%>);
						                </script>
                                    </td>
                                    <td><%# Server.HtmlEncode(Eval("MenuDesc").ToString())%></td>
                                    <td>
										<select name="usestatecode" id="usestatecode_<%# Server.HtmlEncode(Eval("MenuSort").ToString())%>"></select>
						                <script type="text/javascript">
							                fnGetUseStateCodeDDLB('usestatecode_<%# Server.HtmlEncode(Eval("MenuSort").ToString())%>', '<%# Server.HtmlEncode(Eval("UseStateCode").ToString())%>');
						                </script>
                                    </td>
                                    <td><%# Server.HtmlEncode(Eval("RegDate").ToString())%></td>
                                    <td><%# Server.HtmlEncode(Eval("UpdDate").ToString())%></td>
                                    <td>
                                        <button type="button" class="ss_type_01" onclick="javascript:fnUpdAdminMenu('메뉴 수정','<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>', '<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>');">조회</button>
                                        <button type="button" class="ss_type_02" onclick="javascript:fnDelAdminMenu('<%# Server.HtmlEncode(Eval("MenuNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuName").ToString())%>');">삭제</button>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                        <!-- DISPLAY LIST END -->
                    </tbody>
                </table>
                <div style="margin-top:10px;text-align:center">
                    <button type="button" class="btn_01" onclick="javascript:fnUpdAdminMenu('메뉴 등록','','');">메뉴추가</button>
                    <button type="button" class="btn_01" onclick="javascript:fnUpdAdminMenuAll();">수정반영</button>
                </div>
            </div>
        </div>
        </div>
		
        
	</div>
<script type="text/javascript">
<!--
    fnSetSortDDLB("menusort"); //Sort DDLB를 배열에 저장한다.
    -->
</script>
</asp:Content>