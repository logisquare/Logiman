/*리스트 파라미터*/
var strListDataParam = "";
$(document).ready(function () {
    /*리스트 파라미터*/
    var strListData = $("#HidParam").val();
    strListDataParam = strListData.replace(/:/g, "=").replace(/,/g, "&").replace(/{/g, "").replace(/}/g, "");

    $(".data_detail h2").on("click", function () {
        $(this).parent("div").children("table").toggle();
    });

    $("#PopMastertitle").text("내수 오더상세");
    
    if ($("#HidErrMsg").val()) {
        fnDefaultAlert($("#HidErrMsg").val(), "warning", "$(\"#BtnGoBack\").click()");
        return false;
    }

    //오더수정
    $("#BtnGoUpdOrder").on("click", function (e) {
        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 수정하실 수 없습니다.");
            return false;
        }

        document.location.replace("/APP/TMS/Domestic/DomesticIns?OrderNo=" + $("#HidOrderNo").val());
        return false;
    });

    //오더복사
    $("#BtnCopyOrder").on("click", function (e) {

        if (!$("#PickupPlaceFullAddr").val()) {
            fnDefaultAlert("상차지 적용주소 정보가 없습니다.<br/>오더 수정 후 복사하실 수 있습니다.");
            return false;
        }

        if (!$("#GetPlaceFullAddr").val()) {
            fnDefaultAlert("하차지 적용주소 정보가 없습니다.<br/>오더 수정 후 복사하실 수 있습니다.");
            return false;
        }

        document.location.replace("/APP/TMS/Domestic/DomesticIns?OrderNo=" + $("#HidOrderNo").val() + "&CopyFlag=Y");
        return false;
    });

    //오더취소
    $("#BtnCancelOrder").on("click", function (e) {
        if (!$("#HidOrderNo").val()) {
            return false;
        }

        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 취소하실 수 없습니다.");
            return false;
        }

        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 취소하실 수 없습니다.");
            return false;
        }

        fnCnlOrder();
        return false;
    });

    //차량검색 버튼
    $("#BtnSearchDispatchCar").on("click", function (e) {
        e.preventDefault();
        fnGetDispatchCar();
        return false;
    });

    $("#SearchCarNo").on("keyup", function (e) {
        if (e.keyCode === 13) {
            fnGetDispatchCar();
        }
        return false;
    });

    //자동운임 수정요청
    $("#BtnUpdRequestAmt").on("click", function () {
        fnUpdRequestAmt();
        return false;
    });

    $("#RateSaleSupplyAmt1").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            fnCalcTax($(this).val(), "RateSaleTaxAmt1", "RateSaleTaxKind1");
        });

    $("#RateSaleTaxAmt1").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
        });

    $("#RatePurchaseSupplyAmt1").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            fnCalcTax($(this).val(), "RatePurchaseTaxAmt1", "RatePurchaseTaxKind1");
        });

    $("#RatePurchaseTaxAmt1").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
        });

    $("#RateSaleSupplyAmt2").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            fnCalcTax($(this).val(), "RateSaleTaxAmt2", "RateSaleTaxKind2");
        });

    $("#RateSaleTaxAmt2").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
        });

    $("#RatePurchaseSupplyAmt2").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            fnCalcTax($(this).val(), "RatePurchaseTaxAmt2", "RatePurchaseTaxKind2");
        });

    $("#RatePurchaseTaxAmt2").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
        });

    $("#RateSaleSupplyAmt3").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            fnCalcTax($(this).val(), "RateSaleTaxAmt3", "RateSaleTaxKind3");
        });

    $("#RateSaleTaxAmt3").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
        });

    $("#RatePurchaseSupplyAmt3").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            fnCalcTax($(this).val(), "RatePurchaseTaxAmt3", "RatePurchaseTaxKind3");
        });

    $("#RatePurchaseTaxAmt3").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
        });

    fnSetInitData();
});

