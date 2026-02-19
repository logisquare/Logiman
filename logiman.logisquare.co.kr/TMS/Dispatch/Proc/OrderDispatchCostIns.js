// 그리드
var GridID = "#OrderDispatchCostGrid";

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

    // 그리드 초기화
    fnGridInit();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "OrderNo");
    
    fnSetGridEvent(GridID, "", "", "", "", "", "", "", "fnGridCellDblClick");

    //에디팅 이벤트
    AUIGrid.bind(GridID, ["cellEditBegin", "cellEditEnd"], fnGridCellEditingHandler);

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

    //푸터
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
    objGridProps.fixedColumnCount = 6; // 고정 칼럼 개수
    objGridProps.editableOnFixedCell = true; //고정 칼럼 수정 가능여부 설정
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
    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (AUIGrid.isCheckedRowById(GridID, item.OrderNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.FTLFlag === "Y" && item.OrderItemCode !==  "OA007") {
            return "aui-grid-closing-y-row-style";
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
        fnSaveColumnLayoutAuto(GridID, 'OrderDispatchCostGrid');
        return false;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "ItemCodeM",
            headerText: "비용항목",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PurchaseSupplyAmt",
            headerText: "매입",
            editable: true,
            width: 100,
            style: "aui-grid-text-right",
            headerStyle: "aui-grid-no-edit-row-style",
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true, // 0~9 까지만 허용
                allowPoint: false // onlyNumeric 인 경우 소수점(.) 도 허용
            },
            viewstatus: false
        },
        {
            dataField: "PurchaseTaxAmt",
            headerText: "부가세",
            editable: true,
            width: 100,
            style: "aui-grid-text-right",
            headerStyle: "aui-grid-no-edit-row-style",
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true, // 0~9 까지만 허용
                allowPoint: false // onlyNumeric 인 경우 소수점(.) 도 허용
            },
            viewstatus: false
        },
        {
            dataField: "BtnCallTransRate",
            headerText: "자동운임확인",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "운임확인",
                onClick: function (event) {
                    fnCallTransRate(event.item);
                    return false;
                },
                visibleFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    return item.FTLFlag == "Y" && item.OrderItemCode != "OA007";
                }
            },
            viewstatus: false
        },
        {
            dataField: "BtnUpdRequestAmt",
            headerText: "자동운임수정",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "수정요청",
                onClick: function (event) {
                    fnOpenTransRateAmtRequest(event.item);
                    return false;
                },
                visibleFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    return item.FTLFlag == "Y" && item.OrderItemCode != "OA007";
                }
            },
            viewstatus: false
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
            dataField: "CarDivTypeM",
            headerText: "차량구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComName",
            headerText: "차량업체명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DriverCell",
            headerText: "기사휴대폰",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
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
            dataType: "string",
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
            dataField: "FTLFlag",
            headerText: "FTL",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM",
            headerText: "요청톤수",
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
            dataField: "OrderClientName",
            headerText: "발주처명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
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
            dataField: "ConsignorName",
            headerText: "화주명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupYMD",
            headerText: "상차요청일",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false,
            dataType: "date",
            formatString: "yyyy-mm-dd",
        },
        {
            dataField: "PickupHM",
            headerText: "상차요청시간",
            editable: false,
            width: 80,
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
            dataField: "PickupPlace",
            headerText: "상차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupPlaceLocalName",
            headerText: "(상)지역명",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceNote",
            headerText: "(상)특이사항",
            editable: false,
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
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetHM",
            headerText: "하차요청시간",
            editable: false,
            width: 80,
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
            viewstatus: true
        },
        {
            dataField: "GetPlaceAddrDtl",
            headerText: "(하)주소상세",
            editable: false,
            width: 150,
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
            dataField: "GetPlaceChargeCell",
            headerText: "(하)담당자 연락처",
            editable: false,
            width: 100,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
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
            dataField: "Quantity",
            headerText: "화물정보",
            editable: false,
            width: 80,
            style: "aui-grid-text-left",
            viewstatus: true
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
            dataField: "PurchaseSeqNo",
            headerText: "PurchaseSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "GoodsSeqNo",
            headerText: "GoodsSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchSeqNo",
            headerText: "DispatchSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PayClientCode",
            headerText: "PayClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComTaxKind",
            headerText: "ComTaxKind",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ApplySeqNo",
            headerText: "ApplySeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "TransDtlSeqNo",
            headerText: "TransDtlSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "TransRateStatus",
            headerText: "TransRateStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CarDivType",
            headerText: "CarDivType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "TransRateChk",
            headerText: "TransRateChk",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClosingFlag",
            headerText: "ClosingFlag",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "BillStatus",
            headerText: "BillStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "SendStatus",
            headerText: "SendStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderLocationCode",
            headerText: "OrderLocationCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderItemCode",
            headerText: "OrderItemCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ConsignorCode",
            headerText: "ConsignorCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PickupPlaceFullAddr",
            headerText: "PickupPlaceFullAddr",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "GetPlaceFullAddr",
            headerText: "GetPlaceFullAddr",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CarTonCode",
            headerText: "CarTonCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CarTypeCode",
            headerText: "CarTypeCode",
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
//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1 || strKey === "PurchaseSupplyAmt" || strKey === "PurchaseTaxAmt") {
        return;
    }
    
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchCostInsHandler.ashx";
    var strCallBackFunc = "fnDetailSuccResult";

    var objParam = {
        CallType: "OrderDispatchPayList",
        CenterCode: objItem.CenterCode,
        OrderNo: objItem.OrderNo
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
    return false;
}

