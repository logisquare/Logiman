// 그리드
var GridID = "#TransRateApplyHistListGrid";
var GridSort = [];

$(document).ready(function () {
    // 그리드 초기화
    fnGridInit();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "");

    fnSetGridEvent(GridID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 220;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 220);
    });

    //그리드 데이터
    fnCallGridData(GridID);

    //그리드에 포커스
    AUIGrid.setFocus(GridID);
}

//기본 레이아웃 세팅
function fnCreateGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = false; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 40; // 헤더 높이 지정
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
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "RegDate",
            headerText: "적용일시",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "RegAdminName",
            headerText: "적용담당자",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return value + "(" + item.RegAdminID + ")";
            }
        },
        {
            dataField: "OrderLocationCodesM",
            headerText: "사업장",
            editable: false,
            width: 200,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            headerText: "기본요율표- 독차",
            children: [
                {
                    dataField: "FtlSPTransSeqNoM",
                    headerText: "매출/입요율표",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "FtlSTransSeqNoM",
                    headerText: "매출요율표",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "FtlPTransSeqNoM",
                    headerText: "매입요율표",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "FtlFixedPurchaseRate",
                    headerText: "매입비율-고정차",
                    editable: false,
                    width: 150,
                    viewstatus: true
                },
                {
                    dataField: "FtlPurchaseRate",
                    headerText: "매입비율-용차",
                    editable: false,
                    width: 150,
                    viewstatus: true
                },
                {
                    dataField: "FtlRoundAmtKindM",
                    headerText: "매입비율-단위",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "FtlRoundTypeM",
                    headerText: "매입비율-단위조건",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                }
            ]
        },
        {
            headerText: "기본요율표-혼적",
            children: [
                {
                    dataField: "LtlSPTransSeqNoM",
                    headerText: "매출/입요율표",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "LtlSTransSeqNoM",
                    headerText: "매출요율표",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "LtlPTransSeqNoM",
                    headerText: "매입요율표",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "LtlFixedPurchaseRate",
                    headerText: "매입비율-고정차",
                    editable: false,
                    width: 150,
                    viewstatus: true
                },
                {
                    dataField: "LtlPurchaseRate",
                    headerText: "매입비율-용차",
                    editable: false,
                    width: 150,
                    viewstatus: true
                },
                {
                    dataField: "LtlRoundAmtKindM",
                    headerText: "매입비율-단위",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                }, {
                    dataField: "LtlRoundTypeM",
                    headerText: "매입비율-단위조건",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                }
            ]
        },
        {
            dataField: "LayoverTransSeqNoM",
            headerText: "추가요율-경유지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            headerText: "추가요율-유가연동",
                children: [
                {
                    dataField: "OilPeriodTypeM",
                    headerText: "기간",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "OilSearchArea",
                    headerText: "지역",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "OilPrice",
                    headerText: "적용유가",
                    editable: false,
                    dataType: "numeric",
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "OilTransSeqNoM",
                    headerText: "요율표",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "OilGetPlace1",
                    headerText: "적용지역1",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "OilGetPlace2",
                    headerText: "적용지역2",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "OilGetPlace3",
                    headerText: "적용지역3",
                    editable: false,
                    width: 150,
                    filter: { showIcon: true },
                    viewstatus: true
                },
                {
                    dataField: "OilSaleRoundAmtKindM",
                    headerText: "매출단위",
                    editable: false,
                    width: 150,
                    viewstatus: true
                },
                {
                    dataField: "OilSaleRoundTypeM",
                    headerText: "매출단위조건",
                    editable: false,
                    width: 150,
                    viewstatus: true
                },
                {
                    dataField: "OilFixedRoundAmtKindM",
                    headerText: "매입고정단위",
                    editable: false,
                    width: 150,
                    viewstatus: true
                },
                {
                    dataField: "OilFixedRoundTypeM",
                    headerText: "매입고정단위조건",
                    editable: false,
                    width: 150,
                    viewstatus: true
                },
                {
                    dataField: "OilPurchaseRoundAmtKindM",
                    headerText: "매입용차단위",
                    editable: false,
                    width: 150,
                    viewstatus: true
                },
                {
                    dataField: "OilPurchaseRoundTypeM",
                    headerText: "매입용차단위조건",
                    editable: false,
                    width: 150,
                    viewstatus: true
                }
            ]
        },
        /*************/
        /* 숨김필드 */
        /*************/
        {
            dataField: "DtlSeqNo",
            headerText: "DtlSeqNo",
            editable: false,
            width: 0
        },
        {
            dataField: "TransSeqNo",
            headerText: "TransSeqNo",
            editable: false,
            width: 0
        },
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            width: 0
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    if (!$("#CenterCode").val()) {
        fnDefaultAlert("회원사 정보가 없어 조회 할 수 없습니다.");
        return false;
    }

    if (!$("#ApplySeqNo").val()) {
        fnDefaultAlert("요율표 정보가 없어 조회 할 수 없습니다.");
        return false;
    }

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "TransRateApplyHistList",
        ApplySeqNo: $("#ApplySeqNo").val(),
        CenterCode: $("#CenterCode").val(),
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
        return false;
    }
}