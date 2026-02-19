// 그리드
var GridID = "#AdminListGrid";
var GridSort = [];

$(document).ready(function () {
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
    fnCreateGridLayout(GridID, "AdminID");

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

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'AdminListGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "CenterName",
            headerText: "회원사",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GradeCodeM",
            headerText: "사용자 등급",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "AdminID",
            headerText: "아이디",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "AdminName",
            headerText: "이름",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "MobileNo",
            headerText: "휴대폰",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "AdminPosition",
            headerText: "직급",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DeptName",
            headerText: "소속",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DupLoginFlagM",
            headerText: "중복로그인 여부",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "MyOrderFlagM",
            headerText: "내오더만 조회 여부",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "RegDate",
            headerText: "가입일시",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "UseFlagM",
            headerText: "사용여부",
            editable: false,
            width: 80,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var retStr = item.UseFlagM;

                if (item.UseFlag === "D") {
                    retStr += retStr + "(" + item.ExitDate + ")";
                }

                return retStr;
            },
            viewstatus: true
        },
        {
            dataField: "BtnMenuAccess",
            headerText: "메뉴사용",
            editable: false,
            width: 150,
            renderer: {
                type: "ButtonRenderer",
                labelText: "메뉴사용권한",
                onClick: function (event) {
                    fnMenuAccess(event.item.AdminID, event.item.MobileNo);
                },
                visibleFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    if (item.GradeCode !== 1) {
                        return true;
                    } else {
                        return false;
                    }

                    
                }
            }
        },
        {
            dataField: "BtnSendResetPwd",
            headerText: "신규 비밀번호",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "전송",
                onClick: function (event) {
                    fnSendResetPassword(event.item.AdminID, event.item.MobileNo);
                }
            }
        },
        {
            dataField: "BtnResetAdmin",
            headerText: "접속초기화",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "Reset",
                onClick: function (event) {
                    fnResetAdmin(event.item.AdminID);
                }
            }
        },
        {
            dataField: "BtnInsAdmin",
            headerText: "조회",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "조회",
                onClick: function (event) {
                    fnInsAdmin(event.item.AdminID);
                }
            }
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

    fnInsAdmin(objItem.AdminID);
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/SSO/Admin/Proc/AdminHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "AdminList",
        CenterCode: $("#CenterCode").val(),
        GradeCode: $("#GradeCode").val(),
        UseFlag: $("#UseFlag").val(),
        SearchType: $("#SearchType").val(),
        ListSearch: $("#ListSearch").val(),
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

        // 푸터
        fnSetGridFooter(GridID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {

    // 푸터 설정
/*
    var GridFooterObject = [{
        positionField: "OrderRequestStatusM",
        dataField: "OrderRequestStatusM",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
*/
}

function fnInsAdmin(strAdminID) {
    var title = "관리자 등록";
    if (typeof strAdminID !== "undefined" && strAdminID !== "") {
        title = "관리자 수정";
    }

    fnOpenRightSubLayer(title, "/SSO/Admin/AdminIns.aspx?AdminID=" + strAdminID, "1024px", "700px", "50%");
}

function fnMenuAccess(strAdminID) {
    fnOpenRightSubLayer("관리자 메뉴 권한 설정", "/SSO/Admin/AdminMenuAccessUpd.aspx?AdminID=" + strAdminID, "1024px", "700px", "50%");
}

function fnResetAdmin(strAdminID) {
    var strConfMsg = "로그인 접속을 초기화 하시겠습니까?";
    var objFnParam = {
        AdminID: strAdminID
    }

    fnDefaultConfirm(strConfMsg, "fnResetAdminProc", objFnParam);
    return;
}

function fnResetAdminProc(objParam) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminHandler.ashx";
    var strCallBackFunc = "fnAjaxResetAdmin";
    var objFnParam = {
        CallType: "AdminLoginReset",
        AdminID: objParam.AdminID
    }

    UTILJS.Ajax.fnHandlerRequest(objFnParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxResetAdmin(objData) {

    if (objData[0].RetCode !== 0) {
        fnDefaultAlert("초기화를 실패하였습니다. 나중에 다시 시도해 주세요.(" + objData[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("로그인 접속이 초기화 되었습니다.", "success");
    }

    return;
}

function fnSendResetPassword(strAdminID, strMobileNo) {
    var strConfMsg = "비밀번호를 전송하시겠습니까?";
    var objFnParam = {
        AdminID: strAdminID,
        MobileNo: strMobileNo
    }

    fnDefaultConfirm(strConfMsg, "fnSendResetPasswordProc", objFnParam);
}

function fnSendResetPasswordProc(objParam) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminHandler.ashx";
    var strCallBackFunc = "fnAjaxSendPwdSuccResult";

    var objFnParam = {
        CallType: "AdminSendPwd",
        AdminID: objParam.AdminID,
        MobileNo: objParam.MobileNo
    }
    UTILJS.Ajax.fnHandlerRequest(objFnParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxSendPwdSuccResult(objData) {

    if (objData[0].RetCode !== 0) {
        fnDefaultAlert("신규 비밀번호 전송을 실패하였습니다. 나중에 다시 시도해 주세요.(" + objData[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("신규 비밀번호 전송을 완료하였습니다.", "success");
    }

    return;
}