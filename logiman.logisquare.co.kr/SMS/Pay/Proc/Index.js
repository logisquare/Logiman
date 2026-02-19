$(document).ready(function () {
    fnSetInit();
});

function fnSetInit() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Pay/Proc/SmsPayHandler.ashx";
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
        if (objRes[0].RetCode === 0) {
            $("#CorpNo").text(objRes[0].ComCorpNoPart);
            $("#HidUserName").val(objRes[0].DriverName);
            $("#HidUserCell").val(objRes[0].DriverCell);
            //fnBannerEventHistRequest(1, "TmapPopup", "티맵팝업(MMP041)");

            $("div.event_popup").hide();
            if ($("#HidEventViewFlag").val() === "Y") {
                if ($("#HidEventAvailChkFlag").val() === "Y") {
                    fnChkEventAvail();
                } else {
                    $("div.event_popup").show();
                }
            }
            return false;
        } else {
            fnSetInitFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetInitFailResult();
        return false;
    }
}

function fnSetInitFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    fnGoError(msg);
    return false;
}

function fnChkCorpNo() {
    if (!$("#pwd1").val()) {
        fnDefaultAlertFocus("사업자번호 뒷2자리를 입력해주세요.", "pwd1", "warning");
        return false;
    }

    if (!$("#pwd2").val()) {
        fnDefaultAlertFocus("사업자번호 뒷2자리를 입력해주세요.", "pwd2", "warning");
        return false;
    }

    var strHandlerUrl = "/SMS/Pay/Proc/SmsPayHandler.ashx";
    var strCallBackFunc = "fnChkCorpNoSuccResult";
    var strFailCallBackFunc = "fnChkCorpNoFailResult";

    var objParam = {
        CallType: "CorpNoChk",
        No: $("#No").val(),
        CorpNo1: $("#pwd1").val(),
        CorpNo2: $("#pwd2").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnChkCorpNoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            document.location.replace("/SMS/Pay/PayInfo?No=" + encodeURIComponent(objRes[0].No));
            return false;
        } else {
            fnChkCorpNoFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnChkCorpNoFailResult();
        return false;
    }
}

function fnChkCorpNoFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    if (msg !== "") {
        msg = " (" + msg + ")";
    }

    fnDefaultAlert("나중에 다시 시도해 주세요." + msg, "warning");
    return false;
}

function fnChkEventAvail() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Pay/Proc/SmsPayHandler.ashx";
    var strCallBackFunc = "fnChkEventAvailSuccResult";
    var strFailCallBackFunc = "fnChkEventAvailFailResult";

    var objParam = {
        CallType: "EventAvailCheck",
        No: $("#No").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnChkEventAvailSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            if (objRes[0].EventAvailFlag === "Y") {
                $("div.event_popup").show();
            }           
            return false;
        } else {
            fnChkEventAvailFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnChkEventAvailFailResult();
        return false;
    }
}

function fnChkEventAvailFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    //fnGoError(msg);
    return false;
}