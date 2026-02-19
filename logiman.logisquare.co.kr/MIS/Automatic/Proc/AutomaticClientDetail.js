var intHeight;
var chartDataJson;
var chartDataObject = {};
var arrDataTable = [];
var arrDataTablePre = [];
var arrDataTableTotal = [];
var tableColListJson;

var itemObj = {};

$(document).ready(function () {
    GetMonthListData();
});
function fnCallData() {
    chartDataJson = "";
    chartDataObject = {};
    arrDataTable = [];
    arrDataTablePre = [];
    arrDataTableTotal = [];
    //월 목록 + 워킹데이 수 포함
    GetMonthListData();
}

//월 목록 + 워킹데이 수 포함
function GetMonthListData() {
    var strCallType = "";

    if ($("#DateType").val() === "M") {
        strCallType = "MonthList";
    } else {
        strCallType = "DailyList";
    }

    var strHandlerURL = "/MIS/Automatic/Proc/AutomaticHandler.ashx";
    var strCallBackFunc = "fnDataMonthSuccResult";

    var objParam = {
        CallType: strCallType,
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnDataMonthSuccResult(objRes) {
    AUIGrid.destroy(GridID);
    if (objRes) {
        tableColListJson = objRes[0].data.list;
        //그리드 데이터
        GetCharData();
        CreateGridLayout(GridID);
        AUIGrid.resize(GridID, $(".gridWrap").width(), 280);
    } else {
        return;
    }
}

function GetCharData() {

    if ($("#DateType").val() === "M") {
        strCallType = "StatTransRateClientMonthlyList";
    } else {
        strCallType = "StatTransRateClientDailyList";
    }

    var strHandlerURL = "/MIS/Automatic/Proc/AutomaticHandler.ashx";
    var strCallBackFunc = "fnDataChartDataSuccResult";

    var objParam = {
        CallType: strCallType,
        ListType: 2,
        ClientCode: $("#ClientCode").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        CenterCode: $("#CenterCode").val(),
        OrderItemCodes: $("#OrderItemCode").val(),
        ClientName: $("#ClientName").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(GridID);
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnDataChartDataSuccResult(objSes) {
    AUIGrid.removeAjaxLoader(GridID);
    if (objSes) {
        chartDataJson = objSes;
        fnDrawCharts(); //차트
    } else {
        return;
    }
    fnSetGridDataSetting();
}

function fnSetGridDataSetting() {
    AUIGrid.setGridData("#ClientChartDetailGrid", []);

    //data가 존재할 때만 처리
    if (chartDataJson) {
        $.each(chartDataJson.ChartItems, function (i, val) {
            chartDataObject[val.ItemKey] = val.ItemNewData;
        });

        //전체 합계값 처리 위한 object 설정
        var order_count = {};
        var applied_order_count = {};
        var Unapplied_order_count = {};
        var totalMonthlyPurchaseAmountObj = {};
        var apply_rate = {};

        order_count.ItemKey = "Total";
        order_count.Type = "전체오더건수";

        applied_order_count.ItemKey = "Total";
        applied_order_count.Type = "적용건수";

        Unapplied_order_count.ItemKey = "Total";
        Unapplied_order_count.Type = "미적용건수";

        totalMonthlyPurchaseAmountObj.ItemKey = "Total";
        totalMonthlyPurchaseAmountObj.Type = "적용률";

        //GRID용 data object 생성
        $.each(chartDataObject, function (key, val) {
            var order_count_cumulative = 0;
            var applied_order_count_cumulative = 0;
            var Unapplied_order_count_cumulative = 0;
            var apply_rate_cumulative = 0;
            //OrderCount
            //OrderCount 아이템별 합계
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "전체오더건수";
            //itemObj["item_total"] = val.ItemValues.order_count[val.ItemValues.order_count.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.order_count[j];
                order_count_cumulative += val.ItemValues.order_count[j];
            });
            itemObj["item_total"] = order_count_cumulative;
            itemObj = {};

            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "적용건수";
            itemObj["item_total"] = val.ItemValues.applied_order_count[val.ItemValues.applied_order_count.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.applied_order_count[j];
                applied_order_count_cumulative += val.ItemValues.applied_order_count[j];
            });
            itemObj["item_total"] = applied_order_count_cumulative;
            itemObj = {};

            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "미적용건수";
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.Unapplied_order_count[j];
                Unapplied_order_count_cumulative += val.ItemValues.Unapplied_order_count[j];
            });
            itemObj["item_total"] = Unapplied_order_count_cumulative;
            itemObj = {};

            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "적용률";
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = ((val.ItemValues.applied_order_count[j] / val.ItemValues.order_count[j]) * 100).toFixed(1) + "%";
            });
            itemObj["item_total"] = ((applied_order_count_cumulative / order_count_cumulative) * 100).toFixed(1) + "%";
            itemObj = {};
        }); //end of $.each(chartDataObject, function (key, val)
        //합계 data 추가
        arrDataTable = arrDataTableTotal.concat(arrDataTablePre);
    }

    fnCallGridData("#ClientChartDetailGrid");
}

