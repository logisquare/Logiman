var strCenterCode = "";
var strPayType = "";
var strSaleClosingFlag = "N";
var strPurchaseClosingFlag = "N";

$(document).ready(function () {

    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // f2
        if (event.keyCode === 113) {
            $("#BtnRegOrder").click();
           return false;
        }
    });

    $("#PickupYMD").datepicker({
        dateFormat: "yy-mm-dd"
    });
    $("#PickupYMD").datepicker("setDate", GetDateToday("-"));

    $("#ShipmentYMD").datepicker({
        dateFormat: "yy-mm-dd"
    });

    $("#EnterYMD").datepicker({
        dateFormat: "yy-mm-dd"
    });

    if ($("#hidDisplayMode").val() === "Y") {
        if (parent) {
            parent.fnReloadPageNotice($("#HidErrMsg").val());
        }
        else if (opener) {
            opener.fnReloadPageNotice($("#HidErrMsg").val());
        }
    }

    /**
      * 버튼 이벤트
      */
    //오더등록
    $("#BtnRegOrder").on("click", function (e) {
        fnChkSaleLimit(); //한도 및 원가율 계산
        return false;
    });

    //변경요청목록
    $("#BtnChangeRequestList").on("click", function (e) {
        fnDefaultAlert("준비중입니다.");
        return false;
    });

    //원본오더
    $("#BtnOriginalOrder").on("click", function (e) {
        fnDefaultAlert("원본오더가 없습니다.");
        return false;
    });

    //서비스이슈
    $("#BtnSQI").on("click", function (e) {
        if (!$("#OrderNo").val() || !$("#CenterCode").val()) {
            return false;
        }
        window.open("/TMS/Common/SQIDetailList?OrderType=3&CenterCode=" + $("#CenterCode").val() + "&OrderNo=" + $("#OrderNo").val(), "서비스이슈", "width=760, height=850, scrollbars=Yes");
    });

    //오더복사
    $("#BtnCopyOrder").on("click", function (e) {
        if (!$("#OrderNo").val()) {
            return false;
        }

        if (!$("#OldPickupPlaceFullAddr").val() && $("#PickupPlaceFullAddr").val()) {
            fnDefaultAlert("작업지 적용주소가 변경되었습니다.<br/>오더 등록 후 복사하실 수 있습니다.");
            return false;
        }

        if (!$("#OldPickupPlaceFullAddr").val() || !$("#PickupPlaceFullAddr").val()) {
            fnDefaultAlert("작업지 적용주소 정보가 없습니다.<br/>우편번호 검색 후 복사하실 수 있습니다.");
            return false;
        }

        document.location.replace("/TMS/Container/ContainerIns?OrderNo=" + $("#OrderNo").val() + "&CopyFlag=Y");
        return false;
    });

    //오더대량복사
    $("#BtnCopyOrders").on("click", function (e) {
        if (!$("#OrderNo").val() || !$("#CenterCode").val()) {
            return false;
        }

        if (!$("#OldPickupPlaceFullAddr").val() && $("#PickupPlaceFullAddr").val()) {
            fnDefaultAlert("작업지 적용주소가 변경되었습니다.<br/>오더 등록 후 복사하실 수 있습니다.");
            return false;
        }

        if (!$("#OldPickupPlaceFullAddr").val() || !$("#PickupPlaceFullAddr").val()) {
            fnDefaultAlert("작업지 적용주소 정보가 없습니다.<br/>우편번호 검색 후 복사하실 수 있습니다.");
            return false;
        }

        window.open("/TMS/Common/OrderCopy?OrderType=3&CenterCode=" + $("#CenterCode").val() + "&OrderNos=" + $("#OrderNo").val(), "오더대량복사", "width=1140, height=850, scrollbars=Yes");
        return false;
    });

    //새로등록
    $("#BtnGoWrite").on("click", function (e) {
        document.location.replace("/TMS/Container/ContainerIns");
        return false;
    });

    //오더취소
    $("#BtnCancelOrder").on("click", function (e) {
        if (!$("#OrderNo").val()) {
            return false;
        }
        fnCnlOrder();
        return false;
    });

    //발주처 검색
    $("#BtnSearchOrderClient").on("click", function (e) {
        fnListClient(1);
        return false;
    });

    //발주처 특이사항
    $("#BtnSearchOrderClientInfo").on("click", function (e) {
        if (!$("#OrderClientCode").val()) {
            fnDefaultAlert("선택된 발주처가 없습니다.");
            return false;
        }
        fnInfoClient(1, $("#OrderClientCode").val());
        return false;
    });

    //발주처미수내역
    $("#BtnOrderClientMisuAmt").on("click", function (e) {
        fnOpenMisuList("Order");
        return false;
    });

    //청구처 검색
    $("#BtnSearchPayClient").on("click", function (e) {
        fnListClient(2);
        return false;
    });

    //청구처 특이사항
    $("#BtnSearchPayClientInfo").on("click", function (e) {
        if (!$("#PayClientCode").val()) {
            fnDefaultAlert("선택된 청구처가 없습니다.");
            return false;
        }
        fnInfoClient(2, $("#PayClientCode").val());
        return false;
    });

    //청구처미수내역
    $("#BtnPayClientMisuAmt").on("click", function (e) {
        fnOpenMisuList("Pay");
        return false;
    });

    //화주 비고
    $("#BtnSearchConsignorInfo").on("click", function (e) {
        if (!$("#ConsignorCode").val()) {
            fnDefaultAlert("선택된 화주가 없습니다.");
            return false;
        }

        fnInfoClient(3, $("#ConsignorCode").val());
        return false;
    });

    //화주간편등록 열기
    $("#BtnOpenConsignor").on("click",
        function () {
            fnOpenPopConsignor();
            return false;
        });

    //화주간편등록 닫기
    $("#LinkPopCloseConsignor").on("click",
        function () {
            fnClosePopConsignor();
            return false;
        });

    //화주등록 
    $("#BtnPopRegConsignor").on("click",
        function () {
            fnRegPopConsignor();
            return false;
        });

    //화주간편등록 닫기
    $("#BtnPopCloseConsignor").on("click",
        function () {
            fnClosePopConsignor();
            return false;
        });

    //작업지 특이사항 조회
    $("#BtnOpenPickupPlaceNote").on("click", function (e) {
        fnOpenPlaceNote(1);
        return;
    });

    //작업지 주소 검색
    $("#BtnSearchAddrPickupPlace").on("click", function (e) {
        fnOpenAddress("PickupPlace");
        return;
    });

    //작업지 다시 입력 
    $("#BtnResetPickupPlace").on("click", function (e) {
        $(".TdPickup input").val("");
        $("#PickupYMD").datepicker("setDate", GetDateToday("-"));
        return;
    });

    //비용
    //추가
    $("#BtnAddPay").on("click", function (e) {
        fnPayAddRow();
        return false;
    });

    //수정
    $("#BtnUpdPay").on("click", function (e) {
        fnPayUpdRow();
        return false;
    });

    //삭제
    $("#BtnDelPay").on("click", function (e) {
        fnPayDelRow();
        return false;
    });

    //다시입력
    $("#BtnResetPay").on("click", function (e) {
        fnResetPay();
        return false;
    });

    /**
     * 폼 이벤트
     */
    $("#CenterCode").on("click", function () {
        strCenterCode = $(this).val();
    }).on("change", function () {

        var chkForm = false;
        //발주처, 청구처, 화주 체크
        $.each($(".TdClient input"), function (index, Item) {
            if ($(Item).val()) {
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

    $("#PickupPlaceSearch").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#BtnSearchAddrPickupPlace").click();
            }
        });

    $("#PickupPlaceLocal").on("change",
        function () {
            $("#PickupPlaceLocalCode").val("");
            $("#PickupPlaceLocalName").val("");
            if ($(this).val() !== "") {
                $("#PickupPlaceLocalCode").val($(this).val());
                $("#PickupPlaceLocalName").val($(this).children("option:selected").text());
            }
        });

    $("#PayType").on("click",
        function (e) {
            strPayType = $(this).val();
        });

    $("#PayType").on("change",
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

//기본정보 세팅
function fnSetInitData() {
    if ($("#HidMode").val() === "Update" || ($("#HidMode").val() === "Insert" && $("#CopyFlag").val() === "Y")) {
        fnCallOrderDetail();
    }

    //상단고정을 위한 margin
    if ($("#HidMode").val() === "Update") {
        $("table.order_table").css("margin-top", "147px");
    } else {
        $("table.order_table").css("margin-top", "119px");
    }

    //발주처 자동완성
    if ($("#OrderClientName").length > 0) {
        fnSetAutocomplete({
            formId: "OrderClientName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    var strOldOrderClientCode = $("#OrderClientCode").val();
                    var strOldPayClientCode = $("#PayClientCode").val();

                    $("#OrderClientCode").val(ui.item.etc.ClientCode);
                    $("#OrderClientName").val(ui.item.etc.ClientName);
                    $("#OrderClientChargeName").val(ui.item.etc.ChargeName);
                    $("#OrderClientChargePosition").val(ui.item.etc.ChargePosition);
                    $("#OrderClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#OrderClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#OrderClientChargeCell").val(ui.item.etc.ChargeCell);
                    if (ui.item.etc.MisuFlag === "Y") {
                        $("#SpanOrderClientMisuAmt").text("미수금액: " + fnMoneyComma(ui.item.etc.MisuAmt) + "원 / " + ui.item.etc.NoMatchingCnt + "건");
                        $("#BtnOrderClientMisuAmt").show();
                    } else {
                        $("#SpanOrderClientMisuAmt").text("");
                        $("#BtnOrderClientMisuAmt").hide();
                    }

                    if (!$("#PayClientCode").val() || strOldOrderClientCode == strOldPayClientCode) {
                        $("#PayClientCode").val(ui.item.etc.ClientCode);
                        $("#PayClientInfo").val(ui.item.etc.ClientInfo);
                        $("#PayClientName").val(ui.item.etc.ClientName);
                        $("#PayClientCorpNo").val(ui.item.etc.ClientCorpNo);
                        $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                        $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                        $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                        $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                        $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                        $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                        if (ui.item.etc.MisuFlag === "Y") {
                            $("#SpanPayClientMisuAmt").text("미수금액: " + fnMoneyComma(ui.item.etc.MisuAmt) + "원 / " + ui.item.etc.NoMatchingCnt + "건");
                            $("#BtnPayClientMisuAmt").show();
                        } else {
                            $("#SpanPayClientMisuAmt").text("");
                            $("#BtnPayClientMisuAmt").hide();
                        }
                    } else {
                        if ($("#PayClientCode").val() == ui.item.etc.ClientCode && ui.item.etc.ChargeName != "") {
                            $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                            $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                            $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                            $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                            $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                            $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                        }
                    }
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#OrderClientName").val()) {
                        $("#OrderClientCode").val("");
                        $("#OrderClientChargeName").val("");
                        $("#OrderClientChargePosition").val("");
                        $("#OrderClientChargeTelExtNo").val("");
                        $("#OrderClientChargeTelNo").val("");
                        $("#OrderClientChargeCell").val("");
                        $("#SpanOrderClientMisuAmt").text("");
                        $("#BtnOrderClientMisuAmt").hide();
                    }
                }
            }
        });
    }

    //발주처 담당자 자동완성
    if ($("#OrderClientChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "OrderClientChargeName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientChargeList",
                    ChargeName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName,
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    var strOldOrderClientCode = $("#OrderClientCode").val();
                    var strOldPayClientCode = $("#PayClientCode").val();

                    $("#OrderClientCode").val(ui.item.etc.ClientCode);
                    $("#OrderClientName").val(ui.item.etc.ClientName);
                    $("#OrderClientChargeName").val(ui.item.etc.ChargeName);
                    $("#OrderClientChargePosition").val(ui.item.etc.ChargePosition);
                    $("#OrderClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#OrderClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#OrderClientChargeCell").val(ui.item.etc.ChargeCell);
                    if (ui.item.etc.MisuFlag === "Y") {
                        $("#SpanOrderClientMisuAmt").text("미수금액: " + fnMoneyComma(ui.item.etc.MisuAmt) + "원 / " + ui.item.etc.NoMatchingCnt + "건");
                        $("#BtnOrderClientMisuAmt").show();
                    } else {
                        $("#SpanOrderClientMisuAmt").text("");
                        $("#BtnOrderClientMisuAmt").hide();
                    }

                    if (!$("#PayClientCode").val() || strOldOrderClientCode == strOldPayClientCode) {
                        $("#PayClientCode").val(ui.item.etc.ClientCode);
                        $("#PayClientInfo").val(ui.item.etc.ClientInfo);
                        $("#PayClientName").val(ui.item.etc.ClientName);
                        $("#PayClientCorpNo").val(ui.item.etc.ClientCorpNo);
                        $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                        $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                        $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                        $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                        $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                        $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                        if (ui.item.etc.MisuFlag === "Y") {
                            $("#SpanPayClientMisuAmt").text("미수금액: " + fnMoneyComma(ui.item.etc.MisuAmt) + "원 / " + ui.item.etc.NoMatchingCnt + "건");
                            $("#BtnPayClientMisuAmt").show();
                        } else {
                            $("#SpanPayClientMisuAmt").text("");
                            $("#BtnPayClientMisuAmt").hide();
                        }
                    } else {
                        if ($("#PayClientCode").val() == ui.item.etc.ClientCode && ui.item.etc.ChargeName != "") {
                            $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                            $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                            $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                            $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                            $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                            $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                        }
                    }
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#OrderClientChargeName").val()) {
                        $("#OrderClientChargePosition").val("");
                        $("#OrderClientChargeTelExtNo").val("");
                        $("#OrderClientChargeTelNo").val("");
                        $("#OrderClientChargeCell").val("");
                    }
                }
            }
        });
    }

    //청구처 자동완성
    if ($("#PayClientName").length > 0) {
        fnSetAutocomplete({
            formId: "PayClientName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    ClientFlag: "Y",
                    ChargeFlag: "Y",
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#PayClientCode").val(ui.item.etc.ClientCode);
                    $("#PayClientInfo").val(ui.item.etc.ClientInfo);
                    $("#PayClientName").val(ui.item.etc.ClientName);
                    $("#PayClientCorpNo").val(ui.item.etc.ClientCorpNo);
                    $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                    $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                    $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                    $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                    if (ui.item.etc.MisuFlag === "Y") {
                        $("#SpanPayClientMisuAmt").text("미수금액: " + fnMoneyComma(ui.item.etc.MisuAmt) + "원 / " + ui.item.etc.NoMatchingCnt + "건");
                        $("#BtnPayClientMisuAmt").show();
                    } else {
                        $("#SpanPayClientMisuAmt").text("");
                        $("#BtnPayClientMisuAmt").hide();
                    }
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#PayClientName").val()) {
                        $("#PayClientCode").val("");
                        $("#PayClientInfo").val("");
                        $("#PayClientCorpNo").val("");
                        $("#PayClientChargeName").val("");
                        $("#PayClientChargePosition").val("");
                        $("#PayClientChargeTelExtNo").val("");
                        $("#PayClientChargeTelNo").val("");
                        $("#PayClientChargeCell").val("");
                        $("#PayClientChargeLocation").val("");
                        $("#SpanPayClientMisuAmt").text("");
                        $("#BtnPayClientMisuAmt").hide();
                    }
                }
            }
        });
    }

    //청구처 담당자 자동완성
    if ($("#PayClientChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "PayClientChargeName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientChargeList",
                    ChargeName: request.term,
                    ClientFlag: "Y",
                    ChargeFlag: "Y",
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName,
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    $("#PayClientCode").val(ui.item.etc.ClientCode);
                    $("#PayClientInfo").val(ui.item.etc.ClientInfo);
                    $("#PayClientName").val(ui.item.etc.ClientName);
                    $("#PayClientCorpNo").val(ui.item.etc.ClientCorpNo);
                    $("#PayClientChargeName").val(ui.item.etc.ChargeName);
                    $("#PayClientChargePosition").val(ui.item.etc.ChargePosition);
                    $("#PayClientChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#PayClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#PayClientChargeCell").val(ui.item.etc.ChargeCell);
                    $("#PayClientChargeLocation").val(ui.item.etc.ChargeLocation);
                    if (ui.item.etc.MisuFlag === "Y") {
                        $("#SpanPayClientMisuAmt").text("미수금액: " + fnMoneyComma(ui.item.etc.MisuAmt) + "원 / " + ui.item.etc.NoMatchingCnt + "건");
                        $("#BtnPayClientMisuAmt").show();
                    } else {
                        $("#SpanPayClientMisuAmt").text("");
                        $("#BtnPayClientMisuAmt").hide();
                    }
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#PayClientChargeName").val()) {
                        $("#PayClientChargePosition").val("");
                        $("#PayClientChargeTelExtNo").val("");
                        $("#PayClientChargeTelNo").val("");
                        $("#PayClientChargeCell").val("");
                        $("#PayClientChargeLocation").val("");
                    }
                }
            }
        });
    }

    //화주 자동완성
    if ($("#ConsignorName").length > 0) {
        fnSetAutocomplete({
            formId: "ConsignorName",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ConsignorList",
                    ConsignorName: request.term,
                    ClientCode: $("#OrderClientCode").val(),
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ConsignorInfo,
                getValue: (item) => item.ConsignorName,
                onSelect: (event, ui) => {
                    $("#ConsignorCode").val(ui.item.etc.ConsignorCode);
                    $("#ConsignorName").val(ui.item.etc.ConsignorName);
                    fnSetFocus();
                },
                onBlur: () => {
                    if (!$("#ConsignorName").val()) {
                        $("#ConsignorCode").val("");
                    }
                }
            }
        });
    }

    //작업지 자동완성
    if ($("#PickupPlace").length > 0) {
        fnSetAutocomplete({
            formId: "PickupPlace",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "PlaceList",
                    PlaceName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.PlaceName,
                getValue: (item) => item.PlaceName,
                onSelect: (event, ui) => {
                    $("#PickupPlace").val(ui.item.etc.PlaceName);
                    $("#PickupPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#PickupPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#PickupPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#PickupPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#PickupPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#PickupPlacePost").val(ui.item.etc.PlacePost);
                    $("#PickupPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#PickupPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#PickupPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#PickupPlaceNote").val(ui.item.etc.PlaceRemark4);
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#PickupPlace").val()) {
                        $("#PickupPlaceChargeName").val("");
                        $("#PickupPlaceChargePosition").val("");
                        $("#PickupPlaceChargeTelExtNo").val("");
                        $("#PickupPlaceChargeTelNo").val("");
                        $("#PickupPlaceChargeCell").val("");
                        $("#PickupPlacePost").val("");
                        $("#PickupPlaceAddr").val("");
                        $("#PickupPlaceAddrDtl").val("");
                        $("#PickupPlaceFullAddr").val("");
                        $("#PickupPlaceNote").val("");
                    }
                }
            }
        });
    }

    //작업지 담당자 자동완성
    if ($("#PickupPlaceChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "PickupPlaceChargeName",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "PlaceChargeList",
                    PlaceChargeName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName,
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    $("#PickupPlace").val(ui.item.etc.PlaceName);
                    $("#PickupPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#PickupPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#PickupPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#PickupPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#PickupPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#PickupPlacePost").val(ui.item.etc.PlacePost);
                    $("#PickupPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#PickupPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#PickupPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#PickupPlaceNote").val(ui.item.etc.PlaceRemark4);
                    fnSetFocus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#PickupPlaceChargeName").val()) {
                        $("#PickupPlaceChargePosition").val("");
                        $("#PickupPlaceChargeTelExtNo").val("");
                        $("#PickupPlaceChargeTelNo").val("");
                        $("#PickupPlaceChargeCell").val("");
                    }
                }
            }
        });
    }

    //업체명 검색
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    ClientFlag: "Y",
                    ChargeFlag: "N",
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $.each($(".TrPayCar input"),
                        function (index, item) {
                            $(item).val("");
                        });
                    $("#ClientCode").val(ui.item.etc.ClientCode);
                    $("#ClientName").val(ui.item.etc.ClientName);
                    $("#ClientInfo").val(ui.item.etc.ClientInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                },
                onBlur: () => {
                    if (!$("#ClientName").val()) {
                        $("#ClientCode").val("");
                        $("#ClientInfo").val("");
                    }
                }
            }
        });
    }

    //차량번호(배차) 검색
    if ($("#RefCarNo").length > 0) {
        fnSetAutocomplete({
            formId: "RefCarNo",
            width: 800,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "CarDispatchRefList",
                    CarNo: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }

                    if (request.term.length < 4) {
                        fnDefaultAlert("검색어를 4자 이상 입력하세요.", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.CarNo,
                getValue: (item) => item.CarNo,
                onSelect: (event, ui) => {
                    $.each($(".TrPayCar input[type='text']"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#RefSeqNo").val(ui.item.etc.RefSeqNo);
                    $("#RefCarNo").val(ui.item.etc.CarNo);
                    $("#DispatchInfo").val(ui.item.etc.DispatchInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("CarDispatchRef", ul, item);
                },
                onBlur: () => {
                    if (!$("#RefCarNo").val()) {
                        $("#RefSeqNo").val("");
                        $("#DispatchInfo").val("");
                    }
                }
            }
        });
    }

    //차량업체명 검색
    if ($("#ComName").length > 0) {
        fnSetAutocomplete({
            formId: "ComName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "CarCompanyList",
                    ComName: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.ComName,
                getValue: (item) => item.ComName,
                onSelect: (event, ui) => {
                    $("#RefSeqNo").val("");
                    $("#DispatchInfo").val("");
                    $("#RefCarNo").val("");

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#ComCode").val(ui.item.etc.ComCode);
                    $("#ComName").val(ui.item.etc.ComName);
                    $("#ComInfo").val(ui.item.etc.ComInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("CarCompany", ul, item);
                },
                onBlur: () => {
                    if (!$("#ComName").val()) {
                        $("#ComCode").val("");
                        $("#ComInfo").val("");
                    }
                }
            }
        });
    }

    //차량번호 검색
    if ($("#CarNo").length > 0) {
        fnSetAutocomplete({
            formId: "CarNo",
            width: 300,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "CarList",
                    CarNo: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (request.term.length < 4) {
                        fnDefaultAlert("검색어를 4자 이상 입력하세요.", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.CarInfo,
                getValue: (item) => item.CarNo,
                onSelect: (event, ui) => {
                    $("#RefSeqNo").val("");
                    $("#DispatchInfo").val("");
                    $("#RefCarNo").val("");

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#CarSeqNo").val(ui.item.etc.CarSeqNo);
                    $("#CarNo").val(ui.item.etc.CarNo);
                    $("#CarInfo").val(ui.item.etc.CarInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Car", ul, item);
                },
                onBlur: () => {
                    if (!$("#CarNo").val()) {
                        $("#CarSeqNo").val("");
                        $("#CarInfo").val("");
                    }
                }
            }
        });
    }

    //기사명 검색
    if ($("#DriverName").length > 0) {
        fnSetAutocomplete({
            formId: "DriverName",
            width: 250,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "DriverList",
                    DriverName: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.DriverName,
                getValue: (item) => item.DriverName,
                onSelect: (event, ui) => {
                    $("#RefSeqNo").val("");
                    $("#DispatchInfo").val("");
                    $("#RefCarNo").val("");

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#DriverSeqNo").val(ui.item.etc.DriverSeqNo);
                    $("#DriverName").val(ui.item.etc.DriverName);
                    $("#DriverCell").val(ui.item.etc.DriverCell);
                    $("#DriverInfo").val(ui.item.etc.DriverInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Driver", ul, item);
                },
                onBlur: () => {
                    if (!$("#DriverName").val()) {
                        $("#DriverSeqNo").val("");
                        $("#DriverCell").val("");
                        $("#DriverInfo").val("");
                    }
                }
            }
        });
    }

    //기사휴대폰 검색
    if ($("#DriverCell").length > 0) {
        fnSetAutocomplete({
            formId: "DriverCell",
            width: 250,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Container/Proc/ContainerHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "DriverList",
                    DriverCell: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.DriverCell,
                getValue: (item) => item.DriverCell,
                onSelect: (event, ui) => {
                    $("#RefSeqNo").val("");
                    $("#DispatchInfo").val("");
                    $("#RefCarNo").val("");

                    $.each($(".TrPayClient input"),
                        function (index, item) {
                            $(item).val("");
                        });

                    $("#DriverSeqNo").val(ui.item.etc.DriverSeqNo);
                    $("#DriverName").val(ui.item.etc.DriverName);
                    $("#DriverCell").val(ui.item.etc.DriverCell);
                    $("#DriverInfo").val(ui.item.etc.DriverInfo);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Driver", ul, item);
                },
                onBlur: () => {
                    if (!$("#DriverCell").val()) {
                        $("#DriverSeqNo").val("");
                        $("#DriverName").val("");
                        $("#DriverInfo").val("");
                    }
                }
            }
        });
    }
}

function fnSetFocus() {
    
    if(!$("#OrderClientCode").val()) {
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
    } else if (!$("#PickupPlaceChargeName").val()) {
        $("#PickupPlaceChargeName").focus();
        return false;
    } else if (!$("#PickupPlaceChargeTelNo").val() && !$("#PickupPlaceChargeCell").val()) {
        $("#PickupPlaceChargeTelNo").focus();
        return false;
    } else if (!$("#PickupPlaceAddr").val()) {
        $("#BtnSearchAddrPickupPlace").focus();
        return false;
    } else if (!$("#GoodsItemCode").val()) {
        $("#GoodsItemCode").focus();
        return false;
    } else if (!$("#Volume").val()) {
        $("#Volume").focus();
        return false;
    }
}

//수출입에 따른 항목 세팅
function fnSetInout() {
    if ($("#OrderItemCode option:selected").text().indexOf("수입") > -1) { //수입
        $(".TrGoods .out").hide();
        $(".TrGoods .in").show();

        $.each($(".TrGoods .out"),
            function (index, item) {
                if (!$(item).hasClass("in")) {
                    $(item).val("");
                }
            });
    } else { //수출 & 미선택
        $(".TrGoods .in").hide();
        $(".TrGoods .out").show();

        $.each($(".TrGoods .in"),
            function (index, item) {
                if (!$(item).hasClass("out")) {
                    $(item).val("");
                }
            });
    }
}

//비용정보 세팅
function fnSetPay() {
    if ($("#PayType option:selected").text() === "매입") { //매입
        $(".TrPayClient").show();
        $(".TrPayCar").show();
        $(".TrPay th").attr("rowspan", "4");
    } else if ($("#PayType option:selected").text() === "선급" || $("#PayType option:selected").text() === "예수") { //선급 or 예수
        $(".TrPayClient").show();
        $(".TrPayCar").hide();
        $(".TrPay th").attr("rowspan", "3");
    } else { //매출 외
        $(".TrPayClient").hide();
        $(".TrPayCar").hide();
        $(".TrPay th").attr("rowspan", "2");
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
    
    $.each($(".TrPayClient input"),
        function (index, item) {
            $(item).val("");
        });

    $.each($(".TrPayCar input"),
        function (index, item) {
            $(item).val("");
        });

    $.each($(".TrPayCar select"),
        function (index, item) {
            $(item).val("");
        });
}

//오더 데이터 세팅
function fnCallOrderDetail() {

    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
    var strCallBackFunc = "fnOrderDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "ContainerList",
        OrderNo: $("#OrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
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

        if (item.OrderItemCodeM.indexOf("수입") > -1) {
            $("#ReturnCY").val(item.GetCY);
            $("#ReturnCYCharge").val(item.GetCYCharge);
            $("#ReturnCYTelNo").val(item.GetCYTelNo);
        }

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
        $("#CustomFlag").prop("checked", item.CustomFlag === "Y");
        $("#BondedFlag").prop("checked", item.BondedFlag === "Y");
        $("#DocumentFlag").prop("checked", item.DocumentFlag === "Y");

        //RadioButton

        //Span
        $("#OrderStatusM").text("[" + item.OrderStatusM + "]");
        $("#AcceptDate").text(item.AcceptDate);
        $("#AcceptAdminName").text(item.AcceptAdminName);

        if (item.OrderClientMisuFlag === "Y") {
            $("#SpanOrderClientMisuAmt").text("미수금액: " + fnMoneyComma(item.OrderClientMisuAmt) + "원 / " + item.OrderClientNoMatchingCnt + "건");
            $("#BtnOrderClientMisuAmt").show();
        } else {
            $("#SpanOrderClientMisuAmt").text("");
            $("#BtnOrderClientMisuAmt").hide();
        }

        if (item.PayClientMisuFlag === "Y") {
            $("#SpanPayClientMisuAmt").text("미수금액: " + fnMoneyComma(item.PayClientMisuAmt) + "원 / " + item.PayClientNoMatchingCnt + "건");
            $("#BtnPayClientMisuAmt").show();
        } else {
            $("#SpanPayClientMisuAmt").text("");
            $("#BtnPayClientMisuAmt").hide();
        }

        if ($("#CopyFlag").val()==="Y") {
            $("#HidMode").val("Insert");
            $("#CopyFlag").val("N");
            $("#CnlFlag").val("N");
            $("#OrderNo").val("");
            $("#DivOrderInfo").remove();
            $("#DivButtons").remove();
            $("#PickupYMD").datepicker("setDate", GetDateToday("-"));
            $("#PickupHM").val("");
            $(".TrGoods input").val("");
            $(".TrGoods select").val("");
            return false;
        }

        if ($("#CnlFlag").val() === "Y") {
            $("#BtnRegOrder").hide();
            $("#BtnCancelOrder").hide();
        }

        //파일 목록 조회
        fnCallFileData();

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

    if (!$("#ConsignorCode").val()) {
        fnDefaultAlertFocus("화주를 검색하세요.", "ConsignorName", "warning");
        return;
    }

    if (!$("#PickupYMD").val()) {
        fnDefaultAlertFocus("작업일을 입력하세요.", "PickupYMD", "warning");
        return;
    }

    if (!$("#PickupPlace").val()) {
        fnDefaultAlertFocus("작업지를 입력(or 검색)하세요.", "PickupPlace", "warning");
        return;
    }

    if (!$("#PickupPlaceChargeName").val()) {
        fnDefaultAlertFocus("작업지 담당자를 입력하세요.", "PickupPlaceChargeName", "warning");
        return;
    }

    if (!$("#PickupPlaceChargeTelNo").val() && !$("#PickupPlaceChargeCell").val()) {
        fnDefaultAlertFocus("작업지 담당자의 전화번호나 휴대폰번호를 입력하세요.", "PickupPlaceChargeTelNo", "warning");
        return;
    }

    if (!$("#PickupPlacePost").val() || !$("#PickupPlaceAddr").val()) {
        fnDefaultAlertFocus("작업지 주소를 입력하세요.", "BtnSearchAddrPickupPlace", "warning");
        return;
    }

    if (!$("#GoodsItemCode").val()) {
        fnDefaultAlertFocus("품목을 선택하세요.", "GoodsItemCode", "warning");
        return;
    }

    if (!$("#Volume").val()) {
        fnDefaultAlertFocus("총 수량을 입력하세요.", "Volume", "warning");
        return;
    }

    //매출입 체크
    var SaleAmt = 0;
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
                }
            });
    }

    if (PurchaseAmt > 0 && SaleAmt <= 0) {
        fnDefaultAlert("매입은 매출입력 후 등록이 가능합니다.", "warning");
        return;
    }

    strCallType = "Container" + $("#HidMode").val();
    strConfMsg = "오더를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsOrderProc", fnParam);
    return;
};

