window.name = "DepositList";
// 그리드
var GridID = "#DepositClientListGrid";

var ViewCalendarFlag = false; //캘린더 날짜 선택 표시 여부

$(document).ready(function () {
    $("#DateFrom").datepicker({
        dateFormat:"yy-mm",
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

    $("#DateFrom2").datepicker({
        dateFormat: "yy-mm",
        currentText: "이번달",
        closeText: "선택",
        onSelect: function (dateText, inst) {
            var year = inst.selectedYear;
            var month = inst.selectedMonth;

            dateText = year + (parseInt(month) < 10 ? "0" : "") + month;
            var DateTo2Text = $("#DateTo2").val().replace(/-/gi, "");
            if (DateTo2Text.length !== 6) {
                DateTo2Text = GetDateTo2day("").substr(0, 6);
            }

            if (parseInt(dateText.replace(/-/gi, "")) > parseInt(DateTo2Text)) {
                $("#DateTo2").datepicker("setDate", new Date(year, month, 1));
            }
        },
        onClose: function (dateText, inst) {
            var year = inst.selectedYear;
            var month = inst.selectedMonth;
            $(this).datepicker("setDate", new Date(year, month, 1));

            dateText = year + (parseInt(month) < 10 ? "0" : "") + month;
            var DateTo2Text = $("#DateTo2").val().replace(/-/gi, "");
            if (DateTo2Text.length !== 6) {
                DateTo2Text = GetDateTo2day("").substr(0, 6);
            }

            if (parseInt(dateText.replace(/-/gi, "")) > parseInt(DateTo2Text)) {
                $("#DateTo2").datepicker("setDate", new Date(year, month, 1));
            }
        }
    });
    $("#DateFrom2").datepicker("setDate", new Date());

    $("#DateTo2").datepicker({
        dateFormat: "yy-mm",
        currentText: "이번달",
        closeText: "선택",
        onSelect: function (dateText, inst) {
            var year = inst.selectedYear;
            var month = inst.selectedMonth;
            $(this).datepicker("setDate", new Date(year, month, 1));

            dateText = year + (parseInt(month) < 10 ? "0" : "") + month;
            var DateFrom2Text = $("#DateFrom2").val().replace(/-/gi, "");
            if (DateFrom2Text.length !== 6) {
                DateFrom2Text = GetDateTo2day("").substr(0, 6);
            }

            if (parseInt(dateText.replace(/-/gi, "")) < parseInt(DateFrom2Text)) {
                $("#DateFrom2").datepicker("setDate", new Date(year, month, 1));
            }
        },
        onClose: function (dateText, inst) {
            var year = inst.selectedYear;
            var month = inst.selectedMonth;
            $(this).datepicker("setDate", new Date(year, month, 1));

            dateText = year + (parseInt(month) < 10 ? "0" : "") + month;
            var DateFrom2Text = $("#DateFrom2").val().replace(/-/gi, "");
            if (DateFrom2Text.length !== 6) {
                DateFrom2Text = GetDateTo2day("").substr(0, 6);
            }

            if (parseInt(dateText.replace(/-/gi, "")) < parseInt(DateFrom2Text)) {
                $("#DateFrom2").datepicker("setDate", new Date(year, month, 1));
            }
        }
    });
    $("#DateTo2").datepicker("setDate", new Date());
    
    $("#InputYMD").datepicker({
        dateFormat: "yy-mm-dd",
        onClose: function () {
            ViewCalendarFlag = false;
        }
    });

    $("#InputYMD").click(function () {
        $(".ui-datepicker-calendar").show();
        ViewCalendarFlag = true;
    }).focus(function () {
        $(".ui-datepicker-calendar").show();
        ViewCalendarFlag = true;
    });

    $("#InputYM").datepicker({
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
    $("#InputYM").datepicker("setDate", new Date());


    if ($("#SetOffClientName").length > 0) {
        fnSetAutocomplete({
            formId: "SetOffClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    ChargeFlag: "N",
                    CenterCode: $("#HidCenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#HidCenterCode").val()) {
                        fnDefaultAlert("검색 후 거래처를 선택하세요.", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#SetOffClientCode").val(ui.item.etc.ClientCode);
                    $("#SetOffClientName").val(ui.item.etc.ClientName);
                    $("#SetOffNote").focus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                },
                onBlur: () => {
                    if (!$("#SetOffClientName").val()) {
                        $("#SetOffClientCode").val("");
                    }
                }
            }
        });
    }

    $("#SetOffInputYM").datepicker({
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
    $("#SetOffInputYM").datepicker("setDate", new Date());

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

    $("#Amt").on("keyup blur",
        function () {
            $(this).val(fnMoneyComma($(this).val()));
        });

    $("#SetOffAmt").on("keyup blur",
        function () {
            $(this).val(fnMoneyComma($(this).val()));
        });
    
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
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "ClientCode");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 95;
    AUIGrid.resize(GridID, $(".grid_type_03 > div.left").width() - 5, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_type_03 > div.left").width() - 5, $(document).height() - 95);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_type_03 > div.left").width() - 5, $(document).height() - 95);
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
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    //objGridProps.rowStyleFunction = function (rowIndex, item) {
    //    if (item.NoMatchingCnt > 0) { //
    //        return "aui-grid-carryover-y-row-style";
    //    }
    //
    //    return "";
    //}

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
            dataField: "ClientPayDayM",
            headerText: "여신일",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "MisuAmt",
            headerText: "여신일초과미수금",
            editable: false,
            width: 120,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "TotalMisuAmt",
            headerText: "채권잔액",
            editable: false,
            width: 120,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "NoMatchingCnt",
            headerText: "미매칭전표수",
            editable: false,
            width: 120,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
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
            dataField: "BtnMisuUpd",
            headerText: "미수금정보",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "업데이트",
                onClick: function (event) {
                    fnSetMisuUpd(event.item);
                }
            }
        },
        /*숨김필드*/
        {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CenterName",
            headerText: "CenterName",
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
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return false;
    }

    fnSetDetailList(objItem);
}

function fnSetDetailList(objItem) {
    AUIGrid.setGridData(GridDepositID, []);
    AUIGrid.setGridData(GridDepositSaleID, []);
    AUIGrid.setGridData(GridDepositDetailID, []);
    AUIGrid.setGridData(GridDepositSetOffID, []);
    $("#BtnResetDeposit").click();
    $("#BtnResetSetOff").click();
    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidClientCode").val(objItem.ClientCode);
    $("#HidClientName").val(objItem.ClientName);

    $("#CenterCode").val(objItem.CenterCode);

    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val()) {
        return false;
    }

    fnCallDepositGridData(GridDepositID);
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

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    AUIGrid.setGridData(GridID, []);
    AUIGrid.setGridData(GridDepositID, []);
    AUIGrid.setGridData(GridDepositSaleID, []);
    AUIGrid.setGridData(GridDepositDetailID, []);
    AUIGrid.setGridData(GridDepositSetOffID, []);
    $("#BtnResetDeposit").click();
    $("#BtnResetSetOff").click();
    $("#HidCenterCode").val("");
    $("#HidClientCode").val("");
    $("#HidClientName").val("");

    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "DepositClientList",
        CenterCode: $("#CenterCode").val(),
        ClientName: $("#ClientName").val(),
        CsAdminName: $("#CsAdminName").val(),
        CsClosingAdminName: $("#CsClosingAdminName").val()
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
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridID, objRes[0].data.list);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {
    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "ClientNameSimple",
            dataField: "ClientNameSimple",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "MisuAmt",
            dataField: "MisuAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TotalMisuAmt",
            dataField: "TotalMisuAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/
// 총미수내역 그리드
/**********************************************************/
var GridDepositID = "#DepositClientTotalListGrid";

$(document).ready(function () {
    if ($(GridDepositID).length > 0) {
        // 그리드 초기화
        fnDepositGridInit();
    }
});

function fnDepositGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDepositGridLayout(GridDepositID, "InputYM");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDepositID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    var intHeight = 168;

    AUIGrid.resize(GridDepositID, $(".grid_type_03 > div.right").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridDepositID, $(".grid_type_03 > div.right").width(), intHeight);

        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridDepositID, $(".grid_type_03 > div.right").width(), intHeight);
        }, 100);
    });

    // 푸터
    fnSetDepositGridFooter(GridDepositID);
}

