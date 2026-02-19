$(document).ready(function () {
    if ($("#hidDisplayMode").val() == "Y") {
        fnDefaultAlert($("#hidErrMsg").val(), "success");
        $("#hidDisplayMode").val("");
        $("#hidErrMsg").val("");
    }

    fnDisplayListView();

    $("#DDLMenuGroup").change(function () {
        __doPostBack("", "");
    });
});

function fnDisplayListView() {
    if ($("#DDLMenuGroup").val() == "") {
        $("#ListView").css("display", "none");
    }
    else {
        $("#ListView").css("display", "");
    }
}

var tmpArray = new Array();
var tmpOldValue = new Array();

function fnSetSortDDLB(strSortObjName) {
    var sortDDLB = document.getElementsByName(strSortObjName);

    //DropDownList Box 중 sortddl 아이디를 가진것만 tmpArray에 저장
    for (var i = 0; i < sortDDLB.length; i++) {
        tmpOldValue[i] = sortDDLB[i].value;
    }
}

function fnGetSortDDLB(strSortObjID, SortNo) {
    var sort = document.getElementById(strSortObjID);

    for (var i = 1; i <= parseInt($("#RecordCnt").val()); i++) {
        var opt = document.createElement("option");
        opt.setAttribute("value", i);
        opt.innerHTML = i;

        if (i == SortNo) {
            opt.setAttribute("selected", true);
        }

        sort.appendChild(opt);
    }
}

function fnChgSort(strSortObjName, objSortDDLB, strRowNo)    // Sort DDLB 전체 명, Sort No가 변경된 DDLB, 배열 번호 
{
    // 동일한 Name의 Sort DDLB를 확인
    var sorts = document.getElementsByName(strSortObjName);

    // 변경된 Sort No가 이전의 Sort No 보다 클 경우
    if (parseInt(objSortDDLB.value) > parseInt(tmpOldValue[strRowNo - 1])) {
        for (var i = 0; i < sorts.length; i++) {
            // 임시 배열에 변경될 Sort No를 저장.
            // 배열에 저장된 이전 Sort No보다 크고, 변경 된 Sort No보다 작거나 같은 Sort No을 1씩 차감한다.
            if (parseInt(tmpOldValue[i]) > parseInt(tmpOldValue[strRowNo - 1]) && parseInt(tmpOldValue[i]) <= parseInt(objSortDDLB.value)) {
                tmpArray[i] = parseInt(tmpOldValue[i]) - 1;
            }
            else if (parseInt(tmpOldValue[i]) == parseInt(tmpOldValue[strRowNo - 1])) {
                tmpArray[i] = objSortDDLB.value;
            }
            else {
                tmpArray[i] = tmpOldValue[i];
            }
        }
    }

    // 변경된 Sort No가 이전의 Sort No 보다 작을 경우
    if (parseInt(objSortDDLB.value) < parseInt(tmpOldValue[strRowNo - 1])) {
        for (var i = 0; i < sorts.length; i++) {
            // 임시 배열에 변경될 Sort No를 저장.
            // 배열에 저장된 이전 Sort No보다 작고, 변경 된 Sort No보다 큰 Sort No을 1씩 증감한다.
            if (parseInt(tmpOldValue[i]) >= parseInt(objSortDDLB.value) && parseInt(tmpOldValue[i]) < parseInt(tmpOldValue[strRowNo - 1])) {
                tmpArray[i] = parseInt(tmpOldValue[i]) + 1;
            }
            else if (parseInt(tmpOldValue[i]) == parseInt(tmpOldValue[strRowNo - 1])) {
                tmpArray[i] = objSortDDLB.value;
            }
            else {
                tmpArray[i] = tmpOldValue[i];
            }
        }
    }

    for (var i = 0; i < tmpOldValue.length; i++) {
        tmpOldValue[i] = tmpArray[i];
        sorts[i].value = tmpOldValue[i];
    }
}

function fnGetUseStateCodeDDLB(strObjID, UseStateCode) {
    var usestatecode = document.getElementById(strObjID);

    var opt = document.createElement("option");
    opt.setAttribute("value", "1");
    opt.innerHTML = '정상';

    if ("1" == UseStateCode) {
        opt.setAttribute("selected", true);
    }

    usestatecode.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "2");
    opt.innerHTML = '비정상';

    if ("2" == UseStateCode) {
        opt.setAttribute("selected", true);
    }

    usestatecode.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "3");
    opt.innerHTML = '팝업 정상';

    if ("3" == UseStateCode) {
        opt.setAttribute("selected", true);
    }

    usestatecode.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "4");
    opt.innerHTML = '팝업 비정상';

    if ("4" == UseStateCode) {
        opt.setAttribute("selected", true);
    }

    usestatecode.appendChild(opt);
}

function fnUpdAdminMenuAll() {
    var menuno = "";
    var menusort = "";
    var usestatecode = "";
    var allparam = "";

    $("input[name=menuno]").each(function () {
        menuno = menuno + $(this).val() + ",";
    });

    $("select[name=menusort]").each(function () {
        menusort = menusort + $(this).val() + ",";
    });

    $("select[name=usestatecode]").each(function () {
        usestatecode = usestatecode + $(this).val() + ",";
    });

    // 마지막 "," 삭제
    menuno = menuno.substr(0, menuno.length - 1);
    menusort = menusort.substr(0, menusort.length - 1);
    usestatecode = usestatecode.substr(0, usestatecode.length - 1);

    allparam = menuno + "|" + menusort + "|" + usestatecode;
    var fnParam = "'" + allparam + "'";
    fnDefaultConfirm("수정하시겠습니까?", "fnUpdAdminMenuProc", fnParam);
}
function fnUpdAdminMenuProc(ojbParam) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminMenuHandler.ashx";
    var strCallBackFunc = "fnAjaxUpdAdminMenu";

    let objParam = {
        CallType: "AdminMenuUpdateList",
        AllParam: ojbParam,
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxUpdAdminMenu(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", "fnAjaxUpdAdminMenuComplete()");
    }
}

function fnAjaxUpdAdminMenuComplete() {
    __doPostBack("", "");
}


function fnUpdAdminMenu(title, menuGroupNo, menuNo) {
    var nMenuGroupNo = "";

    if (menuGroupNo == "") {
        if ($("#DDLMenuGroup").val() == "") {
            AlertNotice("메뉴 그룹을 선택해 주세요.");
            return;
        }

        nMenuGroupNo = $("#DDLMenuGroup").val();
    }
    else {
        nMenuGroupNo = menuGroupNo;
    }

    fnOpenRightSubLayer(title, "/SSO/Admin/AdminMenuUpd.aspx?MenuGroupNo=" + nMenuGroupNo + "&MenuNo=" + menuNo, "500px", "350px", "30%");
}

function fnDelAdminMenu(menuNo, menuName) {
    var fnParam = "'" + menuNo + "'";
    fnDefaultConfirm("[" + menuName + "] 메뉴를 삭제하시겠습니까?", "fnDelAdminMenuProc", fnParam);
}
function fnDelAdminMenuProc(ojbParam) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminMenuHandler.ashx";
    var strCallBackFunc = "fnAjaxDelAdminMenu";

    let objParam = {
        CallType: "AdminMenuDelete",
        MenuNo: ojbParam,
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}
function fnAjaxDelAdminMenu(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", "fnAjaxDelAdminMenuComplete()");
    }
}

function fnAjaxDelAdminMenuComplete() {
    __doPostBack("", "");
}