// 그리드
var GridID = "#ClientTransRateListGrid";
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

    $("#ConsignorName").on("keydown", function (event) {
        if (event.keyCode === 13) {
            fnCallGridData(GridID);
            return false;
        }
    });
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "");
    
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
        fnSaveColumnLayoutAuto(GridID, 'ClientTransRateListGrid');
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
            dataField: "SeqNo",
            headerText: "상하차지 일련번호",
            editable: false,
            width: 0
        },
        {
            dataField: "CenterCode",
            headerText: "회원사코드",
            editable: false,
            width: 0
        },
        {
            dataField: "ConsignorCode",
            headerText: "화주코드",
            editable: false,
            width: 0
        },
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "CenterName",
            headerText: "운송사명",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "ClientCode",
            headerText: "고객사 코드",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "FromYMD",
            headerText: "적용일",
            dataType: "date",
            formatString : "yyyy-mm-dd",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "ClientName",
            headerText: "고객사명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ConsignorName",
            headerText: "화주명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "RateTypeM",
            headerText: "요율표구분",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Cnt",
            headerText: "등록건수",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "RegAdminID",
            headerText: "최초등록자",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "RegDate",
            headerText: "최초등록일",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "UpdAdminID",
            headerText: "최종수정자",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "UpdDate",
            headerText: "최종수정일",
            editable: false,
            width: 100,
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
                    var CenterCode = event.item.CenterCode;
                    var ClientCode = event.item.ClientCode;
                    var ClientName = event.item.ClientName;
                    var ConsignorCode = event.item.ConsignorCode;
                    var ConsignorName = event.item.ConsignorName;
                    var FromYMD = event.item.FromYMD;
                    var RateType = event.item.RateType;
                    fnUpdClientTrans(CenterCode, ClientCode, ClientName, ConsignorCode, ConsignorName, FromYMD, RateType);
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
                    var CenterCode = event.item.CenterCode;
                    var ClientCode = event.item.ClientCode;
                    var ConsignorCode = event.item.ConsignorCode;
                    var FromYMD = event.item.FromYMD;
                    var RateType = event.item.RateType;
                    var ParamArr = [CenterCode, ClientCode, ConsignorCode, FromYMD, RateType];
                    fnDefaultConfirm("요율표를 삭제하시겠습니까?", "fnDelClientTrans", ParamArr)
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

    var strHandlerURL = "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType        : "ClientTransRateGroupList",
        CenterCode      : $("#CenterCode").val(),
        ClientName      : $("#ClientName").val(),
        ConsignorName   : $("#ConsignorName").val(),
        DelFlag         : "N",
        PageNo          : $("#PageNo").val(),
        PageSize        : $("#PageSize").val()
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

function fnUpdClientTrans(CenterCode, ClientCode, ClientName, ConsignorCode, ConsignorName, FromYMD, RateType) {
    var Param = "";
    Param = "HidMode=Update";
    Param += "&ParamCenterCode=" + CenterCode;
    Param += "&ParamClientCode=" + ClientCode;
    Param += "&ParamClientName=" + ClientName;
    Param += "&ParamConsignorCode=" + ConsignorCode;
    Param += "&ParamConsignorName=" + ConsignorName;
    Param += "&ParamFromYMD=" + FromYMD;
    Param += "&ParamRateType=" + RateType;
    fnOpenRightSubLayer("요율표 수정", "/TMS/ClientTransRate/ClientTransRateIns?" + Param, "1024px", "700px", "80%");
    return;
}

function fnDelClientTrans(param) {
    var CenterCode      = param[0];
    var ClientCode      = param[1];
    var ConsignorCode   = param[2];
    var FromYMD         = param[3];
    var RateType        = param[4];

    var strHandlerURL = "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
    var strCallBackFunc = "fnAjaxDelClientTrans";

    var objParam = {
        CallType: "ClientTransRateDel",
        CenterCode: CenterCode,
        ClientCode: ClientCode,
        ConsignorCode: ConsignorCode,
        FromYMD: FromYMD,
        RateType: RateType,
        DelFlag: "Y"
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(GridID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnAjaxDelClientTrans(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("삭제되었습니다.", "info", "fnCallGridData", GridID);
    }
}