//기본 레이아웃 세팅
function fnCreateDepositGridLayout(strGID, strRowIdField) {

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
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    objGridProps.applyRestPercentWidth = true; //칼럼 레이아웃 작성 시 칼럼의 width 를 퍼센티지(%) 로 설정
    objGridProps.fillColumnSizeMode = true;

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDepositDefaultColumnLayout()");
    var objOriLayout = fnGetDepositDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDepositDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "InputYM",
            headerText: "작성월",
            editable: false,
            width: "10%",
            dataType: "date",
            formatString: "yyyy-mm",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "TotalUnpaidAmt",
            headerText: "채권잔액",
            editable: false,
            width: "12%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) {
                return item.SaleAmt - item.SaleDepositAmt + item.AdvanceAmt - item.AdvanceDepositAmt - item.SetOffAmt;
            }
        },
        {
            dataField: "SaleAmt",
            headerText: "매출",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SaleDepositAmt",
            headerText: "매출입금",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SaleUnpaidAmt",
            headerText: "매출미수",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) {
                return item.SaleAmt - item.SaleDepositAmt;
            }
        },
        {
            dataField: "AdvanceAmt",
            headerText: "선급",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "AdvanceDepositAmt",
            headerText: "선급입금",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "AdvanceUnpaidAmt",
            headerText: "선급미수",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) {
                return item.AdvanceAmt - item.AdvanceDepositAmt;
            }
        },
        {
            dataField: "SetOffAmt",
            headerText: "상계",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
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
            dataField: "ClientCode",
            headerText: "ClientCode",
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
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDepositGridData(strGID) {
    AUIGrid.setGridData(strGID, []);

    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnDepositGridSuccResult";

    var objParam = {
        CallType: "DepositClientTotalList",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDepositGridSuccResult(objRes) {

    if (objRes) {
        AUIGrid.removeAjaxLoader(GridDepositID);

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridDepositID, objRes[0].data.list);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDepositGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "InputYM",
            dataField: "InputYM",
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
            positionField: "SaleAmt",
            dataField: "SaleAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleDepositAmt",
            dataField: "SaleDepositAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt",
            dataField: "SaleUnpaidAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt",
            dataField: "AdvanceAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceDepositAmt",
            dataField: "AdvanceDepositAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt",
            dataField: "AdvanceUnpaidAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SetOffAmt",
            dataField: "SetOffAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}
/**********************************************************/


/**********************************************************/
// 매출마감 그리드
/**********************************************************/
var GridDepositSaleID = "#DepositSaleListGrid";

$(document).ready(function () {
    if ($(GridDepositSaleID).length > 0) {
        // 그리드 초기화
        fnDepositSaleGridInit();
    }
});

function fnDepositSaleGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDepositSaleGridLayout(GridDepositSaleID, "SaleClosingSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDepositSaleID, "", "", "", "", "", "", "", "fnGridDepositSaleCellDblClick");

    // 사이즈 세팅
    var intHeight = $("#DivSetOffWrap").css("display") === "none" ? 365 : 173;
    AUIGrid.resize(GridDepositSaleID, $(".grid_type_03 > div.right").width() / 2 - 5, intHeight);
    
    // 브라우저 리사이징
    $(window).on("resize", function () {
        intHeight = $("#DivSetOffWrap").css("display") === "none" ? 365 : 173;

        AUIGrid.resize(GridDepositSaleID, $(".grid_type_03 > div.right").width() / 2 - 5, intHeight);

        clearTimeout(window.resizedEnd3);
        window.resizedEnd3 = setTimeout(function () {
            AUIGrid.resize(GridDepositSaleID, $(".grid_type_03 > div.right").width() / 2 - 5, intHeight);
        }, 100);
    });

    // 푸터
    fnSetDepositSaleGridFooter(GridDepositSaleID);
}

//기본 레이아웃 세팅
function fnCreateDepositSaleGridLayout(strGID, strRowIdField) {

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
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    objGridProps.applyRestPercentWidth = false; //칼럼 레이아웃 작성 시 칼럼의 width 를 퍼센티지(%) 로 설정
    objGridProps.fillColumnSizeMode = false;
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (AUIGrid.isCheckedRowById(strGID, item.SaleClosingSeqNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.MatchingClosingSeqNo != "") { //
            return "aui-grid-closing-y-row-style";
        }

        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDepositSaleDefaultColumnLayout()");
    var objOriLayout = fnGetDepositSaleDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        fnSetCheckedSale();
    });

    // 전체 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowAllChkClick", function (event) {
        if (event.checked) {
            //var objItemsChecked = [];
            //$.each(AUIGrid.getGridData(event.pid), function (index, item) {
            //    if (item.ClosingFlag != "Y") {
            //        objItemsChecked.push(item.AdvanceSeqNo);
            //    }
            //});
            //AUIGrid.setCheckedRowsByIds(event.pid, objItemsChecked);
        } else {
            //var objItemsChecked = [];
            //$.each(AUIGrid.getCheckedRowItems(event.pid), function (index, item) {
            //    objItemsChecked.push(item.item.AdvanceSeqNo);
            //});
            //AUIGrid.addUncheckedRowsByIds(event.pid, objItemsChecked);
        }

        fnSetCheckedSale();
    });
};

function fnSetCheckedSale() {
    var strInputYM = "000000";
    var intTotalOrgAmt = 0;
    var intOrgAmt = 0;
    var intNoMatchingCnt = 0;
    var arrSaleClosingSeqNo = [];
    var strInputYMD = $("#InputYMD").val();
    $("#BtnResetDeposit").click();
    $("#SpanDepositSaleCnt").text("");
    $("#InputYMD").val(strInputYMD);

    var objCheckedItems = AUIGrid.getCheckedRowItems(GridDepositSaleID);
    if (objCheckedItems.length > 0) {
        $.each(objCheckedItems, function (intIndex, objItem) {
            intTotalOrgAmt += objItem.item.OrgAmt;

            if (objItem.item.MatchingClosingSeqNo == "") {
                strInputYM = strInputYM < objItem.item.BillWriteYM ? objItem.item.BillWriteYM : strInputYM;
                intOrgAmt += objItem.item.OrgAmt;
                arrSaleClosingSeqNo.push(objItem.item.SaleClosingSeqNo);
                intNoMatchingCnt++;
            }
        });

        $("#SpanDepositSaleCnt").text(UTILJS.Util.fnComma(objCheckedItems.length) + "건 / " + fnMoneyComma(intTotalOrgAmt) + "원");

        if (intNoMatchingCnt > 0) {
            $("#SaleClosingSeqNos").val(arrSaleClosingSeqNo.length > 0 ? arrSaleClosingSeqNo.join(",") : "");
            $("#Amt").val(fnMoneyComma(intOrgAmt));
            $("#InputYM").datepicker("setDate", new Date(strInputYM.substr(0, 4), parseInt(strInputYM.substr(4, 2) - 1), 1));
        }
    } else {
        return false;
    }
}

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDepositSaleDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "BillWriteYM",
            headerText: "작성월",
            editable: false,
            width: 60,
            dataType: "date",
            formatString: "yyyy-mm",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "BillWrite",
            headerText: "작성일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SaleClosingSeqNo",
            headerText: "매출전표번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "MatchingClosingSeqNo",
            headerText: "매칭전표번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrgAmt",
            headerText: "금액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "ClosingDate",
            headerText: "마감일",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClosingAdminName",
            headerText: "마감자",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "BtnDetail",
            headerText: "상세내역",
            editable: false,
            width: 80,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    fnOpenSaleDetailList(event.item)
                }
            },
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
            dataField: "ClientCode",
            headerText: "ClientCode",
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
function fnGridDepositSaleCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    fnOpenSaleDetailList(objItem);
}

//마감상세
function fnOpenSaleDetailList(objItem) {
    fnOpenRightSubLayer("매출 마감 상세", "/TMS/ClosingSale/SaleClosingDetailList?ClosingCenterCode=" + objItem.CenterCode + "&SaleClosingSeqNo=" + objItem.SaleClosingSeqNo, "500px", "700px", "80%");
    return false;
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDepositSaleGridData(strGID) {
    $("#SpanDepositSaleCnt").text("");
    AUIGrid.setGridData(strGID, []);

    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnDepositSaleGridSuccResult";

    var objParam = {
        CallType: "DepositSaleList",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        NoMatchingFlag: $("#ChkNoMatching").is(":checked") ? "Y" : ""
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDepositSaleGridSuccResult(objRes) {

    if (objRes) {
        AUIGrid.removeAjaxLoader(GridDepositSaleID);
        
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridDepositSaleID, objRes[0].data.list);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDepositSaleGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "BillWriteYM",
            dataField: "BillWriteYM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "OrgAmt",
            dataField: "OrgAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}
/**********************************************************/

/**********************************************************/
// 입금내역 그리드
/**********************************************************/
var GridDepositDetailID = "#DepositDetailListGrid";

$(document).ready(function () {
    if ($(GridDepositDetailID).length > 0) {
        // 그리드 초기화
        fnDepositDetailGridInit();
    }
});

function fnDepositDetailGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDepositDetailGridLayout(GridDepositDetailID, "DepositClosingSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDepositDetailID, "", "", "", "", "", "", "", "fnGridDepositDetailDblClick");

    // 사이즈 세팅
    var intHeight = $("#DivSetOffWrap").css("display") === "none" ? 365 : 173;
    AUIGrid.resize(GridDepositDetailID, $(".grid_type_03 > div.right").width() / 2, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        intHeight = $("#DivSetOffWrap").css("display") === "none" ? 365 : 173;

        AUIGrid.resize(GridDepositDetailID, $(".grid_type_03 > div.right").width() / 2, intHeight);

        clearTimeout(window.resizedEnd4);
        window.resizedEnd4 = setTimeout(function () {
            AUIGrid.resize(GridDepositDetailID, $(".grid_type_03 > div.right").width() / 2, intHeight);
        }, 100);
    });

    // 푸터
    fnSetDepositDetailGridFooter(GridDepositDetailID);
}

//기본 레이아웃 세팅
function fnCreateDepositDetailGridLayout(strGID, strRowIdField) {

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
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    objGridProps.applyRestPercentWidth = false; //칼럼 레이아웃 작성 시 칼럼의 width 를 퍼센티지(%) 로 설정
    objGridProps.fillColumnSizeMode = false;
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (AUIGrid.isCheckedRowById(strGID, item.DepositClosingSeqNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.MatchingClosingSeqNo != "") { //
            return "aui-grid-closing-y-row-style";
        }

        return "";
    }

    objGridProps.rowCheckDisabledFunction = function (rowIndex, isChecked, item) {
        if (item.MatchingClosingSeqNo != "") {
            return false; // false 반환하면 disabled 처리됨
        }
        return true;
    }

    objGridProps.rowCheckableFunction = function (rowIndex, isChecked, item) {
        if (item.MatchingClosingSeqNo != "") {
            return false; // false 반환하면 disabled 처리됨
        }
        return true;
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDepositDetailDefaultColumnLayout()");
    var objOriLayout = fnGetDepositDetailDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        fnSetCheckedDeposit();
    });

    // 전체 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowAllChkClick", function (event) {

        if (event.checked) {
            var objItemsChecked = [];
            $.each(AUIGrid.getGridData(event.pid), function (index, item) {
                if (item.MatchingClosingSeqNo == "") {
                    objItemsChecked.push(item.DepositClosingSeqNo);
                }
            });
            AUIGrid.setCheckedRowsByIds(event.pid, objItemsChecked);
        } else {
            var objItemsChecked = [];
            $.each(AUIGrid.getCheckedRowItems(event.pid), function (index, item) {
                objItemsChecked.push(item.item.DepositClosingSeqNo);
            });
            AUIGrid.addUncheckedRowsByIds(event.pid, objItemsChecked);
        }

        fnSetCheckedDeposit();
    });
};

