$(document).ready(function () {

    //--웹오더 알림 수신업체 리스트//
    if ($("#CenterCode").val() != "") {
        fnCallAdminClientData();
    } else {
        $("#ClientInfo").html("<option value=''>고객사 목록</option>");
        $("#CenterCode").on("change", function () {
            fnCallAdminClientData();
        });
    }
     //웹오더 알림 수신업체 리스트--//

    if ($("#hidErrMsg").val() != "") {
        fnDefaultAlert($("#hidErrMsg").val());
    }

    $("input[ID=AdminResetPwd]").keyup(function (event) {
        if ($("#AdminResetPwd").val() === "") {
            $("p.info_text").css("color", "#E23D77").text("비밀번호는 영문,숫자,특수문자(!@$%^*만 허용)를 혼합 사용하여 8~16자까지");
            $("#SecurityFlag").val("");
            return;
        }
    });

    $('input[ID=AdminResetPwd]').focusout(function () {
        if ($("#AdminResetPwd").val() !== "") {
            var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
            var strCallBackFunc = "fnAjaxPwdPolicySuccResult";

            var objParam = {
                CallType: "CheckAdminPwdPolicy",
                AdminResetPwd: $("#AdminResetPwd").val()
            }

            UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
        }
    });

    //고객사명
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/SSO/Admin/Proc/AdminMyInfoHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientSearchList",
                    ClientName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#ClientCode").val(ui.item.etc.ClientCode);
                    $("#ClientName").val(ui.item.etc.ClientName);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                }
            }
        });
    }

    if ($("#GradeCode").val() == "6") {
        $(".WebOrderNone").hide();
        $(".WebOrderRegTypeM").show();
    }    
});

function fnAjaxPwdPolicySuccResult(data) {
    if (data[0].RetCode !== 0) {
        $("p.info_text").css("color", "#E23D77").text(data[0].ErrMsg);
        $("#SecurityFlag").val("");
    } else {
        $("p.info_text").css("color", "#0095F6").text("안전한 비밀번호입니다.");
        $("#SecurityFlag").val("Y");
    }
}

function fnUpdAdminMyInfo() {
    if ($("#MobileNoAuthFlag").val() != "Y") {
        fnDefaultAlert("계정 전용 핸드폰 번호를 인증하세요.", "warning");
        return;
    }

    if ($("#TelNo").val() == "") {
        fnDefaultAlert("전화번호를 입력하세요.", "warning");
        return;
    }

    if ($("#Email").val() !== "") {
        if (!UTILJS.Util.fnValidEmail($("#Email").val())) {
            fnDefaultAlertFocus("잘못된 이메일 형식입니다.", "Email");
            return;
        }
    }
    

    $("#NewMobileNo").val($("#MobileNo").val());


    fnDefaultConfirm("정보를 수정하시겠습니까?", "fnUpdAdminMyInfoProc", "");
    return;
}

function fnUpdAdminMyInfoProc(ojbParam) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminMyInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxUpdAdminMyInfo";

    let objParam = {
        CallType: "AdminMyInfoUpdate",
        AdminID: $("#AdminID").val(),
        MobileNo: $('#MobileNo').val(),
        AdminPosition: $("#AdminPosition").val(),
        DeptName: $('#DeptName').val(),
        TelNo: $('#TelNo').val(),
        Email: $('#Email').val(),
        Network24DDID: $('#Network24DDID').val(),
        NetworkHMMID: $('#NetworkHMMID').val(),
        NetworkOneCallID: $('#NetworkOneCallID').val(),
        NetworkHmadangID: $('#NetworkHmadangID').val(),
        UseFlag: $('#UseFlag').val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxUpdAdminMyInfo(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", "fnAjaxUpdAdminMyInfoComplete()");
    }
}

function fnAjaxUpdAdminMyInfoComplete() {
    document.location.replace("/SSO/Admin/AdminMyInfo");
}

