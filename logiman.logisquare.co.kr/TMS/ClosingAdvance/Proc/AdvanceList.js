window.name = "AdvanceListGrid";
// 그리드
var GridID = "#AdvanceListGrid";
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

    $("#RDepositYMD").datepicker({
        dateFormat: "yy-mm-dd",
        maxDate: GetDateToday("-")
    });

    if ($("#RClientName").length > 0) {
        fnSetAutocomplete({
            formId: "RClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/ClosingAdvance/Proc/AdvanceHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    ChargeFlag: "N",
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
                    $("#RClientCode").val(ui.item.etc.ClientCode);
                    $("#RClientName").val(ui.item.etc.ClientName);
                    $("#RDepositAmt").focus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                },
                onBlur: () => {
                    if (!$("#RClientName").val()) {
                        $("#RClientCode").val("");
                    }
                }
            }
        });
    }

    $("#RDepositAmt").on("keyup blur",
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
    fnCreateGridLayout(GridID, "AdvanceSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "fnGridSelectionChange", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 270;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 270);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 270);
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
    objGridProps.independentAllCheckBox = true;
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

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (AUIGrid.isCheckedRowById(strGID, item.DispatchSeqNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.ClosingFlag == "Y") { //마감
            if (item.ClosingFlag == "Y") {
                return "aui-grid-closing-y-row-style";
            }
        }
        return "";
    }

    objGridProps.rowCheckDisabledFunction = function (rowIndex, isChecked, item) {
        if (item.ClosingFlag == "Y") {
            return false; // false 반환하면 disabled 처리됨
        }
        return true;
    }

    objGridProps.rowCheckableFunction = function (rowIndex, isChecked, item) {
        if (item.ClosingFlag == "Y") {
            return false; // false 반환하면 disabled 처리됨
        }
        return true;
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'AdvanceListGrid');
        return;
    });

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        fnCalcMoney();
    });

    // 전체 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowAllChkClick", function (event) {
        if (event.checked) {
            var objItemsChecked = [];
            $.each(AUIGrid.getGridData(event.pid), function (index, item) {
                if (item.ClosingFlag != "Y") {
                    objItemsChecked.push(item.AdvanceSeqNo);
                }
            });
            AUIGrid.setCheckedRowsByIds(event.pid, objItemsChecked);
        } else {
            var objItemsChecked = [];
            $.each(AUIGrid.getCheckedRowItems(event.pid), function (index, item) {
                objItemsChecked.push(item.item.AdvanceSeqNo);
            });
            AUIGrid.addUncheckedRowsByIds(event.pid, objItemsChecked);
        }

        fnCalcMoney();
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
            dataField: "ClosingFlag",
            headerText: "입금여부",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DepositTypeM",
            headerText: "입금구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DepositYMD",
            headerText: "입금일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DepositClientName",
            headerText: "입금업체명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DepositNote",
            headerText: "입금비고",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClosingDate",
            headerText: "입금등록일",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ClosingAdminName",
            headerText: "입금등록자",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PayTypeM",
            headerText: "비용구분",
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
            dataField: "PayClientChargeLocation",
            headerText: "청구사업장",
            editable: false,
            width: 80,
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
            dataField: "Hawb",
            headerText: "H/AWB",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CntrNo",
            headerText: "CNTR No",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClientName",
            headerText: "업체명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ItemNameM",
            headerText: "항목",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "AdvanceOrgAmt",
            headerText: "합계금액",
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
            dataField: "AdvanceSupplyAmt",
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
            dataField: "AdvanceTaxAmt",
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
            dataField: "DepositType",
            headerText: "DepositType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DepositClosingSeqNo",
            headerText: "DepositClosingSeqNo",
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
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DepositClientCode",
            headerText: "DepositClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "AdvanceSeqNo",
            headerText: "AdvanceSeqNo",
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

    fnCommonOpenOrder(objItem);
    return false;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

// 셀렉션 체인지 이벤트 핸들러
function fnGridSelectionChange(event) {

    var items = event.selectedItems;
    var val;
    var count = items.length;
    var sum = 0;
    var msg = "";

    if (count <= 1) {
        $("#GridDataInfo").text("셀 선택 : 0, 합계 : 0");
        return;
    }

    for (i = 0; i < count; i++) {
        val = String(items[i].value).replace(/,/gi, ""); // 컴마 모두 제거
        val = Number(val);
        if (isNaN(val)) {
            continue;
        }
        sum += val;
    }

    msg = "셀 선택 : " + count + ", 합계 : " + UTILJS.Util.fnComma(sum);

    $("#GridDataInfo").text(msg);
};

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var LocationCode = [];
    var ItemCode = [];

    var strHandlerURL = "/TMS/ClosingAdvance/Proc/AdvanceHandler.ashx";
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
        CallType: "AdvanceList",
        CenterCode: $("#CenterCode").val(),
        PayType: $("#PayType").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        SearchClientType: $("#SearchClientType").val(),
        SearchClientText: $("#SearchClientText").val(),
        SearchChargeType: $("#SearchChargeType").val(),
        SearchChargeText: $("#SearchChargeText").val(),
        ClientName: $("#ClientName").val(),
        DepositClientName: $("#DepositClientName").val(),
        OrgAmt: $("#OrgAmt").val(),
        DepositAmt: $("#DepositAmt").val(),
        DepositNote: $("#DepositNote").val(),
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
        $("#GridResult").html("");
        AUIGrid.setGridData(GridID, []);
        fnCreatePagingNavigator();

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            // 페이징
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
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
            positionField: "AdvanceOrgAmt",
            dataField: "AdvanceOrgAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceSupplyAmt",
            dataField: "AdvanceSupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceTaxAmt",
            dataField: "AdvanceTaxAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/*********************************************/
