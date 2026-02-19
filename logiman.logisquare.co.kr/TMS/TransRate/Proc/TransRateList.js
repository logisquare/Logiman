// 그리드
var GridID = "#TransRateListGrid";
var GridSort = [];

$(document).ready(function () {
    // 그리드 초기화
    fnGridInit();

    $("#ClientName").on("keydown", function (event) {
        if (event.keyCode === 13) {
            fnCallGridData(GridID);
            return false;
        }
    });

    $("#ConsignorName").on("keydown", function (event) {
        if (event.keyCode === 13) {
            fnCallGridData(GridID);
            return false;
        }
    });

    if (Number($("#GradeCode").val()) > 4) {
        AUIGrid.hideColumnByDataField(GridID, "BtnUpdList");//삭제버튼    
    }

    if (Number($("#RateRegKind").val()) >= 4) {
        $("#FTLFlag").hide();
        AUIGrid.hideColumnByDataField(GridID, "FTLFlagM");//운송구분
    }
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "");
    
    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "", "", "", "", "fnGridCellDblClick");

    // 사이즈 세팅
    var intHeight = $(document).height() - 220;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 220);
    });

    if ($("#CenterCode").val() !== "") {
        fnCallGridData(GridID);
    }

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
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
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
        fnSaveColumnLayoutAuto(GridID, 'TransRateListGrid');
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
            dataField: "TransSeqNo",
            headerText: "요율표 일련번호",
            width: 0,
            visible: false
        },
        {
            dataField: "CenterCode",
            headerText: "회원사코드",
            width: 0,
            visible: false
        },
        {
            dataField: "RateRegKind",
            headerText: "요율표 등록 종류",
            width: 0,
            visible: false
        },
        {
            dataField: "FTLFlag",
            headerText: "운송구분",
            width: 0,
            visible: false
        },
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "RateTypeM",
            headerText: "요율표 구분",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "FTLFlagM",
            headerText: "운송구분",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "TransRateName",
            headerText: "요율표명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "TransRateCnt",
            headerText: "등록 요율수",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "ClientApplyCnt",
            headerText: "적용현황(고객사 수)",
            editable: false,
            width: 150,
            viewstatus: true,
            renderer: { // HTML 템플릿 렌더러 사용
                type: "TemplateRenderer"
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) { // HTML 템플릿 작성
                var TransSeqNo = item.TransSeqNo;
                var CenterCode = item.CenterCode;
                var RateRegKind = item.RateRegKind;
                var FTLFlag = item.FTLFlag;
                var ArrayData = [TransSeqNo, CenterCode, RateRegKind, FTLFlag];

                var template = "<button type=\"button\" class=\"btn_01\" style=\"height:20px; font-size:12px;\" onclick=\"fnTransRateClientLayerOpen('" + ArrayData + "')\">";
                template += '보기(' + value +')';
                template += '</button>';
                return template;
            }
        },
        {
            dataField: "RegDate",
            headerText: "최초등록일",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "RegAdminName",
            headerText: "최초등록자",
            editable: false,
            width: 80,
            viewstatus: true,
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return value + "(" + item.RegAdminID +")";
            }
        },
        {
            dataField: "UpdDate",
            headerText: "최종수정일",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "UpdAdminName",
            headerText: "최종수정자",
            editable: false,
            width: 80,
            viewstatus: true,
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (typeof value !== "undefined" && value !== "") {
                    return value + "(" + item.UpdAdminID + ")";
                }

                return value
            }
        },
        {
            dataField: "DelFlag",
            headerText: "사용여부",
            editable: false,
            width: 100,
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (value == "N") {
                    return "사용중";
                } else {
                    return "사용중지";
                }
                return value;
            }
        },
        {
            dataField: "BtnUpdList",
            headerText: "수정내역",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    var CenterCode = event.item.CenterCode;
                    var TransSeqNo = event.item.TransSeqNo;
                    var CenterName = event.item.CenterName;
                    var RateTypeM = event.item.RateTypeM;
                    var RateType = event.item.RateType;
                    var FTLFlagM = event.item.FTLFlagM;
                    var TransRateName = event.item.TransRateName;
                    fnTransRateModifyList(CenterCode, TransSeqNo, CenterName, RateTypeM, FTLFlagM, TransRateName, RateType);
                }
            },
            viewstatus: true

        },
        {
            dataField: "BtnDetail",
            headerText: "조회",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "조회",
                onClick: function (event) {
                    var CenterCode = event.item.CenterCode;
                    var TransSeqNo = event.item.TransSeqNo;
                    var RateType = event.item.RateType;
                    var FTLFlag = event.item.FTLFlag;
                    var TransRateName = event.item.TransRateName;
                    var DelFlag = event.item.DelFlag;
                    fnUpdTransRateDtl(CenterCode, TransSeqNo, RateType, FTLFlag, TransRateName, DelFlag);
                }
            },
            viewstatus: true

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
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode");
        return;
    }

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType        : "TransRateList",
        TransSeqNo      : $("#TransSeqNo").val(),
        CenterCode      : $("#CenterCode").val(),
        RateRegKind     : $("#RateRegKind").val(),
        RateType        : $("#RateType").val(),
        FTLFlagList         : $("#FTLFlag").val(),
        TransRateName   : $("#TransRateName").val(),
        DelFlag         : $("#DelFlag").val(),
        PageNo          : $("#PageNo").val(),
        PageSize        : $("#PageSize").val()
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

