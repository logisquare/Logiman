window.name = "SaleClosingListGrid";
// 그리드
var GridID = "#SaleClosingListGrid";
var GridSort = [];

$(document).ready(function () {

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

    $("#BillWrite").datepicker({
        dateFormat: "yy-mm-dd"
    });

    $("#BillYMD").datepicker({
        dateFormat: "yy-mm-dd"
    });

    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
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

    //업무담당
    if ($("#CsAdminName").length > 0) {
        fnSetAutocomplete({
            formId: "CsAdminName",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/ClosingSale/Proc/SaleClosingHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientCsList",
                    CenterCode: $("#CenterCode").val(),
                    CsAdminType: 1,
                    CsAdminName: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "CsAdminName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.CsAdminName + " (" + item.CsAdminID + ")",
                getValue: (item) => item.CsAdminName,
                onSelect: (event, ui) => {
                    $("#CsAdminID").val(ui.item.etc.CsAdminID);
                    $("#CsAdminName").val(ui.item.etc.CsAdminName);
                },
                onBlur: () => {
                    if (!$("#CsAdminName").val()) {
                        $("#CsAdminID").val("");
                    }
                }
            }
        });
    }
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "SaleClosingSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 205;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 205);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 205);
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
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    objGridProps.nullsLastOnSorting = false; //빈값 상단 정렬

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        /*
        if (AUIGrid.isCheckedRowById(GridID, item.OrderNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.BondedFlag === "Y" && item.OrderStatusM !== "등록") {
            return "aui-grid-bonded-y-row-style";
        } else if (item.BondedFlag === "Y" && item.OrderStatusM === "등록") {
            return "aui-grid-bonded-y-no-accept-row-style";
        } else if (item.BondedFlag !== "Y" && item.OrderStatusM === "등록") {
            return "aui-grid-no-accept-row-style";
        }
        */

        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'SaleClosingListGrid');
        return;
    });

        // 푸터
        fnSetGridFooter(GridID);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "BtnBillProc",
            headerText: "계산서발행",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                onClick: function (event) {
                    fnProcBill(event.item);
                },
                visibleFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    if (item.ClosingKind === 2 || item.BillKind !== 99) {
                        return false;
                    }
                    return true;
                }
            },
            viewstatus: false
        },
        {
            dataField: "BtnOpenTaxBill",
            headerText: "계산서보기",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText : "계산서보기",
                onClick: function (event) {
                    fnOpenTaxBillDetail(event.item);
                },
                visibleFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    if (typeof item.IssuSeqNo === "undefined" || item.IssuSeqNo == null || item.IssuSeqNo == "") {
                        return false;
                    }
                    return true;
                }
            },
            viewstatus: false
        },
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SaleClosingSeqNo",
            headerText: "전표번호",
            editable: false,
            width: 150,            
            filter: { showIcon: true },
            viewstatus: false
        },
		{
			dataField: "ClientName",
			headerText: "거래처명",
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
            dataField: "ClientCeoName",
            headerText: "대표자명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CsAdminNames",
            headerText: "업무담당",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
		{
			dataField: "OrgAmt",
			headerText: "매출",
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
            dataField: "ClosingKindM",
            headerText: "청구방식",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "BillStatusM",
            headerText: "발행상태",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
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
            dataField: "BillChargeEmail",
            headerText: "계산서수취이메일",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PayStatusM",
            headerText: "카드청구상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PayYMD",
            headerText: "카드청구일",
            editable: false,
            width: 80,
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
            dataField: "Note",
            headerText: "메모",
            editable: true,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BtnRegProc",
            headerText: "메모등록",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "등록",
                onClick: function (event) {
                    fnRegNote(event.item);
                }
            },
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
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientStatus",
            headerText: "ClientStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientClosingType",
            headerText: "ClientClosingType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientTaxKind",
            headerText: "ClientTaxKind",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientPayDay",
            headerText: "ClientPayDay",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientBusinessStatus",
            headerText: "ClientBusinessStatus",
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
            dataField: "BillKind",
            headerText: "BillKind",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClosingKind",
            headerText: "ClosingKind",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PayStatus",
            headerText: "PayStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "IssuSeqNo",
            headerText: "IssuSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PickupYMDFrom",
            headerText: "PickupYMDFrom",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PickupYMDTo",
            headerText: "PickupYMDTo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderCnt",
            headerText: "OrderCnt",
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

    if (strKey.indexOf("Btn") > -1 || strKey === "Note") {
        return;
    }

    fnSetDetailList(objItem);
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

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingHandler.ashx";
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

    var objParam = {
        CallType: "SaleClosingList",
        CenterCode: $("#CenterCode").val(),
        ClosingKind: $("#ClosingKind").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        DeliveryLocationCodes: DLocationCode.join(","),
        CsAdminID: $("#CsAdminID").val(),
        PayClientName: $("#PayClientName").val(),
        ClosingAdminName: $("#ClosingAdminName").val(),
        SaleClosingSeqNo: $("#SearchSaleClosingSeqNo").val(),
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
        AUIGrid.removeAjaxLoader(GridID);
        // 페이징
        fnCreatePagingNavigator();

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
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
            style: "aui-grid-text-right"
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
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

//마감상세
function fnSetDetailList(objItem) {
    fnOpenRightSubLayer("매출 마감 상세", "/TMS/ClosingSale/SaleClosingDetailList?ClosingCenterCode=" + objItem.CenterCode + "&SaleClosingSeqNo=" + objItem.SaleClosingSeqNo, "500px", "700px", "80%");
    return false;
}

//계산서발행내역
function fnOpenTaxList() {
    window.open("/TMS/ClosingSale/SaleClosingTaxBillList?ClosingType=1", "계산서발행현황", "width=1500, height=760, scrollbars=Yes");
    return false;
}

//계산서발행 처리
function fnProcBill(objItem) {
    window.open("/TMS/ClosingSale/SaleClosingTaxBillIns?SaleClosingSeqNo=" + objItem.SaleClosingSeqNo + "&CenterCode=" + objItem.CenterCode , "계산서발행", "width=1150, height=760, scrollbars=Yes");
    return false;
}

/**************************************/
//메모
/**************************************/
//메모 등록
function fnRegNote(objItem) {
    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingHandler.ashx";
    var strCallBackFunc = "fnRegNoteSuccResult";
    var strFailCallBackFunc = "fnRegNoteFailResult";
    var objParam = {
        CallType: "SaleClosingNoteUpdate",
        CenterCode: objItem.CenterCode,
        SaleClosingSeqNo: objItem.SaleClosingSeqNo,
        Note: objItem.Note
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnRegNoteSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("메모가 등록되었습니다.", "info");
            return false;
        } else {
            fnRegNoteFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegNoteFailResult();
        return false;
    }
}

function fnRegNoteFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("메모 등록에 실패했습니다. 나중에 다시 시도해 주세요." + msg);
    return false;
}
/**************************************/

/**************************************/
//별도발행
/**************************************/
var BillEtcList = null;

//별도발행 처리
function fnRegBillEtc() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 마감전표가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var billCnt = 0;
    $.each(CheckedItems, function (index, item) { //미발행, 미발행, 카드마감x
        if (item.item.BillStatus != 1) {
            billCnt++;
        }

        if ($("#CenterCode").val() == item.item.CenterCode && item.item.BillKind == 99 && item.item.BillStatus == 1 && item.item.ClosingKind != 2) {
            cnt++;
        }
    });

    if (billCnt > 0) {
        fnDefaultAlert("계산서가 발행된 전표가 포함되어 있습니다.", "warning");
        return false;
    }

    if (cnt <= 0) {
        fnDefaultAlert("별도 발행할 수 있는 마감전표가 없습니다.", "warning");
        return false;
    }

    $("#DivBillEtc").show();
}

