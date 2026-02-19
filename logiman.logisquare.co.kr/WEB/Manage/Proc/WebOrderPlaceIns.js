$(document).ready(function () {
    SetInitData();
});

function SetInitData() {
    if ($("#HidMode").val() === "Update") {
        $("#InsBtn").text("수정");
        $("#CenterCode").addClass("read").removeClass("essential");
        $("#PlaceName").attr("readonly", true).removeClass("essential");
        $("#PlacePost").removeClass("essential");
        $("#PlaceAddr").removeClass("essential");
        $("#PlaceAddrDtl").attr("readonly", true).removeClass("essential");
        $("#Sido").attr("readonly", true);
        $("#Gugun").attr("readonly", true);
        $("#Dong").attr("readonly", true);
        $("#BtnPlaceNameChk").hide();

        fnCallClientPlaceDetail();
    } else {
        $("#ChargeName").removeClass("essential");
    }

    $("#SearchChargeBtn").on("click",
        function () {
            fnCallChargeGridData(GridChargeID);
            return;
        }
    );
}

function fnClientPlaceChargeInsConfirm() {
    var strConfMsg = "";
    var strCallType = "";
    if (fnInsValidCheck()) {
        strCallType = "WebOrderPlace" + $("#HidMode").val();
        strConfMsg = "상하차지를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록");
        strConfMsg += "하시겠습니까?";

        var fnParam = strCallType;
        fnDefaultConfirm(strConfMsg, "fnClientPlaceChargeIns", fnParam);
        return;
    }
}

