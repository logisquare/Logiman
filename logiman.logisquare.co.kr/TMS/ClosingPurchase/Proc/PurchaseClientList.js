window.name = "PurchaseClientListGrid";
// 그리드
var GridID = "#PurchaseClientListGrid";
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

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 190);
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 190);
        },
        stop: function (event, ui) {
            var leftWidthPer = ui.size.width / $("div.grid_type_03").width() * 100;
            var rightWidthPer = 100 - leftWidthPer;

            $("div.left").width(leftWidthPer + "%");
            $("li.left").width(leftWidthPer + "%");
            $("div.right").width(rightWidthPer + "%");
            $("li.right").width(rightWidthPer + "%");

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 190);
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 190);

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

    $("#PopBillWrite").datepicker({
        dateFormat: "yy-mm-dd",
        maxDate: GetDateToday("-")
    });
    
    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // Ctrl + F
        if (event.ctrlKey && event.keyCode === 70) {
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
    fnCreateGridLayout(GridID, "ClientCode");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 190;
    AUIGrid.resize(GridID, $("div.left").width() - 5, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 190);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 190);
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
    objGridProps.rowCheckToRadio = true; //체크박스 대신 라디오버튼으로 변환
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(strGID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(strGID, "PurchaseClientListGrid");
        return;
    });

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        if (event.checked) {
            fnSetDetailList(event.item);
        }
    });
};

function fnSetDetailList(objItem) {

    $("#CenterCode").val(objItem.CenterCode);
    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidClientCode").val(objItem.ClientCode);

    var objCheckedRow = AUIGrid.getCheckedRowItems(GridID);
    if (objCheckedRow.ClientCode !== objItem.ClientCode) {
        AUIGrid.setCheckedRowsByValue(GridID, "ClientCode", objItem.ClientCode);
    }

    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val()) {
        return false;
    }

    $("#GridSelectedInfo2").text("");

    AUIGrid.setGridData(GridDetailID, []);

    fnCallDetailGridData(GridDetailID);
}

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClientName",
            headerText: "업체명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClientCorpNo",
            headerText: "사업자번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PurchaseOrgAmt",
            headerText: "매입합계",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
		{
			dataField: "PurchaseSupplyAmt",
			headerText: "공급가액",
			editable: false,
			width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "PurchaseTaxAmt",
            headerText: "부가세",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "PurchaseCnt",
            headerText: "비용건수",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function(rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "ClosingPurchaseCnt",
            headerText: "마감비용건수",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "ClientStatusM",
            headerText: "사업자상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClientPayDay",
            headerText: "결제일",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClientTaxKindM",
            headerText: "과세구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        /*숨김필드*/
        {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
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
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    fnSetDetailList(objItem);
}

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

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    $("#HidCenterCode").val("");
    $("#HidClientCode").val("");
    AUIGrid.setGridData(GridDetailID, []);

    var LocationCode = [];
    var ItemCode = [];

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClientHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            ItemCode.push($(el).val());
        }
    });

    var objParam = {
        CallType: "PurchaseClientList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        ClosingFlag: $("#ClosingFlag").val(),
        ClientName: $("#ClientName").val(),
        ClientCorpNo: $("#ClientCorpNo").val()
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
        $("#GridSelectedInfo2").text("");
        AUIGrid.setGridData(GridID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

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
            positionField: "PurchaseOrgAmt",
            dataField: "PurchaseOrgAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "PurchaseSupplyAmt",
            dataField: "PurchaseSupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "PurchaseTaxAmt",
            dataField: "PurchaseTaxAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "PurchaseCnt",
            dataField: "PurchaseCnt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "ClosingPurchaseCnt",
            dataField: "ClosingPurchaseCnt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/
// 오더 상세 목록 그리드
/**********************************************************/
var GridDetailID = "#PurchaseClientPayListGrid";

$(document).ready(function () {
    if ($(GridDetailID).length > 0) {
        // 그리드 초기화
        fnDetailGridInit();
    }
});

function fnDetailGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDetailGridLayout(GridDetailID, "PurchaseSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDetailID, "", "", "fnDetailGridKeyDown", "fnGridSearchNotFound", "", "", "fnDetailGridCellClick", "fnDetailGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 190;

    AUIGrid.resize(GridDetailID, $("div.right").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 190);

        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 190);
        }, 100);
    });


    // 푸터
    fnSetDetailGridFooter(GridDetailID);
    AUIGrid.setGridData(GridDetailID, []);
}

