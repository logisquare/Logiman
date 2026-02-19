// 그리드
var GridID = "#WebTransInoutListGrid";
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

    fnGridInit();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "DispatchSeqNo");
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = 600;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 50);
    });

    //fnCallGridData(GridID);

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
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = false; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'WebTransInoutListGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 숨김필드 */
        /*************/
        {
            dataField: "OrderNo",
            headerText: "일련번호",
            editable: false,
            width: 0
        },
        /*************/
        /* 일반필드 */
        /*************/
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
                    "배차(예정)": "/js/lib/AUIGrid/assets/blue_circle.png",
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
            dataField: "PickupPlace",
            headerText: "상차지명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        }, {
            dataField: "PickupYMD",
            headerText: "상차일",
            editable: false,
            width: 150,
            viewstatus: true
        }, {
            dataField: "GetPlace",
            headerText: "하차지명",
            editable: false,
            width: 150,
            viewstatus: true
        }, {
            dataField: "GetYMD",
            headerText: "하차일",
            editable: false,
            width: 150,
            viewstatus: true
        }, {
            dataField: "Volume",
            headerText: "수량",
            editable: false,
            width: 150,
            viewstatus: true
        }, {
            dataField: "Weight",
            headerText: "중량",
            editable: false,
            width: 150,
            viewstatus: true
        }, {
            dataField: "DispatchCarInfo1",
            headerText: "차량정보",
            editable: false,
            width: 630,
            viewstatus: true
        },
        {
            dataField: "InCarDt",
            headerText: "입차",
            editable: false,
            width: 250,
            viewstatus: true,
            formatString: "yyyy-mm-dd hh:MM:ss",
            renderer: {
                type: "TemplateRenderer"
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) { // HTML 템플릿 작성
                var template = "<button type='button' class='submit_button' onclick='fnOrderInOutUpd(\"" + item.CenterCode + "\", \"" + item.DispatchSeqNo + "\",1);'>확인</button>";
                var data = "<div style='line-height:20px; font-weight:bold; font-size:12px;'>" + item.InCarDt + "<button type='button' onclick='fnOrderInOutUpd(\"" + item.CenterCode + "\", \"" + item.DispatchSeqNo + "\",1, \"Y\");' style='background:#d7d7d7; font-size:12px; border:1px solid #515151; border-radius:10px; color:#515151; margin-left:15px; min-width:50px; line-height:16px; opacity:0.7;'>초기화</button></div>";
                if (item.InCarDt != "N" && item.InCarDt != "" && item.InCarDt != "0") {
                    return data; // HTML 형식의 스트링
                }
                return template; // HTML 형식의 스트링
            }
        },
        {
            dataField: "OutCarDt",
            headerText: "출차",
            editable: false,
            width: 250,
            viewstatus: true,
            formatString: "yyyy-mm-dd hh:MM:ss",
            renderer: {
                type: "TemplateRenderer"
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) { // HTML 템플릿 작성
                var template = "<button type='button' class='submit_button' onclick='fnOrderInOutUpd(\"" + item.CenterCode + "\", \"" + item.DispatchSeqNo + "\",2);'>확인</button>";
                var data = "<div style='line-height:20px; font-weight:bold; font-size:12px;'>" + item.OutCarDt + "<button type='button' onclick='fnOrderInOutUpd(\"" + item.CenterCode + "\", \"" + item.DispatchSeqNo + "\",2, \"Y\");' style='background:#d7d7d7; font-size:12px; border:1px solid #515151; border-radius:10px; color:#515151; margin-left:15px; min-width:50px; line-height:16px; opacity:0.7;'>초기화</button></div>";
                if (item.OutCarDt != "N" && item.OutCarDt != "" && item.OutCarDt != "0") {
                    return data; // HTML 형식의 스트링
                }
                return template; // HTML 형식의 스트링
            }
        }, {
            dataField: "MooringTime",
            headerText: "계류시간(분)",
            editable: false,
            width: 100,
            viewstatus: true
        }, {
            dataField: "InOutEtc",
            headerText: "비고",
            editable: true,
            width: 150,
            viewstatus: true
        }, {
            dataField: "BtnInoutNoteUpd",
            headerText: "비고수정",
            editable: false,
            width: 150,
            viewstatus: true,
            renderer: {
                type: "ButtonRenderer",
                labelText: "수정",
                onClick: function (event) {
                    fnOrderInOutUpd(event.item.CenterCode, event.item.DispatchSeqNo, 0, 'N', event.item.InOutEtc);
                    return;
                }
            }
        }
        /*숨김필드*/
        , {
            dataField: "DispatchSeqNo",
            headerText: "배차번호",
            width: 0,
            viewstatus: false,
            visible : false
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

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/WEB/Manage/Proc/WebTransInoutHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "WebOrderList",
        CenterCode: $("#CenterCode").val(),
        ListType: "1",
        DateType: "1",
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        MyOrderFlag: "N",
        CnlFlag: "N",
        PageSize: $("#PageSize").val(),
        PageNo: $("#PageNo").val()
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

function fnOrderInOutUpd(objCenterCode, objDispatchSeqNo, objType, objCnlFlag, objInOutEtc) {
    if (objDispatchSeqNo == "0" || objDispatchSeqNo == "") {
        fnDefaultAlert("배차 된 오더만 수정이 가능합니다.");
        return;
    }
    //objType 1: 입차, 2:출차
    var strHandlerURL = "/WEB/Manage/Proc/WebTransInoutHandler.ashx";
    var strCallBackFunc = "fnOrderInOutSuccResult";

    var objParam = {
        CallType: "OrderInoutIns",
        DispatchSeqNo: objDispatchSeqNo,
        CenterCode: objCenterCode,
        InOutType: objType,
        CnlFlag: objCnlFlag,
        InOutEtc: objInOutEtc,
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(GridID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnOrderInOutSuccResult(data) {
    AUIGrid.removeAjaxLoader(GridID);
    if (data[0].RetCode != 0) {
        fnDefaultAlert(data[0].ErrMsg, "warning");
        return;
    } else {
        fnDefaultAlert("처리되었습니다.", "success");
        fnCallGridData(GridID);
        return;
    }
}
