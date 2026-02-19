window.name = "InoutGMOrderInsGrid";
// 그리드
var GridID = "#InoutGMOrderInsGrid";
var GridSort = [];
var strCenterCode = "";
var styleMap = [];

$(document).ready(function () {

    $("#PickupYMD").datepicker({
        dateFormat: "yy-mm-dd",
        onSelect: function (dateFromText, inst) {
            var GetYMDText = $("#GetYMD").val().replace(/-/gi, "");
            if (GetYMDText.length !== 8) {
                GetYMDText = GetDateToday("");
            }

            if (parseInt(dateFromText.replace(/-/gi, "")) > parseInt(GetYMDText)) {
                $("#GetYMD").datepicker("setDate", dateFromText);
            }
        }
    });
    $("#PickupYMD").datepicker("setDate", GetDateToday("-"));

    $("#GetYMD").datepicker({
        dateFormat: "yy-mm-dd"
    });
    $("#GetYMD").datepicker("setDate", GetDateToday("-"));

    /**
     * 폼 이벤트
     */
    //하차지 주소 검색
    $("#BtnSearchAddrGetPlace").on("click", function (e) {
        fnOpenAddress("GetPlace");
        return;
    });

    $("#CenterCode").on("click", function () {
        strCenterCode = $(this).val();
    }).on("change", function () {
        var chkForm = false;
        //발주처, 청구처 체크
        $.each($(".TdClient input"), function (index, Item) {
            if ($(Item).val()) {
                chkForm = true;
                return false;
            }
        });

        //발주처, 청구처, 화주, 사업장, 비용항목 리셋
        if ($(this).val() !== strCenterCode) {
            if (chkForm) {
                fnDefaultConfirm("회원사를 변경하면 일부 정보가 삭제됩니다. 변경 하시겠습니까?", "fnSetCenterChange", "0", "fnSetCenterChange", "1");
            } else {
                fnSetCenterChange(0);
            }
        }
    });

    //발주처 자동완성
    if ($("#OrderClientName").length > 0) {
        fnSetAutocomplete({
            formId: "OrderClientName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutGMHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#OrderClientCode").val(ui.item.etc.ClientCode);
                    $("#OrderClientName").val(ui.item.etc.ClientName);
                    $("#OrderClientChargeName").val(ui.item.etc.ChargeName);
                    $("#OrderClientChargePosition").val(ui.item.etc.ChargePosition);
                    $("#OrderClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#OrderClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#OrderClientChargeCell").val(ui.item.etc.ChargeCell);

                    if (!$("#PayClientCode").val()) {
                        $("#PayClientCode").val(ui.item.etc.ClientCode);
                        $("#PayClientInfo").val(ui.item.etc.ClientInfo);
                        $("#PayClientName").val(ui.item.etc.ClientName);
                        $("#PayClientCorpNo").val(ui.item.etc.ClientCorpNo);
                        $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                        $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                        $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                        $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                        $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                        $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                    }
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#OrderClientName").val()) {
                        $("#OrderClientCode").val("");
                        $("#OrderClientChargeName").val("");
                        $("#OrderClientChargePosition").val("");
                        $("#OrderClientChargeTelExtNo").val("");
                        $("#OrderClientChargeTelNo").val("");
                        $("#OrderClientChargeCell").val("");
                    }
                }
            }
        });
    }

    //발주처 담당자 자동완성
    if ($("#OrderClientChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "OrderClientChargeName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutGMHandler.ashx";
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
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName,
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    $("#OrderClientCode").val(ui.item.etc.ClientCode);
                    $("#OrderClientName").val(ui.item.etc.ClientName);
                    $("#OrderClientChargeName").val(ui.item.etc.ChargeName);
                    $("#OrderClientChargePosition").val(ui.item.etc.ChargePosition);
                    $("#OrderClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#OrderClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#OrderClientChargeCell").val(ui.item.etc.ChargeCell);

                    if (!$("#PayClientCode").val()) {
                        $("#PayClientCode").val(ui.item.etc.ClientCode);
                        $("#PayClientInfo").val(ui.item.etc.ClientInfo);
                        $("#PayClientName").val(ui.item.etc.ClientName);
                        $("#PayClientCorpNo").val(ui.item.etc.ClientCorpNo);
                        $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                        $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                        $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                        $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                        $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                        $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                    }
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#OrderClientChargeName").val()) {
                        $("#OrderClientChargeName").val("");
                        $("#OrderClientChargePosition").val("");
                        $("#OrderClientChargeTelExtNo").val("");
                        $("#OrderClientChargeTelNo").val("");
                        $("#OrderClientChargeCell").val("");
                    }
                }
            }
        });
    }

    //청구처 자동완성
    if ($("#PayClientName").length > 0) {
        fnSetAutocomplete({
            formId: "PayClientName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutGMHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    ClientFlag: "Y",
                    ChargeFlag: "Y",
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#PayClientCode").val(ui.item.etc.ClientCode);
                    $("#PayClientInfo").val(ui.item.etc.ClientInfo);
                    $("#PayClientName").val(ui.item.etc.ClientName);
                    $("#PayClientCorpNo").val(ui.item.etc.ClientCorpNo);
                    $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                    $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                    $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                    $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#PayClientName").val()) {
                        $("#PayClientCode").val("");
                        $("#PayClientInfo").val("");
                        $("#PayClientCorpNo").val("");
                        $("#PayClientChargeName").val("");
                        $("#PayClientChargePosition").val("");
                        $("#PayClientChargeTelExtNo").val("");
                        $("#PayClientChargeTelNo").val("");
                        $("#PayClientChargeCell").val("");
                        $("#PayClientChargeLocation").val("");
                    }
                }
            }
        });
    }

    //청구처 담당자 자동완성
    if ($("#PayClientChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "PayClientChargeName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutGMHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientChargeList",
                    ChargeName: request.term,
                    ClientFlag: "Y",
                    ChargeFlag: "Y",
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName,
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    $("#PayClientCode").val(ui.item.etc.ClientCode);
                    $("#PayClientInfo").val(ui.item.etc.ClientInfo);
                    $("#PayClientName").val(ui.item.etc.ClientName);
                    $("#PayClientCorpNo").val(ui.item.etc.ClientCorpNo);
                    $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                    $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                    $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                    $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#PayClientChargeName").val()) {
                        $("#PayClientChargePosition").val("");
                        $("#PayClientChargeTelExtNo").val("");
                        $("#PayClientChargeTelNo").val("");
                        $("#PayClientChargeCell").val("");
                        $("#PayClientChargeLocation").val("");
                    }
                }
            }
        });
    }

    //하차지 자동완성
    if ($("#GetPlace").length > 0) {
        fnSetAutocomplete({
            formId: "GetPlace",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutGMHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "PlaceList",
                    PlaceName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.PlaceName,
                getValue: (item) => item.PlaceName,
                onSelect: (event, ui) => {
                    $("#GetPlace").val(ui.item.etc.PlaceName);
                    $("#GetPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#GetPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#GetPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#GetPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#GetPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#GetPlacePost").val(ui.item.etc.PlacePost);
                    $("#GetPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#GetPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#GetPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#GetPlaceLocalCode").val(ui.item.etc.LocalCode);
                    $("#GetPlaceLocalName").val(ui.item.etc.LocalName);
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#GetPlace").val()) {
                        $("#GetPlaceChargeName").val("");
                        $("#GetPlaceChargePosition").val("");
                        $("#GetPlaceChargeTelExtNo").val("");
                        $("#GetPlaceChargeTelNo").val("");
                        $("#GetPlaceChargeCell").val("");
                        $("#GetPlacePost").val("");
                        $("#GetPlaceAddr").val("");
                        $("#GetPlaceAddrDtl").val("");
                        $("#GetPlaceFullAddr").val("");
                        $("#GetPlaceLocalCode").val("");
                        $("#GetPlaceLocalName").val("");
                    }
                }
            }
        });
    }

    //하차지 담당자 자동완성
    if ($("#GetPlaceChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "GetPlaceChargeName",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutGMHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "PlaceChargeList",
                    PlaceChargeName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName,
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    $("#GetPlace").val(ui.item.etc.PlaceName);
                    $("#GetPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#GetPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#GetPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#GetPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#GetPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#GetPlacePost").val(ui.item.etc.PlacePost);
                    $("#GetPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#GetPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#GetPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#GetPlaceLocalCode").val(ui.item.etc.LocalCode);
                    $("#GetPlaceLocalName").val(ui.item.etc.LocalName);
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#GetPlaceChargeName").val()) {
                        $("#GetPlaceChargeName").val("");
                        $("#GetPlaceChargePosition").val("");
                        $("#GetPlaceChargeTelExtNo").val("");
                        $("#GetPlaceChargeTelNo").val("");
                        $("#GetPlaceChargeCell").val("");
                    }
                }
            }
        });
    }

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

});

