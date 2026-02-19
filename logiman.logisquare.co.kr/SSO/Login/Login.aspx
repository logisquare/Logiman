<%@ Page Language="C#" MasterPageFile="~/MemberShip.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SSO.Login.Login" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/SSO/Login/Proc/Login.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <% if(!string.IsNullOrWhiteSpace(SiteGlobal.GA_CODE_WEB)) {%>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=<%=SiteGlobal.GA_CODE_WEB%>"></script>
        <script> window.dataLayer = window.dataLayer || []; function gtag() { dataLayer.push(arguments); } gtag('js', new Date()); gtag('config', '<%=SiteGlobal.GA_CODE_WEB%>');</script>
    <%}%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="returnurl" />
    <asp:HiddenField runat="server" ID="errmsg" />
    <asp:HiddenField runat="server" ID="EncSMSAuthNum" />    
    <asp:HiddenField runat="server" ID="AuthInfo" />
    <asp:HiddenField runat="server" ID="AuthFlag" />
    <asp:HiddenField runat="server" ID="SecurityFlag" />
    <asp:HiddenField runat="server" ID="FindPwdFlag" />
        <div class="login_area">
            <div class="login_body">
                <div class="login_form">
                    <h1><!--로고--></h1>
                    <ul class="login_input">
                        <li class="input">
                            <span>아이디</span>
                            <asp:TextBox runat="server" ID="AdminID" MaxLength="30" TabIndex="1" alt="아이디" PlaceHolder="아이디"></asp:TextBox>
                        </li>
                        <li class="input">
                            <span>비밀번호</span>
                            <asp:TextBox TextMode="Password" runat="server" ID="AdminPwd" MaxLength="30" TabIndex="2" alt="패스워드" PlaceHolder="패스워드"></asp:TextBox>
                        </li>
                        <li>
                            <input type="checkbox" name="SaveId" id="SaveId"><label for="SaveId"><span></span> 아이디 저장</label>
                        </li>
                        <li><button type="button" id="btnLogin">로그인</button></li>
                        <li><button type="button" onclick="location.href='/SSO/MemberShip/MembershipStep1';">회원가입</button></li>
                    </ul>
                    <div class="user_find">
                        <a href="javascript:fnOpenPwdChangeLayer();">비밀번호 재발급</a><span>|</span><a href="javascript:fnOpenIdFindLayer();">아이디 찾기</a><span>|</span><a href="javascript:fnCreateBookmark();">즐겨찾기 추가</a>
                    </div>
                </div>
            </div>
            <div class="notice_body">
                <h1>
                    Welcome <br> <span>to</span> <strong>logisquare manager!</strong>
                </h1>
            </div>
        </div>

        <!--비밀번호 재발급-->
        <div id="UserPasswordChange">
            <div class="contents">
                <a href="javascript:fnClosePwdChangeLayer()" class="close_btn"><img src="/images/common/close_wh_icon.png"/></a>
                <h1>
                    비밀번호 재발급
                </h1>
                <p class="sub_text">정보 입력 후 변경하실 새로운 비밀번호를 입력해주세요<br />기타 문의사항은 고객센터 042-935-3100로 문의 바랍니다.</p>
                <dl>
                    <dd>
                        <table>
                            <colgroup>
                                <col style="width:65%"/>
                                <col style="width:30%"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th colspan="2">아이디</th>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:TextBox runat="server" ID="PwdAdminID" CssClass="default" PlaceHolder="아이디" Title="아이디"></asp:TextBox>
                                </td>
                            </tr>
                                <tr>
                                    <th colspan="2">휴대폰번호</th>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox runat="server" ID="PwdMobileNo" class="default OnlyNumber" MaxLength="20" PlaceHolder="휴대폰번호('-' 제외)" Title="휴대폰번호('-' 제외)"></asp:TextBox>
                                    </td>
                                    <td style="text-align:center;">
                                        <button type="button" id="AuthNumberBtn" onclick="fnGetAuthNumber(); return false;" class="btn_dafault">인증번호 받기</button>
                                        <button type="button" id="AuthNumberReturn" onclick="fnResetAuthNumber(); return false;" class="btn_dafault" style="display:none;">다시입력</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox runat="server" ID="AuthNumber" class="default OnlyNumber"  MaxLength="10" autocomplete="off" PlaceHolder="인증번호" Title="인증번호"></asp:TextBox>
                                    </td>
                                    <td style="text-align:center;">
                                        <button type="button" id="AuthNumberChk" onclick="fnCheckAuthNumber()" class="btn_dafault">확인</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </dd>
                </dl>
                <dl>
                    <dd>
                        <table>
                            <colgroup>
                                <col style="width:100%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>비밀번호 변경</th>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox TextMode="Password" runat="server" ID="AdminResetPwd" CssClass="default" PlaceHolder="비밀번호 변경" Title="비밀번호 변경" onKeyDown="return (event.keyCode!=13);"></asp:TextBox>
                                        <p class="info_text">비밀번호는 영문,숫자,특수문자(!@$%^*만 허용)를 혼합 사용하여 8~16자까지</p>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox TextMode="Password" runat="server" ID="AdminResetPwdChk" CssClass="default" PlaceHolder="비밀번호 변경확인" title="비밀번호 변경확인" onKeyDown="return (event.keyCode!=13);"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center;">
                                        <span style="color:#006cb7; display:none;">정상</span>
                                        <span style="color:#f15929; display:none;">비밀번호를 확인해 주세요.</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </dd>
                </dl>
                <div class="button_type_01">
                    <button type="button" onclick="fnResetPassword();" class="l_type_03">비밀번호 변경</button>
                </div>
            </div>
        </div>

        <!--최초 접속 비밀번호 변경-->
        <div id="InitUserPasswordChange">
            <div class="contents">
                <a href="javascript:fnCloseInitPwdChangeLayer()" class="close_btn"><img src="/images/common/close_wh_icon.png"/></a>
                <h1>
                    최초 접속 비밀번호 설정
                </h1>
                <p class="sub_text">변경하실 새로운 비밀번호를 입력해주세요<br />기타 문의사항은 고객센터 042-935-3100로 문의 바랍니다.</p>
                <dl>
                    <dd>
                        <table>
                            <colgroup>
                                <col style="width:100%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>비밀번호 설정</th>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox TextMode="Password" runat="server" ID="AdminInitPwd" CssClass="default" PlaceHolder="비밀번호 변경" Title="비밀번호 변경" onKeyDown="return (event.keyCode!=13);"></asp:TextBox>
                                        <p class="info_text">비밀번호는 영문,숫자,특수문자(!@$%^*만 허용)를 혼합 사용하여 8~16자까지</p>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox TextMode="Password" runat="server" ID="AdminInitPwdChk" CssClass="default" PlaceHolder="비밀번호 변경확인" title="비밀번호 변경확인" onKeyDown="return (event.keyCode!=13);"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center;">
                                        <span style="color:#006cb7; display:none;">정상</span>
                                        <span style="color:#f15929; display:none;">비밀번호를 확인해 주세요.</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </dd>
                </dl>
                <div class="button_type_01">
                    <button type="button" onclick="fnInitPassword();" class="l_type_03">비밀번호 변경</button>
                </div>
            </div>
        </div>

        <div id="UserIdFindLayer">
            <div class="user_id_body">
                <a href="javascript:fnCloseIdFindLayer()" class="close_btn"><img src="/images/common/close_wh_icon.png"/></a>
                <h1>
                    아이디를 잊어버리셨나요?
                </h1>
                <p>개인정보 도용 피해방지를 위하여 일부 아이디에<br /> *표시되어 문자 전송됩니다.<br />기타 문의사항은 고객센터 042-935-3100로 문의 바랍니다.</p>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th colspan="2">사업자등록번호</th>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox runat="server" ID="IdAdminCorpNo" class="default OnlyNumber" MaxLength="10" PlaceHolder="사업자등록번호('-' 제외)" Title="사업자등록번호('-' 제외)" onKeyDown="return (event.keyCode!=13);"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th colspan="2">이름</th>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox runat="server" ID="IdAdminName" class="default"  MaxLength="50" autocomplete="off" PlaceHolder="가입자 이름" Title="가입자 이름" onKeyDown="return (event.keyCode!=13);"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th colspan="2">휴대폰번호</th>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox runat="server" ID="IdMobileNo" class="default OnlyNumber" MaxLength="20" PlaceHolder="휴대폰번호('-' 제외)" Title="휴대폰번호('-' 제외)" onKeyDown="return (event.keyCode!=13);"></asp:TextBox>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="button_type_01">
                    <button type="button" onclick="fnChkAuthID();" class="l_type_03">확인</button>
                </div>
            </div>
        </div>

        <!--구글 QR코드 생성-->
        <div id="GoogleQrCodeLayer">
            <asp:HiddenField runat="server" ID="AUTH_NUMBER"/>
            <asp:HiddenField runat="server" ID="GradeCode"/>
            <asp:HiddenField runat="server" ID="OtpFlag"/>
            <div class="google_layer">
                <a href="javascript:fnCloseGoogleQrCode();" class="close_btn"><img src="/images/common/close_wh_icon.png"></a>
                <div class="top">
                    <h1>구글 OTP코드 입력</h1>
                    <asp:TextBox runat="server" ID="OtpCode" CssClass="OnlyNumber" MaxLength="10" TabIndex="3" alt="구글 OTP코드" autocomplete="off" PlaceHolder="구글 OTP코드"></asp:TextBox>
                    <button type="button" class="btn_01" style="height: 30px;" onclick="fnGoLogin();">확인</button>
                    <div style="margin-top: 30px; text-align: center">
                        <button type="button" class="google_btn" onclick="fnOpenGoogleQrCodeDetail();">구글 보안코드 QR생성 ▼</button>
                    </div>
                </div>
                <div class="bottom">
                    <h1>
                        구글 보안코드 QR 생성
                    </h1>
                    <p>* 계정 인증을 진행하시면 QR코드가 생성됩니다.<span>(← 글씨에 마우스 커서를 올려보세요.)</span></p>
                    <table>
                        <colgroup>
                            <col style="width:20%"/>
                            <col style="width:30%"/>
                            <col style="width:20%"/>
                            <col style="width:30%"/>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>아이디</th>
                                <td>
                                    <asp:TextBox runat="server" ID="AUTH_ADMIN_ID" placeholder="아이디 입력"></asp:TextBox>
                                </td>
                                <th>휴대폰번호</th>
                                <td>
                                    <asp:TextBox runat="server" ID="AUTH_CELL" CssClass="OnlyNumber" MaxLength="20" placeholder="휴대폰번호 입력('-'제외)"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 10px 0;">
                                    <button type="button" onclick="fnSmsAdminAuth();" id="AUTH_BTN" style="padding: 0 10px; height: 30px;" class="SMSSendButton">인증번호 받기</button>
                                    <button type="button" onclick="fnAuthReset();" id="RESET_BTN" style="display: none;" class="ResetButton">다시입력</button>
                                </td>
                            </tr>
                            <tr style="display: none;" id="AuthTr">
                                <th>인증번호</th>
                                <td colspan="3">
                                    <asp:TextBox runat="server" id="ADMIN_AUTH_NUMBER" CssClass="OnlyNumber" MaxLength="10" style="width:150px;" placeholder="인증번호 입력"></asp:TextBox>
                                    <button type="button" onclick="fnSmsAdminAuthSend();" style="padding: 0 10px; height: 30px;" class="SMSSendButton">인증하기</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <div class="qr_code_exp">
                        <strong>구글 OTP 인증으로 로그인 하시려면 아래의 절차를 진행해주세요</strong>
                        <ul>
                            <li>1. 스마트폰에 Google Authenticator 앱 설치</li>
                            <li>2. 앱 접속 후 구글 계정 로그인</li>
                            <li>3. 코드 추가 버튼 선택</li>
                            <li>4. QR코드 스캔 선택</li>
                            <li>5. 웹 브라우저 화면의 QR코드 인식</li>
                            <li style="margin-top: 10px; font-size: 13px; color: red;">* OR 인증은 최초 1회만 진행하며, 이후 구글 OTP의 카고매니저 보안코드를 통해 접속</li>
                        </ul>
                    </div>
                    <div class="qr_area" id="QR_CODE_AREA" style="display: none;">
                        <img src="" id="QR_CODE_IMG"/>
                    </div>
                    <div class="goggle_btn">
                        <button type="button" class="ResetButton" onclick="fnCloseGoogleQrCodeDetail();">닫기</button>
                    </div>
                </div>
            </div>
        </div>
</asp:Content>