function fnSetCheckedDeposit() {
    var intAmt = 0;
    $("#SpanDepositDetailCnt").text("");

    var objCheckedItems = AUIGrid.getCheckedRowItems(GridDepositDetailID);
    if (objCheckedItems.length > 0) {
        $.each(objCheckedItems, function (intIndex, objItem) {
            intAmt += objItem.item.Amt;
        });

        $("#SpanDepositDetailCnt").text(UTILJS.Util.fnComma(objCheckedItems.length) + "건 / " + fnMoneyComma(intAmt) + "원");
    } else {
        return false;
    }
}

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDepositDetailDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "InputYM",
            headerText: "작성월",
            editable: false,
            width: 60,
            dataType: "date",
            formatString: "yyyy-mm",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "InputYMD",
            headerText: "입금일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DepositClosingSeqNo",
            headerText: "입금전표번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "MatchingClosingSeqNo",
            headerText: "매칭전표번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Amt",
            headerText: "금액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "Note",
            headerText: "적요",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "RegDate",
            headerText: "등록일",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "RegAdminName",
            headerText: "등록자",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
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
            dataField: "ClientCode",
            headerText: "ClientCode",
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
function fnGridDepositDetailDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    fnSetDeposit(objItem);
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDepositDetailGridData(strGID) {
    $("#SpanDepositDetailCnt").text("");
    AUIGrid.setGridData(strGID, []);

    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnDepositDetailGridSuccResult";

    var objParam = {
        CallType: "DepositDetailList",
        DepositTypes: "5",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        NoMatchingFlag: $("#ChkNoMatching").is(":checked") ? "Y" : ""
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDepositDetailGridSuccResult(objRes) {

    if (objRes) {
        AUIGrid.removeAjaxLoader(GridDepositDetailID);

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }
        
        AUIGrid.setGridData(GridDepositDetailID, objRes[0].data.list);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDepositDetailGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "InputYM",
            dataField: "InputYM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Amt",
            dataField: "Amt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}
/**********************************************************/


/**********************************************************/
// 입금내역 그리드
/**********************************************************/
var GridDepositSetOffID = "#DepositSetOffListGrid";

$(document).ready(function () {
    if ($(GridDepositSetOffID).length > 0) {
        // 그리드 초기화
        fnDepositSetOffGridInit();
    }
});

function fnDepositSetOffGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDepositSetOffGridLayout(GridDepositSetOffID, "SaleClosingSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDepositSetOffID, "", "", "", "", "", "", "", "fnGridDepositSetOffCellDblClick");

    // 사이즈 세팅
    var intHeight = 145;

    AUIGrid.resize(GridDepositSetOffID, $(".grid_type_03 > div.right").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridDepositSetOffID, $(".grid_type_03 > div.right").width(), intHeight);

        clearTimeout(window.resizedEnd5);
        window.resizedEnd5 = setTimeout(function () {
            AUIGrid.resize(GridDepositSetOffID, $(".grid_type_03 > div.right").width(), intHeight);
        }, 100);
    });

    // 푸터
    fnSetDepositSetOffGridFooter(GridDepositSetOffID);
}

//기본 레이아웃 세팅
function fnCreateDepositSetOffGridLayout(strGID, strRowIdField) {

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
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    objGridProps.applyRestPercentWidth = true; //칼럼 레이아웃 작성 시 칼럼의 width 를 퍼센티지(%) 로 설정
    objGridProps.fillColumnSizeMode = false;

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDepositSetOffDefaultColumnLayout()");
    var objOriLayout = fnGetDepositSetOffDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDepositSetOffDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "DepositTypeM",
            headerText: "구분",
            editable: false,
            width: "7.5%",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "InputYM",
            headerText: "작성월",
            editable: false,
            width: "7.5%",
            dataType: "date",
            formatString: "yyyy-mm",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "InputYMD",
            headerText: "입금일",
            editable: false,
            width: "10%",
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClientName",
            headerText: "거래처명",
            editable: false,
            width: "15%",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DepositClosingSeqNo",
            headerText: "전표번호",
            editable: false,
            width: "15%",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Amt",
            headerText: "금액",
            editable: false,
            width: "10%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "Note",
            headerText: "적요",
            editable: false,
            width: "15%",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "RegDate",
            headerText: "등록일",
            editable: false,
            width: "10%",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "RegAdminName",
            headerText: "등록자",
            editable: false,
            width: "10%",
            filter: { showIcon: true },
            viewstatus: false
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
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DepositType",
            headerText: "DepositType",
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
function fnGridDepositSetOffCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    fnSetSetOff(objItem);
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDepositSetOffGridData(strGID) {
    AUIGrid.setGridData(strGID, []);

    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnDepositSetOffGridSuccResult";

    var objParam = {
        CallType: "DepositDetailList",
        DepositTypes:"3,4",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        DateFrom: $("#DateFrom2").val(),
        DateTo: $("#DateTo2").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDepositSetOffGridSuccResult(objRes) {

    if (objRes) {
        AUIGrid.removeAjaxLoader(GridDepositSetOffID);

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }
        
        AUIGrid.setGridData(GridDepositSetOffID, objRes[0].data.list);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDepositSetOffGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "InputYM",
            dataField: "InputYM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Amt",
            dataField: "Amt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}
/**********************************************************/

/**********************************************************/
//입금등록
/**********************************************************/
//입금 작성월 변경
function fnUpdMonthDeposit() {
    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val() || !$("#HidClientName").val()) {
        fnDefaultAlert("업체 선택 후 입력하실 수 있습니다.", "warning");
        return false;
    }

    if (!$("#DepositClosingSeqNo").val()) {
        fnDefaultAlert("선택된 입금 정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#InputYM").val()) {
        fnDefaultAlertFocus("작성월을 선택하세요.", "InputYM", "warning");
        return false;
    }

    fnDefaultConfirm("입금의 작성월을 수정하시겠습니까?", "fnUpdMonthDepositProc", "");
    return false;
}

function fnUpdMonthDepositProc() {
    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnUpdMonthDepositSuccResult";
    var strFailCallBackFunc = "fnUpdMonthDepositFailResult";
    var objParam = {
        CallType: "DepositMonthUpdate",
        DepositClosingSeqNo: $("#DepositClosingSeqNo").val(),
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        DepositYM: $("#InputYM").val(),
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnUpdMonthDepositSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("입금의 작성월이 수정되었습니다.", "info");
            $("#BtnListSearchDeposit").click();
            $("#BtnResetDeposit").click();
            fnCallDepositGridData(GridDepositID);
            return false;
        } else {
            fnUpdMonthDepositFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnUpdMonthDepositFailResult();
        return false;
    }
}

function fnUpdMonthDepositFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}


//입금 등록
function fnInsDeposit() {
    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val() || !$("#HidClientName").val()) {
        fnDefaultAlert("업체 선택 후 입력하실 수 있습니다.", "warning");
        return false;
    }

    if (!$("#InputYM").val()) {
        fnDefaultAlertFocus("작성월을 선택하세요.", "InputYM", "warning");
        return false;
    }

    if (!$("#InputYMD").val()) {
        fnDefaultAlertFocus("입금일을 선택하세요.", "InputYMD", "warning");
        return false;
    }

    if (!$("#Amt").val()) {
        fnDefaultAlertFocus("금액을 입력하세요.", "Amt", "warning");
        return false;
    }

    var strConfirmMsg = "입금을 등록하시겠습니까?";
    strConfirmMsg = ($("#SaleClosingSeqNos").val() != "" ? "선택한 매출전표와 매칭이 함께 진행됩니다.<br/>" : "") + strConfirmMsg;

    fnDefaultConfirm(strConfirmMsg, "fnInsDepositProc", "");
    return false;
}

function fnInsDepositProc() {
    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnInsDepositSuccResult";
    var strFailCallBackFunc = "fnInsDepositFailResult";
    var objParam = {
        CallType: "DepositInsert",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        ClientName: $("#HidClientName").val(),
        DepositType: 5,
        DepositYMD: $("#InputYMD").val(),
        DepositYM: $("#InputYM").val(),
        DepositAmt: $("#Amt").val(),
        DepositNote: $("#Note").val(),
        SaleClosingSeqNos: $("#SaleClosingSeqNos").val()
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnInsDepositSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("입금이 등록되었습니다.", "info");
            $("#BtnListSearchDeposit").click();
            $("#BtnResetDeposit").click();
            fnCallDepositGridData(GridDepositID);
            return false;
        } else {
            fnInsDepositFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnInsDepositFailResult();
        return false;
    }
}

function fnInsDepositFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//입금 수정
function fnUpdDeposit() {
    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val() || !$("#HidClientName").val()) {
        fnDefaultAlert("업체 선택 후 입력하실 수 있습니다.", "warning");
        return false;
    }

    if (!$("#DepositClosingSeqNo").val()) {
        fnDefaultAlert("선택된 입금 정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#InputYM").val()) {
        fnDefaultAlertFocus("작성월을 선택하세요.", "InputYM", "warning");
        return false;
    }

    if (!$("#Amt").val()) {
        fnDefaultAlertFocus("금액을 입력하세요.", "Amt", "warning");
        return false;
    }

    if (!$("#InputYMD").val()) {
        fnDefaultAlertFocus("입금일을 선택하세요.", "InputYMD", "warning");
        return false;
    }

    var strConfirmMsg = "입금을 수정하시겠습니까?";
    strConfirmMsg = ($("#MatchingClosingSeqNo").val() != "" ? "매칭정보가 있는 입금내역은 금액변경시 매칭이 해제됩니다.<br/>" : "") + strConfirmMsg;

    fnDefaultConfirm(strConfirmMsg, "fnUpdDepositProc", "");
    return false;
}

function fnUpdDepositProc() {
    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnUpdDepositSuccResult";
    var strFailCallBackFunc = "fnUpdDepositFailResult";
    var objParam = {
        CallType: "DepositUpdate",
        DepositClosingSeqNo: $("#DepositClosingSeqNo").val(),
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        ClientName: $("#HidClientName").val(),
        DepositType: 5,
        DepositYMD: $("#InputYMD").val(),
        DepositYM: $("#InputYM").val(),
        DepositAmt: $("#Amt").val(),
        DepositNote: $("#Note").val()
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnUpdDepositSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("입금이 수정되었습니다.", "info");
            $("#BtnListSearchDeposit").click();
            $("#BtnResetDeposit").click();
            fnCallDepositGridData(GridDepositID);
            return false;
        } else {
            fnUpdDepositFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnUpdDepositFailResult();
        return false;
    }
}

function fnUpdDepositFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//입금 삭제
function fnDelDeposit() {
    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val() || !$("#HidClientName").val()) {
        fnDefaultAlert("업체 선택 후 입력하실 수 있습니다.", "warning");
        return false;
    }

    if (!$("#DepositClosingSeqNo").val()) {
        fnDefaultAlert("선택된 입금 정보가 없습니다.", "warning");
        return false;
    }

    var strConfirmMsg = "입금을 삭제하시겠습니까?";
    strConfirmMsg = ($("#MatchingClosingSeqNo").val() != "" ? "매칭정보가 있는 입금내역은 매칭이 해제됩니다.<br/>" : "") + strConfirmMsg;

    fnDefaultConfirm(strConfirmMsg, "fnDelDepositProc", "");
    return false;
}

