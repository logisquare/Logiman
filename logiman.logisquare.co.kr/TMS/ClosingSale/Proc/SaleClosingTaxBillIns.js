$(document).ready(function () {
    //품목연동/미연동 체크
    $("input[type='radio'][name='ItemDependFlag']").off("click").on("click", function () {
        fnSetItemDepend($(this).val());
        return;
    });

    //품목 공급가액
    $("#InvoiceDetail input.amt").on("keyup", function (event) {
        fnSetItemAmt(this);
    }).on("blur", function (event) {
        fnSetItemAmt(this);
    });

    //품목 부가세
    $("#InvoiceDetail input.tax").on("keyup", function (event) {
        fnSetItemTax(this);
    }).on("blur", function (event) {
        fnSetItemTax(this);
    });

    //작성일자
    $("#BUY_DATE").datepicker({
        dateFormat: "yy-mm-dd",
        maxDate: GetDateToday("-"),
        onSelect: function (dateText, inst) {
            for (i = 1; i <= 15; i++) {
                if($("#ITEM" + i).css("display") !== "none")
                {
                    $("#DTL_BUY_DATE" + i).val(dateText.substring(5, 10).replace("-", ""));
                }
            }
        }
    });
    $("#BUY_DATE").datepicker("setDate", GetDateToday("-"));

    //공급받는자 담당자
    if ($("#BUYR_CHRG_NM").length > 0) {
        fnSetAutocomplete({
            formId: "BUYR_CHRG_NM",
            width: 300,
            callbacks: {
                getUrl: () => {
                    return "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientChargeList",
                    ChargeName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    ClientCode: $("#ClientCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlert("필요한 정보가 없습니다.", "warning");
                        return false;
                    }

                    if (!$("#ClientCode").val()) {
                        fnDefaultAlert("필요한 정보가 없습니다.", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName,
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    $("#BUYR_CHRG_NM").val(ui.item.etc.ChargeName);
                    $("#BUYR_CHRG_MOBL").val(ui.item.etc.ChargeTelNo == "" ? ui.item.etc.ChargeCell : ui.item.etc.ChargeTelNo);
                    $("#BUYR_CHRG_EMAIL").val(ui.item.etc.ChargeEmail);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#BUYR_CHRG_NM").val()) {
                        $("#BUYR_CHRG_MOBL").val("");
                        $("#BUYR_CHRG_EMAIL").val("");
                    }
                }
            }
        });
    }

    fnSetInitData();
});

//기본정보 세팅
function fnSetInitData() {
    if ($("#HidErrMsg").val()) {
        fnDefaultAlert($("#HidErrMsg").val(), "warning", "fnClosePopUpLayer()");
        return false;
    }

    fnCallSaleClosing();
}

function fnCallSaleClosing() {

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
    var strCallBackFunc = "fnCallSaleClosingSuccResult";
    var strFailCallBackFunc = "fnCallSaleClosingFailResult";

    var objParam = {
        CallType: "SaleClosingList",
        SaleClosingSeqNo: $("#SaleClosingSeqNo").val(),
        CenterCode: $("#CenterCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnCallSaleClosingSuccResult(objRes) {

    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallSaleClosingFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSaleClosingFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnCallSaleClosingFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];

        if (item.BillStatus > 1) {
            fnDefaultAlert("이미 계산서 발행요청이 완료된 전표입니다.", "error", "fnClosePopUpLayer()");
            return false;
        }

        if (item.ClosingKind !== 1) {
            fnDefaultAlert("카드청구 신청이 완료된 전표입니다." + msg, "error", "fnClosePopUpLayer()");
            return false;
        }

        $("#SELR_CORP_NO").val(item.CorpNo);
        $("#SELR_CORP_NM").val(item.CenterName);
        $("#SELR_CEO").val(item.CeoName);
        $("#SELR_ADDR").val(item.Addr);
        $("#SELR_BUSS_CONS").val(item.BizType);
        $("#SELR_BUSS_TYPE").val(item.BizClass);
        $("#SELR_TEL").val(item.TelNo);
        $("#BUYR_CORP_NO").val(item.ClientCorpNo);
        $("#BUYR_CORP_NM").val(item.ClientName);
        $("#BUYR_CEO").val(item.ClientCeoName);
        $("#BUYR_ADDR").val(item.ClientAddr);
        $("#BUYR_BUSS_CONS").val(item.ClientBizType);
        $("#BUYR_BUSS_TYPE").val(item.ClientBizClass);
        $("#BUYR_TEL").val(item.ClientTelNo);
        $("#ITEM_AMT").val(item.SupplyAmt);
        $("#ITEM_TAX").val(item.TaxAmt);
        $("#TOTAL_AMT").val(item.OrgAmt);

        $("#ITEM_AMT").val(fnMoneyComma($("#ITEM_AMT").val()));
        $("#ITEM_TAX").val(fnMoneyComma($("#ITEM_TAX").val()));
        $("#TOTAL_AMT").val(fnMoneyComma($("#TOTAL_AMT").val()));
        
        $("#ClientCode").val(item.ClientCode);
        $("#ClientStatus").val(item.ClientStatus);
        $("#ClientCloseYMD").val(item.ClientCloseYMD);
        $("#IssuID").val(item.NtsConfirmNum);
        $("#MinBillWrite").val(item.MinBillWrite);

        $("#OrderCnt").val(item.OrderCnt);
        $("#OrgAmt").val(item.OrgAmt);
        $("#SupplyAmt").val(item.SupplyAmt);
        $("#TaxAmt").val(item.TaxAmt);
        var intTaxAmt = Math.trunc((parseFloat(item.SupplyAmt) / 1000 * 1000 * 0.1) / 10 * 10);
        $("#MinTaxAmt").val(intTaxAmt - item.OrderCnt * 9);
        $("#MaxTaxAmt").val(intTaxAmt + item.OrderCnt * 9);
        $("#SpanSupplyAmt").text(fnMoneyComma(item.SupplyAmt) + "원");
        $("#SpanTaxAmt").text(fnMoneyComma(item.TaxAmt) + "원");
        $("#SpanOrderCnt").text(fnMoneyComma(item.OrderCnt) + "건");
        $("#SpanTaxAmtInfo").text(fnMoneyComma($("#MinTaxAmt").val()) + "원 ~ " + fnMoneyComma($("#MaxTaxAmt").val()) + "원");

        fnCallSaleClosingDetail();
    }
    else {
        fnCallSaleClosingFailResult();
    }
}

function fnCallSaleClosingFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("매출 마감 정보를 불러오는데 실패했습니다." + msg, "error", "fnClosePopUpLayer()");
}

