<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="logiman.logisquare.co.kr._Default" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta charset="utf-8" />
    <meta name="robots" content="noindex, nofollow" />
    <script type="text/javascript" src="/js/lib/jquery/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".moment").fadeIn(3000);
        });
    </script>
    <style>
        * {margin:0px; padding:0px; font-family: "Noto Sans KR", sans-serif; box-sizing: border-box; font-weight:300;}
        body, html {width:100%; height:100%;}
        .logiman_main {width:100%; height:100%; background:#F8FAFB;}
        div.logiman_content {width:880px; margin:0 auto; padding-top:127px;}
        div.logiman_content dl {position:relative;}
        div.logiman_content dl dt {text-align:center;}
        div.logiman_content dl dt span {display:block; font-size:20px; color:#888888;}
        div.logiman_content dl dt strong {display:block; font-size:50px; color:#333333; font-weight:600;}
        div.logiman_content dl dt strong span {display:inline-block; font-size:50px; color:#5674C8; font-size:50px; font-weight:600;}
        div.logiman_content dl dt p {display:block; font-size:26px; color:#888888;}
    </style>
</head>
<body>
    <div class="logiman_main">
        <div class="logiman_content">
            <dl>
                <dt>
                    <span>상용차 운송업무 관리의 모든 것</span>
                    <strong><span>로지스퀘어 매니저</span>를 불러주세요!</strong>
                    <p>오더 정보에서 운송료 정산까지 한번에!</p>
                </dt>
                <dd>
                    <img src="/images/main_img_01.png"/>
                </dd>
            </dl>
        </div>
    </div>
</body>
</html>