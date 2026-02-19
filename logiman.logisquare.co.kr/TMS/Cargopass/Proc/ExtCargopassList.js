$(document).ready(function () {
    fnOpenCargopassExtList();
});

function fnOpenCargopassExtList() {
    var strHandlerURL = "/TMS/Cargopass/Proc/ExtCargopassHandler.ashx";
    var strCallBackFunc = "fnGetSessionSuccResult";
    var strFailCallBackFunc = "fnGetSessionFailResult";

    var objParam = {
        CallType: "CargopassSessionList"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    return false;
}

function fnGetSessionSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnOpenCargopassExtListPost(objRes[0].ListURL, objRes[0].SessionKey, objRes[0].EncSession, objRes[0].PageOption);
            return false;
        } else {
            fnGetSessionFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnGetSessionFailResult();
        return false;
    }
}

function fnGetSessionFailResult(strMsg) {
    strMsg = typeof strMsg === "string" ? strMsg : "";
    fnDefaultAlert("일시적인 오류가 발생하여 이용이 불가능합니다." + (strMsg === "" ? "" : ("(" + strMsg + ")")), "warning");
    return false;
}

function fnOpenCargopassExtListPost(strUrl, strSessionKey, strEncSession, strPageOption) {
    var newForm = $("<form></form>");
    newForm.attr("method", "post");
    newForm.attr("action", strUrl);
    newForm.attr("target", "ExtCargopassList");

    newForm.append($("<input/>", { type: "hidden", name: "SessionKey", value: strSessionKey }));
    newForm.append($("<input/>", { type: "hidden", name: "EncSession", value: strEncSession }));
    newForm.append($("<input/>", { type: "hidden", name: "PageOption", value: strPageOption }));

    // 새 창에서 폼을 열기
    newForm.appendTo("body");
    newForm.submit().remove();
}