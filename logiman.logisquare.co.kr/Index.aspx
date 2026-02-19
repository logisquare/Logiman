<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="logiman.logisquare.co.kr.Index" %>
<%@ Import Namespace="CommonLibrary.Constants" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>
<!DOCTYPE html>

<html lang="en">
<head runat="server">
    <title><%=Server.HtmlEncode(CommonConstant.SITE_TITLE)%></title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="robots" content="noindex, nofollow" />

    <asp:PlaceHolder runat="server">
        <%: Scripts.Render("~/bundles/LibJS") %>
        <script type="text/javascript" src="/js/lib/jquery-ui/jquery-ui.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
        <script type="text/javascript" src="/js/common.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
        <script type="text/javascript" src="/js/utils.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
        <%: Scripts.Render("~/js/lib/sweetalert2/sweetalert2.js") %>
    </asp:PlaceHolder>

    <!-- Default CSS -->
    <link rel="icon" href="/images/icon/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="/css/style.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <link rel="stylesheet" href="/css/notosanskr.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <link rel="stylesheet" runat="server" ID="ThemeStyle"/>
    <webopt:bundlereference runat="server" path="~/Content/css" />
    <link rel="stylesheet" href="/css/jquery-ui.css?ver=20251015" />
    <!-- AUIGrid CSS -->
    <link rel="stylesheet" href="/js/lib/AUIGrid/AUIGrid_style.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <link rel="stylesheet" href="/js/lib/AUIGrid/AUIGrid_custom_style.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <!-- AUIGrid JS -->
    <script type="text/javascript" src="/js/lib/AUIGrid/AUIGridLicense.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/lib/AUIGrid/AUIGrid.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/lib/AUIGrid_Common.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <!-- SignalR -->
    <script src="/Scripts/jquery.signalR-2.4.3.js"></script>
    <script src="<%= ResolveUrl("~/signalr/hubs") %>"></script>

    <script>
        $(document).ready(function () {
            /*대메뉴 클릭 Start*/
            $('#menu ul.main li span').click(function () {
                if ($("ul.sub_depth1").hasClass("open")) {
                    if ($(this).next("ul.sub_depth1").hasClass("open")) {
                        $(this).next("ul.sub_depth1").stop().animate({ 'width': '0px' }, 200);
                        //$("ul.sub_depth1 li").not($(this)).hide(50);
                        $(this).next("ul.sub_depth1").removeClass('open').animate({ 'left': '-1000%' }, 200);
                        $(this).parent("li").removeClass("on");
                        $("div.menu_fade").hide();
                    } else {
                        $("ul.sub_depth1").not($(this)).css({ 'width': '0px', 'left': '-1000%' });
                        //$("ul.sub_depth1 li").not($(this)).hide();
                        $("ul.sub_depth1").not($(this)).removeClass('open');
                        $("#menu ul.main li").removeClass("on");
                        $(this).next("ul.sub_depth1").addClass("open");
                        //$(this).next("ul.open").children("li").show();
                        $(this).next("ul.sub_depth1").css("left", "162px");
                        $(this).next("ul.sub_depth1").css('width', '180px');
                        $(this).parent("li").addClass("on");
                        $("div.menu_fade").show();
                    }
                } else {
                    if (!$(this).next("ul.sub_depth1").hasClass("open")) {
                        $("ul.sub_depth1").not($(this)).css({ 'width': '0px', 'left': '-1000%' });
                        $("ul.sub_depth1").not($(this)).removeClass('open');
                        $("#menu ul.main li").removeClass("on");
                        $(this).next("ul.sub_depth1").addClass("open");
                        //$(this).next("ul.sub_depth1").children("li").show(200);
                        $(this).next("ul.sub_depth1").css("left", "162px");
                        $(this).next("ul.sub_depth1").stop().animate({ 'width': '180px' }, 200);
                        $(this).parent("li").addClass("on");
                        $("div.menu_fade").show();
                    }
                }
            });

            $("div#menu ul.main ul.sub_depth1 li dl dt").click(function () {
                if ($(this).hasClass("on")) {
                    $(this).removeClass("on");
                    $(this).next("dd").slideUp();
                } else {
                    $("div#menu ul.main ul.sub_depth1 li dl dt").not($(this)).next("dd").slideUp();
                    $("div#menu ul.main ul.sub_depth1 li dl dt").not($(this)).removeClass("on");
                    $(this).addClass("on");
                    $(this).next("dd").slideDown();
                }
            });
            /*대메뉴 클릭 Start*/

            /*메뉴 닫기*/
            $("header, div.menu_fade").click(function (e) {
                $("ul.sub_depth1.open").css({ 'width': '0', 'left': '-1000%' });
                $("ul.sub_depth1").removeClass("open");
                $("div.menu_fade").hide();
            });

            if ($("#HidMNo").val()) {
                fnGoMenu($("#HidMNo").val(), $("#HidMPra").val());
            }
        });

        function fnGoPage(GroupTitle, SubGroupTitle, MenuName, strUrl, GroupNo, MenuNo) {
            $("#iframePageLoading").show();
            $("div#SiteMap").hide();
            $("div.menu_fade").hide();
            var MenuList = "";
            var selected = "";
            $("header div.page_navi a").removeClass("on");
            $("ul.menu" + GroupNo).children("li").each(function (index) {
                if (MenuNo === index) {
                    selected = "on";
                } else {
                    selected = "";
                }
                MenuList += "<a class=\"" + selected + "\" href=\"" + $(this).children("a").attr("href") + "\">" + $(this).children("a").text() + "</a>";
            });
            $("div.page_items").html("<span>" + GroupTitle + "</span>" + " <span class='arrow'></span> " + "<span>" + SubGroupTitle + "</span>" + " <span class='arrow'></span> " + MenuList);
            document.getElementById("Content_frame").src = strUrl;
            $("ul.sub_depth1.open").css({ 'width': '0', 'left': '-1000%' });
            $("ul.sub_depth1").removeClass("open");
            $('#Content_frame').contents().find('div.data_list h1.title').text("사용자 관리");
        }

        function fnSetMenuFromIframe(GroupTitle, SubGroupTitle, MenuName, strUrl, GroupNo, MenuNo) {
            $("div#SiteMap").hide();
            $("div.menu_fade").hide();
            var MenuList = "";
            var selected = "";
            $("header div.page_navi a").removeClass("on");
            $("ul.menu" + GroupNo).children("li").each(function (index) {
                if (MenuNo === index) {
                    selected = "on";
                } else {
                    selected = "";
                }
                MenuList += "<a class=\"" + selected + "\" href=\"" + $(this).children("a").attr("href") + "\">" + $(this).children("a").text() + "</a>";
            });
            $("div.page_items").html("<span>" + GroupTitle + "</span>" + " <span class='arrow'></span> " + "<span>" + SubGroupTitle + "</span>" + " <span class='arrow'></span> " + MenuList);
            $("ul.sub_depth1.open").css({ 'width': '0', 'left': '-1000%' });
            $("ul.sub_depth1").removeClass("open");
            $('#Content_frame').contents().find('div.data_list h1.title').text("사용자 관리");
        }

        function fnGoLogout() {
            __doPostBack("logout", "");
        }

        $(function () {
            $('#Content_frame').on("load", function () {
                $("#iframePageLoading").hide();
            });
        });

        function fnSiteMapMenu() {
            $("#SiteMap").slideToggle();
        }

        function NoticeClose() {
            $.cookie("MainNoticeView", $('input:radio[name="NoticeClose"]:checked').val(), { expires: Number($('input:radio[name="NoticeClose"]:checked').val()), path: "/" });
            $("#NoticeMainLayer").hide();
            $("#Notice_frame").attr("src", "");
        }

        function NoticeMainView() {
            if ($("#HidNoticeFlag").val() != "Y") {
                fnDefaultAlert("등록된 공지사항이 없습니다.", "warning");
                return;
            }
            $.removeCookie('MainNoticeView', { path: '/' });
            $("#NoticeMainLayer").show();
            document.getElementById("Notice_frame").src = "/SSO/Board/BoardNoticeMain";
        }

        function NoticeMainViewSub() {
            $("#NoticeMainLayer").show();
        }

        function fnAgree(type) {
            if (type === 1) {
                window.open("/SSO/MemberShip/LogimanAgree1", "이용약관", "width=1000px, height=800px, scrollbars=Yes");
            } else if (type === 2) {
                window.open("/SSO/MemberShip/LogimanAgree2", "개인정보 처리방침", "width=1000px, height=800px, scrollbars=Yes");
            }
        }

        function fnHelpLayer() {
            $("div#HelpLayer").slideToggle();
        }
    </script>
    <script>
        $(document).ready(function () {
            if ($("#HidGradeCode").val() !== "6")
                (function () {
                    var w = window; if (w.ChannelIO) {
                        return w.console.error("ChannelIO script included twice.");
                    }
                    var ch = function () { ch.c(arguments); };
                    ch.q = []; ch.c = function (args) { ch.q.push(args); };
                    w.ChannelIO = ch; function l() {
                        if (w.ChannelIOInitialized) { return; }
                        w.ChannelIOInitialized = true;
                        var s = document.createElement("script");
                        s.type = "text/javascript";
                        s.async = true;
                        s.src = "https://cdn.channel.io/plugin/ch-plugin-web.js";
                        var x = document.getElementsByTagName("script")[0];
                        if (x.parentNode) { x.parentNode.insertBefore(s, x); }
                    }
                    if (document.readyState === "complete") { l(); }
                    else { w.addEventListener("DOMContentLoaded", l); w.addEventListener("load", l); }
                })();
                ChannelIO('boot', { "pluginKey": "ede459ae-e85f-481d-be99-e928d49c6b86" });
        });
    </script>

    <!-- SignalR -->
    <script>
        var myLoginId = "<%=objSes.AdminID%>";
        var myLoginName = "<%=objSes.AdminName%>";
        var myLoginMobileNo = "<%=objSes.MobileNo%>";
        var myLoginSessionKey = "<%=objSes.SessionKey%>";

        //서버에 접속할 signalr hub instance 생성
        //아래에 지정된 notiHub의 경우 서버에서 Hub를 상속받은 NotiHub class로 생성된 서버의 hub에 접속하는 것임
        var notiProxy = $.connection.notiHub;
        var orderWin;

        const channel = new BroadcastChannel("window-check");
        let myId = Math.random().toString(36).substring(2); // 창 고유 ID
        const openWindows = {}; // { 창ID: { focused: true/false, lastSeen: timestamp } }

        // 내 상태 브로드캐스트
        function broadcastState() {
            channel.postMessage({
                type: "state",
                id: myId,
                timestamp: Date.now()
            });
        }

        // 현재 리스트 전체 공유 요청
        function requestSync() {
            channel.postMessage({ type: "requestSync", id: myId });
        }

        // 다른 창의 메시지 처리
        channel.onmessage = (event) => {
            const data = event.data;

            if (data.type === "state") {
                openWindows[data.id] = {
                    lastSeen: data.timestamp
                };
            } else if (data.type === "leave") {
                delete openWindows[data.id];
            } else if (data.type === "requestSync" && data.id !== myId) {
                // 다른 창이 리스트를 달라고 요청 → 내 리스트 전달
                channel.postMessage({ type: "sync", id: myId, windows: openWindows });

            } else if (data.type === "sync" && data.id !== myId) {
                // 병합 로직
                Object.entries(data.windows).forEach(([id, info]) => {
                    if (!openWindows[id] || info.lastSeen > openWindows[id].lastSeen) {
                        openWindows[id] = info;
                    }
                });
            }
        };

        // 창이 닫히기 전에 "leave" 이벤트 전송
        window.addEventListener("beforeunload", () => {
            channel.postMessage({ type: "leave", id: myId });
        });

        // 창이 닫히기 전에 "leave" 이벤트 전송
        window.addEventListener("beforeunload", () => {
            channel.postMessage({ type: "leave", id: myId });
        });

        // 페이지 로드 시 초기 상태 전송
        broadcastState();
        requestSync();

        $(document).ready(function () {

            //////////////////////////////////////////////////
            //SignalR 연결
            //////////////////////////////////////////////////
            //1. 서버와 websocket channel 연결
            $.connection.hub.logging = true;
            $.connection.hub.start()
                .done(function () {
                    console.log("Connected to the server. Connection Id=" + $.connection.hub.id);
                    notiProxy.server.joinUser(myLoginSessionKey, myLoginId, myLoginName, myLoginMobileNo);
                    /*
                    notiProxy.server.broadcastMessage("Hi! all, I'm in.")
                        .done(function () {
                            console.log("broadcastMessage succeeded.");
                        })
                        .fail(function (error) {
                            console.log("broadcastMessage failed. - " + error);
                        });
                    */
                    notiProxy.server.getConnectedUsers()
                        .done(function () {
                            console.log("getConnectedUsers succeeded.");
                        })
                        .fail(function (error) {
                            console.log("getConnectedUsers failed. - " + error);
                        });
                })
                .fail(function () {
                    console.log("Cannot connect to the server.");
                });

            //서버와 연결이 끊어지면 발생하는 event
            $.connection.hub.disconnected(function () {
                console.log("Disconnected from the server.");

                // 자동 재연결 (예: 5초 후)
                setTimeout(function () {
                    $.connection.hub.start().done(function () {
                        console.log("ReConnection Success.");
                        notiProxy.server.joinUser(myLoginSessionKey, myLoginId, myLoginName, myLoginMobileNo);
                    });
                }, 5000);
            });

            //서버와의 연결이 좋지 않을 때 event
            $.connection.hub.connectionSlow(function () {
                console.log("Connection slow. check connection status.");
            });

            //error 발생 event
            $.connection.hub.error(function (error, data) {
                console.log("Error occured :" + error + ", sent data = " + data);
            });

            //서버와 다시 연결되었을 때 event
            $.connection.hub.reconnecting(function () {
                console.log("reconnecting to the server.");
            });

            //서버와 다시 연결되었을 때 event
            $.connection.hub.reconnected(function () {
                console.log("Reconnected to the server.");
                notiProxy.server.joinUser(myLoginSessionKey, myLoginId, myLoginName, myLoginMobileNo);
            });

            //서버와 다시 연결되었을 때 event
            $.connection.hub.stateChanged(function (data) {
                console.log("State changed : Old state = " + data.oldState + ", New state = " + data.newState);
            });

            ////////////////////////////////////////////
            //서버에서 호출할 client측 메소드 정의 START
            ////////////////////////////////////////////
            // 서버에서 유저 리스트를 수신
            notiProxy.client.receiveUserList = function (userList) {
                //console.log("receiveUserList -> " + userList);

                //userList.forEach(function (user) {
                    //console.log(user.AdminName + " / " + user.AdminID);
                //});
            };

            // 서버에서 updateUserList 호출 시 자동 실행됨
            notiProxy.client.updateUserList = function (userList) {
                //console.log("receiveUserList -> " + userList);

                //userList.forEach(function (user) {
                //console.log(user.AdminName + " / " + user.AdminID);
                //});
            };

            //서버에서는 다음과 같이 사용됨 hub.Clients.All.cidReceived(~);
            notiProxy.client.cidReceived = function (strCMJsonParam, strWebAlarmFlag, strPCAlarmFlag, strAutoPopupFlag) {

                if ($("#DivCMSetting").length == 0) {
                    return false;
                }

                fnResetSideMenu();

                var objCMJsonParam = JSON.parse(strCMJsonParam);
                if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
                    return false;
                }

                $("#CMJsonParam").val(strCMJsonParam);

                //PC알림
                var firstWindowId = "";
                if (Object.entries(openWindows).length == 0) {
                    firstWindowId = myId
                } else {
                    firstWindowId = Object.entries(openWindows)[0][0];
                }

                if (strPCAlarmFlag == "Y" && firstWindowId == myId) {
                    var strTitle   = fnGetNotiTitleByType(objCMJsonParam.CallerType, objCMJsonParam.CallerDetailText, objCMJsonParam.Name, objCMJsonParam.ClassType);
                    var strContent = fnGetNotiContent(objCMJsonParam.SndTelNo);
                    var strIconUrl = fnGetNotiIconByType(objCMJsonParam.intCallerType);

                    // 알림 권한 요청
                    if (Notification.permission === "granted") {
                        fnSetNotification(strTitle, strContent, strIconUrl, strCMJsonParam);
                    } else if (Notification.permission !== "denied") {
                        Notification.requestPermission().then(permission => {
                            if (permission === "granted") {
                                fnSetNotification(strTitle, strContent, strIconUrl, strCMJsonParam);
                            }
                        });
                    }
                }

                //WEB알림
                if (strWebAlarmFlag != "Y") {
                    return false;
                }

                $("#DivCMNotice").addClass("type0" + objCMJsonParam.CallerType);
                $("#DivCMNotice div.sign").addClass("class" + objCMJsonParam.ClassType);
                $("#DivCMNotice div.number").html(fnMakeCellNo(objCMJsonParam.SndTelNo));
                $("#DivCMNotice div.info_txt p").html(objCMJsonParam.CallerDetailText);
                $("#DivCMNotice div.info_txt div").html(objCMJsonParam.Name);

                if (objCMJsonParam.CallerType == 1) { //차주
                    $("#DivCMNotice div.icon img").attr("src", "/images/callmanager/notify/ico_item01.svg");

                    if (objCMJsonParam.CallerDetailType == 31) { //기사
                        $("#DivCMNotice div.notify_list li.office").html(objCMJsonParam.CarNo);
                        $("#DivCMNotice div.notify_list li.name").hide();
                        $("#DivCMNotice div.notify_list li.num").html(objCMJsonParam.CarTon + "<span></span>" + objCMJsonParam.CarType);
                    } else {
                        $("#DivCMNotice div.notify_list li.office").html(objCMJsonParam.ComName);
                        $("#DivCMNotice div.notify_list li.name").html(objCMJsonParam.CeoName);
                        $("#DivCMNotice div.notify_list li.num").html(fnMakeCorpNo(objCMJsonParam.CorpNo));
                    }
                } else if (objCMJsonParam.CallerType == 2) { //고객사
                    $("#DivCMNotice div.icon img").attr("src", "/images/callmanager/notify/ico_item03.svg");
                    if (objCMJsonParam.CallerDetailType == 53 || objCMJsonParam.CallerDetailType == 71) { //상하차지
                        $("#DivCMNotice div.notify_list li.office").html(objCMJsonParam.PlaceName);
                        $("#DivCMNotice div.notify_list li.name").hide();
                        $("#DivCMNotice div.notify_list li.num").html(objCMJsonParam.PlaceAddr);
                    } else if (objCMJsonParam.CallerDetailType == 11) { //웹오더
                        $("#DivCMNotice div.notify_list li.office").html(objCMJsonParam.ComName);
                        $("#DivCMNotice div.notify_list li.name").html(objCMJsonParam.DeptName);
                        $("#DivCMNotice div.notify_list li.num").html(objCMJsonParam.Position);
                    } else {
                        $("#DivCMNotice div.notify_list li.office").html(objCMJsonParam.ComName);
                        $("#DivCMNotice div.notify_list li.name").html(objCMJsonParam.CeoName);
                        $("#DivCMNotice div.notify_list li.num").html(fnMakeCorpNo(objCMJsonParam.CorpNo));
                    }
                } else if (objCMJsonParam.CallerType == 3) { //관리자
                    $("#DivCMNotice div.icon img").attr("src", "/images/callmanager/notify/ico_item06.svg");
                    $("#DivCMNotice div.notify_list li.office").html(objCMJsonParam.CenterName);
                    $("#DivCMNotice div.notify_list li.name").html(objCMJsonParam.DeptName);
                    $("#DivCMNotice div.notify_list li.num").html(objCMJsonParam.Position);
                } else if (objCMJsonParam.CallerType == 4) { //미등록
                    $("#DivCMNotice div.icon img").attr("src", "");
                }

                if (objCMJsonParam.CallerType == 1 || objCMJsonParam.CallerType == 2 || objCMJsonParam.CallerType == 3) {
                    $("#DivCMNotice div.icon").show();
                    $("#DivCMNotice div.notify_list ul").show();
                    $("#DivCMNotice div.notify_list div.nodata").hide();
                } else { //미등록
                    $("#DivCMNotice div.icon").hide();
                    $("#DivCMNotice div.notify_list ul").hide();
                    $("#DivCMNotice div.notify_list div.nodata").show();
                }

                fnShowSideMenu();

                //자동팝업
                if (strAutoPopupFlag == "Y") {
                    //3초 후 자동 팝업
                    setTimeout(function () {
                        if ($("#DivCMNotice").css("bottom") == "8px") {
                            $("#DivCMNotice").click();
                        }
                    }, 3000);
                }
            };

            notiProxy.client.receiveMessage = function (message, flag) {
                console.log("receiveMessage message = " + message + ", flag = " + flag);
            };

            if ($("#DivCMSetting").length > 0) {
                //연락처 목록
                fnSetCMAdminPhoneList("CMAdminPhoneList", "", "", true);
            }
        });

        function fnSetNotification(strTitle, strContent, strIconUrl, strCMJsonParam) {
            let notification = new Notification(strTitle, {
                body: strContent,
                icon: strIconUrl
            });

            notification.onclick = () => {
                window.focus();
                fnOpenCallDetailFromNotification(strCMJsonParam);
                notification.close();
            };

            // 60초 뒤 자동 닫기
            setTimeout(() => {
                notification.close();
            }, 60 * 1000);
        }

        // 타입별 아이콘 반환
        function fnGetNotiIconByType(intCallerType) {
            switch (intCallerType) {
                case 1: return "/images/callmanager/notify/icon_pc_alarm_01.png";
                case 2: return "/images/callmanager/notify/icon_pc_alarm_02.png";
                case 3: return "/images/callmanager/notify/icon_pc_alarm_03.png";
                case 4: return "/images/callmanager/notify/icon_pc_alarm_04.png";
                default: return "/images/callmanager/notify/ico_notify01.svg";
            }
        }

        // 타입별 제목 반환
        function fnGetNotiTitleByType(intCallerType, strDetailText, strName, intClassType) {
            var strTitle = strDetailText + " - " + (intCallerType == 4 ? "전화가 왔습니다." : strName);

            switch (intClassType) {
                case 2: strTitle += " 🔵"; break;
                case 3: strTitle += " 🟢"; break;
                case 4: strTitle += " 🟡"; break;
                case 5: strTitle += " 🟠"; break;
                case 6: strTitle += " 🔴"; break;
                case 7: strTitle += " ⚫️"; break;
            }

            return strTitle;
        }

        // 내용 반환
        function fnGetNotiContent(strSndTelNo) {
            let now = new Date();
            let hour = now.getHours();   // 시 (0 ~ 23)
            let minute = now.getMinutes(); // 분 (0 ~ 59)
            let second = now.getSeconds(); // 초 (0 ~ 59)
            return fnMakeCellNo(strSndTelNo) + " (" + (hour + "시 " + minute + "분 " + second + "초") + ")";
        }

        function fnOpenCallDetailFromNotification(strCMJsonParam) {
            if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
                return false;
            }

            fnHideSideMenu();
            fnOpenCMDetailPage(strCMJsonParam, true);
            return false;
        }

        function fnResetSideMenu() {
            fnHideSideMenu();
            $("#CMJsonParam").val("");
            $("#DivCMNotice").removeClass(function (i, c) {
                return (c.match(/\btype\S+/g) || []).join(" ");
            });
            $("#DivCMNotice div.sign").removeClass(function (i, c) {
                return (c.match(/\bclass\S+/g) || []).join(" ");
            });
            $("#DivCMNotice div.number").html("");
            $("#DivCMNotice div.info_txt p").html("");
            $("#DivCMNotice div.info_txt div").html("");
            $("#DivCMNotice div.notify_list li.office").html("");
            $("#DivCMNotice div.notify_list li.name").html("");
            $("#DivCMNotice div.notify_list li.num").html("");
            $("#DivCMNotice div.icon").show();
            $("#DivCMNotice div.notify_list ul").show();
            $("#DivCMNotice div.notify_list div.nodata").hide();
        }

        var giMenuDuration = 300;
        var timer = null;
        // 전체 메뉴를 왼쪽으로 슬라이드하여서 닫는다.
        function fnHideSideMenu() {
            if (timer != null) {
                clearTimeout(timer);
            }

            if ($('#DivCMNotice').css("bottom") != "-100%") {
                $('#DivCMNotice').animate({ bottom: '-100%' }, { duration: giMenuDuration, complete: function () { $('.menu_bg').css({ 'display': 'none' }); } });
            }
        }

        // 전체 메뉴를 오른쪽으로 슬라이드하여서 보여준다.
        function fnShowSideMenu() {
            if (timer != null) {
                clearTimeout(timer);
            }

            $('#DivCMNotice').css({ 'bottom': '-100%' });
            $('#DivCMNotice').animate({ bottom: '8px' }, { duration: giMenuDuration });

            timer = setTimeout(fnResetSideMenu, 30 * 1000);
        }

        //콜매니저 상세 열기
        function fnOpenCallDetail() {
            var strCMJsonParam = $("#CMJsonParam").val();

            if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
                return false;
            }

            fnHideSideMenu();
            fnOpenCMDetailPage(strCMJsonParam, true);
            return false;
        }

        //메뉴 이동
        function fnGoMenu(intMenuType, strParam) {
            var strHref = "";
            var strMenuUrl = "";
            strParam = typeof strParam == "undefined" ? "" : strParam;
            strParam = strParam == null ? "" : strParam;

            if(intMenuType == 1){ //수발신내역
                strMenuUrl = "/TMS/CallManager/CMCallRecordList";
            } else if (intMenuType == 2) { //메시지 전송 내역
                strMenuUrl = "/SSO/Msg/MsgSendLogList";
            } else if (intMenuType == 3) { //오더현황(내수)
                strMenuUrl = "/TMS/Domestic/DomesticList";
            } else if (intMenuType == 4) { //오더현황(수출입)
                strMenuUrl = "/TMS/Inout/InoutList";
            } else if (intMenuType == 5) { //오더현황(통합)
                strMenuUrl = "/TMS/AllOrder/AllOrderList";
            } else if (intMenuType == 6) { //배차현황
                strMenuUrl = "/TMS/Dispatch/OrderDispatchList";
            } else if (intMenuType == 7) { //매출마감현황
                strMenuUrl = "/TMS/ClosingSale/SaleClosingList";
            } else if (intMenuType == 8) { //매입마감현황
                strMenuUrl = "/TMS/ClosingPurchase/PurchaseClosingList";
            } else if (intMenuType == 9) { //고객사조회
                strMenuUrl = "/TMS/Client/ClientList";
            } else if (intMenuType == 10) { //차량조회
                strMenuUrl = "/TMS/Car/CarDispatchRefList";
            } else if (intMenuType == 11) { //업체매입마감
                strMenuUrl = "/TMS/ClosingPurchase/PurchaseClientList";
            } else if (intMenuType == 12) { //메모내역
                strMenuUrl = "/TMS/CallManager/CMCallMemoList";
            }

            $.each($("#menu a"), function (index, item) {
                if ($(item).attr("href").indexOf(strMenuUrl) > -1) {
                    strHref = $(item).attr("href");

                    if (strParam != "") {
                        strHref = strHref.replace(strMenuUrl, strMenuUrl + "?" + strParam);
                    }
                    return false;
                }
            });

            if (strHref != "") {
                eval(strHref);
                return false;
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <asp:HiddenField runat="server" ID="HidNoticeFlag"/>
        <asp:HiddenField runat="server" ID="HidGradeCode"/>
        <asp:HiddenField runat="server" ID="HidMNo"/>
        <asp:HiddenField runat="server" ID="HidMPra"/>
        <header>
            <div class="info">
                <a href="/" class="main_location"></a>
                <ul>
                    <% if (!SiteGlobal.SERVICE_TYPE_NAME.Equals("실서버"))
                       {
                    %>
                    <li class="server">
                        <span><%=SiteGlobal.SERVICE_TYPE_NAME %></span>
                    </li>
                    <%
                       }
                    %>
                    <li class="cscenter">
                        <span>고객센터 042-935-3100</span>
                    </li>
                    <li class="wifi">
                        <a href="javascript:fnDefaultAlert('준비중입니다.');"></a>
                    </li>
                    <li class="help">
                        <a href="javascript:fnHelpLayer();" title="도움말"></a>
                    </li>
                    <li class="info">
                        <a href="javascript:NoticeMainView();" title="공지사항"></a>
                    </li>
                    <li class="myinfo">
                        <a title="내정보" href="javascript:fnGoPage('내정보 관리','내정보 관리','내정보 관리','/SSO/Admin/AdminMyInfo.aspx',0);"></a>
                    </li>
                    <li class="logout">
                        <a title="로그아웃" href="javascript:fnDefaultConfirm('로그아웃 하시겠습니까?', 'fnGoLogout', '');"></a>
                    </li>
                    <li class="sitemap">
                        <a title="사이트맵" href="javascript:fnSiteMapMenu();"></a>
                    </li>
                </ul>
            </div>
            <div class="page_navi">
                <div class="page_items"></div>
            </div>
        </header>
        <div id="menu">
            <ul class="main">
                <%=strLeftMenu_B_List%>
            </ul>
            <%if(intGradeCode.Equals(6)){%>
            <ul class="client_agree">
                <li><a href="javascript:fnAgree(1);">- 이용약관</a></li>
                <li><a href="javascript:fnAgree(2);">- 개인정보 처리방침</a></li>
            </ul>
            <%} %>

            <!-- 알림 연락처 영역 -->
            <div class="notify_area" runat="server" id="DivCMSetting">
                <a href="#" title="콜수발신내역" onclick="fnGoMenu(1); return false;"><img src="/images/callmanager/notify/ico_notify01.svg" alt=""/></a>
                <div>
                    <select class="select" id="CMAdminPhoneList" style="display:none;">
                    </select>
                </div>
            </div>
            <!-- 알림 연락처 영역 -->

            <!-- 알림 영역 -->
            <div class="notify_box" runat="server" id="DivCMNotice" onclick="fnOpenCallDetail(); return false;">
                <asp:HiddenField runat="server" ID="CMJsonParam"/>
                <div class="icon"><img src="/images/callmanager/notify/ico_item01.svg" alt="" /></div>
                <div class="sign"></div>
                <div class="notify_info">
                    <div class="number"></div>
                    <div class="info_txt">
                        <p></p>
                        <span></span>
                        <div></div>
                    </div>
                </div>
                <div class="notify_list">
                    <ul>
                        <li class="office"></li>
                        <li class="name"></li>
                        <li class="num"></li>
                    </ul>
                    <div class="nodata">
                        <img src="/images/callmanager/notify/ico_item05.svg" alt="">
                        <div>미등록 전화번호</div>
                    </div>
                </div>
            </div>
            <!-- //알림 영역 -->
        </div>
        <div id="SiteMap">
            <div class="sitemap_wrap">
                <%=strSiteMap%>
            </div>
        </div>
        <section>
            <iframe id="Content_frame" name="Content_frame" style="width: 100%; height:100%; border:none;" src="Default.aspx" scrolling="no" border="0"></iframe>
            <div class="menu_fade"></div>
            <div id="iframePageLoading" ><img src="/images/common/loader.gif" alt="Loading..." /></div>
        </section>

        <!--테마변경 임시-->
        <!--button type="button" class="btn_theme" onclick="fnThemeChange();" aria-pressed="false"></button-->
        <asp:Button runat="server" ID="BtnTheme" aria-pressed="false" UseSubmitBehavior="false" CssClass="btn_theme" OnClick="BtnThemeCookieOnClick"/>

        <!--공지사항-->
        <div id="NoticeMainLayer">
            <div id="NoticeCloseLayer">
                <span><input type="radio" id="NoticeCloseDay" name="NoticeClose" checked value="1" /> <label for="NoticeCloseDay"> 하루동안 보지 않기</label></span>
                <span><input type="radio" id="NoticeCloseWeek" name="NoticeClose" value="7" /> <label for="NoticeCloseWeek"> 일주일간 보지 않기</label></span>
                <span class="notice_close">
                    <a href="javascript:NoticeClose();"></a>
                </span>
            </div>

            <iframe id="Notice_frame" name="Notice_frame" src="/SSO/Board/BoardNoticeMain" scrolling="no" style="width:100%; height:100%; border:none;"></iframe>
        </div>

        <!--도움말 리스트-->
        <div id="HelpLayer">
            <h1>
                로지맨 사용법 가이드 & 프로세스
                <button type="button" class="help_close" onclick="fnHelpLayer();">&#88;</button>
            </h1>
            <div class="help_wrap">
                <ul>
                    <li>
                        <dl>
                            <dt><a href="/Help/A_01" target="_blank">문자메시지</a></dt>
                            <dd>
                                <a href="/Help/A_01?#A_02" target="_blank">발신번호 사전등록 요청방법</a>
                                <a href="/Help/A_01?#A_03" target="_blank">발신번호 설정 방법</a>
                                <a href="/Help/A_01?#A_05" target="_blank">문자발송</a>
                                <a href="/Help/A_01?#A_06" target="_blank">문자내용 즐겨찾기 등록</a>
                                <a href="/Help/A_01?#A_07" target="_blank">포인트 충전 요청</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/B_01" target="_blank">자동운임</a></dt>
                            <dd>
                                <a href="/Help/B_01?#B_01" target="_blank">요율표 등록방법</a>
                                <a href="/Help/B_01?#B_04" target="_blank">적용방법</a>
                                <a href="/Help/B_01?#B_06" target="_blank">수정요청 방법</a>
                                <a href="/Help/B_01?#B_08" target="_blank">수정요청 승인방법</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/C_01" target="_blank">이관</a></dt>
                            <dd>
                                <a href="/Help/C_01?#C_01" target="_blank">오더이관</a>
                                <a href="/Help/C_01?#C_03" target="_blank">이관 오더 조회</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/D_01" target="_blank">위탁</a></dt>
                            <dd>
                                <a href="/Help/D_01?#D_01" target="_blank">오더위탁</a>
                                <a href="/Help/D_01?#D_03" target="_blank">오더위탁취소</a>
                                <a href="/Help/D_01?#D_04" target="_blank">위탁 오더 조회</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/E_01" target="_blank">고객(화주)용 웹오더</a></dt>
                            <dd>
                                <a href="/Help/E_01?#E_02" target="_blank">웹오더 계정생성(최초 계정 생성)</a>
                                <!--
                                <a href="" target="_blank">웹오더 계정생성(추가 계정 생성)</a>
                                <a href="" target="_blank">웹오더 계정별 메뉴권한 부여</a>
                                    -->
                                <a href="/Help/E_01?#E_03" target="_blank">웹오더 등록</a>
                                <a href="/Help/E_01?#E_04" target="_blank">웹오더 등록요청 카카오톡 수신설정/해제</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/F_01" target="_blank">항목순서 설정</a></dt>
                            <dd>
                                <a href="/Help/F_01?#F_02" target="_blank">항목순서 변경/저장</a>
                                <a href="/Help/F_01?#F_03" target="_blank">항목순서 초기화</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/G_01" target="_blank">엑셀다운로드</a></dt>
                            <dd>
                                <a href="/Help/G_01?#G_02" target="_blank">전체엑셀 다운로드</a>
                                <a href="/Help/G_01?#G_03" target="_blank">설정 항목 기준 엑셀다운로드</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/H_01" target="_blank">오더조회조건</a></dt>
                            <dd>
                                <a href="/Help/H_01?#H_02" target="_blank">내담당</a>
                                <a href="/Help/H_01?#H_03" target="_blank">내오더</a>
                                <a href="/Help/H_01?#H_04" target="_blank">취소오더</a>
                                <a href="/Help/H_01?#H_05" target="_blank">오더 조회 정렬순서</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/I_01" target="_blank">내수오더</a></dt>
                            <dd>
                                <a href="/Help/I_01?#I_02" target="_blank">대량복사</a>
                                <a href="/Help/I_01?#I_03" target="_blank">집하 오더로 변경하기/집하사업장 설정하기</a>
                                <a href="/Help/I_01?#I_04" target="_blank">집하 오더를 직송으로 변경하기</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/J_01" target="_blank">수출입 오더</a></dt>
                            <dd>
                                <a href="/Help/J_01?#J_02" target="_blank">비용등록(매출)</a>
                                <a href="/Help/J_01?#J_03" target="_blank">대량복사</a>
                                <a href="/Help/J_01?#J_04" target="_blank">서비스 이슈 등록하기</a>
                                <a href="/Help/J_01?#J_05" target="_blank">서비스 이슈 현황</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/K_01" target="_blank">매입마감</a></dt>
                            <dd>
                                <a href="/Help/K_01?#K_02" target="_blank">조회기간 내 미매칭 계산서 조회하기</a>
                                <a href="/Help/K_01?#K_03" target="_blank">매입마감하기(일반입금)</a>
                                <a href="/Help/K_01?#K_04" target="_blank">매입마감하기(빠른입금(운))</a>
                                <a href="/Help/K_01?#K_05" target="_blank">매입마감하기(업체마감)</a>
                                <a href="/Help/K_01?#K_06" target="_blank">매입마감 취소하기(일반, 빠른, 업체)</a>
                                <a href="/Help/K_01?#K_07" target="_blank">매입계산서 매칭하기</a>
                                <a href="/Help/K_01?#K_08" target="_blank">매입마감 현황조회(상세)</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/L_01" target="_blank">매출마감</a></dt>
                            <dd>
                                <a href="/Help/L_01?#L_02" target="_blank">매출 등록 거래처 조회하기</a>
                                <a href="/Help/L_01?#L_03" target="_blank">매출마감하기</a>
                                <a href="/Help/L_01?#L_04" target="_blank">매출 계산서 별도발행/별도발행 취소</a>
                                <a href="/Help/L_01?#L_05" target="_blank">계산서 발행내역 확인</a>
                                <a href="/Help/L_01?#L_06" target="_blank">전표 메모작성</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/M_01" target="_blank">카고페이 결제</a></dt>
                            <dd>
                                <a href="/Help/M_01?#M_02" target="_blank">송금신청</a>
                                <a href="/Help/M_01?#M_03" target="_blank">카드결제</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/N_01" target="_blank">고객사등록</a></dt>
                            <dd>
                                <a href="/Help/N_01?#N_02" target="_blank">고객사 등록하기</a>
                                <a href="/Help/N_01?#N_03" target="_blank">담당업체 등록하기</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/O_01" target="_blank">화주등록</a></dt>
                            <dd>
                                <a href="/Help/O_01?#O_02" target="_blank">화주등록</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/P_01" target="_blank">차량정보 등록</a></dt>
                            <dd>
                                <a href="/Help/P_01?#P_02" target="_blank">차량등록하기</a>
                                <a href="/Help/P_01?#P_03" target="_blank">차량 구분 안내</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/Q_01" target="_blank">상하차지 관리</a></dt>
                            <dd>
                                <a href="/Help/Q_01?#Q_02" target="_blank">상하차지 등록</a>
                                <a href="/Help/Q_01?#Q_03" target="_blank">고객사 상하차지 관리</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/R_01" target="_blank">담당 고객사 관리</a></dt>
                            <dd>
                                <a href="/Help/R_01?#R_02" target="_blank">관리 고객사 등록하기 (내담당 오더 안내)</a>
                            </dd>
                        </dl>
                    </li>
                    <li>
                        <dl>
                            <dt><a href="/Help/S_01" target="_blank">데이터 경영</a></dt>
                            <dd>
                                <a href="/Help/S_01?#S_02" target="_blank">매출이익 현황</a>
                                <a href="/Help/S_01?#S_03" target="_blank">자동운임현황</a>
                            </dd>
                        </dl>
                    </li>
                </ul>
            </div>
        </div>
    </form>
</body>
</html>