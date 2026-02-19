window.name = "DomesticListGrid";
// 그리드
var GridID = "#DomesticListGrid";
var GridSort = [];
var GridFilter = null;

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

    $("#PopSupplyOrgAmt").on("keyup blur",
        function () {
            $(this).val(fnMoneyComma($(this).val()));
        });

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
            fnCloseDispatchCar();
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

    //카운트 표시
    fnGetDomesticCount();

    //위탁, 이관 회원사
    fnHeadCenterInit();
    fnContractCenterInit();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "OrderNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    AUIGrid.bind(GridID, "filtering", function (evt) {
        GridFilter = evt.filterCache;
    });

    AUIGrid.bind(GridID, "sorting", function (evt) {
        GridSort = evt.sortingFields;
    });

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

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (AUIGrid.isCheckedRowById(GridID, item.OrderNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.BondedFlag === "Y" && item.OrderStatusM !== "등록") {
            return "aui-grid-bonded-y-row-style";
        } else if (item.BondedFlag === "Y" && item.OrderStatusM === "등록") {
            return "aui-grid-bonded-y-no-accept-row-style";
        } else if (item.BondedFlag !== "Y" && item.OrderStatusM === "등록") {
            return "aui-grid-no-accept-row-style";
        }

        return "";
    }

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
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderRegTypeM",
            headerText: "오더등록구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
		{
            dataField: "OrderStatusM",
            headerText: "상태",
            width: 100,
            editable: false,
            renderer: {
                type: "IconRenderer",
                iconWidth: 20,
                iconHeight: 20,
                iconPosition: "aisle",
                iconTableRef: {
                    "등록": "/js/lib/AUIGrid/assets/yellow_circle.png",
                    "접수": "/js/lib/AUIGrid/assets/blue_circle.png",
                    "배차": "/js/lib/AUIGrid/assets/violet_circle.png",
                    "직송(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "집하(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "간선(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "배송(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "직송(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "집하(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "간선(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "배송(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "취소": "/js/lib/AUIGrid/assets/gray_circle.png"
                }
            },
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
            dataField: "CargopassInfo",
            headerText: "카고패스",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "TransTypeM",
            headerText: "이관구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "TransInfo",
            headerText: "이관정보",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: false
        }, {
            dataField: "ContractTypeM",
            headerText: "위탁구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ContractInfo",
            headerText: "위탁정보",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "ContractStatusMView",
            headerText: "위탁상태",
            editable: false,
            width: 100,
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
            dataField: "ConsignorName",
            headerText: "화주명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
		{
			dataField: "OrderClientName",
			headerText: "발주처명",
			editable: false,
			width: 150,
            filter: { showIcon: true },
            viewstatus: false
		},
		{
			dataField: "OrderClientChargeName",
			headerText: "(발)담당자",
			editable: false,
            width: 120,
            filter: { showIcon: true },
            visible: false,
            viewstatus: true
		},
		{
			dataField: "OrderClientChargeTelExtNo",
			headerText: "(발)내선",
			editable: false,
            width: 80,
            visible: false,
            viewstatus: true
		},
		{
			dataField: "OrderClientChargeTelNo",
			headerText: "(발)전화번호",
			editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
		},
		{
			dataField: "OrderClientChargeCell",
			headerText: "(발)휴대폰번호",
			editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
		},
        {
            dataField: "PayClientTypeM",
            headerText: "청구처구분",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
		{
            dataField: "PayClientName",
			headerText: "청구처명",
			editable: false,
			width: 150,
            filter: { showIcon: true },
			viewstatus: false
		},
		{
			dataField: "PayClientChargeName",
			headerText: "(청)담당자",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            visible: false,
			viewstatus: true
		},
		{
			dataField: "PayClientChargeTelExtNo",
			headerText: "(청)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
		},
		{
			dataField: "PayClientChargeTelNo",
			headerText: "(청)전화번호",
			editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
		},
		{
			dataField: "PayClientChargeCell",
			headerText: "(청)휴대폰번호",
            editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
		},
		{
			dataField: "PayClientChargeLocation",
			headerText: "청구사업장",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
		},
		{
			dataField: "PickupYMD",
			headerText: "상차요청일",
			editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupHM",
            headerText: "상차요청시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "PickupWay",
            headerText: "상차방법",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlace",
            headerText: "상차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
			dataField: "PickupPlacePost",
            headerText: "(상)우편번호",
            editable: false,
			width: 80,
			filter: { showIcon: true },
            viewstatus: true
        },
		{
			dataField: "PickupPlaceAddr",
			headerText: "(상)주소",
			editable: false,
            width: 150,
            style: "aui-grid-text-left",
			viewstatus: true
		},
		{
			dataField: "PickupPlaceAddrDtl",
			headerText: "(상)주소상세",
			editable: false,
            width: 150,
            style: "aui-grid-text-left",
			viewstatus: true
        },
        {
            dataField: "PickupPlaceFullAddr",
            headerText: "(상)적용주소",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeName",
            headerText: "(상)담당자명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargePosition",
            headerText: "(상)직급",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeTelExtNo",
            headerText: "(상)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeTelNo",
            headerText: "(상)전화번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupPlaceChargeCell",
            headerText: "(상)휴대폰번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupPlaceNote",
            headerText: "(상)특이사항",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "OrderGetTypeM",
            headerText: "하차구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetYMD",
            headerText: "하차요청일",
            editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetHM",
            headerText: "하차요청시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "GetWay",
            headerText: "하차방법",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlace",
            headerText: "하차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetPlacePost",
            headerText: "(하)우편번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlaceAddr",
            headerText: "(하)주소",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "GetPlaceAddrDtl",
            headerText: "(하)주소상세",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "GetPlaceFullAddr",
            headerText: "(하)적용주소",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlaceChargeName",
            headerText: "(하)담당자명",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {

            dataField: "GetPlaceChargePosition",
            headerText: "(하)직급",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "GetPlaceChargeTelExtNo",
            headerText: "(하)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "GetPlaceChargeTelNo",
            headerText: "(하)전화번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "GetPlaceChargeCell",
            headerText: "(하)휴대폰번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "GetPlaceNote",
            headerText: "(하)특이사항",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM",
            headerText: "요청톤급",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTypeCodeM",
            headerText: "요청차종",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GoodsItemCodeM",
            headerText: "품목",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Weight",
            headerText: "총중량",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "Volume",
            headerText: "총수량",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "CBM",
            headerText: "총부피",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "Length",
            headerText: "총길이",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "GoodsName",
            headerText: "화물명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GoodsNote",
            headerText: "화물비고",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "FTLFlag",
            headerText: "독차여부",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GoodsRunTypeM",
            headerText: "운행구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarFixedFlag",
            headerText: "고정여부",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "LayoverFlag",
            headerText: "경유여부",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SamePlaceCount",
            headerText: "동일지역수",
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
            dataField: "NonSamePlaceCount",
            headerText: "타지역수",
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
            dataField: "NoteInside",
            headerText: "비고",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "NoteClient",
            headerText: "고객전달사항",
            editable: false,
            width: 80,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "FileCnt",
            headerText: "첨부파일",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GoodsDispatchTypeM",
            headerText: "배차구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupDispatchCarNo",
            headerText: "(픽업)차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupCarTonCodeM",
            headerText: "(픽업)차량톤수",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupCarDivTypeM",
            headerText: "(픽업)차량구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupComName",
            headerText: "(픽업)차량업체명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupComCorpNo",
            headerText: "(픽업)차량사업자번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupDriverName",
            headerText: "(픽업)기사명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupDriverCell",
            headerText: "(픽업)기사휴대폰",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupPickupDT",
            headerText: "(픽업)상차시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupGetDT",
            headerText: "(픽업)하차시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DispatchCarNo1",
            headerText: "(직송)차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM1",
            headerText: "(직송)차량톤수",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarDivTypeM1",
            headerText: "(직송)차량구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComName1",
            headerText: "(직송)차량업체명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComCorpNo1",
            headerText: "(직송)차량사업자번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName1",
            headerText: "(직송)기사명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverCell1",
            headerText: "(직송)기사휴대폰",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupDT1",
            headerText: "(직송)상차시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetDT1",
            headerText: "(직송)하차시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DispatchCarNo2",
            headerText: "(집하)차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM2",
            headerText: "(집하)차량톤수",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarDivTypeM2",
            headerText: "(집하)차량구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComName2",
            headerText: "(집하)차량업체명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComCorpNo2",
            headerText: "(집하)차량사업자번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName2",
            headerText: "(집하)기사명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverCell2",
            headerText: "(집하)기사휴대폰",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupDT2",
            headerText: "(집하)상차시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetDT2",
            headerText: "(집하)하차시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DispatchCarNo3",
            headerText: "(간선)차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarDivTypeM3",
            headerText: "(간선)차량구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComName3",
            headerText: "(간선)차량업체명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComCorpNo3",
            headerText: "(간선)차량사업자번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName3",
            headerText: "(간선)기사명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverCell3",
            headerText: "(간선)기사휴대폰",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "DispatchCarNo4",
            headerText: "(배송)차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarDivTypeM4",
            headerText: "(배송)차량구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComName4",
            headerText: "(배송)차량업체명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComCorpNo4",
            headerText: "(배송)차량사업자번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName4",
            headerText: "(배송)기사명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverCell4",
            headerText: "(배송)기사휴대폰",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "TransRateInfo",
            headerText: "자동운임",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SaleClosingSeqNo",
            headerText: "매출마감전표",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
		{
			dataField: "SaleSupplyAmt",
			headerText: "매출",
			editable: false,
			width: 100,
			viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "PurchaseClosingSeqNo",
            headerText: "매입마감전표",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
		{
			dataField: "PurchaseSupplyAmt",
			headerText: "매입",
			editable: false,
			width: 100,
			viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
		},
		{
			dataField: "Revenue",
			headerText: "수익",
			width: 100,
			editable: false,
			visible: true,
			dataType: "numeric",
			style: "aui-grid-text-right",
			labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
				return AUIGrid.formatNumber(value, "#,##0");
			},
			expFunction: function (rowIndex, columnIndex, item, dataField) {
                return Number(item.SaleSupplyAmt) - Number(item.PurchaseSupplyAmt) - Number(item.QuickPaySupplyFee);
			},
			styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
				if (value <= 0) {
					return "aui-grid-font-color-blue";
				} else if (value >= 20) {
					return "aui-grid-font-color-red";
				}
				return null;
			},
			viewstatus: true
		},
		{
			dataField: "RevenuePer",
			headerText: "수익률",
			width: 100,
			editable: false,
			visible: true,
			dataType: "numeric",
			style: "aui-grid-text-right",
			labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
				return AUIGrid.formatNumber(value, "#,##0.0");
			},
			expFunction: function (rowIndex, columnIndex, item, dataField) {
                var Revenue = Number(item.SaleSupplyAmt) - Number(item.PurchaseSupplyAmt) - Number(item.QuickPaySupplyFee);
				var RevenuePer = item.SaleSupplyAmt == 0 ? 0 : Revenue / Number(item.SaleSupplyAmt) * 100;
				return RevenuePer;
			},
			styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
				if (value <= 0) {
					return "aui-grid-font-color-blue";
				} else if (value >= 20) {
					return "aui-grid-font-color-red";
				}
				return null;
			},
			viewstatus: true
		},
        {
            dataField: "AdvanceSupplyAmt3",
            headerText: "선급금",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
		},
		{
			dataField: "AdvanceSupplyAmt4",
            headerText: "예수금",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "QuickPaySupplyFee",
            headerText: "빠른입금수수료(공급가액)",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "QuickPayTaxFee",
            headerText: "빠른입금수수료(부가세)",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "AcceptDate",
            headerText: "접수일",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "AcceptAdminName",
            headerText: "접수자명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "UpdDate",
            headerText: "최종수정일",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "UpdAdminName",
            headerText: "최종수정자명",
            editable: false,
            width: 100,
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
            dataField: "CnlFlag",
            headerText: "CnlFlag",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "NetworkNo",
            headerText: "NetworkNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CargopassOrderNo",
            headerText: "CargopassOrderNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo1",
            headerText: "DispatchRefSeqNo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ContractType",
            headerText: "ContractType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ContractStatus",
            headerText: "ContractStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "GoodsDispatchType",
            headerText: "GoodsDispatchType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CargopassFlag",
            headerText: "CargopassFlag",
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
        fnCloseDispatchCar();
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
        return;
    }

    if ((strKey === "CargopassFlag" || strKey === "CargopassInfo") && objItem.CargopassFlag === "Y") {
        var strCenterCode = (typeof objItem.CenterCode === "undefined" || objItem.CenterCode === null) ? "" : objItem.CenterCode;
        var strCargopassOrderNo = (typeof objItem.CargopassOrderNo === "undefined" || objItem.CargopassOrderNo === null) ? "" : objItem.CargopassOrderNo;
        var strURL = "/TMS/Cargopass/CargopassIns?CenterCode=" + strCenterCode + "&CargopassOrderNo=" + strCargopassOrderNo;
        $("#IfrmCargopass").attr("src", strURL);
        $("#DivCargopassIns").show();
        return false;
    }

    if (strKey === "OrderStatusM" && event.item.OrderStatusM !== "등록" && event.item.OrderStatusM !== "접수") {
        fnOpenDispatchCar(event.item.CenterCode, event.item.OrderNo, event.item.GoodsSeqNo);
        return false;
    }

    fnCommonOpenOrder(objItem);
    return false;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var LocationCode = [];
    var OrderStatus = [];
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    if (!$("#ChkFilter").is(":checked")) {
        GridFilter = null;
    }

    if (!$("#ChkSort").is(":checked")) {
        GridSort = [];
    }

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    $.each($("#OrderStatus input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            OrderStatus.push($(el).val());
        }
    });

    var objParam = {
        CallType: "DomesticList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderStatuses: OrderStatus.join(","),
        TransCenterCode: $("#TransCenterCode").val(),
        ContractCenterCode: $("#ContractCenterCode").val(),
        SearchClientType: $("#SearchClientType").val(),
        SearchClientText: $("#SearchClientText").val(),
        SearchPlaceType: $("#SearchPlaceType").val(),
        SearchPlaceText: $("#SearchPlaceText").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        CarNo: $("#CarNo").val(),
        DriverName: $("#DriverName").val(),
        NoteClient: $("#NoteClient").val(),
        AcceptAdminName: $("#AcceptAdminName").val(),
        OrderNo: $("#OrderNo").val(),
        MyChargeFlag: $("#ChkMyCharge").is(":checked") ? "Y" : "N",
        MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N",
        CnlFlag: $("#ChkCnl").is(":checked") ? "Y" : "N",
        SortType: $("#SortType").val(),
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

        if (GridFilter != null) {
            fnSetGridFilter(GridID, GridFilter);
        }

        if (GridSort.length > 0) {
            AUIGrid.setSorting(GridID, GridSort);
        }
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
            positionField: "Weight",
            dataField: "Weight",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Volume",
            dataField: "Volume",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "CBM",
            dataField: "CBM",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Length",
            dataField: "Length",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SamePlaceCount",
            dataField: "SamePlaceCount",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "NonSamePlaceCount",
            dataField: "NonSamePlaceCount",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "FileCnt",
            dataField: "FileCnt",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleSupplyAmt",
            dataField: "SaleSupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "PurchaseSupplyAmt",
            dataField: "PurchaseSupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Revenue",
            dataField: "Revenue",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "RevenuePer",
            dataField: "RevenuePer",
            formatString: "#,##0.0",
            postfix: "%",
            style: "aui-grid-text-right",
            labelFunction: function (value, columnValues, footerValues) {
                var newValue = "";
                if (footerValues[8] !== 0) {
                    newValue = (footerValues[10] / footerValues[8]) * 100;
                }
                return newValue;
            }
        },
        {
            positionField: "AdvanceSupplyAmt3",
            dataField: "AdvanceSupplyAmt3",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceSupplyAmt4",
            dataField: "AdvanceSupplyAmt4",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "QuickPaySupplyFee",
            dataField: "QuickPaySupplyFee",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "QuickPayTaxFee",
            dataField: "QuickPayTaxFee",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];
    
    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

function fnOrderIns() {
    var objItem = {
        OrderItemCode: "OA007"
    }
    fnCommonOpenOrder(objItem);
    return false;
}

/*********************************************/
//오더 취소처리
//오더취소
var CnlOrderList = null;
var CnlOrderCnt = 0;
var CnlOrderProcCnt = 0;
var CnlOrderSuccessCnt = 0;
var CnlOrderFailCnt = 0;
var CnlOrderResultMsg = "";
function fnCnlOrder() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        $("#CenterCode").focus();
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.CnlFlag !== "Y" && $("#CenterCode").val() == item.item.CenterCode) {
            cnt++;
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("취소할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    $("#DivCancel").show();
}

function fnCnlOrderReg() {
    CnlOrderList = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    $.each(CheckedItems, function (index, item) {
        if (item.item.CnlFlag !== "Y" && $("#CenterCode").val() == item.item.CenterCode) {
            CnlOrderList.push(item.item.OrderNo);
        }
    });

    if (CnlOrderList.length <= 0) {
        fnDefaultAlert("취소할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (CnlOrderList.length > 500) {
        fnDefaultAlert("최대 500건까지 취소할 수 있습니다.", "warning");
        return false;
    }

    if (!$("#CnlReason").val()) {
        fnDefaultAlertFocus("취소 사유를 입력하세요.", "CnlReason", "warning");
        return false;
    }

    CnlOrderCnt = CnlOrderList.length;
    CnlOrderProcCnt = 0;
    CnlOrderSuccessCnt = 0;
    CnlOrderFailCnt = 0;
    CnlOrderResultMsg = "";
    fnCnlOrderRegProc();
}

function fnCnlOrderRegProc() {
    AUIGrid.showAjaxLoader(GridID);
    $("#divLoadingImage").show();
    if (CnlOrderProcCnt >= CnlOrderCnt) {
        AUIGrid.removeAjaxLoader(GridID);
        $("#divLoadingImage").hide();
        fnCnlOrderRegEnd();
        return;
    }

    var RowCnlOrder = CnlOrderList[CnlOrderProcCnt];
    if (RowCnlOrder) {
        var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
        var strCallBackFunc = "fnCnlOrderRegProcSuccResult";
        var strFailCallBackFunc = "fnCnlOrderRegProcFailResult";
        var objParam = {
            CallType: "DomesticOneCancel",
            CenterCode: $("#CenterCode").val(),
            OrderNo: RowCnlOrder,
            CnlReason: $("#CnlReason").val()
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnCnlOrderRegProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            CnlOrderSuccessCnt++;
        } else {
            var strMsg = objRes[0].ErrMsg;
            if (typeof objRes[0].ErrMsg === "undefined") {
                strMsg = objRes[0].result.ErrorMsg;
            }
            CnlOrderFailCnt++;
            CnlOrderResultMsg += "<br>" + CnlOrderList[CnlOrderProcCnt] + ":" + objRes[0].ErrMsg;
        }
    } else {
        CnlOrderFailCnt++;
        CnlOrderResultMsg += "<br>" + CnlOrderList[CnlOrderProcCnt];
    }
    CnlOrderProcCnt++;
    setTimeout(fnCnlOrderRegProc(), 200);
}

function fnCnlOrderRegProcFailResult() {
    CnlOrderFailCnt++;
    CnlOrderResultMsg += "<br>" + CnlOrderList[CnlOrderProcCnt];
    CnlOrderProcCnt++;
    setTimeout(fnCnlOrderRegProc(), 200);
    return false;
}

function fnCnlOrderRegEnd() {
    var msg = "총 " + CnlOrderCnt + "건의 오더 중 " + CnlOrderSuccessCnt + "건이 취소되었습니다.";
    if (CnlOrderResultMsg != "") {
        msg += CnlOrderResultMsg;
    }
    fnDefaultAlert(msg, "info");
    fnCallGridData(GridID);
    fnCloseCnlOrder();
}

//오더취소 닫기
function fnCloseCnlOrder() {
    $("#CnlReason").val("");
    $("#DivCancel").hide();
}
/*********************************************/

//오더대량복사
function fnCopyOrders() {
    var OrderNo = [];
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        $("#CenterCode").focus();
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 원본 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var noFullAddrCnt = 0;
    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() == item.item.CenterCode) {
            cnt++;
            OrderNo.push(item.item.OrderNo);

            var PickupPlaceFullAddr = typeof item.item.PickupPlaceFullAddr === "string" ? item.item.PickupPlaceFullAddr : "";
            var GetPlaceFullAddr = typeof item.item.GetPlaceFullAddr === "string" ? item.item.GetPlaceFullAddr : "";
            if (PickupPlaceFullAddr === "" || GetPlaceFullAddr === "") {
                noFullAddrCnt++;
            }
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("복사할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (noFullAddrCnt > 0) {
        fnDefaultAlert("적용주소가 없는 오더가 포함되어 복사가 불가능합니다.", "warning");
        return false;
    }

    window.open("/TMS/Common/OrderCopy?OrderType=1&CenterCode=" + $("#CenterCode").val() + "&OrderNos=" + OrderNo.join(","), "오더대량복사", "width=1140, height=880, scrollbars=Yes");
    return false;
}

//사업장변경
function fnChgOrderLocation() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        $("#CenterCode").focus();
        return false;
    }

    if (!$("#ChgOrderLocationCode").val()) {
        fnDefaultAlertFocus("변경할 사업장을 선택하세요.", "CenterCode", "warning");
        $("#ChgOrderLocationCode").focus();
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.CnlFlag !== "Y" && $("#CenterCode").val() == item.item.CenterCode && item.item.OrderLocationCodeM != "") {
            cnt++;
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("변경할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    strConfMsg = "오더 사업장을 변경 하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnChgOrderLocationProc", "DomesticLocationUpdate");
    return;
}

function fnChgOrderLocationProc(fnParam) {
    var OrderNo = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    $.each(CheckedItems, function (index, item) {
        if (item.item.CnlFlag !== "Y" && $("#CenterCode").val() == item.item.CenterCode && item.item.OrderLocationCodeM !== "") {
            OrderNo.push(item.item.OrderNo);
        }
    });

    if (OrderNo.length <= 0) {
        fnDefaultAlert("변경할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (OrderNo.length > 200) {
        fnDefaultAlert("최대 200건까지 변경할 수 있습니다.", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnChgOrderLocationSuccResult";
    var strFailCallBackFunc = "fnChgOrderLocationFailResult";
    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        OrderNos: OrderNo.join(","),
        OrderLocationCode: $("#ChgOrderLocationCode").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnChgOrderLocationSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("오더 사업장이 변경되었습니다.", "info");
            fnCallGridData(GridID);
            return false;
        } else {
            fnChgOrderLocationFailResult();
            return false;
        }
    } else {
        fnChgOrderLocationFailResult();
        return false;
    }
}

function fnChgOrderLocationFailResult() {
    fnDefaultAlert("오더 사업장 변경에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning");
    return false;
}

/**********************************************************/
// 오더 배차 목록 그리드
/**********************************************************/
var GridDispatchCarID = "#OrderDispatchCarListGrid";

$(document).ready(function () {
    if ($(GridDispatchCarID).length > 0) {
        // 그리드 초기화
        fnDispatchCarGridInit();
    }
});

function fnDispatchCarGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDispatchCarGridLayout(GridDispatchCarID, "DispatchSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDispatchCarID, "", "", "", "", "", "", "fnDispatchCarGridCellClick", "");

    // 사이즈 세팅
    AUIGrid.resize(GridDispatchCarID, $("#DivDispatchCar .gridWrap").width(), $("#DivDispatchCar .gridWrap").height());
}

//기본 레이아웃 세팅
function fnCreateDispatchCarGridLayout(strGID, strRowIdField) {

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
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultDispatchCarColumnLayout()");
    var objOriLayout = fnGetDefaultDispatchCarColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(strGID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(strGID, 'OrderDispatchCarListGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultDispatchCarColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "BtnKakaoTalk",
            headerText: "알림톡",
            editable: false,
            visible: false,
            width: 0,
            renderer: {
                type: "ButtonRenderer",
                labelText: "발송",
                onClick: function (event) {
                    fnKakaoTalkSend(event.item);
                    return;
                }
            }
        },{
            dataField: "BtnViewDispatchFile",
            headerText: "증빙",
            editable: false,
            width: 60,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    fnViewDispatchFile(event.item);
                    return;
                }
            }
        }, {
            dataField: "DispatchTypeM",
            headerText: "구분",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "QuickTypeM",
            headerText: "지급방법",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "DeliveryLocationCodeM",
            headerText: "배송사업장",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "CarDivTypeM",
            headerText: "차량구분",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "DriverCell",
            headerText: "기사휴대폰",
            editable: false,
            width: 100,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "ComName",
            headerText: "차량업체명",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "InsureTargetFlag",
            headerText: "산재보험대상",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "DispatchStatusM",
            headerText: "상태",
            editable: false,
            width: 100,
            viewstatus: true
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
            dataField: "PickupHM",
            headerText: "상차요청시간",
            editable: false,
            width: 80,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "PickupDT",
            headerText: "상차완료",
            editable: true,
            width: 150,
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
            dataField: "GetHM",
            headerText: "하차요청시간",
            editable: false,
            width: 80,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "ArrivalDT",
            headerText: "도착예정",
            editable: true,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GetDT",
            headerText: "하차완료",
            editable: true,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "BtnUpd",
            headerText: "시간등록",
            width: 60,
            renderer: {
                type: "ButtonRenderer",
                labelText: "등록",
                onClick: function (event) {
                    fnUpdDispatchCarStatus(event.item);
                    return;
                }
            }
        },
        {
            dataField: "UpdAdminID",
            headerText: "수정자",
            editable: false,
            width: 100,
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
            dataField: "DispatchAdminName",
            headerText: "배차자",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "DispatchDate",
            headerText: "배차일",
            editable: false,
            width: 150,
            viewstatus: true
        }
        /*숨김필드*/
        , {
            dataField: "DispatchSeqNo",
            headerText: "DispatchSeqNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "GoodsSeqNo",
            headerText: "GoodsSeqNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "OrderNo",
            headerText: "OrderNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "TransType",
            headerText: "TransType",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "RefSeqNo",
            headerText: "RefSeqNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "PickupPlaceAddr",
            headerText: "PickupPlaceAddr",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "PickupPlaceAddrDtl",
            headerText: "PickupPlaceAddrDtl",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnDispatchCarGridCellClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridDispatchCarID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    if (strKey === "PickupDT" || strKey === "ArrivalDT" || strKey === "GetDT") {
        var nDate = fnGetDateToday("-");
        var nHour = new Date().getHours();
        var nMinute = new Date().getMinutes();
        if (nHour < 10) {
            nHour = "0" + nHour;
        }
        if (nMinute < 10) {
            nMinute = "0" + nMinute;
        }

        if (strKey == "PickupDT") {
            var item = {
                PickupDT: nDate + " " + nHour + ":" + nMinute
            };
            AUIGrid.updateRow(GridDispatchCarID, item, event.rowIndex);
        } else if (strKey == "ArrivalDT") {
            var item = {
                ArrivalDT: nDate + " " + nHour + ":" + nMinute
            };
            AUIGrid.updateRow(GridDispatchCarID, item, event.rowIndex);
        } else if (strKey == "GetDT") {
            var item = {
                GetDT: nDate + " " + nHour + ":" + nMinute
            };
            AUIGrid.updateRow(GridDispatchCarID, item, event.rowIndex);
        }
    }
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDispatchCarGridData(strGID) {

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnDispatchCarGridSuccResult";

    var objParam = {
        CallType: "DomesticDispatchCarList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        GoodsSeqNo: $("#HidGoodsSeqNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDispatchCarGridSuccResult(objRes) {

    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridDispatchCarID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridDispatchCarID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridDispatchCarID);

        // 푸터
        fnSetDispatchCarGridFooter(GridDispatchCarID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDispatchCarGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "DispatchTypeM",
        dataField: "DispatchTypeM",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

// 상/하차 시간 등록
function fnUpdDispatchCarStatus(objItem) {
    var strConfMsg = "";
    strConfMsg = "상/하차 시간을 등록 하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnUpdDispatchCarStatusProc", objItem);
    return;
}

function fnUpdDispatchCarStatusProc(objItem) {
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnAjaxUpdDispatchCarStatus";

    var objParam = {
        CallType: "DomesticDispatchCarStatusUpdate",
        CenterCode: objItem.CenterCode,
        OrderNo: objItem.OrderNo,
        DispatchSeqNo: objItem.DispatchSeqNo,
        PickupDT: objItem.PickupDT,
        ArrivalDT: objItem.ArrivalDT,
        GetDT: objItem.GetDT
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxUpdDispatchCarStatus(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        var msg = "상/하차 시간 등록에 성공하였습니다.";
        fnDefaultAlert(msg, "info");
        fnCallDispatchCarGridData(GridDispatchCarID);
    }
}

//오더 배차 목록 오픈
function fnOpenDispatchCar(intCenterCode, intOrderNo, intGoodsSeqNo) {
    $("#HidCenterCode").val(intCenterCode);
    $("#HidOrderNo").val(intOrderNo);
    $("#HidGoodsSeqNo").val(intGoodsSeqNo);
    fnCallDispatchCarGridData(GridDispatchCarID);
    $("#DivDispatchCar").show();
    AUIGrid.resize(GridDispatchCarID, $("#DivDispatchCar .gridWrap").width(), $("#DivDispatchCar .gridWrap").height());
}

//배차 목록 새로고침
function fnResetDispatchCar() {
    fnCallDispatchCarGridData(GridDispatchCarID);
}

// 배차 목록 닫기
function fnCloseDispatchCar() {
    AUIGrid.setGridData(GridDispatchCarID, []);
    $("#DivDispatchCar").hide();
    return false;
}

// 상하차 파일 보기
function fnViewDispatchFile(item) {
    fnOpenRightSubLayer("증빙보기", "/TMS/Common/OrderReceiptList?ParamDispatchType=1&ParamCenterCode=" + item.CenterCode + "&ParamOrderNo=" + item.OrderNo + "&ParamDispatchSeqNo=" + item.DispatchSeqNo, "800px", "600px", "60%");
    return false;
}
/**********************************************************/

//자동운임 수정승인
function fnConfirmRequestAmt() {
    window.open("/TMS/Common/OrderAmtConfirmList?ListType=1", "자동운임 수정승인", "width=1400, height=850, scrollbars=Yes");
    return false;
}

//카운트 표시
function fnGetDomesticCount() {
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnGetDomesticCountSuccResult";

    var objParam = {
        CallType: "DomesticCount"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnGetDomesticCountSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnGetDomesticCountCallBack();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnGetDomesticCountCallBack();
            return false;
        }

        $("#BtnWebRegRequest").html("웹등록요청 " + objRes[0].data.WebRegRequestCnt);

        if (objRes[0].data.WebUpdRequestCnt > 0) {
            $("#BtnWebUpdRequest").html("웹수정요청 " + "<span class=\"on\">" + objRes[0].data.WebUpdRequestCnt + "</span>");
        } else {
            $("#BtnWebUpdRequest").html("웹수정요청 " + "<span>" + objRes[0].data.WebUpdRequestCnt + "</span>");
        }
        
        $("#BtnAmtRequest").text("자동운임 수정승인 " + objRes[0].data.AmtRequestCnt);

        $("#BtnOpenRegCargopass").text("카고패스등록 " + objRes[0].data.NetworkDispatchCnt);

        if (objRes[0].data.WebRegRequestCnt == "0") {
            $("#BtnWebRegRequest").removeClass("border_on");
        }

        if (objRes[0].data.WebUpdRequestCnt == "0") {
            $("#BtnWebUpdRequest").removeClass("border_on");
        }

        if (objRes[0].data.AmtRequestCnt == "0") {
            $("#BtnAmtRequest").removeClass("border_on");
        }

        if (objRes[0].data.NetworkDispatchCnt == "0") {
            $("#BtnOpenRegCargopass").removeClass("border_on");
        }

        fnGetDomesticCountCallBack();
        return false;
    } else {
        fnGetDomesticCountCallBack();
    }
}

function fnGetDomesticCountCallBack() {
    fnBorderSetting();
    setTimeout(fnGetDomesticCount, 1000 * 60);
}

var BorderTimer = null;
function fnBorderSetting() {

    if (BorderTimer) {
        clearTimeout(BorderTimer);
        BorderTimer = null;
    }
    var strBtnWebRegRequest = $("#BtnWebRegRequest").text().replace("웹등록요청", "").replace(/ /gi, "");
    var strBtnWebUpdRequest = $("#BtnWebUpdRequest").text().replace("웹수정요청", "").replace(/ /gi, "");
    var strBtnAmtRequest = $("#BtnAmtRequest").text().replace("자동운임", "").replace("수정승인", "").replace(/ /gi, "");
    var strBtnOpenRegCargopass = $("#BtnOpenRegCargopass").text().replace("카고패스등록", "").replace(/ /gi, "");

    if (!isNaN(Number(strBtnWebRegRequest))) {
        if (Number(strBtnWebRegRequest) > 0) {
            if ($("#BtnWebRegRequest").hasClass("border_on")) {
                $("#BtnWebRegRequest").removeClass("border_on");
            } else {
                $("#BtnWebRegRequest").addClass("border_on");
            }
        }
    }

    if (!isNaN(Number(strBtnWebUpdRequest))) {
        if (Number(strBtnWebUpdRequest) > 0) {
            if ($("#BtnWebUpdRequest").hasClass("border_on")) {
                $("#BtnWebUpdRequest").removeClass("border_on");
            } else {
                $("#BtnWebUpdRequest").addClass("border_on");
            }
        }
    }

    if (!isNaN(Number(strBtnAmtRequest))) {
        if (Number(strBtnAmtRequest) > 0) {
            if ($("#BtnAmtRequest").hasClass("border_on")) {
                $("#BtnAmtRequest").removeClass("border_on");
            } else {
                $("#BtnAmtRequest").addClass("border_on");
            }
        }
    }

    if (!isNaN(Number(strBtnOpenRegCargopass))) {
        if (Number(strBtnOpenRegCargopass) > 0) {
            if ($("#BtnOpenRegCargopass").hasClass("border_on")) {
                $("#BtnOpenRegCargopass").removeClass("border_on");
            } else {
                $("#BtnOpenRegCargopass").addClass("border_on");
            }
        }
    }
    BorderTimer = setTimeout(fnBorderSetting, 1000);
}

function fnHeadCenterInit() {
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnHeadCenterSuccResult";

    var objParam = {
        CallType: "HeadCenterList"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
}

function fnHeadCenterSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                return false;
            }
        }

        $("#TransCenterCode option").remove();
        $("#TransCenterCode").append("<option value=''>이관운송사</option>");
        $.each(objRes[0].List, function (index, item) {
            $("#TransCenterCode").append("<option value=\"" + item.CenterCode + "\">" + item.CenterName + "</option>");
        });
    }
}

//위탁 운송사
function fnContractCenterInit() {
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnContractCenterSuccResult";

    var objParam = {
        CallType: "ContractCenterList"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
}

function fnContractCenterSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                return false;
            }
        }

        $("#ContractCenterCode option").remove();
        $("#ContractCenterCode").append("<option value=''>위탁운송사</option>");
        $.each(objRes[0].List, function (index, item) {
            $("#ContractCenterCode").append("<option value=\"" + item.CenterCode + "\">" + item.CenterName + "</option>");
        });
    }
}

/*********************************************/
//오더 이관 처리
var TransList = null;
var TransCnt = 0;
var TransProcCnt = 0;
var TransSuccessCnt = 0;
var TransFailCnt = 0;
//오더 이관
function fnRegTrans() {
    TransList = [];
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.CnlFlag == "N" && item.item.GoodsDispatchType == 2 && item.item.TransType != 3 && item.item.TransType != 2 && item.item.ContractType != 3 && $("#CenterCode").val() == item.item.CenterCode) {
            cnt++;
            TransList.push(item.item);
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("이관할 수 있는 오더가 없습니다.<br/>(직송, 이관x, 취소x, 수탁x)", "warning");
        return false;
    }

    $("#DivTrans").show();
    fnTransHeadCenterInit();
}

function fnTransHeadCenterInit() {
    $("#PopTargetCenterCode option").remove();
    $("#PopTargetCenterCode").append("<option value=''>이관운송사</option>");

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnTransCenterSuccResult";

    var objParam = {
        CallType: "HeadCenterList",
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnTransCenterSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                return false;
            }
        }

        $.each(objRes[0].List, function (index, item) {
            $("#PopTargetCenterCode").append("<option value=\"" + item.CenterCode + "\">" + item.CenterName + "</option>");
        });
    }
}

