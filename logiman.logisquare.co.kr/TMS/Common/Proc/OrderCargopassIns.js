$(document).ready(function () {

    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // f2
        if (event.keyCode === 113) {
            $("#BtnRegCargopass").click();
            return false;
        }
    });

    $("#PickupYMD").datepicker({
        dateFormat: "yy-mm-dd",
        onSelect: function (dateFromText, inst) {
            var GetYMDText = $("#GetYMD").val().replace(/-/gi, "");
            if (GetYMDText.length !== 8) {
                GetYMDText = GetDateToday("");
            }

            if (parseInt(dateFromText.replace(/-/gi, "")) > parseInt(GetYMDText)) {
                $("#GetYMD").datepicker("setDate", dateFromText);
            }
        }
    });
    $("#PickupYMD").datepicker("setDate", GetDateToday("-"));

    $("#GetYMD").datepicker({
        dateFormat: "yy-mm-dd",
        onClose: function (dateFromText, inst) {
            fnSetQuickPay();
        }
    });
    $("#GetYMD").datepicker("setDate", GetDateToday("-"));

    if ($("#HidDisplayMode").val() === "Y") {
        fnDefaultAlert($("#HidErrMsg").val(), "warning", "fnWindowClose()");
        return false;
    }

    //버튼 이벤트
    //상차지 다시 입력 
    $("#BtnResetPickupPlace").on("click", function (e) {
        if ($("#CargopassStatus").val() == "3" || $("#CargopassStatus").val() == "4" || $("#CargopassStatus").val() == "9") {
            fnDefaultAlert("배차, 배차확정, 취소된 오더는 수정이 불가능합니다.", "warning");
            return false;
        }

        $(".TdPickup input").val("");
        $(".TdPickup select").val("");
        $("#PickupYMD").datepicker("setDate", GetDateToday("-"));
        return false;
    });

    //상차지 주소 검색
    $("#BtnSearchAddrPickupPlace").on("click", function (e) {
        if ($("#CargopassStatus").val() === "3" || $("#CargopassStatus").val() === "4" || $("#CargopassStatus").val() === "9") {
            fnDefaultAlert("배차, 배차확정, 취소된 오더는 수정이 불가능합니다.", "warning");
            return false;
        }

        fnOpenCargopassAddress("Pickup");
        return false;
    });

    //하차지 다시 입력 
    $("#BtnResetGetPlace").on("click", function (e) {
        if ($("#CargopassStatus").val() === "3" || $("#CargopassStatus").val() === "4" || $("#CargopassStatus").val() === "9") {
            fnDefaultAlert("배차, 배차확정, 취소된 오더는 수정이 불가능합니다.", "warning");
            return false;
        }

        $(".TdGet input").val("");
        $(".TdGet select").val("");
        $("#GetYMD").datepicker("setDate", GetDateToday("-"));
        return false;
    });

    //하차지 주소 검색
    $("#BtnSearchAddrGetPlace").on("click", function (e) {
        if ($("#CargopassStatus").val() === "3" || $("#CargopassStatus").val() === "4" || $("#CargopassStatus").val() === "9") {
            fnDefaultAlert("배차, 배차확정, 취소된 오더는 수정이 불가능합니다.", "warning");
            return false;
        }

        fnOpenCargopassAddress("Get");
        return false;
    });

    //빠른입금 안내
    $("#BtnSearchConsignorInfo").on("click", function (e) {
        fnDefaultAlert("바로지급 : 마감하는 즉시 송금<br>14일 지급 : 마감일 + 14일 후 송금", "info");
        return false;
    });

    //카고패스 연동하기
    $("#BtnRegCargopass").on("click", function (e) {
        if ($("#CargopassStatus").val() === "3" || $("#CargopassStatus").val() === "4" || $("#CargopassStatus").val() === "9") {
            fnDefaultAlert("배차, 배차확정, 취소된 오더는 수정이 불가능합니다.", "warning");
            return false;
        }

        fnInsCargopass();
        return false;
    });

    //카고패스 연동보기
    $("#BtnViewCargopass").on("click", function (e) {
        if (!($("#CargopassStatus").val() === "2" || $("#CargopassStatus").val() === "3" || $("#CargopassStatus").val() === "4" || $("#CargopassStatus").val() === "9")) {
            fnDefaultAlert("등록, 배차, 배차확정, 취소된 오더만 조회가 가능합니다.", "warning");
            return false;
        }

        fnViewCargopass();
        return false;
    });

    //빠른입금 변경
    $("#QuickType1").on("click", function () {
        if ($("#CargopassStatus").val() === "3" || $("#CargopassStatus").val() === "4" || $("#CargopassStatus").val() === "9") {
            fnDefaultAlert("배차, 배차확정, 취소된 오더는 수정이 불가능합니다.", "warning");
            return false;
        }

        fnSetQuickPay();
    });

    $("#QuickType2").on("click", function () {
        if ($("#CargopassStatus").val() === "3" || $("#CargopassStatus").val() === "4" || $("#CargopassStatus").val() === "9") {
            fnDefaultAlert("배차, 배차확정, 취소된 오더는 수정이 불가능합니다.", "warning");
            return false;
        }
        fnSetQuickPay();
    });

    $("#QuickType3").on("click", function () {
        if ($("#CargopassStatus").val() === "3" || $("#CargopassStatus").val() === "4" || $("#CargopassStatus").val() === "9") {
            fnDefaultAlert("배차, 배차확정, 취소된 오더는 수정이 불가능합니다.", "warning");
            return false;
        }

        fnSetQuickPay();
    });

    $("#PickupSearch").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#BtnSearchAddrPickupPlace").click();
            }
        });

    $("#GetSearch").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#BtnSearchAddrGetPlace").click();
            }
        });
    
    $("#SupplyAmt").on("keyup blur",
        function () {
            $(this).val(fnMoneyComma($(this).val()));
        });

    $("#Weight").on("blur",
        function () {
            var strVal = Number($(this).val() === "" ? "0" : $(this).val());
            if (isNaN(strVal)) {
                $(this).val("0.00");
            } else {
                $(this).val(parseFloat(strVal).toFixed(2));
            }
        });

    //기본 설정 값
    fnSetInitData();
});