//회원사 변경 세팅
function fnSetCenterChange(intType) {
    if (intType == 0) {
        $(".TdClient input").val("");
    } else {
        $("#CenterCode").val(strCenterCode);
    }
}

function fnSetFocus() {

    if (!$("#OrderItemCode").val()) {
        $("#OrderItemCode").focus();
        return false;
    } else if (!$("#PickupYMD").val()) {
        $("#PickupYMD").focus();
        return false;
    } else if (!$("#GetYMD").val()) {
        $("#GetYMD").focus();
        return false;
    } else if (!$("#OrderClientCode").val()) {
        $("#OrderClientName").focus();
        return false;
    } else if (!$("#OrderClientChargeName").val()) {
        $("#OrderClientChargeName").focus();
        return false;
    } else if (!$("#OrderClientChargeTelNo").val() && !$("#OrderClientChargeCell").val()) {
        $("#OrderClientChargeTelNo").focus();
        return false;
    } else if (!$("#PayClientCode").val()) {
        $("#PayClientName").focus();
        return false;
    } else if (!$("#PayClientChargeName").val()) {
        $("#PayClientChargeName").focus();
        return false;
    } else if (!$("#PayClientChargeTelNo").val() && !$("#PayClientChargeCell").val()) {
        $("#PayClientChargeTelNo").focus();
        return false;
    } else if (!$("#PayClientChargeLocation").val()) {
        $("#PayClientChargeLocation").focus();
        return false;
    } else if (!$("#GetPlace").val()) {
        $("#GetPlace").focus();
        return false;
    }/* else if (!$("#GetPlaceChargeName").val()) {
        $("#GetPlaceChargeName").focus();
        return false;
    }*/ else if (!$("#GetPlaceChargeTelNo").val() && !$("#GetPlaceChargeCell").val()) {
        $("#GetPlaceChargeTelNo").focus();
        return false;
    } else if (!$("#GetPlaceAddr").val()) {
        $("#BtnSearchAddrGetPlace").focus();
        return false;
    }
}

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 350;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 350);
        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 350);
        }, 100);
    });

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
    objGridProps.fixedColumnCount = 1; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = true; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = true; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    AUIGrid.bind(GridID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "addRow", "pasteBegin"], fnGridCellEditingHandler);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "ValidationCheck",
            headerText: "상태",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Nation",
            headerText: "PLANT",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "Hawb",
            headerText: "SO",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Mawb",
            headerText: "MTI",
            editable: true,
            width: 100,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "LocationAlias",
            headerText: "Location Alias",
            editable: true,
            width: 120,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction

        },
        {
            dataField: "Shipper",
            headerText: "Shipper",
            editable: true,
            width: 200,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "Origin",
            headerText: "Origin",
            editable: true,
            width: 120,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "Length",
            headerText: "Length",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Width",
            headerText: "Width",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Height",
            headerText: "Height",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PTVolume",
            headerText: "Pallet",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CTVolume",
            headerText: "Carton",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Weight",
            headerText: "GWT kg",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CBM",
            headerText: "Volume cbm",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "InvoiceNo",
            headerText: "INV#",
            editable: true,
            width: 120,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "NoteClient",
            headerText: "Remark(CISCO)",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderLocation",
            headerText: "사업장",
            editable: true,
            width: 80,
            visible: true,
            viewstatus: false,
            headerStyle: "aui-grid-editable_header",
            styleFunction: fnCellStyleFunction
        },
        {
            dataField: "GMOrderType",
            headerText: "오더구분",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "NationKr",
            headerText: "나라",
            editable: true,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: false
        },
        /*숨김필드*/
        {
            dataField: "SeqNo",
            headerText: "SeqNo",
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


function fnGridCellEditingHandler(event) {
    if (event.type === "cellEditBegin") {
        //if (event.isClipboard && (event.columnIndex === 0))
        //    return false;
    } else if (event.type == "cellEditEnd") {
        var item = event.item;
        item.ValidationCheck = "미검증";
        AUIGrid.updateRowsById(GridID, item);
    } else if (event.type === "cellEditEndBefore") {
        var retStr = event.value;
        retStr = retStr.toString().replace(/\t/gi, "");
        retStr = retStr.toString().replace(/\n/gi, "");

        if (event.dataField === "Length" || event.dataField === "Width" || event.dataField === "Height" || event.dataField === "PTVolume" || event.dataField === "CTVolume") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9]/gi, '');
            if (retStr === "") {
                retStr = "0";
            }
        }

        if (event.dataField == "Weight" || event.dataField == "CBM") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9.\-]/gi, '');
            if (retStr === "") {
                retStr = "0";
            }
        }

        retStr = retStr.replace(/\t/gi, "");
        retStr = retStr.replace(/\"/gi, "");
        retStr = retStr.replace(/\\/gi, "");
        retStr = retStr.replace(/\xA0/gi, ""); //char(160)
        return retStr;
    } else if (event.type === "addRow") {
        for (i = 0; i < event.items.length; i++) {
            event.items[i].ValidationCheck = "미검증";
            AUIGrid.updateRowsById(GridID, event.items[i]);
        }
        AUIGrid.update(GridID);
    } else if (event.type === "pasteBegin") {

        var arrData = event.clipboardData.split("\r\n");
        var arrResult = [];
        var selectedRows = AUIGrid.getSelectedItems(GridID);
        for (var i = 0; i < arrData.length; i++) {
            if (arrData[i] !== "") {
                arrResult[i] = arrData[i].split("\t");
            }
        }
        
        if (selectedRows.length !== 0) {
            var rowIndex = selectedRows[0].rowIndex;
            var columnIndex = AUIGrid.getSelectedColIndexes(GridID)[0];
            var cnt = 0;

            if (columnIndex === 0) {
                for (var i = 0; i < arrResult.length; i++) {
                    if (arrResult[i].length === 18) {
                        arrResult[i].unshift("미검증");
                    }
                }
            }

            for (var i = rowIndex; i < AUIGrid.getRowCount(GridID); i++) {
                var item = AUIGrid.getItemByRowIndex(GridID, i);
                if (item.ValidationCheck === "미검증") {
                    if (arrResult[cnt].length === 19) {
                        arrResult[cnt].shift();
                    }
                }
                cnt++;

                if (cnt >= arrResult.length) {
                    break;
                }
            }
        } else {
            for (var i = 0; i < arrResult.length; i++) {
                if (arrResult[i].length === 18) {
                    arrResult[i].unshift("미검증");
                }
            }
        }

        return arrResult; // 반환되는 값을 붙여넣기 적용함.
    }
};
//---------------------------------------------------------------------------------

