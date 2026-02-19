window.name = "DepositMonthlyList";
// 그리드
var GridID = "#DepositMonthlyListGrid";

var ViewCalendarFlag = false; //캘린더 날짜 선택 표시 여부
$(document).ready(function () {
    $("#UpdateYM").datepicker({
        dateFormat: "yy-mm",
        currentText: "이번달",
        closeText: "선택",
        onSelect: function (dateText, inst) {
            var year = inst.selectedYear;
            var month = inst.selectedMonth;
            $(this).datepicker("setDate", new Date(year, month, 1));
        },
        onClose: function (dateText, inst) {
            var year = inst.selectedYear;
            var month = inst.selectedMonth;
            $(this).datepicker("setDate", new Date(year, month, 1));
        }
    });
    $("#UpdateYM").datepicker("setDate", new Date());
    
    $(document).on("click", ".ui-datepicker-next", function () {
        if (ViewCalendarFlag) {
            $(".ui-datepicker-calendar").show();
        } else {
            $(".ui-datepicker-calendar").hide();
        }
    });

    $(document).on("click", '.ui-datepicker-prev', function () {
        if (ViewCalendarFlag) {
            $(".ui-datepicker-calendar").show();
        } else {
            $(".ui-datepicker-calendar").hide();
        }
    });

    $("#ChkViewMonth input[type='checkbox']").prop("checked", true);

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

    $("#ChkViewMonth input[type='checkbox']").bind("click", function (e) {
        var ChkAll = true;

        if ($(this).parent("li").children("label").children("span").hasClass("ChkAll")) { //전체체크
            $("input[type='checkbox'][id^='ChkViewMonth']").prop("checked", $(this).is(":checked"));
        } else {
            for (var i = 1; i <= 12; i++) {
                if (!$("input[type='checkbox'][id='ChkViewMonth_"+i+"']").is(":checked")) {
                    ChkAll = false;
                    break;
                }
            }
            $("input[type='checkbox'][id='ChkViewMonth_0']").prop("checked", ChkAll);
        }

        fnMonthColumnsSet();
    });
});


