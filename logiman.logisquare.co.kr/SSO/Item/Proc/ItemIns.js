$(document).ready(function () {

    if ($("#hidDisplayMode").val() === "Y") {
        if (parent) {
            parent.fnReloadPageNotice($("#hidErrMsg").val());
        }
        else if (opener) {
            opener.fnReloadPageNotice($("#hidErrMsg").val());
        }
    }
    fnSetInitData();
});

function fnSetInitData() {
    /*
    if ($("#hidMode").val() === "insert") {
        $("#lblMode").html("등록");
    }
    else {
        $("#lblMode").html("수정");
    }
    */
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnReloadPageNotice(strMsg) {
    fnClosePopUpLayer();
    fnDefaultAlert(strMsg, "info");

}

function fnInsItem() {
    var strConfMsg = "";
    var strCallType = "";


    if ($("#GroupCode").val() === "") {
        fnDefaultAlertFocus("그룹코드를 입력하세요.", "GroupCode", "warning");
        return;
    }

    if ($("#ItemName").val() === "") {
        fnDefaultAlertFocus("항목명을 입력하세요.", "ItemName", "warning");
        return;
    }

    strCallType = "ItemInsert";
    strConfMsg = "등록하시겠습니까?";

    //Confirm
    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsItemProc", fnParam);

    return;
}

function fnInsItemProc(fnParam) {
    var strHandlerURL = "/SSO/Item/Proc/ItemHandler.ashx";
    var strCallBackFunc = "fnAjaxInsItem";

    var objParam = {
        CallType: fnParam,
        GroupCode: $("#hidGroupCode").val(),
        ItemCode: $("#ItemCode").val(),
        ItemName: $("#ItemName").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);

}

function fnAjaxInsItem(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        parent.fnReloadPageNotice("등록 성공하였습니다.");
    }
}