// 행 추가
function fnAddRow() {
    var item = new Object();
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    item.ValidationCheck = "미검증";
    item.CBM = "";
    item.CTVolume = "";
    item.GMOrderType = "";
    item.Hawb = "";
    item.Height = "";
    item.InvoiceNo = "";
    item.Length = "";
    item.LocationAlias = "";
    item.Mawb = "";
    item.Nation = "";
    item.NationKr = "";
    item.NoteClient = "";
    item.OrderLocation = "";
    item.OrderNo = "";
    item.Origin = "";
    item.PTVolume = "";
    item.SeqNo = "";
    item.Shipper = "";
    item.Weight = "";
    item.Width = "";
    AUIGrid.addRow(GridID, item, "last");
}

// 행 삭제
function fnRemoveRow() {
    var selectedItems = AUIGrid.getSelectedItems(GridID);
    if (selectedItems.length <= 0) return;
    // singleRow, singleCell 이 아닌 multiple 인 경우 선택된 개수 만큼 배열의 요소가 있음
    for (i = selectedItems.length - 1; i >= 0; i--) {
        var sItem = selectedItems[i];
        AUIGrid.removeRow(GridID, sItem.rowIndex);
    }
}

// 등록 행 삭제
function BtnDelSuccRow() {
    var selectedItems = AUIGrid.getItemsByValue(GridID, "ValidationCheck", "등록");
    if (selectedItems.length <= 0) return;
    // singleRow, singleCell 이 아닌 multiple 인 경우 선택된 개수 만큼 배열의 요소가 있음    
    for (i = selectedItems.length - 1; i >= 0; i--) {
        var sItem = selectedItems[i];
        AUIGrid.removeRowByRowId(GridID, sItem.SeqNo);
    }
}