function fnResetPassword() {
    var confMsg = "비밀번호를 변경하시겠습니까?";

    if ($("#OrgAdminPwd").val() === "") {
        fnDefaultAlertFocus("현재 비밀번호를 입력해주세요.", "OrgAdminPwd");
        return false;
    }

    if ($("#AdminResetPwd").val() === "") {
        fnDefaultAlertFocus("비밀번호를 입력해주세요.", "AdminResetPwd");
        return false;
    }
    if ($("#AdminResetPwdChk").val() === "") {
        fnDefaultAlertFocus("비밀번호 확인을 입력해주세요.", "AdminResetPwdChk");
        return false;
    }
    if ($("#AdminResetPwd").val() !== $("#AdminResetPwdChk").val()) {
        fnDefaultAlertFocus("입력하신 비밀번호가 일치하지 않습니다.", "AdminResetPwd");
        return false;
    }

    if ($("#OrgAdminPwd").val() === $("#AdminResetPwd").val()) {
        fnDefaultAlertFocus("현재 비밀번호와 변경 비밀번호가 동일합니다.", "AdminResetPwd");
        return false;
    }

    if ($("#SecurityFlag").val() !== "Y") {
        fnDefaultAlertFocus("안전하지 않은 비밀번호입니다.", "#AdminResetPwd");
        return false;
    }
    fnDefaultConfirm(confMsg, "fnResetPasswordProc", "");
}

