$(document).ready(function () {
    fnSetInitData();
});

function fnSetInitData() {
    if ((!$("#ClientCode").val() && !$("#ConsignorCode").val()) || !$("#Type").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "error", "fnWindowClose()");
        return false;
    }
    fnCallNote();
}

function fnCallNote()
{
    var strHandlerURL = "/TMS/Common/Proc/SpecialNoteHandler.ashx";
    var strCallBackFunc = "fnCallNoteSucc";

    var objParam = {
        CallType: "ClientNote",
        ClientCode: $("#ClientCode").val(),
        ConsignorCode: $("#ConsignorCode").val(),
        Type: $("#Type").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
}

function fnCallNoteSucc(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")", "error", "fnWindowClose()");
    } else {
        $("#CenterCode").val(objRes[0].CenterCode);
        if ($("#Type").val() === "1" || $("#Type").val() == "2") {
            $("#H3Name").text(objRes[0].ClientName + "(" + objRes[0].ClientCorpNo + ")");
            $("#Note").val(objRes[0].ClientNote);
        } else if ($("#Type").val() === "3") {
            $("#H3Name").text(objRes[0].ConsignorName);
            $("#Note").val(objRes[0].ConsignorNote);
        }
        $("#Note")[0].setSelectionRange(0, 0);
        $("#Note").focus();
    }
}

function fnUpdNote() {
    var strConfMsg = "";

    if ((!$("#ClientCode").val() && !$("#ConsignorCode").val()) || !$("#Type").val() || !$("#CenterCode").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "error", "fnWindowClose()");
        return false;
    }

    strConfMsg = $("#NoteTitle").text() + "을(를) 수정하시겠습니까?";

    var fnParam = "ClientNoteUpdate";
    fnDefaultConfirm(strConfMsg, "fnUpdNoteProc", fnParam);
}

function fnUpdNoteProc(fnParam) {
    var strHandlerURL = "/TMS/Common/Proc/SpecialNoteHandler.ashx";
    var strCallBackFunc = "fnUpdNoteSucc";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        ClientCode : $("#ClientCode").val(),
        ConsignorCode: $("#ConsignorCode").val(),
        Note : $("#Note").val(),
        Type : $("#Type").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnUpdNoteSucc(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")", "error", "fnWindowClose()");
    } else {
        fnDefaultAlert($("#NoteTitle").text() + "이(가) 수정되었습니다.", "info");
    }
}