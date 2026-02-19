window.name = "InoutCostInsOrderListGrid";
// 그리드
var GridID = "#InoutCostInsOrderListGrid";
var GridSort = [];
var GridFilter = null;
var strPayType = "";

$(document).ready(function () {
    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // f2
        if (event.keyCode === 113) {
            $("#BtnInsPay").click();
            return false;
        }
    });

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

    //업무담당
    if ($("#CsAdminName").length > 0) {
        fnSetAutocomplete({
            formId: "CsAdminName",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientCsList",
                    CenterCode: $("#CenterCode").val(),
                    CsAdminType: 1,
                    CsAdminName: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "CsAdminName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.CsAdminName + " (" + item.CsAdminID + ")",
                getValue: (item) => item.CsAdminName,
                onSelect: (event, ui) => {
                    $("#CsAdminID").val(ui.item.etc.CsAdminID);
                    $("#CsAdminName").val(ui.item.etc.CsAdminName);
                },
                onBlur: () => {
                    if (!$("#CsAdminName").val()) {
                        $("#CsAdminID").val("");
                    }
                }
            }
        });
    }

    //자동운임
    $("#BtnCallTransRate").on("click", function () {
        if ($("#HidContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 사용하실 수 없습니다.");
            return false;
        }

        fnCallTransRate();
        return false;
    });

    //자동운임 수정요청
    $("#BtnUpdRequestAmt").on("click", function () {
        fnOpenTransRateAmtRequest();
        return false;
    });

    //비용
    //등록
    $("#BtnInsPay").on("click", function (e) {
        fnChkSaleLimit();
        return false;
    });

    //새로고침
    $("#BtnResetAllPay").on("click", function (e) {
        if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
            fnDefaultAlert("선택된 오더정보가 없습니다.", "warning");
            return false;
        }
        fnCallPayGridData(GridPayID);
        return false;
    });

    //추가
    $("#BtnAddPay").on("click", function (e) {
        if ($("#HidContractType").val() === "3" && $("#PayType").val() === "1") {
            fnDefaultAlert("수탁 오더는 매출을 등록 하실 수 없습니다.");
            return false;
        }

        var objItem = AUIGrid.getItemByRowId(GridID, $("#HidOrderNo").val());
        if (objItem.FTLFlag === "Y" && $("#PayType").val() === "1" && $("#ItemCode").val() === "OP001") {
            fnDefaultAlert("비용 입력 전, 자동운임 확인이 필요합니다.");
            return false;
        }

        fnPayAddRow();
        return false;
    });

    //수정
    $("#BtnUpdPay").on("click", function (e) {
        if ($("#HidContractType").val() === "3" && $("#PayType").val() === "1") {
            fnDefaultAlert("수탁 오더는 매출을 수정 하실 수 없습니다.");
            return false;
        }

        fnPayUpdRow();
        return false;
    });

    //삭제
    $("#BtnDelPay").on("click", function (e) {
        if ($("#HidContractType").val() === "3" && $("#PayType").val() === "1") {
            fnDefaultAlert("수탁 오더는 매출을 삭제 하실 수 없습니다.");
            return false;
        }

        fnPayDelRow();
        return false;
    });

    //다시입력
    $("#BtnResetPay").on("click", function (e) {
        fnResetPay();
        return false;
    });

    $("#PayType").on("click",
        function (e) {
            strPayType = $(this).val();
        });

    $("#PayType").on("change",
        function (e) {
            fnSetPay();
        });

    $("#TaxKind").on("change",
        function (e) {
            fnCalcTax($("#SupplyAmt").val(), "TaxAmt", "TaxKind");
        });

    $("#SupplyAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            if ($("#PayType").val() == "1" || $("#PayType").val() == "2") {
                fnCalcTax($(this).val(), "TaxAmt", "TaxKind");
            }

            if (event.type === "keyup" && event.keyCode === 13) {
                if ($("#BtnUpdPay").css("display") === "none") {
                    $("#BtnAddPay").click();
                } else {
                    $("#BtnUpdPay").click();
                }
                return;
            }
        });

    $("#TaxAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            if (event.type === "keyup" && event.keyCode === 13) {
                if ($("#BtnUpdPay").css("display") === "none") {
                    $("#BtnAddPay").click();
                } else {
                    $("#BtnUpdPay").click();
                }
                return;
            }
        });

    $("#Rate").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                if ($("#BtnUpdPay").css("display") === "none") {
                    $("#BtnAddPay").click();
                } else {
                    $("#BtnUpdPay").click();
                }
                return;
            }
        });

    //기본 설정 값
    fnSetPay();

    fnSetInitData();
});

function fnSetInitData() {

    //업체명 검색
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    ClientFlag: "Y",
                    ChargeFlag: "N",
                    CenterCode: $("#HidCenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
                        fnDefaultAlert("선택된 오더정보가 없습니다.", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#ClientCode").val(ui.item.etc.ClientCode);
                    $("#ClientInfo").val(ui.item.etc.ClientInfo);
                    $("#ClientName").val(ui.item.etc.ClientName);
                    $.each($(".TrPayCar input"), function (index, item) {
                        $(item).val("");
                    });
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                },
                onBlur: () => {
                    if (!$("#ClientName").val()) {
                        $("#ClientCode").val("");
                        $("#ClientInfo").val("");
                    }
                }
            }
        });
    }
}

