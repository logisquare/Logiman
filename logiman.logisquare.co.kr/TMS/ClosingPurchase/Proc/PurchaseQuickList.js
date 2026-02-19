window.name = "PurchaseQuickPayListGrid";
// 그리드
var GridID = "#PurchaseQuickPayListGrid";
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

    $("div.right").resizable({
        handles: "w",
        minWidth: 450,
        maxWidth: $("div.grid_list").width() - 450,
        start: function (event, ui) {
            var intMaxWidth = $("div.grid_list").width() - 450;
            if (intMaxWidth < 450) {
                intMaxWidth = 450;
            }
            $("div.right").resizable("option", "maxWidth", intMaxWidth);
        },
        resize: function (event, ui) {
            var rightWidthPer = ui.size.width / $("div.grid_type_03").width() * 100;
            var leftWidthPer = 100 - rightWidthPer;

            $("div.left").width(leftWidthPer + "%");
            $("li.left").width(leftWidthPer + "%");
            $("div.right").width(rightWidthPer + "%");
            $("li.right").width(rightWidthPer + "%");
            $("div.right").css("left", 0);

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 230);
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 230);
        },
        stop: function (event, ui) {
            var rightWidthPer = ui.size.width / $("div.grid_type_03").width() * 100;
            var leftWidthPer = 100 - rightWidthPer;

            $("div.left").width(leftWidthPer + "%");
            $("li.left").width(leftWidthPer + "%");
            $("div.right").width(rightWidthPer + "%");
            $("li.right").width(rightWidthPer + "%");
            $("div.right").css("left", 0);

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 230);
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 230);

            $.cookie(window.name, "{\"left\":" + leftWidthPer + ", \"right\":" + rightWidthPer + "}", { expires: 7 });
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

    $("#TaxWriteDateTo").datepicker({
        dateFormat: "yy-mm-dd",
        maxDate: GetDateToday("-")
    });
    $("#TaxWriteDateTo").datepicker("setDate", GetDateToday("-"));
    
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
    fnCreateGridLayout(GridID, "DispatchSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 230;
    AUIGrid.resize(GridID, $("div.left").width() - 5, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 230);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 230);
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
    objGridProps.showRowAllCheckBox = false; //체크박스를 표시할지 여부
    objGridProps.rowCheckToRadio = false; //체크박스 대신 라디오버튼으로 변환
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
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (AUIGrid.isCheckedRowById(strGID, item.DispatchSeqNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.ClosingFlag === "Y") { //마감
            return "aui-grid-closing-y-row-style";
        } else {
            if (item.BillStatus !== 1 && item.BillStatus !== 4) { //계산서 발행
                return "aui-grid-carryover-y-row-style";
            }
        }
        return "";
    }

    objGridProps.rowCheckDisabledFunction = function (rowIndex, isChecked, item) {
        if (item.SendStatus > 1 || item.ClosingFlag === "Y" || item.BillStatus == 2) {
            return false; // false 반환하면 disabled 처리됨
        }
        return true;
    }

    objGridProps.rowCheckableFunction = function (rowIndex, isChecked, item) {
        if (item.SendStatus > 1 || item.ClosingFlag === "Y" || item.BillStatus == 2) {
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
    AUIGrid.bind(strGID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(strGID, "PurchaseQuickPayListGrid");
        return;
    });

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        fnSetCheckedList(event.checked, event.item);
    });
};

