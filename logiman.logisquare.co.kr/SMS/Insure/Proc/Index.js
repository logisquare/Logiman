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
        CallType: "ParamChk",
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
    fnGoErrorUrl("/SMS/Insure/Error", "조회 불가 안내", msg);
    return false;
}

function fnAuthCheck() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Insure/Proc/SmsInsureHandler.ashx";
    var strCallBackFunc = "fnGetLogInfoSuccResult";
    var strFailCallBackFunc = "fnGetLogInfoFailResult";

    var objParam = {
        CallType: "AuthLogInfo",
        No: $("#No").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnGetLogInfoSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnGetLogInfoFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].TryCnt >= 5) {
            fnDefaultAlert("인증 횟수(하루 5회)를 초과하여 본인 인증이 불가능합니다.", "info", "", null, strSiteTitle);
            return false;
        }

        $("#ordr_idxx").val(objRes[0].ordr_idxx);
        fnAuthOpen();
        return false;
    } else {
        fnGetLogInfoFailResult();
        return false;
    }
}

function fnGetLogInfoFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    fnGoErrorUrl("/SMS/Insure/Error", "조회 불가 안내", msg);
    return false;
}

function fnGoEnd(strMsg) {
    if (typeof strMsg === "string") {
        fnDefaultAlert(strMsg, "info", "fnGoAction(\"InsureEdit\")", null, strSiteTitle);
        return false;
    } else {
        fnGoAction("InsureEdit");
        return false;
    }
}

function fnGoAction(strPage) {
    var url = "/SMS/Insure/" + strPage + "?No=" + encodeURIComponent($("#No").val());
    document.location.replace(url);
    return false;
}


function fnAuthOpen() {
    if (!$("#ordr_idxx").val()) {
        return false;
    }

    $("#mainform").attr("action", "/KCP/SmartCertReq");

    if ($("#MobileDevice").val() == "W") {
        var width = 410;
        var height = 500;
        var leftpos = screen.width / 2 - (width / 2);
        var toppos = screen.height / 2 - (height / 2);
        var winopts = "width=" + width + ", height=" + height + ", toolbar=no,status=no,statusbar=no,menubar=no,scrollbars=no,resizable=no";
        var position = ",left=" + leftpos + ", top=" + toppos;
        var AUTH_POP = window.open("", "auth_popup", winopts + position);
        $("#mainform").attr("target", "auth_popup");
    } else {
        $("#DivWrapCert").show();
        $("#mainform").attr("target", "kcp_cert");
    }

    $("#mainform").submit();
    return false;
}

function fnAuthData(objFrm) {
    $("#mainform").attr("action", "");
    $("#mainform").attr("target", "");
    $("#DivWrapCert").hide();

    var strHandlerUrl = "/SMS/Insure/Proc/SmsInsureHandler.ashx";
    var strCallBackFunc = "fnAuthDataSuccResult";
    var strFailCallBackFunc = "fnAuthDataFailResult";

    var objParam = {
        CallType: "AuthLogChk",
        No: $("#No").val(),
        ResCd: objFrm.res_cd.value,
        ResMsg: objFrm.res_msg.value,
        EncCertData2: objFrm.enc_cert_data2.value,
        CertNo: objFrm.cert_no.value,
        DnHash: objFrm.dn_hash.value,
        UpHash: objFrm.up_hash.value,
        VariUpHash: $("#veri_up_hash").val(),
        OrdrIdxx: $("#ordr_idxx").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
    return false;
}

function fnAuthDataSuccResult(objRes) {
 
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                $("#No").val("");
                fnAuthDataFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        $("#No").val(objRes[0].No);
        fnGoAction(objRes[0].ExistsFlag === "Y" ? "InsureEdit" : "InsureIns");
        return false;
    } else {
        $("#No").val("");
        fnAuthDataFailResult();
        return false;
    }
}

function fnAuthDataFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }

    fnGoErrorUrl("/SMS/Insure/Error", "휴대폰 본인인증 오류 안내", msg);
    return false;
}

function fnGoAction(strPage) {
    var url = "/SMS/Insure/" + strPage + "?No=" + encodeURIComponent($("#No").val());
    document.location.href = url;
    return false;
}