//비용정보 세팅
function fnSetPay() {
    if ($("#PayType option:selected").text() === "매입") { //매입
        $(".TrPayClient").show();
        $("#Rate").hide();
    } else if ($("#PayType option:selected").text() === "선급" || $("#PayType option:selected").text() === "예수") { //선급 or 예수
        $(".TrPayClient").show();
        $("#Rate").hide();
    } else { //매출 외
        $(".TrPayClient").hide();
        $("#Rate").show();
    }

    $("#TaxKind").find("option").filter(function (index) {
        return $(this).text() === "과세";
    }).prop("selected", true);
    
    $("#BtnUpdPay").hide();
    $("#BtnDelPay").hide();

    $("#SeqNo").val("");
    $("#PaySeqNo").val("");
    $("#Rate").val("");

    if (!((strPayType == "1" && $("#PayType").val() == "2") || (strPayType == "2" && $("#PayType").val() == "1"))) {
        $("#ItemCode").find("option:nth-child(2)").prop("selected", true);
        $("#SupplyAmt").val("");
        $("#TaxAmt").val("");
    }

    $("#ClientCode").val("");
    $("#ClientInfo").val("");
    $("#ClientName").val("");
}

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "OrderNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "fnGridCellClick", "");

    AUIGrid.bind(GridID, "filtering", function (evt) {
        GridFilter = evt.filterCache;
    });

    AUIGrid.bind(GridID, "sorting", function (evt) {
        GridSort = evt.sortingFields;
    });

    // 사이즈 세팅
    var intHeight = 320;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);
        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);
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
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'InoutCostInsOrderListGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "BtnOpenOrder",
            headerText: "보기",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "오더보기",
                onClick: function (event) {
                    fnCommonOpenOrder(event.item);
                    return false;
                }
            }
        },{
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
            filter: { showIcon: true },
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
            viewstatus: true
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
            dataField: "GetPlaceNote",
            headerText: "(하)특이사항",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
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
            dataField: "NoteClient",
            headerText: "고객전달사항",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
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
            dataField: "FileCnt",
            headerText: "첨부파일",
            editable: false,
            width: 80,
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

//셀 클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return false;
    }

    fnSetOrderInfo(objItem);
    return false;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var LocationCode = [];
    var ItemCode = [];
    var OrderStatus = [];
    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
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

    $.each($("#OrderStatus input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            OrderStatus.push($(el).val());
        }
    });

    var objParam = {
        CallType: "InoutList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        OrderStatuses: OrderStatus.join(","),
        SearchClientType: $("#SearchClientType").val(),
        SearchClientText: $("#SearchClientText").val(),
        SearchPlaceType: $("#SearchPlaceType").val(),
        SearchPlaceText: $("#SearchPlaceText").val(),
        SearchChargeType: $("#SearchChargeType").val(),
        SearchChargeText: $("#SearchChargeText").val(),
        CsAdminID: $("#CsAdminID").val(),
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
        //$("#GridResult").html("");
        AUIGrid.setGridData(GridID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            // 페이징
            fnCreatePagingNavigator();
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        //$("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
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
                if (footerValues[5] !== 0) {
                    newValue = (footerValues[7] / footerValues[5]) * 100;
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

function fnSetOrderInfo(objItem) {
    $("#divLoadingImage").show();

    $("#HidOrderNo").val(objItem.OrderNo);
    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidGoodsSeqNo").val(objItem.GoodsSeqNo);
    $("#HidPayClientCode").val(objItem.PayClientCode);
    $("#HidPickupYMD").val(objItem.PickupYMD);
    $("#HidCnlFlag").val(objItem.CnlFlag);
    $("#HidCarDivType1").val(objItem.CarDivType1);
    $("#PayClientCode").val(objItem.PayClientCode);
    $("#PayClientName").val(objItem.PayClientName);
    $("#PayClientInfo").val(objItem.PayClientInfo);
    $("#SpanOrderNo").text(objItem.OrderNo);
    $("#SpanNation").text(objItem.Nation);
    $("#SpanHawb").text(objItem.Hawb);
    $("#SpanMawb").text(objItem.Mawb);
    $("#SpanInvoiceNo").text(objItem.InvoiceNo);
    $("#SpanBookingNo").text(objItem.BookingNo);
    $("#SpanStockNo").text(objItem.StockNo);
    $("#SpanVolume").text(fnMoneyComma(objItem.Volume));
    $("#SpanCBM").text(objItem.CBM);
    $("#SpanWeight").text(objItem.Weight);
    $("#SpanLength").text(fnMoneyComma(objItem.Length));
    $("#SpanQuantity").text(objItem.Quantity);
    $("#OrderClientNote").val("");

    if (objItem.CenterCode !== $("#HidCenterCode").val()) {
        $("#HidCenterCode").val(objItem.CenterCode);
        //항목코드 세팅
        fnSetCodeList();
    }

    fnCallPayGridData(GridPayID);
    fnCallClientNote(objItem.CenterCode, objItem.PayClientCode);

    $(".TrContract").hide();
    $("#SpanContract").text("");
    //위수탁 정보 조회
    fnCallOrderContract();

    //자동운임 세팅
    fnSetTransRateData(objItem.FTLFlag);
}

//비용항목 리셋
function fnSetCodeList() {
    if (!$("#HidCenterCode").val()) {
        fnDefaultAlert("회원사를 선택하세요.", "warning");
        return;
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
    var strCallBackFunc = "fnAjaxSetCodeList";

    var objParam = {
        CallType: "InoutCodeList",
        CenterCode: $("#HidCenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
}

function fnAjaxSetCodeList(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
    } else {
        $("#ItemCode option").remove();
        $("#ItemCode").append("<option value=''>비용항목</option>");
        $.each(objRes[0].PayItemCode, function (index, item) {
            $("#ItemCode").append("<option value=\"" + item.ItemFullCode + "\">" + item.ItemName + "</option>");
        });

        fnSetPay();
    }
}

/*********************************************/
// 비용 그리드
/*********************************************/
var GridPayID = "#InoutCostInsPayListGrid";

$(document).ready(function () {
    if ($(GridPayID).length > 0) {
        // 그리드 초기화
        fnPayGridInit();
    }
});

function fnPayGridInit() {
    // 그리드 레이아웃 생성
    fnCreatePayGridLayout(GridPayID, "PaySeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridPayID, "", "", "fnPayGridKeyDown", "", "", "", "fnPayGridCellClick", "");

    // 사이즈 세팅
    var intHeight = 170;
    AUIGrid.resize(GridPayID, $(document).width() - 20, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridPayID, $(".grid_list").width(), intHeight);
        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridPayID, $(".grid_list").width(), intHeight);
        }, 100);
    });
}

//기본 레이아웃 세팅
function fnCreatePayGridLayout(strGID, strRowIdField) {

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
    objGridProps.showStateColumn = true; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = true; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (item.ClosingFlag == "Y" || item.BillStatus !== 1 || item.SendStatus !== 1) { //마감, 계산서발행, 송금
            return "aui-grid-closing-y-row-style";
        }
        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultPayColumnLayout()");
    var objOriLayout = fnGetDefaultPayColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultPayColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "PayTypeM",
            headerText: "비용구분",
            editable: false,
            width: 80,
            filter: { showIcon: true }
        },
        {
            dataField: "TaxKindM",
            headerText: "과세구분",
            editable: false,
            width: 80,
            filter: { showIcon: true }
        },
        {
            dataField: "ItemCodeM",
            headerText: "비용항목",
            editable: false,
            width: 100,
            filter: { showIcon: true }
        },
        {
            dataField: "SupplyAmt",
            headerText: "공급가액",
            editable: false,
            width: 80,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.##");
            }
        },
        {
            dataField: "TaxAmt",
            headerText: "부가세",
            editable: false,
            width: 80,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.##");
            }
        },
        {
            dataField: "ClientInfo",
            headerText: "업체정보",
            editable: false,
            width: 250
        },
        {
            dataField: "DispatchInfo",
            headerText: "차량정보",
            editable: false,
            width: 250
        },
        {
            dataField: "RegAdminName",
            headerText: "등록자",
            editable: false,
            width: 80
        },
        {
            dataField: "RegDate",
            headerText: "등록일",
            editable: false,
            width: 150
        },
        {
            dataField: "UpdAdminName",
            headerText: "수정자",
            editable: false,
            width: 80
        },
        {
            dataField: "UpdDate",
            headerText: "수정일",
            editable: false,
            width: 150
        }
        /*숨김필드*/
        , {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "PaySeqNo",
            headerText: "PaySeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "OrderNo",
            headerText: "OrderNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "GoodsSeqNo",
            headerText: "GoodsSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "DispatchSeqNo",
            headerText: "DispatchSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "PayType",
            headerText: "PayType",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "TaxKind",
            headerText: "TaxKind",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ItemCode",
            headerText: "ItemCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClientName",
            headerText: "ClientName",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "OrgAmt",
            headerText: "OrgAmt",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClosingFlag",
            headerText: "ClosingFlag",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClosingSeqNo",
            headerText: "ClosingSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "BillStatus",
            headerText: "BillStatus",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "SendStatus",
            headerText: "SendStatus",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "RegAdminID",
            headerText: "RegAdminID",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "UpdAdminID",
            headerText: "UpdAdminID",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "RefSeqNo",
            headerText: "RefSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CarDivType",
            headerText: "CarDivType",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ComCode",
            headerText: "ComCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ComInfo",
            headerText: "ComInfo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CarSeqNo",
            headerText: "CarSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CarInfo",
            headerText: "CarInfo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "DriverSeqNo",
            headerText: "DriverSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "DriverInfo",
            headerText: "DriverInfo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ApplySeqNo",
            headerText: "ApplySeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "TransDtlSeqNo",
            headerText: "TransDtlSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "TransRateStatus",
            headerText: "TransRateStatus",
            editable: false,
            visible: false,
            width: 0
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
// 키 다운 핸들러 - 사용자 정의(페이지 기능별 수정 필요)
function fnPayGridKeyDown(event) {
    // ESC
    if (event.keyCode === 113) {
        $("#BtnInsPay").click();
        return false;
    }
    return true;
}

//셀 클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnPayGridCellClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridPayID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    if (objItem.ClosingFlag !== "N" || objItem.BillStatus !== 1 || objItem.SendStatus !== 1) {
        fnDefaultAlert("매출 마감된 오더입니다. 매출 비용을 수정하시려면 매출 마감취소 후 수정해 주세요.", "error");
        return;
    }

    if (typeof objItem.ApplySeqNo !== "undefined") {
        if (objItem.ApplySeqNo != "0") {
            fnDefaultAlert("자동운임으로 등록된 비용은 수정할 수 없습니다.<br/>\"자동운임 수정요청\" 기능을 이용하세요.", "error");
            return false;
        }
    }

    fnDisplayPay(objItem);
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallPayGridData(strGID) {

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        AUIGrid.setGridData(GridPayID, []);
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
    var strCallBackFunc = "fnPayGridSuccResult";

    var objParam = {
        CallType: "InoutPayList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnPayGridSuccResult(objRes) {

    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridPayID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridPayID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridPayID);

        // 푸터
        fnSetPayGridFooter(GridPayID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetPayGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "PayTypeM",
            dataField: "PayTypeM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        },
        {
            positionField: "SupplyAmt",
            dataField: "SupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TaxAmt",
            dataField: "TaxAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

// 비용 데이터 세팅
function fnDisplayPay(item) {
    $("#PayType").val(item.PayType);
    fnSetPay();

    var strClientInfo = typeof item.ClientInfo === "undefined" ? "" : item.ClientInfo;

    $("#SeqNo").val(item.SeqNo);
    $("#PaySeqNo").val(item.PaySeqNo);
    $("#TaxKind").val(item.TaxKind);
    $("#ItemCode").val(item.ItemCode);
    $("#SupplyAmt").val(fnMoneyComma(item.SupplyAmt));
    $("#TaxAmt").val(fnMoneyComma(item.TaxAmt));
    $("#ClientCode").val(item.ClientCode);
    $("#ClientInfo").val(strClientInfo);
    $("#ClientName").val(item.ClientName);
    $("#BtnUpdPay").show();
    $("#BtnDelPay").show();
}

//비용추가
function fnPayAddRow() {
    var blRatePayChk = true;
    var intRate = 0;
    var intRateSupplyAmt = 0;
    var intRateTaxAmt = 0;
    var strClientInfo = "";

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        fnDefaultAlert("선택된 오더정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#PayType").val()) {
        fnDefaultAlertFocus("비용 구분을 선택하세요.", "PayType", "warning");
        return false;
    }

    if (!$("#TaxKind").val()) {
        fnDefaultAlertFocus("과세 구분을 선택하세요.", "TaxKind", "warning");
        return false;
    }

    if (!$("#ItemCode").val()) {
        fnDefaultAlertFocus("비용항목을 선택하세요.", "ItemCode", "warning");
        return false;
    }

    if (!$("#SupplyAmt").val()) {
        fnDefaultAlertFocus("공급가액을 입력하세요.", "SupplyAmt", "warning");
        return false;
    }

    var cnt = 0;
    if ($("#ItemCode").val() === "OP001" && ($("#PayType").val() == "1" || $("#PayType").val() == "2")) {
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                        if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val()) {
                            cnt++;
                        }
                    }
                });
        }

        if (cnt > 0) {
            fnDefaultAlert("운임은 매출/입에 한건씩 입력이 가능합니다.", "warning");
            return;
        }
    }

    if ($("#PayType").val() === "2") { //매입
        if ($("#ClientCode").val() && $("#ClientCode").val() !== "0") {
            strClientInfo = $("#ClientInfo").val();
            strDispatchInfo = "";
        } else {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }
    } else if ($("#PayType").val() === "3" || $("#PayType").val() === "4") { //선급 or 예수
        if (!$("#PayClientCode").val() && !$("#ClientCode").val()) {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }

        if ($("#ClientCode").val()) {
            strClientInfo = $("#ClientInfo").val();
        } else if ($("#PayClientCode").val()) {
            strClientInfo = $("#PayClientInfo").val();
            $("#ClientCode").val($("#PayClientCode").val());
            $("#ClientName").val($("#PayClientName").val());
        }
    } else { //매출
        try {
            intRate = parseInt($("#Rate").val());

            if (isNaN(intRate)) {
                intRate = 0;
            }
        } catch (e) {
            intRate = 0;
        }

        //OP037	할증료
        if (intRate > 0) {
            try {
                intRateSupplyAmt = Math.floor(parseFloat($("#SupplyAmt").val().replace(/,/gi, "")) * intRate / 100);

                if (isNaN(intRateSupplyAmt)) {
                    intRateSupplyAmt = 0;
                }

                intRateSupplyAmt = parseInt(intRateSupplyAmt / 100) * 100;

            } catch (e) {
                intRateSupplyAmt = 0;
            }

            //과세구분 (1:과세, 2:면세, 3:간이, 4:간이과세, 5:영세)
            if ($("#TaxKind").val() === "2" || $("#TaxKind").val() === "3" || $("#TaxKind").val() === "5") {
                intRateTaxAmt = 0;
            } else {
                try {
                    intRateTaxAmt = Math.floor(parseFloat(intRateSupplyAmt) * 0.1);

                    if (isNaN(intRateTaxAmt)) {
                        intRateTaxAmt = 0;
                    }

                } catch (e) {
                    intRateTaxAmt = 0;
                }
            }
        } else {
            blRatePayChk = false;
        }
    }

    var objItem = new Object();
    objItem.PayTypeM = $("#PayType option:selected").text();
    objItem.TaxKindM = $("#TaxKind option:selected").text();
    objItem.ItemCodeM = $("#ItemCode option:selected").text();
    objItem.SupplyAmt = $("#SupplyAmt").val();
    objItem.TaxAmt = $("#TaxAmt").val();
    objItem.ClientInfo = strClientInfo;
    objItem.SeqNo = "";
    objItem.PaySeqNo = "";
    objItem.CenterCode = $("#HidCenterCode").val();
    objItem.OrderNo = $("#HidOrderNo").val();
    objItem.GoodsSeqNo = $("#HidGoodsSeqNo").val();
    objItem.PayType = $("#PayType").val();
    objItem.TaxKind = $("#TaxKind").val();
    objItem.ItemCode = $("#ItemCode").val();
    objItem.ClientCode = $("#ClientCode").val();
    objItem.ClientName = $("#ClientName").val();
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
    AUIGrid.addRow(GridPayID, objItem, "last");

    if ($("#PayType").val() === "1" && blRatePayChk) { //할증료 등록
        var objItem = new Object();
        objItem.PayTypeM = $("#PayType option:selected").text();
        objItem.TaxKindM = $("#TaxKind option:selected").text();
        objItem.ItemCodeM = "할증료";
        objItem.SupplyAmt = intRateSupplyAmt;
        objItem.TaxAmt = intRateTaxAmt;
        objItem.ClientInfo = strClientInfo;
        objItem.SeqNo = "";
        objItem.PaySeqNo = "";
        objItem.CenterCode = $("#HidCenterCode").val();
        objItem.OrderNo = $("#HidOrderNo").val();
        objItem.GoodsSeqNo = $("#HidGoodsSeqNo").val();
        objItem.PayType = $("#PayType").val();
        objItem.TaxKind = $("#TaxKind").val();
        objItem.ItemCode = "OP037";
        objItem.ClientCode = $("#ClientCode").val();
        objItem.ClientName = $("#ClientName").val();
        objItem.ClosingFlag = "N";
        objItem.BillStatus = 1;
        objItem.SendStatus = 1;
        AUIGrid.addRow(GridPayID, objItem, "last");
    }

    fnSetPay();
}

