// 그리드
var GridID = "#CarDriverListGrid";

$(document).ready(function () {
    // 그리드 초기화
    fnGridInit();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "DriverSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "", "", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 200;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 200);
    });

    //fnCallGridData(GridID);

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

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'CarDriverListGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 120,
            viewstatus: true,
            filter: { showIcon: true }
        },
        {
            dataField: "DriverCell",
            headerText: "휴대폰",
            editable: false,
            width: 150,
            viewstatus: true,
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "DriverDtlFlag",
            headerText: "추가정보수집여부",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strFlag = "N";
                if (item.DriverDtl > 0) {
                    strFlag = "Y";
                }
                return strFlag;
            }
        },
        {
            dataField: "UseFlagM",
            headerText: "사용여부",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "RegDate",
            headerText: "등록일",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "RegAdminID",
            headerText: "등록자",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "UpdDate",
            headerText: "수정일",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "UpdAdminID",
            headerText: "수정자",
            editable: false,
            width: 120,
            viewstatus: true
        },
        /*************/
        /* 숨김필드 */
        /*************/
        {
            dataField: "DriverSeqNo",
            headerText: "DriverSeqNo",
            editable: false,
            width: 0
        },
        {
            dataField: "DriverDtlCnt",
            headerText: "DriverDtlCnt",
            editable: false,
            width: 0
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;
    fnOpenDriverUpd(objItem);
    return false;
}
//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/TMS/Car/Proc/CarDriverListHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "CarDriverList",
        UseFlag: $("#UseFlag").val(),
        DriverName: $("#DriverName").val(),
        DriverCell: $("#DriverCell").val(),
        PageNo: $("#PageNo").val(),
        PageSize: $("#PageSize").val()
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
        fnCreatePagingNavigator();
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

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);

        // 페이징
        fnCreatePagingNavigator();
        return false;
    }
}

//기사명 수정 리셋
function fnDriverUpdReset() {
    $("#DriverSeqNo").val("");
    $("#SpanDriverName").text("");
    $("#SpanDriverCell").text("");
    $("#DriverNameNew").val("");
    return false;
}

// 기사명 수정 열기
function fnOpenDriverUpd(objItem) {
    fnDriverUpdReset();
    $("#DriverSeqNo").val(objItem.DriverSeqNo);
    $("#SpanDriverName").text(objItem.DriverName);
    $("#SpanDriverCell").text(fnMakeCellNo(objItem.DriverCell));
    $("#DivDriverUpd").show();
    return false;
}

// 기사명 수정 닫기
function fnCloseDriverUpd() {
    fnDriverUpdReset();
    $("#DivDriverUpd").hide();
    return false;
}

//기사명 수정
function fnDriverUpdReg() {
    if (!$("#DriverSeqNo").val()) {
        return false;
    }

    if (!$("#DriverNameNew").val()) {
        fnDefaultAlertFocus("기사명을 입력하세요.", "DriverNameNew", "warning");
        return false;
    }

    fnDefaultConfirm("기사명을 수정하시겠습니까?", "fnDriverUpdRegProc", "");
    return false;
}

function fnDriverUpdRegProc() {
    if (!$("#DriverSeqNo").val() || !$("#DriverNameNew").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/Car/Proc/CarDriverListHandler.ashx";
    var strCallBackFunc = "fnDriverUpdRegSuccResult";
    var strFailCallBackFunc = "fnDriverUpdRegFailResult";

    var objParam = {
        CallType: "CarDriverInfoUpd",
        DriverSeqNo: $("#DriverSeqNo").val(),
        DriverName: $("#DriverNameNew").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    return false;
}

function fnDriverUpdRegSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode == 0) {
            fnDefaultAlert("기사명 수정이 완료되었습니다.", "info");
            $("#DriverName").val($("#DriverNameNew").val());
            fnMoveToPage(1);
            fnCloseDriverUpd();
            return false;
        } else {
            fnDriverUpdRegFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnDriverUpdRegFailResult();
        return false;
    }
}

function fnDriverUpdRegFailResult(strMsg) {
    strMsg = typeof strMsg === "string" ? strMsg : "";
    strMsg = strMsg !== "" ? ("<br/>(" + strMsg + ")") : "";

    fnDefaultAlert("기사명 수정에 실패했습니다." + strMsg);
    return false;
}