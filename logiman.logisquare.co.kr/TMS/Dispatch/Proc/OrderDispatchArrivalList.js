// 그리드
var GridID = "#OrderDispatchArrivalListGrid";
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

    $(".search_line > input[type=text]").on("keydown", function (event) {
        if (event.keyCode === 13) {
            fnCallGridData(GridID);
            return;
        }
    });

    $("input#ComName").on("keydown", function (event) {
        if (event.keyCode === 13) {
            fnCallGridData(GridID);
            return;
        }
    });

    fnSetInitAutoComplete();
});


function fnSetInitAutoComplete() {
    //고객사명
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientChargeList",
                    ClientName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ClientName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#ClientCenterCode").val(ui.item.etc.CenterCode);
                    $("#ClientCode").val(ui.item.etc.ClientCode);
                    $("#ClientName").val(ui.item.etc.ClientName);
                    $("#ChargeSeqNo").val(ui.item.etc.ChargeSeqNo);
                    $("#ChargeName").val(ui.item.etc.ChargeName);
                    $(".Client_info").text(ui.item.etc.ClientInfo + " - " + ui.item.etc.ChargeInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                }
            }
        });
    }

    //고객사 담당자
    if ($("#ChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "ChargeName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientChargeList",
                    ChargeName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        return false;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ClientName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName,
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    $("#ClientCenterCode").val(ui.item.etc.CenterCode);
                    $("#ClientCode").val(ui.item.etc.ClientCode);
                    $("#ClientName").val(ui.item.etc.ClientName);
                    $("#ChargeSeqNo").val(ui.item.etc.ChargeSeqNo);
                    $("#ChargeName").val(ui.item.etc.ChargeName);
                    $(".Client_info").text(ui.item.etc.ClientInfo + " - " + ui.item.etc.ChargeInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                }
            }
        });
    }

    $("#BtnClientNameReset").on("click", function () {
        $("#ClientCode").val("");
        $("#ClientName").val("");
        $("#ChargeSeqNo").val("");
        $("#ChargeName").val("");
        $("p.Client_info").text("");
        $("#BtnClientNameReset").hide();
        $("#ClientName").attr("readonly", false);
        $("#ChargeName").attr("readonly", false);
        $("#ClientName").val("");
        $("#ClientName").focus();
        $("#ArrivalReportNo").val("");
    });
}

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "OrderNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "", "", "", "fnGridCellClick", "fnGridCellDblClick");

    AUIGrid.bind(GridID, "filtering", function (evt) {
        GridFilter = evt.filterCache;
    });

    //에디팅 이벤트
    AUIGrid.bind(GridID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "pasteBegin"], fnGridCellEditingHandler);

    // 사이즈 세팅
    var intHeight = $(document).height() - 230;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 230);
    });

    //fnCallGridData(GridID);

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
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = true; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true;
    objGridProps.nullsLastOnSorting = false; //빈값 상단 정렬

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'OrderDispatchArrivalListGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "BtnSms",
            headerText: "문자",
            editable: false,
            width: 60,
            renderer: {
                type: "IconRenderer",
                iconWidth: 16,
                iconHeight: 17,
                iconPosition: "center",
                iconTableRef: {
                    "default": "/images/icon/search_icon.png",
                }
            },
            viewstatus: false
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
            dataField: "ArrivalReportClientName",
            headerText: "(도)업체명",
            editable: false,
            width: 100,
            dataType: "string",
            filter: { showIcon: true },
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
            viewstatus: false,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
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
            editable: true,
            filter: { showIcon: true },
            width: 150,
            dataType: "string",
            viewstatus: false,
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true // 0~9 까지만 허용
            }
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
            dataField: "TransInfo",
            headerText: "이관정보",
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
            dataField: "PickupStandard",
            headerText: "상차일 기준",
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
            viewstatus: false
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
            viewstatus: true
        },
        {
            dataField: "PickupPlaceAddrDtl",
            headerText: "(상)주소상세",
            editable: false,
            width: 150,
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
            dataField: "PickupPlaceLocalCode",
            headerText: "(상)지역코드",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlaceLocalName",
            headerText: "(상)지역명",
            editable: false,
            width: 150,
            viewstatus: true,
            filter: { showIcon: true }
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
            dataField: "GetPlaceLocalCode",
            headerText: "(하)지역코드",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlaceLocalName",
            headerText: "(하)지역명",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "NoLayerFlag",
            headerText: "이단불가",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "NoTopFlag",
            headerText: "무탑배차",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "FTLFlag",
            headerText: "FTL",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM",
            headerText: "요청톤급",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTypeCodeM",
            headerText: "요청차종",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CustomFlag",
            headerText: "통관",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BondedFlag",
            headerText: "보세",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DocumentFlag",
            headerText: "서류",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ArrivalReportFlag",
            headerText: "도착보고",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "LicenseFlag",
            headerText: "면허진행",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "InTimeFlag",
            headerText: "시간엄수",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ControlFlag",
            headerText: "특별관제",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "QuickGetFlag",
            headerText: "하차긴급",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Nation",
            headerText: "목적국",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Hawb",
            headerText: "H/AWB",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Mawb",
            headerText: "M/AWB",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BookingNo",
            headerText: "Booking No.",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "InvoiceNo",
            headerText: "Invoice No.",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "StockNo",
            headerText: "입고 No.",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GMOrderType",
            headerText: "오더구분",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "GMTripID",
            headerText: "Trip ID",
            editable: false,
            width: 80,
            visible: false,
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
            style: "aui-grid-text-left",
            viewstatus: true,
            filter: { showIcon: true }
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
            width: 80,
            viewstatus: true,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    if (event.item.FileCnt > 0) {
                        fnOrderFileDetail(event.item.CenterCode, event.item.OrderNo);
                    }
                },
                visibleFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    // 행 아이템의 name 이 Anna 라면 버튼 표시 하지 않음
                    if (item.FileCnt === 0) {
                        return false;
                    }
                    return true;
                }
            }
        },
        {
            dataField: "TaxClientName",
            headerText: "(계)업체명",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "TaxClientCorpNo",
            headerText: "(계)사업자번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "TaxClientChargeName",
            headerText: "(계)담당자",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "TaxClientChargeTelNo",
            headerText: "(계)전화번호",
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
            dataField: "TaxClientChargeEmail",
            headerText: "(계)이메일",
            editable: false,
            width: 80,
            visible: false,
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
            dataField: "DispatchCarNo1",
            headerText: "직송차량",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.DispatchCarInfo1 == "") {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; border-right:1px solid #aaa; text-align:right;'>";
                    str += item.DispatchCarInfo1 + " <br> " + item.DispatchInfo1 + ")";
                    str += "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
                }
            }
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
            width: 80,
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
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "DispatchCarNo2",
            headerText: "집하차량",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.DispatchCarInfo2 == "") {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; border-right:1px solid #aaa; text-align:right;'>";
                    str += item.DispatchCarInfo2 + " <br> " + item.DispatchInfo2 + ")";
                    str += "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
                }
            }
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
            width: 80,
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
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "DispatchCarNo3",
            headerText: "간선차량",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.DispatchCarInfo3 == "") {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; border-right:1px solid #aaa; text-align:right;'>";
                    str += item.DispatchCarInfo3 + " <br> " + item.DispatchInfo3 + ")";
                    str += "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
                }
            }
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
            width: 80,
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
            width: 80,
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
            headerText: "배송차량",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.DispatchCarInfo4 == "") {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; border-right:1px solid #aaa; text-align:right;'>";
                    str += item.DispatchCarInfo4 + " <br/> " + item.DispatchInfo4 + ")";
                    str += "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
                }
            }
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
            width: 80,
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
            width: 80,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PurchaseSupplyAmt",
            headerText: "도착보고료",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (item.ArrivalReportClientCode !== 0) {
                    return AUIGrid.formatNumber(value, "#,##0");
                } else {
                    return 0;
                }
            }
        }/*,
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
        }*/,
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
            dataField: "OrderStatus",
            headerText: "OrderStatus",
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
            dataField: "DispatchRefSeqNo2",
            headerText: "DispatchRefSeqNo2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo3",
            headerText: "DispatchRefSeqNo3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo4",
            headerText: "DispatchRefSeqNo4",
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
            dataField: "GoodsDispatchType",
            headerText: "GoodsDispatchType",
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
            dataField: "DispatchCarInfo1",
            headerText: "DispatchCarInfo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo1",
            headerText: "DispatchInfo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo2",
            headerText: "DispatchCarInfo2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo2",
            headerText: "DispatchInfo2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo3",
            headerText: "DispatchCarInfo3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo3",
            headerText: "DispatchInfo3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo4",
            headerText: "DispatchCarInfo4",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo4",
            headerText: "DispatchInfo4",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientName",
            headerText: "ClientName",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientFaxNo",
            headerText: "ClientFaxNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchSeqNo1",
            headerText: "DispatchSeqNo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ArrivalReportClientCode",
            headerText: "ArrivalReportClientCode",
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

