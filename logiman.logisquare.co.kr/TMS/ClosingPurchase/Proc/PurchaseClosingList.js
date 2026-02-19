window.name = "PurchaseClosingListGrid";
// 그리드
var GridID = "#PurchaseClosingListGrid";
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

    $("#PopOtherPaySendPlanYMD").datepicker({
        dateFormat: "yy-mm-dd"
    });

    $("#PopSendPlanYMD").datepicker({
        dateFormat: "yy-mm-dd",
        minDate: GetDateToday("-")
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
    fnCreateGridLayout(GridID, "PurchaseClosingSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 210;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 210);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 210);
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
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        /*
        if (AUIGrid.isCheckedRowById(GridID, item.OrderNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.BondedFlag === "Y" && item.OrderStatusM !== "등록") {
            return "aui-grid-bonded-y-row-style";
        } else if (item.BondedFlag === "Y" && item.OrderStatusM === "등록") {
            return "aui-grid-bonded-y-no-accept-row-style";
        } else if (item.BondedFlag !== "Y" && item.OrderStatusM === "등록") {
            return "aui-grid-no-accept-row-style";
        }
        */

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
        fnSaveColumnLayoutAuto(GridID, 'PurchaseClosingListGrid');
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
            dataField: "PurchaseClosingSeqNo",
            headerText: "전표번호",
            editable: false,
            width: 150,            
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
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComKindM",
            headerText: "법인여부",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComCeoName",
            headerText: "대표자명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus:true
        },
        {
            dataField: "ComStatusM",
            headerText: "업체상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComTaxKindM",
            headerText: "과세구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComTaxMsg",
            headerText: "과세구분상세",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComUpdYMD",
            headerText: "과세변경일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CardAgreeFlag",
            headerText: "카드결제동의여부",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CardAgreeYMD",
            headerText: "카드결제동의일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
		{
			dataField: "OrgAmt",
			headerText: "매입합계",
			editable: false,
			width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SupplyAmt",
            headerText: "공급가액",
            editable: false,
            width: 80,
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
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "DeductAmt",
            headerText: "총공제금액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "InputDeductAmt",
            headerText: "공제금액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "DeductReason",
            headerText: "공제사유",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            style: "aui-grid-text-left",
            viewstatus: false
        },
        {
            dataField: "InsureFlag",
            headerText: "산재보험적용",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DriverInsureAmt",
            headerText: "산재보험료",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SendAmt",
            headerText: "송금예정액",
            editable: false,
            width: 80,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "PickupYMDTo",
            headerText: "최종상차일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillStatusM",
            headerText: "발행상태",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "BillKindM",
            headerText: "발행구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillWrite",
            headerText: "계산서작성일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillYMD",
            headerText: "계산서발행일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BtnRegBill",
            headerText: "계산서",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                onClick: function (event) {
                    fnOpenBill(event.item);
                }
            },
            viewstatus: false
        },
        {
            dataField: "NtsConfirmNum",
            headerText: "국세청승인번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BankName",
            headerText: "은행명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SearchAcctNo",
            headerText: "계좌번호(끝4자리)",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "AcctName",
            headerText: "예금주",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BtnRegAcct",
            headerText: "계좌등록",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "등록",
                onClick: function (event) {
                    fnOpenAcctNo(event.item);
                }
            },
            viewstatus: false
        },
        {
            dataField: "SendTypeM",
            headerText: "결제방식",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SendStatusM",
            headerText: "송금상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SendPlanYMD",
            headerText: "송금예정일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendYMD",
            headerText: "실제송금일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendBankName",
            headerText: "송금-은행명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendSearchAcctNo",
            headerText: "송금-계좌번호(끝4자리)",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SendAcctName",
            headerText: "송금-예금주",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BtnCnlOtherPay",
            headerText: "별도송금",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "송금취소",
                onClick: function (event) {
                    fnCnlOtherPay(event.item);
                },
                disabledFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    return item.SendType != 6;
                }
            },
            viewstatus: false
        },
        {
            dataField: "Note",
            headerText: "메모",
            editable: true,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BtnRegProc",
            headerText: "메모등록",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "등록",
                onClick: function (event) {
                    fnRegNote(event.item);
                }
            },
            viewstatus: true
        },
        {
            dataField: "ClosingAdminName",
            headerText: "마감자",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClosingDate",
            headerText: "마감일시",
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
            dataField: "ComCode",
            headerText: "ComCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "SendKind",
            headerText: "SendKind",
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
            dataField: "ComBizType",
            headerText: "ComBizType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComBizClass",
            headerText: "ComBizClass",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComTelNo",
            headerText: "ComTelNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComFaxNo",
            headerText: "ComFaxNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComEmail",
            headerText: "ComEmail",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComAddr",
            headerText: "ComAddr",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComAddr1",
            headerText: "ComAddr1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComAddrDtl",
            headerText: "ComAddrDtl",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ComPost",
            headerText: "ComPost",
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
            dataField: "AcctValidFlag",
            headerText: "AcctValidFlag",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PickupYMDFrom",
            headerText: "PickupYMDFrom",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderCnt",
            headerText: "OrderCnt",
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

    if (strKey.indexOf("Btn") > -1 || strKey === "Note") {
        return;
    }

    fnSetDetailList(objItem);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var LocationCode = [];
    var DLocationCode = [];
    var ItemCode = [];

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx";
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
        CallType: "PurchaseClosingList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        DeliveryLocationCodes: DLocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        SendStatus: $("#SendStatus").val(),
        SendType: $("#SendType").val(),
        ComName: $("#ComName").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        CarNo: $("#CarNo").val(),
        DriverName: $("#DriverName").val(),
        DriverCell: $("#DriverCell").val(),
        ClosingAdminName: $("#ClosingAdminName").val(),
        PurchaseClosingSeqNo: $("#SearchPurchaseClosingSeqNo").val(),
        InsureFlag: $("#ChkInsure").is(":checked") ? "Y" : "",
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
            positionField: "OrgAmt",
            dataField: "OrgAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
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
        },
        {
            positionField: "DeductAmt",
            dataField: "DeductAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "InputDeductAmt",
            dataField: "InputDeductAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "DriverInsureAmt",
            dataField: "DriverInsureAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SendAmt",
            dataField: "SendAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

//마감상세
function fnSetDetailList(objItem) {
    fnOpenRightSubLayer("매입 마감 상세", "/TMS/ClosingPurchase/PurchaseClosingDetailList?ClosingCenterCode=" + objItem.CenterCode + "&PurchaseClosingSeqNo=" + objItem.PurchaseClosingSeqNo, "500px", "700px", "80%");
    return false;
}

/**************************************/
//메모
/**************************************/
//메모 등록
function fnRegNote(objItem) {
    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx";
    var strCallBackFunc = "fnRegNoteSuccResult";
    var strFailCallBackFunc = "fnRegNoteFailResult";
    var objParam = {
        CallType: "PurchaseClosingNoteUpdate",
        CenterCode: objItem.CenterCode,
        PurchaseClosingSeqNo: objItem.PurchaseClosingSeqNo,
        Note: objItem.Note
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnRegNoteSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("메모가 등록되었습니다.", "info");
            return false;
        } else {
            fnRegNoteFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegNoteFailResult();
        return false;
    }
}

function fnRegNoteFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("메모 등록에 실패했습니다. 나중에 다시 시도해 주세요." + msg);
    return false;
}

