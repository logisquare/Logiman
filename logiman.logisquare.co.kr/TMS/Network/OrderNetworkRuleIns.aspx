<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderNetworkRuleIns.aspx.cs" Inherits="TMS.Network.OrderNetworkRuleIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Network/Proc/OrderNetworkRuleIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }
       
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidMode" />
    <asp:HiddenField runat="server" ID="RuleSeqNo" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>회원사</th>
                        <td>
                            <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_100p essential"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>고객사명</th>
                        <td>
                            <asp:TextBox runat="server" ID="ClientName" CssClass="type_100p find essential" placeholder="고객사 검색"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="ClientCode"/>
                        </td>
                    </tr>
                    <tr>
                        <th>수정주기(분)</th>
                        <td>
                            <asp:TextBox runat="server" ID="RenewalModMinute" CssClass="type_100p essential OnlyNumber" placeholder="수정주기(분)"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>증액시작시간(분)</th>
                        <td>
                            <asp:DropDownList runat="server" ID="RenewalStartMinute" CssClass="type_100p essential"></asp:DropDownList>
                            
                        </td>
                    </tr>
                    <tr>
                        <th>증액주기(분)</th>
                        <td>
                            <asp:TextBox runat="server" ID="RenewalIntervalMinute" CssClass="type_100p essential OnlyNumber" placeholder="증액주기(분)"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>증액금액</th>
                        <td>
                            <asp:TextBox runat="server" ID="RenewalIntervalPrice" CssClass="type_100p essential OnlyNumber" placeholder="증액금액"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>정보망 종류</th>
                        <td>
                            <asp:DropDownList runat="server" ID="NetworkKind" CssClass="type_100p"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <div style="text-align:center; margin-top:20px;">
                    <button type="button" class="btn_01" id="BtnNetworkRule" onclick="fnNetworkRuleConfirm();">등록</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>