//셀 클릭
function fnGridCellClick(event) {
    var key = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);

    if (key == "BtnSms") {
        var OrderNo = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).OrderNo;
        var CenterCode = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).CenterCode;
        fnOpenRightSubLayer("문자 발송", "/TMS/Common/MsgSend?ParamOrderNos=" + OrderNo + "&ParamCenterCode=" + CenterCode + "&ParamOrderType=2", "1024px", "700px", "50%");
        return;
    }
}

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1 || strKey === "ArrivalReportNo") {
        return;
    }
    return false;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    var LocationCode = [];

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    if (!$("#ChkFilter").is(":checked")) {
        GridFilter = null;
    }

    var objParam = {
        CallType: "OrderDispatchList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: $("#OrderItemCodes").val(),
        SearchClientType: $("#SearchClientType").val(),
        SearchClientText: $("#SearchClientText").val(),
        CarNo: $("#CarNo").val(),
        DispatchAdminName: $("#DispatchAdminName").val(),
        ArrivalReportClientName: $("#ComName").val(),
        GetStandardType: $("#GetStandardType").val(),
        OrderByPageType: 1,
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

        if (GridFilter != null) {
            fnSetGridFilter(GridID, GridFilter);
        }

        // 그리드 정렬
        AUIGrid.setSorting(GridID, GridSort);

        // 푸터
        fnSetGridFooter(GridID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "InoutRequestStatusM",
            dataField: "InoutRequestStatusM",
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
//도착보고 등록/취소
var strCnlFlag = "";
function fnArrivalInsConfirm(flag) {
    strCnlFlag = flag;
    var strMsg = "";
    var GoodsSeqNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    var intValidType = 0;

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return;
    }

    if ($("#ClientCode").val() === "") {
        fnDefaultAlert("업체를 입력 선택해주세요.", "warning");
        return;
    }

    if ($("#ChargeSeqNo").val() === "") {
        fnDefaultAlert("담당자를 입력 선택해주세요.", "warning");
        return;
    }


    if (strCnlFlag != "Y") {
        strMsg = "등록";

        if ($("#ClientCode").val() === "") {
            fnDefaultAlertFocus("업체를 검색하여 선택해주세요.", "ClientName", "warning");
            return;
        }

        if ($("#ChargeSeqNo").val() === "") {
            fnDefaultAlertFocus("담당자를 검색하여 선택해주세요.", "ChargeName", "warning");
            return;
        }
    } else {
        strMsg = "취소";
    }
    

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
        }
        if (item.item.GoodsSeqNo === "0" || item.item.GoodsSeqNo === "") {
            intValidType = 2;
        }
        if ($("#ClientCenterCode").val() != item.item.CenterCode) {
            intValidType = 3;
        }
        GoodsSeqNos.push(item.item.GoodsSeqNo);
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlert("화물정보가 없는 오더가 포함되어있습니다.", "warning");
        return false;
    }

    if (intValidType === 3) {
        fnDefaultAlertFocus("검색된 업체의 회원사와 오더의 회원사가 서로 다릅니다.<br>업체 및 담당자를 다시 검색해주세요.", "ClientName" ,"warning");
        return false;
    }

    if (GoodsSeqNos.length <= 0) {
        fnDefaultAlert("변경할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (GoodsSeqNos.length > 200) {
        fnDefaultAlert("최대 200건까지 변경가능합니다.", "warning");
        return false;
    }

    fnDefaultConfirm("도착보고를 " + strMsg + "하시겠습니까?", "fnArrivalIns", GoodsSeqNos);
    return;
}

