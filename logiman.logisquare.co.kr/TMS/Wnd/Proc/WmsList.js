window.name = "WmsListGrid";
// 그리드
var GridID = "#WmsListGrid";
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

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 180);
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 180);
        },
        stop: function (event, ui) {
            var leftWidthPer = ui.size.width / $("div.grid_type_03").width() * 100;
            var rightWidthPer = 100 - leftWidthPer;

            $("div.left").width(leftWidthPer + "%");
            $("li.left").width(leftWidthPer + "%");
            $("div.right").width(rightWidthPer + "%");
            $("li.right").width(rightWidthPer + "%");

            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 180);
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 180);

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
    fnCreateGridLayout(GridID, "OrderNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 180;
    AUIGrid.resize(GridID, $("div.left").width() - 5, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 180);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $("div.left").width() - 5, $(document).height() - 180);
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
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
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

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

function fnSetDetailList(objItem) {

    $("#CenterCode").val(objItem.CenterCode);
    $("#HidCenterCode").val(objItem.CenterCode);
    $("#HidOrderNo").val(objItem.OrderNo);

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        return false;
    }

    AUIGrid.setGridData(GridDetailID, []);
    fnCallDetailGridData(GridDetailID);
    return false;
}

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
            dataField: "PickupPlace",
            headerText: "상차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
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
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 80,
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
            dataField: "LayoverCnt",
            headerText: "총배송지",
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
            dataField: "LayoverDeliveryCnt",
            headerText: "배송완료",
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
            dataField: "TotalQuantity",
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
            dataField: "TotalWeight",
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
            dataField: "BtnTemper",
            headerText: "온도기록계",
            editable: false,
            width: 100,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var retStr = "미등록";
                if (item.ThermographFlag == "Y") {
                    retStr = "보기";
                }
                return retStr;
            },
            renderer: {
                type: "ButtonRenderer",
                //labelText: "보기",
                onClick: function (event) {
                    if (event.item.ThermographFlag != "Y") {
                        return false;
                    }

                    fnOpenReceipt(1, event.item);
                    return false;
                }
            },
            viewstatus: false
        },
        {
            dataField: "ThermographDate",
            headerText: "온도기록등록일시",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "LastPickupDate",
            headerText: "최종상차일시",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "LastDeliveryDate",
            headerText: "최종배송일시",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BtnOrder",
            headerText: "오더상세",
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
            dataField: "BtnGps",
            headerText: "위치관제",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    fnOpenGps(event.item);
                    return false;
                }
            },
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
            dataField: "OrderNo",
            headerText: "오더번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "AcceptDate",
            headerText: "접수일시",
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
            headerText: "최종수정일시",
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
            dataField: "OrderItemCode",
            headerText: "OrderItemCode",
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
        return false;
    }

    fnSetDetailList(objItem);
    return false;
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
    $("#HidOrderNo").val("");
    AUIGrid.setGridData(GridDetailID, []);

    var strHandlerURL = "/TMS/Wnd/Proc/WmsHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "WmsOrderList",
        CenterCode: $("#CenterCode").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        ComName: $("#ComName").val(),
        CarNo: $("#CarNo").val(),
        DriverName: $("#DriverName").val(),
        MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N",
        CnlFlag: $("#ChkCnl").is(":checked") ? "Y" : "N",
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

        if (objRes[0].result.ErrorCode !== 0) {
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
            positionField: "LayoverCnt",
            dataField: "LayoverCnt",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "LayoverDeliveryCnt",
            dataField: "LayoverDeliveryCnt",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TotalQuantity",
            dataField: "TotalQuantity",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TotalWeight",
            dataField: "TotalWeight",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/
// 오더 상세 목록 그리드
/**********************************************************/
var GridDetailID = "#WmsLayoverListGrid";

$(document).ready(function () {
    if ($(GridDetailID).length > 0) {
        // 그리드 초기화
        fnDetailGridInit();
    }
});

function fnDetailGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDetailGridLayout(GridDetailID, "LayoverSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDetailID, "", "", "fnDetailGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnDetailGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 180;

    AUIGrid.resize(GridDetailID, $("div.right").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 180)

        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridDetailID, $("div.right").width(), $(document).height() - 180)
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
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
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

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDetailDefaultColumnLayout()");
    var objOriLayout = fnGetDetailDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDetailDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "DeliveryNo",
            headerText: "출고번호",
            editable: false,
            width: 110,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "TruckNo",
            headerText: "호차번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DispatchYMD",
            headerText: "배송요청일",
            editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "LayoverSort",
            headerText: "배송순서",
            editable: false,
            width: 100,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: false
        },
        {
            dataField: "DeliveryName",
            headerText: "거래처",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Quantity",
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
            dataField: "Price",
            headerText: "총금액합계",
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
            dataField: "LayoverNote",
            headerText: "참고사항",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "LayoverGoodsCnt",
            headerText: "총품목수",
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
            dataField: "PickupFlagM",
            headerText: "상차여부",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupDate",
            headerText: "상차일시",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DeliveryFlagM",
            headerText: "배송여부",
            editable: false,
            width: 130,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DeliveryDate",
            headerText: "배송일시",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BtnReceipt",
            headerText: "배송증빙",
            editable: false,
            width: 100,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var retStr = "미등록";
                if (item.LayoverFileCnt > 0) {
                    retStr = "보기";
                }
                return retStr;
            },
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    if (event.item.LayoverFileCnt ==  0) {
                        return false;
                    }
                    fnOpenReceipt(2, event.item);
                    return false;
                }
            },
            viewstatus: false
        },
        {
            dataField: "LayoverConsignorName",
            headerText: "화주사",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DeliveryAddr",
            headerText: "주소",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DeliveryTelNo",
            headerText: "전화번호",
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
            dataField: "DeliveryCell",
            headerText: "휴대폰번호",
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
            dataField: "RegDate",
            headerText: "등록일시",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "UpdDate",
            headerText: "수정일시",
            editable: false,
            width: 120,
            viewstatus: true
        },
        /*숨김필드*/
        {
            dataField: "LayoverSeqNo",
            headerText: "LayoverSeqNo",
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
            dataField: "LayoverFileCnt",
            headerText: "LayoverFileCnt",
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

    fnOpenRightSubLayer("배송상세", "/TMS/Wnd/WmsGoodsList?CenterCode=" + objItem.CenterCode + "&OrderNo=" + objItem.OrderNo + "&DeliveryNo=" + objItem.DeliveryNo, "500px", "700px", "80%");
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

    var strHandlerURL = "/TMS/Wnd/Proc/WmsHandler.ashx";
    var strCallBackFunc = "fnDetailGridSuccResult";
    var objParam = {
        CallType: "WmsOrderLayoverList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
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

        if (objRes[0].result.ErrorCode !== 0) {
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
    var GridFooterObject = [
        {
            positionField: "DeliveryNo",
            dataField: "DeliveryNo",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Quantity",
            dataField: "Quantity",
            operation: "SUM",
            formatString: "#,##0",
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
            positionField: "Price",
            dataField: "Price",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "LayoverGoodsCnt",
            dataField: "LayoverGoodsCnt",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/

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

//온도기록계, 배송증빙
function fnOpenReceipt(intReceiptType, objItem) {
    var strParam = "ParamReceiptType=" + intReceiptType;
    strParam += "&ParamCenterCode=" + objItem.CenterCode;
    strParam += "&ParamOrderNo=" + objItem.OrderNo;
    if (typeof objItem.DeliveryNo != "undefined") {
        strParam += "&ParamDeliveryNo=" + objItem.DeliveryNo;
    }

    fnOpenRightSubLayer("증빙보기", "/TMS/Wnd/WmsReceiptList?" + strParam, "800px", "600px", "60%");
    return false;
}

//위치관제
function fnOpenGps(objItem) {
    var strParam = "MobileNo=" + objItem.DriverCell;
    strParam += "&YMD=" + objItem.PickupYMD;

    fnOpenRightSubLayer("위치관제", "/TMS/Wnd/WmsGpsDetail?" + strParam, "800px", "600px", "50%");
    return false;
}