//비용수정
function fnPayUpdRow() {
    var strClientInfo = "";
    var strDispatchInfo = "";

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        fnDefaultAlert("선택된 오더정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#PaySeqNo").val()) {
        fnDefaultAlert("선택된 비용정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#PayType").val()) {
        fnDefaultAlertFocus("비용 구분을 선택하세요.", "PayType", "warning");
        return false;
    }

    if (!$("#TaxKind").val()) {
        fnDefaultAlertFocus("과세 구분을 선택하세요.", "TaxKind", "warning");
        return false;
    }

    if (!$("#ItemCode").val()) {
        fnDefaultAlertFocus("비용항목을 선택하세요.", "ItemCode", "warning");
        return false;
    }

    if (!$("#SupplyAmt").val()) {
        fnDefaultAlertFocus("공급가액을 입력하세요.", "SupplyAmt", "warning");
        return false;
    }

    var cnt = 0;
    if ($("#ItemCode").val() === "OP001" && ($("#PayType").val() == "1" || $("#PayType").val() == "2")) {
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                        if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.PaySeqNo != $("#PaySeqNo").val()) {
                            cnt++;
                        }
                    }
                });
        }

        if (cnt > 0) {
            fnDefaultAlert("운임은 매출/입에 한건씩 입력이 가능합니다.", "warning");
            return;
        }
    }

    if ($("#PayType").val() === "2") { //매입
        if ($("#ClientCode").val() && $("#ClientCode").val() !== "0") {
            strClientInfo = $("#ClientInfo").val();
            strDispatchInfo = "";
        } else {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }
    } else if ($("#PayType").val() === "3" || $("#PayType").val() === "4") { //선급 or 예수
        if (!$("#PayClientCode").val() && !$("#ClientCode").val()) {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }

        if ($("#ClientCode").val()) {
            strClientInfo = $("#ClientInfo").val();
        } else if ($("#PayClientCode").val()) {
            strClientInfo = $("#PayClientInfo").val();
            $("#ClientCode").val($("#PayClientCode").val());
            $("#ClientName").val($("#PayClientName").val());
        }
    }

    var objItem = new Object();
    objItem.PayTypeM = $("#PayType option:selected").text();
    objItem.TaxKindM = $("#TaxKind option:selected").text();
    objItem.ItemCodeM = $("#ItemCode option:selected").text();
    objItem.SupplyAmt = $("#SupplyAmt").val();
    objItem.TaxAmt = $("#TaxAmt").val();
    objItem.ClientInfo = strClientInfo;
    objItem.SeqNo = $("#SeqNo").val();
    objItem.PaySeqNo = $("#PaySeqNo").val();
    objItem.CenterCode = $("#HidCenterCode").val();
    objItem.OrderNo = $("#HidOrderNo").val();
    objItem.GoodsSeqNo = $("#HidGoodsSeqNo").val();
    objItem.DispatchSeqNo = $("#DispatchSeqNo").val();
    objItem.PayType = $("#PayType").val();
    objItem.TaxKind = $("#TaxKind").val();
    objItem.ItemCode = $("#ItemCode").val();
    objItem.ClientCode = $("#ClientCode").val();
    objItem.ClientName = $("#ClientName").val();
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
    AUIGrid.updateRowsById(GridPayID, objItem);
    fnSetPay();
}

