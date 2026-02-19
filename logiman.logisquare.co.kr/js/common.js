/*************************************************************
*                      팝업 Layer 관련 함수
**************************************************************/
$(document).ready(function () {
    /*팝업 레이어 리사이즈*/
    if ($("#cp_layer").length > 0) {
        $("#cp_layer").resizable({
            minWidth: 320,
            maxWidth: $(document).width() - 210,
            handles: "w",
            start: function (event, ui) {
                $("#ifrm_layer").css("pointer-events", "none");
            },
            stop: function (event, ui) {
                $("#ifrm_layer").css("pointer-events", "auto");
            }

        });
    }
});

function fnOpenCpLayer() {
    $("#cp_layer").css("left", "");
    $("#cp_layer").toggle();
}
function fnCloseCpLayer() {
    $("#ifrm_layer").attr("src", "about:blank");
    $("#cp_layer").css("left", "");
    $("#cp_layer").toggle();
}

function fnOpenCpLayerSub() {
    $("#cp_layer_sub").css("left", "");
    $("#cp_layer_sub").toggle();
}
function fnCloseCpLayerSub() {
    $("#cp_layer_sub").css("left", "");
    $("#cp_layer_sub").toggle();
}

function fnSmallLayer() {
    $("#cp_layer_smallLayer").css("display", "none");
    $("#cp_layer_bigLayer").css("display", "");
    $("div#cp_layer").css("width", "");
    $("div#cp_layer").css("left", "");
    $("#cp_layer").animate({
        width: "50%"
    }, 200);
}

function fnBigLayer() {
    $("#cp_layer_smallLayer").css("display", "");
    $("#cp_layer_bigLayer").css("display", "none");
    $("div#cp_layer").css("width", "");
    $("div#cp_layer").css("left", "");
	$("#cp_layer").animate({
        width: $(window).width()
	}, 200);
}

function fnPageReplace(url) {
    document.getElementById("Content_frame").src = url;
}

function fnRootPageReplace(url) {
    if (opener) {
        opener.location.replace(url);
        return;
    }
    else if (parent) {
        parent.location.replace(url);
    }
    else {
        location.replace(url);
    }
}

//윈도우 팝업 기본 
//주소, 팝업 이름, 가로, 세로, 팝업 옵션
function fnPopupWindow(url, title, w, h, options) {
    // Fixes dual-screen position                         Most browsers      Firefox
    var dualScreenLeft = window.screenLeft != "undefined" ? window.screenLeft : screen.left;
    var dualScreenTop = window.screenTop != "undefined" ? window.screenTop : screen.top;

    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var left = ((width / 2) - (w / 2)) + dualScreenLeft;
    var top = ((height / 2) - (h / 2)) + dualScreenTop;
    var newWindow = window.open(url, title, "width=" + w + ", height=" + h + ", top=" + top + ", left=" + left + options);

    // Puts focus on the newWindow
    setTimeout(function () {
        if (window.focus) {
            newWindow.focus();
        }
    }, 200);
}

//윈도우 팝업 - Post로 팝업에 Parameter 전송
//주소, 팝업 이름, 가로, 세로, 팝업 옵션, 폼(mainform) 전송 여부
function fnPopupWindowPost(url, title, w, h, options, formSendFlag = false, objParam = null) {
    // Fixes dual-screen position                         Most browsers      Firefox
    var dualScreenLeft = window.screenLeft != "undefined" ? window.screenLeft : screen.left;
    var dualScreenTop = window.screenTop != "undefine" ? window.screenTop : screen.top;

    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var left = ((width / 2) - (w / 2)) + dualScreenLeft;
    var top = ((height / 2) - (h / 2)) + dualScreenTop;
    var newWindow = window.open("", title, "width=" + w + ", height=" + h + ", top=" + top + ", left=" + left + options);

    var $form = null;
    if ($("form[name=popupform]").length > 0) {
        $form = $("form[name=popupform]");
        $form.remove();
        $form = null;
    }

    $form = $("<form name='popupform'></form>");
    $form.attr("action", url);
    $form.attr("method", "post");
    $form.attr("target", title);

    if (formSendFlag) {
        var formData = $("#mainform").serializeObject();
        $form.addHidden(formData);
    }

    if (objParam !== null) {
        $form.addHidden(objParam);
    }

    $form.appendTo("body");
    $form.submit();
    $form.remove();

    // Puts focus on the newWindow
    setTimeout(function () {
        if (window.focus) {
            newWindow.focus();
        }
    }, 200);
}

/***************************************************************************/
/*							디자인 Alert 실행함수							   */
/***************************************************************************/
function fnDefaultAlert(msg, type = "error", closeFunction = "", closeParam = null, title = "로지스퀘어 매니저") {
    Swal.fire({
        icon: type, //error,info,success,warning,question
        title: title,
        html: msg,
        didClose: function () {
            if (typeof closeFunction === "undefined") {
                closeFunction = "";
            }

            if (closeFunction !== "") {
                if (closeParam !== null) {
                    eval(closeFunction)(closeParam);
                } else {
                    eval(closeFunction);
                }
            }
        }
    });
}

function fnDefaultAlertFocus(msg, focusId = "", type = "error", closeFunction = "", closeParam = null, title = "로지스퀘어 매니저") {
    Swal.fire({
        icon: type, //error,info,success,warning,question
        title: title,
        html: msg,
        didClose: function () {

            if (typeof closeFunction === "undefined") {
                closeFunction = "";
            }

            if (closeFunction !== "") {
                if (closeParam !== null) {
                    eval(closeFunction)(closeParam);
                } else {
                    eval(closeFunction);
                }
            }

            if (typeof focusId === "undefined") {
                focusId = "";
            }

            if ($("#" + focusId).length > 0) {
                $("#" + focusId).focus();
            }
        }
    });
}

/***************************************************************************/
/*							Toast메세지 실행함수							   */
/***************************************************************************/
function fnDefaultToast(msg, type = "error") {
    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer);
            toast.addEventListener('mouseleave', Swal.resumeTimer);
        }
    });

    Toast.fire({
        icon: type,
        title: msg
    });
}

/***************************************************************************/
/*							디자인 Confirm 실행함수						       */
/***************************************************************************/
function fnDefaultConfirm(msg, trueFunction = "", trueParam = null, falseFunction = "", falseParam = null, type = "question", title = "로지스퀘어 매니저") {
    Swal.fire({
        title: title,
        html: msg,
        icon: type, //error,info,success,warning,question
        showCancelButton: true,
        confirmButtonText: "네",
        cancelButtonText: "아니오"
    }).then((result) => {
        if (result.value) {

            if (typeof trueFunction === "undefined") {
                trueFunction = "";
            }

            //true일때 실행시킬 함수
            if (trueFunction !== "") {
                if (trueParam !== null) {
                    eval(trueFunction)(trueParam);
                } else {
                    eval(trueFunction);
                }
            }
        } else {

            if (typeof falseFunction === "undefined") {
                falseFunction = "";
            }

            if (falseFunction !== "") {
                if (falseParam !== null) {
                    eval(falseFunction)(falseParam);
                } else {
                    eval(falseFunction);
                }
            }

        }
    });
}

function fnDefaultConfirmWithCheckbox(msg, chkMsg, trueFunction = "", trueParam = null, falseFunction = "", falseParam = null, type = "question", title = "로지스퀘어 매니저") {
    Swal.fire({
        title: title,
        html: msg,
        icon: type, //error,info,success,warning,question
        showCancelButton: true,
        confirmButtonText: "네",
        cancelButtonText: "아니오",
        input: "checkbox",
        inputPlaceholder: chkMsg
    }).then((result) => {
        if (result.isConfirmed) {

            if (typeof trueFunction === "undefined") {
                trueFunction = "";
            }

            //true일때 실행시킬 함수
            if (trueFunction !== "") {
                if (trueParam !== null) {
                    trueParam.isConfirmChecked = result.value === 1;
                } else {
                    trueParam = {isConfirmChecked: result.value === 1}
                }
                eval(trueFunction)(trueParam);
            }
        } else {

            if (typeof falseFunction === "undefined") {
                falseFunction = "";
            }

            if (falseFunction !== "") {
                if (falseParam !== null) {
                    eval(falseFunction)(falseParam);
                } else {
                    eval(falseFunction);
                }
            }
        }
    });
}

/***************************************************************************/
/*							디자인 Confirm 결과 함수					       */
/* EX) 데이터를 호출하는 함수 CallFunction에 해당 함수를 넣어 결과 메시지를 보여준다	   */
/***************************************************************************/
function fnResultConfirm(title, msg, type) {
    Swal.fire(
        title,
        msg,
        type
    );
}

/*************************************************************
*                      Grid 관련 공통 함수
**************************************************************/
// 그리드 페이징 네비게이터
function fnCreatePagingNavigator() {

    var totalRowCount = $("#RecordCnt").val(); // 전체 데이터 건수
    var rowCount = $("#PageSize").val();	// 1페이지에서 보여줄 행 수
    var pageButtonCount = 5;		// 페이지 네비게이션에서 보여줄 페이지의 수
    var currentPage = $("#PageNo").val();	// 현재 페이지
    var totalPage = Math.ceil(totalRowCount / rowCount);	// 전체 페이지 계산

    if (totalRowCount) {
        totalRowCount = parseInt(totalRowCount);
    } else {
        totalRowCount = 0;
    }

    if (rowCount) {
        rowCount = parseInt(rowCount);
    } else {
        rowCount = 1000;
    }

    if (currentPage) {
        currentPage = parseInt(currentPage);
    } else {
        currentPage = 1;
    }

    var retStr = "";
    var prevPage = parseInt((currentPage - 1) / pageButtonCount) * pageButtonCount;
    var nextPage = ((parseInt((currentPage - 1) / pageButtonCount)) * pageButtonCount) + pageButtonCount + 1;

    prevPage = Math.max(0, prevPage);
    nextPage = Math.min(nextPage, totalPage);

    // 처음
    if (totalPage > 1 && currentPage > 1) {
        retStr += "<span class=\"page_prev\"><a href=\"javascript:void(0);\" onclick=\"fnMoveToPage(1); return false;\">&lt;&lt;</a></span>\n";
    }

    // 이전
    if (prevPage > 0) {
        retStr += "<span class=\"page_prev\"><a href=\"javascript:void(0);\" onclick=\"fnMoveToPage(" + prevPage + "); return false;\">&lt;</a></span>\n";
    }

    //retStr += "<span class=\"page_num\">\n";

    for (var i = (prevPage + 1), len = (pageButtonCount + prevPage); i <= len; i++) {
        if (currentPage == i) {
            retStr += "<a href=\"javascript:void(0);\" class=\"on\">" + i + "</a>\n";
        } else {
            retStr += "<a href=\"javascript:void(0);\" onclick=\"fnMoveToPage(" + i + "); return false;\">";
            retStr += i;
            retStr += "</a>\n";
        }

        if (i >= totalPage) {
            break;
        }

    }

    //retStr += "</span>\n";

    // 다음
    if (nextPage > 0 && nextPage != totalPage) {
        retStr += "<span class=\"page_next\"><a href=\"#\" onclick=\"fnMoveToPage(" + nextPage + "); return false;\">&gt;</a></span>\n";
    }
    // 마지막
    if (totalPage > 0 && currentPage != totalPage) {
        retStr += "<span class=\"page_next\"><a href=\"#\" onclick=\"fnMoveToPage(" + totalPage + "); return false;\">&gt;&gt;</a></span>\n";
    }

    $("#page").html(retStr);
}

