$(document).ready(function () {
    if ($("#hidDisplayMode").val() == "Y") {
        fnDefaultAlert($("#hidErrMsg").val(), "success");
        $("#hidDisplayMode").val("");
        $("#hidErrMsg").val("");
    }
});

var tmpArray = new Array();
var tmpOldValue = new Array();
var oldValue;
var sortTotal = 0;

function fnGetSortDDLB(strSortObjID, SortNo) {

    var sort = document.getElementById(strSortObjID);

    for (i = 1; i <= parseInt($("#RecordCnt").val()); i++) {
        opt = document.createElement("option");
        opt.setAttribute("value", i);
        opt.innerHTML = i;

        if (i == SortNo) {
            opt.setAttribute("selected", true);
        }

        sort.appendChild(opt);
    }
}

function fnSetSortDDLB(strSortObjName) //Sort DDLB 가지고 와서 배열에 저장. 페이지 로드시 한번만 실행.
{
    sortDDLB = document.getElementsByName(strSortObjName);

    //DropDownList Box 중 sortddl 아이디를 가진것만 tmpArray에 저장
    for (i = 0; i < sortDDLB.length; i++) {
        tmpOldValue[i] = sortDDLB[i].value;
    }
}

function fnChgSort(strSortObjName, objSortDDLB, strRowNo)    // Sort DDLB 전체 명, Sort No가 변경된 DDLB, 배열 번호 
{
    // 동일한 Name의 Sort DDLB를 확인
    var sorts = document.getElementsByName(strSortObjName);

    // 변경된 Sort No가 이전의 Sort No 보다 클 경우
    if (parseInt(objSortDDLB.value) > parseInt(tmpOldValue[strRowNo - 1])) {
        for (i = 0; i < sorts.length; i++) {
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
        for (i = 0; i < sorts.length; i++) {
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

    for (i = 0; i < tmpOldValue.length; i++) {
        tmpOldValue[i] = tmpArray[i];
        sorts[i].value = tmpOldValue[i];
    }
}


function fnGetMenuKindDDLB(strObjID, menugroupkind) {
    var displaykind = document.getElementById(strObjID);
    opt = document.createElement("option");
    opt.setAttribute("value", "1");
    opt.innerHTML = '오더관리';
    if (menugroupkind == "1") {
        opt.setAttribute("selected", true);
    }
    displaykind.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "2");
    opt.innerHTML = '배차관리';
    if (menugroupkind == "2") {
        opt.setAttribute("selected", true);
    }
    displaykind.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "3");
    opt.innerHTML = '매출관리';
    if (menugroupkind == "3") {
        opt.setAttribute("selected", true);
    }
    displaykind.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "4");
    opt.innerHTML = '매입관리';
    if (menugroupkind == "4") {
        opt.setAttribute("selected", true);
    }
    displaykind.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "5");
    opt.innerHTML = '정보관리';
    if (menugroupkind == "5") {
        opt.setAttribute("selected", true);
    }
    displaykind.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "6");
    opt.innerHTML = '시스템관리';
    if (menugroupkind == "6") {
        opt.setAttribute("selected", true);
    }
    displaykind.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "7");
    opt.innerHTML = '데이터경영';
    if (menugroupkind == "7") {
        opt.setAttribute("selected", true);
    }
    displaykind.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "8");
    opt.innerHTML = '요율표관리';
    if (menugroupkind == "8") {
        opt.setAttribute("selected", true);
    }
    displaykind.appendChild(opt);
}

function fnGetDisplayFlagDDLB(strObjID, UseFlag) {
    var displayflag = document.getElementById(strObjID);

    opt = document.createElement("option");
    opt.setAttribute("value", "Y");
    opt.innerHTML = "Y";

    if ("Y" == UseFlag) {
        opt.setAttribute("selected", true);
    }

    displayflag.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "N");
    opt.innerHTML = "N";

    if ("N" == UseFlag) {
        opt.setAttribute("selected", true);
    }

    displayflag.appendChild(opt);
}

