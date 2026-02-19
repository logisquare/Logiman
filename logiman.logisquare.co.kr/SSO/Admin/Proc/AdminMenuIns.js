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
   
    if ($("#hidMode").val() === "insert") {
        $("#lblMode").html("등록");
    }
    else {
        $("#lblMode").html("수정");
    }
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnReloadPageNotice(strMsg) {
    fnClosePopUpLayer();
    fnDefaultAlert(strMsg, "info");

}

function fnInsAdminMenu() {
    var strConfMsg;
    var strCallType;
    

    if ($("#MenuName").val() === "") {
        fnDefaultAlertFocus("메뉴 명을 입력하세요.", "MenuName", "warning");
        return;
    }

    if ($("#MenuLink").val() === "") {
        fnDefaultAlertFocus("메뉴 링크를 입력하세요.", "MenuLink", "warning");
        return;
    }

    if ($("#DDLUseStateCode").val() === "") {
        fnDefaultAlertFocus("메뉴 유형을 선택하세요.", "DDLUseStateCode", "warning");
        return;
    }

    if ($("#hidMode").val() === "insert") {
        strCallType = "AdminMenuInsert";
        strConfMsg = "등록하시겠습니까?";
    }
    else {
        strCallType = "AdminMenuUpdate";
        strConfMsg = "수정하시겠습니까?";
    }

    //Confirm
    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsAdminMenuProc", fnParam);

    return;
}

function fnInsAdminMenuProc(ojbParam) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminMenuHandler.ashx";
    var strCallBackFunc = "fnAjaxInsAdminMenu";

    let objParam = {
        CallType: ojbParam,
        MenuGroupNo: $("#hidMenuGroupNo").val(),
        MenuNo: $("#hidMenuNo").val(),
        MenuName: $("#MenuName").val(),
        MenuLink: $("#MenuLink").val(),
        MenuSort: $("#hidMenuSort").val(),
        MenuDesc: $("#MenuDesc").val(),
        UseStateCode: $("#DDLUseStateCode").val(),  
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
   
}

function fnAjaxInsAdminMenu(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        if ($("#hidMode").val() === "insert") {
            parent.fnReloadPageNotice("등록 성공하였습니다.");
        }
        else {
            parent.fnReloadPageNotice("수정 성공하였습니다");
        }
    }
}
