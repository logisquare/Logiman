window.name = "InoutEIListGrid";
// 그리드
var GridID = "#InoutEIListGrid";
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


    $("#ActualPickupYMD").datepicker({
        dateFormat: "yy-mm-dd"
    });

    $("#ActualDeliveryYMD").datepicker({
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

    // 그리드 초기화
    fnEIEquipmentGridInit();

    // 그리드 초기화
    fnEIStopGridInit();

    fnSetLayoutSize();

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

    // 브라우저 리사이징
    $(window).on("resize", function () {
        fnSetLayoutSize();
        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            fnSetLayoutSize();
        }, 100);
    });
});

function fnSetLayoutSize() {
    var intHeight = $("#contents").height() - 20;
    intHeight -= $(".data_list").height() + 10;
    intHeight = intHeight < 400 ? 400 : intHeight;

    $(".grid_wrap").height(intHeight);

    var intGridHeight = $(".grid_wrap").height();
    intGridHeight -= $(".grid_option").height() + 18;
    var intGridWidth = $(".grid_left").width();
    AUIGrid.resize(GridID, intGridWidth, intGridHeight);

    intGridWidth = $(".equipment_wrap").width();
    AUIGrid.resize(GridEIEquipmentID, intGridWidth, 170);

    intGridWidth = $(".stop_wrap").width();
    AUIGrid.resize(GridEIStopID, intGridWidth, 170);
}

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "OrderNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    //그리드에 포커스
    AUIGrid.setFocus(GridID);

    // 푸터
    fnSetGridFooter(GridID);
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
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (item.WorkOrderStatusM == "Create") {
            return "aui-grid-no-accept-row-style";
        } else if (item.WorkOrderStatusM == "Reject") {
            return "aui-grid-no-edit-row-style";
        }

        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "SelectedView",
            headerText: "",
            editable: false,
            width: 25,
            viewstatus: false,
            styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                if (item.SelectedFlag === "Y") {
                    return "my-cell-style";
                }
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = "";
                if (item.SelectedFlag === "Y") {
                    strValue = "▶";
                }
                return strValue;
            }
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
            dataField: "OrderNo",
            headerText: "오더번호",
            editable: false,
            width: 150,
            dataType: "string",
            filter: { showIcon: true },
            viewstatus: false,
            styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                if (item.SelectedFlag === "Y") {
                    return "my-cell-style";
                }
            }
        },
        {
            dataField: "AcceptDate",
            headerText: "접수일",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "AcceptAdminName",
            headerText: "접수자명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OrderStatusM",
            headerText: "오더상태",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false,
            styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                if (item.SelectedFlag === "Y") {
                    return "my-cell-style";
                }
            }
        },
        {
            dataField: "WorkOrderStatusM",
            headerText: "연동오더상태",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false,
            styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                if (item.SelectedFlag === "Y") {
                    return "my-cell-style";
                }
            }
        },
        {
            dataField: "OriginatorCode",
            headerText: "OriginatorCode",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ReceiverCode",
            headerText: "ReceiverCode",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "WorkOrderNumber",
            headerText: "WorkOrderNumber",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                if (item.SelectedFlag === "Y") {
                    return "my-cell-style";
                }
            }
        },
        {
            dataField: "CarrierCode",
            headerText: "CarrierCode",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Category",
            headerText: "Category",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CreatedBy",
            headerText: "CreatedBy",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "WorkOrderDate",
            headerText: "WorkOrderDate",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BookingNumber",
            headerText: "BookingNumber",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillOfLadingNumber",
            headerText: "BillOfLadingNumber",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "MasterAirWayBillNumber",
            headerText: "MasterAirWayBillNumber",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "HouseAirWayBillNumber",
            headerText: "HouseAirWayBillNumber",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PaymentMethodIndicator",
            headerText: "PaymentMethodIndicator",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ShipmentReferenceNumber",
            headerText: "ShipmentReferenceNumber",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OriginatorOnHandNumber",
            headerText: "OriginatorOnHandNumber",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OriginatorOrderReference",
            headerText: "OriginatorOrderReference",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OriginatorImportReferenceNumber",
            headerText: "OriginatorImportReferenceNumber",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ExportCutoffDate",
            headerText: "ExportCutoffDate",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Voyage",
            headerText: "Voyage",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PortOfLoading",
            headerText: "PortOfLoading",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Shipper",
            headerText: "Shipper",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillTo",
            headerText: "BillTo",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Comments",
            headerText: "Comments",
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
            dataField: "OrderRegFlag",
            headerText: "OrderRegFlag",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "SelectedFlag",
            headerText: "SelectedFlag",
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

    fnCallDetailData(objItem);
    return false;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    var strHandlerURL = "/TMS/Inout/Proc/InoutEIHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "EdiWorkOrderList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        WorkOrderStatuses: $("#WorkOrderStatuses").val(),
        CreatedBy: $("#CreatedBy").val(),
        WorkOrderNumber: $("#WorkOrderNumber").val(),
        MasterAirWayBillNumber: $("#MasterAirWayBillNumber").val(),
        HouseAirWayBillNumber: $("#HouseAirWayBillNumber").val(),
        MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : ""
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
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

function fnSetSelectedItem() {
    var objRowItems = AUIGrid.getItemsByValue(GridID, "SelectedFlag", "Y");
    if (objRowItems != null) {
        $.each(objRowItems, function (index, item) {
            item.SelectedFlag = null;
            AUIGrid.updateRowsById(GridID, item);
        });
    }

    if ($("#HidWorkOrderNumber").val()) {
        var objSelectedItems = AUIGrid.getItemsByValue(GridID, "WorkOrderNumber", $("#HidWorkOrderNumber").val());
        if (objSelectedItems != null) {
            $.each(objSelectedItems, function (index, item) {
                item.SelectedFlag = "Y";
                AUIGrid.updateRowsById(GridID, item);
            });
        }
    }
}

/**********************************************************/
// 오더 화물 목록 그리드
/**********************************************************/
var GridEIEquipmentID = "#InoutEIEquipmentListGrid";

function fnEIEquipmentGridInit() {
    // 그리드 레이아웃 생성
    fnCreateEIEquipmentGridLayout(GridEIEquipmentID, "EqSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridEIEquipmentID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    AUIGrid.resize(GridEIEquipmentID, $(".equipment_wrap").width(), 170);

    // 푸터
    fnSetEIEquipmentGridFooter(GridEIEquipmentID);
}

//기본 레이아웃 세팅
function fnCreateEIEquipmentGridLayout(strGID, strRowIdField) {

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
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    var objResultLayout = fnGetDefaultEIEquipmentColumnLayout();

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultEIEquipmentColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "EquipmentTypeCode",
            headerText: "EquipmentTypeCode",
            editable: false,
            width: 80,
            viewstatus: true,
            filter: { showIcon: true }
        },
        {
            dataField: "PieceCount",
            headerText: "PieceCount",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "GrossWeight",
            headerText: "GrossWeight",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "WeightUOM",
            headerText: "WeightUOM",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "Volume",
            headerText: "Volume",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "VolumeUOM",
            headerText: "VolumeUOM",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "FreightDescription",
            headerText: "FreightDescription",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "IsHazmat",
            headerText: "IsHazmat",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "IsOverweight",
            headerText: "IsOverweight",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "Shipmentnumber",
            headerText: "Shipmentnumber",
            editable: false,
            width: 100,
            viewstatus: true,
            filter: { showIcon: true }
        },
        {
            dataField: "Height",
            headerText: "Height",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "Width",
            headerText: "Width",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "Length",
            headerText: "Length",
            editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "DimensionUOM",
            headerText: "DimensionUOM",
            editable: false,
            width: 80,
            viewstatus: true
        },
        /*숨김필드*/
        {
            dataField: "EqSeqNo",
            headerText: "EqSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "WorkOrderNumber",
            headerText: "WorkOrderNumber",
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
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallEIEquipmentGridData(strGID) {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#HidWorkOrderNumber").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutEIHandler.ashx";
    var strCallBackFunc = "fnEIEquipmentGridSuccResult";

    var objParam = {
        CallType: "EdiEquipmentList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        WorkOrderNumber: $("#HidWorkOrderNumber").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnEIEquipmentGridSuccResult(objRes) {

    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridEIEquipmentID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridEIEquipmentID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridEIEquipmentID);

        // 푸터
        fnSetEIEquipmentGridFooter(GridEIEquipmentID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetEIEquipmentGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "EquipmentTypeCode",
            dataField: "EquipmentTypeCode",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "PieceCount",
            dataField: "PieceCount",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "GrossWeight",
            dataField: "GrossWeight",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Length",
            dataField: "Length",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Volume",
            dataField: "Volume",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Width",
            dataField: "Width",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Height",
            dataField: "Height",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        }
    ];
    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/

/**********************************************************/
// 오더 화물 목록 그리드
/**********************************************************/
var GridEIStopID = "#InoutEIStopListGrid";

function fnEIStopGridInit() {
    // 그리드 레이아웃 생성
    fnCreateEIStopGridLayout(GridEIStopID, "StSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridEIStopID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    AUIGrid.resize(GridEIStopID, $(".stop_wrap").width(), 170);

    // 푸터
    fnSetEIStopGridFooter(GridEIStopID);
}

//기본 레이아웃 세팅
function fnCreateEIStopGridLayout(strGID, strRowIdField) {

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
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    var objResultLayout = fnGetDefaultEIStopColumnLayout();

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultEIStopColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "StopType",
            headerText: "StopType",
            editable: false,
            width: 80,
            viewstatus: true,
            filter: { showIcon: true }
        },
        {
            dataField: "StopName",
            headerText: "StopName",
            editable: false,
            width: 100,
            viewstatus: true,
            filter: { showIcon: true }
        },
        {
            dataField: "StopNumber",
            headerText: "StopNumber",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "Address1",
            headerText: "Address1",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "Address2",
            headerText: "Address2",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "City",
            headerText: "City",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "Country",
            headerText: "Country",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "PostalCode",
            headerText: "PostalCode",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "ContactName",
            headerText: "ContactName",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "ContactPhone",
            headerText: "ContactPhone",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "Comments",
            headerText: "Comments",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "Latitude",
            headerText: "Latitude",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "Longitude",
            headerText: "Longitude",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "EquipmentTypeCode",
            headerText: "EquipmentTypeCode",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "Shipmentnumber",
            headerText: "Shipmentnumber",
            editable: false,
            width: 100,
            viewstatus: true,
            filter: { showIcon: true }
        },
        {
            dataField: "ScheduledGateInStart",
            headerText: "ScheduledGateInStart",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "ScheduledGateInForm",
            headerText: "ScheduledGateInForm",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "ScheduledGateInEnd",
            headerText: "ScheduledGateInEnd",
            editable: false,
            width: 120,
            viewstatus: true
        },
        /*숨김필드*/
        {
            dataField: "StSeqNo",
            headerText: "StSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "WorkOrderNumber",
            headerText: "WorkOrderNumber",
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
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallEIStopGridData(strGID) {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#HidWorkOrderNumber").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutEIHandler.ashx";
    var strCallBackFunc = "fnEIStopGridSuccResult";

    var objParam = {
        CallType: "EdiStopList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        WorkOrderNumber: $("#HidWorkOrderNumber").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnEIStopGridSuccResult(objRes) {

    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridEIStopID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridEIStopID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridEIStopID);

        // 푸터
        fnSetEIStopGridFooter(GridEIStopID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetEIStopGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "StopType",
        dataField: "StopType",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-text-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/

//검색
function fnSearchList() {
    //폼 리셋
    fnFormReset();
    //상세 데이터 리셋
    AUIGrid.setGridData(GridEIEquipmentID, []);
    AUIGrid.setGridData(GridEIStopID, []);

    if ($("#WorkOrderNumber").val()) { //오더번호 입력 검색
        fnCallGridData(GridID);
        return false;
    } else {
        var dateTerm = fnGetDateTerm($("#DateFrom").val(), $("#DateTo").val());
        var intDay   = 93;

        if (dateTerm > intDay - 1) {
            fnDefaultAlert("최대 " + intDay + "일까지 조회하실 수 있습니다.", "info");
            return false;
        }
        fnCallGridData(GridID);
        return false;
    }
}

//페이지 폼 리셋
function fnFormReset() {
    $("#HidWoSeqNo").val("");
    $("#HidOrderNo").val("");
    $("#HidCenterCode").val("");
    $("#HidDispatchSeqNo").val("");
    $("#HidWorkOrderNumber").val("");
    $("#HidWorkOrderStatus").val("");
    $("#HidActualPickupDT").val("");
    $("#HidActualDeliveryDT").val("");
    $("#HidEdiPickupYMD").val("");
    $("table.tbl_info td").html("");
    $("table.tbl_proc input").val("");
    $("table.tbl_proc select").val("");
    $("table.tbl_proc").hide();

    $("tr.TRHide").hide();

    $("#BtnReset").hide();
    $("#BtnOpenOrder").hide();
    $("#BtnOpenOrderReg").hide();
    return false;
}

//상세 불러오기
function fnCallDetailData(objItem) {
    fnFormReset();
    $("#HidOrderNo").val(objItem.OrderNo);
    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidWorkOrderNumber").val(objItem.WorkOrderNumber);
    //오더정보
    fnCallOrderInfo();

    //선택행 지정
    fnSetSelectedItem();

    //화물정보
    fnCallEIEquipmentGridData(GridEIEquipmentID);

    //상하차지정보
    fnCallEIStopGridData(GridEIStopID);
}

function fnCallOrderInfo() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#HidWorkOrderNumber").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutEIHandler.ashx";
    var strCallBackFunc = "fnCallOrderInfoSuccResult";
    var strFailCallBackFunc = "fnCallOrderInfoFailResult";

    var objParam = {
        CallType: "EdiWorkOrderList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        WorkOrderNumber: $("#HidWorkOrderNumber").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnCallOrderInfoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnCallOrderInfoFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnCallOrderInfoFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];
        $("#HidWoSeqNo").val(item.WoSeqNo);
        $("#HidOrderNo").val(item.OrderNo);
        $("#HidCenterCode").val(item.CenterCode);
        $("#HidDispatchSeqNo").val(item.DispatchSeqNo);
        $("#HidWorkOrderNumber").val(item.WorkOrderNumber);
        $("#HidWorkOrderStatus").val(item.WorkOrderStatus);
        $("#HidActualPickupDT").val(item.ActualPickupDT);
        $("#HidActualDeliveryDT").val(item.ActualDeliveryDT);
        $("#HidEdiPickupYMD").val(item.EdiPickupYMD);

        $("#TDOrderNo").html(item.OrderNo);
        $("#TDOrderStatusM").html(item.OrderStatusM);
        $("#TDWorkOrderNumber").html(item.WorkOrderNumber);
        $("#TDWorkOrderStatusM").html(item.WorkOrderStatusM);
        $("#TDMasterAirWayBillNumber").html(item.MasterAirWayBillNumber);
        var strHwab = "";
        if (item.HouseAirWayBillNumber != "") {
            strHwab = "<a href=\"#\" onclick=\"fnUnipassPopup(); return false;\" title=\"유니패스새창열기\">";
            strHwab += item.HouseAirWayBillNumber;
            strHwab += "</a>";
        }
        $("#TDHouseAirWayBillNumber").html(strHwab);
        $("#TDPickupPlace").html(item.PickupPlace);
        $("#TDPickupYMDHM").html(fnGetStrDateFormat(item.PickupYMD, "-") + " " + fnGetHMFormat(item.PickupHM));
        $("#TDGetPlace").html(item.GetPlace);
        $("#TDGetYMDHM").html(fnGetStrDateFormat(item.GetYMD, "-") + " " + fnGetHMFormat(item.GetHM));
        $("#TDActualPickupDT").html(item.ActualPickupDT);
        $("#TDActualDeliveryDT").html(item.ActualDeliveryDT);
        var strPOD = "";
        if (item.POD != "") {
            strPOD = "<a href=\"" + item.POD + "\" target=\"_blank\" title=\"POD새창에서열기\">";
            strPOD += item.POD.substring(item.POD.lastIndexOf('/') + 1);
            strPOD += "</a>";
        }
        $("#TDPOD").html(strPOD);

        $("#BtnReset").show();

        if (item.WorkOrderStatus == 1) { //등록 - Create
            $("#TblReject").show();
            $("#BtnOpenOrderReg").show();
            
        } else if (item.WorkOrderStatus == 2 || item.WorkOrderStatus == 3) { //접수 - Accept, 상차예정 - ScheduledPickup
            $("#BtnOpenOrder").show();
            $("#TRPickup").show();
            $("#TRGet").show();

        } else if (item.WorkOrderStatus == 4) { //하차예정 - ScheduledDelivery
            $("#TblActualPickup").show();
            $("#BtnOpenOrder").show();
            $("#TRPickup").show();
            $("#TRGet").show();

            var nHour = new Date().getHours();
            var nMinute = new Date().getMinutes();
            if (nHour < 10) {
                nHour = "0" + nHour;
            }

            if (nMinute < 10) {
                nMinute = "0" + nMinute;
            }

            $("#ActualPickupYMD").datepicker("setDate", GetDateToday("-"));
            $("#ActualPickupHM").val(nHour.toString() + nMinute.toString());

        } else if (item.WorkOrderStatus == 5) { //상차완료 - ActualPickup
            $("#TblActualDelivery").show();
            $("#BtnOpenOrder").show();
            $("#TRPickup").show();
            $("#TRGet").show();
            $("#TRActualPickup").show();

            var nHour = new Date().getHours();
            var nMinute = new Date().getMinutes();
            if (nHour < 10) {
                nHour = "0" + nHour;
            }

            if (nMinute < 10) {
                nMinute = "0" + nMinute;
            }

            $("#ActualDeliveryYMD").datepicker("setDate", GetDateToday("-"));
            $("#ActualDeliveryHM").val(nHour.toString() + nMinute.toString());

        } else if (item.WorkOrderStatus == 6) { //하차완료 - ActualDelivery
            $("#TblPOD").show();
            $("#BtnOpenOrder").show();
            $("#TRPickup").show();
            $("#TRGet").show();
            $("#TRActualPickup").show();
            $("#TRActualDelivery").show();

        } else if (item.WorkOrderStatus == 7) { //증빙 - POD
            $("#BtnOpenOrder").show();
            $("#TRPickup").show();
            $("#TRGet").show();
            $("#TRActualPickup").show();
            $("#TRActualDelivery").show();
            $("#TRPOD").show();

        } else if (item.WorkOrderStatus == 9) { //취소 - Reject
            $("#BtnReset").hide();
        }
        return false;
    } else {
        fnCallOrderInfoFailResult();
        return false;
    }
}

function fnCallOrderInfoFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "fnFormReset();");
    return false;
}


//상세 새로고침
function fnCallResetDetailData() {
    var objItem = {
        OrderNo: $("#HidOrderNo").val(),
        CenterCode: $("#HidCenterCode").val(),
        WorkOrderNumber: $("#HidWorkOrderNumber").val()
    };
    fnCallDetailData(objItem)
    return false;
}

//상차완료
function fnRegActualPickup() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#HidWorkOrderNumber").val() || !$("#HidWoSeqNo").val()) {
        return false;
    }

    if ($("#HidWorkOrderStatus").val() != "4") {
        return false;
    }

    if (!$("#HidDispatchSeqNo").val() || $("#HidDispatchSeqNo").val() == "0") {
        fnDefaultAlert("오더가 배차된 상태가 아닙니다.", "warning");
        return false;
    }

    if (!$("#ActualPickupYMD").val()) {
        fnDefaultAlertFocus("상차완료 일자를 선택하세요.", "ActualPickupYMD", "warning");
        return false;
    }

    if (!$("#ActualPickupHM").val()) {
        fnDefaultAlertFocus("상차완료 시간을 입력하세요.", "ActualPickupHM", "warning");
        return false;
    }

    if (!UTILJS.Util.fnValidHM($("#ActualPickupHM").val())) {
        fnDefaultAlertFocus("상차완료 시간을 올바르게 입력하세요.", "ActualPickupHM", "warning");
        return false;
    }

    fnDefaultConfirm("오더를 ActualPickup처리 하시겠습니까?", "fnRegActualPickupProc", "");
    return false;
}

function fnRegActualPickupProc() {
    var strHandlerURL = "/TMS/Inout/Proc/InoutEIHandler.ashx";
    var strCallBackFunc = "fnRegActualPickupProcSuccResult";
    var strFailCallBackFunc = "fnRegActualPickupProcFailResult";

    var objParam = {
        CallType: "DispatchCarStatusUpdate",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        DispatchSeqNo: $("#HidDispatchSeqNo").val(),
        PickupDT: $("#ActualPickupYMD").val() + " " + $("#ActualPickupHM").val().substring(0, 2) + ":" + $("#ActualPickupHM").val().substring(2, 4)
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnRegActualPickupProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("오더가 ActualPickup처리 되었습니다.", "info", "$('#BtnReset').click();");
            return false;
        } else {
            fnRegActualPickupProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegActualPickupProcFailResult();
        return false;
    }
}

function fnRegActualPickupProcFailResult(strMsg) {
    if (typeof strMsg !== "string") {
        strMsg = "";
    }
    fnDefaultAlert("오더 ActualPickup처리에 실패했습니다." + (strMsg == "" ? "" : ("<br>(" + strMsg + ")")), "warning");
    return false;
}


//하차완료
function fnRegActualDelivery() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#HidWorkOrderNumber").val() || !$("#HidWoSeqNo").val()) {
        return false;
    }

    if ($("#HidWorkOrderStatus").val() != "5") {
        return false;
    }

    if (!$("#HidDispatchSeqNo").val() || $("#HidDispatchSeqNo").val() == "0") {
        fnDefaultAlert("오더가 배차된 상태가 아닙니다.", "warning");
        return false;
    }

    if (!$("#ActualDeliveryYMD").val()) {
        fnDefaultAlertFocus("하차완료 일자를 선택하세요.", "ActualDeliveryYMD", "warning");
        return false;
    }

    if (!$("#ActualDeliveryHM").val()) {
        fnDefaultAlertFocus("하차완료 시간을 입력하세요.", "ActualDeliveryHM", "warning");
        return false;
    }

    if (!UTILJS.Util.fnValidHM($("#ActualDeliveryHM").val())) {
        fnDefaultAlertFocus("하차완료 시간을 올바르게 입력하세요.", "ActualDeliveryHM", "warning");
        return false;
    }

    fnDefaultConfirm("오더를 ActualDelivery처리 하시겠습니까?", "fnRegActualDeliveryProc", "");
    return false;
}

