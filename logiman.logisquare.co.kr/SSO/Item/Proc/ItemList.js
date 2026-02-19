window.name = "ItemList";
// 그리드
var GridID = "#ItemGroupListGrid";

$(document).ready(function () {

    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
    });

    // 그리드 초기화
    fnGridInit();

    // 그리드 검색 이벤트
    if ($("#gridDialog").length > 0) {
        $("#BtnGridSearch").on("click", function () {
            fnSearchClick();
            return false;
        });
    }
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridID, "", "", "", "", "", "", "fnGridCellClick", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 200;
    AUIGrid.resize(GridID, $("#ItemGroupListGrid").width() - 5, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $("#ItemGroupListGrid").width() - 5, $(document).height() - 200);

        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $("#ItemGroupListGrid").width() - 5, $(document).height() - 200);
        }, 100);
    });

    fnCallGridData(GridID);

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
    objGridProps.selectionMode = "multipleRows"; // 셀 선택 모드
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
            dataField: "GroupCode",
            headerText: "그룹코드",
            editable: false,
            width: 60,
            viewstatus: true
        },
        {
            dataField: "GroupName",
            headerText: "그룹명",
            editable: false,
            width: 150,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "CenterFlag",
            headerText: "회원사별 관리 여부",
            editable: false,
            width: 60,
            viewstatus: true
        },
        {
            dataField: "AdminFlag",
            headerText: "사용자별 관리 여부",
            editable: false,
            width: 60,
            viewstatus: true
        },
        {
            dataField: "BtnItemReg",
            headerText: "항목",
            width: 50,
            editable: false,
            visible: true,
            viewstatus: true,
            renderer: {
                type: "ButtonRenderer",
                labelText: "등록",
                onClick: function (event) {
                    fnItemIns("항목 등록", event.item);
                }
            }
        }
        /*숨김필드*/
        , {
            dataField: "SeqNo",
            headerText: "SeqNo",
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

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    $("#hidGroupCode").val(objItem.GroupCode);
    $("#hidItemFullCode").val("");
    fnCallGridItemListData(GridItemListID);
    AUIGrid.setGridData(GridCenterListID, []);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/SSO/Item/Proc/ItemHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "ItemGroupList",
        GroupCode: $("#GroupCode").val(),
        GroupName: $("#GroupName").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    $("#hidGroupCode").val("");
    $("#hidItemFullCode").val("");
    AUIGrid.setGridData(GridItemListID, []);
    AUIGrid.setGridData(GridCenterListID, []);

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
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);

        // 푸터
        fnSetGridFooter(GridID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "GroupCode",
        dataField: "GroupCode",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

function fnItemIns(strTitle, Item) {
    fnOpenRightSubLayer(strTitle, "/SSO/Item/ItemIns?GroupCode=" + Item.GroupCode + "&GroupName=" + Item.GroupName, "1024px", "700px", "50%");
    return;
}


/**************************/
/*       항목  그리드     */
/**************************/
var GridItemListID = "#ItemListGrid";

$(document).ready(function () {
    setTimeout(function () {
        fnGridItemListInit();
    }, 200);
});

function fnGridItemListInit() {
    // 그리드 레이아웃 생성
    fnCreateGridItemListLayout(GridItemListID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridItemListID, "", "", "", "", "", "", "fnGridItemListCellClick", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 200;
    AUIGrid.resize(GridItemListID, $("#ItemListGrid").width() - 5, intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridItemListID, $("#ItemListGrid").width() - 5, $(document).height() - 200);

        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridItemListID, $("#ItemListGrid").width() - 5, $(document).height() - 200);
        }, 100);
    });
}

