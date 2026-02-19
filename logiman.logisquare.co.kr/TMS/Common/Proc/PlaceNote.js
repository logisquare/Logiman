$(document).ready(function () {
    fnSetInitData();
});

function fnSetInitData() {
    
    if ((!$("#CenterCode").val() && !$("#OrderType").val()) || !$("#PlaceType").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "error", "fnWindowClose()");
        return false;
    }
    fnCallNote();
}

function fnCallNote()
{
    var strHandlerURL = "/TMS/Common/Proc/PlaceNoteHandler.ashx";
    var strCallBackFunc = "fnCallNoteSucc";

    var objParam = {
        CallType: "PlaceNote",
        CenterCode: $("#CenterCode").val(),
        PlaceName: $("#PlaceName").val(),
        PlaceAddr: $("#PlaceAddr").val(),
        PlaceAddrDtl: $("#PlaceAddrDtl").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
}

function fnCallNoteSucc(objRes) {
    if (objRes) {
        if (objRes[0].RetCode ) {
            if (objRes[0].RetCode != 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")", "error", "fnWindowClose()");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].result.ErrorMsg + ")", "error", "fnWindowClose()");
            return false;
        }

        $("#PlaceSeqNo").val(objRes[0].data.PlaceSeqNo);
        if ($("#OrderType").val() === "1") {
            $("#PlaceRemark1").val(objRes[0].data.PlaceRemark1);
            $("#PlaceRemark1")[0].setSelectionRange(0, 0);
            $("#PlaceRemark1").focus();
        } else if ($("#OrderType").val() === "2") {
            $("#PlaceRemark2").val(objRes[0].data.PlaceRemark2);
            $("#PlaceRemark3").val(objRes[0].data.PlaceRemark3);
            $("#PlaceRemark2")[0].setSelectionRange(0, 0);
            $("#PlaceRemark2").focus();
        } else if ($("#OrderType").val() === "3") {
            $("#PlaceRemark3").val(objRes[0].data.PlaceRemark3);
            $("#PlaceRemark3")[0].setSelectionRange(0, 0);
            $("#PlaceRemark3").focus();
        }
    } else {
        fnDefaultAlert("나중에 다시 시도해 주세요.", "error", "fnWindowClose()");
        return false;
    }
}

function fnUpdNote() {
    var strConfMsg = "";

    if (!$("#CenterCode").val() || !$("#OrderType").val() || !$("#PlaceType").val() || !$("#PlaceSeqNo").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "error", "fnWindowClose()");
        return false;
    }

    strConfMsg = $("#NoteTitle").text() + "을 수정하시겠습니까?";

    var fnParam = "PlaceNoteUpdate";
    fnDefaultConfirm(strConfMsg, "fnUpdNoteProc", fnParam);
}

function fnUpdNoteProc(fnParam) {
    var strHandlerURL = "/TMS/Common/Proc/PlaceNoteHandler.ashx";
    var strCallBackFunc = "fnUpdNoteSucc";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        OrderType: $("#OrderType").val(),
        PlaceSeqNo: $("#PlaceSeqNo").val(),
        PlaceRemark1: $("#PlaceRemark1").val(),
        PlaceRemark2: $("#PlaceRemark2").val(),
        PlaceRemark3: $("#PlaceRemark3").val(),
        PlaceRemark4: $("#PlaceRemark4").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnUpdNoteSucc(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")", "error", "fnWindowClose()");
    } else {
        fnDefaultAlert($("#NoteTitle").text() + "이 수정되었습니다.", "info");
    }
}