/**************************************/

/**************************************/
//계산서
/**************************************/
function fnOpenBill(objItem) {
    var strPurchaseClosingSeqNo = (typeof objItem.PurchaseClosingSeqNo === "undefined" || objItem.PurchaseClosingSeqNo === null) ? "" : objItem.PurchaseClosingSeqNo;
    var strCenterCode = (typeof objItem.CenterCode === "undefined" || objItem.CenterCode === null) ? "" : objItem.CenterCode;
    var strNtsConfirmNum = (typeof objItem.NtsConfirmNum === "undefined" || objItem.NtsConfirmNum === null) ? "" : objItem.NtsConfirmNum;

    if (strPurchaseClosingSeqNo !== "" && strPurchaseClosingSeqNo != "0" && strCenterCode != "" && strNtsConfirmNum != "") {
        window.open("/TMS/ClosingPurchase/PurchaseClosingBillView?PurchaseClosingSeqNo=" + strPurchaseClosingSeqNo + "&CenterCode=" + strCenterCode + "&NtsConfirmNum=" + strNtsConfirmNum, "계산서보기", "width=1150, height=800, scrollbars=Yes");
        return false;
    } else {
        fnOpenBillList(objItem);
        return false;
    }
}
/**************************************/



/**************************************/
//송금예정일등록
/**************************************/