//기본 설정
function fnSetInitData() {

    if ($("#HidMode").val() === "Insert") {
        if ($("#CenterCode").val()) {
            $("#CenterCode option:not(:selected)").prop("disabled", true);
        }

        if ($("#DispatchType").val()) {
            $("#DispatchType option:not(:selected)").prop("disabled", true);
        }

        if (!$("#OrderNos").val() || !$("#DispatchType").val() || !$("#CenterCode").val()) {
            fnDefaultAlert("카고패스 연동에 필요한 값이 없습니다.", "warning", "fnWindowClose()");
            return false;
        }

        fnSetOrdersInfo();
        return false;

    } else if ($("#HidMode").val() === "Update") {
        $("#PickupYMD").datepicker("disable").removeAttr("disabled");
        $("#GetYMD").datepicker("disable").removeAttr("disabled");
        fnCallCargopassDetail();
        return false;
    }
}

//단건 오더 정보 세팅
function fnSetOrdersInfo() {

    if (!$("#CenterCode").val()) {
        return false;
    }

    if (!$("#OrderNos").val() && !$("#CargopassOrderNo").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/Common/Proc/OrderCargopassHandler.ashx";
    var strCallBackFunc = "fnSetOrderInfoSuccResult";
    var strFailCallBackFunc = "fnAjaxFailResult";

    var objParam = {
        CallType: "OrderPlaceList",
        CargopassOrderNo: $("#CargopassOrderNo").val(),
        CenterCode: $("#CenterCode").val(),
        OrderNos: $("#OrderNos").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetOrderInfoSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnAjaxFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnAjaxFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnAjaxFailResult("오더 상하차 정보를 불러오지 못했습니다.");
            return false;
        }

        $("#TblOrderList Tbody Tr").remove();

        var strHtml = "";
        $.each(objRes[0].data.list,
            function(index, item) {
                strHtml += "<tr>\n";
                strHtml += "\t<td>" + item.PGTypeM + "</td>\n";
                strHtml += "\t<td>" + fnGetStrDateFormat(item.YMD, "-") + "</td>\n";
                var strHM = item.HM;
                if (strHM.length === 4 && $.isNumeric(strHM)) {
                    strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                } else {
                    strHM = "";
                }
                strHtml += "\t<td>" + strHM + "</td>\n";
                strHtml += "\t<td>" + item.ConsignorName + "</td>\n";
                strHtml += "\t<td>" + item.Addr + "</td>\n";
                strHtml += "\t<td>" + item.AddrDtl + "</td>\n";
                strHtml += "\t<td>" + item.TelNo + "</td>\n";
                strHtml += "\t<td>" + item.Way + "</td>\n";
                strHtml += "\t<td>\n";
                strHtml += "\t\t<button type=\"button\" class=\"btn_01\" onclick=\"fnSetPlace(1, " +
                    (index + 1) +
                    "); return false;\">상차정보적용</button>&nbsp;\n";
                strHtml += "\t\t<button type=\"button\" class=\"btn_01\" onclick=\"fnSetPlace(2, " +
                    (index + 1) +
                    "); return false;\">하차정보적용</button>\n";
                strHtml += "\t</td>\n";
                strHtml += "</tr>\n";
            });

        $("#TblOrderList Tbody").html(strHtml);

        if ($("#HidMode").val() === "Insert") {
            $("#Volume").val(objRes[0].data.Volume);
            $("#CBM").val(objRes[0].data.CBM);

            var dblWeight = parseFloat(objRes[0].data.Weight) / 1000;
            dblWeight = dblWeight.toFixed(2);
            $("#Weight").val(dblWeight);

            $("#PickupYMD").val($("#TblOrderList Tbody Tr:first-child td:nth-child(2)").text());
            $("#PickupHM").val($("#TblOrderList Tbody Tr:first-child td:nth-child(3)").text().replace(/:/gi, ""));
            $("#ConsignorName").val($("#TblOrderList Tbody Tr:first-child td:nth-child(4)").text());
            $("#PickupAddr").val($("#TblOrderList Tbody Tr:first-child td:nth-child(5)").text());
            $("#PickupAddrDtl").val($("#TblOrderList Tbody Tr:first-child td:nth-child(6)").text());
            $("#PickupWay").val($("#TblOrderList Tbody Tr:first-child td:nth-child(8)").text());

            $("#GetYMD").val($("#TblOrderList Tbody Tr:last-child td:nth-child(2)").text());
            $("#GetHM").val($("#TblOrderList Tbody Tr:last-child td:nth-child(3)").text().replace(/:/gi, ""));
            $("#GetAddr").val($("#TblOrderList Tbody Tr:last-child td:nth-child(5)").text());
            $("#GetAddrDtl").val($("#TblOrderList Tbody Tr:last-child td:nth-child(6)").text());
            $("#GetTelNo").val($("#TblOrderList Tbody Tr:last-child td:nth-child(7)").text());
            $("#GetWay").val($("#TblOrderList Tbody Tr:last-child td:nth-child(8)").text());

            //톤수처리
            var strCarTon = objRes[0].data.CarTon;
            if (strCarTon !== "") {
                var arrCarTon = strCarTon.split(",");
                for (i = 0; i < arrCarTon.length; i++) {
                    var strCarTonDetail = arrCarTon[i];
                    $.each($("#CarTon option"), function (index, item) {
                        if ($("#CarTon option:selected").val() === "") {
                            if ($(item).val() === strCarTonDetail) {
                                $("#CarTon").val($(item).val());
                            }
                        }
                    });
                    $.each($("#CarTon option"), function (index, item) {
                        if ($("#CarTon option:selected").val() === "") {
                            if ($(item).val().indexOf(strCarTonDetail) > -1) {
                                $("#CarTon").val($(item).val());
                            }
                        }
                    });
                }
            }

            //차종처리
            var strCarTruck = objRes[0].data.CarTruck;
            if (strCarTruck !== "") {
                var arrCarTruck = strCarTruck.split(",");
                for (i = 0; i < arrCarTruck.length; i++) {
                    var strCarTruckDetail = arrCarTruck[i];
                    $.each($("#CarTruck option"), function (index, item) {
                        if ($("#CarTruck option:selected").val() === "") {
                            if ($(item).val() === strCarTruckDetail) {
                                $("#CarTruck").val($(item).val());
                            }
                        }
                    });
                    $.each($("#CarTruck option"), function (index, item) {
                        if ($("#CarTruck option:selected").val() === "") {
                            if ($(item).val().indexOf(strCarTruckDetail) > -1) {
                                $("#CarTruck").val($(item).val());
                            }
                        }
                    });
                }
            }
        }

        fnSetFocus();
        return false;
    } else {
        fnAjaxFailResult();
        return false;
    }
}

function fnAjaxFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("일시적인 오류가 발생했습니다." + msg, "warning", "fnWindowClose();");
    return false;
}

//상/하차 정보 적용
function fnSetPlace(intPGType, intNum) {
    if ($("#CargopassStatus").val() === "3" || $("#CargopassStatus").val() === "4" || $("#CargopassStatus").val() === "9") {
        fnDefaultAlert("배차, 배차확정, 취소된 오더는 수정이 불가능합니다.", "warning");
        return false;
    }

    if (intPGType === 1) {
        $("#PickupYMD").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(2)").text());
        $("#PickupHM").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(3)").text().replace(/:/gi, ""));
        $("#ConsignorName").val($("#TblOrderList Tbody Tr:first-child td:nth-child(4)").text());
        $("#PickupAddr").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(5)").text());
        $("#PickupAddrDtl").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(6)").text());
        $("#PickupWay").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(8)").text());
    } else if (intPGType === 2) {
        $("#GetYMD").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(2)").text());
        $("#GetHM").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(3)").text().replace(/:/gi, ""));
        $("#GetAddr").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(5)").text());
        $("#GetAddrDtl").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(6)").text());
        $("#GetTelNo").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(7)").text());
        $("#GetWay").val($("#TblOrderList Tbody Tr:nth-child(" + intNum + ") td:nth-child(8)").text());
    }

    return false;
}

