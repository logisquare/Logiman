window.name = "InoutGMLocationListGrid";
// 그리드
var GridID = "#InoutGMLocationListGrid";
var GridSort = [];
var strRCenterCode = "";

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

    $("#RCenterCode").on("click", function () {
        strRCenterCode = $(this).val();
    }).on("change", function () {
        if ($(this).val() !== strRCenterCode) {
            $("#RConsignorCode").val("");
            $("#RConsignorName").val("");
        }
    });

    $("#RConsignorName").on("click", function() {
        if ($(this).attr("readonly") === "readonly") {
            fnDefaultAlert("화주는 수정하실 수 없습니다.", "warning");
            return false;
        }
    });

    //상차지 주소 검색
    $("#BtnSearchAddrPickupPlace").on("click", function (e) {
        fnOpenAddress("RPickupPlace");
        return;
    });

    //화주 자동완성
    if ($("#RConsignorName").length > 0) {
        fnSetAutocomplete({
            formId: "RConsignorName",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutGMHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ConsignorList",
                    ConsignorName: request.term,
                    CenterCode: $("#RCenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#RCenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "RCenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ConsignorInfo,
                getValue: (item) => item.ConsignorName,
                onSelect: (event, ui) => {
                    $("#RConsignorCode").val(ui.item.etc.ConsignorCode);
                    $("#RConsignorName").val(ui.item.etc.ConsignorName);
                },
                onBlur: () => {
                    if (!$("#RConsignorName").val()) {
                        $("#RConsignorCode").val("");
                    }
                }
            }
        });
    }

    //상차지 자동완성
    if ($("#RPickupPlace").length > 0) {
        fnSetAutocomplete({
            formId: "RPickupPlace",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutGMHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "PlaceList",
                    PlaceName: request.term,
                    CenterCode: $("#RCenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#RCenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "RCenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.PlaceName,
                getValue: (item) => item.PlaceName,
                onSelect: (event, ui) => {
                    $("#RPickupPlace").val(ui.item.etc.PlaceName);
                    $("#RPickupPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#RPickupPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#RPickupPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#RPickupPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#RPickupPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#RPickupPlacePost").val(ui.item.etc.PlacePost);
                    $("#RPickupPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#RPickupPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#RPickupPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#RPickupPlaceLocalCode").val(ui.item.etc.LocalCode);
                    $("#RPickupPlaceLocalName").val(ui.item.etc.LocalName);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#RPickupPlace").val()) {
                        $("#RPickupPlace").val("");
                        $("#RPickupPlaceChargeName").val("");
                        $("#RPickupPlaceChargePosition").val("");
                        $("#RPickupPlaceChargeTelExtNo").val("");
                        $("#RPickupPlaceChargeTelNo").val("");
                        $("#RPickupPlaceChargeCell").val("");
                        $("#RPickupPlacePost").val("");
                        $("#RPickupPlaceAddr").val("");
                        $("#RPickupPlaceAddrDtl").val("");
                        $("#RPickupPlaceFullAddr").val("");
                        $("#RPickupPlaceLocalCode").val("");
                        $("#RPickupPlaceLocalName").val("");
                    }
                }
            }
        });
    }

    //상차지 담당자 자동완성
    if ($("#RPickupPlaceChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "RPickupPlaceChargeName",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutGMHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "PlaceChargeList",
                    PlaceChargeName: request.term,
                    CenterCode: $("#RCenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#RCenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "RCenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName,
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    $("#RPickupPlace").val(ui.item.etc.PlaceName);
                    $("#RPickupPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#RPickupPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#RPickupPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#RPickupPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#RPickupPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#RPickupPlacePost").val(ui.item.etc.PlacePost);
                    $("#RPickupPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#RPickupPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#RPickupPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#RPickupPlaceLocalCode").val(ui.item.etc.LocalCode);
                    $("#RPickupPlaceLocalName").val(ui.item.etc.LocalName);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#RPickupPlaceChargeName").val()) {
                        $("#RPickupPlaceChargeName").val("");
                        $("#RPickupPlaceChargePosition").val("");
                        $("#RPickupPlaceChargeTelExtNo").val("");
                        $("#RPickupPlaceChargeTelNo").val("");
                        $("#RPickupPlaceChargeCell").val("");
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

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "GMSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

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
            dataField: "ConsignorName",
            headerText: "화주명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "LocationAlias",
            headerText: "Location Alias",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Shipper",
            headerText: "Shipper",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Origin",
            headerText: "Origin",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
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
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargePosition",
            headerText: "(상)직급",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeTelExtNo",
            headerText: "(상)내선",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeTelNo",
            headerText: "(상)전화번호",
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
            dataField: "PickupPlaceChargeCell",
            headerText: "(상)휴대폰번호",
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
            dataField: "RegDate",
            headerText: "등록일",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "RegAdminName",
            headerText: "등록자",
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
            dataField: "UpdAdminName",
            headerText: "수정자",
            editable: false,
            width: 100,
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
            dataField: "GMSeqNo",
            headerText: "GMSeqNo",
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

    fnSetLocation(objItem);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    
    var strHandlerURL = "/TMS/Inout/Proc/InoutGMHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "ConsignorGMList",
        CenterCode: $("#CenterCode").val(),
        Origin: $("#Origin").val(),
        LocationAlias: $("#LocationAlias").val(),
        Shipper: $("#Shipper").val(),
        ConsignorName: $("#ConsignorName").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {

        $("#RecordCnt").val(0);
        $("#GridResult").html("");
        AUIGrid.setGridData(GridID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

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
            style: "aui-grid-my-column-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

function fnSetLocation(objItem) {
    fnResetLocation();

    //Hidden
    $.each($(".RegForm input[type='hidden']"),
        function (index, input) {
            var strId = $(input).attr("id");
            var strField = $(input).attr("id").substring(1, $(input).attr("id").length);
            if (eval("objItem." + strField) != null) {
                $("#" + strId).val(eval("objItem." + strField));
            }
        });

    //Textbox
    $.each($(".RegForm input[type='text']"),
        function (index, input) {
            var strId = $(input).attr("id");
            var strField = $(input).attr("id").substring(1, $(input).attr("id").length);
            if (eval("objItem." + strField) != null) {
                $("#" + strId).val(eval("objItem." + strField));
            }
        });

    $("#RCenterCode").val(objItem.CenterCode);
    $("#RCenterCode option:not(:selected)").prop("disabled", true);
    $("#RConsignorName").attr("readonly", "readonly");
    $("#BtnInsLocation").hide();
    $("#BtnUpdLocation").show();
    $("#BtnDelLocation").show();
}

function fnInsLocation() {
    var strConfMsg = "";
    var strCallType = "";
    
    if (!$("#RCenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "RCenterCode", "warning");
        return;
    }

    if (!$("#RLocationAlias").val()) {
        fnDefaultAlertFocus("Location Alias 입력하세요.", "RLocationAlias", "warning");
        return;
    }

    if (!$("#RShipper").val()) {
        fnDefaultAlertFocus("Shipper를 입력하세요.", "RShipper", "warning");
        return;
    }

    if (!$("#ROrigin").val()) {
        fnDefaultAlertFocus("Origin을 입력하세요.", "ROrigin", "warning");
        return;
    }

    if (!$("#RConsignorCode").val()) {
        fnDefaultAlertFocus("화주를 검색하세요.", "RConsignorName", "warning");
        return;
    }

    if (!$("#RPickupPlace").val()) {
        fnDefaultAlertFocus("상차지를 입력(or 검색)하세요.", "RPickupPlace", "warning");
        return;
    }
    /*
    if (!$("#RPickupPlaceChargeName").val()) {
        fnDefaultAlertFocus("상차지 담당자를 입력하세요.", "RPickupPlaceChargeName", "warning");
        return;
    }
    */

    if (!$("#RPickupPlaceChargeTelNo").val() && !$("#RPickupPlaceChargeCell").val()) {
        fnDefaultAlertFocus("상차지 담당자의 전화번호나 휴대폰번호를 입력하세요.", "RPickupPlaceChargeTelNo", "warning");
        return;
    }

    if (!$("#RPickupPlacePost").val() || !$("#RPickupPlaceAddr").val()) {
        fnDefaultAlertFocus("상차지 주소를 입력하세요.", "BtnSearchAddrPickupPlace", "warning");
        return;
    }

    strCallType = "ConsignorGMInsert";
    strConfMsg = "GM Location을 등록하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsLocationProc", fnParam);
    return;
}

function fnInsLocationProc(fnParam) {
    var strHandlerURL = "/TMS/Inout/Proc/InoutGMHandler.ashx";
    var strCallBackFunc = "fnAjaxInsLocation";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#RCenterCode").val(),
        LocationAlias: $("#RLocationAlias").val(),
        Shipper: $("#RShipper").val(),
        Origin: $("#ROrigin").val(),
        ConsignorCode: $("#RConsignorCode").val(),
        PickupPlace: $("#RPickupPlace").val(),
        PickupPlaceChargeName: $("#RPickupPlaceChargeName").val(),
        PickupPlaceChargePosition: $("#RPickupPlaceChargePosition").val(),
        PickupPlaceChargeTelExtNo: $("#RPickupPlaceChargeTelExtNo").val(),
        PickupPlaceChargeTelNo: $("#RPickupPlaceChargeTelNo").val(),
        PickupPlaceChargeCell: $("#RPickupPlaceChargeCell").val(),
        PickupPlacePost: $("#RPickupPlacePost").val(),
        PickupPlaceAddr: $("#RPickupPlaceAddr").val(),
        PickupPlaceAddrDtl: $("#RPickupPlaceAddrDtl").val(),
        PickupPlaceFullAddr: $("#RPickupPlaceFullAddr").val(),
        PickupPlaceLocalCode: $("#RPickupPlaceLocalCode").val(),
        PickupPlaceLocalName: $("#RPickupPlaceLocalName").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsLocation(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("Location이 등록되었습니다.", "info");
        fnResetLocation();
        fnCallGridData(GridID);
    }
}

function fnUpdLocation() {
    var strConfMsg = "";
    var strCallType = "";

    if (!$("#RGMSeqNo").val()) {
        fnDefaultAlert("선택된 Location정보가 없습니다.", "warning");
        return;
    }

    if (!$("#RCenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "RCenterCode", "warning");
        return;
    }

    if (!$("#RLocationAlias").val()) {
        fnDefaultAlertFocus("Location Alias 입력하세요.", "RLocationAlias", "warning");
        return;
    }

    if (!$("#RShipper").val()) {
        fnDefaultAlertFocus("Shipper를 입력하세요.", "RShipper", "warning");
        return;
    }

    if (!$("#ROrigin").val()) {
        fnDefaultAlertFocus("Origin을 입력하세요.", "ROrigin", "warning");
        return;
    }

    if (!$("#RConsignorCode").val()) {
        fnDefaultAlertFocus("화주를 검색하세요.", "RConsignorName", "warning");
        return;
    }

    if (!$("#RPickupPlace").val()) {
        fnDefaultAlertFocus("상차지를 입력(or 검색)하세요.", "RPickupPlace", "warning");
        return;
    }
    /*
    if (!$("#RPickupPlaceChargeName").val()) {
        fnDefaultAlertFocus("상차지 담당자를 입력하세요.", "RPickupPlaceChargeName", "warning");
        return;
    }
    */
    if (!$("#RPickupPlaceChargeTelNo").val() && !$("#RPickupPlaceChargeCell").val()) {
        fnDefaultAlertFocus("상차지 담당자의 전화번호나 휴대폰번호를 입력하세요.", "RPickupPlaceChargeTelNo", "warning");
        return;
    }

    if (!$("#RPickupPlacePost").val() || !$("#RPickupPlaceAddr").val()) {
        fnDefaultAlertFocus("상차지 주소를 입력하세요.", "BtnSearchAddrPickupPlace", "warning");
        return;
    }

    strCallType = "ConsignorGMUpdate";
    strConfMsg = "GM Location을 수정하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnUpdLocationProc", fnParam);
    return;
}

function fnUpdLocationProc(fnParam) {
    var strHandlerURL = "/TMS/Inout/Proc/InoutGMHandler.ashx";
    var strCallBackFunc = "fnAjaxUpdLocation";

    var objParam = {
        CallType: fnParam,
        GMSeqNo: $("#RGMSeqNo").val(),
        CenterCode: $("#RCenterCode").val(),
        LocationAlias: $("#RLocationAlias").val(),
        Shipper: $("#RShipper").val(),
        Origin: $("#ROrigin").val(),
        ConsignorCode: $("#RConsignorCode").val(),
        PickupPlace: $("#RPickupPlace").val(),
        PickupPlaceChargeName: $("#RPickupPlaceChargeName").val(),
        PickupPlaceChargePosition: $("#RPickupPlaceChargePosition").val(),
        PickupPlaceChargeTelExtNo: $("#RPickupPlaceChargeTelExtNo").val(),
        PickupPlaceChargeTelNo: $("#RPickupPlaceChargeTelNo").val(),
        PickupPlaceChargeCell: $("#RPickupPlaceChargeCell").val(),
        PickupPlacePost: $("#RPickupPlacePost").val(),
        PickupPlaceAddr: $("#RPickupPlaceAddr").val(),
        PickupPlaceAddrDtl: $("#RPickupPlaceAddrDtl").val(),
        PickupPlaceFullAddr: $("#RPickupPlaceFullAddr").val(),
        PickupPlaceLocalCode: $("#RPickupPlaceLocalCode").val(),
        PickupPlaceLocalName: $("#RPickupPlaceLocalName").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxUpdLocation(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("Location이 수정되었습니다.", "info");
        fnResetLocation();
        fnCallGridData(GridID);
    }
}

function fnDelLocation() {
    var strConfMsg = "";
    var strCallType = "";

    if (!$("#RGMSeqNo").val()) {
        fnDefaultAlert("선택된 Location정보가 없습니다.", "warning");
        return;
    }

    if (!$("#RCenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "RCenterCode", "warning");
        return;
    }

    strCallType = "ConsignorGMDelete";
    strConfMsg = "GM Location을 삭제하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnDelLocationProc", fnParam);
    return;
}

function fnDelLocationProc(fnParam) {

    var strHandlerURL = "/TMS/Inout/Proc/InoutGMHandler.ashx";
    var strCallBackFunc = "fnAjaxDelLocation";

    var objParam = {
        CallType: fnParam,
        GMSeqNo: $("#RGMSeqNo").val(),
        CenterCode: $("#RCenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxDelLocation(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("Location이 삭제되었습니다.", "info");
        fnResetLocation();
        fnCallGridData(GridID);
    }
}

function fnResetLocation() {
    $(".RegForm input").val("");
    //$(".RegForm select").val("");
    $("#RCenterCode option").prop("disabled", false);
    $("#RConsignorName").removeAttr("readonly");
    $("#BtnInsLocation").show();
    $("#BtnUpdLocation").hide();
    $("#BtnDelLocation").hide();
    return false;
}