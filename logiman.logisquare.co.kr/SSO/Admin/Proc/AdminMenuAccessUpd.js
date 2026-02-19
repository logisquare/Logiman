$(document).ready(function () {
    if ($("#hidDisplayMode").val() === "Y") {
        if (parent) {
            parent.ReloadPageNotice($("#hidErrMsg").val());
        }
        else if (opener) {
            opener.ReloadPageNotice($("#hidErrMsg").val());
        }
    }

    $("#BtnSaveAll").on("click", function() {
        fnSaveAll();
        return false;
    });

    fnSetInitData();
});

function fnSetInitData() {
    if ($("#hidMode").val() == "insert") {
        $("#BtnSaveAll").html("등록");
    }
    else {
        $("#BtnSaveAll").html("수정");
        if (parseInt($("#hidGradeCode").val()) > 3) {
            $("#AccessTypeMenu").prop("checked", false);
            $("#divAccessList").hide();
            $("#AccessTypeMenu").hide();
            $("#AccessTypeMenu").next("label").hide();
            $("#AccessTypeRole").prop("checked", true);
            $("#divRoleList").show();
        }
        
    }
}

function fnChkRoleType(menuGroupNo, menuNo, type) {
    if (menuNo == 0) {
        fnChkMenuGroup(menuGroupNo, type);
    }
    else {
        fnChkMenu(menuGroupNo, menuNo, type);
    }
}

function fnChkMenuGroup(menuGroupNo, type) {

    var lastindex = 0;
    var menuno = "";

    var targetObjs = document.getElementsByName(type);;
    var blnChkMenuGroup = document.getElementById(type + "_" + menuGroupNo + "_0").checked;

    for (var i = 0; i < targetObjs.length; i++) {
        if (targetObjs[i].id.indexOf(type + "_" + menuGroupNo + "_") != -1) {
            lastindex = targetObjs[i].id.lastIndexOf("_");
            menuno = targetObjs[i].id.substring(lastindex + 1, targetObjs[i].id.length);

            targetObjs[i].checked = blnChkMenuGroup;

            fnChkMenu(menuGroupNo, menuno, type);
        }
    }
}

function fnChkMenu(menuGroupNo, menuNo, type) {
    var obj_add = document.getElementById("add_" + menuGroupNo + "_" + menuNo);
    var obj_remove = document.getElementById("remove_" + menuGroupNo + "_" + menuNo);
    var obj_all = document.getElementById("all_" + menuGroupNo + "_" + menuNo);
    var obj_rw = document.getElementById("rw_" + menuGroupNo + "_" + menuNo);
    var obj_ro = document.getElementById("ro_" + menuGroupNo + "_" + menuNo);

    switch (type) {
        case ("add"):
            if (obj_add.checked == true && obj_all.checked == false && obj_rw.checked == false && obj_ro.checked == false) obj_all.checked = true;

            else if (obj_add.checked == false) {
                obj_all.checked = false;
                obj_rw.checked = false;
                obj_ro.checked = false;
            }

            break;
        case ("remove"):
            obj_all.checked = false;
            obj_rw.checked = false;
            obj_ro.checked = false;
            break;
        case ("all"):
            if (obj_add) {
                if (obj_all.checked == false) obj_add.checked = false;
                else if (obj_all.checked == true) obj_add.checked = true;
            }
            if (obj_remove) {
                if (obj_all.checked == false && obj_rw.checked == false && obj_ro.checked == false) obj_remove.checked = true;
                else obj_remove.checked = false;
            }
            obj_rw.checked = false;
            obj_ro.checked = false;
            break;
        case ("rw"):
            if (obj_add) {
                if (obj_rw.checked == false) obj_add.checked = false;
                else if (obj_rw.checked == true) obj_add.checked = true;
            }
            if (obj_remove) {
                if (obj_all.checked == false && obj_rw.checked == false) obj_remove.checked = true;
                else obj_remove.checked = false;
            }

            obj_all.checked = false;
            obj_ro.checked = false;
            break;
        case ("ro"):
            if (obj_add) {
                if (obj_ro.checked == false) obj_add.checked = false;
                else if (obj_ro.checked == true) obj_add.checked = true;
            }
            if (obj_remove) {
                if (obj_all.checked == false && obj_ro.checked == false) obj_remove.checked = true;
                else obj_remove.checked = false;
            }

            obj_all.checked = false;
            obj_rw.checked = false;
            break;
    }
}

function fnToggleMenu(no) {
    if (no == '1') {
        $("#divAccessList").css("display", "");
        $("#divRoleList").css("display", "none");
    }
    else {
        $("#divAccessList").css("display", "none");
        $("#divRoleList").css("display", "");
    }
}

function fnSaveAll()
{
    var strConfMsg = "";
    var intAccessTypeCode = 0;
    var strAddMenuList = $.map($("input:checkbox[name='add']:checked"), function (n) { return n.value; }).join(",");
    var strRmMenuList = $.map($("input:checkbox[name='remove']:checked"), function (n) { return n.value; }).join(",");
    var strAllAuthCode = $.map($("input:checkbox[name='all']:checked"), function (n) { return n.value; }).join(",");
    var strRwAuthCode = $.map($("input:checkbox[name='rw']:checked"), function (n) { return n.value; }).join(",");
    var strRoAuthCode = $.map($("input:checkbox[name='ro']:checked"), function (n) { return n.value; }).join(",");
    var strAddRoleList = $.map($("input:checkbox[name='addrole']:checked"), function (n) { return n.value; }).join(",");
    var strRmRoleList = $.map($("input:checkbox[name='removerole']:checked"), function (n) { return n.value; }).join(",");
    var strAdminID = $("#hidAdminID").val();


    if ($("#AccessTypeMenu").is(":checked")) {
        intAccessTypeCode = 1;
    }

    if ($("#AccessTypeRole").is(":checked")){
        intAccessTypeCode = 2;
        strAddMenuList = strAddRoleList;
        strRmMenuList = strRmRoleList;
        strAllAuthCode = "";
        strRwAuthCode = "";
        strRoAuthCode = "";
    }

    if (intAccessTypeCode === 0) {
        fnDefaultAlert("접근방법을 선택 후 등록이 가능합니다.", "warning");
        return;
    }

    if (!$("#hidAdminID").val()) {
        fnDefaultAlert("사용자 정보가 없습니다.", "warning");
        return;
    }

    strConfMsg = "메뉴 사용 권한을 등록하시겠습니까?";

    //Confirm
    var fnParam = {
        CallType: "AdminMenuAccessInsert",
        AccessTypeCode: intAccessTypeCode,
        AdminID: strAdminID,
        AddMenuList : strAddMenuList,
        RmMenuList : strRmMenuList,
        AllAuthCode : strAllAuthCode,
        RwAuthCode : strRwAuthCode,
        RoAuthCode : strRoAuthCode
    };
    
    fnDefaultConfirm(strConfMsg, "fnSaveAllProc", fnParam);
    return;
}


function fnSaveAllProc(objFnParam) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminMenuAccessUpdHandler.ashx";
    var strCallBackFunc = "fnSaveAllCallBack";
    var objParam = objFnParam;

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnSaveAllCallBack(data) {

    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("메뉴 사용 권한이 등록되었습니다.", "success", "fnSaveAllComplete", $("#hidAdminID").val());
    }

    return false;
}

function fnSaveAllComplete(strAdminID) {
    document.location.replace("/SSO/Admin/AdminMenuAccessUpd?AdminID=" + strAdminID);
}