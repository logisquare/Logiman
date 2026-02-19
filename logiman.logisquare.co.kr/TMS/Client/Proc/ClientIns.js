$(document).ready(function () {

    if ($("#hidDisplayMode").val() === "Y") {
        if (parent) {
            parent.fnReloadPageNotice($("#HidErrMsg").val());
        }
        else if (opener) {
            opener.fnReloadPageNotice($("#HidErrMsg").val());
        }
    }

    $("#SaleLimitAmt").on("keyup blur",
        function () {
            $(this).val(fnMoneyComma($(this).val()));
        });

    $("#BtnClientPayDayHelp").on("click", function (e) {
        var htmlMsg = "";
        htmlMsg += "매출에 대한 여신일로 즉시결제를 제외하고<br>계산서 작성월의 말일을 기준으로 함.<br/><br/>";
        htmlMsg += "<b>예시 1. 작성일 : 2024년 6월 21일, 매출여신일 : 15일 선택<br/>";
        htmlMsg += "&nbsp;&nbsp;&nbsp;=> 작성월의 말일 : 2024년 6월 30일 + 15일<br/>";
        htmlMsg += "&nbsp;&nbsp;&nbsp;=> 여신일 : 2024년 7월 15일</b><br/><br/>";
        htmlMsg += "<b>예시 2. 작성일 : 2024년 6월 21일, 매출여신일 : 즉시결제 선택<br/>";
        htmlMsg += "&nbsp;&nbsp;&nbsp;=> 작성일 : 2024년 6월 21일 + 1일<br/>";
        htmlMsg += "&nbsp;&nbsp;&nbsp;=> 여신일 : 2024년 6월 22일</b><br/>";
        htmlMsg += "<br/>※ 선급금은 상차일기준 익월 말일을 여신일로 함.";
        fnDefaultAlert(htmlMsg, "info");
        return false;
    });

    fnSetInitData();
});

function fnSetInitData() {
    if ($("#HidMode").val() === "Update") {
        $("#lbl_LAYER_TITLE", parent.document.body).text("고객사 수정");
        fnCallClientDetail();
    }
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnReloadPageNotice(strMsg) {
    fnClosePopUpLayer();
    fnDefaultAlert(strMsg, "info");
}

function fnChkCenter()
{
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }
    var strHandlerURL = "/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnAjaxChkCenter";

    var objParam = {
        CallType: "ClientCenterTransList",
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
}

function fnAjaxChkCenter(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
    } else {
        $("#TransCenterCode option").remove();
        $("#TransCenterCode").append("<option value=''>계열사 선택</option>");
        if (objRes[0].CenterType === 1) {
            $("#TrTrans").show();
        } else {
            $("#TrTrans").hide();
        }

        $.each(objRes[0].List, function (index, item){
            $("#TransCenterCode").append("<option value=\"" + item.CenterCode + "\">" + item.CenterName +"</option>");
        });
    }
}

