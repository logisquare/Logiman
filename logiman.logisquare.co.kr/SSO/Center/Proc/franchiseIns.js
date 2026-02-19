$(document).ready(function () {
    if ($("#DisplayMode").val() == "Y") {
        if (parent) {
            parent.fnReloadPageNotice($("#ErrMsg").val());
        }
        else if (opener) {
            opener.fnReloadPageNotice($("#ErrMsg").val());
        }
    }

    if (parseInt($("#GradeCode").val()) > 3) {
        $("#TransSaleRate").attr("readonly", true);
        $("#TransSaleRate").css("background-color", "#e7e7e7");
        $("#TransSaleRate").addClass("readonly");
    }

    fnSetInitData();
});

function fnSetInitData() {
    if ($("#hidMode").val() === "insert") {
        $("#lblMode").html("등록");

        $("#CenterID").attr("placeholder", "별도 입력없이 자동으로 설정됩니다.");
        $("#CenterKey").attr("placeholder", "별도 입력없이 자동으로 설정됩니다.");
        $("#UseFlag").val("Y");
    }
    else {
        $("#lblMode").html("수정");

        $("#CorpNo").attr("readonly", true);
        $("#CorpNo").css("background-color", "#e7e7e7");
        $("#CorpNo").addClass("readonly");
        $("#BtnChkCorpNo").hide();
        $("#BankCode option:not(:selected)").attr("disabled", true);
        $("#BankCode").addClass("read");
        $("#AcctName").attr("readonly", true);
        $("#EncAcctNo").attr("readonly", true);
        $("#BtnChkAcctNo").hide();
        $("#BtnChkAcctNoReset").show();
    }

    $("#CenterID").attr("readonly", true);
    $("#CenterID").css("background-color", "#e7e7e7");
    $("#CenterID").addClass("readonly");

    $("#CenterKey").attr("readonly", true);
    $("#CenterKey").css("background-color", "#e7e7e7");
    $("#CenterKey").addClass("readonly");

    if ($("#CenterType").val() === "2") {
        $("#divTransSaleRate").show();
    }

    $("#maintable").show();
}