function fnUpdBillEtc() {
    BillEtcList = [];

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() == item.item.CenterCode && item.item.BillKind == 99 && item.item.BillStatus == 1 && item.item.ClosingKind != 2) {
            BillEtcList.push(item.item.SaleClosingSeqNo);
        }
    });

    if (BillEtcList.length <= 0) {
        fnDefaultAlert("별도 발행할 수 있는 마감전표가 없습니다.", "warning");
        return false;
    }

    if (BillEtcList.length > 200) {
        fnDefaultAlert("최대 200건까지 별도 발행할 수 있습니다.", "warning");
        return false;
    }

    if (!$("#BillKind").val()) {
        fnDefaultAlertFocus("계산서 종류를 선택하세요.", "BillKind", "warning");
        return false;
    }

    if (!$("#BillWrite").val()) {
        fnDefaultAlertFocus("계산서 작성일을 입력하세요.", "BillWrite", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingHandler.ashx";
    var strCallBackFunc = "fnUpdBillEtcSuccResult";
    var strFailCallBackFunc = "fnUpdBillEtcFailResult";
    var objParam = {
        CallType: "SaleClosingBillEtcUpdate",
        CenterCode: $("#CenterCode").val(),
        SaleClosingSeqNos: BillEtcList.join(","),
        BillKind: $("#BillKind").val(),
        BillWrite: $("#BillWrite").val(),
        BillYMD: $("#BillYMD").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnUpdBillEtcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("마감전표 별도 발행이 완료되었습니다.", "info");
            fnCloseBillEtc();
            fnCallGridData(GridID);
            return false;
        } else {
            fnUpdBillEtcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnUpdBillEtcFailResult();
        return false;
    }
}

function fnUpdBillEtcFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("별도 발행 등록에 실패했습니다. 나중에 다시 시도해 주세요." + msg);
    return false;
}

