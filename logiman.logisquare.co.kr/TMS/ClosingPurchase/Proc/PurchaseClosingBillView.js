$(document).ready(function () {
    fnSetInitData();
});

//기본정보 세팅
function fnSetInitData() {
    if ($("#HidErrMsg").val()) {
        fnDefaultAlert($("#HidErrMsg").val(), "warning", "fnClosePopUpLayer()");
        return false;
    }
    fnCallPurchaseClosing();
}

function fnCallPurchaseClosing() {
    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingBillHandler.ashx";
    var strCallBackFunc = "fnCallPurchaseClosingSuccResult";
    var strFailCallBackFunc = "fnCallPurchaseClosingFailResult";

    var objParam = {
        CallType: "PurchaseClosingList",
        CenterCode: $("#CenterCode").val(),
        PurchaseClosingSeqNo: $("#PurchaseClosingSeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCallPurchaseClosingSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallPurchaseClosingFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallPurchaseClosingFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnCallPurchaseClosingFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];
        $("#SendStatus").val(item.SendStatus);
        $("#BillStatus").val(item.BillStatus);
        $("#BillWrite").val(item.BillWrite);
        
        if ($("#SendStatus").val() === "1" && $("#BillStatus").val() === "3" && $("#BtnCnlPreMatching").length > 0) {
            $("#BtnCnlPreMatching").show();
        }

        if ($("#BillStatus").val() === "2") {
            fnDefaultAlert("계산서 발행 완료 후에 확인하실 수 있습니다.", "error", "fnClosePopUpLayer()");
            return false;
        }

        fnCallBillDetail();
    }
    else {
        fnCallPurchaseClosingFailResult();
    }
}

function fnCallPurchaseClosingFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("계산서 정보를 불러오는데 실패했습니다." + msg, "error", "fnClosePopUpLayer()");
}

//계산서 세팅
function fnCallBillDetail() {

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingBillHandler.ashx";
    var strCallBackFunc = "fnCallBillDetailSuccResult";
    var strFailCallBackFunc = "fnCallBillDetailFailResult";

    var objParam = {
        CallType: "HometaxList",
        CenterCode: $("#CenterCode").val(),
        PurchaseClosingSeqNo: $("#PurchaseClosingSeqNo").val(),
        NtsConfirmNum: $("#NtsConfirmNum").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCallBillDetailSuccResult(objRes) {

    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallBillDetailFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallBillDetailFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        if (objRes[0].data.RECORD_CNT !== 1) {
            fnCallBillDetailFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];
        $.each($("span"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).text(eval("item." + $(input).attr("id")));
                }
            });

        $("#SUPPLY_COST_TOTAL").text(fnMoneyComma(item.SUPPLY_COST_TOTAL));
        $("#TAX_TOTAL").text(fnMoneyComma(item.TAX_TOTAL));
        $("#TOTAL_AMOUNT").text(fnMoneyComma(item.TOTAL_AMOUNT));
        $("#WRITE_DATE").text(fnGetStrDateFormat(item.WRITE_DATE, "-"));
        $("#ScanFileUrl").val(item.SCAN_FILE_URL);
        $("#ScanFileName").val(item.SCAN_FILENAME);

        if (item.INVOICE_KIND == "4") {//전자세금계산서-계산서구분(1:일반매입전자계산서, 2:카고페이위수탁계산서, 3:타사위수탁계산서 4.수기계산서)
            $("#BrnViewOriginal").show();
        }

        fnCallBillItemDetail();
    } else {
        fnCallBillDetailFailResult();
    }
}

function fnCallBillDetailFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("계산서 정보를 불러오는데 실패했습니다." + msg, "error", "fnClosePopUpLayer()");
}


