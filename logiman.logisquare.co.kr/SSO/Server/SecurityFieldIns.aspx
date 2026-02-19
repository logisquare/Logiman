<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="SecurityFieldIns.aspx.cs" Inherits="SSO.Server.SecurityFieldIns" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="./Proc/SecurityFieldIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidMode" />
    <asp:HiddenField runat="server" ID="hidFieldName" />

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table id="maintable" class="popup_table" style="display:none; border-top:0px;">
                    <colgroup>
                        <col style="width:180px"/>
                        <col style="width:auto;"/>
                    </colgroup>
                    <tr>
                        <th style="width:150px"><span style="color:#f00">*</span> 필드명</th>
                        <td class="lft"><asp:TextBox runat="server" ID="FieldName" Width="233px" class="type_01" MaxLength="50" placeholder="필수입력" title="필수입력"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px"><span style="color:#f00">*</span> 마크 문자 개수</th>
                        <td class="lft"><asp:TextBox runat="server" ID="MarkCharCnt" Width="233px" class="type_01" MaxLength="50" placeholder="필수입력" title="필수입력"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px">필드 설명</th>
                        <td class="lft"><asp:TextBox runat="server" ID="FieldDesc" Width="233px" class="type_01" MaxLength="50" placeholder="필드 설명"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px"><span style="color:#f00">*</span> 사용 여부</th>
                        <td class="lft"><asp:DropDownList runat="server" ID="UseFlag" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                    </tr>
                    <tr id="trAdminID">
                        <th style="width:150px">등록자</th>
                        <td class="lft"><asp:Label runat="server" ID="AdminID"></asp:Label></td>
                    </tr>
                    <tr id="trRegDate">
                        <th style="width:150px">등록일</th>
                        <td class="lft"><asp:Label runat="server" ID="RegDate"></asp:Label></td>
                    </tr>
                </table>
            </div>
            <div style="text-align:center;margin-top:10px">
                <ul><li><button type="button" class="btn_01" onclick="javascript:fnInsSecurityField();"><asp:Label runat="server" ID="lblMode" style="color:#fff;font-weight:200;font-size:15px">저장</asp:Label></button></li></ul>
            </div>
        </div>
    </div>
</asp:Content>
