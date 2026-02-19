var strListDataParam = "";
$(document).ready(function () {
    if ($("#HidMode").val() === "Insert") {
        $("#PopMastertitle").text("차량등록");
    } else {
        $("#PopMastertitle").text("차량수정");
    }

    SettingData();
    var strListData = $("#HidParam").val();
    strListDataParam = strListData.replace(/:/g, "=").replace(/,/g, "&").replace(/{/g, "").replace(/}/g, "");

    $("#InsureTargetFlagY").on("change", function (event) {
        if ($("#ComKindM").val() == "법인") {
            $("#InsureTargetFlagY").prop("checked", false);
            $("#InsureTargetFlagN").prop("checked", true);
            fnDefaultAlert("법인 소속 기사는 산재보험 대상이 아닙니다.", "warning");
            return false;
        }
    });
});

function SettingData() {
    $("#ComTaxKind").addClass("read");
    $("#ComPost").attr("readonly", true);
    $("#ComAddr").attr("readonly", true);

    if ($("#HidMode").val() === "Update") {
        $("#CarDivType option:not(:selected)").attr("disabled", true);
        $("#CarDivType").addClass("read");
        $("#CenterCode option:not(:selected)").attr("disabled", true);
        $("#CenterCode").addClass("read");
        $("#CarNo").attr("readonly", true);
        $("#DriverName").attr("readonly", true);
        $("#DriverCell").attr("readonly", true);
        $("#ComCorpNo").attr("readonly", true);
        if ($("#AcctValidFlag").val() === "Y") {
            $("#BtnChkAcctNo").hide()
            $("#BtnChkAcctNoReset").css("display", "inline-block");
            $("#EncAcctNo").attr("readonly", true);
            $("#AcctName").attr("readonly", true);
            $("#BankCode option:not(:selected)").attr("disabled", true);
            $("#BankCode").addClass("read");
        }
        $("#InsBtn").text("수정");
        $("#CopyBtn").show();
    } else if ($("#HidMode").val() === "Copy") {
        $("#CarDivType option:not(:selected)").attr("disabled", true);
        $("#CarDivType").addClass("read");
        $("#CarNo").attr("readonly", true);
        $("#DriverName").attr("readonly", true);
        $("#DriverCell").attr("readonly", true);
        $("#ComCorpNo").attr("readonly", true);
        if ($("#AcctValidFlag").val() === "Y") {
            $("#BtnChkAcctNo").hide()
            $("#BtnChkAcctNoReset").css("display", "inline-block");
            $("#EncAcctNo").attr("readonly", true);
            $("#AcctName").attr("readonly", true);
            $("#BankCode option:not(:selected)").attr("disabled", true);
            $("#BankCode").addClass("read");
        }

        $("#BtnChkCar").hide();
        $("#BtnChkCarReset").css("display", "inline-block");
        $("#BtnChkDriver").hide();
        $("#BtnChkDriverReset").css("display", "inline-block");
        $("#BtnChkCorpNo").hide();
        $("#BtnChkCorpNoReset").css("display", "inline-block");
    }
}

