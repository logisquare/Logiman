window.name = "CargopassListGrid";
// 그리드
var GridID = "#CargopassListGrid";
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
            fnCloseDispatchCar();
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

    //연동상태 즐겨찾기 삭제
    $("#DivCargopassStatus a.SaveSearchConditions").remove();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "CargopassOrderNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 235;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 235);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 255);
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
    objGridProps.fixedColumnCount = 2; // 고정 칼럼 개수
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
            dataField: "BtnViewOrderDetail",
            headerText: "카고패스",
            editable: false,
            width: 80,
            renderer: {
                type: "ButtonRenderer",
                labelText: "등록정보",
                onClick: function (event) {
                    fnOpenOrderDetail(event.item);
                    return false;
                }
            }
        },
        {
            dataField: "BtnViewCargopassDetail",
            headerText: "정보망",
            editable: false,
            width: 80,
            renderer: {
                type: "ButtonRenderer",
                labelText: "연동정보",
                onClick: function (event) {
                    fnOpenCargopassDetail(event.item);
                    return false;
                }
            }
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
            dataField: "CargopassOrderNo",
            headerText: "등록번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CargopassStatusM",
            headerText: "연동상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            renderer: {
                type: "IconRenderer",
                iconWidth: 20,
                iconHeight: 20,
                iconPosition: "aisle",
                iconTableRef: {
                    "요청": "/js/lib/AUIGrid/assets/violet_circle.png",
                    "등록": "/js/lib/AUIGrid/assets/yellow_circle.png",
                    "배차": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "배차확정": "/js/lib/AUIGrid/assets/green_circle.png",
                    "취소": "/js/lib/AUIGrid/assets/gray_circle.png"
                }
            },
            viewstatus: false
        },
        {
            dataField: "DispatchTypeM",
            headerText: "배차구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
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
            headerText: "상차일",
            editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupHM",
            headerText: "상차시간",
            editable: false,
            width: 100,
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
            dataField: "PickupAddr",
            headerText: "상차지주소",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
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
            dataField: "GetYMD",
            headerText: "하차일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetHM",
            headerText: "하차시간",
            editable: false,
            width: 100,
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
            dataField: "GetAddr",
            headerText: "하차지주소",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetWay",
            headerText: "하차방법",
            editable: false,
            width: 100,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetTelNo",
            headerText: "하차지 연락처",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CarTon",
            headerText: "톤수",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CarTruck",
            headerText: "차종",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
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
            dataField: "QuickTypeM",
            headerText: "지급방법",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "SupplyAmt",
            headerText: "운송료",
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
            dataField: "LayerFlag",
            headerText: "혼적",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "UrgentFlag",
            headerText: "긴급",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ShuttleFlag",
            headerText: "왕복",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "Note",
            headerText: "비고",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CargopassNetworkKindM",
            headerText: "정보망종류",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ComCorpNo",
            headerText: "사업자번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "DriverCell",
            headerText: "기사휴대폰",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "DispatchCnt",
            headerText: "오더수",
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
            filter: { showIcon: true },
            viewstatus: false,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return value == 0 ? "" : value.toString();
            }
        },
        {
            dataField: "RegAdminName",
            headerText: "등록자",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "RegDate",
            headerText: "등록일",
            editable: false,
            width: 130,
            viewstatus: false
        },
        {
            dataField: "UpdAdminName",
            headerText: "수정자",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "UpdDate",
            headerText: "수정일",
            editable: false,
            width: 130,
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
            dataField: "DispatchType",
            headerText: "DispatchType",
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
            dataField: "CargopassNetworkKind",
            headerText: "CargopassNetworkKind",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CargopassStatus",
            headerText: "CargopassStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "Network24DDID",
            headerText: "Network24DDID",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "NetworkHMMID",
            headerText: "NetworkHMMID",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "NetworkOneCallID",
            headerText: "NetworkOneCallID",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "NetworkHmadangID",
            headerText: "NetworkHmadangID",
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
        fnCloseDispatchCar();
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
    var CargopassStatus = [];
    var strHandlerURL = "/TMS/Cargopass/Proc/CargopassHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    $.each($("#CargopassStatus input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            CargopassStatus.push($(el).val());
        }
    });

    var objParam = {
        CallType: "CargopassList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        CargopassStatuses: CargopassStatus.join(","),
        CargopassOrderNo: $("#CargopassOrderNo").val(),
        OrderNo: $("#OrderNo").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        CarNo: $("#CarNo").val(),
        DriverName: $("#DriverName").val(),
        DriverCell: $("#DriverCell").val(),
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
            positionField: "Weight",
            dataField: "Weight",
            operation: "SUM",
            formatString: "#,##0.##",
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
            positionField: "SupplyAmt",
            dataField: "SupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

function fnOpenOrderDetail(objItem) {
    var strCenterCode = (typeof objItem.CenterCode === "undefined" || objItem.CenterCode === null) ? "" : objItem.CenterCode;
    var strCargopassOrderNo = (typeof objItem.CargopassOrderNo === "undefined" || objItem.CargopassOrderNo === null) ? "" : objItem.CargopassOrderNo;
    var strURL = "/TMS/Cargopass/CargopassIns?CenterCode=" + strCenterCode + "&CargopassOrderNo=" + strCargopassOrderNo;
    $("#IfrmCargopass").attr("src", strURL);
    $("#DivCargopassIns").show();
    return false;
}

function fnOpenCargopassDetail(objItem) {
    if (objItem.CargopassStatus == "0" || objItem.CargopassStatus == "1") {
        fnDefaultAlert("요청 상태인 연동정보는 조회할 수 없습니다.", "warning");
        return false;
    }
    var strHandlerURL = "/TMS/Cargopass/Proc/CargopassHandler.ashx";
    var strCallBackFunc = "fnOpenCargopassDetailSuccResult";
    var strFailCallBackFunc = "fnOpenCargopassDetailFailResult";

    var objParam = {
        CallType: "CargopassSessionView",
        CargopassOrderNo: objItem.CargopassOrderNo,
        CenterCode: objItem.CenterCode
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    return false;
}

function fnOpenCargopassDetailSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnOpenCargopassDetailPost(objRes[0].InsUrl, objRes[0].SessionKey, objRes[0].EncSession, objRes[0].OrderInfo);
            return false;
        } else {
            fnOpenCargopassDetailFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnOpenCargopassDetailFailResult();
        return false;
    }
}

function fnOpenCargopassDetailFailResult(strMsg) {
    strMsg = typeof strMsg === "string" ? strMsg : "";
    fnDefaultAlert("일시적인 오류가 발생하여 이용이 불가능합니다." + (strMsg === "" ? "" : ("(" + strMsg + ")")), "warning");
    return false;
}

function fnOpenCargopassDetailPost(strUrl, strSessionKey, strEncSession, strOrderInfo) {
    var newForm = $("<form></form>");
    newForm.attr("method", "post");
    newForm.attr("action", strUrl);
    newForm.attr("target", "CargopassIns");

    newForm.append($("<input/>", { type: "hidden", name: "SessionKey", value: strSessionKey }));
    newForm.append($("<input/>", { type: "hidden", name: "EncSession", value: strEncSession }));
    newForm.append($("<input/>", { type: "hidden", name: "OrderInfo", value: strOrderInfo }));

    // 새 창에서 폼을 열기
    window.open("", "CargopassIns", "width=1700, height=822, scrollbars=Yes");
    newForm.appendTo("body");
    newForm.submit().remove();
}

function fnCloseRegCargopass() {
    $("#IfrmCargopass").attr("src", "about:blank");
    $("#DivCargopassIns").hide();
    return false;
}