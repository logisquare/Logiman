// 그리드
var GridID = "#ServerIPListGrid";
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
    fnCreateGridLayout(GridID, "AllowIPAddr");

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

    AUIGrid.setRendererProp(GridID, AUIGrid.getColumnIndexByDataField(GridID, "BtnDelServerIP"),
        {
            onclick: function (rowIndex, columnIndex, value, item) {
                fnDelServerIP(item);
            }
        });
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
    objGridProps.selectionMode = "multipleRows";
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
        fnSaveColumnLayoutAuto(GridID, "ServerIPListGrid");
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "ServerType",
            headerText: "서버유형",
            editable: false,
            width: 150
        },
        {
            dataField: "CenterCodeM",
            headerText: "운송사",
            editable: false,
            width: 150
        },
        {
            dataField: "AllowIPAddr",
            headerText: "IP",
            editable: false,
            width: 150
        },
        {
            dataField: "AllowIPDesc",
            headerText: "IP 설명",
            editable: false,
            viewstatus: true
        },
        {
            dataField: "UseFlagM",
            headerText: "사용 여부",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "AdminID",
            headerText: "관리자 아이디",
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
            dataField: "UpdDate",
            headerText: "수정일시",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "BtnUpdServerIP",
            headerText: "수정",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "수정",
                onClick: function (event) {
                    fnInsServerIP("접근 IP 수정", event.item.ServerType, event.item.CenterCode, event.item.AllowIPAddr);
                }
            }
        },
        {
            dataField: "BtnDelServerIP",
            headerText: "삭제",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "삭제"
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

    fnInsServerIP("접근 IP 수정", objItem.ServerType, objItem.CenterCode, objItem.AllowIPAddr);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/SSO/Server/Proc/ServerHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "ServerIPList",
        UseFlag: $("#UseFlag").val(),
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

// 데이터 삭제
var DelRowItem;
function fnDelServerIP(item) {

    var strConfMsg;
    var strCallType;

    strCallType = "ServerIPDelete";
    strConfMsg = "허용 IP를 삭제하시겠습니까?";

    if (item.ServerType === "" || item.CenterCode === "" || item.AllowIPAddr === "") {
        fnDefaultAlert("IP 삭제에 필요한 정보가 부족합니다.", "warning");
        return;
    }

    DelRowItem = item;

    //Confirm
    fnDefaultConfirm(strConfMsg, "fnDelServerIPProc", strCallType);

    return;
}

function fnDelServerIPProc(ojbParam) {
    var strHandlerURL = "/SSO/Server/Proc/ServerHandler.ashx";
    var strCallBackFunc = "fnAjaxDelServerIP";

    let objParam = {
        CallType: ojbParam,
        ServerType: DelRowItem.ServerType,
        CenterCode: DelRowItem.CenterCode,
        AllowIPAddr: DelRowItem.AllowIPAddr
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxDelServerIP(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", fnCallGridData(GridID));
    }
}