function fnResetPasswordProc() {
    var strHandlerURL = "/SSO/Admin/Proc/AdminMyInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxUpdPwdSuccResult";

    var objParam = "CallType=UpdAdminPwd&AdminID=" + $("#AdminID").val() + "&AdminResetPwd=" + $("#AdminResetPwd").val();
    var objParam = {
        CallType: "UpdAdminPwd",
        AdminID: $("#AdminID").val(),
        AdminResetPwd: $("#AdminResetPwd").val(),
        OrgAdminPwd: $("#OrgAdminPwd").val(),
        HidEncCode: $("#HidEncCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxUpdPwdSuccResult(data) {
    if (data[0].RetCode != "0") {
        fnDefaultAlert(data[0].ErrMsg);
    } else {
        fnDefaultAlert("비밀번호 변경을 완료하였습니다.", "success", "fnAjaxUpdAdminMyInfoComplete", "");
    }
    return;
}

function fnAjaxFailResult(XMLHttpRequest, textStatus, errorThrown) {
    fnDefaultAlert("처리 중 오류가 발생하였습니다.");
}


//휴대폰번호 변경 인증 Script Start

function fnMobileNoUpd() {
    $("#ConfirmArea").slideToggle(200);
}

function fnAuthNumberGet() {
    var strHandlerURL = "/SSO/Admin/Proc/AdminMyInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxAuthNumSuccResult";
    
    if ($("#NewMobileNo").val() == $("#MobileNo").val()) {
        fnDefaultAlertFocus("변경할 휴대폰 번호가 기존 휴대폰번호와 동일합니다.", "NewMobileNo");
        return false;
    }

    if ($("#NewMobileNo").val() == "") {
        fnDefaultAlertFocus("변경할 휴대폰 번호를 입력하세요.", "NewMobileNo");
        return false;
    }

    if ($("#NewMobileNo").val().length > 11 || $("#NewMobileNo").val().length < 10) {
        fnDefaultAlertFocus("변경할 휴대폰번호 자리수를 정확히 입력해주세요.", "NewMobileNo");
        return false;
    }

    var objParam = {
        CallType: "CallSMSAuth",
        MobileNo: $("#NewMobileNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    return false;
}
function fnAjaxAuthNumSuccResult(data) {
    
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("인증번호 요청을 실패하였습니다. 나중에 다시 시도해 주세요.<br/>(" + data[0].ErrMsg + ")");
        fnResetMobile(true);
    } else {

        fnDefaultAlert("인증번호가 발송되었습니다.", "success");
        $("#HidAuthCode").val(data[0].receiptNum);
        $("#btnMobileReset").show();
        $("#btnMobile").hide();
        $("#NewMobileNo").attr("readonly", true);
        $("#SmsAuthNo").show();
        $("#ConfirmBtn").show();
    }
    return;
}

function fnAuthNumberReset() {
    $("#btnMobile").show();

    $("#NewMobileNo").attr("readonly", false);
    $("#btnMobileReset").hide();
    $("#SmsAuthNo").hide();
    $("#ConfirmBtn").hide();
    $("#NewMobileNo").focus();
    $("#NewMobileNo").val("");
}

function fnAuthMobileUpd() {
    if ($("#SmsAuthNo").val() === "") {
        fnDefaultAlertFocus("인증번호를 입력해주세요.", "SmsAuthNo", "warning");
        return;
    } else {
        var strHandlerURL = "/SSO/Admin/Proc/AdminMyInfoHandler.ashx";
        var strCallBackFunc = "fnAjaxAuthMobileSuccResult";
        var objParam = {
            CallType: "UpdAuthMobileNo",
            AdminID: $("#AdminID").val(),
            MobileNo: $("#NewMobileNo").val(),
            AdminPosition: $("#AdminPosition").val(),
            DeptName: $('#DeptName').val(),
            TelNo: $('#TelNo').val(),
            Email: $('#Email').val(),
            Network24DDID: $('#Network24DDID').val(),
            NetworkHMMID: $('#NetworkHMMID').val(),
            NetworkOneCallID: $('#NetworkOneCallID').val(),
            NetworkHmadangID: $('#NetworkHmadangID').val(),
            UseFlag: $('#UseFlag').val(),
            HidAuthCode : $("#HidAuthCode").val(),
            SmsAuthNo : $("#SmsAuthNo").val(),
        }

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
        return false;
    }
}

function fnAjaxAuthMobileSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("인증 실패하였습니다.<br/>(" + data[0].ErrMsg + ")");
    } else {

        fnDefaultAlert("정상적으로 변경되었습니다.", "success");
        $("#MobileNo").val(data[0].MobileNo);
        fnAuthNumberReset();
        $("#ConfirmArea").hide();
    }
    return;
}

function fnAdminClientConfirm(type) {
    var objMsg = "";
    var strCallType = "";
    
    if (type === "Ins") {
        if ($("#CenterCode").val() === "") {
            fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
            return;
        }
        if ($("#ClientCode").val() === "") {
            fnDefaultAlertFocus("고객사를 검색하여 선택하십시오.", "ClientName", "warning");
            return;
        }
        objMsg = "등록";
        strCallType = "AdminClientIns";
    } else {
        if ($("#ClientInfo").val() === "") {
            fnDefaultAlertFocus("고객사 목록을 선택하십시오.", "ClientInfo", "warning");
            return;
        }
        objMsg = "삭제";
        strCallType = "AdminClientDel";
    }
    

    fnDefaultConfirm("웹오더 알림 수신업체를 " + objMsg + "하시겠습니까?", "fnAdminClientIns", strCallType);
}

function fnAdminClientIns(Param) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminMyInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxAdminClientSuccResult";
    var objParam = {
        CallType: Param,
        ClientCode: $("#ClientCode").val(),
        CenterCode: $("#CenterCode").val(),
        SeqNo     : $("#ClientInfo").val()
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    return false;
}

function fnAjaxAdminClientSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("실패하였습니다.<br/>(" + data[0].ErrMsg + ")");
    } else {

        fnDefaultAlert("처리되었습니다.", "success");
        $("#ClientName").focus();
        $("#ClientName").val("");
        $("#ClientCode").val("");
        fnCallAdminClientData();
    }
    return;
}


function fnCallAdminClientData() {

    var strHandlerURL = "/SSO/Admin/Proc/AdminMyInfoHandler.ashx";
    var strCallBackFunc = "fnAdminClientListSuccResult";

    var objParam = {
        CallType: "AdminClientList",
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAdminClientListSuccResult(objRes) {
    
    var option = "";
    $("#ClientInfo").html("");
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            option += "<option value=''>등록된 고객사가 없습니다.</option>";
        } else {
            if (objRes[0].data.RecordCnt > 0) {
                option += "<option value=''>고객사 목록</option>";
                for (var i = 0; i < objRes[0].data.RecordCnt; i++) {
                    option += "<option value=\"" + objRes[0].data.list[i].SeqNo + "\">" + objRes[0].data.list[i].ClientInfo + "</option>";
                }
            } else {
                option += "<option value=''>고객사 목록</option>";
            }
        }
    }
    $("#ClientInfo").html(option);
    return false;
}