var intHeight;
var chartDataJson;
var chartDataObject = {};
var arrDataTable = [];
var arrDataTablePre = [];
var arrDataTableTotal = [];
var tableColListJson;

var itemObj = {};

$(document).ready(function () {
    $("#DateFrom").datepicker({
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'yy-mm',
        closeText: "선택",
        onChangeMonthYear: function (year, month, inst) {
            $(this).val($.datepicker.formatDate('yy-mm', new Date(year, month - 1, 1)));
        },
        onClose: function (dateText, inst) {
            var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
            var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
            $(this).datepicker('setDate', new Date(year, month, 1));
        },
        beforeShow: function (input, inst) {
            if ((datestr = $(this).val()).length > 0) {
                actDate = datestr.split('-');
                year = actDate[0];
                month = actDate[1] - 1;
                $(this).datepicker('option', 'defaultDate', new Date(year, month));
                $(this).datepicker('setDate', new Date(year, month));
            }
        }
    });
    $("#DateFrom").datepicker("setDate", new Date());

    $("#DateTo").datepicker({
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'yy-mm',
        closeText: "선택",
        onChangeMonthYear: function (year, month, inst) {
            $(this).val($.datepicker.formatDate('yy-mm', new Date(year, month - 1, 1)));
        },
        onClose: function (dateText, inst) {
            var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
            var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
            $(this).datepicker('setDate', new Date(year, month, 1));
        },
        beforeShow: function (input, inst) {
            if ((datestr = $(this).val()).length > 0) {
                actDate = datestr.split('-');
                year = actDate[0];
                month = actDate[1] - 1;
                $(this).datepicker('option', 'defaultDate', new Date(year, month));
                $(this).datepicker('setDate', new Date(year, month));
            }
        }
    });
    $("#DateTo").datepicker("setDate", new Date());
    $("#ui-datepicker-div").addClass("ui-datepicker-div-hide-days");
    intHeight = $(document).height() - 230;
    fnDateTypeChange();

});

function fnDateTypeChange() {
    
    $("#DateType").on("change", function () {
        $("#DateFrom").datepicker("destroy");
        $("#DateTo").datepicker("destroy");
        if ($(this).val() === "M") {
            $("#DateFrom").datepicker({
                dateFormat: "yy-mm",
                currentText: "이번달",
                closeText: "선택",
                onSelect: function (dateText, inst) {
                    var year = inst.selectedYear;
                    var month = inst.selectedMonth;

                    dateText = year + (parseInt(month) < 10 ? "0" : "") + month;
                    var dateToText = $("#DateTo").val().replace(/-/gi, "");
                    if (dateToText.length !== 6) {
                        dateToText = GetDateToday("").substr(0, 6);
                    }

                    if (parseInt(dateText.replace(/-/gi, "")) > parseInt(dateToText)) {
                        $("#DateTo").datepicker("setDate", new Date(year, month, 1));
                    }
                },
                onClose: function (dateText, inst) {
                    var year = inst.selectedYear;
                    var month = inst.selectedMonth;
                    $(this).datepicker("setDate", new Date(year, month, 1));

                    dateText = year + (parseInt(month) < 10 ? "0" : "") + month;
                    var dateToText = $("#DateTo").val().replace(/-/gi, "");
                    if (dateToText.length !== 6) {
                        dateToText = GetDateToday("").substr(0, 6);
                    }

                    if (parseInt(dateText.replace(/-/gi, "")) > parseInt(dateToText)) {
                        $("#DateTo").datepicker("setDate", new Date(year, month, 1));
                    }
                }
            });
            $("#DateFrom").datepicker("setDate", new Date());

            $("#DateTo").datepicker({
                dateFormat: "yy-mm",
                currentText: "이번달",
                closeText: "선택",
                onSelect: function (dateText, inst) {
                    var year = inst.selectedYear;
                    var month = inst.selectedMonth;
                    $(this).datepicker("setDate", new Date(year, month, 1));

                    dateText = year + (parseInt(month) < 10 ? "0" : "") + month;
                    var dateFromText = $("#DateFrom").val().replace(/-/gi, "");
                    if (dateFromText.length !== 6) {
                        dateFromText = GetDateToday("").substr(0, 6);
                    }

                    if (parseInt(dateText.replace(/-/gi, "")) < parseInt(dateFromText)) {
                        $("#DateFrom").datepicker("setDate", new Date(year, month, 1));
                    }
                },
                onClose: function (dateText, inst) {
                    var year = inst.selectedYear;
                    var month = inst.selectedMonth;
                    $(this).datepicker("setDate", new Date(year, month, 1));

                    dateText = year + (parseInt(month) < 10 ? "0" : "") + month;
                    var dateFromText = $("#DateFrom").val().replace(/-/gi, "");
                    if (dateFromText.length !== 6) {
                        dateFromText = GetDateToday("").substr(0, 6);
                    }

                    if (parseInt(dateText.replace(/-/gi, "")) < parseInt(dateFromText)) {
                        $("#DateFrom").datepicker("setDate", new Date(year, month, 1));
                    }
                }
            });
            $("#DateTo").datepicker("setDate", new Date());
            $("#ui-datepicker-div").addClass("ui-datepicker-div-hide-days");
        } else {
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
            $("#ui-datepicker-div").removeClass("ui-datepicker-div-hide-days");
        }
    });
}
function fnCallData() {
    $("#divLoadingImage").show();
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
        AUIGrid.resize(GridID, $(".gridWrap").width(), intHeight);
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
        ListType: 1,
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        CenterCode: $("#CenterCode").val(),
        OrderItemCodes: $("#OrderItemCode").val(),
        ClientName  : $("#ClientName").val()
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
    $("#divLoadingImage").hide();
}

