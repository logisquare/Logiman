var GridID = "#DomesticHwaseungInsGrid";
var GridSort = [];
var strCenterCode = "";
var arrStyleMap = [];
var objDefaultItem = "";

$(document).ready(function () {
    /**
     * 폼 이벤트
     */

    //차량번호 검색
    if ($("#SearchCarNo").length > 0) {
        fnSetAutocomplete({
            formId: "SearchCarNo",
            width: 800,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Domestic/Proc/DomesticHwaseungHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "SearchCar",
                    CenterCode: $("#CenterCode").val(),
                    CarNo: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        return false;
                    }

                    if (request.term.length < 4) {
                        fnDefaultAlertFocus("검색어를 4자 이상 입력하세요.", "SearchCarNo", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.CarNo,
                getValue: (item) => item.CarNo,
                onSelect: (event, ui) => {
                    $("#CarCenterCode").val(ui.item.etc.CenterCode);
                    $("#RefSeqNo").val(ui.item.etc.RefSeqNo);
                    $("#CarNo").val(ui.item.etc.CarNo);
                    $("#DriverName").val(ui.item.etc.DriverName);
                    $("#DriverCell").val(ui.item.etc.DriverCell);
                    $("#CarDivTypeM").val(ui.item.etc.CarDivTypeM);
                    $("#SpanDispatchInfo").text(ui.item.etc.DispatchInfo);
                    $("#BtnCarNoReset").show();
                    $("#SearchCarNo").attr("readonly", true);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("CarDispatchRef", ul, item);
                }
            }
        });
    }

    $("#CenterCode").on("click", function () {
        strCenterCode = $(this).val();
    }).on("change", function () {
        if ($(this).val() !== strCenterCode) {
            fnCarNoReset();
            return false;
        }
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

});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "fnGridSelectionChange", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 180;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 180);
        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 180);
        }, 100);
    });

    //그리드에 포커스
    AUIGrid.setFocus(GridID);
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
    objGridProps.fixedColumnCount = 1; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = false; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = true; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = true; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    AUIGrid.bind(GridID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "addRow", "addRowFinish", "pasteBegin", "pasteEnd"], fnGridCellEditingHandler);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "ValidationCheck",
            headerText: "상태",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "NotInField0",
            headerText: "No",
            editable: true,
            width: 60,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupYMD",
            headerText: "일자",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "ConsignorName",
            headerText: "회사",
            editable: true,
            width: 150,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "NotInField1",
            headerText: "고객코드",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "NotInField2",
            headerText: "고객명",
            editable: true,
            width: 150,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DeliveryType",
            headerText: "납품구분",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "NotInField3",
            headerText: "납품처코드",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetPlace",
            headerText: "납품처명",
            editable: true,
            width: 200,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "NotInField4",
            headerText: "하차지",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "NotInField5",
            headerText: "주소",
            editable: true,
            width: 150,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "NotInField6",
            headerText: "조건표 권역",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CarTon",
            headerText: "고정차 톤급",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "DriverCell",
            headerText: "기사휴대폰",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "SaleAmt",
            headerText: "(매출)운임",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "SaleLayoverAmt",
            headerText: "(매출)경유비",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "SaleWaitingAmt",
            headerText: "(매출)대기비",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "SaleWorkingAmt",
            headerText: "(매출)작업비",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "NotInField7",
            headerText: "합계",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "SaleAreaAmt",
            headerText: "(매출)권역비용",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "NotInField8",
            headerText: "합계",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "SaleOilDifferenceAmt",
            headerText: "(매출)유가연동차액",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "NotInField9",
            headerText: "총합계",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "PurchaseAmt",
            headerText: "(매입)운임",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "PurchaseLayoverAmt",
            headerText: "(매입)경유비",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "PurchaseWaitingAmt",
            headerText: "(매입)대기비",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "PurchaseConservationAmt",
            headerText: "(매입)보존비용",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "NotInField10",
            headerText: "합계",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "PurchaseOilAmt",
            headerText: "(매입)유가연동비",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "PurchaseAreaAmt",
            headerText: "(매입)권역비용",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "NotInField11",
            headerText: "합계",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "PurchaseOilDifferenceAmt",
            headerText: "(매입)유가연동차액",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "NotInField12",
            headerText: "총합계",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "NoteInside",
            headerText: "비고",
            editable: true,
            width: 200,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        /*숨김필드*/
        {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderNo",
            headerText: "OrderNo",
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
            dataField: "ConsignorCode",
            headerText: "ConsignorCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PickupPlaceSeqNo",
            headerText: "PickupPlaceSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "GetPlaceSeqNo",
            headerText: "GetPlaceSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CarTonCode",
            headerText: "CarTonCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CarCnt",
            headerText: "CarCnt",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "RefSeqNo",
            headerText: "RefSeqNo",
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

// 셀 선택 변경 이벤트 핸들러
function fnGridSelectionChange(event) {
    if (event.selectedItems.length > 0) {
        var intRowIndex = event.selectedItems[0].rowIndex;
        var intColIndex = event.selectedItems[0].columnIndex;
        if (intColIndex === 0) {
            AUIGrid.setSelectionByIndex(event.pid, intRowIndex, 1);
            return false;
        }
    }
}

function fnGridCellEditingHandler(event) {
    if (event.type === "cellEditBegin") {
        //if (event.isClipboard && (event.columnIndex === 0))
        //    return false;
    } else if (event.type == "cellEditEnd") {
        var item = event.item;
        item.ValidationCheck = "미검증";
        item.CenterCode = 0;
        item.ClientCode = 0;
        item.PickupPlaceSeqNo = 0;

        if (event.oldValue != event.value) {
            if (event.dataField === "ConsignorName" && event.oldValue != event.value) {
                item.ConsignorCode = 0;
            }

            if (event.dataField === "GetPlace" && event.oldValue != event.value) {
                item.GetPlaceSeqNo = 0;
            }

            if (event.dataField === "CarTon" && event.oldValue != event.value) {
                item.CarTonCode = "";
            }
            
            if ((event.dataField === "DeliveryType" || event.dataField === "CarNo" || event.dataField === "DriverName" || event.dataField === "DriverCell")) {
                var strOldValue = typeof event.oldValue === "string" ? event.oldValue : "";
                var strValue = typeof event.value === "string" ? event.value : "";

                if (event.dataField === "DriverCell") {
                    strOldValue = strOldValue.toString().replace(/[^0-9\-]/gi, "");
                    strValue = strValue.toString().replace(/[^0-9\-]/gi, "");
                }

                if (strOldValue !== strValue) {
                    item.CarCnt = 0;
                    item.RefSeqNo = 0;
                }
            }
        }

        AUIGrid.updateRowsById(event.pid, item);

    } else if (event.type === "cellEditEndBefore") {
        var retStr = event.value;
        retStr = retStr.toString().replace(/\t/gi, "");
        retStr = retStr.toString().replace(/\n/gi, "");

        if (event.dataField === "PickupYMD" || event.dataField === "DriverCell") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9\-]/gi, "");
        }

        if (event.dataField === "SaleAmt" || event.dataField === "SaleLayoverAmt" || event.dataField === "SaleWaitingAmt" || event.dataField === "SaleWorkingAmt" || event.dataField === "NotInField8" || event.dataField === "SaleAreaAmt" || event.dataField === "NotInField9" || event.dataField === "SaleOilDifferenceAmt" || event.dataField === "NotInField10") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9]/gi, "");
            if (retStr === "") {
                retStr = "0";
            }
        }

        if (event.dataField === "PurchaseAmt" || event.dataField === "PurchaseLayoverAmt" || event.dataField === "PurchaseWaitingAmt" || event.dataField === "PurchaseConservationAmt" || event.dataField === "NotInField11" || event.dataField === "PurchaseOilAmt" || event.dataField === "PurchaseAreaAmt" || event.dataField === "NotInField12" || event.dataField === "PurchaseOilDifferenceAmt" || event.dataField === "NotInField13") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9]/gi, "");
            if (retStr === "") {
                retStr = "0";
            }
        }

        retStr = retStr.replace(/\t/gi, "");
        retStr = retStr.replace(/\"/gi, "");
        retStr = retStr.replace(/\\/gi, "");
        retStr = retStr.replace(/\xA0/gi, "");

        return retStr;

    } else if (event.type === "addRow") {

        for (i = 0; i < event.items.length; i++) {
            event.items[i].ValidationCheck = "미검증";
            event.items[i].CenterCode = 0;
            event.items[i].OrderNo = 0;
            event.items[i].ClientCode = 0;
            event.items[i].ConsignorCode = 0;
            event.items[i].PickupPlaceSeqNo = 0;
            event.items[i].GetPlaceSeqNo = 0;
            event.items[i].CarTonCode = "";
            event.items[i].CarCnt = 0;
            event.items[i].RefSeqNo = 0;
            AUIGrid.updateRowsById(event.pid, event.items[i]);
        }
        AUIGrid.update(GridID);

    } else if (event.type === "addRowFinish") {

        var arrGridRows = AUIGrid.getGridData(event.pid);
        if (arrGridRows.length > 0) {
            AUIGrid.setSelectionByIndex(event.pid, AUIGrid.getGridData(event.pid).length - 1, 1);
        }

    } else if (event.type === "pasteBegin") {

        var arrData = event.clipboardData.split("\r\n");
        var arrResult = [];
        var arrGridRows = AUIGrid.getGridData(event.pid);
        var arrSelectedItems = AUIGrid.getSelectedItems(event.pid);
        var intSelectedColIndex = arrSelectedItems.length > 0 ? arrSelectedItems[0].columnIndex : -1;

        for (var i = 0; i < arrData.length; i++) {
            if (arrData[i] !== "") {
                arrResult[i] = arrData[i].split("\t");
            }
        }

        if (arrResult.length > 0) {
            if (arrResult[0].length === 35) {
                if (intSelectedColIndex === -1) { //그리드 미선택
                    for (var i = 0; i < arrResult.length; i++) {
                        arrResult[i].unshift("미검증");
                    }
                }
            }
        }

        return arrResult; // 반환되는 값을 붙여넣기 적용함.

    }
};
//---------------------------------------------------------------------------------

