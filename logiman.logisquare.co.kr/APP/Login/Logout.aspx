<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="APP.Login.Logout" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>
<%@ Import Namespace="CommonLibrary.Constants" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title><%=Server.HtmlEncode(CommonConstant.SITE_TITLE)%></title>

    <% if(!string.IsNullOrWhiteSpace(SiteGlobal.GA_CODE_APP)) {%>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=<%=SiteGlobal.GA_CODE_APP%>"></script>
        <script> window.dataLayer = window.dataLayer || []; function gtag() { dataLayer.push(arguments); } gtag('js', new Date()); gtag('config', '<%=SiteGlobal.GA_CODE_APP%>');</script>
    <%}%>
</head>
<body>
<form runat="server">
    <!-- Loader //-->
    <div id="divLoadingImage" style="display: none;"><img src="/images/common/loader.gif" alt="Loading..." /></div>
    <!-- Loader //-->
</form>
</body>
</html>