var strSiteTitle = "로지맨 알림톡";

$(document).ready(function () {
    fnSetInit();

    $("input[type=checkbox]").on("click", function (event) {
        var strID = $(this).attr("id");
        var strReverseID = "";
        if (strID.indexOf("Y") > -1) {
            strReverseID = strID.replace(/Y/gi, "N");
        } else {
            strReverseID = strID.replace(/N/gi, "Y");
        }
        $("#" + strReverseID).prop("checked", !$(this).is(":checked"));
    });
});

function fnSetInit() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()", null, strSiteTitle);
        return false;
    }

    var strHandlerUrl = "/SMS/SafetyCheck/Proc/SmsSafetyCheckHandler.ashx";
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
        $("#SpanDriverName").text(objRes[0].DriverName);
        fnSetReplyUpd();
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
    fnGoErrorUrl("/SMS/SafetyCheck/Error", "조회 불가 안내", msg);
    return false;
}

function fnSetReplyUpd() {

    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()", null, strSiteTitle);
        return false;
    }

    var strHandlerUrl = "/SMS/SafetyCheck/Proc/SmsSafetyCheckHandler.ashx";
    var strCallBackFunc = "fnSetReplyUpdProcSuccResult";
    var strFailCallBackFunc = "fnSetReplyUpdProcFailResult";

    var objParam = {
        CallType: "ReplyUpd",
        No: $("#No").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetReplyUpdProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                $("#No").val("");
                fnSetReplyUpdProcFailResult(objRes[0].ErrMsg);
                return false;
            }
        }
        //fnDefaultAlert("점검 항목 작성이 완료되었습니다.", "info");
        return false;
    } else {
        $("#No").val("");
        fnSetReplyUpdProcFailResult();
        return false;
    }
}

function fnSetReplyUpdProcFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    fnGoErrorUrl("/SMS/SafetyCheck/Error", "점검 항목 작성 실패 안내", msg);
    return false;
}