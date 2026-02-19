$(document).ready(function () {
    $("dl.bill_info dt").click(function () {
        $(this).toggleClass("up");
        $(this).next().slideToggle(500);
    });
    
    $("#BtnQuickPay").on("click", function () {
        fnQuickPay();
        return;
    });

    $("#BtnQuickPayView").on("click", function () {
        fnQuickPay();
        return;
    });
    
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

        $.each($("span"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).text(eval("item." + $(input).attr("id")));
                }
            });

        $("#CenterNameView").text(item.CenterName);
        $("#BankNameView").text(item.BankName);
        $("#SearchAcctNoView").text(item.SearchAcctNo);
        $("#AcctNameView").text(item.AcctName);
        $("#SendPlanYMD").text(fnGetStrDateFormat(item.SendPlanYMD, "."));
        $("#BillWriteView").text(fnGetStrDateFormat(item.BillWrite, "."));
        $("#DeductAmtView").text(fnMoneyComma(item.DeductAmt));
        $("#SendAmtView").text(fnMoneyComma(item.SendAmt));

        if (item.SendStatus >= 2) {
            $("#BankNameView").text(item.SendBankName);
            $("#SearchAcctNoView").text(item.SendSearchAcctNo);
            $("#AcctNameView").text(item.SendAcctName);
        }

        $("#BillWrite").text(fnGetStrDateFormat(item.BillWrite, "."));
        $("#OrgAmt").text(fnMoneyComma(item.OrgAmt));
        $("#SupplyAmt").text(fnMoneyComma(item.SupplyAmt));
        $("#TaxAmt").text(fnMoneyComma(item.TaxAmt));
        
        if (item.SendType === 0 || (item.SendType === 1 && item.SendStatus <= 2)) { //빠른입금 신청 가능
            $("#DivQuickPayInfo").show();
            $("#DivQuickPayEnd").remove();
            $("#DivButton1").show();
            $("#DivButton2").remove();
        } else if (item.SendType === 3) { //빠른입금 신청
            $("#DivQuickPayInfo").remove();
            $("#DivQuickPayEnd").show();
            $("#DivButton1").remove();
        } else {
            $("#DivQuickPayInfo").remove();
            $("#DivQuickPayEnd").remove();
            $("#DivButton1").remove();
        }

        if (item.SendStatus === 3) {
            $("#TdPay").hide();
            $("#TdPayEnd").show();
        } else {
            $("#TdPay").show();
            $("#TdPayEnd").hide();
        }

        $("#DtlOrgAmt").text(fnMoneyComma(item.OrgAmt));
        $("#DtlDriverInsureAmt").text(fnMoneyComma(item.DriverInsureAmt));
        $("#DtlInputDeductAmt").text(fnMoneyComma(item.InputDeductAmt));
        $("#DtlSendAmt").text(fnMoneyComma(item.SendAmt));

        if (item.SendType === 3  && item.SendStatus >= 2) {
            fnGetCargopayInfo();
        }
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


function fnQuickPay() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var url = "/SMS/Pay/PayStep01.aspx?No=" + encodeURIComponent($("#No").val());
    document.location.href = url;
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

        if (item.ExistsFlag !== "Y") {
            fnGetCargopayInfoFailResult("입금 신청정보를 찾을 수 없습니다.");
            return false;
        }

        $("#RateAmt").text(fnMoneyComma(item.SendFee));
        $("#ResultAmt").text(fnMoneyComma(item.ResultAmt));
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
