window.name = "PurchaseInsureListGrid";
// 그리드
var GridID = "#PurchaseInsureListGrid";
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
    fnCreateGridLayout(GridID, "DispatchSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 210;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 210);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 210);
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
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
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

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'PurchaseInsureListGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderNo",
            headerText: "접수번호",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupYMD",
            headerText: "상차요청일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            viewstatus: true
        },
        {
            dataField: "GetYMD",
            headerText: "하차요청일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            viewstatus: true
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverCell",
            headerText: "기사휴대폰",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "InformationFlag",
            headerText: "주민번호수집",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "InsureExceptKindM",
            headerText: "산재보험신고",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "InsureTargetFlag",
            headerText: "산재보험대상",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "InsureFlag",
            headerText: "산재보험적용",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SupplyAmt",
            headerText: "운송료(공급가액)",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "TransAmt",
            headerText: "월보수액",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "PurchaseClosingSeqNo",
            headerText: "전표번호",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: false,
            labelFunction: function(rowIndex, columnIndex, value, headerText, item) {
                if (value == "0") {
                    value = "";
                }
                return value;
            }
        },
        {
            dataField: "BillStatusM",
            headerText: "발행상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "BillKindM",
            headerText: "발행구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillWrite",
            headerText: "계산서작성일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
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
            dataField: "ComCode",
            headerText: "ComCode",
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
            dataField: "DriverSeqNo",
            headerText: "DriverSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderItemCodeM",
            headerText: "OrderItemCodeM",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ContractFlag",
            headerText: "ContractFlag",
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
        return false;
    }

    if (strKey === "PurchaseClosingSeqNo") {
        fnClosingDetail(objItem.CenterCode, objItem.PurchaseClosingSeqNo);
        return false;
    } else {
        fnCommonOpenOrder(objItem);
        return false;
    }
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

    var dateTerm = fnGetDateTerm($("#DateFrom").val(), $("#DateTo").val());

    if (dateTerm > 30) {
        fnDefaultAlert("최대 31일까지 조회하실 수 있습니다.", "info");
        return false;
    }

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseInsureHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "PurchaseInsureList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        CarNo: $("#CarNo").val(),
        DriverName: $("#DriverName").val(),
        DriverCell: $("#DriverCell").val(),
        InformationFlag: $("#InformationFlag").val(),
        InsureExceptKind: $("#InsureExceptKind").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {

        $("#RecordCnt").val(0);
        $("#GridResult").html("");
        AUIGrid.setGridData(GridID, []);

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
            positionField: "SupplyAmt",
            dataField: "SupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TransAmt",
            dataField: "TransAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

//마감상세
function fnClosingDetail(strCenterCode, strPurchaseClosingSeqNo) {
    if (typeof strCenterCode === "undefined" || typeof strPurchaseClosingSeqNo === "undefined") {
        return false;
    }

    if (strCenterCode == "0" || strCenterCode == "" || strCenterCode == null || strPurchaseClosingSeqNo == "0" || strPurchaseClosingSeqNo == "" || strPurchaseClosingSeqNo == null) {
        return false;
    }

    fnOpenRightSubLayer("매입 마감 상세", "/TMS/ClosingPurchase/PurchaseClosingDetailList?ClosingCenterCode=" + strCenterCode + "&PurchaseClosingSeqNo=" + strPurchaseClosingSeqNo, "500px", "700px", "80%");
    return false;
}

var SendItemList = [];
var SendCnt = 0;
var SendProcCnt = 0;
var SendSuccessCnt = 0;
var SendFailCnt = 0;
var SendResultMsg = "";

//알림톡 발송
function fnSendAgreement() {

    SendItemList = [];

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("알림톡을 발송할 내역을 선택해주세요.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.ContractFlag === "Y") {
            if (SendItemList.findIndex((e) => (e.DriverSeqNo === item.item.DriverSeqNo && e.CenterCode === item.item.CenterCode)) === -1) {
                SendItemList.push(item.item);
                cnt++;
            }
        }
    });

    if (cnt === 0) {
        fnDefaultAlert("발송할 내역이 없습니다.", "warning");
        return false;
    }

    SendCnt = SendItemList.length;
    SendProcCnt = 0;
    SendSuccessCnt = 0;
    SendFailCnt = 0;
    SendResultMsg = "";
    fnDefaultConfirm("알림톡을 발송하시겠습니까?", "fnSendAgreementProc", "");
    return false;
}

function fnSendAgreementProc() {

    AUIGrid.showAjaxLoader(GridID);

    if (SendProcCnt >= SendCnt) {
        AUIGrid.removeAjaxLoader(GridID);
        fnSendAgreementEnd();
        return;
    }

    var RowSend = SendItemList[SendProcCnt];
    if (RowSend) {
        var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseInsureHandler.ashx";
        var strCallBackFunc = "fnSendAgreementProcSuccResult";
        var strFailCallBackFunc = "fnSendAgreementProcFailResult";
        var objParam = {
            CallType: "SendKakaoDriver",
            CenterCode: RowSend.CenterCode,
            RefSeqNo: RowSend.RefSeqNo,
            DriverSeqNo: RowSend.DriverSeqNo
        };

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    }
}

function fnSendAgreementProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            SendSuccessCnt++;
        } else {
            SendFailCnt++;
            SendResultMsg += "<br>" + SendItemList[SendProcCnt].OrderNo + ":" + objRes[0].ErrMsg;
        }
    } else {
        SendFailCnt++;
        SendResultMsg += "<br>" + SendItemList[SendProcCnt].OrderNo;
    }
    SendProcCnt++;
    setTimeout(fnSendAgreementProc(), 500);
}

function fnSendAgreementProcFailResult() {
    SendFailCnt++;
    SendProcCnt++;
    SendResultMsg += "<br>" + SendItemList[SendProcCnt];
    setTimeout(fnSendAgreementProc(), 500);
    return false;
}

function fnSendAgreementEnd() {
    var msg = "총 " + SendCnt + "건의 내역 중 " + SendSuccessCnt + "건이 발송되었습니다.";
    if (SendResultMsg != "") {
        msg += SendResultMsg;
    }
    fnDefaultAlert(msg, "info");
    return false;
}