//오더 데이터 세팅
function fnCallCargopassDetail() {

    if (!$("#CargopassOrderNo").val()) {
        fnAjaxFailResult();
        return false;
    }

    var strHandlerURL = "/TMS/Common/Proc/OrderCargopassHandler.ashx";
    var strCallBackFunc = "fnOrderDetailSuccResult";
    var strFailCallBackFunc = "fnAjaxFailResult";

    var objParam = {
        CallType: "CargopassDetail",
        CenterCode: $("#CenterCode").val(),
        CargopassOrderNo: $("#CargopassOrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnOrderDetailSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnAjaxFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnAjaxFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnAjaxFailResult("연동 정보를 불러오지 못했습니다.");
            return false;
        }

        var item = objRes[0].data.list[0];
        //Hidden
        $.each($("input[type='hidden']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });
       
        //Textbox
        $.each($("input[type='text']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($(input).attr("id").indexOf("YMD") > -1) {
                        if (eval("item." + $(input).attr("id")).length == 8) {
                            $("#" + $(input).attr("id")).val(fnGetStrDateFormat(eval("item." + $(input).attr("id")), "-"));
                        } else {
                            $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                        }
                    } else {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });
        $("#SupplyAmt").val(fnMoneyComma($("#SupplyAmt").val()));

        //Textarea

        //Select
        $("#CenterCode").val(item.CenterCode);
        $("#CenterCode option:not(:selected)").prop("disabled", true);
        $.each($("select"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id")) + "']").length > 0) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });
        $("#DispatchType option:not(:selected)").prop("disabled", true);
        $("#CarTon").find("option").filter(function (index) {
            return $(this).text() === item.CarTon;
        }).attr("selected", "selected");
        $("#CarTruck").find("option").filter(function (index) {
            return $(this).text() === item.CarTruck;
        }).attr("selected", "selected");

        //RadioButton
        $("#QuickType1").prop("checked", item.QuickType == "1");
        $("#QuickType2").prop("checked", item.QuickType == "2");
        $("#QuickType3").prop("checked", item.QuickType == "3");
        if (!$("#QuickType1").is(":checked") && !$("#QuickType2").is(":checked") && !$("#QuickType3").is(":checked")) {
            $("#QuickType1").prop("checked", true);
        }

        if (item.QuickType == "2" || item.QuickType == "3") {
            $("#PayPlanYMD").show();
        }

        $("#LayerFlag").prop("checked", item.LayerFlag === "Y");
        $("#UrgentFlag").prop("checked", item.UrgentFlag === "Y");
        $("#ShuttleFlag").prop("checked", item.ShuttleFlag === "Y");

        //Button
        if (item.CargopassStatus >= 2) { //등록 이후 상태
            $("#BtnViewCargopass").show();
        }

        if (item.CargopassStatus >= 3) { //배차 이후 상태
            $("#BtnRegCargopass").hide();
        }

        //Span
        $("#SpanCargopassStatusM").text(item.CargopassStatusM);
        $("#SpanCargopassStatusM").show();

        //배차확정
        if (item.CargopassStatus == "4") {
            $("#SpanCargopassNetworkKindM").text(item.CargopassNetworkKindM);
            $("#SpanComName").text(item.ComName);
            $("#SpanComCorpNo").text(item.ComCorpNo);
            $("#SpanCarNo").text(item.CarNo);
            $("#SpanDriverName").text(item.DriverName);
            $("#SpanDriverCell").text(item.DriverCell);
            $(".TrCarInfo").show();
        }

        fnSetOrdersInfo();
        return false;
    } else {
        fnAjaxFailResult();
        return false;
    }
}

//빠른입금 리셋
function fnSetQuickPay() {
    $("#PayPlanYMD").hide();
    $("#PayPlanYMD").val("");
    $("#Note").val($("#Note").val().replace(/★빠른입금★/gi, ""));

    if ($("#QuickType2").is(":checked")) {
        fnGetPlanYMD(2);
        $("#PayPlanYMD").show();
        if ($("#Note").val().indexOf("★빠른입금★" < 0)) {
            $("#Note").val("★빠른입금★" + $("#Note").val());
        }
        return false;
    } else if ($("#QuickType3").is(":checked")) {
        fnGetPlanYMD(3);
        $("#PayPlanYMD").show();
        if ($("#Note").val().indexOf("★빠른입금★" < 0)) {
            $("#Note").val("★빠른입금★" + $("#Note").val());
        }
        return false;
    }
}

//송금예정일
function fnGetPlanYMD(intType) {
    if (intType !== 2 && intType !== 3) {
        return false;
    }

    if (!$("#GetYMD").val()) {
        fnDefaultAlertFocus("하차일을 선택하세요.", "GetYMD", "warning");
        return false;
    }

    var strHandlerURL = "/TMS/Common/Proc/OrderCargopassHandler.ashx";
    var strCallBackFunc = "fnGetPlanYMDSuccResult";
    var strFailCallBackFunc = "fnAjaxFailResult";

    var objParam = {
        CallType: "PlanYMD",
        YMD: $("#GetYMD").val(),
        AddDateCnt: intType === 2 ? 3 : 14,
        HolidayFlag: "N"
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnGetPlanYMDSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnAjaxFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnAjaxFailResult();
            return false;
        }

        $("#PayPlanYMD").val(fnGetStrDateFormat(objRes[0].data.PlanYMD, "-"));
    }
}

//포커스 이동
function fnSetFocus() {
    if (!$("#ConsignorName").val()) {
        $("#ConsignorName").focus();
        return false;
    } else if (!$("#CenterCode").val()) {
        $("#CenterCode").focus();
        return false;
    } else if (!$("#DispatchType").val()) {
        $("#DispatchType").focus();
        return false;
    } else if (!$("#PickupYMD").val()) {
        $("#PickupYMD").focus();
        return false;
    } else if (!$("#PickupHM").val()) {
        $("#PickupHM").focus();
        return false;
    } else if (!$("#PickupAddr").val()) {
        $("#PickupAddrSearch").focus();
        return false;
    } else if (!$("#PickupAddrDtl").val()) {
        $("#PickupAddrDtl").focus();
        return false;
    } else if (!$("#PickupWay").val()) {
        $("#PickupWay").focus();
        return false;
    } else if (!$("#GetYMD").val()) {
        $("#GetYMD").focus();
        return false;
    } else if (!$("#GetHM").val()) {
        $("#GetHM").focus();
        return false;
    } else if (!$("#GetAddr").val()) {
        $("#GetAddrSearch").focus();
        return false;
    } else if (!$("#GetAddrDtl").val()) {
        $("#GetAddrDtl").focus();
        return false;
    } else if (!$("#GetTelNo").val()) {
        $("#GetTelNo").focus();
        return false;
    } else if (!$("#GetWay").val()) {
        $("#GetWay").focus();
        return false;
    } else if (!$("#CarTon").val()) {
        $("#CarTon").focus();
        return false;
    } else if (!$("#CarTruck").val()) {
        $("#CarTruck").focus();
        return false;
    } else if (!$("#Weight").val()) {
        $("#Weight").focus();
        return false;
    } else if (!$("#SupplyAmt").val()) {
        $("#SupplyAmt").focus();
        return false;
    } else if (!$("#Note").val()) {
        $("#Note").focus();
        return false;
    }
}

/************************************************************/
//카고패스 등록/수정
function fnInsCargopass() {

    var strConfMsg = "";
    var strCallType = "";

    if ($("#CargopassStatus").val() === "9") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return false;
    }

    if ($("#CargopassStatus").val() === "3") {
        fnDefaultAlert("배차 취소 후 연동할 수 있습니다.", "warning");
        return false;
    }

    if ($("#CargopassStatus").val() === "4") {
        fnDefaultAlert("이미 배차가 확정되었습니다.", "warning");
        return false;
    }

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#DispatchType").val()) {
        fnDefaultAlertFocus("배차구분을 선택하세요.", "DispatchType", "warning");
        return false;
    }

    if (!$("#ConsignorName").val()) {
        fnDefaultAlertFocus("화주명을 입력하세요.", "ConsignorName", "warning");
        return false;
    }

    if (!$("#TelNo").val()) {
        fnDefaultAlertFocus("배차자 연락처를 입력하세요.", "TelNo", "warning");
        return false;
    }

    if (!$("#PickupYMD").val()) {
        fnDefaultAlertFocus("상차일을 입력하세요.", "PickupYMD", "warning");
        return false;
    }

    if ($("#PickupYMD").val().replace(/-/gi, "") < GetDateToday("")) {
        fnDefaultAlertFocus("상차일이 오늘 이전일 수 없습니다.", "PickupYMD", "warning");
        return false;
    }

    if (!$("#PickupHM").val()) {
        fnDefaultAlertFocus("상차 시간을 입력하세요.", "PickupHM", "warning");
        return false;
    }

    if ($("#PickupHM").val().length !== 4) {
        fnDefaultAlertFocus("상차 시간을 정확(HHMM) 하게 입력하세요.", "PickupHM", "warning");
        return false;
    }
    
    if (!$.isNumeric($("#PickupHM").val())) {
        fnDefaultAlertFocus("상차 시간을 정확(HHMM) 하게 입력하세요.", "PickupHM", "warning");
        return false;
    }

    if (parseInt($("#PickupHM").val().substr(0, 2)) < 0 || parseInt($("#PickupHM").val().substr(0, 2)) > 23) {
        fnDefaultAlertFocus("상차 시간을 정확(HHMM) 하게 입력하세요.", "PickupHM", "warning");
        return false;
    }

    if (parseInt($("#PickupHM").val().substr(2, 2)) < 0 || parseInt($("#PickupHM").val().substr(2, 2)) > 59) {
        fnDefaultAlertFocus("상차 시간을 정확(HHMM) 하게 입력하세요.", "PickupHM", "warning");
        return false;
    }

    if (!$("#PickupAddr").val()) {
        fnDefaultAlertFocus("상차지 주소를 입력하세요.", "PickupAddr", "warning");
        return false;
    }

    if (!$("#PickupAddrDtl").val()) {
        fnDefaultAlertFocus("상차지 상세 주소를 입력하세요.", "PickupAddrDtl", "warning");
        return false;
    }

    if (!$("#PickupWay").val()) {
        fnDefaultAlertFocus("상차방법을 선택하세요.", "PickupWay", "warning");
        return false;
    }

    if (!$("#GetYMD").val()) {
        fnDefaultAlertFocus("하차일을 입력하세요.", "GetYMD", "warning");
        return false;
    }

    if ($("#PickupYMD").val().replace(/-/gi, "") > $("#GetYMD").val().replace(/-/gi, "")) {
        fnDefaultAlertFocus("하차일이 상차일보다 빠를 수 없습니다.", "GetYMD", "warning");
        return false;
    }

    if (!$("#GetHM").val()) {
        fnDefaultAlertFocus("하차 시간을 입력하세요.", "GetHM", "warning");
        return false;
    }

    if (!$.isNumeric($("#GetHM").val())) {
        fnDefaultAlertFocus("하차 시간을 정확(HHMM) 하게 입력하세요.", "GetHM", "warning");
        return false;
    }

    if (parseInt($("#GetHM").val().substr(0, 2)) < 0 || parseInt($("#GetHM").val().substr(0, 2)) > 23) {
        fnDefaultAlertFocus("하차 시간을 정확(HHMM) 하게 입력하세요.", "GetHM", "warning");
        return false;
    }

    if (parseInt($("#GetHM").val().substr(2, 2)) < 0 || parseInt($("#GetHM").val().substr(2, 2)) > 59) {
        fnDefaultAlertFocus("하차 시간을 정확(HHMM) 하게 입력하세요.", "GetHM", "warning");
        return false;
    }

    if ($("#PickupYMD").val() === $("#GetYMD").val()) {
        if ($("#PickupHM").val() === $("#GetHM").val()) {
            fnDefaultAlertFocus("상차일시와 하차일시가 같을 수 없습니다.", "GetHM", "warning");
            return false;
        }

        if ($("#PickupHM").val() > $("#GetHM").val()) {
            fnDefaultAlertFocus("하차시간이 상차시간보다 빠를 수 없습니다.", "GetHM", "warning");
            return false;
        }
    }

    if (!$("#GetAddr").val()) {
        fnDefaultAlertFocus("하차지 주소를 입력하세요.", "GetAddrSearch", "warning");
        return false;
    }

    if (!$("#GetAddrDtl").val()) {
        fnDefaultAlertFocus("하차지 상세 주소를 입력하세요.", "GetAddrDtl", "warning");
        return false;
    }

    if (!$("#GetTelNo").val()) {
        fnDefaultAlertFocus("하차지 연락처를 입력하세요.", "GetTelNo", "warning");
        return false;
    }

    if (!$("#GetWay").val()) {
        fnDefaultAlertFocus("하차방법을 선택하세요.", "GetWay", "warning");
        return false;
    }

    if ($("#CarTon option:selected").text() === "톤수") {
        fnDefaultAlertFocus("차량 톤수를 선택하세요.", "CarTon", "warning");
        return false;
    }

    if ($("#CarTruck option:selected").text() === "차종") {
        fnDefaultAlertFocus("차종을 선택하세요.", "CarTruck", "warning");
        return false;
    }

    if (!$("#Volume").val()) {
        fnDefaultAlertFocus("수량을 입력하세요.", "Volume", "warning");
        return false;
    }

    if (!$("#CBM").val()) {
        fnDefaultAlertFocus("부피를 입력하세요.", "CBM", "warning");
        return false;
    }

    if (!$("#Weight").val()) {
        fnDefaultAlertFocus("중량을 입력하세요.", "Weight", "warning");
        return false;
    }

    if (parseFloat($("#Weight").val().replace(/,/gi, "").replace(/\./gi, "")) < 0.01) {
        fnDefaultAlertFocus("중량은 0.01t이상 입력하세요.", "Weight", "warning");
        return false;
    }

    var carTon = $("#CarTon option:selected").text().replace("플러스", "").replace("축", "").replace("미만", "").replace("톤", "");
    if (carTon !== "기타" && carTon !== "20피트" && carTon !== "40피트") {
        if (parseFloat(carTon) * 1.1 < parseFloat($("#Weight").val().replace(/,/gi, ""))) {
            fnDefaultAlertFocus("중량은 차량톤수의 110%를 초과하실 수 없습니다.", "Weight", "warning");
            return false;
        }
    }

    if (!$("#SupplyAmt").val()) {
        fnDefaultAlertFocus("운송료를 입력하세요.", "SupplyAmt", "warning");
        return false;
    }

    if (parseInt($("#SupplyAmt").val().replace(/,/gi, "")) < 20000 || parseInt($("#SupplyAmt").val().replace(/,/gi, "")) > 5000000) {
        fnDefaultAlertFocus("운송료는 2만원 ~ 500만원 사이로 입력하세요.", "SupplyAmt", "warning");
        return false;
    }

    if (!$("#Note").val()) {
        fnDefaultAlertFocus("화물 상세 정보를 입력하세요.", "Note", "warning");
        return false;
    }

    strCallType = "Cargopass" + $("#HidMode").val();
    strConfMsg = "카고패스 연동" + ($("#HidMode").val() === "Update" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsCargopassProc", fnParam);
    return false;
}

function fnInsCargopassProc(fnParam) {
    var strHandlerURL = "/TMS/Common/Proc/OrderCargopassHandler.ashx";
    var strCallBackFunc = "fnInsCargopassSuccResult";

    var objParam = {
        CallType: fnParam,
        CargopassOrderNo: $("#CargopassOrderNo").val(),
        OrderNos: $("#OrderNos").val(),
        CenterCode: $("#CenterCode").val(),
        CenterName: $("#CenterCode option:selected").text(),
        DispatchType: $("#DispatchType").val(),
        ConsignorName: $("#ConsignorName").val(),
        TelNo: $("#TelNo").val(),
        PickupYMD: $("#PickupYMD").val(),
        PickupHM: $("#PickupHM").val(),
        PickupAddr: $("#PickupAddr").val(),
        PickupAddrDtl: $("#PickupAddrDtl").val(),
        PickupWay: $("#PickupWay").val(),
        GetYMD: $("#GetYMD").val(),
        GetHM: $("#GetHM").val(),
        GetPlace: $("#GetPlace").val(),
        GetAddr: $("#GetAddr").val(),
        GetAddrDtl: $("#GetAddrDtl").val(),
        GetTelNo: $("#GetTelNo").val(),
        GetWay: $("#GetWay").val(),
        CarTon: $("#CarTon option:selected").text(),
        CarTruck: $("#CarTruck option:selected").text(),
        Volume: $("#Volume").val(),
        CBM: $("#CBM").val(),
        Weight: $("#Weight").val(),
        SupplyAmt: $("#SupplyAmt").val(),
        QuickType: $("input[name$='QuickType']:checked").val(),
        PayPlanYMD: $("#PayPlanYMD").val(),
        LayerFlag: $("#LayerFlag").is(":checked") ? "Y" : "N",
        UrgentFlag: $("#UrgentFlag").is(":checked") ? "Y" : "N",
        ShuttleFlag: $("#ShuttleFlag").is(":checked") ? "Y" : "N",
        Note: $("#Note").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnInsCargopassSuccResult(objRes) {
    if (objRes[0].RetCode !== 0) {
        if (objRes[0].CargopassOrderNo != "" && objRes[0].CargopassOrderNo != "0") {
            $("#CargopassOrderNo").val(objRes[0].CargopassOrderNo);
            fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")", "warning", "fnOrderReload();");
            return false;
        } else {
            fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")", "warning", "fnWindowClose();");
            return false;
        }
    }

    if ($("#HidMode").val() === "Insert") {
        $("#CargopassOrderNo").val(objRes[0].CargopassOrderNo);

        if ($("#InsCallback").val()) {
            opener.fnCargopassInsCallback(objRes[0].CargopassOrderNo);
        }
    }

    fnOpenCargopassInsPost(objRes[0].InsUrl, objRes[0].SessionKey, objRes[0].EncSession, objRes[0].OrderInfo);

    if ($("#HidMode").val() === "Insert") {
        fnOrderReload();
    } else {
        fnCallCargopassDetail();
    }
    return false;
}

function fnOrderReload() {
    document.location.replace("/TMS/Common/OrderCargopassIns?CenterCode=" + $("#CenterCode").val() + "&CargopassOrderNo=" + $("#CargopassOrderNo").val());
    return false;
}

function fnOpenCargopassInsPost(strUrl, strSessionKey, strEncSession, strOrderInfo) {
    var newForm = $("<form></form>");
    newForm.attr("method", "post");
    newForm.attr("action", strUrl);
    newForm.attr("target", "CargopassIns");

    newForm.append($("<input/>", { type: "hidden", name: "SessionKey", value: strSessionKey}));
    newForm.append($("<input/>", { type: "hidden", name: "EncSession", value: strEncSession}));
    newForm.append($("<input/>", { type: "hidden", name: "OrderInfo", value: strOrderInfo}));

    // 새 창에서 폼을 열기
    window.open("", "CargopassIns", "width=1700, height=822, scrollbars=Yes");
    newForm.appendTo("body");
    newForm.submit();
    newForm.remove();
}

//주소 검색 팝업형태
function fnOpenCargopassAddress(type) {

    var strQueryStr = "";
    if ($("#" + type + "Search").length > 0) {
        strQueryStr = $("#" + type + "Search").val();
    }

    var objOpenParam = {
        q: strQueryStr
    };

    new daum.Postcode({
        oncomplete: function (data) {
            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ""; // 주소 변수
            var extraAddr = ""; // 참고항목 변수
            var post = data.zonecode;
            var sido = "";
            var sigungu = "";
            var dong = "";

            addr = data.sido;
            addr += data.sigungu == "" ? "" : (" " + data.sigungu);
            addr += data.bname1 == "" ? "" : (" " + data.bname1);

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if (data.userSelectedType === "R") {
                addr += data.roadname == "" ? "" : (" " + data.roadname);
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }

                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== "") {
                    extraAddr += (extraAddr !== "" ? ", " + data.buildingName : data.buildingName);
                }

                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraAddr !== "") {
                    extraAddr = " (" + extraAddr + ")";
                }

                extraAddr = data.roadAddress.replace(addr + " ", "") + extraAddr;

            } else {
                addr += data.bname == "" ? "" : (" " + data.bname);
                extraAddr = data.jibunAddress.replace(addr + " ", "") + extraAddr;
            }

            sido = fnGetShortSido(data.sido);
            sigungu = data.sigungu;
            dong = data.bname1;
            if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                dong += dong === "" ? data.bname2 : (" " + data.bname2);
            }

            fnSetCargopassAddress(type, post, addr, extraAddr, sido, sigungu, dong);
        }
    }).open(objOpenParam);
}

