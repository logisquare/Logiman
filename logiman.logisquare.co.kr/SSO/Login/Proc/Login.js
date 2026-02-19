var strInitPwd = "";
var strResetPwd = "";

$(document).ready(function () {
    if ($("#errmsg").val() != "") {
        fnDefaultAlert($("#errmsg").val());
    }

    if ($.cookie("LoginId") != "") {
        $("#AdminID").val($.cookie("LoginId"));
        $("#SaveId").prop("checked", true);
        $("#AdminPwd").focus();
    }

    $(".membership_header").remove();//회원가입 페이지 공통 노드 제거

    $('.OnlyNumber').on('keyup blur', function () {
        $(this).val($(this).val().replace(/[^0-9]/g, ""));
    });

    $("#AdminID").keyup(function (event) {
        if (event.which == 13) {
            event.preventDefault();
            fnGoLogin();
            return;
        }
    });

    $("#AdminPwd").keyup(function (event) {
        if (event.which == 13) {
            event.preventDefault();
            fnGoLogin();
            return;
        }
    });

    $("#UserPasswordChange input[type=text]").keyup(function (event) {
        if (event.which == 13) {
            event.preventDefault();

            if ($(this).attr("id") === "PwdAdminID" || $(this).attr("id") === "PwdMobileNo") {
                if ($("#AuthNumberBtn").css("display") === "none") {
                    fnCheckAuthNumber();
                } else {
                    fnGetAuthNumber();
                }
                return;
            } else {
                fnCheckAuthNumber();
                return;
            }
        }
    });

    $("#UserPasswordChange input[type=password]").keyup(function (event) {
        if ($(this).attr("id") === "AdminResetPwd") {
            if ($(this).val() === "") {
                $("#UserPasswordChange p.info_text").css("color", "#E23D77").text("비밀번호는 영문,숫자,특수문자(!@$%^*만 허용)를 혼합 사용하여 8~16자까지");
                $("#SecurityFlag").val("");
            }

            if (strResetPwd !== $(this).val()) {
                $("#SecurityFlag").val("");
            }
        }

        if (event.which == 13) {
            event.preventDefault();
            fnResetPassword();
            return;
        }
    });

    $("#AdminResetPwd").on("focusin", function () {
        strResetPwd = $(this).val();
    }).blur(function () {
        if ($(this).val() !== "") {
            var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
            var strCallBackFunc = "fnResetPwdPolicySuccResult";

            var objParam = {
                CallType: "CheckAdminPwdPolicy",
                AdminResetPwd: $(this).val()
            }

            UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
            return;
        }
    });

    $("#GoogleQrCodeLayer input[type=text]").keyup(function (event) {
        if (event.which == 13) {
            event.preventDefault();

            if ($(this).attr("id") === "OtpCode") {
                fnGoLogin();
                return;
            } else if ($(this).attr("id") === "AUTH_CELL") {
                if ($("#AUTH_BTN").css("display") === "none") {
                    fnSmsAdminAuthSend();
                } else {
                    fnSmsAdminAuth();
                }
                return;
            } else {
                fnSmsAdminAuthSend();
                return;
            }
        }
    });

    $("#UserIdFindLayer input[type=text]").keyup(function (event) {
        if (event.which == 13) {
            event.preventDefault();
            fnChkAuthID();
            return;
        }
    });

    $("#InitUserPasswordChange input[type=password]").keyup(function (event) {
        if ($(this).attr("id") === "AdminInitPwd") {
            if ($(this).val() === "") {
                $("#InitUserPasswordChange p.info_text").css("color", "#E23D77").text("비밀번호는 영문,숫자,특수문자(!@$%^*만 허용)를 혼합 사용하여 8~16자까지");
                $("#SecurityFlag").val("");
            }

            if (strInitPwd !== $(this).val()) {
                $("#SecurityFlag").val("");
            }
        } 

        if (event.which == 13) {
            event.preventDefault();
            fnInitPassword();
            return;
        }
    });

    $("#AdminInitPwd").on("focusin", function () {
        strInitPwd = $(this).val();
    }).blur(function () {
        if ($(this).val() !== "") {
            var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
            var strCallBackFunc = "fnInitPwdPolicySuccResult";

            var objParam = {
                CallType: "CheckAdminPwdPolicy",
                AdminResetPwd: $("#AdminInitPwd").val()
            }

            UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
        }
    });

    $("#btnLogin").on("click", function (event) {
        event.preventDefault();
        fnGoLogin();
    });
});