//비용삭제
function fnPayDelRow() {

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        fnDefaultAlert("선택된 오더정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#PaySeqNo").val()) {
        fnDefaultAlert("선택된 비용정보가 없습니다.", "warning");
        return false;
    }

    AUIGrid.removeRowByRowId(GridPayID, $("#PaySeqNo").val());
    fnSetPay();
}

//초기화
function fnResetPay() {
    strPayType = "";
    fnSetPay();
}

// 비용 등록/수정/삭제
var PayList = null;
var PayCnt = 0;
var PayProcCnt = 0;
var PaySuccessCnt = 0;
var PayFailCnt = 0;
function fnInsPay() {

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        fnDefaultAlert("선택된 오더정보가 없습니다.", "warning");
        return false;
    }

    //매출입 체크
    var AutoPay = false;
    var ClosingPay = false;
    if (AUIGrid.getGridData(GridPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridPayID),
            function (index, item) {
                if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                    if (item.PayType == 1) {
                        if (!AutoPay && item.ApplySeqNo > 0) {
                            AutoPay = true;
                        }

                        if (!ClosingPay && item.ItemCode == "OP001" && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) { //마감비용 체크
                            ClosingPay = true;
                        }
                    }
                }
            });
    }

    //자동운임체크
    var objItem = AUIGrid.getItemByRowId(GridID, $("#HidOrderNo").val());
    if ($("#HidContractType").val() !== "3" && objItem.FTLFlag === "Y") {
        if (!ClosingPay) {
            if (!AutoPay && $("#TransRateChk").val() !== "Y") {
                fnDefaultAlert("자동운임 확인이 필요하여 자동 조회합니다. 변경된 비용정보를 확인해 주세요.", "warning", "$(\"#BtnCallTransRate\").show();$(\"#BtnCallTransRate\").click();");
                return false;
            }
        } else {
            if (AutoPay && $("#TransRateChk").val() !== "Y") {
                fnDefaultAlert("마감된 자동운임이 있어 항목 변경이 불가능합니다.", "warning");
                return false;
            }
        }
    }

    var GridItems = AUIGrid.getGridData(GridPayID);
    PayList = [];
    $.each(GridItems, function (index, item) {
        if (item.SeqNo === "" || AUIGrid.isAddedById(GridPayID, item.PaySeqNo) || AUIGrid.isEditedById(GridPayID, item.PaySeqNo) || AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
            PayList.push(item);
        }
    });

    if (PayList.length > 0) {
        PayCnt = PayList.length;
        PayProcCnt = 0;
        PaySuccessCnt = 0;
        PayFailCnt = 0;
        fnInsPayProc();
        return false;
    } else {
        fnDefaultAlert("등록할 비용정보가 없습니다.", "info");
        return false;
    }
}