function fnRegActualDeliveryProc() {
    var strHandlerURL = "/TMS/Inout/Proc/InoutEIHandler.ashx";
    var strCallBackFunc = "fnRegActualDeliveryProcSuccResult";
    var strFailCallBackFunc = "fnRegActualDeliveryProcFailResult";

    var objParam = {
        CallType: "DispatchCarStatusUpdate",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        DispatchSeqNo: $("#HidDispatchSeqNo").val(),
        PickupDT: $("#HidActualPickupDT").val(),
        ArrivalDT: "",
        GetDT: $("#ActualDeliveryYMD").val() + " " + $("#ActualDeliveryHM").val().substring(0, 2) + ":" + $("#ActualDeliveryHM").val().substring(2, 4),
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnRegActualDeliveryProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("오더가 ActualDelivery처리 되었습니다.", "info", "$('#BtnReset').click();");
            return false;
        } else {
            fnRegActualDeliveryProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegActualDeliveryProcFailResult();
        return false;
    }
}

function fnRegActualDeliveryProcFailResult(strMsg) {
    if (typeof strMsg !== "string") {
        strMsg = "";
    }
    fnDefaultAlert("오더 ActualDelivery처리에 실패했습니다." + (strMsg == "" ? "" : ("<br>(" + strMsg + ")")), "warning");
    return false;
}


