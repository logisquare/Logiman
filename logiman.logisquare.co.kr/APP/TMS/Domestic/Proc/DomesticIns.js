var strCenterCode = "";
var strGoodsDispatchType = "";
var strPayType = "";
var strSaleClosingFlag = "N";
var strPurchaseClosingFlag = "N";
/*리스트 파라미터*/
var strListDataParam = "";
$(document).ready(function () {
    /*리스트 파라미터*/
    var strListData = $("#HidParam").val();
    strListDataParam = strListData.replace(/:/g, "=").replace(/,/g, "&").replace(/{/g, "").replace(/}/g, "");

    //상차일 변경
    $("#PickupYMD").on("change", function (e) {

        var dateFromText = $(this).val();

        var GetYMDText = $("#GetYMD").val().replace(/-/gi, "");
        if (GetYMDText.length !== 8) {
            GetYMDText = GetDateToday("");
        }

        if (parseInt(dateFromText.replace(/-/gi, "")) > parseInt(GetYMDText)) {
            $("#GetYMD").val(dateFromText);
        }

        //자동운임 변경 체크
        fnChangeRateChk();
        return false;
    });

    //하차일 변경
    $("#GetYMD").on("change", function (e) {
        //자동운임 변경 체크
        fnChangeRateChk();
        return false;
    });

    //오더등록
    $("#BtnRegOrder").on("click", function (e) {
        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 수정하실 수 없습니다.");
            return false;
        }
        fnChkSaleLimit(); //한도 및 원가율 계산
        return false;
    });

    //화주 검색
    $("#ConsignorName").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(1);
        return false;
    });

    //발주처 검색
    $("#OrderClientName").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(2);
        return false;
    });

    //발주처 담당자 검색
    $("#BtnSearchOrderClientCharge").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(3);
        return false;
    });

    //청구처 검색
    $("#PayClientName").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(4);
        return false;
    });

    //청구처 담당자 검색
    $("#BtnSearchPayClientChargeName").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(5);
        return false;
    });

    //상차지 검색
    $("#BtnSearchPickupPlace").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(6);
        return false;
    });

    //상차지 담당자 검색
    $("#BtnSearchPickupPlaceChargeName").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(7);
        return false;
    });

    //상차지 주소 검색
    $("#BtnSearchAddrPickupPlace").on("click", function (e) {
        e.preventDefault();
        fnOpenAddress("PickupPlace");
        return false;
    });

    //하차지 검색
    $("#BtnSearchGetPlace").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(8);
        return false;
    });

    //하차지 담당자 검색
    $("#BtnSearchGetPlaceChargeName").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(9);
        return false;
    });

    //하차지 주소 검색
    $("#BtnSearchAddrGetPlace").on("click", function (e) {
        e.preventDefault();
        fnOpenAddress("GetPlace");
        return false;
    });

    //화주, 발주처, 청구처 등 검색 버튼
    $("#BtnSearchInfo").on("click", function (e) {
        e.preventDefault();
        fnGetSearchInfo();
        return false;
    });

    $("#SearchText").on("keyup", function (e) {
        if (e.keyCode === 13) {
            fnGetSearchInfo();
        }
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

    //비용등록 업체명 검색
    $("#ClientName").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(10);
        return false;
    });

    //배차취소
    $("#BtnResetDispatch").on("click", function (e) {
        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 배차취소하실 수 없습니다.");
            return false;
        }

        if ($("#ContractType").val() === "2" && $("#ContractStatus").val() === "2") {
            fnDefaultAlert("위탁한 오더는 배차 취소하실 수 없습니다.");
            return false;
        }

        //매입비용 체크
        var PayChk = false;
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if (typeof item.DispatchInfo !== "undefined") {
                        if (item.DispatchInfo !== null && item.DispatchInfo !== "" && item.ClosingFlag == "Y" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1) {
                            PayChk = true;
                            return false;
                        }
                    }
                });

            if (PayChk) {
                fnDefaultAlert("이미 마감되었거나 계산서가 발행된 차량 비용정보가 등록되어 있어 변경이 불가능합니다.", "warning");
                return false;
            }
        }

        $("#Sec5 input").val("");
        $("#TbodyDispatchInfo").html("");
        $(".DispatchType2Reg").show();
        $(".DispatchType2Upd").hide();
        return false;
    });

    //자동운임
    $("#BtnCallTransRate").on("click", function () {
        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 사용하실 수 없습니다.");
            return false;
        }

        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 사용하실 수 없습니다.");
            return false;
        }

        fnCallTransRate();
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

    //경유지 체크
    $("#LayoverFlag").on("click", function () {
        $("#SamePlaceCount").val("");
        $("#NonSamePlaceCount").val("");

        if ($(this).is(":checked")) {
            $("#SamePlaceCount").removeAttr("readonly");
            $("#NonSamePlaceCount").removeAttr("readonly");
            $("#SamePlaceCount").focus();
        } else {
            $("#SamePlaceCount").attr("readonly", "readonly");
            $("#NonSamePlaceCount").attr("readonly", "readonly");
        }

        //자동운임 변경 체크
        fnChangeRateChk();
    });

    //비용
    //추가
    $("#BtnAddPay").on("click", function (e) {
        if ($("#TransType").val() === "3" && $("#PayType").val() === "2") {
            fnDefaultAlert("이관받은 오더는 매입을 등록 하실 수 없습니다.");
            return false;
        }

        if ($("#ContractType").val() === "3" && $("#PayType").val() === "1") {
            fnDefaultAlert("수탁 오더는 매출을 등록 하실 수 없습니다.");
            return false;
        }

        fnPayAddRow();
        return false;
    });

    //수정
    $("#BtnUpdPay").on("click", function (e) {
        if ($("#TransType").val() === "3" && $("#PayType").val() === "2") {
            fnDefaultAlert("이관받은 오더는 매입을 수정하실 수 없습니다.");
            return false;
        }

        if ($("#ContractType").val() === "3" && $("#PayType").val() === "1") {
            fnDefaultAlert("수탁 오더는 매출을 수정하실 수 없습니다.");
            return false;
        }

        fnPayUpdRow();
        return false;
    });

    //삭제
    $("#BtnDelPay").on("click", function (e) {
        if ($("#TransType").val() === "3" && $("#PayType").val() === "2") {
            fnDefaultAlert("이관받은 오더는 매입을 삭제 하실 수 없습니다.");
            return false;
        }

        if ($("#ContractType").val() === "3" && $("#PayType").val() === "1") {
            fnDefaultAlert("수탁 오더는 매출을 삭제 하실 수 없습니다.");
            return false;
        }

        fnPayDelRow();
        return false;
    });

    //다시입력
    $("#BtnResetPay").on("click", function (e) {
        fnResetPay();
        return false;
    });

    //비용등록
    $("#BtnSetPay").on("click", function (e) {
        fnClosePay();
        return false;
    });


    /**
     * 폼 이벤트
     */
    //회원사
    $("#CenterCode").on("focusin", function () {
        strCenterCode = $(this).val();
    }).on("change", function () {

        var chkForm = false;
        //발주처, 청구처, 화주 체크
        $.each($("#Sec1 input"), function (index, item) {
            if ($(item).val()) {
                chkForm = true;
                return false;
            }
        });
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            chkForm = true;
        }

        //발주처, 청구처, 화주, 사업장, 비용항목 리셋
        if ($(this).val() !== strCenterCode) {
            if (chkForm) {
                fnDefaultConfirm("회원사를 변경하면 일부 정보가 삭제됩니다. 변경 하시겠습니까?", "fnSetCenterChange", "0", "fnSetCenterChange", "1");
            } else {
                fnSetCenterChange(0);
            }
        }
    }).on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    //배차구분
    $("#GoodsDispatchType").on("focusin", function () {
        strGoodsDispatchType = $(this).val();
    }).on("change", function () {
        var msg = "";
        if (strGoodsDispatchType !== $(this).val()) {
            //매입비용 체크
            var PayChk = false;
            if (AUIGrid.getGridData(GridPayID).length > 0) {
                $.each(AUIGrid.getGridData(GridPayID),
                    function (index, item) {
                        if (typeof item.DispatchInfo !== "undefined") {
                            if (item.DispatchInfo !== null && item.DispatchInfo !== "") {
                                PayChk = true;
                                return false;
                            }
                        }
                    });

                if (PayChk) {
                    fnDefaultAlert("이미 차량 비용정보가 등록되어 있어 변경이 불가능합니다.", "warning");
                    $(this).val(strGoodsDispatchType);
                    return false;
                }
            }

            //배차 체크
            if (strGoodsDispatchType === "2" && $("#RefSeqNo").val() !== "0" && $("#RefSeqNo").val() !== "") {
                $(this).val(strGoodsDispatchType);
                fnDefaultAlert("이미 배차된 차량이 있어 변경이 불가능합니다.", "warning");
                return false;
            }

            if (strGoodsDispatchType === "3" && $("#TbodyDispatchInfo tr").length > 0) {
                $(this).val(strGoodsDispatchType);
                fnDefaultAlert("이미 배차된 차량이 있어 변경이 불가능합니다.", "warning");
                return false;
            }

            if ($(this).val() == "2") {
                msg = "직송 배차 오더로 변경하시겠습니까?";
            } else if ($(this).val() == "3") {
                msg = "집하 배차 오더로 변경하시겠습니까?<br>집하로 변경하면 배차는 [배차관리 > 집하배차] 메뉴에서 가능합니다.<br>집하 사업장이 추가됩니다.";
            }

            fnDefaultConfirm(msg, "fnSetGoodsDispatchType", $(this).val(), "fnSetGoodsDispatchType", strGoodsDispatchType);
        }
    }).on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#OrderLocationCode").on("blur",
        function () {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#PickupHM").on("blur",
        function () {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#GetHM").on("blur",
        function () {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#CarTonCode").on("blur",
        function () {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#CarTypeCode").on("blur",
        function () {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#Volume").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#Weight").focus();
            }
        }).on("blur",
            function (event) {
                //자동운임 변경 체크
                fnChangeRateChk();
            });

    $("#Weight").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#CBM").focus();
            }
        }).on("blur",
            function (event) {
                //자동운임 변경 체크
                fnChangeRateChk();
            });

    $("#CBM").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#Length").focus();
            }
        }).on("blur",
            function (event) {
                //자동운임 변경 체크
                fnChangeRateChk();
            });

    $("#Length").on("blur",
        function (event) {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#FTLFlag").on("blur",
        function (e) {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#GoodsRunType").on("blur",
        function (e) {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#CarFixedFlag").on("blur",
        function (e) {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#LayoverFlag").on("blur",
        function (e) {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#SamePlaceCount").on("blur",
        function (event) {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#NonSamePlaceCount").on("blur",
        function (event) {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#PayType").on("focusin",
        function (e) {
            strPayType = $(this).val();
        }).on("change",
        function (e) {
            fnSetPay();
        });

    $("#TaxKind").on("change",
        function (e) {
            fnCalcTax($("#SupplyAmt").val(), "TaxAmt", "TaxKind");
        });

    $("#SupplyAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            if ($("#PayType").val() == "1" || $("#PayType").val() == "2") {
                fnCalcTax($(this).val(), "TaxAmt", "TaxKind");
            }

            if (event.type === "keyup" && event.keyCode === 13) {
                if ($("#BtnUpdPay").css("display") === "none") {
                    $("#BtnAddPay").click();
                } else {
                    $("#BtnUpdPay").click();
                }
                return;
            }
        });

    $("#TaxAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            if (event.type === "keyup" && event.keyCode === 13) {
                if ($("#BtnUpdPay").css("display") === "none") {
                    $("#BtnAddPay").click();
                } else {
                    $("#BtnUpdPay").click();
                }
                return;
            }
        });

    //자동운임 요청
    $("#ReqSaleSupplyAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            fnCalcTax($(this).val(), "ReqSaleTaxAmt", "ReqTaxKind");
        });

    $("#ReqSaleTaxAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
        });

    $("#ReqPurchaseSupplyAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            fnCalcTax($(this).val(), "ReqPurchaseTaxAmt", "ReqTaxKind");
        });

    $("#ReqPurchaseTaxAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
        });

    //기본 설정 값
    fnSetPay();
    fnSetInitData();
});

//기본정보 세팅
function fnSetInitData() {
    $("#PopMastertitle").text("내수 오더등록");

    fnChangeDate("1", "PickupYMD");
    fnChangeDate("1", "GetYMD");

    $("#GoodsDispatchType option:first-child").prop("disabled", true);

    if ($("#HidMode").val() === "Update" || ($("#HidMode").val() === "Insert" && $("#CopyFlag").val() === "Y")) {
        fnCallOrderDetail();
    }
}

//상단 바로가기
function fnPositionMove(node) {
    var height = $(node).offset();
    var header = $(".header").height();
    var tab = $(".tab_btn").height();
    var total = header + tab + header;

    $("html, body").animate({ scrollTop: height.top - total }, 400);
}

//회원사 변경 세팅
function fnSetCenterChange(intType) {
    if (intType === 0) {
        $("#Sec1 input").val("");
        AUIGrid.setGridData(GridPayID, []);
        fnSetCodeList();
    } else {
        $("#CenterCode").val(strCenterCode);
    }
}

//사업장, 비용항목 리셋
function fnSetCodeList() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnAjaxSetCodeList";

    var objParam = {
        CallType: "DomesticCodeList",
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
}

function fnAjaxSetCodeList(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
        return false;
    } else {
        $("#OrderLocationCode option").remove();
        $("#OrderLocationCode").append("<option value=''>사업장</option>");
        $.each(objRes[0].LocationCode, function (index, item) {
            $("#OrderLocationCode").append("<option value=\"" + item.ItemFullCode + "\">" + item.ItemName + "</option>");
        });

        $("#ItemCode option").remove();
        $("#ItemCode").append("<option value=''>비용항목</option>");
        $.each(objRes[0].PayItemCode, function (index, item) {
            $("#ItemCode").append("<option value=\"" + item.ItemFullCode + "\">" + item.ItemName + "</option>");
        });

        fnSetPay();
    }
}