function fnSetInitData() {
    $("#GoodsDispatchType option:first-child").prop("disabled", true);

    fnCallOrderDetail();
}

//오더 데이터 세팅
function fnCallOrderDetail() {

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnOrderDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "DomesticList",
        OrderNo: $("#HidOrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnOrderDetailSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning", "$(\"#BtnGoBack\").click()");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnCallDetailFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];
        //Hidden
        $("#HidCenterCode").val(item.CenterCode);
        $.each($("input[type='hidden']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    $("#Hid" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //Select
        $("#GoodsDispatchType").val(item.GoodsDispatchType);

        //Span
        $.each($("span"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).text(eval("item." + $(input).attr("id")));
                    if ($(input).attr("id").indexOf("YMD") > -1) {
                        $("#" + $(input).attr("id")).text(fnGetStrDateFormat($("#" + $(input).attr("id")).text(), "-"));
                    }

                    if ($(input).attr("id").indexOf("HM") > -1) {
                        $("#" + $(input).attr("id")).text(fnGetHMFormat($("#" + $(input).attr("id")).text()));
                    }

                    if ($(input).attr("id").indexOf("TelNo") > -1 || $(input).attr("id").indexOf("Cell") > -1) {
                        $("#" + $(input).attr("id")).text(fnMakeCellNo($("#" + $(input).attr("id")).text()));
                    }
                }
            });

        $("#Weight").text(fnMoneyComma($("#Weight").text()));
        $("#Volume").text(fnMoneyComma($("#Volume").text()));
        $("#Length").text(fnMoneyComma($("#Length").text()));
        
        $("#DivTrans").hide();
        $("#DivTransPay").hide();
        $("#DivContract").hide();

        if (item.GoodsDispatchType === 2) {
            if (item.TransType === 2 || item.TransType === 3) {
                $("#DivTrans").show();
                $("#GoodsDispatchType option:not(:selected)").prop("disabled", true);

                if (item.TransType === 2) {
                    $("#DivTransPay").show();
                    //이관 매출 조회
                    fnCallTransPayData();
                }
            }

            if (item.ContractType === 2) {
                if (item.ContractStatus === 2) {
                    $("#GoodsDispatchType option:not(:selected)").prop("disabled", true);
                } else {
                    $("#ContractInfo").text("위탁취소 : " + item.ContractInfo);
                }
                $("#DivContract").show();
            } else if (item.ContractType === 3) {
                $("#GoodsDispatchType option:not(:selected)").prop("disabled", true);
                $("#DivContract").show();
            }

            $("#ContractInfo").html($("#ContractInfo").text().indexOf("▶") > 0 ? $("#ContractInfo").text().replace("▶", "<br />▶") : $("#ContractInfo").text());

        } else {
            $("#DispatchSeqNo").val("");
            $("#RefSeqNo").val("");
            $("#BtnDispatchOrder").hide();
        }

        if ($("#CnlFlag").val() === "Y") {
            $("#BtnCancelOrder").hide();
            $("#BtnDispatchOrder").hide();
            $("#BtnGoUpdOrder").hide();
        }

        if ($("#GoodsDispatchType").val() !== "2") {
            $("#BtnDispatchOrder").hide();
        }

        $("#DivUnitAmt").hide();
        $(".TrUpdRequestAmt").hide();

        var strTransRateInfo = item.TransRateInfo;
        strTransRateInfo = typeof strTransRateInfo === "undefined" ? "" : strTransRateInfo;
        
        if (strTransRateInfo.indexOf("Y") === 0) {
            //요율표 조회
            fnCallTransRateData();
        }

        //배차 목록 조회
        fnCallDispatchData();

        //비용 목록 조회
        fnCallPayData();
    }
    else {
        fnCallDetailFailResult();
    }
}

function fnCallDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "$(\"#BtnGoBack\").click()");
}