$(document).ready(function () {

    $(document).keydown(function (e) {
        if (e.ctrlKey && e.keyCode === 70) {
            // Ctrl-F pressed
            searchDialog("gridDialog", "open");
            return false; // 브라우저의 Ctrl+F 막기
        }

        if (event.keyCode === 27) {
            searchDialog("gridDialog", "close");
            return false; // 브라우저의 Ctrl+F 막기
        }
    });

    $("input[type='text']").keydown(function (e) {
        if (e.keyCode === 13) {
            return false; // 브라우저의 Ctrl+F 막기
        }
    });
});

//==========================================
// 그리드
var GridID = "#ClientChartDetailGrid";
var GridDataLength = 0;

$(document).ready(function () {
    // 그리드 레이아웃 생성
    CreateGridLayout(GridID);

    // 이벤트 바인딩 
    fnSetGridEvent(GridID, "GridReady", "", "", "", "", "", "");

    // 검색(search) Not Found 이벤트 바인딩
    AUIGrid.bind(GridID, "notFound", "");

    //차트 아이콘 클릭 시
    AUIGrid.bind(GridID, "cellEditBegin", "");

    // 사이즈 세팅
    AUIGrid.resize(GridID, $(".gridWrap").width(), 250);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".gridWrap").width(), $(document).height() - 230);
    });

    //틀고정
    AUIGrid.setFixedColumnCount(GridID, 4);
});

//기본 레이아웃 세팅
function CreateGridLayout(GID) {
    AUIGrid.destroy(GridID);
    var objGridProps = {
        enableCellMerge: true,
        enableSorting: false,
        enableMovingColumn: true,
        useGroupingPanel: false, // 그룹핑 패널 사용	
        processValidData: true, // 숫자 정렬
        noDataMessage: "검색된 데이터가 없습니다.", // No Data message;
        headerHeight: 38, // 헤더 높이 지정
        rowHeight: 30, //로우 높이 지정
        selectionMode: "multipleCells", // singleRow 선택모드
        fixedColumnCount: 0, // 고정 칼럼 1개
        showRowNumColumn: false, // 줄번호 칼럼 렌더러 출력 안함
        showRowCheckColumn: false, // 체크박스 표시 렌더러 출력 안함
        enableFilter: true, //필터 표시
        editable: false, //수정 모드
        editableOnFixedCell: true, //고정컬럼 셀 수정 가능

    };

    var strItemKey = GID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(GID, objResultLayout, objGridProps);
};

