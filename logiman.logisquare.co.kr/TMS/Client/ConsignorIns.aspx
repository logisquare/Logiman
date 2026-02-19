<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ConsignorIns.aspx.cs" Inherits="TMS.Client.ConsignorIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Client/Proc/ConsignorIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        function fnCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
        }
    </script>
    <style>
        #UlClientList {margin-top:5px; margin-left:5px;}
        #UlClientList li {float:left; display:inline-block; padding:3px 5px; background: #5674C8; font-weight:bold; color: #fff; margin-top: 2px; margin-left:5px; border-radius: 3px;}
        #UlClientList li:first-child{ margin-left:0px;}
        #UlClientList li span {float: right; margin-left: 10px; margin-top: 5px; width: 12px; height: 12px; background: url(/images/icon/ctrl_wh_03.png) no-repeat; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="ConsignorCode"/>
    <asp:HiddenField runat="server" ID="ClientCode"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>회원사</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="CenterCode"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <br />
                <table class="popup_table">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="2">화주정보</th>
                        <td>
                            <asp:TextBox runat="server" ID="ConsignorName" CssClass="type_01 essential" placeholder="화주명"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="ConsignorNote" CssClass="type_01" placeholder="비고" Width="100%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr runat="server" id="TrClient">
                        <th>고객사정보</th>
                        <td>
                            <asp:TextBox runat="server" ID="ClientName" CssClass="type_01" placeholder="고객사명 검색"></asp:TextBox>
                            <button type="button" class="btn_01" onclick="fnInsClientConsignor();">추가</button><br/>
                            <ul id="UlClientList"></ul>
                        </td>
                    </tr>
                    <tr runat="server" id="TrUseFlag">
                        <th rowspan="2">사용여부</th>
                        <td>
                            <asp:RadioButton ID="UseFlagY" runat="server" GroupName="UseFlag" value="Y" Checked="true" />
                            <label for="UseFlagY"><span></span>사용중</label>
                            <asp:RadioButton ID="UseFlagN" runat="server" GroupName="UseFlag" value="N" />
                            <label for="UseFlagN"><span></span>사용중지</label>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="text-align:center;margin-top:20px">
                <button type="button" class="btn_03" onclick="fnCloseCpLayer();">닫기</button>
                &nbsp;&nbsp;
                <button type="button" class="btn_01" onclick="fnInsConsignor();">저장</button>
            </div>
        </div>
    </div>
</asp:Content>
