window.name = "SaleListGrid";
// 그리드
var GridID = "#SaleListGrid";
var GridSort = [];

$(document).ready(function () {
    /* 그리드 사이즈 조정 */
    $("div.right").css("z-index", "1");
    if ($.cookie(window.name)) {
        var objSize = JSON.parse($.cookie(window.name));
        if (typeof objSize.left != "undefined" && typeof objSize.right != "undefined") {
            $("div.left").width(objSize.left + "%");
            $("li.left").width(objSize.left + "%");
            $("div.right").width(objSize.right + "%");
            $("li.right").width(objSize.right + "%");
        }
    }

    $("div.left").resizable({
        handles: "e",
        minWidth: 450,
        maxWidth: $("div.grid_list").width() - 450,
        start: function (event, ui) {
            var intMaxWidth = $("div.grid_list").width() - 450;
            if (intMaxWidth < 450) {
                intMaxWidth = 450;
            }
            $("div.left").resizable("option", "maxWidth", intMaxWidth);
        },
        resize: function (event, ui) {
            var leftWidthPer = ui.size.width / $("div.grid_type_03").width() * 100;
            var rightWidthPer = 100 - leftWidthPer;

            $("div.left").width(leftWidthPer + "%");
            $("li.left").width(leftWidthPer + "%");
            $("div.right").width(rightWidthPer + "%");
            $("li.right").width(rightWidthPer + "%");

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 250);
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 250);
        },
        stop: function (event, ui) {
            var leftWidthPer = ui.size.width / $("div.grid_type_03").width() * 100;
            var rightWidthPer = 100 - leftWidthPer;

            $("div.left").width(leftWidthPer + "%");
            $("li.left").width(leftWidthPer + "%");
            $("div.right").width(rightWidthPer + "%");
            $("li.right").width(rightWidthPer + "%");

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 250);
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 250);

            $.cookie(window.name, "{\"left\":" + leftWidthPer + ", \"right\":" + rightWidthPer +"}", { expires: 7 });
        }
    });
    /* 그리드 사이즈 조정 끝 */

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

    //업무담당
    if ($("#CsAdminName").length > 0) {
        fnSetAutocomplete({
            formId: "CsAdminName",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/ClosingSale/Proc/SaleHandler.ashx";
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

    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // Ctrl + F
        if (event.ctrlKey && event.keyCode === 70) {
            return false;
        }

        // ESC
        if (event.keyCode === 27) {
            fnSearchDialog("gridDialog", "close");
            fnSearchDialog("gridDialog2", "close");
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

    if ($("#gridDialog2").length > 0) {
        $("#LinkGridSearchClose2").on("click", function () {
            fnSearchDialog("gridDialog2", "close");
            return false;
        });

        $("#BtnGridSearch2").on("click", function () {
            fnSearchClick2();
            return false;
        });

        $("#GridSearchText2").on("keydown", function (event) {
            if (event.keyCode === 13) {
                fnSearchClick2();
                return false;
            }

            if (event.keyCode === 27) {
                fnSearchDialog("gridDialog2", "close");
                return false;
            }
        });
    }
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "PayClientCode");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 250;
    AUIGrid.resize(GridID, $("div.left").width() - 5, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 250);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 250);
        }, 100);
    });

    //그리드에 포커스
    AUIGrid.setFocus(GridID);

    // 푸터
    fnSetGridFooter(GridID);
    AUIGrid.setGridData(GridID, []);
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
    objGridProps.rowCheckToRadio = true; //체크박스 대신 라디오버튼으로 변환
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
    AUIGrid.bind(strGID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(strGID, "SaleListGrid");
        return;
    });

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        if (event.checked) {
            fnSetDetailList(event.item);
        }
    });
};

