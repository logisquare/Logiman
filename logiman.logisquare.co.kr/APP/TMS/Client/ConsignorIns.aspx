<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppPopup.Master" AutoEventWireup="true" CodeBehind="ConsignorIns.aspx.cs" Inherits="APP.TMS.Client.ConsignorIns" %>

<asp:Content ID="headscript" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/APP/TMS/Client/Proc/ConsignorIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            if ($("#HidMode").val() === "Insert") {
                $("#PopMastertitle").text("화주 등록");
            } else {
                $("#PopMastertitle").text("화주 수정");
            }
        });
    </script>
</asp:Content>

<asp:Content ID="MainFormPlaceHolder" ContentPlaceHolderID="MainFormPlaceHolder" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="ConsignorCode"/>
    <asp:HiddenField runat="server" ID="HidParam"/>
    <div class="contents" style="padding-top:0px;">
        <div class="data_detail">
            <div class="ins_section">
                <h2>화주정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <span>회원사</span>
                                        <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <span>화주명</span>
                                        <asp:TextBox runat="server" ID="ConsignorName" CssClass="type_01"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>비고</span>
                                        <asp:TextBox TextMode="MultiLine" runat="server" ID="ConsignorNote" CssClass="textarea_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="reg_btn">
                <button type="button" onclick="fnInsConsignor();">등록하기</button>
            </div>
        </div>
    </div>
</asp:Content>