// 행 추가
function fnAddRow() {
    var objItem = new Object();
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    objItem.ValidationCheck = "미검증";
    objItem.PickupYMD = "";
    objItem.ConsignorName = "";
    objItem.DeliveryType = "";
    objItem.GetPlace = "";
    objItem.CarTon = "";
    objItem.CarNo = "";
    objItem.DriverName = "";
    objItem.DriverCell = "";
    objItem.SaleAmt = 0;
    objItem.SaleLayoverAmt = 0;
    objItem.SaleWaitingAmt = 0;
    objItem.SaleWorkingAmt = 0;
    objItem.NotInField8 = 0;
    objItem.SaleAreaAmt = 0;
    objItem.NotInField9 = 0;
    objItem.SaleOilDifferenceAmt = 0;
    objItem.NotInField10 = 0;
    objItem.PurchaseAmt = 0;
    objItem.PurchaseLayoverAmt = 0;
    objItem.PurchaseWaitingAmt = 0;
    objItem.PurchaseConservationAmt = 0;
    objItem.NotInField11 = 0;
    objItem.PurchaseOilAmt = 0;
    objItem.PurchaseAreaAmt = 0;
    objItem.NotInField12 = 0;
    objItem.PurchaseOilDifferenceAmt = 0;
    objItem.NotInField13 = 0;
    objItem.CenterCode = 0;
    objItem.OrderNo = 0;
    objItem.ClientCode = 0;
    objItem.ConsignorCode = 0;
    objItem.PickupPlaceSeqNo = 0;
    objItem.GetPlaceSeqNo = 0;
    objItem.CarTonCode  = "";
    objItem.CarCnt = 0;
    objItem.RefSeqNo = 0;
    AUIGrid.addRow(GridID, objItem, "last");
}

