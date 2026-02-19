<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderDispatchContract.aspx.cs" Inherits="TMS.Dispatch.OrderDispatchContract" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Dispatch/Proc/OrderDispatchContract.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode" />
    <asp:HiddenField runat="server" ID="HidGridID" />
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidDispatchType" />
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>운송사</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="ContractCenterCode"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <dl class="contract">
                    <dt>* 위탁이란?</dt>
                    <dd>
                         운송사가 운송사 또는 차주에게 운송을 의뢰하는 것
                        <ul>
                            <li>
                                - 운송사 &uarr; 운송사 = 위탁
                            </li>
                            <li>
                                - 운송사 &uarr; 차주 = 배차
                            </li>
                        </ul>
                    </dd>
                </dl>
                <div style="text-align:center;margin-top:20px">
                    <button type="button" class="btn_01" id="InsBtn" onclick="fnContractInsConfirm();">위탁</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