function fnArrivalIns(GoodsSeqNos) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnGridUpdSuccResult";

    var objParam = {
        CallType: "OrderGoodsArrivalIns",
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        ChargeSeqNo: $("#ChargeSeqNo").val(),
        ArrivalReportNo: $("#ArrivalReportNo").val(),
        CnlFlag: strCnlFlag,
        GoodsSeqNos: GoodsSeqNos.join(",")
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridUpdSuccResult(data) {
    strCnlFlag = "";
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "error");
        return;
    } else {
        fnDefaultAlert("처리되었습니다.", "success");
        fnCallGridData(GridID);
        return;
    }
}

function fnArrivalDocumentConfirm(flag) {
    strCnlFlag = flag;
    var strArray;
    var strMsg = "";
    var GoodsSeqNos = [];
    var OrderNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    var intValidType = 0;

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return;
    }

    if (strCnlFlag === "Y") {
        strMsg = "등록";
    } else {
        strMsg = "취소";
    }


    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
            return false;
        }
        if (item.item.GoodsSeqNo === "0" || item.item.GoodsSeqNo === "") {
            intValidType = 2;
            return false;
        }
        GoodsSeqNos.push(item.item.GoodsSeqNo);
        OrderNos.push(item.item.OrderNo);
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlert("화물정보가 없는 오더가 포함되어있습니다.", "warning");
        return false;
    }

    if (GoodsSeqNos.length <= 0) {
        fnDefaultAlert("변경할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (GoodsSeqNos.length > 200) {
        fnDefaultAlert("최대 200건까지 변경가능합니다.", "warning");
        return false;
    }
    strArray = [GoodsSeqNos, OrderNos]
    fnDefaultConfirm("서류를 " + strMsg + "하시겠습니까?", "fnArrivalDocument", strArray);
    return;
}