function fnInsTrans() {

    TransCnt = TransList.length;
    TransProcCnt = 0;
    TransSuccessCnt = 0;
    TransFailCnt = 0;

    if (TransCnt === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if ($("#PopTargetCenterCode option").length === 1) {
        fnDefaultAlert("이관할 수 있는 운송사가 없습니다.", "warning");
        return false;
    }

    if (!$("#PopTargetCenterCode").val()) {
        fnDefaultAlertFocus("이관운송사를 선택하세요.", "PopTargetCenterCode", "warning");
        return false;
    }

    fnDefaultConfirm("총 " + TransCnt + "건의 오더를 " + $("#PopTargetCenterCode option:selected").text() + "에 이관처리 하시겠습니까?", "fnInsTransProc", "", "", "");
}

function fnInsTransProc() {

    AUIGrid.showAjaxLoader(GridID);
    if (TransProcCnt >= TransCnt) {
        AUIGrid.removeAjaxLoader(GridID);
        fnInsTransEnd();
        return false;
    }

    var RowTrans = TransList[TransProcCnt];

    if (RowTrans) {
        var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
        var strCallBackFunc = "fnInsTransSuccResult";
        var strFailCallBackFunc = "fnInsTransFailResult";
        var objParam = {
            CallType: "DomesticTransInsert",
            CenterCode: RowTrans.CenterCode,
            OrderNo: RowTrans.OrderNo,
            TargetCenterCode: $("#PopTargetCenterCode").val()
        };

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnInsTransSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            TransSuccessCnt++;
        } else {
            TransFailCnt++;
        }
    } else {
        TransFailCnt++;
    }
    TransProcCnt++;
    setTimeout(fnInsTransProc(), 500);
}