function fnDetailSuccResult(objRes) {
    var strDefaultInfo = "";
    var strCheckInfo = "";
    var strOrderNote = "";
    var strClientNote = "";

    if (objRes[0].data.RecordCnt > 0) {
        strDefaultInfo += "발주처 : " + objRes[0].data.list[0].OrderClientName + "</br>";
        strDefaultInfo += "청구처 : " + objRes[0].data.list[0].PayClientName + "</br>";
        strDefaultInfo += "화주 : " + objRes[0].data.list[0].ConsignorName + "</br>";
        strDefaultInfo += "상차일시 : " + fnGetStrDateFormat(objRes[0].data.list[0].PickupYMD, "-") + "</br>";
        strDefaultInfo += "하차일시 : " + fnGetStrDateFormat(objRes[0].data.list[0].GetYMD, "-");

        strCheckInfo += objRes[0].data.list[0].NoLayerFlag          === "Y" ? "이단불가, " : "";
        strCheckInfo += objRes[0].data.list[0].NoTopFlag            === "Y" ? "무탑배차, " : "";
        strCheckInfo += objRes[0].data.list[0].FTLFlag              === "Y" ? "FTL(독차), " : "";
        strCheckInfo += objRes[0].data.list[0].ArrivalReportFlag    === "Y" ? "도착보고, " : "";
        strCheckInfo += objRes[0].data.list[0].CustomFlag           === "Y" ? "통관, " : "";
        strCheckInfo += objRes[0].data.list[0].BondedFlag           === "Y" ? "보세, " : "";
        strCheckInfo += objRes[0].data.list[0].DocumentFlag         === "Y" ? "서류, " : "";
        strCheckInfo += objRes[0].data.list[0].LicenseFlag          === "Y" ? "면허진행, " : "";
        strCheckInfo += objRes[0].data.list[0].InTimeFlag           === "Y" ? "시간엄수, " : "";
        strCheckInfo += objRes[0].data.list[0].ControlFlag          === "Y" ? "특별관제, " : "";
        strCheckInfo += objRes[0].data.list[0].QuickGetFlag         === "Y" ? "하차긴급, " : "";
        strCheckInfo += objRes[0].data.list[0].OrderFPISFlag        === "Y" ? "화물 실적 신고, " : "";

        strOrderNote += objRes[0].data.list[0].NoteInside;
        strClientNote += objRes[0].data.list[0].NoteClient;

        $(".default_info").html(strDefaultInfo);
        $(".check_info").html(strCheckInfo.slice(0, -2));
        $(".order_note").html(strOrderNote);
        $(".client_note").html(strClientNote);
    }
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    var LocationCode = [];
    var ItemCode = [];

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchCostInsHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

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
        CallType: "OrderDispatchPayList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        CarNo: $("#CarNo").val(),
        ComName: $("#ComName").val(),
        PurchaseItemCode: $("#ItemCode").val(),
        GoodsDispatchType: $("#HidDispatchType").val(),
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
        AUIGrid.setGridData(GridID, []);
        // 페이징
        fnCreatePagingNavigator();
        AUIGrid.removeAjaxLoader(GridID);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        AUIGrid.setGridData(GridID, objRes[0].data.list);

        // 페이징
        fnCreatePagingNavigator();

        // 푸터
        fnSetGridFooter(GridID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {

    var GridFooterObject = [
        {
            positionField: "ItemCodeM",
            dataField: "ItemCodeM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
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
            positionField: "PurchaseTaxAmt",
            dataField: "PurchaseTaxAmt",
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
            positionField: "CBM",
            dataField: "CBM",
            operation: "SUM",
            formatString: "#,##0.##",
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
            positionField: "Length",
            dataField: "Length",
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
                if (footerValues[7] !== 0) {
                    newValue = (footerValues[8] / footerValues[7]) * 100;
                }
                return newValue;
            }
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

var inPurIndex;
function fnGridCellEditingHandler(event) {
    if (event.type === "cellEditBegin") {
        var objItem = event.item;

        if (!$("#CenterCode").val()) {
            fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
            return false;
        }

        if ($("#CenterCode").val() != objItem.CenterCode) {
            fnDefaultAlertFocus("조회하신 회원사와 변경한 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
            return false;
        }

        if (!$("#ItemCode").val()) {
            fnDefaultAlertFocus("비용항목 구분을 선택해주세요.", "ItemCode", "warning");
            return false;
        }

        if (objItem.TransRateChk === "Y") {
            fnDefaultAlert("자동운임으로 등록된 비용은 수정할 수 없습니다.<br/>\"자동운임 수정요청\" 기능을 이용하세요.", "error");
            return false;
        }

        if ($("#ItemCode").val() === "OP001" && objItem.FTLFlag === "Y") {
            //자동운임체크
            if (objItem.OrderItemCode !== "OA007") {
                fnDefaultAlert("자동운임 확인이 필요하여 자동 조회합니다. 변경된 비용정보를 확인해 주세요.", "warning", "fnCallTransRate", objItem);
                return false;
            }
        }
    }
    if (event.type == "cellEditEnd") {
        var objItem = event.item;

        if (event.dataField === "PurchaseSupplyAmt" || event.dataField === "PurchaseTaxAmt") {

            var strRegType = "";

            $("#HidCenterCode").val(objItem.CenterCode);
            $("#HidOrderNo").val(objItem.OrderNo);
            
            var intPurchaseTaxAmt = objItem.PurchaseTaxAmt;

            if (event.dataField === "PurchaseSupplyAmt") {
                intPurchaseTaxAmt = Math.floor(parseInt(objItem.PurchaseSupplyAmt) * 0.1);
            }

            objItem.PurchaseTaxAmt = intPurchaseTaxAmt;
            objItem.ItemCodeM = $("#ItemCode option:checked").text();
            AUIGrid.updateRowsById(GridID, objItem);
            
            if (typeof objItem.PurchaseSeqNo === "undefined" || objItem.PurchaseSeqNo === "" || objItem.PurchaseSeqNo === null || objItem.PurchaseSeqNo == 0 || objItem.PurchaseSeqNo == "0") {
                strRegType = "Insert";
            } else {
                strRegType = "Update";
            }

            var objParam = {
                CallType: "OrderDispatchPay" + strRegType,
                CenterCode: objItem.CenterCode,
                OrderNo: objItem.OrderNo,
                PurchaseSeqNo: objItem.PurchaseSeqNo,
                GoodsSeqNo: objItem.GoodsSeqNo,
                DispatchSeqNo: objItem.DispatchSeqNo,
                PayType: 2,
                TaxKind: objItem.TaxKind,
                ItemCode: $("#ItemCode").val(),
                SupplyAmt: objItem.PurchaseSupplyAmt,
                TaxAmt: intPurchaseTaxAmt,
                ApplySeqNo: objItem.ApplySeqNo,
                TransDtlSeqNo: objItem.TransDtlSeqNo,
                TransRateStatus: objItem.TransRateStatus
            };
            fnOrderDispatPayIns(objParam);
        }
    }
}
//비용등록
function fnOrderDispatPayIns(objParam) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchCostInsHandler.ashx";
    var strCallBackFunc = "fnGridPaySuccResult";
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
}

function fnGridPaySuccResult(data) {
    if (data[0].RetCode != 0) {
        fnDefaultAlert(data[0].ErrMsg, "warning");
        return;
    } else {
        if (data[0].PurchaseSeqNo > 0) {
            var objItem = AUIGrid.getItemByRowId(GridID, $("#HidOrderNo").val());
            objItem.PurchaseSeqNo = data[0].PurchaseSeqNo
            AUIGrid.updateRowsById(GridID, objItem);
        }
    }
}

/*********************************************/
/* 자동운임 */
/*********************************************/
//오더 자동운임 조회
function fnCallTransRateData() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchCostInsHandler.ashx";
    var strCallBackFunc = "fnCallTransRateDataSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "TransRateOrderList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
    return false;
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallTransRateDataSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallTransRateFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallTransRateFailResult();
            return false;
        }

        $("#TransRateChk").val("");
        $("#ApplySeqNo").val("");
        $("#SaleUnitAmt").val("");
        $("#FixedPurchaseUnitAmt").val("");
        $("#PurchaseUnitAmt").val("");
        $("#SpanTransRateInfo").html("");
        $("#BtnCallTransRate").show();
        $("#BtnUpdRequestAmt").hide();

        //자동운임 항목 초기화
        if (objRes[0].data.RecordCnt <= 0) {
            return false;
        }

        var rateCntType1 = 0;
        $.each(objRes[0].data.list, function (index, item) {
            if (item.RateInfoKind === 1) {
                rateCntType1++;
            }
        });

        $("#ApplySeqNo").val(objRes[0].data.ApplySeqNo);

        $.each(objRes[0].data.list, function (index, item) {
            if (item.RateInfoKind === 1) { //운임
                if (rateCntType1 > 1) {
                    if (item.SaleUnitAmt > 0) {
                        $("#SaleUnitAmt").val(item.SaleUnitAmt);
                        $("#SaleUnitAmt").val(fnMoneyComma($("#SaleUnitAmt").val()));
                    } else {
                        $("#FixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                        $("#FixedPurchaseUnitAmt").val(fnMoneyComma($("#FixedPurchaseUnitAmt").val()));
                        $("#PurchaseUnitAmt").val(item.PurchaseUnitAmt);
                        $("#PurchaseUnitAmt").val(fnMoneyComma($("#PurchaseUnitAmt").val()));
                    }
                    $("#SpanTransRateInfo").html($("#SpanTransRateInfo").html() + ($("#SpanTransRateInfo").html() !== "" ? " / " : "") + item.RateInfo);
                } else {
                    $("#SaleUnitAmt").val(item.SaleUnitAmt);
                    $("#SaleUnitAmt").val(fnMoneyComma($("#SaleUnitAmt").val()));
                    $("#FixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                    $("#FixedPurchaseUnitAmt").val(fnMoneyComma($("#FixedPurchaseUnitAmt").val()));
                    $("#PurchaseUnitAmt").val(item.PurchaseUnitAmt);
                    $("#PurchaseUnitAmt").val(fnMoneyComma($("#PurchaseUnitAmt").val()));
                    $("#SpanTransRateInfo").html(item.RateInfo);
                }
            }
        });

        $("#TransRateChk").val("Y");
        $("#BtnCallTransRate").hide();
        $("#BtnUpdRequestAmt").show();
    } else {
        fnCallDetailFailResult();
    }
}

//자동운임 조회
function fnCallTransRate(objItem) {

    if (typeof objItem.CenterCode === "undefined" || typeof objItem.OrderNo === "undefined") {
        return false;
    }

    if (objItem.FTLFlag !== "Y") {
        fnDefaultAlert("자동운임을 적용할 수 있는 오더가 아닙니다.", "warning");
        return false;
    }

    if ($("#ItemCode").val() !== "OP001") {
        fnDefaultAlert("자동운임은 운임항목에만 적용할 수 있습니다.", "warning");
        return false;
    }

    if (objItem.ApplySeqNo != "0") {
        fnDefaultAlert("자동운임으로 등록된 비용은 수정할 수 없습니다.<br/>\"자동운임 수정요청\" 기능을 이용하세요.", "warning");
        return false;
    }

    //운임
    if (objItem.ClosingFlag !== "N" || objItem.BillStatus === 2 || objItem.BillStatus === 3 || objItem.SendStatus !== 1) { //마감체크
        fnDefaultAlert("이미 마감된 운임이 있어 자동운임을 적용할 수 없습니다.", "warning");
        return false;
    }

    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidOrderNo").val(objItem.OrderNo);

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchCostInsHandler.ashx";
    var strCallBackFunc = "fnCallTransRateSuccResult";
    var strFailCallBackFunc = "fnCallTransRateFailResult";

    var objParam = {
        CallType: "TransRateOrderApplyList",
        CenterCode: objItem.CenterCode,
        OrderLocationCode: objItem.OrderLocationCode,
        OrderItemCode: objItem.OrderItemCode,
        PayClientCode: objItem.PayClientCode,
        ConsignorCode: objItem.ConsignorCode,
        PickupYMD: objItem.PickupYMD,
        PickupHM: objItem.PickupHM,
        PickupPlaceFullAddr: objItem.PickupPlaceFullAddr,
        GetYMD: objItem.GetYMD,
        GetHM: objItem.GetHM,
        GetPlaceFullAddr: objItem.GetPlaceFullAddr,
        CarTonCode: objItem.CarTonCode,
        CarTypeCode: objItem.CarTypeCode,
        Volume: objItem.Volume,
        Weight: objItem.Weight,
        CBM: objItem.CBM,
        Length: objItem.Length,
        FTLFlag: objItem.FTLFlag,
        CarFixedFlag: objItem.CarDivType == "3" ? "N" : "Y"
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnCallTransRateSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallTransRateFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallTransRateFailResult();
            return false;
        }

        var objItem = AUIGrid.getItemByRowId(GridID, $("#HidOrderNo").val());
        objItem.TransRateChk = "Y";

        //자동운임 항목 초기화
        if (objRes[0].data.RecordCnt <= 0) {
            fnDefaultAlert("적용 가능한 자동운임이 없습니다.", "info");
            AUIGrid.updateRowsById(GridID, objItem);
            return false;
        }

        //운임
        if (objItem.ClosingFlag !== "N" || objItem.BillStatus === 2 || objItem.BillStatus === 3 || objItem.SendStatus !== 1) { //마감체크
            fnDefaultAlert("이미 마감된 운임이 있어 자동운임을 적용할 수 없습니다.", "warning");
            return false;
        }

        //매출, 매입이 따로 적용되었는지 확인
        var rateCntType1 = 0;
        $.each(objRes[0].data.list, function (index, item) {
            if (item.RateInfoKind === 1) {
                rateCntType1++;
            }
        });

        var intPurchaseSupplyAmt = 0;
        var intPurchaseTaxAmt = 0;
        var intTransDtlSeqNo = 0;
        $.each(objRes[0].data.list, function (index, item) {
            if (item.RateInfoKind === 1) { //운임
                if (rateCntType1 > 1) {
                    if (item.SaleUnitAmt <= 0) {
                        if (objItem.CarDivType == "3") {
                            intPurchaseSupplyAmt = item.PurchaseUnitAmt;
                        } else {
                            intPurchaseSupplyAmt = item.FixedPurchaseUnitAmt;
                        }
                        intTransDtlSeqNo = item.TransDtlSeqNo
                    }
                } else {

                    if (objItem.CarDivType == "3") {
                        intPurchaseSupplyAmt = item.PurchaseUnitAmt;
                    } else {
                        intPurchaseSupplyAmt = item.FixedPurchaseUnitAmt;
                    }
                    intTransDtlSeqNo = item.TransDtlSeqNo
                }
            }
        });

        intPurchaseTaxAmt = Math.floor(parseInt(intPurchaseSupplyAmt) * 0.1);

        objItem.ItemCodeM = "운임";
        objItem.ItemCode = "OP001";
        objItem.ApplySeqNo = objRes[0].data.ApplySeqNo;
        objItem.TransRateStatus = 2;
        objItem.TransDtlSeqNo = intTransDtlSeqNo;
        objItem.PurchaseSupplyAmt = intPurchaseSupplyAmt;
        objItem.PurchaseTaxAmt = intPurchaseTaxAmt;
        AUIGrid.updateRowsById(GridID, objItem);

        var strRegType = "";
        if (typeof objItem.PurchaseSeqNo === "undefined" || objItem.PurchaseSeqNo === "" || objItem.PurchaseSeqNo === null || objItem.PurchaseSeqNo == 0 || objItem.PurchaseSeqNo == "0") {
            strRegType = "Insert";
        } else {
            strRegType = "Update";
        }

        var objParam = {
            CallType: "OrderDispatchPay" + strRegType,
            CenterCode: objItem.CenterCode,
            OrderNo: objItem.OrderNo,
            PurchaseSeqNo: objItem.PurchaseSeqNo,
            GoodsSeqNo: objItem.GoodsSeqNo,
            DispatchSeqNo: objItem.DispatchSeqNo,
            PayType: 2,
            TaxKind: objItem.ComTaxKind,
            ItemCode: objItem.ItemCode,
            SupplyAmt: objItem.PurchaseSupplyAmt,
            TaxAmt: objItem.PurchaseTaxAmt,
            ApplySeqNo: objItem.ApplySeqNo,
            TransDtlSeqNo: objItem.TransDtlSeqNo,
            TransRateStatus: objItem.TransRateStatus
        };
        fnOrderDispatPayIns(objParam);
        return false;
    }
}

function fnCallTransRateFailResult() {
    fnDefaultAlert("나중에 다시 시도해주세요.", "warning");
    return false;
}

function fnCallDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

/*********************************************/
/*********************************************/
//자동운임 수정요청
/*********************************************/

var GridTRAID = "#OrderTransRateAmtRequestGrid";
$(document).ready(function () {
    if ($(GridTRAID).length > 0) {
        // 그리드 초기화
        fnGridTRAInit();
    }
});

function fnGridTRAInit() {

    // 그리드 레이아웃 생성
    fnCreateGridTRALayout(GridTRAID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridTRAID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridTRAID, "", "", "", "", "", "", "", "");

    //에디팅 이벤트 바인딩
    AUIGrid.bind(GridTRAID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd"], fnGridTRACellEditingHandler);

    // 사이즈 세팅
    var intHeight = $("#DivTransRateAmtRequest > div").height() - 50;
    AUIGrid.resize(GridTRAID, $("#DivTransRateAmtRequest > div").width(), intHeight);
}

//기본 레이아웃 세팅
function fnCreateGridTRALayout(strGID, strRowIdField) {

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
    objGridProps.editableOnFixedCell = true; // 고정 칼럼, 행에 있는 셀도 수정 가능 여부(기본값:false)
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    var objResultLayout = fnGetTRADefaultColumnLayout();

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

function fnGetTRADefaultColumnLayout() {
    var objColumnLayout = [

        {
            dataField: "ReqStatusM",
            headerText: "요청상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        }, {
            dataField: "ReqSupplyAmt",
            headerText: "요청공급가액",
            editable: true,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "ReqTaxAmt",
            headerText: "요청부가세",
            editable: true,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "ReqReason",
            headerText: "요청사유",
            editable: true,
            width: 100,
            viewstatus: false
        },
        {
            dataField: "ReqStatusInfo",
            headerText: "요청정보",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BtnRegRequest",
            headerText: "요청",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                onClick: function (event) {
                    fnRegAmtRequest(event.item);
                    return false;
                }
            },
            viewstatus: true
        },
        {
            dataField: "PayTypeM",
            headerText: "비용구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ItemCodeM",
            headerText: "비용항목",
            editable: false,
            width: 100,
            filter: { showIcon: true }
        },
        {
            dataField: "UnitAmt",
            headerText: "자동운임금액",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (item.PayTypeM == "매입" && item.CarFixedFlag == "Y") {
                    return AUIGrid.formatNumber(item.FixedUnitAmt, "#,##0");
                } else {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }
        },
        {
            dataField: "SupplyAmt",
            headerText: "공급가액",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "TaxAmt",
            headerText: "부가세",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
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
            dataField: "OrderNo",
            headerText: "OrderNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PaySeqNo",
            headerText: "PaySeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ReqSeqNo",
            headerText: "ReqSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ReqStatus",
            headerText: "ReqStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PayType",
            headerText: "PayType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CarFixedFlag",
            headerText: "CarFixedFlag",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "FixedUnitAmt",
            headerText: "FixedUnitAmt",
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
//그리드 에디팅 이벤트 핸들러
function fnGridTRACellEditingHandler(event) {
    if (event.type === "cellEditBegin") {
        if (event.item.ReqStatus === 1) {
            fnDefaultAlert("현재 처리되지 않은 수정요청 정보가 있습니다. ", "warning");
            return false;
        }
    } else if (event.type === "cellEditEndBefore") {
        var retStr = event.value;

        retStr = retStr.toString().replace(/\t/gi, "");
        retStr = retStr.toString().replace(/\n/gi, "");

        if (event.dataField === "ReqSupplyAmt") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9.,]/gi, "");

            var tax = Math.floor((parseFloat(retStr) / 10));

            if (isNaN(tax)) {
                tax = 0;
            }

            AUIGrid.updateRow(event.pid, {
                ReqTaxAmt: tax
            }, event.rowIndex);
        }

        if (event.dataField === "ReqTaxAmt") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9.,]/gi, "");
        }

        return retStr;
    } else if (event.type === "cellEditEnd") {
        if (event.dataField === "ReqSupplyAmt" || event.dataField === "ReqTaxAmt") {
            AUIGrid.updateRow(event.pid, {
                ReqReason: ""
            }, event.rowIndex);
        }
    }
}
//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridTRAData(strGID) {

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchCostInsHandler.ashx";
    var strCallBackFunc = "fnGridTRASuccResult";

    var objParam = {
        CallType: "AmtRequestOrderList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridTRASuccResult(objRes) {
    if (objRes) {
        AUIGrid.setGridData(GridTRAID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridTRAID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridTRAID);
        return false;
    }
}


