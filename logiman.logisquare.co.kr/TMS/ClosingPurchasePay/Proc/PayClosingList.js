window.name = "PayClosingList";
// 그리드
var GridID = "#PayClosingSendListGrid";
var GridSort = [];

$(document).ready(function () {
    /* 그리드 사이즈 조정 */
    $("div.right").css("z-index", "1");
    if ($.cookie(window.name)) {
        var objSize = JSON.parse($.cookie(window.name));
        if (typeof objSize.left != "undefined" && typeof objSize.right != "undefined") {
            $("div.left").width(objSize.left + "%");
            $("li.left").width(objSize.left + "%");
            $("div.right").width(objSize.right + "%");
            $("li.right").width(objSize.right + "%");
        }
    }

    $("div.left").resizable({
        handles: "e",
        minWidth: 450,
        maxWidth: $("div.grid_list").width() - 450,
        start: function (event, ui) {
            var intMaxWidth = $("div.grid_list").width() - 450;
            if (intMaxWidth < 450) {
                intMaxWidth = 450;
            }
            $("div.left").resizable("option", "maxWidth", intMaxWidth);
        },
        resize: function (event, ui) {
            var leftWidthPer = ui.size.width / $("div.grid_type_03").width() * 100;
            var rightWidthPer = 100 - leftWidthPer;

            $("div.left").width(leftWidthPer + "%");
            $("li.left").width(leftWidthPer + "%");
            $("div.right").width(rightWidthPer + "%");
            $("li.right").width(rightWidthPer + "%");

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 230);
            AUIGrid.resize(GridPurchaseID, $("div.right").width(), $(document).height() - 230);
        },
        stop: function (event, ui) {
            var leftWidthPer = ui.size.width / $("div.grid_type_03").width() * 100;
            var rightWidthPer = 100 - leftWidthPer;

            $("div.left").width(leftWidthPer + "%");
            $("li.left").width(leftWidthPer + "%");
            $("div.right").width(rightWidthPer + "%");
            $("li.right").width(rightWidthPer + "%");

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 230);
            AUIGrid.resize(GridPurchaseID, $("div.right").width(), $(document).height() - 230);

            $.cookie(window.name, "{\"left\":" + leftWidthPer + ", \"right\":" + rightWidthPer + "}", { expires: 7 });
        }
    });
    /* 그리드 사이즈 조정 끝 */

    $("#DateFrom").datepicker({
        dateFormat: "yy-mm-dd",
        onSelect: function (dateFromText, inst) {
            var dateToText = $("#DateTo").val().replace(/-/gi, "");
            if (dateToText.length !== 8) {
                dateToText = GetDateToday("");
            }

            if (parseInt(dateFromText.replace(/-/gi, "")) > parseInt(dateToText)) {
                $("#DateTo").datepicker("setDate", dateFromText);
            }
        }
    });
    $("#DateFrom").datepicker("setDate", GetDateToday("-"));

    $("#DateTo").datepicker({
        dateFormat: "yy-mm-dd",
        onSelect: function (dateToText, inst) {
            var dateFromText = $("#DateFrom").val().replace(/-/gi, "");
            if (dateFromText.length !== 8) {
                dateFromText = GetDateToday("");
            }

            if (parseInt(dateFromText) > parseInt(dateToText.replace(/-/gi, ""))) {
                $("#DateFrom").datepicker("setDate", dateToText);
            }
        }
    });
    $("#DateTo").datepicker("setDate", GetDateToday("-"));

    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // Ctrl + F
        if (event.ctrlKey && event.keyCode === 70) {
            //fnSearchDialog("gridDialog", "open");
            return false;
        }

        // ESC
        if (event.keyCode === 27) {
            fnSearchDialog("gridDialog", "close");
            fnSearchDialog("gridDialog2", "close");
            return false;
        }
    });

    // 그리드 초기화
    fnGridInit();

    // 그리드 검색 이벤트
    if ($("#gridDialog").length > 0) {
        $("#LinkGridSearchClose").on("click", function () {
            fnSearchDialog("gridDialog", "close");
            return false;
        });

        $("#BtnGridSearch").on("click", function () {
            fnSearchClick();
            return false;
        });

        $("#GridSearchText").on("keydown", function (event) {
            if (event.keyCode === 13) {
                fnSearchClick();
                return false;
            }

            if (event.keyCode === 27) {
                fnSearchDialog("gridDialog", "close");
                return false;
            }
        });
    }

    if ($("#gridDialog2").length > 0) {
        $("#LinkGridSearchClose2").on("click", function () {
            fnSearchDialog("gridDialog2", "close");
            return false;
        });

        $("#BtnGridSearch2").on("click", function () {
            fnSearchClick2();
            return false;
        });

        $("#GridSearchText2").on("keydown", function (event) {
            if (event.keyCode === 13) {
                fnSearchClick2();
                return false;
            }

            if (event.keyCode === 27) {
                fnSearchDialog("gridDialog2", "close");
                return false;
            }
        });
    }
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 230;
    AUIGrid.resize(GridID, $("div.left").width() - 5, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 230);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 230);
        }, 100);
    });

    //그리드에 포커스
    AUIGrid.setFocus(GridID);

    // 푸터
    fnSetGridFooter(GridID);
    AUIGrid.setGridData(GridID, []);
}