function fnSetDetailList(objItem) {

    $("#CenterCode").val(objItem.CenterCode);
    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidPayClientCode").val(objItem.PayClientCode);

    var objCheckedRow = AUIGrid.getCheckedRowItems(GridID);
    if (objCheckedRow.PayClientCode !== objItem.PayClientCode) {
        AUIGrid.setCheckedRowsByValue(GridID, "PayClientCode", objItem.PayClientCode);
    }

    if (!$("#HidCenterCode").val() || !$("#HidPayClientCode").val()) {
        return false;
    }

    AUIGrid.setGridData(GridDetailID, []);

    fnCallDetailGridData(GridDetailID);
}

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PayClientName",
            headerText: "거래처명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PayClientCorpNo",
            headerText: "사업자번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SaleOrgAmt",
            headerText: "매출합계",
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
			dataField: "SaleSupplyAmt",
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
            dataField: "SaleTaxAmt",
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
        {
            dataField: "OrderCnt",
            headerText: "오더건수",
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
            dataField: "CarryoverCnt",
            headerText: "이월건수",
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
            dataField: "ClosingOrderCnt",
            headerText: "마감건수",
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
            dataField: "ClientStatusM",
            headerText: "거래처상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClientClosingTypeM",
            headerText: "마감구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClientPayDay",
            headerText: "결제일",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClientBusinessStatusM",
            headerText: "거래상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClientTaxKindM",
            headerText: "과세구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CsAdminNames",
            headerText: "업무담당",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },        
        /*숨김필드*/
        {
            dataField: "PayClientCode",
            headerText: "PayClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
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
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    fnSetDetailList(objItem);

}

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

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    $("#hidCenterCode").val("");
    $("#hidPayClientCode").val("");
    AUIGrid.setGridData(GridDetailID, []);

    var LocationCode = [];
    var DLocationCode = [];
    var ItemCode = [];

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    $.each($("#DeliveryLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            DLocationCode.push($(el).val());
        }
    });

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            ItemCode.push($(el).val());
        }
    });

    var objParam = {
        CallType: "SaleClientList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        DeliveryLocationCodes: DLocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        CarryOverFlag: $("#ChkCarryOver").is(":checked") ? "Y" : "",
        ClosingFlag: $("#ClosingFlag").val(),
        OrderClientName: $("#OrderClientName").val(),
        PayClientName: $("#PayClientName").val(),
        PayClientChargeName: $("#PayClientChargeName").val(),
        CsAdminID: $("#CsAdminID").val(),
        ConsignorName: $("#ConsignorName").val(),
        Hawb: $("#Hawb").val()
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
            //fnCreatePagingNavigator();
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

        // 페이징
        //fnCreatePagingNavigator();

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
            positionField: "SaleOrgAmt",
            dataField: "SaleOrgAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
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
            positionField: "SaleTaxAmt",
            dataField: "SaleTaxAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "OrderCnt",
            dataField: "OrderCnt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "CarryoverCnt",
            dataField: "CarryoverCnt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "ClosingOrderCnt",
            dataField: "ClosingOrderCnt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/
// 오더 상세 목록 그리드
/**********************************************************/
var GridDetailID = "#SaleOrderListGrid";

$(document).ready(function () {
    if ($(GridDetailID).length > 0) {
        // 그리드 초기화
        fnDetailGridInit();
    }
});

function fnDetailGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDetailGridLayout(GridDetailID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDetailID, "", "", "fnDetailGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnDetailGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 250;

    AUIGrid.resize(GridDetailID, $("div.right").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 250);

        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 250);
        }, 100);
    });

    AUIGrid.bind(GridDetailID, "rowAllCheckClick", function (event) {
        fnSetDataInfo();
    });

    AUIGrid.bind(GridDetailID, "rowCheckClick", function (event) {
        fnSetDataInfo();
    });

    // 푸터
    fnSetDetailGridFooter(GridDetailID);
    AUIGrid.setGridData(GridDetailID, []);
}

function fnSetDataInfo() {
    var strDataInfo = "";
    var intSupplyAmt = 0;
    var intTaxAmt = 0;
    var intOrgAmt = 0;
    //선택오더(건수, 공급가액, 부가세, 합계금액)
    var objCheckedRows = AUIGrid.getCheckedRowItems(GridDetailID);
    if (objCheckedRows.length > 0) {
        strDataInfo = fnMoneyComma(objCheckedRows.length.toString()) + "건, ";
        $.each(objCheckedRows, function (index, item) {
            intSupplyAmt += item.item.SaleSupplyAmt;
            intTaxAmt += item.item.SaleTaxAmt;
            intOrgAmt += item.item.SaleOrgAmt;
        });

        strDataInfo += "공급가액 : " + fnMoneyComma(intSupplyAmt.toString()) + "원, ";
        strDataInfo += "부가세 : " + fnMoneyComma(intTaxAmt.toString()) + "원, ";
        strDataInfo += "합계 : " + fnMoneyComma(intOrgAmt.toString()) + "원";
    }

    $("#GridDataInfo2").text((strDataInfo == "" ? "" : "선택 : ") + strDataInfo);
}