function fnDelDepositProc() {
    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnDelDepositSuccResult";
    var strFailCallBackFunc = "fnDelDepositFailResult";
    var objParam = {
        CallType: "DepositDelete",
        DepositClosingSeqNos: $("#DepositClosingSeqNo").val(),
        CenterCode: $("#HidCenterCode").val()
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnDelDepositSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("입금이 삭제되었습니다.", "info");
            $("#BtnListSearchDeposit").click();
            $("#BtnResetDeposit").click();
            fnCallDepositGridData(GridDepositID);
            return false;
        } else {
            fnDelDepositFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnDelDepositFailResult();
        return false;
    }
}

function fnDelDepositFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//입금 다시 입력
function fnResetDeposit() {
    $("#SaleClosingSeqNos").val("");
    $("#MatchingClosingSeqNo").val("");
    $("#DepositClosingSeqNo").val("");
    $("#InputYM").datepicker("setDate", new Date());
    $("#Amt").val("");
    $("#InputYMD").val("");
    $("#Note").val("");
    $("#BtnInsDeposit").show();
    $("#BtnUpdMonthDeposit").hide();
    $("#BtnUpdDeposit").hide();
    $("#BtnDelDeposit").hide();
}

//입금 데이터 세팅
function fnSetDeposit(objItem) {
    $("#MatchingClosingSeqNo").val(objItem.MatchingClosingSeqNo);
    $("#DepositClosingSeqNo").val(objItem.DepositClosingSeqNo);
    $("#InputYM").datepicker("setDate", new Date(objItem.InputYM.substr(0, 4), parseInt(objItem.InputYM.substr(4, 2) - 1), 1));
    $("#Amt").val(fnMoneyComma(objItem.Amt));
    $("#InputYMD").val(fnGetStrDateFormat(objItem.InputYMD, "-"));
    $("#Note").val(objItem.Note);
    $("#BtnInsDeposit").hide();
    $("#BtnUpdMonthDeposit").show();
    $("#BtnUpdDeposit").show();
    $("#BtnDelDeposit").show();
}

//매칭
function fnInsMatching() {
    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val()) {
        return false;
    }

    var intMatchingCnt = 0;
    var intOrgAmt = 0;
    var objCheckedSaleItems = AUIGrid.getCheckedRowItems(GridDepositSaleID);
    if (objCheckedSaleItems.length === 0) {
        fnDefaultAlert("선택된 매출마감내역이 없습니다.", "warning");
        return false;
    }

    if (objCheckedSaleItems.length > 0) {
        $.each(objCheckedSaleItems, function (intIndex, objItem) {
            if (objItem.item.MatchingClosingSeqNo > 0) {
                intMatchingCnt++;
            }

            intOrgAmt += objItem.item.OrgAmt;
        });
    }

    if (intMatchingCnt > 0) {
        fnDefaultAlert("이미 매칭된 매출마감내역이 포함되어 있습니다.", "warning");
        return false;
    }

    intMatchingCnt = 0;
    var intAmt = 0;
    var objCheckedDepositItems = AUIGrid.getCheckedRowItems(GridDepositDetailID);
    if (objCheckedDepositItems.length === 0) {
        fnDefaultAlert("선택된 입금내역이 없습니다.", "warning");
        return false;
    }

    if (objCheckedDepositItems.length > 0) {
        $.each(objCheckedDepositItems, function (intIndex, objItem) {
            if (objItem.item.MatchingClosingSeqNo > 0) {
                intMatchingCnt++;
            }

            intAmt += objItem.item.Amt;
        });
    }

    if (intMatchingCnt > 0) {
        fnDefaultAlert("이미 매칭된 입금내역이 포함되어 있습니다.", "warning");
        return false;
    }

    if (intOrgAmt != intAmt) {
        fnDefaultAlert("선택된 매출과 입금내역의 총금액이 다릅니다.", "warning");
        return false;
    }

    fnDefaultConfirm("선택한 매출과 입금내역을 매칭하시겠습니까?", "fnInsMatchingProc", "");
    return false;
}

function fnInsMatchingProc() {
    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val()) {
        return false;
    }

    var objCheckedSaleItems = AUIGrid.getCheckedRowItems(GridDepositSaleID);
    if (objCheckedSaleItems.length === 0) {
        return false;
    }

    var objCheckedDepositItems = AUIGrid.getCheckedRowItems(GridDepositDetailID);
    if (objCheckedDepositItems.length === 0) {
        return false;
    }

    var arrSaleClosingSeqNo = [];
    var arrDepositClosingSeqNo = [];

    $.each(objCheckedSaleItems, function (intIndex, objItem) {
        arrSaleClosingSeqNo.push(objItem.item.SaleClosingSeqNo);
    });
    $.each(objCheckedDepositItems, function (intIndex, objItem) {
        arrDepositClosingSeqNo.push(objItem.item.DepositClosingSeqNo);
    });

    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnInsMatchingProcSuccResult";
    var strFailCallBackFunc = "fnInsMatchingProcFailResult";
    var objParam = {
        CallType: "MatchingInsert",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        SaleClosingSeqNos: arrSaleClosingSeqNo.join(","),
        DepositClosingSeqNos: arrDepositClosingSeqNo.join(",")
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    return false;
}

function fnInsMatchingProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("매칭이 등록되었습니다.", "info");
            $("#BtnListSearchDeposit").click();
            $("#BtnResetDeposit").click();
            fnCallDepositGridData(GridDepositID);
            return false;
        } else {
            fnInsMatchingProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnInsMatchingProcFailResult();
        return false;
    }
}

function fnInsMatchingProcFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

var arrDelMatchingList = null;
var intDelMatchingCnt = 0;
var intDelMatchingProcCnt = 0;
var intDelMatchingSuccessCnt = 0;
var intDelMatchingFailCnt = 0;
var strDelMatchingFailMsg = "";
var strDelMatchingDepositFlag = "N";
function fnDelMatching() {
    if (!$("#HidCenterCode").val() || !$("#HidClientCode").val()) {
        return false;
    }

    arrDelMatchingList = [];
    intDelMatchingCnt = 0;
    intDelMatchingProcCnt = 0;
    intDelMatchingSuccessCnt = 0;
    intDelMatchingFailCnt = 0;
    strDelMatchingDepositFlag = "N";

    var objCheckedSaleItems = AUIGrid.getCheckedRowItems(GridDepositSaleID);
    if (objCheckedSaleItems.length === 0) {
        fnDefaultAlert("선택된 매출마감내역이 없습니다.", "warning");
        return false;
    }

    $.each(objCheckedSaleItems, function (intIndex, objItem) {
        if (objItem.item.MatchingClosingSeqNo != "") {
            if (arrDelMatchingList.findIndex((e) => e === objItem.item.MatchingClosingSeqNo) === -1) {
                arrDelMatchingList.push(objItem.item.MatchingClosingSeqNo);
            }
        }
    });

    intDelMatchingCnt = arrDelMatchingList.length;

    if (arrDelMatchingList.length === 0) {
        fnDefaultAlert("매칭된 매출마감내역이 없습니다.", "warning");
        return false;
    }

    fnDefaultConfirmWithCheckbox("매칭을 해제하시겠습니까?", "입금내역삭제", "fnDelMatchingProc");
    return false;
}

