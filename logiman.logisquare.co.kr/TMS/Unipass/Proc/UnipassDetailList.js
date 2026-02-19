// 그리드
var GridID = "#UnipassListGrid";
var GridSort = [];

$(document).ready(function () {
    // 그리드 초기화
    fnGridInit();

    if ($("#HidMode").val() === "Inout") {
        $("#SearchType").val("HBL");
        $("#SearchText").val($("#Hawb").val());
        $("#SearchYear").show();
        $("#SearchYear").val($("#PickupYMD").val());
        fnSearchData();
        return;
    } else if ($("#HidMode").val() === "Container") {
        $("#SearchType").val("HBL");
        $("#SearchText").val($("#BLNo").val());
        $("#SearchYear").show();
        $("#SearchYear").val($("#PickupYMD").val());
        fnSearchData();
        return;
    }

    
});

function fnSearchData() {
    fnCallGridData(GridID);
}


function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "");

    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 420;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

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
    //objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.reverseRowNum = true; //넘버링 역순

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'UnipassListGrid');
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
            dataField: "prcsDttm",
            headerText: "처리일시",
            editable: false,
            width: 150,
            viewstatus: true,
            dataType: "date",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return fnDataFullFormat(value);
            }
        },
        {
            dataField: "cargTrcnRelaBsopTpcd",
            headerText: "처리단계",
            editable: false,
            width: 150,
            viewstatus: true,
            filter: { showIcon: true }
        }, {
            dataField: "shedNm",
            headerText: "장치장명",
            editable: false,
            width: 150,
            viewstatus: true,
            filter: { showIcon: true }
        }, {
            dataField: "shedSgn",
            headerText: "장치장 / 장치위치",
            editable: false,
            width: 150,
            viewstatus: true,
            filter: { showIcon: true },
            styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                if (value !== "") {
                    return "my-cell-style-color";
                }
                return null;
            }
        }, {
            dataField: "pckGcnt",
            headerText: "포장개수",
            editable: false,
            width: 150,
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (value === "") {
                    return "0" + item.pckUt;
                }
                return value + item.pckUt;
            }
        }, {
            dataField: "wght",
            headerText: "중량",
            editable: false,
            width: 150,
            viewstatus: true,
            dataType: "numeric",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (value === "") {
                    return "0" + item.wghtUt;
                }
                return value.toLocaleString() + item.wghtUt;
            }
        },
        {
            dataField: "rlbrDttm",
            headerText: "반출입(처리)일시",
            editable: false,
            width: 150,
            viewstatus: true
        },{
            dataField: "rlbrCn",
            headerText: "반출입(처리)내용",
            editable: false,
            width: 150,
            viewstatus: true
        },{
            dataField: "dclrNo",
            headerText: "신고번호",
            editable: false,
            width: 150,
            viewstatus: true
        },{
            dataField: "rlbrBssNo",
            headerText: "반출입근거번호",
            editable: false,
            width: 150,
            viewstatus: true,
            filter: { showIcon: true }
        },{
            dataField: "bfhnGdncCn",
            headerText: "사전안내",
            editable: false,
            width: 350,
            viewstatus: true
        },

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

    if (strKey === "shedSgn") {
        window.open('/TMS/Unipass/UnipassShedInfo?shedSgn=' + event.item.shedSgn.substring(0,8), '장치장 정보', 'width=830px,height=300px,scrollbars=yes');
        return;
    }
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {

    var strHandlerURL = "/TMS/Unipass/Proc/UnipassHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "GetUnipassDetailInfo",
        SearchType: $("#SearchType").val(),
        SearchText: $("#SearchText").val().replace(/ /g, ''),
        SearchYear: $("#SearchYear").val()
    };
    
    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].Header.ResultCode !== 0) {
            AUIGrid.setGridData(GridID, []);
            // 페이징
            fnCreatePagingNavigator();
            fnDefaultAlert(objRes[0].Header.ResultMessage, "warning");
            $("#ContainerBtn").hide();
            AUIGrid.removeAjaxLoader(GridID);
            return false;
        }
        AUIGrid.setGridData(GridID, objRes[0].Payload.List);
        AUIGrid.removeAjaxLoader(GridID);

        // 페이징
        fnCreatePagingNavigator();

        // 그리드 정렬
        AUIGrid.setSorting(GridID, GridSort);

        //상세정보 출력
        fnUnipassDetail(objRes[0]);
        return false;
    }
}

function fnUnipassDetail(objData) {
    if (objData) {
        var item = objData.Payload.Info;
        if (objData.Payload.Common.tCnt > 0) {
            $.each($("span"),
                function (index, input) {
                    if (eval("item." + $(input).attr("id")) != null) {
                        $("#" + $(input).attr("id")).text(eval("item." + $(input).attr("id")));
                    }
                });
            $("#etprDt").text(fnGetStrDateFormat(item.etprDt, "-"));
            $("#prcsDttm").text(fnDataFullFormat(item.prcsDttm));
            $("#HidcargMtNo").val(item.cargMtNo);
            $("#ContainerBtn").show();
            $("#ttwg").text(fnMoneyComma(item.ttwg));
            
            if (item.cargMtNo.length === 19) {
                var first = item.cargMtNo.substring(0, 11);
                var second = item.cargMtNo.substring(11, 15);
                var third = item.cargMtNo.substring(15, 19);
                $("#cargMtNo").text(first + "-" + second + "-" + third);
            }
            
        } else {
            fnDefaultAlert("조회된 데이터가 없습니다.");
            return;
        }
    }
}

function fnContainerList() {
    window.open('/TMS/Unipass/UnipassContainerList?cargMtNo=' + $("#HidcargMtNo").val(), '컨테이너 내역', 'width=830px,height=700px,scrollbars=yes');
    return;
}

function fnDataFullFormat(str) {
    var year = str.substring(0, 4);
    var month = str.substring(4, 6);
    var day = str.substring(6, 8);
    var hour = str.substring(8, 10);
    var minute = str.substring(10, 12);
    var second = str.substring(12, 14);

    var formattedDate = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;

    return formattedDate;
};