function fnInsClient() {
    var strConfMsg = "";
    var strCallType = "";

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#ClientCorpNo").val()) {
        fnDefaultAlertFocus("사업자번호를 입력하세요.", "ClientCorpNo", "warning");
        return false;
    }

    if ($("#HidCorpNoChk").val() !== "Y") {
        fnDefaultAlert("사업자 중복확인을 진행하세요.", "warning");
        return false;
    }

    if (!$("#ClientName").val()) {
        fnDefaultAlertFocus("업체명을 입력하세요.", "ClientName", "warning");
        return false;
    }

    if (!$("#ClientCeoName").val()) {
        fnDefaultAlertFocus("대표자명을 입력하세요.", "ClientCeoName", "warning");
        return false;
    }

    if (!$("#ClientTaxKind").val()) {
        fnDefaultAlertFocus("과세구분을 선택하세요.", "ClientTaxKind", "warning");
        return false;
    }

    if (!$("#ClientType").val()) {
        fnDefaultAlertFocus("고객사구분을 선택하세요.", "ClientType", "warning");
        return false;
    }

    if (!$("#ClientTelNo").val()) {
        fnDefaultAlertFocus("전화번호를 입력하세요.", "ClientTelNo", "warning");
        return false;
    }

    if (!$("#ClientBankCode").val() && $("#ClientAcctNo").val()) {
        fnDefaultAlertFocus("은행을 선택하세요.", "ClientBankCode", "warning");
        return false;
    }

    if ($("#ClientBankCode").val() && !$("#ClientAcctNo").val()) {
        fnDefaultAlertFocus("계좌번호를 입력하세요.", "ClientAcctNo", "warning");
        return false;
    }

    if ($("#ClientBankCode").val() && $("#ClientAcctNo").val() && $("#HidAcctNoChk").val() !== "Y") {
        fnDefaultAlert("예금주명 확인을 진행하세요.", "warning");
        return false;
    }

    if (!$("#ClientPayDay").val()) {
        fnDefaultAlertFocus("매출여신일을 선택하세요.", "ClientPayDay", "warning");
        return false;
    }

    strCallType = "Client" + $("#HidMode").val();
    strConfMsg = "고객사를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록") ;
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsClientProc", fnParam);
    return;
}

function fnInsClientProc(fnParam) {
    var strHandlerURL = "/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnAjaxInsClient";
    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        ClientCode : $("#ClientCode").val(),
        ClientStatus : $("#ClientStatus").val(),
        ClientCloseYMD : $("#ClientCloseYMD").val(),
        ClientUpdYMD : $("#ClientUpdYMD").val(),
        ClientTaxMsg : $("#ClientTaxMsg").val(),
        ClientCorpNo : $("#ClientCorpNo").val(),
        ClientName : $("#ClientName").val(),
        ClientCeoName : $("#ClientCeoName").val(),
        ClientTaxKind : $("#ClientTaxKind").val(),
        ClientType : $("#ClientType").val(),
        ClientBizType : $("#ClientBizType").val(),
        ClientBizClass : $("#ClientBizClass").val(),
        ClientTelNo : $("#ClientTelNo").val(),
        ClientFaxNo : $("#ClientFaxNo").val(),
        ClientEmail : $("#ClientEmail").val(),
        ClientPost : $("#ClientPost").val(),
        ClientAddr : $("#ClientAddr").val(),
        ClientAddrDtl : $("#ClientAddrDtl").val(),
        ClientBankCode : $("#ClientBankCode").val(),
        ClientAcctNo : $("#ClientAcctNo").val(),
        ClientAcctName : $("#ClientAcctName").val(),
        ClientDMPost : $("#ClientDMPost").val(),
        ClientDMAddr : $("#ClientDMAddr").val(),
        ClientDMAddrDtl: $("#ClientDMAddrDtl").val(),
        ClientClosingType : $("#ClientClosingType").val(),
        ClientPayDay : $("#ClientPayDay").val(),
        ClientBusinessStatus : $("#ClientBusinessStatus").val(),
        ClientFPISFlag: $("#ClientFPISFlagY").is(":checked") ? "Y" : "N",
        ClientNote1 : $("#ClientNote1").val(),
        ClientNote2 : $("#ClientNote2").val(),
        ClientNote3 : $("#ClientNote3").val(),
        ClientNote4: $("#ClientNote4").val(),
        SaleLimitAmt: $("#SaleLimitAmt").val(),
        RevenueLimitPer: $("#RevenueLimitPer").val(),
        UseFlag: $("#UseFlagY").is(":checked") ? "Y" : "N",
        TransCenterCode: $("#TransCenterCode").val(),
        DouzoneCode: $("#DouzoneCode").val(),
        ChargeName: $("#ChargeName").val(),
        ChargeLocation: $("#ChargeLocation").val(),
        ChargeTelExtNo: $("#ChargeTelExtNo").val(),
        ChargeTelNo: $("#ChargeTelNo").val(),
        ChargeCell: $("#ChargeCell").val(),
        ChargeFaxNo: $("#ChargeFaxNo").val(),
        ChargeEmail: $("#ChargeEmail").val(),
        ChargePosition: $("#ChargePosition").val(),
        ChargeDepartment: $("#ChargeDepartment").val(),
        ChargeOrderFlag: $("#ChargeOrderFlag").is(":checked") ? "Y" : "N",
        ChargePayFlag: $("#ChargePayFlag").is(":checked") ? "Y" : "N",
        ChargeArrivalFlag: $("#ChargeArrivalFlag").is(":checked") ? "Y" : "N",
        ChargeBillFlag: $("#ChargeBillFlag").is(":checked") ? "Y" : "N",
        ChargeUseFlag: "Y"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsClient(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        var msg = "고객사 " + ($("#HidMode").val() === "Update" ? "수정" : "등록") + "에 성공하였습니다.";
        fnDefaultAlert(msg, "info", "fnClientInsReload", data[0].ClientCode);
    }
}