//계산서 상세
function fnCallBillItemDetail() {

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingBillHandler.ashx";
    var strCallBackFunc = "fnCallBillItemDetailSuccResult";
    var strFailCallBackFunc = "fnCallBillItemDetailFailResult";

    var objParam = {
        CallType: "HometaxItemList",
        NtsConfirmNum: $("#NtsConfirmNum").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCallBillItemDetailSuccResult(objRes) {

    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallBillItemDetailFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallBillItemDetailFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        if (objRes[0].data.RECORD_CNT === 0) {
            for (i = 1; i <= 5; i++) {
                var html = "";
                html += "<tr>\n";
                html += "\t<td class=\"al_c noborder_l tax_gb_01_t tax_gb_01_r\" colspan=\"3\">\n";
                html += "\t<span></span>\n";
                html += "\t</td>\n";
                html += "\t<td class=\"al_c noborder_l tax_gb_01_t tax_gb_01_r\" colspan=\"3\">\n";
                html += "\t<span></span>\n";
                html += "\t</td>\n";
                html += "\t<td class=\"al_l pdl_3 tax_gb_01_t tax_gb_01_r\" colspan=\"20\">\n";
                html += "\t<span></span>\n";
                html += "\t</td>\n";
                html += "\t<td class=\"al_c pdl_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
                html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
                html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
                html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"18\">\n";
                html += "\t<span></span>\n";
                html += "\t</td>\n";
                html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"13\">\n";
                html += "\t<span></span>\n";
                html += "\t</td>\n";
                html += "\t<td class=\"al_l pdl_3 tax_gb_01_t\" colspan=\"22\"></td>\n";
                html += "</tr>\n";

                $("#InvoiceDetail").append(html);
            }
            return false;
        } else {

            $.each(objRes[0].data.list,
                function(index, item) {
                    var num = index + 1;
                    var html = "";
                    html += "<tr>\n";
                    html += "\t<td class=\"al_c noborder_l tax_gb_01_t tax_gb_01_r\" colspan=\"3\">\n";
                    html += "\t<span id=\"DTL_BUY_DATE" +
                        num +
                        "\" style=\"display:none;\">" +
                        item.PURCHASE_DT +
                        "</span>\n";
                    html += "\t<span>" + item.PURCHASE_DT.substring(4, 6) + "</span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_c noborder_l tax_gb_01_t tax_gb_01_r\" colspan=\"3\">\n";
                    html += "\t<span>" + item.PURCHASE_DT.substring(6, 8) + "</span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_l pdl_3 tax_gb_01_t tax_gb_01_r\" colspan=\"20\">\n";
                    html += "\t<span id=\"DTL_ITEM_NM" + num + "\">" + item.ITEM_NAME + "</span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_c pdl_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
                    html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
                    html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
                    html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"18\">\n";
                    html += "\t<span id=\"DTL_ITEM_AMT" + num + "\">" + fnMoneyComma(item.SUPPLY_COST) + "</span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"13\">\n";
                    html += "\t<span id=\"DTL_ITEM_TAX" + num + "\">" + fnMoneyComma(item.TAX) + "</span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_l pdl_3 tax_gb_01_t\" colspan=\"22\">";
                    html += "\t<span id=\"DTL_ITEM_DESP" + num + "\">" + item.REMARK + "</span>\n";
                    html += "\t</td>\n";
                    html += "</tr>\n";

                    $("#InvoiceDetail").append(html);
                });

            if (objRes[0].data.RECORD_CNT < 5) {
                for (i = 1; i <= 5 - objRes[0].data.RECORD_CNT; i++) {
                    var html = "";
                    html += "<tr>\n";
                    html += "\t<td class=\"al_c noborder_l tax_gb_01_t tax_gb_01_r\" colspan=\"3\">\n";
                    html += "\t<span></span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_c noborder_l tax_gb_01_t tax_gb_01_r\" colspan=\"3\">\n";
                    html += "\t<span></span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_l pdl_3 tax_gb_01_t tax_gb_01_r\" colspan=\"20\">\n";
                    html += "\t<span></span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_c pdl_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
                    html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
                    html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
                    html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"18\">\n";
                    html += "\t<span></span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"13\">\n";
                    html += "\t<span></span>\n";
                    html += "\t</td>\n";
                    html += "\t<td class=\"al_l pdl_3 tax_gb_01_t\" colspan=\"22\"></td>\n";
                    html += "</tr>\n";

                    $("#InvoiceDetail").append(html);
                }
            }
        }
    }
    else {
        fnCallBillItemDetailFailResult();
    }
}

function fnCallBillItemDetailFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("계산서 정보를 불러오는데 실패했습니다." + msg, "error", "fnClosePopUpLayer()");
}

function fnViewOriginal() {
    if (!$("#ScanFileUrl").val() || !$("#ScanFileName").val()) {
        fnDefaultAlert("계산서 원본을 확인할 수 없습니다.", "error");
        return false;
    }

    fnPopupWindow($("#ScanFileUrl").val(), "계산서 원본보기", "700px", "500px", "");
    return false;
}

function fnCnlPreMatching() {
    if ($("#BillStatus").val() == "1" || $("#BillStatus").val() == "2") {
        fnDefaultAlert("계산서 발행 완료 후 연결 해제하실 수 있습니다.", "error");
        return false;
    }

    fnDefaultConfirm("계산서를 연결 해제하시겠습니까?", "fnCnlPreMatchingProc", "");
    return false;
}

function fnCnlPreMatchingProc() {

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingBillHandler.ashx";
    var strCallBackFunc = "fnCnlPreMatchingSuccResult";
    var strFailCallBackFunc = "fnCnlPreMatchingFailResult";

    var objParam = {
        CallType: "HometaxPreMatchingCancel",
        CenterCode: $("#CenterCode").val(),
        PurchaseClosingSeqNo: $("#PurchaseClosingSeqNo").val(),
        NtsConfirmNum: $("#NtsConfirmNum").val(),
        BillWrite: $("#BillWrite").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnCnlPreMatchingSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCnlPreMatchingFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        fnDefaultConfirm("계산서 연결이 해제되었습니다.<br/>마감을 취소하시겠습니까?", "fnCnlClosing", "", "fnClosePopUpLayer()");
        return false;
    }
    else {
        fnCnlPreMatchingFailResult();
    }
}

function fnCnlPreMatchingFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("계산서 연결해제에 실패했습니다." + msg, "error", "");
}

function fnCnlClosing() {

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseClosingBillHandler.ashx";
    var strCallBackFunc = "fnCnlClosingSuccResult";
    var strFailCallBackFunc = "fnCnlClosingFailResult";

    var objParam = {
        CallType: "PurchaseClosingCancel",
        CenterCode: $("#CenterCode").val(),
        PurchaseClosingSeqNo: $("#PurchaseClosingSeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnCnlClosingSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCnlClosingFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        fnDefaultAlert("마감이 취소되었습니다.", "success", "fnClosePopUpLayer()");
        return false;
    }
    else {
        fnCnlClosingFailResult();
    }
}

function fnCnlClosingFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("마감취소에 실패했습니다." + msg, "error", "fnClosePopUpLayer()");
}