function fnInsPayProc() {
    AUIGrid.showAjaxLoader(GridPayID);
    if (PayProcCnt >= PayCnt) {
        AUIGrid.removeAjaxLoader(GridPayID);
        fnInsPayEnd();
        return;
    }

    var RowPay = PayList[PayProcCnt];
    if (AUIGrid.isEditedById(GridPayID, RowPay.PaySeqNo)) {
        if (RowPay.SeqNo === "") {
            RowPay.CallType = "InoutPayInsert";
        } else {
            RowPay.CallType = "InoutPayUpdate";
        }
    } else if (AUIGrid.isRemovedById(GridPayID, RowPay.PaySeqNo)) {
        RowPay.CallType = "InoutPayDelete";
    } else { //isAddedById
        RowPay.CallType = "InoutPayInsert";
    }

    RowPay.CenterCode = $("#HidCenterCode").val();
    RowPay.OrderNo = $("#HidOrderNo").val();
    RowPay.GoodsSeqNo = $("#HidGoodsSeqNo").val();

    if (RowPay) {
        var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
        var strCallBackFunc = "fnGridPayInsSuccResult";
        var strFailCallBackFunc = "fnGridPayInsFailResult";
        var objParam = RowPay;
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnGridPayInsSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            PaySuccessCnt++;
        } else {
            PayFailCnt++;
        }
    } else {
        PayFailCnt++;
    }
    PayProcCnt++;
    setTimeout(fnInsPayProc(), 500);
}

