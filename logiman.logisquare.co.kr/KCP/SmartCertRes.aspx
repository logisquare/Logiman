<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SmartCertRes.aspx.cs" Inherits="KCP.SmartCert.SmartCertRes" %>

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
            window.onload = function()
            {
                try
                {
                    if ($("#mobile_device").val() == "W") {
                        opener.fnAuthData(document.all.form_auth); // 부모창으로 값 전달
                        self.close();
                    } else {
                        parent.fnAuthData(document.all.form_auth); // 부모창으로 값 전달
                    }
                } catch(e) {
                    if (opener) {
                        self.close();
                    } else {
                        //alert('인증이 취소되었습니다.\n처음부터 다시 진행해 주시기 바랍니다.');   // 정상적인 부모창의 iframe 을 못찾은 경우임
                        parent.fnPopupClose();
                    }
                }
            }
        </script>
    </head>
    <body oncontextmenu="return false;" ondragstart="return false;" onselectstart="return false;">
        <form id="form_auth" method="post" runat="server">
        </form>
    </body>
</html>