function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "ClientCode");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "fnGridReady", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 200;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 200);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 200);
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
    objGridProps.fixedColumnCount = 8; // 고정 칼럼 개수
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
        {
            dataField: "ClientNameSimple",
            headerText: "거래처명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "ClientCorpNo",
            headerText: "사업자번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClientBusinessStatusM",
            headerText: "거래상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClientPayDayM",
            headerText: "여신일",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CsAdminNames",
            headerText: "업무담당",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "CsClosingAdminNames",
            headerText: "마감담당",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "Note",
            headerText: "확인내용",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "TotalUnpaidAmt",
            headerText: "채권잔액",
            editable: false,
            width: 100,
            dataType: "numeric",
            filter: { showIcon: true },
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            headerText: "1월",
            children: [{
                dataField: "SaleAmt1",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt1",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt1 - item.SaleDepositAmt1;
                }
            }, {
                dataField: "AdvanceAmt1",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt1",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt1 - item.AdvanceDepositAmt1;
                }
            }]
        },
        {
            headerText: "2월",
            children: [{
                dataField: "SaleAmt2",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt2",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt2 - item.SaleDepositAmt2;
                }
            }, {
                dataField: "AdvanceAmt2",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt2",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt2 - item.AdvanceDepositAmt2;
                }
            }]
        },
        {
            headerText: "3월",
            children: [{
                dataField: "SaleAmt3",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt3",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt3 - item.SaleDepositAmt3;
                }
            }, {
                dataField: "AdvanceAmt3",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt3",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt3 - item.AdvanceDepositAmt3;
                }
            }]
        },
        {
            headerText: "4월",
            children: [{
                dataField: "SaleAmt4",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt4",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt4 - item.SaleDepositAmt4;
                }
            }, {
                dataField: "AdvanceAmt4",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt4",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt4 - item.AdvanceDepositAmt4;
                }
            }]
        },
        {
            headerText: "5월",
            children: [{
                dataField: "SaleAmt5",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt5",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt5 - item.SaleDepositAmt5;
                }
            }, {
                dataField: "AdvanceAmt5",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt5",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt5 - item.AdvanceDepositAmt5;
                }
            }]
        },
        {
            headerText: "6월",
            children: [{
                dataField: "SaleAmt6",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt6",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt6 - item.SaleDepositAmt6;
                }
            }, {
                dataField: "AdvanceAmt6",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt6",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt6 - item.AdvanceDepositAmt6;
                }
            }]
        },
        {
            headerText: "7월",
            children: [{
                dataField: "SaleAmt7",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt7",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt7 - item.SaleDepositAmt7;
                }
            }, {
                dataField: "AdvanceAmt7",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt7",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt7 - item.AdvanceDepositAmt7;
                }
            }]
        },
        {
            headerText: "8월",
            children: [{
                dataField: "SaleAmt8",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt8",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt8 - item.SaleDepositAmt8;
                }
            }, {
                dataField: "AdvanceAmt8",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt8",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt8 - item.AdvanceDepositAmt8;
                }
            }]
        },
        {
            headerText: "9월",
            children: [{
                dataField: "SaleAmt9",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt9",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt9 - item.SaleDepositAmt9;
                }
            }, {
                dataField: "AdvanceAmt9",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt9",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt9 - item.AdvanceDepositAmt9;
                }
            }]
        },
        {
            headerText: "10월",
            children: [{
                dataField: "SaleAmt10",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt10",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt10 - item.SaleDepositAmt10;
                }
            }, {
                dataField: "AdvanceAmt10",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt10",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt10 - item.AdvanceDepositAmt10;
                }
            }]
        },
        {
            headerText: "11월",
            children: [{
                dataField: "SaleAmt11",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt11",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt11 - item.SaleDepositAmt11;
                }
            }, {
                dataField: "AdvanceAmt11",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt11",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt11 - item.AdvanceDepositAmt11;
                }
            }]
        },
        {
            headerText: "12월",
            children: [{
                dataField: "SaleAmt12",
                headerText: "매출",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "SaleUnpaidAmt12",
                headerText: "매출미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.SaleAmt12 - item.SaleDepositAmt12;
                }
            }, {
                dataField: "AdvanceAmt12",
                headerText: "선급",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }, {
                dataField: "AdvanceUnpaidAmt12",
                headerText: "선급미수",
                dataType: "numeric",
                style: "aui-grid-text-right",
                width: 80,
                labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                    return AUIGrid.formatNumber(value, "#,##0");
                },
                expFunction: function (rowIndex, columnIndex, item, dataField) {
                    return item.AdvanceAmt12 - item.AdvanceDepositAmt12;
                }
            }]
        },
        /*숨김필드*/
        {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "CenterName",
            headerText: "CenterName",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "SaleDepositAmt1",
            headerText: "SaleDepositAmt1",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt1",
            headerText: "AdvanceDepositAmt1",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt2",
            headerText: "SaleDepositAmt2",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt2",
            headerText: "AdvanceDepositAmt2",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt3",
            headerText: "SaleDepositAmt3",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt3",
            headerText: "AdvanceDepositAmt3",
            editable: false,
            width: 0,
            visible: false,

        },
        {
            dataField: "SaleDepositAmt4",
            headerText: "SaleDepositAmt4",
            editable: false,
            width: 0,
            visible: false,

        },
        {
            dataField: "AdvanceDepositAmt4",
            headerText: "AdvanceDepositAmt4",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt5",
            headerText: "SaleDepositAmt5",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt5",
            headerText: "AdvanceDepositAmt5",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt6",
            headerText: "SaleDepositAmt6",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt6",
            headerText: "AdvanceDepositAmt6",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt7",
            headerText: "SaleDepositAmt7",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt7",
            headerText: "AdvanceDepositAmt7",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt8",
            headerText: "SaleDepositAmt8",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt8",
            headerText: "AdvanceDepositAmt8",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt9",
            headerText: "SaleDepositAmt9",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt9",
            headerText: "AdvanceDepositAmt9",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt10",
            headerText: "SaleDepositAmt10",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt10",
            headerText: "AdvanceDepositAmt10",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt11",
            headerText: "SaleDepositAmt11",
            editable: false,
            width: 0,
            visible: false,

        },
        {
            dataField: "AdvanceDepositAmt11",
            headerText: "AdvanceDepositAmt11",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "SaleDepositAmt12",
            headerText: "SaleDepositAmt12",
            editable: false,
            width: 0,
            visible: false
        },
        {
            dataField: "AdvanceDepositAmt12",
            headerText: "AdvanceDepositAmt12",
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

function fnGridReady(event) {
    var footer = AUIGrid.getFooterData(GridID);
    var monthCnt = 1;
    var cnt = 0;
    var mny = 0;
    var allText = "";
    for (var i = 2; i < footer.length; i++) {

        cnt++;
        if (cnt === 2 || cnt === 4) {
            mny += footer[i].value;
        }

        if (cnt === 4) {
            allText += monthCnt + "월 : " + fnMoneyComma(mny) + " 원 " + (monthCnt < 12 ? "&nbsp;&nbsp;/&nbsp;&nbsp;" : "");
            monthCnt++;
            mny = 0;
            cnt = 0;
        }
    }
    $("#GridResult2").html(allText);
}

function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    fnOpenMonthlyNote(objItem);
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
function fnCallGridData(strGID) {
    $("#RecordCnt").val(0);
    $("#GridResult").html("");
    AUIGrid.setGridData(GridID, []);

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositMonthlyHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "PayMisuList",
        CenterCode: $("#CenterCode").val(),
        Year: $("#SearchYear").val(),
        ClientBusinessStatus: $("#ClientBusinessStatus").val(),
        ClientName: $("#ClientName").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {
        AUIGrid.removeAjaxLoader(GridID);
        
        if (objRes[0].RetCode) {
            if (objRes[0].result.ErrorCode !== 0) {
                fnDefaultAlert(objRes[0].result.ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {
    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "CenterName",
            dataField: "CenterName",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TotalUnpaidAmt",
            dataField: "TotalUnpaidAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt1",
            dataField: "SaleAmt1",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt1",
            dataField: "SaleUnpaidAmt1",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt1",
            dataField: "AdvanceAmt1",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt1",
            dataField: "AdvanceUnpaidAmt1",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt2",
            dataField: "SaleAmt2",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt2",
            dataField: "SaleUnpaidAmt2",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt2",
            dataField: "AdvanceAmt2",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt2",
            dataField: "AdvanceUnpaidAmt2",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt3",
            dataField: "SaleAmt3",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt3",
            dataField: "SaleUnpaidAmt3",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt3",
            dataField: "AdvanceAmt3",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt3",
            dataField: "AdvanceUnpaidAmt3",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt4",
            dataField: "SaleAmt4",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt4",
            dataField: "SaleUnpaidAmt4",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt4",
            dataField: "AdvanceAmt4",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt4",
            dataField: "AdvanceUnpaidAmt4",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt5",
            dataField: "SaleAmt5",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt5",
            dataField: "SaleUnpaidAmt5",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt5",
            dataField: "AdvanceAmt5",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt5",
            dataField: "AdvanceUnpaidAmt5",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt6",
            dataField: "SaleAmt6",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt6",
            dataField: "SaleUnpaidAmt6",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt6",
            dataField: "AdvanceAmt6",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt6",
            dataField: "AdvanceUnpaidAmt6",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt7",
            dataField: "SaleAmt7",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt7",
            dataField: "SaleUnpaidAmt7",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt7",
            dataField: "AdvanceAmt7",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt7",
            dataField: "AdvanceUnpaidAmt7",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt8",
            dataField: "SaleAmt8",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt8",
            dataField: "SaleUnpaidAmt8",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt8",
            dataField: "AdvanceAmt8",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt8",
            dataField: "AdvanceUnpaidAmt8",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt9",
            dataField: "SaleAmt9",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt9",
            dataField: "SaleUnpaidAmt9",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt9",
            dataField: "AdvanceAmt9",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt9",
            dataField: "AdvanceUnpaidAmt9",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt10",
            dataField: "SaleAmt10",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt10",
            dataField: "SaleUnpaidAmt10",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt10",
            dataField: "AdvanceAmt10",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt10",
            dataField: "AdvanceUnpaidAmt10",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt11",
            dataField: "SaleAmt11",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt11",
            dataField: "SaleUnpaidAmt11",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt11",
            dataField: "AdvanceAmt11",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt11",
            dataField: "AdvanceUnpaidAmt11",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt12",
            dataField: "SaleAmt12",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt12",
            dataField: "SaleUnpaidAmt12",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt12",
            dataField: "AdvanceAmt12",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt12",
            dataField: "AdvanceUnpaidAmt12",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

function fnMonthColumnsSet() {
    for (i = 1; i <= 12; i++) {
        if ($("#ChkViewMonth_" + i).is(":checked")) {
            AUIGrid.showColumnByDataField(GridID, ["SaleAmt" + i, "SaleUnpaidAmt" + i, "AdvanceAmt" + i, "AdvanceUnpaidAmt" + i]);
        } else {
            AUIGrid.hideColumnByDataField(GridID, ["SaleAmt" + i, "SaleUnpaidAmt" + i, "AdvanceAmt" + i, "AdvanceUnpaidAmt" + i]);
        }
    }
}

function fnOpenMonthlyNote(objItem) {
    fnOpenRightSubLayer("미수업체 확인정보", "/TMS/ClosingSaleDeposit/DepositMonthlyNoteIns?DepositCenterCode=" + objItem.CenterCode + "&ClientCode=" + objItem.ClientCode, "500px", "700px", "80%");
    return false;
}

//업데이트
function fnUpdData() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#UpdateYM").val()) {
        fnDefaultAlertFocus("업데이트 할 연월을 선택하세요.", "UpdateYM", "warning");
        return false;
    }

    fnDefaultConfirm("업데이트를 진행하시겠습니까?", "fnUpdDataProc", "");
    return false;
}

function fnUpdDataProc() {
    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositMonthlyHandler.ashx";
    var strCallBackFunc = "fnUpdDataSuccResult";
    var strFailCallBackFunc = "fnUpdDataFailResult";
    var objParam = {
        CallType: "PayMisuInsert",
        CenterCode: $("#CenterCode").val(),
        UpdateYM: $("#UpdateYM").val()
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnUpdDataSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("업데이트가 완료되었습니다.", "info");
            fnCallGridData(GridID);
            return false;
        } else {
            fnUpdDataFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnUpdDataFailResult();
        return false;
    }
}

function fnUpdDataFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}