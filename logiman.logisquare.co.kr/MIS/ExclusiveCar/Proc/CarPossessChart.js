var seriesData = [];
var GridDataJson = [];
var GridDataObject = {};
var tableColListJson;
var arrDataTable = [];
var arrDataTablePre = [];
var itemObj = {};

function fnSearchData() {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode");
        return;
    }
    AUIGrid.destroy(GridID);
    fnCarPossessPieChart();
    arrDataTable = [];
    arrDataTablePre = [];
}

function fnCarPossessPieChart() {
    var strSearchYM = "";
    strSearchYM = $("#DateYear").val() + $("#DateMonth").val();

    var strHandlerURL = "/MIS/ExclusiveCar/Proc/CarProssessHandler.ashx";
    var strCallBackFunc = "fnStatCarDivTypeSuccResult";

    var objParam = {
        CallType: "StatCarDivTypeList",
        CenterCode: $("#CenterCode").val(),
        SearchYM: strSearchYM
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnStatCarDivTypeSuccResult(objData) {
    //원그래프
    var CarDivType1Cnt;
    var CarDivType4Cnt;
    var CarDivType6Cnt;
    if (objData.ChartItems.length !== 0) {
        GridDataJson = {};
        GridDataObject = {};
        CarDivType1Cnt = objData.ChartItems[0].ItemData.SumCarDivType1Cnt; //직영
        CarDivType4Cnt = objData.ChartItems[0].ItemData.SumCarDivType4Cnt; //지입
        CarDivType6Cnt = objData.ChartItems[0].ItemData.SumCarDivType6Cnt; //고정
        GridDataJson = objData;

        fnCarDivTypePieChart(CarDivType1Cnt, CarDivType4Cnt, CarDivType6Cnt); //원형 그래프
        fnCarDivTypeLineChart();//라인 그래프
        fnGetMonthListData() // 전 12개월 불러오기
        setTimeout(function () {
            fnSetGridDataSetting();//그리드 
        }, 1000);

    } else {
        fnDefaultAlert("조회 된 데이터가 없습니다.");
        return;
    }
}

//월 목록 + 워킹데이 수 포함
function fnGetMonthListData() {
    var SearchYMD = $("#DateYear").val() + $("#DateMonth").val();

    var strHandlerURL = "/MIS/ExclusiveCar/Proc/CarProssessHandler.ashx";
    var strCallBackFunc = "fnDataMonthSuccResult";

    var objParam = {
        CallType: "MonthPrevList",
        DateFrom: SearchYMD
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnDataMonthSuccResult(objRes) {
    if (objRes) {
        tableColListJson = objRes[0].data.list;
    } else {
        return;
    }
}

function fnCarDivTypePieChart(CarDivType1Cnt, CarDivType4Cnt, CarDivType6Cnt) {
    if (CarDivType1Cnt === 0 && CarDivType4Cnt === 0 && CarDivType6Cnt === 0) {
        $("#CarPossessPieChart").html("<p style='text-align:center; padding-top:160px;'>조회 된 데이터가 없습니다.</p>");
        return;
    }
    var chart = bb.generate({
        data: {
            columns: [
                ["직영(" + CarDivType1Cnt + "대)", CarDivType1Cnt],
                ["지입(" + CarDivType4Cnt + "대)", CarDivType4Cnt],
                ["고정(" + CarDivType6Cnt + "대)", CarDivType6Cnt]
            ],
            type: "pie", // for ESM specify as: pie()
        },
        pie: {
            startingAngle: 1,
            label: {
                ratio: 1.3,
                format: function (value, ratio, id) {
                    return id;
                }
            }
        },
        bindto: "#CarPossessPieChart"
    });
}

function fnCarDivTypeLineChart() {
    var ArrayCarDivTypeData = new Array();

    ArrayCarDivTypeData[0] = ["x", "직영", "지입", "고정"];

    for (var i = 0; i < GridDataJson.ChartItems[0].ItemData.TickValues.length; i++) {
        ArrayCarDivTypeData[i + 1] = [GridDataJson.ChartItems[0].ItemData.TickValues[i] + "-01", GridDataJson.ChartItems[0].ItemData.ItemValues.CarDivType1Cnt[i], GridDataJson.ChartItems[0].ItemData.ItemValues.CarDivType4Cnt[i], GridDataJson.ChartItems[0].ItemData.ItemValues.CarDivType6Cnt[i]];
    }

    var chartObj = bb.generate({
        padding: {
            bottom: 20
        },
        data: {
            x: "x",
            rows: ArrayCarDivTypeData,
            type: "line"
        },
        axis: {
            x: {
                type: "timeseries",
                tick: {
                    culling: false,
                    format: function (x) {
                        if (Number($("#DateYear").val()) > x.getFullYear() && x.getMonth() + 1 === 12) {
                            return x.getFullYear() + "-" + (x.getMonth() + 1) + "월";
                        }
                        return x.getMonth() + 1 + "월";
                    }
                }
            }
        },
        tooltip: {
            format: {
                value: function (x) {
                    return d3.format(",")(x);
                }
            },
        },
        bindto: "#CarPossessLineChart"
    });

    return chartObj;
}

/***************************************************************************/
//전담차량 보유 상세현황 GRID
/***************************************************************************/
// 그리드
var GridID = "#CarPossessListGrid";
var GridSort = [];

function fnSetGridDataSetting() {
    var chartDataObject = [];
    var CenterCodePush = [];
    var CenterNamePush = [];
    var DataPush = [];
    var Type1 = [];
    var Type4 = [];
    var Type6 = [];
    AUIGrid.setGridData("#CarPossessListGrid", []);

    if (GridDataJson) {
        $.each(GridDataJson.ChartItems, function (i, val) {
            GridDataObject[val.ItemKey] = val.ItemData;
        });
        
        //data가 존재할 때만 처리
        //GRID용 data object 생성
        $.each(GridDataObject, function (key, val) {
            //OrderCount
            //OrderCount 아이템별 합계
            itemObj.CenterCode = key;
            itemObj.CenterName = val.CenterName;
            itemObj.CarDivType = "직영";
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.CarDivType1UseCarCnt[j] + "/" + val.ItemValues.CarDivType1Cnt[j];
            });
            itemObj = {};

            itemObj.CenterCode = key;
            itemObj.CenterName = val.CenterName;
            itemObj.CarDivType = "지입";
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.CarDivType4UseCarCnt[j] + "/" +val.ItemValues.CarDivType4Cnt[j];
            });
            itemObj = {};

            itemObj.CenterCode = key;
            itemObj.CenterName = val.CenterName;
            itemObj.CarDivType = "고정";
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.CarDivType6UseCarCnt[j] + "/" + val.ItemValues.CarDivType6Cnt[j];
            });
            itemObj = {};

            itemObj.CenterCode = key;
            itemObj.CenterName = val.CenterName;
            itemObj.CarDivType = "합계";
            itemObj.sty
            arrDataTablePre.push(itemObj);
            $.each(val.TickValues, function (j, data) {
                itemObj[data] = val.ItemValues.TotCarDivTypeUseCarCnt[j] + "/" + val.ItemValues.TotalCnt[j];
            });
            itemObj = {};

        }); //end of $.each(chartDataObject, function (key, val)

        arrDataTable = arrDataTablePre;

        if (arrDataTable !== "") {
            fnGridInit();
            AUIGrid.setGridData(GridID, arrDataTable);
        }
    }
}

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