// 미검증 행 삭제
function fnDelFailRow() {
    var selectedItems = AUIGrid.getItemsByValue(GridID, "ValidationCheck", "미검증");
    if (selectedItems.length <= 0) return;

    // singleRow, singleCell 이 아닌 multiple 인 경우 선택된 개수 만큼 배열의 요소가 있음
    for (i = selectedItems.length - 1; i >= 0; i--) {
        var sItem = selectedItems[i];
        AUIGrid.removeRowByRowId(GridID, sItem.SeqNo);
    }
}

/***********************************/
//오더 등록
/***********************************/
var RegList = null;
var RegCnt = 0;
var RegProcCnt = 0;
var RegSuccessCnt = 0;
var RegFailCnt = 0;
function fnRegOrder() {
    RegList = [];

    RegList = AUIGrid.getGridData(GridID);
    RegCnt = RegList.length;
    RegProcCnt = 0;
    RegSuccessCnt = 0;
    RegFailCnt = 0;

    if (RegCnt === 0) {
        fnDefaultAlert("추가된 오더 정보가 없습니다.", "warning");
        return false;
    }

    if (!fnValidationData()) {
        fnDefaultAlert("검증이 완료되지 않은 데이터가 있습니다.", "warning");
        return false;
    }

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#OrderItemCode").val()) {
        fnDefaultAlertFocus("상품을 선택하세요.", "OrderItemCode", "warning");
        return false;
    }

    if (!$("#PickupYMD").val()) {
        fnDefaultAlertFocus("상차일을 입력하세요.", "PickupYMD", "warning");
        return false;
    }

    if (!$("#GetYMD").val()) {
        fnDefaultAlertFocus("하차일을 입력하세요.", "GetYMD", "warning");
        return false;
    }

    if (!$("#OrderClientCode").val()) {
        fnDefaultAlertFocus("발주처를 검색하세요.", "OrderClientName", "warning");
        return false;
    }

    if (!$("#OrderClientChargeName").val()) {
        fnDefaultAlertFocus("발주처 담당자명을 입력(or 검색)하세요.", "OrderClientChargeName", "warning");
        return false;
    }

    if (!$("#OrderClientChargeTelNo").val() && !$("#OrderClientChargeCell").val()) {
        fnDefaultAlertFocus("발주처 담당자의 전화번호나 휴대폰번호를 입력하세요.", "OrderClientChargeTelNo", "warning");
        return false;
    }

    if (!$("#PayClientCode").val()) {
        fnDefaultAlertFocus("청구처를 검색하세요.", "PayClientName", "warning");
        return false;
    }

    if (!$("#PayClientChargeName").val()) {
        fnDefaultAlertFocus("청구처 담당자명을 입력(or 검색)하세요.", "PayClientChargeName", "warning");
        return false;
    }

    if (!$("#PayClientChargeTelNo").val() && !$("#PayClientChargeCell").val()) {
        fnDefaultAlertFocus("청구처 담당자의 전화번호나 휴대폰번호를 입력하세요.", "PayClientChargeTelNo", "warning");
        return false;
    }

    if (!$("#PayClientChargeLocation").val()) {
        fnDefaultAlertFocus("청구사업장을 입력하세요.", "PayClientChargeLocation", "warning");
        return false;
    }

    if (!$("#GetPlace").val()) {
        fnDefaultAlertFocus("하차지를 입력(or 검색)하세요.", "GetPlace", "warning");
        return false;
    }

    /*
    if (!$("#GetPlaceChargeName").val()) {
        fnDefaultAlertFocus("하차지 담당자를 입력하세요.", "GetPlaceChargeName", "warning");
        return false;
    }
    */

    if (!$("#GetPlaceChargeTelNo").val() && !$("#GetPlaceChargeCell").val()) {
        fnDefaultAlertFocus("하차지 담당자의 전화번호나 휴대폰번호를 입력하세요.", "GetPlaceChargeTelNo", "warning");
        return false;
    }

    if (!$("#GetPlacePost").val() || !$("#GetPlaceAddr").val()) {
        fnDefaultAlertFocus("하차지 주소를 입력하세요.", "BtnSearchAddrGetPlace", "warning");
        return false;
    }

    var strConfMsg = "오더를 등록 하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnRegOrderProc", "");
    return false;
}

