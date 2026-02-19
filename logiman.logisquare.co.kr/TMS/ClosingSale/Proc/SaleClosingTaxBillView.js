$(document).ready(function () {
    fnSetInitData();
});

//기본정보 세팅
function fnSetInitData() {
    if ($("#HidErrMsg").val()) {
        fnDefaultAlert($("#HidErrMsg").val(), "warning", "fnClosePopUpLayer()");
        return false;
    }
    fnCallTaxBill();
}

//계산서 세팅
function fnCallTaxBill() {

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
    var strCallBackFunc = "fnCallTaxBillSuccResult";
    var strFailCallBackFunc = "fnCallTaxBillFailResult";

    var objParam = {
        CallType: "SaleClosingTaxBillList",
        IssuSeqNo: $("#IssuSeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCallTaxBillSuccResult(objRes) {

    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallTaxBillFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallTaxBillFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        if (objRes[0].data.RECORD_CNT !== 1) {
            fnCallTaxBillFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];
        //Span
        $.each($("span"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).text(eval("item." + $(input).attr("id")));
                }
            });
        $("#ERR_CD").val(item.ERR_CD);
        $("#POPS_CODE").val(item.POPS_CODE);
        $("#NOTE3").val(item.NOTE3);
        $("#IssuSeqNo").val(item.ISSU_SEQNO);
        $("#IssuID").val(item.ISSU_ID);
        $("#CHRG_AMT").text(fnMoneyComma($("#CHRG_AMT").text()));
        $("#TAX_AMT").text(fnMoneyComma($("#TAX_AMT").text()));
        $("#TOTAL_AMT").text(fnMoneyComma(item.TOTL_AMT));
        $("#BUY_DATE").text(fnGetStrDateFormat(item.REGS_DATE, "-"));
        $("#BUYR_CHRG_NM").text(item.BUYR_CHRG_NM1);
        $("#BUYR_CHRG_EMAIL").text(item.BUYR_CHRG_EMAIL1);
        $("#BUYR_CHRG_MOBL").text(item.BUYR_CHRG_MOBL1);

        if (item.TAX_TYPE.substring(0, 2) == "01") {
            if (item.ERR_CD == "000000") { //정상발행
                if ($("#BtnModTaxBill").length > 0) {
                    $("#BtnModTaxBill").show();
                    $("#PModTaxBill").show();
                }
            } else {
                if ((item.ERR_CD != "" && item.ERR_CD != null) || $("#IssuID").val() == "") {
                    $("#BtnCnlTaxBill").show();
                }
            }
        }

        fnCallTaxBillDetail();
    }
    else {
        fnCallTaxBillFailResult();
    }
}

function fnCallTaxBillFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("계산서 정보를 불러오는데 실패했습니다." + msg, "error", "fnClosePopUpLayer()");
}