function fnInsOrderProc(fnParam) {
    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
    var strCallBackFunc = "fnAjaxInsOrder";

    var objParam = {
        CallType: fnParam,
        OrderNo: $("#OrderNo").val(),
        CenterCode: $("#CenterCode").val(),
        CustomFlag: $("#CustomFlag").is(":checked") ? "Y" : "N",
        BondedFlag: $("#BondedFlag").is(":checked") ? "Y" : "N",
        DocumentFlag: $("#DocumentFlag").is(":checked") ? "Y" : "N",
        OrderLocationCode: $("#OrderLocationCode").val(),
        OrderItemCode: $("#OrderItemCode").val(),
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
        NoteInside: $("#NoteInside").val(),
        NoteClient: $("#NoteClient").val(),
        GoodsSeqNo: $("#GoodsSeqNo").val(),
        GoodsItemCode: $("#GoodsItemCode").val(),
        Volume: $("#Volume").val(),
        Weight: $("#Weight").val(),
        BookingNo: $("#BookingNo").val(),
        GoodsOrderNo: $("#GoodsOrderNo").val(),
        CntrNo: $("#CntrNo").val(),
        SealNo: $("#SealNo").val(),
        DONo: $("#DONo").val(),
        BLNo: $("#BLNo").val(),
        Port: $("#Port").val(),
        ShippingCompany: $("#ShippingCompany").val(),
        ShippingShipName: $("#ShippingShipName").val(),
        ShippingCharge: $("#ShippingCharge").val(),
        ShippingTelNo: $("#ShippingTelNo").val(),
        ShipmentPort: $("#ShipmentPort").val(),
        ShipmentYMD: $("#ShipmentYMD").val(),
        EnterYMD: $("#EnterYMD").val(),
        PickupCY: $("#PickupCY").val(),
        PickupCYCharge: $("#PickupCYCharge").val(),
        PickupCYTelNo: $("#PickupCYTelNo").val(),
        GetCY: $("#OrderItemCode option:selected").text().indexOf("수입") > -1 ? $("#ReturnCY").val() : $("#GetCY").val(),
        GetCYCharge: $("#OrderItemCode option:selected").text().indexOf("수입") > -1 ? $("#ReturnCYCharge").val() :$("#GetCYCharge").val(),
        GetCYTelNo: $("#OrderItemCode option:selected").text().indexOf("수입") > -1 ? $("#ReturnCYTelNo").val() :$("#GetCYTelNo").val(),
        Item: $("#Item").val(),
        Consignor: $("#Consignor").val(),
        ShipCode: $("#ShipCode").val(),
        ShipName: $("#ShipName").val(),
        DivCode: $("#DivCode").val(),
        CargoClosingTime: $("#CargoClosingTime").val()
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
        } else {
            strSaleClosingFlag = data[0].SaleClosingFlag;
            strPurchaseClosingFlag = data[0].PurchaseClosingFlag;
        }
        fnInsFile();
    }
}