//기본 레이아웃 세팅
function fnCreateDetailGridLayout(strGID, strRowIdField) {

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
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (AUIGrid.isCheckedRowById(strGID, item.SeqNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.ClosingFlag === "Y") { //마감
            return "aui-grid-closing-y-row-style";
        } else if (item.SaleCarryoverFlag === "Y") { //이월
            return "aui-grid-carryover-y-row-style";
        }

        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDetailDefaultColumnLayout()");
    var objOriLayout = fnGetDetailDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(strGID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(strGID, "SaleOrderListGrid");
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDetailDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
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
            dataField: "ClosingFlag",
            headerText: "마감여부",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClosingKindM",
            headerText: "청구방식",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillStatusM",
            headerText: "계산서발행상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SaleClosingSeqNo",
            headerText: "전표번호",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (value === "0") {
                    return "";
                }
                return value;
            }
        },
        {
            dataField: "ClosingAdminName",
            headerText: "마감자",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClosingDate",
            headerText: "마감일",
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
            dataField: "DeliveryLocationCodeM",
            headerText: "배송사업장",
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
            viewstatus: false
        },
        {
            dataField: "PayClientChargeLocation",
            headerText: "청구사업장",
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
            viewstatus: true
        },
        {
            dataField: "PickupPlace",
            headerText: "상차지",
            editable: false,
            width: 150,
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
            viewstatus: true
        },
        {
            dataField: "GetPlace",
            headerText: "하차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SaleCarryoverFlag",
            headerText: "이월여부",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
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
            dataField: "SaleOrgAmt",
            headerText: "매출합계",
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
            dataField: "SaleSupplyAmt",
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
            dataField: "SaleTaxAmt",
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
            dataField: "SumAmt",
            headerText: "매출+선급금",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) { 
                return Number(item.SaleOrgAmt + item.AdvanceSupplyAmt3);
            }
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 120,
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
            dataField: "OrderItemCode",
            headerText: "OrderItemCode",
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
            dataField: "PayClientCode",
            headerText: "PayClientCode",
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
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnDetailGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridDetailID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return false;
    }

    if (objItem.ClosingFlag === "Y") {
        fnOpenRightSubLayer("매출 마감 상세", "/TMS/ClosingSale/SaleClosingDetailList?ClosingCenterCode=" + objItem.CenterCode + "&SaleClosingSeqNo=" + objItem.SaleClosingSeqNo, "500px", "700px", "80%");
        return false;
    }

    fnCommonOpenOrder(objItem);
    return false;
}