// 검색 notFound 이벤트 핸들러
function fnGridSearchNotFoundHandler(event) {
    var term = event.term; // 찾는 문자열
    var wrapFound = event.wrapFound; // wrapSearch 한 경우 만족하는 term 이 그리드에 1개 있는 경우.

    if (wrapFound) {
        fnDefaultAlert("그리드 마지막 행을 지나 다시 찾았지만 다음 문자열을 찾을 수 없습니다 - " + term, "warning");
    } else {
        fnDefaultAlert("다음 문자열을 찾을 수 없습니다 - " + term, "warning");
    }
}

//항목관리 팝업 Open
function fnGridColumnManage(strGridID, objButton) {
    if (typeof objButton != "undefined") {
        $("#GRID_COLUMN_LAYER .grid_manage").css("right", $(".grid_list ul li.right").width() + 30);
    }
    fnGridColumnSetting("GRID", strGridID);
    $("#GRID_COLUMN_LAYER").slideDown(500);
}

function fnGridColumnSetting(obj, strGridID) {
    var ColumnData = fnGetDefaultColumnLayout();
    var columnLayout = AUIGrid.getColumnLayout("#" + strGridID);
    var ColumnHtml = "";
    var chacked = "";

    if (!columnLayout) {
        for (var i = 0; i < ColumnData.length; i++) {
            if (ColumnData[i].viewstatus === true) {
                ColumnHtml += "<input type=\"checkbox\" class=\"gird_check\" id=\"GridColumn" + ColumnData[i].dataField + "\" value=\"" + ColumnData[i].dataField + "\" onclick=\"fnCheckboxChangeHandler(event,'" + strGridID + "')\" checked><label for=\"GridColumn" + ColumnData[i].dataField + "\"><span></span>" + ColumnData[i].headerText + "</label></br>";
            }
        }
    } else {
        for (var j = 0; j < columnLayout.length; j++) {
            if (columnLayout[j].visible === false) {
                chacked = "";
            } else {
                chacked = "checked";
            }
            if (columnLayout[j].viewstatus === true) {
                ColumnHtml += "<input type=\"checkbox\" class=\"gird_check\" id=\"GridColumn" + columnLayout[j].dataField + "\" value=\"" + columnLayout[j].dataField + "\" onclick=\"fnCheckboxChangeHandler(event,'" + strGridID + "')\" " + chacked + "><label for=\"GridColumn" + columnLayout[j].dataField + "\"><span></span>" + columnLayout[j].headerText + "</label><br/>";
            }
        }
    }
    $("#GridColumn").html(ColumnHtml);
    
    if ($("#GridColumn input[type=checkbox]:checked").length === $("#GridColumn input[type=checkbox]").length) {
        $("#AllGridColumnCheck").prop("checked", true);
    } else {
        $("#AllGridColumnCheck").prop("checked", false);
    }
}

//항목 전체체크/해제
function fnColumnChkAll(strGridID) {
    var ColumnId = "#GridColumn";

    if ($("#AllGridColumnCheck").is(":checked")) {
        $(ColumnId + " input[type=checkbox]").prop("checked", true);
        $.each($(ColumnId + " input[type=checkbox]"), function(index, item) {
            AUIGrid.showColumnByDataField("#" + strGridID, $(item).val());
        });
    } else {
        $(ColumnId + " input[type=checkbox]").prop("checked", false);
        $.each($(ColumnId + " input[type=checkbox]"), function (index, item) {
            AUIGrid.hideColumnByDataField("#" + strGridID, $(item).val());
        });
    }
}

function fnCloseColumnLayout(strGridID) {

    var GridColumnChangeChecked = false;
    var OriColumnLayout = fnLoadColumnLayout(strGridID, "fnGetDefaultColumnLayout()");
    var CurrentColumnLayout = AUIGrid.getColumnLayout("#" + strGridID);
    $.each(CurrentColumnLayout, function (index, item) {
        if (item.viewstatus === true) {
            var itemVisible = typeof(item.visible) === "undefined" ? true : item.visible;

            var oriItem = OriColumnLayout.find(e => e.dataField === item.dataField);
            if (oriItem) {
                var oriItemVisible = typeof (oriItem.visible) === "undefined" ? true : oriItem.visible;
                if (itemVisible !== oriItemVisible) {
                    GridColumnChangeChecked = true;
                    return false;
                }
            }
        }
    });

    $("#GridColumn").html("");

    if (GridColumnChangeChecked) {
        fnDefaultConfirm("항목 변경사항이 있습니다. 적용하시겠습니까?", "fnCloseColumnLayoutTrue", { GridID: strGridID }, "fnCloseColumnLayoutFalse", { GridID: strGridID });
    } else {
        $("#GRID_COLUMN_LAYER").hide();
    }
}

function fnCloseColumnLayoutTrue(objParam) {
    var strGridID = objParam.GridID;
    fnSaveColumnLayout("#" + strGridID, strGridID);
    $("#GRID_COLUMN_LAYER").hide();
}

function fnCloseColumnLayoutFalse(objParam) {
    var strGridID = objParam.GridID;
    var ColumnData = $("#GridColumn input[type=checkbox]:checked").length;
    var GridColumnChangeLen = $("#GridColumn input[type=checkbox]").length;
    var GridColumnChangeChecked = $("#GridColumn input[type=checkbox]:checked").length;

    fnGridColumnSetting();
    if (GridColumnChangeChecked > ColumnData) {
        for (var i = 1; i < GridColumnChangeLen; i++) {
            if (!$("#GridColumn input[type=checkbox]")[i].checked) {
                AUIGrid.hideColumnByDataField("#" + strGridID, $("#GridColumn input[type=checkbox]")[i].value);
            }
        }
    } else {
        for (var j = 0; j < ColumnData; j++) {
            AUIGrid.showColumnByDataField("#" + strGridID, $("#GridColumn input[type=checkbox]:checked")[j].value);
        }
    }
    $("#GRID_COLUMN_LAYER").hide();

}

//체크박스 체크시 그리드 항목 Show/Hide
function fnCheckboxChangeHandler(event, strGridID) {
    var target = event.target || event.srcElement;
    if (!target) return;

    var dataField = target.value;
    var checked = target.checked;

    if (checked) {
        AUIGrid.showColumnByDataField("#" + strGridID, dataField);
    } else {
        AUIGrid.hideColumnByDataField("#" + strGridID, dataField);
    }

    if ($("#GridColumn input[type=checkbox]:checked").length === $("#GridColumn input[type=checkbox]").length) {
        $("#AllGridColumnCheck").prop("checked", true);
    } else {
        $("#AllGridColumnCheck").prop("checked", false);
    }
};

//그리드 항목 저장
function fnSaveColumnCustomLayout(strGridID) {
    fnSaveColumnLayout("#" + strGridID, strGridID);
    $("#GRID_COLUMN_LAYER").hide();
    $("#GridColumn").html("");
}

//그리드 네비게이션 페이지 이동
function fnMoveToPage(goPage) {
    //이동할 페이지 세팅
    $("#PageNo").val(goPage);
    // rowCount 만큼 데이터 요청
    fnCallGridData(GridID);
}

//그리드 네비게이션 페이지 이동
function fnMoveToPagePeriod(goPage, intDay) {

    var dateTerm = fnGetDateTerm($("#DateFrom").val(), $("#DateTo").val());

    if (dateTerm > intDay - 1) {
        fnDefaultAlert("최대 " + intDay + "일까지 조회하실 수 있습니다.", "info");
        return false;
    }

    //이동할 페이지 세팅
    $("#PageNo").val(goPage);
    // rowCount 만큼 데이터 요청
    fnCallGridData(GridID);
}

//검색용 다이얼로그
function fnSearchDialog(id, type) {
    if (type == "open") {
        $("#" + id).show();
        $("#GridSearchText").focus();
    } else if (type == "close") {
        $("#" + id).hide();
    }
}

// 검색 버튼 클릭
function fnSearchClick() {
    var dataField = document.getElementById("GridSearchDataField").value;
    var term = document.getElementById("GridSearchText").value;

    var options = {
        direction: true, //document.getElementById("direction").checked, // 검색 방향  (true : 다음, false : 이전 검색)
        ChkCaseSensitive: document.getElementById("ChkCaseSensitive").checked, // 대소문자 구분 여부 (true : 대소문자 구별, false :  무시)
        wholeWord: false, // document.getElementById("wholeWord").checked, // 온전한 단어 여부
        wrapSearch: true // document.getElementById("wrapSearch").checked // 끝에서 되돌리기 여부
    };

    // 검색 실시
    //options 를 지정하지 않으면 기본값이 적용됨(기본값은 direction : true, wrapSearch : true)
    if (dataField == "ALL") {
        AUIGrid.searchAll(GridID, term, options);
    } else {
        AUIGrid.search(GridID, dataField, term, options);
    }
};

function fnGridSelectionChangeHandler(event) {

    var items = event.selectedItems;
    var val;
    var count = items.length;
    var sum = 0;
    var msg = "";

    if (count <= 1) {
        $("#GridDataInfo").text("셀 선택 : 0, 합계 : 0");
        return;
    }

    for (i = 0; i < count; i++) {
        val = String(items[i].value).replace(/,/gi, ""); // 컴마 모두 제거
        val = Number(val);
        //console.log(val);
        if (isNaN(val)) {
            continue;
        }
        sum += val;
    }

    msg = "셀 선택 : " + count + ", 합계 : " + fnMoneyComma(sum);

    $("#GridDataInfo").text(msg);
}

/* --------------------------------------
-- Util 함수
-------------------------------------- */
function fnGetToday() {
    var date = new Date();
    var year = date.getFullYear();
    var month = ("0" + (1 + date.getMonth())).slice(-2);
    var day = ("0" + date.getDate()).slice(-2);

    return year + month + day;
}

function fnGetDateToday(str) {
    var date = new Date();

    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();

    if (m < 10) {
        m = "0" + m;
    } else {
        m = m.toString();
    }

    if (d < 10) {
        d = "0" + d;
    } else {
        d = d.toString();
    }

    return y + str + m + str + d;
}