//기본 레이아웃 세팅
function fnCreateGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleCells"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
    objGridProps.showRowAllCheckBox = false; //체크박스를 표시할지 여부
    objGridProps.rowCheckToRadio = true; //체크박스 대신 라디오버튼으로 변환
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    
    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'PayClosingSendListGrid');
        return;
    });

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        fnSetCheckedList(event.checked, event.item);
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [

        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SendPlanYMD",
            headerText: "송금예정일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "AllCnt",
            headerText: "총건수",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "AllAmt",
            headerText: "총매입",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendCnt1",
            headerText: "미신청건수",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendAmt1",
            headerText: "미신청매입",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendCnt2",
            headerText: "신청건수",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendAmt2",
            headerText: "신청매입",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendCnt3",
            headerText: "완료건수",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendAmt3",
            headerText: "완료매입",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        /*숨김필드*/
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
// 키 다운 핸들러 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridKeyDown(event) {
    // Ctrl + F
    if (event.ctrlKey && event.keyCode === 70) {
        fnSearchDialog("gridDialog", "open");
        return false;
    }

    // ESC
    if (event.keyCode === 27) {
        fnSearchDialog("gridDialog", "close");
        return false;
    }
    return true;
}

// 검색 notFound 이벤트 핸들러
function fnGridSearchNotFound(event) {
    var strTerm = event.term; // 찾는 문자열
    var blWrapFound = event.wrapFound; // wrapSearch 한 경우 만족하는 term 이 그리드에 1개 있는 경우.

    if (blWrapFound) {
        fnDefaultAlert("그리드 마지막 행을 지나 다시 찾았지만 다음 문자열을 찾을 수 없습니다 - " + strTerm, "warning");
    } else {
        fnDefaultAlert("다음 문자열을 찾을 수 없습니다 - " + strTerm, "warning");
    }
    return false;
};

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    fnSetCheckedList(true, objItem);
}

function fnSetCheckedList(isChecked, objItem) {
    if (isChecked) {
        AUIGrid.setAllCheckedRows(GridID, false);
        AUIGrid.setCheckedRowsByIds(GridID, objItem.SeqNo);

        $("#HidCenterCode").val(objItem.CenterCode);
        $("#HidSendPlanYMD").val(objItem.SendPlanYMD);
        $("#GridResult2").html("");
        AUIGrid.setGridData(GridPurchaseID, []);
        fnCallPurchaseGridData(GridPurchaseID);
    }
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var LocationCode = [];
    var DLocationCode = [];
    var ItemCode = [];

    var strHandlerURL = "/TMS/ClosingPurchasePay/Proc/PayClosingHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    $.each($("#DeliveryLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            DLocationCode.push($(el).val());
        }
    });

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            ItemCode.push($(el).val());
        }
    });

    var objParam = {
        CallType: "PayClosingSendList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        DeliveryLocationCodes: DLocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        ComName: $("#ComName").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        ClosingAdminName: $("#ClosingAdminName").val(),
        DeductFlag: $("#DeductFlag").is(":checked") ? "Y" : "N",
        InsureFlag: $("#ChkInsure").is(":checked") ? "Y" : "",
        PurchaseClosingSeqNo: $("#SearchPurchaseClosingSeqNo").val(),
        PageNo: $("#PageNo").val(),
        PageSize: $("#PageSize").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {

        $("#RecordCnt").val(0);
        $("#GridResult").html("");
        AUIGrid.setGridData(GridID, []);
        fnCreatePagingNavigator();

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

        // 페이징
        fnCreatePagingNavigator();

        // 그리드 정렬
        AUIGrid.setSorting(GridID, GridSort);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {
    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "CenterName",
            dataField: "CenterName",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        },
        {
            positionField: "AllCnt",
            dataField: "AllCnt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AllAmt",
            dataField: "AllAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendCnt1",
            dataField: "SendCnt1",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendAmt1",
            dataField: "SendAmt1",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendCnt2",
            dataField: "SendCnt2",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendAmt2",
            dataField: "SendAmt2",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendCnt3",
            dataField: "SendCnt3",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendAmt3",
            dataField: "SendAmt3",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}


/**************************************/


/**********************************************/
//마감 
/**********************************************/

var GridPurchaseID = "#PayClosingListGrid";

$(document).ready(function () {
    if ($(GridPurchaseID).length > 0) {
        // 그리드 초기화
        fnPurchaseGridInit();
    }
});

function fnPurchaseGridInit() {
    // 그리드 레이아웃 생성
    fnCreatePurchaseGridLayout(GridPurchaseID, "PurchaseClosingSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridPurchaseID, "", "", "fnPurchaseGridKeyDown", "", "", "", "", "fnGridPurchaseCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 230;
    AUIGrid.resize(GridPurchaseID, $("div.right").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridPurchaseID, $("div.right").width(), $(document).height() - 230);

        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridPurchaseID, $("div.right").width(), $(document).height() - 230);
        }, 100);
    });

    // 푸터
    fnSetPurchaseGridFooter(GridPurchaseID);
    AUIGrid.setGridData(GridPurchaseID, []);
}