function fnChangeCenterType() {
    if ($("#CenterType").val() === "2") {
        $("#divTransSaleRate").show();
    } else {
        $("#divTransSaleRate").hide();
    }
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnInsCenter() {
    var strConfMsg;
    var strCallType;

    if ($("#CenterName").val() === "") {
        fnDefaultAlertFocus("회원사명을 입력하세요.","CenterName", "warning");
        return;
    }

    if ($("#CorpNo").val() === "") {
        fnDefaultAlertFocus("사업자번호를 입력하세요.", "CorpNo", "warning");
        return;
    }

    if ($("#CorpNoCheck").val() === "") {
        fnDefaultAlertFocus("사업자확인이 필요합니다.", "CorpNo", "warning");
    }

    if ($("#CeoName").val() === "") {
        fnDefaultAlertFocus("대표자명을 입력하세요.", "CeoName", "warning");
        return;
    }

    if ($("#BizType").val() === "") {
        fnDefaultAlertFocus("업태를 입력하세요.", "BizType", "warning");
        return;
    }

    if ($("#BizClass").val() === "") {
        fnDefaultAlertFocus("종목을 입력하세요.", "BizClass", "warning");
        return;
    }

    if ($("#TelNo").val() === "") {
        fnDefaultAlertFocus("전화번호를 입력하세요.", "TelNo", "warning");
        return;
    }

    if ($("#FaxNo").val() === "") {
        fnDefaultAlertFocus("팩스번호를 입력하세요.", "FaxNo", "warning");
        return;
    }

    if ($("#Email").val() === "") {
        fnDefaultAlertFocus("이메일을 입력하세요.", "Email", "warning");
        return;
    }

    if ($("#AddrPost").val() === "") {
        fnDefaultAlertFocus("우편번호를 입력하세요.", "AddrPost", "warning");
        return;
    }

    if ($("#Addr").val() === "") {
        fnDefaultAlertFocus("주소를 입력하세요.", "Addr", "warning");
        return;
    }

    if ($("#CenterType").val() === "") {
        fnDefaultAlertFocus("회원사 종류를 선택하세요.", "CenterType", "warning");
        return;
    }

    if ($("#ContractFlag").val() === "") {
        fnDefaultAlertFocus("계약여부를 선택하세요.", "ContractFlag", "warning");
        return;
    }

    if ($("#UseFlag").val() === "") {
        fnDefaultAlertFocus("사용여부를 선택하세요.", "UseFlag", "warning");
        return;
    }

    if ($("#hidMode").val() == "insert") {
        strCallType = "CenterInsert";
        strConfMsg = "등록하시겠습니까?";
    }
    else {
        strCallType = "CenterUpdate";
        strConfMsg = "수정하시겠습니까?";
    }

    //Confirm
    //var fnParam = "'" + strCallType + "'";
    fnDefaultConfirm(strConfMsg, "fnInsCenterProc", strCallType);

    return;
}

function fnInsCenterProc(ojbParam) {
    var strHandlerURL = "/SSO/Center/Proc/CenterHandler.ashx";
    var strCallBackFunc = "fnAjaxInsCenter";

    var objParam = {
        CallType: ojbParam,
        CenterCode: $("#hidCenterCode").val(),
        CenterID: $("#CenterID").val(),
        CenterKey: $("#CenterKey").val(),
        CenterName: $("#CenterName").val(),
        CorpNo: $("#CorpNo").val(),
        CeoName: $("#CeoName").val(),
        BizType: $("#BizType").val(),
        BizClass: $("#BizClass").val(),
        TelNo: $("#TelNo").val(),
        FaxNo: $("#FaxNo").val(),
        Email: $("#Email").val(),
        AddrPost: $("#AddrPost").val(),
        Addr: $("#Addr").val(),
        CenterNote: $("#CenterNote").val(),
        CenterType: $("#CenterType").val(),
        TransSaleRate: $("#TransSaleRate").val(),
        BankCode: $("#AcctValidFlag").val() === "Y" ? $("#BankCode").val() : "",
        AcctName: $("#AcctValidFlag").val() === "Y" ? $("#AcctName").val() : "",
        EncAcctNo: $("#AcctValidFlag").val() === "Y" ? $("#EncAcctNo").val() : "",
        AcctValidFlag: $("#AcctValidFlag").val(),
        ContractFlag: $("#ContractFlag").val(),
        UseFlag: $("#UseFlag").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsCenter(data) {
    
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", "fnCenterInsReload", data[0].CenterCode);
    }
}

function fnCenterInsReload(intCenterCode) {
    document.location.replace("/SSO/Center/FranchiseIns?CenterCode=" + intCenterCode);
    parent.$("#lbl_LAYER_TITLE").text("가맹점 수정");
    parent.fnCallGridData("#CenterListGrid");
}


/*사업자 확인*/
function fnChkCorpNo() {

    if (!UTILJS.Util.fnBizNoChk($("#CorpNo").val())) {
        fnDefaultAlertFocus("잘못된 사업자번호입니다.", "warning", "CorpNo");
        return;
    }

    if ($("#CorpNo").val() === "") {
        fnDefaultAlertFocus("사업자번호를 입력해주세요.", "warning", "CorpNo");
        return;
    }

    var strHandlerURL = "/SSO/Center/Proc/CenterHandler.ashx";
    var strCallBackFunc = "fnAjaxChkCorpNo";

    var objParam = {
        CallType: "ChkCorpNo",
        CorpNo: $("#CorpNo").val(),
        CenterCode: $("#CenterCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxChkCorpNo(data) {
    
    if (data[0].RetCode === 0) {
        if (data[0].RecordCnt > 0) {
            fnDefaultAlertFocus("이미 등록된 사업자 번호입니다.", "CorpNo", "warning");
            $("#CorpNoCheck").val("");
            return;
        } else {
            if (data[0].ComStatus === 2) {
                fnDefaultAlertFocus("정상사업자 번호입니다.", "CeoName", "info");
                $("#BtnChkCorpNo").hide();
                $("#BtnChkCorpNoReset").show();
                $("#CorpNo").attr("readonly", true);
                $("#CorpNoCheck").val("Y");

            } else {
                fnDefaultAlertFocus("등록할 수 없습니다.<br>" + data[0].ComTaxMsg, "CorpNo", "warning");
                $("#CorpNoCheck").val("");
            }
            return;
        }
        return;
    } else {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    }
    $("#divLoadingImage").hide();
}

function fnCorpNoReset() {
    $("#CorpNo").val("");
    $("#CorpNoCheck").val("");
    $("#CorpNo").attr("readonly", false);
    $("#BtnChkCorpNo").show();
    $("#BtnChkCorpNoReset").hide();
    return;
}

//예금주 계좌 확인
function fnChkAcctNo() {
    if ($("#BankCode").val() === "") {
        fnDefaultAlertFocus("은행을 선택해주세요.", "BankCode", "warning");
        return;
    }
    if ($("#AcctName").val() === "") {
        fnDefaultAlertFocus("예금주를 입력해주세요.", "AcctName", "warning");
        return;
    }
    if ($("#EncAcctNo").val() === "") {
        fnDefaultAlertFocus("계좌번호를 입력해주세요.", "EncAcctNo", "warning");
        return;
    }
    //임시 설정


    if ($("#AcctNo").val() === "") {
        fnDefaultAlert("계좌번호를 입력해주세요.", "warning", "fnObjFocus", "#AcctNo")
    }
    var strHandlerURL = "/TMS/Car/Proc/CarDispatchRefInsHandler.ashx";
    var strCallBackFunc = "fnAjaxChkAcctNo";

    var objParam = {
        CallType: "ChkAcctNo",
        ComCorpNo: $("#ComCorpNo").val(),
        EncAcctNo: $("#EncAcctNo").val(),
        BankCode: $("#BankCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxChkAcctNo(data) {
    if (data[0].RetCode === 0) {
        $("#BtnChkAcctNo").hide();
        $("#BtnChkAcctNoReset").css("display", "inline-block");
        $("#EncAcctNo").attr("readonly", true);
        $("#AcctName").attr("readonly", true);
        $("#BankCode option:not(:selected)").attr("disabled", true);
        $("#BankCode").addClass("read");

        $("#AcctName").val(data[0].AcctName);
        $("#EncAcctNo").val(data[0].AcctNo);
        $("#BankCode").val(data[0].BankCode);
        $("#AcctValidFlag").val("Y");
    } else {
        fnDefaultAlertFocus("잘못된 계좌정보입니다.<br>은행과 계좌번호를 정확히 입력해주세요.", "EncAcctNo", "warning");
        return;
    }
}

function fnObjReset(obj) {
    $("#BtnChkAcctNo").css("display", "inline-block");
    $("#BtnChkAcctNoReset").hide();
    $("#EncAcctNo").attr("readonly", false);
    $("#EncAcctNo").focus();
    $("#AcctName").attr("readonly", false);
    $("#BankCode option:not(:selected)").attr("disabled", false);
    $("#BankCode").removeClass("read");
    $("#AcctValidFlag").val("");
}