function fnGridPayInsFailResult() {
    PayProcCnt++;
    PayFailCnt++;
    setTimeout(fnInsPayProc(), 500);
    return false;
}

function fnInsPayEnd() {
    var msg = "비용 정보 등록에 성공하였습니다.";
    fnDefaultAlert(msg, "info", "fnCallPayGridData", GridPayID);

    var objItem = AUIGrid.getItemByRowId(GridID, $("#HidOrderNo").val());
    fnSetTransRateData(objItem.FTLFlag);
    return false;
}
/*********************************************/

//청구처 업무특이사항
function fnCallClientNote(strCenterCode, strClientCode) {

    if (strCenterCode == 0 || strCenterCode == "" || strCenterCode == null) {
        return false;
    }

    if (strClientCode == 0 || strClientCode == "" || strClientCode == null) {
        return false;
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
    var strCallBackFunc = "fnCallClientNoteSuccResult";

    var objParam = {
        CallType: "ClientNote",
        CenterCode: strCenterCode,
        ClientCode: strClientCode
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
}

function fnCallClientNoteSuccResult(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("청구처 업무특이사항을 불러오는데 실패했습니다.");
        return false;
    } else {
        $("#OrderClientNote").val(objRes[0].ClientNote);
        $("#OrderClientNote")[0].setSelectionRange(0, 0);
    }
}
/*****************************************/
//한도 및 원가율 계산
function fnChkSaleLimit() {

    if ($("#HidCnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return;
    }

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        fnDefaultAlertFocus("오더를 선택하세요.", "CenterCode", "warning");
        return;
    }

    var strHandlerUrl = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
    var strCallBackFunc = "fnChkSaleLimitSuccResult";
    var strFailCallBackFunc = "fnChkSaleLimitFailResult";
    var objParam = {
        CallType: "ClientSaleLimit",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        PayClientCode: $("#HidPayClientCode").val(),
        PickupYMD: $("#HidPickupYMD").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnChkSaleLimitSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode == 0) {
            //매출입 체크
            var SaleAmt = 0;
            var AdvanceAmt = 0;
            var PurchaseAmt = 0;
            if (AUIGrid.getGridData(GridPayID).length > 0) {
                $.each(AUIGrid.getGridData(GridPayID),
                    function (index, item) {
                        if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                            if (item.PayType == 1) {
                                SaleAmt += typeof item.SupplyAmt === "number" ? item.SupplyAmt : Number(item.SupplyAmt.replace(/,/gi, ""));
                            }

                            if (item.PayType == 2) {
                                PurchaseAmt += typeof item.SupplyAmt === "number" ? item.SupplyAmt : Number(item.SupplyAmt.replace(/,/gi, ""));
                            }

                            if (item.PayType == 3 || item.PayType == 4) {
                                AdvanceAmt += typeof item.SupplyAmt === "number" ? item.SupplyAmt : Number(item.SupplyAmt.replace(/,/gi, ""));
                            }
                        }
                    });
            }

            //한도 체크 대상일 때 매출 한도 체크
            if (objRes[0].LimitCheckFlag == "Y") {
                if (SaleAmt + AdvanceAmt > 0) {
                    if (objRes[0].LimitAvailAmt + objRes[0].TotalSaleAmt < (SaleAmt + AdvanceAmt)) {
                        fnDefaultAlert("매출 한도를 초과하여 비용을 등록하실 수 없습니다.");
                        return false;
                    }
                }
            }

            fnInsPay();
            return false;
        } else {
            fnChkSaleLimitFailResult();
            return false;
        }
    } else {
        fnChkSaleLimitFailResult();
        return false;
    }
}

