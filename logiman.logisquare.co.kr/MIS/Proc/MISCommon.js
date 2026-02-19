//---------------------------------------------------------
// chartType : 챠트 유형
// chartTitle : 챠트 제목
// chartXAxisLabel : X축 Label
// chartYAxisLabel : Y축 Label
// chartXAxisKey : data 키 컬럼
// chartXAxisValue : data value 컬럼
// chartTargetDivId : 챠트를 표시할 div id
// tickValueScale : Y축 표시할 숫자 단위
// barMaxWidth : bar 챠트 최대 width
// tickData : x label value array
// chartData : series data
// dateType : 조회 기간 단위(M:월별, D:일별)
//---------------------------------------------------------
function fnDrawChartTop(chartType, chartTitle, chartXAxisLabel, chartYAxisLabel, chartXAxisKey, chartXAxisValue, chartTargetDivId, tickValueScale, barMaxWidth, tickData, chartData, dateType) {
    var dict_series_mapper = {};
    var dict_series_name_mapper = {};
    var dict_chart_type_mapper = {};
    var array_columns = [];
    var x_date_format = dateType === "M" ? "%Y-%m" : "%m-%d";

    //var array_tick_values = JSON.parse(tickData);
    var jsonItems = JSON.parse(chartData);

    for (var i = 0; i < jsonItems.length; i++) {
        var jsonItem = JSON.parse(jsonItems[i]);
        var seriesName = jsonItem["SeriesName"];

        if (dict_series_mapper.hasOwnProperty(seriesName)) {
            seriesName = seriesName + "(" + (i + 1) + ")";
        }
        dict_series_mapper[seriesName] = "x" + (i + 1);
        dict_series_name_mapper[seriesName] = jsonItem["SeriesName"];
        dict_chart_type_mapper[seriesName] = chartType;

        var arrayTempLabel = [];
        var arrayTempData = [];

        if (jsonItem["data"].length > 0) {
            arrayTempLabel[0] = "x" + (i + 1);
            arrayTempData[0] = seriesName;

            for (var j = 0; j < jsonItem["data"].length; j++) {
                arrayTempLabel[j + 1] = jsonItem["data"][j][chartXAxisKey];
                //수익률의 경우 %단위로 보여주기 위해서 값에 100을 
                if (chartTargetDivId.includes("return_on_sales")) {
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
            names: dict_series_name_mapper,
        },
        axis: {
            x: {
                type: "timeseries",
                tick: {
                    format: x_date_format
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

//---------------------------------------------------------
// 선택된 항목(selectedItems)에 대해서만 출력하는 차트 함수
// 선택된 항목은 페이지에서 global하게 관리되는 변수에 설정
// chartName : 챠트 고유 명 *메모 등에서 사용함
// chartType : 챠트 유형
// jsonItems : 챠트 data
// chartYAxisLabel : Y축 Label
// chartXAxisKey : data 키 컬럼
// chartTargetDivId : 챠트를 표시할 div id
// tickValueScale : Y축 표시할 숫자 단위
// barMaxWidth : bar 챠트 최대 width
// dateType : 조회 기간 단위(M:월별, D:일별)
//---------------------------------------------------------
function fnDrawChartRank(chartName, chartType, jsonItems, chartYAxisLabel, chartXAxisKey, chartTargetDivId, tickValueScale, barMaxWidth, dateType) {
    var dict_series_mapper = {};
    var array_columns = [];
    var x_date_format = dateType === "M" ? "%Y-%m" : "%m-%d";

    var inx = 0;
    for (var i = 0; i < jsonItems.length; i++) {
        //선택된 항목 리스트에 존재하고, 해당 항목이 active한 경우만 출력
        //selectedItems는 선택된 항목을 관리하는 class object이며 각 페이지에서 정의되고 관리됨
        if (selectedItems.hasOwnProperty(jsonItems[i].ItemKey) && selectedItems[jsonItems[i].ItemKey].active) {
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
                    arrayTempLabel[j + 1] = jsonItems[i].ItemData.TickValues[j];
                    //수익률의 경우 %단위로 보여주기 위해서 값에 100을 곱함
                    if (chartTargetDivId.includes("return_on_sales")) {
                        arrayTempData[j + 1] = jsonItems[i].ItemData.ItemValues[chartXAxisKey][j] * 100;
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
    }

    var chartObj = bb.generate({
        data: {
            xs: dict_series_mapper,
            type: chartType,
            columns: array_columns,
            onclick: function (d, elem) {
                if (this.selected().length === 0) {
                    memoHide(chartName);
                }
                else {
                    memoShow(chartName, d);
                }
            },
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
                var key = chartName + "|" + d.id + "|" + getDateFormat(d.x, "-");
                //메모가 존재하는 경우 point 크기를 조금 더 크게해서 구분
                if (typeof chartMemosJson[key] !== "undefined") {
                    return 6.5;
                }
                else {
                    return 2.5;
                }
            },
            select: {
                r: function (d) {
                    //메모가 존재하는 경우  point가 커진 상태에서 selection되면 큰 상태에서 4배(기본)로 커지므로 무조건 동일하게 기본값 10.5로 처리
                    return 10.5;
                }
            }
        },
        axis: {
            x: {
                type: "timeseries",
                tick: {
                    format: x_date_format
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

//---------------------------------------------------------
// jsonItems : 챠트 data
// chartXAxisKey : data 키 컬럼
// chartTargetDivId : 챠트를 표시할 div id
//---------------------------------------------------------
function fnDrawChartPie(jsonItems, chartXAxisKey, chartTargetDivId) {
    var dict_series_inner_radius = {};
    var dict_series_color = {};
    var array_columns = [];

    //선택된 항목 처리
    var inx = 0;
    for (var i = 0; i < jsonItems.length; i++) {
        if (selectedItems.hasOwnProperty(jsonItems[i].ItemKey) && selectedItems[jsonItems[i].ItemKey].active) {
            var seriesName = jsonItems[i].ItemData.ItemName;
            dict_series_inner_radius[seriesName] = 0;

            var arrayTempData = [];

            if (jsonItems[i].ItemData.TickValues.length > 0) {
                arrayTempData[0] = seriesName;
                if (chartTargetDivId.includes("return_on_sales")) {
                    arrayTempData[1] = jsonItems[i].ItemData[chartXAxisKey] * 100;
                }
                else {
                    arrayTempData[1] = jsonItems[i].ItemData[chartXAxisKey];
                }

                array_columns.push(arrayTempData);
            }

            inx++;
        }
    }

    //선택되지 않은 항목 처리
    arrayTempData = [];
    arrayTempData[0] = "나머지";
    var remainAmount = 0.0;
    for (i = 0; i < jsonItems.length; i++) {
        if (!selectedItems.hasOwnProperty(jsonItems[i].ItemKey) || !selectedItems[jsonItems[i].ItemKey].active) {
            remainAmount += jsonItems[i].ItemData[chartXAxisKey];
        }
    }

    //나머지가 있을 경우만 시리즈에 추가
    if (remainAmount > 0) {
        dict_series_inner_radius["나머지"] = 50;
        dict_series_color["나머지"] = "#000000";

        if (chartTargetDivId.includes("return_on_sales")) {
            arrayTempData[1] = remainAmount * 100;
        }
        else {
            arrayTempData[1] = remainAmount;
        }
        array_columns.push(arrayTempData);
    }

    var chartObj = bb.generate({
        data: {
            type: "pie",
            columns: array_columns,
            colors: dict_series_color
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
        pie: {
            innerRadius: dict_series_inner_radius
        },
        bindto: chartTargetDivId
    });

    return chartObj;
}


/**
 * 각 차트의 메모 숨김(그래프 상단)
 */
// chartName
function memoHide(chartName) {
    $("#div_" + chartName).css("visibility", "hidden");
}


function getChartObject(chartName) {
    //gChartMapper는 각 페이지에서 정의함
    for (var key in gChartMapper) {
        if (gChartMapper[key][0] === chartName) {
            return eval(key);
        }
    }

    return null;
}

function getChartObjectName(chartName) {
    //gChartMapper는 각 페이지에서 정의함
    for (var key in gChartMapper) {
        if (gChartMapper[key][0] === chartName) {
            return key;
        }
    }

    return "";
}

function getYYMMDateFormat(date, delimiter) {

    var newDate = new Date();

    if (date !== null) newDate = date;

    var yy = newDate.getFullYear().toString().substring(2, 4);
    var mm = newDate.getMonth() + 1;
    if (mm < 10) mm = "0" + mm;

    if (delimiter === null) delimiter = "";
    return yy + delimiter + mm;
}

function getYYYYMMDateFormat(date, delimiter) {

    var newDate = new Date();

    if (date !== null) newDate = date;

    var yy = newDate.getFullYear().toString();
    var mm = newDate.getMonth() + 1;
    if (mm < 10) mm = "0" + mm;

    if (delimiter === null) delimiter = "";
    return yy + delimiter + mm;
}