//기본 레이아웃 세팅
function fnCreateDetailGridLayout(strGID, strRowIdField) {

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

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (AUIGrid.isCheckedRowById(strGID, item.SeqNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.ClosingFlag === "Y") { //마감
            return "aui-grid-closing-y-row-style";
        }

        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDetailDefaultColumnLayout()");
    var objOriLayout = fnGetDetailDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(strGID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(strGID, "PurchaseClientPayListGrid");
        return;
    });

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        fnSetDetailSelectedInfo(event.pid);
        //SetDetailGridChecked(event, event.checked);
    });

    // 전체체크 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowAllChkClick", function (event) {
        fnSetDetailSelectedInfo(event.pid);
    });
};

function fnSetDetailSelectedInfo(strGID) {

    var objCheckedRow = AUIGrid.getCheckedRowItems(strGID);
    var intRowCnt = 0;
    var intOrgAmt = 0;
    var intSupplyAmt = 0;
    var intTaxAmt = 0;
    var strSelectedInfo = "";
    $.each(objCheckedRow, function (index, item) {
        intRowCnt++;
        intOrgAmt += item.item.PurchaseOrgAmt;
        intSupplyAmt += item.item.PurchaseSupplyAmt;
        intTaxAmt += item.item.PurchaseTaxAmt;
    });

    strSelectedInfo = "총 " + intRowCnt + "건 / 매입합계 : " + fnMoneyComma(intOrgAmt) + "원 / 공급가액 : " + fnMoneyComma(intSupplyAmt) + "원 / 부가세 : " + fnMoneyComma(intTaxAmt) + "원";
    $("#GridSelectedInfo2").text(strSelectedInfo);
}

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDetailDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OrderNo",
            headerText: "오더번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClosingFlag",
            headerText: "마감여부",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "BillStatusM",
            headerText: "계산서발행상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PurchaseClosingSeqNo",
            headerText: "전표번호",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (value === "0") {
                    return "";
                }
                return value;
            }
        },
        {
            dataField: "ClosingAdminName",
            headerText: "마감자",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClosingDate",
            headerText: "마감일",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderItemCodeM",
            headerText: "상품",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderLocationCodeM",
            headerText: "사업장",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderClientName",
            headerText: "발주처명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PayClientName",
            headerText: "청구처명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ConsignorName",
            headerText: "화주명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupYMD",
            headerText: "상차요청일",
            editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlace",
            headerText: "상차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetYMD",
            headerText: "하차요청일",
            editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlace",
            headerText: "하차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Length",
            headerText: "총길이",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "Volume",
            headerText: "총수량",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "CBM",
            headerText: "총부피",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "Weight",
            headerText: "총중량",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "PurchaseOrgAmt",
            headerText: "매입합계",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "PurchaseSupplyAmt",
            headerText: "공급가액",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "PurchaseTaxAmt",
            headerText: "부가세",
            editable: false,
            width: 100,
            viewstatus: false,
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
        },
        {
            dataField: "OrderItemCode",
            headerText: "OrderItemCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "BillStatus",
            headerText: "BillStatus",
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
            dataField: "PurchaseSeqNo",
            headerText: "PurchaseSeqNo",
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
function fnDetailGridCellClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridDetailID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return false;
    }

    rowIdField = AUIGrid.getProp(event.pid, "rowIdField"); // rowIdField 얻기
    rowId = eval("objItem." + rowIdField);

    // 이미 체크 선택되었는지 검사
    if (AUIGrid.isCheckedRowById(event.pid, rowId)) {
        // 엑스트라 체크박스 체크해제 추가
        AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
        //SetDetailGridChecked(event, false);
    } else {
        // 엑스트라 체크박스 체크 추가
        AUIGrid.addCheckedRowsByIds(event.pid, rowId);
        //SetDetailGridChecked(event, true);
    }

    fnSetDetailSelectedInfo(event.pid);
}

