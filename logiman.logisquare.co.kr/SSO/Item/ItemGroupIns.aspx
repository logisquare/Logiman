<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ItemGroupIns.aspx.cs" Inherits="SSO.Item.ItemGroupIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Item/Proc/ItemGroupIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidMode" />

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table id="maintable" class="popup_table" style="border-top:0px;">
                    <colgroup>
                        <col style="width:180px"/>
                        <col style="width:auto;"/>
                    </colgroup>
                    <tr>
                        <th style="width:150px"><span style="color:#f00">*</span> 그룹코드</th>
                        <td class="lft"><asp:TextBox runat="server" ID="GroupCode" Width="100" class="type_01 onlyAlphabet" MaxLength="2" placeholder="필수입력" title="필수입력" AutoPostBack="false"/></td>
                    </tr>
                    <tr>
                        <th style="width:150px"><span style="color:#f00">*</span> 그룹명</th>
                        <td class="lft"><asp:TextBox runat="server" ID="GroupName" Width="500" class="type_01" MaxLength="50" placeholder="필수입력" title="필수입력" AutoPostBack="false"/></td>
                    </tr>
                    <tr>
                        <th style="width:150px">회원사별 설정 여부</th>
                        <td class="lft"><asp:DropDownList runat="server" ID="CenterFlag" class="type_01" AutoPostBack="false"/></td>
                    </tr>
                    <tr>
                        <th style="width:150px">사용자별 설정 여부</th>
                        <td class="lft"><asp:DropDownList runat="server" ID="AdminFlag" class="type_01" AutoPostBack="false"/></td>
                    </tr>
                </table>
            </div>
            <div style="text-align:center;margin-top:10px">
                <ul><li><button type="button" class="btn_01" onclick="javascript:fnInsItemGroup();"><asp:Label runat="server" ID="lblMode" style="color:#fff;font-weight:200;font-size:15px">저장</asp:Label></button></li></ul>
            </div>
        </div>
    </div>
</asp:Content>
