// 그리드
var GridID = "#WebDomesticReqInsGrid";
var GridSort = [];

$(document).ready(function () {
    $("#NoticeClient").focus();
    // 그리드 초기화
    fnGridInit();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "ChgSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = 550;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 50);
    });

    fnCallGridData(GridID);

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
    objGridProps.selectionMode = "multipleRows"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    //objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    objGridProps.rowStyleFunction = function (rowIndex, item) {

        if (item.ChgStatus === 4) {
            return "aui-grid-bonded-y-no-accept-row-style";
        }

        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'WebDomesticReqInsGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 숨김필드 */
        /*************/
        {
            dataField: "ChgSeqNo",
            headerText: "일련번호",
            editable: false,
            width: 0
        },
        {
            dataField: "ChgMessage",
            headerText: "요청메시지",
            editable: false,
            width: 0
        },
        {
            dataField: "ChgStatus",
            headerText: "상태값",
            editable: false,
            width: 0
        },
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "ChgStatusM",
            headerText: "상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        }, {
            dataField: "ChgReqContent",
            headerText: "요청내용",
            editable: false,
            width: 650,
            viewstatus: true
        }, {
            dataField: "YMD",
            headerText: "요청일",
            editable: false,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            width: 200,
            viewstatus: true
        },
        {
            dataField: "BtnCancel",
            headerText: "요청취소",
            editable: false,
            width: 100,
            viewstatus: true,
            renderer: {
                type: "ButtonRenderer",
                labelText: "취소",
                onClick: function (event) {
                    fnRequestChgCnlConfitm(event.item);
                    return;
                },
                visibleFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    if (item.ChgStatus == 1) {
                        return true;
                    } else {
                        return false;
                    }
                    
                }
            }
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

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "WebRequestChgList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        PageSize: 3000,
        PageNo: 1
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
            // 페이징
            fnCreatePagingNavigator();
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

        // 페이징
        fnCreatePagingNavigator();

        // 그리드 정렬
        AUIGrid.setSorting(GridID, GridSort);

        return false;
    }
}

//요청등록
function fnRequestChgInsConfirm() {
    if ($("#ChgReqContent").val() === "") {
        fnDefaultAlertFocus("요청내용을 입력해주세요", "ChgReqContent", "warning");
        return;
    }

    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("필요한 값이 없습니다.(회원사)", "warning");
        return;
    }

    if ($("#OrderNo").val() === "") {
        fnDefaultAlert("필요한 값이 없습니다.(접수번호)", "warning");
        return;
    }

    var objParam = {
        CallType: "WebOrderRequestCnlInsert",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        OrderClientCode: $("#OrderClientCode").val(),
        ChgReqContent: $("#ChgReqContent").val(),
        ChgStatus: 1
    };

    fnDefaultConfirm("해당 내용으로 요청하시겠습니까?", "fnRequestChgIns", objParam)
    return;
    
}

function fnRequestChgIns(objParam) {

    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
    var strCallBackFunc = "fnAjaxRequestChgIns";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxRequestChgIns(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
    } else {
        fnDefaultAlert("처리되었습니다.", "success");
        $("#ChgReqContent").val("");
        fnCallGridData(GridID);
        return;
    }
}

function fnRequestChgCnlConfitm(item) {
    
    var objParam = {
        CallType: "WebOrderRequestCnlUpdate",
        ChgSeqNo: item.ChgSeqNo,
        ChgReqContent: item.ChgReqContent,
        ChgMessage: item.ChgMessage,
        ChgStatus: 4
    };

    fnDefaultConfirm("해당 내용을 취소하시겠습니까?", "fnRequestChgCnl", objParam)
    return;
}

function fnRequestChgCnl(objParam) {
    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
    var strCallBackFunc = "fnAjaxRequestChgIns";
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}