function fnGetDateFormat(date, delimiter) {

    var newDate = new Date();

    if (date != null) newDate = date;

    var yy = newDate.getFullYear();
    var mm = newDate.getMonth() + 1;
    if (mm < 10) mm = "0" + mm;

    var dd = newDate.getDate();
    if (dd < 10) dd = "0" + dd;

    if (delimiter == null) delimiter = "";
    return yy + delimiter + mm + delimiter + dd;
}

function fnGetStrDateFormat(ymd, delimiter) {
    var yy = ymd.substring(0, 4);
    var mm = ymd.substring(4, 6);
    var dd = ymd.substring(6, 8);
    if (delimiter == null) delimiter = "";
    return yy + delimiter + mm + delimiter + dd;
}

//날짜간의 간격 yyyy-mm-dd ~ yyyy-mm-dd
function fnGetDateTerm (sDate, eDate) {
    var sDateArray = sDate.split("-");
    var eDateArray = eDate.split("-");

    var sDateObj = new Date(sDateArray[0], Number(sDateArray[1]) - 1, sDateArray[2]);
    var eDateObj = new Date(eDateArray[0], Number(eDateArray[1]) - 1, eDateArray[2]);

    var betweenDay = (eDateObj.getTime() - sDateObj.getTime()) / 1000 / 60 / 60 / 24;

    return betweenDay;
}

//날짜 간에 존재하는 월 개수
function fnGetMonthTerm(sDateStr, eDateStr) {
    var sDate = new Date(sDateStr);
    var eDate = new Date(eDateStr);
    return eDate.getMonth() - sDate.getMonth() + (12 * (eDate.getFullYear() - sDate.getFullYear())) + 1;
}

function fnChangeDatePeriod(val, sid, eid) {
    //val => 1 금일, 2 익일, 3 전일, 4 금월, 5 전월, 6 금주
    var date = new Date();
    var yy = date.getFullYear();
    var mm = date.getMonth() + 1;
    var dd = date.getDate();
    var date_from = "";
    var date_to = "";

    if (val === "1") {
        date_from = fnGetDateFormat(date, "-");
        date_to = fnGetDateFormat(date, "-");
    } else if (val === "2") {
        date = new Date(yy, mm - 1, dd + 1);
        date_from = fnGetDateFormat(date, "-");
        date_to = fnGetDateFormat(date, "-");
    } else if (val === "3") {
        date = new Date(yy, mm - 1, dd - 1);
        date_from = fnGetDateFormat(date, "-");
        date_to = fnGetDateFormat(date, "-");
    } else if (val === "4") {
        date = new Date(yy, mm - 1, 1);
        date_from = fnGetDateFormat(date, "-");
        date = new Date(yy, mm, 0);
        date_to = fnGetDateFormat(date, "-");
    } else if (val === "5") {
        date = new Date(yy, mm - 2, 1);
        date_from = fnGetDateFormat(date, "-");
        date = new Date(yy, mm - 1, 0);
        date_to = fnGetDateFormat(date, "-");
    } else if (val === "6") {
        var weekday = date.getDay();
        date = new Date(yy, mm - 1, dd - weekday);
        date_from = fnGetDateFormat(date, "-");
        date = new Date(yy, mm - 1, dd + 6 - weekday);
        date_to = fnGetDateFormat(date, "-");
    }

    if (date_from !== "") {
        $("#" + sid).datepicker("setDate", date_from);
    }
    if (date_to !== "") {
        $("#" + eid).datepicker("setDate", date_to);
    }
}


//부가세 계산
function fnSetTax(obj, target, code, sum) {
    var tax = 0;
    var total = 0;
    try {
        tax = Math.floor(parseInt($(obj).val().replace(/,/gi, "")) * 0.1);
        total = Math.floor(parseInt($(obj).val().replace(/,/gi, "")) + tax);


        if (isNaN(tax)) {
            tax = "0";
            total = "0";
        }

        if (code != "1") {
            $("#" + target).val(0);
            $("#" + sum).val(0);
        } else {
            $("#" + target).val(comma(tax));
            $("#" + sum).val(comma(total));
        }

        $("#" + target).val(comma(tax));
        $("#" + sum).val(comma(total));

    } catch (e) {
    }
}

//부가세 입력에 따른 공급가 + 부가세 합계계산
function fnTaxInputTotal(obj, target, code, sumObj) {
    var supplyAmt = $("#" + sumObj).val();
    var total = 0;

    try {
        total = Math.floor(parseInt($(obj).val().replace(/,/gi, "")) + parseInt(supplyAmt.replace(/,/gi, "")));

        if (isNaN(total)) {
            total = "0";
        }

        if (code != "1") {
            $("#" + target).val(0);
        } else {
            $("#" + target).val(comma(total));
        }

        $("#" + target).val(comma(total));

    } catch (e) {
    }
}

function fnAjaxFailResult(XMLHttpRequest, textStatus, errorThrown) {
    console.log(XMLHttpRequest);
    console.log(textStatus);
    console.log(errorThrown);

    try {
        if (isBlock) {
            $.unblockUI();
        }

        if (XMLHttpRequest.status === 401) {
            var msg = "처리 중 오류가 발생하였습니다.";
            if (XMLHttpRequest.responseText != null) {
                var data = $.parseJSON(XMLHttpRequest.responseText);
                msg = data[0].ErrMsg;
            }
            fnDefaultAlert(msg, "warning", "parent.fnGoLogout()");
            return false;
        }

        if (XMLHttpRequest.responseText != null) {
            var data = $.parseJSON(XMLHttpRequest.responseText);
            fnDefaultAlert(data[0].ErrMsg);
        } else {
            fnDefaultAlert("처리 중 오류가 발생하였습니다.");
        }
    } catch (e) {
        fnDefaultAlert("처리 중 오류가 발생하였습니다.(" + errorThrown + ")");
    }
}

function fnGridErrorResult(XMLHttpRequest, textStatus, errorThrown) {
    console.log(XMLHttpRequest);
    console.log(textStatus);
    console.log(errorThrown);

    try {
        if (XMLHttpRequest.responseText != null) {
            var data = $.parseJSON(XMLHttpRequest.responseText);

            fnDefaultAlert(data[0].ErrMsg);
        } else {
            fnDefaultAlert("처리 중 오류가 발생하였습니다.");
        }
    } catch (e) {
        fnDefaultAlert("처리 중 오류가 발생하였습니다.(" + errorThrown + ")");
    }

    // 로더 제거
    AUIGrid.removeAjaxLoader(GridID);
    return false;
}

String.prototype.string = function (len) { var s = '', i = 0; while (i++ < len) { s += this; } return s; };
String.prototype.zf = function (len) { return "0".string(len - this.length) + this; };
Number.prototype.zf = function (len) { return this.toString().zf(len); };

Date.prototype.withoutTime = function () {
    var d = new Date(this);
    d.setHours(0, 0, 0, 0);
    return d;
};

Date.prototype.Dateformat = function (f) {
    if (!this.valueOf()) return " ";
    var weekName = ["일", "월", "화", "수", "목", "금", "토"];
    var d = this;
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function ($1) {
        switch ($1) {
        case "yyyy": return d.getFullYear();
        case "yy": return (d.getFullYear() % 1000).zf(2);
        case "MM": return (d.getMonth() + 1).zf(2);
        case "dd": return d.getDate().zf(2);
        case "E": return weekName[d.getDay()];
        case "HH": return d.getHours().zf(2);
        case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
        case "mm": return d.getMinutes().zf(2);
        case "ss": return d.getSeconds().zf(2);
        case "a/p": return d.getHours() < 12 ? "오전" : "오후";
        default: return $1;
        }
    });
};

Date.prototype.addMonths = function (m) {
    var d = new Date(this);
    var years = Math.floor(m / 12);
    var months = m - (years * 12);
    if (years) d.setFullYear(d.getFullYear() + years);
    if (months) d.setMonth(d.getMonth() + months);
    return d;
};

//폼을 json 배열로 반환
$.fn.serializeObject = function () {
    var obj = null;
    try {
        if (this[0].tagName && this[0].tagName.toUpperCase() === "FORM") {
            var arr = this.serializeArray();
            if (arr) {
                obj = {};
                $.each(arr, function () {
                    if (this.name.indexOf("__") < 0) {
                        obj[this.name] = this.value;
                    }
                });
            }//if ( arr ) {
        }
    } catch (e) {
        console.log(e.message);
    }

    return obj;
};

//json 배열을 받아서 폼에 hidden객체 추가
$.fn.addHidden = function (objArray) {
    var form = $(this);

    $.each(objArray,
        function (key, value) {
            var input = $("<input>").attr("type", "hidden").attr("name", key).val(value);
            $(form).append($(input));
        });

    return $(form);
};


/**********************/
//주소검색
//팝업형태
function fnOpenAddress(type) {

    var strQueryStr = "";
    if ($("#" + type + "Search").length > 0) {
        strQueryStr = $("#" + type + "Search").val();
    }

    var objOpenParam = {
        q: strQueryStr
    };

    new daum.Postcode({
        oncomplete: function (data) {
            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ""; // 주소 변수
            var extraAddr = ""; // 참고항목 변수
            var post = data.zonecode;
            var sido = "";
            var sigungu = "";
            var dong = "";
            
            addr = data.sido;
            addr += data.sigungu == "" ? "" : (" " + data.sigungu);
            addr += data.bname1 == "" ? "" : (" " + data.bname1);

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if (data.userSelectedType === "R") {
                addr += data.roadname == "" ? "" : (" " + data.roadname);
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }

                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== "") {
                    extraAddr += (extraAddr !== "" ? ", " + data.buildingName : data.buildingName);
                }

                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraAddr !== "") {
                    extraAddr = " (" + extraAddr + ")";
                }

                extraAddr = data.roadAddress.replace(addr + " ", "") + extraAddr;

            } else {
                addr += data.bname == "" ? "" : (" " + data.bname);
                extraAddr = data.jibunAddress.replace(addr + " ", "") + extraAddr;
            }

            sido = fnGetShortSido(data.sido);
            sigungu = data.sigungu;
            dong = data.bname1;
            if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                dong += dong === "" ? data.bname2 : (" " + data.bname2);
            }

            fnSetAddress(type, post, addr, extraAddr, sido, sigungu, dong);
        }
    }).open(objOpenParam);
}