// 기본 컬럼 세팅 
function fnGetDefaultColumnLayout() {
    var searchMode = $("#DateType").val();

    var ColumnLayout = [
        {
            dataField: "ItemKey",
            headerText: "화주ID",
            width: 0,
            editable: false,
            cellMerge: true
        }, {
            dataField: "ItemValue",
            headerText: "화주",
            width: 150,
            editable: true,
            renderer: { // HTML 템플릿 렌더러 사용
                type: "TemplateRenderer"
            },
            cellMerge: true,
            /*headerTooltip: {
                show: true,
                tooltipHtml: '<div style="width:350px;"><p style="border-bottom:1px dashed #999; padding-bottom:5px">각 셀을 더블클릭하면 아래 그래프에 추가 할 수 있습니다.</p><p style="padding-top:5px">고객사명에 마우스를 올려 나타나는 차트아이콘을 클릭하면 고객사의 운송건수, 매출금액, 이익금액, 이익률을 볼 수 있습니다.</p></div>'
            },*/
            filter: {
                showIcon: true
            }
        }, {
            dataField: "Type",
            headerText: "구분",
            width: 100,
            editable: false
        }, {
            dataField: "item_total",
            headerText: "합계",
            width: 120,
            editable: false,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (item.Type === "적용률") {
                    return AUIGrid.formatNumber(value, "###0.0");
                } else {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }
        }
    ];

    if (tableColListJson) {
        $.each(tableColListJson, function (i, val) {
            var colObj = {};
            var dateStr = "";

            if (searchMode === "M") {
                dateStr = GetStrMonthFormat(val.YMD, "-");
                colObj.dataField = dateStr;
                colObj.headerText = GetStrMonthFormat(val.YMD, "-") + "(" + val.WORK_DAYS + ")";
            }
            else {
                dateStr = GetStrDateFormat(val.YMD, "-");
                colObj.dataField = dateStr;
                colObj.headerText = GetStrDateFormat(val.YMD, "-");
                if (val.HOLIDAY_FLAG === "Y") {
                    colObj.headerStyle = "grid-header-holiday-color";
                }
            }
            colObj.width = 100;
            colObj.editable = false;
            colObj.dataType = "numeric";
            colObj.style = "aui-grid-my-column-right";
            colObj.labelFunction =
                function (rowIndex, columnIndex, value, headerText, item) {
                    if (typeof (item[dateStr]) === "undefined") {
                        return 0;
                    }
                    else {
                        if (item.Type === "적용률") {
                            return AUIGrid.formatNumber(value, "###0.0");
                        } else {
                            return AUIGrid.formatNumber(value, "#,##0");
                        }
                    }


                };
            ColumnLayout.push(colObj);
        });
    }

    return ColumnLayout;
}