// 행 삭제
function fnRemoveRow() {
    var objSelectedItems = AUIGrid.getSelectedItems(GridID);
    if (objSelectedItems.length <= 0) return;
    $.each(objSelectedItems, function (index, item) {
        AUIGrid.removeRowByRowId(GridID, item.item.SeqNo);
    });
}

// 미검증 행 삭제
function fnDelNoValidationRow() {
    var objGridData = AUIGrid.getGridData(GridID);
    var objSelectedItems = objGridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("미검증") !== -1) return true;
        return false;
    });
    if (objSelectedItems.length <= 0) return false;
    $.each(objSelectedItems, function (index, item) {
        AUIGrid.removeRowByRowId(GridID, item.SeqNo);
    });
}


// 등록 행 삭제
function fnDelSuccRow() {
    var objSelectedItems = AUIGrid.getItemsByValue(GridID, "ValidationCheck", "등록");
    if (objSelectedItems.length <= 0) return false;

    $.each(objSelectedItems, function (index, item) {
        AUIGrid.removeRowByRowId(GridID, item.SeqNo);
    });
}

// 실패 행 삭제
function fnDelFailRow() {
    var objGridData = AUIGrid.getGridData(GridID);
    var objSelectedItems = objGridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("실패") !== -1) return true;
        return false;
    });
    if (objSelectedItems.length <= 0) return false;
    $.each(objSelectedItems, function (index, item) {
        AUIGrid.removeRowByRowId(GridID, item.SeqNo);
    });
}