//파일 등록
var FileList = null;
var FileCnt = 0;
var FileProcCnt = 0;
var FileSuccessCnt = 0;
var FileFailCnt = 0;
function fnInsFile() {
    FileList = [];
    $.each($("#UlFileList li"), function (index, item) {
        if ($(item).attr("flag") === "Y") {
            FileList.push({
                FileSeqNo: $(item).attr("seq"),
                FileName: $(item).children("a:first-child").text(),
                FileNameNew: $(item).attr("fname"),
                TempFlag: $(item).attr("flag")
            });
        }
    });

    if (FileList.length > 0) {
        FileCnt = FileList.length;
        FileProcCnt = 0;
        FileSuccessCnt = 0;
        FileFailCnt = 0;
        fnInsFileProc();
        return false;
    } else {
        fnInsPay();
        return false;
    }
}

function fnInsFileProc() {
    if (FileProcCnt >= FileCnt) {
        fnInsPay();
        return;
    }

    var RowFile = FileList[FileProcCnt];
    RowFile.CallType = "OrderInsFileUpload";
    RowFile.CenterCode = $("#CenterCode").val();
    RowFile.OrderNo = $("#OrderNo").val();

    if (RowFile) {
        var strHandlerURL = "/TMS/Container/Proc/ContainerFileHandler.ashx";
        var strCallBackFunc = "fnInsFileSuccResult";
        var strFailCallBackFunc = "fnInsFileFailResult";
        var objParam = RowFile;
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
    }
}

function fnInsFileSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            FileSuccessCnt++;
        } else {
            FileFailCnt++;
        }
    } else {
        FileFailCnt++;
    }
    FileProcCnt++;
    setTimeout(fnInsFileProc(), 500);
}

function fnInsFileFailResult() {
    FileProcCnt++;
    FileFailCnt++;
    setTimeout(fnInsFileProc(), 500);
    return false;
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
            RowPay.CallType = "ContainerPayInsert";
        } else {
            RowPay.CallType = "ContainerPayUpdate";
        }
    } else if (AUIGrid.isRemovedById(GridPayID, RowPay.PaySeqNo)) {
        RowPay.CallType = "ContainerPayDelete";
    } else { //isAddedById
        RowPay.CallType = "ContainerPayInsert";
    }

    RowPay.CenterCode = $("#CenterCode").val();
    RowPay.OrderNo = $("#OrderNo").val()
    RowPay.GoodsSeqNo = $("#GoodsSeqNo").val()

    if (RowPay) {
        var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
        var strCallBackFunc = "fnGridPayInsSuccResult";
        var strFailCallBackFunc = "fnGridPayInsFailResult";
        var objParam = RowPay;
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
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
    document.location.replace("/TMS/Container/ContainerIns?OrderNo=" + $("#OrderNo").val());
}