function fnInsTransFailResult() {
    TransProcCnt++;
    TransFailCnt++;
    setTimeout(fnInsTransProc(), 500);
    return false;
}

function fnInsTransEnd() {
    fnDefaultAlert("총 " + TransCnt + "건의 오더 중 " + TransSuccessCnt + "건이 이관되었습니다.", "info");
    fnCallGridData(GridID);
    fnCloseTrans();
    return false;
}

//오더 이관 닫기
function fnCloseTrans() {
    $("#PopTargetCenterCode option").remove();
    $("#PopTargetCenterCode").append("<option value=''>이관운송사</option>");
    $("#DivTrans").hide();
}
/*********************************************/

/*********************************************/
//오더 위탁 처리

var ContractList = null;
var ContractCnt = 0;
var ContractProcCnt = 0;
var ContractSuccessCnt = 0;
var ContractFailCnt = 0;
//오더 위탁
function fnRegContract() {
    ContractList = [];
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.GoodsDispatchType == 2
            && item.item.CnlFlag == "N"
            && item.item.DispatchRefSeqNo1 == 0
            && !(item.item.ContractType == 2 && item.item.ContractStatus == 2)
            && item.item.ContractType != 3
            && item.item.TransType != 3
            && $("#CenterCode").val() == item.item.CenterCode
            && item.item.CargopassFlag !== "Y") {
            cnt++;
            ContractList.push(item.item);
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("위탁할 수 있는 오더가 없습니다.<br/>(직송, 취소x, 미배차, 위탁x, 수탁x, 위탁상태x, 이관받음x, 카고패스)", "warning");
        return false;
    }

    $("#DivContract").show();
    fnPopContractCenterInit();
}