function fnRegAmtRequest(objItem) {
    if (objItem.ReqStatus === 1) { //취소
        if (objItem.ReqSeqNo === "0" || typeof objItem.ReqSeqNo === "undefined") {
            fnDefaultAlert("등록된 수정요청 정보가 없습니다.", "warning");
            return false;
        }

        fnDefaultConfirm("수정요청을 취소 하시겠습니까?", "fnCnlAmtRequestProc", objItem);
        return false;
    } else { //요청

        if (objItem.ReqReason === "" || typeof objItem.ReqReason === "undefined") {
            fnDefaultAlert("수정요청 사유를 입력해주세요.", "warning");
            AUIGrid.setSelectionByIndex(GridTRAID, AUIGrid.getRowIndexesByValue(GridTRAID, "SeqNo", objItem.SeqNo)[0], 3);
            return false;
        }

        fnDefaultConfirm("수정요청을 진행 하시겠습니까?", "fnRegAmtRequestProc", objItem);
        return false;
    }
}

//등록
function fnRegAmtRequestProc(objItem) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchCostInsHandler.ashx";
    var strCallBackFunc = "fnRegAmtRequestSuccResult";
    var strFailCallBackFunc = "fnRegAmtRequestFailResult";
    var objParam = {
        CallType: "AmtRequestInsert",
        CenterCode: objItem.CenterCode,
        OrderNo: objItem.OrderNo,
        ReqKind: objItem.PayType,
        PaySeqNo: objItem.PaySeqNo,
        ReqSupplyAmt: objItem.ReqSupplyAmt,
        ReqTaxAmt: objItem.ReqTaxAmt,
        ReqReason: objItem.ReqReason
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnRegAmtRequestSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("수정요청 등록이 완료되었습니다.", "info");
            fnCallGridTRAData(GridTRAID);
            return false;
        } else {
            fnRegAmtRequestFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegAmtRequestFailResult();
        return false;
    }
}