/*************************/
//로그인 시작
/*************************/
function fnChkLogin() {
    if ($("#AdminID").val() == "") {
        fnDefaultAlertFocus("로그인 아이디를 입력하세요.", "AdminID", "warning");
        return false;
    }

    if ($("#AdminPwd").val() == "") {
        fnDefaultAlertFocus("패스워드를 입력하세요.", "AdminPwd", "warning");
        return false;
    }

    if ($("#GradeCode").val()) {
        if (!$("#OtpCode").val()) {
            fnDefaultAlertFocus("구글 OTP코드를 입력하세요.", "OtpCode", "warning");
            return false;
        }
    }

    return true;
}

function fnGoLogin() {
    if (!fnChkLogin()) {
        return false;
    }

    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxLoginSuccResult";
    var objParam = {
        CallType: "chkLogin",
        AdminID: $("#AdminID").val(),
        AdminPwd: $("#AdminPwd").val(),
        OtpCode: $("#OtpCode").val(),
        OtpFlag: $("#OtpFlag").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    return false;
}

function fnAjaxLoginSuccResult(data) {
    if (data[0].RetCode !== 0) {
        if (data[0].RetCode === 22000) {
            fnDefaultAlert("비밀번호 설정이 필요한 최초 로그인입니다.<br/>비밀번호 설정 후 다시 로그인해 주세요.", "info");
            fnOpenInitPwdChangeLayer();
            return false;
        }

        fnDefaultAlert("로그인을 실패하였습니다. 나중에 다시 시도해 주세요.<br/>(" + data[0].ErrMsg + ")");
        return false;
    } else {
        if (data[0].OtpFlag === "Y") {
            $("#GradeCode").val(data[0].GradeCode);
            $("#OtpFlag").val(data[0].OtpFlag);
            fnOpenGoogleQrCode();
            return false;
        }

        fnDefaultAlert(data[0].LastLoginNotice, "success", "fnRootPageReplace", $("#returnurl").val());

        if ($("#SaveId").is(":checked")) {
            $.cookie("LoginId", $("#AdminID").val(), { expires: 365, path: "/" });
        } else {
            $.cookie("LoginId", "", { expires: 365, path: "/" });
        }
    }
}
/*************************/
//로그인 끝
/*************************/

/*************************/
//비밀번호 재발급 시작
/*************************/

function fnOpenPwdChangeLayer() {
    fnResetPwdChangeLayer();
    $("#UserPasswordChange").show();
    $("#PwdAdminID").focus();
    return false;
}

function fnClosePwdChangeLayer() {
    fnResetPwdChangeLayer();
    $("#UserPasswordChange").hide();
    return false;
}

function fnResetPwdChangeLayer() {
    $("#SecurityFlag").val("");
    $("#EncSMSAuthNum").val("");
    $("#AuthInfo").val("");
    $("#AuthFlag").val(""); 
    $("#PwdAdminID").val("");
    $("#PwdAdminID").attr("readonly", false);
    $("#PwdMobileNo").val("");
    $("#PwdMobileNo").attr("readonly", false);
    $("#AuthNumberBtn").show();
    $("#AuthNumberReturn").hide();    
    $("#AuthNumber").val("");
    $("#AuthNumber").attr("readonly", true);
    $("#AdminResetPwd").val("");
    $("#AdminResetPwdChk").val("");
    $("#UserPasswordChange p.info_text").css("color", "#E23D77").text("비밀번호는 영문,숫자,특수문자(!@$%^*만 허용)를 혼합 사용하여 8~16자까지");
    return false;
}

//비밀번호 재발급 - 인증번호 받기 세팅
function fnResetAuthNumber() {
    $("#EncSMSAuthNum").val("");
    $("#AuthInfo").val("");
    $("#AuthFlag").val("");
    $("#PwdAdminID").val("");
    $("#PwdAdminID").attr("readonly", false);
    $("#PwdMobileNo").val("");
    $("#PwdMobileNo").attr("readonly", false);
    $("#AuthNumberBtn").show();
    $("#AuthNumberReturn").hide();
    $("#AuthNumber").val("");
    $("#AuthNumber").attr("readonly", true);
    $("#PwdAdminID").focus();
    return false;
}

function fnGetAuthNumber() {
    $("#EncSMSAuthNum").val("");
    $("#AuthInfo").val("");
    $("#AuthFlag").val("");

    if (!$("#PwdAdminID").val()) {
        fnDefaultAlertFocus("아이디를 입력해주세요.", "PwdAdminID", "warning");
        return false;
    }

    if (!$("#PwdMobileNo").val()) {
        fnDefaultAlertFocus("휴대폰 번호를 입력해주세요.", "PwdMobileNo", "warning");
        return false;
    }

    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxAuthNumSuccResult";
    var objParam = {
        CallType: "AdminPwdReset",
        AdminID: $("#PwdAdminID").val(),
        MobileNo: $("#PwdMobileNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    return false;
}

function fnAjaxAuthNumSuccResult(data) {

    if (data[0].RetCode !== 0) {
        fnDefaultAlert("인증번호 요청을 실패하였습니다. 나중에 다시 시도해 주세요.<br/>(" + data[0].ErrMsg + ")");
        return false;
    } else {
        $("#EncSMSAuthNum").val(data[0].EncSMSAuthNum);
        $("#AuthInfo").val(data[0].AuthInfo);
        $("#PwdAdminID").attr("readonly", true);
        $("#PwdMobileNo").attr("readonly", true);
        $("#AuthNumberBtn").hide();
        $("#AuthNumberReturn").show();
        $("#AuthNumber").attr("readonly", false);
        fnDefaultAlertFocus("인증번호를 요청하였습니다.", "AuthNumber", "success");
        return false;
    }
}

//인증번호 받기 세팅
function fnCheckAuthNumber() {
    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxChkAuthSuccResult";

    if (!$("#EncSMSAuthNum").val()) {
        fnDefaultAlert("인증번호를 다시 요청하세요.", "warning");
        return false;
    }

    if (!$("#AuthNumber").val()) {
        fnDefaultAlert("인증 번호를 입력해주세요.", "warning");
        return false;
    }

    var objParam = {
        CallType: "CheckSMSAuthNum",
        EncSMSAuthNum: $("#EncSMSAuthNum").val(),
        AuthNumber: $("#AuthNumber").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    return false;
}

function fnAjaxChkAuthSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("인증번호가 다릅니다. 다시 확인해주세요.");
        return false;
    } else {
        $("#AuthFlag").val("Y");
        $("#AuthNumber").attr("readonly", true);
        fnDefaultAlertFocus("인증이 완료되었습니다.", "AdminResetPwd", "success");
        return false;
    }
}

function fnResetPwdPolicySuccResult(data) {
    if (data[0].RetCode !== 0) {
        $("#UserPasswordChange p.info_text").css("color", "#E23D77").text(data[0].ErrMsg);
        $("#SecurityFlag").val("");
        return false;
    } else {
        $("#UserPasswordChange p.info_text").css("color", "#0095F6").text("안전한 비밀번호입니다.");
        $("#SecurityFlag").val("Y");
        return false;
    }
}

function fnResetPassword() {
    if (!$("#EncSMSAuthNum").val() || !$("#AuthInfo").val() || !$("#AuthNumber").val() || $("#AuthFlag").val() !== "Y") {
        fnDefaultAlertFocus("가입정보 인증 후 비밀번호 변경이 가능합니다.", "PwdAdminID", "warning");
        return false;
    }

    if (!$("#AdminResetPwd").val()) {
        fnDefaultAlertFocus("비밀번호를 입력해주세요.", "AdminResetPwd", "warning");
        return false;
    }

    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnResetPasswordSuccResult";

    var objParam = {
        CallType: "CheckAdminPwdPolicy",
        AdminResetPwd: $("#AdminResetPwd").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
    return false;
}

function fnResetPasswordSuccResult(data) {
    if (data[0].RetCode !== 0) {
        $("#UserPasswordChange p.info_text").css("color", "#E23D77").text(data[0].ErrMsg);
        $("#SecurityFlag").val("");
        return false;
    } else {
        $("#UserPasswordChange p.info_text").css("color", "#0095F6").text("안전한 비밀번호입니다.");
        $("#SecurityFlag").val("Y");
        fnResetPasswordProc();
        return false;
    }
}

function fnResetPasswordProc() {

    if (!$("#EncSMSAuthNum").val()) {
        return false;
    }

    if (!$("#AuthFlag").val()) {
        return false;
    }

    if (!$("#AuthInfo").val()) {
        return false;
    }

    if (!$("#PwdAdminID").val()) {
        return false;
    }

    if (!$("#PwdMobileNo").val()) {
        return false;
    }

    if (!$("#AuthNumber").val()) {
        return false;
    }

    if (!$("#AdminResetPwd").val()) {
        fnDefaultAlertFocus("비밀번호를 입력해주세요.", "AdminResetPwd", "warning");
        return false;
    }

    if (!$("#AdminResetPwdChk").val()) {
        fnDefaultAlertFocus("비밀번호 확인을 입력해주세요.", "AdminResetPwdChk", "warning");
        return false;
    }

    if ($("#AdminResetPwd").val() !== $("#AdminResetPwdChk").val()) {
        fnDefaultAlertFocus("입력하신 비밀번호가 일치하지 않습니다.", "AdminResetPwdChk", "warning");
        return false;
    }

    if ($("#SecurityFlag").val() !== "Y") {
        fnDefaultAlertFocus("안전하지 않은 비밀번호입니다.", "AdminResetPwd", "warning");
        return false;
    }

    //Confirm
    fnDefaultConfirm("비밀번호를 변경하시겠습니까?", "fnResetPasswordConfirm", "");
    return false;
}

function fnResetPasswordConfirm() {
    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxUpdPwdSuccResult";

    var objParam = {
        CallType: "UpdAdminPwd",
        EncSMSAuthNum: $("#EncSMSAuthNum").val(),
        AuthInfo: $("#AuthInfo").val(),
        AuthNumber: $("#AuthNumber").val(),
        AdminResetPwd: $("#AdminResetPwd").val(),
        AdminID: $("#PwdAdminID").val(),
        MobileNo: $("#PwdMobileNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    return false;
}

function fnAjaxUpdPwdSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("비밀번호 변경을 실패하였습니다. 나중에 다시 시도해 주세요.<br/>(" + data[0].ErrMsg + ")");
        return false;
    } else {
        fnDefaultAlert("비밀번호 변경을 완료하였습니다.", "success", "fnClosePwdChangeLayer()");
        return false;
    } 
}
/*************************/
//비밀번호 재발급 끝
/*************************/

/*************************/
//최초 로그인 비밀번호 시작
/*************************/
function fnOpenInitPwdChangeLayer() {
    fnResetInitPwdChangeLayer();
    $("#InitUserPasswordChange").show();
    $("#AdminInitPwd").focus();
    return false;
}

function fnCloseInitPwdChangeLayer() {
    fnResetInitPwdChangeLayer();
    $("#InitUserPasswordChange").hide();
    return false;
}

function fnResetInitPwdChangeLayer() {
    $("#SecurityFlag").val("");
    $("#AdminInitPwd").val("");
    $("#AdminInitPwdChk").val("");
    $("#InitUserPasswordChange p.info_text").css("color", "#E23D77").text("비밀번호는 영문,숫자,특수문자(!@$%^*만 허용)를 혼합 사용하여 8~16자까지");
    return false;
}

function fnInitPwdPolicySuccResult(data) {
    if (data[0].RetCode !== 0) {
        $("#InitUserPasswordChange p.info_text").css("color", "#E23D77").text(data[0].ErrMsg);
        $("#SecurityFlag").val("");
        return false;
    } else {
        $("#InitUserPasswordChange p.info_text").css("color", "#0095F6").text("안전한 비밀번호입니다.");
        $("#SecurityFlag").val("Y");
        return false;
    }
}

function fnInitPassword() {
    if (!$("#AdminInitPwd").val()) {
        fnDefaultAlertFocus("비밀번호를 입력해주세요.", "AdminInitPwd", "warning");
        return false;
    }

    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnInitPasswordSuccResult";

    var objParam = {
        CallType: "CheckAdminPwdPolicy",
        AdminResetPwd: $("#AdminInitPwd").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
    return false;
}

function fnInitPasswordSuccResult(data) {
    if (data[0].RetCode !== 0) {
        $("#InitUserPasswordChange p.info_text").css("color", "#E23D77").text(data[0].ErrMsg);
        $("#SecurityFlag").val("");
        return false;
    } else {
        $("#InitUserPasswordChange p.info_text").css("color", "#0095F6").text("안전한 비밀번호입니다.");
        $("#SecurityFlag").val("Y");
        fnInitPasswordProc();
        return false;
    }
}

function fnInitPasswordProc() {

    if ($("#AdminInitPwd").val() === "") {
        fnDefaultAlertFocus("비밀번호를 입력해주세요.", "AdminInitPwd", "warning");
        return false;
    }

    if ($("#AdminInitPwdChk").val() === "") {
        fnDefaultAlertFocus("비밀번호 확인을 입력해주세요.", "AdminInitPwdChk", "warning");
        return false;
    }

    if ($("#AdminInitPwd").val() !== $("#AdminInitPwdChk").val()) {
        fnDefaultAlertFocus("입력하신 비밀번호가 일치하지 않습니다.", "AdminInitPwdChk", "warning");
        return false;
    }

    if ($("#SecurityFlag").val() !== "Y") {
        fnDefaultAlertFocus("안전하지 않은 비밀번호입니다.", "AdminInitPwd", "warning");
        return false;
    }

    //Confirm
    fnDefaultConfirm("비밀번호를 설정하시겠습니까?", "fnInitPasswordConfirm", "");
    return false;

}

function fnInitPasswordConfirm() {
    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxInitPwdSuccResult";
    var strFailCallBackFunc = "fnAjaxInitPwdFailResult";

    var objParam = {
        CallType: "InitAdminPwd",
        AdminID: $("#AdminID").val(),
        AdminResetPwd: $("#AdminInitPwd").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
    return false;
}

function fnAjaxInitPwdSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnAjaxInitPwdFailResult(data[0].ErrMsg);
        return false;
    } else {
        fnCloseInitPwdChangeLayer();
        fnDefaultAlert("비밀번호 설정을 완료하였습니다.", "success", "AdminPwd");
        return false;
    }
}

function fnAjaxInitPwdFailResult(strMsg) {
    var strAlertMsg = "비밀번호 설정을 실패하였습니다. 나중에 다시 시도해 주세요.";
    if (typeof strMsg === "string") {
        strAlertMsg += "<br/>(" + strMsg + ")";
    }

    fnDefaultAlert(strAlertMsg, "warning");
    fnResetInitPwdChangeLayer();
    return false;
}

/*************************/
//최초 로그인 비밀번호 끝
/*************************/

/*************************/
//OTP 시작
/*************************/
function fnOpenGoogleQrCode() {
    $("#GoogleQrCodeLayer").show();
    $("#OtpCode").focus();
    return false;
}

function fnCloseGoogleQrCode() {
    fnResetGoogleQrCode();
    $("#GoogleQrCodeLayer").hide();
    return false;
}

function fnResetGoogleQrCode() {
    $("#AUTH_NUMBER").val("");
    $("#GradeCode").val("");
    $("#OtpFlag").val("");
    $("#OtpCode").val("");
    fnResetGoogleQrCodeDetail();
    return false;
}

function fnOpenGoogleQrCodeDetail() {
    fnResetGoogleQrCodeDetail();
    $("#GoogleQrCodeLayer div.bottom").show();
    $("#AUTH_ADMIN_ID").focus();
    return false;
}

function fnCloseGoogleQrCodeDetail() {
    fnResetGoogleQrCodeDetail();
    $("#GoogleQrCodeLayer div.bottom").hide();
    $("#OtpCode").focus();
    return false;
}

function fnResetGoogleQrCodeDetail() {
    $("#AUTH_ADMIN_ID").attr("readonly", false);
    $("#AUTH_ADMIN_ID").val("");
    $("#AUTH_CELL").attr("readonly", false);
    $("#AUTH_CELL").val("");
    $("#AUTH_BTN").show();
    $("#RESET_BTN").hide();

    $("#ADMIN_AUTH_NUMBER").val("");
    $("#AuthTr").hide();

    $("#QR_CODE_IMG").attr("src", "");
    $("#QR_CODE_AREA").hide();
    return false;
}

//인증번호 받기 - 아이디체크
function fnSmsAdminAuth() {

    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnSmsAdminAuthSuccResult";

    if (!$("#AUTH_ADMIN_ID").val()) {
        fnDefaultAlertFocus("아이디를 입력해주세요.", "AUTH_ADMIN_ID");
        return;
    }
    if (!$("#AUTH_CELL").val()) {
        fnDefaultAlertFocus("휴대폰번호를 입력해주세요.", "AUTH_CELL");
        return;
    }

    var objParam = {
        CallType: "AdminIDCheck",
        AdminID: $("#AUTH_ADMIN_ID").val(),
        MobileNo: $("#AUTH_CELL").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnSmsAdminAuthSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("등록되지 않은 계정입니다.");
            return false;
        } else {
            fnGoogleCallSMSAuth();
            return false;
        }
    }
}

//인증번호 받기 - 문자 전송
function fnGoogleCallSMSAuth() {
    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnCallSMSAuthSuccResult";

    if ($("#AUTH_CELL").val() === "") {
        fnDefaultAlertFocus("휴대폰번호를 입력해주세요.", "AUTH_CELL");
        return;
    }

    var objParam = {
        CallType: "CallSMSAuth",
        MobileNo: $("#AUTH_CELL").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnCallSMSAuthSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("인증번호가 전송되었습니다.", "success");
            $("#AUTH_NUMBER").val(objRes[0].EncSMSAuthNum);
            $("#AUTH_ADMIN_ID").attr("readonly", true);
            $("#AUTH_CELL").attr("readonly", true);
            $("#AUTH_BTN").hide();
            $("#RESET_BTN").show();
            $("#AuthTr").show();
            $("#ADMIN_AUTH_NUMBER").focus();
            return false;
        } else {
            fnDefaultAlert("인증번호 전송 실패하였습니다.", "error", "fnResetGoogleQrCode()");
            return false;
        }
    }
}

//QR 생성
function fnSmsAdminAuthSend() {
    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxGoogleSuccResult";

    if ($("#AUTH_ADMIN_ID").val() === "") {
        fnDefaultAlertFocus("아이디를 입력해주세요.", "AUTH_ADMIN_ID", "warning");
        return;
    }

    if ($("#AUTH_CELL").val() === "") {
        fnDefaultAlertFocus("휴대폰번호를 입력해주세요.", "AUTH_CELL", "warning");
        return;
    }

    if ($("#ADMIN_AUTH_NUMBER").val() === "") {
        fnDefaultAlertFocus("인증번호를 입력해주세요.", "ADMIN_AUTH_NUMBER", "warning");
        return;
    }

    if ($("#AUTH_NUMBER").val() === "") {
        fnDefaultAlertFocus("인증번호를 받지않았습니다.", "AUTH_NUMBER", "warning");
        return;
    }

    var objParam = {
        CallType: "GetAuthNumberCheck",
        AdminAuthNumber: $("#ADMIN_AUTH_NUMBER").val(),
        AuthNumber: $("#AUTH_NUMBER").val(),
        AuthAdminID: $("#AUTH_ADMIN_ID").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    return false;
}

function fnAjaxGoogleSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("인증되었습니다." + "<br>QR코드가 생성되었습니다.", "success");
            $("#QR_CODE_AREA").show();
            $("#QR_CODE_IMG").attr("src", objRes[0].QrCodeSetupImageUrl);
            return false;
        } else {
            fnDefaultAlert(objRes[0].ErrMsg);
            return false;
        }
    }
}