//계산서 상세
function fnCallSaleClosingDetail() {

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
    var strCallBackFunc = "fnCallSaleClosingDetailSuccResult";
    var strFailCallBackFunc = "fnCallSaleClosingDetailFailResult";

    var objParam = {
        CallType: "SaleClosingPayList",
        SaleClosingSeqNo: $("#SaleClosingSeqNo").val(),
        CenterCode: $("#CenterCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCallSaleClosingDetailSuccResult(objRes) {

    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallSaleClosingDetailFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSaleClosingDetailFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnCallSaleClosingDetailFailResult();
            return false;
        }
        
        $.each(objRes[0].data.list, function (index, item) {
            var num = index + 1;
            $("#DTL_BUY_DATE" + num).val($("#BUY_DATE").val().substring(5, 10).replace("-", ""));
            $("#DTL_ITEM_NM" + num).val(item.ItemCodeM);
            $("#DTL_ITEM_AMT" + num).val(fnMoneyComma(item.SupplyAmt));
            $("#DTL_ITEM_TAX" + num).val(fnMoneyComma(item.TaxAmt));
            $("#ITEM" + num).show();
        });
    }
    else {
        fnCallSaleClosingDetailFailResult();
    }
}

function fnCallSaleClosingDetailFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("매출 마감 정보를 불러오는데 실패했습니다." + msg, "error", "fnClosePopUpLayer()");
}

