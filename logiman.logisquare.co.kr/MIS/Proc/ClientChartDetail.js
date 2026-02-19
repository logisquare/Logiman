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
    var SearchYMD = "";
    var strCallType = "";
    SearchYMD = $("#DateYear").val();
    strCallType = "MonthList";

    var strHandlerURL = "/MIS/Proc/MisStatHandler.ashx";
    var strCallBackFunc = "fnDataMonthSuccResult";

    var objParam = {
        CallType: strCallType,
        DateFrom: SearchYMD,
        DateTo: SearchYMD
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
    var SearchYMD = "";
    var strCallType = "";

    SearchYMD = $("#DateYear").val();
    strCallType = "StatOrderClientMonthlyList";

    var strHandlerURL = "/MIS/Proc/MisStatHandler.ashx";
    var strCallBackFunc = "fnDataChartDataSuccResult";

    var objParam = {
        CallType: strCallType,
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        ClientName: $("#ClientName").val(),
        SearchYMD: SearchYMD,
        OrderItemCodes: $("#OrderItemCodes").val(),
        AgentName: $("#AgentName").val(),
        DateType: $("#DateType").val()
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
            chartDataObject[val.ItemKey] = val.ItemData;
        });

        //GRID용 data object 생성
        $.each(chartDataObject, function (key, val) {
            //OrderCount
            //OrderCount 아이템별 합계
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "건수";
            itemObj["item_total"] = val.ItemValues.OrderCountSum[val.ItemValues.OrderCountSum.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.OrderCount[j];
            });
            itemObj = {};

            //SalesAmount
            //SalesAmount 아이템별 합계
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "매출";
            itemObj["item_total"] = val.ItemValues.SalesAmountSum[val.ItemValues.SalesAmountSum.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.SalesAmount[j];
            });
            itemObj = {};

            //PuchaseAmount
            //PuchaseAmount 아이템별 합계
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "매입";
            itemObj["item_total"] = val.ItemValues.PurchaseAmountSum[val.ItemValues.PurchaseAmountSum.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.PurchaseAmount[j];
            });
            itemObj = {};

            //MonthlyPuchaseAmount
            //MonthlyPuchaseAmount 아이템별 합계
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "매입배분(월대차량)";
            itemObj["item_total"] = val.ItemValues.MonthlyPurchaseAmountSum[val.ItemValues.MonthlyPurchaseAmountSum.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.MonthlyPurchaseAmount[j];
            });
            itemObj = {};

            ///CenterFeeAmount
            //CenterFeeAmount 아이템별 합계
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "빠른입금 수수료";
            itemObj["item_total"] = val.ItemValues.CenterFeeAmountSum[val.ItemValues.CenterFeeAmountSum.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.CenterFeeAmount[j];
            });
            itemObj = {};

            //ProfitAmount
            //ProfitAmount 아이템별 합계
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "이익";
            itemObj["item_total"] = val.ItemValues.ProfitAmountSum[val.ItemValues.ProfitAmountSum.length - 1];

            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.ProfitAmount[j];
            });
            itemObj = {};

            //ReturnOnSales
            //ReturnOnSales 아이템별 합계
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "이익률";
            itemObj["item_total"] = val.ItemValues.ReturnOnSalesSum[val.ItemValues.ReturnOnSalesSum.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.ReturnOnSales[j];
            });

            itemObj = {};

        }); //end of $.each(chartDataObject, function (key, val)

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

    // 리사이징
    /*$(".gridWrap").on("mresize", function () {
        var height = $(window).height() - $("#header").height() - 410;
        if (height < 300) {
            height = 300;
        }
        AUIGrid.resize(GridID, $(".gridWrap").width(), height);
    });*/
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
            headerText: "고객사ID",
            width: 0,
            editable: false,
            styleFunction: setColumnStyle,
            cellMerge: true
        }, {
            dataField: "ItemValue",
            headerText: "고객사명",
            width: 150,
            styleFunction: setColumnStyle,
            editable: false,
            cellMerge: true,
            filter: {
                showIcon: true
            }
        }, {
            dataField: "Type",
            headerText: "구분",
            width: 100,
            editable: false,
            styleFunction: setColumnStyle
        }, {
            dataField: "item_total",
            headerText: "합계",
            width: 120,
            editable: false,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            styleFunction: setColumnStyle,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (item.Type === "이익률") {
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

            dateStr = GetStrMonthFormat(val.YMD, "-");
            colObj.dataField = dateStr;
            colObj.headerText = GetStrMonthFormat(val.YMD, "-") + "(" + val.WORK_DAYS + ")";
            colObj.width = 100;
            colObj.editable = false;
            colObj.dataType = "numeric";
            colObj.style = "aui-grid-my-column-right";
            colObj.styleFunction = setColumnStyle;
            colObj.labelFunction =
                function (rowIndex, columnIndex, value, headerText, item) {
                    if (typeof (item[dateStr]) === "undefined") {
                        return 0;
                    }
                    else {
                        if (item.Type === "이익률") {
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
    fnDrawChart("", "line", chartDataJson.ChartItems, "건수", "OrderCount", "#div_chart_order_count_specific", 1, 20, "M");
    fnDrawChart("", "line", chartDataJson.ChartItems, "매출", "SalesAmount", "#div_chart_sales_amount_specific", 1, 20, "M");
    fnDrawChart("", "line", chartDataJson.ChartItems, "이익", "ProfitAmount", "#div_chart_profit_amount_specific", 1, 20, "M");
    fnDrawChart("", "line", chartDataJson.ChartItems, "이익률", "ReturnOnSales", "#div_chart_return_on_sales_specific", 1, 20, "M");
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
    var dict_series_mapper = {};
    var array_columns = [];
    var x_date_format = dateType === "M" ? "%Y-%m" : "%m-%d";
    var inx = 0;
    for (var i = 0; i < jsonItems.length; i++) {
        var seriesName = jsonItems[i].ItemData.ItemName;

        //이름이 동일한 업체가 있을 수도 있으므로 이름이 동일한 경우 index를 뒤에 붙여 처리함
        if (dict_series_mapper.hasOwnProperty(seriesName)) {
            seriesName = seriesName + "(" + (inx + 1) + ")";
        }
        dict_series_mapper[seriesName] = "x" + (inx + 1);

        var arrayTempLabel = [];
        var arrayTempData = [];

        if (jsonItems[i].ItemData.TickValues.length > 0) {
            arrayTempLabel[0] = "x" + (inx + 1);
            arrayTempData[0] = seriesName;
            for (var j = 0; j < jsonItems[i].ItemData.TickValues.length; j++) {
                arrayTempLabel[j + 1] = jsonItems[i].ItemData.TickValues[j] + "-01";
                //수익률의 경우 %단위로 보여주기 위해서 값에 100을 곱함
                if (chartTargetDivId.includes("return_on_sales")) {
                    arrayTempData[j + 1] = jsonItems[i].ItemData.ItemValues[chartXAxisKey][j];
                }
                else {
                    arrayTempData[j + 1] = jsonItems[i].ItemData.ItemValues[chartXAxisKey][j];;
                }
            }

            array_columns.push(arrayTempLabel);
            array_columns.push(arrayTempData);
        }
        inx++;
    }

    var chartObj = bb.generate({
        data: {
            xs: dict_series_mapper,
            type: chartType,
            columns: array_columns,
            selection: {
                enabled: true,
                multiple: false,
                isselectable: function (id, value, index) {
                    return true;
                }
            }
        },
        point: {
            r: function (d) {
                var key = chartName + "|" + d.id + "|" + d.x;
                return 2.5;
            }
        },
        axis: {
            x: {
                type: "timeseries",
                tick: {
                    format: x_date_format,
                    culling: false
                }
            },
            y: {
                label: {
                    text: chartYAxisLabel,
                    position: "outer-top"

                },
                tick: {
                    format: function (x) { return d3.format(",")(x / tickValueScale) }
                }
            },
        },
        //기본적으로 y tick value와 연동이 되기 때문에, tooltip에서 보여주는 단위를 다르게 하고 싶은 경우
        //명시적으로 tooltip으로 기술해야 함.
        tooltip: {
            order: "desc",
            format: {
                value: function (x) {
                    return d3.format(",")(x);
                }
            },
        },
        grid: {
            y: {
                show: true,
                lines: [{
                    value: 0,
                    class: "zero"
                }]
            }
        },
        bar: {
            width: {
                max: barMaxWidth
            }
        },
        bindto: chartTargetDivId
    });

    return chartObj;
}