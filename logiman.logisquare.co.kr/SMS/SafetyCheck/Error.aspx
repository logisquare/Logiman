<%@ Page Language="C#" MasterPageFile="~/Sms.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="SMS.SafetyCheck.Error" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="wrap">
        <div class="fast_area">
            <div class="top">
                <h2 class="bill_title"><asp:Literal runat="server" ID="MsgTitle"></asp:Literal></h2>
            </div>
            <div class="middle">
                <div style="padding:100px 0; text-align:center;"><img src="/SMS/images/info_icon.png"></div>
                <p style="padding: 0px !important; text-align:center;"><asp:Literal runat="server" ID="Msg"></asp:Literal></p>
            </div>
            <div class="btn_type2">
                <ul>
                    <li style="width: 100%;"><button type="button" class="blue" onclick="fnPopupClose(); return false;">닫기</button></li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>