function fnSetAddress(type, post, addr, addrDtl, sido, sigungu, dong) {
    var strFullAddr = "";
    if ($("#" + type + "Post").length > 0) {
        $("#" + type + "Post").val(post);
    }

    $("#" + type + "Addr").val(addr);
    $("#" + type + "AddrDtl").val(addrDtl);
    $("#" + type + "AddrDtl").focus();

    if ($("#" + type + "Sido").length > 0) {
        $("#" + type + "Sido").val(sido);
    }

    if ($("#" + type + "Sigungu").length > 0) {
        $("#" + type + "Sigungu").val(sigungu);
    }

    if ($("#" + type + "Dong").length > 0) {
        $("#" + type + "Dong").val(dong);
    }

    strFullAddr = sido;
    if (sigungu != "") {
        strFullAddr += " " + sigungu;
    }
    if (dong != "") {
        strFullAddr += " " + dong;
    }

    if ($("#" + type + "FullAddr").length > 0) {
        $("#" + type + "FullAddr").val(strFullAddr);
    }

    if ($("#" + type + "Search").length > 0) {
        $("#" + type + "Search").val("");
    }
}


//레이어형태
function fnOpenAddressLayer(type) {

    if ($("#DivDaumAddrWrap").length == 0) {
        $('body').append(
            "<div id=\"DivDaumAddrWrap\"><div id=\"DivDaumAddr\"><img src=\"//t1.daumcdn.net/postcode/resource/images/close.png\" id=\"BtnDaumAddrClose\" alt=\"닫기 버튼\"></div></div>");
    }

    if ($("#BtnDaumAddrClose").length > 0) {
        $("#BtnDaumAddrClose").off().on("click", function () {
            fnCloseDaumPostcodeLayer();
            return false;
        });
    }

    fnOpenDaumPostcodeLayer(type);
}

//주소 팝업 열기
function fnOpenDaumPostcodeLayer(type) {

    var strQueryStr = "";
    if ($("#" + type + "Search").length > 0) {
        strQueryStr = $("#" + type + "Search").val();
    }

    var objOpenParam = {
        q: strQueryStr
    };

    var obj = document.getElementById("DivDaumAddr");

    new daum.Postcode({
        oncomplete: function (data) {
            // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ""; // 주소 변수
            var extraAddr = ""; // 참고항목 변수
            var post = data.zonecode;
            var sido = "";
            var sigungu = "";
            var dong = "";

            addr = data.sido;
            addr += data.sigungu == "" ? "" : (" " + data.sigungu);
            addr += data.bname1 == "" ? "" : (" " + data.bname1);

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if (data.userSelectedType === "R") {
                addr += data.roadname == "" ? "" : (" " + data.roadname);
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }

                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== "") {
                    extraAddr += (extraAddr !== "" ? ", " + data.buildingName : data.buildingName);
                }

                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraAddr !== "") {
                    extraAddr = " (" + extraAddr + ")";
                }

                extraAddr = data.roadAddress.replace(addr + " ", "") + extraAddr;

            } else {
                addr += data.bname == "" ? "" : (" " + data.bname);
                extraAddr = data.jibunAddress.replace(addr + " ", "") + extraAddr;
            }

            sido = fnGetShortSido(data.sido);
            sigungu = data.sigungu;
            dong = data.bname1;
            if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                dong += dong === "" ? data.bname2 : (" " + data.bname2);
            }

            fnSetAddressLayer(type, post, addr, extraAddr, sido, sigungu, dong);

            // iframe을 넣은 element를 안보이게 한다.
            // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)                
            $("#DivDaumAddrWrap").hide();
        },
        width: "100%",
        height: "100%",
        maxSuggestItems: 5
    }).embed(obj, objOpenParam);

    fnInitDaumAddrLayerPositionLayer(obj);
    // iframe을 넣은 element를 보이게 한다.
    $("#DivDaumAddrWrap").show();
}

function fnSetAddressLayer(type, post, addr, addrDtl, sido, sigungu, dong) {
    var strFullAddr = "";
    if ($("#" + type + "Post").length > 0) {
        $("#" + type + "Post").val(post);
    }

    $("#" + type + "Addr").val(addr);
    $("#" + type + "AddrDtl").val(addrDtl);
    $("#" + type + "AddrDtl").focus();

    if ($("#" + type + "Sido").length > 0) {
        $("#" + type + "Sido").val(sido);
    }

    if ($("#" + type + "Sigungu").length > 0) {
        $("#" + type + "Sigungu").val(sigungu);
    }

    if ($("#" + type + "Dong").length > 0) {
        $("#" + type + "Dong").val(dong);
    }

    strFullAddr = sido;
    if (sigungu != "") {
        strFullAddr += " " + sigungu;
    }
    if (dong != "") {
        strFullAddr += " " + dong;
    }

    if ($("#" + type + "FullAddr").length > 0) {
        $("#" + type + "FullAddr").val(strFullAddr);
    }

    if ($("#" + type + "Search").length > 0) {
        $("#" + type + "Search").val("");
    }

    fnCloseDaumPostcodeLayer();
}

//주소 팝업 닫기
function fnCloseDaumPostcodeLayer() {
    $("#DivDaumAddrWrap").hide();
}

//주소 팝업 위치 저장
function fnInitDaumAddrLayerPositionLayer(obj) {
    var width = 300; //우편번호서비스가 들어갈 element의 width
    var height = 500; //우편번호서비스가 들어갈 element의 height
    var borderWidth = 3; //샘플에서 사용하는 border의 두께

    // 위에서 선언한 값들을 실제 element에 넣는다.
    obj.style.width = width + 'px';
    obj.style.height = height + 'px';
    obj.style.border = borderWidth + 'px solid';
    // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
    obj.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width) / 2 - borderWidth) + 'px';
    obj.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height) / 2 - borderWidth) + 'px';
}
/**********************/

/** 검색 체크 세팅 시작 **/
$(document).ready(function () {
    $.each($(".DivSearchConditions"), function(index, objItem) {
        fnGetSearchCondition($(objItem).attr("id"));
        if ($(objItem).children("a.CloseSearchConditions").length === 0) {
            $(objItem).prepend("<a href=\"#\" class=\"CloseSearchConditions\" title=\"닫기\"></a>");
        }
        if ($(objItem).children("a.SaveSearchConditions").length === 0) {
            $(objItem).prepend("<a href=\"#\" class=\"SaveSearchConditions\" title=\"저장\"></a>");
        }
    });

    //검색 체크 레이어 열기
    $(".SearchConditions").bind("click", function (e) {
        e.preventDefault();
        $(".DivSearchConditions").hide();

        var id = $(this).attr("id");
        if (id.length === 0) {
            return;
        }

        id = id.substring(4, id.length);
        $("#Div" + id).css("top", $(this).position().top + $(this).height() + 7);
        $("#Div" + id).css("left", $(this).position().left);
        $("#Div" + id).show();
    });

    //검색 체크 레이어 - 체크 박스
    $(".DivSearchConditions input[type='checkbox']").bind("change", function (e) {
        e.preventDefault();
        var id = $(this).attr("id");
        var chkAllID = "";
        id = id.substring(0, id.lastIndexOf("_"));
        chkAllID = $("label[for^='" + id + "'] span.ChkAll").parent("label").attr("for");
        if ($(this).attr("id") !== chkAllID) {
            if ($("input[type='checkbox'][id^='" + id + "']:checked").filter(function () { return $(this).attr("id") !== chkAllID }).length + 1 === $("input[type='checkbox'][id^='" + id + "']").length) {
                $("input[type='checkbox'][id='" + chkAllID + "']").prop("checked", true);
            } else {
                $("input[type='checkbox'][id='" + chkAllID + "']").prop("checked", false);
            }
        } else {
            $("input[type='checkbox'][id^='" + id + "']").prop("checked", $(this).is(":checked"));
        }

        SetChkSearchConditions(id);
    });

    //검색 체크 레이어 - 닫기
    $(".CloseSearchConditions").bind("click", function (e) {
        e.preventDefault();
        $(this).parent().hide();
    });

    //검색 체크 레이어 - 저장
    $(".SaveSearchConditions").bind("click", function (e) {
        e.preventDefault();
        fnSetSaveSearchCondition($(this));
    });

    $(document).on("click", function (e) {
        $.each($(".DivSearchConditions"), function(index, item) {
            if ($(item).has($(e.target)).length < 1 && !$(e.target).hasClass("SearchConditions")) {
                $(item).hide();
            }
        });
    });
});

function fnGetSearchCondition(strID) {
    var intCodeType = 0;
    if (strID.indexOf("OrderLocation") !== -1) {
        intCodeType = 1;
    } else if (strID.indexOf("OrderItem") !== -1) {
        intCodeType = 2;
    } else if (strID.indexOf("OrderStatus") !== -1) {
        intCodeType = 3;
    } else if (strID.indexOf("DeliveryLocation") !== -1) {
        intCodeType = 4;
    } else if (strID.indexOf("CargopassStatus") !== -1) {
        intCodeType = 999; //아무처리 안함
    }

    var strHandlerUrl = "/Lib/SearchConditionHandler.ashx";
    var strCallBackFunc = "fnGetSearchConditionSuccResult";
    var strFailCallBackFunc = "fnGetSearchConditionFailResult";
    var objParam = {
        CallType: "SearchConditionGet",
        CodeType: intCodeType,
        CodeID: strID
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnGetSearchConditionSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            if (typeof objRes[0].Codes !== "string" || typeof objRes[0].CodeID !== "string") {
                return false;
            }

            if (objRes[0].Codes === "") {
                return false;
            }

            var arrCode = objRes[0].Codes.split(",");
            var strUlID = "";
            if (arrCode.length > 0) {
                for (var i = 0; i < arrCode.length; i++) {
                    $.each($("#" + objRes[0].CodeID + " input[type='checkbox']"), function (index, item) {
                        if ($(item).val() == arrCode[i]) {
                            $(item).prop("checked", true);
                            strUlID = $(item).parent("li").parent("ul").attr("id");
                        }
                    });
                }

                if ($("#" + objRes[0].CodeID + " input[type='checkbox']").length - 1 === $("#" + objRes[0].CodeID + " input[type='checkbox']:checked").length) {
                    $("#" + objRes[0].CodeID + " input[type='checkbox']").prop("checked", true);
                }

                SetChkSearchConditions(strUlID);
            }

            return false;
        } else {
            fnGetSearchConditionFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnGetSearchConditionFailResult();
        return false;
    }
}

function fnGetSearchConditionFailResult(strMsg) {
    strMsg = typeof strMsg === "string" ? strMsg : "";
    fnDefaultAlert("일시적인 오류가 발생했습니다." + (strMsg === "" ? "" : ("(" + strMsg + ")")), "warning");
    return false;
}