function fnOpenSendPlan() {
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 마감 전표가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (!(item.item.SendStatus == 2 || item.item.SendStatus == 3) && item.item.BillStatus == 3 && !(item.item.AcctValidFlag == "N" || item.item.SearchAcctNo == "")) {
            cnt++;
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("송금예정일을 변경할 수 있는 전표가 없습니다.", "warning");
        return false;
    }

    $("#DivSendPlan").show();
}

var ClosingSendPlanList = null;
var ClosingSendPlanCnt = 0;
var ClosingSendPlanProcCnt = 0;
var ClosingSendPlanSuccessCnt = 0;
var ClosingSendPlanFailCnt = 0;
var ClosingSendPlanResultMsg = "";

function fnInsSendPlan() {
    if (!$("#PopSendPlanYMD").val()) {
        fnDefaultAlertFocus("송금예정일을 선택하세요.", "PopSendPlanYMD", "warning");
        return false;
    }

    ClosingSendPlanList = [];

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 마감 전표가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (!(item.item.SendStatus == 2 || item.item.SendStatus == 3) && item.item.BillStatus == 3 && !(item.item.AcctValidFlag == "N" || item.item.SearchAcctNo == "")) {
            if (ClosingSendPlanList.findIndex((e) => e.PurchaseClosingSeqNo === item.item.PurchaseClosingSeqNo) === -1) {
                cnt++;
                ClosingSendPlanList.push(item.item);
            }
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("송금예정일을 변경할 수 있는 전표가 없습니다.<br>(계산서 발행완료, 계좌번호 체크)", "warning");
        return false;
    }

    ClosingSendPlanCnt = ClosingSendPlanList.length;
    ClosingSendPlanProcCnt = 0;
    ClosingSendPlanSuccessCnt = 0;
    ClosingSendPlanFailCnt = 0;
    ClosingSendPlanResultMsg = "";
    fnDefaultConfirm("송금예정일을 변경 하시겠습니까?", "fnInsSendPlanProc", "");
    return false;
}

function fnInsSendPlanProc() {

    $("#divLoadingImage").show();
    if (ClosingSendPlanProcCnt >= ClosingSendPlanCnt) {
        $("#divLoadingImage").hide();
        fnInsSendPlanEnd();
        return false;
    }

    var RowClosing = ClosingSendPlanList[ClosingSendPlanProcCnt];

    if (RowClosing) {
        var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx";
        var strCallBackFunc = "fnInsSendPlanSuccResult";
        var strFailCallBackFunc = "fnInsSendPlanFailResult";
        var objParam = {
            CallType: "PurchaseClosingSendPlanYMDUpdate",
            CenterCode: RowClosing.CenterCode,
            PurchaseClosingSeqNos: RowClosing.PurchaseClosingSeqNo,
            SendPlanYMD: $("#PopSendPlanYMD").val()
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnInsSendPlanSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            ClosingSendPlanSuccessCnt++;
        } else {
            ClosingSendPlanResultMsg += "<br>" + ClosingSendPlanList[ClosingSendPlanProcCnt].PurchaseClosingSeqNo + " : " + objRes[0].ErrMsg;
            ClosingSendPlanFailCnt++;
        }
    } else {
        ClosingSendPlanFailCnt++;
    }
    ClosingSendPlanProcCnt++;
    setTimeout(fnInsSendPlanProc(), 500);
}

function fnInsSendPlanFailResult() {
    ClosingSendPlanProcCnt++;
    ClosingSendPlanFailCnt++;
    setTimeout(fnInsSendPlanProc(), 500);
    return false;
}

function fnInsSendPlanEnd() {
    var msg = "총 " + ClosingSendPlanProcCnt + "건 중 " + ClosingSendPlanSuccessCnt + "건의 전표의 송금예정일이 등록 되었습니다.";
    if (ClosingSendPlanResultMsg !== "") {
        msg += ClosingSendPlanResultMsg;
    }

    fnCallGridData(GridID);
    fnCloseSendPlan();
    fnDefaultAlert(msg, "info");
    return false;
}

function fnCloseSendPlan() {
    $("#PopSendPlanYMD").val("");
    $("#DivSendPlan").hide();
}
/**************************************/