//배차 구분 변경
function fnSetGoodsDispatchType(strType) {
    $("#GoodsDispatchType").val(strType);
    $(".DispatchType2").hide();
    $(".DispatchType3").hide();
    if ($(".DispatchType" + strType).length > 0) {
        $(".DispatchType" + strType).show();
    }

    if (strType === "2") {
        $("#OrderLocationCode").val("");
    }
}

//오더 데이터 세팅
function fnCallOrderDetail() {

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnOrderDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "DomesticList",
        OrderNo: $("#OrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnOrderDetailSuccResult(objRes) {
    if (objRes) {
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
        $.each($("input[type='hidden']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }

                if ($(input).attr("id").substr(0, 3) === "Hid") {
                    if (eval("item." + $(input).attr("id").substr(3, $(input).attr("id").length - 3)) != null) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id").substr(3, $(input).attr("id").length - 3)));
                    }
                }
            });

        $("#OldPickupPlaceFullAddr").val(item.PickupPlaceFullAddr);
        $("#OldGetPlaceFullAddr").val(item.GetPlaceFullAddr);

        //Textbox
        $.each($("input[type='text']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //Date
        $.each($("input[type='date']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if (eval("item." + $(input).attr("id")).length == 8) {
                        $("#" + $(input).attr("id")).val(fnGetStrDateFormat(eval("item." + $(input).attr("id")), "-"));
                    } else {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });

        //Textarea
        $.each($("textarea"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //Select
        $("#CenterCode").val(item.CenterCode);
        $("#CenterCode option:not(:selected)").prop("disabled", true);
        fnSetCodeList();
        $.each($("select"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id")) + "']").length > 0) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });

        //Checkbox
        $("#LayoverFlag").prop("checked", item.LayoverFlag === "Y");
        $("#SamePlaceCount").attr("readonly", "readonly");
        $("#NonSamePlaceCount").attr("readonly", "readonly");
        if (item.LayoverFlag === "Y") {
            $("#SamePlaceCount").removeAttr("readonly");
            $("#NonSamePlaceCount").removeAttr("readonly");
        }

        //RadioButton

        //Span
        $(".DispatchType2").hide();
        $(".DispatchType3").hide();
        $(".DispatchType2Reg").hide();
        $(".DispatchType2Upd").hide();

        if (item.GoodsDispatchType === 2) {

            if ($("#CopyFlag").val() === "Y") {
                $("#DispatchSeqNo").val("");
                $("#RefSeqNo").val("");
            } else {
                $(".DispatchType2Reg").show();
                $(".DispatchType2Upd").hide();
                $("#DispatchSeqNo").val(item.DispatchSeqNo1);
                $("#RefSeqNo").val(item.DispatchRefSeqNo1);
            }

            $(".DispatchType2").show();
        } else {
            $("#DispatchSeqNo").val("");
            $("#RefSeqNo").val("");
            $(".DispatchType3").show();
        }

        $("#DivTransPay").hide();
        $("#DivTrans").hide();
        $("#DivContract").hide();
        
        if ($("#CopyFlag").val() !== "Y") {            
            if (item.GoodsDispatchType === 2) {
                if (item.TransType === 2 || item.TransType === 3) {
                    $(".NotAllowedTrans").show();
                    $("#DivTrans").show();
                    $("#GoodsDispatchType option:not(:selected)").prop("disabled", true);
                    $("#TransInfo").html((item.TransInfo + "").indexOf("▶") > 0 ? item.TransInfo.replace("▶", "<br />▶") : item.TransInfo);
                   
                    if (item.TransType == 2) {
                        $("#DivTransPay").show();
                        $(".NotAllowedTrans").hide();
                        //비용 목록 조회
                        fnCallTransPayData();
                    }
                }

                if (item.ContractType === 2) {
                    $("#ContractInfo").html((item.ContractInfo + "").indexOf("▶") > 0 ? item.ContractInfo.replace("▶", "<br />▶") : item.ContractInfo);
                    if (item.ContractStatus === 2) {
                        $(".NotAllowedContract").show();
                        $("#GoodsDispatchType option:not(:selected)").prop("disabled", true);
                    } else {
                        $("#ContractInfo").html("위탁취소 : " + $("#ContractInfo").html());
                    }

                    $("#DivContract").show();
                } else if (item.ContractType === 3) {
                    $(".NotAllowedContractTarget").show();
                    $("#ContractInfo").html((item.ContractInfo + "").indexOf("▶") > 0 ? item.ContractInfo.replace("▶", "<br />▶") : item.ContractInfo);
                    $("#GoodsDispatchType option:not(:selected)").prop("disabled", true);
                    $("#DivContract").show();
                }
            }
        }

        if ($("#CopyFlag").val() === "Y") {
            $("#HidMode").val("Insert");
            $("#CopyFlag").val("N");
            $("#CnlFlag").val("N");
            $("#OrderNo").val("");
            $("#NetworkNo").val("");
            $("#TransType").val("");
            $("#ContractType").val("");
            $("#ContractStatus").val("");
            $("#DispatchRefSeqNo1").val("");
            fnChangeDate("1", "PickupYMD");
            fnChangeDate("1", "GetYMD");
            $("#Sec4 input").val("");
            $("#Sec4 select").val("");
            $("#FTLFlag").val("Y");
            $("#GoodsRunType").val("1");
            $("#CarFixedFlag").val("Y");
            $("#LayoverFlag").prop("checked", false);
            $("#SamePlaceCount").attr("readonly", "readonly");
            $("#NonSamePlaceCount").attr("readonly", "readonly");
            $("#SamePlaceCount").val("");
            $("#NonSamePlaceCount").val("");
            $("#NoteInside").val("");
            $("#NoteClient").val("");
            $("#HidCenterCode").val("");
            $("#HidGoodsDispatchType").val("");
            $("#HidOrderLocationCode").val("");
            $("#HidPayClientCode").val("");
            $("#HidConsignorCode").val("");
            $("#HidPickupYMD").val("");
            $("#HidPickupHM").val("");
            $("#HidPickupPlaceFullAddr").val("");
            $("#HidGetYMD").val("");
            $("#HidGetHM").val("");
            $("#HidGetPlaceFullAddr").val("");
            $("#HidCarTonCode").val("");
            $("#HidCarTypeCode").val("");
            $("#HidVolume").val("");
            $("#HidWeight").val("");
            $("#HidCBM").val("");
            $("#HidLength").val("");
            $("#HidFTLFlag").val("");
            $("#HidGoodsRunType").val("");
            $("#HidCarFixedFlag").val("");
            $("#HidLayoverFlag").val("");
            $("#HidSamePlaceCount").val("");
            $("#HidNonSamePlaceCount").val("");
            fnSetGoodsDispatchType("2");
            return false;
        }

        if ($("#CnlFlag").val() === "Y") {
            $("#BtnRegOrder").hide();
            $("#BtnCancelOrder").hide();
        }

        $("#SamePlaceCount").val($("#SamePlaceCount").val() === "0" ? "" : $("#SamePlaceCount").val());
        $("#NonSamePlaceCount").val($("#NonSamePlaceCount").val() === "0" ? "" : $("#NonSamePlaceCount").val());

        $("#BtnCallTransRate").show();
        $(".TrUpdRequestAmt").hide();
        $("#BtnUpdRequestAmt").hide();

        var strTransRateInfo = item.TransRateInfo;
        strTransRateInfo = typeof strTransRateInfo === "undefined" ? "" : strTransRateInfo;

        if (strTransRateInfo.indexOf("Y") === 0) {
            //요율표 조회
            fnCallTransRateData();
        }

        //비용 목록 조회
        fnCallPayGridData(GridPayID);

        //배차 목록 조회
        fnCallDispatchData();
    }
    else {
        fnCallDetailFailResult();
    }
}

function fnCallDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

// 배차 목록
function fnCallDispatchData() {
    if (!$("#OrderNo").val() || !$("#CenterCode").val() || !$("#GoodsSeqNo").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallDispatchSuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "DomesticDispatchCarList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
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
            if ($("#GoodsDispatchType").val() === "2") {
                var item = objRes[0].data.list[0];
                html += "<tr class=\"center\">\n";
                html += "\t<td>" + item.DispatchTypeM + "</td>\n";
                html += "\t<td class=\"left\">" + item.DispatchCarInfo + "</td>\n";
                html += "</tr>\n";

                $(".DispatchType2Reg").hide();
                $(".DispatchType2Upd").show();

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

/******************************************/
//업체 등 검색
/******************************************/
function fnOpenSearchInfo(intType) {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var strTitle = "";
    switch (intType) {
        case 1: //화주
            strTitle = "화주 검색";
            break;
        case 2: //발주처
            strTitle = "발주처 검색";
            break;
        case 3: //발주처담당자
            strTitle = "발주처 담당자 검색";
            break;
        case 4: //청구처
            strTitle = "청구처 검색";
            break;
        case 5: //청구처담당자
            strTitle = "청구처 담당자 검색";
            break;
        case 6: //상차지
            strTitle = "상차지 검색";
            break;
        case 7: //상차지 담당자
            strTitle = "상차지 담당자 검색";
            break;
        case 8: //하차지
            strTitle = "하차지 검색";
            break;
        case 9: //하차지 담당자
            strTitle = "하차지 담당자 검색";
            break;
        case 10: //매입,선급금,예수금 업체
            strTitle = "업체 검색";
            break;
        default:
            fnDefaultAlert("올바르지 않은 접근입니다.");
            return false;
    }

    $("#HidSearchInfoType").val(intType);
    $("#SearchInfoLayer strong").text(strTitle);
    $("#SearchInfoLayer").show();
    $("#SearchText").focus();
}

function fnGetSearchInfo() {
    var strType = $("#HidSearchInfoType").val();
    if (!strType) {
        return false;
    }

    var strSearchText = $("#SearchText").val();
    if (strSearchText.trim().length < 2) {
        fnDefaultAlert("검색어를 2자이상 입력하세요.", "warning", "$(\"#SearchText\").focus();");
        return false;
    }

    switch (strType) {
        case "1": //화주
            fnGetSearchInfoConsignor();
            break;
        case "2": //발주처
            fnGetSearchInfoClient(2);
            break;
        case "3": //발주처담당자
            fnGetSearchInfoClientCharge(3);
            break;
        case "4": //청구처
            fnGetSearchInfoClient(4);
            break;
        case "5": //청구처담당자
            fnGetSearchInfoClientCharge(5);
            break;
        case "6": //상차지
            fnGetSearchInfoPlace(6);
            break;
        case "7": //상차지 담당자
            fnGetSearchInfoPlaceCharge(7);
            break;
        case "8": //하차지
            fnGetSearchInfoPlace(8);
            break;
        case "9": //하차지 담당자
            fnGetSearchInfoPlaceCharge(9);
            break;
        case "10": //매입,선급금,예수금 업체
            fnGetSearchInfoClient(10);
            break;
        default:
            fnDefaultAlert("올바르지 않은 접근입니다.");
            return false;
    }
}

//화주
function fnGetSearchInfoConsignor() {
    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnGetSearchInfoConsignorResult";
    var strFailCallBackFunc = "fnCallSearchInfoFailResult";

    var objParam = {
        CallType: "ConsignorMapList",
        CenterCode: $("#CenterCode").val(),
        ConsignorName: $("#SearchText").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnGetSearchInfoConsignorResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSearchInfoFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnDefaultAlert("검색된 화주가 없습니다.", "error");
            return false;
        }

        var html = "";
        $.each(objRes[0].data.list, function(index, item) {
            html += "<li>\n";
            html += "\t<input type=\"radio\" id=\"SearchChk" + index + "\" name=\"SearchChk\" />\n";
            html += "\t<label for=\"SearchChk" + index + "\">\n";
            html += "\t\t<strong>" + item.ConsignorInfo + "</strong>\n";
            html += "\t\t<span class=\"data\" data-field=\"ConsignorCode\">" + item.ConsignorCode + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ConsignorName\">" + item.ConsignorName + "</span>\n";

            if (item.OrderClientCode != 0) {
                html += "\t\t<span class=\"d_text\">" + item.OrderClientInfo + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"OrderClientCode\">" + item.OrderClientCode + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"OrderClientName\">" + item.OrderClientName + "</span>\n";
            }

            if (item.PayClientCode != 0) {
                html += "\t\t<span class=\"d_text\">" + item.PayClientInfo + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PayClientCode\">" + item.PayClientCode + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PayClientName\">" + item.PayClientName + "</span>\n";
            }

            if (item.PickupPlaceSeqNo != 0) {
                html += "\t\t<span class=\"d_text\">" + item.PickupPlaceInfo + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PickupPlaceSeqNo\">" + item.PickupPlaceSeqNo + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PickupPlace\">" + item.PickupPlaceName + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PickupPlacePost\">" + item.PickupPlacePost + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PickupPlaceAddr\">" + item.PickupPlaceAddr + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PickupPlaceAddrDtl\">" + item.PickupPlaceAddrDtl + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PickupPlaceFullAddr\">" + item.PickupFullAddr + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PickupPlaceLocalCode\">" + item.PickupLocalCode + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PickupPlaceLocalName\">" + item.PickupLocalName + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"PickupPlaceRemark\">" + item.PickupPlaceRemark + "</span>\n";
            }

            if (item.GetPlaceSeqNo != 0) {
                html += "\t\t<span class=\"d_text\">" + item.GetPlaceInfo + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"GetPlaceSeqNo\">" + item.GetPlaceSeqNo + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"GetPlace\">" + item.GetPlaceName + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"GetPlacePost\">" + item.GetPlacePost + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"GetPlaceAddr\">" + item.GetPlaceAddr + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"GetPlaceAddrDtl\">" + item.GetPlaceAddrDtl + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"GetPlaceFullAddr\">" + item.GetFullAddr + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"GetPlaceLocalCode\">" + item.GetLocalCode + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"GetPlaceLocalName\">" + item.GetLocalName + "</span>\n";
                html += "\t\t<span class=\"data\" data-field=\"GetPlaceRemark\">" + item.GetPlaceRemark + "</span>\n";
            }

            html += "\t\t<span class=\"check_icon\"></span>";
            html += "\t</label>";
            html += "</li>";
        });

        $("#SearchInfoLayer .info_list").html(html);
    }
}

//발주처, 청구처, 매입/선급금 업체 
function fnGetSearchInfoClient(intType) {
    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnGetSearchInfoClientResult";
    var strFailCallBackFunc = "fnCallSearchInfoFailResult";

    var objParam = {
        CallType: "ClientList",
        CenterCode: $("#CenterCode").val(),
        ClientName: $("#SearchText").val(),
        ClientFlag: intType === 4 || intType === 10 ? "Y" : "",
        ChargeFlag: intType === 4 ? "Y" : ""
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnGetSearchInfoClientResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSearchInfoFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnDefaultAlert("검색된 고객사가 없습니다.", "error");
            return false;
        }

        var html = "";
        $.each(objRes[0].data.list, function (index, item) {
            html += "<li>\n";
            html += "\t<input type=\"radio\" id=\"SearchChk" + index + "\" name=\"SearchChk\" />\n";
            html += "\t<label for=\"SearchChk" + index + "\">\n";
            html += "\t\t<strong>" + item.ClientName + "</strong>\n";
            html += "\t\t<span class=\"d_text\">" + item.ClientCorpNo + "</span>\n";
            html += "\t\t<span class=\"d_text\">" + item.ClientTaxKindM + " | " + item.ClientStatusM + "</span>\n";
            if (item.ChargeInfo != "") {
                html += "\t\t<span class=\"d_text\">" + item.ChargeInfo.replace(/\//gi, " | ") + "</span>\n";
            }
            html += "\t\t<span class=\"data\" data-field=\"ClientCode\">" + item.ClientCode + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ClientName\">" + item.ClientName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ClientInfo\">" + item.ClientInfo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ClientCorpNo\">" + item.ClientCorpNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeName\">" + item.ChargeName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargePosition\">" + item.ChargePosition + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeTelExtNo\">" + item.ChargeTelExtNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeTelNo\">" + item.ChargeTelNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeCell\">" + item.ChargeCell + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeLocation\">" + item.ChargeLocation + "</span>\n";
            html += "\t\t<span class=\"check_icon\"></span>";
            html += "\t</label>";
            html += "</li>";
        });

        $("#SearchInfoLayer .info_list").html(html);
    }
}

//발주처, 청구처 담당자
function fnGetSearchInfoClientCharge(intType) {

    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnGetSearchInfoClientChargeSuccResult";
    var strFailCallBackFunc = "fnCallSearchInfoFailResult";

    var objParam = {
        CallType: "ClientChargeList",
        CenterCode: $("#CenterCode").val(),
        ChargeName: $("#SearchText").val(),
        ChargePayFlag: intType === 5 ? "Y" : "",
        ClientFlag: intType === 5 ? "Y" : "",
        ChargeFlag: intType === 5 ? "Y" : ""
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnGetSearchInfoClientChargeSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSearchInfoFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnDefaultAlert("검색된 고객사 담당자가 없습니다.", "error");
            return false;
        }

        var html = "";
        $.each(objRes[0].data.list, function (index, item) {
            html += "<li>\n";
            html += "\t<input type=\"radio\" id=\"SearchChk" + index + "\" name=\"SearchChk\" />\n";
            html += "\t<label for=\"SearchChk" + index + "\">\n";
            html += "\t\t<strong>" + item.ChargeInfo + "</strong>\n";
            html += "\t\t<span class=\"d_text\">" + item.ClientName + "</span>\n";
            html += "\t\t<span class=\"d_text\">" + item.ClientCorpNo + "</span>\n";
            html += "\t\t<span class=\"d_text\">" + item.ClientTaxKindM + " | " + item.ClientStatusM + "</span>\n";
            if (item.ChargeInfo != "") {
                html += "\t\t<span class=\"d_text\">" + item.ChargeInfo.replace(/\//gi, " | ") + "</span>\n";
            }
            html += "\t\t<span class=\"data\" data-field=\"ClientCode\">" + item.ClientCode + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ClientName\">" + item.ClientName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ClientInfo\">" + item.ClientInfo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ClientCorpNo\">" + item.ClientCorpNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeName\">" + item.ChargeName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargePosition\">" + item.ChargePosition + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeTelExtNo\">" + item.ChargeTelExtNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeTelNo\">" + item.ChargeTelNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeCell\">" + item.ChargeCell + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeLocation\">" + item.ChargeLocation + "</span>\n";
            html += "\t\t<span class=\"check_icon\"></span>";
            html += "\t</label>";
            html += "</li>";
        });

        $("#SearchInfoLayer .info_list").html(html);
    }
}

//상차지, 하차지
function fnGetSearchInfoPlace(intType) {

    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnGetSearchInfoPlaceSuccResult";
    var strFailCallBackFunc = "fnCallSearchInfoFailResult";

    var objParam = {
        CallType: "PlaceList",
        CenterCode: $("#CenterCode").val(),
        PlaceName: $("#SearchText").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnGetSearchInfoPlaceSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSearchInfoFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnDefaultAlert("검색된 상하차지가 없습니다.", "error");
            return false;
        }

        var html = "";
        $.each(objRes[0].data.list, function (index, item) {
            html += "<li>\n";
            html += "\t<input type=\"radio\" id=\"SearchChk" + index + "\" name=\"SearchChk\" />\n";
            html += "\t<label for=\"SearchChk" + index + "\">\n";
            html += "\t\t<strong>" + item.PlaceName + "</strong>\n";
            html += "\t\t<span class=\"d_text\">" + item.ChargeName + "</span>\n";
            html += "\t\t<span class=\"d_text\">" + item.PlaceAddr + " " + item.PlaceAddrDtl + "</span>\n";
            html += "\t\t<span class=\"d_text\">" + item.PlaceRemark1 + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlaceName\">" + item.PlaceName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeName\">" + item.ChargeName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargePosition\">" + item.ChargePosition + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeTelExtNo\">" + item.ChargeTelExtNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeTelNo\">" + item.ChargeTelNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeCell\">" + item.ChargeCell + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlacePost\">" + item.PlacePost + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlaceAddr\">" + item.PlaceAddr + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlaceAddrDtl\">" + item.PlaceAddrDtl + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"FullAddr\">" + item.FullAddr + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"LocalCode\">" + item.LocalCode + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"LocalName\">" + item.LocalName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlaceRemark1\">" + item.PlaceRemark1.replace(/\n/gi, " ") + "</span>\n";
            html += "\t\t<span class=\"check_icon\"></span>";
            html += "\t</label>";
            html += "</li>";
        });

        $("#SearchInfoLayer .info_list").html(html);
    }
}

//상차지, 하차지 담당자
function fnGetSearchInfoPlaceCharge(intType) {

    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnGetSearchInfoPlaceChargeSuccResult";
    var strFailCallBackFunc = "fnCallSearchInfoFailResult";

    var objParam = {
        CallType: "PlaceChargeList",
        CenterCode: $("#CenterCode").val(),
        PlaceChargeName: $("#SearchText").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);

}

function fnGetSearchInfoPlaceChargeSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSearchInfoFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnDefaultAlert("검색된 상하차지 담당자가 없습니다.", "error");
            return false;
        }

        var html = "";
        $.each(objRes[0].data.list, function (index, item) {
            html += "<li>\n";
            html += "\t<input type=\"radio\" id=\"SearchChk" + index + "\" name=\"SearchChk\" />\n";
            html += "\t<label for=\"SearchChk" + index + "\">\n";
            html += "\t\t<strong>" + item.ChargeName + "</strong>\n";
            html += "\t\t<span class=\"d_text\">" + item.PlaceName + "</span>\n";
            html += "\t\t<span class=\"d_text\">" + item.PlaceAddr + " " + item.PlaceAddrDtl + "</span>\n";
            html += "\t\t<span class=\"d_text\">" + item.PlaceRemark1 + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlaceName\">" + item.PlaceName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeName\">" + item.ChargeName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargePosition\">" + item.ChargePosition + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeTelExtNo\">" + item.ChargeTelExtNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeTelNo\">" + item.ChargeTelNo + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ChargeCell\">" + item.ChargeCell + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlacePost\">" + item.PlacePost + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlaceAddr\">" + item.PlaceAddr + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlaceAddrDtl\">" + item.PlaceAddrDtl + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"FullAddr\">" + item.FullAddr + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"LocalCode\">" + item.LocalCode + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"LocalName\">" + item.LocalName + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"PlaceRemark1\">" + item.PlaceRemark1.replace(/\n/gi, " ") + "</span>\n";
            html += "\t\t<span class=\"check_icon\"></span>";
            html += "\t</label>";
            html += "</li>";
        });

        $("#SearchInfoLayer .info_list").html(html);
    }
}

function fnCallSearchInfoFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error");
    return false;
}

//검색 레이어 닫기
function fnCloseSearchInfo() {
    $("#HidSearchInfoType").val("");
    $("#SearchText").val("");
    $("#SearchInfoLayer .info_list").html("");
    $("#SearchInfoLayer").hide();
    return false;
}

//검색 결과 반영
function fnSetSearchInfo() {
    var strType = $("#HidSearchInfoType").val();
    if (!strType) {
        return false;
    }

    if ($("input:radio[name='SearchChk']:checked").length === 0) {
        fnDefaultAlert("적용할 정보를 선택하세요.", "error");
        return false;
    }

    var objSelectedItem = $("input:radio[name='SearchChk']:checked")[0];
    var objDataList = $("label[for='" + $(objSelectedItem).attr("id") + "'] span.data");
    var objItem = new Object();


    $.each($(objDataList), function (index, item) {
        eval("objItem." + $(item).attr("data-field") + " = \"" + $(item).text() + "\"");
    });

    if (strType === "1") { //화주

        $("#ConsignorCode").val(objItem.ConsignorCode);
        $("#ConsignorName").val(objItem.ConsignorName);

        if (objItem.OrderClientCode !== "0") {
            $("#OrderClientCode").val(objItem.OrderClientCode);
            $("#OrderClientName").val(objItem.OrderClientName);
        }

        if (objItem.PayClientCode !== "0") {
            $("#PayClientCode").val(objItem.PayClientCode);
            $("#PayClientName").val(objItem.PayClientName);
        }

        if (objItem.PickupPlaceSeqNo !== "0") {
            $("#PickupPlaceSeqNo").val(objItem.PickupPlaceSeqNo);
            $("#PickupPlace").val(objItem.PickupPlaceName);
            $("#PickupPlacePost").val(objItem.PickupPlacePost);
            $("#PickupPlaceAddr").val(objItem.PickupPlaceAddr);
            $("#PickupPlaceAddrDtl").val(objItem.PickupPlaceAddrDtl);
            $("#PickupPlaceFullAddr").val(objItem.PickupFullAddr);
            $("#PickupPlaceLocalCode").val(objItem.PickupLocalCode);
            $("#PickupPlaceLocalName").val(objItem.PickupLocalName);
            $("#PickupPlaceNote").val(objItem.PickupPlaceRemark);
        }

        if (objItem.GetPlaceSeqNo !== "0") {
            $("#GetPlaceSeqNo").val(objItem.GetPlaceSeqNo);
            $("#GetPlace").val(objItem.GetPlaceName);
            $("#GetPlacePost").val(objItem.GetPlacePost);
            $("#GetPlaceAddr").val(objItem.GetPlaceAddr);
            $("#GetPlaceAddrDtl").val(objItem.GetPlaceAddrDtl);
            $("#GetPlaceFullAddr").val(objItem.GetFullAddr);
            $("#GetPlaceLocalCode").val(objItem.GetLocalCode);
            $("#GetPlaceLocalName").val(objItem.GetLocalName);
            $("#GetPlaceNote").val(objItem.GetPlaceRemark);
        }

        //자동운임 변경 체크
        fnChangeRateChk();
        fnSetFocus();

    } else if (strType === "2" || strType === "3") { //발주처, 발주처 담당자

        var strOldOrderClientCode = $("#OrderClientCode").val();
        var strOldPayClientCode = $("#PayClientCode").val();

        $("#OrderClientCode").val(objItem.ClientCode);
        $("#OrderClientName").val(objItem.ClientName);
        $("#OrderClientChargeName").val(objItem.ChargeName);
        $("#OrderClientChargePosition").val(objItem.ChargePosition);
        $("#OrderClientChargeTelExtNo").val(objItem.ChargeTelExtNo);
        $("#OrderClientChargeTelNo").val(objItem.ChargeTelNo);
        $("#OrderClientChargeCell").val(objItem.ChargeCell);

        if (!$("#PayClientCode").val() || strOldOrderClientCode == strOldPayClientCode) {
            $("#PayClientCode").val(objItem.ClientCode);
            $("#PayClientInfo").val(objItem.ClientInfo);
            $("#PayClientName").val(objItem.ClientName);
            $("#PayClientCorpNo").val(objItem.ClientCorpNo);
            $("#PayClientChargeName").val(objItem.ChargeName);
            $("#PayClientChargePosition").val(objItem.ChargePosition);
            $("#PayClientChargeTelExtNo").val(objItem.ChargeTelExtNo);
            $("#PayClientChargeTelNo").val(objItem.ChargeTelNo);
            $("#PayClientChargeCell").val(objItem.ChargeCell);
            $("#PayClientChargeLocation").val(objItem.ChargeLocation);
        } else {
            if ($("#PayClientCode").val() ==  objItem.ClientCode &&  objItem.ChargeName != "") {
                $("#PayClientChargeName").val(objItem.ChargeName);
                $("#PayClientChargePosition").val(objItem.ChargePosition);
                $("#PayClientChargeTelExtNo").val(objItem.ChargeTelExtNo);
                $("#PayClientChargeTelNo").val(objItem.ChargeTelNo);
                $("#PayClientChargeCell").val(objItem.ChargeCell);
                $("#PayClientChargeLocation").val(objItem.ChargeLocation);
            }
        }

        //자동운임 변경 체크
        fnChangeRateChk();

        fnSetFocus();

    } else if (strType === "4" || strType === "5") { //청구처, 청구처 담당자

        $("#PayClientCode").val(objItem.ClientCode);
        $("#PayClientInfo").val(objItem.ClientInfo);
        $("#PayClientName").val(objItem.ClientName);
        $("#PayClientCorpNo").val(objItem.ClientCorpNo);
        $("#PayClientChargeName").val(objItem.ChargeName);
        $("#PayClientChargePosition").val(objItem.ChargePosition);
        $("#PayClientChargeTelExtNo").val(objItem.ChargeTelExtNo);
        $("#PayClientChargeTelNo").val(objItem.ChargeTelNo);
        $("#PayClientChargeCell").val(objItem.ChargeCell);
        $("#PayClientChargeLocation").val(objItem.ChargeLocation);

        //자동운임 변경 체크
        fnChangeRateChk();
        fnSetFocus();

    } else if (strType === "6" || strType === "7") { //상차지, 상차지 담당자

        $("#PickupPlace").val(objItem.PlaceName);
        $("#PickupPlaceChargeName").val(objItem.ChargeName);
        $("#PickupPlaceChargePosition").val(objItem.ChargePosition);
        $("#PickupPlaceChargeTelExtNo").val(objItem.ChargeTelExtNo);
        $("#PickupPlaceChargeTelNo").val(objItem.ChargeTelNo);
        $("#PickupPlaceChargeCell").val(objItem.ChargeCell);
        $("#PickupPlacePost").val(objItem.PlacePost);
        $("#PickupPlaceAddr").val(objItem.PlaceAddr);
        $("#PickupPlaceAddrDtl").val(objItem.PlaceAddrDtl);
        $("#PickupPlaceFullAddr").val(objItem.FullAddr);
        $("#PickupPlaceLocalCode").val(objItem.LocalCode);
        $("#PickupPlaceLocalName").val(objItem.LocalName);
        $("#PickupPlaceNote").val(objItem.PlaceRemark1);

        //자동운임 변경 체크
        fnChangeRateChk();
        fnSetFocus();

    } else if (strType === "8" || strType === "9") { //하차지, 하차지 담당자

        $("#GetPlace").val(objItem.PlaceName);
        $("#GetPlaceChargeName").val(objItem.ChargeName);
        $("#GetPlaceChargePosition").val(objItem.ChargePosition);
        $("#GetPlaceChargeTelExtNo").val(objItem.ChargeTelExtNo);
        $("#GetPlaceChargeTelNo").val(objItem.ChargeTelNo);
        $("#GetPlaceChargeCell").val(objItem.ChargeCell);
        $("#GetPlacePost").val(objItem.PlacePost);
        $("#GetPlaceAddr").val(objItem.PlaceAddr);
        $("#GetPlaceAddrDtl").val(objItem.PlaceAddrDtl);
        $("#GetPlaceFullAddr").val(objItem.FullAddr);
        $("#GetPlaceLocalCode").val(objItem.LocalCode);
        $("#GetPlaceLocalName").val(objItem.LocalName);
        $("#GetPlaceNote").val(objItem.PlaceRemark1);

        //자동운임 변경 체크
        fnChangeRateChk();

        fnSetFocus();

    } else if (strType === "10") { //매입,선급금 등 업체

        $("#ClientCode").val(objItem.ClientCode);
        $("#ClientInfo").val(objItem.ClientInfo);
        $("#ClientName").val(objItem.ClientName);

    }

    fnCloseSearchInfo();
    return false;
}

function fnSetFocus() {
    if (!$("#ConsignorCode").val()) {
        $("#ConsignorName").focus();
        return false;
    } else if (!$("#OrderClientCode").val()) {
        $("#OrderClientName").focus();
        return false;
    } else if (!$("#OrderClientChargeName").val()) {
        $("#OrderClientChargeName").focus();
        return false;
    } else if (!$("#OrderClientChargeTelNo").val() && !$("#OrderClientChargeCell").val()) {
        $("#OrderClientChargeTelNo").focus();
        return false;
    } else if (!$("#PayClientCode").val()) {
        $("#PayClientName").focus();
        return false;
    } else if (!$("#PayClientChargeName").val()) {
        $("#PayClientChargeName").focus();
        return false;
    } else if (!$("#PayClientChargeTelNo").val() && !$("#PayClientChargeCell").val()) {
        $("#PayClientChargeTelNo").focus();
        return false;
    } else if (!$("#PickupYMD").val()) {
        $("#PickupYMD").focus();
        return false;
    } else if (!$("#PickupPlace").val()) {
        $("#PickupPlace").focus();
        return false;
    } else if (!$("#PickupPlaceChargeName").val()) {
        $("#PickupPlaceChargeName").focus();
        return false;
    } else if (!$("#PickupPlaceChargeTelNo").val() && !$("#PickupPlaceChargeCell").val()) {
        $("#PickupPlaceChargeTelNo").focus();
        return false;
    } else if (!$("#PickupPlaceAddr").val()) {
        $("#BtnSearchAddrPickupPlace").focus();
        return false;
    } else if (!$("#GetYMD").val()) {
        $("#GetYMD").focus();
        return false;
    } else if (!$("#GetPlace").val()) {
        $("#GetPlace").focus();
        return false;
    } else if (!$("#GetPlaceChargeName").val()) {
        $("#GetPlaceChargeName").focus();
        return false;
    } else if (!$("#GetPlaceChargeTelNo").val() && !$("#GetPlaceChargeCell").val()) {
        $("#GetPlaceChargeTelNo").focus();
        return false;
    } else if (!$("#GetPlaceAddr").val()) {
        $("#BtnSearchAddrGetPlace").focus();
        return false;
    }
}
/******************************************/

/******************************************/
//차량검색
/******************************************/

//차량 검색 열기
function fnOpenDispatchCar() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#GoodsDispatchType").val()) {
        fnDefaultAlertFocus("배차구분을 선택하세요.", "GoodsDispatchType", "warning");
        return false;
    }

    if ($("#GoodsDispatchType").val() !== "2") {
        fnDefaultAlertFocus("직송 배차 오더만 배차가 가능합니다.", "GoodsDispatchType", "warning");
        return false;
    }

    if ($("#ContractType").val() === "2" && $("#ContractStatus").val() === "2") {
        fnDefaultAlert("위탁한 오더는 차량배차가 불가능합니다.", "warning");
        return false;
    }

    var PayChk = false;
    if (AUIGrid.getGridData(GridPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridPayID),
            function (index, item) {
                if (typeof item.DispatchInfo !== "undefined") {
                    if (item.DispatchInfo !== null && item.DispatchInfo !== "" && item.ClosingFlag == "Y" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1) {
                        PayChk = true;
                        return false;
                    }
                }
            });

        if (PayChk) {
            fnDefaultAlert("이미 마감되었거나 계산서가 발행된 차량 비용정보가 등록되어 있어 변경이 불가능합니다.", "warning");
            return false;
        }
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
        CenterCode: $("#CenterCode").val(),
        CarNo: $("#SearchCarNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
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

    var objSelectedItem = $("input:radio[name='DispatchChk']:checked")[0];
    var objDataList = $("label[for='" + $(objSelectedItem).attr("id") + "'] span.data");
    var objItem = new Object();

    $.each($(objDataList), function (index, item) {
        eval("objItem." + $(item).attr("data-field") + " = \"" + $(item).text() + "\"");
    });

    //배차정보 세팅
    $("#RefSeqNo").val(objItem.RefSeqNo);
    $("#DispatchInfo").val(objItem.DispatchInfo);

    var html = "";
    html += "<tr class=\"center\">\n";
    html += "\t<td>직송</td>\n";
    html += "\t<td>" + objItem.DispatchInfo + "</td>\n";
    html += "</tr>\n";

    $("#TbodyDispatchInfo").html(html);
    $(".DispatchType2Reg").hide();
    $(".DispatchType2Upd").show();

    fnCloseDispatchCar();
    return false;
}

//차량 검색 닫기
function fnCloseDispatchCar() {
    $("#SearchCarNo").val("");
    $("#DispatchLayer .dispatch_list").html("");
    $("#DispatchLayer").hide();
    return false;
}

/******************************************/


/*********************************************/
// 비용 그리드
/*********************************************/
var GridPayID = "#AppDomesticPayListGrid";

$(document).ready(function () {
    if ($(GridPayID).length > 0) {
        // 그리드 초기화
        fnPayGridInit();
    }
});

function fnPayGridInit() {
    // 그리드 레이아웃 생성
    fnCreatePayGridLayout(GridPayID, "PaySeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridPayID, "", "", "", "", "", "", "fnPayGridCellClick", "");
}

//기본 레이아웃 세팅
function fnCreatePayGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 40; // 헤더 높이 지정
    objGridProps.rowHeight = 40; //로우 높이 지정
    objGridProps.selectionMode = "multipleCells"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = false; // 푸터 보이게 설정
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = true; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = true; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.wordWrap = true;

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (item.ClosingFlag == "Y" || item.SendStatus !== 1) { //마감, 송금
            return "aui-grid-closing-y-row-style";
        } else if (item.BillStatus === 2 || item.BillStatus === 3) { //계산서발행
            return "aui-grid-carryover-y-row-style";
        }
        return "";
    }

    var objResultLayout = fnGetDefaultPayColumnLayout();

        //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    AUIGrid.bind(strGID, "rowStateCellClick", function (event) {
        if (event.item.TransRateStatus == 2) { //event.marker === edited, added-edited, removed, added
            fnDefaultAlert("자동운임이 적용된 비용은 상태를 변경하실 수 없습니다.");
            return false;
        }
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultPayColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "PayTypeM",
            headerText: "비용구분",
            editable: false,
            width: 80,
            filter: { showIcon: true }
        },
        {
            dataField: "TaxKindM",
            headerText: "과세구분",
            editable: false,
            width: 80,
            filter: { showIcon: true }
        },
        {
            dataField: "ItemCodeM",
            headerText: "비용항목",
            editable: false,
            width: 100,
            filter: { showIcon: true }
        },
        {
            dataField: "SupplyAmt",
            headerText: "공급가액",
            editable: false,
            width: 80,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.##");
            }
        },
        {
            dataField: "TaxAmt",
            headerText: "부가세",
            editable: false,
            width: 80,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.##");
            }
        },
        {
            dataField: "Info",
            headerText: "업체/차량",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = "";
                var strClientInfo = typeof item.ClientInfo === "string" ? item.ClientInfo : "";
                var strDispatchInfo = typeof item.DispatchInfo === "string" ? item.DispatchInfo : "";

                strValue = strClientInfo === "" ? strDispatchInfo : strClientInfo;

                return strValue;
            }
        }
        /*숨김필드*/
        , {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "PaySeqNo",
            headerText: "PaySeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "OrderNo",
            headerText: "OrderNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "GoodsSeqNo",
            headerText: "GoodsSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "GoodsDispatchType",
            headerText: "GoodsDispatchType",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "DispatchSeqNo",
            headerText: "DispatchSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "PayType",
            headerText: "PayType",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "TaxKind",
            headerText: "TaxKind",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ItemCode",
            headerText: "ItemCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClientName",
            headerText: "ClientName",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "OrgAmt",
            headerText: "OrgAmt",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClosingFlag",
            headerText: "ClosingFlag",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClosingSeqNo",
            headerText: "ClosingSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "BillStatus",
            headerText: "BillStatus",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "SendStatus",
            headerText: "SendStatus",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "RegAdminID",
            headerText: "RegAdminID",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "UpdAdminID",
            headerText: "UpdAdminID",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "RefSeqNo",
            headerText: "RefSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CarDivType",
            headerText: "CarDivType",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ComCode",
            headerText: "ComCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ComInfo",
            headerText: "ComInfo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CarSeqNo",
            headerText: "CarSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CarInfo",
            headerText: "CarInfo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "DriverSeqNo",
            headerText: "DriverSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "DriverInfo",
            headerText: "DriverInfo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ApplySeqNo",
            headerText: "ApplySeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "TransDtlSeqNo",
            headerText: "TransDtlSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "TransRateStatus",
            headerText: "TransRateStatus",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "RegAdminName",
            headerText: "등록자",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "RegDate",
            headerText: "등록일",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "UpdAdminName",
            headerText: "수정자",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "UpdDate",
            headerText: "수정일",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "ClientInfo",
            headerText: "업체정보",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "DispatchInfo",
            headerText: "차량정보",
            editable: false,
            visible: false,
            width: 0
        }
    ];

    return objColumnLayout;
}