function fnDelMatchingProc(objTrueParam) {
    AUIGrid.showAjaxLoader(GridDepositSaleID);
    AUIGrid.showAjaxLoader(GridDepositDetailID);

    if (intDelMatchingProcCnt >= intDelMatchingCnt) {
        AUIGrid.removeAjaxLoader(GridDepositSaleID);
        AUIGrid.removeAjaxLoader(GridDepositDetailID);
        fnDelMatchingEnd();
        return false;
    }

    if (typeof objTrueParam !== "undefined") {
        strDelMatchingDepositFlag = objTrueParam.isConfirmChecked ? "Y" : "N";
    }

    var objParam = {
        CallType: "MatchingDelete",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#HidClientCode").val(),
        MatchingClosingSeqNo: arrDelMatchingList[intDelMatchingProcCnt],
        DepositFlag: strDelMatchingDepositFlag
    }

    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnDelMatchingProcSuccResult";
    var strFailCallBackFunc = "fnDelMatchingProcFailResult";
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnDelMatchingProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            intDelMatchingSuccessCnt++;
        } else {
            intDelMatchingFailCnt++;
            strDelMatchingFailMsg += "<br><b>" + arrDelMatchingList[intDelMatchingProcCnt] + " : " + objRes[0].ErrMsg + "</b>";
        }
    } else {
        intDelMatchingFailCnt++;
    }
    intDelMatchingProcCnt++;
    setTimeout(fnDelMatchingProc(), 200);
    return false;
}

function fnGridPayInsFailResult() {
    intDelMatchingFailCnt++;
    intDelMatchingProcCnt++;
    setTimeout(fnDelMatchingProc(), 200);
    return false;
}

function fnDelMatchingEnd() {
    var msg = "총 " + intDelMatchingCnt + "건의 매칭정보 중 " + intDelMatchingSuccessCnt + "건이 해제되었습니다.";
    if (strDelMatchingFailMsg != "") {
        msg += strDelMatchingFailMsg;
    }
    fnDefaultAlert(msg, "info");
    $("#BtnListSearchDeposit").click();
    $("#BtnResetDeposit").click();
    fnCallDepositGridData(GridDepositID);
    return false;
}
/**********************************************************/


/**********************************************************/
//상계등록
/**********************************************************/
//상계 등록
function fnInsSetOff() {
    if (!$("#HidCenterCode").val()) {
        fnDefaultAlert("업체 선택 후 입력하실 수 있습니다.", "warning");
        return false;
    }

    if (!$("#SetOffType").val()) {
        fnDefaultAlertFocus("상계 구분을 선택하세요.", "SetOffType", "warning");
        return false;
    }

    if (!$("#SetOffInputYM").val()) {
        fnDefaultAlertFocus("작성월을 선택하세요.", "SetOffInputYM", "warning");
        return false;
    }

    if (!$("#SetOffAmt").val()) {
        fnDefaultAlertFocus("금액을 입력하세요.", "SetOffAmt", "warning");
        return false;
    }

    if (!$("#SetOffClientCode").val() || $("#SetOffClientCode").val() === "0") {
        fnDefaultAlertFocus("업체명을 검색하세요.", "SetOffClientName", "warning");
        return false;
    }

    fnDefaultConfirm("상계을 등록하시겠습니까?", "fnInsSetOffProc", "");
    return false;
}

function fnInsSetOffProc() {
    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnInsSetOffSuccResult";
    var strFailCallBackFunc = "fnInsSetOffFailResult";
    var objParam = {
        CallType: "DepositInsert",
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#SetOffClientCode").val(),
        ClientName: $("#SetOffClientName").val(),
        DepositType: $("#SetOffType").val(),
        DepositYM: $("#SetOffInputYM").val(),
        DepositYMD: $("#SetOffInputYM").val() + "01",
        DepositAmt: $("#SetOffAmt").val(),
        DepositNote: $("#SetOffNote").val()
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnInsSetOffSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("상계가 등록되었습니다.", "info");
            $("#BtnListSearchSetOff").click();
            $("#BtnResetSetOff").click();
            return false;
        } else {
            fnInsSetOffFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnInsSetOffFailResult();
        return false;
    }
}

function fnInsSetOffFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//상계 수정
function fnUpdSetOff() {
    if (!$("#HidCenterCode").val()) {
        fnDefaultAlert("업체 선택 후 입력하실 수 있습니다.", "warning");
        return false;
    }

    if (!$("#SetOffClosingSeqNo").val()) {
        fnDefaultAlert("선택된 상계 정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#SetOffType").val()) {
        fnDefaultAlertFocus("상계 구분을 선택하세요.", "SetOffType", "warning");
        return false;
    }

    if (!$("#SetOffInputYM").val()) {
        fnDefaultAlertFocus("작성월을 선택하세요.", "SetOffInputYM", "warning");
        return false;
    }

    if (!$("#SetOffAmt").val()) {
        fnDefaultAlertFocus("금액을 입력하세요.", "SetOffAmt", "warning");
        return false;
    }

    if (!$("#SetOffClientCode").val() || $("#SetOffClientCode").val() === "0") {
        fnDefaultAlertFocus("업체명을 검색하세요.", "SetOffClientName", "warning");
        return false;
    }

    fnDefaultConfirm("상계을 수정하시겠습니까?", "fnUpdSetOffProc", "");
    return false;
}

function fnUpdSetOffProc() {
    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnUpdSetOffSuccResult";
    var strFailCallBackFunc = "fnUpdSetOffFailResult";
    var objParam = {
        CallType: "DepositUpdate",
        DepositClosingSeqNo: $("#SetOffClosingSeqNo").val(),
        CenterCode: $("#HidCenterCode").val(),
        ClientCode: $("#SetOffClientCode").val(),
        ClientName: $("#SetOffClientName").val(),
        DepositType: $("#SetOffType").val(),
        DepositYM: $("#SetOffInputYM").val(),
        DepositYMD: $("#SetOffInputYM").val() + "01",
        DepositAmt: $("#SetOffAmt").val(),
        DepositNote: $("#SetOffNote").val()
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnUpdSetOffSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("상계가 수정되었습니다.", "info");
            $("#BtnListSearchSetOff").click();
            $("#BtnResetSetOff").click();
            return false;
        } else {
            fnUpdSetOffFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnUpdSetOffFailResult();
        return false;
    }
}

function fnUpdSetOffFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//상계 삭제
function fnDelSetOff() {
    if (!$("#HidCenterCode").val()) {
        fnDefaultAlert("업체 선택 후 입력하실 수 있습니다.", "warning");
        return false;
    }

    if (!$("#SetOffClosingSeqNo").val()) {
        fnDefaultAlert("선택된 상계 정보가 없습니다.", "warning");
        return false;
    }

    fnDefaultConfirm("상계을 삭제하시겠습니까?", "fnDelSetOffProc", "");
    return false;
}

function fnDelSetOffProc() {
    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnDelSetOffSuccResult";
    var strFailCallBackFunc = "fnDelSetOffFailResult";
    var objParam = {
        CallType: "DepositDelete",
        DepositClosingSeqNos: $("#SetOffClosingSeqNo").val(),
        CenterCode: $("#HidCenterCode").val()
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnDelSetOffSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("상계가 삭제되었습니다.", "info");
            $("#BtnListSearchSetOff").click();
            $("#BtnResetSetOff").click();
            return false;
        } else {
            fnDelSetOffFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnDelSetOffFailResult();
        return false;
    }
}

function fnDelSetOffFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//상계 다시 입력
function fnResetSetOff() {
    $("#SetOffClosingSeqNo").val("");
    $("#SetOffClientCode").val("");
    $("#SetOffType option").attr("disabled", false);
    $("#SetOffType").val("3");
    $("#SetOffInputYM").datepicker("setDate", new Date());
    $("#SetOffAmt").val("");
    $("#SetOffClientName").val("");
    $("#SetOffClientName").prop("readonly", false);
    $("#SetOffNote").val("");
    $("#BtnInsSetOff").show();
    $("#BtnUpdSetOff").hide();
    $("#BtnDelSetOff").hide();
}

//상계 데이터 세팅
function fnSetSetOff(objItem) {
    $("#SetOffClosingSeqNo").val(objItem.DepositClosingSeqNo);
    $("#SetOffClientCode").val(objItem.ClientCode);
    $("#SetOffType").val(objItem.DepositType);
    $("#SetOffType option:not(:selected)").attr("disabled", true);
    $("#SetOffInputYM").datepicker("setDate", new Date(objItem.InputYM.substr(0, 4), parseInt(objItem.InputYM.substr(4, 2) - 1), 1));
    $("#SetOffAmt").val(fnMoneyComma(objItem.Amt));
    $("#SetOffClientName").val(objItem.ClientName);
    $("#SetOffClientName").prop("readonly", true);
    $("#SetOffNote").val(objItem.Note);
    $("#BtnInsSetOff").hide();
    $("#BtnUpdSetOff").show();
    $("#BtnDelSetOff").show();
}

//상계 열기+닫기
function fnSetOffToggle(objTitle) {
    if ($("#DivSetOffWrap").css("display") === "none") { //닫혀있을때
        $("#DivSetOffWrap").show();
        $(objTitle).addClass("on");
        $("#DepositSaleListGrid").css("height", "173px");
        $("#DepositDetailListGrid").css("height", "173px");
        AUIGrid.resize(GridDepositSaleID, $(".grid_type_03 > div.right").width() / 2 - 5, 173);
        AUIGrid.resize(GridDepositDetailID, $(".grid_type_03 > div.right").width() / 2, 173);
        AUIGrid.resize(GridDepositSetOffID, $(".grid_type_03 > div.right").width(), 145);
    } else { //열려있을때
        $("#DivSetOffWrap").hide();
        $(objTitle).removeClass("on");
        $("#DepositSaleListGrid").css("height", "365px");
        $("#DepositDetailListGrid").css("height", "365px");
        AUIGrid.resize(GridDepositSaleID, $(".grid_type_03 > div.right").width() / 2 - 5, 365);
        AUIGrid.resize(GridDepositDetailID, $(".grid_type_03 > div.right").width() / 2, 365);
    }
}
/**********************************************************/