//계산서 상세
function fnCallTaxBillDetail() {

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
    var strCallBackFunc = "fnCallTaxBillDetailSuccResult";
    var strFailCallBackFunc = "fnCallTaxBillDetailFailResult";

    var objParam = {
        CallType: "SaleClosingTaxBillItemList",
        IssuSeqNo: $("#IssuSeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCallTaxBillDetailSuccResult(objRes) {

    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallTaxBillDetailFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallTaxBillDetailFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        if (objRes[0].data.RECORD_CNT === 0) {
            fnCallTaxBillDetailFailResult();
            return false;
        }

        $.each(objRes[0].data.list, function (index, item) {
            var num = index + 1;
            var html = "";
            html += "<tr>\n";
            html += "\t<td class=\"al_c noborder_l tax_gb_01_t tax_gb_01_r\" colspan=\"3\">\n";
            html += "\t<span id=\"DTL_BUY_DATE" + num + "\" style=\"display:none;\">" + item.BUY_DATE + "</span>\n";
            html += "\t<span>" + item.BUY_DATE.substring(4, 6) + "</span>\n";
            html += "\t</td>\n";
            html += "\t<td class=\"al_c noborder_l tax_gb_01_t tax_gb_01_r\" colspan=\"3\">\n";
            html += "\t<span>" + item.BUY_DATE.substring(6, 8) + "</span>\n";
            html += "\t</td>\n";
            html += "\t<td class=\"al_l pdl_3 tax_gb_01_t tax_gb_01_r\" colspan=\"20\">\n";
            html += "\t<span id=\"DTL_ITEM_NM" + num + "\">" + item.ITEM_NM + "</span>\n";
            html += "\t</td>\n";
            html += "\t<td class=\"al_c pdl_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
            html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
            html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"7\"></td>\n";
            html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"18\">\n";
            html += "\t<span id=\"DTL_ITEM_AMT" + num + "\">" + fnMoneyComma(item.ITEM_AMT) + "</span>\n";
            html += "\t</td>\n";
            html += "\t<td class=\"al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r\" colspan=\"13\">\n";
            html += "\t<span id=\"DTL_ITEM_TAX" + num + "\">" + fnMoneyComma(item.ITEM_TAX) + "</span>\n";
            html += "\t</td>\n";
            html += "\t<td class=\"al_l pdl_3 tax_gb_01_t\" colspan=\"22\">";
            html += "\t<span id=\"DTL_ITEM_DESP" + num + "\">" + item.ITEM_DESP + "</span>\n";
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
    else {
        fnCallTaxBillDetailFailResult();
    }
}

function fnCallTaxBillDetailFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("계산서 정보를 불러오는데 실패했습니다." + msg, "error", "fnClosePopUpLayer()");
}

function fnCnlTaxBill() {
    if (!$("#IssuSeqNo").val()) {
        fnDefaultAlert("필요한 정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#NOTE3").val()) {
        fnDefaultAlert("필요한 정보가 없습니다.", "warning");
        return false;
    }

    if ($("#NOTE3").val().length !== 13) {
        fnDefaultAlert("취소할 수 없는 마감 전표입니다.", "warning");
        return false;
    }

    if ($("#ERR_CD").val() == "000000") {
        fnDefaultAlert("취소할 수 없는 마감 전표입니다.", "warning");
        return false;
    }

    if (!(($("#ERR_CD").val() != "" && $("#ERR_CD").val() != null) || $("#IssuID").val() == "")) {
        fnDefaultAlert("취소할 수 없는 마감 전표입니다.", "warning");
        return false;
    }

    fnDefaultConfirm("계산서 발행을 취소 하시겠습니까?", "fnCnlTaxBillProc", "");
}


function fnCnlTaxBillProc() {
    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
    var strCallBackFunc = "fnCnlTaxBillSuccResult";
    var strFailCallBackFunc = "fnCnlTaxBillFailResult";
    var objParam = {
        CallType: "SaleClosingTaxBillCancel",
        IssuSeqNo: $("#IssuSeqNo").val(),
        SaleClosingSeqNo: $("#NOTE3").val(),
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCnlTaxBillSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("계산서 발행이 취소되었습니다.", "warning", "fnClosePopUpLayer()");
            return false;
        } else {
            fnCnlTaxBillFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnCnlTaxBillFailResult();
        return false;
    }
}

function fnCnlTaxBillFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("계산서 발행 취소에 실패했습니다. 나중에 다시 시도해 주세요." + msg, "error");
    return false;
}


function fnModTaxBill() {
    if (!$("#IssuSeqNo").val()) {
        fnDefaultAlert("필요한 정보가 없습니다.", "warning");
        return false;
    }

    if ($("#ERR_CD").val() != "000000") {
        fnDefaultAlert("수정 발행 할 수 없는 마감 전표입니다.", "warning");
        return false;
    }

    fnDefaultConfirm("계산서를 수정 발행 하시겠습니까?", "fnModTaxBillProc", "");
}

function fnModTaxBillProc() {
    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
    var strCallBackFunc = "fnModTaxBillSuccResult";
    var strFailCallBackFunc = "fnModTaxBillFailResult";
    var objParam = {
        CallType: "SaleClosingTaxBillModInsert",
        CenterCode: $("#CenterCode").val(),
        IssuSeqNo: $("#IssuSeqNo").val(),
        POPS_CODE: $("#POPS_CODE").val(),
        MODY_CODE: "06", //착오에의한이중발급
        SELR_CORP_NO: $("#SELR_CORP_NO").text(),
        SELR_CORP_NM: $("#SELR_CORP_NM").text(),
        SELR_CEO: $("#SELR_CEO").text(),
        SELR_ADDR: $("#SELR_ADDR").text(),
        SELR_TEL: $("#SELR_TEL").text(),
        SELR_BUSS_CONS: $("#SELR_BUSS_CONS").text(),
        SELR_BUSS_TYPE: $("#SELR_BUSS_TYPE").text(),
        SELR_CHRG_NM: $("#SELR_CHRG_NM").text(),
        SELR_CHRG_EMAIL: $("#SELR_CHRG_EMAIL").text(),
        SELR_CHRG_MOBL: $("#SELR_CHRG_MOBL").text(),
        BUYR_CORP_NO: $("#BUYR_CORP_NO").text(),
        BUYR_CORP_NM: $("#BUYR_CORP_NM").text(),
        BUYR_CEO: $("#BUYR_CEO").text(),
        BUYR_ADDR: $("#BUYR_ADDR").text(),
        BUYR_TEL: $("#BUYR_TEL").text(),
        BUYR_BUSS_CONS: $("#BUYR_BUSS_CONS").text(),
        BUYR_BUSS_TYPE: $("#BUYR_BUSS_TYPE").text(),
        BUYR_CHRG_NM: $("#BUYR_CHRG_NM").text(),
        BUYR_CHRG_EMAIL: $("#BUYR_CHRG_EMAIL").text(),
        BUYR_CHRG_MOBL: $("#BUYR_CHRG_MOBL").text(),
        BUY_DATE: $("#BUY_DATE").text(),
        ITEM_AMT: $("#CHRG_AMT").text(),
        ITEM_TAX: $("#TAX_AMT").text(),
        DTL_BUY_DATE1: $("#DTL_BUY_DATE1").text(),
        DTL_ITEM_NM1: $("#DTL_ITEM_NM1").text(),
        DTL_ITEM_AMT1: $("#DTL_ITEM_AMT1").text(),
        DTL_ITEM_TAX1: $("#DTL_ITEM_TAX1").text(),
        DTL_ITEM_DESP1: $("#DTL_ITEM_DESP1").text(),
        DTL_BUY_DATE2: $("#DTL_BUY_DATE2").text(),
        DTL_ITEM_NM2: $("#DTL_ITEM_NM2").text(),
        DTL_ITEM_AMT2: $("#DTL_ITEM_AMT2").text(),
        DTL_ITEM_TAX2: $("#DTL_ITEM_TAX2").text(),
        DTL_ITEM_DESP2: $("#DTL_ITEM_DESP2").text(),
        DTL_BUY_DATE3: $("#DTL_BUY_DATE3").text(),
        DTL_ITEM_NM3: $("#DTL_ITEM_NM3").text(),
        DTL_ITEM_AMT3: $("#DTL_ITEM_AMT3").text(),
        DTL_ITEM_TAX3: $("#DTL_ITEM_TAX3").text(),
        DTL_ITEM_DESP3: $("#DTL_ITEM_DESP3").text(),
        DTL_BUY_DATE4: $("#DTL_BUY_DATE4").text(),
        DTL_ITEM_NM4: $("#DTL_ITEM_NM4").text(),
        DTL_ITEM_AMT4: $("#DTL_ITEM_AMT4").text(),
        DTL_ITEM_TAX4: $("#DTL_ITEM_TAX4").text(),
        DTL_ITEM_DESP4: $("#DTL_ITEM_DESP4").text(),
        DTL_BUY_DATE5: $("#DTL_BUY_DATE5").text(),
        DTL_ITEM_NM5: $("#DTL_ITEM_NM5").text(),
        DTL_ITEM_AMT5: $("#DTL_ITEM_AMT5").text(),
        DTL_ITEM_TAX5: $("#DTL_ITEM_TAX5").text(),
        DTL_ITEM_DESP5: $("#DTL_ITEM_DESP5").text(),
        DTL_BUY_DATE6: $("#DTL_BUY_DATE6").text(),
        DTL_ITEM_NM6: $("#DTL_ITEM_NM6").text(),
        DTL_ITEM_AMT6: $("#DTL_ITEM_AMT6").text(),
        DTL_ITEM_TAX6: $("#DTL_ITEM_TAX6").text(),
        DTL_ITEM_DESP6: $("#DTL_ITEM_DESP6").text(),
        DTL_BUY_DATE7: $("#DTL_BUY_DATE7").text(),
        DTL_ITEM_NM7: $("#DTL_ITEM_NM7").text(),
        DTL_ITEM_AMT7: $("#DTL_ITEM_AMT7").text(),
        DTL_ITEM_TAX7: $("#DTL_ITEM_TAX7").text(),
        DTL_ITEM_DESP7: $("#DTL_ITEM_DESP7").text(),
        DTL_BUY_DATE8: $("#DTL_BUY_DATE8").text(),
        DTL_ITEM_NM8: $("#DTL_ITEM_NM8").text(),
        DTL_ITEM_AMT8: $("#DTL_ITEM_AMT8").text(),
        DTL_ITEM_TAX8: $("#DTL_ITEM_TAX8").text(),
        DTL_ITEM_DESP8: $("#DTL_ITEM_DESP8").text(),
        DTL_BUY_DATE9: $("#DTL_BUY_DATE9").text(),
        DTL_ITEM_NM9: $("#DTL_ITEM_NM9").text(),
        DTL_ITEM_AMT9: $("#DTL_ITEM_AMT9").text(),
        DTL_ITEM_TAX9: $("#DTL_ITEM_TAX9").text(),
        DTL_ITEM_DESP9: $("#DTL_ITEM_DESP9").text(),
        DTL_BUY_DATE10: $("#DTL_BUY_DATE10").text(),
        DTL_ITEM_NM10: $("#DTL_ITEM_NM10").text(),
        DTL_ITEM_AMT10: $("#DTL_ITEM_AMT10").text(),
        DTL_ITEM_TAX10: $("#DTL_ITEM_TAX10").text(),
        DTL_ITEM_DESP10: $("#DTL_ITEM_DESP10").text(),
        DTL_BUY_DATE11: $("#DTL_BUY_DATE11").text(),
        DTL_ITEM_NM11: $("#DTL_ITEM_NM11").text(),
        DTL_ITEM_AMT11: $("#DTL_ITEM_AMT11").text(),
        DTL_ITEM_TAX11: $("#DTL_ITEM_TAX11").text(),
        DTL_ITEM_DESP11: $("#DTL_ITEM_DESP11").text(),
        DTL_BUY_DATE12: $("#DTL_BUY_DATE12").text(),
        DTL_ITEM_NM12: $("#DTL_ITEM_NM12").text(),
        DTL_ITEM_AMT12: $("#DTL_ITEM_AMT12").text(),
        DTL_ITEM_TAX12: $("#DTL_ITEM_TAX12").text(),
        DTL_ITEM_DESP12: $("#DTL_ITEM_DESP12").text(),
        DTL_BUY_DATE13: $("#DTL_BUY_DATE13").text(),
        DTL_ITEM_NM13: $("#DTL_ITEM_NM13").text(),
        DTL_ITEM_AMT13: $("#DTL_ITEM_AMT13").text(),
        DTL_ITEM_TAX13: $("#DTL_ITEM_TAX13").text(),
        DTL_ITEM_DESP13: $("#DTL_ITEM_DESP13").text(),
        DTL_BUY_DATE14: $("#DTL_BUY_DATE14").text(),
        DTL_ITEM_NM14: $("#DTL_ITEM_NM14").text(),
        DTL_ITEM_AMT14: $("#DTL_ITEM_AMT14").text(),
        DTL_ITEM_TAX14: $("#DTL_ITEM_TAX14").text(),
        DTL_ITEM_DESP14: $("#DTL_ITEM_DESP14").text(),
        DTL_BUY_DATE15: $("#DTL_BUY_DATE15").text(),
        DTL_ITEM_NM15: $("#DTL_ITEM_NM15").text(),
        DTL_ITEM_AMT15: $("#DTL_ITEM_AMT15").text(),
        DTL_ITEM_TAX15: $("#DTL_ITEM_TAX15").text(),
        DTL_ITEM_DESP15: $("#DTL_ITEM_DESP15").text(),
        NOTE1: $("#NOTE1").text(),
        TOTAL_AMT: $("#TOTAL_AMT").text()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnModTaxBillSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("수정 발행 요청이 완료되었습니다.", "warning", "fnClosePopUpLayer()");
            return false;
        } else {
            fnModTaxBillFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnModTaxBillFailResult();
        return false;
    }
}

function fnModTaxBillFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("수정 발행 요청에 실패했습니다. 나중에 다시 시도해 주세요." + msg, "error");
    return false;
}