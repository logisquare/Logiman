<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SendPush2.aspx.cs" Inherits="WebSocket.SendPush2" %>
<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow" />

    <script type="text/javascript" src="/js/lib/jquery/jquery.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    
    <script>
        console.log(Notification.permission);
        if (Notification.permission === "granted") {
            showNotification();
        } else if (Notification.permission !== "denied") {
            Notification.requestPermission().then(function (permission) {
                if (permission === "granted") {
                    showNotification();
                }
            });
        }

        function showNotification() {
            new Notification("알림 제목", {
                body: "이것은 브라우저 알림입니다.",
                icon: "/favicon.ico" // 선택 사항
            });
        }
    </script>
</head>
<body>

</body>
</html>