//화면 초기화
function fnResetAll() {
    AUIGrid.setGridData(GridID, []);
    fnCarNoReset();
}

/***********************************/
//오더 등록
/***********************************/
var RegList = null;
var RegCnt = 0;
var RegProcCnt = 0;
var RegSuccessCnt = 0;
var RegFailCnt = 0;
function fnRegOrder() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    RegList = [];
    var objGridData = AUIGrid.getGridData(GridID);
    // 원하는 결과로 필터링
    RegList = objGridData.filter(function (v) {
        if (String(v.ValidationCheck) === "검증" && $("#CenterCode").val() == v.CenterCode) return true;
        return false;
    });

    RegCnt = RegList.length;
    RegProcCnt = 0;
    RegSuccessCnt = 0;
    RegFailCnt = 0;

    if (RegCnt === 0) {
        fnDefaultAlert("검증된 정보가 없습니다.", "warning");
        return false;
    }

    var strConfMsg = "오더 등록을 하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnRegOrderProc", "");
    return false;
}

function fnRegOrderProc() {

    AUIGrid.showAjaxLoader(GridID);

    if (RegProcCnt >= RegCnt) {
        AUIGrid.removeAjaxLoader(GridID);

        if (RegFailCnt > 0) {
            fnDefaultAlert("일부 정보만 오더 등록이 완료되었습니다.<br>[총 " + RegCnt + "건 중 " + RegFailCnt + "건]", "warning");
        } else {
            fnDefaultAlert("모든 정보가 오더 등록이 완료되었습니다.<br>[총 " + RegCnt + "건]", "success");
        }
        return false;
    }

    var objRowItem = RegList[RegProcCnt];

    if (objRowItem) {
        var strHandlerUrl = "/TMS/Domestic/Proc/DomesticHwaseungHandler.ashx";
        var strCallBackFunc = "fnRegOrderSuccResult";
        var strFailCallBackFunc = "fnRegOrderFailResult";
        var objParam = {
            CallType: "OrderInsert",
            CenterCode: objRowItem.CenterCode,
            OrderClientCode: objRowItem.ClientCode,
            PayClientCode: objRowItem.ClientCode,
            ConsignorCode: objRowItem.ConsignorCode,
            DeliveryType: objRowItem.DeliveryType,
            PickupYMD: objRowItem.PickupYMD,
            PickupPlaceSeqNo: objRowItem.PickupPlaceSeqNo,
            GetYMD: objRowItem.PickupYMD,
            GetPlaceSeqNo: objRowItem.GetPlaceSeqNo,
            NoteInside: objRowItem.NoteInside,
            CarTonCode: objRowItem.CarTonCode,
            RefSeqNo: objRowItem.RefSeqNo,
            SaleAmt: objRowItem.SaleAmt,
            SaleLayoverAmt: objRowItem.SaleLayoverAmt,
            SaleWaitingAmt: objRowItem.SaleWaitingAmt,
            SaleWorkingAmt: objRowItem.SaleWorkingAmt,
            SaleAreaAmt: objRowItem.SaleAreaAmt,
            SaleOilDifferenceAmt: objRowItem.SaleOilDifferenceAmt,
            PurchaseAmt: objRowItem.PurchaseAmt,
            PurchaseLayoverAmt: objRowItem.PurchaseLayoverAmt,
            PurchaseWaitingAmt: objRowItem.PurchaseWaitingAmt,
            PurchaseConservationAmt: objRowItem.PurchaseConservationAmt,
            PurchaseOilAmt: objRowItem.PurchaseOilAmt,
            PurchaseAreaAmt: objRowItem.PurchaseAreaAmt,
            PurchaseOilDifferenceAmt: objRowItem.PurchaseOilDifferenceAmt
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, false, strFailCallBackFunc, "", true);
        return false;
    } else {
        fnRegOrderFailResult();
        return false;
    }
}