//기본 레이아웃 세팅
function fnCreatePurchaseGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleCells"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
    objGridProps.independentAllCheckBox = true;
    objGridProps.rowCheckToRadio = false; //체크박스 대신 라디오버튼으로 변환
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    objGridProps.rowCheckDisabledFunction = function (rowIndex, isChecked, item) {
        if (item.SendStatus > 1) {
            return false; // false 반환하면 disabled 처리됨
        }
        return true;
    }

    objGridProps.rowCheckableFunction = function (rowIndex, isChecked, item) {
        if (item.SendStatus > 1) {
            return false; // false 반환하면 disabled 처리됨
        }
        return true;
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultPurchaseColumnLayout()");
    var objOriLayout = fnGetDefaultPurchaseColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);


    // 전체 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowAllChkClick", function (event) {
        if (event.checked) {
            var objItemsChecked = [];
            $.each(AUIGrid.getGridData(event.pid), function (index, item) {
                if (!(item.SendStatus == 2 || item.SendStatus == 3)) {
                    objItemsChecked.push(item.PurchaseClosingSeqNo);
                }
            });

            AUIGrid.setCheckedRowsByIds(event.pid, objItemsChecked);
        } else {
            var objItemsChecked = [];
            $.each(AUIGrid.getCheckedRowItems(event.pid), function (index, item) {
                objItemsChecked.push(item.item.PurchaseClosingSeqNo);
            });
            AUIGrid.addUncheckedRowsByIds(event.pid, objItemsChecked);
        }
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultPurchaseColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/

        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PurchaseClosingSeqNo",
            headerText: "전표번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComName",
            headerText: "차량업체명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComKindM",
            headerText: "법인여부",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComCeoName",
            headerText: "대표자명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComStatusM",
            headerText: "업체상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComTaxKindM",
            headerText: "과세구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComTaxMsg",
            headerText: "과세구분상세",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OrgAmt",
            headerText: "매입합계",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SupplyAmt",
            headerText: "공급가액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "TaxAmt",
            headerText: "부가세",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "DeductAmt",
            headerText: "총공제금액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "InputDeductAmt",
            headerText: "공제금액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "DeductReason",
            headerText: "공제사유",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "InsureFlag",
            headerText: "산재보험적용",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DriverInsureAmt",
            headerText: "산재보험료",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendAmt",
            headerText: "송금예정액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "BillStatusM",
            headerText: "발행상태",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "BillKindM",
            headerText: "발행구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupYMDTo",
            headerText: "최종상차일",
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillWrite",
            headerText: "계산서작성일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillYMD",
            headerText: "계산서발행일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "NtsConfirmNum",
            headerText: "국세청승인번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BankName",
            headerText: "은행명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SearchAcctNo",
            headerText: "계좌번호(끝4자리)",
            editable: false,
            width: 100,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "AcctNo",
            headerText: "계좌번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "AcctName",
            headerText: "예금주",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendTypeM",
            headerText: "결제방식",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SendStatusM",
            headerText: "송금상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SendPlanYMD",
            headerText: "송금예정일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendYMD",
            headerText: "실제송금일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendBankName",
            headerText: "송금-은행명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendSearchAcctNo",
            headerText: "송금-계좌번호(끝4자리)",
            editable: false,
            width: 100,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "SendAcctNo",
            headerText: "송금-계좌번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendAcctName",
            headerText: "송금-예금주",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendAdminName",
            headerText: "송금신청자",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendDate",
            headerText: "송금신청일",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Note",
            headerText: "메모",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClosingAdminName",
            headerText: "마감자",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClosingDate",
            headerText: "마감일시",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        /*숨김필드*/
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComCode",
            headerText: "ComCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "SendKind",
            headerText: "SendKind",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "SendStatus",
            headerText: "SendStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "BtnRegBill",
            headerText: "계산서",
            editable: false,
            visible: false,
            width: 0,
            renderer: {
                type: "ButtonRenderer",
                onClick: function (event) {
                    fnOpenBill(event.item);
                }
            },
            viewstatus: false
        },
        {
            dataField: "BtnRegAcct",
            headerText: "계좌등록",
            editable: false,
            visible: false,
            width: 0,
            renderer: {
                type: "ButtonRenderer",
                labelText: "등록",
                onClick: function (event) {
                    fnOpenAcctNo(event.item);
                }
            },
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------
//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridPurchaseCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    fnSetDetailList(objItem);
}

