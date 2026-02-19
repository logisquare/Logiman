// 그리드
var GridID = "#TransRateApplyListGrid";

$(document).ready(function () {
    // 그리드 초기화
    fnGridInit();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "");
    
    fnSetGridEvent(GridID, "", "", "", "", "", "", "", "");

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

    if (Number($("#GradeCode").val()) > 4) {
        AUIGrid.hideColumnByDataField(GridID, "BtnDetailList");//수정내역
        AUIGrid.hideColumnByDataField(GridID, "BtnDelete");//삭제
    }

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
    objGridProps.fixedColumnCount = 3; // 고정 칼럼 개수
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
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        
        {
            dataField: "BtnDetail",
            headerText: "조회",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "조회",
                onClick: function (event) {
                    fnUpdTransRateApplyDtl(event.item);
                    return false;
                }
            },
            viewstatus: false

        },
        {
            dataField: "BtnDelete",
            headerText: "삭제",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "삭제",
                onClick: function (event) {
                    fnUpdTransRateApplyDelConfirm(event.item);
                    return false;
                }
            },
            viewstatus: false
        },
        {
            dataField: "BtnDetailList",
            headerText: "수정내역",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    fnUpdTransRateApplyHist(event.item);
                    return false;
                }
            },
            viewstatus: false
        }, 
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
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
            dataField: "OrderItemCodeM",
            headerText: "상품",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OrderLocationCodesM",
            headerText: "사업장",
            editable: false,
            width: 300,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "FtlYN",
            headerText: "기본요율-독차",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "LtlYN",
            headerText: "기본요율-혼적",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "LayoverYN",
            headerText: "추가요율-경유지",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OilYN",
            headerText: "추가요율-유가연동",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "RegDate",
            headerText: "최초등록일",
            editable: false,
            width: 130,
            viewstatus: true
        },
        {
            dataField: "RegAdminName",
            headerText: "최초등록자",
            editable: false,
            width: 110,
            viewstatus: true,
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return value + "(" + item.RegAdminID + ")";
            }
        },
        {
            dataField: "UpdDate",
            headerText: "최종수정일",
            editable: false,
            width: 130,
            viewstatus: true
        },
        {
            dataField: "UpdAdminName",
            headerText: "최종수정자",
            editable: false,
            width: 110,
            viewstatus: true,
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (typeof value !== "undefined" && value !== "") {
                    return value + "(" + item.UpdAdminID + ")";
                }

                return value
            }
        },
        /*************/
        /* 숨김필드 */
        /*************/
        {
            dataField: "ApplySeqNo",
            headerText: "요율표 일련번호",
            width: 0,
            visible: false
        },
        {
            dataField: "CenterCode",
            headerText: "회원사코드",
            width: 0,
            visible: false
        },
        {
            dataField: "ClientCode",
            headerText: "고객사코드",
            width: 0,
            visible: false
        },
        {
            dataField: "ConsignorCode",
            headerText: "화주코드",
            width: 0,
            visible: false
        }
    ];

    return objColumnLayout;
}

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode");
        return false;
    }

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "TransRateApplyList",
        CenterCode: $("#CenterCode").val(),
        ClientName: $("#ClientName").val(),
        ConsignorName: $("#ConsignorName").val(),
        OrderItemCode: $("#OrderItemCode").val(),
        OrderLocationCode: $("#OrderLocationCode").val(),
        DelFlag: "N",
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

        if (objRes[0].result.ErrorCode !== 0) {
            // 페이징
            fnCreatePagingNavigator();
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

function fnUpdTransRateApplyDtl(objItem) {
    var strParam = "HidMode=Update";
    strParam += "&ApplySeqNo=" + objItem.ApplySeqNo;
    fnOpenRightSubLayer("요율표 적용관리 수정", "/TMS/TransRate/TransRateApplyIns?" + strParam, "1024px", "700px", "90%");
    return false;
}

function fnUpdTransRateApplyDelConfirm(objItem) {
    var objConfirmParam = {
        CenterCode: objItem.CenterCode,
        ApplySeqNo: objItem.ApplySeqNo
    };
    fnDefaultConfirm("해당 내용을 삭제하시겠습니까?", fnUpdTransRateApplyDel, objConfirmParam)
    return false;
}

function fnUpdTransRateApplyDel(objConfirmParam) {
    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
    var strCallBackFunc = "fnTransRateApplyDelSuccResult";

    var objParam = {
        CallType: "TransRateApplyDel",
        CenterCode: objConfirmParam.CenterCode,
        ApplySeqNo: objConfirmParam.ApplySeqNo,
        UpdType: 99,
        RateRegKind: 0
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
    return false;
}

function fnTransRateApplyDelSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("삭제되었습니다.", "info", "fnCallGridData", GridID);
    }
    return false;
}

function fnUpdTransRateApplyHist(objItem) {
    var strParam = "ApplySeqNo=" + objItem.ApplySeqNo;
    strParam += "&CenterCode=" + objItem.CenterCode;
    strParam += "&CenterName=" + objItem.CenterName;
    strParam += "&ClientName=" + objItem.ClientName;
    strParam += "&ConsignorName=" + objItem.ConsignorName;
    strParam += "&OrderItemCodeM=" + objItem.OrderItemCodeM;
    fnOpenRightSubLayer("요율표 적용관리 수정내역", "/TMS/TransRate/TransRateApplyHistList?" + strParam, "1024px", "700px", "90%");
    return false;
}