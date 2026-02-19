// 그리드
var GridID = "#OrderDispatchArrivalWorkClientListGrid";
var GridSort = null;

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
        minWidth: 200,
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
            AUIGrid.resize(SubGridID, $("div.right").width(), $(document).height() - 230);
        },
        stop: function (event, ui) {
            var leftWidthPer = ui.size.width / $("div.grid_type_03").width() * 100;
            var rightWidthPer = 100 - leftWidthPer;

            $("div.left").width(leftWidthPer + "%");
            $("li.left").width(leftWidthPer + "%");
            $("div.right").width(rightWidthPer + "%");
            $("li.right").width(rightWidthPer + "%");

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 230);
            AUIGrid.resize(SubGridID, $("div.right").width(), $(document).height() - 230);

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
    fnCreateGridLayout(GridID, "RowNum");

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
    return false;
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
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true;

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
    return false;
};


// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "ArrivalReportClientName",
            headerText: "업체명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        }, {
            dataField: "ArrivalReportChargeName",
            headerText: "담당자",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        }, {
            dataField: "ArrivalReportChargeCell",
            headerText: "담당자연락처",
            editable: false,
            width: 100,
            viewstatus: false
        }
        /*숨김 필드*/
        ,{
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "ArrivalReportClientCode",
            headerText: "ArrivalReportClientCode",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "RowNum",
            headerText: "RowNum",
            editable: false,
            width: 0,
            visible: false
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    fnCallGridDataSub(SubGridID, event.item.ArrivalReportClientCode);
    return false;
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
function fnCallGridData(strGridID) {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return false;
    }

    var LocationCode = [];
    $("#GridResult2").html("");
    AUIGrid.setGridData(SubGridID, []);

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "OrderDispatchArrivalWorkList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: $("#OrderItemCodes").val(),
        ClientName: $("#ClientName").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGridID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {
        $("#GridResult").html("");
        AUIGrid.setGridData(GridID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");

        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

        // 그리드 정렬
        AUIGrid.setSorting(GridID, GridSort);

        // 푸터
        fnSetGridFooter(GridID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "ArrivalReportClientName",
            dataField: "CarNo",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************/
//운송내역
/**********************************************/
var SubGridID = "#OrderDispatchArrivalWorkListGrid";
var SubGridSort = [{ dataField: "GoodsDispatchType", sortType: 1 }, { dataField: "OrderStatus", sortType: 1 }];

$(document).ready(function () {
    if ($(SubGridID).length > 0) {
        // 그리드 초기화
        fnGridInitSub();
    }
});

function fnGridInitSub() {
    // 그리드 레이아웃 생성
    fnCreateGridLayoutSub(SubGridID, "OrderNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(SubGridID, "", "", "fnGridKeyDownSub", "fnGridSearchNotFound", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 230;

    AUIGrid.resize(SubGridID, $("div.right").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(SubGridID, $("div.right").width(), $(document).height() - 230)

        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(SubGridID, $("div.right").width(), $(document).height() - 230)
        }, 100);
    });

    // 푸터
    fnSetGridFooterSub(SubGridID);
    AUIGrid.setGridData(SubGridID, []);
    return false;
}

//기본 레이아웃 세팅
function fnCreateGridLayoutSub(strGID, strRowIdField) {

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
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true;

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayoutSub()");
    var objOriLayout = fnGetDefaultColumnLayoutSub();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
    return false;
}

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayoutSub() {
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
            dataField: "OrderStatusM",
            headerText: "상태",
            width: 100,
            editable: false,
            renderer: {
                type: "IconRenderer",
                iconWidth: 20,
                iconHeight: 20,
                iconPosition: "aisle",
                iconTableRef: {
                    "등록": "/js/lib/AUIGrid/assets/yellow_circle.png",
                    "접수": "/js/lib/AUIGrid/assets/blue_circle.png",
                    "배차": "/js/lib/AUIGrid/assets/violet_circle.png",
                    "직송(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "집하(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "간선(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "배송(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "직송(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "집하(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "간선(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "배송(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "취소": "/js/lib/AUIGrid/assets/gray_circle.png"
                }
            },
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
            viewstatus: false
        },
        {
            dataField: "TransInfo",
            headerText: "이관정보",
            editable: false,
            width: 150,
            dataType: "string",
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
            viewstatus: false
        },
        {
            dataField: "OrderClientChargeName",
            headerText: "(발)담당자",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            visible: false,
            viewstatus: true
        },
        {
            dataField: "OrderClientChargeTelExtNo",
            headerText: "(발)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "OrderClientChargeTelNo",
            headerText: "(발)전화번호",
            editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "OrderClientChargeCell",
            headerText: "(발)휴대폰번호",
            editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PayClientTypeM",
            headerText: "청구처구분",
            editable: false,
            width: 80,
            visible: false,
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
            dataField: "PayClientChargeName",
            headerText: "(청)담당자",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PayClientChargeTelExtNo",
            headerText: "(청)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PayClientChargeTelNo",
            headerText: "(청)전화번호",
            editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PayClientChargeCell",
            headerText: "(청)휴대폰번호",
            editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PayClientChargeLocation",
            headerText: "청구사업장",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupStandard",
            headerText: "상차일 기준",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ConsignorName",
            headerText: "화주명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupYMD",
            headerText: "상차요청일",
            editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupHM",
            headerText: "상차요청시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "PickupWay",
            headerText: "상차방법",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlace",
            headerText: "상차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupPlacePost",
            headerText: "(상)우편번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlaceAddr",
            headerText: "(상)주소",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceAddrDtl",
            headerText: "(상)주소상세",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeName",
            headerText: "(상)담당자명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargePosition",
            headerText: "(상)직급",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeTelExtNo",
            headerText: "(상)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeTelNo",
            headerText: "(상)전화번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupPlaceChargeCell",
            headerText: "(상)휴대폰번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupPlaceLocalCode",
            headerText: "(상)지역코드",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlaceLocalName",
            headerText: "(상)지역명",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceNote",
            headerText: "(상)특이사항",
            editable: false,
            width: 150,
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
            viewstatus: false
        },
        {
            dataField: "GetHM",
            headerText: "하차요청시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "GetWay",
            headerText: "하차방법",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlace",
            headerText: "하차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetPlacePost",
            headerText: "(하)우편번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlaceAddr",
            headerText: "(하)주소",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GetPlaceAddrDtl",
            headerText: "(하)주소상세",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GetPlaceChargeName",
            headerText: "(하)담당자명",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {

            dataField: "GetPlaceChargePosition",
            headerText: "(하)직급",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "GetPlaceChargeTelExtNo",
            headerText: "(하)내선",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "GetPlaceChargeTelNo",
            headerText: "(하)전화번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "GetPlaceChargeCell",
            headerText: "(하)휴대폰번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "GetPlaceLocalCode",
            headerText: "(하)지역코드",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlaceLocalName",
            headerText: "(하)지역명",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "NoLayerFlag",
            headerText: "이단불가",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "NoTopFlag",
            headerText: "무탑배차",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "FTLFlag",
            headerText: "FTL",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM",
            headerText: "요청톤급",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTypeCodeM",
            headerText: "요청차종",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CustomFlag",
            headerText: "통관",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BondedFlag",
            headerText: "보세",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DocumentFlag",
            headerText: "서류",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ArrivalReportFlag",
            headerText: "도착보고",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "LicenseFlag",
            headerText: "면허진행",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "InTimeFlag",
            headerText: "시간엄수",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ControlFlag",
            headerText: "특별관제",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "QuickGetFlag",
            headerText: "하차긴급",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Nation",
            headerText: "목적국",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Hawb",
            headerText: "H/AWB",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Mawb",
            headerText: "M/AWB",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BookingNo",
            headerText: "Booking No.",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "InvoiceNo",
            headerText: "Invoice No.",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "StockNo",
            headerText: "입고 No.",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GMOrderType",
            headerText: "오더구분",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "GMTripID",
            headerText: "Trip ID",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
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
            dataField: "Quantity",
            headerText: "화물정보",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "NoteInside",
            headerText: "비고",
            editable: false,
            width: 80,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "NoteClient",
            headerText: "고객전달사항",
            editable: false,
            width: 80,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "FileCnt",
            headerText: "첨부파일",
            editable: false,
            width: 80,
            viewstatus: true,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    if (event.item.FileCnt > 0) {
                        fnOrderFileDetail(event.item.CenterCode, event.item.OrderNo);
                    }
                },
                visibleFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    // 행 아이템의 name 이 Anna 라면 버튼 표시 하지 않음
                    if (item.FileCnt === 0) {
                        return false;
                    }
                    return true;
                }
            }
        },
        {
            dataField: "TaxClientName",
            headerText: "(계)업체명",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "TaxClientCorpNo",
            headerText: "(계)사업자번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "TaxClientChargeName",
            headerText: "(계)담당자",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "TaxClientChargeTelNo",
            headerText: "(계)전화번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "TaxClientChargeEmail",
            headerText: "(계)이메일",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "GoodsDispatchTypeM",
            headerText: "배차구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DispatchCarNo1",
            headerText: "직송차량",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.DispatchCarInfo1 == "") {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; border-right:1px solid #aaa; text-align:right;'>" + item.DispatchCarInfo1 + "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
                }
            }
        },
        {
            dataField: "DispatchCarNo2",
            headerText: "집하차량",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.DispatchCarInfo2 == "") {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; border-right:1px solid #aaa; text-align:right;'>" + item.DispatchCarInfo2 + "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
                }
            }
        },
        {
            dataField: "DispatchCarNo3",
            headerText: "간선차량",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.DispatchCarInfo3 == "") {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; border-right:1px solid #aaa; text-align:right;'>" + item.DispatchCarInfo3 + "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
                }
            }
        },
        {
            dataField: "DispatchCarNo4",
            headerText: "배송차량",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.DispatchCarInfo4 == "") {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; border-right:1px solid #aaa; text-align:right;'>" + item.DispatchCarInfo4 + "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
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
            dataField: "UpdDate",
            headerText: "최종수정일",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "UpdAdminName",
            headerText: "최종수정자명",
            editable: false,
            width: 100,
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
            dataField: "OrderStatus",
            headerText: "OrderStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo1",
            headerText: "DispatchRefSeqNo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo2",
            headerText: "DispatchRefSeqNo2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo3",
            headerText: "DispatchRefSeqNo3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo4",
            headerText: "DispatchRefSeqNo4",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "GoodsSeqNo",
            headerText: "GoodsSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "GoodsDispatchType",
            headerText: "GoodsDispatchType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderLocationCode",
            headerText: "OrderLocationCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo1",
            headerText: "DispatchCarInfo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo1",
            headerText: "DispatchInfo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo2",
            headerText: "DispatchCarInfo2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo2",
            headerText: "DispatchInfo2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo3",
            headerText: "DispatchCarInfo3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo3",
            headerText: "DispatchInfo3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo4",
            headerText: "DispatchCarInfo4",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo4",
            headerText: "DispatchInfo4",
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
            dataField: "ClientName",
            headerText: "ClientName",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientFaxNo",
            headerText: "ClientFaxNo",
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
function fnGridKeyDownSub(event) {
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
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridDataSub(strGID, value) {
    var LocationCode = [];

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnGridSuccResultSub";

    var objParam = {
        CallType: "OrderDispatchList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        ClientCode: value,
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: $("#OrderItemCodes").val(),
        PageNo: $("#PageNo").val(),
        PageSize: $("#PageSize").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResultSub(objRes) {

    if (objRes) {
        $("#RecordCnt").val(0);
        $("#GridResult2").html("");
        AUIGrid.setGridData(SubGridID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult2").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(SubGridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(SubGridID);

        // 그리드 정렬
        AUIGrid.setSorting(SubGridID, SubGridSort);

        // 푸터
        fnSetGridFooterSub(SubGridID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooterSub(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "InoutRequestStatusM",
            dataField: "InoutRequestStatusM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        },
        {
            positionField: "SaleSupplyAmt",
            dataField: "SaleSupplyAmt",
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
            positionField: "Revenue",
            dataField: "Revenue",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "RevenuePer",
            dataField: "RevenuePer",
            formatString: "#,##0.0",
            postfix: "%",
            style: "aui-grid-text-right",
            labelFunction: function (value, columnValues, footerValues) {
                var newValue = "";
                if (footerValues[1] !== 0) {
                    newValue = (footerValues[3] / footerValues[1]) * 100;
                }
                return newValue;
            }
        },
        {
            positionField: "AdvanceSupplyAmt3",
            dataField: "AdvanceSupplyAmt3",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceSupplyAmt4",
            dataField: "AdvanceSupplyAmt4",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
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
            positionField: "Weight",
            dataField: "Weight",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}
/**********************************************/

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
        AUIGrid.searchAll(SubGridID, term, options);
    } else {
        AUIGrid.search(SubGridID, dataField, term, options);
    }
}

//항목관리 팝업 Open
function fnGridColumnManage2(strGridID) {
    fnGridColumnSetting2("GRID", strGridID);
    $("#GRID_COLUMN_LAYER2").slideDown(500);
}

function fnGridColumnSetting2(obj, strGridID) {
    var ColumnData = fnGetDefaultColumnLayoutSub();
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
    var OriColumnLayout = fnLoadColumnLayout(strGridID, "fnGetDefaultColumnLayoutSub()");
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
/**********************************************/