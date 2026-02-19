<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WebInoutReqIns.aspx.cs" Inherits="WEB.Inout.WebInoutReqIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/WEB/Inout/Proc/WebInoutReqIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            if ($("#DisplayMode").val() === "Y") {
                fnDefaultAlert($("#ErrMsg").val(), "warning", "parent.fnCloseCpLayer();");
                return;
            }
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="OrderNo" />
    <asp:HiddenField runat="server" ID="CenterCode" />
    <asp:HiddenField runat="server" ID="OrderClientCode" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <p style="margin-bottom:10px;">* 운송사 에서 오더 접수 완료 시 오더의 수정을 요청할 수 있습니다.</p>
                        <table class="popup_table">
                            <colgroup>
                                <col style="width:180px"/> 
                                <col style="width:auto;"/> 
                                <col style="width:180px"/> 
                            </colgroup>
                            <tr>
                                <th>요청내용</th>
                                <td>
                                    <asp:TextBox TextMode="MultiLine" ID="ChgReqContent" runat="server" style="height:50px; margin-top:0px;" CssClass="special_note" MaxLength="1000" placeholder="요청내용을 입력해주세요."></asp:TextBox>
                                </td>
                                <td style="text-align:center;">
                                    <button type="button" class="btn_01" onclick="fnRequestChgInsConfirm(1);">요청</button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div>
                    <div style="margin-top:20px;">
                        <div id="WebInoutReqInsGrid"></div>
                        <div id="page"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