//기본 레이아웃 세팅
function fnCreateGridLayout(strGID) {
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
        rowStyleFunction: function (rowIndex, item) {
            // 그룹핑을 더 많은 필드로 하여 depth 가 많아진 경우는 그에 맞게 스타일을 정의하십시오.
            // 현재 3개의 스타일이 기본으로 정의됨.(AUIGrid_style.css)
            switch (item.CarDivType) {  // 계층형의 depth 비교 연산
                case "합계":
                    return "aui-grid-row-depth3-style";
            }
            return null;
        } // end of rowStyleFunction
    };

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
        {
            dataField: "CenterCode",
            headerText: "회원사코드",
            width: 0,
            visible: false,
            cellMerge: true
        },
        {
            dataField: "CenterName",
            headerText: "회원사명",
            width: 150,
            editable: true,
            renderer: { // HTML 템플릿 렌더러 사용
                type: "TemplateRenderer"
            },
            cellMerge: true,
            filter: {
                showIcon: true
            }
        }, {
            dataField: "CarDivType",
            headerText: "차량구분",
            width: 100,
            editable: false
        }
    ];

    if (tableColListJson) {
        $.each(tableColListJson, function (i, val) {

            var colObj = {};
            var dateStr = "";
            dateStr = GetStrMonthFormat(val.YMD, "-");
            colObj.dataField = dateStr;
            colObj.headerText = GetStrMonthFormat(val.YMD, "-");

            colObj.width = 100;
            colObj.editable = false;
            colObj.dataType = "numeric";
            colObj.style = "aui-grid-my-column-right";
            colObj.labelFunction =
                function (rowIndex, columnIndex, value, headerText, item) {
                    if (typeof (item[dateStr]) === "undefined") {
                        return 0;
                    }
                    return value;
                };
            ColumnLayout.push(colObj);
        });
    }

    return ColumnLayout;
}

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