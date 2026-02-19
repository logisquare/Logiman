window.name = "CMPersonalSetting";
// 그리드
var GridID = "#CMPersonalSetting1Grid";
var objMainUseFlag = [{ "Code": "N", "Value": "-" }, { "Code": "Y", "Value": "기본" }];

$(document).ready(function () {

    $("#AppUseFlag").attr("disabled", true);

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

    $("#BtnInsCMAdmin").on("click", function () {
        fnInsCMAdmin();
        return false;
    });

    $("#BtnUpdCMAdminPhone").on("click", function () {
        fnUpdCMAdminPhone();
        return false;
    });

    // 그리드 초기화
    fnGridInit();
    fnCallGridData(GridID);

    // 계정 알림 정보 조회
    fnGetAdminList()

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

    //앱 다운로드 큐알 보기
    $("#ViewQR").on("mouseover", function () {
        $("#DivQRCode").css("top", $(this).offset().top + 20 + "px");
        $("#DivQRCode").css("left", $(this).offset().left + "px");
        $("#DivQRCode").fadeIn(300);
    }).on("mouseout", function () {
        $("#DivQRCode").fadeOut(300);
    });

    // 브라우저 리사이징
    $(window).on("resize", function () {
        SetGridHeight();
        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            SetGridHeight();
        }, 100);
    });
});

