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

        $("#CodeName").attr("readonly", true);
        $("#CodeName").css("background-color", "#e7e7e7");
        $("#CodeName").addClass("readonly");

        $("#trAdminID").show();
        $("#trRegDate").show();
    }

    $("#maintable").show();
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnInsCode() {
    var strConfMsg;
    var strCallType;

    if ($("#CodeName").val() === "") {
        fnDefaultAlert("코드명을 입력하세요.", "warning");
        return;
    }

    if ($("#CodeVal").val() === "") {
        fnDefaultAlert("코드값을 입력하세요.", "warning");
        return;
    }

    if ($("#hidMode").val() == "insert") {
        strCallType = "CodeInsert";
        strConfMsg = "등록하시겠습니까?";
    }
    else {
        strCallType = "CodeUpdate";
        strConfMsg = "수정하시겠습니까?";
    }

    //Confirm
    //var fnParam = "'" + strCallType + "'";
    fnDefaultConfirm(strConfMsg, "fnInsCodeProc", strCallType);

    return;
}

function fnInsCodeProc(ojbParam) {
    var strHandlerURL = "/SSO/Server/Proc/ServerHandler.ashx";
    var strCallBackFunc = "fnAjaxInsCode";

    let objParam = {
        CallType: ojbParam,
        CodeName: $("#CodeName").val(),
        CodeVal: $("#CodeVal").val(),
        CodeDesc: $("#CodeDesc").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsCode(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", parent.fnCallGridData("#CodeListGrid"));
    }
}
