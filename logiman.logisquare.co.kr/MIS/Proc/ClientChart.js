var intHeight;
var chartDataJson;
var chartDataObject = {};
var arrDataTable = [];
var arrDataTablePre = [];
var arrDataTableTotal = [];
var tableColListJson;

var itemObj = {};

$(document).ready(function () {
    intHeight = $(document).height() - 230;
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
    if ($("#DateType").val() === "M") {
        SearchYMD = $("#DateYear").val();
        strCallType = "MonthList";
    } else {
        SearchYMD = $("#DateYear").val() + $("#DateMonth").val();
        strCallType = "DailyList";
    }

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
        AUIGrid.resize(GridID, $(".gridWrap").width(), intHeight);
    } else {
        return;
    }
}

function GetCharData() {
    var ItemCode = [];
    var SearchYMD = "";

    if ($("#DateType").val() === "M") {
        SearchYMD = $("#DateYear").val();
        strCallType = "StatOrderClientMonthlyList";
    } else {
        SearchYMD = $("#DateYear").val() + $("#DateMonth").val();
        strCallType = "StatOrderClientDailyList";
    }

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() !== "") {
            ItemCode.push($(el).val());
        }
    });

    var strHandlerURL = "/MIS/Proc/MisStatHandler.ashx";
    var strCallBackFunc = "fnDataChartDataSuccResult";

    var objParam = {
        CallType    : strCallType,
        CenterCode  : $("#CenterCode").val(),
        ClientName  : $("#ClientName").val(),
        SearchYMD: SearchYMD,
        OrderItemCodes: ItemCode.join(","),
        DateType    : $("#DateType").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(GridID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnDataChartDataSuccResult(objSes) {
    AUIGrid.removeAjaxLoader(GridID);
    if (objSes) {
        chartDataJson = objSes;
    } else {
        return;
    }
    fnSetGridDataSetting();
}

function fnSetGridDataSetting() {
    AUIGrid.setGridData("#ClientChartGrid", []);
    
    //data가 존재할 때만 처리
    if (chartDataJson) {
        $.each(chartDataJson.ChartItems, function (i, val) {
            chartDataObject[val.ItemKey] = val.ItemData;
        });

        //전체 합계값 처리 위한 object 설정
        var totalOrderCountObj = {};
        var totalSalesAmountObj = {};
        var totalPurchaseAmountObj = {};
        var totalMonthlyPurchaseAmountObj = {};
        var totalCenterFeeAmountObj = {};
        var totalProfitAmountObj = {};
        var totalReturnOnSalesObj = {};

        totalOrderCountObj.ItemKey = "Total";
        totalOrderCountObj.ItemValue = "합계";
        totalOrderCountObj.Type = "건수";

        totalSalesAmountObj.ItemKey = "Total";
        totalSalesAmountObj.ItemValue = "합계";
        totalSalesAmountObj.Type = "매출";

        totalPurchaseAmountObj.ItemKey = "Total";
        totalPurchaseAmountObj.ItemValue = "합계";
        totalPurchaseAmountObj.Type = "매입";

        totalMonthlyPurchaseAmountObj.ItemKey = "Total";
        totalMonthlyPurchaseAmountObj.ItemValue = "합계";
        totalMonthlyPurchaseAmountObj.Type = "매입배분(월대차량)";

        totalCenterFeeAmountObj.ItemKey = "Total";
        totalCenterFeeAmountObj.ItemValue = "합계";
        totalCenterFeeAmountObj.Type = "빠른입금 수수료";

        totalProfitAmountObj.ItemKey = "Total";
        totalProfitAmountObj.ItemValue = "합계";
        totalProfitAmountObj.Type = "이익";

        totalReturnOnSalesObj.ItemKey = "Total";
        totalReturnOnSalesObj.ItemValue = "합계";
        totalReturnOnSalesObj.Type = "이익률";

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
                if (totalOrderCountObj.hasOwnProperty(data)) {
                    totalOrderCountObj[data] += val.ItemValues.OrderCount[j];
                }
                else {
                    totalOrderCountObj[data] = val.ItemValues.OrderCount[j];
                }
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
                if (totalSalesAmountObj.hasOwnProperty(data)) {
                    totalSalesAmountObj[data] += val.ItemValues.SalesAmount[j];
                }
                else {
                    totalSalesAmountObj[data] = val.ItemValues.SalesAmount[j];
                }
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
                if (totalPurchaseAmountObj.hasOwnProperty(data)) {
                    totalPurchaseAmountObj[data] += val.ItemValues.PurchaseAmount[j];
                }
                else {
                    totalPurchaseAmountObj[data] = val.ItemValues.PurchaseAmount[j];
                }
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
                if (totalMonthlyPurchaseAmountObj.hasOwnProperty(data)) {
                    totalMonthlyPurchaseAmountObj[data] += val.ItemValues.MonthlyPurchaseAmount[j];
                }
                else {
                    totalMonthlyPurchaseAmountObj[data] = val.ItemValues.MonthlyPurchaseAmount[j];
                }
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
                if (totalCenterFeeAmountObj.hasOwnProperty(data)) {
                    totalCenterFeeAmountObj[data] += val.ItemValues.CenterFeeAmount[j];
                }
                else {
                    totalCenterFeeAmountObj[data] = val.ItemValues.CenterFeeAmount[j];
                }
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
                if (totalProfitAmountObj.hasOwnProperty(data)) {
                    totalProfitAmountObj[data] += val.ItemValues.ProfitAmount[j];
                }
                else {
                    totalProfitAmountObj[data] = val.ItemValues.ProfitAmount[j];
                }
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

            if (totalOrderCountObj.hasOwnProperty("item_total")) {
                totalOrderCountObj["item_total"] += val.ItemValues.OrderCountSum[val.ItemValues.OrderCountSum.length - 1];
            }
            else {
                totalOrderCountObj["item_total"] = val.ItemValues.OrderCountSum[val.ItemValues.OrderCountSum.length - 1];
            }

            if (totalSalesAmountObj.hasOwnProperty("item_total")) {
                totalSalesAmountObj["item_total"] += val.ItemValues.SalesAmountSum[val.ItemValues.SalesAmountSum.length - 1];
            }
            else {
                totalSalesAmountObj["item_total"] = val.ItemValues.SalesAmountSum[val.ItemValues.SalesAmountSum.length - 1];
            }

            if (totalPurchaseAmountObj.hasOwnProperty("item_total")) {
                totalPurchaseAmountObj["item_total"] += val.ItemValues.PurchaseAmountSum[val.ItemValues.PurchaseAmountSum.length - 1];
            }
            else {
                totalPurchaseAmountObj["item_total"] = val.ItemValues.PurchaseAmountSum[val.ItemValues.PurchaseAmountSum.length - 1];
            }

            if (totalMonthlyPurchaseAmountObj.hasOwnProperty("item_total")) {
                totalMonthlyPurchaseAmountObj["item_total"] += val.ItemValues.MonthlyPurchaseAmountSum[val.ItemValues.MonthlyPurchaseAmountSum.length - 1];
            }
            else {
                totalMonthlyPurchaseAmountObj["item_total"] = val.ItemValues.MonthlyPurchaseAmountSum[val.ItemValues.MonthlyPurchaseAmountSum.length - 1];
            }

            if (totalCenterFeeAmountObj.hasOwnProperty("item_total")) {
                totalCenterFeeAmountObj["item_total"] += val.ItemValues.CenterFeeAmountSum[val.ItemValues.CenterFeeAmountSum.length - 1];
            }
            else {
                totalCenterFeeAmountObj["item_total"] = val.ItemValues.CenterFeeAmountSum[val.ItemValues.CenterFeeAmountSum.length - 1];
            }

            if (totalProfitAmountObj.hasOwnProperty("item_total")) {
                totalProfitAmountObj["item_total"] += val.ItemValues.ProfitAmountSum[val.ItemValues.ProfitAmountSum.length - 1];
            }
            else {
                totalProfitAmountObj["item_total"] = val.ItemValues.ProfitAmountSum[val.ItemValues.ProfitAmountSum.length - 1];
            }

        }); //end of $.each(chartDataObject, function (key, val)

        $.each(totalSalesAmountObj, function (key, val) {
            if (key !== "ItemKey" && key !== "ItemValue" && key !== "Type") {
                if (totalSalesAmountObj[key] === 0) {
                    totalReturnOnSalesObj[key] = 0;
                }
                else {
                    totalReturnOnSalesObj[key] = (totalProfitAmountObj[key] / totalSalesAmountObj[key]) * 100;
                }
            }
        });

        //합계 data 추가
        arrDataTableTotal.push(totalOrderCountObj);
        arrDataTableTotal.push(totalSalesAmountObj);
        arrDataTableTotal.push(totalPurchaseAmountObj);
        arrDataTableTotal.push(totalMonthlyPurchaseAmountObj);
        arrDataTableTotal.push(totalCenterFeeAmountObj);
        arrDataTableTotal.push(totalProfitAmountObj);
        arrDataTableTotal.push(totalReturnOnSalesObj);
        
        arrDataTable = arrDataTableTotal.concat(arrDataTablePre);
    }

    fnCallGridData("#ClientChartGrid");
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
var GridID = "#ClientChartGrid";
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
    AUIGrid.resize(GridID, $(".gridWrap").width(), intHeight);

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
            editable: true,
            renderer: { // HTML 템플릿 렌더러 사용
                type: "TemplateRenderer"
            }, labelFunction: function (rowIndex, columnIndex, value, headerText, item) { // HTML 템플릿 작성
                if (value !== "합계") {
                    if (!value) return "";
                    var template = "<a href=\"javascript:fnClientDetail('" + item.ItemKey + "', '" + value + "');\" class=\"my_a_tag\" title=\"상세페이지 이동\">";
                    template += value;
                    template += '</a>';
                    return template; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
                } else {
                    return "합계";
                }
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

/******************/
/* 데이터 */
/******************/
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


//차트 아이콘 클릭 시
function fnClientDetail(item, ClientName) {
    var ItemCode = [];

    var ClientCode = item.replace("_", "");
    var OrderItemCodes = "";

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() !== "") {
            ItemCode.push($(el).val());
        }
    });

    OrderItemCodes = ItemCode.join(",");

    fnOpenRightSubLayer("고객사 상세", "/MIS/ClientChartDetail?ClientCode=" + Number(ClientCode) + "&DateYear=" + $("#DateYear").val() + "&ClientName=" + ClientName + "&CenterCode=" + $("#CenterCode").val() + "&OrderItemCodes=" + OrderItemCodes, "1024px", "700px", "70%");
    return;
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