//POD등록
function fnRegPOD() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#HidWorkOrderNumber").val() || !$("#HidWoSeqNo").val()) {
        return false;
    }

    if ($("#HidWorkOrderStatus").val() != "6") {
        return false;
    }

    if (!$("#FileUpload").val()) {
        fnDefaultAlertFocus("첨부할 파일을 선택하세요.", "FileUpload", "warning");
        return false;
    }

    var acceptFileTypes = /(pdf)/i;
    var file = $("#FileUpload")[0].files[0];
    var fileExt = file["name"].substring(file["name"].lastIndexOf('.') + 1).toLowerCase();
    var uploadErrors = [];

    if (!acceptFileTypes.test(fileExt)) {
        uploadErrors.push("첨부할 수 없는 파일확장자입니다.");
    }

    if (file["size"] > 1024 * 1024 * 1) {
        uploadErrors.push("첨부파일 용량은 1MB 이내로 등록가능합니다.");
    }

    if (uploadErrors.length > 0) {
        fnDefaultAlert(uploadErrors.join("<br>"), "warning");
        return false;
    }

    fnDefaultConfirm("오더에 POD처리하시겠습니까?", "fnRegPODProc", "");
    return false;
}

function fnRegPODProc() {
    var strHandlerURL = "/TMS/Inout/Proc/InoutEIHandler.ashx";
    var strCallBackFunc = "fnRegPODProcSuccResult";
    var strFailCallBackFunc = "fnRegPODProcFailResult";

    var objParam = new FormData();
    objParam.append("CallType", "EdiPOD");
    objParam.append("CenterCode", $("#HidCenterCode").val());
    objParam.append("OrderNo", $("#HidOrderNo").val());
    objParam.append("WorkOrderNumber", $("#HidWorkOrderNumber").val());
    objParam.append("file", $("#FileUpload")[0].files[0]);

    UTILJS.Ajax.fnFileHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnRegPODProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("오더가 POD처리 되었습니다.", "info", "$('#BtnReset').click();");
            return false;
        } else {
            fnRegPODProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegPODProcFailResult();
        return false;
    }
}

