var TickArray = [];
var seriesData = [];

function fnCallDataList() {
    var ItemCode = [];
    var strCallType = "";
    var SearchYMD = "";
    var intTIckCount = 0;

    TickArray = [];
    if ($("#DateType").val() === "M") {
        intTIckCount = 12;
        SearchYMD = $("#DateYear").val();
        strCallType = "IntegrationChartMonthlyList";
    } else {
        intTIckCount = 31;
        SearchYMD = $("#DateYear").val() + $("#DateMonth").val();
        strCallType = "IntegrationChartDailyList";
    }

    for (var i = 0; i < intTIckCount; i++) {
        TickArray.push(String(i + 1));
    }

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() !== "") {
            ItemCode.push($(el).val());
        }
    });

    var strHandlerURL = "/MIS/Proc/MisStatHandler.ashx";
    var strCallBackFunc = "fnDataSuccResult";

    var objParam = {
        CallType: strCallType,
        CenterCode: $("#CenterCode").val(),
        ClientName: $("#ClientName").val(),
        SearchYMD: SearchYMD,
        OrderItemCodes: ItemCode.join(","),
        AgentName: $("#AgentName").val(),
        DateType: $("#DateType").val()
    };
    
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnDataSuccResult(objRes) {
    if (objRes.length > 0) {
        seriesData = objRes;
        fnDateTypeChange();
        fnDrawCharts();
    } else {
        fnDefaultAlert("조회된 데이터가 없습니다.");
        return;
    }
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

function fnDateTypeChange() {
    if ($("#DateType").val() === "D") {
        dataKeyColumn = "DD";
        barMaxWidth = 10;
    } else {
        dataKeyColumn = "MM";
        barMaxWidth = 20;
    }
}

function fnDrawCharts() {
    fnDrawChart("", "bar", "매출(단위:백만원)", dataKeyColumn, "sales_amount", "#div_chart_sales", 1000000, barMaxWidth);
    fnDrawChart("", "line", "누적 매출(단위:백만원)", dataKeyColumn, "sales_amount_cumulative", "#div_chart_sales_cumulative", 1000000, barMaxWidth);
    fnDrawChart("", "bar", "수익(단위:백만원)", dataKeyColumn, "profit_amount", "#div_chart_profit", 1000000, barMaxWidth);
    fnDrawChart("", "line", "누적 수익(단위:백만원)", dataKeyColumn, "profit_amount_cumulative", "#div_chart_profit_cumulative", 1000000, barMaxWidth);
}

//---------------------------------------------------------
// chartName : 챠트 명
// chartType : 챠트 유형
// chartYAxisLabel : Y축 Label
// chartXAxisKey : data 키 컬럼
// chartXAxisValue : data value 컬럼
// chartTargetDivId : 챠트를 표시할 div id
// tickValueScale : Y축 표시할 숫자 단위
// barMaxWidth : bar 챠트 최대 width
//---------------------------------------------------------
function fnDrawChart(chartName, chartType, chartYAxisLabel, chartXAxisKey, chartXAxisValue, chartTargetDivId, tickValueScale, barMaxWidth) {
    var dict_series_mapper = {};
    var dict_chart_type_mapper = {};
    var array_columns = [];
    console.log(seriesData);
    var array_tick_values = TickArray;
    var jsonItems = seriesData;
    
    for (var i = 0; i < jsonItems.length; i++) {
        var jsonItem = JSON.parse(jsonItems[i]);
        
        dict_series_mapper[jsonItem["SeriesName"]] = "x" + (i + 1);
        dict_chart_type_mapper[jsonItem["SeriesName"]] = chartType;

        var arrayTempLabel = [];
        var arrayTempData = [];
        
        if (jsonItem["data"].length > 0) {
            arrayTempLabel[0] = "x" + (i + 1);
            arrayTempData[0] = jsonItem["SeriesName"];
            
            for (var j = 0; j < jsonItem["data"].length; j++) {
                arrayTempLabel[j + 1] = jsonItem["data"][j][chartXAxisKey];
                
                //수익률의 경우 %단위로 보여주기 위해서 100을 곱함
                if (chartXAxisValue === "return_on_sales" || chartXAxisValue === "return_on_sales_cumulative") {
                    arrayTempData[j + 1] = jsonItem["data"][j][chartXAxisValue] * 100;
                }
                else {
                    arrayTempData[j + 1] = jsonItem["data"][j][chartXAxisValue];
                }
            }

            array_columns.push(arrayTempLabel);
            array_columns.push(arrayTempData);
        }
    }
    
    var chartObj = bb.generate({
        data: {
            xs: dict_series_mapper,
            types: dict_chart_type_mapper,
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
                tick: {
                    values: array_tick_values,
                    format: function (x) {
                        return x;
                    },
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