function fnInsTaxBill() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlert("필요한 정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#ClientCode").val()) {
        fnDefaultAlert("필요한 정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#SaleClosingSeqNo").val()) {
        fnDefaultAlert("필요한 정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#BUY_DATE").val()) {
        fnDefaultAlertFocus("작성일을 선택하세요.", "BUY_DATE", "warning");
        return false;
    }

    //휴폐업 상태 (1 - 미조회, 2 - 정상, 3 - 휴업, 4 - 폐업)
    if ($("#BUY_DATE").val() === "3" || $("#BUY_DATE").val() === "4") {
        if ($("#BUY_DATE").val().replace(/-/gi, "") > $("#ClientCloseYMD").val().replace(/-/gi, "")) {
            fnDefaultAlertFocus("공급받는자 사업자가 휴업 또는 폐업상태입니다. [" + fnGetStrDateFormat($("#ClientCloseYMD").val(), "-") + "] 이전으로 작성일을 변경하세요.", "BUY_DATE", "warning");
            return false;
        }
    }

    if ($("#BUY_DATE").val().replace(/-/gi, "") < $("#MinBillWrite").val().replace(/-/gi, "")) {
        fnDefaultAlertFocus("작성일을 [" + fnGetStrDateFormat($("#MinBillWrite").val(), "-") + "] 이후로 변경하세요.", "BUY_DATE", "warning");
        return false;
    }

    //품목 체크
    var intTotalSupplyAmt = 0;
    var intTotalTaxAmt = 0;
    for (var i = 1; i <= 15; i++) {
        if ($("#ITEM" + i).css("display") !== "none") {
            if (!$("#DTL_ITEM_NM" + i).val()) {
                fnDefaultAlertFocus("품목을 입력하세요.", "DTL_ITEM_NM" + i, "warning");
                return false;
            }

            if (!$("#DTL_ITEM_AMT" + i).val()) {
                fnDefaultAlertFocus("공급가액을 입력하세요.", "DTL_ITEM_AMT" + i, "warning");
                return false;
            }

            if (!$("#DTL_ITEM_TAX" + i).val()) {
                fnDefaultAlertFocus("세액을 입력하세요.", "DTL_ITEM_TAX" + i, "warning");
                return false;
            }

            var intSupplyAmt = parseInt(($("#DTL_ITEM_AMT" + i).val() == "" ? "0" : $("#DTL_ITEM_AMT" + i).val()).replace(/,/gi, ""));
            var intTaxAmt = parseInt(($("#DTL_ITEM_TAX" + i).val() == "" ? "0" : $("#DTL_ITEM_TAX" + i).val()).replace(/,/gi, ""));
            var intCalcTax = Math.trunc(parseFloat(intSupplyAmt) / 1000 * 1000 * 0.1);

            if (intTaxAmt < intCalcTax - 99 || intTaxAmt > intCalcTax + 99) {
                fnDefaultAlertFocus("발행 가능한 품목 부가세 범위를 벗어났습니다.<br>" + fnMoneyComma(intCalcTax - 99) + "원 ~ " + fnMoneyComma(intCalcTax + 99) + "원", "DTL_ITEM_TAX" + i, "warning");
                return false;
            }

            intTotalSupplyAmt += intSupplyAmt;
            intTotalTaxAmt += intTaxAmt;
        }
    }

    if (intTotalSupplyAmt != parseInt($("#SupplyAmt").val()) || $("#ITEM_AMT").val().replace(/,/gi, "") != $("#SupplyAmt").val()) {
        fnDefaultAlert("마감공급가액과 입력된 총공급가액이 일치하지 않습니다.", "error");
        return false;
    }

    if (intTotalTaxAmt != parseInt($("#TaxAmt").val()) || $("#ITEM_TAX").val().replace(/,/gi, "") != $("#TaxAmt").val()) {
        fnDefaultAlert("마감부가세와 입력된 총부가세가 일치하지 않습니다.", "error");
        return false;
    }

    var intMinTaxAmt = parseInt($("#MinTaxAmt").val());
    var intMaxTaxAmt = parseInt($("#MaxTaxAmt").val());
    if (intTotalTaxAmt < intMinTaxAmt || intTotalTaxAmt > intMaxTaxAmt) {
        fnDefaultAlert("발행 가능한 총 부가세 범위를 벗어났습니다.<br>" + fnMoneyComma(intMinTaxAmt) + "원 ~ " + fnMoneyComma(intMaxTaxAmt) + "원", "error");
        return false;
    }

    var strCallType = "SaleClosingTaxBillInsert";
    var strConfMsg = "계산서 발행 요청을 진행 하시겠습니까?";
    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsTaxBillProc", fnParam);
    return false;
}