function fnSetGridDataSetting() {
    AUIGrid.setGridData("#ClientChartGrid", []);
    console.log(chartDataJson.ChartItems);
    //data가 존재할 때만 처리
    if (chartDataJson) {
        $.each(chartDataJson.ChartItems, function (i, val) {
            chartDataObject[val.ItemKey] = val.ItemNewData;
        });

        //전체 합계값 처리 위한 object 설정
        var total_order_count_cumulative = {};
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
            //OrderCount
            //OrderCount 아이템별 합계
            itemObj.CenterCode = val.CenterCode;
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "전체오더건수";
            itemObj["item_total"] = val.ItemValues.order_count_cumulative[val.ItemValues.order_count_cumulative.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.order_count[j];
                if (order_count.hasOwnProperty(data)) {
                    order_count[data] += val.ItemValues.order_count[j];
                }
                else {
                    order_count[data] = val.ItemValues.order_count[j];
                }
            });
            itemObj = {};

            itemObj.CenterCode = val.CenterCode;
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "적용건수";
            itemObj["item_total"] = val.ItemValues.applied_order_count_cumulative[val.ItemValues.applied_order_count_cumulative.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.applied_order_count[j];
                if (applied_order_count.hasOwnProperty(data)) {
                    applied_order_count[data] += val.ItemValues.applied_order_count[j];
                }
                else {
                    applied_order_count[data] = val.ItemValues.applied_order_count[j];
                }
            });
            itemObj = {};

            itemObj.CenterCode = val.CenterCode;
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "미적용건수";
            itemObj["item_total"] = val.ItemValues.Unapplied_order_count_cumulative[val.ItemValues.Unapplied_order_count_cumulative.length - 1];
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.Unapplied_order_count[j];
                if (Unapplied_order_count.hasOwnProperty(data)) {
                    Unapplied_order_count[data] += val.ItemValues.Unapplied_order_count[j];
                }
                else {
                    Unapplied_order_count[data] = val.ItemValues.Unapplied_order_count[j];
                }
            });
            itemObj = {};

            itemObj.CenterCode = val.CenterCode;
            itemObj.ItemKey = key;
            itemObj.ItemValue = val.ItemName;
            itemObj.Type = "적용률";
            itemObj["item_total"] = val.ItemValues.apply_rate[val.ItemValues.apply_rate.length - 1].toFixed(1) + "%";
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = ((val.ItemValues.applied_order_count[j] / val.ItemValues.order_count[j]) * 100).toFixed(1) + "%";
                if (apply_rate.hasOwnProperty(data)) {
                    apply_rate[data] += ((val.ItemValues.applied_order_count[j] / val.ItemValues.order_count[j]) * 100).toFixed(1) + "%";
                }
                else {
                    apply_rate[data] = ((val.ItemValues.applied_order_count[j] / val.ItemValues.order_count[j]) * 100).toFixed(1) + "%";
                }
            });
            itemObj = {};
        }); //end of $.each(chartDataObject, function (key, val)
        //합계 data 추가
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
            dataField: "CenterCode",
            headerText: "회원사코드",
            width: 0,
            editable: false,
            cellMerge: true
        },
        {
            dataField: "ItemKey",
            headerText: "고객사ID",
            width: 0,
            editable: false,
            cellMerge: true
        }, {
            dataField: "ItemValue",
            headerText: "고객사",
            width: 150,
            editable: true,
            renderer: { // HTML 템플릿 렌더러 사용
                type: "TemplateRenderer"
            }, labelFunction: function (rowIndex, columnIndex, value, headerText, item) { // HTML 템플릿 작성
                var template = "<a href=\"javascript:fnClientDetail('" + item.ItemKey + "', '" + value + "', '" + item.CenterCode + "');\" class=\"my_a_tag\" title=\"상세페이지 이동\">";
                template += value;
                template += '</a>';
                return template; // HTML 템플릿 반환..그대도 innerHTML 속성값으로 처리됨
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
function fnClientDetail(item, ClientName, CenterCode) {
    fnOpenRightSubLayer("고객사 상세", "/MIS/Automatic/AutomaticClientDetail?ClientCode=" + item.replace("_", "") + "&ClientName=" + ClientName + "&DateFrom=" + $("#DateFrom").val() + "&DateTo=" + $("#DateTo").val() + "&DateType=" + $("#DateType").val() + "&OrderItemCodes=OA007" + "&CenterCode=" + CenterCode, "1024px", "700px", "70%");
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