// 키 다운 핸들러 - 사용자 정의(페이지 기능별 수정 필요)
function fnDetailGridKeyDown(event) {
    // Ctrl + F
    if (event.ctrlKey && event.keyCode === 70) {
        fnSearchDialog("gridDialog2", "open");
        return false;
    }

    // ESC
    if (event.keyCode === 27) {
        fnSearchDialog("gridDialog2", "close");
        return false;
    }
    return true;
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDetailGridData(strGID) {

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleHandler.ashx";
    var strCallBackFunc = "fnDetailGridSuccResult";

    var LocationCode = [];
    var DLocationCode = [];
    var ItemCode = [];

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    $.each($("#DeliveryLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            DLocationCode.push($(el).val());
        }
    });

    $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            ItemCode.push($(el).val());
        }
    });

    var objParam = {
        CallType: "SaleClientOrderList",
        CenterCode: $("#HidCenterCode").val(),
        PayClientCode: $("#HidPayClientCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        DeliveryLocationCodes: DLocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        CarryOverFlag: $("#ChkCarryOver").is(":checked") ? "Y" : "",
        ClosingFlag: $("#ClosingFlag").val(),
        OrderClientName: $("#OrderClientName").val(),
        PayClientName: $("#PayClientName").val(),
        PayClientChargeName: $("#PayClientChargeName").val(),
        PayClientChargeLocation: $("#PayClientChargeLocation").val(),
        ConsignorName: $("#ConsignorName").val(),
        Hawb: $("#Hawb").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDetailGridSuccResult(objRes) {

    if (objRes) {
        $("#GridResult2").html("");
        $("#GridDataInfo2").html("");

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridDetailID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#GridResult2").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridDetailID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridDetailID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDetailGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
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
        positionField: "SaleOrgAmt",
        dataField: "SaleOrgAmt",
        operation: "SUM",
        formatString: "#,##0",
        postfix: "원",
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
        positionField: "SaleTaxAmt",
        dataField: "SaleTaxAmt",
        operation: "SUM",
        formatString: "#,##0",
        postfix: "원",
        style: "aui-grid-text-right"
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
        positionField: "SumAmt",
        dataField: "SumAmt",
        operation: "SUM",
        formatString: "#,##0",
        postfix: "원",
        style: "aui-grid-text-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}
/**********************************************************/

//개별마감
var OrderList = null;
var OrderCnt = 0;
var OrderProcCnt = 0;
var OrderSuccessCnt = 0;
var OrderFailCnt = 0;
function fnClosingEach() {
    OrderList = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var closingCnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag == "Y") {
            closingCnt++;
        }

        if (item.item.ClosingFlag != "Y" && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidPayClientCode").val() == item.item.PayClientCode) {
            cnt++;
            OrderList.push(item.item);
        }
    });

    if (closingCnt > 0) {
        fnDefaultAlert("선택한 오더 중 마감된 오더가 포함되어 있습니다.", "warning");
        return false;
    }

    if (cnt <= 0) {
        fnDefaultAlert("마감할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    OrderCnt = cnt;
    OrderProcCnt = 0;
    OrderSuccessCnt = 0;
    OrderFailCnt = 0;
    fnDefaultConfirm("오더를 개별마감 하시겠습니까?", "fnClosingEachProc", "");
    return false;
}

function fnClosingEachProc(){

    AUIGrid.showAjaxLoader(GridDetailID);
    if (OrderProcCnt >= OrderCnt) {
        AUIGrid.removeAjaxLoader(GridDetailID);
        fnClosingEachEnd();
        return;
    }

    var RowOrder = OrderList[OrderProcCnt];

    if (RowOrder) {
        var strHandlerURL = "/TMS/ClosingSale/Proc/SaleHandler.ashx";
        var strCallBackFunc = "fnClosingEachSuccResult";
        var strFailCallBackFunc = "fnClosingEachFailResult";
        var objParam = {
            CallType: "SaleClosingInsert",
            CenterCode: RowOrder.CenterCode,
            OrderNos1: RowOrder.OrderNo,
            SaleOrgAmt: RowOrder.SaleOrgAmt
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnClosingEachSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            OrderSuccessCnt++;
        } else {
            OrderFailCnt++;
        }
    } else {
        OrderFailCnt++;
    }

    OrderProcCnt++;
    setTimeout(fnClosingEachProc(), 500);
}

function fnClosingEachFailResult() {
    OrderProcCnt++;
    OrderFailCnt++;
    setTimeout(fnClosingEachProc(), 500);
    return false;
}

function fnClosingEachEnd() {
    fnDefaultAlert("총 " + OrderCnt + "건 중 " + OrderSuccessCnt + "건의 오더가 마감되었습니다.", "info", "fnCallDetailGridData", GridDetailID);
    return false;
}

//일괄마감
var OrderList1 = null;
var OrderList2 = null;
var OrderList3 = null;
var OrderList4 = null;
var OrderList5 = null;
var intDomesticValidType = 0; //상품 체크 내수
var intInoutValidType = 0; //상품 체크 수출입
var intContainerValidType = 0; //상품 체크 컨테이너
var PayClientCode = 0; //청구처 코드
var strDateFrom = "";//상차일 첫번째
var strDateTo = "";//상차일 마지막
function fnClosingAll() {
    OrderList = [];
    OrderList1 = [];
    OrderList2 = [];
    OrderList3 = [];
    OrderList4 = [];
    OrderList5 = [];
    var SaleOrgAmt = 0;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var arrCnt = 1;
    var closingCnt = 0;
    intDomesticValidType = 0; //상품 체크 내수
    intInoutValidType = 0; //상품 체크 수출입
    intContainerValidType = 0; //상품 체크 컨테이너
    PayClientCode = 0; //거래처 코드 초기화
    strDateFrom = "";//상차일 첫번째
    strDateTo = "";//상차일 마지막

    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag == "Y") {
            closingCnt++;
        }

        if (item.item.ClosingFlag !== "Y" && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidPayClientCode").val() == item.item.PayClientCode) {
            if (OrderList.findIndex((e) => e === item.item.OrderNo) === -1) {

                if ((eval("OrderList" + arrCnt).join(",") + "," + item.item.OrderNo).length > 4000) {
                    arrCnt++;
                    if (arrCnt > 5) {
                        fnDefaultAlert("마감할 수 있는 오더 수를 초과하였습니다.", "warning");
                        return false;
                    }
                }

                cnt++;
                eval("OrderList").push(item.item.OrderNo);
                eval("OrderList" + arrCnt).push(item.item.OrderNo);
                SaleOrgAmt += item.item.SaleOrgAmt;

                //내수 체크
                if (item.item.OrderItemCode === "OA007") {
                    intDomesticValidType = 1;
                }
                if (item.item.OrderItemCode === "OA005" || item.item.OrderItemCode === "OA006") {
                    intContainerValidType = 1;
                }
                if (item.item.OrderItemCode === "OA001" ||
                    item.item.OrderItemCode === "OA002" ||
                    item.item.OrderItemCode === "OA003" ||
                    item.item.OrderItemCode === "OA004" ||
                    item.item.OrderItemCode === "OA008" ||
                    item.item.OrderItemCode === "OA009")
                {
                    intInoutValidType = 1;
                }
                
                PayClientCode = CheckedItems[0].item.PayClientCode;
                strDateFrom = CheckedItems[0].item.PickupYMD;
                strDateTo = CheckedItems[CheckedItems.length - 1].item.PickupYMD;
            }
        }
    });

    if (closingCnt > 0) {
        fnDefaultAlert("선택한 오더 중 마감된 오더가 포함되어 있습니다.", "warning");
        return false;
    }

    if (cnt <= 0) {
        fnDefaultAlert("마감할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    fnDefaultConfirm("오더를 일괄마감 처리 하시겠습니까?", "fnClosingAllProc", SaleOrgAmt);
    return false;
}

function fnClosingAllProc(intSaleOrgAmt) {
    if (OrderList1.join(",") === "" && OrderList2.join(",") === "" && OrderList3.join(",") === "" && OrderList4.join(",") === "" && OrderList5.join(",") === "") {
        fnDefaultAlert("마감할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleHandler.ashx";
    var strCallBackFunc = "fnClosingAllSuccResult";
    var strFailCallBackFunc = "fnClosingAllFailResult";
    var objParam = {
        CallType: "SaleClosingInsert",
        CenterCode: $("#HidCenterCode").val(),
        OrderNos1: OrderList1.join(","),
        OrderNos2: OrderList2.join(","),
        OrderNos3: OrderList3.join(","),
        OrderNos4: OrderList4.join(","),
        OrderNos5: OrderList5.join(","),
        SaleOrgAmt: intSaleOrgAmt
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnClosingAllSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultConfirm("오더가 마감되었습니다.<br>내역서 메일발송을 진행 하시겠습니까?", "fnGoPrintPage", objRes[0].SaleClosingSeqNo, "", "", "info");
            fnCallDetailGridData(GridDetailID);
            return false;
        } else {
            fnClosingAllFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnClosingAllFailResult();
        return false;
    }
}

function fnGoPrintPage(SaleClosingSeqNo) {
    if ((intDomesticValidType + intContainerValidType + intInoutValidType) > 1) {
        fnDefaultAlert("상품이 서로 다른 오더가 포함되어있습니다.");
        return;
    } else {
        var postData = {
            CenterCode: $("#CenterCode").val(),
            ClientCode: PayClientCode,
            SaleClosingSeqNo: SaleClosingSeqNo
        };

        if (intDomesticValidType === 1) {
            fnOpenWindowWithPost("/TMS/Common/OrderDomesticPrint", postData);
        } else if (intInoutValidType === 1) {
            fnOpenWindowWithPost("/TMS/Common/OrderInoutPrintPeriod", postData);
        } else if (intContainerValidType === 1) {
            fnOpenWindowWithPost("/TMS/Common/OrderContainerPrintPeriod", postData);
        }
    }
    if (intValidType === 0) {
        //상품 구분해서 경로 분기처리
        
    } else {
        fnDefaultAlert("상품이 서로 다른 오더가 포함되어있습니다.");
        return;
    }
}

function fnClosingAllFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//마감취소
function fnCnlClosing() {
    var ClosingList = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 마감 전표가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var notClosingCnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag != "Y") {
            notClosingCnt++;
        }

        if (item.item.ClosingFlag == "Y" && !(item.item.BillStatus == 2 || item.item.BillStatus == 3) && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidPayClientCode").val() == item.item.PayClientCode) {
            if (ClosingList.findIndex((e) => e  === item.item.SaleClosingSeqNo) === -1)
            {
                cnt++;
                ClosingList.push(item.item.SaleClosingSeqNo);
            }
        }
    });

    if (notClosingCnt > 0) {
        fnDefaultAlert("선택한 오더 중 마감되지 않은 오더가 포함되어 있습니다.", "warning");
        return false;
    }

    if (cnt <= 0) {
        fnDefaultAlert("마감취소할 수 있는 전표가 없습니다.", "warning");
        return false;
    }

    if (ClosingList.join(",").length > 4000) {
        fnDefaultAlert("마감취소할 수 있는 전표 수를 초과하였습니다.", "warning");
        return false;
    }

    fnDefaultConfirm("마감취소를 진행 하시겠습니까?", "fnCnlClosingProc", ClosingList);
    return false;
}

function fnCnlClosingProc(arrClosingList) {
    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleHandler.ashx";
    var strCallBackFunc = "fnCnlClosingSuccResult";
    var strFailCallBackFunc = "fnCnlClosingFailResult";
    var objParam = {
        CallType: "SaleClosingCancel",
        CenterCode: $("#HidCenterCode").val(),
        SaleClosingSeqNos: arrClosingList.join(","),
        CnlReason: $("#CnlReason").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnCnlClosingSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("마감이 취소되었습니다.", "info");
            fnCallDetailGridData(GridDetailID);
            return false;
        } else {
            fnCnlClosingFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnCnlClosingFailResult();
        return false;
    }
}

function fnCnlClosingFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//이월처리
function fnSetCarryover() {
    OrderList = [];
    OrderList1 = [];
    OrderList2 = [];
    OrderList3 = [];
    OrderList4 = [];
    OrderList5 = [];

    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var closingCnt = 0;
    var arrCnt = 1;
    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag == "Y") {
            closingCnt++;
            return false;
        }

        if (item.item.ClosingFlag !== "Y" && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidPayClientCode").val() == item.item.PayClientCode) {
            if (OrderList.findIndex((e) => e === item.item.OrderNo) === -1) {
                cnt++;
                eval("OrderList").push(item.item.OrderNo);
            }
        }
    });

    if (closingCnt > 0) {
        fnDefaultAlert("선택한 오더 중 마감된 오더가 포함되어 있습니다.", "warning");
        return false;
    }

    if (cnt <= 0) {
        fnDefaultAlert("이월할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (cnt > 1000) {
        fnDefaultAlert("최대 1,000건 이월 가능합니다", "warning");
        const arrOrderNosRemove = OrderList.slice(1000, OrderList.length);
        AUIGrid.addUncheckedRowsByValue(GridDetailID, "OrderNo", arrOrderNosRemove);
        fnSetDataInfo();
        return false;
    }

    OrderList = [];
    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag !== "Y" && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidPayClientCode").val() == item.item.PayClientCode) {
            if (OrderList.findIndex((e) => e === item.item.OrderNo) === -1) {
                if ((eval("OrderList" + arrCnt).join(",") + "," + item.item.OrderNo).length > 4000) {
                    arrCnt++;
                }

                if (arrCnt <= 5) {
                    eval("OrderList").push(item.item.OrderNo);
                    eval("OrderList" + arrCnt).push(item.item.OrderNo);
                }
            }
        }
    });

    fnDefaultConfirm("오더를 이월 처리 하시겠습니까?", "fnSetCarryoverProc", OrderList);
    return false;
}