/*
function SetDetailGridChecked(objEvent, blChecked) {
    var strDispatchSeqNo = objEvent.item.DispatchSeqNo;
    if (blChecked) {
        AUIGrid.addCheckedRowsByValue(objEvent.pid, "DispatchSeqNo", strDispatchSeqNo);
    } else {
        AUIGrid.addUncheckedRowsByValue(objEvent.pid, "DispatchSeqNo", strDispatchSeqNo);
    }
}
*/

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnDetailGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridDetailID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return false;
    }

    if (objItem.ClosingFlag === "Y") {
        fnOpenRightSubLayer("업체 매입 마감 상세", "/TMS/ClosingPurchase/PurchaseClosingClientDetailList?ClosingCenterCode=" + objItem.CenterCode + "&PurchaseClosingSeqNo=" + objItem.PurchaseClosingSeqNo, "500px", "700px", "80%");
        return false;
    }

    fnCommonOpenOrder(objItem);
    return false;
}

// 키 다운 핸들러 - 사용자 정의(페이지 기능별 수정 필요)
function fnDetailGridKeyDown(event) {
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
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDetailGridData(strGID) {

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClientHandler.ashx";
    var strCallBackFunc = "fnDetailGridSuccResult";

    var LocationCode = [];
    var ItemCode = [];

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            ItemCode.push($(el).val());
        }
    });

    var objParam = {
        CallType: "PurchaseClientPayList",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        ClosingFlag: $("#ClosingFlag").val(),
        ClientName: $("#ClientName").val(),
        ClientCorpNo: $("#ClientCorpNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDetailGridSuccResult(objRes) {

    if (objRes) {
        $("#GridResult2").html("");
        AUIGrid.setGridData(GridDetailID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#GridResult2").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridDetailID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridDetailID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDetailGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "CenterName",
        dataField: "CenterName",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    },
    {
        positionField: "Length",
        dataField: "Length",
        operation: "SUM",
        formatString: "#,##0",
        style: "aui-grid-text-right"
    },
    {
        positionField: "Volume",
        dataField: "Volume",
        operation: "SUM",
        formatString: "#,##0",
        style: "aui-grid-text-right"
    },
    {
        positionField: "CBM",
        dataField: "CBM",
        operation: "SUM",
        formatString: "#,##0.##",
        style: "aui-grid-text-right"
    },
    {
        positionField: "Weight",
        dataField: "Weight",
        operation: "SUM",
        formatString: "#,##0.##",
        style: "aui-grid-text-right"
    },
    {
        positionField: "PurchaseOrgAmt",
        dataField: "PurchaseOrgAmt",
        operation: "SUM",
        formatString: "#,##0",
        postfix: "원",
        style: "aui-grid-text-right"
    },
    {
        positionField: "PurchaseSupplyAmt",
        dataField: "PurchaseSupplyAmt",
        operation: "SUM",
        formatString: "#,##0",
        postfix: "원",
        style: "aui-grid-text-right"
    },
    {
        positionField: "PurchaseTaxAmt",
        dataField: "PurchaseTaxAmt",
        operation: "SUM",
        formatString: "#,##0",
        postfix: "원",
        style: "aui-grid-text-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/

//마감
var PurchaseList1 = null;
var PurchaseList2 = null;
var PurchaseList3 = null;
var PurchaseList4 = null;
var PurchaseList5 = null;
var PurchaseOrgAmt = 0;
var PurchaseSupplyAmt = 0;
var PurchaseTaxAmt = 0;

function fnInsClosing() {
    var PurchaseList = [];
    PurchaseList1 = [];
    PurchaseList2 = [];
    PurchaseList3 = [];
    PurchaseList4 = [];
    PurchaseList5 = [];
    PurchaseOrgAmt = 0;
    PurchaseSupplyAmt = 0;
    PurchaseTaxAmt = 0;

    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 비용이 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var arrCnt = 1;
    var closingCnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag == "Y" ){
            closingCnt++;
        }

        if (item.item.ClosingFlag !== "Y" && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidClientCode").val() == item.item.ClientCode) {
            if (PurchaseList.findIndex((e) => e === item.item.PurchaseSeqNo) === -1) {

                if ((eval("PurchaseList" + arrCnt).join(",") + "," + item.item.PurchaseSeqNo).length > 4000) {
                    arrCnt++;
                    if (arrCnt > 5) {
                        fnDefaultAlert("마감할 수 있는 비용 수를 초과하였습니다.", "warning");
                        return false;
                    }
                }

                cnt++;
                PurchaseList.push(item.item.OrderNo);
                eval("PurchaseList" + arrCnt).push(item.item.PurchaseSeqNo);
                PurchaseOrgAmt += item.item.PurchaseOrgAmt;
                PurchaseSupplyAmt += item.item.PurchaseSupplyAmt;
                PurchaseTaxAmt += item.item.PurchaseTaxAmt;
            }
        }
    });

    if (closingCnt > 0) {
        fnDefaultAlert("마감된 비용이 포함되어 있습니다.", "warning");
        return false;
    }

    if (cnt <= 0) {
        fnDefaultAlert("마감할 수 있는 비용이 없습니다.", "warning");
        return false;
    }

    fnDefaultConfirm("선택한 비용을 마감 하시겠습니까?", "fnInsClosingProc", "");
    return false;
}

function fnInsClosingProc() {
    if (PurchaseList1.join(",") === "" && PurchaseList2.join(",") === "" && PurchaseList3.join(",") === "" && PurchaseList4.join(",") === "" && PurchaseList5.join(",") === "") {
        fnDefaultAlert("마감할 수 있는 비용이 없습니다.", "warning");
        return false;
    }

    var DeductAmt = 0;
    var DeductReason = "";

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClientHandler.ashx";
    var strCallBackFunc = "fnInsClosingProcSuccResult";
    var strFailCallBackFunc = "fnInsClosingProcFailResult";
    var objParam = {
        CallType: "PurchaseClosingInsert",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        PurchaseOrgAmt: PurchaseOrgAmt,
        PurchaseSeqNos1: PurchaseList1.join(","),
        PurchaseSeqNos2: PurchaseList2.join(","),
        PurchaseSeqNos3: PurchaseList3.join(","),
        PurchaseSeqNos4: PurchaseList4.join(","),
        PurchaseSeqNos5: PurchaseList5.join(","),
        DeductAmt: DeductAmt,
        DeductReason: DeductReason
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnInsClosingProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("비용이 마감되었습니다.", "info");
            fnCallDetailGridData(GridDetailID);
            return false;
        } else {
            fnInsClosingProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnInsClosingProcFailResult();
        return false;
    }
}

function fnInsClosingProcFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//마감취소
var ClosingList = null;
var ClosingCnt = 0;
var ClosingProcCnt = 0;
var ClosingSuccessCnt = 0;
var ClosingFailCnt = 0;
var ClosingResultMsg = "";

function fnCnlClosing() {
    ClosingList = [];

    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 마감 전표가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var notClosingCnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag != "Y"){
            notClosingCnt++;
        }

        if (item.item.ClosingFlag == "Y" && !(item.item.SendStatus == 2 || item.item.SendStatus == 3) && !(item.item.BillKind == 2 && (item.item.BillStatus == 2 || item.item.BillStatus == 3)) && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidClientCode").val() == item.item.ClientCode) {
            if (ClosingList.findIndex((e) => e.PurchaseClosingSeqNo  === item.item.PurchaseClosingSeqNo) === -1)
            {
                cnt++;
                ClosingList.push(item.item);
            }
        }
    });

    if (notClosingCnt > 0) {
        fnDefaultAlert("미마감된 비용이 포함되어 있습니다.", "warning");
        return false;
    }

    if (cnt <= 0) {
        fnDefaultAlert("마감취소할 수 있는 전표가 없습니다.<br>(송금신청, 송금완료건 불가)", "warning");
        return false;
    }

    ClosingCnt = ClosingList.length;
    ClosingProcCnt = 0;
    ClosingSuccessCnt = 0;
    ClosingFailCnt = 0;
    ClosingResultMsg = "";
    fnDefaultConfirm("마감취소를 진행 하시겠습니까?", "fnCnlClosingProc", "");
    return false;
}