function fnRegAmtRequestFailResult(msg) {
    var alertMsg = "비용 수정요청 등록에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.";
    if (typeof msg != "undefined" && msg !== "") {
        alertMsg += " (" + msg + ")";
    }
    fnDefaultAlert(alertMsg, "warning");
    return false;
}

//취소
function fnCnlAmtRequestProc(objItem) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchCostInsHandler.ashx";
    var strCallBackFunc = "fnCnlAmtRequestSuccResult";
    var strFailCallBackFunc = "fnCnlAmtRequestFailResult";
    var objParam = {
        CallType: "AmtRequestCancel",
        CenterCode: objItem.CenterCode,
        OrderNo: objItem.OrderNo,
        SeqNo: objItem.ReqSeqNo
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnCnlAmtRequestSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("수정요청 취소가 완료되었습니다.", "info");
            fnCallGridTRAData(GridTRAID);
            return false;
        } else {
            fnRegAmtRequestFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegAmtRequestFailResult();
        return false;
    }
}

function fnCnlAmtRequestFailResult(msg) {
    var alertMsg = "비용 수정요청 취소에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.";
    if (typeof msg != "undefined" && msg !== "") {
        alertMsg += " (" + msg + ")";
    }
    fnDefaultAlert(alertMsg, "warning");
    return false;
}