function fnClientPlaceChargeIns(fnParam) {
    var strHandlerURL = "/WEB/Manage/Proc/WebOrderPlaceHandler.ashx";
    var strCallBackFunc = "fnAjaxInsClientPlaceChargeIns";

    var objParam = {
        CallType    : fnParam,
        CenterCode: $("#CenterCode").val(),
        PlaceSeqNo: $("#PlaceSeqNo").val(),
        PlaceName   : $("#PlaceName").val(),
        PlacePost   : $("#PlacePost").val(),
        PlaceAddr: $("#PlaceAddr").val(),
        PlaceAddrDtl: $("#PlaceAddrDtl").val(),
        Sido        : $("#PlaceSido").val(),
        Gugun       : $("#PlaceSigungu").val(),
        Dong        : $("#PlaceDong").val(),
        ChargeName: $("#ChargeName").val(),
        ChargePosition: $("#ChargePosition").val(),
        ChargeTelExtNo: $("#ChargeTelExtNo").val(),
        ChargeTelNo: $("#ChargeTelNo").val(),
        ChargeCell: $("#ChargeCell").val(),
        ChargeNote: $("#ChargeNote").val(),
        PlaceNote: $("#PlaceNote").val(),
        UseFlag: $("input[name$='UseFlag']:checked").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsClientPlaceChargeIns(data) {
    
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {

        var strConfMsg = "";
        strConfMsg = $("#HidMode").val() === "Update" ? "수정" : "등록";
        strConfMsg += " 성공하였습니다.";

        fnDefaultAlert(strConfMsg, "success", "fnLocationUpdateMode", data[0].PlaceSeqNo);
    }

    $("#divLoadingImage").hide();
}

function fnLocationUpdateMode(PlaceSeqNo) {
    location.href = "/WEB/Manage/WebOrderPlaceIns?HidMode=Update&PlaceSeqNo=" + PlaceSeqNo;
}

function fnInsValidCheck() {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if ($("#PlaceName").val() === "") {
        fnDefaultAlertFocus("상하차지명을 입력하세요.", "PlaceName", "warning");
        return false;
    }

    if ($("#PlacePost").val() === "") {
        fnDefaultAlertFocus("우편번호가 누락되었습니다.", "PlacePost", "warning");
        return false;
    }

    if ($("#PlaceAddr").val() === "") {
        fnDefaultAlertFocus("상하차지 주소를 검색해주세요.", "PlaceAddr", "warning");
        return false;
    }

    if ($("#HidPlaceNameChk").val() !== "Y") {
        fnDefaultAlertFocus("상차지명 중복확인해주세요.", "PlaceName", "warning");
        return false;
    }

    return true;
}

function fnCallClientPlaceDetail() {

    var strHandlerURL = "/WEB/Manage/Proc/WebOrderPlaceHandler.ashx";
    var strCallBackFunc = "fnDetailSuccResult";
    var strFailCallBackFunc = "fnDetailFailResult";

    var objParam = {
        CallType: "WebOrderPlaceList",
        PlaceSeqNo : $("#PlaceSeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnDetailSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnDetailFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];
        
        //hidden
        $.each($("input[type='hidden']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //textbox
        $.each($("input[type='text']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //textarea
        $.each($("textarea"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //select
        $.each($("select"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id")) + "']").length > 0) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });
        $("#CenterCode option:not(:selected)").prop("disabled", true);
        
        $("#PlaceSido").val(item.Sido);
        $("#PlaceSigungu").val(item.Gugun);
        $("#PlaceDong").val(item.Dong);

        if (item.UseFlag === "Y") {
            $("#UseFlagY").prop("checked", true);
            $("#UseFlagN").prop("checked", false);
        } else {
            $("#UseFlagY").prop("checked", false);
            $("#UseFlagN").prop("checked", true);
        }

        $(".ChargeInput > input").val("");
        $("#SeqNo").val("");

        $("#HidPlaceNameChk").val("Y");
        //담당자 목록 조회
        fnCallChargeGridData(GridChargeID);
    }
    else {
        fnDetailFailResult();
    }
}

/*담당자 등록*/
function fnChargeInsConfirm() {
    if ($("#ChargeName").val() === "") {
        fnDefaultAlertFocus("담당자명은 필수입니다.", "ChargeName", "warning");
        return;
    }
    
    var strConfMsg = "";
    var strCallType = "";
    strCallType = "WebOrderCharge" + ($("#SeqNo").val() != "" ? "Update" : "Insert");
    strConfMsg = "담당자를 " + ($("#SeqNo").val() != "" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnChargeIns", fnParam);
    return;
}

function fnChargeIns(fnParam) {
    var strHandlerURL = "/WEB/Manage/Proc/WebOrderPlaceHandler.ashx";
    var strCallBackFunc = "fnAjaxInsChargeIns";

    var objParam = {
        CallType: fnParam,
        PlaceSeqNo: $("#PlaceSeqNo").val(),
        ChargeSeqNo : $("#SeqNo").val(),
        ChargeName: $("#ChargeName").val(),
        ChargePosition: $("#ChargePosition").val(),
        ChargeTelExtNo: $("#ChargeTelExtNo").val(),
        ChargeTelNo: $("#ChargeTelNo").val(),
        ChargeCell: $("#ChargeCell").val(),
        ChargeNote: $("#ChargeNote").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsChargeIns(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {

        var strConfMsg = "";
        strConfMsg = $("#SeqNo").val() != "" ? "수정" : "등록";
        strConfMsg += " 성공하였습니다.";

        fnDefaultAlert(strConfMsg, "success", "fnCallChargeGridData", GridChargeID);
        fnChargeReset("Charge");
    }
    $("#divLoadingImage").hide();
}

function fnChargeReset(name) {
    $("#" + name + "Name").val("");
    $("#" + name + "Position").val("");
    $("#" + name + "TelExtNo").val("");
    $("#" + name + "TelNo").val("");
    $("#" + name + "Cell").val("");
    $("#" + name + "Note").val("");
    $("#" + name + "Name").focus();
}

function fnChargeDelConfirm() {
    var CheckedItems = AUIGrid.getCheckedRowItems(GridChargeID);

    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 담당자가 없습니다.", "warning");
        return;
    }

    var strConfMsg = "";
    var strCallType = "";
    strCallType = "WebOrderPlaceChargeDelete";
    strConfMsg = "담당자를 삭제 하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnChargeDel", fnParam);
    return;
}

function fnChargeDel(fnParam) {
    var Nos1 = [];
    var Nos2 = [];
    var Nos3 = [];
    var Nos4 = [];
    var Nos5 = [];
    var Cnt = 1;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridChargeID);

    for (var i = 0, len = CheckedItems.length; i < len; i++) {
        if ((eval("Nos" + Cnt).join(",") + "," + CheckedItems[i].item.SeqNo).length > 4000) {
            Cnt++;
        }

        if (Cnt > 11) {
            break;
        }
        eval("Nos" + Cnt).push(CheckedItems[i].item.SeqNo);
    }
    
    var strHandlerURL = "/WEB/Manage/Proc/WebOrderPlaceHandler.ashx";
    var strCallBackFunc = "fnAjaxDelCharge";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        PlaceSeqNo : $("#PlaceSeqNo").val(),
        SeqNos1 : Nos1.join(","),
        SeqNos2 : Nos2.join(","),
        SeqNos3 : Nos3.join(","),
        SeqNos4 : Nos4.join(","),
        SeqNos5 : Nos5.join(",")
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxDelCharge(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {

        var strConfMsg = "";
        strConfMsg = "삭제 되었습니다.";

        fnDefaultAlert(strConfMsg, "success", "fnCallChargeGridData", GridChargeID);
    }
    $("#divLoadingImage").hide();
}

/*********************************************/
// 상하차지 담당자 
/*********************************************/
var GridChargeID = "#ChargeListGrid";

$(document).ready(function () {
    if ($(GridChargeID).length > 0) {
        // 그리드 초기화
        fnCargeGridInit();
    }
});

function fnCargeGridInit() {
    // 그리드 레이아웃 생성
    fnCreateChargeGridLayout(GridChargeID, "SeqNo");
    
    fnSetGridEvent(GridChargeID, "", "", "", "fnChargeGridSearchNotFound", "", "", "", "fnChargeGridCellDblClick");

    // 사이즈 세팅
    var intHeight = 170;
    AUIGrid.resize(GridChargeID, $(GridChargeID).width(), intHeight);
}

//기본 레이아웃 세팅
function fnCreateChargeGridLayout(strGID, strRowIdField) {

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
    objGridProps.showRowNumColumn = false; // 줄번호 칼럼 렌더러 출력
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
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultChargeColumnLayout()");
    var objOriLayout = fnGetDefaultChargeColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultChargeColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "ChargeName",
            headerText: "담당자명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargePosition",
            headerText: "직급",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeTelExtNo",
            headerText: "연락처(내선)",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeTelNo",
            headerText: "연락처(유선)",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeCell",
            headerText: "휴대폰번호",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeNote",
            headerText: "비고",
            editable: false,
            width: 383,
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
// 검색 notFound 이벤트 핸들러
function fnChargeGridSearchNotFound(event) {
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
function fnChargeGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridChargeID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    return;
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallChargeGridData(strGID) {

    var strHandlerURL = "/WEB/Manage/Proc/WebOrderPlaceHandler.ashx";
    var strCallBackFunc = "fnChargeGridSuccResult";

    var objParam = {
        CallType: "WebOrderPlaceChargeList",
        SeqNoType: "2",
        PlaceSeqNo: $("#PlaceSeqNo").val(),
        SearchType: "ChargeName",
        SearchText: $("#SearchChargeName").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnChargeGridSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridChargeID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        if (objRes[0].data.list[0].SeqNo === 0) {
            AUIGrid.setGridData(GridChargeID, []);
            AUIGrid.removeAjaxLoader(GridChargeID);
            return false;
        }

        AUIGrid.setGridData(GridChargeID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridChargeID);

        // 푸터
        fnSetChargeGridFooter(GridChargeID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetChargeGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "ChargeName",
        dataField: "ChargeName",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}


function fnPlaceNameChk() {
    if ($("#PlaceName").val() === "") {
        fnDefaultAlertFocus("상하차지명을 입력해주세요.", "PlaceName", "warning");
        return
    }
    var strHandlerURL = "/WEB/Manage/Proc/WebOrderPlaceHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "WebOrderPlaceList",
        CenterCode: $("#CenterCode").val(),
        PlaceName: $("#PlaceName").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridSuccResult(objRes) {
    if (objRes[0].data.RecordCnt > 0) {
        fnDefaultAlertFocus("이미 등록된 상하차지명입니다.(현재 " + objRes[0].data.list[0].UseFlagM + ")", "PlaceName", "warning");
        return;
    } else {
        $("#PlaceName").attr("readonly", true);
        $("#BtnPlaceNameChk").hide();
        $("#BtnPlaceNameReset").show();
        $("#PlaceAddrDtl").focus();
        $("#HidPlaceNameChk").val("Y");
    }
}

function fnPlaceNameReset() {
    $("#PlaceName").attr("readonly", false);
    $("#BtnPlaceNameChk").show();
    $("#BtnPlaceNameReset").hide();
    $("#PlaceName").focus();
    $("#PlaceName").val("");
    $("#HidPlaceNameChk").val("");
}

function fnDetailFailResult() {
    parent.fnReloadPageNotice("데이터를 불러올 수 없습니다.");
}