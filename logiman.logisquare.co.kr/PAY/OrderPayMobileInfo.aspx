<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrderPayMobileInfo.aspx.cs" Inherits="PAY.OrderPayMobileInfo" %>
<!doctype html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, intial-scale=1, user-scalable=no" />
    <title>카고페이</title>
    <style>
        * { margin:0px; padding:0px; font-family: "Noto Sans KR", sans-serif; box-sizing: border-box; font-weight:300;}
        body, html {height:100%; position:relative; overflow: hidden;}
        #wrap {width:100%; height:95vh; position:relative; background:#332E2E; display:table; vertical-align:middle;}
        #wrap ul {vertical-align:middle; display:table-cell; text-align:center;}
        #wrap ul li:nth-child(2) {margin-top:20px; margin-bottom:20px;}
        #wrap ul li:nth-child(2) strong {display:block; color:#fff; font-size:22px; font-weight:700; margin-bottom:10px; word-break: keep-all;}
        #wrap ul li:nth-child(2) span {display:block; color:#888888; font-size:14px; font-weight:300; line-height:1.5; word-break: keep-all;}
        #wrap ul li button {width:212px; height:52px; border-radius:10px; background:#FFFFFF; color:#333333; font-size:14px; border:none;}
        .logo {width:100%; height:5vh; position:relative; background:#332E2E; text-align:center;}
    </style>
</head>
<body>
    <div id="wrap">
        <ul>
            <li>
                <img src="/images/mobile_01.png"/>
            </li>
            <li>
                <strong>모바일에서는 결제가 불가합니다.</strong>
                <span>웹 화면에서 결제를 진행해주시기바랍니다.</span>
            </li>
            <!--버튼은 필요시 사용 불필요하면 삭제-->
            <li>
                <button type="button">웹에서 결제하기</button>
            </li>
        </ul>
    </div>
    <div class="logo">
        <img src="/images/mobile_02.png"/>
    </div>
</body>
</html>