function fnOpenTransRateAmtRequest(objItem) {
    if (objItem.ClosingFlag !== "N" || (objItem.BillStatus != "1" && objItem.BillStatus != "0") || objItem.SendStatus !== 1) {
        fnDefaultAlert("이미 마감되었거나, 계산서가 발행된 차량 비용정보가 등록되어 있어 변경이 불가능합니다. 매입 비용을 수정하시려면 매입 마감취소 or 계산서 연결해제 후 수정해 주세요.", "warning");
        return false;
    }

    if (objItem.FTLFlag !== "Y") {
        fnDefaultAlert("자동운임을 적용할 수 있는 오더가 아닙니다.", "warning");
        return false;
    }

    if ($("#ItemCode").val() !== "OP001") {
        fnDefaultAlert("자동운임은 운임항목에만 적용할 수 있습니다.", "warning");
        return false;
    }

    if (typeof objItem.ApplySeqNo === "undefined" || typeof objItem.CenterCode === "undefined" || typeof objItem.OrderNo === "undefined") {
        return false;
    }

    if (objItem.ApplySeqNo == "0") {
        fnDefaultAlert("자동운임 적용 후 수정요청이 가능합니다.", "warning");
        return false;
    }

    if (objItem.CenterCode == "0" || objItem.OrderNo == "0") {
        return false;
    }

    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidOrderNo").val(objItem.OrderNo);

    fnCallGridTRAData(GridTRAID);
    $("#DivTransRateAmtRequest").show();
    return false;
}

function fnCloseTransRateAmtRequest() {
    AUIGrid.setGridData(GridTRAID, []);
    //비용 목록 조회
    fnCallGridData(GridID);
    $("#DivTransRateAmtRequest").hide();
    return false;
}
/*********************************************/