//입금액 계산
function fnCalcMoney() {
    $("#BtnResetDeposit").click();

    var strPayType = "";
    var strCenterCode = "";
    var strClientCode = "";
    var strClientName = "";
    var intDiffCnt = 0;
    var intTotalMoney = 0;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length > 0) {
        $.each(CheckedItems, function (index, item) {
            if (index == 0) {
                strPayType = item.item.PayType;
                strCenterCode = item.item.CenterCode;
                strClientCode = item.item.ClientCode;
                strClientName = item.item.ClientName;
            }

            if (strPayType != item.item.PayType || strCenterCode != item.item.CenterCode || strClientCode != item.item.ClientCode) {
                intDiffCnt++;
            }

            intTotalMoney += parseInt(item.item.AdvanceOrgAmt);
        });

        if (intDiffCnt > 0) {
            return false;
        }

        $("#CenterCode").val(strCenterCode);
        $("#RPayType").val(strPayType);
        $("#RClientCode").val(strClientCode);
        $("#RClientName").val(strClientName);
        $("#RDepositAmt").val(fnMoneyComma(intTotalMoney));
    }
}

//입금 등록
var AdvanceList = null;
function fnRegDeposit() {
    var Cnt = 0;
    var Amt = 0;
    var RegAmt = $("#RDepositAmt").val();
    AdvanceList = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    var msg = "";

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#RPayType").val()) {
        fnDefaultAlertFocus("입금구분을 선택하세요.", "RPayType", "warning");
        return false;
    }

    if (!$("#RDepositYMD").val()) {
        fnDefaultAlertFocus("입금일을 선택하세요.", "RDepositYMD", "warning");
        return false;
    }

    if (!$("#RClientCode").val() || $("#RClientCode").val() === "0") {
        fnDefaultAlertFocus("입금업체명을 검색하세요.", "RClientName", "warning");
        return false;
    }

    if (!$("#RDepositAmt").val()) {
        fnDefaultAlertFocus("입금액을 입력하세요.", "RDepositAmt", "warning");
        return false;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 비용이 없습니다.", "warning");
        return false;
    }

    if (CheckedItems.length > 0) {
        $.each(CheckedItems, function (index, item) {
            if (item.item.ClosingFlag == "Y" ) {
                msg = "이미 입금된 비용이 포함되어 있습니다.";
                return false;
            }

            if ($("#CenterCode").val() != item.item.CenterCode) {
                msg = "회원사가 다른 비용이 포함되어 있습니다.";
                return false;
            }

            if ($("#RClientCode").val() != item.item.ClientCode) {
                msg = "입금업체와 비용업체가 다른 비용이 포함되어 있습니다.";
                return false;
            }

            if ($("#RPayType").val() != item.item.PayType) {
                msg = "입금구분과 비용구분이 다른 비용이 포함되어 있습니다.";
                return false;
            }

            Cnt++;
            Amt += item.item.AdvanceOrgAmt;
            
            if (AdvanceList.findIndex((e) => e === item.item.AdvanceSeqNo) === -1) {
                AdvanceList.push(item.item.AdvanceSeqNo);
            }
        });
    }

    if (msg !== "") {
        fnDefaultAlert(msg, "warning");
        return false;
    }

    RegAmt = RegAmt.replace(/,/gi, "");

    if (Amt != parseInt(RegAmt)) {
        fnDefaultAlert("선택된 비용 총액과 입금액이 다릅니다.", "warning");
        return false;
    }

    if (AdvanceList.join(",").length > 4000) {
        fnDefaultAlert("한번에 입금 등록할 수 있는 비용의 최대수를 초과했습니다.", "warning");
        return false;
    }

    fnDefaultConfirm("입금을 등록하시겠습니까?", "fnRegDepositProc", "");
    return false;
}

function fnRegDepositProc() {

    var strHandlerURL = "/TMS/ClosingAdvance/Proc/AdvanceHandler.ashx";
    var strCallBackFunc = "fnRegDepositSuccResult";
    var strFailCallBackFunc = "fnRegDepositFailResult";
    var objParam = {
        CallType: "PayDepositInsert",
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#RClientCode").val(),
        ClientName: $("#RClientName").val(),
        PayType: $("#RPayType").val(),
        DepositYMD: $("#RDepositYMD").val(),
        DepositAmt: $("#RDepositAmt").val(),
        DepositNote: $("#RDepositNote").val(),
        AdvanceSeqNos: AdvanceList.join(",")
    }
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnRegDepositSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("입금이 등록되었습니다.", "info");
            fnCallGridData(GridID);
            $("#BtnResetDeposit").click();
            return false;
        } else {
            fnRegDepositFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegDepositFailResult();
        return false;
    }
}

function fnRegDepositFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}