function fnCloseBillEtc() {
    $("#BillKind").val("");
    $("#BillWrite").val("");
    $("#BillYMD").val("");
    $("#DivBillEtc").hide();
}

//별도발행 취소 처리
function fnCnlBillEtc() {
    BillEtcList = [];
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    var notBillCnt = 0;
    $.each(CheckedItems, function (index, item) {
        var strNtsConfirmNum = typeof item.item.NtsConfirmNum == "string" ? item.item.NtsConfirmNum : "";

        if (item.item.BillKind == 99 || item.item.BillStatus == 2 || strNtsConfirmNum != "") {
            notBillCnt++;
        }

        if ($("#CenterCode").val() == item.item.CenterCode && item.item.BillKind != 99 && item.item.BillStatus != 2 && strNtsConfirmNum == "" && item.item.ClosingKind == 1) {
            BillEtcList.push(item.item.SaleClosingSeqNo);
        }
    });

    if (notBillCnt > 0) {
        fnDefaultAlert("계산서가 발행되지 않았거나, 카고페이에서 발행된 전표가 포함되어 있습니다.", "warning");
        return false;
    }

    if (BillEtcList.length <= 0) {
        fnDefaultAlert("별도 발행 취소할 수 있는 마감전표가 없습니다.", "warning");
        return false;
    }

    if (BillEtcList.length > 200) {
        fnDefaultAlert("최대 200건까지 별도 발행 취소할 수 있습니다.", "warning");
        return false;
    }

    var strConfMsg = "별도 발행 취소를 진행 하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnCnlBillEtcProc", "");
    return false;
}

function fnCnlBillEtcProc() {
    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingHandler.ashx";
    var strCallBackFunc = "fnCnlBillEtcProcSuccResult";
    var strFailCallBackFunc = "fnCnlBillEtcProcFailResult";
    var objParam = {
        CallType: "SaleClosingBillEtcCancel",
        CenterCode: $("#CenterCode").val(),
        SaleClosingSeqNos: BillEtcList.join(",")
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnCnlBillEtcProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("마감전표 별도 발행 취소가 완료되었습니다.", "info");
            fnCallGridData(GridID);
            return false;
        } else {
            fnCnlBillEtcProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnCnlBillEtcProcFailResult();
        return false;
    }
}

function fnCnlBillEtcProcFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("별도 발행 취소에 실패했습니다. 나중에 다시 시도해 주세요." + msg);
    return false;
}
/**************************************/

function fnOpenTaxBillDetail(objItem) {
    window.open("/TMS/ClosingSale/SaleClosingTaxBillView?IssuSeqNo=" + objItem.IssuSeqNo + "&CenterCode=" + objItem.CenterCode, "계산서보기", "width=1150, height=800, scrollbars=Yes");
    return false;
}

/************************************************/
//발행 취소 처리
function fnCnlBillSU() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#CnlBillSUSaleClosingSeqNos").val()) {
        fnDefaultAlertFocus("발행 취소할 전표번호를 입력하세요.", "CnlSaleClosingSeqNos", "warning");
        return false;
    }

    var strConfMsg = "발행 취소를 진행 하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnCnlBillSUProc", "");
    return false;
}

function fnCnlBillSUProc() {
    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingHandler.ashx";
    var strCallBackFunc = "fnCnlBillSUProcSuccResult";
    var strFailCallBackFunc = "fnCnlBillSUProcFailResult";
    var objParam = {
        CallType: "SaleClosingBillCancelSU",
        CenterCode: $("#CenterCode").val(),
        SaleClosingSeqNos: $("#CnlBillSUSaleClosingSeqNos").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnCnlBillSUProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            var strMsg = "계산서 발행 취소가 완료되었습니다.";
            strMsg += "<br>(총 " + objRes[0].TotalCnt + "건 중 " + objRes[0].CancelCnt + "건)";
            fnDefaultAlert(strMsg, "info");
            fnCallGridData(GridID);
            $("#CnlBillSUSaleClosingSeqNos").val("");
            return false;
        } else {
            fnCnlBillSUProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnCnlBillSUProcFailResult();
        return false;
    }
}

function fnCnlBillSUProcFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("<br>(" + msg + ")");
    fnDefaultAlert("발행 취소에 실패했습니다. 나중에 다시 시도해 주세요." + msg);
    return false;
}

/************************************************/