//기본 레이아웃 세팅
function fnCreateGridItemListLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleRows"; // 셀 선택 모드
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

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetItemListDefaultColumnLayout()");
    var objOriLayout = fnGetItemListDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetItemListDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "ItemFullCode",
            headerText: "항목전체코드",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "ItemCode",
            headerText: "항목코드",
            editable: false,
            width: 60,
            viewstatus: true
        },
        {
            dataField: "ItemName",
            headerText: "항목명",
            editable: false,
            width: 200,
            style: "aui-grid-text-left",
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
            dataField: "RegAdminID",
            headerText: "등록자",
            editable: false,
            width: 80,
            viewstatus: true
        }
        /*숨김필드*/
        , {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "GroupCode",
            headerText: "GroupCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "GroupName",
            headerText: "GroupName",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "ItemGroupCode",
            headerText: "ItemGroupCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "CenterFlag",
            headerText: "CenterFlag",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "AdminFlag",
            headerText: "AdminFlag",
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

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridItemListCellClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridItemListID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    $("#hidGroupCode").val(objItem.GroupCode);
    $("#hidItemFullCode").val(objItem.ItemFullCode);
    AUIGrid.setSelectionByIndex(GridID, AUIGrid.getRowIndexesByValue(GridID, "GroupCode", $("#hidGroupCode").val())[0]);

    if (objItem.CenterFlag === "Y") {
        fnCallGridCenterListData(GridCenterListID, objItem.ItemFullCode);
    } else {
        AUIGrid.setGridData(GridCenterListID, []);
    }
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridItemListData(strGID) {

    var strHandlerURL = "/SSO/Item/Proc/ItemHandler.ashx";
    var strCallBackFunc = "fnGridItemListSuccResult";
    var strGroupCode = $("#hidGroupCode").val();

    if (strGroupCode == null || strGroupCode === "") {
        AUIGrid.setGridData(GridItemListID, []);
        AUIGrid.setGridData(GridCenterListID, []);
        return;
    }

    var objParam = {
        CallType: "ItemList",
        GroupCode: strGroupCode
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    AUIGrid.setGridData(GridCenterListID, []);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridItemListSuccResult(objRes) {
    AUIGrid.removeAjaxLoader(GridItemListID);

    if (objRes) {
        $("#GridResult2").html("");
        AUIGrid.setGridData(GridItemListID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#GridResult2").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridItemListID, objRes[0].data.list);

        // 푸터
        fnSetGridItemListFooter(GridItemListID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridItemListFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "GroupCode",
        dataField: "GroupCode",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}


/**************************/
/*     회원사  그리드     */
/**************************/
var GridCenterListID = "#ItemCenterListGrid";

$(document).ready(function () {
    setTimeout(function () {
        fnGridCenterListInit();
    }, 200);
});

function fnGridCenterListInit() {
    // 그리드 레이아웃 생성
    fnCreateGridCenterListLayout(GridCenterListID, "No");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridCenterListID, "", "", "", "", "fnGridCenterListHeaderClick", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 200;
    AUIGrid.resize(GridCenterListID, $("#ItemCenterListGrid").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridCenterListID, $("#ItemCenterListGrid").width(), $(document).height() - 200);

        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridCenterListID, $("#ItemCenterListGrid").width(), $(document).height() - 200);
        }, 100);
    });
}

//기본 레이아웃 세팅
function fnCreateGridCenterListLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleRows"; // 셀 선택 모드
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
    objGridProps.filterMenuCenterMaxCount = 200; //필터링 가능한 체크박스의 최대값

    var strCenterKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strCenterKey, "fnGetCenterListDefaultColumnLayout()");
    var objOriLayout = fnGetCenterListDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetCenterListDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "UseFlag",
            headerText: '<input type="checkbox" id="AllCheck" /><label for="AllCheck"><span></span>사용여부</label>',
            width: 100,
            renderer: {
                type: "CheckBoxEditRenderer",
                showLabel: false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                editable: true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue: "Y", // true, false 인 경우가 기본
                unCheckValue: "N"
            }
        },
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 200,
            viewstatus: true
        }
        /*숨김필드*/
        ,{
            dataField: "No",
            headerText: "No",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "GroupCode",
            headerText: "GroupCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "GroupName",
            headerText: "GroupName",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "ItemCode",
            headerText: "ItemCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "ItemFullCode",
            headerText: "ItemFullCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        },
        {
            dataField: "ItemName",
            headerText: "ItemName",
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


// 그리드 헤더 클릭 핸들러
function fnGridCenterListHeaderClick(event) {
    // isActive 칼럼 클릭 한 경우
    if (event.dataField === "UseFlag") {
        if (event.orgEvent.target.id === "AllCheck") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var isChecked = document.getElementById("AllCheck").checked;
            fnCheckAll(isChecked);
        }
        return false;
    }
};

// 전체 체크 설정, 전체 체크 해제 하기
function fnCheckAll(isChecked) {

    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if (isChecked) {
        AUIGrid.updateAllToValue(GridCenterListID, "UseFlag", "Y");
    } else {
        AUIGrid.updateAllToValue(GridCenterListID, "UseFlag", "N");
    }
    // 헤더 체크 박스 일치시킴.
    document.getElementById("AllCheck").checked = isChecked;
};

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridCenterListData(strGID) {

    var strHandlerURL = "/SSO/Item/Proc/ItemHandler.ashx";
    var strCallBackFunc = "fnGridCenterListSuccResult";
    var strItemFullCode = $("#hidItemFullCode").val();

    if (strItemFullCode == null || strItemFullCode === "") {
        AUIGrid.setGridData(GridCenterListID, []);
        return;
    }

    var objParam = {
        CallType: "ItemCenterList",
        ItemFullCode: strItemFullCode
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    AUIGrid.setGridData(GridCenterListID, []);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCenterListSuccResult(objRes) {
    AUIGrid.removeAjaxLoader(GridCenterListID);

    if (objRes) {
        $("#GridResult3").html("");
        AUIGrid.setGridData(GridCenterListID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#GridResult3").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridCenterListID, objRes[0].data.list);

        // 푸터
        fnSetGridCenterListFooter(GridCenterListID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridCenterListFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "CenterName",
        dataField: "CenterName",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

var ItemCenterList = null;
var ItemCnt = 0;
var ItemProcCnt = 0;
var ItemSuccessCnt = 0;
var ItemFailCnt = 0;

//회원사 항목 등록
function fnItemCenterIns() {
    var GridItems = AUIGrid.getGridData(GridCenterListID);
    ItemCenterList = [];
    $.each(GridItems, function (index, item) {
        if (item.OrgUseFlag !== item.UseFlag || item.SeqNo === 0) {
            ItemCenterList.push(item);
        }
    });

    if (ItemCenterList.length > 0) {
        ItemCnt = ItemCenterList.length;
        ItemProcCnt = 0;
        ItemSuccessCnt = 0;
        ItemFailCnt = 0;
        fnDefaultConfirm("회원사 항목 정보를 등록 하시겠습니까?", "fnItemCenterInsProc", "");
    } else {
        fnDefaultAlert("등록할 회원사 항목 정보가 없습니다.");
        return false;
    }
}

function fnItemCenterInsProc() {
    AUIGrid.showAjaxLoader(GridCenterListID);
    if (ItemProcCnt >= ItemCnt) {
        AUIGrid.removeAjaxLoader(GridCenterListID);

        if (ItemFailCnt > 0) {
            fnDefaultAlert("일부 회원사 항목 정보가 등록되지 않았습니다.", "warning");
        } else {
            fnDefaultAlert(ItemSuccessCnt + "건의 회원사 항목 정보가 등록되었습니다.", "success");
        }

        fnCallGridCenterListData(GridCenterListID);
        return;
    }

    var RowItem = ItemCenterList[ItemProcCnt];
    RowItem.CallType = "ItemCenterInsert";

    if (RowItem) {
        var strHandlerURL = "/SSO/Item/Proc/ItemHandler.ashx";
        var strCallBackFunc = "fnGridCenterInsSuccResult";
        var strFailCallBackFunc = "fnGridCenterInsFailResult";
        var objParam = RowItem;
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnGridCenterInsSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            ItemSuccessCnt++;
        } else {
            ItemFailCnt++;
        }
    } else {
        ItemFailCnt++;
    }
    ItemProcCnt++;
    setTimeout(fnItemCenterInsProc(), 500);
}

function fnGridCenterInsFailResult() {
    ItemProcCnt++;
    ItemFailCnt++;
    setTimeout(fnItemCenterInsProc(), 500);
    return false;
}

//항목 JSON 파일 생성
function fnMakeItemJson() {
    fnDefaultConfirm("항목 정보를 적용 하시겠습니까?", "fnMakeItemJsonProc", "");
}

function fnMakeItemJsonProc() {

    var strHandlerURL = "/SSO/Item/Proc/ItemHandler.ashx";
    var strCallBackFunc = "fnMakeItemJsonSuccResult";
    var strFailCallBackFunc = "fnMakeItemJsonFailResult";

    var objParam = {
        CallType: "MakeItemJson"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnMakeItemJsonSuccResult(objRes) {

    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnDefaultAlert(objRes[0].ErrMsg, "warning");
            return false;
        }

        fnDefaultAlert("항목 적용이 완료되었습니다.", "success");
        return false;
    }
}

function fnMakeItemJsonFailResult() {
    fnDefaultAlert("항목 적용에 실패했습니다.");
    return false;
}