function fnSetCarryoverProc(arrOrderList) {
    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleHandler.ashx";
    var strCallBackFunc = "fnSetCarryoverSuccResult";
    var strFailCallBackFunc = "fnSetCarryoverFailResult";
    var objParam = {
        CallType: "SaleCarryoverUpdate",
        CenterCode: $("#HidCenterCode").val(),
        OrderNos1: OrderList1.join(","),
        OrderNos2: OrderList2.join(","),
        OrderNos3: OrderList3.join(","),
        OrderNos4: OrderList4.join(","),
        OrderNos5: OrderList5.join(",")
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}


function fnSetCarryoverSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("총 " + objRes[0].TotalCnt + "건 중 " + objRes[0].SuccessCnt + "건의 오더가 이월 되었습니다.", "info");
            fnCallDetailGridData(GridDetailID);
            return false;
        } else {
            fnSetCarryoverFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetCarryoverFailResult();
        return false;
    }
}

function fnSetCarryoverFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//이월처리취소
function fnSetCarryoverDel() {
    OrderList = [];
    OrderList1 = [];
    OrderList2 = [];
    OrderList3 = [];
    OrderList4 = [];
    OrderList5 = [];

    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var closingCnt = 0;
    var arrCnt = 1;
    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag == "Y") {
            closingCnt++;
            return false;
        }

        if (item.item.ClosingFlag !== "Y" && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidPayClientCode").val() == item.item.PayClientCode) {
            if (OrderList.findIndex((e) => e === item.item.OrderNo) === -1) {
                cnt++;
                eval("OrderList").push(item.item.OrderNo);
            }
        }
    });

    if (closingCnt > 0) {
        fnDefaultAlert("선택한 오더 중 마감된 오더가 포함되어 있습니다.", "warning");
        return false;
    }

    if (cnt <= 0) {
        fnDefaultAlert("이월취소할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (cnt > 1000) {
        fnDefaultAlert("최대 1,000건 이월 취소 가능합니다", "warning");
        const arrOrderNosRemove = OrderList.slice(1000, OrderList.length);
        AUIGrid.addUncheckedRowsByValue(GridDetailID, "OrderNo", arrOrderNosRemove);
        fnSetDataInfo();
        return false;
    }

    OrderList = [];
    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag !== "Y" && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidPayClientCode").val() == item.item.PayClientCode) {
            if (OrderList.findIndex((e) => e === item.item.OrderNo) === -1) {
                if ((eval("OrderList" + arrCnt).join(",") + "," + item.item.OrderNo).length > 4000) {
                    arrCnt++;
                }

                if (arrCnt <= 5) {
                    eval("OrderList").push(item.item.OrderNo);
                    eval("OrderList" + arrCnt).push(item.item.OrderNo);
                }
            }
        }
    });


    fnDefaultConfirm("오더를 이월 취소 처리 하시겠습니까?", "fnSetCarryoverDelProc", OrderList);
    return false;
}