/*************************/
//OTP 끝
/*************************/

/*************************/
//아이디 찾기 시작
/*************************/
function fnOpenIdFindLayer() {
    fnResetIdFindLayer();
    $("#UserIdFindLayer").show();
    $("#IdAdminCorpNo").focus();
    return false;
}

function fnCloseIdFindLayer() {
    fnResetIdFindLayer();
    $("#UserIdFindLayer").hide();
    return false;
}

function fnResetIdFindLayer() {
    $("#IdAdminCorpNo").val("");
    $("#IdAdminName").val("");
    $("#IdMobileNo").val("");
    return false;
}

function fnChkAuthID() {

    if (!$("#IdAdminCorpNo").val()) {
        fnDefaultAlertFocus("사업자등록번호를 입력하세요.", "IdAdminCorpNo", "warning");
        return false;
    }

    if (!$("#IdAdminName").val()) {
        fnDefaultAlertFocus("이름을 입력하세요.", "IdAdminName", "warning");
        return false;
    }

    if (!$("#IdMobileNo").val()) {
        fnDefaultAlertFocus("휴대폰번호를 입력하세요.", "IdMobileNo", "warning");
        return false;
    }

    if (!UTILJS.Util.fnBizNoChk($("#IdAdminCorpNo").val())) {
        fnDefaultAlertFocus("사업자등록번호의 형식이 올바르지 않습니다.<br>형식에 맞춰서 입력해주세요.", "IdAdminCorpNo", "warning");
        return false;
    }

    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxAuthIDSuccResult";
    var objParam = {
        CallType: "chkAuthID",
        IdAdminCorpNo: $("#IdAdminCorpNo").val(),
        IdMobileNo: $("#IdMobileNo").val(),
        IdAdminName: $("#IdAdminName").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    return false;
}

function fnAjaxAuthIDSuccResult(data) {
    if (data[0].RetCode === 0) {
        fnDefaultAlert("입력하신 휴대폰번호로 아이디를 전송했습니다.", "success");
        fnCloseIdFindLayer();
        return false;
    } else {
        fnDefaultAlert(data[0].ErrMsg);
        return false;
    }
}

/*************************/
//아이디 찾기 끝
/*************************/

function fnCreateBookmark() {
    var strTitle = document.title;
    var strURL = document.location.href;

    strURL = strURL.substr(0, strURL.indexOf("co.kr") + 5);

    if (window.sidebar && window.sidebar.addPanel) {
        // Firefox version < 23
        window.sidebar.addPanel(strTitle, strURL, '');
    } else if ((window.sidebar && (navigator.userAgent.toLowerCase().indexOf('firefox') > -1)) || (window.opera && window.print)) {
        // Firefox version >= 23 and Opera Hotlist
        var $this = $(this);
        $this.attr('href', strURL);
        $this.attr('title', strTitle);
        $this.attr('rel', 'sidebar');
        $this.off(e);
    } else if (window.external && ('AddFavorite' in window.external)) {
        // IE Favorite
        window.external.AddFavorite(strURL, strTitle);
    } else {
        // WebKit - Safari/Chrome
        fnDefaultAlert((navigator.userAgent.toLowerCase().indexOf('mac') != -1 ? 'Cmd' : 'Ctrl') + '+D 키를 눌러 즐겨찾기에 등록하실 수 있습니다.', "info");
    }

    return;
}