function fnSetCargopassAddress(type, post, addr, addrDtl, sido, sigungu, dong) {
    var strFullAddr = "";

    strFullAddr = sido;
    if (sigungu != "") {
        strFullAddr += " " + sigungu;
    }
    if (dong != "") {
        strFullAddr += " " + dong;
    }

    if ($("#" + type + "Addr").length > 0) {
        $("#" + type + "Addr").val(strFullAddr);
    }

    if ($("#" + type + "AddrDtl").length > 0) {
        $("#" + type + "AddrDtl").val(addrDtl);
    }

    if ($("#" + type + "Search").length > 0) {
        $("#" + type + "Search").val("");
    }
}

function fnWindowClose() {
    window.close();
    return false;
}

//연동보기
function fnViewCargopass() {
    var strHandlerURL = "/TMS/Common/Proc/OrderCargopassHandler.ashx";
    var strCallBackFunc = "fnViewCargopassSuccResult";
    var strFailCallBackFunc = "fnViewCargopassFailResult";

    var objParam = {
        CallType: "CargopassSessionView",
        CargopassOrderNo: $("#CargopassOrderNo").val(),
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    return false;
}

function fnViewCargopassSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnViewCargopassPost(objRes[0].InsUrl, objRes[0].SessionKey, objRes[0].EncSession, objRes[0].OrderInfo);
            return false;
        } else {
            fnViewCargopassFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnViewCargopassFailResult();
        return false;
    }
}