function fnChkSaleLimitFailResult() {
    fnDefaultAlert("매출한도 조회에 실패했습니다. 나중에 다시 시도해주세요.");
    return false;
}
/*****************************************/

//위수탁 정보 조회
function fnCallOrderContract() {

    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
    var strCallBackFunc = "fnCallOrderContractSuccResult";
    var strFailCallBackFunc = "fnCallOrderContractFailResult";

    var objParam = {
        CallType: "InoutContract",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnCallOrderContractSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                fnCallOrderContractFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallOrderContractFailResult();
            return false;
        }

        $("#HidContractType").val(objRes[0].data.ContractType);
        $("#HidContractStatus").val(objRes[0].data.ContractStatus);
        if (objRes[0].data.ContractType == 2) {
            /*
            if (item.ContractStatus === 2) {
                $("#SpanContract").text(item.ContractInfo);
                $(".NotAllowedContract").show();
            } else {
                $("#SpanContract").text("위탁취소 : " + item.ContractInfo);
            }
            $(".TrContract").show();
            */
        } else if (objRes[0].data.ContractType == 3) {
            $("#SpanContract").text(objRes[0].data.ContractInfo);
            $(".TrContract").show();
        }
    } else {
        fnCallOrderContractFailResult();
    }
}

function fnCallOrderContractFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

/*********************************************/
/* 자동운임 */
/*********************************************/
//오더 자동운임 조회
function fnCallTransRateData() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
    var strCallBackFunc = "fnCallTransRateDataSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "TransRateOrderList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        CarFixedFlag: $("#HidCarDivType1").val() != "3" ? "Y" : "N"
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
function fnCallTransRate() {
    var PayChk = true;
    if (AUIGrid.getGridData(GridPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridPayID),
            function (index, item) {
                //운임
                if (item.PayType == 1 && item.ItemCode == "OP001" && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) { //마감체크
                    PayChk = false;
                    return false;
                }
            });
    }

    if (!PayChk) {
        fnDefaultAlert("이미 마감된 운임이 있어 자동운임을 적용할 수 없습니다.", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
    var strCallBackFunc = "fnCallTransRateSuccResult";
    var strFailCallBackFunc = "fnCallTransRateFailResult";
    var objItem = AUIGrid.getItemByRowId(GridID, $("#HidOrderNo").val());

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
        CarFixedFlag: objItem.CarDivType1 != "3" ? "Y" : "N"
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

        $("#TransRateChk").val("Y");
        $("#ApplySeqNo").val("");
        $("#SaleUnitAmt").val("");
        $("#FixedPurchaseUnitAmt").val("");
        $("#PurchaseUnitAmt").val("");
        $("#SpanTransRateInfo").html("");
        $("#BtnUpdRequestAmt").hide();

        //자동운임 항목 초기화
        if (objRes[0].data.RecordCnt <= 0) {
            if (AUIGrid.getGridData(GridPayID).length > 0) {
                var arrRemoveIds = [];
                $.each(AUIGrid.getGridData(GridPayID),
                    function (index, item) {
                        //운임
                        if (item.PayType == 1 && item.ItemCode == "OP001" && (item.ApplySeqNo != "" && item.ApplySeqNo != "0")) {
                            arrRemoveIds.push(item.PaySeqNo);
                        }
                    });

                if (arrRemoveIds.length > 0) {
                    AUIGrid.removeRowByRowId(GridPayID, arrRemoveIds);
                }
            }

            fnDefaultAlert("적용 가능한 자동운임이 없습니다.", "info");
            return false;
        }


        var PayChk = true;
        //마감체크 (운임) 시작
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if (item.PayType == 1 && item.ItemCode == "OP001" && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) {
                        PayChk = false;
                        return false;
                    }
                });
        }

        if (!PayChk) {
            fnDefaultAlert("이미 마감된 운임이 있어 자동운임을 적용할 수 없습니다.", "warning");
            return false;
        }
        //마감체크 (운) 끝

        //기존 항목 삭제
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            var arrRemoveIds = [];

            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if (item.PayType == 1 && item.ItemCode == "OP001") {
                        arrRemoveIds.push(item.PaySeqNo);
                    }
                });

            if (arrRemoveIds.length > 0) {
                AUIGrid.removeRowByRowId(GridPayID, arrRemoveIds);
            }
        }

        $("#ApplySeqNo").val(objRes[0].data.ApplySeqNo);

        //매출, 매입이 따로 적용되었는지 확인
        var rateCntType1 = 0;
        $.each(objRes[0].data.list, function (index, item) {
            if (item.RateInfoKind === 1) {
                rateCntType1++;
            }
        });

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
                fnSetTransRate(item);
            }
        });

        return false;
    }
}