// 배차 목록
function fnCallDispatchData() {
    if (!$("#HidOrderNo").val() || !$("#HidCenterCode").val() || !$("#GoodsSeqNo").val()) {
        return false;
    }

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallDispatchSuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "DomesticDispatchCarList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        GoodsSeqNo: $("#GoodsSeqNo").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strCallBackFailFunc, "", false);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDispatchSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallDetailFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt > 0) {
            var html = "";
            if ($("#GoodsDispatchType").val() === "2") {
                var item = objRes[0].data.list[0];
                html += "<tr class=\"center\">\n";
                html += "\t<td>" + item.DispatchTypeM + "</td>\n";
                html += "\t<td class=\"left\">" + item.DispatchCarInfo + "</td>\n";
                html += "</tr>\n";
            } else if ($("#GoodsDispatchType").val() === "3") {
                if (objRes[0].data.RecordCnt > 0) {
                    $.each(objRes[0].data.list, function (index, item) {
                        html += "<tr class=\"center\">\n";
                        html += "\t<td>" + item.DispatchTypeM + "</td>\n";
                        html += "\t<td class=\"left\">" + item.DispatchCarInfo + "</td>\n";
                        html += "</tr>\n";
                    });
                }
            }
            $("#TbodyDispatchInfo").html(html);
        }
    } else {
        fnCallDetailFailResult();
    }
}


//비용 목록 조회
function fnCallPayData() {

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnPaySuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "DomesticPayList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strCallBackFailFunc, "", false);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnPaySuccResult(objRes) {

    if (objRes) {
        if (objRes[0].result.RetCode) {
            if (objRes[0].result.RetCode !== 0) {
                fnCallDetailFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt > 0) {
            var html = "";

            $.each(objRes[0].data.list, function (index, item) {
                var info = item.DispatchInfo;
                if ($.isNumeric(item.ClientCode)) {
                    if (parseInt(item.ClientCode) !== 0) {
                        info = item.ClientInfo;
                    }
                }
                var strClass = "";
                if (item.PayTypeM === "매출") {
                    strClass = "red";
                } else if (item.PayTypeM === "매입") {
                    strClass = "blue";
                }

                html += "<tr class=\"center\">\n";
                html += "\t<td><span class=\"" + strClass + "\">"+ item.PayTypeM + "</span><br/>" + item.TaxKindM + "</td>\n";
                html += "\t<td>" + item.ItemCodeM + "</td>\n";
                html += "\t<td class=\"right\">" + fnMoneyComma(item.SupplyAmt) + "<br/>" + fnMoneyComma(item.TaxAmt) + "</td>\n";
                html += "\t<td class=\"left\">" + info + "</td>\n";
                html += "</tr>\n";
            });
            $("#TbodyPayInfo").html(html);
        }
    }
}

//이관 매출 조회
function fnCallTransPayData() {
    $("#TbodyTransPayInfo").html("");

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallTransPayDataSuccResult";

    var objParam = {
        CallType: "DomesticTransPayList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnCallTransPayDataSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallDetailFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt > 0) {
            var html = "";

            $.each(objRes[0].data.list, function (index, item) {
                var info = item.DispatchInfo;
                if ($.isNumeric(item.ClientCode)) {
                    if (parseInt(item.ClientCode) !== 0) {
                        info = item.ClientInfo;
                    }
                }
                var strClass = "";
                if (item.PayTypeM === "매출") {
                    strClass = "red";
                } else if (item.PayTypeM === "매입") {
                    strClass = "blue";
                }

                html += "<tr class=\"center\">\n";
                html += "\t<td><span class=\"" + strClass + "\">" + item.PayTypeM + "</span><br/>" + item.TaxKindM + "</td>\n";
                html += "\t<td>" + item.ItemCodeM + "</td>\n";
                html += "\t<td class=\"right\">" + fnMoneyComma(item.SupplyAmt) + "<br/>" + fnMoneyComma(item.TaxAmt) + "</td>\n";
                html += "\t<td class=\"left\">" + info + "</td>\n";
                html += "</tr>\n";
            });
            $("#TbodyTransPayInfo").html(html);
        }
    }
}

