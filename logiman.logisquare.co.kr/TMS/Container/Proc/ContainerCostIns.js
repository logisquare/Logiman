window.name = "ContainerCostInsOrderListGrid";
// 그리드
var GridID = "#ContainerCostInsOrderListGrid";
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
        fnPayAddRow();
        return false;
    });

    //수정
    $("#BtnUpdPay").on("click", function (e) {
        fnPayUpdRow();
        return false;
    });

    //삭제
    $("#BtnDelPay").on("click", function (e) {
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

    //기본 설정 값
    fnSetPay();

    fnSetInitAutocomplete();
});

function fnSetInitAutocomplete() {
    //업체명 검색
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
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
                    $.each($(".TrPayCar input"),
                        function (index, item) {
                            $(item).val("");
                        });
                    $("#ClientCode").val(ui.item.etc.ClientCode);
                    $("#ClientName").val(ui.item.etc.ClientName);
                    $("#ClientInfo").val(ui.item.etc.ClientInfo);
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

    //차량번호(배차) 검색
    if ($("#RefCarNo").length > 0) {
        fnSetAutocomplete({
            formId: "RefCarNo",
            width: 800,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "CarDispatchRefList",
                    CarNo: request.term,
                    CenterCode: $("#HidCenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
                        fnDefaultAlert("선택된 오더정보가 없습니다.", "warning");
                        return false;
                    }

                    if (request.term.length < 4) {
                        fnDefaultAlert("검색어를 4자 이상 입력하세요.", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.CarNo,
                getValue: (item) => item.CarNo,
                onSelect: (event, ui) => {
                    $.each($(".TrPayCar input[type='text']"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#RefSeqNo").val(ui.item.etc.RefSeqNo);
                    $("#RefCarNo").val(ui.item.etc.CarNo);
                    $("#DispatchInfo").val(ui.item.etc.DispatchInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("CarDispatchRef", ul, item);
                },
                onBlur: () => {
                    if (!$("#RefCarNo").val()) {
                        $("#RefSeqNo").val("");
                        $("#DispatchInfo").val("");
                    }
                }
            }
        });
    }

    //차량업체명 검색
    if ($("#ComName").length > 0) {
        fnSetAutocomplete({
            formId: "ComName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "CarCompanyList",
                    ComName: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.ComName,
                getValue: (item) => item.ComName,
                onSelect: (event, ui) => {
                    $("#RefSeqNo").val("");
                    $("#DispatchInfo").val("");
                    $("#RefCarNo").val("");

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#ComCode").val(ui.item.etc.ComCode);
                    $("#ComName").val(ui.item.etc.ComName);
                    $("#ComInfo").val(ui.item.etc.ComInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("CarCompany", ul, item);
                },
                onBlur: () => {
                    if (!$("#ComName").val()) {
                        $("#ComCode").val("");
                        $("#ComInfo").val("");
                    }
                }
            }
        });
    }

    //차량번호 검색
    if ($("#CarNo").length > 0) {
        fnSetAutocomplete({
            formId: "CarNo",
            width: 300,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "CarList",
                    CarNo: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (request.term.length < 4) {
                        fnDefaultAlert("검색어를 4자 이상 입력하세요.", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.CarInfo,
                getValue: (item) => item.CarNo,
                onSelect: (event, ui) => {
                    $("#RefSeqNo").val("");
                    $("#DispatchInfo").val("");
                    $("#RefCarNo").val("");

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#CarSeqNo").val(ui.item.etc.CarSeqNo);
                    $("#CarNo").val(ui.item.etc.CarNo);
                    $("#CarInfo").val(ui.item.etc.CarInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Car", ul, item);
                },
                onBlur: () => {
                    if (!$("#CarNo").val()) {
                        $("#CarSeqNo").val("");
                        $("#CarInfo").val("");
                    }
                }
            }
        });
    }

    //기사명 검색
    if ($("#DriverName").length > 0) {
        fnSetAutocomplete({
            formId: "DriverName",
            width: 250,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "DriverList",
                    DriverName: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.DriverName,
                getValue: (item) => item.DriverName,
                onSelect: (event, ui) => {
                    $("#RefSeqNo").val("");
                    $("#DispatchInfo").val("");
                    $("#RefCarNo").val("");

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#DriverSeqNo").val(ui.item.etc.DriverSeqNo);
                    $("#DriverName").val(ui.item.etc.DriverName);
                    $("#DriverCell").val(ui.item.etc.DriverCell);
                    $("#DriverInfo").val(ui.item.etc.DriverInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Driver", ul, item);
                },
                onBlur: () => {
                    if (!$("#DriverName").val()) {
                        $("#DriverSeqNo").val("");
                        $("#DriverCell").val("");
                        $("#DriverInfo").val("");
                    }
                }
            }
        });
    }

    //기사휴대폰 검색
    if ($("#DriverCell").length > 0) {
        fnSetAutocomplete({
            formId: "DriverCell",
            width: 250,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "DriverList",
                    DriverCell: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.DriverCell,
                getValue: (item) => item.DriverCell,
                onSelect: (event, ui) => {
                    $("#RefSeqNo").val("");
                    $("#DispatchInfo").val("");
                    $("#RefCarNo").val("");

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#DriverSeqNo").val(ui.item.etc.DriverSeqNo);
                    $("#DriverName").val(ui.item.etc.DriverName);
                    $("#DriverCell").val(ui.item.etc.DriverCell);
                    $("#DriverInfo").val(ui.item.etc.DriverInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Driver", ul, item);
                },
                onBlur: () => {
                    if (!$("#DriverCell").val()) {
                        $("#DriverSeqNo").val("");
                        $("#DriverName").val("");
                        $("#DriverInfo").val("");
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
        $(".TrPayCar").show();
    } else if ($("#PayType option:selected").text() === "선급" || $("#PayType option:selected").text() === "예수") { //선급 or 예수
        $(".TrPayClient").show();
        $(".TrPayCar").hide();
    } else { //매출 외
        $(".TrPayClient").hide();
        $(".TrPayCar").hide();
    }

    $("#TaxKind").find("option").filter(function (index) {
        return $(this).text() === "과세";
    }).prop("selected", true);

    $("#BtnUpdPay").hide();
    $("#BtnDelPay").hide();

    $("#SeqNo").val("");
    $("#PaySeqNo").val("");

    if (!((strPayType == "1" && $("#PayType").val() == "2") || (strPayType == "2" && $("#PayType").val() == "1"))) {
        $("#ItemCode").find("option:nth-child(2)").prop("selected", true);
        $("#SupplyAmt").val("");
        $("#TaxAmt").val("");
    }

    $.each($(".TrPayClient input"),
        function (index, item) {
            $(item).val("");
        });

    $.each($(".TrPayCar input"),
        function (index, item) {
            $(item).val("");
        });

    $.each($(".TrPayCar select"),
        function (index, item) {
            $(item).val("");
        });
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
    AUIGrid.resize(GridID, $(".grid_list").width(), 320);

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
        fnSaveColumnLayoutAuto(GridID, 'ContainerCostInsOrderListGrid');
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
            visible: false,
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
            viewstatus: true
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
        return;
    }

    fnSetOrderInfo(objItem);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var LocationCode = [];
    var ItemCode = [];
    var strHandlerURL = "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
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

function fnSetOrderInfo(objItem) {
    $("#HidOrderNo").val(objItem.OrderNo);
    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidGoodsSeqNo").val(objItem.GoodsSeqNo);
    $("#HidPayClientCode").val(objItem.PayClientCode);
    $("#HidPickupYMD").val(objItem.PickupYMD);
    $("#HidCnlFlag").val(objItem.CnlFlag);
    $("#SpanOrderNo").text(objItem.OrderNo);
    $("#SpanOrderClientName").text(objItem.OrderClientName);
    $("#SpanPayClientName").text(objItem.PayClientName);
    $("#PayClientCode").val(objItem.PayClientCode);
    $("#PayClientName").val(objItem.PayClientName);
    $("#PayClientInfo").val(objItem.PayClientInfo);
    $("#SpanConsignorName").text(objItem.ConsignorName);
    $("#SpanPickupInfo").text(fnGetStrDateFormat(objItem.PickupYMD, "-"));
    $("#SpanGoodsInfo").text(objItem.GoodsItemCodeM + " / " + objItem.Volume + " / " + objItem.Weight);
    $("#OrderClientNote").val("");

    if (objItem.CenterCode !== $("#HidCenterCode").val()) {
        $("#HidCenterCode").val(objItem.CenterCode);
        //항목코드 세팅
        fnSetCodeList();
    }
    fnCallPayGridData(GridPayID);
    fnCallClientNote(objItem.CenterCode, objItem.PayClientCode);
}

//비용항목 리셋
function fnSetCodeList() {
    if (!$("#HidCenterCode").val()) {
        fnDefaultAlert("회원사를 선택하세요.", "warning");
        return;
    }

    var strHandlerURL = "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
    var strCallBackFunc = "fnAjaxSetCodeList";

    var objParam = {
        CallType: "ContainerCodeList",
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
var GridPayID = "#ContainerCostInsPayListGrid";

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
    AUIGrid.resize(GridPayID, $(GridPayID).width(), intHeight);
    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridPayID, $(GridPayID).width(), intHeight);
        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridPayID, $(GridPayID).width(), intHeight);
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
            dataField: "InsureExceptKind",
            headerText: "InsureExceptKind",
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
        fnDefaultAlert("마감된 비용은 수정할 수 없습니다", "error");
        return;
    }

    fnDisplayPay(objItem);
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallPayGridData(strGID) {

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        AUIGrid.setGridData(GridPayID, []);
    }

    var strHandlerURL = "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
    var strCallBackFunc = "fnPayGridSuccResult";

    var objParam = {
        CallType: "ContainerPayList",
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
    var strDispatchInfo = typeof item.DispatchInfo === "undefined" ? "" : item.DispatchInfo;
    var strComInfo = typeof item.ComInfo === "undefined" ? "" : item.ComInfo;
    var strCarInfo = typeof item.CarInfo === "undefined" ? "" : item.CarInfo;
    var strDriverInfo = typeof item.DriverInfo === "undefined" ? "" : item.DriverInfo;

    var strRefCarNo = "";
    var strComName = "";
    var strCarNo = "";
    var strDriverName = "";
    var strDriverCell = "";

    //업체비용
    if (strClientInfo !== "" && item.ClientCode !== "" && item.ClientCode != "0") {
        strDispatchInfo = "";
        strComInfo = "";
        strCarInfo = "";
        strDriverInfo = "";
    }

    //차량비용
    if (item.CarDivType != "" && strComInfo !== "" && strCarInfo !== "" && strDriverInfo !== "" && item.ComCode != "0" && item.ComCode != "" && item.CarSeqNo != "0" && item.CarSeqNo != "" && item.DriverSeqNo != "0" && item.DriverSeqNo != "") {
        strClientInfo = "";
        strDispatchInfo = "";

        strComName = strComInfo.substring(0, strComInfo.indexOf("(") - 1);
        if (strCarInfo.indexOf("(") > -1) {
            strCarNo = strCarInfo.substring(0, strCarInfo.indexOf("(") - 1);
        } else {
            strCarNo = strCarInfo;
        }
        strDriverName = strDriverInfo.substring(0, strDriverInfo.indexOf("(") - 1);
        strDriverCell = strDriverInfo.substring(strDriverInfo.indexOf("(") + 1, strDriverInfo.indexOf(")"));
    }

    //배차차량비용
    if (strDispatchInfo !== "" && item.RefSeqNo != "0" && item.RefSeqNo != "") {
        strClientInfo = "";
        strComInfo = "";
        strCarInfo = "";
        strDriverInfo = "";
        strRefCarNo = strDispatchInfo.substring(strDispatchInfo.indexOf("]") + 2, strDispatchInfo.indexOf("(") - 1);
        if (strRefCarNo.indexOf("/") > -1) {
            strRefCarNo = strRefCarNo.substring(0, strRefCarNo.indexOf("/") - 1);
        }
    }

    $("#SeqNo").val(item.SeqNo);
    $("#PaySeqNo").val(item.PaySeqNo);
    $("#TaxKind").val(item.TaxKind);
    $("#ItemCode").val(item.ItemCode);
    $("#SupplyAmt").val(fnMoneyComma(item.SupplyAmt));
    $("#TaxAmt").val(fnMoneyComma(item.TaxAmt));
    $("#ClientCode").val(item.ClientCode);
    $("#ClientInfo").val(strClientInfo);
    $("#ClientName").val(item.ClientName);
    $("#RefSeqNo").val(item.RefSeqNo);
    $("#DispatchInfo").val(strDispatchInfo);
    $("#CarDivType").val(item.CarDivType);
    $("#ComCode").val(item.ComCode);
    $("#ComInfo").val(strComInfo);
    $("#CarSeqNo").val(item.CarSeqNo);
    $("#CarInfo").val(strCarInfo);
    $("#DriverSeqNo").val(item.DriverSeqNo);
    $("#DriverInfo").val(strDriverInfo);
    $("#RefCarNo").val(strRefCarNo);
    $("#ComName").val(strComName);
    $("#CarNo").val(strCarNo);
    $("#DriverName").val(strDriverName);
    $("#DriverCell").val(strDriverCell);
    $("#DispatchSeqNo").val(item.DispatchSeqNo);
    $("#InsureExceptKind").val(item.InsureExceptKind);
    $("#BtnUpdPay").show();
    $("#BtnDelPay").show();
}

//비용추가
function fnPayAddRow() {
    var strClientInfo = "";
    var strDispatchInfo = "";

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
                        if ($("#PayType").val() == "1") {
                            if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val()) {
                                cnt++;
                            }
                        } else if ($("#PayType").val() == "2") {
                            if ($("#RefSeqNo").val()) {
                                if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.RefSeqNo == $("#RefSeqNo").val()) {
                                    cnt++;
                                }
                            } else {
                                if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val()) {
                                    cnt++;
                                }
                            }
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
        } else if ($("#CarDivType").val() !== "" && $("#ComCode").val() && $("#ComCode").val() !== "0" && $("#CarSeqNo").val() && $("#CarSeqNo").val() !== "0" && $("#DriverSeqNo").val() && $("#DriverSeqNo").val() !== "0") {
            if (!$("#InsureExceptKind").val()) {
                fnDefaultAlertFocus("산재보험 신고 정보를 선택하세요.", "InsureExceptKind", "warning");
                return false;
            }
            $("#ClientCode").val("");
            $("#ClientName").val("");
            strClientInfo = "";
            strDispatchInfo = "[" + $("#CarDivType option:selected").text() + "] " + $("#CarInfo").val() + " / " + $("#DriverInfo").val() + " / " + $("#ComInfo").val();
        } else if ($("#RefSeqNo").val() && $("#RefSeqNo").val() !== "0") {
            if (!$("#InsureExceptKind").val()) {
                fnDefaultAlertFocus("산재보험 신고 정보를 선택하세요.", "InsureExceptKind", "warning");
                return false;
            }
            $("#ClientCode").val("");
            $("#ClientName").val("");
            $("#CarDivType").val("");
            $("#ComCode").val("");
            $("#ComInfo").val("");
            $("#CarSeqNo").val("");
            $("#CarInfo").val("");
            $("#DriverSeqNo").val("");
            $("#DriverInfo").val("");
            strClientInfo = "";
            strDispatchInfo = $("#DispatchInfo").val();
        } else {
            fnDefaultAlertFocus("업체정보나 차량정보를 입력하세요.", "ClientName", "warning");
            return false;
        }
    } else if ($("#PayType").val() === "3" || $("#PayType").val() === "4") { //선급 or 예수
        if (!$("#PayClientCode").val() && !$("#ClientCode").val()) {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }

        strDispatchInfo = "";

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
    objItem.DispatchInfo = strDispatchInfo;
    objItem.SeqNo = "";
    objItem.PaySeqNo = "";
    objItem.CenterCode = $("#HidCenterCode").val();
    objItem.OrderNo = $("#HidOrderNo").val();
    objItem.GoodsSeqNo = $("#HidGoodsSeqNo").val();
    objItem.DispatchSeqNo = $("#DispatchSeqNo").val();
    objItem.PayType = $("#PayType").val();
    objItem.TaxKind = $("#TaxKind").val();
    objItem.ItemCode = $("#ItemCode").val();
    objItem.ClientCode = $("#ClientCode").val();
    objItem.ClientName = $("#ClientName").val();
    objItem.RefSeqNo = $("#RefSeqNo").val();
    objItem.CarDivType = $("#CarDivType").val();
    objItem.ComCode = $("#ComCode").val();
    objItem.ComInfo = $("#ComInfo").val();
    objItem.CarSeqNo = $("#CarSeqNo").val();
    objItem.CarInfo = $("#CarInfo").val();
    objItem.DriverSeqNo = $("#DriverSeqNo").val();
    objItem.DriverInfo = $("#DriverInfo").val();
    objItem.InsureExceptKind = $("#InsureExceptKind").val();
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
    AUIGrid.addRow(GridPayID, objItem, "last");
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
                        if ($("#PayType").val() == "1") {
                            if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.PaySeqNo != $("#PaySeqNo").val()) {
                                cnt++;
                            }
                        } else if ($("#PayType").val() == "2") {
                            if ($("#RefSeqNo").val()) {
                                if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.PaySeqNo != $("#PaySeqNo").val() && item.RefSeqNo == $("#RefSeqNo").val()) {
                                    cnt++;
                                }
                            } else {
                                if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.PaySeqNo != $("#PaySeqNo").val()) {
                                    cnt++;
                                }
                            }
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
        } else if ($("#CarDivType").val() !== "" && $("#ComCode").val() && $("#ComCode").val() !== "0" && $("#CarSeqNo").val() && $("#CarSeqNo").val() !== "0" && $("#DriverSeqNo").val() && $("#DriverSeqNo").val() !== "0") {
            if (!$("#InsureExceptKind").val()) {
                fnDefaultAlertFocus("산재보험 신고 정보를 선택하세요.", "InsureExceptKind", "warning");
                return false;
            }
            $("#ClientCode").val("");
            $("#ClientName").val("");
            strClientInfo = "";
            strDispatchInfo = "[" + $("#CarDivType option:selected").text() + "] " + $("#CarInfo").val() + " / " + $("#DriverInfo").val() + " / " + $("#ComInfo").val();
        } else if ($("#RefSeqNo").val() && $("#RefSeqNo").val() !== "0") {
            if (!$("#InsureExceptKind").val()) {
                fnDefaultAlertFocus("산재보험 신고 정보를 선택하세요.", "InsureExceptKind", "warning");
                return false;
            }
            $("#ClientCode").val("");
            $("#ClientName").val("");
            $("#CarDivType").val("");
            $("#ComCode").val("");
            $("#ComInfo").val("");
            $("#CarSeqNo").val("");
            $("#CarInfo").val("");
            $("#DriverSeqNo").val("");
            $("#DriverInfo").val("");
            strClientInfo = "";
            strDispatchInfo = $("#DispatchInfo").val();
        } else {
            fnDefaultAlertFocus("업체정보나 차량정보를 입력하세요.", "ClientName", "warning");
            return false;
        }
    } else if ($("#PayType").val() === "3" || $("#PayType").val() === "4") { //선급 or 예수
        if (!$("#PayClientCode").val() && !$("#ClientCode").val()) {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }

        strDispatchInfo = "";

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
    objItem.DispatchInfo = strDispatchInfo;
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
    objItem.RefSeqNo = $("#RefSeqNo").val();
    objItem.CarDivType = $("#CarDivType").val();
    objItem.ComCode = $("#ComCode").val();
    objItem.ComInfo = $("#ComInfo").val();
    objItem.CarSeqNo = $("#CarSeqNo").val();
    objItem.CarInfo = $("#CarInfo").val();
    objItem.DriverSeqNo = $("#DriverSeqNo").val();
    objItem.DriverInfo = $("#DriverInfo").val();
    objItem.InsureExceptKind = $("#InsureExceptKind").val();
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
    var SaleAmt = 0;
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
                }
            });
    }

    if (PurchaseAmt > 0 && SaleAmt <= 0) {
        fnDefaultAlert("매입은 매출입력 후 등록이 가능합니다.", "warning");
        return;
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
            RowPay.CallType = "ContainerPayInsert";
        } else {
            RowPay.CallType = "ContainerPayUpdate";
        }
    } else if (AUIGrid.isRemovedById(GridPayID, RowPay.PaySeqNo)) {
        RowPay.CallType = "ContainerPayDelete";
    } else { //isAddedById
        RowPay.CallType = "ContainerPayInsert";
    }

    RowPay.CenterCode = $("#HidCenterCode").val();
    RowPay.OrderNo = $("#HidOrderNo").val();
    RowPay.GoodsSeqNo = $("#HidGoodsSeqNo").val();

    if (RowPay) {
        var strHandlerURL = "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
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

    var strHandlerURL = "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
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

    var strHandlerUrl = "/TMS/Container/Proc/ContainerCostInsHandler.ashx";
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