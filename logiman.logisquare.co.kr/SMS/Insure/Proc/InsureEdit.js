var strSiteTitle = "로지맨 알림톡";

$(document).ready(function () {
    fnSetInit();
});

function fnSetInit() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()", null, strSiteTitle);
        return false;
    }

    var strHandlerUrl = "/SMS/Insure/Proc/SmsInsureHandler.ashx";
    var strCallBackFunc = "fnSetInitSuccResult";
    var strFailCallBackFunc = "fnSetInitFailResult";

    var objParam = {
        CallType: "ParamChkWithAuth",
        No: $("#No").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetInitSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                $("#No").val("");
                fnSetInitFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].TimeOutFlag === "Y") {
            fnSetInitFailResult("조회 가능 기간(발송일 기준 7일)이 초과했습니다.");
            return false;
        }

        if (objRes[0].ChkCertFlag !== "Y") {
            fnSetInitFailResult("휴대폰 본인인증 후 이용이 가능합니다.");
            return false;
        }

        if (objRes[0].CertTimeOutFlag === "Y") {
            fnSetInitFailResult("휴대폰 본인인증 후 1시간이 초과하여 이용이 불가능합니다.");
            return false;
        }

        if (objRes[0].ExistsFlag !== "Y") {
            fnSetInitFailResult("수정할 수 있는 주민등록 정보가 없습니다.");
            return false;
        }

        $("#TdInformationDate").text(objRes[0].InformationDate);
        $("#TdAgreementDate").text(objRes[0].AgreementDate);

        var strText = "";
        strText = $("div.agree1 div.agree_text").html().replaceAll("#{운송사명}", objRes[0].CenterName);
        strText = strText.replaceAll("#{책임자명}", objRes[0].ChiefName);
        strText = strText.replaceAll("#{책임자직책}", objRes[0].ChiefPosition);
        strText = strText.replaceAll("#{책임자이메일}", objRes[0].ChiefEmail);
        strText = strText.replaceAll("#{담당자명}", objRes[0].ManagerName);
        strText = strText.replaceAll("#{담당자부서}", objRes[0].ManagerDepartment);
        strText = strText.replaceAll("#{담당자전화번호}", objRes[0].ManagerTelNo);
        strText = strText.replaceAll("#{담당자이메일}", objRes[0].ManagerEmail);
        strText = strText.replaceAll("#{계약적용일}", objRes[0].FromYMD);
        $("div.agree1 div.agree_text").html(strText);
        strText = $("div.agree2 div.agree_text").html().replaceAll("#{운송사명}", objRes[0].CenterName);
        $("div.agree2 div.agree_text").html(strText);
        strText = $("div.agree3 div.agree_text").html().replaceAll("#{운송사명}", objRes[0].CenterName);
        $("div.agree3 div.agree_text").html(strText);

        $("#No").val(objRes[0].No);
        return false;
    } else {
        $("#No").val("");
        fnSetInitFailResult();
        return false;
    }
}

function fnSetInitFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
   fnGoErrorUrl("/SMS/Insure/Error", "개인정보 수정 불가 안내", msg);
   return false;
}

function fnGoAction(strPage) {
    var url = "/SMS/Insure/" + strPage + "?No=" + encodeURIComponent($("#No").val());
    document.location.replace(url);
    return false;
}

/* 약관 동의 관련 */
function fnAgreeView(intNo, isOpen) {
    $(".agree_area").hide();
    if (isOpen) {
        $(".agree" + intNo).show();
    }
}


function fnInfoUpd() {

    if (!$("#Name").val()) {
        fnDefaultAlertFocus("이름을 입력하세요.", "Name", "warning", "", null, strSiteTitle);
        return false;
    }

    if (!$("#PersonalNo").val()) {
        fnDefaultAlertFocus("주민등록번호를 입력하세요.", "PersonalNo", "warning", "", null, strSiteTitle);
        return false;
    }

    if (!fnCheckPersonalNo($("#PersonalNo").val())) {
        fnDefaultAlertFocus("주민등록번호를 올바르게 입력하세요.", "PersonalNo", "warning", "", null, strSiteTitle);
        return false;
    }

    var fnParam = "InsureUpd";
    fnDefaultConfirm("개인정보를 수정하시겠습니까?", "fnInfoUpdProc", fnParam, "", null, "question", strSiteTitle);
    return false;
}

function fnInfoUpdProc(fnParam) {

    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()", null, strSiteTitle);
        return false;
    }

    var strHandlerUrl = "/SMS/Insure/Proc/SmsInsureHandler.ashx";
    var strCallBackFunc = "fnInfoUpdProcSuccResult";
    var strFailCallBackFunc = "fnInfoUpdProcFailResult";

    var objParam = {
        CallType: fnParam,
        No: $("#No").val(),
        Name: $("#Name").val(),
        PersonalNo: $("#PersonalNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnInfoUpdProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                $("#No").val("");
                fnInfoUpdProcFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        $("#No").val(objRes[0].No);
        fnDefaultAlert("개인정보 수정이 완료되었습니다.", "info", "fnGoAction", "InsureEdit", strSiteTitle);
        //fnGoErrorUrl("/SMS/Insure/Error", "개인정보 수정 완료 안내", "개인정보 수정이 완료되었습니다.");

        return false;
    } else {
        $("#No").val("");
        fnInfoUpdProcFailResult();
        return false;
    }
}

function fnInfoUpdProcFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    fnGoErrorUrl("/SMS/Insure/Error", "개인정보 수정 실패 안내", msg);
    return false;
}