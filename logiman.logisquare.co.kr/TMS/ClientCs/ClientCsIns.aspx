<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ClientCsIns.aspx.cs" Inherits="TMS.ClientCs.ClientCsIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClientCs/Proc/ClientCsIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }       
    </script>
    <style>
        .TbListWrapper{height: 400px; overflow: auto;}
        #TbList {}
        #TbList thead {position: sticky; top: 0px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidMode" />
    <asp:HiddenField runat="server" ID="CsSeqNo" />
    <asp:HiddenField runat="server" ID="GradeCode" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>회원사</th>
                        <td>
                            <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01"></asp:DropDownList>
                        </td>
                        <th>고객사명</th>
                        <td>
                            <asp:HiddenField runat="server" ID="ClientCode" />
                            <asp:TextBox runat="server" ID="ClientName" CssClass="type_02 find" placeholder="고객사 검색"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>담당구분</th>
                        <td>
                            <asp:DropDownList runat="server" ID="CsAdminType" CssClass="type_01"></asp:DropDownList>
                        </td>
                        <th>담당자명</th>
                        <td>
                            <asp:HiddenField runat="server" ID="CsAdminID" />
                            <asp:HiddenField runat="server" ID="CsAdminName" />
                            <asp:TextBox runat="server" ID="AdminName" CssClass="type_01 find" placeholder="담당자명 검색"></asp:TextBox>
                        </td>
                    </tr>
                    <tr id="TrDetail" style="display:none;">
                        <th>상품</th>
                        <td>
                            <asp:DropDownList runat="server" ID="OrderItemCode" CssClass="type_01"></asp:DropDownList>
                        </td>
                        <th>사업장</th>
                        <td>
                            <asp:DropDownList runat="server" ID="OrderLocationCode" CssClass="type_01"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <div style="text-align:center; margin:20px 0; ">
                    <button type="button" class="btn_01" onclick="fnClientCsInsConfirm();">추가</button>
                    <button type="button" class="btn_03" onclick="fnClientCsReset();">다시입력</button>
                </div>
                <div class="TbListWrapper">
                    <table class="popup_table" id="TbList">
                        <colgroup>
                            <col style="width:40%;"/>
                            <col style="width:20%;"/>
                            <col style="width:15%;"/>
                            <col style="width:15%;"/>
                            <col style="width:10%;"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th>고객사명(필터)</th>
                                <th>담당구분(필터)</th>
                                <th>상품(필터)</th>
                                <th>사업장(필터)</th>
                                <th>삭제</th>
                            </tr>
                        </thead>
                        <tbody id="ClientCsAddList">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>