function fnSetCarryoverDelProc(arrOrderList) {
    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleHandler.ashx";
    var strCallBackFunc = "fnSetCarryoverDelSuccResult";
    var strFailCallBackFunc = "fnSetCarryoverDelFailResult";
    var objParam = {
        CallType: "SaleCarryoverDelete",
        CenterCode: $("#HidCenterCode").val(),
        OrderNos1: OrderList1.join(","),
        OrderNos2: OrderList2.join(","),
        OrderNos3: OrderList3.join(","),
        OrderNos4: OrderList4.join(","),
        OrderNos5: OrderList5.join(",")
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}


function fnSetCarryoverDelSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("총 " + objRes[0].TotalCnt + "건 중 " + objRes[0].SuccessCnt + "건의 오더가 이월 취소 되었습니다.", "info");
            fnCallDetailGridData(GridDetailID);
            return false;
        } else {
            fnSetCarryoverDelFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetCarryoverDelFailResult();
        return false;
    }
}

function fnSetCarryoverDelFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

/**********************************************/
//그리드 관련 추가
/**********************************************/
// 검색 버튼 클릭
function fnSearchClick2() {
    var dataField = document.getElementById("GridSearchDataField2").value;
    var term = document.getElementById("GridSearchText2").value;

    var options = {
        direction: true, //document.getElementById("direction").checked, // 검색 방향  (true : 다음, false : 이전 검색)
        ChkCaseSensitive: document.getElementById("ChkCaseSensitive2").checked, // 대소문자 구분 여부 (true : 대소문자 구별, false :  무시)
        wholeWord: false, // document.getElementById("wholeWord").checked, // 온전한 단어 여부
        wrapSearch: true // document.getElementById("wrapSearch").checked // 끝에서 되돌리기 여부
    };

    // 검색 실시
    //options 를 지정하지 않으면 기본값이 적용됨(기본값은 direction : true, wrapSearch : true)
    if (dataField == "ALL") {
        AUIGrid.searchAll(GridDetailID, term, options);
    } else {
        AUIGrid.search(GridDetailID, dataField, term, options);
    }
};

