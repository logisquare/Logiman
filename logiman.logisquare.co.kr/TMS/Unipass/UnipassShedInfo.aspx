<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="UnipassShedInfo.aspx.cs" Inherits="TMS.Unipass.UnipassShedInfo" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Unipass/Proc/UnipassShedInfo.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="shedSgn" />
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control" style="padding-bottom: 30px;">
                <h1 class="title">장치장 정보</h1>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>장치장명</th>
                        <td>
                            <asp:Label runat="server" ID="snarNm"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td>
                            <asp:Label runat="server" ID="snarAddr"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td>
                            <asp:Label runat="server" ID="snartelno"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>FAX 번호</th>
                        <td>
                            -
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