function fnSetSaveSearchCondition(objSearch) {
    var strID = $(objSearch).parent().attr("id");
    var intCodeType = 0;
    var strCodes = "";
    var arrCodes = [];
    if (strID.indexOf("OrderLocation") !== -1) {
        intCodeType = 1;
    } else if (strID.indexOf("OrderItem") !== -1) {
        intCodeType = 2;
    } else if (strID.indexOf("OrderStatus") !== -1) {
        intCodeType = 3;
    } else if (strID.indexOf("DeliveryLocation") !== -1) {
        intCodeType = 4;
    }

    $.each($("#" + strID + " input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() !== "") {
            arrCodes.push($(el).val());
        }
    });

    if (intCodeType === 0) {
        return false;
    }

    strCodes = arrCodes.join(",");

    var strHandlerUrl = "/Lib/SearchConditionHandler.ashx";
    var strCallBackFunc = "fnSetSaveSearchConditionSuccResult";
    var strFailCallBackFunc = "fnSetSaveSearchConditionFailResult";
    var objParam = {
        CallType: "SearchConditionUpdate",
        CodeType: intCodeType,
        Codes: strCodes
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnSetSaveSearchConditionSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("검색조건이 저장되었습니다.", "info");
            return false;
        } else {
            fnSetSaveSearchConditionFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetSaveSearchConditionFailResult();
        return false;
    }
}

function fnSetSaveSearchConditionFailResult(strMsg) {
    strMsg = typeof strMsg === "string" ? strMsg : "";
    fnDefaultAlert("일시적인 오류가 발생했습니다." + (strMsg === "" ? "" : ("(" + strMsg + ")")), "warning");
    return false;
}

//검색 체크 레이어 - 텍스트 세팅
function SetChkSearchConditions(id) {
    var resultTxt = "";
    $("input[type='checkbox'][id^='" + id + "']:checked").each(function (index, item) {
        if ($(item).val() != "") {
            var labelTxt = $("label[for='" + $(item).attr("id") + "']").text();
            if (resultTxt == "") {
                resultTxt = labelTxt;
            } else {
                resultTxt += "," + labelTxt;
            }
        }
    });

    $("#View" + id).val(resultTxt);
}
/** 검색 체크 세팅 끝 **/

/** 일자 선택 **/
$(document).ready(function () {
    if ($("#DateChoice").length > 0) {
        $("#DateChoice").on("change",
            function() {
                fnChangeDatePeriod($(this).val(), "DateFrom", "DateTo");
            });
    }
});
/** 일자 선택 **/


//금액 콤마 붙이기
function fnMoneyComma(str) {
    str = String(str);
    var chkMinus = false;
    if (str.indexOf("-") !== -1) {
        str = str.replace(/-/gi, "");
        chkMinus = true;
    }

    if (str.indexOf(",") !== -1) {
        str = str.replace(/,/gi, "");
    }
    str = (chkMinus ? "-" : "") +  str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    return str;
}

function fnCalcTax(strSupplyAmt, strTaxAmtID, strTaxKindID) {
    var strTaxKind = $("#" + strTaxKindID).val();
    var strTaxAmt = 0;
    if (strSupplyAmt.indexOf(",") !== -1) {
        strSupplyAmt = strSupplyAmt.replace(/,/gi, "");
    }

    if (strSupplyAmt === "") {
        $("#" + strTaxAmtID).val("");
        return;
    }

    if (strSupplyAmt === "0") {
        $("#" + strTaxAmtID).val("0");
        return;
    }

    //과세구분 (1:과세, 2:면세, 3:간이, 4:간이과세, 5:영세)
    if (strTaxKind === "2" || strTaxKind === "3" || strTaxKind === "5") {
        $("#" + strTaxAmtID).val("0");
        return;
    }

    try {
        strTaxAmt = Math.floor(parseInt(strSupplyAmt) * 0.1);

        if (isNaN(strTaxAmt)) {
            strTaxAmt = 0;
        }

    } catch (e) {
        strTaxAmt = 0;
    }

    $("#" + strTaxAmtID).val(fnMoneyComma(strTaxAmt.toString()));
}

/*시간 포맷 EX) 1000 --> 10:00*/
function fnGetHMFormat(strHM) {
    var strHmFormat = "";
    if (strHM != "" && typeof strHM != "undefined") {
        if (strHM.length === 4) {
            strHmFormat = strHM.substr(0, 2) + ":" + strHM.substr(2, 3);
        } else {
            strHmFormat = strHM;
        }
    }
    return strHmFormat;
}

function fnGetFullSido(strSido) {
    var strRetSido = "";
    switch (strSido) { // 1번
    case "서울":
        strRetSido = "서울특별시";
        break;
    case "부산":
        strRetSido = "부산광역시";
        break;
    case "인천":
        strRetSido = "인천광역시";
        break;
    case "대구":
        strRetSido = "대구광역시";
        break;
    case "대전":
        strRetSido = "대전광역시";
        break;
    case "광주":
        strRetSido = "광주광역시";
        break;
    case "울산":
        strRetSido = "울산광역시";
        break;
    case "세종":
        strRetSido = "세종특별자치시";
        break;
    case "제주":
        strRetSido = "제주특별자치도";
        break;
    case "경기":
        strRetSido = "경기도";
        break;
    case "강원":
        strRetSido = "강원특별자치도";
        break;
    case "충북":
        strRetSido = "충청북도";
        break;
    case "충남":
        strRetSido = "충청남도";
        break;
    case "전북":
        strRetSido = "전북특별자치도";
        break;
    case "전남":
        strRetSido = "전라남도";
        break;
    case "경북":
        strRetSido = "경상북도";
        break;
    case "경남":
        strRetSido = "경상남도";
        break;
    default:
        strRetSido = strSido;
        break;
    }

    return strRetSido;
}

function fnGetShortSido(strSido) {
    var strRetSido = "";
    switch (strSido) { // 1번
    case "서울특별시":
        strRetSido = "서울";
        break;
    case "부산광역시":
        strRetSido = "부산";
        break;
    case "인천광역시":
        strRetSido = "인천";
        break;
    case "대구광역시":
        strRetSido = "대구";
        break;
    case "대전광역시":
        strRetSido = "대전";
        break;
    case "광주광역시":
        strRetSido = "광주";
        break;
    case "울산광역시":
        strRetSido = "울산";
        break;
    case "세종특별자치시":
        strRetSido = "세종";
        break;
    case "제주특별자치도":
        strRetSido = "제주";
        break;
    case "경기도":
        strRetSido = "경기";
        break;
    case "강원특별자치도":
        strRetSido = "강원";
        break;
    case "충청북도":
        strRetSido = "충북";
        break;
    case "충청남도":
        strRetSido = "충남";
        break;
    case "전북특별자치도":
        strRetSido = "전북";
        break;
    case "전라남도":
        strRetSido = "전남";
        break;
    case "경상북도":
        strRetSido = "경북";
        break;
    case "경상남도":
        strRetSido = "경남";
        break;
    default:
        strRetSido = strSido;
        break;
    }

    return strRetSido;
}

function fnMakeCellNo(strCellNo) {
    if (typeof strCellNo !== "string"){
        return strCellNo;
    }

    if (strCellNo === "") {
        return strCellNo;
    }

    strCellNo = strCellNo.replace(/-/gi, "");

    if (!fnChkNum(strCellNo)) {
        return strCellNo;
    }

    strCellNo = strCellNo.replace(/ /gi, "");
    
    var arrCell = ["010", "011", "016", "017", "018", "019"];
    var arrTel = ["02", "031", "032", "033", "041", "042", "043", "044", "051", "052", "053", "054", "055", "061", "062", "063", "064", "070"];
    var strRetCellNo = "";

    $.each(arrCell, function (index, item) {
        if (strCellNo.indexOf(item) === 0) {
            if (strCellNo.length === 10) {
                strRetCellNo = item + "-" + strCellNo.substr(3, 3) + "-" + strCellNo.substr(6);
                return false;
            } else if (strCellNo.length === 11) {
                strRetCellNo = item + "-" + strCellNo.substr(3, 4) + "-" + strCellNo.substr(7);
                return false;
            } else {
                strRetCellNo = strCellNo;
                return false;
            }
        }
    });

    if (strRetCellNo !== "") {
        return strRetCellNo;
    }

    $.each(arrTel, function (index, item) {
        if (strCellNo.indexOf(item) === 0) {
            if (item.length === 2) {
                if (strCellNo.length === 9) {
                    strRetCellNo = item + "-" + strCellNo.substr(2, 3) + "-" + strCellNo.substr(5);
                    return false;
                } else if (strCellNo.length === 10) {
                    strRetCellNo = item + "-" + strCellNo.substr(2, 4) + "-" + strCellNo.substr(6);
                    return false;
                } else {
                    strRetCellNo = strCellNo;
                    return false;
                }
            } else {
                if (strCellNo.length === 10) {
                    strRetCellNo = item + "-" + strCellNo.substr(3, 3) + "-" + strCellNo.substr(6);
                    return false;
                } else if (strCellNo.length === 11) {
                    strRetCellNo = item + "-" + strCellNo.substr(3, 4) + "-" + strCellNo.substr(7);
                    return false;
                } else {
                    strRetCellNo = strCellNo;
                    return false;
                }
            }
        }
    });

    if (strRetCellNo !== "") {
        return strRetCellNo;
    }

    if (strCellNo.length === 8) {
        strCellNo = strCellNo.substr(0, 4) + "-" + strCellNo.substr(4);
    }

    return strCellNo;
}

function fnChkNum(s) {
    s += ""; // 문자열로 변환
    s = s.replace(/^\s*|\s*$/g, ""); // 좌우 공백 제거
    if (s === "" || isNaN(s)) return false;
    return true;
}

//반각 문자를 전각 문자로 변환
function fnToFullChar(strChar) {
    var strFullChar = ""; //컨버트된 문자
    var c = strChar.charCodeAt(0);

    if (32 <= c && c <= 126) { //전각으로 변환될수 있는 문자의 범위
        if (c === 32) { //스페이스인경우 ascii 코드 32
            strFullChar = "　";
        } else {
            strFullChar = unescape("%u" + fnDecToHex(c + 65248));
        }
    } else {
        strFullChar = strChar;
    }

    return strFullChar;
}

// 10진수를 16진수로 변환
function fnDecToHex(intDec) {

    var arrHex = new Array();
    var intSerial = 0;

    while (intDec > 15) {
        var intH = intDec % 16;          //나머지
        intDec = parseInt(intDec / 16); //몫
        arrHex[intSerial++] = (intH > 9 ? String.fromCharCode(intH + 55) : intH); //16진수코드변환
    }

    //마지막은 몫의 값을 가짐
    arrHex[intSerial++] = (intDec > 9 ? String.fromCharCode(intDec + 55) : intDec); //16진수코드변환

    //몫,나머지,나머지
    var strRetValue = "";
    for (var i = arrHex.length; i > 0; i--) {
        strRetValue += arrHex[i - 1];
    }

    return strRetValue;
}

//반각 문자열을 전각 문자열로 변환
function fnToFullString(strConvert) {
    var strResult = "";
    strConvert = strConvert + "";

    if (strConvert != "") {
        for (var i = 0; i < strConvert.length; i++) {
            strResult += fnToFullChar(strConvert.charAt(i));
        }
    }
    return strResult;
}

