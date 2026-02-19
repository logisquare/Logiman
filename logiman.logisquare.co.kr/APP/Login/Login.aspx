<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="APP.Login.LoginApp" %>
<%@ Import Namespace="CommonLibrary.Constants" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="Keywords" lang="ko" content="로지스퀘어 매니저">
    <meta name="keywords" lang="ko" content="로지스퀘어 매니저" />
    <meta name="keywords" lang="en" content="logisquaremanager" />
    <meta name="keywords" lang="en" content="logisquaremanager" />
    <meta property="og:title" content="로지스퀘어 매니저" />
    <meta property="og:type" content="website" />
    <meta property="og:type" content="website" />
    <meta property="og:site_name" content="로지스퀘어 매니저" />
    <meta property="og:description" content="로지스퀘어 매니저" />
    <meta name="description" content="로지스퀘어 매니저" />
    
    <title><%=CommonConstant.APP_SITE_TITLE %></title>
    <link rel="icon" href="/APP/images/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="/APP/css/common.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <script type="text/javascript" src="/APP/js/jquery-1.11.2.min.js" ></script>
    <%: Scripts.Render("~/bundles/LibJS") %>
    <script type="text/javascript" src="/js/lib/jquery-ui/jquery-ui.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/common.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/utils.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/APP/Login/Proc/Login.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <%: Scripts.Render("~/js/lib/sweetalert2/sweetalert2.js") %>
    <link rel="icon" href="/images/icon/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="/css/sweetalert2.min.css" />
    <link rel="stylesheet" href="/css/style.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <link rel="stylesheet" href="/css/notosanskr.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />

    <% if(!string.IsNullOrWhiteSpace(SiteGlobal.GA_CODE_APP)) {%>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=<%=SiteGlobal.GA_CODE_APP%>"></script>
        <script> window.dataLayer = window.dataLayer || []; function gtag() { dataLayer.push(arguments); } gtag('js', new Date()); gtag('config', '<%=SiteGlobal.GA_CODE_APP%>');</script>
    <%}%>
</head>
<body>
    <form id="MainForm" runat="server">
        <asp:HiddenField runat="server" ID="returnurl" />
        <div id="LoginWrap">
            <div class="login_body">
                <img src="/APP/images/login_logo.png" class="login_logo" alt="엠엠피 로고" />
                <ul>
                    <li>
                        <asp:TextBox runat="server" ID="AdminID" MaxLength="30" placeholder="아이디"></asp:TextBox>
                    </li>
                    <li>
                        <asp:TextBox TextMode="Password" runat="server" ID="AdminPwd" MaxLength="30" placeholder="비밀번호"></asp:TextBox>
                    </li>
                    <li>
                        <button type="button" id="btnLogin">로그인</button>
                    </li>
                </ul>
            </div>
        </div>
    </form>
</body>
</html>
