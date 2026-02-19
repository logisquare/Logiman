window.name = "ContainerListGrid";
// 그리드
var GridID = "#ContainerListGrid";
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

    //카운트 표시
    fnGetContainerCount();
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

    //fnCallGridData(GridID);

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
            viewstatus: true
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
            width: 80,
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
            dataType: "string",
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
			dataField: "OrderClientName",
			headerText: "발주처명",
			editable: false,
			width: 150,
            filter: { showIcon: true },
			viewstatus: true
		},
		{
			dataField: "OrderClientChargeName",
			headerText: "(발)담당자",
			editable: false,
            width: 120,
            filter: { showIcon: true },
			viewstatus: true
		},
		{
			dataField: "OrderClientChargeTelExtNo",
			headerText: "(발)내선",
			editable: false,
			width: 80,
			visible: false,
			viewstatus: false
		},
		{
			dataField: "OrderClientChargeTelNo",
			headerText: "(발)전화번호",
			editable: false,
			width: 120,
            visible: false,
            viewstatus: false,
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
            viewstatus: false,
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
            viewstatus: false
        },
		{
            dataField: "PayClientName",
			headerText: "청구처명",
			editable: false,
			width: 150,
            filter: { showIcon: true },
			viewstatus: true
		},
		{
			dataField: "PayClientChargeName",
			headerText: "(청)담당자",
			editable: false,
            width: 120,
            filter: { showIcon: true },
			viewstatus: true
		},
		{
			dataField: "PayClientChargeTelExtNo",
			headerText: "(청)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: false
		},
		{
			dataField: "PayClientChargeTelNo",
			headerText: "(청)전화번호",
			editable: false,
            width: 120,
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
            viewstatus: false,
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
            viewstatus: false
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
			dataField: "PickupYMD",
			headerText: "DOOR요청일",
			editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
			viewstatus: true
        },
        {
            dataField: "PickupHM",
            headerText: "DOOR요청시간",
            editable: false,
            width: 120,
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
            dataField: "PickupPlace",
            headerText: "작업지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
		{
			dataField: "PickupPlaceLocalCode",
			headerText: "DOOR지역코드",
			editable: false,
            width: 80,
            filter: { showIcon: true },
			viewstatus: true
		},
		{
			dataField: "PickupPlaceLocalName",
			headerText: "DOOR지역명",
			editable: false,
			width: 150,
			viewstatus: true
		},
        {
			dataField: "PickupPlacePost",
            headerText: "(작)우편번호",
            editable: false,
			width: 80,
			filter: { showIcon: true },
            viewstatus: true
        },
		{
			dataField: "PickupPlaceAddr",
			headerText: "(작)주소",
			editable: false,
            width: 150,
            style: "aui-grid-text-left",
			viewstatus: true
		},
		{
			dataField: "PickupPlaceAddrDtl",
			headerText: "(작)주소상세",
			editable: false,
            width: 150,
            style: "aui-grid-text-left",
			viewstatus: true
        },
        {
            dataField: "PickupPlaceFullAddr",
            headerText: "(작)적용주소",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
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
				return Number(item.SaleSupplyAmt) - Number(item.PurchaseSupplyAmt);
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
				var Revenue = Number(item.SaleSupplyAmt) - Number(item.PurchaseSupplyAmt);
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
			dataField: "GoodsItemCodeM",
			headerText: "품목",
			editable: false,
            width: 120,
            filter: { showIcon: true },
			viewstatus: true
		},
		{
			dataField: "Volume",
			headerText: "총수량",
			editable: false,
			width: 80,
			viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
		},
		{
			dataField: "Weight",
			headerText: "총중량",
			editable: false,
            width: 80,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.##", "floor");
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
            dataField: "PickupCY",
            headerText: "픽업CY",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "GetCY",
            headerText: "하차/반납CY",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "BookingNo",
            headerText: "부킹 No",
            editable: false,
            width: 100,
            viewstatus: true
        },
		{
			dataField: "CntrNo",
            headerText: "CNTR No",
			editable: false,
            width: 100,
			viewstatus: true
        },
        {
            dataField: "SealNo",
            headerText: "SEAL No",
            editable: false,
            width: 100,
            viewstatus: true
        },
		{
            dataField: "DONo",
			headerText: "D/O No",
			editable: false,
            width: 100,
			viewstatus: true
        },
        {
            dataField: "BLNo",
            headerText: "BL No",
            editable: false,
            width: 100,
            viewstatus: true,
            styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                if (value !== "") {
                    return "my-cell-style-color";
                }
                return null;
            }
        },
        {
            dataField: "ShipmentPort",
            headerText: "선적항",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "ShippingCompany",
            headerText: "선사",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "ShippingShipName",
            headerText: "선명",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "DispatchAdminName",
            headerText: "배차자명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarDivTypeM",
            headerText: "차량구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComName",
            headerText: "차량업체명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM",
            headerText: "차량톤수",
            editable: false,
            width: 80,
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
            dataField: "PickupDT",
            headerText: "상차시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetDT",
            headerText: "하차시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
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
        return;
    }

    if (strKey === "BLNo") {
        window.open('/TMS/Unipass/UnipassDetailList?BLNo=' + objItem.BLNo + "&PickupYMD=" + objItem.PickupYMD.substring(0, 4) + "&HidMode=Container", '화물통관 진행정보', 'width=1200px,height=800px,scrollbars=yes');
        return;
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
    var ItemCode = [];
    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
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

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            ItemCode.push($(el).val());
        }
    });

    var objParam = {
        CallType: "ContainerList",
        CenterCode: $("#CenterCode").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        SearchClientType: $("#SearchClientType").val(),
        SearchClientText: $("#SearchClientText").val(),
        SearchChargeType: $("#SearchChargeType").val(),
        SearchChargeText: $("#SearchChargeText").val(),
        GoodsItemCode: $("#GoodsItemCode").val(),
        SearchType: $("#SearchType").val(),
        SearchText: $("#SearchText").val(),
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
            style: "aui-grid-my-column-right"
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
                if (footerValues[1] !== 0) {
                    newValue = (footerValues[3] / footerValues[1]) * 100;
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
            positionField: "Volume",
            dataField: "Volume",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Weight",
            dataField: "Weight",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}


function fnOrderIns() {
    var objItem = {
        OrderItemCode: "OA005"
    }
    fnCommonOpenOrder(objItem);
    return false;
}

function fnCostIns() {
    window.open("/TMS/Container/ContainerCostIns", "컨테이너비용등록", "width=1720, height=850px, scrollbars=Yes");
    return;
}

/*
function fnWebReqIns() {
    window.open("/TMS/Container/ContainerWebReqList", "웹등록요청", "width=1324, height=700px, scrollbars=Yes");
    return;
}
function fnWebReqUpd() {
    window.open("/TMS/Container/ContainerWebReqList", "웹수정요청", "width=1324, height=700px, scrollbars=Yes");
    return;
}
*/


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

    if (CnlOrderList.length > 200) {
        fnDefaultAlert("최대 200건까지 취소할 수 있습니다.", "warning");
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
    if (CnlOrderProcCnt >= CnlOrderCnt) {
        AUIGrid.removeAjaxLoader(GridID);
        fnCnlOrderRegEnd();
        return;
    }

    var RowCnlOrder = CnlOrderList[CnlOrderProcCnt];
    if (RowCnlOrder) {
        var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
        var strCallBackFunc = "fnCnlOrderRegProcSuccResult";
        var strFailCallBackFunc = "fnCnlOrderRegProcFailResult";
        var objParam = {
            CallType: "ContainerOneCancel",
            CenterCode: $("#CenterCode").val(),
            OrderNo: RowCnlOrder,
            CnlReason: $("#CnlReason").val()
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    }
}

function fnCnlOrderRegProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            CnlOrderSuccessCnt++;
        } else {
            CnlOrderFailCnt++;
            CnlOrderResultMsg += "<br>" + CnlOrderList[CnlOrderProcCnt] + ":" + objRes[0].ErrMsg;
        }
    } else {
        CnlOrderFailCnt++;
        CnlOrderResultMsg += "<br>" + CnlOrderList[CnlOrderProcCnt];
    }
    CnlOrderProcCnt++;
    setTimeout(fnCnlOrderRegProc(), 500);
}