function fnInsTaxBillProc(fnParam) {

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        SaleClosingSeqNo: $("#SaleClosingSeqNo").val(),
        SELR_CORP_NO: $("#SELR_CORP_NO").val(),
        SELR_CORP_NM: $("#SELR_CORP_NM").val(),
        SELR_CEO: $("#SELR_CEO").val(),
        SELR_ADDR: $("#SELR_ADDR").val(),
        SELR_TEL: $("#SELR_TEL").val(),
        SELR_BUSS_CONS: $("#SELR_BUSS_CONS").val(),
        SELR_BUSS_TYPE: $("#SELR_BUSS_TYPE").val(),
        SELR_CHRG_NM: $("#SELR_CHRG_NM").val(),
        SELR_CHRG_EMAIL: $("#SELR_CHRG_EMAIL").val(),
        SELR_CHRG_MOBL: $("#SELR_CHRG_MOBL").val(),
        BUYR_CORP_NO: $("#BUYR_CORP_NO").val(),
        BUYR_CORP_NM: $("#BUYR_CORP_NM").val(),
        BUYR_CEO: $("#BUYR_CEO").val(),
        BUYR_ADDR: $("#BUYR_ADDR").val(),
        BUYR_TEL: $("#BUYR_TEL").val(),
        BUYR_BUSS_CONS: $("#BUYR_BUSS_CONS").val(),
        BUYR_BUSS_TYPE: $("#BUYR_BUSS_TYPE").val(),
        BUYR_CHRG_NM: $("#BUYR_CHRG_NM").val(),
        BUYR_CHRG_EMAIL: $("#BUYR_CHRG_EMAIL").val(),
        BUYR_CHRG_MOBL: $("#BUYR_CHRG_MOBL").val(),
        BUY_DATE: $("#BUY_DATE").val(),
        ITEM_AMT: $("#ITEM_AMT").val(),
        ITEM_TAX: $("#ITEM_TAX").val(),
        DTL_BUY_DATE1: $("#DTL_BUY_DATE1").val(),
        DTL_ITEM_NM1: $("#DTL_ITEM_NM1").val(),
        DTL_ITEM_AMT1: $("#DTL_ITEM_AMT1").val(),
        DTL_ITEM_TAX1: $("#DTL_ITEM_TAX1").val(),
        DTL_ITEM_DESP1: $("#DTL_ITEM_DESP1").val(),
        DTL_BUY_DATE2: $("#DTL_BUY_DATE2").val(),
        DTL_ITEM_NM2: $("#DTL_ITEM_NM2").val(),
        DTL_ITEM_AMT2: $("#DTL_ITEM_AMT2").val(),
        DTL_ITEM_TAX2: $("#DTL_ITEM_TAX2").val(),
        DTL_ITEM_DESP2: $("#DTL_ITEM_DESP2").val(),
        DTL_BUY_DATE3: $("#DTL_BUY_DATE3").val(),
        DTL_ITEM_NM3: $("#DTL_ITEM_NM3").val(),
        DTL_ITEM_AMT3: $("#DTL_ITEM_AMT3").val(),
        DTL_ITEM_TAX3: $("#DTL_ITEM_TAX3").val(),
        DTL_ITEM_DESP3: $("#DTL_ITEM_DESP3").val(),
        DTL_BUY_DATE4: $("#DTL_BUY_DATE4").val(),
        DTL_ITEM_NM4: $("#DTL_ITEM_NM4").val(),
        DTL_ITEM_AMT4: $("#DTL_ITEM_AMT4").val(),
        DTL_ITEM_TAX4: $("#DTL_ITEM_TAX4").val(),
        DTL_ITEM_DESP4: $("#DTL_ITEM_DESP4").val(),
        DTL_BUY_DATE5: $("#DTL_BUY_DATE5").val(),
        DTL_ITEM_NM5: $("#DTL_ITEM_NM5").val(),
        DTL_ITEM_AMT5: $("#DTL_ITEM_AMT5").val(),
        DTL_ITEM_TAX5: $("#DTL_ITEM_TAX5").val(),
        DTL_ITEM_DESP5: $("#DTL_ITEM_DESP5").val(),
        DTL_BUY_DATE6: $("#DTL_BUY_DATE6").val(),
        DTL_ITEM_NM6: $("#DTL_ITEM_NM6").val(),
        DTL_ITEM_AMT6: $("#DTL_ITEM_AMT6").val(),
        DTL_ITEM_TAX6: $("#DTL_ITEM_TAX6").val(),
        DTL_ITEM_DESP6: $("#DTL_ITEM_DESP6").val(),
        DTL_BUY_DATE7: $("#DTL_BUY_DATE7").val(),
        DTL_ITEM_NM7: $("#DTL_ITEM_NM7").val(),
        DTL_ITEM_AMT7: $("#DTL_ITEM_AMT7").val(),
        DTL_ITEM_TAX7: $("#DTL_ITEM_TAX7").val(),
        DTL_ITEM_DESP7: $("#DTL_ITEM_DESP7").val(),
        DTL_BUY_DATE8: $("#DTL_BUY_DATE8").val(),
        DTL_ITEM_NM8: $("#DTL_ITEM_NM8").val(),
        DTL_ITEM_AMT8: $("#DTL_ITEM_AMT8").val(),
        DTL_ITEM_TAX8: $("#DTL_ITEM_TAX8").val(),
        DTL_ITEM_DESP8: $("#DTL_ITEM_DESP8").val(),
        DTL_BUY_DATE9: $("#DTL_BUY_DATE9").val(),
        DTL_ITEM_NM9: $("#DTL_ITEM_NM9").val(),
        DTL_ITEM_AMT9: $("#DTL_ITEM_AMT9").val(),
        DTL_ITEM_TAX9: $("#DTL_ITEM_TAX9").val(),
        DTL_ITEM_DESP9: $("#DTL_ITEM_DESP9").val(),
        DTL_BUY_DATE10: $("#DTL_BUY_DATE10").val(),
        DTL_ITEM_NM10: $("#DTL_ITEM_NM10").val(),
        DTL_ITEM_AMT10: $("#DTL_ITEM_AMT10").val(),
        DTL_ITEM_TAX10: $("#DTL_ITEM_TAX10").val(),
        DTL_ITEM_DESP10: $("#DTL_ITEM_DESP10").val(),
        DTL_BUY_DATE11: $("#DTL_BUY_DATE11").val(),
        DTL_ITEM_NM11: $("#DTL_ITEM_NM11").val(),
        DTL_ITEM_AMT11: $("#DTL_ITEM_AMT11").val(),
        DTL_ITEM_TAX11: $("#DTL_ITEM_TAX11").val(),
        DTL_ITEM_DESP11: $("#DTL_ITEM_DESP11").val(),
        DTL_BUY_DATE12: $("#DTL_BUY_DATE12").val(),
        DTL_ITEM_NM12: $("#DTL_ITEM_NM12").val(),
        DTL_ITEM_AMT12: $("#DTL_ITEM_AMT12").val(),
        DTL_ITEM_TAX12: $("#DTL_ITEM_TAX12").val(),
        DTL_ITEM_DESP12: $("#DTL_ITEM_DESP12").val(),
        DTL_BUY_DATE13: $("#DTL_BUY_DATE13").val(),
        DTL_ITEM_NM13: $("#DTL_ITEM_NM13").val(),
        DTL_ITEM_AMT13: $("#DTL_ITEM_AMT13").val(),
        DTL_ITEM_TAX13: $("#DTL_ITEM_TAX13").val(),
        DTL_ITEM_DESP13: $("#DTL_ITEM_DESP13").val(),
        DTL_BUY_DATE14: $("#DTL_BUY_DATE14").val(),
        DTL_ITEM_NM14: $("#DTL_ITEM_NM14").val(),
        DTL_ITEM_AMT14: $("#DTL_ITEM_AMT14").val(),
        DTL_ITEM_TAX14: $("#DTL_ITEM_TAX14").val(),
        DTL_ITEM_DESP14: $("#DTL_ITEM_DESP14").val(),
        DTL_BUY_DATE15: $("#DTL_BUY_DATE15").val(),
        DTL_ITEM_NM15: $("#DTL_ITEM_NM15").val(),
        DTL_ITEM_AMT15: $("#DTL_ITEM_AMT15").val(),
        DTL_ITEM_TAX15: $("#DTL_ITEM_TAX15").val(),
        DTL_ITEM_DESP15: $("#DTL_ITEM_DESP15").val(),
        NOTE1: $("#NOTE1").val(),
        POPS_CODE: $("#POPS_CODE1").is(":checked") ? "01" : "02",
        TOTAL_AMT: $("#TOTAL_AMT").val()
    };

    var strHandlerURL = "/TMS/ClosingSale/Proc/SaleClosingTaxBillHandler.ashx";
    var strCallBackFunc = "fnInsTaxBillSuccResult";
    var strFailCallBackFunc = "fnInsTaxBillFailResult";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnInsTaxBillSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnInsTaxBillFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        $("#IssuSeqNo").val(objRes[0].IssuSeqNo);
        fnDefaultAlert("계산서 발행 요청이 완료되었습니다.", "info", "fnTaxBillReload()");
        return false;
    } else {
        fnInsTaxBillFailResult();
        return false;
    }
}

function fnInsTaxBillFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("계산서 발행에 실패했습니다. 나중에 다시 시도해 주세요." + msg, "error");
    return false;
}

function fnTaxBillReload() {
    document.location.replace("/TMS/ClosingSale/SaleClosingTaxBillView?IssuSeqNo=" + $("#IssuSeqNo").val() + "&CenterCode=" + $("#CenterCode").val());
}

//품목연동, 미연동 체크
function fnSetItemDepend(strFlag) {
    if (strFlag === "N") { //미연동
        $("#InvoiceDetail a").show();
        $("#InvoiceDetail input.desp").css("width", "calc(100% - 27px)");
        $("#InvoiceDetail input.nm").removeAttr("readonly");
        $("#InvoiceDetail input.amt").removeAttr("readonly");
        $("#InvoiceDetail input.tax").removeAttr("readonly");

        for (var i = 2; i <= 15; i++) {
            if ($("#ITEM" + i).css("display") != "none") {
                fnItemReset(i);
                $("#ITEM" + i).hide();
            }
        }

        $("#DTL_ITEM_NM1").val("");
        $("#DTL_ITEM_AMT1").val(fnMoneyComma($("#SupplyAmt").val()));
        $("#DTL_ITEM_TAX1").val(fnMoneyComma($("#TaxAmt").val()));
        $("#DTL_ITEM_DESP1").val("");
        fnSetItemCalc();
    } else { //연동
        document.location.reload();
    }
    return false;
}