function fnClientInsReload(intClientCode) {
    document.location.replace("/TMS/Client/ClientIns?ClientCode=" + intClientCode);
}

function fnCallClientDetail() {

    var strHandlerURL = "/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnDetailSuccResult";
    var strFailCallBackFunc = "fnDetailFailResult";

    var objParam = {
        CallType: "ClientList",
        ClientCode: $("#ClientCode").val()
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
        $("#HidCorpNoChk").val("Y");
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
                    if($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id"))+"']").length > 0)
                    {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });

        $("#CenterCode option:not(:selected)").prop("disabled", true);
        $("#ClientTaxKind option:not(:selected)").prop("disabled", true);
        
        if (item.ClientEncAcctNo !== "" && item.ClientBankCode !== "" && item.ClientAcctName !== "") {
            $("#ClientBankCode option:not(:selected)").prop("disabled", true);
            $("#HidAcctNoChk").val("Y");
            $("#BtnAcctNoChk").hide();
            $("#BtnAcctNoReChk").show();
        }

        //Checkbox

        //radio
        if (item.ClientFPISFlag === "Y") {
            $("#ClientFPISFlagY").prop("checked", true);
            $("#ClientFPISFlagN").prop("checked", false);
        } else {
            $("#ClientFPISFlagY").prop("checked", false);
            $("#ClientFPISFlagN").prop("checked", true);
        }

        if (item.UseFlag === "Y") {
            $("#UseFlagY").prop("checked", true);
            $("#UseFlagN").prop("checked", false);
        } else {
            $("#UseFlagY").prop("checked", false);
            $("#UseFlagN").prop("checked", true);
        }

        if (item.CenterType === 1) {
            fnChkCenter();
            if ($("#TransCenterCode option[value='" + item.TransCenterCode + "']").length > 0) {
                $("#TransCenterCode").val(item.TransCenterCode);
            }
        }

        $("#SaleLimitAmt").val(fnMoneyComma($("#SaleLimitAmt").val()));

        //담당자 목록 조회
        fnCallChargeGridData(GridChargeID);
    }
    else
    {
        fnDetailFailResult();
    }
}

function fnDetailFailResult() {
    parent.fnReloadPageNotice("데이터를 불러올 수 없습니다.");
}