function SetGridHeight() {
    var objContainer = $("div.popup_control > div:nth-child(5)");
    var intHeight = $(objContainer).height();
    intHeight -= $(objContainer).children("h1").height();
    intHeight -= 44;

    AUIGrid.resize(GridID, $(GridID).parent("div").width(), intHeight);
    AUIGrid.resize(GridDetailID, $(GridDetailID).parent("div").width(), intHeight);

}

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "PhoneSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    AUIGrid.resize(GridID, $(GridID).parent("div").width(), $(GridID).parent("div").height());

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
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    objGridProps.rowIdTrustMode = true;
    objGridProps.applyRestPercentWidth = true;

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
            viewstatus: false
        },
        {
            dataField: "ChannelTypeM",
            headerText: "통신사",
            editable: false,
            width: 80,
            viewstatus: false,
            filter: { showIcon: true }
        },
        {
            dataField: "PhoneNo",
            headerText: "전화번호",
            editable: false,
            width: 120,
            viewstatus: false,
            filter: { showIcon: true },
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PhoneMemo",
            headerText: "비고",
            editable: false,
            width: 200,
            viewstatus: false,
            style: "aui-grid-text-left"
        },
        {
            dataField: "AuthID",
            headerText: "계정",
            editable: false,
            width: "70%",
            viewstatus: false,
            filter: { showIcon: true }
        },
        {
            dataField: "PhoneSeqNo",
            headerText: "일련번호",
            editable: false,
            width: "30%",
            visible: true,
            viewstatus: true
        },
        /*숨김필드*/
        {
            dataField: "MainUseFlag",
            headerText: "MainUseFlag",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ChannelType",
            headerText: "ChannelType",
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
}

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    return false;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "CMAuthPhoneAvailList",
        UseFlag: "Y",
        PageNo: 0,
        PageSize: 0
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    AUIGrid.removeAjaxLoader(GridID);

    if (objRes) {
        AUIGrid.setGridData(GridID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            // 페이징
            fnCreatePagingNavigator();
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridID, objRes[0].data.list);

        // 페이징
        fnCreatePagingNavigator();
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
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/*********************************************/


/**********************************************************/
// 오더 상세 목록 그리드
/**********************************************************/
var GridDetailID = "#CMPersonalSetting2Grid";

$(document).ready(function () {
    if ($(GridDetailID).length > 0) {
        // 그리드 초기화
        fnDetailGridInit();
        fnCallDetailGridData(GridDetailID);
    }
});

function fnDetailGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDetailGridLayout(GridDetailID, "PhoneSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDetailID, "", "", "fnDetailGridKeyDown", "fnGridSearchNotFound", "", "", "", "fnDetailGridCellDblClick");

    // 사이즈 세팅
    AUIGrid.resize(GridDetailID, $(GridDetailID).parent("div").width(), $(GridDetailID).parent("div").height());

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
    objGridProps.rowIdTrustMode = true;
    objGridProps.applyRestPercentWidth = true;

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
            dataField: "ChannelTypeM",
            headerText: "통신사",
            editable: false,
            width: 100,
            viewstatus: false,
            filter: { showIcon: true }
        },
        {
            dataField: "AuthID",
            headerText: "계정",
            editable: false,
            width: 150,
            viewstatus: false,
            filter: { showIcon: true }
        },
        {
            dataField: "PhoneNo",
            headerText: "전화번호",
            editable: false,
            width: 150,
            viewstatus: false,
            filter: { showIcon: true },
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PhoneMemo",
            headerText: "비고",
            editable: false,
            width: "100%",
            viewstatus: false,
            style: "aui-grid-text-left"
        },
        {
            dataField: "MainUseFlag",
            headerText: "기본발신",
            width: 100,
            editable: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var retStr = "";
                for (var i = 0, len = objMainUseFlag.length; i < len; i++) {
                    if (objMainUseFlag[i]["Code"] === value) {
                        retStr = objMainUseFlag[i]["Value"];
                        break;
                    }
                }
                return retStr === "" ? value : retStr;
            },
            editRenderer: {
                type: "ComboBoxRenderer",
                list: objMainUseFlag, //key-value Object 로 구성된 리스트
                keyField: "Code", // key 에 해당되는 필드명
                valueField: "Value" // value 에 해당되는 필드명
            },
            headerStyle: "aui-grid-editable_header"
        },
        {
            dataField: "PhoneSeqNo",
            headerText: "일련번호",
            editable: false,
            width: 100,
            visible: true,
            viewstatus: false
        },
        /*숨김필드*/
        {
            dataField: "CenterName",
            headerText: "CenterName",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "AuthID",
            headerText: "AuthID",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ChannelType",
            headerText: "ChannelType",
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

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnDetailGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridDetailID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return false;
    }

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

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnDetailGridSuccResult";

    var objParam = {
        CallType: "CMAdminPhoneList",
        AdminPhoneOnlyFlag: "Y",
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDetailGridSuccResult(objRes) {

    if (objRes) {
        AUIGrid.setGridData(GridDetailID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridDetailID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridDetailID);

        var objGridData = AUIGrid.getGridData(GridDetailID);
        $.each(objGridData, function (intIndex, objItem) {
            if (AUIGrid.getItemsByValue(GridID, "PhoneSeqNo", objItem.PhoneSeqNo).length > 0) {
                AUIGrid.removeRowByRowId(GridID, AUIGrid.getItemsByValue(GridID, "PhoneSeqNo", objItem.PhoneSeqNo)[0].PhoneSeqNo);
            }
        });
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDetailGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "ChannelType",
            dataField: "ChannelType",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**********************************************************/

function fnGetAdminList() {
    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnGetAdminListResult";

    var objParam = {
        CallType: "CMAdminList",
        PageSize: 1,
        PageNo: 1
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGetAdminListResult(objRes) {

    fnSetFlagInit();

    if (objRes) {
        if (objRes[0].result.ErrorCode === 0 && objRes[0].data.RecordCnt === 1)
        {
            $("#WebAlarmFlag").prop('checked', (objRes[0].data.list[0].WebAlarmFlag === "Y"));
            $("#PCAlarmFlag").prop('checked', (objRes[0].data.list[0].PCAlarmFlag === "Y"));
            $("#AutoPopupFlag").prop('checked', (objRes[0].data.list[0].AutoPopupFlag === "Y"));
            $("#OrderViewFlag").prop('checked', (objRes[0].data.list[0].OrderViewFlag === "Y"));
            $("#CompanyViewFlag").prop('checked', (objRes[0].data.list[0].CompanyViewFlag === "Y"));
            $("#PurchaseViewFlag").prop('checked', (objRes[0].data.list[0].PurchaseViewFlag === "Y"));
            $("#SaleViewFlag").prop('checked', (objRes[0].data.list[0].SaleViewFlag === "Y"));
            $("#AppUseFlag").prop('checked', (objRes[0].data.list[0].AppUseFlag === "Y"));
        }
        else if (objRes[0].result.ErrorCode !== 0)
        {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
        }
    }
    else{
        fnDefaultAlert("나중에 다시 시도해 주세요.", "warning");
    }
}

function fnSetFlagInit(){
    $("#WebAlarmFlag").prop('checked', true);
    $("#PCAlarmFlag").prop('checked', true);
    $("#AutoPopupFlag").prop('checked', false);
    $("#OrderViewFlag").prop('checked', true);
    $("#CompanyViewFlag").prop('checked', true);
    $("#PurchaseViewFlag").prop('checked', true);
    $("#SaleViewFlag").prop('checked', true);
    $("#AppUseFlag").prop('checked', false);
}

function fnInsCMAdmin() {
    fnDefaultConfirm("알람 설정 정보를 변경 하시겠습니까?", "fnInsCMAdminProc", "");
}

function fnInsCMAdminProc() {
    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnAjaxResult";

    var objParam = {
        CallType: "CMAdminInsert",
        WebAlarmFlag: $("#WebAlarmFlag").is(":checked") ? "Y" : "N",
        PCAlarmFlag: $("#PCAlarmFlag").is(":checked") ? "Y" : "N",
        AutoPopupFlag: $("#AutoPopupFlag").is(":checked") ? "Y" : "N",
        OrderViewFlag: $("#OrderViewFlag").is(":checked") ? "Y" : "N",
        CompanyViewFlag: $("#CompanyViewFlag").is(":checked") ? "Y" : "N",
        PurchaseViewFlag: $("#PurchaseViewFlag").is(":checked") ? "Y" : "N",
        SaleViewFlag: $("#SaleViewFlag").is(":checked") ? "Y" : "N"
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success");
    }
}


function fnUpdCMAdminPhone() {
    var intRowCnt = 0;
    var intMainUseFlagCnt = 0;

    var objRows = AUIGrid.getGridData(GridDetailID);
    intRowCnt = objRows.length;

    $.each(objRows, function (intIndex, objItem) {
        if (objItem.MainUseFlag === "Y") {
            intMainUseFlagCnt++;
        }
    });

    if (intRowCnt > 0 && intMainUseFlagCnt === 0)
    {
        fnDefaultAlert("기본발신 전화번호를 선택하세요.", "warning");
        return;
    }
    else if (intRowCnt > 0 && intMainUseFlagCnt > 1)
    {
        fnDefaultAlert("하나의 기본발신 전호만 선택하실 수 있습니다..", "warning");
        return;
    }

    fnDefaultConfirm("연동 전화번호를 저장하시겠습니까?", "fnUpdCMAdminPhoneProc", "");
}

function fnUpdCMAdminPhoneProc() {
    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnAjaxResult";

    var strPhoneSeqNos = "";
    var strMainUseFlags = "";

    var objRows = AUIGrid.getGridData(GridDetailID);
    intRowCnt = objRows.length;

    $.each(objRows, function (intIndex, objItem) {
        strPhoneSeqNos = strPhoneSeqNos + objItem.PhoneSeqNo + ",";
        strMainUseFlags = strMainUseFlags + objItem.MainUseFlag + ",";
    });

    strPhoneSeqNos = strPhoneSeqNos.substring(0, strPhoneSeqNos.length - 1);
    strMainUseFlags = strMainUseFlags.substring(0, strMainUseFlags.length - 1);

    var objParam = {
        CallType: "CMAdminPhoneMultiUpdate",
        PhoneSeqNos: strPhoneSeqNos,
        MainUseFlags: strMainUseFlags
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

//항목 추가
function fnAddItem() {

    var objRows = AUIGrid.getSelectedRows(GridID);
    if (objRows.length <= 0) {
        fnDefaultAlert("선택된 행이 없습니다.");
        return false;
    }

    $.each(objRows, function (intIndex, objItem) {
        var objAddItem = {
            CenterCode: typeof objItem.CenterCode != "undefined" ? objItem.CenterCode : "0",
            CenterName: typeof objItem.CenterName != "undefined" ? objItem.CenterName : "-",
            ChannelType: objItem.ChannelType,
            ChannelTypeM: objItem.ChannelTypeM,
            AuthID: objItem.AuthID,
            PhoneNo: objItem.PhoneNo,
            PhoneMemo: objItem.PhoneMemo,
            PhoneSeqNo: objItem.PhoneSeqNo,
            MainUseFlag: typeof objItem.MainUseFlag != "undefined" ? objItem.MainUseFlag : "N",
        };

        if (AUIGrid.getItemsByValue(GridDetailID, "PhoneSeqNo", objItem.PhoneSeqNo).length < 1) {
            AUIGrid.addRow(GridDetailID, objAddItem, "last");
            AUIGrid.removeRowByRowId(GridID, objItem.PhoneSeqNo);
        }
    });
}

//항목 항목삭제
function fnRemoveItem() {

    var objRows = AUIGrid.getSelectedRows(GridDetailID);
    if (objRows.length <= 0) {
        fnDefaultAlert("선택된 행이 없습니다.");
        return false;
    }

    $.each(objRows, function (intIndex, objItem) {
        var objAddItem = {
            CenterCode: typeof objItem.CenterCode != "undefined" ? objItem.CenterCode : "0",
            CenterName: typeof objItem.CenterName != "undefined" ? objItem.CenterName : "-",
            ChannelType: objItem.ChannelType,
            ChannelTypeM: objItem.ChannelTypeM,
            AuthID: objItem.AuthID,
            PhoneNo: objItem.PhoneNo,
            PhoneMemo: objItem.PhoneMemo,
            PhoneSeqNo: objItem.PhoneSeqNo,
            MainUseFlag: typeof objItem.MainUseFlag != "undefined" ? objItem.MainUseFlag : "N"
        };

        if (AUIGrid.getItemsByValue(GridID, "PhoneSeqNo", objItem.PhoneSeqNo).length < 1) {
            AUIGrid.addRow(GridID, objAddItem, "last");
            AUIGrid.removeRowByRowId(GridDetailID, objItem.PhoneSeqNo);
        }
    });
}