function fnCallTransRateFailResult() {
    fnDefaultAlert("나중에 다시 시도해주세요.", "warning");
    return false;
}

//자동운임 세팅
function fnSetTransRate(objRateItem) {

    var intSupplyAmt = 0;
    var intTaxAmt = 0;
    var strItemCode = "";
    var strItemName = "";
    var ApplySale = true;

    if (objRateItem.SaleUnitAmt === 0) {
        ApplySale = false;
    }

    if (objRateItem.RateInfoKind === 1) { //운임
        strItemCode = "OP001";
        strItemName = "운임";
    }

    //매출 추가
    if (ApplySale) {

        try {
            intSupplyAmt = objRateItem.SaleUnitAmt;

            if (isNaN(intSupplyAmt)) {
                intSupplyAmt = 0;
            }
        } catch (e) {
            intSupplyAmt = 0;
        }

        try {
            intTaxAmt = Math.floor(parseFloat(intSupplyAmt) / 10);

            if (isNaN(intTaxAmt)) {
                intTaxAmt = 0;
            }
        } catch (e) {
            intTaxAmt = 0;
        }

        var objItem = new Object();
        objItem.PayTypeM = "매출";
        objItem.TaxKindM = "과세";
        objItem.ItemCodeM = strItemName;
        objItem.SupplyAmt = intSupplyAmt;
        objItem.TaxAmt = intTaxAmt;
        objItem.ClientInfo = "";
        objItem.DispatchInfo = "";
        objItem.SeqNo = "";
        objItem.PaySeqNo = "";
        objItem.CenterCode = $("#HidCenterCode").val();
        objItem.OrderNo = $("#HidOrderNo").val();
        objItem.GoodsSeqNo = $("#HidGoodsSeqNo").val();
        objItem.DispatchSeqNo = "0";
        objItem.PayType = 1;
        objItem.TaxKind = 1;
        objItem.ItemCode = strItemCode;
        objItem.ClientCode = "";
        objItem.ClientName = "";
        objItem.RefSeqNo = "";
        objItem.ClosingFlag = "N";
        objItem.BillStatus = 1;
        objItem.SendStatus = 1;
        objItem.ApplySeqNo = $("#ApplySeqNo").val();
        objItem.TransDtlSeqNo = objRateItem.TransDtlSeqNo;
        objItem.TransRateStatus = 2;

        AUIGrid.addRow(GridPayID, objItem, "last");
    }
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

    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
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
    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
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
    var strHandlerURL = "/TMS/Inout/Proc/InoutCostInsHandler.ashx";
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

function fnOpenTransRateAmtRequest() {
    if (!$("#ApplySeqNo").val() || $("#ApplySeqNo").val() == "0") {
        return false;
    }

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        return false;
    }

    fnCallGridTRAData(GridTRAID);
    $("#DivTransRateAmtRequest").show();
    return false;
}

function fnCloseTransRateAmtRequest() {
    AUIGrid.setGridData(GridTRAID, []);
    //비용 목록 조회
    fnCallPayGridData(GridPayID);
    $("#DivTransRateAmtRequest").hide();
    return false;
}

//자동운임 세팅
function fnSetTransRateData(strFTLFlag) {
    $("#TransRateChk").val("");
    $("#ApplySeqNo").val("");
    $("#SaleUnitAmt").val("");
    $("#FixedPurchaseUnitAmt").val("");
    $("#PurchaseUnitAmt").val("");
    $("#SpanTransRateInfo").text("");
    $("#BtnCallTransRate").show();
    $("#BtnUpdRequestAmt").hide();
    $(".TrTransRate").hide();

    if (strFTLFlag === "Y") {
        $(".TrTransRate").show();
        //요율표 조회
        fnCallTransRateData();
    }
}
/*********************************************/