function fnGetScrollBarWidth() {
    var el = document.createElement("div");
    el.style.cssText = "overflow:scroll; visibility:hidden; position:absolute;";
    document.body.appendChild(el);
    var width = el.offsetWidth - el.clientWidth;
    el.remove();

    if (isNaN(width)) {
        width = 17;
    }

    return width;
}

//오더상세 열기
function fnCommonOpenOrder(objItem, strParam = "") {
    var strOrderItemCode = (typeof objItem.OrderItemCode === "undefined" || objItem.OrderItemCode === null) ? "" : objItem.OrderItemCode;
    var strOrderNo = (typeof objItem.OrderNo === "undefined" || objItem.OrderNo === null) ? "" : objItem.OrderNo;
    var strTitle = "";
    var strUrl = "";
    strParam = (typeof strParam === "undefined" || strParam === null) ? "" : strParam;
    if (strParam !== "") {
        strParam = (strOrderNo === "" ? "?" : "&") + strParam;
    }

    if (strOrderItemCode === "") {
        return false;
    }

    if (strOrderItemCode === "OA007") {
        strTitle = "내수오더" + (Math.floor(Math.random() * 1000) + 1);
        strUrl = "/TMS/Domestic/DomesticIns" + (strOrderNo === "" ? "" : ("?OrderNo=" + strOrderNo)) + strParam;
        window.open(strUrl, strTitle, "width=1650px, height=700px, scrollbars=Yes");
        return false;
    } else if (strOrderItemCode === "OA001" || strOrderItemCode === "OA002" || strOrderItemCode === "OA003" || strOrderItemCode === "OA004" || strOrderItemCode === "OA008" || strOrderItemCode === "OA009") {
        strTitle = "수출입오더" + (Math.floor(Math.random() * 1000) + 1);
        strUrl = "/TMS/Inout/InoutIns" + (strOrderNo === "" ? "" : ("?OrderNo=" + strOrderNo)) + strParam;
        window.open(strUrl, strTitle, "width=1650px, height=750px, scrollbars=Yes");
        return false;
    } else if (strOrderItemCode === "OA005" || strOrderItemCode === "OA006") {
        strTitle = "컨테이너오더" + (Math.floor(Math.random() * 1000) + 1);
        strUrl = "/TMS/Container/ContainerIns" + (strOrderNo === "" ? "" : ("?OrderNo=" + strOrderNo)) + strParam;
        window.open(strUrl, strTitle, "width=1650px, height=700px, scrollbars=Yes");
        return false;
    } else if (strOrderItemCode === "OA010") {
        strTitle = "배송오더" + (Math.floor(Math.random() * 1000) + 1);
        strUrl = "/TMS/Wnd/WmsIns" + (strOrderNo === "" ? "" : ("?OrderNo=" + strOrderNo)) + strParam;
        window.open(strUrl, strTitle, "width=1650px, height=700px, scrollbars=Yes");
        return false;
    } else {
        return false;
    }
}

function fnMakeCorpNo(strCorpNo) {
    if (typeof strCorpNo !== "string") {
        return strCorpNo;
    }

    if (strCorpNo === "") {
        return strCorpNo;
    }

    strCorpNo = strCorpNo.replace(/[^0-9]/g, "");

    if (strCorpNo.length !== 10) {
        return strCorpNo;
    }

    strCorpNo = strCorpNo.substr(0, 3) + "-" + strCorpNo.substr(3, 2) + "-" + strCorpNo.substr(5, 5);
    return strCorpNo;
}

String.format = function () {
    var s = arguments[0];
    for (var i = 0; i < arguments.length - 1; i += 1) {
        var reg = new RegExp('\\{' + i + '\\}', 'gm');
        s = s.replace(reg, arguments[i + 1]);
    }
    return s;
};


//콜매니저 관련
/**************************/
//관리자 연동 연락처 표시
/**************************/
var strAdminPhoneListFormID = "";
var strAdminPhonestrRcvTelNo = "";
var strAdminPhonestrPrefix = "";
var isAdminPhonestrUseKT = true;

function fnSetCMAdminPhoneList(strFormID, strRcvTelNo, strPrefix, isUseKT) {
    if (typeof strRcvTelNo == "undefined" || strFormID == "") {
        return false;
    }
    strRcvTelNo = typeof strRcvTelNo == "undefined" ? "" : strRcvTelNo
    strPrefix = typeof strPrefix == "undefined" ? "" : strPrefix;
    isUseKT = typeof isUseKT == "undefined" ? true : isUseKT;

    strAdminPhoneListFormID = strFormID;
    strAdminPhonestrRcvTelNo = strRcvTelNo;
    strAdminPhonestrPrefix = strPrefix;
    isAdminPhonestrUseKT = isUseKT;

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnSetCMAdminPhoneListSuccResult";
    var strFailCallBackFunc = "fnSetCMAdminPhoneListFailResult";
    var objParam = {
        CallType: "CMAdminPhoneList",
        PageSize: 10,
        PageNo: 1
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnSetCMAdminPhoneListSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                fnSetCMAdminPhoneListFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode) {
            if (objRes[0].result.ErrorCode != 0) {
                fnSetCMAdminPhoneListFailResult();
                return false;
            }
        }

        if (strAdminPhoneListFormID != "") {
            var strHtml = "";
            $.each(objRes[0].data.list, function (index, item) {
                if (isAdminPhonestrUseKT || (!isAdminPhonestrUseKT && item.ChannelType.toUpperCase() != "KT")) {
                    strHtml += "<option value=\"" + item.PhoneNo + "\" " + (item.MainUseFlag == "Y" ? "selected" : "") + ">" + strAdminPhonestrPrefix + fnMakeCellNo(item.PhoneNo) + "</option>";
                }
            });

            $("#" + strAdminPhoneListFormID).append(strHtml);

            if (strAdminPhonestrRcvTelNo != "") {
                $("#" + strAdminPhoneListFormID + " option").filter(function () { return $(this).val() === strAdminPhonestrRcvTelNo; }).prop("selected", true);
            }

            if ($("#" + strAdminPhoneListFormID + " option").length > 0) {
                $("#" + strAdminPhoneListFormID).show();
            } else {
                $("#" + strAdminPhoneListFormID).hide();
            }
        }
    } else {
        fnSetCMAdminPhoneListFailResult();
        return false;
    }
}

function fnSetCMAdminPhoneListFailResult() {
    $("#" + strAdminPhoneListFormID).hide();
    //fnDefaultAlert("연락처 조회 실패", "warning");
    return false;
}
/**************************/

// 휴대폰 여부 체크
function isMobilePhone(number) {
    // 휴대폰 번호 정규식 (국내용)
    const regex = /^01[016789]-?\d{3,4}-?\d{4}$/;
    return regex.test(number);
}

/*****************/
// 연락처 팝업
/*****************/
//팝업 열기 (그리드)
function fnOpenConnectCallGrid(objEvent, arrPhones, strRcvTelNo, strCenterCode, strOrderNo, strSmsType) {
    objEvent.stopPropagation();

    var strHtml = "";
    strRcvTelNo = typeof strRcvTelNo == "undefined" ? "" : strRcvTelNo;
    if (strRcvTelNo == "") {
        if ($("#CMAdminPhoneList").length > 0) {
            strRcvTelNo = $("#CMAdminPhoneList").val();
        } else if ($("#CMAdminPhoneList", parent.document).length > 0) {
            strRcvTelNo = $("#CMAdminPhoneList", parent.document).val();
        } else if ($("#CMAdminPhoneList", opener.document).length > 0) {
            strRcvTelNo = $("#CMAdminPhoneList", opener.document).val();
        }
    }

    strCenterCode = typeof strCenterCode == "undefined" ? "" : strCenterCode;
    strOrderNo = typeof strOrderNo == "undefined" ? "" : strOrderNo;
    strSmsType = typeof strSmsType == "undefined" ? "1" : strSmsType;
    strHtml = fnGetConnectCallHtml(arrPhones, strCenterCode, strRcvTelNo, strOrderNo, strOrderNo, strSmsType);

    if ($("#DivConnectCall").length == 0) {
        strHtml = "<div id=\"DivConnectCall\" class=\"tooltip\">" + strHtml + "</div>";
        $("body").append(strHtml);
    } else {
        $("#DivConnectCall").html(strHtml);
    }

    var intLeft = objEvent.clientX;
    var intTop = objEvent.clientY + 7;
    if (intTop + $("#DivConnectCall").height() + 10 > window.innerHeight) {
        intTop -= (intTop + $("#DivConnectCall").height() + 10 - window.innerHeight);
    }
    //window.innerWidth

    $("#DivConnectCall").css("left", intLeft + "px");
    $("#DivConnectCall").css("top", intTop + "px");
    $("#DivConnectCall").show();
}

//팝업 열기 (일반)
function fnOpenConnectCall(obj, arrPhones, strRcvTelNo, strCenterCode, strOrderNo, strSmsType) {
    var strHtml = "";
    var objPos = $(obj).offset(); // 페이지 기준 위치
    strRcvTelNo = typeof strRcvTelNo == "undefined" ? "" : strRcvTelNo;
    if (strRcvTelNo == "") {
        if ($("#CMAdminPhoneList").length > 0) {
            strRcvTelNo = $("#CMAdminPhoneList").val();
        } else if ($("#CMAdminPhoneList", parent.document).length > 0) {
            strRcvTelNo = $("#CMAdminPhoneList", parent.document).val();
        } else if ($("#CMAdminPhoneList", opener.document).length > 0) {
            strRcvTelNo = $("#CMAdminPhoneList", opener.document).val();
        }
    }

    strCenterCode = typeof strCenterCode == "undefined" ? "" : strCenterCode;
    strOrderNo = typeof strOrderNo == "undefined" ? "" : strOrderNo;
    strSmsType = typeof strSmsType == "undefined" ? "1" : strSmsType;
    strHtml = fnGetConnectCallHtml(arrPhones, strCenterCode, strRcvTelNo, strOrderNo, strOrderNo, strSmsType);

    if ($("#DivConnectCall").length == 0) {
        strHtml = "<div id=\"DivConnectCall\" class=\"tooltip\">" + strHtml + "</div>";
        $("body").append(strHtml);
    } else {
        $("#DivConnectCall").html(strHtml);
    }

    var intLeft = objPos.left + ($("#DivConnectCall").width() / 2);
    var intTop = objPos.top + $(obj).height();
    if (intTop + $("#DivConnectCall").height() + 10 > window.innerHeight) {
        intTop -= (intTop + $("#DivConnectCall").height() + 10 - window.innerHeight);
    }
    //window.innerWidth

    $("#DivConnectCall").css("left", intLeft + "px");
    $("#DivConnectCall").css("top", intTop + "px");
    $("#DivConnectCall").show();
}