//항목관리 팝업 Open
function fnGridColumnManage2(strGridID) {
    fnGridColumnSetting2("GRID", strGridID);
    $("#GRID_COLUMN_LAYER2").slideDown(500);
}

function fnGridColumnSetting2(obj, strGridID) {
    var ColumnData = fnGetDetailDefaultColumnLayout();
    var columnLayout = AUIGrid.getColumnLayout("#" + strGridID);
    var ColumnHtml = "";
    var chacked = "";

    if (!columnLayout) {
        for (var i = 0; i < ColumnData.length; i++) {
            if (ColumnData[i].viewstatus === true) {
                ColumnHtml += "<input type=\"checkbox\" class=\"gird_check\" id=\"GridColumn" + ColumnData[i].dataField + "\" value=\"" + ColumnData[i].dataField + "\" onclick=\"fnCheckboxChangeHandler(event,'" + strGridID + "')\" checked><label for=\"GridColumn" + ColumnData[i].dataField + "\"><span></span>" + ColumnData[i].headerText + "</label></br>";
            }
        }
    } else {
        for (var j = 0; j < columnLayout.length; j++) {
            if (columnLayout[j].visible === false) {
                chacked = "";
            } else {
                chacked = "checked";
            }
            if (columnLayout[j].viewstatus === true) {
                ColumnHtml += "<input type=\"checkbox\" class=\"gird_check\" id=\"GridColumn" + columnLayout[j].dataField + "\" value=\"" + columnLayout[j].dataField + "\" onclick=\"fnCheckboxChangeHandler(event,'" + strGridID + "')\" " + chacked + "><label for=\"GridColumn" + columnLayout[j].dataField + "\"><span></span>" + columnLayout[j].headerText + "</label><br/>";
            }
        }
    }
    $("#GridColumn2").html(ColumnHtml);

    if ($("#GridColumn2 input[type=checkbox]:checked").length === $("#GridColumn2 input[type=checkbox]").length) {
        $("#AllGridColumnCheck2").prop("checked", true);
    } else {
        $("#AllGridColumnCheck2").prop("checked", false);
    }
}

//항목 전체체크/해제
function fnColumnChkAll2(strGridID) {
    var ColumnId = "#GridColumn2";

    if ($("#AllGridColumnCheck2").is(":checked")) {
        $(ColumnId + " input[type=checkbox]").prop("checked", true);
        $.each($(ColumnId + " input[type=checkbox]"), function (index, item) {
            AUIGrid.showColumnByDataField("#" + strGridID, $(item).val());
        });
    } else {
        $(ColumnId + " input[type=checkbox]").prop("checked", false);
        $.each($(ColumnId + " input[type=checkbox]"), function (index, item) {
            AUIGrid.hideColumnByDataField("#" + strGridID, $(item).val());
        });
    }
}

function fnCloseColumnLayout2(strGridID) {

    var GridColumnChangeChecked = false;
    var OriColumnLayout = fnLoadColumnLayout(strGridID, "fnGetDetailDefaultColumnLayout()");
    var CurrentColumnLayout = AUIGrid.getColumnLayout("#" + strGridID);

    $.each(CurrentColumnLayout, function (index, item) {
        if (item.viewstatus === true) {
            var itemVisible = typeof (item.visible) === "undefined" ? true : item.visible;

            var oriItem = OriColumnLayout.find(e => e.dataField === item.dataField);
            if (oriItem) {
                var oriItemVisible = typeof (oriItem.visible) === "undefined" ? true : oriItem.visible;
                if (itemVisible !== oriItemVisible) {
                    GridColumnChangeChecked = true;
                    return false;
                }
            }
        }
    });

    $("#GridColumn2").html("");

    if (GridColumnChangeChecked) {
        fnDefaultConfirm("항목 변경사항이 있습니다. 적용하시겠습니까?", "fnCloseColumnLayoutTrue2", { GridID: strGridID }, "fnCloseColumnLayoutFalse2", { GridID: strGridID });
    } else {
        $("#GRID_COLUMN_LAYER2").hide();
    }
}