function fnGetUseFlagDDLB(strObjID, strUseFlag) {
    var useflag = document.getElementById(strObjID);

    opt = document.createElement("option");
    opt.setAttribute("value", "Y");
    opt.innerHTML = "Y";

    if ("Y" == strUseFlag) {
        opt.setAttribute("selected", true);
    }

    useflag.appendChild(opt);

    opt = document.createElement("option");
    opt.setAttribute("value", "N");
    opt.innerHTML = "N";

    if ("N" == strUseFlag) {
        opt.setAttribute("selected", true);
    }

    useflag.appendChild(opt);
}

function fnDelAdminMenuGroup(strMenuGroupNo, strMenuGroupName) {
    var fnParam = "'" + strMenuGroupNo + "'";
    fnDefaultConfirm("[" + strMenuGroupName + "] 메뉴 그룹을 삭제하시겠습니까?", "fnDelAdminMenuGroupProc", fnParam);
}
function fnDelAdminMenuGroupProc(ojbParam) {

    var strHandlerURL = "/SSO/Admin/Proc/AdminMenuHandler.ashx";
    var strCallBackFunc = "fnAjaxDelAdminMenuGroup";

    let objParam = {
        CallType: "AdminMenuGroupDelete",
        MenuGroupNo: ojbParam,
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}
function fnAjaxDelAdminMenuGroup(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", "fnAjaxDelAdminMenuGroupComplete()");
    }
}

function fnAjaxDelAdminMenuGroupComplete() {

    document.location.replace("/SSO/Admin/AdminMenuGroupList");
}