function fnUpdTransRateDtl(CenterCode, TransSeqNo, RateType, FTLFlag, TransRateName, DelFlag) {
    var Param = "";
    Param = "HidMode=Update";
    Param += "&CenterCode=" + CenterCode;
    Param += "&TransSeqNo=" + TransSeqNo;
    Param += "&RateType=" + RateType;
    Param += "&FTLFlag=" + FTLFlag;
    Param += "&TransRateName=" + TransRateName;
    Param += "&RateRegKind=" + $("#RateRegKind").val();
    Param += "&DelFlag=" + DelFlag;
    fnOpenRightSubLayer("요율표 수정", "/TMS/TransRate/TransRateIns?" + Param, "1024px", "700px", "80%");
    return;
}

function fnDelClientTrans(param) {
    var CenterCode      = param[0];
    var ClientCode      = param[1];
    var ConsignorCode   = param[2];
    var FromYMD         = param[3];
    var RateType        = param[4];

    var strHandlerURL = "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
    var strCallBackFunc = "fnAjaxDelClientTrans";

    var objParam = {
        CallType: "ClientTransRateDel",
        CenterCode: CenterCode,
        ClientCode: ClientCode,
        ConsignorCode: ConsignorCode,
        FromYMD: FromYMD,
        RateType: RateType,
        DelFlag: "Y"
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(GridID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnAjaxDelClientTrans(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("삭제되었습니다.", "info", "fnCallGridData", GridID);
    }
}

/**********************************************************/
//적용 고객사 현황 그리드
/**********************************************************/
var GridTransRateClientID = "#TransRateApplyClientListGrid"

$(document).ready(function () {
    if ($(GridTransRateClientID).length > 0) {
        // 그리드 초기화
        fnTransRateClientGridInit();
    }
    if (Number($("#GradeCode").val()) > 4) {
        AUIGrid.hideColumnByDataField(GridTransRateClientID, "BtnDel");//삭제버튼
    }
});

function fnTransRateClientGridInit() {
    // 그리드 레이아웃 생성
    fnCreateTransRateClientGridLayout(GridTransRateClientID, "ApplySeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridTransRateClientID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    AUIGrid.resize(GridTransRateClientID, $("#TranseRateClientLayer .gridLayerWrap").width(), $("#TranseRateClientLayer .gridLayerWrap").height());
}

//기본 레이아웃 세팅
function fnCreateTransRateClientGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = false; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
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
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetTransRateClientColumnLayout()");
    var objOriLayout = fnGetTransRateClientColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetTransRateClientColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "ClientName",
            headerText: "고객사명",
            editable: false,
            width: 200,
            viewstatus: true
        },
        {
            dataField: "ConsignorName",
            headerText: "화주명",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "OrderItemCodeM",
            headerText: "상품",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "OrderLocationCodeM",
            headerText: "사업장",
            editable: false,
            width: 120,
            viewstatus: true,
        }, {
            dataField: "BtnDel",
            headerText: "삭제",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "적용삭제",
                onClick: function (event) {
                    var TransSeqNo = $("#TransSeqNo").val();
                    var ApplySeqNo = event.item.ApplySeqNo;
                    var CenterCode = event.item.CenterCode;
                    var UpdType = event.item.UpdType;
                    var RateRegKind = event.item.RateRegKind ;


                    fnTransRateApplyClientDelConfirm(TransSeqNo, ApplySeqNo, CenterCode, UpdType, RateRegKind);
                    return;
                }
            }
        }
        /*숨김필드*/
        , {
            dataField: "ApplySeqNo",
            headerText: "ApplySeqNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "UpdType",
            headerText: "UpdType",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "RateRegKind",
            headerText: "RateRegKind",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallTransRateClientGridData(ArrayData) {
    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
    var strCallBackFunc = "fnTransRateClientGridSuccResult";

    var objParam = {
        CallType: "TransRateApplyClientList",
        TransSeqNo: ArrayData.split(",")[0],
        CenterCode: ArrayData.split(",")[1],
        RateRegKind: ArrayData.split(",")[2],
        FTLFlag: ArrayData.split(",")[3]
    };
    
    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(GridTransRateClientID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
    $("#TransSeqNo").val(ArrayData.split(",")[0]);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnTransRateClientGridSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridTransRateClientID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridTransRateClientID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridTransRateClientID);

        return false;
    }
}

function fnTransRateClientLayerOpen(ArrayData) {
    fnCallTransRateClientGridData(ArrayData);
    $("#TranseRateClientLayer").show();
    AUIGrid.resize(GridTransRateClientID, $("#TranseRateClientLayer .gridLayerWrap").width(), $("#TranseRateClientLayer .gridLayerWrap").height());
}

// 적용고객사 목록 닫기
function fnCloseClientLayer() {
    AUIGrid.setGridData(GridTransRateClientID, []);
    $("#TranseRateClientLayer").hide();
    $("#TransSeqNo").val("");
    return false;
}

function fnTransRateModifyList(CenterCode, TransSeqNo, CenterName, RateTypeM, FTLFlagM, TransRateName, RateType) {
    var strParam = "";
    strParam = "CenterCode=" + CenterCode;
    strParam += "&TransSeqNo=" + TransSeqNo;
    strParam += "&CenterName=" + CenterName;
    strParam += "&RateTypeM=" + RateTypeM;
    strParam += "&FTLFlagM=" + FTLFlagM;
    strParam += "&TransRateName=" + TransRateName;
    strParam += "&RateType=" + RateType;
    strParam += "&RateRegKind=" + $("#RateRegKind").val();

    fnOpenRightSubLayer("요율표 수정 내역", "/TMS/TransRate/TransRateModifyList?" + strParam, "1024px", "700px", "90%");
}

function fnTransRateApplyClientDelConfirm(TransSeqNo, ApplySeqNo, CenterCode, UpdType, RateRegKind) {
    var DelArrayData = [TransSeqNo, ApplySeqNo, CenterCode, UpdType, RateRegKind];
    fnDefaultConfirm("삭제하시겠습니까?", fnTransRateApplyClientDel, DelArrayData);
}

function fnTransRateApplyClientDel(DelArrayData) {

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
    var strCallBackFunc = "fnTransRateApplyDelSuccResult";

    var objParam = {
        CallType: "TransRateApplyDel",
        TransSeqNo: DelArrayData[0],
        ApplySeqNo: DelArrayData[1],
        CenterCode: DelArrayData[2],
        UpdType: DelArrayData[3],
        RateRegKind: DelArrayData[4]
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(GridTransRateClientID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnTransRateApplyDelSuccResult(objData) {
    AUIGrid.removeAjaxLoader(GridTransRateClientID);
    if (objData) {
        if (objData[0].RetCode !== 0) {
            fnDefaultAlert(objRes[0].ErrMsg, "warning");
            return;
        } else {
            fnDefaultAlert("삭제되었습니다.", "success");
            AUIGrid.removeRowByRowId(GridTransRateClientID, objData[0].ApplySeqNo);
            return;
        }
    }
}