//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------

//셀 클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnPayGridCellClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridPayID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return false;
    }

    if ($("#TransType").val() === "3" && objItem.PayType == "2") {
        fnDefaultAlert("이관받은 오더는 매입을 수정하실 수 없습니다.");
        return false;
    }

    if ($("#ContractType").val() === "3" && objItem.PayType == "1") {
        fnDefaultAlert("수탁 오더는 매출을 수정하실 수 없습니다.");
        return false;
    }

    if (typeof objItem.RefSeqNo !== "undefined" && typeof objItem.GoodsDispatchType !== "undefined") {
        if (objItem.RefSeqNo !== "" && objItem.RefSeqNo !== "0" && objItem.GoodsDispatchType != "2") {
            fnDefaultAlert("집하/간선/배차 차량 비용은 수정할 수 없습니다", "error");
            return false;
        }
    }

    if (objItem.ClosingFlag !== "N" || objItem.BillStatus === 2 || objItem.BillStatus === 3 || objItem.SendStatus !== 1) {
        fnDefaultAlert("마감된 비용은 수정할 수 없습니다", "error");
        return false;
    }

    if (typeof objItem.ApplySeqNo !== "undefined") {
        if (objItem.ApplySeqNo != "0") {
            fnDefaultAlert("자동운임으로 등록된 비용은 수정할 수 없습니다.<br/>\"자동운임 수정요청\" 기능을 이용하세요.", "error");
            return false;
        }
    }

    fnDisplayPay(objItem);
}

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallPayGridData(strGID) {

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnPayGridSuccResult";

    var objParam = {
        CallType: "DomesticPayList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnPayGridSuccResult(objRes) {

    if (objRes) {

        AUIGrid.setGridData(GridPayID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridPayID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridPayID);
        fnClosePay();

        // 푸터
        fnSetPayGridFooter(GridPayID);
        return false;
    }
}

//이관 매출 조회
function fnCallTransPayData() {
    $("#TbodyTransPayInfo").html("");

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallTransPayDataSuccResult";

    var objParam = {
        CallType: "DomesticTransPayList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
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

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetPayGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "PayTypeM",
            dataField: "PayTypeM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        },
        {
            positionField: "SupplyAmt",
            dataField: "SupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TaxAmt",
            dataField: "TaxAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}


// 비용 데이터 세팅
function fnDisplayPay(item) {
    $("#PayType").val(item.PayType);
    fnSetPay();

    var strClientInfo = typeof item.ClientInfo === "undefined" ? "" : item.ClientInfo;

    $("#SeqNo").val(item.SeqNo);
    $("#PaySeqNo").val(item.PaySeqNo);
    $("#TaxKind").val(item.TaxKind);
    $("#ItemCode").val(item.ItemCode);
    $("#SupplyAmt").val(fnMoneyComma(item.SupplyAmt));
    $("#TaxAmt").val(fnMoneyComma(item.TaxAmt));
    $("#ClientCode").val(item.ClientCode);
    $("#ClientInfo").val(strClientInfo);
    $("#ClientName").val(item.ClientName);
    $("#BtnUpdPay").show();
    $("#BtnDelPay").show();
}

//비용추가
function fnPayAddRow() {
    var strClientInfo = "";
    var strDispatchInfo = "";
    var strDispatchSeqNo = "";
    var strRefSeqNo = "";
    var strGoodsDispatchType = 1;

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#PayType").val()) {
        fnDefaultAlertFocus("비용 구분을 선택하세요.", "PayType", "warning");
        return false;
    }

    if (!$("#TaxKind").val()) {
        fnDefaultAlertFocus("과세 구분을 선택하세요.", "TaxKind", "warning");
        return false;
    }

    if (!$("#ItemCode").val()) {
        fnDefaultAlertFocus("비용항목을 선택하세요.", "ItemCode", "warning");
        return false;
    }

    if (!$("#SupplyAmt").val()) {
        fnDefaultAlertFocus("공급가액을 입력하세요.", "SupplyAmt", "warning");
        return false;
    }

    var cnt = 0;
    if ($("#ItemCode").val() == "OP001" && ($("#PayType").val() == "1" || $("#PayType").val() == "2")) {
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                        if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val()) {
                            cnt++;
                        }
                    }
                });
        }

        if (cnt > 0) {
            fnDefaultAlert("운임은 매출/입에 한건씩 입력이 가능합니다.", "warning");
            return false;
        }
    }

    if ($("#PayType").val() === "2") { //매입
        if ($("#ClientCode").val() && $("#ClientCode").val() !== "0") {
            strClientInfo = $("#ClientInfo").val();
        } else if ($("#GoodsDispatchType").val() === "2") {

            if (!($("#ContractType").val() == "2" && $("#ContractStatus").val() == "2")) { //위탁 아닐때 추가 처리
                if (!($("#TbodyDispatchInfo td:nth-child(2)").text() !== "" && $("#RefSeqNo").val() && $("#RefSeqNo").val() !== "0" && strClientInfo === "")) {
                    fnDefaultAlertFocus("업체정보(or 배차정보)를 입력하세요.", "ClientName", "warning");
                    return false;
                }
            }

            $("#ClientCode").val("");
            $("#ClientName").val("");
            strDispatchInfo = $("#TbodyDispatchInfo td:nth-child(2)").text();
            strGoodsDispatchType = $("#GoodsDispatchType").val();
            strDispatchSeqNo = $("#DispatchSeqNo").val();
            strRefSeqNo = $("#RefSeqNo").val();
        } else {
            fnDefaultAlertFocus("업체정보(or 배차정보)를 입력하세요.", "ClientName", "warning");
            return false;
        }
    } else if ($("#PayType").val() === "3" || $("#PayType").val() === "4") { //선급 or 예수
        if (!$("#PayClientCode").val() && !$("#ClientCode").val()) {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }
        if ($("#ClientCode").val()) {
            strClientInfo = $("#ClientInfo").val();
        } else if ($("#PayClientCode").val()) {
            strClientInfo = $("#PayClientInfo").val();
            $("#ClientCode").val($("#PayClientCode").val());
            $("#ClientName").val($("#PayClientName").val());
        }
    }

    var objItem = new Object();
    objItem.PayTypeM = $("#PayType option:selected").text();
    objItem.TaxKindM = $("#TaxKind option:selected").text();
    objItem.ItemCodeM = $("#ItemCode option:selected").text();
    objItem.SupplyAmt = $("#SupplyAmt").val();
    objItem.TaxAmt = $("#TaxAmt").val();
    objItem.ClientInfo = strClientInfo;
    objItem.DispatchInfo = strDispatchInfo;
    objItem.SeqNo = "";
    objItem.PaySeqNo = "";
    objItem.CenterCode = $("#CenterCode").val();
    objItem.OrderNo = $("#OrderNo").val();
    objItem.GoodsSeqNo = $("#GoodsSeqNo").val();
    objItem.DispatchSeqNo = strDispatchSeqNo;
    objItem.PayType = $("#PayType").val();
    objItem.TaxKind = $("#TaxKind").val();
    objItem.ItemCode = $("#ItemCode").val();
    objItem.ClientCode = $("#ClientCode").val();
    objItem.ClientName = $("#ClientName").val();
    objItem.RefSeqNo = strRefSeqNo;
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
    objItem.GoodsDispatchType = strGoodsDispatchType;
    AUIGrid.addRow(GridPayID, objItem, "last");
    fnSetPay();
}