function fnGetConnectCallHtml(arrPhones, strCenterCode, strRcvTelNo, strOrderNo, strOrderNo, strSmsType) {
    var strHtml = "";
    $.each(arrPhones, function (index, item) {
        item = item.replace(/[^0-9]/gi, "");

        strHtml += "<div>";
        strHtml += "<h2>" + fnMakeCellNo(item) + "</h2>";
        strHtml += "<ul>";
        strHtml += "<li><a href=\"#\" onclick=\"fnGetCMCallerInfo(event, '" + strCenterCode + "','" + item + "','" + strRcvTelNo + "'); return false;\" title=\"CID정보\" class=\"ic_cid\"></a></li>";
        if (strRcvTelNo != "" && strRcvTelNo != null) {
            strHtml += "<li><a href=\"#\" onclick=\"fnCMConnectCall(event, '" + strCenterCode + "','" + item + "','" + strRcvTelNo + "'); return false;\" title=\"전화걸기\" class=\"ic_tell\"></a></li>";
        }
        if (isMobilePhone(item)) {
            strHtml += "<li><a href=\"#\" onclick=\"fnCMSendSMS(event, '" + item + "','" + strRcvTelNo + "', '" + strSmsType + "', '" + strCenterCode + "', '" + strOrderNo + "'); return false;\" title=\"문자보내기\" class=\"ic_sms\"></a></li>";
        }

        strHtml += "</ul>";
        strHtml += "</div>";
    });

    strHtml += "<button type=\"button\" onclick=\"fnCloseConnectCall(event, this); return false;\" title=\"닫기\"></button>"
    return strHtml;
}

//팝업닫기
function fnCloseConnectCall(e, obj) {
    e.stopPropagation();
    $("#DivConnectCall").html("");
    $("#DivConnectCall").hide();
}

$(function () {
    // 문서 바깥 클릭 시 닫기
    $(document).on("click", function (e) {
        if ($("#DivConnectCall").length > 0) {
            if ($(e.target).closest("#DivConnectCall").length === 0) {
                $("#DivConnectCall>button").click();
            }
        }
    });
});

//카드 정보 조회
function fnGetCMCallerInfo(e, strCenterCode, strSndTelNo, strRcvTelNo) {
    if (e != null) {
        e.stopPropagation();
    }

    if (typeof strCenterCode === "undefined" || strCenterCode == null) {
        return false;
    }

    if (typeof strSndTelNo === "undefined" || strSndTelNo == null) {
        return false;
    }

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnGetCMCallerInfoSuccResult";
    var strFailCallBackFunc = "fnGetCMCallerInfoFailResult";
    var objParam = {
        CallType: "CMCallerInfoGet",
        CenterCode: strCenterCode,
        SndTelNo: strSndTelNo,
        RcvTelNo: strRcvTelNo
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    return false;
}

function fnGetCMCallerInfoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                fnGetCMCallerInfoFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode) {
            if (objRes[0].result.ErrorCode != 0) {
                fnGetCMCallerInfoFailResult();
                return false;
            }
        }

        var strPageUrl = document.location.href;
        fnOpenCMDetailPage(JSON.stringify(objRes[0].data), strPageUrl.indexOf("CMCallDetail") > -1 ? false : true);
        return false;
    } else {
        fnGetCMCallerInfoFailResult();
        return false;
    }
}

function fnGetCMCallerInfoFailResult() {
    fnDefaultAlert("정보 조회에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning");
    return false;
}

//CID 상세 페이지 열기
function fnOpenCMDetailPage(strCMJsonParam, isOpenPopup) {
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var $form = null;

    if ($("form[name=CMForm]").length == 0) {
        $form = $("<form name='CMForm'></form>");
        $form.appendTo("body");
    } else {
        $form = $("form[name=CMForm]");
    }

    $form.attr("action", "/TMS/CallManager/CMCallDetail");
    $form.attr("method", "post");
    var f1 = $("<input type='hidden' name='CMJsonParam' value='" + strCMJsonParam + "'>");
    $form.append(f1);

    if (isOpenPopup) {
        $form.attr("target", "CMDetail");
        window.open("", "CMDetail", "width=" + screen.width + ",height=" + screen.height + ",scrollbars=no,fullscreen=yes");
    }
    $form.submit();
    $form.remove();
    return false;
}

//전화걸기
function fnCMConnectCall(e, strCenterCode, strRcvTelNo, strSndTelNo) {
    if (e != null) {
        e.stopPropagation();
    }

    if (typeof strCenterCode === "undefined" || strCenterCode == "") {
        return false;
    }

    if (typeof strSndTelNo === "undefined" || strSndTelNo == "") {
        return false;
    }

    if (typeof strRcvTelNo === "undefined" || strRcvTelNo == "") {
        fnDefaultAlert("발신 전화번호 정보가 없습니다.", "warning");
        return false;
    }

    var strConfMsg = "[ " + fnMakeCellNo(strSndTelNo) + " ]를 이용하여<br/>[ " + fnMakeCellNo(strRcvTelNo) + " ]와 통화하시겠습니까?";
    var objParam = {
        CenterCode: strCenterCode,
        SndTelNo: strSndTelNo,
        RcvTelNo: strRcvTelNo,
        MobileFlag: isMobilePhone(strSndTelNo) ? "Y" :"N"
    };

    fnDefaultConfirm(strConfMsg, "fnCMConnectCallProc", objParam);
    return false;
}

function fnCMConnectCallProc(objParam) {
    if (typeof objParam === "undefined" || objParam == null) {
        return false;
    }

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnCMConnectCallProcSuccResult";
    var strFailCallBackFunc = "fnCMConnectCallProcFailResult";
    objParam.CallType = "CMSendCall"
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    return false;
}

function fnCMConnectCallProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode != 0) {
            fnCMConnectCallProcFailResult(objRes[0].ErrMsg);
            return false;
        } else {
            fnDefaultAlert(objRes[0].ErrMsg, "info");
            return false;
        }
    } else {
        fnCMConnectCallProcFailResult();
        return false;
    }
}

function fnCMConnectCallProcFailResult(strErrMsg) {
    strErrMsg = typeof strErrMsg != "string" ? "" : strErrMsg;
    fnDefaultAlert(strErrMsg == "" ? "통화 연결에 실패했습니다." : strErrMsg, "warning");
    return false;
}

//문자보내기
function fnCMSendSMS(e, strRcvTelNo, strSndTelNo, strSMSType, strCenterCode, strOrderNo) {
    if (e != null) {
        e.stopPropagation();
    }
    //if (typeof strRcvTelNo === "undefined" || strRcvTelNo == "") {
    //    return false;
    //}
    //
    //if (typeof strSndTelNo === "undefined" || strSndTelNo == "") {
    //    return false;
    //}

    if (typeof strSMSType === "undefined" || strSMSType == "") {
        return false;
    }

    if (typeof strCenterCode === "undefined" || strCenterCode == "") {
        return false;
    }

    //1:기본, 2:오더내용 불러오기, 3:머핀트럭 다운로드 안내, 4:배차정보전송
    var strParam = "?ParamCenterCode=" + strCenterCode;
    if (strOrderNo != "") {
        strParam += "&ParamOrderNos=" + strOrderNo;
    }

    if (strRcvTelNo != "") {
        strParam += "&ParamRcvTelNo=" + strRcvTelNo;
    }
    if (strSndTelNo != "") {
        strParam += "&ParamSndTelNo=" + strSndTelNo;
    }

    strParam += "&ParamOrderType=" + strSMSType;

    fnOpenRightSubLayer("문자 발송", "/TMS/Common/MsgSend" + strParam , "1024px", "700px", "50%");
    return false;
}
/*****************/

//자동완성설정
function fnSetAutocomplete({
    formId, //적용할 폼 아이디
    width = 400, //리스트 가로 사이즈(기본 400)
    useTemplate = true, //템플릿 사용여부
    position = { my: "left top", at: "left bottom", collision: "flipfit" }, //리스트 표시 위치
    pageSize = 100, //리스트 표시 수
    callbacks = {} //콜백함수
}) {
    let state = {
        pageNo: 1,
        pageSize: pageSize,
        lastKey: 0,
        term: ""
    };

    const $input = $("#" + formId);
    let isSearching = false;

    // Enter 검색 트리거
    $input.on("keydown", function (e) {
        state.lastKey = e.keyCode === 13 || e.keyCode === 40 ? 13 : 0; //아래화살표 추가
        if (state.lastKey === 13) {
            e.preventDefault();
            if ($(this).autocomplete("instance").menu.element.is(":visible")) {
                //var li = $(this).autocomplete("instance").menu.element.find("li");
                if ($(this).val() == state.term) {
                    return;
                }
            }

            $(this).autocomplete("search");
        }
    });

    $input.autocomplete({
        delay: 0,
        minLength: 2,
        position: position,
        source: function (request, response) {
            if (state.lastKey !== 13) return;

            if (isSearching) return; // 이미 검색 중이면 무시
            isSearching = true;

            if (request.term !== state.term) {
                state.pageNo = 1;
            }

            state.term = request.term;

            const paramFn = callbacks.getParam || (() => ({}));
            const beforeSendFn = callbacks.beforeSend || (() => true);

            $.ajax({
                url: callbacks.getUrl(),
                type: "POST",
                cache: false,
                async: false,
                data: paramFn(request, state),
                dataType: "json",
                beforeSend: () => {
                    if (!beforeSendFn(request, state)) {
                        isSearching = false;
                        return false;
                    }

                    fnAjaxBlockUI();
                },
                success: function (data) {
                    if (!data) return;
                    if (typeof data[0].RetCode !== "undefined") { if (data[0].RetCode !== 0) return; }

                    let recordCnt = 0;
                    let list = [];

                    if (data[0].result) {
                        if (data[0].result.ErrorCode !== 0) return;
                        if (!data[0].data) return;
                        data = data[0].data;
                        recordCnt = data.RecordCnt;
                        list = data.list || [];
                    } else {
                        data = data[0];
                        recordCnt = data.TotalCount;
                        list = data.List || [];
                    }

                    const totalPage = Math.ceil(recordCnt / pageSize);

                    let arrObj = [];

                    if (list.length === 0) {
                        arrObj.push({ label: "검색 결과가 없습니다.", value: "" });
                    } else {
                        // Header
                        arrObj.push({
                            label: `Total : ${recordCnt}, Page : ${state.pageNo} / ${totalPage}`,
                            value: ""
                        });

                        if (state.pageNo > 1) {
                            arrObj.push({ label: "◀ 이전페이지", value: "" });
                        }

                        // List
                        list.forEach(item => {
                            arrObj.push({
                                label: callbacks.getLabel(item),
                                value: callbacks.getValue(item),
                                etc: item
                            });
                        });

                        if (state.pageNo < totalPage) {
                            arrObj.push({ label: "다음페이지 ▶", value: "" });
                        }
                    }
                    response(arrObj);
                },
                complete: function () {
                    $.unblockUI();
                    isSearching = false;
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $.unblockUI();
                    isSearching = false;
                }
            });
        },
        select: function (event, ui) {
            if (ui.item.etc) {
                callbacks.onSelect?.(event, ui);
            } else if (ui.item.label.includes("이전페이지")) {
                state.pageNo--;
                let self = this;
                setTimeout(function () {
                    $(self).autocomplete("search");
                }, 0);
            } else if (ui.item.label.includes("다음페이지")) {
                state.pageNo++;
                let self = this;
                setTimeout(function () {
                    $(self).autocomplete("search");
                }, 0);
            }
            return false;
        },
        focus: function (event) {
            event.preventDefault(); // label이 input에 세팅되지 않도록 방지
        },
        open: function () {
            $(this).removeClass("ui-corner-all").addClass("ui-corner-top");
        },
        close: function () {
            $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
            callbacks.onClose?.();
        }
    }).on("blur", function () {
        state.term = "";
        callbacks.onBlur?.();
    });

    // 리스트 가로 길이
    $input.autocomplete("instance")._resizeMenu = function () {
        this.menu.element.outerWidth(width);
    };

    // 템플릿 지정
    if (useTemplate && callbacks.getTemplate) {
        $input.autocomplete("instance")._renderItem = function (ul, item) {
            const html = callbacks.getTemplate(ul, item);
            return $("<li></li>")
                .data("item.autocomplete", item)
                .append(html)
                .appendTo(ul);
        };
    }

    // 페이징 표시 스타일링
    $input.autocomplete("instance")._renderMenu = function (ul, items) {
        const that = this;
        items.forEach(item => that._renderItemData(ul, item));
        $(ul).find("li").each(function (i) {
            const text = $(this).text();
            if (text.includes("Total :")) $(this).addClass("ui-menu-item-info");
            else if (text.includes("다음페이지") || text.includes("이전페이지")) $(this).addClass("ui-menu-item-nav");
            else if ((i + 1) % 2 === 1) $(this).addClass("ui-menu-item-odd");
        });
    };
}