//거래처 미수 업데이트
function fnSetMisuUpd(objItem) {
    fnDefaultConfirm(objItem.ClientNameSimple + "의 미수금 정보를 업데이트 하시겠습니까?", "fnSetMisuUpdProc", objItem);
    return false;
}

function fnSetMisuUpdProc(objParam) {
    var strHandlerURL = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
    var strCallBackFunc = "fnSetMisuUpdSuccResult";
    var strFailCallBackFunc = "fnSetMisuUpdFailResult";

    var objParam = {
        CallType: "ClientMisuUpdate",
        CenterCode: objParam.CenterCode,
        ClientCode: objParam.ClientCode
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetMisuUpdSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            var objItem = {
                TotalMisuAmt: objRes[0].TotalMisuAmt,
                MisuAmt: objRes[0].MisuAmt,
                NoMatchingCnt: objRes[0].NoMatchingCnt,
                ClientCode: objRes[0].ClientCode
            };

            AUIGrid.updateRowsById(GridID, objItem);
            fnDefaultAlert("미수금정보가 업데이트되었습니다.", "info");
            return false;
        } else {
            fnSetMisuUpdFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetMisuUpdFailResult();
        return false;
    }
}

function fnSetMisuUpdFailResult(strMsg) {
    strMsg = typeof strMsg != "string" ? "" : strMsg;
    fnDefaultAlert("거래처의 미수금정보 업데이트에 실패했습니다." + strMsg == "" ? "" : ("<br>(" + strMsg  + ")"), "error");
    return false;
}

/**********************************************************/
//입금엑셀등록
/**********************************************************/
var GridDepositExcelID = "#DepositExcelListGrid";
var arrStyleMap = [];

$(document).ready(function () {
    if ($(GridDepositExcelID).length > 0) {
        // 그리드 초기화
        fnDepositExcelGridInit();
    }
});

function fnDepositExcelGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDepositExcelGridLayout(GridDepositExcelID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDepositExcelID, "", "", "", "", "", "", "", "");

    AUIGrid.resize(GridDepositExcelID, $("#DivDepositExcel div.gridWrap").width(), $("#DivDepositExcel div.gridWrap").height());

    // 푸터
    //fnSetDepositExcelGridFooter(GridDepositExcelID);
    AUIGrid.setGridData(GridDepositExcelID, []);
}

//기본 레이아웃 세팅
function fnCreateDepositExcelGridLayout(strGID, strRowIdField) {

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
    objGridProps.fixedColumnCount = 5; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = true; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = true; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    objGridProps.applyRestPercentWidth = false; //칼럼 레이아웃 작성 시 칼럼의 width 를 퍼센티지(%) 로 설정
    objGridProps.fillColumnSizeMode = false;
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDepositExcelDefaultColumnLayout()");
    var objOriLayout = fnGetDepositExcelDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    AUIGrid.bind(strGID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "addRow", "addRowFinish", "pasteBegin", "pasteEnd"], fnGetDepositExcelEditingHandler);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDepositExcelDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "ValidationCheck",
            headerText: "상태",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DepositFlag",
            headerText: "등록",
            editable: false,
            width: 60,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "MatchingFlag",
            headerText: "매칭",
            editable: false,
            width: 60,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClientNameSimple",
            headerText: "업체명",
            editable: false,
            width: 150,
            visible: true,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "ClientPayDayM",
            headerText: "여신일",
            editable: false,
            width: 60,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClientCorpNo",
            headerText: "사업자번호",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "InputYM",
            headerText: "작성월",
            editable: true,
            width: 60,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            headerTooltip: {
                show: true,
                tooltipHtml: "미입력시 거래처 여신일에 따라 자동계산(YYYYMM)"
            }
        },
        {
            dataField: "InputYMD",
            headerText: "입금일",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "Amt",
            headerText: "금액",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "Note",
            headerText: "적요",
            editable: true,
            width: 130,
            visible: true,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "SaleClosingSeqNos",
            headerText: "매출전표번호",
            editable: true,
            width: 130,
            visible: true,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false,
            headerTooltip: {
                show: true,
                tooltipHtml: "매출전표번호를 콤마(,)로 구분하여 입력"
            }
        },
        {
            dataField: "DepositClosingSeqNos",
            headerText: "입금전표번호",
            editable: true,
            width: 130,
            visible: true,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false,
            headerTooltip: {
                show: true,
                tooltipHtml: "등록되어있는 입금전표번호를 콤마(,)로 구분하여 입력"
            }
        },
        /*숨김필드*/
        {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
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
            dataField: "DepositClosingSeqNo",
            headerText: "DepositClosingSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "MatchingClosingSeqNo",
            headerText: "MatchingClosingSeqNo",
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
function fnGetDepositExcelEditingHandler(event) {
    if (event.type === "cellEditBegin") {
        //if (event.isClipboard && (event.columnIndex === 0))
        //    return false;

    } else if (event.type == "cellEditEnd") {
        var item = event.item;

        //if (event.oldValue != event.value) {
        //    if (event.dataField === "ConsignorName" && event.oldValue != event.value) {
        //        item.ConsignorCode = 0;
        //    }
        //}

        item.ValidationCheck = "미검증";
        item.DepositFlag = "N";
        item.MatchingFlag = "N";
        item.ClientNameSimple = "";
        item.ClientPayDayM = "";
        item.CenterCode = 0;
        item.ClientCode = 0;
        item.DepositClosingSeqNo = 0;
        item.MatchingClosingSeqNo = 0;
        AUIGrid.updateRowsById(event.pid, item);

    } else if (event.type === "cellEditEndBefore") {
        var retStr = event.value;
        retStr = retStr.toString().replace(/\t/gi, "");
        retStr = retStr.toString().replace(/\n/gi, "");

        if (event.dataField === "InputYM" || event.dataField === "InputYMD") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9\-]/gi, "");
        }

        if (event.dataField === "ClientCorpNo") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9]/gi, "");
        }

        if (event.dataField === "Amt") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9]/gi, "");
            if (retStr === "") {
                retStr = "0";
            }
        }

        if (event.dataField === "SaleClosingSeqNos" || event.dataField === "DepositClosingSeqNos") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9\,]/gi, "");
        }

        retStr = retStr.replace(/\t/gi, "");
        retStr = retStr.replace(/\"/gi, "");
        retStr = retStr.replace(/\\/gi, "");
        retStr = retStr.replace(/\xA0/gi, "");

        return retStr;

    } else if (event.type === "addRow") {

        for (i = 0; i < event.items.length; i++) {
            event.items[i].ValidationCheck = "미검증";
            event.items[i].DepositFlag = "N";
            event.items[i].MatchingFlag = "N";
            event.items[i].ClientNameSimple = "";
            event.items[i].ClientPayDayM = "";
            event.items[i].CenterCode = 0;
            event.items[i].ClientCode = 0;
            event.items[i].DepositClosingSeqNo = 0;
            event.items[i].MatchingClosingSeqNo = 0;
            AUIGrid.updateRowsById(event.pid, event.items[i]);
        }

        AUIGrid.update(event.pid);

    } else if (event.type === "addRowFinish") {

        var arrGridRows = AUIGrid.getGridData(event.pid);
        if (arrGridRows.length > 0) {
            AUIGrid.setSelectionByIndex(event.pid, AUIGrid.getGridData(event.pid).length - 1, 5);
        }

    } else if (event.type === "pasteBegin") {

        var arrData = event.clipboardData.split("\r\n");
        var arrResult = [];
        var arrGridRows = AUIGrid.getGridData(event.pid);
        var arrSelectedItems = AUIGrid.getSelectedItems(event.pid);
        var intSelectedColIndex = arrSelectedItems.length > 0 ? arrSelectedItems[0].columnIndex : -1;

        for (var i = 0; i < arrData.length; i++) {
            if (arrData[i] !== "") {
                arrResult[i] = arrData[i].split("\t");
            }
        }

        if (arrResult.length > 0) {
            if (arrResult[0].length === 35) {
                if (intSelectedColIndex === -1) { //그리드 미선택
                    for (var i = 0; i < arrResult.length; i++) {
                        arrResult[i].unshift("미검증");
                    }
                }
            }
        }

        return arrResult; // 반환되는 값을 붙여넣기 적용함.
    }
};
//---------------------------------------------------------------------------------

// 셀 스타일 함수
function fnCellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField) {
    var key = rowIndex + "-" + dataField;
    if (typeof arrStyleMap[key] != "undefined") {
        return arrStyleMap[key];
    }
    return null;
};

function fnChangeStyleFunction(rowIndex, datafield) {
    var key = rowIndex + "-" + datafield;
    arrStyleMap[key] = "error-column-style";
};

function fnCloseDepositExcel() {
    $("#DepositExcelCenterCode").val("");
    AUIGrid.setGridData(GridDepositExcelID, []);
    $("#DivDepositExcel").hide();
    return false;
}

function fnOpenDepositExcel() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    $("#DepositExcelCenterCode").val($("#CenterCode").val());

    $("#DivDepositExcel").show();
    AUIGrid.setGridData(GridDepositExcelID, []);
    AUIGrid.resize(GridDepositExcelID, $("#DivDepositExcel div.gridWrap").width(), $("#DivDepositExcel div.gridWrap").height());
    return false;
}

