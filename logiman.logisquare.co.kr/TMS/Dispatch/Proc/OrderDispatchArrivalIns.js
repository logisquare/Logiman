// 그리드
var GridID = "#OrderDispatchArrivalCostGrid";
var GridSort = [];

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

    $("#ClientName").on("keydown", function (event) {
        if (event.keyCode === 13) {
            fnCallGridData(GridID);
            return;
        }
    });

    fnSetInitData();
});

function fnSetInitData() {
    $("#SupplyAmt").on("keyup blur",
        function () {
            $(this).val(fnMoneyComma($(this).val()));
            fnCalcTax($(this).val(), "TaxAmt");
    });

    $("#TaxAmt").on("keyup blur",
        function () {
            $(this).val(fnMoneyComma($(this).val()));
    });
}

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "");
    
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "", "", "", "", "fnGridCellDblClick");

    //에디팅 이벤트
    AUIGrid.bind(GridID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "pasteBegin"], fnGridCellEditingHandler);

    // 사이즈 세팅
    var intHeight = $(document).height() - 250;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 250);
    });

    //fnCallGridData(GridID);

    fnSetGridFooter(GridID);

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
        fnSaveColumnLayoutAuto(GridID, 'OrderDispatchArrivalCostGrid');
        return;
    });
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
            dataField: "ItemCodeM",
            headerText: "비용항목",
            editable: false,
            width: 80,
            dataType: "string",
            filter: { showIcon: true },
            viewstatus: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return "도착보고료";
            }
        },
        {
            dataField: "PurchaseSupplyAmt",
            headerText: "매입",
            editable: true,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "PurchaseTaxAmt",
            headerText: "부가세",
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
            dataField: "ComName",
            headerText: "업체명",
            editable: false,
            width: 150,
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
            dataField: "ArrivalReportClientName",
            headerText: "(도)업체명",
            editable: false,
            width: 100,
            dataType: "string",
            viewstatus: false
        },
        {
            dataField: "ArrivalReportChargeName",
            headerText: "(도)담당자",
            editable: false,
            width: 100,
            dataType: "string",
            viewstatus: false
        },
        {
            dataField: "ArrivalReportChargeCell",
            headerText: "(도)담당자 연락처",
            editable: false,
            width: 100,
            dataType: "string",
            viewstatus: false
        },
        {
            dataField: "GoodsArrivalReportFlag",
            headerText: "(도)입고 여부",
            editable: false,
            width: 80,
            dataType: "string",
            viewstatus: false
        },
        {
            dataField: "ArrivalReportNo",
            headerText: "(도)입고 번호",
            editable: false,
            width: 150,
            dataType: "string",
            viewstatus: false
        },
        {
            dataField: "ArrivalDocumentFlag",
            headerText: "서류등록여부",
            editable: false,
            width: 80,
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
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupHM",
            headerText: "상차요청시간",
            editable: false,
            width: 120,
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
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetHM",
            headerText: "하차요청시간",
            editable: false,
            width: 120,
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
            viewstatus: true
        },
        {
            dataField: "NoteInside",
            headerText: "비고",
            editable: false,
            width: 80,
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
            dataField: "ClientTaxKind",
            headerText: "ClientTaxKind",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ItemCode",
            headerText: "비용항목코드",
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

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnDetailSuccResult";

    var objParam = {
        CallType: "OrderDispatchArrivalPayList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: event.item.OrderNo
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
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

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
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
        CallType: "OrderDispatchArrivalPayList",
        CenterCode: $("#CenterCode").val(),
        ListType : "3",
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        ArrivalReportFlag : "Y",
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: "OA003",
        CarNo: $("#CarNo").val(),
        ClientName: $("#ClientName").val(),
        PurchaseItemCode: $("#ItemCode").val(),
        PageNo: $("#PageNo").val(),
        PageSize: $("#PageSize").val(),
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
            AUIGrid.setGridData(GridID, []);
            // 페이징
            fnCreatePagingNavigator();
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

        // 페이징
        fnCreatePagingNavigator();

        // 그리드 정렬
        AUIGrid.setSorting(GridID, GridSort);
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
            positionField: "PurchaseTaxAmt",
            dataField: "PurchaseTaxAmt",
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
            positionField: "Volume",
            dataField: "Volume",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "CBM",
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
        },
        {
            positionField: "Length",
            dataField: "Weight",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

function fnGridCellEditingHandler(event) {
    if (event.type === "cellEditBegin") {
        var lo_CenterCode = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).CenterCode;
        if ($("#CenterCode").val() === "") {
            fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
            return false;
        }

        if ($("#CenterCode").val() != lo_CenterCode) {
            fnDefaultAlertFocus("조회하신 회원사와 변경한 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
            return false;
        }
    }
    if (event.type == "cellEditEnd") {
        if (event.dataField === "PurchaseSupplyAmt") {
            var lo_RegType = "";
            var lo_OrderNo = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).OrderNo;
            var lo_CenterCode = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).CenterCode;
            var lo_PurchaseSupplyAmt = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).PurchaseSupplyAmt;
            var lo_PurchaseSeqNo = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).PurchaseSeqNo;
            var lo_GoodsSeqNo = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).GoodsSeqNo;
            var lo_DispatchSeqNo = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).DispatchSeqNo;
            var lo_ClientTaxKind = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).ClientTaxKind;
            var lo_PayClientCode = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).PayClientCode;
            var lo_PayClientName = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).PayClientName;
            var lo_PurchaseTaxAmt = Math.floor(parseInt(lo_PurchaseSupplyAmt * 0.1));
            if ($("#CenterCode").val() === "") {
                fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                return lo_OrgSupplyAmt;
            }
            if ($("#CenterCode").val() != lo_CenterCode) {
                fnDefaultAlertFocus("조회하신 회원사와 변경한 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
                return false;
            }
            
            item = {};
            item["PurchaseTaxAmt"] = lo_PurchaseTaxAmt;
            AUIGrid.updateRow(GridID, item, event.rowIndex);
            if (typeof lo_PurchaseSeqNo === "undefined" || lo_PurchaseSeqNo === "" || lo_PurchaseSeqNo === null || lo_PurchaseSeqNo == 0) {
                lo_RegType = "Insert";
            } else {
                lo_RegType = "Update";
            }
            
            var objParam = {
                CallType            : "OrderDispatchPay" + lo_RegType,
                CenterCode          : lo_CenterCode,
                OrderNo             : lo_OrderNo,
                PurchaseSeqNo       : lo_PurchaseSeqNo,
                GoodsSeqNo          : lo_GoodsSeqNo,
                DispatchSeqNo       : lo_DispatchSeqNo,
                PayType             : 2,
                TaxKind             : lo_ClientTaxKind,
                ItemCode            : "OP071", //도착보고 코드
                ClientCode          : lo_PayClientCode,
                ClientName          : lo_PayClientName,
                SupplyAmt           : lo_PurchaseSupplyAmt,
                TaxAmt              : lo_PurchaseTaxAmt
            };
            fnOrderDispatPayIns(objParam);
        }
    }
}
//비용등록
function fnOrderDispatPayIns(objParam) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnGridPaySuccResult";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnGridPaySuccResult(data) {
    if (data[0].RetCode != 0) {
        fnDefaultAlert(data[0].ErrorMsg, "warning");
        return;
    }
}

