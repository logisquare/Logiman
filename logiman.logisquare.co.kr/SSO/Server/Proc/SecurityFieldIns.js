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

        $("#trAdminID").hide();
        $("#trRegDate").hide();
    }
    else {
        $("#lblMode").html("수정");

        $("#FieldName").attr("readonly", true);
        $("#FieldName").css("background-color", "#e7e7e7");
        $("#FieldName").addClass("readonly");

        $("#trAdminID").show();
        $("#trRegDate").show();
    }

    $("#maintable").show();
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnInsSecurityField() {
    var strConfMsg;
    var strCallType;

    if ($("#FieldName").val() === "") {
        fnDefaultAlert("필드명을 입력하세요.", "warning");
        return;
    }

    if ($("#MarkCharCnt").val() === "") {
        fnDefaultAlert("마크 문자 개수를 입력하세요.", "warning");
        return;
    }

    if ($("#UseFlag").val() === "") {
        fnDefaultAlert("사용 여부를 선택하세요.", "warning");
        $("#UseFlag").focus();
        return;
    }

    if ($("#hidMode").val() == "insert") {
        strCallType = "SecurityFieldInsert";
        strConfMsg = "등록하시겠습니까?";
    }
    else {
        strCallType = "SecurityFieldUpdate";
        strConfMsg = "수정하시겠습니까?";
    }

    //Confirm
    //var fnParam = "'" + strCallType + "'";
    fnDefaultConfirm(strConfMsg, "fnInsSecurityFieldProc", strCallType);

    return;
}

function fnInsSecurityFieldProc(ojbParam) {
    var strHandlerURL = "/SSO/Server/Proc/ServerHandler.ashx";
    var strCallBackFunc = "fnAjaxInsSecurityField";

    let objParam = {
        CallType: ojbParam,
        FieldName: $("#FieldName").val(),
        MarkCharCnt: $("#MarkCharCnt").val(),
        FieldDesc: $("#FieldDesc").val(),
        UseFlag: $("#UseFlag").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsSecurityField(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", parent.fnCallGridData("#SecurityFieldListGrid"));
    }
}