function setColumnStyle(rowIndex, columnIndex, value, headerText, item, dataField) {
    if (item.ItemKey === "Total") {
        if (item.Type === "이익률") {
            if (value >= 20) {
                return "grid-font-color-mainblue";
            }
            else if (value <= 0) {
                return "grid-font-color-orange";
            }
            else {
                return "grid-font-bold-total";
            }
        }
        else {
            return "grid-font-bold-total";
        }
    }
    else {
        if (item.Type === "이익률") {
            if (value >= 20) {
                return "grid-font-color-mainblue";
            }
            else if (value <= 0) {
                return "grid-font-color-orange";
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
    }
}

/**********/
/* 데이터 */
/**********/
// GID
function fnCallGridData(GID) {
    if (arrDataTable !== "") {
        AUIGrid.setGridData(GID, arrDataTable);
    }
}

/******************/
/* 이벤트 핸들러 */
/******************/
// READY 이벤트 핸들러
function GridReady(event) {
    GridDataLength = AUIGrid.getGridData(GridID).length; // 그리드 전체 행수 보관  
}
/*********************/

function GetStrMonthFormat(ym, delimiter) {
    if (ym.length === 6) {
        var yy = ym.substring(0, 4);
        var mm = ym.substring(4, 6);
        if (delimiter === null) delimiter = "";
        return yy + delimiter + mm;
    }
    else {
        return ym;
    }
}

function GetStrDateFormat(ymd, delimiter) {
    var yy = ymd.substring(0, 4);
    var mm = ymd.substring(4, 6);
    var dd = ymd.substring(6, 8);
    if (delimiter === null) delimiter = "";
    return yy + delimiter + mm + delimiter + dd;
}


//chart변수 선언
//현재는 chart 생성 후, chart에 대한 추가 설정을 하는 것이 없어 사용되지 않지만.
//향후 chart 생성 후, chart에 변경을 해야 하는 경우는 아래 변수를 통해서 처리 가능함.
var chartSales;
var chartSalesCum;
var chartProfit;
var chartProfitCum;
var chartReturnOnSales;
var chartReturnOnSalesCum;
var chartCount;
var chartCountCum;

var dataKeyColumn;
var titleMode;
var xAxisLabel;
var barMaxWidth;

function fnDrawCharts() {
    fnDrawChart("", "bar", chartDataJson.ChartItems, "건수", "OrderCount", "#ClientDeatilChart", 1, 20, "M");
}

//---------------------------------------------------------
// 선택된 항목(selectedItems)에 대해서만 출력하는 차트 함수
// 선택된 항목은 페이지에서 global하게 관리되는 변수에 설정
// chartName : 챠트 명
// chartType : 챠트 유형
// jsonItems : 챠트 data
// chartYAxisLabel : Y축 Label
// chartXAxisKey : data 키 컬럼
// chartTargetDivId : 챠트를 표시할 div id
// tickValueScale : Y축 표시할 숫자 단위
// barMaxWidth : bar 챠트 최대 width
// dateType : 조회 기간 단위(M:월별, D:일별)
//---------------------------------------------------------
function fnDrawChart(chartName, chartType, jsonItems, chartYAxisLabel, chartXAxisKey, chartTargetDivId, tickValueScale, barMaxWidth, dateType) {
    var xTitle = [];
    var TotalOrderSum = [];
    var AppliedOrderSum = [];
    var UnAppliedOrderSum = [];
    var ApplyRate = [];

    xTitle[0] = "x";
    TotalOrderSum[0] = "건수";
    AppliedOrderSum[0] = "적용건수";
    UnAppliedOrderSum[0] = "미적용건수";
    ApplyRate[0] = "적용률(%)";
    $.each(jsonItems, function (intIndex, objItem) {
        var OrdSum = 0;
        var ApOrdSum = 0;
        var UnAOrderSum = 0;
        //타이틀
        xTitle[intIndex + 1] = objItem.ItemNewData.ItemName;
        //전체건수
        $.each(objItem.ItemNewData.ItemValues.order_count, function (idx, value) {
            OrdSum += value;
        });
        $.each(objItem.ItemNewData.ItemValues.applied_order_count, function (idx, value) {
            ApOrdSum += value;
        });
        $.each(objItem.ItemNewData.ItemValues.Unapplied_order_count, function (idx, value) {
            UnAOrderSum += value;
        });

        TotalOrderSum[intIndex + 1] = OrdSum;
        AppliedOrderSum[intIndex + 1] = ApOrdSum;
        UnAppliedOrderSum[intIndex + 1] = UnAOrderSum;
        ApplyRate[intIndex + 1] = ((ApOrdSum / OrdSum) * 100).toFixed(1);
    });

    var chart = bb.generate({
        padding: {
            bottom: 20
        },
        data: {
            x: "x",
            columns: [
                xTitle,
                TotalOrderSum,
                AppliedOrderSum,
                UnAppliedOrderSum,
                ApplyRate
            ],
            type: "bar", // for ESM specify as: bar()
            types: {
                "적용률(%)": "line", // for ESM specify as: spline()
            }
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d3.format(",")(d);
                    }
                }
            }
        },
        bindto: "#ClientDeatilChart"
    });
}