function fnRegOrderProc() {
    AUIGrid.showAjaxLoader(GridID);
    if (RegProcCnt >= RegCnt) {
        AUIGrid.removeAjaxLoader(GridID);

        if (RegFailCnt > 0) {
            fnDefaultAlert("일부 오더가 등록되지 않았습니다.", "warning");
        } else {
            fnDefaultAlert("총" + RegCnt + "건 중 "  + RegSuccessCnt + "건의 오더 정보가 등록되었습니다.", "success");
        }
        return false;
    }

    var RowItem = RegList[RegProcCnt];
    RowItem.CallType = "InoutGMOrderInsert";
    RowItem.CenterCode = $("#CenterCode").val();
    RowItem.OrderItemCode = $("#OrderItemCode").val();
    RowItem.PickupYMD = $("#PickupYMD").val();
    RowItem.PickupHM = $("#PickupHM").val();
    RowItem.GetYMD = $("#GetYMD").val();
    RowItem.GetHM = $("#GetHM").val();
    RowItem.OrderClientCode = $("#OrderClientCode").val();
    RowItem.OrderClientName = $("#OrderClientName").val();
    RowItem.OrderClientChargeName = $("#OrderClientChargeName").val();
    RowItem.OrderClientChargePosition = $("#OrderClientChargePosition").val();
    RowItem.OrderClientChargeTelExtNo = $("#OrderClientChargeTelExtNo").val();
    RowItem.OrderClientChargeTelNo = $("#OrderClientChargeTelNo").val();
    RowItem.OrderClientChargeCell = $("#OrderClientChargeCell").val();
    RowItem.PayClientCode = $("#PayClientCode").val();
    RowItem.PayClientName = $("#PayClientName").val();
    RowItem.PayClientChargeName = $("#PayClientChargeName").val();
    RowItem.PayClientChargePosition = $("#PayClientChargePosition").val();
    RowItem.PayClientChargeTelExtNo = $("#PayClientChargeTelExtNo").val();
    RowItem.PayClientChargeTelNo = $("#PayClientChargeTelNo").val();
    RowItem.PayClientChargeCell = $("#PayClientChargeCell").val();
    RowItem.PayClientChargeLocation = $("#PayClientChargeLocation").val();
    RowItem.GetPlaceLocalCode = $("#GetPlaceLocalCode").val();
    RowItem.GetPlaceLocalName = $("#GetPlaceLocalName").val();
    RowItem.GetPlace = $("#GetPlace").val();
    RowItem.GetPlaceChargeName = $("#GetPlaceChargeName").val();
    RowItem.GetPlaceChargePosition = $("#GetPlaceChargePosition").val();
    RowItem.GetPlaceChargeTelExtNo = $("#GetPlaceChargeTelExtNo").val();
    RowItem.GetPlaceChargeTelNo = $("#GetPlaceChargeTelNo").val();
    RowItem.GetPlaceChargeCell = $("#GetPlaceChargeCell").val();
    RowItem.GetPlacePost = $("#GetPlacePost").val();
    RowItem.GetPlaceAddr = $("#GetPlaceAddr").val();
    RowItem.GetPlaceAddrDtl = $("#GetPlaceAddrDtl").val();
    RowItem.GetPlaceFullAddr = $("#GetPlaceFullAddr").val();

    if (RowItem) {
        var strHandlerURL = "/TMS/Inout/Proc/InoutGMHandler.ashx";
        var strCallBackFunc = "fnRegOrderSuccResult";
        var strFailCallBackFunc = "fnRegOrderFailResult";
        var objParam = RowItem;
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnRegOrderSuccResult(objRes) {
    var RowItem = RegList[RegProcCnt];
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            RegSuccessCnt++;
            RowItem.ValidationCheck = "등록";
        } else {
            RegFailCnt++;
            RowItem.ValidationCheck = "실패 [사유:" + objRes[0].ErrMsg + "]";
        }
    } else {
        RegFailCnt++;
        RowItem.ValidationCheck = "실패";
    }
    RegProcCnt++;
    AUIGrid.updateRowsById(GridID, RowItem);
    setTimeout(fnRegOrderProc(), 500);
}