// 행 추가
function fnAddRow() {
    var objItem = new Object();
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    objItem.ValidationCheck = "미검증";
    objItem.DepositFlag = "N";
    objItem.MatchingFlag = "N";
    objItem.ClientNameSimple = "";
    objItem.ClientPayDayM = "";
    objItem.ClientCorpNo = "";
    objItem.InputYM = "";
    objItem.InputYMD = "";
    objItem.Amt = 0;
    objItem.Note = "";
    objItem.SaleClosingSeqNos = "";
    objItem.DepositClosingSeqNos = "";
    objItem.CenterCode = 0;
    objItem.ClientCode = 0;
    objItem.DepositClosingSeqNo = 0;
    objItem.MatchingClosingSeqNo = 0;
    AUIGrid.addRow(GridDepositExcelID, objItem, "last");
}

// 행 삭제
function fnRemoveRow() {
    var objSelectedItems = AUIGrid.getSelectedItems(GridDepositExcelID);
    if (objSelectedItems.length <= 0) return false;
    $.each(objSelectedItems, function (index, item) {
        AUIGrid.removeRowByRowId(GridDepositExcelID, item.item.SeqNo);
    });
}

// 미검증 행 삭제
function fnDelNoValidationRow() {
    var objGridData = AUIGrid.getGridData(GridDepositExcelID);
    var objSelectedItems = objGridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("미검증") !== -1) return true;
        return false;
    });
    if (objSelectedItems.length <= 0) return false;
    $.each(objSelectedItems, function (index, item) {
        AUIGrid.removeRowByRowId(GridDepositExcelID, item.SeqNo);
    });
}

// 등록 행 삭제
function fnDelSuccRow() {
    var objSelectedItems = AUIGrid.getItemsByValue(GridDepositExcelID, "ValidationCheck", "등록");
    if (objSelectedItems.length <= 0) return false;

    $.each(objSelectedItems, function (index, item) {
        AUIGrid.removeRowByRowId(GridDepositExcelID, item.SeqNo);
    });
}

// 실패 행 삭제
function fnDelFailRow() {
    var objGridData = AUIGrid.getGridData(GridDepositExcelID);
    var objSelectedItems = objGridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("실패") !== -1) return true;
        return false;
    });
    if (objSelectedItems.length <= 0) return false;
    $.each(objSelectedItems, function (index, item) {
        AUIGrid.removeRowByRowId(GridDepositExcelID, item.SeqNo);
    });
}

//화면 초기화
function fnResetAll() {
    AUIGrid.setGridData(GridDepositExcelID, []);
}

//필수값 확인
function fnValidationData() {
    var intChkCnt = 0;
    var intRowIndex = 0;

    var objGridData = AUIGrid.getGridData(GridDepositExcelID);
    var objItems = objGridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("미검증") !== -1 || String(v.ValidationCheck).indexOf("실패") !== -1) return true;
        return false;
    });

    var strMsg = "";
    arrStyleMap = [];

    for (i = 0; i < objItems.length; i++) {
        intChkCnt = 0;
        strMsg = "";
        intRowIndex = AUIGrid.rowIdToIndex(GridDepositExcelID, objItems[i].SeqNo);

        var strClientCorpNo = typeof objItems[i].ClientCorpNo === "undefined" || objItems[i].ClientCorpNo == null ? "" : objItems[i].ClientCorpNo;
        strClientCorpNo = strClientCorpNo.toString().replace(/[^0-9]/gi, "");
        if (strClientCorpNo == "" || strClientCorpNo.length != 10) {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "ClientCorpNo");
            strMsg += strMsg === "" ? "거래처 사업자번호 정보가 없습니다." : " / " + "거래처 사업자번호 정보가 없습니다.";
        }

        //var strInputYM = typeof objItems[i].InputYM === "undefined" || objItems[i].InputYM == null ? "" : objItems[i].InputYM;
        //strInputYM = strInputYM.toString().replace(/[^0-9]/gi, "");
        //if (strInputYM == "" || strInputYM.length != 6) {
        //    intChkCnt++;
        //    fnChangeStyleFunction(intRowIndex, "InputYM");
        //    strMsg += strMsg === "" ? "작성월 정보가 없습니다." : " / " + "작성월 정보가 없습니다.";
        //}

        var strInputYMD = typeof objItems[i].InputYMD === "undefined" || objItems[i].InputYMD == null ? "" : objItems[i].InputYMD;
        strInputYMD = strInputYMD.toString().replace(/[^0-9]/gi, "");
        if (strInputYMD == "" || strInputYMD.length != 8) {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "InputYMD");
            strMsg += strMsg === "" ? "입금일 정보가 없습니다." : " / " + "입금일 정보가 없습니다.";
        }

        var strAmt = typeof objItems[i].Amt === "undefined" || objItems[i].Amt == null ? "0" : objItems[i].Amt;
        strAmt = strAmt.toString().replace(/[^0-9]/gi, "");
        if (!$.isNumeric(strAmt)) {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "Amt");
            strMsg += strMsg === "" ? "금액 정보가 올바르지 않습니다." : " / " + "금액 정보가 올바르지 않습니다.";
        }

        if (strAmt === "" || parseInt(strAmt) <= 0) {
            intChkCnt++;
            fnChangeStyleFunction(intRowIndex, "Amt");
            strMsg += strMsg === "" ? "금액 정보가 없습니다." : " / " + "금액 정보가 없습니다.";
        }

        if (intChkCnt === 0) {
            strMsg = "미검증";
        } else {
            strMsg = "미검증 [" + strMsg + "]";
        }
        objItems[i].ValidationCheck = strMsg;
        AUIGrid.updateRowsById(GridDepositExcelID, objItems[i]);
    }

    AUIGrid.update(GridDepositExcelID);
    AUIGrid.removeAjaxLoader(GridDepositExcelID);

    var objItems = objGridData.filter(function (v) {
        if (String(v.ValidationCheck) !== "미검증") return true;
        return false;
    });

    return objItems.length == 0;
}

//검증
var ValidationList = null;
var ValidationCnt = 0;
var ValidationProcCnt = 0;
var ValidationSuccCnt = 0;
var ValidationFailCnt = 0;
function fnValidationRow() {
    if (!$("#DepositExcelCenterCode").val()) {
        return false;
    }

    var objGridData = AUIGrid.getGridData(GridDepositExcelID);
    if (objGridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("미검증") !== -1) return true;
        return false;
    }).length === 0) {
        fnDefaultAlert("검증할 내역이 없습니다.", "warning");
        return false;
    }

    if (!fnValidationData()) {
        fnDefaultAlert("올바르지 않은 내역이 있습니다.", "warning");
        return false;
    }

    ValidationList = [];
    // 원하는 결과로 필터링
    ValidationList = objGridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("미검증") !== -1) return true;
        return false;
    });

    ValidationCnt = ValidationList.length;
    ValidationProcCnt = 0;
    ValidationSuccCnt = 0;
    ValidationFailCnt = 0;

    fnValidationRowProc();
}

function fnValidationRowProc() {
    AUIGrid.showAjaxLoader(GridDepositExcelID);

    if (ValidationProcCnt >= ValidationCnt) {
        AUIGrid.removeAjaxLoader(GridDepositExcelID);
        fnDefaultAlert("검증이 완료되었습니다.<br/>작성월을 확인해 주세요.", "info");
        return false;
    }

    var objRowItem = ValidationList[ValidationProcCnt];
    if (objRowItem) {

        var strHandlerUrl = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
        var strCallBackFunc = "fnValidationRowSuccResult";
        var strFailCallBackFunc = "fnValidationRowFailResult";
        var objParam = {
            CallType: "DepositExcelChk",
            CenterCode: $("#DepositExcelCenterCode").val(),
            ClientCorpNo: objRowItem.ClientCorpNo,
            InputYMD: objRowItem.InputYMD,
            InputYM: objRowItem.InputYM
        };

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, false, strFailCallBackFunc, "", true);
        return false;

    } else {
        fnValidationRowFailResult();
        return false;
    }
}

function fnValidationRowSuccResult(objRes) {
    var objRowItem = ValidationList[ValidationProcCnt];
    var strResultMsg = "";

    if (objRes) {
        if (objRes[0].RetCode === 0) {
            ValidationProcCnt++;
            ValidationSuccCnt++;

            if (objRes[0].ClientExistsFlag !== "Y") {
                strResultMsg = "거래처 정보가 없습니다.";
            } else {
                if (objRes[0].InputYM == "") {
                    strResultMsg = "작성월 계산에 실패했습니다.";
                }
            }

            if (strResultMsg !== "") {
                objRowItem.ValidationCheck = "미검증 [" + strResultMsg + "]";
            } else {
                objRowItem.ValidationCheck = "검증";
                objRowItem.CenterCode = objRes[0].CenterCode;
                objRowItem.ClientCode = objRes[0].ClientCode;
                objRowItem.ClientNameSimple = objRes[0].ClientNameSimple;
                objRowItem.ClientPayDayM = objRes[0].ClientPayDayM;
                objRowItem.InputYM = objRes[0].InputYM;
            }
        } else {
            ValidationProcCnt++;
            ValidationFailCnt++;
            objRowItem.ValidationCheck = "미검증 [사유:" + objRes[0].ErrMsg + "]";
        }
    } else {
        ValidationProcCnt++;
        ValidationFailCnt++;
        objRowItem.ValidationCheck = "미검증";
    }

    AUIGrid.updateRowsById(GridDepositExcelID, objRowItem);
    setTimeout(fnValidationRowProc(), 200);
    return false;
}

function fnValidationRowFailResult() {
    var objRowItem = ValidationList[ValidationProcCnt];
    ValidationProcCnt++;
    ValidationFailCnt++;
    objRowItem.ValidationCheck = "미검증";
    AUIGrid.updateRowsById(GridDepositExcelID, objRowItem);
    setTimeout(fnValidationRowProc(), 200);
    return false;
}