//비용수정
function fnPayUpdRow() {
    var strClientInfo = "";
    var strDispatchInfo = "";
    var strDispatchSeqNo = "";
    var strRefSeqNo = "";
    var strGoodsDispatchType = 1;

    if (!$("#PaySeqNo").val()) {
        fnDefaultAlert("선택된 비용정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#PayType").val()) {
        fnDefaultAlertFocus("비용 구분을 선택하세요.", "PayType", "warning");
        return false;
    }

    if (!$("#TaxKind").val()) {
        fnDefaultAlertFocus("과세 구분을 선택하세요.", "TaxKind", "warning");
        return false;
    }

    if (!$("#ItemCode").val()) {
        fnDefaultAlertFocus("비용항목을 선택하세요.", "ItemCode", "warning");
        return false;
    }

    if (!$("#SupplyAmt").val()) {
        fnDefaultAlertFocus("공급가액을 입력하세요.", "SupplyAmt", "warning");
        return false;
    }

    var cnt = 0;
    if ($("#ItemCode").val() == "OP001" && ($("#PayType").val() == "1" || $("#PayType").val() == "2")) {
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                        if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.PaySeqNo != $("#PaySeqNo").val()) {
                            cnt++;
                        }
                    }
                });
        }

        if (cnt > 0) {
            fnDefaultAlert("운임은 매출/입에 한건씩 입력이 가능합니다.", "warning");
            return;
        }
    }

    if ($("#PayType").val() === "2") { //매입
        if ($("#ClientCode").val() && $("#ClientCode").val() !== "0") {
            strClientInfo = $("#ClientInfo").val();
        } else if ($("#GoodsDispatchType").val() === "2") {

            if (!($("#ContractType").val() == "2" && $("#ContractStatus").val() == "2")) { //위탁 아닐때 추가 처리
                if (!($("#TbodyDispatchInfo td:nth-child(2)").text() !== "" && $("#RefSeqNo").val() && $("#RefSeqNo").val() !== "0" && strClientInfo === "")) {
                    fnDefaultAlertFocus("업체정보(or 배차정보)를 입력하세요.", "ClientName", "warning");
                    return false;
                }
            }

            $("#ClientCode").val("");
            $("#ClientName").val("");
            strDispatchInfo = $("#TbodyDispatchInfo td:nth-child(2)").text();
            strGoodsDispatchType = $("#GoodsDispatchType").val();
            strDispatchSeqNo = $("#DispatchSeqNo").val();
            strRefSeqNo = $("#RefSeqNo").val();
        } else {
            fnDefaultAlertFocus("업체정보(or 배차정보)를 입력하세요.", "ClientName", "warning");
            return false;
        }
    } else if ($("#PayType").val() === "3" || $("#PayType").val() === "4") { //선급 or 예수
        if (!$("#PayClientCode").val() && !$("#ClientCode").val()) {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }

        if ($("#ClientCode").val()) {
            strClientInfo = $("#ClientInfo").val();
        } else if ($("#PayClientCode").val()) {
            strClientInfo = $("#PayClientInfo").val();
            $("#ClientCode").val($("#PayClientCode").val());
            $("#ClientName").val($("#PayClientName").val());
        }
    }

    var objItem = new Object();
    objItem.PayTypeM = $("#PayType option:selected").text();
    objItem.TaxKindM = $("#TaxKind option:selected").text();
    objItem.ItemCodeM = $("#ItemCode option:selected").text();
    objItem.SupplyAmt = $("#SupplyAmt").val();
    objItem.TaxAmt = $("#TaxAmt").val();
    objItem.ClientInfo = strClientInfo;
    objItem.DispatchInfo = strDispatchInfo;
    objItem.SeqNo = $("#SeqNo").val();
    objItem.PaySeqNo = $("#PaySeqNo").val();
    objItem.CenterCode = $("#CenterCode").val();
    objItem.OrderNo = $("#OrderNo").val();
    objItem.GoodsSeqNo = $("#GoodsSeqNo").val();
    objItem.DispatchSeqNo = strDispatchSeqNo;
    objItem.PayType = $("#PayType").val();
    objItem.TaxKind = $("#TaxKind").val();
    objItem.ItemCode = $("#ItemCode").val();
    objItem.ClientCode = $("#ClientCode").val();
    objItem.ClientName = $("#ClientName").val();
    objItem.RefSeqNo = strRefSeqNo;
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
    objItem.GoodsDispatchType = strGoodsDispatchType;
    AUIGrid.updateRowsById(GridPayID, objItem);
    fnSetPay();
}

