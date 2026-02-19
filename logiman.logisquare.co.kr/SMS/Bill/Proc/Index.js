$(document).ready(function () {
    fnSetInit();
});

function fnSetInit() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Bill/Proc/SmsBillHandler.ashx";
    var strCallBackFunc = "fnSetInitSuccResult";
    var strFailCallBackFunc = "fnSetInitFailResult";

    var objParam = {
        CallType: "ParamChk",
        No: $("#No").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetInitSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {

            if (objRes[0].TimeOutFlag == "Y") {
                fnGoError("조회 가능 기간(발송일 기준 45일)이 초과했습니다.");
                return false;
            }

            $("#No").val(objRes[0].No);
            fnSetCompanyInfo();
            return false;
        } else {
            $("#No").val("");
            fnSetInitFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        $("#No").val("");
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

function fnSetCompanyInfo() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Bill/Proc/SmsBillHandler.ashx";
    var strCallBackFunc = "fnSetCompanyInfoSuccResult";
    var strFailCallBackFunc = "fnSetCompanyInfoFailResult";

    var objParam = {
        CallType: "SmsPurchaseClosingList",
        No: $("#No").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetCompanyInfoSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnSetCompanyInfoFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnSetCompanyInfoFailResult("전표정보를 찾을 수 없습니다.");
            return false;
        }

        var item = objRes[0].data.list[0];

        //위수탁 발행 완료 계산서 처리
        if (item.BillStatus > 1 && item.BillKind === 2) {
            fnGoEnd();
            return false;
        }

        //기타 발행 전표 처리
        if (item.BillStatus > 1 && item.BillKind !== 2) {
            fnGoError("이미 발행 처리된 전표입니다.");
            return false;
        }

        //기타 불가 전표 처리
        if (item.SendStatus > 1) {
            fnGoError("이미 송금 처리된 전표입니다.");
            return false;
        }

        $("#ComCorpNo").text(item.ComCorpNo);
        $("#BankName").text(item.BankName);
        $("#AcctName").text(item.AcctName);
        $("#SearchAcctNo").text(item.SearchAcctNo);
        $("#ChargeEmail").text(item.ComEmail);

    } else {
        fnSetCompanyInfoFailResult();
        return false;
    }
}

function fnSetCompanyInfoFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    fnGoError(msg);
    return false;
}

function fnGoEnd(strMsg) {
    if (typeof strMsg === "string") {
        fnDefaultAlert(strMsg, "info", "fnGoAction(\"BillEnd.aspx\")");
        return false;
    } else {
        fnGoAction("BillEnd.aspx");
        return false;
    }
}

function fnGoAction(strPage) {
    var url = "/SMS/Bill/" + strPage + "?No=" + encodeURIComponent($("#No").val());
    document.location.href = url;
    return false;
}

function fnGoNext() {
    fnGoAction("BillInfo");
    return false;
}