function fnRegOrderSuccResult(objRes) {
    var objRowItem = RegList[RegProcCnt];
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            RegProcCnt++;
            RegSuccessCnt++;
            objRowItem.ValidationCheck = "등록";
            objRowItem.OrderNo = objRes[0].OrderNo;
        } else {
            RegProcCnt++;
            RegFailCnt++;
            objRowItem.ValidationCheck = "실패 [사유:" + objRes[0].ErrMsg + "]";
        }
    } else {
        RegProcCnt++;
        RegFailCnt++;
        objRowItem.ValidationCheck = "실패";
    }

    AUIGrid.updateRowsById(GridID, objRowItem);
    setTimeout(fnRegOrderProc(), 200);
}

function fnRegOrderFailResult() {
    var objRowItem = RegList[RegProcCnt];
    RegProcCnt++;
    RegFailCnt++;
    objRowItem.ValidationCheck = "실패";
    AUIGrid.updateRowsById(GridID, objRowItem);
    setTimeout(fnRegOrderProc(), 200);
    return false;
}
/***********************************/

//검증
var ValidationList = null;
var ValidationCnt = 0;
var ValidationProcCnt = 0;
var ValidationSuccessCnt = 0;
var ValidationFailCnt = 0;
function fnValidationRow() {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return false;
    }

    if (!fnValidationData()) {
        fnDefaultAlert("올바르지 않은 정보가 있습니다.", "warning");
        return false;
    }

    ValidationList = [];

    var objGridData = AUIGrid.getGridData(GridID);
    // 원하는 결과로 필터링
    ValidationList = objGridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("미검증") !== -1) return true;
        return false;
    });

    ValidationCnt = ValidationList.length;
    ValidationProcCnt = 0;
    ValidationSuccessCnt = 0;
    ValidationFailCnt = 0;
    fnValidationRowProc();
}

function fnValidationRowProc() {
    AUIGrid.showAjaxLoader(GridID);
    if (ValidationProcCnt >= ValidationCnt) {
        AUIGrid.removeAjaxLoader(GridID);
        fnDefaultAlert("정보 검증이 완료되었습니다.", "info");
        return false;
    }

    var objRowItem = ValidationList[ValidationProcCnt];
    if (objRowItem) {

        var strHandlerUrl = "/TMS/Domestic/Proc/DomesticHwaseungHandler.ashx";
        var strCallBackFunc = "fnValidationRowSuccResult";
        var strFailCallBackFunc = "fnValidationRowFailResult";
        var objParam = {
            CallType: "OrderChk",
            CenterCode: $("#CenterCode").val() ,
            ConsignorName: objRowItem.ConsignorName,
            DeliveryType: objRowItem.DeliveryType,
            PickupYMD: objRowItem.PickupYMD,
            GetPlace: objRowItem.GetPlace,
            CarTon: objRowItem.CarTon,
            CarNo: objRowItem.CarNo,
            DriverName: objRowItem.DriverName,
            DriverCell: objRowItem.DriverCell,
            RefSeqNo: objRowItem.RefSeqNo
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, false, strFailCallBackFunc, "", true);
        return false;

    } else {
        fnValidationRowFailResult();
        return false;
    }
}

