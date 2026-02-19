<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SmartCertReq.aspx.cs" Inherits="KCP.SmartCert.SmartCertReq" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
        <title>*** KCP Online Payment System [ASP.NET Version] ***</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0" />
        <link rel="icon" href="/images/icon/favicon.ico" type="image/x-icon"/>
        <link rel="stylesheet" href="/css/style.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
        <link rel="stylesheet" href="/css/notosanskr.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
        <%: Scripts.Render("~/bundles/LibJS") %>
        <script type="text/javascript" src="/js/lib/jquery-ui/jquery-ui.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
        <script type="text/javascript" src="/js/common.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
        <script type="text/javascript" src="/js/utils.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
        <%: Scripts.Render("~/js/lib/sweetalert2/sweetalert2.js") %>

        <script type="text/javascript">
            window.onload=function()
            {
                cert_page();
            }

			// 인증 요청 시 호출 함수
            function cert_page()
            {
                
                var frm = document.all.form_auth;

                if ((frm.req_tx.value == "auth" || frm.req_tx.value == "otp_auth"))
                {
                    frm.action="/KCP/SmartCertRes";
                    
                    if ($("#mobile_device").val() == "W") {
                        frm.target = "kcp_cert";
                    }
                    else {
                        self.name = "kcp_cert";
                    }
                    
                    frm.submit();
                    
                    window.close();
                }
				else if ( frm.req_tx.value == "cert" )
                {
                    if ($("#mobile_device").val() == "W") {
                        opener.document.getElementById("veri_up_hash").value = frm.up_hash.value; // up_hash 데이터 검증을 위한 필드
                    }
                    else {
                        parent.document.getElementById("veri_up_hash").value = frm.up_hash.value; // up_hash 데이터 검증을 위한 필드
                        self.name = "auth_popup";
                    }

                   frm.submit();
                }
                
			}
        </script>
    </head>
    <body oncontextmenu="return false;" ondragstart="return false;" onselectstart="return false;">
        <!-- KCP 모바일 인증 페이지는 euc-kr 을 사용하기 때문에, KCP cert 페이지를 호출하기 전에 charset을 euc-kr 로 설정한다 -->
        <form id="form_auth" method="post" runat="server" accept-charset="euc-kr">
        </form>
    </body>
</html>
