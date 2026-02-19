//window.name = "WndGoodsListGrid";
// 그리드
var GridID = "#WndGoodsListGrid";
var GridSort = [];
var objGoodsPickupStatusList = [{ "code": 1, "value": "상차전" }, { "code": 2, "value": "상차완료(바코드)" }, { "code": 3, "value": "상차완료(수기)" }, { "code": 9, "value": "상차취소" }];
var objGoodsDeliveryStatusList = [{ "code": 1, "value": "배송전" }, { "code": 2, "value": "배송완료" }, { "code": 9, "value": "배송취소" }];


$(document).ready(function () {
    
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


    // 그리드 초기화
    fnGridInit();

    fnSetInitData();
});

//기본정보 세팅
function fnSetInitData() {
    if ($("#HidErrMsg").val()) {
        fnDefaultAlert($("#HidErrMsg").val(), "warning", "fnWindowClose()");
        return false;
    }

    fnCallGridData(GridID);
}

function fnWindowClose() {
    parent.$("#cp_layer").css("left", "");
    parent.$("#cp_layer").toggle();
}

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "GoodsSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "");

    //에디팅 이벤트 바인딩
    AUIGrid.bind(GridID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd"], fnGridCellEditingHandler);

    // 사이즈 세팅
    var intHeight = $(document).height() - 100;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 100);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 100);
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
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "DeliveryNo",
            headerText: "출고번호",
            editable: false,
            width: 110,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GoodsBarcodeNo",
            headerText: "바코드번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DispatchYMD",
            headerText: "배송요청일",
            editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DeliveryName",
            headerText: "거래처",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GoodsPickupStatus",
            headerText: "상차상태",
            editable: true,
            width: 150,
            filter: {
                showIcon: true,
                displayFormatValues: true // 포맷팅된 값으로 필터 메뉴 작성 (기본값 : false)
            },
            viewstatus: false,
            headerTooltip: {
                show: true,
                tooltipHtml: "선택박스 변경시 상태 수정 가능"
            },
            headerStyle: "aui-grid-editable_header",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                const keyField = this.editRenderer.keyField;
                const valueField = this.editRenderer.valueField;
                const list = this.editRenderer.list;
                const result = list.find(v => v[keyField] == value); // editRenderer 리스트에서 key-value 에 맞는 값 찾아 반환.
                if (result === undefined) return "";
                return result[valueField]; // key 값이 아닌 value 값으로 출력 시키기
            },
            editRenderer: {
                type: "DropDownListRenderer",
                list: objGoodsPickupStatusList, //key-value Object 로 구성된 리스트
                keyField: "code", // key 에 해당되는 필드명
                valueField: "value" // value 에 해당되는 필드명
            }
        },
        {
            dataField: "GoodsPickupDate",
            headerText: "상차상태변경일시",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "GoodsDeliveryStatus",
            headerText: "배송상태",
            editable: true,
            width: 150,
            filter: {
                showIcon: true,
                displayFormatValues: true // 포맷팅된 값으로 필터 메뉴 작성 (기본값 : false)
            },
            viewstatus: false,
            headerTooltip: {
                show: true,
                tooltipHtml: "선택박스 변경시 상태 수정 가능"
            },
            headerStyle: "aui-grid-editable_header",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                const keyField = this.editRenderer.keyField;
                const valueField = this.editRenderer.valueField;
                const list = this.editRenderer.list;
                const result = list.find(v => v[keyField] == value); // editRenderer 리스트에서 key-value 에 맞는 값 찾아 반환.
                if (result === undefined) return "";
                return result[valueField]; // key 값이 아닌 value 값으로 출력 시키기
            },
            editRenderer: {
                type: "DropDownListRenderer",
                list: objGoodsDeliveryStatusList, //key-value Object 로 구성된 리스트
                keyField: "code", // key 에 해당되는 필드명
                valueField: "value", // value 에 해당되는 필드명
            }
        },
        {
            dataField: "GoodsDeliveryDate",
            headerText: "배송상태변경일시",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "GoodsCode",
            headerText: "품목코드",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GoodsName",
            headerText: "품목명",
            editable: false,
            width: 300,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "GoodsWeight",
            headerText: "중량",
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
            dataField: "GoodsSpec",
            headerText: "규격",
            editable: false,
            width: 200,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GoodsUnitPrice",
            headerText: "단가",
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
            dataField: "GoodsUnitType",
            headerText: "단위",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GoodsQuantity",
            headerText: "수량",
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
            dataField: "GoodsPrice",
            headerText: "금액",
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
            dataField: "RegDate",
            headerText: "등록일시",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "UpdDate",
            headerText: "수정일시",
            editable: false,
            width: 120,
            viewstatus: true
        },
        /*숨김필드*/
        {
            dataField: "GoodsSeqNo",
            headerText: "GoodsSeqNo",
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
            dataField: "OrderNo",
            headerText: "OrderNo",
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

//그리드 에디팅 이벤트 핸들러
function fnGridCellEditingHandler(event) {
    
    if (event.type == "cellEditBegin") {
    } else if (event.type == "cellEditEndBefore") {
        var retStr = event.value;
        if (event.dataField === "GoodsPickupStatus") {
        
            if (event.value == "2") {
                fnDefaultAlert("상차완료(바코드)는 선택할 수 없습니다.", "warning");
                return event.oldValue;
            }
        
            retStr = event.value;
        }
        return retStr;
    } else if (event.type == "cellEditEnd") {

        if (event.dataField === "GoodsPickupStatus" && event.oldValue != event.value) {
            fnSetGoodsStatus(event);
            return;
        }
        
        if (event.dataField === "GoodsDeliveryStatus" && event.oldValue != event.value) {
            fnSetGoodsStatus(event);
            return;
        }
    }
};

var objEvent = null;

function fnSetGoodsStatus(objEventParam) {
    if (typeof objEventParam == "undefined") {
        return false;
    }

    if (typeof objEventParam == null) {
        return false;
    }

    objEvent = objEventParam;
    var strConfMsg = (objEvent.dataField === "GoodsPickupStatus"  ? "상차" : "배송") + "상태를 변경하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnSetGoodsStatusProc", "", "fnSetGoodsStatusCnl", "");
    return false;
}

