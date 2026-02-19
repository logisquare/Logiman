// 그리드
var GridID = "#NetworkRuleListGrid";
var GridSort = [];

$(document).ready(function () {
    
    // 그리드 초기화
    fnGridInit();

    $("#ClientName").on("keydown", function (event) {
        if (event.keyCode === 13) {
            fnCallGridData(GridID);
            return false;
        }
    });

    $("#RegAdminName").on("keydown", function (event) {
        if (event.keyCode === 13) {
            fnCallGridData(GridID);
            return false;
        }
    });
});


function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "PlaceSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 220;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 220);
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
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
    //objGridProps.rowIdField = strRowIdField; // 키 필드 지정
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
        fnSaveColumnLayoutAuto(GridID, 'NetworkRuleListGrid');
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
            dataField: "RuleSeqNo",
            headerText: "일련번호",
            editable: false,
            width: 0
        },
        {
            dataField: "ClientCode",
            headerText: "고객사 키(TClient)",
            editable: false,
            width: 0
        },
        {
            dataField: "CenterCode",
            headerText: "회원사 키(TCenter)",
            editable: false,
            width: 0
        }, {
            dataField: "NetworkKind",
            headerText: "정보망구분",
            editable: false,
            width: 0
        },
        
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "ClientName",
            headerText: "고객사명",
            editable: false,
            width: 300,
            filter: { showIcon: true },
            viewstatus: true
        },{
            dataField: "RenewalModMinute",
            headerText: "수정주기(분)",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },{
            dataField: "RenewalStartMinute",
            headerText: "증액시작시간(분)",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "RenewalIntervalMinute",
            headerText: "증액주기(분)",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "RenewalIntervalPrice",
            headerText: "증액금액",
            editable: false,
            width: 200,
            filter: { showIcon: true },
            dataType: "numeric",
            formatString: "#,###",
            viewstatus: true
        },
        {
            dataField: "RegAdminName",
            headerText: "등록자",
            editable: false,
            width: 200,
            viewstatus: true
        },
        {
            dataField: "RegDate",
            headerText: "등록일시",
            dataType: "date",
            formatString: "yyyy-mm-dd",
            editable: false,
            width: 200,
            viewstatus: true
        },
        {
            dataField: "BtnDetail",
            headerText: "조회",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "조회",
                onClick: function (event) {
                    fnNetworkRuleDetail(event.item.RuleSeqNo);
                }
            },
            viewstatus: true

        },
        {
            dataField: "BtnDel",
            headerText: "삭제",
            editable: false,
            width: 100,
            viewstatus: true,
            renderer: {
                type: "ButtonRenderer",
                labelText: "삭제",
                onClick: function (event) {
                    var strParam = {
                        CallType: "NetworkRuleUpdate",
                        RuleSeqNo: event.item.RuleSeqNo,
                        RuleType: "1",
                        CenterCode: event.item.CenterCode,
                        ClientCode: event.item.ClientCode,
                        RenewalModMinute: event.item.RenewalModMinute,
                        RenewalStartMinute: event.item.RenewalStartMinute,
                        RenewalIntervalMinute: event.item.RenewalIntervalMinute,
                        RenewalIntervalPrice: event.item.RenewalIntervalPrice,
                        NetworkKind: event.item.NetworkKind,
                        UseFlag : "N"
                    };
                    fnDefaultConfirm("해당 룰을 삭제하시겠습니까?", "fnDelNetworkRule", strParam);
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

    fnUpdClientPlaceCharge(objItem.PlaceSeqNo);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/TMS/Network/Proc/OrderNetworkRuleHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "NetworkRuleList",
        CenterCode: $("#CenterCode").val(),
        ClientName: $("#ClientName").val(),
        RegAdminName: $("#RegAdminName").val(),
        UseFlag : "Y"
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

function fnNetworkRuleDetail(RuleSeqNo) {
    fnOpenRightSubLayer("자동배차 룰관리 수정", "/TMS/Network/OrderNetworkRuleIns?HidMode=Update&RuleSeqNo=" + RuleSeqNo, "1024px", "700px", "50%");
    return;
}


function fnDelNetworkRule(strParam) {
    var strHandlerURL = "/TMS/Network/Proc/OrderNetworkRuleHandler.ashx";
    var strCallBackFunc = "fnAjaxNetworkRule";
    UTILJS.Ajax.fnHandlerRequest(strParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxNetworkRule(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {
        fnDefaultAlert("삭제되었습니다.", "success", "fnCallGridData", GridID);
        return;
    }
}