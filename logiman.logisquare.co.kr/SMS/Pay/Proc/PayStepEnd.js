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
        CallType: "ParamChk",
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

            fnGetCargopayInfo();
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


function fnGetCargopayInfo() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Pay/Proc/SmsPayHandler.ashx";
    var strCallBackFunc = "fnGetCargopayInfoSuccResult";
    var strFailCallBackFunc = "fnGetCargopayInfoFailResult";

    var objParam = {
        CallType: "CenterOrder",
        No: $("#No").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnGetCargopayInfoSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnGetCargopayInfoFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        var item = objRes[0];

        if (fnGetDateTerm(fnGetStrDateFormat(item.SendPlanYMD, "-"), GetDateToday("-")) > 10) {
            fnGetCargopayInfoFailResult("조회 가능일이 초과되었습니다.");
            return false;
        }

        if (item.ExistsFlag !== "Y") {
            fnGetCargopayInfoFailResult("입금 신청정보를 찾을 수 없습니다.");
            return false;
        }

        $("#OrgAmt").text(fnMoneyComma(item.OrgAmt));
        $("#DriverInsureAmt").text(fnMoneyComma(item.DriverInsureAmt));
        $("#InputDeductAmt").text(fnMoneyComma(item.InputDeductAmt));
        $("#SendAmt").text(fnMoneyComma(item.SendAmt));
        $("#ResultAmt").text(fnMoneyComma(item.ResultAmt));
        $("#ResultAmtView").text(fnMoneyComma(item.ResultAmt));
        $("#RatePer").text(fnMoneyComma(item.SendFeeRate));
        $("#RateAmt").text(fnMoneyComma(item.SendFee));
    } else {
        fnGetCargopayInfoFailResult();
        return false;
    }
}

function fnGetCargopayInfoFailResult(msg) {

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

function fnGoAction(strPage) {
    var url = "/SMS/Pay/" + strPage + "?No=" + encodeURIComponent($("#No").val());
    document.location.href = url;
    return false;
}

function fnGoMembershipApp() {
    var url = "https://play.google.com/store/apps/details?id=co.kr.cargomanager.CargopayApp";
    document.location.href = url;
    return false;
}