function fnSetGoodsStatusProc() {
    if (typeof objEvent == "undefined") {
        return false;
    }

    if (typeof objEvent == null) {
        return false;
    }

    var strHandlerURL = "/TMS/Wnd/Proc/WmsHandler.ashx";
    var strCallBackFunc = "fnSetGoodsStatusSuccResult";
    var strFailCallBackFunc = "fnSetGoodsStatusFailResult";
    var objParam = {
        CallType: "WmsOrderLayoverGoodsStatusUpd",
        CenterCode: objEvent.item.CenterCode,
        OrderNo: objEvent.item.OrderNo,
        GoodsSeqNo: objEvent.item.GoodsSeqNo,
        StatusType: objEvent.dataField === "GoodsPickupStatus" ? 1 : 2,
        StatusValue: objEvent.value
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnSetGoodsStatusSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("화물 상태가 변경되었습니다.", "info", "fnGridUpdComplete");
            return false;
        } else {
            fnSetGoodsStatusFailResult();
            return false;
        }
    } else {
        fnSetGoodsStatusFailResult();
        return false;
    }
}

function fnSetGoodsStatusFailResult() {
    fnDefaultAlert("화물 상태변경에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning", "fnSetGoodsStatusCnl");
    return false;
}


function fnSetGoodsStatusCnl() {
    var objItem = objEvent.item;
    eval("objItem." + objEvent.dataField + " = " + objEvent.oldValue);
    AUIGrid.updateRowsById(objEvent.pid, objItem); // 1개 업데이트
    AUIGrid.resetUpdatedItems(objEvent.pid); // 현재 수정 정보 초기화
    return false;
}

function fnGridUpdComplete() {
    if (objEvent) {
        AUIGrid.resetUpdatedItems(objEvent.pid); // 현재 수정 정보 초기화
        if (AUIGrid.getItemByRowIndex(objEvent.pid, objEvent.rowIndex + 1)) {
            AUIGrid.setSelectionByIndex(objEvent.pid, objEvent.rowIndex + 1, objEvent.columnIndex);
        }
    }
}

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

    if (!$("#CenterCode").val() || !$("#OrderNo").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/Wnd/Proc/WmsHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "WmsOrderLayoverGoodsList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        DeliveryNo: $("#DeliveryNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            $("#RecordCnt").val(0);
            $("#GridResult").html("");
            AUIGrid.setGridData(GridID, []);
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
            positionField: "DeliveryNo",
            dataField: "DeliveryNo",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "GoodsWeight",
            dataField: "GoodsWeight",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        },
        {
            positionField: "GoodsUnitPrice",
            dataField: "GoodsUnitPrice",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "GoodsQuantity",
            dataField: "GoodsQuantity",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "GoodsPrice",
            dataField: "GoodsPrice",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}