function fnPopContractCenterInit() {
    $("#PopContractCenterCode option").remove();
    $("#PopContractCenterCode").append("<option value=''>위탁운송사</option>");

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnPopContractCenterSuccResult";

    var objParam = {
        CallType: "ContractCenterList",
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnPopContractCenterSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                return false;
            }
        }

        $.each(objRes[0].List, function (index, item) {
            $("#PopContractCenterCode").append("<option value=\"" + item.CenterCode + "\">" + item.CenterName + "</option>");
        });
    }
}

function fnInsContract() {

    ContractCnt = ContractList.length;
    ContractProcCnt = 0;
    ContractSuccessCnt = 0;
    ContractFailCnt = 0;

    if (ContractCnt === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if ($("#PopContractCenterCode option").length === 1) {
        fnDefaultAlert("위탁할 수 있는 운송사가 없습니다.", "warning");
        return false;
    }

    if (!$("#PopContractCenterCode").val()) {
        fnDefaultAlertFocus("위탁운송사를 선택하세요.", "PopTargetCenterCode", "warning");
        return false;
    }
    fnDefaultConfirm("총 " + ContractCnt + "건의 오더를 " + $("#PopContractCenterCode option:selected").text() + "에 위탁처리 하시겠습니까?", "fnInsContractProc", "", "", "");
}

function fnInsContractProc() {

    AUIGrid.showAjaxLoader(GridID);
    if (ContractProcCnt >= ContractCnt) {
        AUIGrid.removeAjaxLoader(GridID);
        fnInsContractEnd();
        return false;
    }

    var RowContract = ContractList[ContractProcCnt];

    if (RowContract) {
        var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
        var strCallBackFunc = "fnInsContractSuccResult";
        var strFailCallBackFunc = "fnInsContractFailResult";
        var objParam = {
            CallType: "DomesticContractInsert",
            CenterCode: RowContract.CenterCode,
            OrderNo: RowContract.OrderNo,
            DispatchType: 1,
            ContractCenterCode: $("#PopContractCenterCode").val()
        };

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnInsContractSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            ContractSuccessCnt++;
        } else {
            ContractFailCnt++;
        }
    } else {
        ContractFailCnt++;
    }
    ContractProcCnt++;
    setTimeout(fnInsContractProc(), 500);
}