//비용삭제
function fnPayDelRow() {
    if (!$("#PaySeqNo").val()) {
        fnDefaultAlert("선택된 비용정보가 없습니다.", "warning");
        return false;
    }

    AUIGrid.removeRowByRowId(GridPayID, $("#PaySeqNo").val());
    fnSetPay();
}

//초기화
function fnResetPay() {
    strPayType = "";
    fnSetPay();
}
//---------------------------------------------------------------------------------

function fnOpenPay() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    $("div#CostMulti").show();
    AUIGrid.resize(GridPayID, $("#CostMulti .cost_list").width(), $("#CostMulti .cost_list").height());
}

function fnClosePay() {
    var html = "";

    if (AUIGrid.getGridData(GridPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridPayID), function (index, item) {
            if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {

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
                html += "\t<td><span class=\"" + strClass + "\">" + item.PayTypeM + "</span>" + item.TaxKindM + "</td>\n";
                html += "\t<td>" + item.ItemCodeM + "</td>\n";
                html += "\t<td class=\"right\">" + fnMoneyComma(item.SupplyAmt) + "<br/>" + fnMoneyComma(item.TaxAmt) + "</td>\n";
                html += "\t<td class=\"left\">" + info + "</td>\n";
                html += "</tr>\n";

            }
        });
    }

    $("#TbodyPayInfo").html(html);
    $("div#CostMulti").hide();
}

//비용정보 세팅
function fnSetPay() {
    if ($("#PayType option:selected").text() === "매입") { //매입
        $(".TrPayClient").show();
    } else if ($("#PayType option:selected").text() === "선급" || $("#PayType option:selected").text() === "예수") { //선급 or 예수
        $(".TrPayClient").show();
    } else { //매출 외
        $(".TrPayClient").hide();
    }

    $("#TaxKind").find("option").filter(function (index) {
        return $(this).text() === "과세";
    }).prop("selected", true);

    $("#BtnUpdPay").hide();
    $("#BtnDelPay").hide();

    $("#SeqNo").val("");
    $("#PaySeqNo").val("");

    if (!((strPayType == "1" && $("#PayType").val() == "2") || (strPayType == "2" && $("#PayType").val() == "1"))) {
        $("#ItemCode").find("option:nth-child(2)").prop("selected", true);
        $("#SupplyAmt").val("");
        $("#TaxAmt").val("");
    }

    $("#ClientCode").val("");
    $("#ClientInfo").val("");
    $("#ClientName").val("");
}
/******************************************/

/******************************************/
// 자동운임
/******************************************/
//오더 자동운임 조회
function fnCallTransRateData() {
    if (!$("#OrderNo").val() || !$("#CenterCode").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallTransRateDataSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "TransRateOrderList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
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

        $("#BtnCallTransRate").hide();
        $(".TrUpdRequestAmt").show();
        $("#BtnUpdRequestAmt").show();

    } else {
        fnCallDetailFailResult();
    }
}