function fnSetCheckedList(isChecked, objItem) {
    var objCheckedRow = AUIGrid.getCheckedRowItems(GridID);

    if (isChecked) {
        var arrIds = [];
        if (objCheckedRow.length > 1) {
            $.each(objCheckedRow, function (index, item) {
                if (objItem.DispatchSeqNo != item.item.DispatchSeqNo && ((objItem.ClosingFlag == "N" && objItem.QuickType != item.item.QuickType) || objItem.ComCorpNo != item.item.ComCorpNo || objItem.ClosingFlag != item.item.ClosingFlag) || objItem.NtsConfirmNum != item.item.NtsConfirmNum) {
                    arrIds.push(item.item.DispatchSeqNo);
                }
            });
        }

        AUIGrid.addUncheckedRowsByIds(GridID, arrIds);

        if (objItem.CenterCode != $("#HidCenterCode").val() || objItem.ComCode != $("#HidComCode").val() || objItem.ComCorpNo != $("#HidComCorpNo").val() || objItem.NtsConfirmNum != $("#HidNtsConfirmNum").val()) {
            fnSetDetailList(objItem);
        }
    } else {

        if (objCheckedRow.length == 0) {
            $("#HidCenterCode").val("");
            $("#HidComCode").val("");
            $("#HidComCorpNo").val("");
            $("#HidNtsConfirmNum").val("");
            $("#GridResult2").html("");
            AUIGrid.setGridData(GridDetailID, []);
        }
    }

    objCheckedRow = AUIGrid.getCheckedRowItems(GridID);
    var intRowCnt = 0;
    var intOrgAmt = 0;
    var intSupplyAmt = 0;
    var intTaxAmt = 0;
    var strSelectedInfo = "";
    $.each(objCheckedRow, function (index, item) {
        intRowCnt++;
        intOrgAmt += item.item.PurchaseOrgAmt;
        intSupplyAmt += item.item.PurchaseSupplyAmt;
        intTaxAmt += item.item.PurchaseTaxAmt;
    });

    strSelectedInfo = "총 " + intRowCnt + "건 / 매입합계 : " + fnMoneyComma(intOrgAmt) + "원 / 공급가액 : " + fnMoneyComma(intSupplyAmt) + "원 / 부가세 : " + fnMoneyComma(intTaxAmt) + "원";
    $("#GridSelectedInfo").text(strSelectedInfo);
}