function fnArrivalDocument(Array) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnGridUpdSuccResult";

    var objParam = {
        CallType: "OrderGoodsArrivalDocumentUpd",
        CenterCode: $("#CenterCode").val(),
        CnlFlag: strCnlFlag,
        GoodsSeqNos: Array[0].join(","),
        OrderNos: Array[1].join(",")
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnOrderFileDetail(CenterCode, OrderNo) {
    if (!CenterCode || !OrderNo) {
        return false;
    }
    $("#HidFileCenterCode").val(CenterCode);
    $("#HidFileOrderNo").val(OrderNo);
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnCallFileSuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "OrderFileList",
        CenterCode: CenterCode,
        OrderNo: OrderNo
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strCallBackFailFunc, "", false);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallFileSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        $("#UlFileList li").remove();
        if (objRes[0].data.RecordCnt > 0) {
            $.each(objRes[0].data.list, function (index, item) {
                fnAddFile(item);
            });
        }
        $("#FileDownLoadLayer").show();

    } else {
        fnCallDetailFailResult();
    }
}

//파일 목록 추가
function fnAddFile(obj) {
    var addHtml = "";
    addHtml = "<li seq = '" + obj.EncFileSeqNo + "' fname='" + obj.EncFileNameNew + "' flag='" + obj.TempFlag + "' >";
    addHtml += "<a href=\"#\" onclick=\"fnDownloadFile(this); return false;\">" + obj.FileName + "</a> ";
    addHtml += "</li>\n";
    $("#UlFileList").append(addHtml);
}

