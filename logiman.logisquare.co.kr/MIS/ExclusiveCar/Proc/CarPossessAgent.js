/***************************************************************************/
//전담차량 보유 상세현황 GRID
/***************************************************************************/
// 그리드
var GridID = "#CarPossessChargeListGrid";
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

    // 그리드 초기화
    fnGridInit();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID);

    fnSetGridEvent(GridID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 230;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 230);
        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 230);
        }, 100);
    });

    //그리드에 포커스
    AUIGrid.setFocus(GridID);
}

function fnSearchData() {
    fnCallGridData(GridID);
}

//기본 레이아웃 세팅
function fnCreateGridLayout(strGID) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = false; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
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
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.groupingFields = ["CenterName", "AgentName", "CenterCode"];
    objGridProps.fillValueGroupingSummary = true;
    objGridProps.groupingSummary = {
        dataFields: ["CarDivTypeM", "OrderCnt", "SaleSupplyAmt", "PurchaseSupplyAmt", "SalesProfitAmt", "ProfitRate"],
        excepts: ["CenterName", "AgentName"],
        labelTexts: ["", ""],
        rows: [{
            // 사용자 정의 계산 함수
            // items (Array) : 소계의 대상이 되는 행들
            // dataField (String) : 소계 대상 필드 (데모 상에서는 "price", "color", "date" 가 대상임)
            expFunction: function (items, dataField) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
                var sum = 0;
                var Ordercount = 0;
                var SalesSum = 0;
                var PurchaseSum = 0;
                var ProfitRate = 0;
                if (items.length <= 0) return sum;
                // 합계 필드 3개 설정했기에 3개를 나눠서 실행
                switch (dataField) {
                    case "CarDivTypeM": // 합계 계산
                        return "합계";
                    case "OrderCnt": // 합계 계산
                        items.forEach(function (item) {
                            sum += Number(item.OrderCnt);
                        });
                        return AUIGrid.formatNumber(sum, "#,##0");
                    case "SaleSupplyAmt": // 합계 계산
                        items.forEach(function (item) {
                            sum += Number(item.SaleSupplyAmt);
                        });
                        return AUIGrid.formatNumber(sum, "#,##0");
                    case "PurchaseSupplyAmt": // 합계 계산
                        items.forEach(function (item) {
                            sum += Number(item.PurchaseSupplyAmt);
                        });
                        return AUIGrid.formatNumber(sum, "#,##0");
                    case "SalesProfitAmt": // 합계 계산
                        items.forEach(function (item) {
                            sum += Number(item.SalesProfitAmt);
                        });
                        return AUIGrid.formatNumber(sum, "#,##0");
                    case "ProfitRate": // price 개수 계산
                        items.forEach(function (item) {
                            SalesSum += Number(item.SaleSupplyAmt);
                            PurchaseSum += Number(item.PurchaseSupplyAmt);
                        });
                        if (SalesSum > 0) {
                            ProfitRate = (SalesSum - PurchaseSum) / SalesSum * 100;
                            return AUIGrid.formatNumber(ProfitRate, "#,##0");
                        } else {
                            return AUIGrid.formatNumber(0, "#,##0");
                        }

                }
            }
        }]
    };
    objGridProps.showBranchOnGrouping = false;
    objGridProps.enableCellMerge = true;
    // 그리드 ROW 스타일 함수 정의
    objGridProps.rowStyleFunction = function (rowIndex, item) {

        if (item._$isGroupSumField) { // 그룹핑으로 만들어진 합계 필드인지 여부

            // 그룹핑을 더 많은 필드로 하여 depth 가 많아진 경우는 그에 맞게 스타일을 정의하십시오.
            // 현재 3개의 스타일이 기본으로 정의됨.(AUIGrid_style.css)
            switch (item._$depth) {  // 계층형의 depth 비교 연산
                case 2:
                    return "aui-grid-row-depth3-style";
                case 3:
                    return "aui-grid-row-depth3-style";
                case 4:
                    return "aui-grid-row-depth3-style";
            }
        }

        return null;
    } // end of rowStyleFunction

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 기본 컬럼 세팅 
function fnGetDefaultColumnLayout() {
    var ColumnLayout = [
        //숨김 필드
        {
            dataField: "CenterCode",
            headerText: "회원사 코드",
            width: 0,
            visible: false
        },
        //
        {
            dataField: "CenterName",
            headerText: "회원사명",
            width: 150,
            editable: false
        }, {
            dataField: "AgentName",
            headerText: "담당자",
            width: 150,
            editable: false
        }, {
            dataField: "CarDivTypeM",
            headerText: "차량구분",
            width: 100,
            editable: false
        }, {
            dataField: "OrderCnt",
            headerText: "건수",
            width: 100,
            editable: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        }, {
            dataField: "SaleSupplyAmt",
            headerText: "매출액",
            width: 200,
            editable: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        }, {
            dataField: "PurchaseSupplyAmt",
            headerText: "매입액",
            width: 200,
            editable: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        }, {
            dataField: "SalesProfitAmt",
            headerText: "매출이익",
            width: 200,
            editable: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        }, {
            dataField: "ProfitRate",
            headerText: "이익률",
            width: 70,
            editable: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.0") + "%";
            }

        }, {
            dataField: "ExclusiveRate",
            headerText: "전담율",
            width: 100,
            editable: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (typeof value === "undefined") {
                    return "";
                }
                return AUIGrid.formatNumber(value, "#,##0.0") + "%";
            }
        }
    ];
    return ColumnLayout;
}


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    var ItemCode = [];

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() !== "") {
            ItemCode.push($(el).val());
        }
    });

    var strHandlerURL = "/MIS/ExclusiveCar/Proc/CarProssessHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";
    var objParam = {
        CallType: "StatCarDispatchAgentList",
        CenterCode: $("#CenterCode").val(),
        OrderItemCodes: ItemCode.join(","),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        AgentName: $("#AgentName").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridID, []);
            // 페이징
            fnCreatePagingNavigator();
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

        // 그리드 정렬
        AUIGrid.setSorting(GridID, GridSort);

        return false;
    }
}