function fnInsContractFailResult() {
    ContractProcCnt++;
    ContractFailCnt++;
    setTimeout(fnInsContractProc(), 500);
    return false;
}

function fnInsContractEnd() {
    fnDefaultAlert("총 " + ContractCnt + "건의 오더 중 " + ContractSuccessCnt + "건이 위탁되었습니다.", "info");
    fnCallGridData(GridID);
    fnCloseContract();
    return false;
}

//오더 위탁 닫기
function fnCloseContract() {
    $("#PopContractCenterCode option").remove();
    $("#PopContractCenterCode").append("<option value=''>위탁운송사</option>");
    $("#DivContract").hide();
}
/*********************************************/

/*********************************************/
//내역서 출력
/*********************************************/
function fnPrintList() {
    var intValidType = 0;
    var ClientCode = 0;
    var OrderList = [];
    var OrderList1 = [];
    var OrderList2 = [];
    var arrCnt = 1;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);


    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사 선택 후 오더를 조회해주세요.", "CenterCode" ,"warning");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return;
    }

    if (CheckedItems.length > 300) {
        fnDefaultAlert("최대 300건까지 조회가능합니다.", "warning");
        return;
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
        }

        if (CheckedItems[0].item.PayClientCode != item.item.PayClientCode) {
            intValidType = 2;
        }
        if (OrderList.findIndex((e) => e === item.item.OrderNo) === -1) {
            if ((eval("OrderList" + arrCnt).join(",") + "," + item.item.OrderNo).length > 4000) {
                arrCnt++;
            }

            eval("OrderList").push(item.item.OrderNo);
            eval("OrderList" + arrCnt).push(item.item.OrderNo);
        }
    });
    
    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlert("하나의 청구처만 선택가능합니다.", "warning");
        return false;
    } else {
        ClientCode = CheckedItems[0].item.PayClientCode;
    }

    var postData = {
        CenterCode: $("#CenterCode").val(),
        ClientCode: ClientCode,
        OrderNos1: OrderList1,
        OrderNos2: OrderList2,
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
    };

    fnOpenWindowWithPost("/TMS/Common/OrderDomesticPrint", postData);
    return;
}

