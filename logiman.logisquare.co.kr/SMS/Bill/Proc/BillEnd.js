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

            fnSetBillInfo();
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

function fnSetBillInfo() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Bill/Proc/SmsBillHandler.ashx";
    var strCallBackFunc = "fnSetBillInfoSuccResult";
    var strFailCallBackFunc = "fnSetBillInfoFailResult";

    var objParam = {
        CallType: "SmsPurchaseClosingList",
        No: $("#No").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetBillInfoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnSetBillInfoFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnSetBillInfoFailResult("전표정보를 찾을 수 없습니다.");
            return false;
        }

        var item = objRes[0].data.list[0];

        //위수탁 발행 완료 계산서 처리
        if (!(item.BillStatus > 1 && item.BillKind === 2)) {
            fnGoError("발행 신청된 전표가 아닙니다.");
            return false;
        }

        $("#CenterTelNo").html("<a href=\"tel:" + item.TelNo + "\">" + item.TelNo + "</a>");
        $(".BillStatus" + item.BillStatus).show();
    } else {
        fnSetBillInfoFailResult();
        return false;
    }
}

function fnSetBillInfoFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    fnGoError(msg);
    return false;
}