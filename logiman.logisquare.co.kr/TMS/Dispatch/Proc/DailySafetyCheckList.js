window.name = "DailySafetyCheckList";
// 그리드
var GridID = "#DailySafetyCheckListGrid";
var GridSort = [];

$(document).ready(function () {

    $("#DateYMD").datepicker({
        dateFormat: "yy-mm-dd"
    });
    $("#DateYMD").datepicker("setDate", GetDateToday("-"));

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
    fnCreateGridLayout(GridID, "DispatchSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 180;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 180);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 180);
        }, 100);
    });

    //그리드에 포커스
    AUIGrid.setFocus(GridID);

    // 푸터
    fnSetGridFooter(GridID);
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
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

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
            dataField: "BtnViewSafetyCheck",
            headerText: "안전점검표",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    fnViewSafetyCheck(event.item);
                    return false;
                }
            }
        },
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderNo",
            headerText: "오더번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderItemCodeM",
            headerText: "상품",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderLocationCodeM",
            headerText: "사업장",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DispatchTypeM",
            headerText: "배차구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DispatchStatusM",
            headerText: "배차상태",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CargoManFlag",
            headerText: "카고맨",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComName",
            headerText: "차량업체명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComCorpNo",
            headerText: "사업자번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DriverCell",
            headerText: "휴대폰번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupYMD",
            headerText: "상차일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SendCnt",
            headerText: "발송횟수",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendYMD",
            headerText: "최종발송일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        /*
        {
            dataField: "SendDate",
            headerText: "최종발송일시",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        */
        {
            dataField: "ReplyFlag",
            headerText: "점검여부",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        /*
        {
            dataField: "ReplyDate",
            headerText: "점검일시",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        */
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
            dataField: "DispatchSeqNo",
            headerText: "DispatchSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "RefSeqNo",
            headerText: "RefSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "Reply1",
            headerText: "Reply1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "Reply2",
            headerText: "Reply2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "Reply3",
            headerText: "Reply3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "Reply4",
            headerText: "Reply4",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "Reply5",
            headerText: "Reply5",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "Reply6",
            headerText: "Reply6",
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

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/TMS/Dispatch/Proc/DailySafetyCheckHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "DailySafetyCheckList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateYMD: $("#DateYMD").val(),
        ComName: $("#ComName").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        CarNo: $("#CarNo").val(),
        DriverName: $("#DriverName").val(),
        DriverCell: $("#DriverCell").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            $("#RecordCnt").val(0);
            $("#GridResult").html("");
            AUIGrid.setGridData(GridID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

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
            positionField: "CenterName",
            dataField: "CenterName",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendCnt",
            dataField: "SendCnt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

// 안전점검표 보기
function fnViewSafetyCheck(objItem) {
    if (objItem.SendCnt <= 0) {
        fnDefaultAlert("점검표를 발송한 내역이 없습니다.", "warning");
        return false;
    }

    if (objItem.ReplyFlag !== "Y") {
        fnDefaultAlert("점검이 완료되지 않았습니다.", "warning");
        return false;
    }

    window.open("/TMS/Dispatch/DailySafetyCheckView?CheckData=" + JSON.stringify(objItem), "안전점검표", "width=750px,height=800px,scrollbars=auto");
    return false;
}

// 안전점검표 발송
var SendList = null;
var SendCnt = 0;
var SendProcCnt = 0;
var SendSuccessCnt = 0;
var SendFailCnt = 0;
var SendResultMsg = "";

function fnSafetyCheckSend() {
    SendList = [];

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 기사정보가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var duplicationCnt = 0;
    $.each(CheckedItems,
        function(index, item) {
            if (item.item.PickupYMD === GetDateToday("")) {
                cnt++;
                SendList.push(item.item);
                if (item.item.SendCnt > 0) {
                    duplicationCnt++;
                }
            }
        });

    if (cnt <= 0) {
        fnDefaultAlert("발송할 수 있는 기사정보가 없습니다.<br/>(금일 상차건만 발송 가능)", "warning");
        return false;
    }

    var strConfMsg = cnt + "명에게 안전점검표 작성요청 알림톡 발송하시겠습니까?";
    if (duplicationCnt > 0) {
        strConfMsg += "<br>(이미 발송된 내역이 포함되어 있습니다.)";
    }

    SendCnt = SendList.length;
    SendProcCnt = 0;
    SendSuccessCnt = 0;
    SendFailCnt = 0;
    SendResultMsg = "";

    fnDefaultConfirm(strConfMsg, "fnSafetyCheckSendProc", "");
    return false;
}

function fnSafetyCheckSendProc() {

    AUIGrid.showAjaxLoader(GridID);

    if (SendProcCnt >= SendCnt) {
        AUIGrid.removeAjaxLoader(GridID);
        fnInsTransEnd();
        return false;
    }

    var RowSend = SendList[SendProcCnt];

    if (RowSend) {
        var strHandlerURL = "/TMS/Dispatch/Proc/DailySafetyCheckHandler.ashx";
        var strCallBackFunc = "fnSafetyCheckSendSuccResult";
        var strFailCallBackFunc = "fnSafetyCheckSendFailResult";
        var objParam = {
            CallType: "DailySafetyCheckInsert",
            CenterCode: RowSend.CenterCode,
            OrderNo: RowSend.OrderNo,
            DispatchSeqNo: RowSend.DispatchSeqNo,
            RefSeqNo: RowSend.RefSeqNo
        };

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnSafetyCheckSendSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            SendSuccessCnt++;
        } else {
            SendFailCnt++;
        }
    } else {
        SendFailCnt++;
    }
    SendProcCnt++;
    setTimeout(fnSafetyCheckSendProc(), 200);
}

function fnInsTransFailResult() {
    SendProcCnt++;
    SendFailCnt++;
    setTimeout(fnSafetyCheckSendProc(), 200);
    return false;
}

function fnInsTransEnd() {
    fnDefaultAlert("총 " + SendCnt + "건 중 " + SendSuccessCnt + "건이 발송되었습니다.", "info");
    fnCallGridData(GridID);
    return false;
}