/**************************************************************/
//오더취소
/**************************************************************/
//오더취소
function fnCnlOrder() {
    if (!$("#HidOrderNo").val()) {
        fnDefaultAlert("취소할 오더 정보가 없습니다.", "info");
        return false;
    }

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return false;
    }

    $("#OrderCancelLayer").show();
    $("#CnlReason").focus();
}

//오더 취소처리
function fnCnlOrderProc() {
    if (!$("#HidOrderNo").val()) {
        fnDefaultAlert("취소할 오더 정보가 없습니다.", "info");
        return false;
    }

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "info");
        return false;
    }

    if (!$("#CnlReason").val()) {
        fnDefaultAlertFocus("오더 취소 사유를 입력하세요.", "CnlReason", "warning");
        return false;
    }

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCnlOrderSuccResult";
    var strFailCallBackFunc = "fnCnlOrderFailResult";
    var objParam = {
        CallType: "DomesticOneCancel",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        CnlReason: $("#CnlReason").val(),
        ChgSeqNo: $("#ChgSeqNo").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnCnlOrderSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("오더가 취소되었습니다.", "info", "fnOrderReload()");
            return false;
        } else {
            fnCnlOrderFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnCnlOrderFailResult();
        return false;
    }
}

function fnCnlOrderFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    fnDefaultAlert("오더 취소에 실패했습니다." + (msg == "" ? "" : ("<br>(" + msg + ")")), "warning");
    return false;
}

//오더취소 닫기
function fnCloseCnlOrder() {
    $("#CnlReason").val("");
    $("#OrderCancelLayer").hide();
}

function fnOrderReload() {
    document.location.replace("/APP/TMS/Domestic/DomesticDetail?OrderNo=" + $("#HidOrderNo").val());
}

/**************************************/
//차량검색
/**************************************/

//차량 검색 열기
function fnOpenDispatchCar() {
    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        return false;
    }

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return false;
    }

    if ($("#TransType").val() === "3") {
        fnDefaultAlert("이관받은 오더는 수정하실 수 없습니다.");
        return false;
    }

    if ($("#ContractType").val() === "2" && $("#ContractStatus").val() === "2") {
        fnDefaultAlert("위탁한 오더는 차량배차가 불가능합니다.", "warning");
        return false;
    }

    if ($("#GoodsDispatchType").val() !== "2") {
        fnDefaultAlert("직송 배차 오더만 배차가 가능합니다.", "warning");
        return false;
    }

    $("#DispatchLayer").show();
    $("#SearchCarNo").focus();
}

//차량 검색
function fnGetDispatchCar() {
    var strSearchText = $("#SearchCarNo").val();
    if (strSearchText.trim().length < 4) {
        fnDefaultAlert("검색어를 4자이상 입력하세요.", "warning", "$(\"#SearchCarNo\").focus();");
        return false;
    }

    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnGetDispatchCarSuccResult";
    var strFailCallBackFunc = "fnGetDispatchCarFailResult";

    var objParam = {
        CallType: "CarDispatchRefList",
        CenterCode: $("#HidCenterCode").val(),
        CarNo: $("#SearchCarNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnGetDispatchCarSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnGetDispatchCarFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnDefaultAlert("검색된 차량이 없습니다.", "error");
            return false;
        }

        var html = "";
        $.each(objRes[0].data.list, function (index, item) {
            html += "<li>\n";
            html += "\t<input type=\"radio\" id=\"DispatchChk" + index + "\" name=\"DispatchChk\" />\n";
            html += "\t<label for=\"DispatchChk" + index + "\">\n";
            html += "\t\t<strong>" + item.CarNo + " <span class=\"car_type\">" + item.CarDivTypeM + "</span></strong>\n";
            html += "\t\t<span class=\"d_text\">" + item.DriverName + " | " + item.DriverCell + "</span>\n";
            html += "\t\t<span class=\"d_text\">" + item.ComName + " | " + item.ComCeoName + "</span>\n";
            html += "\t\t<span class=\"d_text\">" + item.ComCorpNo + " | " + item.ComTaxKindM + " | " + item.ComStatusM + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"RefSeqNo\">" + item.RefSeqNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"DispatchInfo\">" + item.DispatchInfo + "</span>\n";
            html += "\t\t<span class=\"check_icon\"></span>";
            html += "\t</label>";
            html += "</li>";
        });

        $("#DispatchLayer .dispatch_list").html(html);
    }
}

function fnGetDispatchCarFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error");
    return false;
}

//차량 배차
function fnSetDispatchCar() {
    if ($("input:radio[name='DispatchChk']:checked").length === 0) {
        fnDefaultAlert("등록할 배차 차량을 선택하세요.", "error");
        return false;
    }

    if (!$("#InsureExceptKind").val()) {
        fnDefaultAlert("산재보험 신고 구분을 선택하세요.", "error");
        return false;
    }

    var strCallType = "DomesticDispatchCarUpdate";
    var strConfMsg = "배차를 등록하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnSetDispatchCarProc", fnParam);
    return false;
}

function fnSetDispatchCarProc(fnParam) {
    var objSelectedItem = $("input:radio[name='DispatchChk']:checked")[0];
    var objDataList = $("label[for='" + $(objSelectedItem).attr("id") + "'] span.data");
    var objItem = new Object();

    $.each($(objDataList), function (index, item) {
        eval("objItem." + $(item).attr("data-field") + " = \"" + $(item).text() + "\"");
    });

    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnSetDispatchCarProcSuccResult";
    var strFailCallBackFunc = "fnSetDispatchCarProcFailResult";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        RefSeqNo: objItem.RefSeqNo,
        InsureExceptKind: $("#InsureExceptKind").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnSetDispatchCarProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("배차가 등록되었습니다.", "info", "fnOrderReload()");
            return false;
        } else {
            fnSetDispatchCarProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetDispatchCarProcFailResult();
        return false;
    }
}

function fnSetDispatchCarProcFailResult(strMsg) {
    if (typeof strMsg !== "string") {
        strMsg = "";
    }
    fnDefaultAlert("배차 등록에 실패했습니다." + (strMsg == "" ? "" : ("<br>(" + strMsg + ")")), "warning");
    return false;
}

//차량 검색 닫기
function fnCloseDispatchCar() {
    $("#SearchCarNo").val("");
    $("#DispatchLayer .dispatch_list").html("");
    $("#DispatchLayer").hide();
    return false;
}
/**************************************/
/*리스트 돌아가기*/
function fnListBack() {
    document.location.href = "/APP/TMS/Domestic/DomesticList?" + strListDataParam;
}

