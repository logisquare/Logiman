<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="PlaceNote.aspx.cs" Inherits="TMS.Common.PlaceNote" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/PlaceNote.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            $(".special_note").focus();

            $("#BtnUpdNote").on("click", function () {
                fnUpdNote();
                return;
            });
        });

        function fnWindowClose() {
            window.close();
        }
    </script>
    <style>
        form { height: auto;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="OrderType"/>
    <asp:HiddenField runat="server" ID="PlaceSeqNo"/>
    <asp:HiddenField runat="server" ID="PlaceType"/>
    <asp:HiddenField runat="server" ID="PlaceName"/>
    <asp:HiddenField runat="server" ID="PlaceAddr"/>
    <asp:HiddenField runat="server" ID="PlaceAddrDtl"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="data_list">
                <h3 id="H3Name" runat="server" style="text-align: center; color:#0074bc;font-weight: bold;font-size: 18px; " ></h3>
            </div>
            <div class="popup_control">
                <h3 class="popup_title" runat="server" id="NoteTitle" style="margin-top: 20px; padding: 0px;font-weight: bold; font-size: 16px; border-left: 5px solid #5674C8; padding-left: 10px; line-height: 120%;" ></h3>
            </div>
            <div runat="server" id="DivDomestic" Visible="False">
                <textarea class="special_note" runat="server" id="PlaceRemark1" style="height: 280px;"></textarea>
            </div>
            <div runat="server" id="DivInout" Visible="False">
                <h2> ▶ 수입</h2>
                <textarea class="special_note" runat="server" id="PlaceRemark2" style="height: 130px;"></textarea>
                <h2> ▶ 수출</h2>
                <textarea class="special_note" runat="server" id="PlaceRemark3" style="height: 130px;"></textarea>
            </div>
            <div runat="server" id="DivContainer" Visible="False">
                <textarea class="special_note" runat="server" id="PlaceRemark4" style="height: 280px;"></textarea>
            </div>
            <div style="text-align:center;margin-top:20px">
                <button type="button" class="btn_03" onclick="fnWindowClose();">닫기</button>
                &nbsp;&nbsp;
                <button type="button" class="btn_01" id="BtnUpdNote">저장</button>
            </div>
        </div>
    </div>
</asp:Content>
