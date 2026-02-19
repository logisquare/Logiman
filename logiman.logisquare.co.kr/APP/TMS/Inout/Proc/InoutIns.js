var strCenterCode = "";
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
        return false;
    });

    //오더등록
    $("#BtnRegOrder").on("click", function (e) {
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

    //계산서 검색 버튼
    $("#TaxClientName").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(11);
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

    //비용등록 업체명 검색
    $("#ClientName").on("click", function (e) {
        e.preventDefault();
        fnOpenSearchInfo(10);
        return false;
    });

    //화물 추가
    $("#BtnAddGoodsItem").on("click", function (e) {
        e.preventDefault();
        fnAddGoodsItem();
        return;
    });

    //화물 다시 입력
    $("#BtnResetGoodsItem").on("click", function (e) {
        e.preventDefault();
        fnResetGoodsItem();
        return;
    });

    //비용
    //추가
    $("#BtnAddPay").on("click", function (e) {
        if ($("#ContractType").val() === "3" && $("#PayType").val() === "1") {
            fnDefaultAlert("수탁 오더는 매출을 등록 하실 수 없습니다.");
            return false;
        }

        if ($("#ItemCode").val() === "OP001" && $("#FTLFlag").is(":checked")) {
            fnDefaultAlert("독차오더의 운임은 웹에서만 등록 하실 수 있습니다.");
            return false;
        }

        fnPayAddRow();
        return false;
    });

    //수정
    $("#BtnUpdPay").on("click", function (e) {
        if ($("#ContractType").val() === "3" && $("#PayType").val() === "1") {
            fnDefaultAlert("수탁 오더는 매출을 수정 하실 수 없습니다.");
            return false;
        }

        if ($("#ItemCode").val() === "OP001" && $("#FTLFlag").is(":checked")) {
            fnDefaultAlert("독차오더의 운임은 웹에서만 수정 하실 수 있습니다.");
            return false;
        }

        fnPayUpdRow();
        return false;
    });

    //삭제
    $("#BtnDelPay").on("click", function (e) {
        if ($("#ContractType").val() === "3" && $("#PayType").val() === "1") {
            fnDefaultAlert("수탁 오더는 매출을 삭제 하실 수 없습니다.");
            return false;
        }

        if ($("#ItemCode").val() === "OP001" && $("#FTLFlag").is(":checked")) {
            fnDefaultAlert("독차오더의 운임은 웹에서만 삭제 하실 수 있습니다.");
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

    //폼 이벤트
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
    });

    $("#OrderItemCode").on("change",
        function (e) {
            fnSetInout();
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

    //기본 설정 값
    fnSetPay();

    if (!$("#OrderNo").val()) {
        fnSetInout();
    }

    fnSetInitData();
});

//수출입에 따른 항목 세팅
function fnSetInout() {
    if (($("#HidMode").val() === "Insert")) {
        if ($("#OrderItemCode option:selected").text().indexOf("해상수출") > -1) { //수입
            $("#ArrivalReportFlag").prop("checked", true);
        } else {
            $("#ArrivalReportFlag").prop("checked", false);
        }
    }
}

//기본정보 세팅
function fnSetInitData() {
    $("#PopMastertitle").text("수출입 오더등록");

    fnChangeDate("1", "PickupYMD");
    fnChangeDate("1", "GetYMD");

    $(".DispatchInfo").hide();

    if ($("#HidMode").val() === "Update" || ($("#HidMode").val() === "Insert" && $("#CopyFlag").val() === "Y")) {
        fnCallOrderDetail();
        $(".DispatchInfo").show();
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

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnAjaxSetCodeList";

    var objParam = {
        CallType: "InoutCodeList",
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

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnOrderDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "InoutList",
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
        fnSetInout();

        //Checkbox
        $("#NoLayerFlag").prop("checked", item.NoLayerFlag === "Y");
        $("#NoTopFlag").prop("checked", item.NoTopFlag === "Y");
        $("#FTLFlag").prop("checked", item.FTLFlag === "Y");
        $("#CustomFlag").prop("checked", item.CustomFlag === "Y");
        $("#BondedFlag").prop("checked", item.BondedFlag === "Y");
        $("#DocumentFlag").prop("checked", item.DocumentFlag === "Y");
        $("#ArrivalReportFlag").prop("checked", item.ArrivalReportFlag === "Y");
        $("#LicenseFlag").prop("checked", item.LicenseFlag === "Y");
        $("#InTimeFlag").prop("checked", item.InTimeFlag === "Y");
        $("#ControlFlag").prop("checked", item.ControlFlag === "Y");
        $("#QuickGetFlag").prop("checked", item.QuickGetFlag === "Y");

        //RadioButton

        //Span
        $("#OrderStatusM").text("[" + item.OrderStatusM + "]");
        $("#AcceptDate").text(item.AcceptDate);
        $("#AcceptAdminName").text(item.AcceptAdminName);

        if ($("#CopyFlag").val() === "Y") {
            $("#HidMode").val("Insert");
            $("#CopyFlag").val("N");
            $("#CnlFlag").val("N");
            $("#OrderNo").val("");
            fnChangeDate("1", "PickupYMD");
            $("#PickupHM").val("");
            fnChangeDate("1", "GetYMD");
            $("#GetHM").val("");
            $("#DocumentFlag").prop("checked", false);
            $("#Sec4 input").val("");
            $("#Sec4 select").val("");
            return false;
        }

        if ($("#CnlFlag").val() === "Y") {
            $("#BtnRegOrder").hide();
            $("#BtnCancelOrder").hide();
        }

        //위수탁 정보 조회
        fnCallOrderContract();

        //배차 정보 조회
        fnCallDispatchData();

        //비용 목록 조회
        fnCallPayGridData(GridPayID);
    }
    else {
        fnCallDetailFailResult();
    }
}

function fnCallDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

//위수탁 정보 조회
function fnCallOrderContract() {

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCallOrderContractSuccResult";
    var strFailCallBackFunc = "fnCallOrderContractFailResult";

    var objParam = {
        CallType: "InoutContract",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
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
            $(".NotAllowedContractTarget").show();
            $("#OrderItemCode option:not(:selected)").prop("disabled", true);
        }
    } else {
        fnCallOrderContractFailResult();
    }
}

function fnCallOrderContractFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

// 배차 목록
function fnCallDispatchData() {
    if (!$("#OrderNo").val() || !$("#CenterCode").val() || !$("#GoodsSeqNo").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCallDispatchSuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "InoutDispatchCarList",
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
        case 11: //계산서
            strTitle = "계산서 업체 검색";
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
        case "11": //계산서 업체업체
            fnGetSearchInfoClient(11);
            break;
        default:
            fnDefaultAlert("올바르지 않은 접근입니다.");
            return false;
    }
}

//화주
function fnGetSearchInfoConsignor() {
    var strHandlerUrl = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnGetSearchInfoConsignorResult";
    var strFailCallBackFunc = "fnCallSearchInfoFailResult";

    var objParam = {
        CallType: "ConsignorList",
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#OrderClientCode").val(),
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
        $.each(objRes[0].data.list, function (index, item) {
            html += "<li>\n";
            html += "\t<input type=\"radio\" id=\"SearchChk" + index + "\" name=\"SearchChk\" />\n";
            html += "\t<label for=\"SearchChk" + index + "\">\n";
            html += "\t\t<strong>" + item.ConsignorInfo + "</strong>\n";
            html += "\t\t<span class=\"data\" data-field=\"ConsignorCode\">" + item.ConsignorCode + "</span>\n";
            html += "\t\t<span class=\"data\" data-field=\"ConsignorName\">" + item.ConsignorName + "</span>\n";
            html += "\t\t<span class=\"check_icon\"></span>";
            html += "\t</label>";
            html += "</li>";
        });

        $("#SearchInfoLayer .info_list").html(html);
    }
}

//발주처, 청구처, 매입/선급금, 계산서 업체 
function fnGetSearchInfoClient(intType) {
    var strHandlerUrl = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnGetSearchInfoClientResult";
    var strFailCallBackFunc = "fnCallSearchInfoFailResult";

    var objParam = {
        CallType: "ClientList",
        CenterCode: $("#CenterCode").val(),
        ClientName: $("#SearchText").val(),
        ClientFlag: intType === 4 || intType === 10 ? "Y" : "",
        ChargeFlag: intType === 4 || intType === 11 ? "Y" : "",
        ChargeBillFlag: intType === 11 ? "Y" : ""
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

    var strHandlerUrl = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
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

    var strHandlerUrl = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
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

    var strHandlerUrl = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
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
            if ($("#PayClientCode").val() == objItem.ClientCode && objItem.ChargeName != "") {
                $("#PayClientChargeName").val(objItem.ChargeName);
                $("#PayClientChargePosition").val(objItem.ChargePosition);
                $("#PayClientChargeTelExtNo").val(objItem.ChargeTelExtNo);
                $("#PayClientChargeTelNo").val(objItem.ChargeTelNo);
                $("#PayClientChargeCell").val(objItem.ChargeCell);
                $("#PayClientChargeLocation").val(objItem.ChargeLocation);
            }
        }

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
        if ($("#OrderItemCode option:selected").text().indexOf("수입") > -1) {
            $("#PickupPlaceNote").val(objItem.PlaceRemark2);
        } else {
            $("#PickupPlaceNote").val(objItem.PlaceRemark3);
        }

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
        if ($("#OrderItemCode option:selected").text().indexOf("수입") > -1) {
            $("#PickupPlaceNote").val(objItem.PlaceRemark2);
        } else {
            $("#PickupPlaceNote").val(objItem.PlaceRemark3);
        }

        fnSetFocus();

    } else if (strType === "10") { //매입,선급금 등 업체

        $("#ClientCode").val(objItem.ClientCode);
        $("#ClientInfo").val(objItem.ClientInfo);
        $("#ClientName").val(objItem.ClientName);

    } else if (strType === "11") { //계산서 업체

        $("#TaxClientName").val(objItem.ClientName);
        $("#TaxClientCorpNo").val(objItem.ClientCorpNo);
        $("#TaxClientChargeName").val(objItem.ChargeName);
        $("#TaxClientChargeTelNo").val(objItem.ChargeTelNo);
        $("#TaxClientChargeEmail").val(objItem.ChargeEmail);

    }

    fnCloseSearchInfo();
    return false;
}

function fnSetFocus() {

    if (!$("#OrderClientCode").val()) {
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
    } else if (!$("#PayClientChargeLocation").val()) {
        $("#PayClientChargeLocation").focus();
        return false;
    } else if (!$("#ConsignorCode").val()) {
        $("#ConsignorName").focus();
        return false;
    } else if (!$("#PickupYMD").val()) {
        $("#PickupYMD").focus();
        return false;
    } else if (!$("#PickupPlace").val()) {
        $("#PickupPlace").focus();
        return false;
    }/* else if (!$("#PickupPlaceChargeName").val()) {
        $("#PickupPlaceChargeName").focus();
        return false;
    }*/ else if (!$("#PickupPlaceChargeTelNo").val() && !$("#PickupPlaceChargeCell").val()) {
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
    }/* else if (!$("#GetPlaceChargeName").val()) {
        $("#GetPlaceChargeName").focus();
        return false;
    }*/ else if (!$("#GetPlaceChargeTelNo").val() && !$("#GetPlaceChargeCell").val()) {
        $("#GetPlaceChargeTelNo").focus();
        return false;
    } else if (!$("#GetPlaceAddr").val()) {
        $("#BtnSearchAddrGetPlace").focus();
        return false;
    }
}
/******************************************/

/*********************************************/
// 비용 그리드
/*********************************************/
var GridPayID = "#AppInoutPayListGrid";

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
        if (item.ClosingFlag == "Y" || item.BillStatus !== 1 || item.SendStatus !== 1) { //마감, 계산서발행, 송금
            return "aui-grid-closing-y-row-style";
        }
        return "";
    }

    var objResultLayout = fnGetDefaultPayColumnLayout();

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
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

    if (typeof objItem.RefSeqNo !== "undefined") {
        if (objItem.RefSeqNo !== "" && objItem.RefSeqNo !== "0") {
            fnDefaultAlert("차량 비용은 수정할 수 없습니다", "error");
            return;
        }
    }

    if (objItem.ClosingFlag !== "N" || objItem.BillStatus !== 1 || objItem.SendStatus !== 1) {
        fnDefaultAlert("마감된 비용은 수정할 수 없습니다", "error");
        return;
    }

    fnDisplayPay(objItem);
}

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallPayGridData(strGID) {

    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnPayGridSuccResult";

    var objParam = {
        CallType: "InoutPayList",
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
    if ($("#ItemCode").val() === "OP001" && ($("#PayType").val() == "1" || $("#PayType").val() == "2")) {
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
        } else {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
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
    objItem.SeqNo = "";
    objItem.PaySeqNo = "";
    objItem.CenterCode = $("#CenterCode").val();
    objItem.OrderNo = $("#OrderNo").val();
    objItem.GoodsSeqNo = $("#GoodsSeqNo").val();
    objItem.PayType = $("#PayType").val();
    objItem.TaxKind = $("#TaxKind").val();
    objItem.ItemCode = $("#ItemCode").val();
    objItem.ClientCode = $("#ClientCode").val();
    objItem.ClientName = $("#ClientName").val();
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
    AUIGrid.addRow(GridPayID, objItem, "last");
    fnSetPay();
}

//비용수정
function fnPayUpdRow() {
    var strClientInfo = "";

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
    if ($("#ItemCode").val() === "OP001" && ($("#PayType").val() == "1" || $("#PayType").val() == "2")) {
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
            fnDefaultAlert("운임은 매출/매입에 한건씩 입력이 가능합니다.", "warning");
            return;
        }
    }

    if ($("#PayType").val() === "2") { //매입
        if ($("#ClientCode").val() && $("#ClientCode").val() !== "0") {
            strClientInfo = $("#ClientInfo").val();
        } else {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
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
    objItem.SeqNo = $("#SeqNo").val();
    objItem.PaySeqNo = $("#PaySeqNo").val();
    objItem.CenterCode = $("#CenterCode").val();
    objItem.OrderNo = $("#OrderNo").val();
    objItem.GoodsSeqNo = $("#GoodsSeqNo").val();
    objItem.PayType = $("#PayType").val();
    objItem.TaxKind = $("#TaxKind").val();
    objItem.ItemCode = $("#ItemCode").val();
    objItem.ClientCode = $("#ClientCode").val();
    objItem.ClientName = $("#ClientName").val();
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
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

//오더등록/수정
function fnInsOrder() {

    var strConfMsg = "";
    var strCallType = "";
    strSaleClosingFlag = "N";
    strPurchaseClosingFlag = "N";

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return;
    }

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if (!$("#OrderLocationCode").val()) {
        fnDefaultAlertFocus("사업장을 선택하세요.", "OrderLocationCode", "warning");
        return;
    }

    if (!$("#OrderItemCode").val()) {
        fnDefaultAlertFocus("상품을 선택하세요.", "OrderItemCode", "warning");
        return;
    }

    if (!$("#OrderClientCode").val()) {
        fnDefaultAlertFocus("발주처를 검색하세요.", "OrderClientName", "warning");
        return;
    }

    if (!$("#OrderClientChargeName").val()) {
        fnDefaultAlertFocus("발주처 담당자명을 입력(or 검색)하세요.", "OrderClientChargeName", "warning");
        return;
    }

    if (!$("#OrderClientChargeTelNo").val() && !$("#OrderClientChargeCell").val()) {
        fnDefaultAlertFocus("발주처 담당자의 전화번호나 휴대폰번호를 입력하세요.", "OrderClientChargeTelNo", "warning");
        return;
    }

    if (!$("#PayClientCode").val()) {
        fnDefaultAlertFocus("청구처를 검색하세요.", "PayClientName", "warning");
        return;
    }

    if (!$("#PayClientChargeName").val()) {
        fnDefaultAlertFocus("청구처 담당자명을 입력(or 검색)하세요.", "PayClientChargeName", "warning");
        return;
    }

    if (!$("#PayClientChargeTelNo").val() && !$("#PayClientChargeCell").val()) {
        fnDefaultAlertFocus("청구처 담당자의 전화번호나 휴대폰번호를 입력하세요.", "PayClientChargeTelNo", "warning");
        return;
    }

    if ($("#ContractType").val() !== "3") {
        if (!$("#PayClientChargeLocation").val()) {
            fnDefaultAlertFocus("청구사업장을 입력하세요.", "PayClientChargeLocation", "warning");
            return;
        }
    }

    if (!$("#ConsignorCode").val()) {
        fnDefaultAlertFocus("화주를 검색하세요.", "ConsignorName", "warning");
        return;
    }

    if (!$("#PickupYMD").val()) {
        fnDefaultAlertFocus("상차일을 입력하세요.", "PickupYMD", "warning");
        return;
    }

    if (!$("#PickupPlace").val()) {
        fnDefaultAlertFocus("상차지를 입력(or 검색)하세요.", "PickupPlace", "warning");
        return;
    }

    /*
    if (!$("#PickupPlaceChargeName").val()) {
        fnDefaultAlertFocus("상차지 담당자를 입력하세요.", "PickupPlaceChargeName", "warning");
        return;
    }
    */

    if (!$("#PickupPlaceChargeTelNo").val() && !$("#PickupPlaceChargeCell").val()) {
        fnDefaultAlertFocus("상차지 담당자의 전화번호나 휴대폰번호를 입력하세요.", "PickupPlaceChargeTelNo", "warning");
        return;
    }

    if (!$("#PickupPlacePost").val() || !$("#PickupPlaceAddr").val()) {
        fnDefaultAlertFocus("상차지 주소를 입력하세요.", "BtnSearchAddrPickupPlace", "warning");
        return;
    }

    if (!$("#GetYMD").val()) {
        fnDefaultAlertFocus("하차일을 입력하세요.", "GetYMD", "warning");
        return;
    }

    if (!$("#GetPlace").val()) {
        fnDefaultAlertFocus("하차지를 입력(or 검색)하세요.", "GetPlace", "warning");
        return;
    }

    /*
    if (!$("#GetPlaceChargeName").val()) {
        fnDefaultAlertFocus("하차지 담당자를 입력하세요.", "GetPlaceChargeName", "warning");
        return;
    }
    */

    if (!$("#GetPlaceChargeTelNo").val() && !$("#GetPlaceChargeCell").val()) {
        fnDefaultAlertFocus("하차지 담당자의 전화번호나 휴대폰번호를 입력하세요.", "GetPlaceChargeTelNo", "warning");
        return;
    }

    if (!$("#GetPlacePost").val() || !$("#GetPlaceAddr").val()) {
        fnDefaultAlertFocus("하차지 주소를 입력하세요.", "BtnSearchAddrGetPlace", "warning");
        return;
    }

    strCallType = "Inout" + $("#HidMode").val();
    strConfMsg = "오더를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsOrderProc", fnParam);
    return;
};

function fnInsOrderProc(fnParam) {
    var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnAjaxInsOrder";

    var objParam = {
        CallType: fnParam,
        OrderNo: $("#OrderNo").val(),
        CenterCode: $("#CenterCode").val(),
        OrderLocationCode: $("#OrderLocationCode").val(),
        OrderItemCode: $("#OrderItemCode").val(),
        NoLayerFlag: $("#NoLayerFlag").is(":checked") ? "Y" : "N",
        NoTopFlag: $("#NoTopFlag").is(":checked") ? "Y" : "N",
        FTLFlag: $("#FTLFlag").is(":checked") ? "Y" : "N",
        CarTonCode: $("#CarTonCode").val(),
        CarTypeCode: $("#CarTypeCode").val(),
        CustomFlag: $("#CustomFlag").is(":checked") ? "Y" : "N",
        BondedFlag: $("#BondedFlag").is(":checked") ? "Y" : "N",
        DocumentFlag: $("#DocumentFlag").is(":checked") ? "Y" : "N",
        ArrivalReportFlag: $("#ArrivalReportFlag").is(":checked") ? "Y" : "N",
        LicenseFlag: $("#LicenseFlag").is(":checked") ? "Y" : "N",
        InTimeFlag: $("#InTimeFlag").is(":checked") ? "Y" : "N",
        ControlFlag: $("#ControlFlag").is(":checked") ? "Y" : "N",
        QuickGetFlag: $("#QuickGetFlag").is(":checked") ? "Y" : "N",
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
        ConsignorCode: $("#ConsignorCode").val(),
        ConsignorName: $("#ConsignorName").val(),
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
        GoodsDispatchType: $("#GoodsDispatchType").val(),
        Nation: $("#Nation").val(),
        Hawb: $("#Hawb").val(),
        Mawb: $("#Mawb").val(),
        InvoiceNo: $("#InvoiceNo").val(),
        BookingNo: $("#BookingNo").val(),
        StockNo: $("#StockNo").val(),
        GMOrderType: $("#GMOrderType").val(),
        GMTripID: $("#GMTripID").val(),
        Volume: $("#Volume").val(),
        CBM: $("#CBM").val(),
        Weight: $("#Weight").val(),
        Length: $("#Length").val(),
        Quantity: $("#Quantity").val(),
        NoteInside: $("#NoteInside").val(),
        NoteClient: $("#NoteClient").val(),
        TaxClientName: $("#TaxClientName").val(),
        TaxClientCorpNo: $("#TaxClientCorpNo").val(),
        TaxClientChargeName: $("#TaxClientChargeName").val(),
        TaxClientChargeTelNo: $("#TaxClientChargeTelNo").val(),
        TaxClientChargeEmail: $("#TaxClientChargeEmail").val(),
        ChgSeqNo: $("#ChgSeqNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
};

function fnAjaxInsOrder(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
        return false;
    } else {
        if ($("#HidMode").val() === "Insert") {
            $("#OrderNo").val(data[0].OrderNo + "");
            $("#GoodsSeqNo").val(data[0].GoodsSeqNo + "");
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
            RowPay.CallType = "InoutPayInsert";
        } else {
            RowPay.CallType = "InoutPayUpdate";
        }
    } else if (AUIGrid.isRemovedById(GridPayID, RowPay.PaySeqNo)) {
        RowPay.CallType = "InoutPayDelete";
    } else { //isAddedById
        RowPay.CallType = "InoutPayInsert";
    }

    RowPay.CenterCode = $("#CenterCode").val();
    RowPay.OrderNo = $("#OrderNo").val();
    RowPay.GoodsSeqNo = $("#GoodsSeqNo").val();

    if ($("#GoodsDispatchType").val() === "2" && RowPay.PayType == "2" && (RowPay.ClientCode == "" || RowPay.ClientCode == "0")) {
        RowPay.DispatchSeqNo = $("#DispatchSeqNo").val();
    }

    if (RowPay) {
        var strHandlerURL = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
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
    document.location.replace("/APP/TMS/Inout/InoutIns?OrderNo=" + $("#OrderNo").val() + "&HidParam=" + $("#HidParam").val());
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

    if (!$("#PayClientCode").val()) {
        fnDefaultAlertFocus("청구처를 검색하세요.", "PayClientName", "warning");
        return;
    }

    if (!$("#PickupYMD").val()) {
        fnDefaultAlertFocus("상차일을 입력하세요.", "PickupYMD", "warning");
        return;
    }

    var strHandlerUrl = "/APP/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnChkSaleLimitSuccResult";
    var strFailCallBackFunc = "fnChkSaleLimitFailResult";
    var objParam = {
        CallType: "ClientSaleLimit",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        PayClientCode: $("#PayClientCode").val(),
        PickupYMD: $("#PickupYMD").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
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


/*********************************************/
// 화물 관리
/*********************************************/
$(document).ready(function () {

    //화물 상세 열기
    $("#BtnOpenPopGoodsItem").on("click", function (e) {
        fnOpenPopGoodsItem();
        return;
    });

    //화물 상세 적용하기
    $("#BtnSetPopGoodsItem").on("click", function (e) {
        fnResultSetPopGoodsItem();
        return false;
    });

    //화물 상세 추가
    $("#BtnAddPopGoodsItem").on("click", function (e) {
        e.preventDefault();
        fnAddPopGoodsItem();
        return false;
    });

    //화물 상세 다시입력
    $("#BtnResetPopGoodsItem").on("click", function (e) {
        e.preventDefault();
        fnResetPopGoodsItem();
        return false;
    });

    //화물 상세 팝업 닫기
    $("#BtnClosePopGoodsItem").on("click", function (e) {
        fnClosePopGoodsItem();
        return false;
    });

    $("#LinkClosePopGoodsItem").on("click", function (e) {
        fnClosePopGoodsItem();
        return false;
    });

    $("#PopGoodsItemVolume").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#BtnAddPopGoodsItem").click();
            }
        });
});

//화물 추가
function fnAddGoodsItem() {
    if (!$("#GoodsItemCode").val()) {
        fnDefaultAlertFocus("화물 품목을 선택하세요.", "GoodsItemCode", "warning");
        return false;
    }

    var item = $("#GoodsItemCode option:selected").text();
    var w = $("#GoodsItemWidth").val() ? $("#GoodsItemWidth").val() : "0";
    var h = $("#GoodsItemHeight").val() ? $("#GoodsItemHeight").val() : "0";
    var l = $("#GoodsItemLength").val() ? $("#GoodsItemLength").val() : "0";
    var v = $("#GoodsItemVolume").val() ? $("#GoodsItemVolume").val() : "0";
    var itemText = "";
    var totalVolume = $("#Volume").val() ? $("#Volume").val() : "0";
    var totalCbm = $("#CBM").val() ? $("#CBM").val() : "0.0";
    var volume = 0;
    var cbm = 0.0;

    itemText = item + " " + w + "*" + h + "*" + l + "*" + v;

    if ($("#Quantity").val()) {
        $("#Quantity").val($("#Quantity").val() + ", " + itemText);
    } else {
        $("#Quantity").val(itemText);
    }

    volume = parseInt(totalVolume) + parseInt(v);
    cbm = parseFloat(totalCbm) + ((parseFloat(w) / 1000) * (parseFloat(h) / 1000) * (parseFloat(l) / 1000) * 1000 * parseFloat(v));

    volume = isNaN(volume) ? 0 : volume;
    cbm = isNaN(cbm) ? 0 : parseFloat(parseInt(cbm * 100)) / 100;

    $("#Volume").val(volume);
    $("#CBM").val(cbm);

    $("#GoodsItemWidth").val("");
    $("#GoodsItemHeight").val("");
    $("#GoodsItemLength").val("");
    $("#GoodsItemVolume").val("");
    $("#GoodsItemWidth").focus();
}

//화물 다시 입력(삭제)
function fnResetGoodsItem() {
    $("#GoodsItemWidth").val("");
    $("#GoodsItemHeight").val("");
    $("#GoodsItemLength").val("");
    $("#GoodsItemVolume").val("");
    $("#Volume").val("");
    $("#CBM").val("");
    $("#Weight").val("");
    $("#Length").val("");
    $("#Quantity").val("");
    $("#GoodsItemWidth").focus();
}

//화물 상세수정 열기
function fnOpenPopGoodsItem() {
    var html = "";
    $("#PopVolume").val($("#Volume").val());
    $("#PopCBM").val($("#CBM").val());
    $("#PopWeight").val($("#Weight").val());
    $("#PopGoodsItemCode").val($("#GoodsItemCode").val());

    if ($("#Quantity").val()) {
        var arrQuantity = $("#Quantity").val().split(", ");
        for (var i = 0; i < arrQuantity.length; i++) {
            var arrQuantityItem = arrQuantity[i];
            if (arrQuantityItem.charAt(0) == " ") {
                arrQuantityItem = arrQuantityItem.substr(1);
            }
            html = "<li><a href=\"#\" onclick=\"fnSetPopGoodsItem(this); return false;\">" + arrQuantityItem + "</a> <a href=\"#\" onclick=\"fnDelPopGoodsItem(this); return false;\" class=\"file_del\">삭제</a></li>\n";

            $("#UlGoodsItemList").append(html);
        }
    }

    $("#DivGoods").show();
    if ($("#PopGoodsItemCode").val() != "") {
        $("#PopGoodsItemWidth").focus();
        return false;
    }
    $("#PopGoodsItemCode").focus();
}

//화물 상세수정 닫기
function fnClosePopGoodsItem() {
    $("#PopVolume").val("");
    $("#PopCBM").val("");
    $("#PopWeight").val("");
    $("#PopGoodsItemCode").val("");
    $("#PopGoodsItemWidth").val("");
    $("#PopGoodsItemHeight").val("");
    $("#PopGoodsItemLength").val("");
    $("#PopGoodsItemVolume").val("");
    $("#UlGoodsItemList li").remove();
    $("#DivGoods").hide();
}

//화물 상세수정 결과 적용
function fnResultSetPopGoodsItem() {
    var Quantity = [];
    $("#Volume").val($("#PopVolume").val());
    $("#CBM").val($("#PopCBM").val());
    $("#Weight").val($("#PopWeight").val());
    $.each($("#UlGoodsItemList li"), function (index, item) {
        Quantity.push($(item).children("a:first").text());
    });
    $("#Quantity").val(Quantity.join(", "));
    fnClosePopGoodsItem();
}

//화물 상세수정 결과 적용
function fnSetPopGoodsItem(obj) {
    var itemText = $(obj).text();
    var arrItemText = itemText.split("*");
    var GoodsItemCodeM = "";
    var GoodsItemWidth = "";
    if (arrItemText.length === 5) {
        GoodsItemCodeM = arrItemText[0].substring(0, arrItemText[0].indexOf(" "));
        GoodsItemWidth = arrItemText[0].substring(arrItemText[0].indexOf(" ") + 1, arrItemText[0].length);

        $.each($("#PopGoodsItemCode option"), function (index, item) {
            if ($(item).text() == GoodsItemCodeM) {
                $(item).prop("selected", true);
            }
        });
        $("#PopGoodsItemWidth").val(GoodsItemWidth);
        $("#PopGoodsItemHeight").val(arrItemText[1]);
        $("#PopGoodsItemLength").val(arrItemText[2]);
        $("#PopGoodsItemVolume").val(arrItemText[3]);
    } else if (arrItemText.length === 4) {
        GoodsItemCodeM = arrItemText[0].substring(0, arrItemText[0].indexOf(" "));
        GoodsItemWidth = arrItemText[0].substring(arrItemText[0].indexOf(" ") + 1, arrItemText[0].length);
        $.each($("#PopGoodsItemCode option"), function (index, item) {
            if ($(item).text() == GoodsItemCodeM) {
                $(item).prop("selected", true);
            }
        });
        $("#PopGoodsItemWidth").val(GoodsItemWidth);
        $("#PopGoodsItemHeight").val(arrItemText[1]);
        $("#PopGoodsItemLength").val(arrItemText[2]);
        $("#PopGoodsItemVolume").val(arrItemText[3]);
    } else {
        return false;
    }
}

//화물 상세수정 추가
function fnAddPopGoodsItem() {
    if (!$("#PopGoodsItemCode").val()) {
        fnDefaultAlertFocus("화물 품목을 선택하세요.", "PopGoodsItemCode", "warning");
        return false;
    }

    var item = $("#PopGoodsItemCode option:selected").text();
    var w = $("#PopGoodsItemWidth").val() ? $("#PopGoodsItemWidth").val() : "0";
    var h = $("#PopGoodsItemHeight").val() ? $("#PopGoodsItemHeight").val() : "0";
    var l = $("#PopGoodsItemLength").val() ? $("#PopGoodsItemLength").val() : "0";
    var v = $("#PopGoodsItemVolume").val() ? $("#PopGoodsItemVolume").val() : "0";
    var itemText = "";
    var html = "";

    itemText = item + " " + w + "*" + h + "*" + l + "*" + v;

    html = "<li><a href=\"#\" onclick=\"fnSetPopGoodsItem(this); return false;\">" + itemText + "</a> <a href=\"#\" onclick=\"fnDelPopGoodsItem(this); return false;\" class=\"file_del\">삭제</a></li>\n";
    $("#UlGoodsItemList").append(html);

    $("#PopGoodsItemWidth").val("");
    $("#PopGoodsItemHeight").val("");
    $("#PopGoodsItemLength").val("");
    $("#PopGoodsItemVolume").val("");
    $("#PopGoodsItemWidth").focus();
    fnCalcPopGoodsItem();
    return false;
}

// 화물 상세수정 다시입력
function fnResetPopGoodsItem() {
    $("#PopGoodsItemWidth").val("");
    $("#PopGoodsItemHeight").val("");
    $("#PopGoodsItemLength").val("");
    $("#PopGoodsItemVolume").val("");
    $("#PopGoodsItemWidth").focus();
}

//화물 상세수정 삭제
function fnDelPopGoodsItem(obj) {
    $(obj).parent("li").remove();
    fnCalcPopGoodsItem();
    return false;
}

function fnCalcPopGoodsItem() {
    var totalVolume = 0;
    var totalCbm = 0.0;

    $.each($("#UlGoodsItemList li"), function (index, item) {
        var arrItemText = $(item).text().split("*");
        var w = "0";
        var h = "0";
        var l = "0";
        var v = "0";
        if (arrItemText.length === 5) {
            w = arrItemText[0].substring(arrItemText[0].indexOf(" ") + 1, arrItemText[0].length);
            h = arrItemText[1];
            l = arrItemText[2];
            v = arrItemText[3];
        } else if (arrItemText.length === 4) {
            w = arrItemText[0].substring(arrItemText[0].indexOf(" ") + 1, arrItemText[0].length);
            h = arrItemText[1];
            l = arrItemText[2];
            v = arrItemText[3];
        }

        totalVolume += parseInt(v);
        totalCbm += (parseFloat(w) / 1000) * (parseFloat(h) / 1000) * (parseFloat(l) / 1000) * 1000 * parseFloat(v);
    });

    totalVolume = isNaN(totalVolume) ? 0 : totalVolume;
    totalCbm = isNaN(totalCbm) ? 0 : parseFloat(parseInt(totalCbm * 100)) / 100;

    $("#PopVolume").val(totalVolume);
    $("#PopCBM").val(totalCbm);
}
/*********************************************/
/*리스트 돌아가기*/
function fnListBack() {
    document.location.href = "/APP/TMS/Inout/InoutList?" + strListDataParam;
}