function fnValidationRowSuccResult(objRes) {
    var objRowItem = ValidationList[ValidationProcCnt];
    var strResultMsg = "";

    if (objRes) {
        if (objRes[0].RetCode === 0) {
            ValidationProcCnt++;
            ValidationSuccessCnt++;

            if (objRes[0].CenterFlag !== "Y") {
                strResultMsg = "회원사 정보가 올바르지 않습니다.";
            } else if (objRes[0].AuthFlag !== "Y") {
                strResultMsg = "오더 등록 권한이 없습니다.";
            } else if (objRes[0].ClientFlag !== "Y") {
                strResultMsg = "고객사 정보가 없습니다.";
            } else if (objRes[0].PickupYMDFlag !== "Y") {
                strResultMsg = "일자가 올바르지 않습니다.";
            } else if (objRes[0].ConsignorFlag !== "Y") {
                strResultMsg = "회사 정보가 없습니다.";
            } else if (objRes[0].PickupPlaceFlag !== "Y") {
                strResultMsg = "상차지 정보가 없습니다.";
            } else if (objRes[0].GetPlaceFlag !== "Y") {
                strResultMsg = "납품처 정보가 없습니다.";
            } else if (objRes[0].CarTonFlag !== "Y") {
                strResultMsg = "고정차 톤급 정보가 올바르지 않습니다.";
            } else if (objRes[0].CarFlag !== "Y") {
                if (objRes[0].CarCnt > 1) {
                    strResultMsg = "차량 정보가 1대이상 조회되었습니다.";
                } else {
                    strResultMsg = "차량 정보가 없습니다.";
                }
            }


            if (strResultMsg !== "") {
                objRowItem.ValidationCheck = "미검증 [" + strResultMsg + "]";
            } else {
                objRowItem.ValidationCheck = "검증";
                objRowItem.CenterCode = objRes[0].CenterCode;
                objRowItem.ClientCode = objRes[0].ClientCode;
                objRowItem.ConsignorCode = objRes[0].ConsignorCode;
                objRowItem.PickupPlaceSeqNo = objRes[0].PickupPlaceSeqNo;
                objRowItem.GetPlaceSeqNo = objRes[0].GetPlaceSeqNo;
                objRowItem.CarTonCode = objRes[0].CarTonCode;
                objRowItem.CarCnt = objRes[0].CarCnt;
                objRowItem.RefSeqNo = objRes[0].RefSeqNo;
            }
        } else {
            ValidationProcCnt++;
            ValidationFailCnt++;
            objRowItem.ValidationCheck = "미검증 [사유:" + objRes[0].ErrMsg + "]";
        }
    } else {
        ValidationProcCnt++;
        ValidationFailCnt++;
        objRowItem.ValidationCheck = "미검증";
    }
    AUIGrid.updateRowsById(GridID, objRowItem);
    setTimeout(fnValidationRowProc(), 200);
    return false;
}

function fnValidationRowFailResult() {
    var objRowItem = ValidationList[ValidationProcCnt];
    ValidationProcCnt++;
    ValidationFailCnt++;
    objRowItem.ValidationCheck = "미검증";
    AUIGrid.updateRowsById(GridID, objRowItem);
    setTimeout(fnValidationRowProc(), 200);
    return false;
}