function fnCnlClosingProc() {

    $("#divLoadingImage").show();

    if (ClosingProcCnt >= ClosingCnt) {
        $("#divLoadingImage").hide();
        fnCnlClosingEnd();
        return false;
    }

    var RowClosing = ClosingList[ClosingProcCnt];

    if (RowClosing) {
        var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClientHandler.ashx";
        var strCallBackFunc = "fnCnlClosingSuccResult";
        var strFailCallBackFunc = "fnCnlClosingFailResult";
        var objParam = {
            CallType: "PurchaseClosingCancel",
            CenterCode: RowClosing.CenterCode,
            NtsConfirmNum: RowClosing.NtsConfirmNum,
            PurchaseClosingSeqNo: RowClosing.PurchaseClosingSeqNo
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnCnlClosingSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            ClosingSuccessCnt++;
        } else {
            ClosingResultMsg += "<br>" + ClosingList[ClosingProcCnt].PurchaseClosingSeqNo + " : " + objRes[0].ErrMsg;
            ClosingFailCnt++;
        }
    } else {
        ClosingFailCnt++;
    }
    ClosingProcCnt++;
    setTimeout(fnCnlClosingProc(), 500);
}

function fnCnlClosingFailResult() {
    ClosingProcCnt++;
    ClosingFailCnt++;
    setTimeout(fnCnlClosingProc(), 500);
    return false;
}