//자동운임 조회
function fnCallTransRate() {

    $("#HidCenterCode").val($("#CenterCode").val());
    $("#HidGoodsDispatchType").val($("#GoodsDispatchType").val());
    $("#HidOrderLocationCode").val($("#OrderLocationCode").val());
    $("#HidPayClientCode").val($("#PayClientCode").val());
    $("#HidConsignorCode").val($("#ConsignorCode").val());
    $("#HidPickupYMD").val($("#PickupYMD").val().replace(/-/gi, ""));
    $("#HidPickupHM").val($("#PickupHM").val());
    $("#HidPickupPlaceFullAddr").val($("#PickupPlaceFullAddr").val());
    $("#HidGetYMD").val($("#GetYMD").val().replace(/-/gi, ""));
    $("#HidGetHM").val($("#GetHM").val());
    $("#HidGetPlaceFullAddr").val($("#GetPlaceFullAddr").val());
    $("#HidCarTonCode").val($("#CarTonCode").val());
    $("#HidCarTypeCode").val($("#CarTypeCode").val());
    $("#HidVolume").val($("#Volume").val().replace(/,/gi, ""));
    $("#HidWeight").val($("#Weight").val().replace(/,/gi, ""));
    $("#HidCBM").val($("#CBM").val().replace(/,/gi, ""));
    $("#HidLength").val($("#Length").val().replace(/,/gi, ""));
    $("#HidFTLFlag").val($("#FTLFlag").val());
    $("#HidGoodsRunType").val($("#GoodsRunType").val());
    $("#HidCarFixedFlag").val($("#CarFixedFlag").val());
    $("#HidLayoverFlag").val($("#LayoverFlag").is(":checked") ? "Y" : "N");
    $("#HidSamePlaceCount").val($("#SamePlaceCount").val().replace(/,/gi, ""));
    $("#HidNonSamePlaceCount").val($("#NonSamePlaceCount").val().replace(/,/gi, ""));

    var PayChk = true;
    if (AUIGrid.getGridData(GridPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridPayID),
            function (index, item) {
                //운임, 경유비, 유가연동 체크
                if ((item.PayType == 1 || item.PayType == 2) && (item.ItemCode == "OP001" || item.ItemCode == "OP088" || item.ItemCode == "OP089") && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) { //마감체크
                    PayChk = false;
                    return false;
                }
            });
    }

    if (!PayChk) {
        fnDefaultAlert("이미 마감된 운임이 있어 자동운임을 적용할 수 없습니다.", "warning");
        return false;
    }

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#GoodsDispatchType").val()) {
        fnDefaultAlertFocus("배차구분을 선택하세요.", "GoodsDispatchType", "warning");
        return;
    }

    if ($("#GoodsDispatchType").val() === "3" && !$("#OrderLocationCode").val()) {
        fnDefaultAlertFocus("사업장을 선택하세요.", "OrderLocationCode", "warning");
        return;
    }

    if (!$("#ConsignorCode").val() || $("#ConsignorCode").val() === "0") {
        fnDefaultAlertFocus("화주를 선택하세요.", "ConsignorName", "warning");
        return false;
    }

    if (!$("#PayClientCode").val() || $("#PayClientCode").val() === "0") {
        fnDefaultAlertFocus("청구처를 선택하세요.", "PayClientName", "warning");
        return false;
    }

    if (!$("#PickupYMD").val()) {
        fnDefaultAlertFocus("상차일을 선택하세요.", "PickupYMD", "warning");
        return false;
    }

    if (!$("#PickupPlaceFullAddr").val()) {
        fnDefaultAlertFocus("상차지 주소를 검색하세요.", "BtnSearchAddrPickupPlace", "warning");
        return false;
    }

    if (!$("#GetYMD").val()) {
        fnDefaultAlertFocus("하차일을 선택하세요.", "GetYMD", "warning");
        return false;
    }

    if (!$("#GetPlaceFullAddr").val()) {
        fnDefaultAlertFocus("하차지 주소를 검색하세요.", "BtnSearchAddrGetPlace", "warning");
        return false;
    }

    if (!$("#CarTonCode").val()) {
        fnDefaultAlertFocus("요청톤급을 선택하세요.", "CarTonCode", "warning");
        return false;
    }

    if (!$("#CarTypeCode").val()) {
        fnDefaultAlertFocus("요청차종을 선택하세요.", "CarTypeCode", "warning");
        return false;
    }

    if (!$("#FTLFlag").val()) {
        fnDefaultAlertFocus("독차/혼적 구분을 선택하세요.", "FTLFlag", "warning");
        return;
    }

    if (!$("#GoodsRunType").val()) {
        fnDefaultAlertFocus("운행구분을 선택하세요.", "GoodsRunType", "warning");
        return;
    }

    if (!$("#CarFixedFlag").val()) {
        fnDefaultAlertFocus("고정/용차 구분을 선택하세요.", "CarFixedFlag", "warning");
        return;
    }

    if ($("#LayoverFlag").is(":checked")) {
        if (($("#SamePlaceCount").val() == "" || $("#SamePlaceCount").val() == "0") && ($("#NonSamePlaceCount").val() == "" || $("#NonSamePlaceCount").val() == "0")) {
            fnDefaultAlertFocus("지역수를 입력하세요.", "SamePlaceCount", "warning");
            return;
        }
    }

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallTransRateSuccResult";
    var strFailCallBackFunc = "fnCallTransRateFailResult";

    var objParam = {
        CallType: "TransRateOrderApplyList",
        CenterCode: $("#CenterCode").val(),
        GoodsDispatchType: $("#GoodsDispatchType").val(),
        OrderLocationCode: $("#OrderLocationCode").val(),
        PayClientCode: $("#PayClientCode").val(),
        ConsignorCode: $("#ConsignorCode").val(),
        PickupYMD: $("#PickupYMD").val(),
        PickupHM: $("#PickupHM").val(),
        PickupPlaceFullAddr: $("#PickupPlaceFullAddr").val(),
        GetYMD: $("#GetYMD").val(),
        GetHM: $("#GetHM").val(),
        GetPlaceFullAddr: $("#GetPlaceFullAddr").val(),
        CarTonCode: $("#CarTonCode").val(),
        CarTypeCode: $("#CarTypeCode").val(),
        Volume: $("#Volume").val(),
        Weight: $("#Weight").val(),
        CBM: $("#CBM").val(),
        Length: $("#Length").val(),
        FTLFlag: $("#FTLFlag").val(),
        GoodsRunType: $("#GoodsRunType").val(),
        CarFixedFlag: $("#CarFixedFlag").val(),
        LayoverFlag: $("#LayoverFlag").is(":checked") ? "Y" : "N",
        SamePlaceCount: $("#SamePlaceCount").val(),
        NonSamePlaceCount: $("#NonSamePlaceCount").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnCallTransRateSuccResult(objRes) {
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

        $("#BtnUpdRequestAmt").hide();

        //자동운임 항목 초기화
        if (objRes[0].data.RecordCnt <= 0) {
            fnDefaultAlert("적용 가능한 자동운임이 없습니다.", "info");
            if (AUIGrid.getGridData(GridPayID).length > 0) {
                var arrRemoveIds = [];
                $.each(AUIGrid.getGridData(GridPayID),
                    function (index, item) {
                        //운임, 경유비, 유가연동
                        if ((item.PayType == 1 || item.PayType == 2) && (item.ItemCode == "OP001" || item.ItemCode == "OP088" || item.ItemCode == "OP089") && (item.ApplySeqNo != "" && item.ApplySeqNo != "0")) {
                            arrRemoveIds.push(item.PaySeqNo);
                        }
                    });

                if (arrRemoveIds.length > 0) {
                    AUIGrid.removeRowByRowId(GridPayID, arrRemoveIds);
                }
            }
            return false;
        }


        var PayChk = true;
        //마감체크 (운임, 경유비, 유가연동) 시작
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if ((item.PayType == 1 || item.PayType == 2) && (item.ItemCode == "OP001" || item.ItemCode == "OP088" || item.ItemCode == "OP089") && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) {
                        PayChk = false;
                        return false;
                    }
                });
        }

        if (!PayChk) {
            fnDefaultAlert("이미 마감된 운임이 있어 자동운임을 적용할 수 없습니다.", "warning");
            return false;
        }
        //마감체크 (운임, 경유비, 유가연동) 끝

        //기존 항목 삭제
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            var arrRemoveIds = [];

            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if ((item.PayType == 1 || item.PayType == 2) && (item.ItemCode == "OP001" || item.ItemCode == "OP088" || item.ItemCode == "OP089")) {
                        arrRemoveIds.push(item.PaySeqNo);
                    }
                });

            if (arrRemoveIds.length > 0) {
                AUIGrid.removeRowByRowId(GridPayID, arrRemoveIds);
            }
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
                fnSetTransRate(item);
            } else if (item.RateInfoKind === 4) { //경유비
                $("#LayoverSaleUnitAmt").val(item.SaleUnitAmt);
                $("#LayoverSaleUnitAmt").val(fnMoneyComma($("#LayoverSaleUnitAmt").val()));
                $("#LayoverFixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                $("#LayoverFixedPurchaseUnitAmt").val(fnMoneyComma($("#LayoverFixedPurchaseUnitAmt").val()));
                $("#LayoverPurchaseUnitAmt").val(item.PurchaseUnitAmt);
                $("#LayoverPurchaseUnitAmt").val(fnMoneyComma($("#LayoverPurchaseUnitAmt").val()));
                $("#PLayoverTransRateInfo").html(item.RateInfo);
                fnSetTransRate(item);
            } else if (item.RateInfoKind === 5) { //유가연동
                $("#OilSaleUnitAmt").val(item.SaleUnitAmt);
                $("#OilSaleUnitAmt").val(fnMoneyComma($("#OilSaleUnitAmt").val()));
                $("#OilFixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                $("#OilFixedPurchaseUnitAmt").val(fnMoneyComma($("#OilFixedPurchaseUnitAmt").val()));
                $("#OilPurchaseUnitAmt").val(item.PurchaseUnitAmt);
                $("#OilPurchaseUnitAmt").val(fnMoneyComma($("#OilPurchaseUnitAmt").val()));
                $("#POilTransRateInfo").html(item.RateInfo);
                fnSetTransRate(item);
            }
        });

        fnClosePay();

        return false;
    }
}

function fnCallTransRateFailResult() {
    fnDefaultAlert("나중에 다시 시도해주세요.", "warning");
    return false;
}

//자동운임 세팅
function fnSetTransRate(objRateItem) {
    var intSupplyAmt = 0;
    var intTaxAmt = 0;
    var strItemCode = "";
    var strItemName = "";
    var ApplySale = true;
    var ApplyPurchase = true;
    var intSamePlaceCount = "";
    var intNonSamePlaceCount = "";
    var intPlaceCount = 0;

    //경유비 체크
    if (objRateItem.RateInfoKind === 4) { //경유비
        if (!$("#LayoverFlag").is(":checked")) {
            return false;
        }

        intSamePlaceCount = $("#SamePlaceCount").val();
        intNonSamePlaceCount = $("#NonSamePlaceCount").val();

        if ((intSamePlaceCount === "0" || intSamePlaceCount === "") && (intNonSamePlaceCount === "0" || intNonSamePlaceCount === "")) {
            return false;
        }

        try {
            if (intSamePlaceCount === "") {
                intSamePlaceCount = "0";
            }
            intSamePlaceCount = parseInt(intSamePlaceCount);
        } catch (e) {
            intSamePlaceCount = 0;
        }

        try {
            if (intNonSamePlaceCount === "") {
                intNonSamePlaceCount = "0";
            }
            intNonSamePlaceCount = parseInt(intNonSamePlaceCount);
        } catch (e) {
            intNonSamePlaceCount = 0;
        }

        intPlaceCount = intSamePlaceCount + intNonSamePlaceCount;

        if (intPlaceCount === 0) {
            return false;
        }
    }

    if (objRateItem.SaleUnitAmt === 0) {
        ApplySale = false;
    }

    if (objRateItem.FixedPurchaseUnitAmt === 0 && objRateItem.PurchaseUnitAmt === 0) {
        ApplyPurchase = false;
    }

    if (objRateItem.RateInfoKind === 1) { //운임
        strItemCode = "OP001";
        strItemName = "운임";
    } else if (objRateItem.RateInfoKind === 4) { //경유비
        strItemCode = "OP088";
        strItemName = "경유비";
    } else if (objRateItem.RateInfoKind === 5) { //유가연동
        strItemCode = "OP089";
        strItemName = "유가연동";
    }

    //매출 추가
    if (ApplySale) {

        try {
            intSupplyAmt = objRateItem.SaleUnitAmt;

            //if (objRateItem.RateInfoKind === 4) {
            //    intSupplyAmt *= intPlaceCount;
            //}

            if (isNaN(intSupplyAmt)) {
                intSupplyAmt = 0;
            }
        } catch (e) {
            intSupplyAmt = 0;
        }

        try {
            intTaxAmt = Math.floor(parseFloat(intSupplyAmt) / 10);

            if (isNaN(intTaxAmt)) {
                intTaxAmt = 0;
            }
        } catch (e) {
            intTaxAmt = 0;
        }

        var objItem = new Object();
        objItem.PayTypeM = "매출";
        objItem.TaxKindM = "과세";
        objItem.ItemCodeM = strItemName;
        objItem.SupplyAmt = intSupplyAmt;
        objItem.TaxAmt = intTaxAmt;
        objItem.ClientInfo = "";
        objItem.DispatchInfo = "";
        objItem.SeqNo = "";
        objItem.PaySeqNo = "";
        objItem.CenterCode = $("#CenterCode").val();
        objItem.OrderNo = $("#OrderNo").val();
        objItem.GoodsSeqNo = $("#GoodsSeqNo").val();
        objItem.DispatchSeqNo = "0";
        objItem.PayType = 1;
        objItem.TaxKind = 1;
        objItem.ItemCode = strItemCode;
        objItem.ClientCode = "";
        objItem.ClientName = "";
        objItem.RefSeqNo = "";
        objItem.ClosingFlag = "N";
        objItem.BillStatus = 1;
        objItem.SendStatus = 1;
        objItem.GoodsDispatchType = "";
        objItem.ApplySeqNo = $("#ApplySeqNo").val();
        objItem.TransDtlSeqNo = objRateItem.TransDtlSeqNo;
        objItem.TransRateStatus = 2;
        objItem.Trans
        AUIGrid.addRow(GridPayID, objItem, "last");
    }

    //매입 추가
    if (ApplyPurchase) {

        try {
            intSupplyAmt = objRateItem.FixedPurchaseUnitAmt === 0 ? objRateItem.PurchaseUnitAmt : objRateItem.FixedPurchaseUnitAmt;

            //if (objRateItem.RateInfoKind === 4) {
            //    intSupplyAmt *= intPlaceCount;
            //}

            if (isNaN(intSupplyAmt)) {
                intSupplyAmt = 0;
            }
        } catch (e) {
            intSupplyAmt = 0;
        }

        try {
            intTaxAmt = Math.floor(parseFloat(intSupplyAmt) / 10);

            if (isNaN(intTaxAmt)) {
                intTaxAmt = 0;
            }
        } catch (e) {
            intTaxAmt = 0;
        }

        var objItem = new Object();
        objItem.PayTypeM = "매입";
        objItem.TaxKindM = "과세";
        objItem.ItemCodeM = strItemName;
        objItem.SupplyAmt = intSupplyAmt;
        objItem.TaxAmt = intTaxAmt;
        objItem.ClientInfo = "";
        objItem.DispatchInfo = $("#SpanDispatchInfo").text();
        objItem.SeqNo = "";
        objItem.PaySeqNo = "";
        objItem.CenterCode = $("#CenterCode").val();
        objItem.OrderNo = $("#OrderNo").val();
        objItem.GoodsSeqNo = $("#GoodsSeqNo").val();
        objItem.DispatchSeqNo = $("#DispatchSeqNo").val();
        objItem.PayType = 2;
        objItem.TaxKind = 1;
        objItem.ItemCode = strItemCode;
        objItem.ClientCode = "";
        objItem.ClientName = "";
        objItem.RefSeqNo = $("#RefSeqNo").val();
        objItem.ClosingFlag = "N";
        objItem.BillStatus = 1;
        objItem.SendStatus = 1;
        objItem.GoodsDispatchType = $("#GoodsDispatchType").val();
        objItem.ApplySeqNo = $("#ApplySeqNo").val();
        objItem.TransDtlSeqNo = objRateItem.TransDtlSeqNo;
        objItem.TransRateStatus = 2;
        AUIGrid.addRow(GridPayID, objItem, "last");
    }
}

