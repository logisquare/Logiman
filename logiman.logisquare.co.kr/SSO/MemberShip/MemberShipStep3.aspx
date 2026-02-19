<%@ Page Language="C#" MasterPageFile="~/MemberShip.Master" AutoEventWireup="true" CodeBehind="MemberShipStep3.aspx.cs" Inherits="logiman.logisquare.co.kr.MemberShipStep3" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script>
        function fnTermsClose() {
            $(".membership_terms").hide();
            $(".terms_body > div").hide();
        }

        function fnTermsView(n) {
            $(".membership_terms").show();
            $(".terms_body > div.terms_0" + n).show();
        }
    </script>

    <% if(!string.IsNullOrWhiteSpace(SiteGlobal.GA_CODE_WEB)) {%>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=<%=SiteGlobal.GA_CODE_WEB%>"></script>
        <script> window.dataLayer = window.dataLayer || []; function gtag() { dataLayer.push(arguments); } gtag('js', new Date()); gtag('config', '<%=SiteGlobal.GA_CODE_WEB%>');</script>
    <%}%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="membership_body">
        <ul class="membership_step">
            <li>
                <dl>
                    <dt>STEP 01</dt>
                    <dd>약관동의</dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt>STEP 02</dt>
                    <dd>정보입력</dd>
                </dl>
            </li>
            <li class="on">
                <dl>
                    <dt>STEP 03</dt>
                    <dd>신청완료</dd>
                </dl>
            </li>
        </ul>
        <div class="membership_success">
            <h2>
                <span>SMART LOGISTICS</span>
                <br />디지털 운송관리의 시작
            </h2>
            <dl>
                <dt>

                </dt>
                <dd>
                    <strong>회원가입 신청이 접수되었습니다.</strong>
                    운송사 접수 승인 후 사용 가능합니다.<br />
운송사에 승인을 요청해주세요.
                    <span>대표번호 042-935-3100</span>
                </dd>
            </dl>
            <button type="button" onclick="location.href='/SSO/Login/Login'">로그인 페이지로 이동</button>
        </div>
    </div>
</asp:Content>