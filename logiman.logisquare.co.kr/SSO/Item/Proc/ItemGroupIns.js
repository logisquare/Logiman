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

function fnInsItemGroup() {
    var strConfMsg = "";
    var strCallType = "";


    if ($("#GroupCode").val() === "") {
        fnDefaultAlertFocus("그룹코드를 입력하세요.", "GroupCode", "warning");
        return;
    }

    if ($("#GroupName").val() === "") {
        fnDefaultAlertFocus("그룹명을 입력하세요.", "GroupName", "warning");
        return;
    }

    strCallType = "ItemGroupInsert";
    strConfMsg = "등록하시겠습니까?";

    //Confirm
    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsItemGroupProc", fnParam);

    return;
}

function fnInsItemGroupProc(fnParam) {
    var strHandlerURL = "/SSO/Item/Proc/ItemGroupHandler.ashx";
    var strCallBackFunc = "fnAjaxInsItemGroup";

    var objParam = {
        CallType: fnParam,
        MenuGroupNo: $("#hidMenuGroupNo").val(),
        GroupCode: $("#GroupCode").val(),
        GroupName: $("#GroupName").val(),
        AdminFlag: $("#AdminFlag").val(),
        CenterFlag: $("#CenterFlag").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);

}

function fnAjaxInsItemGroup(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        parent.fnReloadPageNotice("등록 성공하였습니다.");
    }
}
