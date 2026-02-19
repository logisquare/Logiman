window.name = "CMConnectionSetting";
// 그리드
var GridID = "#CMConnectionAccountGrid";
var objUseFlag = [{ "Code": "N", "Value": "중지" }, { "Code": "Y", "Value": "사용" }];

$(document).ready(function () {

    $("#PhoneChannelType").prop("disabled", true);
    $("#PhoneChannelType").addClass("read");

    $("#BtnListSearch").on("click", function () {
        $("#PhoneCenterCode").val("");
        $("#PhoneAuthSeqNo").val("");
        $("#PhoneChannelType").val("");
        $("#PhoneAuthID").val("");
        fnMoveToPage(1);
        fnSetResetChangeRowStyleFunction()
        fnDetailGridInit();
        return false;
    });

    $("#BtnInsAuthInfo").on("click", function () {
        fnInsAuthInfo();
        return false;
    });

    $("#BtnDelAuthInfo").on("click", function () {
        fnDelAuthInfo();
        return false;
    });

    $("#BtnPhoneListSearch").on("click", function () {
        fnPhoneListSearch();
        return false;
    });

    $("#BtnUpdAuthPhone").on("click", function () {
        fnUpdAuthPhone();
        return false;
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
    var objContainer = $("div.list_wrap");
    var intHeight = $(objContainer).height();
    intHeight -= $(objContainer).children("div.data_list").height();
    intHeight -= $(GridID).parent("div").parent("div").children("ul.grid_option").height() + 28;
    intHeight -= $(GridID).parent("div").parent("div").children("div.form").height() + 20;
    AUIGrid.resize(GridID, $(GridID).parent("div").width(), intHeight);

    intHeight = $(objContainer).height();
    intHeight -= $(objContainer).children("div.data_list").height();
    intHeight -= $(GridDetailID).parent("div").parent("div").children("ul.grid_option").height() + 28;
    intHeight -= $(GridDetailID).parent("div").parent("div").children("div.form").height() + 20;
    AUIGrid.resize(GridDetailID, $(GridDetailID).parent("div").width(), intHeight);
}

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "AuthSeqNo");

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
            dataField: "ChannelTypeM",
            headerText: "통신사",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "AuthID",
            headerText: "계정",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "MaskAuthPwd",
            headerText: "비밀번호",
            editable: false,
            width: 100,
            viewstatus: false
        },
        {
            dataField: "AdminName",
            headerText: "관리자명",
            editable: false,
            width: 100,
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
            dataField: "UpdDate",
            headerText: "수정일",
            editable: false,
            width: 130,
            viewstatus: false
        },
        /*숨김필드*/
        {
            dataField: "AuthSeqNo",
            headerText: "AuthSeqNo",
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
            dataField: "ChannelType",
            headerText: "ChannelType",
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

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    $("#PhoneCenterCode").val(event.item.CenterCode);
    $("#PhoneAuthSeqNo").val(event.item.AuthSeqNo);
    $("#PhoneChannelType").val(event.item.ChannelType);
    $("#PhoneAuthID").val(event.item.AuthID);

    fnSetChangeRowStyleFunction(event.item.CenterCode, event.item.AuthSeqNo);
    fnCallDetailGridData(GridDetailID);

    return false;
}

function fnSetChangeRowStyleFunction(strCenterCode, strAuthSeqNo) {
    // row Styling 함수를 다른 함수로 변경
    AUIGrid.setProp(GridID, "rowStyleFunction", function (rowIndex, item) {
        if (item.CenterCode == strCenterCode && item.AuthSeqNo == strAuthSeqNo) {
            return "aui-grid-closing-y-row-style";
        }
    });

    // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
    AUIGrid.update(GridID);
}

function fnSetResetChangeRowStyleFunction() {
    // row Styling 함수를 다른 함수로 변경
    AUIGrid.setProp(GridID, "rowStyleFunction", function (rowIndex, item) {
    });

    // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
    AUIGrid.update(GridID);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "CMAuthInfoList",
        CenterCode: $("#CenterCode").val(),
        //ChannelType: $("#ChannelType").val(),
        //AuthID: $("#AuthID").val(),
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
        $("#RecordCnt").val(0);
        $("#GridResult").html("");
        AUIGrid.setGridData(GridID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            // 페이징
            fnCreatePagingNavigator();
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
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
var GridDetailID = "#CMConnectionTelGrid";

$(document).ready(function () {
    if ($(GridDetailID).length > 0) {
        // 그리드 초기화
        fnDetailGridInit();
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
    objGridProps.showStateColumn = true; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true; //엑스트라 체크박스의 헤더 전체 체크박스 설정/해제가 현재 데이터 기반으로 될지 여부를 지정합니다.
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
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
            dataField: "ChannelType",
            headerText: "통신사",
            editable: false,
            width: 0,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "AuthID",
            headerText: "계정",
            editable: false,
            width: 0,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PhoneNo",
            headerText: "전화번호",
            editable: false,
            width: 120,
            viewstatus: true,
            filter: { showIcon: true },
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PhoneMemo",
            headerText: "메모",
            editable: true,
            width: "100%",
            viewstatus: true,
            headerStyle: "aui-grid-editable_header",
            style: "aui-grid-text-left"
        },
        {
            dataField: "UseFlag",
            headerText: "상태",
            width: 70,
            editable: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var retStr = "";
                for (var i = 0, len = objUseFlag.length; i < len; i++) {
                    if (objUseFlag[i]["Code"] === value) {
                        retStr = objUseFlag[i]["Value"];
                        break;
                    }
                }
                return retStr === "" ? value : retStr;
            },
            editRenderer: {
                type: "ComboBoxRenderer",
                list: objUseFlag, //key-value Object 로 구성된 리스트
                keyField: "Code", // key 에 해당되는 필드명
                valueField: "Value" // value 에 해당되는 필드명
            },
            headerStyle: "aui-grid-editable_header"
        },
        {
            dataField: "AdminName",
            headerText: "관리자명",
            editable: false,
            width: 100,
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
            dataField: "AuthIdx",
            headerText: "AuthIdx",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PhoneIdx",
            headerText: "PhoneIdx",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "AuthSeqNo",
            headerText: "AuthSeqNo",
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

    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnDetailGridSuccResult";

    var objParam = {
        CallType: "CMAuthPhoneList",
        AuthSeqNo: $("#PhoneAuthSeqNo").val(),
        ChannelType: $("#PhoneChannelType").val(),
        PageNo: 0,
        PageSize: 0
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
            positionField: "PhoneNo",
            dataField: "PhoneNo",
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

function fnInsAuthInfo() {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("운송사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if (!$("#ChannelType").val()) {
        fnDefaultAlertFocus("통신사를 선택하세요.", "ChannelType", "warning");
        return;
    }

    if (!$("#AuthID").val()) {
        fnDefaultAlertFocus("계정을 선택하세요.", "AuthID", "warning");
        return;
    }

    fnDefaultConfirm("계정 정보를 등록/수정 하시겠습니까?", "fnInsAuthInfoProc", "");
}

function fnInsAuthInfoProc() {
    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnAjaxResult";

    var objParam = {
        CallType: "CMAuthInfoInsert",
        CenterCode: $("#CenterCode").val(),
        ChannelType: $("#ChannelType").val(),
        AuthID: $("#AuthID").val(),
        AuthPwd: $("#AuthPwd").val(),
        CenterName: $('#CenterCode option:selected').text()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

var DelAuthInfoList = null;
var DelAuthInfoPlanCnt = 0;
var DelAuthInfoProcCnt = 0;
var DelAuthInfoSuccessCnt = 0;
var DelAuthInfoFailCnt = 0;
var DelAuthInfoResultMsg = "";

function fnDelAuthInfo() {

    var intCnt = 0;

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("운송사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 계정정보가 없습니다.", "warning");
        return false;
    }

    DelAuthInfoList = [];
    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intCnt++;
        }
        DelAuthInfoList.push(item.item);
    });

    if (intCnt > 0) {
        fnDefaultAlertFocus("선택된 운송사와 다른 계정 정보가 있습니다.", "CenterCode", "warning");
        return false;
    }

    DelAuthInfoPlanCnt = DelAuthInfoList.length;
    DelAuthInfoProcCnt = 0;
    DelAuthInfoSuccessCnt = 0;
    DelAuthInfoFailCnt = 0;
    DelAuthInfoResultMsg = "";
    fnDefaultConfirm("계정 정보를 삭제 하시겠습니까?", "fnDelAuthInfoProc", "");
}

function fnDelAuthInfoProc() {
    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnDelAuthInfoSuccResult";
    var strFailCallBackFunc = "fnDelAuthInfoFailResult";

    $("#divLoadingImage").show();
    if (DelAuthInfoProcCnt >= DelAuthInfoPlanCnt) {
        $("#divLoadingImage").hide();
        fnDelAuthInfoEnd();
        return false;
    }

    var DelRow = DelAuthInfoList[DelAuthInfoProcCnt];

    if (DelRow) {
        var objParam = {
            CallType: "CMAuthInfoDelete",
            CenterCode: $("#CenterCode").val(),
            ChannelType: DelRow.ChannelType,
            AuthID: DelRow.AuthID,
            AuthSeqNo: DelRow.AuthSeqNo
        }

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnDelAuthInfoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            DelAuthInfoSuccessCnt++;
        } else {
            DelAuthInfoResultMsg += "<br>" + DelAuthInfoList[DelAuthInfoProcCnt].AuthID + " : " + objRes[0].ErrMsg;
            DelAuthInfoFailCnt++;
        }
    } else {
        DelAuthInfoFailCnt++;
    }

    DelAuthInfoProcCnt++;
    setTimeout(fnDelAuthInfoProc(), 500);
}

function fnDelAuthInfoFailResult() {
    DelAuthInfoProcCnt++;
    DelAuthInfoFailCnt++;
    setTimeout(fnDelAuthInfoProc(), 500);
    return false;
}

function fnDelAuthInfoEnd(){
    var msg = "총 " + DelAuthInfoProcCnt + "건 중 " + DelAuthInfoSuccessCnt + "건의 계정이 삭제 되었습니다.";
    if (DelAuthInfoResultMsg !== "") {
        msg += DelAuthInfoResultMsg;
    }

    fnCallGridData(GridID);
    fnDefaultAlert(msg, "info");
    return false;
}

function fnPhoneListSearch(){

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("운송사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if ($("#CenterCode").val() !== $("#PhoneCenterCode").val()) {
        fnDefaultAlertFocus("관리계정의 운송사 정보가 다릅니다.", "CenterCode", "warning");
        return;
    }

    if (!$("#PhoneChannelType").val()) {
        fnDefaultAlertFocus("관리전화번호의 통신사를 선택하세요.", "PhoneChannelType", "warning");
        return;
    }

    if (!$("#PhoneAuthID").val()) {
        fnDefaultAlertFocus("관리전화번호의 계정을 선택하세요.", "PhoneAuthID", "warning");
        return;
    }

    fnDefaultConfirm("관리 전화번호를 받으시겠습니까?", "fnPhoneListSearchProc", "");
}

function fnPhoneListSearchProc() {
    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnAjaxDetailResult";

    var objParam = {
        CallType: "CMPhoneListSearch",
        CenterCode: $("#PhoneCenterCode").val(),
        ChannelType: $("#PhoneChannelType").val(),
        AuthID: $("#PhoneAuthID").val(),
        AuthSeqNo: $("#PhoneAuthSeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success");
        fnMoveToPage(1);
    }
}

var UpdAuthPhonePlanCnt = 0;
var UpdAuthPhoneProcCnt = 0;
var UpdAuthPhoneSuccessCnt = 0;
var UpdAuthPhoneFailCnt = 0;
var UpdAuthPhoneList = null;
var UpdAuthPhoneResultMsg = "";

function fnUpdAuthPhone() {

    var EditedRowItems = AUIGrid.getEditedRowItems(GridDetailID);
    if (EditedRowItems.length <= 0) {
        fnDefaultAlert("수정된 관리전화번호 정보가 없습니다.", "warning");
        return false;
    }

    UpdAuthPhoneList = [];
    $.each(EditedRowItems, function (index, item) {
        UpdAuthPhoneList.push(item);
    });

    UpdAuthPhoneProcCnt = 0;
    UpdAuthPhoneSuccessCnt = 0;
    UpdAuthPhoneFailCnt = 0;
    UpdAuthPhoneResultMsg = "";
    UpdAuthPhonePlanCnt = UpdAuthPhoneList.length;
    fnDefaultConfirm("관리전화번호 정보를 변경하시겠습니까?", "fnUpdAuthPhoneProc", "");
}

function fnUpdAuthPhoneProc() {
    var strHandlerURL = "/TMS/CallManager/Proc/CallManagerHandler.ashx";
    var strCallBackFunc = "fnUpdAuthPhoneSuccResult";
    var strFailCallBackFunc = "fnUpdAuthPhoneFailResult";

    $("#divLoadingImage").show();
    if (UpdAuthPhoneProcCnt >= UpdAuthPhonePlanCnt) {
        $("#divLoadingImage").hide();
        fnUpdAuthPhoneEnd();
        return false;
    }

    var UpdateRow = UpdAuthPhoneList[UpdAuthPhoneProcCnt];

    if (UpdateRow) {
        var objParam = {
            CallType: "CMAuthPhoneUpdate",
            PhoneSeqNo: UpdateRow.PhoneSeqNo,
            PhoneMemo: UpdateRow.PhoneMemo,
            UseFlag: UpdateRow.UseFlag
        }

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnUpdAuthPhoneSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            UpdAuthPhoneSuccessCnt++;
        } else {
            UpdAuthPhoneResultMsg += "<br>" + UpdAuthPhoneList[UpdAuthPhoneProcCnt].AuthID + " : " + objRes[0].ErrMsg;
            UpdAuthPhoneFailCnt++;
        }
    } else {
        UpdAuthPhoneFailCnt++;
    }

    UpdAuthPhoneProcCnt++;
    setTimeout(fnUpdAuthPhoneProc(), 500);
}

function fnUpdAuthPhoneFailResult() {
    UpdAuthPhoneProcCnt++;
    UpdAuthPhoneFailCnt++;
    setTimeout(fnUpdAuthPhoneProc(), 500);
    return false;
}

function fnUpdAuthPhoneEnd(){
    var msg = "총 " + UpdAuthPhoneProcCnt + "건 중 " + UpdAuthPhoneSuccessCnt + "건의 정보가 변경되었습니다.";
    if (UpdAuthPhoneResultMsg !== "") {
        msg += UpdAuthPhoneResultMsg;
    }

    fnCallDetailGridData(GridDetailID);
    fnDefaultAlert(msg, "info");
    return false;
}

function fnAjaxDetailResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success");
        fnCallDetailGridData(GridDetailID);
    }
}