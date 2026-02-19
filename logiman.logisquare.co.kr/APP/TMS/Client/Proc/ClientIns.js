var strListDataParam = "";
$(document).ready(function () {
    fnSetInitData();
    var strListData = $("#HidParam").val();
    strListDataParam = strListData.replace(/:/g, "=").replace(/,/g, "&").replace(/{/g, "").replace(/}/g, "");
});

function fnSetInitData() {
    if ($("#HidMode").val() === "Update") {
        $("#PopMastertitle").text("고객사 수정");
        $("#InsBtn").text("수정하기");
        fnCallClientDetail();
    } else {
        $("#PopMastertitle").text("고객사 등록");
    }

    $("#BtnCorpNoReChk").on("click",
        function () {
            $("#ClientCorpNo").val("");
            $("#ClientCorpNo").removeAttr("readonly");
            $("#HidCorpNoChk").val("N");
            $("#BtnCorpNoChk").show();
            $("#BtnCorpNoReChk").hide();
            $("#ClientStatus").val("");
            $("#ClientCloseYMD").val("");
            $("#ClientUpdYMD").val("");
            $("#ClientTaxKind").val("");
            $("#ClientTaxKind option").prop("disabled", false);
            $("#ClientTaxMsg").val("");
            return false;
        });

    //우편번호 검색
    $("#BtnSearchAddrPickupPlace").on("click", function (e) {
        e.preventDefault();
        fnOpenAddress("Client");
        return false;
    });

    $("#BtnAcctNoChk").on("click",
        function () {
            fnChkAcctNo();
            return;
        });

    $("#BtnAcctNoReChk").on("click",
        function () {
            $("#HidAcctNoChk").val("N");
            $("#ClientBankCode").val("");
            $("#ClientBankCode option").prop("disabled", false);
            $("#ClientAcctNo").val("");
            $("#ClientAcctNo").removeAttr("readonly");
            $("#ClientAcctName").val("");
            $("#BtnAcctNoChk").show();
            $("#BtnAcctNoReChk").hide();
            return false;
        });
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

    var strHandlerURL = "/APP/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnChkCorpNoSuccResult";
    var strFailCallBackFunc = "fnChkCorpNoFailResult";

    var objParam = {
        CallType: "ClientCorpNoChk",
        CenterCode: $("#CenterCode").val(),
        ClientCorpNo: $("#ClientCorpNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
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

    var strHandlerURL = "/APP/TMS/Client/Proc/ClientHandler.ashx";
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

function fnInsClient() {
    var strConfMsg = "";
    var strCallType = "";

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if (!$("#ClientCorpNo").val()) {
        fnDefaultAlertFocus("사업자번호를 입력하세요.", "ClientCorpNo", "warning");
        return;
    }

    if ($("#HidCorpNoChk").val() !== "Y") {
        fnDefaultAlert("사업자 중복확인을 진행하세요.", "warning");
        return;
    }

    if (!$("#ClientName").val()) {
        fnDefaultAlertFocus("업체명을 입력하세요.", "ClientName", "warning");
        return;
    }

    if (!$("#ClientCeoName").val()) {
        fnDefaultAlertFocus("대표자명을 입력하세요.", "ClientCeoName", "warning");
        return;
    }

    if (!$("#ClientTaxKind").val()) {
        fnDefaultAlertFocus("과세구분을 선택하세요.", "ClientTaxKind", "warning");
        return;
    }

    if (!$("#ClientType").val()) {
        fnDefaultAlertFocus("고객사구분을 선택하세요.", "ClientType", "warning");
        return;
    }

    if (!$("#ClientTelNo").val()) {
        fnDefaultAlertFocus("전화번호를 입력하세요.", "ClientTelNo", "warning");
        return;
    }

    if (!$("#ClientBankCode").val() && $("#ClientAcctNo").val()) {
        fnDefaultAlertFocus("은행을 선택하세요.", "ClientBankCode", "warning");
        return;
    }

    if ($("#ClientBankCode").val() && !$("#ClientAcctNo").val()) {
        fnDefaultAlertFocus("계좌번호를 입력하세요.", "ClientAcctNo", "warning");
        return;
    }

    if ($("#ClientBankCode").val() && $("#ClientAcctNo").val() && $("#HidAcctNoChk").val() !== "Y") {
        fnDefaultAlert("예금주명 확인을 진행하세요.", "warning");
        return;
    }

    strCallType = "Client" + $("#HidMode").val();
    strConfMsg = "고객사를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsClientProc", fnParam);
    return;
}

function fnInsClientProc(fnParam) {
    var strHandlerURL = "/APP/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "fnAjaxInsClient";
    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        ClientStatus: $("#ClientStatus").val(),
        ClientCloseYMD: $("#ClientCloseYMD").val(),
        ClientUpdYMD: $("#ClientUpdYMD").val(),
        ClientTaxMsg: $("#ClientTaxMsg").val(),
        ClientCorpNo: $("#ClientCorpNo").val(),
        ClientName: $("#ClientName").val(),
        ClientCeoName: $("#ClientCeoName").val(),
        ClientTaxKind: $("#ClientTaxKind").val(),
        ClientType: $("#ClientType").val(),
        ClientBizType: $("#ClientBizType").val(),
        ClientBizClass: $("#ClientBizClass").val(),
        ClientTelNo: $("#ClientTelNo").val(),
        ClientFaxNo: $("#ClientFaxNo").val(),
        ClientEmail: $("#ClientEmail").val(),
        ClientPost: $("#ClientPost").val(),
        ClientAddr: $("#ClientAddr").val(),
        ClientAddrDtl: $("#ClientAddrDtl").val(),
        ClientBankCode: $("#ClientBankCode").val(),
        ClientAcctNo: $("#ClientAcctNo").val(),
        ClientAcctName: $("#ClientAcctName").val(),
        ClientDMPost: $("#ClientDMPost").val(),
        ClientDMAddr: $("#ClientDMAddr").val(),
        ClientDMAddrDtl: $("#ClientDMAddrDtl").val(),
        ClientClosingType: $("#ClientClosingType").val(),
        ClientPayDay: $("#ClientPayDay").val(),
        ClientBusinessStatus: $("#ClientBusinessStatus").val(),
        ClientFPISFlag: $("#ClientFPISFlagY").is(":checked") ? "Y" : "N",
        ClientNote1: $("#ClientNote1").val(),
        ClientNote2: $("#ClientNote2").val(),
        ClientNote3: $("#ClientNote3").val(),
        ClientNote4: $("#ClientNote4").val(),
        SaleLimitAmt: $("#SaleLimitAmt").val(),
        RevenueLimitPer: $("#RevenueLimitPer").val(),
        UseFlag: $("#UseFlag").val(),
        TransCenterCode: $("#TransCenterCode").val(),
        DouzoneCode: $("#DouzoneCode").val(),
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
    if ($("#HidMode").val() === "Insert") {
        document.location.replace("/APP/TMS/Client/ClientIns?HidMode=Update&ClientCode=" + intClientCode + "&HidParam=" + $("#HidParam").val());
    }
}

function fnCallClientDetail() {

    var strHandlerURL = "/APP/TMS/Client/Proc/ClientHandler.ashx";
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
            $("#TransCenterCode").val(item.TransCenterCode);
        }

        $("#SaleLimitAmt").val($("#SaleLimitAmt").val());
        $("#CenterCode").addClass("read");
    }
    else {
        fnDetailFailResult();
    }
}

function fnDetailFailResult() {
    parent.fnReloadPageNotice("데이터를 불러올 수 없습니다.");
}

function fnListBack() {
    location.href = "/APP/TMS/Client/ClientList?" + strListDataParam;
}