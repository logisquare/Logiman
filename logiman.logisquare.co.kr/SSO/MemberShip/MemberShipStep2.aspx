<%@ Page Language="C#" MasterPageFile="~/MemberShip.Master" AutoEventWireup="true" CodeBehind="MemberShipStep2.aspx.cs" Inherits="logiman.logisquare.co.kr.MemberShipStep2" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/MemberShip/Proc/MemberShipStep.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        function fnTermsClose() {
            $(".membership_terms").hide();
            $(".terms_body > div").hide();
        }

        function fnTermsView(n) {
            $(".membership_terms").show();
            $(".terms_body > div.terms_0" + n).show();
        }

        function fnStepInfo(n) {
            if (n === 2) {
                if ($("#CenterCode").val() === "") {
                    fnDefaultAlertFocus("운송사를 선택해주세요.", "CenterCode", "warning", "");
                    return;
                }
                $("div.membership_form div.form_02 > div.form_opacity").fadeOut(500);
                $("#ClientCorpNo").focus();
            } else {
                if ($("#HidCorpNoChk").val() != "Y") {
                    fnDefaultAlertFocus("사업자번호를 조회해주세요1.", "ClientCorpNo", "warning", "");
                    return;
                }
                $("div.membership_form div.form_03 > div.form_opacity").fadeOut(500);
                $("#RegReqType").focus();
            }
            
        }
    </script>

    <% if(!string.IsNullOrWhiteSpace(SiteGlobal.GA_CODE_WEB)) {%>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=<%=SiteGlobal.GA_CODE_WEB%>"></script>
        <script> window.dataLayer = window.dataLayer || []; function gtag() { dataLayer.push(arguments); } gtag('js', new Date()); gtag('config', '<%=SiteGlobal.GA_CODE_WEB%>');</script>
    <%}%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="SecurityFlag" />
    <asp:HiddenField runat="server" ID="HidCorpNoChk" />
    <asp:HiddenField runat="server" ID="hidAdminIDFlag" />
    <div class="membership_body">
        <ul class="membership_step">
            <li>
                <dl>
                    <dt>STEP 01</dt>
                    <dd>약관동의</dd>
                </dl>
            </li>
            <li class="on">
                <dl>
                    <dt>STEP 02</dt>
                    <dd>정보입력</dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt>STEP 03</dt>
                    <dd>신청완료</dd>
                </dl>
            </li>
        </ul>
    </div>

    <div class="membership_form">
        <div style="overflow:hidden;">
            <div class="form_01">
                <h2>
                    <strong>
                        <span>Step1</span> 운송사 선택
                    </strong>
                    <p>거래 중인 운송사를 선택해주세요.</p>
                </h2>
                <div class="form_tb">
                    <table>
                        <colgroup>
                            <col width="100%;"/>
                        </colgroup>
                        <tr>
                            <th>운송사 선택</th>
                        </tr>
                        <tr>
                            <td>
                                <asp:DropDownList runat="server" CssClass="type_100p" ID="CenterCode"></asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="form_btn">
                    <button type="button" class="btn_02 btn_100p" onclick="fnStepInfo(2);">다음</button>
                </div>
            </div>
            <div class="form_02">
                <div class="form_opacity"></div>
                <h2>
                    <strong>
                        <span>Step2</span> 사업자 정보
                    </strong>
                    <p>사업자 정보를 조회해주세요.</p>
                </h2>
                <div class="form_tb">
                    <p class="title"><span class="CenterName"></span>와 거래 중인 사업자만 가능합니다.</p>
                    <table>
                        <colgroup>
                            <col width="100%;"/>
                        </colgroup>
                        <tr>
                            <th>사업자번호</th>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox runat="server" ID="ClientCorpNo" CssClass="type_01 OnlyNumber" placeholder="숫자입력('-'제외)"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="ClientName"/>
                                <button type="button" class="btn_02" id="BtnCorpNoChk" onclick="fnCropNoChk();">조회</button>
                                <button type="button" class="btn_03" id="BtnCorpNoReChk" onclick="fnCropNoChkReset();" style="display:none;">다시입력</button>
                            </td>
                        </tr>
                        <tr>
                            <th>사업자정보</th>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox runat="server" ID="ClientInfo" ReadOnly="true" CssClass="type_03 OnlyNumber" placeholder="사업자/대표자"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                    <p class="cnts" style="display:none;">
                    </p>
                </div>
                <div class="form_btn">
                    <button type="button" class="btn_02 btn_100p" onclick="fnStepInfo(3);">다음</button>
                </div>
            </div>
            <div class="form_03">
                <div class="form_opacity"></div>
                <h2>
                    <strong>
                        <span>Step3</span> 개인정보
                    </strong>
                    <p>개인정보를 입력해주세요.</p>
                </h2>
                <div class="form_tb">
                    <table class="tb_02">
                        <colgroup>
                            <col width="80px;"/>
                            <col width="*;"/>
                        </colgroup>
                        <tr>
                            <th>운송구분</th>
                            <td>
                                <asp:DropDownList runat="server" ID="RegReqType" CssClass="type_100p essential"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>아이디</th>
                            <td>
                                <asp:TextBox runat="server" ID="AdminID" CssClass="type_small essential ml_0" placeholder="영문+숫자 조합"></asp:TextBox>
                                <button type="button" class="btn_02" id="AdminIDBtn" onclick="fnAdminIDChk();">확인</button>
                                <button type="button" class="btn_03" id="AdminIDBtnReturn" style="display:none;" onclick="fnAdminIDChkReset();">재입력</button>
                            </td>
                        </tr>
                        <tr>
                            <th>이름</th>
                            <td>
                                <asp:TextBox runat="server" ID="AdminName" CssClass="type_100p essential ml_0" placeholder="이름을 입력하세요."></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>연락처</th>
                            <td>
                                <asp:TextBox runat="server" ID="TelNo" CssClass="type_100p ml_0" placeholder="연락처를 입력하세요."></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>휴대폰</th>
                            <td>
                                <asp:TextBox runat="server" ID="MobileNo" CssClass="type_100p ml_0 essential" placeholder="휴대폰번호를 입력하세요."></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>소속</th>
                            <td>
                                <asp:TextBox runat="server" ID="DeptName" CssClass="type_100p ml_0" placeholder="부서명을 입력하세요."></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>E-mail</th>
                            <td>
                                <asp:TextBox runat="server" ID="Email" CssClass="type_100p ml_0 essential" placeholder="이메일을 입력하세요."></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>비밀번호</th>
                            <td>
                                <asp:TextBox runat="server" TextMode="password" ID="AdminPwd" CssClass="type_100p ml_0 essential" placeholder="비밀번호를 입력하세요"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <p class="password_text">비밀번호 영문,숫자,특수문자(!@$%^*만 허용)를 혼합 사용하여 8~16자까지</p>
                            </td>
                        </tr>
                        <tr>
                            <th>비밀번호 <br /> 확인</th>
                            <td>
                                <asp:TextBox runat="server" TextMode="password" ID="AdminPwdConfirm" CssClass="type_100p ml_0 essential" placeholder="비밀번호 확인"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="form_btn">
                    <button type="button" class="btn_01 btn_100p" onclick="fnAdminRequestIns();">회원가입</button>
                </div>
            </div>
        </div>
        <div style="text-align:center; margin-top:30px;">
            <button type="button" class="btn_03" style="height:40px; width:150px;" onclick="location.href='/SSO/Login/Login';">취소</button>
        </div>
    </div>
    
</asp:Content>