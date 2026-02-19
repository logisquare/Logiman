<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="CargopassError.aspx.cs" Inherits="TMS.Cargopass.CargopassError" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <style>
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="iframe_wrap">
        <div style="width: 600px; height: 500px; position: absolute; top: 50%; left: 50%; margin-left: -300px; margin-top: -250px;  padding: 10px;">
            <div class="middle">
                <div style="margin:100px 0; text-align:center;"><img src="/SMS/images/info_icon.png"></div>
                <div style="text-align:center; font-size:20px; font-weight: 700;">서비스 이용 불가 안내</div>
                <p style="padding:50px 0; text-align:center; font-size:20px;"><asp:Literal runat="server" ID="Msg"></asp:Literal></p>
            </div>
        </div>
    </div>
</asp:Content>