function fnViewCargopassFailResult(strMsg) {
    strMsg = typeof strMsg === "string" ? strMsg : "";
    fnDefaultAlert("일시적인 오류가 발생하여 이용이 불가능합니다." + (strMsg === "" ? "" : ("(" + strMsg + ")")), "warning");
    return false;
}

function fnViewCargopassPost(strUrl, strSessionKey, strEncSession, strOrderInfo) {
    var newForm = $("<form></form>");
    newForm.attr("method", "post");
    newForm.attr("action", strUrl);
    newForm.attr("target", "CargopassIns");

    newForm.append($("<input/>", { type: "hidden", name: "SessionKey", value: strSessionKey }));
    newForm.append($("<input/>", { type: "hidden", name: "EncSession", value: strEncSession }));
    newForm.append($("<input/>", { type: "hidden", name: "OrderInfo", value: strOrderInfo }));

    // 새 창에서 폼을 열기
    window.open("", "CargopassIns", "width=1760, height=760, scrollbars=Yes");
    newForm.appendTo("body");
    newForm.submit();
    newForm.remove();
}

/************************************************************/
//자식창 콜백 처리
/************************************************************/
window.onmessage = function (e) {
    if (e.origin === $("#CargopassDomain").val()) {
        if (e.data.CallBackType) {

            if (e.data.CallBackType === "CargopassWindowResize") { //창 리사이즈
                return false;
            } else if (e.data.CallBackType === "CargopassInsertComplete") { //등록 처리
                fnCallCargopassDetail();
                return false;
            } else if (e.data.CallBackType === "CargopasUpdateComplete") { //수정 처리
                fnCallCargopassDetail();
                return false;
            } else if (e.data.CallBackType === "CargopassCarConfirmComplete") { //배차 확정 처리
                fnCallCargopassDetail();
                return false;
            } else if (e.data.CallBackType === "CargopassCarCancelComplete") { //차량 취소 처리
                fnCallCargopassDetail();
                return false;
            } else if (e.data.CallBackType === "CargopassCancelComplete") { //취소된 오더 처리
                fnCnlCallBack();
                return false;
            }
        }
    }
}

//opener에서 연동 취소 처리했을때 콜백
function fnCnlCallBack() {
    fnDefaultAlert("카고패스 연동이 취소되었습니다.", "warning", "fnWindowClose()");
    return false;
}
/************************************************************/