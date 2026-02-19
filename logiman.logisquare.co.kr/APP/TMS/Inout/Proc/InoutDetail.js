var strOrderLocationCode = "";
/*리스트 파라미터*/
var strListDataParam = "";
$(document).ready(function () {
    /*리스트 파라미터*/
    var strListData = $("#HidParam").val();
    strListDataParam = strListData.replace(/:/g, "=").replace(/,/g, "&").replace(/{/g, "").replace(/}/g, "");

    $(".data_detail h2").on("click", function () {
        $(this).parent("div").children("table").toggle();
    });

    $("#PopMastertitle").text("수출입 오더상세");

    if ($("#HidErrMsg").val()) {
        fnDefaultAlert($("#HidErrMsg").val(), "warning", "$(\"#BtnGoBack\").click()");
        return false;
    }

    //오더수정
    $("#BtnGoUpdOrder").on("click", function (e) {
        document.location.replace("/APP/TMS/Inout/InoutIns?OrderNo=" + $("#HidOrderNo").val() + "&HidParam=" + $("#HidParam").val());
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

        document.location.replace("/APP/TMS/Inout/InoutIns?OrderNo=" + $("#HidOrderNo").val() + "&CopyFlag=Y" + "&HidParam=" + $("#HidParam").val());
        return false;
    });

    //오더취소
    $("#BtnCancelOrder").on("click", function (e) {
        if (!$("#HidOrderNo").val()) {
            return false;
        }

        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 취소하실 수 없습니다.");
            return false;
        }

        fnCnlOrder();
        return false;
    });

    //사업장
    $("#OrderLocationCode").bind("click", function (e) {
        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 변경할 수 없습니다.", "warning", "fnNoChgOrderLocation()");
            return false;
        }

        strOrderLocationCode = $(this).val();
    }).on("change", function (e) {

        if ($(this).val() !== "") {
            fnDefaultConfirm("사업장을 변경 하시겠습니까?", "fnChgOrderLocation", "","fnNoChgOrderLocation", "");
        } else {
            fnNoChgOrderLocation();
        }
        return false;
    });

    fnSetInitData();
});

function fnSetInitData() {
    fnCallOrderDetail();
}

//오더 데이터 세팅
function fnCallOrderDetail() {

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnOrderDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "InoutList",
        OrderNo: $("#HidOrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
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
        $("#OrderLocationCode").val(item.OrderLocationCode);

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

        $("ul.detail_check li").hide();
        $.each($("li"),
            function (index, input) {
                var strId = $(input).attr("id");
                var strField = "";
                if (typeof strId === "string") {
                    strField = strId.substr(2, strId.length - 1);

                    if (eval("item." + strField) != null) {
                        if (eval("item." + strField) === "Y") {
                            $("#" + strId).show();
                        } else {
                            $("#" + strId).hide();
                        }
                    }
                }
            });

        $("#Weight").text(fnMoneyComma($("#Weight").text()));
        $("#CBM").text(fnMoneyComma($("#CBM").text()));
        $("#Volume").text(fnMoneyComma($("#Volume").text()));
        $("#Length").text(fnMoneyComma($("#Length").text()));

        $("#DivContract").hide();

        if (item.GoodsDispatchType === 2) {
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

        }

        if ($("#CnlFlag").val() === "Y") {
            $("#BtnCancelOrder").hide();
            $("#BtnGoUpdOrder").hide();
        }

        //위수탁 정보 조회
        fnCallOrderContract();

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

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCallDispatchSuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "InoutDispatchCarList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        GoodsSeqNo: $("#GoodsSeqNo").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strCallBackFailFunc, "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDispatchSuccResult(objRes) {
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
                html += "<tr class=\"center\">\n";
                html += "\t<td>" + item.DispatchTypeM + "</td>\n";
                html += "\t<td class=\"left\">" + item.DispatchCarInfo + "</td>\n";
                html += "</tr>\n";
            });
            $("#TbodyDispatchInfo").html(html);
        }
    } else {
        fnCallDetailFailResult();
    }
}

//비용 목록 조회
function fnCallPayData() {

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnPaySuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "InoutPayList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strCallBackFailFunc, "", true);
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
                html += "\t<td><span class=\"" + strClass + "\">" + item.PayTypeM + "</span><br/>" + item.TaxKindM + "</td>\n";
                html += "\t<td>" + item.ItemCodeM + "</td>\n";
                html += "\t<td class=\"right\">" + fnMoneyComma(item.SupplyAmt) + "<br/>" + fnMoneyComma(item.TaxAmt) + "</td>\n";
                html += "\t<td class=\"left\">" + info + "</td>\n";
                html += "</tr>\n";
            });
            $("#TbodyPayInfo").html(html);
        }
    }
}

//위탁정보 조회
function fnCallOrderContract() {

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCallOrderContractSuccResult";
    var strFailCallBackFunc = "fnCallOrderContractFailResult";

    var objParam = {
        CallType: "InoutContract",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnCallOrderContractSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                fnCallOrderContractFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallOrderContractFailResult();
            return false;
        }

        $("#ContractType").val(objRes[0].data.ContractType);
        $("#ContractStatus").val(objRes[0].data.ContractStatus);
        if (objRes[0].data.ContractType == 2) {
        } else if (objRes[0].data.ContractType == 3) {
            $("#ContractInfo").text(objRes[0].data.ContractInfo);
            $("#DivContract").show();
        }
    } else {
        fnCallOrderContractFailResult();
    }
}

function fnCallOrderContractFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
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

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCnlOrderSuccResult";
    var strFailCallBackFunc = "fnCnlOrderFailResult";
    var objParam = {
        CallType: "InoutOneCancel",
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
    document.location.replace("/APP/TMS/Inout/InoutDetail?OrderNo=" + $("#HidOrderNo").val() + "&HidParam=" + $("#HidParam").val());
}

//사업장 변경
function fnChgOrderLocation() {

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnChgOrderLocationSuccResult";
    var strFailCallBackFunc = "fnChgOrderLocationFailResult";
    var objParam = {
        CallType: "InoutLocationUpdate",
        CenterCode: $("#HidCenterCode").val(),
        OrderNos: $("#HidOrderNo").val(),
        OrderLocationCode: $("#OrderLocationCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnChgOrderLocationSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("오더 사업장이 변경되었습니다.", "info");
            return false;
        } else {
            fnChgOrderLocationFailResult();
            return false;
        }
    } else {
        fnChgOrderLocationFailResult();
        return false;
    }
}

function fnChgOrderLocationFailResult() {
    fnDefaultAlert("오더 사업장 변경에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning");
    return false;
}

function fnNoChgOrderLocation() {
    $("#OrderLocationCode").val(strOrderLocationCode);
    return false;
}

/*리스트 돌아가기*/
function fnListBack() {
    document.location.href = "/APP/TMS/Inout/InoutList?" + strListDataParam;
}