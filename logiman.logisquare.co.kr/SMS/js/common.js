/*************************************************************
*                      팝업 Layer 관련 함수
**************************************************************/
$(document).ready(function () {
    /*팝업 레이어 리사이즈*/
  $("#cp_layer").resizable({
		minWidth: 320,
		maxWidth: $(window).width() - 210,
		handles: "w"
	});
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

    if (dateTerm > intDay) {
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

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === "R") { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if (data.userSelectedType === "R") {
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== "" && data.apartment === "Y") {
                    extraAddr += (extraAddr !== "" ? ", " + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraAddr !== "") {
                    extraAddr = "(" + extraAddr + ")";
                }
            }

            sido = fnGetShortSido(data.sido);
            sigungu = data.sigungu;
            dong = data.bname1;
            if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                dong += dong === "" ? data.bname2 : (" " + data.bname2);
            }

            fnSetAddress(type, post, addr, extraAddr, sido, sigungu, dong);
        }
    }).open();
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

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === "R") { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if (data.userSelectedType === "R") {
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== "" && data.apartment === "Y") {
                    extraAddr += (extraAddr !== "" ? ", " + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraAddr !== "") {
                    extraAddr = " (" + extraAddr + ")";
                }
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
    }).embed(obj);

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
        strRetSido = "강원도";
        break;
    case "충북":
        strRetSido = "충청북도";
        break;
    case "충남":
        strRetSido = "충청남도";
        break;
    case "전북":
        strRetSido = "전라북도";
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
    case "강원도":
        strRetSido = "강원";
        break;
    case "충청북도":
        strRetSido = "충북";
        break;
    case "충청남도":
        strRetSido = "충남";
        break;
    case "전라북도":
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

function fnCheckPersonalNo(strPersonalNo) {
    var objArrPersonalNo = [];
    var objArrCompare = [2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5];
    var intSum = 0;

    if (strPersonalNo.length !== 13) {
        return false;
    }

    if (strPersonalNo.match("[^0-9]")) {
        return false;
    }

    // ABCDEF-GHIJKLM
    // 주민등록번호 마지막 자리 = (11 - ((2×A + 3×B + 4×C + 5×D + 6×E + 7×F + 8×G + 9×H + 2×I + 3×J + 4×K + 5×L) % 11)) % 10
    for (var i = 0; i < 13; i++) {
        objArrPersonalNo[i] = strPersonalNo.substring(i, i + 1);
    }

    for (var i = 0; i < 12; i++) {
        intSum += (objArrPersonalNo[i] * objArrCompare[i]);
    }

    intSum = (11 - (intSum % 11)) % 10;
    if (intSum != objArrPersonalNo[12]) {
        return false;
    }

    return true;
}