//자동운임 조건 체크
function fnGetRateConditionChange() {

    //기본 항목이 변경 된 경우
    if ($("#HidCenterCode").val() !== $("#CenterCode").val()
        || $("#HidGoodsDispatchType").val() !== $("#GoodsDispatchType").val()
        || $("#HidOrderLocationCode").val() !== $("#OrderLocationCode").val()
        || $("#HidPayClientCode").val() !== $("#PayClientCode").val()
        || $("#HidConsignorCode").val() !== $("#ConsignorCode").val()
        || $("#HidPickupPlaceFullAddr").val() !== $("#PickupPlaceFullAddr").val()
        || $("#HidGetPlaceFullAddr").val() !== $("#GetPlaceFullAddr").val()
        || $("#HidFTLFlag").val() !== $("#FTLFlag").val()
        || $("#HidGoodsRunType").val() !== $("#GoodsRunType").val()
        || $("#HidCarFixedFlag").val() !== $("#CarFixedFlag").val()) {
        return true;
    }

    if ($("#HidCarTonCode").val() !== $("#CarTonCode").val()
        || $("#HidCarTypeCode").val() !== $("#CarTypeCode").val()) {
        return true;
    }

    if ($("#HidPickupYMD").val() !== $("#PickupYMD").val().replace(/-/gi, "")
        || $("#HidPickupHM").val() !== $("#PickupHM").val()
        || $("#HidGetYMD").val() !== $("#GetYMD").val().replace(/-/gi, "")
        || $("#HidGetHM").val() !== $("#GetHM").val()) {
        return true;
    }

    //수량 체크
    var strHidVolume = $("#HidVolume").val().replace(/,/gi, "");
    var strVolume = $("#Volume").val().replace(/,/gi, "");

    if (strHidVolume === "") {
        strHidVolume = "0";
    }

    if (strVolume === "") {
        strVolume = "0";
    }

    if (strHidVolume !== strVolume) {
        return true;
    }

    //cbm 체크
    var strHidCBM = $("#HidCBM").val().replace(/,/gi, "");
    var strCBM = $("#CBM").val().replace(/,/gi, "");

    if (strHidCBM === "") {
        strHidCBM = "0";
    }

    if (strCBM === "") {
        strCBM = "0";
    }

    if (strHidCBM !== strCBM) {
        return true;
    }

    //중량 체크
    var strHidWeight = $("#HidWeight").val().replace(/,/gi, "");
    var strWeight = $("#Weight").val().replace(/,/gi, "");

    if (strHidWeight === "") {
        strHidWeight = "0";
    }

    if (strWeight === "") {
        strWeight = "0";
    }

    if (strHidWeight !== strWeight) {
        return true;
    }

    //길이 체크
    var strHidLength = $("#HidLength").val().replace(/,/gi, "");
    var strLength = $("#Length").val().replace(/,/gi, "");

    if (strHidLength === "") {
        strHidLength = "0";
    }

    if (strLength === "") {
        strLength = "0";
    }

    if (strHidLength !== strLength) {
        return true;
    }

    //경유지 체크
    var strHidSamePlaceCount = $("#HidSamePlaceCount").val().replace(/,/gi, "");
    var strHidNonSamePlaceCount = $("#HidNonSamePlaceCount").val().replace(/,/gi, "");

    if (strHidSamePlaceCount === "") {
        strHidSamePlaceCount = "0";
    }

    if (strHidNonSamePlaceCount === "") {
        strHidNonSamePlaceCount = "0";
    }

    var strLayoverFlag = $("#LayoverFlag").is(":checked") ? "Y" : "N";
    var strSamePlaceCount = $("#SamePlaceCount").val().replace(/,/gi, "");
    var strNonSamePlaceCount = $("#NonSamePlaceCount").val().replace(/,/gi, "");

    if (strSamePlaceCount === "") {
        strSamePlaceCount = "0";
    }

    if (strNonSamePlaceCount === "") {
        strNonSamePlaceCount = "0";
    }

    if ($("#HidLayoverFlag").val() !== strLayoverFlag
        || strHidSamePlaceCount !== strSamePlaceCount
        || strHidNonSamePlaceCount !== strNonSamePlaceCount) {
        return true;
    }

    return false;
}

//자동운임 변경 체크
function fnChangeRateChk() {
    // 자동운임이 적용된 상태
    if ($("#HidMode").val() === "Update") { //오더 수정중
        if ($("#ApplySeqNo").val() !== "" && $("#ApplySeqNo").val() !== "0" && fnGetRateConditionChange()) {
            var ClosingPay = false;
            if (AUIGrid.getGridData(GridPayID).length > 0) {
                $.each(AUIGrid.getGridData(GridPayID),
                    function (index, item) {
                        if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                            if (!ClosingPay && (item.ItemCode == "OP001" || item.ItemCode == "OP088" || item.ItemCode == "OP089") && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) {
                                ClosingPay = true;
                            }
                        }
                    });
            }

            if (!ClosingPay) {
                $("#BtnCallTransRate").show();
            } else {
                fnDefaultAlert("마감된 자동운임이 있어 일부 항목 변경이 불가능합니다.", "warning");
                return false;
            }
        }
    }
}

//자동운임 수정요청
function fnUpdRequestAmt() {

    if (!$("#CenterCode").val() || !$("#OrderNo").val()) {
        return false;
    }

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return false;
    }

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnUpdRequestAmtSuccResult";
    var strFailCallBackFunc = "fnUpdRequestAmtFailResult";

    var objParam = {
        CallType: "AmtRequestOrderList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
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
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
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


//오더등록/수정
function fnInsOrder() {
    var strConfMsg = "";
    var strCallType = "";
    strSaleClosingFlag = "N";
    strPurchaseClosingFlag = "N";

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return false;
    }

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#GoodsDispatchType").val()) {
        fnDefaultAlertFocus("배차구분을 선택하세요.", "GoodsDispatchType", "warning");
        return false;
    }

    if ($("#GoodsDispatchType").val() === "3" && !$("#OrderLocationCode").val()) {
        fnDefaultAlertFocus("사업장을 선택하세요.", "OrderLocationCode", "warning");
        return false;
    }

    if (!$("#ConsignorCode").val()) {
        fnDefaultAlertFocus("화주를 검색하세요.", "ConsignorName", "warning");
        return false;
    }

    if (!$("#OrderClientCode").val()) {
        fnDefaultAlertFocus("발주처를 검색하세요.", "OrderClientName", "warning");
        return false;
    }

    if ($("#ContractType").val() !== "3") {
        if (!$("#OrderClientChargeName").val()) {
            fnDefaultAlertFocus("발주처 담당자명을 입력(or 검색)하세요.", "OrderClientChargeName", "warning");
            return false;
        }

        if (!$("#OrderClientChargeTelNo").val() && !$("#OrderClientChargeCell").val()) {
            fnDefaultAlertFocus("발주처 담당자의 전화번호나 휴대폰번호를 입력하세요.", "OrderClientChargeTelNo", "warning");
            return false;
        }
    }

    if (!$("#PayClientCode").val()) {
        fnDefaultAlertFocus("청구처를 검색하세요.", "PayClientName", "warning");
        return false;
    }

    if ($("#ContractType").val() !== "3") {
        if (!$("#PayClientChargeName").val()) {
            fnDefaultAlertFocus("청구처 담당자명을 입력(or 검색)하세요.", "PayClientChargeName", "warning");
            return false;
        }

        if (!$("#PayClientChargeTelNo").val() && !$("#PayClientChargeCell").val()) {
            fnDefaultAlertFocus("청구처 담당자의 전화번호나 휴대폰번호를 입력하세요.", "PayClientChargeTelNo", "warning");
            return false;
        }
    }

    if (!$("#PickupYMD").val()) {
        fnDefaultAlertFocus("상차일을 입력하세요.", "PickupYMD", "warning");
        return false;
    }

    if (!$("#PickupPlace").val()) {
        fnDefaultAlertFocus("상차지를 입력(or 검색)하세요.", "PickupPlace", "warning");
        return false;
    }

    if (!$("#PickupPlaceChargeName").val()) {
        fnDefaultAlertFocus("상차지 담당자를 입력하세요.", "PickupPlaceChargeName", "warning");
        return false;
    }

    if (!$("#PickupPlaceChargeTelNo").val() && !$("#PickupPlaceChargeCell").val()) {
        fnDefaultAlertFocus("상차지 담당자의 전화번호나 휴대폰번호를 입력하세요.", "PickupPlaceChargeTelNo", "warning");
        return false;
    }

    if (!$("#PickupPlacePost").val() || !$("#PickupPlaceAddr").val()) {
        fnDefaultAlertFocus("상차지 주소를 입력하세요.", "BtnSearchAddrPickupPlace", "warning");
        return false;
    }

    if (!$("#GetYMD").val()) {
        fnDefaultAlertFocus("하차일을 입력하세요.", "GetYMD", "warning");
        return false;
    }

    if (!$("#GetPlace").val()) {
        fnDefaultAlertFocus("하차지를 입력(or 검색)하세요.", "GetPlace", "warning");
        return false;
    }

    if (!$("#GetPlaceChargeName").val()) {
        fnDefaultAlertFocus("하차지 담당자를 입력하세요.", "GetPlaceChargeName", "warning");
        return false;
    }

    if (!$("#GetPlaceChargeTelNo").val() && !$("#GetPlaceChargeCell").val()) {
        fnDefaultAlertFocus("하차지 담당자의 전화번호나 휴대폰번호를 입력하세요.", "GetPlaceChargeTelNo", "warning");
        return false;
    }

    if (!$("#GetPlacePost").val() || !$("#GetPlaceAddr").val()) {
        fnDefaultAlertFocus("하차지 주소를 입력하세요.", "BtnSearchAddrGetPlace", "warning");
        return false;
    }

    if (!$("#CarTonCode").val()) {
        fnDefaultAlertFocus("요청톤급을 선택하세요.", "CarTonCode", "warning");
        return false;
    }

    if (!$("#CarTypeCode").val()) {
        fnDefaultAlertFocus("요청차종을 선택하세요.", "CarTypeCode", "warning");
        return false;
    }

    if (!$("#FTLFlag").val()) {
        fnDefaultAlertFocus("독차/혼적 구분을 선택하세요.", "FTLFlag", "warning");
        return false;
    }

    if (!$("#GoodsRunType").val()) {
        fnDefaultAlertFocus("운행구분을 선택하세요.", "GoodsRunType", "warning");
        return false;
    }

    if (!$("#CarFixedFlag").val()) {
        fnDefaultAlertFocus("고정/용차 구분을 선택하세요.", "CarFixedFlag", "warning");
        return false;
    }

    if ($("#LayoverFlag").is(":checked")) {
        if (($("#SamePlaceCount").val() == "" || $("#SamePlaceCount").val() == "0") && ($("#NonSamePlaceCount").val() == "" || $("#NonSamePlaceCount").val() == "0")) {
            fnDefaultAlertFocus("지역수를 입력하세요.", "SamePlaceCount", "warning");
            return;
        }
    }

    //매출입 체크
    var AutoPay = false;
    var ClosingPay = false;
    if (AUIGrid.getGridData(GridPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridPayID),
            function (index, item) {
                if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                    if (item.PayType == 1 || item.PayType == 2) {
                        if (!AutoPay && item.ApplySeqNo > 0) {
                            AutoPay = true;
                        }

                        if (!ClosingPay && (item.ItemCode == "OP001" || item.ItemCode == "OP088" || item.ItemCode == "OP089") && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) { //마감비용 체크
                            ClosingPay = true;
                        }
                    }
                }
            });
    }

    //자동운임체크
    if ($("#ContractType").val() !== "3") {
        if (!ClosingPay) {
            if (AutoPay) {
                if (fnGetRateConditionChange()) {
                    $(".TrCallTransRate").show();
                    fnDefaultAlert("자동운임 확인이 필요하여 자동 조회합니다. 변경된 비용정보를 확인해 주세요.", "warning", "$(\"#BtnCallTransRate\").show();$(\"#BtnCallTransRate\").click();");
                    return false;
                }
            } else {
                if ($("#CenterCode").val() && $("#ConsignorCode").val() && $("#PayClientCode").val() && $("#PickupPlaceFullAddr").val() && $("#GetPlaceFullAddr").val() && $("#CarTonCode").val() && $("#CarTypeCode").val() && $("#FTLFlag").val() && $("#GoodsRunType").val() && $("#CarFixedFlag").val()) {
                    if (fnGetRateConditionChange()) {
                        fnDefaultAlert("자동운임 확인이 필요하여 자동 조회합니다. 변경된 비용정보를 확인해 주세요.", "warning", "$(\"#BtnCallTransRate\").show();$(\"#BtnCallTransRate\").click();");
                        return false;
                    }
                }
            }
        } else {
            if (AutoPay && fnGetRateConditionChange()) {
                fnDefaultAlert("마감된 자동운임이 있어 일부 항목 변경이 불가능합니다.", "warning");
                return false;
            }
        }
    }

    strCallType = "Domestic" + $("#HidMode").val();
    strConfMsg = "오더를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsOrderProc", fnParam);
    return false;
}