//품목 공급가액 처리
function fnSetItemAmt(objItem) {
    if ($("#ItemDependFlag2").is(":checked")) {
        var strObjID = $(objItem).attr("id");
        var strNo = strObjID.replace("DTL_ITEM_AMT", "");

        //콤마 추가
        $("#" + strObjID).val(fnMoneyComma($("#" + strObjID).val()));

        //부가세 자동 계산
        fnCalcTax($("#" + strObjID).val(), "DTL_ITEM_TAX" + strNo, "TaxKind");

        //총 공급가액, 부가세 업데이트
        fnSetItemCalc();
    }
    return false;
}

//품목 부가세 처리
function fnSetItemTax(objItem) {
    var strObjID = $(objItem).attr("id");

    //콤마 추가
    $("#" + strObjID).val(fnMoneyComma($("#" + strObjID).val()));

    //총 공급가액, 부가세 업데이트
    fnSetItemCalc();
    return false;
}

//품목 총 합계 적용
function fnSetItemCalc() {
    var intSupplyAmt = 0;
    var intTaxAmt = 0;

    $("#InvoiceDetail input.amt").removeClass("notAvail");
    $("#InvoiceDetail input.tax").removeClass("notAvail");
    $("#ITEM_AMT").removeClass("notAvail");
    $("#ITEM_TAX").removeClass("notAvail");

    for (var i = 1; i <= 15; i++) {
        if ($("#ITEM" + i).css("display") != "none") {
            var intItemAmt = parseInt($("#DTL_ITEM_AMT" + i).val() == "" ? "0" : $("#DTL_ITEM_AMT" + i).val().replace(/,/gi, ""));
            var intItemTax = parseInt($("#DTL_ITEM_TAX" + i).val() == "" ? "0" : $("#DTL_ITEM_TAX" + i).val().replace(/,/gi, ""));
            var intItemCalcTax = Math.trunc(parseFloat(intItemAmt) / 10);
            intSupplyAmt += intItemAmt;
            intTaxAmt += intItemTax;

            if (intItemCalcTax - 99 > intItemTax || intItemCalcTax + 99 < intItemTax) {
                $("#DTL_ITEM_TAX" + i).addClass("notAvail");
            }
        }
    }

    $("#TOTAL_AMT").val(fnMoneyComma(intSupplyAmt + intTaxAmt));
    $("#ITEM_AMT").val(fnMoneyComma(intSupplyAmt));
    $("#ITEM_TAX").val(fnMoneyComma(intTaxAmt));

    //notAvail
    if (intSupplyAmt.toString() != $("#SupplyAmt").val()) {
        $("#ITEM_AMT").addClass("notAvail");
    }

    if (intTaxAmt.toString() != $("#TaxAmt").val() || intTaxAmt > parseInt($("#MaxTaxAmt").val()) || intTaxAmt < parseInt($("#MinTaxAmt").val())) {
        $("#ITEM_TAX").addClass("notAvail");
    }
}