//오더취소
function fnCnlOrder() {
    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return;
    }

    $("#DivCancel").show();
}

//오더 취소처리
function fnCnlOrderProc() {
    if (!$("#OrderNo").val()) {
        fnDefaultAlert("취소할 오더 정보가 없습니다.", "info");
        return false;
    }

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "info");
        return false;
    }

    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
    var strCallBackFunc = "fnCnlOrderSuccResult";
    var strFailCallBackFunc = "fnCnlOrderFailResult";
    var objParam = {
        CallType: "ContainerOneCancel",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        CnlReason: $("#CnlReason").val()
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
    $("#DivCancel").hide();
}

//고객사, 화주 특이사항
function fnInfoClient(intType, intSeqNo) {
    window.open("/TMS/Common/SpecialNote?Type=" + intType + "&SeqNo=" + intSeqNo, "특이사항", "width=650, height=450, scrollbars=Yes");
};

//고객사 목록
function fnListClient(intType) {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    window.open("/TMS/Common/ClientDetailList?Type=" + intType + "&CenterCode=" + $("#CenterCode").val(), "고객사 검색", "width=1200, height=600, scrollbars=Yes");
};

//회원사 변경 세팅
function fnSetCenterChange(intType) {
    if (intType == 0) {
        $(".TdClient input").val("");
        $("#SpanOrderClientMisuAmt").text("");
        $("#BtnOrderClientMisuAmt").hide();
        $("#SpanPayClientMisuAmt").text("");
        $("#BtnPayClientMisuAmt").hide();
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
        return;
    }

    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
    var strCallBackFunc = "fnAjaxSetCodeList";

    var objParam = {
        CallType: "ContainerCodeList",
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", false);
}

function fnAjaxSetCodeList(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
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


/*********************************************/
// 비용 그리드
/*********************************************/
var GridPayID = "#ContainerOrderPayListGrid";

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
    fnSetGridEvent(GridPayID, "", "", "fnPayGridKeyDown", "", "", "", "fnPayGridCellClick", "");

    // 사이즈 세팅
    var intHeight = 170;
    var intScrollBarWidth = fnGetScrollBarWidth();
    AUIGrid.resize(GridPayID, $(window).width() - intScrollBarWidth - 178, intHeight);
    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridPayID, $(window).width() - intScrollBarWidth - 178, intHeight);
        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridPayID, $(window).width() - intScrollBarWidth - 178, intHeight);
        }, 100);
    });
}