function fnRegPODProcFailResult(strMsg) {
    if (typeof strMsg !== "string") {
        strMsg = "";
    }
    fnDefaultAlert("오더 POD처리에 실패했습니다." + (strMsg == "" ? "" : ("<br>(" + strMsg + ")")), "warning");
    return false;
}


//Reject
function fnRegReject() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#HidWorkOrderNumber").val() || !$("#HidWoSeqNo").val()) {
        return false;
    }

    if ($("#HidWorkOrderStatus").val() != "1") {
        return false;
    }

    if (!$("#RejectReasonCode").val()) {
        fnDefaultAlertFocus("ReasonCode를 선택하세요.", "RejectReasonCode", "warning");
        return false;
    }

    fnDefaultConfirm("오더를 Reject처리 하시겠습니까?", "fnRegRejectProc", "");
    return false;
}

function fnRegRejectProc() {
    var strHandlerURL = "/TMS/Inout/Proc/InoutEIHandler.ashx";
    var strCallBackFunc = "fnRegRejectProcSuccResult";
    var strFailCallBackFunc = "fnRegRejectProcFailResult";

    var objParam = {
        CallType: "EdiReject",
        OrderNo: $("#HidOrderNo").val(),
        CenterCode: $("#HidCenterCode").val(),
        WorkOrderNumber: $("#HidWorkOrderNumber").val(),
        RejectReasonCode: $("#RejectReasonCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnRegRejectProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("오더가 Reject처리 되었습니다.", "info", "$('#BtnReset').click();");
            return false;
        } else {
            fnRegRejectProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegRejectProcFailResult();
        return false;
    }
}

function fnRegRejectProcFailResult(strMsg) {
    if (typeof strMsg !== "string") {
        strMsg = "";
    }
    fnDefaultAlert("오더 Reject처리에 실패했습니다." + (strMsg == "" ? "" : ("<br>(" + strMsg + ")")), "warning");
    return false;
}

//오더상세
function fnOpenOrder() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#HidWorkOrderNumber").val() || !$("#HidWoSeqNo").val()) {
        return false;
    }

    var objItem = {
        OrderItemCode: "OA001",
        OrderNo: $("#HidOrderNo").val()
    }

    var strParam = "";
    fnCommonOpenOrder(objItem, strParam);
    return false;
}

//오더등록
function fnOpenOrderReg() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#HidWorkOrderNumber").val() || !$("#HidWoSeqNo").val()) {
        return false;
    }

    var objItem = {
        OrderItemCode: "OA001",
        OrderNo : ""
    }

    var strParam = "WoSeqNo=" + $("#HidWoSeqNo").val();
    fnCommonOpenOrder(objItem, strParam);
    return false;
}

/*유니페스 팝업 페이지*/
function fnUnipassPopup() {
    if (!$("#TDHouseAirWayBillNumber").text()) {
        return false;
    }

    if (!$("#HidEdiPickupYMD").val()) {
        return false;
    }

    window.open('/TMS/Unipass/UnipassDetailList?Hawb=' + $("#TDHouseAirWayBillNumber").text() + "&PickupYMD=" + $("#HidEdiPickupYMD").val().substring(0, 4) + "&HidMode=Inout", '화물통관 진행정보', 'width=1200px,height=800px,scrollbars=yes');
    return false;
}