function fnValidationData() {
    var intChkCnt = 0;
    var intRowIndex = 0;

    var objGridData = AUIGrid.getGridData(GridID);
    var objItems = objGridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("미검증") !== -1 || String(v.ValidationCheck).indexOf("실패") !== -1) return true;
        return false;
    });

    var strMsg = "";
    arrStyleMap = [];

    for (i = 0; i < objItems.length; i++) {
        intChkCnt = 0;
        strMsg = "";
        intRowIndex = AUIGrid.rowIdToIndex(GridID, objItems[i].SeqNo);

        var strPickupYMD = typeof objItems[i].PickupYMD === "undefined" || objItems[i].PickupYMD == null ? "" : objItems[i].PickupYMD;
        if (strPickupYMD == "") {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "PickupYMD");
            strMsg += "일자 정보가 없습니다.";
        }

        var strConsignorName = typeof objItems[i].ConsignorName === "undefined" || objItems[i].ConsignorName == null ? "" : objItems[i].ConsignorName;
        if (strConsignorName == "") {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "ConsignorName");
            strMsg += strMsg === "" ? "회사 정보가 없습니다." : " / " + "회사 정보가 없습니다.";
        }

        var strDeliveryType = typeof objItems[i].DeliveryType === "undefined" || objItems[i].DeliveryType == null ? "" : objItems[i].DeliveryType;
        if (strDeliveryType == "") {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "DeliveryType");
            strMsg += strMsg === "" ? "납품구분 정보가 없습니다." : " / " + "납품구분 정보가 없습니다.";
        }

        if (strDeliveryType != "정규" && strDeliveryType != "용차") {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "DeliveryType");
            strMsg += strMsg === "" ? "납품구분 정보가 올바르지 않습니다." : " / " + "납품구분 정보가 올바르지 않습니다.";
        }

        var strGetPlace = typeof objItems[i].GetPlace === "undefined" || objItems[i].GetPlace == null ? "" : objItems[i].GetPlace;
        if (strGetPlace == "") {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "GetPlace");
            strMsg += strMsg === "" ? "납품처명 정보가 없습니다." : " / " + "납품처명 정보가 없습니다.";
        }

        var strCarTon = typeof objItems[i].CarTon === "undefined" || objItems[i].CarTon == null ? "" : objItems[i].CarTon;
        if (strCarTon == "") {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "CarTon");
            strMsg += strMsg === "" ? "고정차 톤급 정보가 없습니다." : " / " + "고정차 톤급 정보가 없습니다.";
        }

        var strCarNo = typeof objItems[i].CarNo === "undefined" || objItems[i].CarNo == null ? "" : objItems[i].CarNo;
        if (strCarNo == "") {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "CarNo");
            strMsg += strMsg === "" ? "차량번호 정보가 없습니다." : " / " + "차량번호 정보가 없습니다.";
        }

        var strDriverName = typeof objItems[i].DriverName === "undefined" || objItems[i].DriverName == null ? "" : objItems[i].DriverName;
        if (strDriverName == "") {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "DriverName");
            strMsg += strMsg === "" ? "기사명 정보가 없습니다." : " / " + "기사명 정보가 없습니다.";
        }

        var strDriverCell = typeof objItems[i].DriverCell === "undefined" || objItems[i].DriverCell == null ? "" : objItems[i].DriverCell;
        if (strDriverCell == "") {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "DriverCell");
            strMsg += strMsg === "" ? "기사휴대폰 정보가 없습니다." : " / " + "기사휴대폰 정보가 없습니다.";
        }

        var strSaleAmt = typeof objItems[i].SaleAmt === "undefined" || objItems[i].SaleAmt == null ? "0" : objItems[i].SaleAmt;
        strSaleAmt = strSaleAmt.toString();

        if (!$.isNumeric(strSaleAmt)) {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "SaleAmt");
            strMsg += strMsg === "" ? "매출 운임 정보가 올바르지 않습니다." : " / " + "매출 운임 정보가 올바르지 않습니다.";
        }

        if (strSaleAmt === "" || parseInt(strSaleAmt) <= 0) {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "SaleAmt");
            strMsg += strMsg === "" ? "매출 운임 정보가 없습니다." : " / " + "매출 운임 정보가 없습니다.";
        }

        var strPurchaseAmt = typeof objItems[i].PurchaseAmt === "undefined" || objItems[i].PurchaseAmt == null ? "0" : objItems[i].PurchaseAmt;
        strPurchaseAmt = strPurchaseAmt.toString();

        if (!$.isNumeric(strPurchaseAmt)) {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "PurchaseAmt");
            strMsg += strMsg === "" ? "매입 운임 정보가 올바르지 않습니다." : " / " + "매입 운임 정보가 올바르지 않습니다.";
        }

        //if (strPurchaseAmt === "" || parseInt(strPurchaseAmt) <= 0) {
        //    intChkCnt++;
        //    fnChangeStyleFunction(intRowIndex, "PurchaseAmt");
        //    strMsg += strMsg === "" ? "매입 운임 정보가 없습니다." : " / " + "매입 운임 정보가 없습니다.";
        //}

        if (intChkCnt === 0) {
            strMsg = "미검증";
        } else {
            strMsg = "미검증 [" + strMsg + "]";
        }
        objItems[i].ValidationCheck = strMsg;
        AUIGrid.updateRowsById(GridID, objItems[i]);
    }

    AUIGrid.update(GridID);
    AUIGrid.removeAjaxLoader(GridID);
    return strMsg === "미검증";
}