function fnCnlOrderRegProcFailResult() {
    CnlOrderFailCnt++;
    CnlOrderResultMsg += "<br>" + CnlOrderList[CnlOrderProcCnt];
    CnlOrderProcCnt++;
    setTimeout(fnCnlOrderRegProc(), 500);
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
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
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

    window.open("/TMS/Common/OrderCopy?OrderType=3&CenterCode=" + $("#CenterCode").val() + "&OrderNos=" + OrderNo.join(","), "오더대량복사", "width=1140, height=850, scrollbars=Yes");
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
        if (item.item.CnlFlag !== "Y" && $("#CenterCode").val() == item.item.CenterCode) {
            cnt++;
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("변경할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    strConfMsg = "오더 사업장을 변경 하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnChgOrderLocationProc", "ContainerLocationUpdate");
    return;
}

function fnChgOrderLocationProc(fnParam) {
    var OrderNo = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    $.each(CheckedItems, function (index, item) {
        if (item.item.CnlFlag !== "Y" && $("#CenterCode").val() == item.item.CenterCode) {
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

    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
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

//서비스이슈현황
function fnSQIList() {
    window.open("/TMS/Common/SQIList?OrderType=3", "서비스이슈현황", "width=1350, height=700, scrollbars=Yes");
    return false;
}

//카운트 표시
function fnGetContainerCount() {
    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
    var strCallBackFunc = "fnGetContainerCountSuccResult";

    var objParam = {
        CallType: "ContainerCount"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnGetContainerCountSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnGetContainerCountCallBack();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnGetContainerCountCallBack();
            return false;
        }

        $("#BtnWebRegRequest").text("웹등록요청 " + objRes[0].data.WebRegRequestCnt);
        $("#BtnWebUpdRequest").text("웹수정요청 " + objRes[0].data.WebUpdRequestCnt);

        if (objRes[0].data.WebRegRequestCnt === "0") {
            $("#BtnWebRegRequest").removeClass("border_on");
        }

        if (objRes[0].data.WebUpdRequestCnt === "0") {
            $("#BtnWebUpdRequest").removeClass("border_on");
        }

        fnGetContainerCountCallBack();
        return false;
    } else {
        fnGetContainerCountCallBack();
    }
}

function fnGetContainerCountCallBack() {
    fnBorderSetting();
    setTimeout(fnGetContainerCount, 1000 * 60);
}

var BorderTimer = null;
function fnBorderSetting() {

    if (BorderTimer) {
        clearTimeout(BorderTimer);
        BorderTimer = null;
    }
    var strBtnWebRegRequest = $("#BtnWebRegRequest").text().replace("웹등록요청").replace(/ /gi, "");
    var strBtnWebUpdRequest = $("#BtnWebUpdRequest").text().replace("웹수정요청").replace(/ /gi, "");

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

    BorderTimer = setTimeout(fnBorderSetting, 1000);
}

/***********************************************/
//출력물
/***********************************************/
function fnTransPortPrint() {
    var intValidType = 0;
    var OrderNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("회원사 선택 후 오더를 조회해주세요..", "warning");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return;
    }

    if (CheckedItems.length > 100) {
        fnDefaultAlert("최대 100건까지 가능합니다.", "warning");
        return false;
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

    fnPopupWindowPost("/TMS/Common/OrderContainerPrintTransport?OrderNos=" + OrderNos.join(",") + "&CenterCode=" + $("#CenterCode").val(), "운송장", "760px", "900px");
    return;
}

function fnPeriodPrint() {
    var intValidType = 0;
    var OrderList = [];
    var OrderList1 = [];
    var OrderList2 = [];
    var arrCnt = 1;
    var ClientCode = 0;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사 선택 후 오더를 조회해주세요.", "CenterCode", "warning");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return;
    }

    if (CheckedItems.length > 300) {
        fnDefaultAlert("최대 300건까지 가능합니다.", "warning");
        return false;
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
        fnDefaultAlert("청구처가 다른 오더가 선택되어 있습니다.", "warning");
        return false;
    } else {
        ClientCode = CheckedItems[0].item.PayClientCode;
    }

    var postData = {
        CenterCode: $("#CenterCode").val(),
        ClientCode: ClientCode,
        OrderNos1: OrderList1,
        OrderNos2: OrderList2
    };

    fnOpenWindowWithPost("/TMS/Common/OrderContainerPrintPeriod", postData);
    return;
}

function fnClientPrint() {
    var intValidType = 0;
    var OrderList = [];
    var OrderList1 = [];
    var OrderList2 = [];
    var arrCnt = 1;
    var ClientCode = 0;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사 선택 후 오더를 조회해주세요.", "CenterCode", "warning");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return;
    }

    if (CheckedItems.length > 300) {
        fnDefaultAlert("최대 300건까지 가능합니다.", "warning");
        return false;
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
        fnDefaultAlert("청구처가 다른 오더가 선택되어 있습니다.", "warning");
        return false;
    } else {
        ClientCode = CheckedItems[0].item.PayClientCode;
    }

    var postData = {
        CenterCode: $("#CenterCode").val(),
        ClientCode: ClientCode,
        OrderNos1: OrderList1,
        OrderNos2: OrderList2
    };

    fnOpenWindowWithPost("/TMS/Common/OrderContainerPrintClient", postData);
    return;
}

//내역서 POST 방식
function fnOpenWindowWithPost(url, objPostData) {
    var newForm = $("<form></form>");
    newForm.attr("method", "post");
    newForm.attr("action", url);
    newForm.attr("target", "InoutList");

    newForm.append($("<input/>", { type: "hidden", name: "OrderNos1", value: objPostData.OrderNos1 }));
    newForm.append($("<input/>", { type: "hidden", name: "OrderNos2", value: objPostData.OrderNos2 }));
    newForm.append($("<input/>", { type: "hidden", name: "CenterCode", value: objPostData.CenterCode }));
    newForm.append($("<input/>", { type: "hidden", name: "ClientCode", value: objPostData.ClientCode }));

    // 새 창에서 폼을 열기
    window.open("", "InoutList", "width=1050, height=900, scrollbars=Yes");
    newForm.appendTo("body");
    newForm.submit();
    newForm.remove();
}


/*유니페스 팝업 페이지*/
function fnUnipassPopup() {
    window.open('/TMS/Unipass/UnipassDetailList', '화물통관 진행정보', 'width=1200px,height=800px,scrollbars=yes');
    return;
}