//기본 레이아웃 세팅
function fnCreatePayGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleCells"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
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

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (item.ClosingFlag == "Y" || item.BillStatus !== 1 || item.SendStatus !== 1) { //마감, 계산서발행, 송금
            return "aui-grid-closing-y-row-style";
        }
        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultPayColumnLayout()");
    var objOriLayout = fnGetDefaultPayColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

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
            dataField: "ClientInfo",
            headerText: "업체정보",
            editable: false,
            width: 250
        },
        {
            dataField: "DispatchInfo",
            headerText: "차량정보",
            editable: false,
            width: 250
        },
        {
            dataField: "RegAdminName",
            headerText: "등록자",
            editable: false,
            width: 80
        },
        {
            dataField: "RegDate",
            headerText: "등록일",
            editable: false,
            width: 150
        },
        {
            dataField: "UpdAdminName",
            headerText: "수정자",
            editable: false,
            width: 80
        },
        {
            dataField: "UpdDate",
            headerText: "수정일",
            editable: false,
            width: 150
        }
        /*숨김필드*/
        ,{
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
        }, {
            dataField: "InsureExceptKind",
            headerText: "InsureExceptKind",
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
// 키 다운 핸들러 - 사용자 정의(페이지 기능별 수정 필요)
function fnPayGridKeyDown(event) {
    // ESC
    if (event.keyCode === 113) {
        $("#BtnRegOrder").click();
        return false;
    }
    return true;
}

//셀 클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnPayGridCellClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridPayID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    if (objItem.ClosingFlag !== "N" || objItem.BillStatus !== 1 || objItem.SendStatus !== 1) {
        fnDefaultAlert("마감된 비용은 수정할 수 없습니다", "error");
        return;
    }

    fnDisplayPay(objItem);
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallPayGridData(strGID) {

    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
    var strCallBackFunc = "fnPayGridSuccResult";

    var objParam = {
        CallType: "ContainerPayList",
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

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridPayID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridPayID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridPayID);

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
    var strDispatchInfo = typeof item.DispatchInfo === "undefined" ? "" : item.DispatchInfo;
    var strComInfo = typeof item.ComInfo === "undefined" ? "" : item.ComInfo;
    var strCarInfo = typeof item.CarInfo === "undefined" ? "" : item.CarInfo;
    var strDriverInfo = typeof item.DriverInfo === "undefined" ? "" : item.DriverInfo;
    
    var strRefCarNo = "";
    var strComName = "";
    var strCarNo = "";
    var strDriverName = "";
    var strDriverCell = "";

    //업체비용
    if (strClientInfo !== "" && item.ClientCode !== "" && item.ClientCode != "0") {
        strDispatchInfo = "";
        strComInfo = "";
        strCarInfo = "";
        strDriverInfo = "";
    }

    //차량비용
    if (item.CarDivType != "" && strComInfo !== "" && strCarInfo !== "" && strDriverInfo !== "" && item.ComCode != "0" && item.ComCode != "" && item.CarSeqNo != "0" && item.CarSeqNo != "" && item.DriverSeqNo != "0" && item.DriverSeqNo != "") {
        strClientInfo = "";
        strDispatchInfo = "";

        strComName = strComInfo.substring(0, strComInfo.indexOf("(") - 1);
        if (strCarInfo.indexOf("(") > -1) {
            strCarNo = strCarInfo.substring(0, strCarInfo.indexOf("(") - 1);
        } else {
            strCarNo = strCarInfo;
        }
        strDriverName = strDriverInfo.substring(0, strDriverInfo.indexOf("(") - 1);
        strDriverCell = strDriverInfo.substring(strDriverInfo.indexOf("(") + 1, strDriverInfo.indexOf(")"));
    }

    //배차차량비용
    if (strDispatchInfo !== "" && item.RefSeqNo != "0" && item.RefSeqNo != "") {
        strClientInfo = "";
        strComInfo = "";
        strCarInfo = "";
        strDriverInfo = "";
        strRefCarNo = strDispatchInfo.substring(strDispatchInfo.indexOf("]") + 2, strDispatchInfo.indexOf("(") - 1);
        if (strRefCarNo.indexOf("/") > -1) {
            strRefCarNo = strRefCarNo.substring(0, strRefCarNo.indexOf("/") - 1);
        }
    }

    $("#SeqNo").val(item.SeqNo);
    $("#PaySeqNo").val(item.PaySeqNo);
    $("#TaxKind").val(item.TaxKind);
    $("#ItemCode").val(item.ItemCode);
    $("#SupplyAmt").val(fnMoneyComma(item.SupplyAmt));
    $("#TaxAmt").val(fnMoneyComma(item.TaxAmt));
    $("#ClientCode").val(item.ClientCode);
    $("#ClientInfo").val(strClientInfo);
    $("#ClientName").val(item.ClientName);
    $("#RefSeqNo").val(item.RefSeqNo);
    $("#DispatchInfo").val(strDispatchInfo);
    $("#CarDivType").val(item.CarDivType);
    $("#ComCode").val(item.ComCode);
    $("#ComInfo").val(strComInfo);
    $("#CarSeqNo").val(item.CarSeqNo);
    $("#CarInfo").val(strCarInfo);
    $("#DriverSeqNo").val(item.DriverSeqNo);
    $("#DriverInfo").val(strDriverInfo);
    $("#RefCarNo").val(strRefCarNo);
    $("#ComName").val(strComName);
    $("#CarNo").val(strCarNo);
    $("#DriverName").val(strDriverName);
    $("#DriverCell").val(strDriverCell);
    $("#DispatchSeqNo").val(item.DispatchSeqNo);
    $("#InsureExceptKind").val(item.InsureExceptKind);
    $("#BtnUpdPay").show();
    $("#BtnDelPay").show();
}

//비용추가
function fnPayAddRow() {
    var strClientInfo = "";
    var strDispatchInfo = "";

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
                        if ($("#PayType").val() == "1") {
                            if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val()) {
                                cnt++;
                            }
                        } else if ($("#PayType").val() == "2") {
                            if ($("#RefSeqNo").val()) {
                                if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.RefSeqNo == $("#RefSeqNo").val()) {
                                    cnt++;
                                }
                            } else {
                                if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val()) {
                                    cnt++;
                                }
                            }
                        }
                    }
                });
        }

        if (cnt > 0) {
            fnDefaultAlert("운임 매출/입은 한건씩 입력이 가능합니다.", "warning");
            return;
        }
    }

    if ($("#PayType").val() === "2") { //매입
        if ($("#ClientCode").val() && $("#ClientCode").val() !== "0") {
            strClientInfo = $("#ClientInfo").val();
            strDispatchInfo = "";
        } else if ($("#CarDivType").val() !== "" && $("#ComCode").val() && $("#ComCode").val() !== "0" && $("#CarSeqNo").val() && $("#CarSeqNo").val() !== "0" && $("#DriverSeqNo").val() && $("#DriverSeqNo").val() !== "0") {
            if (!$("#InsureExceptKind").val()) {
                fnDefaultAlertFocus("산재보험 신고 정보를 선택하세요.", "InsureExceptKind", "warning");
                return false;
            }
            $("#ClientCode").val("");
            $("#ClientName").val("");
            strClientInfo = "";
            strDispatchInfo = "[" + $("#CarDivType option:selected").text() + "] " + $("#CarInfo").val() + " / " + $("#DriverInfo").val() + " / " + $("#ComInfo").val();
        } else if ($("#RefSeqNo").val() && $("#RefSeqNo").val() !== "0") {
            if (!$("#InsureExceptKind").val()) {
                fnDefaultAlertFocus("산재보험 신고 정보를 선택하세요.", "InsureExceptKind", "warning");
                return false;
            }

            $("#ClientCode").val("");
            $("#ClientName").val("");
            $("#CarDivType").val("");
            $("#ComCode").val("");
            $("#ComInfo").val("");
            $("#CarSeqNo").val("");
            $("#CarInfo").val("");
            $("#DriverSeqNo").val("");
            $("#DriverInfo").val("");
            strClientInfo = "";
            strDispatchInfo = $("#DispatchInfo").val();
        } else {
            fnDefaultAlertFocus("업체정보나 차량정보를 입력하세요.", "ClientName", "warning");
            return false;
        }
    } else if ($("#PayType").val() === "3" || $("#PayType").val() === "4") { //선급 or 예수
        if (!$("#PayClientCode").val() && !$("#ClientCode").val()) {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }
        
        strDispatchInfo = "";

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
    objItem.DispatchSeqNo = $("#DispatchSeqNo").val();
    objItem.PayType = $("#PayType").val();
    objItem.TaxKind = $("#TaxKind").val();
    objItem.ItemCode = $("#ItemCode").val();
    objItem.ClientCode = $("#ClientCode").val();
    objItem.ClientName = $("#ClientName").val();
    objItem.RefSeqNo = $("#RefSeqNo").val();
    objItem.CarDivType = $("#CarDivType").val();
    objItem.ComCode = $("#ComCode").val();
    objItem.ComInfo = $("#ComInfo").val();
    objItem.CarSeqNo = $("#CarSeqNo").val();
    objItem.CarInfo = $("#CarInfo").val();
    objItem.DriverSeqNo = $("#DriverSeqNo").val();
    objItem.DriverInfo = $("#DriverInfo").val();
    objItem.InsureExceptKind = $("#InsureExceptKind").val();
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
    AUIGrid.addRow(GridPayID, objItem, "last");
    fnSetPay();
}