/**************************************/
//별도송금
/**************************************/
//별도송금
function fnOpenOtherPay() {
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 마감 전표가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if (item.item.SendType == 1 || item.item.SendType == 6 || item.item.SendPlanYMD == "") {
            cnt++;
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("별도송금을 등록할 수 있는 전표가 없습니다.", "warning");
        return false;
    }

    $("#DivOtherPay").show();
}

var ClosingOtherPayList = null;
var ClosingOtherPayCnt = 0;
var ClosingOtherPayProcCnt = 0;
var ClosingOtherPaySuccessCnt = 0;
var ClosingOtherPayFailCnt = 0;
var ClosingOtherPayResultMsg = "";

function fnInsOtherPay() {
    if (!$("#PopOtherPaySendPlanYMD").val()) {
        fnDefaultAlertFocus("송금예정일을 선택하세요.", "PopOtherPaySendPlanYMD", "warning");
        return false;
    }

    ClosingOtherPayList = [];

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 마감 전표가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    $.each(CheckedItems, function (index, item) {
        if ((item.item.SendType == 1 && item.item.SendPlanYMD == "") || item.item.SendType == 6) {
            if (ClosingOtherPayList.findIndex((e) => e.PurchaseClosingSeqNo === item.item.PurchaseClosingSeqNo) === -1) {
                cnt++;
                ClosingOtherPayList.push(item.item);
            }
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("별도송금을 등록할 수 있는 전표가 없습니다.", "warning");
        return false;
    }

    ClosingOtherPayCnt = ClosingOtherPayList.length;
    ClosingOtherPayProcCnt = 0;
    ClosingOtherPaySuccessCnt = 0;
    ClosingOtherPayFailCnt = 0;
    ClosingOtherPayResultMsg = "";
    fnDefaultConfirm("별도송금을 등록 하시겠습니까?", "fnInsOtherPayProc", "");
    return false;
}

function fnInsOtherPayProc() {

    if (ClosingOtherPayProcCnt >= ClosingOtherPayCnt) {
        fnInsOtherPayEnd();
        return false;
    }

    var RowClosing = ClosingOtherPayList[ClosingOtherPayProcCnt];

    if (RowClosing) {
        var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx";
        var strCallBackFunc = "fnInsOtherPaySuccResult";
        var strFailCallBackFunc = "fnInsOtherPayFailResult";
        var objParam = {
            CallType: "PurchaseClosingOtherPayUpdate",
            CenterCode: RowClosing.CenterCode,
            PurchaseClosingSeqNos: RowClosing.PurchaseClosingSeqNo,
            SendPlanYMD: $("#PopOtherPaySendPlanYMD").val()
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnInsOtherPaySuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            ClosingOtherPaySuccessCnt++;
        } else {
            ClosingOtherPayResultMsg += "<br>" + ClosingOtherPayList[ClosingOtherPayProcCnt].PurchaseClosingSeqNo + " : " + objRes[0].ErrMsg;
            ClosingOtherPayFailCnt++;
        }
    } else {
        ClosingOtherPayFailCnt++;
    }
    ClosingOtherPayProcCnt++;
    setTimeout(fnInsOtherPayProc(), 500);
}

function fnInsOtherPayFailResult() {
    ClosingOtherPayProcCnt++;
    ClosingOtherPayFailCnt++;
    setTimeout(fnInsOtherPayProc(), 500);
    return false;
}

function fnInsOtherPayEnd() {
    var msg = "총 " + ClosingOtherPayProcCnt + "건 중 " + ClosingOtherPaySuccessCnt + "건의 전표의 별도송금 등록이 되었습니다.";
    if (ClosingOtherPayResultMsg !== "") {
        msg += ClosingOtherPayResultMsg;
    }

    fnCallGridData(GridID);
    fnCloseOtherPay();
    fnDefaultAlert(msg, "info");
    return false;
}

function fnCloseOtherPay() {
    $("#PopOtherPaySendPlanYMD").val("");
    $("#DivOtherPay").hide();
}

//별도송금취소
function fnCnlOtherPay(objItem) {
    if (objItem.SendType != 6) {
        fnDefaultAlert("별도송금 전표가 아닙니다.", "warning");
        return false;
    }

    fnDefaultConfirm("별도송금 취소를 진행 하시겠습니까?", "fnCnlOtherPayProc", objItem);
    return false;
}

function fnCnlOtherPayProc(objItem) {
    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx";
    var strCallBackFunc = "fnCnlOtherPaySuccResult";
    var strFailCallBackFunc = "fnCnlOtherPayFailResult";

    var objParam = {
        CallType: "PurchaseClosingOtherPayCancel",
        CenterCode: objItem.CenterCode,
        PurchaseClosingSeqNos: objItem.PurchaseClosingSeqNo
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnCnlOtherPaySuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode == 0) {
            fnDefaultAlert("별도송금이 취소되었습니다.", "info", "");
            fnCallGridData(GridID);
            return false;
        } else {
            fnCnlOtherPayFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnCnlOtherPayFailResult();
        return false;
    }
}

function fnCnlOtherPayFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}
/**************************************/


/**********************************************/
//계좌번호 
/**********************************************/
function fnOpenAcctNo(objItem) {
    $("#PopAcctValidFlag").val("N");
    $("#PopCenterCode").val(objItem.CenterCode);
    $("#PopComCode").val(objItem.ComCode);
    $("#PopComCorpNo").val(objItem.ComCorpNo);
    $("#PopSpanCenterName").text(objItem.CenterName);
    $("#PopSpanComName").text(objItem.ComName);
    $("#PopSpanComCorpNo").text(objItem.ComCorpNo);
    $("#PopSpanComCeoName").text(objItem.ComCeoName);
    $("#BtnAcctNoChk").show();
    $("#DivAcctNo").show();
    return false;
}

function fnCloseAcctNo() {
    $("#PopAcctValidFlag").val("N");
    $("#PopCenterCode").val("");
    $("#PopComCode").val("");
    $("#PopComCorpNo").val("");
    $("#PopSpanCenterName").text("");
    $("#PopSpanComName").text("");
    $("#PopSpanComCorpNo").text("");
    $("#PopSpanComCeoName").text("");
    $("#PopBankCode").val("");
    $("#PopAcctNo").val("");
    $("#PopAcctName").val("");
    $("#PopBankCode option").prop("disabled", false);
    $("#PopAcctNo").removeAttr("readonly");
    $("#PopAcctName").removeAttr("readonly");
    $("#BtnChkAcctNo").show();
    $("#BtnResetAcctNo").hide();
    $("#DivAcctNo").hide();
    return false;
}

function fnResetAcctNo() {
    $("#PopAcctValidFlag").val("N");
    $("#PopBankCode").val("");
    $("#PopAcctNo").val("");
    $("#PopAcctName").val("");
    $("#PopBankCode option").prop("disabled", false);
    $("#PopAcctNo").removeAttr("readonly");
    $("#PopAcctName").removeAttr("readonly");
    $("#BtnChkAcctNo").show();
    $("#BtnResetAcctNo").hide();
    return false;
}

//계좌확인
function fnChkAcctNo() {
    if (!$("#PopCenterCode").val()) {
        return false;
    }

    if (!$("#PopComCode").val()) {
        return false;
    }

    if (!$("#PopBankCode").val()) {
        fnDefaultAlertFocus("은행을 선택하세요.", "PopBankCode", "warning");
        return false;
    }

    if (!$("#PopAcctNo").val()) {
        fnDefaultAlertFocus("계좌번호를 입력하세요.", "PopAcctNo", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx";
    var strCallBackFunc = "fnChkAcctNoSuccResult";
    var strFailCallBackFunc = "fnChkAcctNoFailResult";

    var objParam = {
        CallType: "ChkAcctNo",
        ComCorpNo: $("#PopComCorpNo").val(),
        AcctNo: $("#PopAcctNo").val(),
        BankCode: $("#PopBankCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnChkAcctNoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode == 0) {
            fnDefaultAlert("계좌가 확인되었습니다.", "info");
            $("#PopAcctValidFlag").val("Y");
            $("#PopBankCode").val(objRes[0].BankCode);
            $("#PopAcctNo").val(objRes[0].AcctNo);
            $("#PopAcctName").val(objRes[0].AcctName);
            $("#PopBankCode option:not(:selected)").prop("disabled", true);
            $("#PopAcctNo").prop("readonly", true);
            $("#PopAcctName").prop("readonly", true);
            $("#BtnChkAcctNo").hide();
            $("#BtnResetAcctNo").show();
            return false;
        } else {
            fnChkAcctNoFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnChkAcctNoFailResult();
        return false;
    }
}

function fnChkAcctNoFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//계좌등록
function fnRegAcctNo() {
    if (!$("#PopCenterCode").val()) {
        return false;
    }

    if (!$("#PopComCode").val()) {
        return false;
    }

    if (!$("#PopBankCode").val()) {
        return false;
    }

    if (!$("#PopAcctNo").val()) {
        return false;
    }

    if (!$("#PopAcctName").val()) {
        return false;
    }

    if ($("#PopAcctValidFlag").val() !== "Y") {
        fnDefaultAlert("계좌 확인 후 등록할 수 있습니다.", "warning");
        return false;
    }

    var strPopSpanComCeoName = fnToFullString($("#PopSpanComCeoName").text());
    var strPopSpanComName = fnToFullString($("#PopSpanComName").text());

    if ($("#PopAcctName").val().indexOf(strPopSpanComCeoName) == -1 && $("#PopAcctName").val().indexOf(strPopSpanComName) == -1 && strPopSpanComName.indexOf($("#PopAcctName").val()) == -1) {
        fnDefaultAlert("예금주는 업체명 또는 대표자명과 동일해야 합니다.<br/>(정보관리 - 차량관리에서 수정해주세요.)", "warning");
        return false;
    }

    fnDefaultConfirm("계좌를 등록 하시겠습니까?", "fnRegAcctNoProc", "");
    return false;
}

function fnRegAcctNoProc() {

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx";
    var strCallBackFunc = "fnRegAcctNoProcSuccResult";
    var strFailCallBackFunc = "fnRegAcctNoProcFailResult";

    var objParam = {
        CallType: "CarComAcctUpdate",
        CenterCode: $("#PopCenterCode").val(),
        ComCode: $("#PopComCode").val(),
        ComCorpNo: $("#PopComCorpNo").val(),
        AcctNo: $("#PopAcctNo").val(),
        BankCode: $("#PopBankCode").val(),
        AcctName: $("#PopAcctName").val(),
        AcctValidFlag: $("#PopAcctValidFlag").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnRegAcctNoProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode == 0) {
            var objRows = AUIGrid.getGridData(GridID);
            $.each(objRows, function (index, item) {
                if (item.ComCode == $("#PopComCode").val() && item.CenterCode == $("#PopCenterCode").val()) {
                    var upditem = {
                        ComCode: $("#PopComCode").val(),
                        CenterCode: $("#PopCenterCode").val(),
                        SearchAcctNo: $("#PopAcctNo").val().substr($("#PopAcctNo").val().length - 4, 4),
                        EncAcctNo: objRes[0].EncAcctNo,
                        AcctName: $("#PopAcctName").val(),
                        BankCode: $("#PopBankCode").val(),
                        BankName: $("#PopBankCode option:selected").text(),
                        AcctValidFlag: "Y",
                        PurchaseClosingSeqNo: item.PurchaseClosingSeqNo
                    }
                    AUIGrid.updateRowsById(GridID, upditem);
                }
            });

            fnDefaultAlert("계좌가 등록되었습니다.", "info", "fnCloseAcctNo()");
            return false;
        } else {
            fnRegAcctNoProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegAcctNoProcFailResult();
        return false;
    }
}

function fnRegAcctNoProcFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}
/**********************************************/

/**********************************************/
//마감 
/**********************************************/

var GridPurchaseBillID = "#PurchaseCarBillListGrid";

$(document).ready(function () {
    if ($(GridPurchaseBillID).length > 0) {
        // 그리드 초기화
        fnPurchaseBillGridInit();
    }
});

function fnPurchaseBillGridInit() {
    // 그리드 레이아웃 생성
    fnCreatePurchaseBillGridLayout(GridPurchaseBillID, "NTS_CONFIRM_NUM");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridPurchaseBillID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    AUIGrid.resize(GridPurchaseBillID, 878, 350);
}

//기본 레이아웃 세팅
function fnCreatePurchaseBillGridLayout(strGID, strRowIdField) {

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
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    objGridProps.rowCheckDisabledFunction = function (rowIndex, isChecked, item) {
        if (item.CLOSING_SEQ_NO != "" || item.PRE_MATCHING_EXISTS === "Y") {
            return false; // false 반환하면 disabled 처리됨
        }

        if ((item.INVOICE_TYPE.substr(0, 1) == "2" || item.INVOICE_TYPE.substr(0, 1) == "4") && item.SUPPLY_COST_TOTAL < 0) { //수정계산서 인경우
            return false; // false 반환하면 disabled 처리됨
        }
        return true;
    }

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (item.MODIFY_FLAG == "Y") { //수정발행 대상 계산서인 경우
            return "aui-grid-carryover-y-row-style";
        }

        if (item.TOTAL_AMOUNT == $("#PopBillOrgAmt").val()) { //금액 일치
            return "aui-grid-closing-y-row-style";
        }
        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultPurchaseBillColumnLayout()");
    var objOriLayout = fnGetDefaultPurchaseBillColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(strGID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(strGID, "PurchaseCarBillListGrid");
        return;
    });

    // 푸터
    fnSetPurchaseBillGridFooter(GridPurchaseBillID);
    AUIGrid.setGridData(GridPurchaseBillID, []);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultPurchaseBillColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "NTS_CONFIRM_NUM",
            headerText: "국세청승인번호",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "INVOICER_CORP_NAME",
            headerText: "공급자",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "INVOICER_CORP_NUM",
            headerText: "공급자사업자번호",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "INVOICER_CEO_NAME",
            headerText: "공급자대표자명",
            editable: false,
            width: 100,
            viewstatus: true
        }, {
            dataField: "INVOICEE_CORP_NAME",
            headerText: "공급받는자",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "INVOICEE_CORP_NUM",
            headerText: "공급받는자사업자번호",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "INVOICEE_CEO_NAME",
            headerText: "공급받는자대표자명",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "WRITE_DATE",
            headerText: "계산서작성일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ISSUE_DATE",
            headerText: "계산서발행일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "INVOICE_KINDM",
            headerText: "계산서종류",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SUPPLY_COST_TOTAL",
            headerText: "공급가액",
            editable: false,
            width: 100,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            viewstatus: true
        },
        {
            dataField: "TAX_TOTAL",
            headerText: "부가세",
            editable: false,
            width: 100,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            viewstatus: true
        },
        {
            dataField: "TOTAL_AMOUNT",
            headerText: "합계",
            editable: false,
            width: 80,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            viewstatus: true
        },

        /*숨김필드*/
        {
            dataField: "INVOICE_KIND",
            headerText: "INVOICE_KIND",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "SEQ_NO",
            headerText: "SEQ_NO",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "CENTER_CODE",
            headerText: "CENTER_CODE",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "YMD",
            headerText: "YMD",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "INVOICE_TYPE",
            headerText: "INVOICE_TYPE",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "MODIFY_FLAG",
            headerText: "MODIFY_FLAG",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "MODIFY_NTS_CONFIRM_NUM",
            headerText: "MODIFY_NTS_CONFIRM_NUM",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallPurchaseBillGridData(strGID) {

    if (!$("#PopBillCenterCode").val() || !$("#PopBillComCode").val() || !$("#PopBillComCorpNo").val() || !$("#PopBillOrgAmt").val()) {
        AUIGrid.setGridData(GridPurchaseBillID, []);
        return false;
    }

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx";
    var strCallBackFunc = "fnPurchaseBillGridSuccResult";

    var objParam = {
        CallType: "HometaxList",
        CenterCode: $("#PopBillCenterCode").val(),
        ComCode: $("#PopBillComCode").val(),
        ComCorpNo: $("#PopBillComCorpNo").val(),
        PurchaseOrgAmt: $("#PopBillOrgAmt").val(),
        PreMatchingFlag: "N"
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnPurchaseBillGridSuccResult(objRes) {

    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                AUIGrid.setGridData(GridPurchaseBillID, []);
                fnDefaultAlert(objRes[0].result.ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridPurchaseBillID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridPurchaseBillID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridPurchaseBillID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetPurchaseBillGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "NTS_CONFIRM_NUM",
        dataField: "NTS_CONFIRM_NUM",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/
function fnOpenBillList(objItem) {
    $("#PopBillCenterCode").val(objItem.CenterCode);
    $("#PopBillComCode").val(objItem.ComCode);
    $("#PopBillComCorpNo").val(objItem.ComCorpNo);
    $("#PopBillOrgAmt").val(objItem.OrgAmt);
    $("#PopBillPurchaseClosingSeqNo").val(objItem.PurchaseClosingSeqNo);
    $("#PopBillInsureFlag").val(objItem.InsureFlag);
    $("#PopSpanBillCenterName").text(objItem.CenterName);
    $("#PopSpanBillComName").text(objItem.ComName);
    $("#PopSpanBillComCorpNo").text(objItem.ComCorpNo);
    $("#PopSpanBillSupplyAmt").text(fnMoneyComma(objItem.SupplyAmt));
    $("#PopSpanBillTaxAmt").text(fnMoneyComma(objItem.TaxAmt));
    fnCallPurchaseBillGridData(GridPurchaseBillID);
    $("#DivPurchaseBill").show();
    return false;
}

function fnCloseBill() {
    AUIGrid.setGridData(GridPurchaseBillID, []);
    $("#PopBillCenterCode").val("");
    $("#PopBillComCode").val("");
    $("#PopBillComCorpNo").val("");
    $("#PopBillOrgAmt").val("");
    $("#PopBillPurchaseClosingSeqNo").val("");
    $("#PopBillInsureFlag").val("");
    $("#PopSpanBillCenterName").text("");
    $("#PopSpanBillComName").text("");
    $("#PopSpanBillComCorpNo").text("");
    $("#PopSpanBillSupplyAmt").text("");
    $("#PopSpanBillTaxAmt").text("");
    $("#DivPurchaseBill").hide();
    return false;
}

function fnUncheckBill() {
    AUIGrid.setAllCheckedRows(GridPurchaseBillID, false);
}

function fnPreMatching() {
    var objCheckedItem = AUIGrid.getCheckedRowItems(GridPurchaseBillID);
    if (objCheckedItem.length === 0) {
        fnDefaultAlert("계산서를 선택해주세요.", "warning");
        return false;
    }

    var objBillItem = objCheckedItem[0].item;
    if (objBillItem.CENTER_CODE != $("#PopBillCenterCode").val() || objBillItem.INVOICER_CORP_NUM != $("#PopBillComCorpNo").val() || objBillItem.TOTAL_AMOUNT != $("#PopBillOrgAmt").val()) {
        fnDefaultAlert("계산서와 마감 전표 정보가 다릅니다.", "warning");
        return false;
    }

    if ($("#PopBillInsureFlag").val() === "Y" && objBillItem.WRITE_DATE <= "20230701") {
        fnDefaultAlert("산재보험료 적용 전표입니다.<br/>23년 7월 1일 이전 계산서 연결은 마감취소 후, 재마감 진행해 주세요.", "warning");
        return false;
    }

    fnDefaultConfirm("계산서를 연결 하시겠습니까?", "fnPreMatchingProc", "");
    return false;
}

function fnPreMatchingProc() {
    var NtsConfirmNum = "";
    var BillKind = 99;
    var BillWrite = "";
    var BillYMD = "";

    if (AUIGrid.getCheckedRowItems(GridPurchaseBillID).length !== 0) {
        var objBillItem = AUIGrid.getCheckedRowItems(GridPurchaseBillID)[0].item;
        BillKind = objBillItem.INVOICE_KIND;
        BillWrite = objBillItem.WRITE_DATE;
        BillYMD = objBillItem.ISSUE_DATE;
        NtsConfirmNum = objBillItem.NTS_CONFIRM_NUM;
    }

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx";
    var strCallBackFunc = "fnPreMatchingSuccResult";
    var strFailCallBackFunc = "fnPreMatchingFailResult";
    var objParam = {
        CallType: "HometaxPreMatching",
        CenterCode: $("#PopBillCenterCode").val(),
        ComCode: $("#PopBillComCode").val(),
        ComCorpNo: $("#PopBillComCorpNo").val(),
        PurchaseOrgAmt: $("#PopBillOrgAmt").val(),
        PurchaseClosingSeqNo: $("#PopBillPurchaseClosingSeqNo").val(),
        BillKind: BillKind,
        BillWrite: BillWrite,
        BillYMD: BillYMD,
        NtsConfirmNum: NtsConfirmNum
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnPreMatchingSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("계산서가 연결되었습니다.", "info", "fnCloseBill()");
            fnCallGridData(GridID);
            return false;
        } else {
            fnPreMatchingFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnPreMatchingFailResult();
        return false;
    }
}

function fnPreMatchingFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}