//품목 추가
function fnItemAdd() {
    if ($("#ITEM15").css("display") !== "none") {
        fnDefaultAlert("품목은 15건을 초과할 수 없습니다.", "error");
        return false;
    }

    var intTotalSupplyAmt = parseInt($("#SupplyAmt").val());
    var intTotalTaxAmt = parseInt($("#TaxAmt").val());
    
    for (var i = 1; i <= 15; i++) {
        if ($("#ITEM" + i).css("display") == "none") {
            $("#DTL_BUY_DATE" + i).val($("#DTL_BUY_DATE1").val());

            if (intTotalSupplyAmt > 0) {
                $("#DTL_ITEM_AMT" + i).val(fnMoneyComma(intTotalSupplyAmt));
            }

            if (intTotalTaxAmt > 0) {
                $("#DTL_ITEM_TAX" + i).val(fnMoneyComma(intTotalTaxAmt));
            }

            $("#ITEM" + i).show();

            fnSetItemCalc();
            break;
        }

        intTotalSupplyAmt -= parseInt(($("#DTL_ITEM_AMT" + i).val() == "" ? "0" : $("#DTL_ITEM_AMT" + i).val()).replace(/,/gi, ""));
        intTotalTaxAmt -= parseInt(($("#DTL_ITEM_TAX" + i).val() == "" ? "0" : $("#DTL_ITEM_TAX" + i).val()).replace(/,/gi, ""));
    }
}