function fnCnlClosingEnd() {
    var msg = "총 " + ClosingProcCnt + "건 중 " + ClosingSuccessCnt + "건의 전표가 취소되었습니다.";
    if (ClosingResultMsg !== "") {
        msg += ClosingResultMsg;
    }

    fnCallDetailGridData(GridDetailID);
    fnDefaultAlert(msg, "info");
    return false;
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
        AUIGrid.searchAll(GridDetailID, term, options);
    } else {
        AUIGrid.search(GridDetailID, dataField, term, options);
    }
};

//항목관리 팝업 Open
function fnGridColumnManage2(strGridID) {
    fnGridColumnSetting2("GRID", strGridID);
    $("#GRID_COLUMN_LAYER2").slideDown(500);
}

function fnGridColumnSetting2(obj, strGridID) {
    var ColumnData = fnGetDetailDefaultColumnLayout();
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
            AUIGrid.HideColumnByDataField("#" + strGridID, $(item).val());
        });
    }
}

function fnCloseColumnLayout2(strGridID) {

    var GridColumnChangeChecked = false;
    var OriColumnLayout = fnLoadColumnLayout(strGridID, "fnGetDetailDefaultColumnLayout()");
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
                AUIGrid.HideColumnByDataField("#" + strGridID, $("#GridColumn2 input[type=checkbox]")[i].value);
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
/**********************************************/
