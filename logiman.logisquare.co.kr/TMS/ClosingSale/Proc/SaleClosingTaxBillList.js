window.name = "SaleClosingTaxBillListGrid";
// 그리드
var GridID = "#SaleClosingTaxBillListGrid";
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
    fnCreateGridLayout(GridID, "ISSU_SEQNO");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

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
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.rowCheckableFunction = function(rowIndex, isChecked, item) {
        if (item.ERR_CD == "000000") {
            return false;
        }
        return true;
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 푸터
    fnSetGridFooter(GridID);
    AUIGrid.setGridData(GridID, []);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "ERR_CD",
            headerText: "코드",
            editable: false,
            width: 80,
            filter: { showIcon: true }
        },
        {
            dataField: "ERR_MSG",
            headerText: "메시지",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "STAT_CODEM",
            headerText: "응답상태",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "TAX_TYPEM",
            headerText: "세금계산서종류",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "POPS_CODEM",
            headerText: "영수/청구",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "REQ_STAT_CODEM",
            headerText: "요청상태",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "ISSU_SEQNO",
            headerText: "발행전표번호",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "ISSU_ID",
            headerText: "국세청승인번호",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "SELR_CORP_NM",
            headerText: "공급자",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "SELR_CORP_NO",
            headerText: "공급자 사업자번호",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "SELR_CHRG_NM",
            headerText: "공급자 담당자",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "SELR_CHRG_EMAIL",
            headerText: "공급자 담당자 이메일",
            editable: false,
            width: 120
        },
        {
            dataField: "BUYR_CORP_NM",
            headerText: "공급받는자",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "BUYR_CORP_NO",
            headerText: "공급받는자 사업자번호",
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "BUYR_CHRG_NM1",
            headerText: "공급받는자 담당자",
            editable: false,
            width: 120,
            filter: { showIcon: true }
        },
        {
            dataField: "BUYR_CHRG_EMAIL1",
            headerText: "공급받는자 담당자 이메일",
            editable: false,
            width: 120
        },
        {
            dataField: "REGS_DATE",
            headerText: "작성일자",
            editable: false,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            width: 100,
            filter: { showIcon: true }
        },
        {
            dataField: "CHRG_AMT",
            headerText: "공급가액",
            editable: false,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            width: 100
        },
        {
            dataField: "TAX_AMT",
            headerText: "부가세",
            editable: false,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            width: 100
        },
        {
            dataField: "TOTL_AMT",
            headerText: "합계",
            editable: false,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            width: 100
        },
        {
            dataField: "REQ_NTS_DATE",
            headerText: "국세청전송일자",
            editable: false,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            width: 100,
            filter: { showIcon: true }
        },
        /*숨김필드*/
        {
            dataField: "STAT_CODE",
            headerText: "STAT_CODE",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "REQ_STAT_CODE",
            headerText: "REQ_STAT_CODE",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "POPS_CODE",
            headerText: "POPS_CODE",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "TAX_TYPE",
            headerText: "TAX_TYPE",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "NOTE1",
            headerText: "NOTE1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "NOTE2",
            headerText: "NOTE2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "NOTE3",
            headerText: "NOTE3",
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

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    fnOpenTaxBillDetail(objItem);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "SaleClosingTaxBillList",
        ClosingType: $("#ClosingType").val(),
        CenterCode: $("#CenterCode").val().split("^")[0],
        CenterCorpNo: $("#CenterCode").val().split("^")[1],
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        ReqStatCode: $("#ReqStatCode").val(),
        StatCode: $("#StatCode").val(),
        CorpName: $("#CorpName").val(),
        CorpNo: $("#CorpNo").val(),
        ChargeName: $("#ChargeName").val(),
        ChargeEmail: $("#ChargeEmail").val(),
        PageNo: $("#PageNo").val(),
        PageSize: $("#PageSize").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    AUIGrid.removeAjaxLoader(GridID);

    if (objRes) {
        $("#RecordCnt").val(0);
        $("#GridResult").html("");
        AUIGrid.setGridData(GridID, []);
        // 페이징
        fnCreatePagingNavigator();

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RECORD_CNT);
        $("#GridResult").html("[" + objRes[0].data.RECORD_CNT + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);

        // 페이징
        fnCreatePagingNavigator();

        // 그리드 정렬
        AUIGrid.setSorting(GridID, GridSort);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {
    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "ERR_CD",
            dataField: "ERR_CD",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        },
        {
            positionField: "CHRG_AMT",
            dataField: "CHRG_AMT",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TAX_AMT",
            dataField: "TAX_AMT",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TOTL_AMT",
            dataField: "TOTL_AMT",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/*****************************************/
// 발행 취소
/*****************************************/
var CnlList = null;
var CnlCnt = 0;
var CnlProcCnt = 0;
var CnlSuccessCnt = 0;
var CnlFailCnt = 0;

function fnCnlTaxBill() {
    CnlList = [];

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 계산서가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.ERR_CD != "000000" && item.item.SELR_CORP_NO.replace(/ /gi, "") == $("#CenterCode").val().split("^")[1]) {
            cnt++;
            CnlList.push(item.item);
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("취소할 수 있는 계산서가 없습니다.", "warning");
        return false;
    }

    CnlCnt = CnlList.length;
    CnlProcCnt = 0;
    CnlSuccessCnt = 0;
    CnlFailCnt = 0;
    fnDefaultConfirm("계산서 발행을 취소 하시겠습니까?", "fnCnlTaxBillProc", "");
}

function fnCnlTaxBillProc() {

    $("#divLoadingImage").show();

    if (CnlProcCnt >= CnlCnt) {

        $("#divLoadingImage").hide();
        fnCnlTaxBillEnd();
        return;
    }

    var RowCnl = CnlList[CnlProcCnt];

    if (RowCnl) {
        var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
        var strCallBackFunc = "fnCnlTaxBillSuccResult";
        var strFailCallBackFunc = "fnCnlTaxBillFailResult";
        var objParam = {
            CallType: "SaleClosingTaxBillCancel",
            IssuSeqNo: RowCnl.ISSU_SEQNO,
            CenterCorpNo: $("#CenterCode").val().split("^")[1],
            CenterCode: $("#CenterCode").val().split("^")[0],
            SaleClosingSeqNo: RowCnl.NOTE3
    };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnCnlTaxBillSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            CnlSuccessCnt++;
        } else {
            CnlFailCnt++;
        }
    } else {
        CnlFailCnt++;
    }
    CnlProcCnt++;
    setTimeout(fnCnlTaxBillProc(), 500);
}

function fnCnlTaxBillFailResult() {
    CnlProcCnt++;
    CnlFailCnt++;
    setTimeout(fnCnlTaxBillProc(), 500);
    return false;
}

function fnCnlTaxBillEnd() {
    fnDefaultAlert("총 " + CnlCnt + "건의 계산서 중 " + CnlSuccessCnt + "건이 취소되었습니다.", "info");
    fnCallGridData(GridID);
    return false;
}
/*****************************************/

function fnOpenTaxBillDetail(objItem) {
    window.open("/TMS/ClosingSale/SaleClosingTaxBillView?IssuSeqNo=" + objItem.ISSU_SEQNO + "&CenterCode=" + objItem.CenterCode, "계산서보기", "width=1150, height=800, scrollbars=Yes");
    return false;
}