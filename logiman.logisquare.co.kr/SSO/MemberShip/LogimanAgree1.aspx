<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogimanAgree1.aspx.cs" Inherits="logiman.logisquare.co.kr.LogimanAgree1" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>
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
    <%: Scripts.Render("~/bundles/LibJS") %>
    <script type="text/javascript" src="/js/lib/jquery-ui/jquery-ui.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/common.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/utils.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <%: Scripts.Render("~/js/lib/sweetalert2/sweetalert2.js") %>
    <link rel="icon" href="/images/icon/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="/css/sweetalert2.min.css" />
    <link rel="stylesheet" href="/css/style.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <link rel="stylesheet" href="/css/notosanskr.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <link rel="stylesheet" runat="server" ID="ThemeStyle" />

    <% if(!string.IsNullOrWhiteSpace(SiteGlobal.GA_CODE_WEB)) {%>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=<%=SiteGlobal.GA_CODE_WEB%>"></script>
        <script> window.dataLayer = window.dataLayer || []; function gtag() { dataLayer.push(arguments); } gtag('js', new Date()); gtag('config', '<%=SiteGlobal.GA_CODE_WEB%>');</script>
    <%}%>
</head>
<body>
    <form id="form1" runat="server">
        <div class="agree_warp">
            <h1>서비스 이용약관</h1>
            <textarea class="agree_text" cols="30" rows="5" readonly >제1조 (목적)
