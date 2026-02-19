$(document).ready(function () {
    if ($("#DisplayMode").val() == "Y") {
        if (parent) {
            parent.fnReloadPageNotice($("#ErrMsg").val());
        }
        else if (opener) {
            opener.fnReloadPageNotice($("#ErrMsg").val());
        }
    }

    fnSetInitData();
});

function fnSetInitData() {
    if ($("#hidMode").val() === "insert") {
        $("#lblMode").html("등록");
    }
    else {
        $("#lblMode").html("수정");

        $("#AllowIPAddr").attr("readonly", true);
        $("#AllowIPAddr").css("background-color", "#e7e7e7");
        $("#AllowIPAddr").addClass("readonly");
    }

    $("#maintable").show();
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnInsServerIP() {
    var strConfMsg;
    var strCallType;

    if ($("#ServerType").val() === "") {
        fnDefaultAlert("서버 유형을 입력하세요.", "warning");
        return;
    }

    if ($("#AllowIPAddr").val() === "") {
        fnDefaultAlert("IP를 입력하세요.", "warning");
        return;
    }

    if ($("#UseFlag").val() === "") {
        fnDefaultAlert("사용 여부를 선택하세요.", "warning");
        $("#UseFlag").focus();
        return;
    }

    if ($("#hidMode").val() == "insert") {
        strCallType = "ServerIPInsert";
        strConfMsg = "등록하시겠습니까?";
    }
    else {
        strCallType = "ServerIPUpdate";
        strConfMsg = "수정하시겠습니까?";
    }

    //Confirm
    //var fnParam = "'" + strCallType + "'";
    fnDefaultConfirm(strConfMsg, "fnInsServerIPProc", strCallType);

    return;
}

function fnInsServerIPProc(ojbParam) {
    var strHandlerURL = "/SSO/Server/Proc/ServerHandler.ashx";
    var strCallBackFunc = "fnAjaxInsServerIP";

    let objParam = {
        CallType: ojbParam,
        ServerType: $("#ServerType").val(),
        CenterCode: $("#CenterCode").val(),
        AllowIPAddr: $("#AllowIPAddr").val(),
        AllowIPDesc: $("#AllowIPDesc").val(),
        UseFlag: $("#UseFlag").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsServerIP(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", parent.fnCallGridData("#ServerIPListGrid"));
    }
}