function fnRegOrderFailResult() {
    var RowItem = RegList[RegProcCnt];
    RegFailCnt++;
    RegProcCnt++;
    RowItem.ValidationCheck = "실패";
    AUIGrid.updateRowsById(GridID, RowItem);
    setTimeout(fnRegOrderProc(), 500);
    return false;
}

/***********************************/

function fnValidationData() {
    var chk = false;
    var subChkCnt = 0;
    var rowIndex = 0;

    var gridData = AUIGrid.getGridData(GridID);
    // 원하는 결과로 필터링
    var items = gridData.filter(function (v) {
        if (String(v.ValidationCheck).indexOf("미검증") !== -1) return true; // 1010 포함된 행만 추리기
        return false;
    });

    var msg = "";
    styleMap = [];

    for (i = 0; i < items.length; i++) {
        subChkCnt = 0;
        msg = "";
        rowIndex = AUIGrid.rowIdToIndex(GridID, items[i].SeqNo);

        if (!(items[i].Nation && items[i].Nation.replace(/ /gi, "") != "")) {
            subChkCnt++;
            fnChangeStyleFunction(rowIndex, "Nation");
            msg += msg === "" ? "PLANT 정보가 없습니다." : " / " + "PLANT 정보가 없습니다.";
        }

        if (!(items[i].LocationAlias && items[i].LocationAlias.replace(/ /gi, "") != "")) {
            subChkCnt++;
            fnChangeStyleFunction(rowIndex, "LocationAlias");
            msg += msg === "" ? "Location Alias 정보가 없습니다." : " / " + "Location Alias 정보가 없습니다.";
        }

        if (!(items[i].Shipper && items[i].Shipper.replace(/ /gi, "") != "")) {
            subChkCnt++;
            fnChangeStyleFunction(rowIndex, "Shipper");
            msg += msg === "" ? "Shipper 정보가 없습니다." : " / " + "Shipper 정보가 없습니다.";
        }

        if (!(items[i].Origin && items[i].Origin.replace(/ /gi, "") != "")) {
            subChkCnt++;
            fnChangeStyleFunction(rowIndex, "Origin");
            msg += msg === "" ? "Origin 정보가 없습니다." : " / " + "Origin 정보가 없습니다.";
        }

        if (!(items[i].OrderLocation && items[i].OrderLocation.replace(/ /gi, "") != "")) {
            subChkCnt++;
            fnChangeStyleFunction(rowIndex, "OrderLocation");
            msg += msg === "" ? "사업장 정보가 없습니다." : " / " + "사업장 정보가 없습니다.";
        }

        if (subChkCnt == 0) {
            msg = "검증";
        } else {
            msg = "미검증 : " + msg;
        }
        items[i].ValidationCheck = msg;
        AUIGrid.updateRowsById(GridID, items[i]);
    }

    AUIGrid.update(GridID);

    if (AUIGrid.getItemsByValue(GridID, "ValidationCheck", "검증").length === AUIGrid.getRowCount(GridID)) {
        chk = true;
    }

    AUIGrid.removeAjaxLoader(GridID);
    return chk;
}

function fnChangeStyleFunction(rowIndex, datafield) {
    var key = rowIndex + "-" + datafield;
    styleMap[key] = "error-column-style";
};

// 셀 스타일 함수
function fnCellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField) {
    var key = rowIndex + "-" + dataField;
    if (typeof styleMap[key] != "undefined") {
        return styleMap[key];
    }
    return null;
};