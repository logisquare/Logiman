<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ServiceStop.aspx.cs" Inherits="APP.Login.ServiceStop" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>
<%@ Import Namespace="CommonLibrary.Constants" %>

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
    <link rel="icon" href="/images/icon/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="/APP/css/common.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <script type="text/javascript" src="/APP/js/jquery-1.11.2.min.js" ></script>
    <%: Scripts.Render("~/bundles/LibJS") %>
    <script type="text/javascript" src="/js/lib/jquery-ui/jquery-ui.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/common.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/utils.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/APP/Login/Proc/Login.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>

    <style>
        div#ServiceStop {width:100%; margin:0 auto; padding-top:25vw; text-align:center;}
        div#ServiceStop h1 {font-size:12vw; text-align:center; font-weight:bold; color:#6782CE; padding:30px 0;}
        div#ServiceStop p {text-align:center; font-size:6vw; word-break:keep-all; line-height:1.5;}
        div.btn_area {text-align:center; margin-top:13vw;}
        div.btn_area button {background:#6782CE; color:#fff; font-size:7vw; height:60px; width:300px; border-radius:10px; font-weight:500;}
        header#MenuArea {display:none;}
        div#MenuWrap {display:none;}
    </style>

    <script>
        $(document).ready(function () {
        });

        function goHome() {
            location.href = "<%= CommonConstant.APP_PAGE_1%>";
        }

    </script>

    <% if(!string.IsNullOrWhiteSpace(SiteGlobal.GA_CODE_APP)) {%>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=<%=SiteGlobal.GA_CODE_APP%>"></script>
        <script> window.dataLayer = window.dataLayer || []; function gtag() { dataLayer.push(arguments); } gtag('js', new Date()); gtag('config', '<%=SiteGlobal.GA_CODE_APP%>');</script>
    <%}%>
</head>
<body>
    <form id="MainForm" runat="server">
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
    </form>
</body>
</html>