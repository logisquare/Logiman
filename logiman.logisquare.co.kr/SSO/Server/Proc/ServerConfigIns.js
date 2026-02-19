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

        $("#KeyName").attr("readonly", true);
        $("#KeyName").css("background-color", "#e7e7e7");
        $("#KeyName").addClass("readonly");
    }

    $("#maintable").show();
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnInsServerConfig() {
    var strConfMsg;
    var strCallType;

    if ($("#ServerType").val() === "") {
        fnDefaultAlert("서버 유형을 입력하세요.", "warning");
        return;
    }

    if ($("#KeyName").val() === "") {
        fnDefaultAlert("키 명을 입력하세요.", "warning");
        return;
    }

    if ($("#KeyVal").val() === "") {
        fnDefaultAlert("키 값을 입력하세요.", "warning");
        return;
    }

    if ($("#hidMode").val() == "insert") {
        strCallType = "ServerConfigInsert";
        strConfMsg = "등록하시겠습니까?";
    }
    else {
        strCallType = "ServerConfigUpdate";
        strConfMsg = "수정하시겠습니까?";
    }

    //Confirm
    //var fnParam = "'" + strCallType + "'";
    fnDefaultConfirm(strConfMsg, "fnInsServerConfigProc", strCallType);

    return;
}

function fnInsServerConfigProc(ojbParam) {
    var strHandlerURL = "/SSO/Server/Proc/ServerHandler.ashx";
    var strCallBackFunc = "fnAjaxInsServerConfig";

    let objParam = {
        CallType: ojbParam,
        ServerType: $("#ServerType").val(),
        KeyName: $("#KeyName").val(),
        KeyVal: $("#KeyVal").val(),
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsServerConfig(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", parent.fnCallGridData("#ServerConfigListGrid"));
    }
}