function fnInsOrderProc(fnParam) {
    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnAjaxInsOrder";

    var objParam = {
        CallType: fnParam,
        OrderNo: $("#OrderNo").val(),
        CenterCode: $("#CenterCode").val(),
        GoodsSeqNo: $("#GoodsSeqNo").val(),
        GoodsDispatchType: $("#GoodsDispatchType").val(),
        OrderLocationCode: $("#OrderLocationCode").val(),
        OrderItemCode: $("#OrderItemCode").val(),
        ConsignorCode: $("#ConsignorCode").val(),
        ConsignorName: $("#ConsignorName").val(),
        OrderClientCode: $("#OrderClientCode").val(),
        OrderClientName: $("#OrderClientName").val(),
        OrderClientChargeName: $("#OrderClientChargeName").val(),
        OrderClientChargePosition: $("#OrderClientChargePosition").val(),
        OrderClientChargeTelExtNo: $("#OrderClientChargeTelExtNo").val(),
        OrderClientChargeTelNo: $("#OrderClientChargeTelNo").val(),
        OrderClientChargeCell: $("#OrderClientChargeCell").val(),
        PayClientCode: $("#PayClientCode").val(),
        PayClientName: $("#PayClientName").val(),
        PayClientChargeName: $("#PayClientChargeName").val(),
        PayClientChargePosition: $("#PayClientChargePosition").val(),
        PayClientChargeTelExtNo: $("#PayClientChargeTelExtNo").val(),
        PayClientChargeTelNo: $("#PayClientChargeTelNo").val(),
        PayClientChargeCell: $("#PayClientChargeCell").val(),
        PayClientChargeLocation: $("#PayClientChargeLocation").val(),
        PickupYMD: $("#PickupYMD").val(),
        PickupHM: $("#PickupHM").val(),
        PickupWay: $("#PickupWay").val(),
        PickupPlaceLocal: $("#PickupPlaceLocal").val(),
        PickupPlaceLocalCode: $("#PickupPlaceLocalCode").val(),
        PickupPlaceLocalName: $("#PickupPlaceLocalName").val(),
        PickupPlace: $("#PickupPlace").val(),
        PickupPlaceChargeName: $("#PickupPlaceChargeName").val(),
        PickupPlaceChargePosition: $("#PickupPlaceChargePosition").val(),
        PickupPlaceChargeTelExtNo: $("#PickupPlaceChargeTelExtNo").val(),
        PickupPlaceChargeTelNo: $("#PickupPlaceChargeTelNo").val(),
        PickupPlaceChargeCell: $("#PickupPlaceChargeCell").val(),
        PickupPlacePost: $("#PickupPlacePost").val(),
        PickupPlaceAddr: $("#PickupPlaceAddr").val(),
        PickupPlaceAddrDtl: $("#PickupPlaceAddrDtl").val(),
        PickupPlaceFullAddr: $("#PickupPlaceFullAddr").val(),
        PickupPlaceNote: $("#PickupPlaceNote").val(),
        GetYMD: $("#GetYMD").val(),
        GetHM: $("#GetHM").val(),
        GetWay: $("#GetWay").val(),
        GetPlaceLocal: $("#GetPlaceLocal").val(),
        GetPlaceLocalCode: $("#GetPlaceLocalCode").val(),
        GetPlaceLocalName: $("#GetPlaceLocalName").val(),
        GetPlace: $("#GetPlace").val(),
        GetPlaceChargeName: $("#GetPlaceChargeName").val(),
        GetPlaceChargePosition: $("#GetPlaceChargePosition").val(),
        GetPlaceChargeTelExtNo: $("#GetPlaceChargeTelExtNo").val(),
        GetPlaceChargeTelNo: $("#GetPlaceChargeTelNo").val(),
        GetPlaceChargeCell: $("#GetPlaceChargeCell").val(),
        GetPlacePost: $("#GetPlacePost").val(),
        GetPlaceAddr: $("#GetPlaceAddr").val(),
        GetPlaceAddrDtl: $("#GetPlaceAddrDtl").val(),
        GetPlaceFullAddr: $("#GetPlaceFullAddr").val(),
        GetPlaceNote: $("#GetPlaceNote").val(),
        GoodsNote: $("#GoodsNote").val(),
        GoodsName: $("#GoodsName").val(),
        GoodsItemCode: $("#GoodsItemCode").val(),
        CarTonCode: $("#CarTonCode").val(),
        CarTypeCode: $("#CarTypeCode").val(),
        Volume: $("#Volume").val(),
        Weight: $("#Weight").val(),
        CBM: $("#CBM").val(),
        Length: $("#Length").val(),
        FTLFlag: $("#FTLFlag").val(),
        GoodsRunType: $("#GoodsRunType").val(),
        CarFixedFlag: $("#CarFixedFlag").val(),
        LayoverFlag: $("#LayoverFlag").is(":checked") ? "Y" : "N",
        SamePlaceCount: $("#SamePlaceCount").val(),
        NonSamePlaceCount: $("#NonSamePlaceCount").val(),
        NoteInside: $("#NoteInside").val(),
        NoteClient: $("#NoteClient").val(),
        RefSeqNo: $("#RefSeqNo").val(),
        QuickType: $("#QuickType").val(),
        ChgSeqNo: $("#ChgSeqNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsOrder(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
        return false;
    } else {
        if ($("#HidMode").val() === "Insert") {
            $("#OrderNo").val(data[0].OrderNo + "");
            $("#GoodsSeqNo").val(data[0].GoodsSeqNo + "");
            $("#DispatchSeqNo").val(data[0].DispatchSeqNo + "");
        } else {
            strSaleClosingFlag = data[0].SaleClosingFlag;
            strPurchaseClosingFlag = data[0].PurchaseClosingFlag;
        }
        fnInsPay();
    }
}

// 비용 등록/수정/삭제
var PayList = null;
var PayCnt = 0;
var PayProcCnt = 0;
var PaySuccessCnt = 0;
var PayFailCnt = 0;
function fnInsPay() {
    var GridItems = AUIGrid.getGridData(GridPayID);
    PayList = [];
    $.each(GridItems, function (index, item) {
        if (item.SeqNo === "" || AUIGrid.isAddedById(GridPayID, item.PaySeqNo) || AUIGrid.isEditedById(GridPayID, item.PaySeqNo) || AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
            PayList.push(item);
        }
    });


    if (PayList.length > 0) {
        PayCnt = PayList.length;
        PayProcCnt = 0;
        PaySuccessCnt = 0;
        PayFailCnt = 0;
        fnInsPayProc();
        return false;
    } else {
        fnOrderInsEnd();
        return false;
    }
}

function fnInsPayProc() {
    AUIGrid.showAjaxLoader(GridPayID);
    if (PayProcCnt >= PayCnt) {
        AUIGrid.removeAjaxLoader(GridPayID);
        fnOrderInsEnd();
        return;
    }

    var RowPay = PayList[PayProcCnt];
    if (AUIGrid.isEditedById(GridPayID, RowPay.PaySeqNo)) {
        if (RowPay.SeqNo === "") {
            RowPay.CallType = "DomesticPayInsert";
        } else {
            RowPay.CallType = "DomesticPayUpdate";
        }
    } else if (AUIGrid.isRemovedById(GridPayID, RowPay.PaySeqNo)) {
        RowPay.CallType = "DomesticPayDelete";
    } else { //isAddedById
        RowPay.CallType = "DomesticPayInsert";
    }

    RowPay.CenterCode = $("#CenterCode").val();
    RowPay.OrderNo = $("#OrderNo").val();
    RowPay.GoodsSeqNo = $("#GoodsSeqNo").val();

    if ($("#GoodsDispatchType").val() === "2" && RowPay.PayType == "2" && (RowPay.ClientCode == "" || RowPay.ClientCode == "0")) {
        RowPay.DispatchSeqNo = $("#DispatchSeqNo").val();
    }

    if (RowPay) {
        var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
        var strCallBackFunc = "fnGridPayInsSuccResult";
        var strFailCallBackFunc = "fnGridPayInsFailResult";
        var objParam = RowPay;
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
    }
}

function fnGridPayInsSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            PaySuccessCnt++;
        } else {
            PayFailCnt++;
        }
    } else {
        PayFailCnt++;
    }
    PayProcCnt++;
    setTimeout(fnInsPayProc(), 500);
}

function fnGridPayInsFailResult() {
    PayProcCnt++;
    PayFailCnt++;
    setTimeout(fnInsPayProc(), 500);
    return false;
}

function fnOrderInsEnd() {
    var msg = "오더 " + ($("#HidMode").val() === "Update" ? "수정" : "등록") + "에 성공하였습니다.";

    if ($("#HidMode").val() === "Update") {
        if (strSaleClosingFlag === "Y" || strPurchaseClosingFlag === "Y") {
            msg = "일부 항목을 제외하고 오더 수정에 성공하였습니다.<br>(";
            if (strSaleClosingFlag === "Y" && strPurchaseClosingFlag === "Y") {
                msg += "매출마감 : Y, 매입마감 : Y";
            } else if (strSaleClosingFlag === "Y" && strPurchaseClosingFlag !== "Y") {
                msg += "매출마감 : Y";
            } else if (strSaleClosingFlag !== "Y" && strPurchaseClosingFlag === "Y") {
                msg += "매입마감 : Y";
            }
            msg += ")";
        }
    }

    fnDefaultAlert(msg, "info", "fnOrderReload()");
}

function fnOrderReload() {
    document.location.replace("/APP/TMS/Domestic/DomesticIns?OrderNo=" + $("#OrderNo").val() + "&HidParam=" + $("#HidParam").val());
}
/*****************************************/
//한도 및 원가율 계산
function fnChkSaleLimit() {

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return;
    }

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if (!$("#GoodsDispatchType").val()) {
        fnDefaultAlertFocus("배차구분을 선택하세요.", "GoodsDispatchType", "warning");
        return;
    }

    if (!$("#PayClientCode").val()) {
        fnDefaultAlertFocus("청구처를 검색하세요.", "PayClientName", "warning");
        return;
    }

    if (!$("#PickupYMD").val()) {
        fnDefaultAlertFocus("상차일을 입력하세요.", "PickupYMD", "warning");
        return;
    }

    var strHandlerUrl = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnChkSaleLimitSuccResult";
    var strFailCallBackFunc = "fnChkSaleLimitFailResult";
    var objParam = {
        CallType: "ClientSaleLimit",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        PayClientCode: $("#PayClientCode").val(),
        PickupYMD: $("#PickupYMD").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnChkSaleLimitSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode == 0) {
            //매출입 체크
            var SaleAmt = 0;
            var AdvanceAmt = 0;
            var PurchaseAmt = 0;
            if (AUIGrid.getGridData(GridPayID).length > 0) {
                $.each(AUIGrid.getGridData(GridPayID),
                    function (index, item) {
                        if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                            if (item.PayType == 1) {
                                SaleAmt += typeof item.SupplyAmt === "number" ? item.SupplyAmt : Number(item.SupplyAmt.replace(/,/gi, ""));
                            }

                            if (item.PayType == 2) {
                                PurchaseAmt += typeof item.SupplyAmt === "number" ? item.SupplyAmt : Number(item.SupplyAmt.replace(/,/gi, ""));
                            }

                            if (item.PayType == 3 || item.PayType == 4) {
                                AdvanceAmt += typeof item.SupplyAmt === "number" ? item.SupplyAmt : Number(item.SupplyAmt.replace(/,/gi, ""));
                            }
                        }
                    });
            }

            if (PurchaseAmt > 0 && SaleAmt <= 0 && $("#GoodsDispatchType").val() == "2") {
                fnDefaultAlert("매입은 매출입력 후 오더" + ($("#HidMode").val() === "Update" ? "수정" : "등록") + "이 가능합니다.", "warning");
                return;
            }

            if (objRes[0].ClientBusinessStatus == 4 && $("#HidMode").val() == "Insert") {
                fnDefaultAlert("거래 정지상태인 청구처입니다.");
                return false;
            }

            //한도 체크 대상일 때 매출 한도 체크
            if (objRes[0].LimitCheckFlag == "Y") {
                if (SaleAmt + AdvanceAmt > 0) {
                    if (objRes[0].LimitAvailAmt + objRes[0].TotalSaleAmt < (SaleAmt + AdvanceAmt)) {
                        fnDefaultAlert("매출 한도를 초과하여 오더를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록") + "하실 수 없습니다.");
                        return false;
                    }
                }
            }

            //원가율 체크
            if (objRes[0].RevenueLimitPer > 0 && $("#GoodsDispatchType").val() == "2") {
                if (SaleAmt > 0 && PurchaseAmt > 0) {
                    if (parseFloat(PurchaseAmt) / parseFloat(SaleAmt) * 100 > parseFloat(objRes[0].RevenueLimitPer)) {
                        fnDefaultAlert("매출 원가율(" + objRes[0].RevenueLimitPer + "%)을 초과했습니다.");
                        return false;
                    }
                }
            }

            if ($("#TransType").val() === "3") {
                fnDefaultConfirm("오더를 수정하시겠습니까?", "fnInsPay", "");
                return false;
            }
            fnInsOrder();
            return false;
        } else {
            fnChkSaleLimitFailResult();
            return false;
        }
    } else {
        fnChkSaleLimitFailResult();
        return false;
    }
}

function fnChkSaleLimitFailResult() {
    fnDefaultAlert("매출한도 조회에 실패했습니다. 나중에 다시 시도해주세요.");
    return false;
}
/*****************************************/
/*리스트 돌아가기*/
function fnListBack() {
    document.location.href = "/APP/TMS/Domestic/DomesticList?" + strListDataParam;
}