//내역서 POST 방식
function fnOpenWindowWithPost(url, objPostData) {
    var newForm = $("<form></form>");
    newForm.attr("method", "post");
    newForm.attr("action", url);
    newForm.attr("target", "PrintList");

    newForm.append($("<input/>", { type: "hidden", name: "OrderNos1", value: objPostData.OrderNos1 }));
    newForm.append($("<input/>", { type: "hidden", name: "OrderNos2", value: objPostData.OrderNos2 }));
    newForm.append($("<input/>", { type: "hidden", name: "CenterCode", value: objPostData.CenterCode }));
    newForm.append($("<input/>", { type: "hidden", name: "ClientCode", value: objPostData.ClientCode }));
    newForm.append($("<input/>", { type: "hidden", name: "DateFrom", value: objPostData.DateFrom }));
    newForm.append($("<input/>", { type: "hidden", name: "DateTo", value: objPostData.DateTo }));

    // 새 창에서 폼을 열기
    window.open("", "PrintList", "width=1050, height=900, scrollbars=Yes");
    newForm.appendTo("body");
    newForm.submit();
    newForm.remove();
    
}
/*********************************************/

/*********************************************/
//문자전송
/*********************************************/
function fnMsgSend(type) {
    var intValidType = 0;
    var OrderNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("회원사를 선택해주세요.");
        return;
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
            return false;
        }
        OrderNos.push(item.item.OrderNo);
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (CheckedItems.length > 30) {
        fnDefaultAlert("최대 30건까지 가능합니다.", "warning");
        return false;
    }

    fnOpenRightSubLayer("문자 발송", "/TMS/Common/MsgSend?OrderNos=" + OrderNos + "&ParamCenterCode=" + $("#CenterCode").val() + "&ParamOrderType=" + type, "1024px", "700px", "50%");
    return;
}
/*********************************************/