function fnUpdAdminMenuGroup() {
    var menugroupno = "";
    var menugroupkind = "";
    var menugroupname = "";
    var menugroupsort = "";
    //var displayimage = "";
    var displayflag = "";
    var useflag = "";
    var allparam = "";

    $("input[name=menugroupno]").each(function () {
        menugroupno = menugroupno + $(this).val() + ",";
    });

    $("select[name=menugroupkind]").each(function () {
        menugroupkind = menugroupkind + $(this).val() + ",";
    });

    $("input[name=menugroupname]").each(function () {
        menugroupname = menugroupname + $(this).val() + ",";
    });

    $("select[name=menugroupsort]").each(function () {
        menugroupsort = menugroupsort + $(this).val() + ",";
    });

    /*$("select[name=displayimage]").each(function () {
        displayimage = displayimage + $(this).val() + ",";
    });*/

    $("select[name=displayflag]").each(function () {
        displayflag = displayflag + $(this).val() + ",";
    });

    $("select[name=useflag]").each(function () {
        useflag = useflag + $(this).val() + ",";
    });

    // 마지막 "," 삭제
    menugroupno = menugroupno.substr(0, menugroupno.length - 1);
    menugroupkind = menugroupkind.substr(0, menugroupkind.length - 1);
    menugroupname = menugroupname.substr(0, menugroupname.length - 1);
    menugroupsort = menugroupsort.substr(0, menugroupsort.length - 1);
    //displayimage = displayimage.substr(0, displayimage.length - 1);
    displayflag = displayflag.substr(0, displayflag.length - 1);
    useflag = useflag.substr(0, useflag.length - 1);

    allparam = menugroupno + "|" + menugroupkind + "|" + menugroupname + "|" + menugroupsort + "|" + displayflag + "|" + useflag;


    var fnParam = "'" + allparam + "'";
    fnDefaultConfirm("수정하시겠습니까?", "fnUpdAdminMenuGroupProc", fnParam);
}
function fnUpdAdminMenuGroupProc(ojbParam) {

    var strHandlerURL = "/SSO/Admin/Proc/AdminMenuHandler.ashx";
    var strCallBackFunc = "fnAjaxUpdAdminMenuGroup";

    let objParam = {
        CallType: "AdminMenuGroupUpdate",
        AllParam: ojbParam,
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxUpdAdminMenuGroup(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", "fnAjaxUpdAdminMenuGroupComplete()");
    }
}

function fnAjaxUpdAdminMenuGroupComplete() {
    document.location.replace("/SSO/Admin/AdminMenuGroupList");
}




function fnddRow(objArgTableID) {
    var objTableID = document.getElementById(objArgTableID);

    sortTotal = (sortTotal > parseInt($("#RecordCnt").val()) ? sortTotal : parseInt($("#RecordCnt").val()));
    sortTotal++;

    tr = document.createElement("tr");
    tr.setAttribute("class", "tablelist");
    tr.setAttribute("text-align", "center");

    td = document.createElement("td");
    strHtml = "<select name=\"menugroupkind\" id=\"menugroupkind_" + sortTotal + "\">";
    strHtml += "<option value=\"1\">오더관리</option>";
    strHtml += "<option value=\"2\">배차관리</option>";
    strHtml += "<option value=\"3\">매출관리</option>";
    strHtml += "<option value=\"4\">매입관리</option>";
    strHtml += "<option value=\"5\">정보관리</option>";
    strHtml += "<option value=\"6\">시스템관리</option>";
    strHtml += "<option value=\"7\">데이터경영</option>";
    strHtml += "<option value=\"8\">요율표관리</option>";
    strHtml += "</select>";

    td.innerHTML = strHtml;
    tr.appendChild(td);

    td = document.createElement("td");
    td.setAttribute("text-align", "center");
    strHtml = "<input type=\"hidden\" name=\"menugroupno\" />";
    strHtml += "<input type=\"text\" name=\"menugroupname\" class=\"type_01\" />";
    td.innerHTML = strHtml;
    tr.appendChild(td);

    td = document.createElement("td");
    strHtml = "<select name=\"menugroupsort\" id=\"menugroupsort_" + sortTotal + "\" onchange=\"javascript:fnChgSort('menugroupsort', this," + sortTotal + ");\" >";

    for (i = 1; i <= sortTotal; i++) {
        if (i == sortTotal) {
            selected = "selected=\"selected\"";
        }
        else {
            selected = "";
        }

        strHtml += "<option value=\"" + i + "\" " + selected + ">" + i + "</option>";
    }
    strHtml += "</select>";
    td.innerHTML = strHtml;

    tr.appendChild(td);


    td = document.createElement("td");
    td.setAttribute("align", "center");
    strHtml = "<select name=\"displayflag\">";
    strHtml += "<option value=\"Y\">Y</option>";
    strHtml += "<option value=\"N\">N</option>";
    strHtml += "</select>";
    td.innerHTML = strHtml;
    tr.appendChild(td);

    td = document.createElement("td");
    td.setAttribute("align", "center");
    strHtml = "<select name=\"useflag\">\n";
    strHtml += "<option value=\"Y\">Y</option>";
    strHtml += "<option value=\"N\">N</option>";
    strHtml += "</select>";
    td.innerHTML = strHtml;
    tr.appendChild(td);

    td = document.createElement("td");
    tr.appendChild(td);

    td = document.createElement("td");
    tr.appendChild(td);

    td = document.createElement("td");
    strHtml = "<button type=\"button\" class=\"ss_type_02\" onclick=\"javascript:fnCancelReload();\">취소</button>";
    td.innerHTML = strHtml;
    tr.appendChild(td);

    objTableID.appendChild(tr);

    // MenuGroupSort DDLB에 정렬순번를 추가
    sortDDLB = document.getElementsByName("menugroupsort");

    //DropDownList
    for (i = 0; i < sortDDLB.length; i++) {
        if (i < sortTotal - 1) {
            opt = document.createElement("option");
            opt.setAttribute("value", sortTotal);
            opt.innerHTML = sortTotal;

            sortDDLB[i].appendChild(opt);
        }

        tmpArray[i] = sortDDLB[i];
        tmpOldValue[i] = sortDDLB[i].value;
    }
}

function fnCancelReload() {
    __doPostBack("cancelWork", "");
}