//파일 다운로드
function fnDownloadFile(obj) {
    var seq = "";
    var foname = "";
    var fnname = "";
    var flag = "";

    seq = $(obj).parent("li").attr("seq");
    foname = $(obj).text();
    fnname = $(obj).parent("li").attr("fname");
    flag = $(obj).parent("li").attr("flag");

    if (seq == "" || seq == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (foname == "" || foname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (fnname == "" || fnname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (flag == "" || flag == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    var $form = null;

    if ($("form[name=dlFrm]").length == 0) {
        $form = $('<form name="dlFrm"></form>');
        $form.appendTo('body');
    } else {
        $form = $("form[name=dlFrm]");
    }

    $form.attr('action', '/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx');
    $form.attr('method', 'post');
    $form.attr('target', 'ifrmFiledown');
    
    var f1 = $('<input type="hidden" name="CallType" value="OrderFileDownload">');
    var f2 = $('<input type="hidden" name="FileSeqNo" value="' + seq + '">');
    var f3 = $('<input type="hidden" name="FileName" value="' + encodeURI(foname) + '">');
    var f4 = $('<input type="hidden" name="FileNameNew" value="' + fnname + '">');
    var f5 = $('<input type="hidden" name="TempFlag" value="' + flag + '">');
    var f6 = $('<input type="hidden" name="CenterCode" value="' + $("#HidFileCenterCode").val() + '">');
    var f7 = $('<input type="hidden" name="OrderNo" value="' + $("#HidFileOrderNo").val() + '">');

    $form.append(f1).append(f2).append(f3).append(f4).append(f5).append(f6).append(f7);
    $form.submit();
    $form.remove();
}

function fnCallDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error");
}

function fnCloseFileDown() {
    $("#UlFileList").html("");
    $("#FileDownLoadLayer").hide();
    $("#HidFileCenterCode").val("");
    $("#HidFileOrderNo").val("");
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
        if (event.dataField === "ArrivalReportNo") {
            inPurIndex = 0;
            var lo_RegType = "";
            var lo_CenterCode = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).CenterCode;
            var lo_GoodsSeqNo = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).GoodsSeqNo;
            var lo_ArrivalReportNo = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).ArrivalReportNo;
            
            if ($("#CenterCode").val() === "") {
                fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                return lo_OrgSupplyAmt;
            }
            if ($("#CenterCode").val() != lo_CenterCode) {
                fnDefaultAlertFocus("조회하신 회원사와 변경한 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
                return false;
            }

            item = {};
            item["ArrivalReportNo"] = lo_ArrivalReportNo;
            AUIGrid.updateRow(GridID, item, event.rowIndex);
            inPurIndex = event.rowIndex;
                        
            var objParam = {
                CallType: "ArrivalReportNoUpdate",
                CenterCode: lo_CenterCode,
                GoodsSeqNo: lo_GoodsSeqNo,
                ArrivalReportNo: lo_ArrivalReportNo
            };
            
            fnArrivalReportNoUpd(objParam);
        }
    }
}

//비용등록
function fnArrivalReportNoUpd(objParam) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx";
    var strCallBackFunc = "fnArrivalReportNoResult";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnArrivalReportNoResult(data) {
    if (data[0].RetCode != 0) {
        fnDefaultAlert(data[0].ErrMsg, "warning");
        return;
    }
}