/*********************************************/
//알림톡
/*********************************************/
function fnKakaoTalkSend(item) {
    

    var objParam = {
        CallType    : "SendKakaoTalk",
        OrderNo: item.OrderNo,
        CenterCode: item.CenterCode,
        SendType: 1,
        RefSeqNo: item.RefSeqNo,
        PickupYMD: item.PickupYMD,
        PickupHM: item.PickupHM,
        PickupPlaceAddr: item.PickupPlaceAddr,
        PickupPlaceAddrDtl: item.PickupPlaceAddrDtl

    };

    fnDefaultConfirm("알림톡을 발송하시겠습니까?", "fnInsKakaoSend", objParam, "", "");
}

function fnInsKakaoSend(objParam) {
    var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
    var strCallBackFunc = "fnInsKakaoSendSuccResult";
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
}

function fnInsKakaoSendSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {
        fnDefaultAlert("알림톡이 발송되었습니다.", "success");
        return;
    }
}

var TotalCnt = 0;
//표준화물위탁증 SMS
function fnCertificateConfirm() {
    TotalCnt = 0;
    var intValidType = 0;
    var OrderNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("회원사를 선택해주세요.");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다..", "warning");
        return false;
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
        }
        if (item.item.DispatchRefSeqNo1 == "0" && item.item.DispatchRefSeqNo2 == "0" && item.item.DispatchRefSeqNo3 == "0") {
            intValidType = 2;
        }
        OrderNos.push(item.item.OrderNo);
    });
    
    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }
    if (intValidType === 2) {
        fnDefaultAlert("배차된 오더만 전송가능합니다.<br>배차가 안된 오더는 선택해제 해주세요.", "warning");
        return false;
    }

    if (CheckedItems.length > 50) {
        fnDefaultAlert("최대 50건까지 가능합니다.", "warning");
        return false;
    }

    TotalCnt = OrderNos.length;
    fnDefaultConfirm("표준화물위탁증을 발송하시겠습니까?", "fnCertificateIns", OrderNos, "", "");
}