var InsList = null;
var InsCnt = 0;
var InsProcCnt = 0;
var InsSuccCnt = 0;
var InsFailCnt = 0;
function fnInsDepositExcel() {
    if (!$("#DepositExcelCenterCode").val()) {
        return false;
    }

    InsList = [];
    var objGridData = AUIGrid.getGridData(GridDepositExcelID);
    // 원하는 결과로 필터링
    InsList = objGridData.filter(function (v) {
        if (String(v.ValidationCheck) === "검증" && $("#DepositExcelCenterCode").val() == v.CenterCode) return true;
        return false;
    });

    InsCnt = InsList.length;
    InsProcCnt = 0;
    InsSuccCnt = 0;
    InsFailCnt = 0;

    if (InsCnt === 0) {
        fnDefaultAlert("검증된 내역이 없습니다.", "warning");
        return false;
    }

    var strConfMsg = "입금내역을 등록하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnInsDepositExcelProc", "");
    return false;
}

function fnInsDepositExcelProc() {

    AUIGrid.showAjaxLoader(GridDepositExcelID);

    if (InsProcCnt >= InsCnt) {
        AUIGrid.removeAjaxLoader(GridDepositExcelID);
        fnInsMatchingExcel();
        return false;
    }

    var objRowItem = InsList[InsProcCnt];

    if (objRowItem) {
        var strHandlerUrl = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
        var strCallBackFunc = "fnInsDepositExcelSuccResult";
        var strFailCallBackFunc = "fnInsDepositExcelFailResult";
        var objParam = {
            CallType: "DepositInsert",
            CenterCode: objRowItem.CenterCode,
            ClientCode: objRowItem.ClientCode,
            ClientName: objRowItem.ClientNameSimple,
            DepositType: 5,
            DepositYMD: objRowItem.InputYMD,
            DepositYM: objRowItem.InputYM,
            DepositAmt: objRowItem.Amt,
            DepositNote: objRowItem.Note,
            SaleClosingSeqNos: ""
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, false, strFailCallBackFunc, "", true);
        return false;
    } else {
        fnInsDepositExcelFailResult();
        return false;
    }
}

function fnInsDepositExcelSuccResult(objRes) {
    var objRowItem = InsList[InsProcCnt];
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            InsSuccCnt++;
            objRowItem.ValidationCheck = "등록";
            objRowItem.DepositFlag = "Y";
            objRowItem.DepositClosingSeqNo = objRes[0].DepositClosingSeqNo;
        } else {
            InsFailCnt++;
            objRowItem.ValidationCheck = "실패 [사유:" + objRes[0].ErrMsg + "]";
        }
    } else {
        InsFailCnt++;
        objRowItem.ValidationCheck = "실패";
    }
    InsProcCnt++;
    AUIGrid.updateRowsById(GridDepositExcelID, objRowItem);
    setTimeout(fnInsDepositExcelProc(), 200);
}

function fnInsDepositExcelFailResult() {
    var objRowItem = InsList[InsProcCnt];
    InsProcCnt++;
    InsFailCnt++;
    objRowItem.ValidationCheck = "실패";
    AUIGrid.updateRowsById(GridDepositExcelID, objRowItem);
    setTimeout(fnInsDepositExcelProc(), 200);
    return false;
}

//매칭등록 
var MatchingList = null;
var MatchingCnt = 0;
var MatchingProcCnt = 0;
var MatchingSuccCnt = 0;
var MatchingFailCnt = 0;
var MatchingFailMsg = "";
function fnInsMatchingExcel() {
    if (!$("#DepositExcelCenterCode").val()) {
        return false;
    }
    
    var objGridData = AUIGrid.getGridData(GridDepositExcelID);
    if (objGridData.findIndex(e => String(e.ValidationCheck) === "등록"
        && $("#DepositExcelCenterCode").val() == e.CenterCode
        && e.SaleClosingSeqNos != "") === -1) {
        var strResultMag = InsFailCnt > 0 ? ("<br>- 입금 : 총 " + InsCnt + "건 중 " + InsSuccCnt + "건") : "<br>- 입금 : 총 " + InsSuccCnt + "건";
        fnDefaultAlert("입금내역이 등록되었습니다." + strResultMag, "success");
        return false;
    }

    var MatchingSaleList = [];
    $.each(objGridData, function (intIndex, objItem) {
        if (String(objItem.ValidationCheck) === "등록" && $("#DepositExcelCenterCode").val() == objItem.CenterCode && objItem.SaleClosingSeqNos != "") {
            if (MatchingSaleList.findIndex(e => e.SaleClosingSeqNos === objItem.SaleClosingSeqNos) === -1) {
                MatchingSaleList.push({
                    CenterCode: objItem.CenterCode,
                    ClientCode: objItem.ClientCode,
                    ClientName: objItem.ClientNameSimple,
                    SaleClosingSeqNos: objItem.SaleClosingSeqNos
                });
            }
        }
    });

    MatchingList = [];
    $.each(MatchingSaleList, function (intIndex, objItem) {
        var arrDepositList = objGridData.filter(function (v) {
            if (String(v.ValidationCheck) === "등록"
                && objItem.CenterCode == v.CenterCode
                && objItem.ClientCode == v.ClientCode
                && objItem.SaleClosingSeqNos == v.SaleClosingSeqNos) return true;
            return false;
        });

        var arrDepositClosingSeqNo = [];
        $.each(arrDepositList, function (intSubIndex, objSubItem) {

            var strDepositClosingSeqNo = typeof objSubItem.DepositClosingSeqNo == "undefined" ? "" : objSubItem.DepositClosingSeqNo;
            var strDepositClosingSeqNos = typeof objSubItem.DepositClosingSeqNos == "undefined" ? "" : objSubItem.DepositClosingSeqNos;

            if (strDepositClosingSeqNo !== "") {
                arrDepositClosingSeqNo.push(strDepositClosingSeqNo);
            }

            if (strDepositClosingSeqNos !== "") {
                arrDepositClosingSeqNo = arrDepositClosingSeqNo.concat(strDepositClosingSeqNos.split(","));
            }

            //중복값 제거
            arrDepositClosingSeqNo = Array.from(new Set(arrDepositClosingSeqNo));
        });

        if (arrDepositClosingSeqNo.length > 0) {
            MatchingList.push({
                CenterCode: objItem.CenterCode,
                ClientCode: objItem.ClientCode,
                ClientName: objItem.ClientNameSimple,
                SaleClosingSeqNos: objItem.SaleClosingSeqNos,
                DepositClosingSeqNos: arrDepositClosingSeqNo.join(",")
            });
        }
    });

    if (MatchingList.length == 0) {
        var strResultMag = InsFailCnt > 0 ? ("<br>- 입금 : 총 " + InsCnt + "건 중 " + InsSuccCnt + "건") : "<br>- 입금 : 총 " + InsSuccCnt + "건";
        fnDefaultAlert("입금내역이 등록되었습니다." + strResultMag, "success");
        return false;
    }

    MatchingCnt = MatchingList.length;
    MatchingProcCnt = 0;
    MatchingSuccCnt = 0;
    MatchingFailCnt = 0;
    fnInsMatchingExcelProc();
    return false;
}

function fnInsMatchingExcelProc() {

    AUIGrid.showAjaxLoader(GridDepositExcelID);

    if (MatchingProcCnt >= MatchingCnt) {
        AUIGrid.removeAjaxLoader(GridDepositExcelID);
        var strResultMag = InsFailCnt > 0 ? ("<br>- 입금 : 총 " + InsCnt + "건 중 " + InsSuccCnt + "건") : "<br>- 입금 : 총 " + InsSuccCnt + "건";
        strResultMag += MatchingFailCnt > 0 ? ("<br>- 매칭 : 총 " + MatchingCnt + "건 중 " + MatchingSuccCnt + "건") : "<br>- 매칭 : 총 " + MatchingSuccCnt + "건";
        strResultMag += MatchingFailMsg != "" ? MatchingFailMsg : "";
        fnDefaultAlert("입금내역이 등록되었습니다." + strResultMag, "success");
        return false;
    }
     
    var objRowItem = MatchingList[MatchingProcCnt];

    if (objRowItem) {
        var strHandlerUrl = "/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx";
        var strCallBackFunc = "fnInsMatchingExcelSuccResult";
        var strFailCallBackFunc = "fnInsMatchingExcelFailResult";
        var objParam = {
            CallType: "MatchingInsert",
            CenterCode: objRowItem.CenterCode,
            ClientCode: objRowItem.ClientCode,
            SaleClosingSeqNos: objRowItem.SaleClosingSeqNos,
            DepositClosingSeqNos: objRowItem.DepositClosingSeqNos
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, false, strFailCallBackFunc, "", true);
        return false;
    } else {
        fnInsMatchingExcelFailResult();
        return false;
    }
}

function fnInsMatchingExcelSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            MatchingSuccCnt++;

            var objGridData = AUIGrid.getGridData(GridDepositExcelID);
            $.each(objGridData, function (intIndex, objItem) {
                if (String(objItem.ValidationCheck) === "등록" && objItem.SaleClosingSeqNos == MatchingList[MatchingProcCnt].SaleClosingSeqNos) {
                    objItem.MatchingFlag = "Y";
                    objItem.MatchingClosingSeqNo = objRes[0].MatchingClosingSeqNo;
                    AUIGrid.updateRowsById(GridDepositExcelID, objItem);
                }
            });

        } else {
            MatchingFailCnt++;
            MatchingFailMsg += "<br>&nbsp;<b>" + MatchingList[MatchingProcCnt].SaleClosingSeqNos + " : " + objRes[0].ErrMsg + "</b>";
        }
    } else {
        MatchingFailCnt++;
    }
    MatchingProcCnt++;
    setTimeout(fnInsMatchingExcelProc(), 200);
}

function fnInsMatchingExcelFailResult() {
    MatchingProcCnt++;
    MatchingFailCnt++;
    setTimeout(fnInsMatchingExcelProc(), 200);
    return false;
}
/**********************************************************/