//자동완성 리스트 레이아웃
function fnGetAutocompleteTemplate(strType, objUl, objItem) {
    var strHtml = "";
    strHtml = "<div>" + objItem.label + "</div>";
    /*
    타이틀이 필요한 경우에 사용
    if (strType == "VCustomer" && objItem.label.indexOf("검색 결과가") < 0 && objItem.label.indexOf("이전페이지") < 0 && objItem.label.indexOf("다음페이지") < 0) { //거래처(View)
        strHtml += "<div><table><colgroup><col width='24%'/><col width='24%'/><col width='20%'/><col width='10%'/><col width='22%'/></colgroup><tr>";
        strHtml += "<td class=\"b\">사업자/거래처</td>";
        strHtml += "<td class=\"tc\">법인명</td>";
        strHtml += "<td>사업자번호</td>";
        strHtml += "<td class=\"tc\">타입</td>";
        strHtml += "<td class=\"tc\">차량번호</td>";
        strHtml += "</tr></table></div>";
    }
    */

    if (typeof objItem.etc == "object") {
        if (strType == "Client") { //고객사
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="" />
                                    <col width="20%" />
                                    <col width="80px" />
                                    <col width="90px" />
                                </colgroup>
                                <tr>
                                    <td class="b tl">${objItem.etc.ClientName}</td>
                                    <td>${objItem.etc.ClientCeoName}</td>
                                    <td>${fnMakeCorpNo(objItem.etc.ClientCorpNo)}</td>
                                    <td>${objItem.etc.ClientTaxKindM}, ${objItem.etc.ClientStatusM}, ${objItem.etc.ClientBusinessStatusM}</td>
                                </tr>
                            </table>
                        </div>`;
        } else if (strType == "ClientNCharge") { //고객사 + 고객사 담당자
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="" />
                                    <col width="10%" />
                                    <col width="90px" />
                                    <col width="90px" />
                                    <col width="10%" />
                                    <col width="90px" />
                                    <col width="90px" />
                                </colgroup>
                                <tr>
                                    <td class="b tl">${objItem.etc.ClientName}</td>
                                    <td>${objItem.etc.ClientCeoName}</td>
                                    <td>${fnMakeCorpNo(objItem.etc.ClientCorpNo)}</td>
                                    <td>${objItem.etc.ClientTaxKindM}, ${objItem.etc.ClientStatusM}, ${objItem.etc.ClientBusinessStatusM}</td>
                                    <td class="b tl">${objItem.etc.ChargeName}</td>
                                    <td>${fnMakeCellNo(objItem.etc.ChargeTelNo)}</td>
                                    <td>${fnMakeCellNo(objItem.etc.ChargeCell)}</td>
                                </tr>
                            </table>
                        </div>`;
        } else if (strType == "ClientCharge") { //고객사 담당자
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="" />
                                    <col width="90px" />
                                    <col width="90px" />
                                </colgroup>
                                <tr>
                                    <td class="b tl">${objItem.etc.ChargeName}</td>
                                    <td>${fnMakeCellNo(objItem.etc.ChargeTelNo)}</td>
                                    <td>${fnMakeCellNo(objItem.etc.ChargeCell)}</td>
                                </tr>
                            </table>
                        </div>`;
        } else if (strType == "CarDispatchRef") { //차량목록
            strHtml = `<div>
                        <table>
                            <colgroup>
                                <col width="35px" />
                                <col width="100px" />
                                <col width="100px" />
                                <col width="180px" />
                                <col width="" />
                                <col width="90px" />
                                <col width="90px" />
                                <col width="90px" />
                            </colgroup>
                            <tr>
                                <td>[${objItem.etc.CarDivTypeM}]</td>
                                <td class="b">${objItem.etc.CarNo}</td>
                                <td class="tl">${objItem.etc.CarTypeCodeM}, ${objItem.etc.CarTonCodeM}</td>
                                <td class="b tl">${objItem.etc.DriverName} (${fnMakeCellNo(objItem.etc.DriverCell)})</td>
                                <td class="tl">${objItem.etc.ComName}</td>
                                <td>${objItem.etc.ComCeoName}</td>
                                <td>${fnMakeCorpNo(objItem.etc.ComCorpNo)}</td>
                                <td>${objItem.etc.ComKindM}, ${objItem.etc.ComTaxKindM}, ${objItem.etc.ComStatusM}</td>
                            </tr>
                        </table>
                    </div>`;
        } else if (strType == "CarCompany") { //차량업체
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="" />
                                    <col width="20%" />
                                    <col width="90px" />
                                    <col width="35px" />
                                    <col width="150px" />
                                    <col width="35px" />
                                </colgroup>
                                <tr>
                                    <td class="b tl">${objItem.etc.ComName}</td>
                                    <td>${objItem.etc.ComCeoName}</td>
                                    <td>${fnMakeCorpNo(objItem.etc.ComCorpNo)}</td>
                                    <td>${objItem.etc.ComKindM}</td>
                                    <td class="tl">${objItem.etc.ComTaxKindM} (${objItem.etc.ComTaxMsg})</td>
                                    <td>${objItem.etc.ComStatusM}</td>
                                </tr>
                            </table>
                        </div>`;
        } else if (strType == "Driver") { //기사정보
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="" />
                                    <col width="90px" />
                                </colgroup>
                                <tr>
                                    <td class="b tl">${objItem.etc.DriverName}</td>
                                    <td>${fnMakeCellNo(objItem.etc.DriverCell)}</td>
                                </tr>
                            </table>
                        </div>`;
        } else if (strType == "Car") { //차량정보
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="" />
                                    <col width="90px" />
                                    <col width="90px" />
                                </colgroup>
                                <tr>
                                    <td class="b tl">${objItem.etc.CarNo}</td>
                                    <td>${objItem.etc.CarTypeCodeM}</td>
                                    <td>${objItem.etc.CarTonCodeM}</td>
                                </tr>
                            </table>
                        </div>`;
        } else if (strType == "Place") { //상하차지
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                </colgroup>
                                <tr>
                                    <td class="b tl">${objItem.etc.PlaceName}</td>
                                    <td>${objItem.etc.PlaceAddr}</td>
                                </tr>
                            </table>
                        </div>`;
        } else if (strType == "PlaceNCharge") { //상하차지 + 상하차지 담당자
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                    <col width="90px" />
                                    <col width="90px" />
                                    <col width="90px" />
                                </colgroup>
                                <tr>
                                    <td class="b tl">${objItem.etc.PlaceName}</td>
                                    <td class="tl">${objItem.etc.PlaceAddr}</td>
                                    <td class="b tl">${objItem.etc.ChargeName}</td>
                                    <td>${fnMakeCellNo(objItem.etc.ChargeTelNo)}</td>
                                    <td>${fnMakeCellNo(objItem.etc.ChargeCell)}</td>
                                </tr>
                            </table>
                        </div>`;
        } else if (strType == "ConsignorNClient") { //화주 + 발주처 + 청구처
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="35%" />
                                    <col width="35%" />
                                    <col width="15%" />
                                    <col width="15%" />
                                </colgroup>
                                <tr>
                                    <td class="b tl" colspan="4">${objItem.etc.ConsignorInfo}</td>
                                </tr>`;
            if (objItem.etc.OrderClientCode != 0 || objItem.etc.PayClientCode != 0 || objItem.etc.PickupPlaceSeqNo != 0 || objItem.etc.GetPlaceSeqNo != 0) {
                strHtml += `    <tr>
                                    <td class="tl cont">${objItem.etc.OrderClientInfo}</td>
                                    <td class="tl cont">${objItem.etc.PayClientInfo}</td>
                                    <td class="tl cont">${objItem.etc.PickupPlaceInfo}</td>
                                    <td class="tl cont">${objItem.etc.GetPlaceInfo}</td>
                                </tr>`;
            }
            strHtml += `    </table>
                        </div>`;
        } else if (strType == "TransRate") { //요율표
            strHtml = `<div>
                            <table>
                                <colgroup>
                                    <col width="" />
                                    <col width="90px" />
                                    <col width="90px" />
                                </colgroup>
                                <tr>
                                    <td class="b tl">${objItem.etc.TransRateName}</td>
                                    <td>${objItem.etc.RateTypeM}</td>
                                    <td>${objItem.etc.FTLFlagM}</td>
                                </tr>
                            </table>
                        </div>`;
        }
    }
    return strHtml;
}

//자동완성버튼
$(document).ready(function () {
    if ($(".findContainer").length > 0) {
        $(".findContainer button").on("click", function (e) {
            var strID = $(this).parent(".findContainer").children(":first-child").attr("id");
            $("#" + strID).trigger($.Event("keydown", { keyCode: 13 }));
        });

        $.each($(".findContainer button"), function (index, item) {
            $(item).attr("title", $(item).parent(".findContainer").children(":first-child").attr("title"));
        });
    }
});