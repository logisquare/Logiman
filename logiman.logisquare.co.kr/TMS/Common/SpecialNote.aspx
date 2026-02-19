<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="SpecialNote.aspx.cs" Inherits="TMS.Common.SpecialNote" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/SpecialNote.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
    <asp:HiddenField runat="server" ID="Type"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="ClientCode"/>
    <asp:HiddenField runat="server" ID="ConsignorCode"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="data_list">
                <h3 id="H3Name" style="text-align: center; color:#0074bc;font-weight: bold;font-size: 18px; " ></h3>
            </div>
            <div class="popup_control">
                <h3 class="popup_title" runat="server" id="NoteTitle" style="margin-top: 20px; padding: 0px;font-weight: bold; font-size: 16px; border-left: 5px solid #5674C8; padding-left: 10px; line-height: 120%;" ></h3>
                <textarea class="special_note" runat="server" id="Note" style="height: 280px;"></textarea>
            </div>
            <div style="text-align:center;margin-top:20px">
                <button type="button" class="btn_03" onclick="fnWindowClose();">닫기</button>
                &nbsp;&nbsp;
                <button type="button" class="btn_01" id="BtnUpdNote">저장</button>
            </div>
        </div>
    </div>
</asp:Content>
