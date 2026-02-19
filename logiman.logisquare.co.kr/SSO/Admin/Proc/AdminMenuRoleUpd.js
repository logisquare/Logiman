$(document).ready(function () {
    if ($("#hidDisplayMode").val() == "Y") {
        if (parent) {
            parent.fnReloadPageNotice($("#hidErrMsg").val());

        }
        else if (opener) {
            opener.fnReloadPageNotice($("#hidErrMsg").val());
        }
    }

    SetInitData();
});

function SetInitData() {
    if ($("#hidMode").val() == "insert") {
        $("#lblMode").html("등록");
    }
    else {
        $("#lblMode").html("수정");
    }
}

function closeThisLayer() {
    parent.fnCloseCpLayer();
}
function chkRoleType(menuGroupNo, menuNo, type) {
    if (menuNo == 0) {
        chkMenuGroup(menuGroupNo, type);
    }
    else {
        chkMenu(menuGroupNo, menuNo, type);
    }

}

function chkMenuGroup(menuGroupNo, type) {

    var lastindex = 0;
    var menuno = "";

    var targetObjs = document.getElementsByName(type);;
    var blnChkMenuGroup = document.getElementById(type + "_" + menuGroupNo + "_0").checked;

    for (var i = 0; i < targetObjs.length; i++) {
        if (targetObjs[i].id.indexOf(type + "_" + menuGroupNo + "_") != -1) {
            lastindex = targetObjs[i].id.lastIndexOf("_");
            menuno = targetObjs[i].id.substring(lastindex + 1, targetObjs[i].id.length);

            targetObjs[i].checked = blnChkMenuGroup;

            chkMenu(menuGroupNo, menuno, type);
        }
    }
}

function chkMenu(menuGroupNo, menuNo, type) {
    var obj_add = document.getElementById("add_" + menuGroupNo + "_" + menuNo);
    var obj_remove = document.getElementById("remove_" + menuGroupNo + "_" + menuNo);
    var obj_all = document.getElementById("all_" + menuGroupNo + "_" + menuNo);
    var obj_ro = document.getElementById("ro_" + menuGroupNo + "_" + menuNo);
    var obj_rw = document.getElementById("rw_" + menuGroupNo + "_" + menuNo);

    switch (type) {
        case ("add"):
            if (obj_all.checked == false && obj_ro.checked == false && obj_rw.checked == false && obj_add.checked == true) obj_all.checked = true;

            else if (obj_add.checked == false) {
                obj_all.checked = false;
                obj_ro.checked = false;
                obj_rw.checked = false;

            }
            break;

        case ("remove"):
            obj_all.checked = false;
            obj_ro.checked = false;
            obj_rw.checked = false;
            break;
        case ("all"):
            if (obj_add) {
                if (obj_all.checked == false) obj_add.checked = false;
                else if (obj_all.checked == true) obj_add.checked = true;
            }
            if (obj_remove) {
                if (obj_all.checked == false && obj_ro.checked == false && obj_rw.checked == false) obj_remove.checked = true;
                else obj_remove.checked = false;
            }
            if (obj_rw) {
                if (obj_all.checked == false && obj_ro.checked == false && obj_remove.checked == false) obj_rw.checked = true;
                else obj_rw.checked = false;
            }
            obj_ro.checked = false;
            break;
        case ("ro"):
            if (obj_add) {
                if (obj_ro.checked == false) obj_add.checked = false;
                else if (obj_ro.checked == true) obj_add.checked = true;
            }
            if (obj_remove) {
                if (obj_all.checked == false && obj_ro.checked == false && obj_rw.checked == false) obj_remove.checked = true;
                else obj_remove.checked = false;
            }
            if (obj_rw) {
                if (obj_all.checked == false && obj_ro.checked == false && obj_remove.checked == false) obj_rw.checked = true;
                else obj_rw.checked = false;
            }
            obj_all.checked = false;
            break;
        case ("rw"):
            if (obj_add) {
                if (obj_rw.checked == false) obj_add.checked = false;
                else if (obj_rw.checked == true) obj_add.checked = true;
            }
            if (obj_remove) {
                if (obj_all.checked == false && obj_ro.checked == false && obj_rw.checked == false) obj_remove.checked = true;
                else obj_remove.checked = false;
            }
            if (obj_ro) {
                if (obj_all.checked == false && obj_rw.checked == false && obj_remove.checked == false) obj_ro.checked = true;
                else obj_ro.checked = false;
            }
            obj_all.checked = false;
            break;
    }
}

function SaveAll() {
    if ($("#MenuRoleName").val() == "") {

        fnDefaultAlertFocus("메뉴 역할명을 입력하세요.", "MenuRoleName", "warning");
        return;
    }
    if ($("#DDLUseFlag").val() == "") {
        fnDefaultAlertFocus("사용 여부를 선택해 주세요.", "DDLUseFlag", "warning");
        return;
    }

    var addObj = document.getElementsByName("add");
    var removeObj = document.getElementsByName("remove");
    var allObj = document.getElementsByName("all");
    var roObj = document.getElementsByName("ro");
    var rwObj = document.getElementsByName("rw");

    var chkArray = new Array(addObj, removeObj, allObj, roObj, rwObj);

    var retFlag = false;
    var strConfMsg = "";
    for (var i = 0; i < chkArray.length; i++) {
        for (var j = 0; j < chkArray[i].length; j++) {
            if (chkArray[i][j].checked == true) { retFlag = true; break; }
        }
    }

    if (retFlag == false) {
        fnDefaultAlert("메뉴역할에 속할 메뉴를 선택해 주세요.", "warning");
        return;
    }
    else {

        var strAddMenuList = $.map($("input:checkbox[name='add']:checked"), function (n) { return n.value; }).join(",");
        var strRmMenuList = $.map($("input:checkbox[name='remove']:checked"), function (n) { return n.value; }).join(",");
        var strAllAuthCode = $.map($("input:checkbox[name='all']:checked"), function (n) { return n.value; }).join(",");
        var strRwAuthCode = $.map($("input:checkbox[name='rw']:checked"), function (n) { return n.value; }).join(",");
        var strRoAuthCode = $.map($("input:checkbox[name='ro']:checked"), function (n) { return n.value; }).join(",");


        if ($("#hidMode").val() === "insert") {
            strCallType = "AdminMenuRoleInsert";
            strConfMsg = "등록하시겠습니까?";
        }
        else {
            strCallType = "AdminMenuRoleUpdate";
            strConfMsg = "수정하시겠습니까?";
        }


        var fnParam = {
            CallType: strCallType,
            MenuRoleNo: $("#hidMenuRoleNo").val(),
            MenuRoleName: $("#MenuRoleName").val(),
            AddMenuList: strAddMenuList,
            AllAuthCode: strAllAuthCode,
            RmMenuList: strRmMenuList,
            RoAuthCode: strRoAuthCode,
            RwAuthCode: strRwAuthCode,
            UseFlag: $("#DDLUseFlag").val()
        };
        fnDefaultConfirm(strConfMsg, "fnUpdAdminRoleProc", fnParam);


    }
}
function fnUpdAdminRoleProc(objFnParam) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminMenuRoleHandler.ashx";
    var strCallBackFunc = "fnAjaxUpdAdminRole";
    var objParam = objFnParam;

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}
function fnAjaxUpdAdminRole(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", "fnAjaxUpdAdminRoleComplete()", $("#hidMenuRoleNo").val());
    }
}

function fnAjaxUpdAdminRoleComplete(strMenuRoleNo) {
    parent.fnReloadPageNotice();
}