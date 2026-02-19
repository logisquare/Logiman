<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CMPersonalSetting.aspx.cs" Inherits="TMS.CallManager.CMPersonalSetting" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/CallManager/Proc/CMPersonalSetting.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".search_line > input[type=text]").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    $("#BtnListSearch").click();
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnSearchList();
                return false;
            });
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
        }
    </script>

    <style>
        label {margin:0 20px 0 5px; }

        .popup_control {display: flex; flex-direction: column; width:100%; margin: 0 auto; height:100%;}
        .popup_control > div {margin-top:10px; background :#fff; border:1px solid #ddd; border-radius: 5px; display: flex; flex-direction: column; padding: 10px;}
        .popup_control > div > h1 {font-weight: bold; font-size: 16px; border-left: 5px solid #5674C8; padding-left: 10px; line-height: 155%;}
        .popup_control > div > div {flex-grow: 1; margin-top: 5px; padding: 5px;}
        .popup_control > div:nth-child(5) {flex-grow: 1; min-height:300px;}
        .popup_control > div:first-child {border:0; background :none; margin-top: 0; padding:0;}
        .popup_control > div:first-child > div {text-align: right; margin-top: 0; padding:0;}
        .popup_control > div:first-child > div button {width: 110px;}

        .popup_control > div > div.tel_wrap {display: flex; flex-direction: row; flex-grow:1;}
        .popup_control > div > div.tel_wrap h2 {font-weight: bold; font-size: 16px; color :#5674c8; padding-left: 5px;}
        .popup_control > div > div.tel_wrap h2 button {float:right;}
        .popup_control > div > div.tel_wrap > div:first-child {width:50%; margin-right:5px;}
        .popup_control > div > div.tel_wrap > div:nth-child(2) {justify-content: center; border: 0 !important; padding: 0 10px;}
        .popup_control > div > div.tel_wrap > div:nth-child(2) button {min-width:30px; padding: 0 2px;}
        .popup_control > div > div.tel_wrap > div:last-child {width:40%; flex-grow: 1;}
        .popup_control > div > div.tel_wrap > div {display: flex; flex-direction: column; }
        .popup_control > div > div.tel_wrap div.grid {margin-top:5px; flex-grow: 1; }

        .popup_control a {font-weight:bold; color :#5674c8;}

        #DivQRCode { width:200px; height:200px; position:absolute; left:0; top:0; display:none; border:2px solid #5674c8; z-index: 100; background:#fff;}
        #DivQRCode img { width:100%; height:100%; border:0px;}

        #AppMobileNo {margin-right: 15px;}
        div.no-margin label {margin-right: 5px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="contents">
        <div class="popup_control">
            <div>
                <div>
                    <button type="button" class="btn_01" id="BtnInsCMAdmin" width="200px;">적용</button>
                </div>
            </div>
            <div>
                <h1>알림 방식</h1>
                <div>
                    <asp:CheckBox runat="server" id="WebAlarmFlag" Text="<span></span>로지맨알림" Checked="False"/>
                    <asp:CheckBox runat="server" id="PCAlarmFlag" Text="<span></span>윈도우알림" Checked="False"/>
                </div>
            </div>
            <div>
                <h1>요약 정보창 표시</h1>
                <div>
                    <asp:CheckBox runat="server" id="AutoPopupFlag" Text="<span></span>자동팝업 (3초지연)" Checked="False"/>
                    <asp:CheckBox runat="server" id="OrderViewFlag" Text="<span></span>오더정보" Checked="False"/>
                    <asp:CheckBox runat="server" id="CompanyViewFlag" Text="<span></span>업체차량현황" Checked="False"/>
                    <asp:CheckBox runat="server" id="SaleViewFlag" Text="<span></span>매출마감정보" Checked="False"/>
                    <asp:CheckBox runat="server" id="PurchaseViewFlag" Text="<span></span>매입마감정보" Checked="False"/>
                </div>
            </div>
            <div>
                <h1>무선전화 연동</h1>
                <div class="no-margin">
                    <asp:CheckBox runat="server" id="AppUseFlag" Text="<span></span>사용하기" Checked="False"/><asp:Label runat="server" ID="AppMobileNo"></asp:Label>
                    <span>연동을 위해서는 콜매니저 앱<a href="#" id="ViewQR" onclick="return false;">(다운로드 QR 보기)</a>을 설치하시고, 앱 내에서 등록을 완료해 주세요.</span>
                </div>
            </div>
            <div>
                <h1>유선전화 연동</h1>
                <div class="tel_wrap">
                    <div>
                        <h2>
                            연동가능 전화번호
                        </h2>
                        <div class="grid">
                            <div id="CMPersonalSetting1Grid"></div>
                        </div>
                    </div>
                    <div>
                        <button type="button" class="btn_01" onclick="fnAddItem(); return false;">▶</button><Br/><Br/>
                        <button type="button" class="btn_02" onclick="fnRemoveItem(); return false;">◀</button>
                    </div>
                    <div>
                        <h2>
                            연동된 전화번호
                            <button type="button" class="btn_01" id="BtnUpdCMAdminPhone">저장</button>
                        </h2>
                        <div class="grid">
                            <div id="CMPersonalSetting2Grid"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="DivQRCode">
        <img src="<%=strQRCodeImg%>" title="앱다운로드및설치"/>
    </div>
</asp:Content>