//품목 삭제
function fnItemDel(intItemNo) {
    var intCnt = 0;
    for (var i = 1; i <= 15; i++) {
        if (i !== intItemNo && $("#ITEM" + i).css("display") !== "none") {
            intCnt++;
        }
    }

    if (intCnt === 0) {
        fnDefaultAlert("품목은 1건 이상 등록해야합니다.", "error");
        return false;
    }

    //var intTargetItemNo = intItemNo - 1 == 0 ? 1 : (intItemNo - 1);
    //var intItemSupplyAmt = parseInt($("#DTL_ITEM_AMT" + intItemNo).val().replace(/,/gi, ""));
    //var intItemTaxAmt = parseInt($("#DTL_ITEM_TAX" + intItemNo).val().replace(/,/gi, ""));
    //intItemSupplyAmt = isNaN(intItemSupplyAmt) ? 0 : intItemSupplyAmt;
    //intItemTaxAmt = isNaN(intItemTaxAmt) ? 0 : intItemTaxAmt;

    for (var i = intItemNo; i <= 14; i++) {
        if ($("#ITEM" + (i + 1)).css("display") !== "none") {
            $("#DTL_ITEM_NM" + i).val($("#DTL_ITEM_NM" + (i + 1)).val());
            $("#DTL_ITEM_DESP" + i).val($("#DTL_ITEM_DESP" + (i + 1)).val());
            $("#DTL_ITEM_AMT" + i).val($("#DTL_ITEM_AMT" + (i + 1)).val());
            $("#DTL_ITEM_TAX" + i).val($("#DTL_ITEM_TAX" + (i + 1)).val());
        }
    }

    //var intSupplyAmt = parseInt($("#DTL_ITEM_AMT" + intTargetItemNo).val().replace(/,/gi, ""));
    //var intTaxAmt = parseInt($("#DTL_ITEM_TAX" + intTargetItemNo).val().replace(/,/gi, ""));
    //intSupplyAmt = isNaN(intSupplyAmt) ? 0 : intSupplyAmt;
    //intTaxAmt = isNaN(intTaxAmt) ? 0 : intTaxAmt;
    //$("#DTL_ITEM_AMT" + intTargetItemNo).val(fnMoneyComma(intSupplyAmt + intItemSupplyAmt));
    //$("#DTL_ITEM_TAX" + intTargetItemNo).val(fnMoneyComma(intTaxAmt + intItemTaxAmt));

    for (var i = 15; i >= intItemNo; i--) {
        if ($("#ITEM" + i).css("display") !== "none") {
            fnItemReset(i);
            $("#ITEM" + i).hide();
            break;
        }
    }

    //총 공급가액, 부가세 업데이트
    fnSetItemCalc();
}

function fnItemReset(intItemNo) {
    $("#DTL_BUY_DATE" + intItemNo).val("");
    $("#DTL_ITEM_NM" + intItemNo).val("");
    $("#DTL_ITEM_AMT" + intItemNo).val("");
    $("#DTL_ITEM_TAX" + intItemNo).val("");
    $("#DTL_ITEM_DESP" + intItemNo).val("");
}