function fnSetDetailList(objItem) {
    $("#CenterCode").val(objItem.CenterCode);
    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidComCode").val(objItem.ComCode);
    $("#HidComCorpNo").val(objItem.ComCorpNo);
    $("#HidNtsConfirmNum").val(objItem.NtsConfirmNum);

    if (!$("#HidCenterCode").val() || !$("#HidComCode").val() || !$("#HidComCorpNo").val()) {
        return false;
    }

    $("#GridResult2").html("");
    AUIGrid.setGridData(GridDetailID, []);

    fnCallDetailGridData(GridDetailID);
}

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "NoMatchTaxCnt",
            headerText: "미매칭계산서",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.NoMatchTaxCnt <= 0) {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; text-align:right;'>";
                    str += item.NoMatchTaxInfo;
                    str += "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
                }
            }
        },
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
            viewstatus: true
        },
        {
            dataField: "BtnOpenOrder",
            headerText: "오더보기",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    fnCommonOpenOrder(event.item);
                    return false;
                }
            },
            viewstatus: false
        },
        {
            dataField: "QuickTypeM",
            headerText: "입금구분",
            editable: false,
            width: 80,
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
            dataField: "PurchaseClosingSeqNo",
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
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ClosingDate",
            headerText: "마감일",
            editable: false,
            width: 100,
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
            dataField: "NtsConfirmNum",
            headerText: "국세청승인번호",
            editable: false,
            width: 120,
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
            dataField: "OrderItemCodeM",
            headerText: "상품",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "OrderLocationCodeM",
            headerText: "사업장",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DeliveryLocationCodeM",
            headerText: "배송사업장",
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
            viewstatus: true
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
            dataField: "PurchaseOrgAmt",
            headerText: "매입합계",
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
            dataField: "PurchaseSupplyAmt",
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
            dataField: "PurchaseTaxAmt",
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
            dataField: "InsureTargetFlag",
            headerText: "산재보험대상",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "InsureExceptKindM",
            headerText: "산재보험신고",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarDivTypeM",
            headerText: "차량구분",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComName",
            headerText: "차량업체명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 120,
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
            viewstatus: false
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverCell",
            headerText: "기사휴대폰",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
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
            dataField: "DispatchAdminName",
            headerText: "배차자명",
            editable: false,
            width: 100,
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
            dataField: "ComCode",
            headerText: "ComCode",
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
            dataField: "DispatchSeqNo",
            headerText: "DispatchSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "QuickType",
            headerText: "QuickType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CooperatorFlag",
            headerText: "CooperatorFlag",
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
            dataField: "InsureExceptKind",
            headerText: "InsureExceptKind",
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

    if (objItem.ClosingFlag === "Y") {
        fnOpenRightSubLayer("매입 마감 상세", "/TMS/ClosingPurchase/PurchaseClosingDetailList?ClosingCenterCode=" + objItem.CenterCode + "&PurchaseClosingSeqNo=" + objItem.PurchaseClosingSeqNo, "500px", "700px", "80%");
        return false;
    } else {
        fnDefaultAlert("운송내역을 체크하면 계산서 내역이 표시됩니다.", "info");
        return false;
    }
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

    $("#HidCenterCode").val("");
    $("#HidComCode").val("");
    $("#HidComCorpNo").val("");
    $("#HidNtsConfirmNum").val("");
    AUIGrid.setGridData(GridDetailID, []);

    var LocationCode = [];
    var ItemCode = [];
    var DLocationCode = [];

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseQuickHandler.ashx";
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
        CallType: "PurchaseQuickPayList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        TaxWriteDateTo: $("#TaxWriteDateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        DeliveryLocationCodes: DLocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        ClosingFlag: $("#ClosingFlag").val(),
        QuickType: $("#QuickType").val(),
        CarDivType: $("#CarDivType").val(),
        ComName: $("#ComName").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        CarNo: $("#CarNo").val(),
        DriverName: $("#DriverName").val(),
        DriverCell: $("#DriverCell").val(),
        ConsignorName: $("#ConsignorName").val(),
        AcceptAdminName: $("#AcceptAdminName").val(),
        DispatchAdminName: $("#DispatchAdminName").val()
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
        $("#GridSelectedInfo").text("");
        AUIGrid.setGridData(GridID, []);
        // 페이징
        //fnCreatePagingNavigator();

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
            style: "aui-grid-my-column-right"
        },
        {
            positionField: "Length",
            dataField: "Length",
            operation: "SUM",
            formatString: "#,##0",
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
            positionField: "PurchaseOrgAmt",
            dataField: "PurchaseOrgAmt",
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

/**********************************************************/
// 오더 상세 목록 그리드
/**********************************************************/
var GridDetailID = "#PurchaseQuickBillListGrid";

$(document).ready(function () {
    if ($(GridDetailID).length > 0) {
        // 그리드 초기화
        fnDetailGridInit();
    }
});

function fnDetailGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDetailGridLayout(GridDetailID, "NTS_CONFIRM_NUM");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDetailID, "", "", "fnDetailGridKeyDown", "fnGridSearchNotFound", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 230;
    
    AUIGrid.resize(GridDetailID, $("div.right").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 230);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 230);
        }, 100);
    });

    // 푸터
    fnSetDetailGridFooter(GridDetailID);
    AUIGrid.setGridData(GridDetailID, []);
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
        fnSaveColumnLayoutAuto(strGID, "PurchaseQuickBillListGrid");
        return;
    });

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        //SetDetailGridChecked(event, event.checked);
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDetailDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "NTS_CONFIRM_NUM",
            headerText: "국세청승인번호",
            editable: false,
            width: 150,
            viewstatus: false
        },
        {
            dataField: "INVOICER_CORP_NAME",
            headerText: "공급자",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "INVOICER_CORP_NUM",
            headerText: "공급자사업자번호",
            editable: false,
            width: 100,
            viewstatus: false
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
            viewstatus: false
        },
        {
            dataField: "INVOICEE_CORP_NUM",
            headerText: "공급받는자사업자번호",
            editable: false,
            width: 100,
            viewstatus: false
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
            dataField: "TOTAL_AMOUNT",
            headerText: "합계",
            editable: false,
            width: 80,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            viewstatus: false
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
            viewstatus: false
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
            viewstatus: false
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

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseQuickHandler.ashx";
    var strCallBackFunc = "fnDetailGridSuccResult";

    var objParam = {
        CallType: "HometaxList",
        CenterCode: $("#HidCenterCode").val(),
        ComCode: $("#HidComCode").val(),
        ComCorpNo: $("#HidComCorpNo").val(),
        NtsConfirmNum: $("#HidNtsConfirmNum").val(),
        TaxWriteDateTo: $("#TaxWriteDateTo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDetailGridSuccResult(objRes) {
    if (objRes) {
        $("#GridResult2").html("");
        AUIGrid.setGridData(GridDetailID, []);

        if (objRes[0].RetCode){
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#GridResult2").html("[" + objRes[0].data.RECORD_CNT + "건]");
        AUIGrid.setGridData(GridDetailID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridDetailID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDetailGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "NTS_CONFIRM_NUM",
            dataField: "NTS_CONFIRM_NUM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}
/**********************************************************/

//마감
var DispatchList1 = null;
var DispatchList2 = null;
var DispatchList3 = null;
var DispatchList4 = null;
var DispatchList5 = null;
var DispatchList6 = null;
var DispatchList7 = null;
var DispatchList8 = null;
var PurchaseOrgAmt = 0;
var PurchaseSupplyAmt = 0;
var PurchaseTaxAmt = 0;
var QuickType = 0;
var CarNo = "";
var DriverName = "";
var DriverCell = "";
var CooperatorFlag = "";
var CenterCode = "";
var ComCode = "";
var ComName = "";
var ComCeoName = "";
var BankCode = "";
var BankName = "";
var AcctName = "";
var EncAcctNo = "";
var AcctValidFlag = "";

function fnClosing() {
    var DispatchList = [];
    DispatchList1 = [];
    DispatchList2 = [];
    DispatchList3 = [];
    DispatchList4 = [];
    DispatchList5 = [];
    DispatchList6 = [];
    DispatchList7 = [];
    DispatchList8 = [];
    PurchaseOrgAmt = 0;
    PurchaseSupplyAmt = 0;
    PurchaseTaxAmt = 0;
    QuickType = 0;
    CarNo = "";
    DriverName = "";
    DriverCell = "";
    CenterCode = "";
    ComCode = "";
    ComName = "";
    ComCeoName = "";
    CooperatorFlag = "";
    BankCode = "";
    BankName = "";
    AcctName = "";
    EncAcctNo = "";

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    var CarNoCnt = 0;
    var DriverNameCnt = 0;
    var DriverCellCnt = 0;
    var arrCnt = 1;
    var insureFlag = "";
    var insureCnt = 0;

    $.each(CheckedItems, function (index, item) {
        if (item.item.ClosingFlag !== "Y" && $("#HidCenterCode").val() == item.item.CenterCode && $("#HidComCode").val() == item.item.ComCode) {
            if (insureFlag != "") {
                insureFlag = item.item.InsureTargetFlag;
            }

            if (insureFlag != "" && insureFlag !== item.item.InsureTargetFlag) {
                insureCnt++;
            }

            if (DispatchList.findIndex((e) => e.DispatchSeqNo === item.item.DispatchSeqNo) === -1) {

                if ((eval("DispatchList" + arrCnt).join(",") + "," + item.item.DispatchSeqNo).length > 4000) {
                    arrCnt++;

                    if (arrCnt > 8) {
                        return false;
                    }
                }

                if (index > 0) {
                    if (QuickType != item.item.QuickType) {
                        fnDefaultAlert("입금구분이 다른 오더가 포함되어 있습니다.", "warning");
                        return false;
                    }
                }

                if ($("#HidNtsConfirmNum").val()) {
                    if ($("#HidNtsConfirmNum").val() != item.item.NtsConfirmNum) {
                        fnDefaultAlert("발행된 오더 계산서의 국세청 승인번호가 다른 오더가 포함되어 있습니다.", "warning");
                        return false;
                    }
                }

                if (CarNo != item.item.CarNo) {
                    CarNoCnt++;
                }

                if (DriverName != item.item.DriverName) {
                    DriverNameCnt++;
                }

                if (DriverCell != item.item.DriverCell) {
                    DriverCellCnt++;
                }

                cnt++;

                DispatchList.push(item.item);
                eval("DispatchList" + arrCnt).push(item.item.DispatchSeqNo);
                PurchaseOrgAmt += item.item.PurchaseOrgAmt;
                PurchaseSupplyAmt += item.item.PurchaseSupplyAmt;
                PurchaseTaxAmt += item.item.PurchaseTaxAmt;
                QuickType = item.item.QuickType;
                CarNo = item.item.CarNo;
                DriverName = item.item.DriverName;
                DriverCell = item.item.DriverCell;
            }
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("마감할 수 있는 비용이 없습니다.", "warning");
        return false;
    }

    if (arrCnt > 8) {
        fnDefaultAlert("마감할 수 있는 최대 비용수를 초과했습니다.", "warning");
        return false;
    }

    if (CarNoCnt > 1) {
        CarNo = "";
    }

    if (DriverNameCnt > 1) {
        DriverName = "";
    }

    if (DriverCellCnt > 1) {
        DriverCell = "";
    }

    if (insureCnt > 0) {
        fnDefaultAlert("오더 중 산재보험 대상여부가 다른 차량정보가 배차되어 있습니다.<br>대상여부가 같은 오더만 마감하실 수 있습니다.<br><b>(* 계산서 기준으로 배차정보를 수정하거나, 나누어 마감해 주세요.)</b>", "warning");
        return false;
    }

    CenterCode = DispatchList[0].CenterCode;
    ComCode = DispatchList[0].ComCode;
    ComName = DispatchList[0].ComName;
    ComCeoName = DispatchList[0].ComCeoName;
    CooperatorFlag = DispatchList[0].CooperatorFlag;
    BankCode = DispatchList[0].BankCode;
    BankName = DispatchList[0].BankName;
    AcctName = DispatchList[0].AcctName;
    EncAcctNo = DispatchList[0].EncAcctNo;
    AcctValidFlag = DispatchList[0].AcctValidFlag;

    if (BankCode == "" || typeof BankCode == "undefined" || AcctName == "" || typeof AcctName == "undefined" || EncAcctNo == "" || typeof EncAcctNo == "undefined" || AcctValidFlag == "" || typeof AcctValidFlag == "undefined" || AcctValidFlag == "N") {
        fnDefaultAlert("계좌번호 등록 후 이용할 수 있습니다.", "warning");
        fnOpenAcctNo(DispatchList[0]);
        return false;
    }

    var objBillItem = AUIGrid.getCheckedRowItems(GridDetailID);
    if (objBillItem.length != 1) {
        fnDefaultAlert("선택된 계산서가 없습니다.", "warning");
        return false;
    }

    if (PurchaseOrgAmt != objBillItem[0].item.TOTAL_AMOUNT) {
        fnDefaultAlert("선택된 계산서와 운송내역의 금액이 다릅니다.", "warning");
        return false;
    }

    if ($("#HidComCorpNo").val() != objBillItem[0].item.INVOICER_CORP_NUM) {
        fnDefaultAlert("선택된 계산서의 공급사사업자번호와 운송내역의 차량사업자번호가 다릅니다.", "warning");
        return false;
    }

    $("#PopInsureCenterCode").val(CenterCode);
    $("#PopInsureComCode").val(ComCode);
    fnResetInsure();
    fnInsureCheck();
    $("#DivPurchaseInsure").show();
    return false;
}

function fnInsClosing() {
    if ($("#PopInsureChkFlag").val() !== "Y") {
        fnDefaultAlert("산재 보험료 대상 확인을 해주세요.", "warning");
        return false;
    }

    if ($("#PopInsureFlag").is(":checked")) {
        var objBillItem = AUIGrid.getCheckedRowItems(GridDetailID);
        var strBillWrite = objBillItem[0].item.WRITE_DATE;

        if (strBillWrite < "20230701") {
            fnDefaultAlert("산재보험은 작성일이 23년 7월 1일 이후인 계산서에 적용할 수 있습니다.", "warning");
            return false;
        }
    }

    var objBillItem = AUIGrid.getCheckedRowItems(GridDetailID);
    var strInsureYMD = objBillItem[0].item.WRITE_DATE;
    if ($("#PopInsureYMD").val() != strInsureYMD) {
        fnDefaultAlert("작성일이 변경되었습니다. 다시 산재 보험료 대상 확인을 해주세요.", "warning");
        return false;
    }

    var msg = "선택한 오더를 마감 하시겠습니까?";

    if (AcctName != ComCeoName) {
        msg = "<h3>예금주(" + AcctName + ")와 대표자명(" + ComCeoName + ")이 다릅니다.</h3>" + msg;
    }

    fnDefaultConfirm(msg, "fnInsClosingProc", "");
    return false;
}

function fnInsClosingProc() {
    if (DispatchList1.join(",") === "" && DispatchList2.join(",") === "" && DispatchList3.join(",") === "" && DispatchList4.join(",") === "" && DispatchList5.join(",") === "" && DispatchList6.join(",") === "" && DispatchList7.join(",") === "" && DispatchList8.join(",") === "") {
        fnDefaultAlert("마감할 수 있는 비용이 없습니다.", "warning");
        return false;
    }

    var objBillItem = AUIGrid.getCheckedRowItems(GridDetailID);
    if (objBillItem.length != 1) {
        fnDefaultAlert("선택된 계산서가 없습니다.", "warning");
        return false;
    }

    var BillKind = objBillItem[0].item.INVOICE_KIND;
    var BillWrite = objBillItem[0].item.WRITE_DATE;
    var BillYMD = objBillItem[0].item.ISSUE_DATE;
    var BillDate = objBillItem[0].item.YMD;
    var IssueTaxAmt = objBillItem[0].item.TOTAL_AMOUNT;
    var NtsConfirmNum = objBillItem[0].item.NTS_CONFIRM_NUM;
    var DeductAmt = 0;
    var DeductReason = "";

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseQuickHandler.ashx";
    var strCallBackFunc = "fnInsClosingProcSuccResult";
    var strFailCallBackFunc = "fnInsClosingProcFailResult";
    var objParam = {
        CallType: "PurchaseClosingInsert",
        CenterCode: $("#HidCenterCode").val(),
        ComCode: $("#HidComCode").val(),
        ComCorpNo: $("#HidComCorpNo").val(),
        PurchaseOrgAmt: PurchaseOrgAmt,
        PurchaseSupplyAmt: PurchaseSupplyAmt,
        PurchaseTaxAmt: PurchaseTaxAmt,
        DispatchSeqNos1: DispatchList1.join(","),
        DispatchSeqNos2: DispatchList2.join(","),
        DispatchSeqNos3: DispatchList3.join(","),
        DispatchSeqNos4: DispatchList4.join(","),
        DispatchSeqNos5: DispatchList5.join(","),
        DispatchSeqNos6: DispatchList6.join(","),
        DispatchSeqNos7: DispatchList7.join(","),
        DispatchSeqNos8: DispatchList8.join(","),
        BillKind: BillKind,
        BillWrite: BillWrite,
        BillYMD: BillYMD,
        BillDate: BillDate,
        IssueTaxAmt: IssueTaxAmt,
        DeductAmt: DeductAmt,
        DeductReason: DeductReason,
        NtsConfirmNum: NtsConfirmNum,
        QuickType: QuickType,
        CarNo: CarNo,
        DriverName: DriverName,
        DriverCell: DriverCell,
        ComName: ComName,
        ComCeoName: ComCeoName,
        CooperatorFlag: CooperatorFlag,
        BankCode: BankCode,
        BankName: BankName,
        AcctName: AcctName,
        EncAcctNo: EncAcctNo,
        InsureFlag: $("#PopInsureFlag").is(":checked") ? "Y" : "N"
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnInsClosingProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("비용이 마감되었습니다.", "info", "fnClosePurchaseInsure()");
            fnCallGridData(GridID);
            $("#GridResult2").html("");
            AUIGrid.setGridData(GridDetailID, []);
            return false;
        } else {
            fnInsClosingProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnInsClosingProcFailResult();
        return false;
    }
}

function fnInsClosingProcFailResult(msg) {
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

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseQuickHandler.ashx";
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

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseQuickHandler.ashx";
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
        AcctValidFlag : $("#PopAcctValidFlag").val()
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
                        DispatchSeqNo: item.DispatchSeqNo
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

/**********************************************************/
// 산재보험 체크
/**********************************************************/
var intPopTransAmt = 0;
var intPopInsureRateAmt = 0;
var intPopInsureReduceAmt = 0;
var intPopInsurePayAmt = 0;
var intPopCenterInsureAmt = 0;
var intPopDriverInsureAmt = 0;

$(document).ready(function () {
    $("#PopInsureFlag").on("change", function (event) {
        if ($(this).is(":checked")) {
            if ($("#PopSpanInsureInfo").text() == "* 산재보험료 적용 대상차량이 아닙니다.") {
                $("#PopInsureFlag").prop("checked", false);
                fnDefaultAlert("산재보험 적용 대상 차량이 아닙니다.");
                return false;
            }

            $("#PopTransAmt").val(intPopTransAmt);
            $("#PopInsureRateAmt").val(intPopInsureRateAmt);
            $("#PopInsureReduceAmt").val(intPopInsureReduceAmt);
            $("#PopInsurePayAmt").val(intPopInsurePayAmt);
            $("#PopCenterInsureAmt").val(intPopCenterInsureAmt);
            $("#PopDriverInsureAmt").val(intPopDriverInsureAmt);
        } else {
            intPopTransAmt = $("#PopTransAmt").val();
            intPopInsureRateAmt = $("#PopInsureRateAmt").val();
            intPopInsureReduceAmt = $("#PopInsureReduceAmt").val();
            intPopInsurePayAmt = $("#PopInsurePayAmt").val();
            intPopCenterInsureAmt = $("#PopCenterInsureAmt").val();
            intPopDriverInsureAmt = $("#PopDriverInsureAmt").val();
            $("#PopTransAmt").val(0);
            $("#PopInsureRateAmt").val(0);
            $("#PopInsureReduceAmt").val(0);
            $("#PopInsurePayAmt").val(0);
            $("#PopCenterInsureAmt").val(0);
            $("#PopDriverInsureAmt").val(0);
        }
    });
});

//산재보험 산정 예시
function fnInsureHelp() {
    var htmlMsg = "산재 보험료 산정 예시<br/><br/>";
    htmlMsg += "<b>총 사업소득이 1,000,000원인 경우 (비과세 소득 0원 가정)<br/><br/>";
    htmlMsg += " - 지급액 : 1,000,000<br/>";
    htmlMsg += " - 필요경비 : 1,000,000 X 49.9% = 499,000 (소수점 절사)<br/>";
    htmlMsg += " - 월 보수액 : 1,000,000 - 499,000 = 501,000<br/>";
    htmlMsg += " - 예상 산재보험료 : 501,000 X (1.76% / 2) = 4,408.8 = 4,400 (원단위 절사)<br/>";
    //htmlMsg += " - 감경보험료 : 4,400 X 30% = 1,320 (원단위 절사)<br/>";
    //htmlMsg += " - 실제 납부보험료 : 4,400 - 1,320 = 3,080 (원단위 절사)<br/>";
    htmlMsg += " - 사업주 및 노무제공자 각각의 보험료 부담액 : 4,400</b>";
    fnDefaultAlert(htmlMsg, "warning");
    return false;
}

//산재보험 대상 확인
function fnInsureCheck() {
    fnResetInsure();

    if (DispatchList1.join(",") === "" && DispatchList2.join(",") === "" && DispatchList3.join(",") === "" && DispatchList4.join(",") === "" && DispatchList5.join(",") === "" && DispatchList6.join(",") === "" && DispatchList7.join(",") === "" && DispatchList8.join(",") === "") {
        fnDefaultAlert("선택된 비용이 없습니다.", "warning");
        return false;
    }

    var objBillItem = AUIGrid.getCheckedRowItems(GridDetailID);
    if (objBillItem.length != 1) {
        fnDefaultAlert("선택된 계산서가 없습니다.", "warning");
        return false;
    }

    var strInsureYMD = objBillItem[0].item.WRITE_DATE;

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseQuickHandler.ashx";
    var strCallBackFunc = "fnInsureCheckSuccResult";
    var strFailCallBackFunc = "fnInsureCheckFailResult";

    var objParam = {
        CallType: "PurchaseCarCompanyInsureCheck",
        CenterCode: $("#PopInsureCenterCode").val(),
        ComCode: $("#PopInsureComCode").val(),
        InsureYMD: strInsureYMD,
        DispatchSeqNos1: DispatchList1.join(","),
        DispatchSeqNos2: DispatchList2.join(","),
        DispatchSeqNos3: DispatchList3.join(","),
        DispatchSeqNos4: DispatchList4.join(","),
        DispatchSeqNos5: DispatchList5.join(","),
        DispatchSeqNos6: DispatchList6.join(","),
        DispatchSeqNos7: DispatchList7.join(","),
        DispatchSeqNos8: DispatchList8.join(",")
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnInsureCheckSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            $("#PopInsureChkFlag").val("Y");

            var objBillItem = AUIGrid.getCheckedRowItems(GridDetailID);
            var strInsureYMD = objBillItem[0].item.WRITE_DATE;
            $("#PopInsureYMD").val(strInsureYMD);

            if (objRes[0].ApplyFlag === "Y") {
                $("#PopSpanInsureInfo").text("* 산재보험료 적용 대상차량입니다.");
                $("#PopTransAmt").val(objRes[0].TransAmt);
                $("#PopInsureRateAmt").val(objRes[0].InsureRateAmt);
                $("#PopInsureReduceAmt").val(objRes[0].InsureReduceAmt);
                $("#PopInsurePayAmt").val(objRes[0].InsurePayAmt);
                $("#PopCenterInsureAmt").val(objRes[0].CenterInsureAmt);
                $("#PopDriverInsureAmt").val(objRes[0].DriverInsureAmt);
                $("#PopInsureFlag").prop("checked", true);
            } else {
                $("#PopSpanInsureInfo").text("* 산재보험료 적용 대상차량이 아닙니다.");
                $("#PopTransAmt").val(0);
                $("#PopInsureRateAmt").val(0);
                $("#PopInsureReduceAmt").val(0);
                $("#PopInsurePayAmt").val(0);
                $("#PopCenterInsureAmt").val(0);
                $("#PopDriverInsureAmt").val(0);
                $("#PopInsureFlag").prop("checked", false);
            }
            return false;
        } else {
            fnInsureCheckFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnInsureCheckFailResult();
        return false;
    }
}

function fnInsureCheckFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

function fnClosePurchaseInsure() {
    DispatchList1 = [];
    DispatchList2 = [];
    DispatchList3 = [];
    DispatchList4 = [];
    DispatchList5 = [];
    DispatchList6 = [];
    DispatchList7 = [];
    DispatchList8 = [];
    PurchaseOrgAmt = 0;
    PurchaseSupplyAmt = 0;
    PurchaseTaxAmt = 0;
    QuickType = 0;
    CarNo = "";
    DriverName = "";
    DriverCell = "";
    CenterCode = "";
    ComCode = "";
    ComName = "";
    ComCeoName = "";
    CooperatorFlag = "";
    BankCode = "";
    BankName = "";
    AcctName = "";
    EncAcctNo = "";

    $("#PopInsureCenterCode").val("");
    $("#PopInsureComCode").val("");
    fnResetInsure();

    $("#DivPurchaseInsure").hide();
    return false;
}

function fnResetInsure() {
    $("#PopInsureYMD").val("");
    $("#PopInsureChkFlag").val("N");
    $("#PopSpanInsureInfo").text("");
    $("#PopTransAmt").val(0);
    $("#PopInsureRateAmt").val(0);
    $("#PopInsureReduceAmt").val(0);
    $("#PopInsurePayAmt").val(0);
    $("#PopCenterInsureAmt").val(0);
    $("#PopDriverInsureAmt").val(0);
    $("#PopInsureFlag").prop("checked", false);
}
/**********************************************************/