//비용등록
function fnArrivalPayInsConfirm(type) {
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    var strMsg = "등록";
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return;
    }
    if (type === 1) {
        if ($("#SupplyAmt").val() === "") {
            fnDefaultAlertFocus("비용을 입력해주세요.", "SupplyAmt", "warning");
            return;
        }
        if ($("#TaxAmt").val() === "") {
            fnDefaultAlertFocus("부가세를 입력해주세요.", "TaxAmt", "warning");
            return;
        }
        if (CheckedItems.length === 0) {
            fnDefaultAlert("선택된 오더가 없습니다.", "warning");
            return;
        }
    }
    if (type === 2) {
        strMsg = "삭제";
    }
    fnDefaultConfirm("비용을 " + strMsg +"하시겠습니까?", "fnArrivalPayIns", type);
}
function fnArrivalPayIns(type) {
    var intValidType = 0;
    var OrderNos = [];
    var PurchaseSeqNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnGridInsertSuccResult";

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
            return false;
        }

        if (item.item.PurchaseSeqNo === 0 || item.item.PurchaseSeqNo === "0" || item.item.PurchaseSeqNo === null || item.item.PurchaseSeqNo === "") {
            if (item.item.ItemCode !== "OP071") {
                OrderNos.push(item.item.OrderNo);
            }
        } else if (item.item.PurchaseSeqNo !== 0 && item.item.ItemCode !== "OP071") {
                OrderNos.push(item.item.OrderNo);
        } else {
            if (type === 2) {
                OrderNos.push(item.item.OrderNo);
            }
            if (item.item.ItemCode === "OP071") {
                PurchaseSeqNos.push(item.item.PurchaseSeqNo);
            }
        }
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    var objParam = {
        CallType: "OrderArrivalPayIns",
        CenterCode: $("#CenterCode").val(),
        OrderNos: OrderNos.join(","),
        PurchaseSeqNos: PurchaseSeqNos.join(","),
        ItemCode: "OP071", //도착보고 비용 코드
        SupplyAmt: $("#SupplyAmt").val(),
        TaxAmt: $("#TaxAmt").val(),
        PurchaseType: type,
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridInsertSuccResult(data) {
    
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "error");
        return;
    } else {
        fnDefaultAlert("처리되었습니다.", "success");
        fnCallGridData(GridID);
        return;
    }
}

//배차취소
function fnOrderDispatchCnl() {
    var strOrderNos;
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnGridCnlSuccResult";
    
    var objParam = {
        CallType: "OrderDispatchCnl",
        CenterCode: $("#CenterCode").val(),
        OrderNos: strOrderNos
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridCnlSuccResult(data) {

}