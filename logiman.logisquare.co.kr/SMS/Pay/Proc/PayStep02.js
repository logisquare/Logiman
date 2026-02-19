var CardAgreeExists = "N";
var SendPlanYMD = "";
var SendAmt = 0;
var CooperatorFlag = "N";
$(document).ready(function () {
    fnSetInit();
});

function fnSetInit() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Pay/Proc/SmsPayHandler.ashx";
    var strCallBackFunc = "fnSetInitSuccResult";
    var strFailCallBackFunc = "fnSetInitFailResult";

    var objParam = {
        CallType: "ParamChkWithJoin",
        No: $("#No").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetInitSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            if (objRes[0].ComCorpNoChkFlag !== "Y") {
                fnSetInitFailResult("사업자번호 체크 후 이용이 가능합니다.");
                return false;
            }

            if (objRes[0].ComCorpNoChkTimeOutFlag === "Y") {
                fnSetInitFailResult("사업자번호 체크 후 1시간이 초과하여 이용이 불가능합니다.");
                return false;
            }

            CardAgreeExists = objRes[0].CardAgreeExists;

            fnGetBillInfo();
        } else {
            fnSetInitFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetInitFailResult();
        return false;
    }
}

function fnSetInitFailResult(msg) {
    
    if (typeof msg !== "string") {
        msg = "";
    }
    fnGoError(msg);
    return false;
}

function fnGoReturn(strMsg) {
    if (typeof strMsg === "string") {
        fnDefaultAlert(strMsg, "info", "fnGoAction(\"PayInfo.aspx\")");
        return false;
    } else {
        fnGoAction("PayInfo.aspx");
        return false;
    }
}

function fnGoEnd(strMsg) {
    if (typeof strMsg === "string") {
        fnDefaultAlert(strMsg, "info", "fnGoAction(\"PayStepEnd.aspx\")");
        return false;
    } else {
        fnGoAction("PayStepEnd.aspx");
        return false;
    }
}

function fnGoAction(strPage) {
    var url = "/SMS/Pay/" + strPage + "?No=" + encodeURIComponent($("#No").val());
    document.location.href = url;
    return false;
}

function fnGoJoin(strMsg) {
    if (typeof strMsg === "string") {
        fnDefaultAlert(strMsg, "info", "fnGoJoinAction()");
        return false;
    } else {
        fnGoJoinAction();
        return false;
    }
}

function fnGoJoinAction() {
    document.location.replace("/SMS/Common/Join?No=" + encodeURIComponent($("#No").val()) + "&RetNo=" + encodeURIComponent($("#No").val()) + "&RetUrl=/SMS/Pay/PayStep02.aspx");
    return false;
}


function fnGetBillInfo() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Pay/Proc/SmsPayHandler.ashx";
    var strCallBackFunc = "fnGetBillInfoSuccResult";
    var strFailCallBackFunc = "fnGetBillInfoFailResult";

    var objParam = {
        CallType: "SmsPurchaseClosingList",
        No: $("#No").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnGetBillInfoSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnGetBillInfoFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnGetBillInfoFailResult("전표정보를 찾을 수 없습니다.");
            return false;
        }

        var item = objRes[0].data.list[0];

        if (fnGetDateTerm(fnGetStrDateFormat(item.SendPlanYMD, "-"), GetDateToday("-")) > 10) {
            fnGetBillInfoFailResult("조회 가능일이 초과되었습니다.");
            return false;
        }

        $("#OrgAmt").text(fnMoneyComma(item.OrgAmt));
        $("#DriverInsureAmt").text(fnMoneyComma(item.DriverInsureAmt));
        $("#InputDeductAmt").text(fnMoneyComma(item.InputDeductAmt));
        $("#SendAmt").text(fnMoneyComma(item.SendAmt));
        $("#SendAmtView").text(fnMoneyComma(item.SendAmt));
        SendPlanYMD = item.SendPlanYMD;
        SendAmt = item.SendAmt;
        CooperatorFlag = item.CooperatorFlag;

        if (item.SendType === 0 || (item.SendType === 1 && item.SendStatus <= 2)) { //빠른입금 신청 가능
            $("#BtnQuickPay").off().on("click", function () {
                //fnGoNext();
                if (CardAgreeExists === "Y") { //빠른입금 신청
                    fnPay();
                } else { //가입처리
                    fnGoJoin("빠른입금 신청을 위하여 사용자 인증 페이지로 이동합니다.");
                }
                return false;
            });
        } else if (item.SendType === 3) { //빠른입금 신청
            $("#BtnQuickPay").off().on("click", function () {
                fnGoEnd("이미 빠른입금 신청이 완료된 전표입니다.");
                return false;
            });
        } else if (item.SendPlanYMD <= GetDateToday("")) { //신청 송금예정일 초과
            $("#BtnQuickPay").off().on("click", function () {
                fnGoReturn("송금예정일이 초과되어 빠른입금 신청이 불가능한 전표입니다.");
                return false;
            });
        } else {
            $("#BtnQuickPay").off().on("click", function () {
                fnGoReturn("빠른입금 신청이 불가능한 전표입니다.");
                return false;
            });
        }

        fnGetRateInfo();
    } else {
        fnGetBillInfoFailResult();
        return false;
    }
}

function fnGetBillInfoFailResult(msg) {

    if (typeof msg !== "string") {
        msg = "";
    }

    fnGoError(msg);
    return false;
}


function fnGetRateInfo() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Pay/Proc/SmsPayHandler.ashx";
    var strCallBackFunc = "fnGetRateInfoSuccResult";
    var strFailCallBackFunc = "fnGetRateInfoFailResult";

    var objParam = {
        CallType: "CenterSendFeeD",
        No: $("#No").val(),
        SendPlanYMD: SendPlanYMD,
        SendAmt: SendAmt,
        CooperatorFlag: CooperatorFlag
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}


function fnGetRateInfoSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnGetRateInfoFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        var item = objRes[0];
        $("#ResultAmt").text(fnMoneyComma(item.Amt));
        $("#ResultAmtView").text(fnMoneyComma(item.Amt));
        $("#RatePer").text(item.FeeRate);
        $("#RatePerView").text(item.FeeRate);
        $("#RateAmt").text(fnMoneyComma(item.Fee));
        $("#RateAmtView").text(fnMoneyComma(item.Fee));

    } else {
        fnGetRateInfoFailResult();
        return false;
    }
}

function fnGetRateInfoFailResult(msg) {

    if (typeof msg !== "string") {
        msg = "";
    }

    fnGoError(msg);
    return false;
}

function fnPay() {
    fnDefaultConfirm("빠른입금 신청 하시겠습니까?", "fnPayProc", "");
}

function fnPayProc() {
    var strHandlerUrl = "/SMS/Pay/Proc/SmsPayHandler.ashx";
    var strCallBackFunc = "fnPaySuccResult";
    var strFailCallBackFunc = "fnPayFailResult";

    var objParam = {
        CallType: "InsOrderTms",
        No: $("#No").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnPaySuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnPayFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        fnGoEnd("빠른입금 신청이 완료되었습니다.");
        return false;
    } else {
        fnPayFailResult();
        return false;
    }
}

function fnPayFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    } else {
        msg = " (" + msg + ")";
    }
    fnDefaultAlert("나중에 다시 시도해주세요." + msg);
    return false;
}