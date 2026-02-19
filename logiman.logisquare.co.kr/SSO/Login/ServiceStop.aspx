<%@ Page Language="C#" MasterPageFile="~/MemberShip.Master" AutoEventWireup="true" CodeBehind="ServiceStop.aspx.cs" Inherits="logiman.logisquare.co.kr.ServiceStop" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script>
        $(document).ready(function () {
        });

        function goHome() {
            location.href = "/";
        }

    </script>
    <style>
        div#ServiceStop {width:800px; margin:0 auto; padding-top:100px; text-align:center;}
        div#ServiceStop h1 {font-size:52px; text-align:center; font-weight:bold; color:#6782CE; padding:30px 0;}
        div#ServiceStop p {text-align:center; font-size:32px; word-break:keep-all; line-height:1.5;}
        div.btn_area {text-align:center; margin-top:50px;}
        div.btn_area button {background:#6782CE; color:#fff; font-size:30px; height:60px; width:300px; border-radius:10px; font-weight:500;}
    </style>

    <% if(!string.IsNullOrWhiteSpace(SiteGlobal.GA_CODE_WEB)) {%>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=<%=SiteGlobal.GA_CODE_WEB%>"></script>
        <script> window.dataLayer = window.dataLayer || []; function gtag() { dataLayer.push(arguments); } gtag('js', new Date()); gtag('config', '<%=SiteGlobal.GA_CODE_WEB%>');</script>
    <%}%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="ServiceStop">
        <img src="/images/error_img.png"/>
        <h1><%=m_Title %></h1>
        <p>
            <%=m_Contents %>
        </p>
    </div>
    <div class="btn_area">
        <button type="button" onclick="javascript:goHome();">메인</button>
    </div>
</asp:Content>