/******************************************/
// 자동운임
/******************************************/
//오더 자동운임 조회
function fnCallTransRateData() {
    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        return false;
    }

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallTransRateDataSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "TransRateOrderList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        CarFixedFlag: $("#CarFixedFlag").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallTransRateDataSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallTransRateFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallTransRateFailResult();
            return false;
        }

        $("#ApplySeqNo").val("");

        $("#SaleUnitAmt").val("");
        $("#FixedPurchaseUnitAmt").val("");
        $("#PurchaseUnitAmt").val("");
        $("#PTransRateInfo").html("");

        $("#LayoverSaleUnitAmt").val("");
        $("#LayoverFixedPurchaseUnitAmt").val("");
        $("#LayoverPurchaseUnitAmt").val("");
        $("#PLayoverTransRateInfo").html("");

        $("#OilSaleUnitAmt").val("");
        $("#OilFixedPurchaseUnitAmt").val("");
        $("#OilPurchaseUnitAmt").val("");
        $("#POilTransRateInfo").html("");

        $("#DivUnitAmt").hide();
        $(".TrUpdRequestAmt").hide();

        //자동운임 항목 초기화
        if (objRes[0].data.RecordCnt <= 0) {
            return false;
        }

        $("#ApplySeqNo").val(objRes[0].data.ApplySeqNo);

        //매출, 매입이 따로 적용되었는지 확인
        var rateCntType1 = 0;
        $.each(objRes[0].data.list, function (index, item) {
            if (item.RateInfoKind === 1) {
                rateCntType1++;
            }
        });

        $.each(objRes[0].data.list, function (index, item) {
            if (item.RateInfoKind === 1) { //운임
                if (rateCntType1 > 1) {
                    if (item.SaleUnitAmt > 0) {
                        $("#SaleUnitAmt").val(item.SaleUnitAmt);
                        $("#SaleUnitAmt").val(fnMoneyComma($("#SaleUnitAmt").val()));
                    } else {
                        $("#FixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                        $("#FixedPurchaseUnitAmt").val(fnMoneyComma($("#FixedPurchaseUnitAmt").val()));
                        $("#PurchaseUnitAmt").val(item.PurchaseUnitAmt);
                        $("#PurchaseUnitAmt").val(fnMoneyComma($("#PurchaseUnitAmt").val()));
                    }

                    $("#PTransRateInfo").html($("#PTransRateInfo").html() + ($("#PTransRateInfo").html() !== "" ? " / " : "") + item.RateInfo);
                } else {
                    $("#SaleUnitAmt").val(item.SaleUnitAmt);
                    $("#SaleUnitAmt").val(fnMoneyComma($("#SaleUnitAmt").val()));
                    $("#FixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                    $("#FixedPurchaseUnitAmt").val(fnMoneyComma($("#FixedPurchaseUnitAmt").val()));
                    $("#PurchaseUnitAmt").val(item.PurchaseUnitAmt);
                    $("#PurchaseUnitAmt").val(fnMoneyComma($("#PurchaseUnitAmt").val()));
                    $("#PTransRateInfo").html(item.RateInfo);
                }
            } else if (item.RateInfoKind === 4) { //경유비
                $("#LayoverSaleUnitAmt").val(item.SaleUnitAmt);
                $("#LayoverSaleUnitAmt").val(fnMoneyComma($("#LayoverSaleUnitAmt").val()));
                $("#LayoverFixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                $("#LayoverFixedPurchaseUnitAmt").val(fnMoneyComma($("#LayoverFixedPurchaseUnitAmt").val()));
                $("#LayoverPurchaseUnitAmt").val(item.PurchaseUnitAmt);
                $("#LayoverPurchaseUnitAmt").val(fnMoneyComma($("#LayoverPurchaseUnitAmt").val()));
                $("#PLayoverTransRateInfo").html(item.RateInfo);
            } else if (item.RateInfoKind === 5) { //유가연동
                $("#OilSaleUnitAmt").val(item.SaleUnitAmt);
                $("#OilSaleUnitAmt").val(fnMoneyComma($("#OilSaleUnitAmt").val()));
                $("#OilFixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                $("#OilFixedPurchaseUnitAmt").val(fnMoneyComma($("#OilFixedPurchaseUnitAmt").val()));
                $("#OilPurchaseUnitAmt").val(item.PurchaseUnitAmt);
                $("#OilPurchaseUnitAmt").val(fnMoneyComma($("#OilPurchaseUnitAmt").val()));
                $("#POilTransRateInfo").html(item.RateInfo);
            }
        });

        $("#DivUnitAmt").show();
        $(".TrUpdRequestAmt").show();

    } else {
        fnCallDetailFailResult();
    }
}

function fnCallTransRateFailResult() {
    fnDefaultAlert("나중에 다시 시도해주세요.", "warning");
    return false;
}


//자동운임 수정요청
function fnUpdRequestAmt() {

    if (!$("#HidCenterCode").val() || !$("#HidOrderNo").val()) {
        return false;
    }

    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnUpdRequestAmtSuccResult";
    var strFailCallBackFunc = "fnUpdRequestAmtFailResult";

    var objParam = {
        CallType: "AmtRequestOrderList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnUpdRequestAmtSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnUpdRequestAmtFailResult();
            return false;
        }

        $.each(objRes[0].data.list, function (index, item) {
            var strType = "";
            var strItem = "";
            if (item.PayType === 1) {
                strType = "Sale";
            } else if (item.PayType === 2) {
                strType = "Purchase";
            }

            if (item.ItemCode === "OP001") {
                strItem = "1";
            } else if (item.ItemCode === "OP088") { //경유
                strItem = "2";
                $(".DlRateLayover").show();
            } else if (item.ItemCode === "OP089") { //유가연동
                strItem = "3";
                $(".DlRateOil").show();
            }

            $("#Rate" + strType + "PaySeqNo" + strItem).val(item.PaySeqNo);
            $("#RateOri" + strType + "SupplyAmt" + strItem).text(item.SupplyAmt);
            $("#RateOri" + strType + "SupplyAmt" + strItem).text(fnMoneyComma($("#RateOri" + strType + "SupplyAmt" + strItem).text()));
            if (item.ReqStatus === 1) {
                $("#Rate" + strType + "SupplyAmt" + strItem).val(item.ReqSupplyAmt);
                $("#Rate" + strType + "SupplyAmt" + strItem).val(fnMoneyComma($("#Rate" + strType + "SupplyAmt" + strItem).val()));
                $("#Rate" + strType + "TaxAmt" + strItem).val(item.ReqTaxAmt);
                $("#Rate" + strType + "TaxAmt" + strItem).val(fnMoneyComma($("#Rate" + strType + "TaxAmt" + strItem).val()));
                $("#Rate" + strType + "Reason" + strItem).val(item.ReqReason);

                $("#Rate" + strType + "SupplyAmt" + strItem).attr("readonly", "readonly");
                $("#Rate" + strType + "TaxAmt" + strItem).attr("readonly", "readonly");
                $("#Rate" + strType + "Reason" + strItem).attr("readonly", "readonly");

                $(".RateBtn" + strType + "" + strItem).hide();
                $(".RateStatus" + strType + "" + strItem).show();
                $(".RateStatus" + strType + "" + strItem).text(item.ReqStatusInfo);
            }
        });

        $("#PayRateLayer").show();
        return false;
    } else {
        fnUpdRequestAmtFailResult();
        return false;
    }
}

function fnUpdRequestAmtFailResult() {
    fnDefaultAlert("나중에 다시 시도해주세요.", "warning");
}

//자동운임 변경 요청 처리
function fnSetPayRate(intItem, intType) {

    if (intType === 1) {
        if (!$("#RateSaleReason" + intItem).val()) {
            fnDefaultAlertFocus("매출 수정 요청 사유를 입력하세요.", "RateSaleReason" + intItem, "warning");
            return false;
        }
    } else if (intType === 2) {
        if (!$("#RatePurchaseReason" + intItem).val()) {
            fnDefaultAlertFocus("매입 수정 요청 사유를 입력하세요.", "RatePurchaseReason" + intItem, "warning");
            return false;
        }
    }

    var fnParam = {
        Item: intItem,
        Type: intType
    };

    fnDefaultConfirm("수정 요청을 진행 하시겠습니까?", "fnSetPayRateProc", fnParam);
    return false;
}

function fnSetPayRateProc(fnParam) {

    var strPaySeqNo = "";
    var strSupplyAmt = "";
    var strTaxAmt = "";
    var strReason = "";
    var strType = "";
    if (fnParam.Type === 1) {
        strType = "Sale";
    } else if (fnParam.Type === 2) {
        strType = "Purchase";
    }

    strPaySeqNo = $("#Rate" + strType + "PaySeqNo" + fnParam.Item).val();
    strSupplyAmt = $("#Rate" + strType + "SupplyAmt" + fnParam.Item).val();
    strTaxAmt = $("#Rate" + strType + "TaxAmt" + fnParam.Item).val();
    strReason = $("#Rate" + strType + "Reason" + fnParam.Item).val();

    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnSetPayRateProcSuccResult";
    var strFailCallBackFunc = "fnSetPayRateProcFailResult";
    var objParam = {
        CallType: "AmtRequestInsert",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        ReqKind: fnParam.Type,
        PaySeqNo: strPaySeqNo,
        ReqSupplyAmt: strSupplyAmt,
        ReqTaxAmt: strTaxAmt,
        ReqReason: strReason
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnSetPayRateProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("수정 요청이 완료되었습니다.", "info");
            fnClosePayRate();
            return false;
        } else {
            fnSetPayRateProcFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetPayRateProcFailResult();
        return false;
    }
}

function fnSetPayRateProcFailResult(msg) {
    var alertMsg = "비용 수정 요청에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.";
    if (typeof msg != "undefined" && msg !== "") {
        alertMsg += " (" + msg + ")";
    }
    fnDefaultAlert(alertMsg, "warning");
    return false;
}

//자동운임 수정요청 닫기
function fnClosePayRate() {
    $("#RateSaleTaxKind1").val("1");
    $("#RateSalePaySeqNo1").val("");
    $("#RateSaleSupplyAmt1").val("");
    $("#RateSaleTaxAmt1").val("");
    $("#RateSaleReason1").val("");
    $(".RateBtnSale1").show();
    $(".RateStatusSale1").hide();
    $(".RateStatusSale1").text("");
    $("#RatePurchaseTaxKind1").val("1");
    $("#RatePurchasePaySeqNo1").val("");
    $("#RatePurchaseSupplyAmt1").val("");
    $("#RatePurchaseTaxAmt1").val("");
    $("#RatePurchaseReason1").val("");
    $(".RateBtnPurchase1").show();
    $(".RateStatusPurchase1").hide();
    $(".RateStatusPurchase1").text("");
    $("#RateSaleTaxKind2").val("1");
    $("#RateSalePaySeqNo2").val("");
    $("#RateSaleSupplyAmt2").val("");
    $("#RateSaleTaxAmt2").val("");
    $("#RateSaleReason2").val("");
    $(".RateBtnSale2").show();
    $(".RateStatusSale2").hide();
    $(".RateStatusSale2").text("");
    $("#RatePurchaseTaxKind2").val("1");
    $("#RatePurchasePaySeqNo2").val("");
    $("#RatePurchaseSupplyAmt2").val("");
    $("#RatePurchaseTaxAmt2").val("");
    $("#RatePurchaseReason2").val("");
    $(".RateBtnPurchase2").show();
    $(".RateStatusPurchase2").hide();
    $(".RateStatusPurchase2").text("");
    $("#RateSaleTaxKind3").val("1");
    $("#RateSalePaySeqNo3").val("");
    $("#RateSaleSupplyAmt3").val("");
    $("#RateSaleTaxAmt3").val("");
    $("#RateSaleReason3").val("");
    $(".RateBtnSale3").show();
    $(".RateStatusSale3").hide();
    $(".RateStatusSale3").text("");
    $("#RatePurchaseTaxKind3").val("1");
    $("#RatePurchasePaySeqNo3").val("");
    $("#RatePurchaseSupplyAmt3").val("");
    $("#RatePurchaseTaxAmt3").val("");
    $("#RatePurchaseReason3").val("");
    $(".RateBtnPurchase3").show();
    $(".RateStatusPurchase3").hide();
    $(".RateStatusPurchase3").text("");

    $(".DlRateLayover").hide();
    $(".DlRateOil").hide();
    $("#PayRateLayer input[type='text']").removeAttr("readonly");
    $("#PayRateLayer").hide();
}
/******************************************/