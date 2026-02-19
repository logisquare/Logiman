<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="MyIP.aspx.cs" Inherits="logiman.logisquare.co.kr.MyIP" %>
<%@ Import Namespace="CommonLibrary.Constants" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, user-scalable=">
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
    <meta name="robots" content="noindex, nofollow" />
    <title><%=Server.HtmlEncode(CommonConstant.SITE_TITLE)%></title>
    <link rel="icon" href="/images/icon/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="/css/style.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <link rel="stylesheet" href="/css/notosanskr.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <style>
        div.login_bottom {width:100%; height:70px; background:#F8F9FA; position: fixed; bottom:0px; left:0px; border-top:1px solid #D9DEE2; text-align: center;}
        div.login_bottom ul {overflow:hidden; width:1218px; margin:14px auto 0;}
        div.login_bottom ul li {float:left; width:100%;}
        div.login_bottom ul li h2 {width:178px; height:28px; background:url("../images/common/foot_logo_1.png") no-repeat; background-size:178px 28px; display:inline-block;}
        div.login_bottom ul li p {display:inline-block; margin-left:50px; font-size:13px; color:#999999; line-height:1.5}
        div.login_bottom ul li:last-child {text-align:center;}
        div.login_bottom a, div.login_bottom span {font-size:13px; }
        div.login_bottom span {padding:0 18px;}
        div.ip_area { width:100%; height:100%; position:relative;}
        div.ip_area div {width: 300px; margin: 200px auto; }
        div.ip_area ul {width:100%;}
        div.ip_area ul li {width:100%; color: #666666; font-size:20px; padding:20px 0; text-align: left;}
        div.ip_area ul li span {float:right; color: #5674C8; font-weight:700;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="membership_header">
            <span>고객센터 042-935-3100</span>
        </div>
        <div class="ip_area">
            <div>
                <ul>
                    <li>IP 1 : <asp:Label  runat="server" ID="LitIP1"></asp:Label></li>
                    <li>IP 2 : <asp:Label  runat="server" ID="LitIP2"></asp:Label></li>
                    <li>Check IP : <asp:Label  runat="server" ID="LitCheckIP"></asp:Label></li>
                </ul>
            </div>
        </div>
        <div class="login_bottom">
            <ul>
                <li>
                    <h2></h2>
                    <p>
                        고객센터  042-935-3100  (운영시간  평일 오전 10시 - 오후 6시) <br />
                        COPYRIGHT ⓒ LOGISQUARE ALL RIGHT RESERVED.
                    </p>
                </li>
            </ul>
            
        </div>
    </form>
</body>
</html>