function fnChangeStyleFunction(rowIndex, datafield) {
    var key = rowIndex + "-" + datafield;
    arrStyleMap[key] = "error-column-style";
};

// 셀 스타일 함수
function fnCellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField) {
    var key = rowIndex + "-" + dataField;
    if (typeof arrStyleMap[key] != "undefined") {
        return arrStyleMap[key];
    }
    return null;
};


//차량검색 폼 리셋
function fnCarNoReset() {
    $("#BtnCarNoReset").hide();
    $("#CarCenterCode").val("");
    $("#RefSeqNo").val("");
    $("#CarNo").val("");
    $("#DriverName").val("");
    $("#DriverCell").val("");
    $("#CarDivTypeM").val("");
    $("#SpanDispatchInfo").text("");
    $("#SearchCarNo").val("");
    $("#SearchCarNo").removeAttr("readonly");
    $("#SearchCarNo").focus();
    return false;
}

//차량 적용
function fnCarNoSet() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#RefSeqNo").val()) {
        fnDefaultAlertFocus("차량을 검색하세요.", "SearchCarNo", "warning");
        return false;
    }

    if ($("#CenterCode").val() != $("#CarCenterCode").val()) {
        fnDefaultAlert("선택한 회원사와 차량의 회원사가 다릅니다. 차량을 다시 검색하세요.", "warning", "fnCarNoReset()");
        return false;
    }

    var intTotalCnt = 0;
    var intSetCnt = 0;
    var objCheckedRow = AUIGrid.getCheckedRowItems(GridID);
    if (objCheckedRow.length < 1) {
        fnDefaultAlert("적용할 정보를 선택하세요.", "warning");
        return false;
    }

    intTotalCnt = objCheckedRow.length;

    $.each(objCheckedRow, function (index, objItem) {
        if (($("#CarDivTypeM").val() === "단기" && objItem.item.DeliveryType === "용차") || ($("#CarDivTypeM").val() === "고정" && objItem.item.DeliveryType === "정규")) {
            objItem.item.ValidationCheck = "미검증";
            objItem.item.RefSeqNo = $("#RefSeqNo").val();
            objItem.item.CarNo = $("#CarNo").val();
            objItem.item.DriverName = $("#DriverName").val();
            objItem.item.DriverCell = $("#DriverCell").val();
            AUIGrid.updateRowsById(GridID, objItem.item);
            intSetCnt++;
        }
    });

    fnDefaultAlert("차량이 적용되었습니다.<br>[총 " + intTotalCnt + "건 중 " + intSetCnt + "건]", "warning");
    return false;
}