//차량중복확인
function fnChkCar() {
    if ($("#CarNo").val() === "") {
        fnDefaultAlert("차량번호를 입력해주세요.", "warning", "fnObjFocus", "#CarNo");
        return;
    }

    if (!UTILJS.Util.fnCarNoChk($("#CarNo").val())) {
        fnDefaultAlert("잘못된 차량번호입니다.", "warning", "fnObjFocus", "#CarNo");
        return;
    }

    var strHandlerURL = "/APP/TMS/Car/Proc/AppCarDispatchRefHandler.ashx";
    var strCallBackFunc = "fnAjaxChkCarNo";

    var objParam = {
        CallType: "ChkCarNo",
        CarNo: $("#CarNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxChkCarNo(data) {
    if (data[0].RetCode === 0) {
        if (data[0].RecordCnt > 0) {
            fnDefaultAlert("이미 등록된 차량으로 확인되어<br>해당 차량정보로 세팅되었습니다.", "info");
            $("#CarSeqNo").val(data[0].CarSeqNo);
            $("#CarNo").val(data[0].CarNo);
            $("#CarTypeCode").val(data[0].CarTypeCode);
            $("#CarTonCode").val(data[0].CarTonCode);
            $("#CarBrandCode").val(data[0].CarBrandCode);
            $("#CarNote").val(data[0].CarNote);
        } else {
            fnDefaultAlert("신규등록 가능한 차량번호입니다.", "success");
        }
        $("#CarNo").attr("readonly", true);
        $("#BtnChkCar").hide();
        $("#BtnChkCarReset").show();
        $("#ChkCar").val("Y");
        return;
    } else {
        fnDefaultAlert(data[0].ErrMsg, "warning");
        return;
    }
    $("#divLoadingImage").hide();
}

//기사중복확인
function fnChkDriver() {

    if ($("#DriverCell").val() === "") {
        fnDefaultAlert("기사 휴대폰번호를 입력해주세요.", "warning", "fnObjFocus", "#DriverCell");
        return;
    }

    if (!UTILJS.Util.fnCellNoChk($("#DriverCell").val())) {
        fnDefaultAlert("잘못된 휴대폰번호입니다.", "warning", "fnObjFocus", "#DriverCell");
        return;
    }

    if ($("#DriverCell").val().length > 11) {
        fnDefaultAlert("기사 휴대폰번호는 11자리까지 등록가능합니다.", "warning", "fnObjFocus", "#DriverCell");
        return;
    }

    var strHandlerURL = "/APP/TMS/Car/Proc/AppCarDispatchRefHandler.ashx";
    var strCallBackFunc = "fnAjaxChkDriverCell";

    var objParam = {
        CallType: "ChkDriver",
        DriverCell: $("#DriverCell").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxChkDriverCell(data) {
    if (data[0].RetCode === 0) {
        if (data[0].RecordCnt > 0) {
            fnDefaultAlert("이미 등록된 기사로 확인되어<br>해당 기사정보로 세팅되었습니다.", "info");
            $("#DriverSeqNo").val(data[0].DriverSeqNo);
            $("#DriverName").val(data[0].DriverName);
            $("#DriverCell").val(data[0].DriverCell);
        } else {
            fnDefaultAlert("신규등록 가능한 기사입니다.", "success");
        }
        $("#DriverCell").attr("readonly", true);
        $("#BtnChkDriver").hide();
        $("#BtnChkDriverReset").show();
        $("#ChkDriver").val("Y");
        return;
    } else {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    }
    $("#divLoadingImage").hide();
}

/*사업자 확인*/
function fnChkCorpNo() {

    if ($("#ComCorpNo").val() === "") {
        fnDefaultAlert("사업자번호를 입력해주세요.", "warning", "fnObjFocus", "#ComCorpNo")
        return;
    }

    if (!UTILJS.Util.fnBizNoChk($("#ComCorpNo").val())) {
        fnDefaultAlert("잘못된 사업자번호입니다.", "warning", "fnObjFocus", "#ComCorpNo");
        return;
    }

    var strHandlerURL = "/APP/TMS/Car/Proc/AppCarDispatchRefHandler.ashx";
    var strCallBackFunc = "fnAjaxChkCorpNo";

    var objParam = {
        CallType: "ChkCorpNo",
        ComCorpNo: $("#ComCorpNo").val(),
        CenterCode: $("#CenterCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxChkCorpNo(data) {
    if (data[0].RetCode === 0) {
        if (data[0].RecordCnt > 0) {
            fnDefaultAlert("이미 등록된 사업자로 확인되어<br>해당 업체정보로 세팅되었습니다.", "info");
            $("#ComCode").val(data[0].ComCode);
            $("#ComStatus").val(data[0].ComStatus);
            $("#ComName").val(data[0].ComName);
            $("#ComCorpNo").val(data[0].ComCorpNo);
            $("#ComName").val(data[0].ComName);
            $("#ComCeoName").val(data[0].ComCeoName);
            $("#ComBizType").val(data[0].ComBizType);
            $("#ComBizClass").val(data[0].ComBizClass);
            $("#ComTelNo").val(data[0].ComTelNo);
            $("#ComFaxNo").val(data[0].ComFaxNo);
            $("#ComEmail").val(data[0].ComEmail);
            $("#ComPost").val(data[0].ComPost);
            $("#ComAddr").val(data[0].ComAddr);
            $("#ComAddrDtl").val(data[0].ComAddrDtl);
            $("#ComCloseYMD").val(data[0].ComCloseYMD);
            $("#ComUpdYMD").val(data[0].ComUpdYMD);
            $("#ComTaxKind").val(data[0].ComTaxKind);
            $("#ComTaxMsg").val(data[0].ComTaxMsg);
            $("#ComKindM").val(data[0].ComKindM);
            $("#InsureTargetFlagY").prop("checked", data[0].ComKindM != "법인");
            $("#InsureTargetFlagN").prop("checked", data[0].ComKindM == "법인");
            if (data[0].DtlRecordCnt > 0) {
                $("#BankCode").val(data[0].BankCode);
                $("#AcctName").val(data[0].AcctName);
                $("#EncAcctNo").val(data[0].EncAcctNo);
                $("#PayDay").val(data[0].PayDay);
                $("#AcctValidFlag").val(data[0].AcctValidFlag);
                $("#CooperatorFlag").prop("checked", data[0].CooperatorFlag === "Y" ? true : false);
                $("#ChargeName").val(data[0].ChargeName);
                $("#ChargeTelNo").val(data[0].ChargeTelNo);
                $("#ChargeEmail").val(data[0].ChargeEmail);
                $("#BtnChkAcctNo").hide();
                $("#BtnChkAcctNoReset").show();
                $("#EncAcctNo").attr("readonly", true);
                $("#AcctName").attr("readonly", true);
                $("#BankCode option:not(:selected)").attr("disabled", true);
                $("#BankCode").addClass("read");
            }

        } else {
            fnDefaultAlert("신규등록 가능한 사업자입니다.", "success");
            $("#ComStatus").val(data[0].ComStatus);
            $("#ComCloseYMD").val(data[0].ComCloseYMD);
            $("#ComUpdYMD").val(data[0].ComUpdYMD);
            $("#ComTaxKind").val(data[0].ComTaxKind);
            $("#ComTaxMsg").val(data[0].ComTaxMsg);
            $("#ComKindM").val(data[0].ComKindM);
            $("#InsureTargetFlagY").prop("checked", data[0].ComKindM != "법인");
            $("#InsureTargetFlagN").prop("checked", data[0].ComKindM == "법인");
        }
        $("#ComCorpNo").attr("readonly", true);
        $("#ComTaxKind option:not(:selected)").attr("disabled", true);
        $("#BtnChkCorpNo").hide();
        $("#BtnChkCorpNoReset").show();
        $("#ChkCom").val("Y");
        return;
    } else {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    }
    $("#divLoadingImage").hide();
}

//차량번호, 사업자번호, 기사 휴대폰번호 초기화
function fnObjReset(obj) {
    $("#" + obj).val("");
    $("#" + obj).focus();
    $("#" + obj).attr("readonly", false);

    if (obj === "CarNo") {
        $("#BtnChkCarReset").hide();
        $("#ChkCar").val("");
        $("#CarSeqNo").val("");
        $("#CarDivType option:not(:selected)").attr("disabled", false);
        $("#CarDivType").removeClass("read");
        $("#BtnChkCar").css("display", "inline-block");

    } else if (obj === "DriverCell") {
        $("#BtnChkDriverReset").hide();
        $("#ChkDriver").val("");
        $("#DriverSeqNo").val("");
        $("#BtnChkDriver").css("display", "inline-block");
    } else if (obj === "ComCorpNo") {
        $("#BtnChkCorpNoReset").hide();
        $("#ChkCom").val("");
        $("#ComCode").val("");
        $("#ComStatus").val("");
        $("#ComTaxKind").val("");
        $("#BtnChkCorpNo").css("display", "inline-block");
        $("#ComTaxKind option:not(:selected)").attr("disabled", false);
        $("#CooperatorFlag").prop("checked", false);
        $("#CargoManFlag").prop("checked", false);
        $("#ComName").val("");
        $("#ComCeoName").val("");
        $("#ComBizType").val("");
        $("#ComBizClass").val("");
        $("#ComTelNo").val("");
        $("#ComFaxNo").val("");
        $("#ComEmail").val("");
        $("#ComPost").val("");
        $("#ComAddr").val("");
        $("#ComAddrDtl").val("");
        $("#ComKindM").val("");
        $("#InsureTargetFlagY").prop("checked", true);
        $("#InsureTargetFlagN").prop("checked", false);
    } else if (obj === "Acct") {
        $("#BtnChkAcctNo").css("display", "inline-block");
        $("#BtnChkAcctNoReset").hide();
        $("#EncAcctNo").attr("readonly", false);
        $("#EncAcctNo").focus();
        $("#AcctName").attr("readonly", false);
        $("#BankCode option:not(:selected)").attr("disabled", false);
        $("#BankCode").removeClass("read");
        $("#AcctValidFlag").val("");
    }
}

function fnCarDispatchInsConfirm() {
    var strConfMsg = "";
    var strCallType = "";
    if (fnCarDispathRefValid()) {
        strCallType = "CarDispatchInsert";
        strConfMsg = "차량업체를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록");
        strConfMsg += "하시겠습니까?";

        var fnParam = strCallType;
        fnDefaultConfirm(strConfMsg, "fnCarDispatchIns", fnParam);
        return;
    }
}
//차량업체 등록
function fnCarDispatchIns(fnParam) {
    var strHandlerURL = "/APP/TMS/Car/Proc/AppCarDispatchRefHandler.ashx";
    var strCallBackFunc = "fnAjaxInsCarDispatch";

    var objParam = {
        CallType: fnParam,
        HidMode: $("#HidMode").val(),
        RefSeqNo: $("#RefSeqNo").val(),
        CenterCode: $("#CenterCode").val(),
        CarDivType: $("#CarDivType").val(),
        CarSeqNo: $("#CarSeqNo").val(),
        CarNo: $("#CarNo").val(),
        CarTypeCode: $("#CarTypeCode").val(),
        CarSubType: $("#CarSubType").val(),
        CarTonCode: $("#CarTonCode").val(),
        CarBrandCode: $("#CarBrandCode").val(),
        CarNote: $("#CarNote").val(),
        ComCode: $("#ComCode").val(),
        ContractCenterCode: $("#ContractCenterCode").val(),
        ComTypeCode: $("#ComTypeCode").val(),
        ComName: $("#ComName").val(),
        ComCeoName: $("#ComCeoName").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        ComBizType: $("#ComBizType").val(),
        ComBizClass: $("#ComBizClass").val(),
        ComTelNo: $("#ComTelNo").val(),
        ComFaxNo: $("#ComFaxNo").val(),
        ComEmail: $("#ComEmail").val(),
        ComPost: $("#ComPost").val(),
        ComAddr: $("#ComAddr").val(),
        ComAddrDtl: $("#ComAddrDtl").val(),
        ComStatus: $("#ComStatus").val(),
        ComTaxKind: $("#ComTaxKind").val(),
        ComTaxMsg: $("#ComTaxMsg").val(),
        CardAgreeFlag: $("#CardAgreeFlag").val(),
        CardAgreeYMD: $("#CardAgreeYMD").val(),
        DriverSeqNo: $("#DriverSeqNo").val(),
        DriverName: $("#DriverName").val(),
        DriverCell: $("#DriverCell").val(),
        PayDay: $("#PayDay").val(),
        BankCode: $("#BankCode").val(),
        EncAcctNo: $("#EncAcctNo").val(),
        SearchAcctNo: $("#SearchAcctNo").val(),
        AcctName: $("#AcctName").val(),
        AcctValidFlag: $("#AcctValidFlag").val(),
        CooperatorFlag: $("#CooperatorFlag").is(":checked") ? "Y" : "N",
        CargoManFlag: $("#CargoManFlag").is(":checked") ? "Y" : "N",
        ChargeName: $("#ChargeName").val(),
        ChargeTelNo: $("#ChargeTelNo").val(),
        ChargeEmail: $("#ChargeEmail").val(),
        RefNote: $("#RefNote").val(),
        DtlSeqNo: $("#DtlSeqNo").val(),
        InsureTargetFlag: $("#InsureTargetFlagY").is(":checked") ? "Y" : "N",
        UseFlag: "Y"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}
//차량업체등록 입력값 체크
function fnCarDispathRefValid() {

    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("회원사를 선택해주세요.", "warning", "fnObjFocus", "#CenterCode");
        return false;
    }

    if ($("#CarDivType").val() === "") {
        fnDefaultAlert("차량구분을 선택해주세요.", "warning", "fnObjFocus", "#CarDivType");
        return false;
    }

    if ($("#CarNo").val() === "") {
        fnDefaultAlert("차량번호를 선택해주세요.", "warning", "fnObjFocus", "#CarNo");
        return false;
    }

    if ($("#DriverName").val() === "") {
        fnDefaultAlert("기사명은 필수 입력입니다.", "warning", "fnObjFocus", "#DriverName");
        return false;
    }

    if ($("#DriverCell").val() === "") {
        fnDefaultAlert("기사 번호는 필수 입력입니다.", "warning", "fnObjFocus", "#DriverCell");
        return false;
    }

    if ($("#ComCorpNo").val() === "") {
        fnDefaultAlert("사업자 번호는 필수 입력입니다.", "warning", "fnObjFocus", "#ComCorpNo");
        return false;
    }

    if ($("#HidMode").val() !== "Update") {
        if ($("#ComTaxKind").val() === "") {
            fnDefaultAlert("과세구분이 선택되지 않았습니다.<br>사업자번호를 다시 조회해주세요.", "warning", "fnObjFocus", "#ComTaxKind");
            return false;
        }

        if ($("#ComStatus").val() != "2") {
            fnDefaultAlert("정상 사업자가 아닙니다.", "warning", "fnObjFocus", "#ComCorpNo");
            return false;
        }

        if ($("#ComStatus").val() === "") {
            fnDefaultAlert("사업자 번호를 조회해주세요.", "warning", "fnObjFocus", "#ComCorpNo");
            return false;
        }
    }

    if ($("#ComName").val() === "") {
        fnDefaultAlert("업체명은 필수 입력입니다.", "warning", "fnObjFocus", "#ComName");
        return false;
    }

    if ($("#ComCeoName").val() === "") {
        fnDefaultAlertFocus("대표자명은 필수 입력입니다.", "ComCeoName", "warning");
        return false;
    }

    if ($("#ChkCar").val() === "") {
        fnDefaultAlert("차량번호 중복확인이 필요합니다.", "warning", "fnObjFocus", "#CarNo");
        return false;
    }

    if ($("#ChkCom").val() === "") {
        fnDefaultAlert("사업자번호 확인이 필요합니다.", "warning", "fnObjFocus", "#ComCorpNo");
        return false;
    }

    if (!$("#InsureTargetFlagY").is(":checked") && !$("#InsureTargetFlagN").is(":checked")) {
        fnDefaultAlert("산재보험 대상 여부를 선택하세요.", "warning");
        return false;
    }

    if (!$("#")) {
        fnDefaultAlert("기사 휴대폰번호 중복확인이 필요합니다.", "warning", "fnObjFocus", "#DriverCell");
        return false;

    }

    var strComCeoName = fnToFullString($("#ComCeoName").val());
    var strComName = fnToFullString($("#ComName").val());

    if ($("#AcctValidFlag").val() === "Y") {
        if ($("#AcctName").val().indexOf(strComCeoName) == -1 && $("#AcctName").val().indexOf(strComName) == -1 && strComName.indexOf($("#AcctName").val()) == -1) {
            fnDefaultAlert("예금주는 업체명 또는 대표자명과 동일해야 합니다.", "warning");
            return false;
        }
    }

    if ($("#BankCode").val() != "" && $("#AcctValidFlag").val() == "") {
        fnDefaultAlertFocus("계좌정보가 입력되어있습니다.<br>(계좌정보를 등록하시려면 계좌확인 후 저장, 미등록하시려면 공란으로 처리)", "BankCode", "warning");
        return false;
    }
    if ($("#AcctName").val() != "" && $("#AcctValidFlag").val() == "") {
        fnDefaultAlertFocus("계좌정보가 입력되어있습니다.<br>(계좌정보를 등록하시려면 계좌확인 후 저장, 미등록하시려면 공란으로 처리)", "AcctName", "warning");
        return false;
    }
    if ($("#EncAcctNo").val() != "" && $("#AcctValidFlag").val() == "") {
        fnDefaultAlertFocus("계좌정보가 입력되어있습니다.<br>(계좌정보를 등록하시려면 계좌확인 후 저장, 미등록하시려면 공란으로 처리)", "EncAcctNo", "warning");
        return false;
    }
    if ($("#HidMode").val() === "Update") {
        if ($("#UseFlag").val() === "") {
            fnDefaultAlertFocus("사용여부를 선택해주세요", "UseFlag", "warning");
            return false;
        }
    }

    return true;
}

function fnAjaxInsCarDispatch(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
    } else {

        var strConfMsg = "";
        var strCallType = "";
        strConfMsg = $("#HidMode").val() === "Update" ? "수정" : "등록";
        strConfMsg += " 성공하였습니다.";

        fnDefaultAlert(strConfMsg, "success", "fnLocationUpdateMode", data[0].RefSeqNo);
    }
    $("#divLoadingImage").hide();
}

function fnLocationUpdateMode(RefSeqNo) {
    if ($("#HidMode").val() === "Insert") {
        document.location.replace("/APP/TMS/Car/CarDispatchRefIns?HidMode=Update&RefSeqNo=" + RefSeqNo + "&HidParam=" + $("#HidParam").val());
        return;
    }
}

function fnObjFocus(obj) {
    $(obj).focus();
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
    var strHandlerURL = "/APP/TMS/Car/Proc/AppCarDispatchRefHandler.ashx";
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
    console.log(data);
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





//반각 문자열을 전각 문자열로 변환
function fnToFullString(strConvert) {
    var strResult = "";
    strConvert = strConvert + "";

    if (strConvert != "") {
        for (var i = 0; i < strConvert.length; i++) {
            strResult += fnToFullChar(strConvert.charAt(i));
        }
    }
    return strResult;
}

function fnToFullChar(strChar) {
    var strFullChar = ""; //컨버트된 문자
    var c = strChar.charCodeAt(0);

    if (32 <= c && c <= 126) { //전각으로 변환될수 있는 문자의 범위
        if (c === 32) { //스페이스인경우 ascii 코드 32
            strFullChar = "　";
        } else {
            strFullChar = unescape("%u" + fnDecToHex(c + 65248));
        }
    } else {
        strFullChar = strChar;
    }

    return strFullChar;
}

// 10진수를 16진수로 변환
function fnDecToHex(intDec) {

    var arrHex = new Array();
    var intSerial = 0;

    while (intDec > 15) {
        var intH = intDec % 16;          //나머지
        intDec = parseInt(intDec / 16); //몫
        arrHex[intSerial++] = (intH > 9 ? String.fromCharCode(intH + 55) : intH); //16진수코드변환
    }

    //마지막은 몫의 값을 가짐
    arrHex[intSerial++] = (intDec > 9 ? String.fromCharCode(intDec + 55) : intDec); //16진수코드변환

    //몫,나머지,나머지
    var strRetValue = "";
    for (var i = arrHex.length; i > 0; i--) {
        strRetValue += arrHex[i - 1];
    }

    return strRetValue;
}

function fnListBack() {
    location.href = "/APP/TMS/Car/CarDispatchRefList?" + strListDataParam;
}