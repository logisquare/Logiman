<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogimanAgree2.aspx.cs" Inherits="logiman.logisquare.co.kr.LogimanAgree2" %>
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
            <h1>개인정보 처리방침</h1>
            <textarea class="agree_text" cols="30" rows="5" readonly >주식회사 로지스퀘어(이하 “회사”라 함)는「개인정보보호법」및「정보통신망 이용촉진 및 정보보호 등에 관한 법률」등 관련 법령을 준수하며, 서비스 이용자의 개인정보 보호를 중요시 하고, 이용자가 회사의 서비스를 이용함과 동시에 회사에 제공한 개인정보가 보호 받을 수 있도록 최선을 다한다. 이에 회사는 이용자의 개인정보 및 권익을 보호하고, 개인정보와 관련한 고충을 원활하게 처리할 수 있도록 개인정보처리 방침을 수립하여 공개한다.
회사의 "개인정보처리 방침"은 다음과 같은 내용을 담고 있다.
1. 개인정보의 처리 목적
2. 개인정보의 처리 및 보유기간
3. 개인정보의 제3자 제공
4. 개인정보 처리의 위탁
5. 정보주체의 권리·의무 및 그 행사방법
6. 개인정보의 파기
7. 개인정보의 안전성 확보조치
8. 개인정보보호 책임자 등 연락처
9. 권익침해 구제방법
10. 개인정보 처리방침의 변경
제1조 개인정보의 처리 목적
회사는 다음 목적을 위하여 개인정보를 처리하며, 다음의 목적 이외의 용도로는 이용하지 않으며, 이용 목적이 변경되는 경우에는 관련 법령에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정이다.
1. 이용자 관리 및 사용 동의 등 서비스 제공에 따른 본인 확인 및 개인 식별, 자격 유지 및 관리 등을 목적으로 개인정보를 처리한다.
2. 약관에 의한 운송관리 과정에서 화물운송 의뢰 및 운송 진행, 오더 확인, 배차/배송 상태 조회, 운송비 조회, 사진 및 인수증 조회, 위치정보 조회 등의 관리를 위한 목적으로 개인정보를 처리한다.
4. 시스템의 유지보수, 개선 등의 목적으로 사용될 때 개인정보를 처리한다.
제2조 개인정보의 처리 및 보유 기간
1. 회사는 법령에 따른 개인정보 보유 및 이용기간 또는 정보 주체로부터 개인정보 수집 때 동의 받은 개인정보 보유 및 이용기간 내에서 처리, 보유한다.
2. 개인정보 처리 및 보유기간은 다음과 같다.
1) 수집 정보항목
① 사업자 정보 : 등록번호, 법인명, 대표자명, 주소, 사업의 종류
② 이용자 정보 : 성명, 전화번호, 휴대폰 번호, 소속 법인명, 이메일, 본인인증 정보
③ 거래 정보 : 화물 및 화물운송 거래 정보, 배차, 송장, 인수증 등 정보
2) 수집 방법
① 이용(거래) 개시 및 성립 시 정보 수집
② 담당자가 이메일, 전화, 문자를 통한 정보 수집 등
3) 보유 기간
이용자가 회사에서 제공하는 서비스를 이용하는 동안 회사는 이용자의 개인정보를 서비스 제공을 위해 보유하고, 계약 종료(탈회) 또는 이용자의 파기 요청 시점까지로 한다.
단, 다음의 정보에 대해서는 아래의 사유로 명시한 기간 동안 보존한다.
① 회원 가입 및 관리 : 가입 시점부터 탈퇴시까지 (다만, 다음의 사유에 해당하는 경우에는 해당 사유 종료시까지)
가. 관계 법령 위반에 따른 수사 ∙ 조사 등이 진행 중인 경우에는 해당 수사 ∙ 조사 종료시까지
나. 서비스 이용에 따른 채권 ∙ 채무관계 잔존 시에는 해당 채권 ∙ 채무관계 정산 시까지
② 재화 또는 서비스 제공 : 재화 ∙ 서비스 공급완료 및 요금정산 / 정산 완료 시까지 (다만, 다음의 사유에 해당하는 경우에는 해당 기간 종료 시까지)
가. 전자상거래 등에서의 소비자 보호에 관한 법률
· 계약 또는 청약철회, 대금결제, 재화 등의 공급기록 : 5년
· 소비자 불만 또는 분쟁처리에 관한 기록 : 3년
나.	부정사용 방지를 위한 회사 내부 방침
· 부정사용 기록 : 10년
다. 정보통신망 이용촉진 및 정보보호 등에 관한 법률
· 본인 확인에 관한 기록 : 6개월
라. 신용정보의 이용 및 보호에 관한 법률
· 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년
마.	통신비밀보호법
· 방문에 관한 기록 : 3개월
제3조 개인정보의 제3자 제공
회사는 이용자의 개인정보를 "제1조. 개인정보의 처리 목적" 범위 내에서 처리하고, 다음에 해당하는 경우에만 개인정보를 제3자에게 제공한다.
1. 정보 주체의 동의를 받은 경우
2. 다른 법률 등에 특별한 규정이 있는 경우
제4조 개인정보 처리의 위탁
1. 회사는 시스템의 유지관리 및 전화상담 업무의 원활한 처리를 위하여 다음과 같이 개인정보 처리업무를 위탁할 수 있다.
1) 시스템 유지보수 및 상담
가. 수탁업체 : ㈜로지스랩
나. 위탁업무 내용 : 시스템 유지보수 및 상담
2) 휴대폰 본인인증
가. 수탁업체: NHN한국사이버결제(주)
나. 위탁업무 내용: 회원 가입을 위한 휴대폰 본인 인증
3) 카카오톡 알림톡 발송
가. 수탁업체: (주)엠앤와이즈
나. 위탁업무 내용: 운송 및 배차 상태 등 운송 서비스 이용에 필요한 통보, 서비스 이용 약관 및 개인정보처리방침 변경 통보
4) SMS발송
가. 수탁업체: (주)링큿허브
나. 위탁업무 내용: 운송 및 배차 상태 등 운송 서비스 이용에 필요한 통보, 서비스 이용 약관 및 개인정보처리방침 변경 통보
5) 상기 1)항은 위탁계약 종료시까지 적용하며, 2), 3), 4)항의 개인정보 보유 및 이용기간은 탈퇴시 혹은 계약 종료시까지로 한다. 단, 관련 법령에 따라 보존할 필요가 있는 경우 해당 보존기간을 적용한다.
2. 회사는 위탁업무 내용이나 수탁자가 변경될 경우 지체 없이 본 개인정보 처리방침을 공개한다.
제5조 정보주체 권리·의무 및 그 행사방법
정보주체는 자신의 개인정보 처리와 관련하여 다음과 같은 권리를 행사할 수 있다.
1. 정보주체 권리 의무
1) 개인정보 열람 요구
2) 개인정보 오류 등이 있을 경우 정정 요구
3) 개인정보 삭제 요구
4) 개인정보 처리 정지 요구
2. 권리 행사 방법
1) 개인정보의 열람 · 정정 · 삭제 · 처리 정지 등은 "제8조. 개인정보보호 책임자 및 개인정보보호 담당자에게 연락(서면, 전화, 이메일) 하면 지체 없이 조치한다.
2) 개인정보 오류를 정보주체가 요청한 경우는 정정을 완료하기 전까지 당해 개인정보의 이용 및 제공을 하지 않으며, 또한 제3자에게 오류 정보를 제공한 경우, 지체 없이 통지하여 정정이 이루어지도록 한다.
3) 회사는 정보주체의 요청에 의해 삭제된 개인정보는 "제2조. 개인정보의 처리 및 보유 기간"에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있다.
제6조 개인정보의 파기
회사의 개인정보 파기절차 및 방법은 다음과 같다.
1. 파기절차
o	개인정보는 보유기간 경과, 처리목적 달성 등 그 개인정보가 불필요하게 되었을 때 지체 없이 개인정보를 파기한다. 다만, 다른 법령에 따라 보존해야 하는 경우에는 그러하지 아니한다.
2. 파기방법
o	개인정보가 전자적 파일 형태인 경우는 복원이 불가능한 방법으로 영구 삭제하고, 전자적 파일 이외의 기록물, 인쇄물, 서면, 그 밖의 기록 매체인 경우에는 분쇄 또는 소각하여 파기한다.
제7조 개인정보의 안전성 확보조치
회사는 개인정보의 안정성 확보를 위하여 다음과 같은 기술적·관리적 및 물리적 조치를 취하고 있다.
1. 기술적 조치
o	개인정보 유출 및 훼손을 방지하기 위해 보안프로그램 및 침입차단시스템을 설치하여 운영하고 있으며, 개인정보에 대한 접근 통제 및 암호화 저장과 주기적 점검 등
2. 관리적 조치
o	개인정보 유출 및 훼손을 방지하기 위해 보안프로그램 및 침입차단시스템을 설치하여 운영하고 있으며, 개인정보에 대한 접근 통제 및 암호화 저장과 주기적 점검 등 개인정보 취급 담당자 최소화 및 취급자의 정기교육 등을 통해 개인정보 보호 강화
3. 물리적 조치
o	정보시스템실 및 자료 보관실 등의 출입 통제
제8조 개인정보보호 책임자 등 연락처
회사는 개인정보 처리와 관련된 정보주체의 불만처리 및 구제 등을 위하여 다음과 같이 개인정보보호책임자 및 담당자를 지정하여 운영하고 있다.
1. 개인정보보호책임자
o	1) 소속명 및 성명 : 경영지원실 이규범 상무
o	2) E-Mail : lkbst@logisquare.co.kr
2. 개인정보보호담당자
1) 소속명 및 성명 : 운영혁신팀 문승일 팀장
2) 연락처 : 042-935-3100
3) E-Mail : munsi21@logisquare.co.kr
제9조 권익침해 구제방법
정보주체는 개인정보 침해에 대한 피해구제, 상담 등을 다음 기관에 신청할 수 있다.
1) 개인정보침해신고센터 : http://privacy.kisa.or.kr (국번없이 118)
2) 개인정보분쟁조정위원회 : http://www.kopico.go.kr (1833-6972)
3) 대검찰청 사이버수사과 : http://www.spo.go.kr (국번없이1301)
4) 경찰청 사이버안전국 : http://cyberbureau.police.go.kr (국번없이182)
제10조 개인정보처리방침의 변경에 관한 사항(고지의 의무)
본 개인정보처리방침은 2022년 11월 10일에 제정되었으며, 법령 및 방침의 내용 추가, 변경, 삭제 및 정정이 있는 경우에는 로지맨 화주용 시스템 공지사항 또는 전자적 형태(전자우편, SMS 등)를 통해 지체 없이 공지하며 공지한 날로부터 시행된다. 다만, 개인정보의 수집 및 활용, 제3자 제공 등과 같이 이용자 권리의 중요한 변경이 있을 경우에는 최소 30일 전에 고지한다.
부칙
본 개인정보처리방침은 2022년 11월 10일부터 시행한다.

            </textarea>
            <div class="agree_btn">
                <button class="btn_03" onclick="self.close();">닫기</button>
            </div>
            
        </div>
    </form>
</body>