본 약관은 주식회사 로지스퀘어(이하 "회사"라 함)가 운영하는 로지맨 화주용 시스템(이하 "시스템"이라 함)의 이용에 관한 제반사항을 규정함에 목적이 있다.
제2조 (용어의 정의)
본 약관에서 사용하는 용어는 다음과 같이 정의한다.
1. 로지맨 화주용 시스템 : 로지스퀘어의 화물운송 서비스를 제공하기 위한 WEB 기반의 운송관리 시스템을 말한다.
2. 운송관리 : “시스템”을 통한 화물운송 의뢰 및 운송 진행, 오더 확인, 배차/배송 상태 조회, 운송비 조회, 운송비 결제, 차량 위치정보 전송 등의 운송관리를 말한다.
3. 이 용 자 : 본 약관에 따라 시스템을 이용(등록)하는 사용자(회원)를 말한다.
4. 아 이 디 : 이용자가 시스템 사용을 위해 문자와 숫자 등으로 정한 조합을 말한다.
5. 비밀번호 : 이용자의 아이디 일치 여부 확인 및 비밀 보호를 위해 정한 문자와 숫자의 조합을 말한다.
6. 본인인증 : 본 시스템을 사용하기 위하여 휴대폰 본인인증 또는 기타 방법을 통하여 이용자 본인이 틀림 없음을 확인하는 인증을 말한다.
제3조 (약관의 효력과 변경)
1. 본 약관의 효력은 시스템을 사용하고자 하는 이용자가 이용약관에 동의함으로써 발생한다.
2. 회사는 본 약관을 변경할 경우 이용자가 직접 확인할 수 있도록 1개월간 시스템 또는 전자적 형태(전자우편, SMS 등)로 변경 내용을 공지하여야 한다. 이용자가 변경 약관에 동의하지 않는 경우 이용자는 본인의 이용자 등록을 취소(탈회)할 수 있으며, 계속 사용의 경우에는 변경 약관에 대한 동의로 간주한다. 이 경우 변경 약관의 효력은 변경사항을 공지한 날로부터 1개월 후에 발생한다.
제4조 (약관 외 관계 법령의 적용사항)
본 약관에 명시되지 않은 사항과 본 약관의 해석에 관해서는 관계 법령 또는 상관례에 의한다.
제5조 (적용범위)
본 약관은 회사와 시스템을 사용하는 이용자간의 운송관리, 문서교환 등 일체의 사항에 적용한다.
제6조 (회원가입 및 정보의 변경)
1. 이용자는 회사가 정한 방식에 따라 본 서비스 및 개인정보처리방침 등의 내용을 확인하고, 이에 동의한다는 의사를 표시하고 회원 가입을 신청해야 하며, 본인인증을 통하여 회원으로 등록해야 한다. 단, 당사의 화주사 및 그 화주사의 고객, 협력사는 회원가입을 신청한 후 당사 운영 관리자의 승인을 득해야 본 시스템을 사용할 수 있다.
2. 회원(화주사, 화주사의 고객사, 협력사)의 서비스 종류 및 이용 목적에 따라 회원별로 차별화된 서비스를 제공할 수 있다.
3. 이용자는 회원 가입시 기재한 사항이 변경된 경우 온라인으로 수정하거나 전자우편, 기타 방법으로 회사에 변경사항을 알려야 한다. 만약 이용자가 변경사항을 알리지 않아 발생한 불이익에 대해서는 회사가 책임지지 않는다.
제7조 (서비스의 종류)
시스템이 제공하는 서비스는 다음과 같다. 단, 제공 서비스 내용의 추가 · 변경이 발생하는 경우 이용자가 직접 확인할 수 있도록 시스템 내 또는 전자적 형태(전자우편, SMS 등)로 별도 공지한다.
1. 운송 관리
1) 화물운송 의뢰 및 운송 진행, 오더의 확인, 배차 및 내역 조회
2) 화물운송 진행상태 조회, 화물 사진 및 인수증 조회
3) 차량 위치정보 조회 등
2. 운송비 관리
1) 운송비 정산 내역 조회
2) 운송비 세금계산서 발행 여부 조회
3) 운송비 카드 결제 등
제8조 (시스템 이용시간)
1. 시스템의 이용시간은 연중무휴, 1일 24시간을 원칙으로 한다. 단, 담당자를 통한 서비스는 회사 근무시간을 기준으로 제한할 수 있다.
2. 제1항의 이용시간은 시스템 정기점검 또는 업무 · 기술상 특별한 사정으로 점검이 필요한 날 또는 시간은 예외로 한다. 이 경우 시스템 관리자는 이용자가 확인할 수 있도록 사전에 이용 중단 날 또는 시간을 공지하여야 한다.
제9조 (서비스 제공의 변경 및 중단)
1. 서비스 종목의 변경 및 통합 등 불가피한 사정이 발생하거나, 필요한 경우 이용자들에게 제공하는 서비스 내용이 변경 또는 중단될 수 있다.
2. 시스템의 보수, 점검, 교체, 고장, 통신장애, 천재지변 등 부득이한 사유가 발생하여 일시적으로 서비스가 변경 및 중단될 수 있으며, 이 경우 이용자들에게 변경 및 중단사항을 공지한다.
3. 회사는 서비스 변경 및 중단 등으로 발생한 이용자 또는 제3자가 입은 손해에 대하여 책임을 부담하지 않는다.
제10조 (정보 제공 및 홍보물 등 게재)
1. 서비스 운영에 따른 각종 정보를 이용자에게 시스템에서 공지사항 등의 방법으로 제공한다.
2. 서비스 운영에 필요하거나 활용 가능성이 있는 홍보물 및 교육 자료 등을 공지사항에 게재할 수 있다.
제11조 (저작권의 귀속 및 사용제한)
1. 회사가 제공하는 시스템에 관한 저작권 및 기타 지적재산권은 회사에 귀속된다.
2. 이용자가 시스템을 사용하면서 얻는 정보를 회사의 사전 승낙 없이 복제, 송신, 배포 등 기타 방법에 의하여 영리목적으로 사용하거나 제3자에게 사용하게 해서는 안된다.
3. 이용자가 타인의 저작권을 침해함으로써 발생하는 민·형사상의 책임은 전적으로 본인이 부담한다.
제12조 (회사의 책임과 의무)
1. 회사는 본 이용약관 및 관계 법령이 규정하는 사항을 준수한다.
2. 회사는 이용자에게 계속적이고 안정적으로 서비스를 제공해야 한다.
3. 회사는 이용자로부터 제기되는 불만사항이 정당하다고 인정되는 경우에는 이를 지체 없이 처리한다. 다만, 즉시 처리가 곤란한 사정이 있을 경우 당해 이용자에게 그 사유를 통보한다.
제13조 (이용자의 책임과 의무)
1. 이용자는 본 약관 및 관계 법령이 규정하는 사항을 준수한다.
2. 이용자 아이디 및 비밀번호에 관한 모든 관리 책임은 당해 이용자에게 있다.
3. 이용자는 아이디 및 비밀번호를 타인에게 양도하거나 사용하게 승낙할 수 없다.
4. 이용자는 아이디 및 비밀번호를 도난 당하거나 제3자가 무단으로 사용하고 있음을 인지한 경우에는 즉시 회사 개인정보보호담당자(042-935-3100)에게 통보하고, 회사의 안내가 있는 경우 그에 따라 조치한다.
5. 이용자는 회원 가입시, 비밀번호 등 정보의 변경, 탈회 등을 할 때 시스템의 본인인증 절차에 따라 진행한다.
제14조 (이용자에 대한 통지 및 탈회)
1. 회사는 시스템 공지사항 게시 또는 전자적 형태(전자우편, SMS, 푸쉬 알림 등)를 통하여 이용자에게 통지할 수 있다. 회사가 불특정 다수 회원에게 통지할 경우 공지사항에 게재함으로써 개별통지를 갈음할 수 있다. 단, 회원 본인에게 중대한 영향을 미치는 사항이거나 불특정 소수에게는 개별통지를 원칙으로 한다.
2. 이용자는 언제든지 탈회할 수 있으며, 회사는 이용자 본인임(본인 인증)을 확인한 후 탈회 처리한다.
3. 회사는 다음과 같은 사유가 발생하거나 확인된 경우 이용자를 탈퇴시킬 수 있다.
1) 이용자가 본 약관에서 정한 사항을 준수하지 않을 경우.
2) 다른 회원의 권리, 명예, 신용을 침해하거나 관련 법령 등에 위배되는 행위를 한 경우
3) 회사가 제공하는 서비스의 진행을 방해하는 행위를 하거나 시도한 경우
제15조 (면책사항)
1. 회사는 천재지변, 전쟁, 폭동, 내란, 법령의 개폐 및 제정, 행정처분, 통신사업장의 서비스 중지, 기타 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우 책임을 지지 않는다.
2. 회사는 이용자의 귀책사유로 인한 서비스 이용장애에 대해서는 책임을 지지 않는다.
3. 회사는 이용자 간에 자발적으로 이뤄진 정보 및 서비스 교류, 물품 및 금전 거래 등으로 인하여 발생한 손해에 대해서는 책임을 지지 않는다.
4. 회사는 시스템 관리자가 고의로 행한 범죄 행위를 제외하고는 제공 서비스와 관련하여 이용자에게 발생한 손해에 대하여 책임을 지지 않는다.
5. 회사는 무료로 제공하는 정보 및 서비스에 관하여 약관 및 관계 법령 등에 위배되지 않는 한 원칙적으로 손해 배상할 책임을 지지 않는다.
제16조 (분쟁 해결 및 관할법원)
1. 본 약관에서 정하지 않은 사항으로 발생한 분쟁에 대해서는 관계 법령 및 상관례에 따른다.
2. 본 서비스 이용과 관련하여 발생한 분쟁에 대해 소송이 제기될 경우 “회사” 소재지 법원을 제1심 관할 법원으로 한다.
부칙
1. 본 이용약관은 2022년 11월 10일부터 시행한다.
            </textarea>
            <div class="agree_btn">
                <button class="btn_03" onclick="self.close();">닫기</button>
            </div>
            
        </div>
    </form>
</body>