function fnCloseColumnLayoutTrue2(objParam) {
    var strGridID = objParam.GridID;
    fnSaveColumnLayout("#" + strGridID, strGridID);
    $("#GRID_COLUMN_LAYER2").hide();
}

function fnCloseColumnLayoutFalse2(objParam) {
    var strGridID = objParam.GridID;
    var ColumnData = $("#GridColumn2 input[type=checkbox]:checked").length;
    var GridColumnChangeLen = $("#GridColumn2 input[type=checkbox]").length;
    var GridColumnChangeChecked = $("#GridColumn2 input[type=checkbox]:checked").length;

    fnGridColumnSetting();
    if (GridColumnChangeChecked > ColumnData) {
        for (var i = 1; i < GridColumnChangeLen; i++) {
            if (!$("#GridColumn2 input[type=checkbox]")[i].checked) {
                AUIGrid.hideColumnByDataField("#" + strGridID, $("#GridColumn2 input[type=checkbox]")[i].value);
            }
        }
    } else {
        for (var j = 0; j < ColumnData; j++) {
            AUIGrid.showColumnByDataField("#" + strGridID, $("#GridColumn2 input[type=checkbox]:checked")[j].value);
        }
    }
    $("#GRID_COLUMN_LAYER2").hide();

}

function fnSaveColumnCustomLayout2(strGridID) {
    fnSaveColumnLayout("#" + strGridID, strGridID);
    $("#GRID_COLUMN_LAYER2").hide();
    $("#GridColumn2").html("");
}
/**********************************************/

/**********************************************/
//출력물
/**********************************************/
function fnDomesticPrint() {
    var intValidType = 0;
    var OrderNo = [];
    var ClientCode = 0;
    var OrderList = [];
    var OrderList1 = [];
    var OrderList2 = [];
    var arrCnt = 1;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사 선택 후 오더를 조회해주세요.", "CenterCode", "warning");
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

        if (item.item.OrderItemCode !== "OA007") {
            intValidType = 3;
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
    }

    if (intValidType === 3) {
        fnDefaultAlert("내수 오더만 선택가능합니다.<br>오더의 상품을 확인하세요.", "warning");
        return false;
    }

    ClientCode = CheckedItems[0].item.PayClientCode;

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

function fnInoutPrint() {
    var intValidType = 0;
    var OrderList = [];
    var OrderList1 = [];
    var OrderList2 = [];
    var arrCnt = 1;
    var ClientCode = 0;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("회원사 선택 후 오더를 조회해주세요..", "warning");
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

        if (item.item.OrderItemCode === "OA007" || item.item.OrderItemCode === "OA005" || item.item.OrderItemCode === "OA006") {
            intValidType = 3;
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
    }

    if (intValidType === 3) {
        fnDefaultAlert("수출입 오더만 선택가능합니다.<br>오더의 상품을 확인하세요.", "warning");
        return false;
    }

    ClientCode = CheckedItems[0].item.PayClientCode;

    var postData = {
        CenterCode: $("#CenterCode").val(),
        ClientCode: ClientCode,
        OrderNos1: OrderList1,
        OrderNos2: OrderList2
    };

    fnOpenWindowWithPost("/TMS/Common/OrderInoutPrintPeriod", postData);
    return;
}

function fnContainerPrint() {
    var intValidType = 0;
    var OrderList = [];
    var OrderList1 = [];
    var OrderList2 = [];
    var arrCnt = 1;
    var ClientCode = 0;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridDetailID);

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

        if (item.item.OrderItemCode !== "OA005" && item.item.OrderItemCode !== "OA006" && item.item.OrderItemCode !== "TM010") {
            intValidType = 3;
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
    }

    if (intValidType === 3) {
        fnDefaultAlert("컨테이너 오더만 선택가능합니다.<br>오더의 상품을 확인하세요.", "warning");
        return false;
    }

    ClientCode = CheckedItems[0].item.PayClientCode;

    var postData = {
        CenterCode: $("#CenterCode").val(),
        ClientCode: ClientCode,
        OrderNos1: OrderList1,
        OrderNos2: OrderList2
    };

    fnOpenWindowWithPost("/TMS/Common/OrderContainerPrintPeriod", postData);
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
    newForm.append($("<input/>", { type: "hidden", name: "SaleClosingSeqNo", value: objPostData.SaleClosingSeqNo }));
    newForm.append($("<input/>", { type: "hidden", name: "CenterCode", value: objPostData.CenterCode }));
    newForm.append($("<input/>", { type: "hidden", name: "ClientCode", value: objPostData.ClientCode }));

    // 새 창에서 폼을 열기
    window.open("", "InoutList", "width=1050, height=900, scrollbars=Yes");
    newForm.appendTo("body");
    newForm.submit();
    newForm.remove();
}