<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminMenuGroupList.aspx.cs" Inherits="SSO.Admin.AdminMenuGroupList" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Admin/Proc/AdminMenuGroupList.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
     <script type="text/javascript">

         function fnChgLeftImage(strObjID, strSelID) {
             var imagepath = "<%= HttpUtility.JavaScriptStringEncode(" / images / common")%>" + "/" + $("#" + strSelID).val();
             if ($("#" + strSelID).val() != "") {
                 $("#" + strObjID).attr("src", imagepath);
             }
             else {
                 $("#" + strObjID).attr("src", "");
             }
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
        
        <div class="grid_list">
          
		 <div id="LIST_VIEW">
            <div class="list_view_body">
            </div>
            <div class="list_control">
                <table id="maintable" class="list_table" style="">
                    <colgroup>
                        <col style="width:150px" />
                        <col style="width:200px" />
                        <col style="" />
                        <col style="" />
                        <col style="" />
                        <col style="" />
                        <col style="" />
                        <col style="" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>메뉴 그룹 구분</th>
                            <th>메뉴 그룹명</th>
                            <th>메뉴 출력 순서</th>
                            <th>출력여부</th>
                            <th>사용여부</th>
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
                                    <input type="hidden" name="menugroupno" id="menugroupno_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>" />
                                    <td>
                                        <select name="menugroupkind" id="menugroupkind_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>"></select>
						                <script type="text/javascript">
                                            fnGetMenuKindDDLB('menugroupkind_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>', <%# Server.HtmlEncode(Eval("MenuGroupKind").ToString())%>);
                                        </script>
                                    </td>
                                    <td>
                                        <input type="text" name="menugroupname" class="type_01" id="menugroupname_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>" value="<%# Server.HtmlEncode(Eval("MenuGroupName").ToString())%>" />
                                    </td>
                                    <td>
                                        <select name="menugroupsort" id="menugroupsort_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>" onchange="fnChgSort('menugroupsort', this, '<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>');"></select>
						                <script type="text/javascript">
                                            fnGetSortDDLB('menugroupsort_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>', <%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>);
                                        </script>
                                    </td>
                                    <td>
										<select name="displayflag" id="displayflag_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>"></select>
						                <script type="text/javascript">
							                fnGetDisplayFlagDDLB('displayflag_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>', '<%# Server.HtmlEncode(Eval("DisplayFlag").ToString())%>');
						                </script>
                                    </td>
                                    <td>
										<select name="useflag" id="useflag_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>"></select>
						                <script type="text/javascript">
							                fnGetUseFlagDDLB('useflag_<%# Server.HtmlEncode(Eval("MenuGroupSort").ToString())%>', '<%# Server.HtmlEncode(Eval("UseFlag").ToString())%>');
                                        </script>
                                    </td>
                                    <td><%# Server.HtmlEncode(Eval("RegDate").ToString())%></td>
                                    <td><%# Server.HtmlEncode(Eval("UpdDate").ToString())%></td>
                                    <td><button type="button" class="ss_type_02" onclick="javascript:fnDelAdminMenuGroup('<%# Server.HtmlEncode(Eval("MenuGroupNo").ToString())%>','<%# Server.HtmlEncode(Eval("MenuGroupName").ToString())%>');">삭제</button></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                        <!-- DISPLAY LIST END -->
                    </tbody>
                </table>
            </div>
            <div style="padding-top:10px;text-align:center">
                <button type="button" class="btn_01" onclick="javascript:fnddRow('main-tbody');">그룹추가</button>
                <button type="button" class="btn_01" onclick="javascript:fnUpdAdminMenuGroup();">확인</button>
            </div>
        </div>
        </div>
	</div>
<script type="text/javascript">
<!--
    fnSetSortDDLB("menugroupsort"); //Sort DDLB를 배열에 저장한다.
    -->
</script>
</asp:Content>