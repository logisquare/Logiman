var strCardAgreeExists = "N";
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
        CallType: "ParamChkWithJoin",
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

            strCardAgreeExists = objRes[0].CardAgreeExists;

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

        $("#SELR_CORP_NO").text(item.ComCorpNo);
        $("#SELR_CORP_NM").text(item.ComName);
        $("#SELR_CEO").text(item.ComCeoName);
        $("#SELR_BUSS_CONS").text(item.ComBizClass);
        $("#SELR_BUSS_TYPE").text(item.ComBizType);
        $("#SELR_ADDR").text(item.ComAddr);
        $("#SELR_TEL").text(item.ComTelNo);
        $("#SELR_FAX").text(item.ComFaxNo);
        $("#SELR_EMAIL").text(item.ComEmail);

        $("#BUYR_CORP_NO").text(item.CorpNo);
        $("#BUYR_CORP_NM").text(item.CenterName);
        $("#BUYR_CEO").text(item.CeoName);
        $("#BUYR_BUSS_CONS").text(item.BizClass);
        $("#BUYR_BUSS_TYPE").text(item.BizType);
        $("#BUYR_ADDR").text(item.Addr);

        $("#BILL_YMD").text(fnGetStrDateFormat(item.BillWrite, "."));
        $("#CHRG_AMT").text(fnMoneyComma(item.SupplyAmt));
        $("#TAX_AMT").text(fnMoneyComma(item.TaxAmt));
        $("#TOTL_AMT").text(fnMoneyComma(item.OrgAmt));

        if (fnGetDateToday("") > item.BillLimitYMD) {
            $("#BtnTaxBill").on("click", function () {
                fnDefaultAlert("계산서 발행 가능일(" + fnGetStrDateFormat(item.BillLimitYMD, ".") + ")이 초과되어 발행 요청하실 수 없습니다.", "info");
                return false;
            });
            return false;
        }

        if (strCardAgreeExists !== "Y") {
            $("#BtnTaxBill").on("click", function () {
                fnGoJoin("계산서 발행 신청을 위하여 사용자 인증 페이지로 이동합니다.");
                return false;
            });
            return false;
        }else{
            $("#BtnTaxBill").on("click", function() {
                fnSetTaxBillIns();
                return false;
            });
            return false;
        }
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

function fnSetTaxBillIns() {
    var strHandlerUrl = "/SMS/Bill/Proc/SmsBillHandler.ashx";
    var strCallBackFunc = "fnSetTaxBillInsSuccResult";
    var strFailCallBackFunc = "fnSetTaxBillInsFailResult";

    var objParam = {
        CallType: "SmsPurchaseTaxBillIns",
        No: $("#No").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetTaxBillInsSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnGoEnd("발행 신청이 완료되었습니다.");
            return false;
        } else {
            $("#No").val("");
            fnSetTaxBillInsFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        $("#No").val("");
        fnSetTaxBillInsFailResult();
        return false;
    }
}

function fnSetTaxBillInsFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    fnGoError(msg);
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
    document.location.replace("/SMS/Common/Join?No=" + encodeURIComponent($("#No").val()) + "&RetNo=" + encodeURIComponent($("#No").val()) + "&RetUrl=/SMS/Bill/BillInfo.aspx");
    return false;
}