// 키 다운 핸들러 - 사용자 정의(페이지 기능별 수정 필요)
function fnPurchaseGridKeyDown(event) {
    // Ctrl + F
    if (event.ctrlKey && event.keyCode === 70) {
        fnSearchDialog("gridDialog2", "open");
        return false;
    }

    // ESC
    if (event.keyCode === 27) {
        fnSearchDialog("gridDialog2", "close");
        return false;
    }
    return true;
}

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallPurchaseGridData(strGID) {

    if (!$("#HidCenterCode").val() || !$("#HidSendPlanYMD").val()) {
        $("#GridResult2").html("");
        AUIGrid.setGridData(GridPurchaseID, []);
        return false;
    }

    var LocationCode = [];
    var DLocationCode = [];
    var ItemCode = [];

    var strHandlerURL = "/TMS/ClosingPurchasePay/Proc/PayClosingHandler.ashx";
    var strCallBackFunc = "fnPurchaseGridSuccResult";

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    $.each($("#DeliveryLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            DLocationCode.push($(el).val());
        }
    });

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            ItemCode.push($(el).val());
        }
    });

    var objParam = {
        CallType: "PayClosingList",
        CenterCode: $("#HidCenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#HidSendPlanYMD").val(),
        DateTo: $("#HidSendPlanYMD").val(),
        OrderLocationCodes: LocationCode.join(","),
        DeliveryLocationCodes: DLocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        ComName: $("#ComName").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        ClosingAdminName: $("#ClosingAdminName").val(),
        DeductFlag: $("#DeductFlag").is(":checked") ? "Y" : "N",
        PurchaseClosingSeqNo: $("#SearchPurchaseClosingSeqNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnPurchaseGridSuccResult(objRes) {

    if (objRes) {

        $("#GridResult2").html("");
        AUIGrid.setGridData(GridPurchaseID, []);

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                AUIGrid.setGridData(GridPurchaseID, []);
                fnDefaultAlert(objRes[0].result.ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridPurchaseID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#GridResult2").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridPurchaseID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridPurchaseID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetPurchaseGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "CenterName",
            dataField: "CenterName",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        },
        {
            positionField: "OrgAmt",
            dataField: "OrgAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SupplyAmt",
            dataField: "SupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TaxAmt",
            dataField: "TaxAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "DeductAmt",
            dataField: "DeductAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "InputDeductAmt",
            dataField: "InputDeductAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "DriverInsureAmt",
            dataField: "DriverInsureAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendAmt",
            dataField: "SendAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************/
//그리드 관련 추가
/**********************************************/
// 검색 버튼 클릭
function fnSearchClick2() {
    var dataField = document.getElementById("GridSearchDataField2").value;
    var term = document.getElementById("GridSearchText2").value;

    var options = {
        direction: true, //document.getElementById("direction").checked, // 검색 방향  (true : 다음, false : 이전 검색)
        ChkCaseSensitive: document.getElementById("ChkCaseSensitive2").checked, // 대소문자 구분 여부 (true : 대소문자 구별, false :  무시)
        wholeWord: false, // document.getElementById("wholeWord").checked, // 온전한 단어 여부
        wrapSearch: true // document.getElementById("wrapSearch").checked // 끝에서 되돌리기 여부
    };

    // 검색 실시
    //options 를 지정하지 않으면 기본값이 적용됨(기본값은 direction : true, wrapSearch : true)
    if (dataField == "ALL") {
        AUIGrid.searchAll(GridPurchaseID, term, options);
    } else {
        AUIGrid.search(GridPurchaseID, dataField, term, options);
    }
};

//항목관리 팝업 Open
function fnGridColumnManage2(strGridID) {
    fnGridColumnSetting2("GRID", strGridID);
    $("#GRID_COLUMN_LAYER2").slideDown(500);
}

function fnGridColumnSetting2(obj, strGridID) {
    var ColumnData = fnGetDefaultPurchaseColumnLayout();
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
    $("#GridColumn2").html(ColumnHtml);

    if ($("#GridColumn2 input[type=checkbox]:checked").length === $("#GridColumn2 input[type=checkbox]").length) {
        $("#AllGridColumnCheck2").prop("checked", true);
    } else {
        $("#AllGridColumnCheck2").prop("checked", false);
    }
}

//항목 전체체크/해제
function fnColumnChkAll2(strGridID) {
    var ColumnId = "#GridColumn2";

    if ($("#AllGridColumnCheck2").is(":checked")) {
        $(ColumnId + " input[type=checkbox]").prop("checked", true);
        $.each($(ColumnId + " input[type=checkbox]"), function (index, item) {
            AUIGrid.showColumnByDataField("#" + strGridID, $(item).val());
        });
    } else {
        $(ColumnId + " input[type=checkbox]").prop("checked", false);
        $.each($(ColumnId + " input[type=checkbox]"), function (index, item) {
            AUIGrid.hideColumnByDataField("#" + strGridID, $(item).val());
        });
    }
}

function fnCloseColumnLayout2(strGridID) {

    var GridColumnChangeChecked = false;
    var OriColumnLayout = fnLoadColumnLayout(strGridID, "fnGetDefaultPurchaseColumnLayout()");
    var CurrentColumnLayout = AUIGrid.getColumnLayout("#" + strGridID);

    $.each(CurrentColumnLayout, function (index, item) {
        if (item.viewstatus === true) {
            var itemVisible = typeof (item.visible) === "undefined" ? true : item.visible;

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

    $("#GridColumn2").html("");

    if (GridColumnChangeChecked) {
        fnDefaultConfirm("항목 변경사항이 있습니다. 적용하시겠습니까?", "fnCloseColumnLayoutTrue2", { GridID: strGridID }, "fnCloseColumnLayoutFalse2", { GridID: strGridID });
    } else {
        $("#GRID_COLUMN_LAYER2").hide();
    }
}

function fnCloseColumnLayoutTrue2(objParam) {
    var strGridID = objParam.GridID;
    fnSaveColumnLayout("#" + strGridID, strGridID);
    $("#GRID_COLUMN_LAYER2").hide();
}

function fnCloseColumnLayoutFalse2(objParam) {
    var strGridID = objParam.GridID;
    var ColumnData = $("#GridColumn2 input[type=checkbox]:checked").length;
    var GridColumnChangeLen = $("#GridColumn2 input[type=checkbox]").length;
    var GridColumnChangeChecked = $("#GridColumn2 input[type=checkbox]:checked").length;

    fnGridColumnSetting();
    if (GridColumnChangeChecked > ColumnData) {
        for (var i = 1; i < GridColumnChangeLen; i++) {
            if (!$("#GridColumn2 input[type=checkbox]")[i].checked) {
                AUIGrid.hideColumnByDataField("#" + strGridID, $("#GridColumn2 input[type=checkbox]")[i].value);
            }
        }
    } else {
        for (var j = 0; j < ColumnData; j++) {
            AUIGrid.showColumnByDataField("#" + strGridID, $("#GridColumn2 input[type=checkbox]:checked")[j].value);
        }
    }
    $("#GRID_COLUMN_LAYER2").hide();
}

function fnSaveColumnCustomLayout2(strGridID) {
    fnSaveColumnLayout("#" + strGridID, strGridID);
    $("#GRID_COLUMN_LAYER2").hide();
    $("#GridColumn2").html("");
}
/**********************************************************/

//마감상세
function fnSetDetailList(objItem) {
    fnOpenRightSubLayer("매입 마감 상세", "/TMS/ClosingPurchase/PurchaseClosingDetailList?ClosingCenterCode=" + objItem.CenterCode + "&PurchaseClosingSeqNo=" + objItem.PurchaseClosingSeqNo, "500px", "700px", "80%");
    return false;
}

/**************************************/
//계산서
/**************************************/
function fnOpenBill(objItem) {
    var strPurchaseClosingSeqNo = (typeof objItem.PurchaseClosingSeqNo === "undefined" || objItem.PurchaseClosingSeqNo === null) ? "" : objItem.PurchaseClosingSeqNo;
    var strCenterCode = (typeof objItem.CenterCode === "undefined" || objItem.CenterCode === null) ? "" : objItem.CenterCode;
    var strNtsConfirmNum = (typeof objItem.NtsConfirmNum === "undefined" || objItem.NtsConfirmNum === null) ? "" : objItem.NtsConfirmNum;

    if (strPurchaseClosingSeqNo !== "" && strPurchaseClosingSeqNo != "0" && strCenterCode != "" && strNtsConfirmNum != "") {
        window.open("/TMS/ClosingPurchase/PurchaseClosingBillView?PurchaseClosingSeqNo=" + strPurchaseClosingSeqNo + "&CenterCode=" + strCenterCode + "&NtsConfirmNum=" + strNtsConfirmNum, "계산서보기", "width=1150, height=800, scrollbars=Yes");
        return false;
    } else {
        fnDefaultAlert("계산서를 확인할 수 없습니다.", "info");
        return false;
    }
}
/**************************************/

/**********************************************/
//계좌번호 
/**********************************************/
function fnOpenAcctNo(objItem) {
    $("#PopAcctValidFlag").val("N");
    $("#PopCenterCode").val(objItem.CenterCode);
    $("#PopComCode").val(objItem.ComCode);
    $("#PopComCorpNo").val(objItem.ComCorpNo);
    $("#PopSpanCenterName").text(objItem.CenterName);
    $("#PopSpanComName").text(objItem.ComName);
    $("#PopSpanComCorpNo").text(objItem.ComCorpNo);
    $("#BtnAcctNoChk").show();
    $("#DivAcctNo").show();
    return false;
}

function fnCloseAcctNo() {
    $("#PopAcctValidFlag").val("N");
    $("#PopCenterCode").val("");
    $("#PopComCode").val("");
    $("#PopComCorpNo").val("");
    $("#PopSpanCenterName").text("");
    $("#PopSpanComName").text("");
    $("#PopSpanComCorpNo").text("");
    $("#PopBankCode").val("");
    $("#PopAcctNo").val("");
    $("#PopAcctName").val("");
    $("#PopBankCode option").prop("disabled", false);
    $("#PopAcctNo").removeAttr("readonly");
    $("#PopAcctName").removeAttr("readonly");
    $("#BtnChkAcctNo").show();
    $("#BtnResetAcctNo").hide();
    $("#DivAcctNo").hide();
    return false;
}

function fnResetAcctNo() {
    $("#PopAcctValidFlag").val("N");
    $("#PopBankCode").val("");
    $("#PopAcctNo").val("");
    $("#PopAcctName").val("");
    $("#PopBankCode option").prop("disabled", false);
    $("#PopAcctNo").removeAttr("readonly");
    $("#PopAcctName").removeAttr("readonly");
    $("#BtnChkAcctNo").show();
    $("#BtnResetAcctNo").hide();
    return false;
}

//계좌확인
function fnChkAcctNo() {
    if (!$("#PopCenterCode").val()) {
        return false;
    }

    if (!$("#PopComCode").val()) {
        return false;
    }

    if (!$("#PopBankCode").val()) {
        fnDefaultAlertFocus("은행을 선택하세요.", "PopBankCode", "warning");
        return false;
    }

    if (!$("#PopAcctNo").val()) {
        fnDefaultAlertFocus("계좌번호를 입력하세요.", "PopAcctNo", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/ClosingPurchasePay/Proc/PayClosingHandler.ashx";
    var strCallBackFunc = "fnChkAcctNoSuccResult";
    var strFailCallBackFunc = "fnChkAcctNoFailResult";

    var objParam = {
        CallType: "ChkAcctNo",
        ComCorpNo: $("#PopComCorpNo").val(),
        AcctNo: $("#PopAcctNo").val(),
        BankCode: $("#PopBankCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnChkAcctNoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode == 0) {
            fnDefaultAlert("계좌가 확인되었습니다.", "info");
            $("#PopAcctValidFlag").val("Y");
            $("#PopBankCode").val(objRes[0].BankCode);
            $("#PopAcctNo").val(objRes[0].AcctNo);
            $("#PopAcctName").val(objRes[0].AcctName);
            $("#PopBankCode option:not(:selected)").prop("disabled", true);
            $("#PopAcctNo").prop("readonly", true);
            $("#PopAcctName").prop("readonly", true);
            $("#BtnChkAcctNo").hide();
            $("#BtnResetAcctNo").show();
            return false;
        } else {
            fnChkAcctNoFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnChkAcctNoFailResult();
        return false;
    }
}

function fnChkAcctNoFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//계좌등록
function fnRegAcctNo() {
    if (!$("#PopCenterCode").val()) {
        return false;
    }

    if (!$("#PopComCode").val()) {
        return false;
    }

    if (!$("#PopBankCode").val()) {
        return false;
    }

    if (!$("#PopAcctNo").val()) {
        return false;
    }

    if (!$("#PopAcctName").val()) {
        return false;
    }

    if ($("#PopAcctValidFlag").val() !== "Y") {
        fnDefaultAlert("계좌 확인 후 등록할 수 있습니다.", "warning");
        return false;
    }

    fnDefaultConfirm("계좌를 등록 하시겠습니까?", "fnRegAcctNoProc", "");
    return false;
}

function fnRegAcctNoProc() {

    var strHandlerURL = "/TMS/ClosingPurchasePay/Proc/PayClosingHandler.ashx";
    var strCallBackFunc = "fnRegAcctNoProcSuccResult";
    var strFailCallBackFunc = "fnRegAcctNoProcFailResult";

    var objParam = {
        CallType: "CarComAcctUpdate",
        CenterCode: $("#PopCenterCode").val(),
        ComCode: $("#PopComCode").val(),
        ComCorpNo: $("#PopComCorpNo").val(),
        AcctNo: $("#PopAcctNo").val(),
        BankCode: $("#PopBankCode").val(),
        AcctName: $("#PopAcctName").val(),
        AcctValidFlag: $("#PopAcctValidFlag").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnRegAcctNoProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode == 0) {
            var objRows = AUIGrid.getGridData(GridPurchaseID);
            $.each(objRows, function (index, item) {
                if (item.ComCode == $("#PopComCode").val() && item.CenterCode == $("#PopCenterCode").val()) {
                    var upditem = {
                        ComCode: $("#PopComCode").val(),
                        CenterCode: $("#PopCenterCode").val(),
                        SearchAcctNo: $("#PopAcctNo").val().substr($("#PopAcctNo").val().length - 4, 4),
                        EncAcctNo: objRes[0].EncAcctNo,
                        AcctName: $("#PopAcctName").val(),
                        BankCode: $("#PopBankCode").val(),
                        BankName: $("#PopBankCode option:selected").text(),
                        AcctValidFlag: "Y",
                        PurchaseClosingSeqNo: item.PurchaseClosingSeqNo
                    }
                    AUIGrid.updateRowsById(GridPurchaseID, upditem);
                }
            });

            fnDefaultAlert("계좌가 등록되었습니다.", "info", "fnCloseAcctNo()");
            return false;
        } else {
            fnRegAcctNoProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegAcctNoProcFailResult();
        return false;
    }
}

function fnRegAcctNoProcFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}
/**********************************************/

/**********************************************/
//송금신청
/**********************************************/
var ClosingList = null;
var ClosingCnt = 0;
var ClosingProcCnt = 0;
var ClosingSuccessCnt = 0;
var ClosingFailCnt = 0;
var ClosingResultMsg = "";
function fnSendPay() {

    ClosingList = [];

    var CheckedItems = AUIGrid.getCheckedRowItems(GridPurchaseID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 마감 전표가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (!(item.item.SendStatus == 2 || item.item.SendStatus == 3)) {
            if (ClosingList.findIndex((e) => e.PurchaseClosingSeqNo === item.item.PurchaseClosingSeqNo) === -1) {
                cnt++;
                ClosingList.push(item.item);
            }
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("카고페이에 송금 신청을 할 수 있는 전표가 없습니다.", "warning");
        return false;
    }

    ClosingCnt = ClosingList.length;
    ClosingProcCnt = 0;
    ClosingSuccessCnt = 0;
    ClosingFailCnt = 0;
    ClosingResultMsg = "";
    fnDefaultConfirm("송금 신청을 하시겠습니까?", "fnSendPayProc", "");
    return false;
}

function fnSendPayProc() {

    $("#divLoadingImage").show();

    if (ClosingProcCnt >= ClosingCnt) {
        $("#divLoadingImage").hide();
        fnSendPayEnd();
        return false;
    }

    var RowClosing = ClosingList[ClosingProcCnt];
    if (RowClosing) {
        var strHandlerURL = "/TMS/ClosingPurchasePay/Proc/PayClosingHandler.ashx";
        var strCallBackFunc = "fnSendPaySuccResult";
        var strFailCallBackFunc = "fnSendPayFailResult";
        var objParam = {
            CallType: "PayClosingSendUpdate",
            CenterCode: RowClosing.CenterCode,
            PurchaseClosingSeqNo: RowClosing.PurchaseClosingSeqNo
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnSendPaySuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            if (objRes[0].FailCnt > 0) {
                ClosingFailCnt++;
            } else {
                ClosingSuccessCnt++;
            }
        } else {
            ClosingResultMsg += "<br>" + ClosingList[ClosingProcCnt].PurchaseClosingSeqNo + " : " + objRes[0].ErrMsg;
            ClosingFailCnt++;
        }
    } else {
        ClosingFailCnt++;
    }
    ClosingProcCnt++;
    setTimeout(fnSendPayProc(), 500);
}

function fnSendPayFailResult() {
    ClosingProcCnt++;
    ClosingFailCnt++;
    setTimeout(fnSendPayProc(), 500);
    return false;
}

function fnSendPayEnd() {
    var msg = "총 " + ClosingProcCnt + "건 중 " + ClosingSuccessCnt + "건이 신청되었습니다.";
    if (ClosingResultMsg !== "") {
        msg += ClosingResultMsg;
    }

    fnCallPurchaseGridData(GridPurchaseID);
    fnDefaultAlert(msg, "info");
    return false;
}
/**********************************************/

/**********************************************/
/* 공제금액 등록                              */
/**********************************************/
var GridDeductID = "#PurchaseClosingDeductListGrid";

$(document).ready(function () {
    if ($(GridDeductID).length > 0) {
        // 그리드 초기화
        fnDeductGridInit();
    }
});

function fnDeductGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDeductGridLayout(GridDeductID, "PurchaseClosingSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDeductID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    AUIGrid.resize(GridDeductID, $("#DivDeduct .gridWrap").width(), $("#DivDeduct .gridWrap").height());
}

//기본 레이아웃 세팅
function fnCreateDeductGridLayout(strGID, strRowIdField) {
    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleCells"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = true; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (typeof item.ValidationChk == "string") {
            return item.ValidationChk !== "" ? "aui-grid-no-accept-row-style" : "";
        }
        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultDeductColumnLayout()");
    var objOriLayout = fnGetDefaultDeductColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
}

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultDeductColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PurchaseClosingSeqNo",
            headerText: "전표번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComName",
            headerText: "차량업체명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComCeoName",
            headerText: "대표자명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OrgAmt",
            headerText: "매입합계",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendAmt",
            headerText: "송금예정액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) {
                return item.OrgAmt - item.DeductAmt;
            }
        },
        {
            dataField: "DeductAmt",
            headerText: "총공제금액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "InputDeductAmt",
            headerText: "공제금액",
            editable: true,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = typeof item.ValidationChk == "string" ? item.ValidationChk : "";
                    return str;
                }
            }
        },
        {
            dataField: "DeductReason",
            headerText: "공제사유",
            editable: true,
            width: 150,
            viewstatus: false,
            style: "aui-grid-text-left",
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = typeof item.ValidationChk == "string" ? item.ValidationChk : "";
                    return str;
                }
            }
        },
        {
            dataField: "InsureFlag",
            headerText: "산재보험적용",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DriverInsureAmt",
            headerText: "산재보험료",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        }
        /*숨김필드*/
        , {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }
        , {
            dataField: "ValidationChk",
            headerText: "ValidationChk",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDeductGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "CenterName",
            dataField: "CenterName",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        },
        {
            positionField: "OrgAmt",
            dataField: "OrgAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "DeductAmt",
            dataField: "DeductAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "InputDeductAmt",
            dataField: "InputDeductAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "DriverInsureAmt",
            dataField: "DriverInsureAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendAmt",
            dataField: "SendAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}


//공제금액 등록
function fnOpenDeduct() {
    var CheckedItems = AUIGrid.getCheckedRowItems(GridPurchaseID);
    var ClosingDeductList = [];
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("공제금액을 등록할 내역을 선택해 주세요.", "warning");
        return false;
    }

    $.each(CheckedItems, function (index, item) {
        ClosingDeductList.push(item.item);
    });

    AUIGrid.setGridData(GridDeductID, ClosingDeductList);
    $("#DivDeduct").show();
    AUIGrid.resize(GridDeductID, $("#DivDeduct .gridWrap").width(), $("#DivDeduct .gridWrap").height());
}

//공제금액 적용
var ClosingDeductList = null;
var ClosingDeductCnt = 0;
var ClosingDeductProcCnt = 0;
var ClosingDeductSuccessCnt = 0;
var ClosingDeductFailCnt = 0;
var ClosingDeductResultMsg = "";
function fnUpdDeduct() {
    ClosingDeductList = [];
    var GridItems = AUIGrid.getGridData(GridDeductID);
    var cnt = 0;
    $.each(GridItems, function (index, item) {
        if (AUIGrid.isEditedById(GridDeductID, item.PurchaseClosingSeqNo)) {
            if (item.DeductAmt < 0) {
                cnt++;
                item.ValidationChk = "공제금액은 0보다 작을 수 없습니다.";
                AUIGrid.updateRowsById(GridDeductID, item);
            } else if (item.DeductAmt > 0 && item.DeductAmt > item.OrgAmt) {
                cnt++;
                item.ValidationChk = "공제금액은 매입합계보다 클 수 없습니다.";
                AUIGrid.updateRowsById(GridDeductID, item);
            } else if (item.DeductAmt > 0 && item.DeductReason == "") {
                cnt++;
                item.ValidationChk = "공제사유가 없습니다.";
                AUIGrid.updateRowsById(GridDeductID, item);
            } else {
                item.ValidationChk = "";
                AUIGrid.updateRowsById(GridDeductID, item);
                ClosingDeductList.push(item);
            }
        }
    });

    if (cnt > 0) {
        fnDefaultAlert("등록이 불가능한 공제금액이 있습니다.<br>(공제사유 항목에 마우스 오버 시 사유 확인 가능)", "warning");
        return false;
    }

    ClosingDeductCnt = ClosingDeductList.length;
    ClosingDeductProcCnt = 0;
    ClosingDeductSuccessCnt = 0;
    ClosingDeductFailCnt = 0;
    ClosingDeductResultMsg = "";
    fnDefaultConfirm("공제금액을 적용하시겠습니까?", "fnUpdDeductProc", "");
    return false;
}

function fnUpdDeductProc() {

    $("#divLoadingImage").show();

    if (ClosingDeductProcCnt >= ClosingDeductCnt) {
        $("#divLoadingImage").hide();
        fnUpdDeductEnd();
        return false;
    }

    var RowClosing = ClosingDeductList[ClosingDeductProcCnt];

    if (RowClosing) {
        var strHandlerURL = "/TMS/ClosingPurchasePay/Proc/PayClosingHandler.ashx";
        var strCallBackFunc = "fnUpdDeductSuccResult";
        var strFailCallBackFunc = "fnUpdDeductFailResult";
        var objParam = {
            CallType: "PayClosingDeductUpdate",
            CenterCode: RowClosing.CenterCode,
            PurchaseClosingSeqNo: RowClosing.PurchaseClosingSeqNo,
            InputDeductAmt: RowClosing.InputDeductAmt,
            DeductReason: RowClosing.DeductReason
        };

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnUpdDeductSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            if (objRes[0].FailCnt > 0) {
                ClosingDeductFailCnt++;
            } else {
                ClosingDeductSuccessCnt++;
            }
        } else {
            ClosingDeductResultMsg += "<br>" + ClosingDeductList[ClosingDeductProcCnt].PurchaseClosingSeqNo + " : " + objRes[0].ErrMsg;
            ClosingDeductFailCnt++;
        }
    } else {
        ClosingDeductFailCnt++;
    }
    ClosingDeductProcCnt++;
    setTimeout(fnUpdDeductProc(), 500);
}

function fnUpdDeductFailResult() {
    ClosingDeductProcCnt++;
    ClosingDeductFailCnt++;
    setTimeout(fnUpdDeductProc(), 500);
    return false;
}

function fnUpdDeductEnd() {
    var msg = "총 " + ClosingDeductProcCnt + "건 중 " + ClosingDeductSuccessCnt + "건이 적용되었습니다.";
    if (ClosingDeductResultMsg !== "") {
        msg += ClosingDeductResultMsg;
    }
    fnCallPurchaseGridData(GridPurchaseID);
    fnDefaultAlert(msg, "info", "fnCloseDeduct()");
    return false;
}

//공제금액 닫기
function fnCloseDeduct() {
    AUIGrid.setGridData(GridDeductID, []);
    $("#DivDeduct").hide();
}
/**********************************************/