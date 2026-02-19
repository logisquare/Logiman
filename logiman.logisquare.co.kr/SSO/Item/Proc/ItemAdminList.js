window.name = "ItemAdminList";
// 그리드
var GridID = "#ItemGroupListGrid";

$(document).ready(function () {
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
    fnCallGridAdminListData(GridAdminListID);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/SSO/Item/Proc/ItemAdminHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "ItemGroupList",
        AdminFlag: "Y"
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    $("#hidGroupCode").val("");
    AUIGrid.setGridData(GridAdminListID, []);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    AUIGrid.removeAjaxLoader(GridID);

    if (objRes) {
        $("#GridResult").html("");
        $("#RecordCnt").val(0);
        AUIGrid.setGridData(GridID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        $("#RecordCnt").val(objRes[0].data.RecordCnt);
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
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

/**************************/
/*     회원사  그리드     */
/**************************/
var GridAdminListID = "#ItemAdminListGrid";
var objSortList = [];

$(document).ready(function () {
    setTimeout(function () {
        fnGridAdminListInit();
    }, 200);
});

function fnGridAdminListInit() {
    // 그리드 레이아웃 생성
    fnCreateGridAdminListLayout(GridAdminListID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridAdminListID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 200;
    AUIGrid.resize(GridAdminListID, $("#ItemAdminListGrid").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridAdminListID, $("#ItemAdminListGrid").width(), $(document).height() - 200);

        clearTimeout(window.resizedEnd2);
        window.resizedEnd2 = setTimeout(function () {
            AUIGrid.resize(GridAdminListID, $("#ItemAdminListGrid").width(), $(document).height() - 200);
        }, 100);
    });
}

//기본 레이아웃 세팅
function fnCreateGridAdminListLayout(strGID, strRowIdField) {

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
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
    objGridProps.showRowAllCheckBox = false; // 전체 체크박스 표시
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuCenterMaxCount = 200; //필터링 가능한 체크박스의 최대값

    var strCenterKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strCenterKey, "fnGetAdminListDefaultColumnLayout()");
    var objOriLayout = fnGetAdminListDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 체크박스 클릭 이벤트 바인딩
    AUIGrid.bind(strGID, "rowCheckClick", function (event) {
        fnSetAdminGridData(event);
    });

    AUIGrid.bind(strGID, ["cellEditBegin", "cellEditEnd"], fnGridCellEditingHandler);
};

function fnSetAdminGridData(event) {
    objSortList = [];
    var objItems = AUIGrid.getCheckedRowItems(event.pid);
    var cnt = objItems.length;
    for (var i = 1; i <= objItems.length; i++) {
        objSortList.push(i);
    }

    var objItem = event.item;
    if (event.checked) {
        objItem.AdminSort = cnt;
        AUIGrid.updateRowsById(event.pid, objItem);
    } else {
        fnSetAdminGridDataSort(objItem.AdminSort, 0, objItem.SeqNo, "Delete");
        objItem.AdminSort = 0;
        AUIGrid.updateRowsById(event.pid, objItem);
    }
}

function fnSetAdminGridDataSort(intAdminSort, intAdminSortBefore, intSeqNo, strMode) {
    if (typeof intAdminSort == "string") {
        intAdminSort = parseInt(intAdminSort);
    }

    if (typeof intAdminSortBefore == "string") {
        intAdminSortBefore = parseInt(intAdminSortBefore);
    }

    var objItems = AUIGrid.getCheckedRowItems(GridAdminListID);

    if (strMode == "Delete") {
        $.each(objItems, function (index, item) {
            if (Number(item.item.AdminSort) >= intAdminSort) {
                item.item.AdminSort = Number(item.item.AdminSort) - 1;
                AUIGrid.updateRowsById(GridAdminListID, item.item);
            }
        });
    } else if (strMode == "Change") {
        if (intAdminSort == intAdminSortBefore) {
            return false;
        }

        $.each(objItems, function (index, item) {
            if (intAdminSort > intAdminSortBefore) { //변경한 값이 원래 값보다 크면
                if (Number(item.item.AdminSort) <= intAdminSort && Number(item.item.AdminSort) > intAdminSortBefore) {
                    if (item.item.SeqNo != intSeqNo ) {
                        item.item.AdminSort = Number(item.item.AdminSort) - 1;
                        AUIGrid.updateRowsById(GridAdminListID, item.item);
                    }
                }
            } else if (intAdminSort < intAdminSortBefore) { //변경한 값이 원래 값보다 작으면
                if (Number(item.item.AdminSort) >= intAdminSort && Number(item.item.AdminSort) < intAdminSortBefore) {
                    if (item.item.SeqNo != intSeqNo) {
                        item.item.AdminSort = Number(item.item.AdminSort) + 1;
                        AUIGrid.updateRowsById(GridAdminListID, item.item);
                    }
                }
            }
        });
    }
}

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetAdminListDefaultColumnLayout() {
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
            visible: false,
            width: 0,
            viewstatus: false
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
            dataField: "AdminSort",
            headerText: "순서",
            editable: true,
            width: 80,
            viewstatus: true,
            editRenderer: {
                type: "DropDownListRenderer",
                autoCompleteMode: true, // 자동완성 모드 설정
                listFunction: function (rowIndex, columnIndex, item, dataField) {
                    return objSortList;
                }
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var retStr = value == "0" ? "" : value;
                return retStr;
            }
        }
        /*숨김필드*/
        ,
        {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }
        ,
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
            dataField: "OrgBookmarkFlag",
            headerText: "OrgBookmarkFlag",
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
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

function fnGridCellEditingHandler(event) {
    if (event.type === "cellEditBegin") {
        if (event.dataField === "AdminSort") {
            if (!AUIGrid.isCheckedRowById(event.pid, event.item.SeqNo)) {
                return false;
            }
        }
    } else if (event.type == "cellEditEnd") {
        if (event.dataField === "AdminSort") {
            fnSetAdminGridDataSort(event.value, event.oldValue, event.item.SeqNo, "Change");
        }
    }
};

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridAdminListData(strGID) {

    var strHandlerURL = "/SSO/Item/Proc/ItemAdminHandler.ashx";
    var strCallBackFunc = "fnGridAdminListSuccResult";
    var strGroupCode = $("#hidGroupCode").val();

    if (strGroupCode == null || strGroupCode === "") {
        fnDefaultAlert("그룹명을 선택하세요.");
        AUIGrid.setGridData(GridAdminListID, []);
        return;
    }

    var objParam = {
        CallType: "ItemAdminList",
        GroupCode: strGroupCode
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    AUIGrid.setGridData(GridAdminListID, []);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridAdminListSuccResult(objRes) {
    AUIGrid.removeAjaxLoader(GridAdminListID);

    if (objRes) {

        $("#GridResult2").html("");
        AUIGrid.setGridData(GridAdminListID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#GridResult2").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridAdminListID, objRes[0].data.list);

        // 푸터
        fnSetGridAdminListFooter(GridAdminListID);

        //기본 데이터 처리
        fnSetAdminGridDefaultData();
    }
}

function fnSetAdminGridDefaultData() {
    var objNumberList = [];
    objSortList = [];
    var objCheckedItem = [];
    var objCheckedNoSortItem = [];
    var objItems = AUIGrid.getItemsByValue(GridAdminListID, "OrgBookmarkFlag", "Y");

    for (var i = 1; i <= objItems.length; i++) {
        objSortList.push(i);
        objCheckedItem.push(objItems[i - 1].SeqNo);
        if (typeof objItems[i - 1].AdminSort !== "number" || objItems[i - 1].AdminSort  == 0) {
            objNumberList.push(i);
            objCheckedNoSortItem.push(objItems[i - 1]);
        }
    }

    AUIGrid.setCheckedRowsByIds(GridAdminListID, objCheckedItem);

    if (objCheckedNoSortItem.length > 0) {
        $.each(objCheckedNoSortItem,
            function(index, item) {
                item.AdminSort = objNumberList[index];
                AUIGrid.updateRowsById(GridAdminListID, item);
            });
    }

    return false;
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridAdminListFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

var ItemAdminList = null;
var ItemCnt = 0;
var ItemProcCnt = 0;
var ItemSuccessCnt = 0;
var ItemFailCnt = 0;

//회원사 항목 등록
function fnItemAdminIns() {
    var GridItems = AUIGrid.getGridData(GridAdminListID);
    ItemAdminList = [];
    $.each(GridItems, function (index, item) {
        var oldItem = AUIGrid.getInitValueItem(GridAdminListID, item.SeqNo);
        item.BookmarkFlag = AUIGrid.isCheckedRowById(GridAdminListID, item.SeqNo) ? "Y" : "N";
        var changeSort = false;
        if (oldItem != null) {
            if (typeof oldItem.AdminSort != "undefined") {
                if (item.AdminSort != oldItem.AdminSort) {
                    changeSort = true;
                }
            }
        }
        if (item.OrgBookmarkFlag !== item.BookmarkFlag || changeSort ) {
            ItemAdminList.push(item);
        }
    });

    if (ItemAdminList.length > 0) {
        ItemCnt = ItemAdminList.length;
        ItemProcCnt = 0;
        ItemSuccessCnt = 0;
        ItemFailCnt = 0;
        fnDefaultConfirm("사용자 항목 정보를 등록 하시겠습니까?", "fnItemAdminInsProc", "");
    } else {
        fnDefaultAlert("등록할 사용자 항목 정보가 없습니다.");
        return false;
    }
}

function fnItemAdminInsProc() {
    AUIGrid.showAjaxLoader(GridAdminListID);
    if (ItemProcCnt >= ItemCnt) {
        AUIGrid.removeAjaxLoader(GridAdminListID);

        if (ItemFailCnt > 0) {
            fnDefaultAlert("일부 사용자 항목 정보가 등록되지 않았습니다.", "warning");
        } else {
            fnDefaultAlert(ItemSuccessCnt + "건의 사용자 항목 정보가 등록되었습니다.", "success");
        }

        fnCallGridAdminListData(GridAdminListID);
        return;
    }

    var RowItem = ItemAdminList[ItemProcCnt];
    RowItem.CallType = "ItemAdminInsert";

    if (RowItem) {
        var strHandlerURL = "/SSO/Item/Proc/ItemAdminHandler.ashx";
        var strCallBackFunc = "fnGridAdminInsSuccResult";
        var strFailCallBackFunc = "fnGridAdminInsFailResult";
        var objParam = RowItem;
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
    }
}

function fnGridAdminInsSuccResult(objRes) {
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
    setTimeout(fnItemAdminInsProc(), 500);
}

function fnGridAdminInsFailResult() {
    ItemProcCnt++;
    ItemFailCnt++;
    setTimeout(fnItemAdminInsProc(), 500);
    return false;
}

//항목 JSON 파일 생성
function fnMakeItemJson() {
    fnDefaultConfirm("항목 정보를 적용 하시겠습니까?", "fnMakeItemJsonProc", "");
}

function fnMakeItemJsonProc() {

    var strHandlerURL = "/SSO/Item/Proc/ItemAdminHandler.ashx";
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