//사업자번호 체크
function fnChkCorpNo() {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if (!$("#ClientCorpNo").val()) {
        fnDefaultAlertFocus("사업자번호를 입력하세요.", "ClientCorpNo", "warning");
        return false;
    }

    if (!UTILJS.Util.fnBizNoChk($("#ClientCorpNo").val())) {
        fnDefaultAlertFocus("사업자번호가 올바르지 않습니다.", "ClientCorpNo", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnChkCorpNoSuccResult";
    var strFailCallBackFunc = "fnChkCorpNoFailResult";

    var objParam = {
        CallType: "ClientCorpNoChk",
        CenterCode: $("#CenterCode").val(),
        ClientCorpNo: $("#ClientCorpNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnChkCorpNoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnChkCorpNoFailResult();
            return false;
        }

        $("#HidCorpNoChk").val("Y");
        $("#ClientCorpNo").val(objRes[0].ClientCorpNo);
        $("#ClientCorpNo").attr("readonly", "readonly");
        $("#BtnCorpNoChk").hide();
        $("#BtnCorpNoReChk").show();
        $("#ClientStatus").val(objRes[0].ClientStatus);
        $("#ClientCloseYMD").val(objRes[0].ClientCloseYMD);
        $("#ClientUpdYMD").val(objRes[0].ClientUpdYMD);
        $("#ClientTaxKind").val(objRes[0].ClientTaxKind);
        $("#ClientTaxKind option:not(:selected)").prop("disabled", true);
        $("#ClientTaxMsg").val(objRes[0].ClientTaxMsg);
    } else {
        fnChkCorpNoFailResult();
    }
}

function fnChkCorpNoFailResult() {
    fnDefaultAlertFocus("중복된 사업자이거나, 사업자 휴폐업조회에 실패했습니다.", "ClientCorpNo", "warning");
}

//계좌번호 체크
function fnChkAcctNo() {
    if (!$("#ClientBankCode").val()) {
        fnDefaultAlertFocus("은행을 선택하세요.", "ClientBankCode", "warning");
        return false;
    }

    if (!$("#ClientAcctNo").val()) {
        fnDefaultAlertFocus("계좌번호를 입력하세요.", "ClientAcctNo", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnChkAcctNoSuccResult";
    var strFailCallBackFunc = "fnChkAcctNoFailResult";

    var objParam = {
        CallType: "ClientGetAcctRealName",
        ClientBankCode: $("#ClientBankCode").val(),
        ClientAcctNo: $("#ClientAcctNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnChkAcctNoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnChkAcctNoFailResult();
            return false;
        }

        if (objRes[0].ExistsFlag === "N") {
            fnDefaultAlertFocus("존재하지 않는 계좌입니다.", "ClientAcctNo", "warning");
            return false;
        }

        $("#HidAcctNoChk").val("Y");
        $("#ClientBankCode").val(objRes[0].ClientBankCode);
        $("#ClientBankCode option:not(:selected)").prop("disabled", true);
        $("#ClientAcctNo").val(objRes[0].ClientAcctNo);
        $("#ClientAcctNo").attr("readonly", "readonly");
        $("#ClientAcctName").val(objRes[0].ClientAcctName);
        $("#BtnAcctNoChk").hide();
        $("#BtnAcctNoReChk").show();
    } else {
        fnChkAcctNoFailResult();
    }
}

function fnChkAcctNoFailResult() {
    fnDefaultAlertFocus("계좌 예금주명 조회에 실패했습니다.", "ClientAcctNo", "warning");
}

/*********************************************/
// 업무 담당자 
/*********************************************/
var GridChargeID = "#ClientChargeListGrid";

$(document).ready(function () {
    if ($(GridChargeID).length > 0) {
        // 그리드 초기화
        fnCargeGridInit();
    }
});

function fnCargeGridInit() {
    // 그리드 레이아웃 생성
    fnCreateChargeGridLayout(GridChargeID, "ChargeSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridChargeID, "", "", "", "fnChargeGridSearchNotFound", "", "", "", "fnChargeGridCellDblClick");

    // 사이즈 세팅
    var intHeight = 170;
    AUIGrid.resize(GridChargeID, $(GridChargeID).width(), intHeight);

    // 푸터
    fnSetChargeGridFooter(GridChargeID);
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
            dataField: "OrderFlag",
            headerText: "업무",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PayFlag",
            headerText: "청구",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ArrivalFlag",
            headerText: "도착보고",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BillFlag",
            headerText: "계산서",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeName",
            headerText: "담당자명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeLocation",
            headerText: "청구사업장",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeTelExtNo",
            headerText: "내선",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeTelNo",
            headerText: "유선번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeCell",
            headerText: "휴대폰번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeFaxNo",
            headerText: "팩스",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ChargeEmail",
            headerText: "이메일",
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
            dataField: "ChargeDepartment",
            headerText: "부서",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "UseFlag",
            headerText: "사용여부",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "RegAdminID",
            headerText: "등록자",
            editable: false,
            width: 80,
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
            dataField: "UpdAdminID",
            headerText: "수정자",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "UpdDate",
            headerText: "수정일",
            editable: false,
            width: 150,
            viewstatus: true
        }
        /*숨김필드*/
        , {
            dataField: "ClientChargeSeqNo",
            headerText: "ClientChargeSeqNo",
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
        }, {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "ChargeType",
            headerText: "ChargeType",
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

    fnDisplayCharge(objItem);
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallChargeGridData(strGID) {

    var strHandlerURL = "/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnChargeGridSuccResult";

    var objParam = {
        CallType: "ClientChargeList",
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        ChargeType: $("#SchChargeType").val(),
        ChargeName: $("#SchChargeName").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnChargeGridSuccResult(objRes) {

    if (objRes) {
        AUIGrid.setGridData(GridChargeID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridChargeID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridChargeID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetChargeGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "OrderFlag",
        dataField: "OrderFlag",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

// 담당자 데이터 세팅
function fnDisplayCharge(item) {
    $("#ChargeSeqNo").val(item.ChargeSeqNo);
    $("#ChargeName").val(item.ChargeName);
    $("#ChargeLocation").val(item.ChargeLocation);
    $("#ChargeTelExtNo").val(item.ChargeTelExtNo);
    $("#ChargeTelNo").val(item.ChargeTelNo);
    $("#ChargeCell").val(item.ChargeCell);
    $("#ChargeFaxNo").val(item.ChargeFaxNo);
    $("#ChargeEmail").val(item.ChargeEmail);
    $("#ChargePosition").val(item.ChargePosition);
    $("#ChargeDepartment").val(item.ChargeDepartment);
    $("#ChargeOrderFlag").prop("checked", item.OrderFlag === "Y");
    $("#ChargePayFlag").prop("checked", item.PayFlag === "Y");
    $("#ChargeArrivalFlag").prop("checked", item.ArrivalFlag === "Y");
    $("#ChargeBillFlag").prop("checked", item.BillFlag === "Y");

    if (item.UseFlag === "Y") {
        $("#ChargeUseFlagY").prop("checked", true);
        $("#ChargeUseFlagN").prop("checked", false);
    } else {
        $("#ChargeUseFlagY").prop("checked", false);
        $("#ChargeUseFlagN").prop("checked", true);
    }

    $("#BtnChargeDel").show();
    $("#BtnChargeDel").off("click").on("click",
        function() {
            fnDelCharge();
        });
}

// 담당자 등록/수정
function fnInsCharge() {
    var strConfMsg = "";
    var strCallType = "";

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if (!$("#ClientCode").val()) {
        fnDefaultAlert("고객사 정보가 없습니다.", "warning");
        return;
    }

    if (!$("#ChargeOrderFlag").is(":checked") && !$("#ChargePayFlag").is(":checked") && !$("#ChargeArrivalFlag").is(":checked") && !$("#ChargeBillFlag").is(":checked")) {
        fnDefaultAlert("담당 업무를 선택하세요.", "warning");
        return;
    }

    if (!$("#ChargeName").val()) {
        fnDefaultAlertFocus("담당자명을 입력하세요.", "ChargeName", "warning");
        return;
    }

    if (!$("#ChargeTelNo").val() && !$("#ChargeCell").val()) {
        fnDefaultAlertFocus("전화번호나 휴대폰번호를 입력하세요.", "ChargeTelNo", "warning");
        return;
    }

    var strMode = "Insert";
    if ($("#ChargeSeqNo").val() !== "0" && $("#ChargeSeqNo").val()) {
        strMode = "Update";
    }
    strCallType = "ClientCharge" + strMode;
    strConfMsg = "업체 담당자를 " + (strMode === "Update" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsChargeProc", fnParam);
    return;
}

function fnInsChargeProc(fnParam) {
    var strHandlerURL = "/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnAjaxInsCharge";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        ChargeSeqNo: $("#ChargeSeqNo").val(),
        ChargeType: $("#ChargeType").val(),
        ChargeName: $("#ChargeName").val(),
        ChargeLocation: $("#ChargeLocation").val(),
        ChargeTelExtNo: $("#ChargeTelExtNo").val(),
        ChargeTelNo: $("#ChargeTelNo").val(),
        ChargeCell: $("#ChargeCell").val(),
        ChargeFaxNo: $("#ChargeFaxNo").val(),
        ChargeEmail: $("#ChargeEmail").val(),
        ChargePosition: $("#ChargePosition").val(),
        ChargeDepartment: $("#ChargeDepartment").val(),
        ChargeOrderFlag: $("#ChargeOrderFlag").is(":checked") ? "Y" : "N",
        ChargePayFlag: $("#ChargePayFlag").is(":checked") ? "Y" : "N",
        ChargeArrivalFlag: $("#ChargeArrivalFlag").is(":checked") ? "Y" : "N",
        ChargeBillFlag: $("#ChargeBillFlag").is(":checked") ? "Y" : "N",
        ChargeUseFlag: $("input[name$='ChargeUseFlag']:checked").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsCharge(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {

        var strMode = "Insert";
        if ($("#ChargeSeqNo").val() !== "0" && $("#ChargeSeqNo").val()) {
            strMode = "Update";
        }
        var msg = "업체 담당자 " + (strMode === "Update" ? "수정" : "등록") + "에 성공하였습니다.";
        fnDefaultAlert(msg, "info");
        fnResetCharge();
        fnCallChargeGridData(GridChargeID);
    }
}


// 담당자 삭제
function fnDelCharge() {
    var strConfMsg = "";
    var strCallType = "";

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if (!$("#ClientCode").val()) {
        fnDefaultAlert("고객사 정보가 없습니다.", "warning");
        return;
    }

    if (!$("#ChargeSeqNo").val()) {
        fnDefaultAlertFocus("선택된 고객사 담당자 정보가 없습니다.", "ChargeCell", "warning");
        return;
    }

    strCallType = "ClientChargeDelete";
    strConfMsg = "업체 담당자를 삭제 하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnDelChargeProc", fnParam);
    return;

}

function fnDelChargeProc(fnParam) {
    var strHandlerURL = "/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnAjaxDelCharge";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        ChargeSeqNo: $("#ChargeSeqNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxDelCharge(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        var msg = "업체 담당자 삭제에 성공하였습니다.";
        fnDefaultAlert(msg, "info");
        fnResetCharge();
        fnCallChargeGridData(GridChargeID);
    }
}

// 담당자 폼 리셋
function fnResetCharge() {
    $("#ChargeSeqNo").val("");
    $("#ChargeType").val("");
    $("#ChargeName").val("");
    $("#ChargeLocation").val("");
    $("#ChargeTelExtNo").val("");
    $("#ChargeTelNo").val("");
    $("#ChargeCell").val("");
    $("#ChargeFaxNo").val("");
    $("#ChargeEmail").val("");
    $("#ChargePosition").val("");
    $("#ChargeDepartment").val("");
    $("#ChargeOrderFlag").prop("checked", false);
    $("#ChargePayFlag").prop("checked", false);
    $("#ChargeArrivalFlag").prop("checked", false);
    $("#ChargeBillFlag").prop("checked", false);
    $("#ChargeUseFlagY").prop("checked", true);
    $("#ChargeUseFlagN").prop("checked", false);
    $("#BtnChargeDel").hide();
}
/*********************************************/
