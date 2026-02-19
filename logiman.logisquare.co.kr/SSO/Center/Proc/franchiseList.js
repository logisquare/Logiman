// 그리드
var GridID = "#CenterListGrid";
var GridSort = [];

$(document).ready(function () {
    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // Ctrl + F
        if (event.ctrlKey && event.keyCode === 70) {
            //fnSearchDialog("gridDialog", "open");
            return false;
        }

        // ESC
        if (event.keyCode === 27) {
            //fnSearchDialog("gridDialog", "close");
            return false;
        }
    });

    // 그리드 초기화
    fnGridInit();
});


function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "CenterCode");

    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 200;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 200);
    });

    fnCallGridData(GridID);

    //그리드에 포커스
    AUIGrid.setFocus(GridID);
}

//기본 레이아웃 세팅
function fnCreateGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true;
    objGridProps.enableMovingColumn = true;
    objGridProps.useGroupingPanel = false;
    objGridProps.processValidData = true;
    objGridProps.noDataMessage = "검색된 데이터가 없습니다.";
    objGridProps.headerHeight = 25;
    objGridProps.rowHeight = 25;
    objGridProps.selectionMode = "multipleCells";
    objGridProps.copySingleCellOnRowMode = true;
    objGridProps.fixedColumnCount = 0;
    objGridProps.showFooter = true;
    objGridProps.footerHeight = 25;
    objGridProps.showRowNumColumn = true;
    objGridProps.showRowCheckColumn = false;
    objGridProps.rowIdField = strRowIdField;
    objGridProps.enableFilter = true;
    objGridProps.editable = false;
    objGridProps.showStateColumn = false;
    objGridProps.softRemoveRowMode = false;
    objGridProps.enableRestore = false;
    objGridProps.isGenNewRowsOnPaste = false;
    objGridProps.showTooltip = true;
    objGridProps.filterMenuItemMaxCount = 200;

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'CenterListGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "CenterCode",
            headerText: "회원사코드",
            editable: false,
            width: 0
        },
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false
        },
        {
            dataField: "CorpNo",
            headerText: "사업자번호",
            editable: false
        },
        {
            dataField: "CeoName",
            headerText: "대표자명",
            editable: false,
            viewstatus: true
        },
        {
            dataField: "TelNo",
            headerText: "전화번호",
            editable: false,
            viewstatus: true
        },
        {
            dataField: "FaxNo",
            headerText: "팩스번호",
            editable: false,
            viewstatus: true
        },
        {
            dataField: "CenterTypeM",
            headerText: "회원사 종류",
            editable: false,
            viewstatus: true
        },
        {
            dataField: "TransSaleRate",
            headerText: "이관매출비율(%)",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right"
        },
        {
            dataField: "RegAdminID",
            headerText: "등록 ID",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "RegDate",
            headerText: "등록일시",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "BtnUpdCenter",
            headerText: "상세",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "조회",
                onClick: function (event) {
                    fnInsCenter("가맹점 수정", event.item.CenterCode);
                }
            }
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
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

    fnInsCenter("회원사 수정", objItem.CenterCode);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/SSO/Center/Proc/CenterHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "CenterList",
        SearchType: $("#SearchType").val(),
        ListSearch: $("#ListSearch").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "");
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

        // 푸터
        //fnSetGridFooter(GridID);
        return false;
    }
}
