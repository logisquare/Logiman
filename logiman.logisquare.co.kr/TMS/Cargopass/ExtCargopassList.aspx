<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ExtCargopassList.aspx.cs" Inherits="TMS.Cargopass.ExtCargopassList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Cargopass/Proc/ExtCargopassList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        #contents { padding:0 !important;}
        #ExtCargopassList { width:100%; height:99%; padding:0; border:0px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="contents">
        <iframe id="ExtCargopassList" name="ExtCargopassList" src="about:blank"></iframe>
    </div>
</asp:Content>