function fnCertificateIns(OrderNos) {
    var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
    var strCallBackFunc = "fnCertificateInsResult";
    var objParam = {
        CallType: "CertificateIns",
        OrderNos: OrderNos.join(","),
        CenterCode: $("#CenterCode").val(),
        SendType: 2,
        SendUrl: "SMS/Certificate"
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
}

function fnCertificateInsResult(data) {
    if (data[0].RetCode != 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {
        fnDefaultAlert("총 " + TotalCnt + "건중 " + data[0].SuccCnt + "건이 전송되었습니다.");
        return;
    }
}

/*웹수정요청*/
function fnWebOrderChg() {
    window.open("/TMS/Common/WebOrderRequestChgList?ListType=1", "웹수정요청", "width=840, height=600, scrollbars=Yes");
    return false;
}


/*********************************************/
//오더 위탁 취소처리
var CnlOrderContractList = null;
var CnlOrderContractCnt = 0;
var CnlOrderContractProcCnt = 0;
var CnlOrderContractSuccessCnt = 0;
var CnlOrderContractFailCnt = 0;
var CnlOrderContractResultMsg = "";

function fnCnlOrderContract() {
    CnlOrderContractList = [];

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        $("#CenterCode").focus();
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.CnlFlag !== "Y" && $("#CenterCode").val() == item.item.CenterCode && item.item.GoodsDispatchType == "2" && item.item.ContractType == "2" && item.item.ContractStatus == "2") {
            cnt++;
            CnlOrderContractList.push(item.item.OrderNo);
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("위탁 취소할 수 있는 오더가 없습니다.", "warning");
        return false;
    }


    CnlOrderContractCnt = CnlOrderContractList.length;
    CnlOrderContractProcCnt = 0;
    CnlOrderContractSuccessCnt = 0;
    CnlOrderContractFailCnt = 0;
    CnlOrderContractResultMsg = "";

    fnDefaultConfirm("위탁 취소를 진행하시겠습니까?", "fnCnlOrderContractProc", "");
    return;
}

function fnCnlOrderContractProc() {
    AUIGrid.showAjaxLoader(GridID);
    if (CnlOrderContractProcCnt >= CnlOrderContractCnt) {
        AUIGrid.removeAjaxLoader(GridID);
        fnCnlOrderContractRegEnd();
        return;
    }

    var RowCnlOrderContract = CnlOrderContractList[CnlOrderContractProcCnt];
    if (RowCnlOrderContract) {
        var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
        var strCallBackFunc = "fnCnlOrderContractRegProcSuccResult";
        var strFailCallBackFunc = "fnCnlOrderContractRegProcFailResult";
        var objParam = {
            CallType: "OrderDispatchContractCancel",
            CenterCode: $("#CenterCode").val(),
            OrderNos: RowCnlOrderContract
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    }
}

function fnCnlOrderContractRegProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            CnlOrderContractSuccessCnt++;
        } else {
            CnlOrderContractFailCnt++;
            CnlOrderContractResultMsg += "<br>" + CnlOrderContractList[CnlOrderContractProcCnt] + ":" + objRes[0].ErrMsg;
        }
    } else {
        CnlOrderContractFailCnt++;
        CnlOrderContractResultMsg += "<br>" + CnlOrderContractList[CnlOrderContractProcCnt];
    }
    CnlOrderContractProcCnt++;
    setTimeout(fnCnlOrderContractProc(), 500);
}

function fnCnlOrderContractRegProcFailResult() {
    CnlOrderContractFailCnt++;
    CnlOrderContractResultMsg += "<br>" + CnlOrderContractList[CnlOrderContractProcCnt];
    CnlOrderContractProcCnt++;
    setTimeout(fnCnlOrderContractProc(), 500);
    return false;
}

function fnCnlOrderContractRegEnd() {
    var msg = "총 " + CnlOrderContractCnt + "건의 오더 중 " + CnlOrderContractSuccessCnt + "건이 위탁 취소되었습니다.";
    if (CnlOrderContractResultMsg != "") {
        msg += CnlOrderContractResultMsg;
    }
    fnDefaultAlert(msg, "info");
    fnCallGridData(GridID);
}

/*********************************************/

/**********************************************************/
//카고패스 연동
function fnCloseRegCargopass() {
    $("#IfrmCargopass").attr("src", "about:blank");
    $("#DivCargopassIns").hide();
    return false;
}

function fnOpenRegCargopass() {
    var objArrOrderNo = [];
    var strOrderNos = "";
    var intCnt = 0;
    var intNoCnt = 0;
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        $("#CenterCode").focus();
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    //이관대상, 위탁제외
    $.each(CheckedItems, function (index, item) {
        if (item.item.CnlFlag !== "Y"
            && $("#CenterCode").val() == item.item.CenterCode
            && item.item.OrderStatusM === "접수"
            && item.item.GoodsDispatchTypeM === "직송"
            && item.item.TransType != 3
            && !(item.item.ContractType == 2 && item.item.ContractStatus == 2)
            && (item.item.NetworkNo == "" || item.item.NetworkNo == "0")
            && item.item.CargopassFlag !== "Y") {

            if (objArrOrderNo.findIndex((e) => e === item.item.OrderNo) === -1) {
                objArrOrderNo.push(item.item.OrderNo);
                intCnt++;
            }
        } else {
            intNoCnt++;
        }
    });

    if (intCnt <= 0) {
        fnDefaultAlert("카고패스에 등록할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    strOrderNos = objArrOrderNo.join(",");

    var fnParam = {
        CenterCode: $("#CenterCode").val(),
        OrderNos: strOrderNos
    };

    if (intNoCnt > 0) {
        var strConfMsg = "선택한 오더 중 카고패스에 등록이 불가능한 오더가 포함되어있습니다.<br/>제외하고 진행 하시겠습니까?";
        fnDefaultConfirm(strConfMsg, "fnOpenRegCargopassConfirm", fnParam);
        return false;
    } else {
        fnOpenRegCargopassConfirm(fnParam);
        return false;
    }
}

function fnOpenRegCargopassConfirm(objParam) {
    var strURL = "/TMS/Cargopass/CargopassIns?DispatchType=1&CenterCode=" + objParam.CenterCode + "&OrderNos=" + objParam.OrderNos;
    $("#IfrmCargopass").attr("src", strURL);
    $("#DivCargopassIns").show();
    return false;
}

/**********************************************************/