//비용수정
function fnPayUpdRow() {
    var strClientInfo = "";
    var strDispatchInfo = "";
    
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
                        if ($("#PayType").val() == "1") {
                            if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.PaySeqNo != $("#PaySeqNo").val()) {
                                cnt++;
                            }
                        } else if ($("#PayType").val() == "2") {
                            if ($("#RefSeqNo").val()) {
                                if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.PaySeqNo != $("#PaySeqNo").val() && item.RefSeqNo == $("#RefSeqNo").val()) {
                                    cnt++;
                                }
                            } else {
                                if (item.ItemCode == "OP001" && item.PayType == $("#PayType").val() && item.PaySeqNo != $("#PaySeqNo").val()) {
                                    cnt++;
                                }
                            }
                        }
                    }
                });
        }

        if (cnt > 0) {
            fnDefaultAlert("운임 매출/입은 한건씩 입력이 가능합니다.", "warning");
            return;
        }
    }

    if ($("#PayType").val() === "2") { //매입
        if ($("#ClientCode").val() && $("#ClientCode").val() !== "0") {
            strClientInfo = $("#ClientInfo").val();
            strDispatchInfo = "";
        } else if ($("#CarDivType").val() !== "" && $("#ComCode").val() && $("#ComCode").val() !== "0" && $("#CarSeqNo").val() && $("#CarSeqNo").val() !== "0" && $("#DriverSeqNo").val() && $("#DriverSeqNo").val() !== "0") {
            if (!$("#InsureExceptKind").val()) {
                fnDefaultAlertFocus("산재보험 신고 정보를 선택하세요.", "InsureExceptKind", "warning");
                return false;
            }
            $("#ClientCode").val("");
            $("#ClientName").val("");
            strClientInfo = "";
            strDispatchInfo = "[" + $("#CarDivType option:selected").text() + "] " + $("#CarInfo").val() + " / " + $("#DriverInfo").val() + " / " + $("#ComInfo").val();
        } else if ($("#RefSeqNo").val() && $("#RefSeqNo").val() !== "0") {
            if (!$("#InsureExceptKind").val()) {
                fnDefaultAlertFocus("산재보험 신고 정보를 선택하세요.", "InsureExceptKind", "warning");
                return false;
            }
            $("#ClientCode").val("");
            $("#ClientName").val("");
            $("#CarDivType").val("");
            $("#ComCode").val("");
            $("#ComInfo").val("");
            $("#CarSeqNo").val("");
            $("#CarInfo").val("");
            $("#DriverSeqNo").val("");
            $("#DriverInfo").val("");
            strClientInfo = "";
            strDispatchInfo = $("#DispatchInfo").val();
        } else {
            fnDefaultAlertFocus("업체정보나 차량정보를 입력하세요.", "ClientName", "warning");
            return false;
        }
    } else if ($("#PayType").val() === "3" || $("#PayType").val() === "4") { //선급 or 예수
        if (!$("#PayClientCode").val() && !$("#ClientCode").val()) {
            fnDefaultAlertFocus("업체정보를 입력하세요.", "ClientName", "warning");
            return false;
        }

        strDispatchInfo = "";

        if ($("#ClientCode").val()) {
            strClientInfo = $("#ClientInfo").val();
        } else if ($("#PayClientCode").val()) {
            strClientInfo = $("#PayClientInfo").val();
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
    objItem.DispatchSeqNo = $("#DispatchSeqNo").val();
    objItem.PayType = $("#PayType").val();
    objItem.TaxKind = $("#TaxKind").val();
    objItem.ItemCode = $("#ItemCode").val();
    objItem.ClientCode = $("#ClientCode").val();
    objItem.ClientName = $("#ClientName").val();
    objItem.RefSeqNo = $("#RefSeqNo").val();
    objItem.CarDivType = $("#CarDivType").val();
    objItem.ComCode = $("#ComCode").val();
    objItem.ComInfo = $("#ComInfo").val();
    objItem.CarSeqNo = $("#CarSeqNo").val();
    objItem.CarInfo = $("#CarInfo").val();
    objItem.DriverSeqNo = $("#DriverSeqNo").val();
    objItem.DriverInfo = $("#DriverInfo").val();
    objItem.InsureExceptKind = $("#InsureExceptKind").val();
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
/*********************************************/

/*********************************************/
/*                파일 첨부                  */
/*********************************************/
$(document).ready(function () {
    $("#FileUpload").fileupload({
        dataType: "json",
        autoUpload: false,
        type: "POST",
        url: "/TMS/Container/Proc/ContainerFileHandler.ashx?CallType=OrderFileUpload",
        add: function (e, data) {
            var uploadErrors = [];

            if (!$("#CenterCode").val()) {
                uploadErrors.push("회원사를 선택하세요.");
                $("#CenterCode").focus();
            }

            var acceptFileTypes = /(jpe?g|jpg|png|gif|pdf|xls|xlsx|doc|docx|ppt|pptx|hwp|hwpx)/i;
            var fileExt = data.originalFiles[0]["name"].substring(data.originalFiles[0]["name"].lastIndexOf('.') + 1);

            if (!acceptFileTypes.test(fileExt)) {
                uploadErrors.push("첨부할 수 없는 파일확장자입니다.");
            }
            if (data.originalFiles[0]["size"] > 1024 * 1024 * 10) {
                uploadErrors.push("첨부파일 용량은 10MB 이내로 등록가능합니다.");
            }
            if (uploadErrors.length > 0) {
                fnDefaultAlert(uploadErrors.join("<br>"), "warning");
            } else {
                FileDisabled = $("#mainform").find("select:disabled").removeAttr("disabled");
                data.submit();
            }
        },
        success: function (response, status) {
            FileDisabled.attr("disabled", "disabled");
            // Success callback
            //console.log(response);
            if (response[0].RetCode == 0) {
                fnAddFile(response[0]);
                return;
            } else {
                fnDefaultAlert(response[0].ErrMsg, "error");
                return;
            }
        },
        error: function (error) {
            FileDisabled.attr("disabled", "disabled");
            // Error callback
            //console.log('error', error);
        }
    });
});

// 파일 목록
function fnCallFileData() {
    if (!$("#OrderNo").val() || !$("#CenterCode").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/TMS/Container/Proc/ContainerFileHandler.ashx";
    var strCallBackFunc = "fnCallFileSuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "OrderFileList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strCallBackFailFunc, "", false);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallFileSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        $("#UlFileList li").remove();
        if (objRes[0].data.RecordCnt > 0) {
            $.each(objRes[0].data.list, function (index, item) {
                fnAddFile(item);
            });
        }

    } else {
        fnCallDetailFailResult();
    }
}

//파일 목록 추가
function fnAddFile(obj) {
    var addHtml = "";
    addHtml = "<li seq = '" + obj.EncFileSeqNo + "' fname='" + obj.EncFileNameNew + "' flag='" + obj.TempFlag + "' >";
    addHtml += "<a href=\"#\" onclick=\"fnDownloadFile(this); return false;\">" + obj.FileName + "</a> ";
    addHtml += "<a href=\"#\" onclick=\"fnDeleteFile(this); return false;\" class=\"file_del\" title=\"파일삭제\">삭제</a>";
    addHtml += "</li>\n";
    $("#UlFileList").append(addHtml);
}

//파일 다운로드
function fnDownloadFile(obj) {
    var seq = "";
    var foname = "";
    var fnname = "";
    var flag = "";

    seq = $(obj).parent("li").attr("seq");
    foname = $(obj).text();
    fnname = $(obj).parent("li").attr("fname");
    flag = $(obj).parent("li").attr("flag");

    if (seq == "" || seq == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (foname == "" || foname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (fnname == "" || fnname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (flag == "" || flag == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    var $form = null;

    if ($("form[name=dlFrm]").length == 0) {
        $form = $('<form name="dlFrm"></form>');
        $form.appendTo('body');
    } else {
        $form = $("form[name=dlFrm]");
    }

    $form.attr('action', '/TMS/Container/Proc/ContainerFileHandler.ashx');
    $form.attr('method', 'post');
    $form.attr('target', 'ifrmFiledown');

    var f1 = $('<input type="hidden" name="CallType" value="OrderFileDownload">');
    var f2 = $('<input type="hidden" name="FileSeqNo" value="' + seq + '">');
    var f3 = $('<input type="hidden" name="FileName" value="' + encodeURI(foname) + '">');
    var f4 = $('<input type="hidden" name="FileNameNew" value="' + fnname + '">');
    var f5 = $('<input type="hidden" name="TempFlag" value="' + flag + '">');
    var f6 = $('<input type="hidden" name="CenterCode" value="' + $("#CenterCode").val() + '">');
    var f7 = $('<input type="hidden" name="OrderNo" value="' + $("#OrderNo").val() + '">');

    $form.append(f1).append(f2).append(f3).append(f4).append(f5).append(f6).append(f7);
    $form.submit();
    $form.remove();
}

//파일 삭제
var objDeleteFile = null;
function fnDeleteFile(obj) {
    var seq = "";
    var foname = "";
    var fnname = "";
    var flag = "";
    objDeleteFile = obj;

    seq = $(obj).parent("li").attr("seq");
    foname = $(obj).parent("li").children("a:first-child").text();
    fnname = $(obj).parent("li").attr("fname");
    flag = $(obj).parent("li").attr("flag");

    if (seq == "" || seq == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (foname == "" || foname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (fnname == "" || fnname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (flag == "" || flag == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }
    
    var strHandlerURL = "/TMS/Container/Proc/ContainerFileHandler.ashx";
    var strCallBackFunc = "fnDeleteFileSuccResult";
    var strCallBackFailFunc = "fnDeleteFileFailResult";

    var objParam = {
        CallType: "OrderFileDelete",
        FileSeqNo: seq,
        FileName: encodeURI(foname),
        FileNameNew: fnname,
        TempFlag: flag,
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strCallBackFailFunc, "", true);
}

function fnDeleteFileSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }else {
            fnDefaultAlert("파일이 삭제되었습니다");
            if ($(objDeleteFile) !== null) {
                $(objDeleteFile).parent("li").remove();
            }
            return false;
        }
    } else {
        fnDeleteFileSuccResult();
    }
}

function fnDeleteFileFailResult() {
    fnDefaultAlert("파일 삭제에 실패했습니다.", "error");
    return false;
}
/*********************************************/


/*****************************************/
//작업지 특이사항
/*****************************************/
function fnClosePlaceNote() {
    $("#DivPlaceNote textarea").val("");
    $("#DivPlaceNote").hide();
}

function fnOpenPlaceNote(intType) {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    var strPlaceName = "";
    var strPlaceAddr = "";
    var strPlaceAddrDtl = "";

    if (intType === 1) {
        strPlaceName = $("#PickupPlace").val();
        strPlaceAddr = $("#PickupPlaceAddr").val();
        strPlaceAddrDtl = $("#PickupPlaceAddrDtl").val();
        if (strPlaceName === "") {
            fnDefaultAlertFocus("작업지를 입력(or 검색)하세요.", "PickupPlace", "warning");
            return false;
        }
    } else if (intType === 2) {
        strPlaceName = $("#GetPlace").val();
        strPlaceAddr = $("#GetPlaceAddr").val();
        strPlaceAddrDtl = $("#GetPlaceAddrDtl").val();
        if (strPlaceName === "") {
            fnDefaultAlertFocus("작업지를 입력(or 검색)하세요.", "GetPlace", "warning");
            return false;
        }
    }

    strPlaceName = encodeURIComponent(strPlaceName);
    strPlaceAddr = encodeURIComponent(strPlaceAddr);
    strPlaceAddrDtl = encodeURIComponent(strPlaceAddrDtl);

    window.open("/TMS/Common/PlaceNote?OrderType=3&CenterCode=" + $("#CenterCode").val() + "&PlaceType=" + intType + "&PlaceName=" + strPlaceName + "&PlaceAddr=" + strPlaceAddr + "&PlaceAddrDtl=" + strPlaceAddrDtl, "상하차지특이사항", "width=650, height=450, scrollbars=Yes");
}
/*****************************************/

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
        fnDefaultAlertFocus("작업일을 입력하세요.", "PickupYMD", "warning");
        return;
    }

    var strHandlerUrl = "/TMS/Container/Proc/ContainerHandler.ashx";
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
/* 화주 간편 등록 */
/*********************************************/
function fnOpenPopConsignor() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    $("#DivConsignor").show();
}

function fnRegPopConsignor() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#PopConsignorName").val()) {
        fnDefaultAlertFocus("화주명을 입력하세요.", "fnRegPopConsignor", "warning");
        return false;
    }

    strCallType = "ConsignorInsert";
    strConfMsg = "화주를 등록하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnRegPopConsignorProc", fnParam);
    return false;
}

function fnRegPopConsignorProc(fnParam) {
    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
    var strCallBackFunc = "fnAjaxRegConsignor";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        ConsignorName: $("#PopConsignorName").val(),
        ConsignorNote: $("#PopConsignorNote").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxRegConsignor(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
    } else {
        $("#ConsignorCode").val(objRes[0].ConsignorCode);
        $("#ConsignorName").val($("#PopConsignorName").val());
        var msg = "화주 등록에 성공하였습니다.";
        fnDefaultAlert(msg, "info", "fnClosePopConsignor()");
    }
}

function fnClosePopConsignor() {
    $("#PopConsignorName").val("");
    $("#PopConsignorNote").val("");
    $("#DivConsignor").hide();
    fnSetFocus();
}
/*********************************************/

function fnUnipassPopup() {
    if ($("#BLNo").val() === "") {
        fnDefaultAlert("H/AWB(B/L NO)가 없습니다.");
        return;
    }

    window.open('/TMS/Unipass/UnipassDetailList?BLNo=' + $("#BLNo").val() + "&PickupYMD=" + $("#PickupYMD").val().substring(0, 4) + "&HidMode=Container", '화물통관 진행정보', 'width=1200px,height=800px,scrollbars=yes');
    return;
}


/*********************************************/
//미수내역 그리드
/*********************************************/
var GridDepositID = "#OrderMisuListGrid";

$(document).ready(function () {
    if ($(GridDepositID).length > 0) {
        // 그리드 초기화
        fnDepositGridInit();
    }
});

function fnDepositGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDepositGridLayout(GridDepositID, "InputYM");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDepositID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $("#DivMisuList > div").height() - 50;
    AUIGrid.resize(GridDepositID, $("#DivMisuList > div").width(), intHeight);

    // 푸터
    fnSetDepositGridFooter(GridDepositID);
    AUIGrid.setGridData(GridDepositID, []);
}

//기본 레이아웃 세팅
function fnCreateDepositGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleCells"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부
    objGridProps.applyRestPercentWidth = true; //칼럼 레이아웃 작성 시 칼럼의 width 를 퍼센티지(%) 로 설정

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDepositDefaultColumnLayout()");
    var objOriLayout = fnGetDepositDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDepositDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "InputYM",
            headerText: "작성월",
            editable: false,
            width: "10%",
            dataType: "date",
            formatString: "yyyy-mm",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "TotalUnpaidAmt",
            headerText: "채권잔액",
            editable: false,
            width: "12%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) {
                return item.SaleAmt - item.SaleDepositAmt + item.AdvanceAmt - item.AdvanceDepositAmt - item.SetOffAmt;
            }
        },
        {
            dataField: "SaleAmt",
            headerText: "매출",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SaleDepositAmt",
            headerText: "매출입금",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SaleUnpaidAmt",
            headerText: "매출미수",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) {
                return item.SaleAmt - item.SaleDepositAmt;
            }
        },
        {
            dataField: "AdvanceAmt",
            headerText: "선급",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "AdvanceDepositAmt",
            headerText: "선급입금",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "AdvanceUnpaidAmt",
            headerText: "선급미수",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) {
                return item.AdvanceAmt - item.AdvanceDepositAmt;
            }
        },
        {
            dataField: "SetOffAmt",
            headerText: "상계",
            editable: false,
            width: "11%",
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        /*숨김필드*/
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDepositGridData(strGID, strCenterCode, strClientCode) {

    if (typeof strCenterCode == "undefined" || typeof strClientCode == "undefined") {
        return false;
    }

    if (strCenterCode == null || strCenterCode == "") {
        return false;
    }

    if (strClientCode == null || strClientCode == "") {
        return false;
    }

    var strHandlerURL = "/TMS/Container/Proc/ContainerHandler.ashx";
    var strCallBackFunc = "fnDepositGridSuccResult";

    var objParam = {
        CallType: "OrderMisuList",
        CenterCode: strCenterCode,
        ClientCode: strClientCode
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDepositGridSuccResult(objRes) {

    if (objRes) {
        AUIGrid.setGridData(GridDepositID, []);

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnDefaultAlert(objRes[0].ErrMsg, "warning");
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridDepositID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridDepositID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDepositGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "InputYM",
            dataField: "InputYM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TotalUnpaidAmt",
            dataField: "TotalUnpaidAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleAmt",
            dataField: "SaleAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleDepositAmt",
            dataField: "SaleDepositAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleUnpaidAmt",
            dataField: "SaleUnpaidAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceAmt",
            dataField: "AdvanceAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceDepositAmt",
            dataField: "AdvanceDepositAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceUnpaidAmt",
            dataField: "AdvanceUnpaidAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SetOffAmt",
            dataField: "SetOffAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

function fnOpenMisuList(strClientType) {
    AUIGrid.setGridData(GridDepositID, []);
    fnCallDepositGridData(GridDepositID, $("#CenterCode").val(), $("#" + strClientType + "ClientCode").val())
    $("#DivMisuList").show();
    return false;
}

function fnCloseMisuList() {
    AUIGrid.setGridData(GridDepositID, []);
    $("#DivMisuList").hide();
    return false;
}

/*********************************************/