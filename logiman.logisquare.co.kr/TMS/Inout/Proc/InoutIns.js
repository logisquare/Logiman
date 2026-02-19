var strCenterCode = "";
var strPayType = "";
var strSaleClosingFlag = "N";
var strPurchaseClosingFlag = "N";
var strFtlFlag = "";
var strCarTonCode = "";
var strCarTypeCode = "";

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
        dateFormat: "yy-mm-dd",
        onSelect: function (dateFromText, inst) {
            var GetYMDText = $("#GetYMD").val().replace(/-/gi, "");
            if (GetYMDText.length !== 8) {
                GetYMDText = GetDateToday("");
            }

            if (parseInt(dateFromText.replace(/-/gi, "")) > parseInt(GetYMDText)) {
                $("#GetYMD").datepicker("setDate", dateFromText);
            }

            //자동운임 변경 체크
            fnChangeRateChk();
        }
    });
    $("#PickupYMD").datepicker("setDate", GetDateToday("-"));

    $("#GetYMD").datepicker({
        dateFormat: "yy-mm-dd",
        onSelect: function (dateFromText, inst) {
            //자동운임 변경 체크
            fnChangeRateChk();
        }
    });
    $("#GetYMD").datepicker("setDate", GetDateToday("-"));

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
        fnOpenOrderReqChg();
        return false;
    });

    //원본오더
    $("#BtnOriginalOrder").on("click", function (e) {
        fnOpenOrderOrgDetail();
        return false;
    });

    //서비스이슈
    $("#BtnSQI").on("click", function (e) {
        if (!$("#OrderNo").val() || !$("#CenterCode").val()) {
            return false;
        }
        window.open("/TMS/Common/SQIDetailList?OrderType=2&CenterCode=" + $("#CenterCode").val() + "&OrderNo=" + $("#OrderNo").val(), "서비스이슈", "width=760, height=850, scrollbars=Yes");
    });

    //오더복사
    $("#BtnCopyOrder").on("click", function (e) {
        if (!$("#OrderNo").val()) {
            return false;
        }

        if (!$("#OldPickupPlaceFullAddr").val() && $("#PickupPlaceFullAddr").val()) {
            fnDefaultAlert("상차지 적용주소가 변경되었습니다.<br/>오더 등록 후 복사하실 수 있습니다.");
            return false;
        }

        if (!$("#OldPickupPlaceFullAddr").val() || !$("#PickupPlaceFullAddr").val()) {
            fnDefaultAlert("상차지 적용주소 정보가 없습니다.<br/>우편번호 검색 후 복사하실 수 있습니다.");
            return false;
        }

        if (!$("#OldGetPlaceFullAddr").val() && $("#GetPlaceFullAddr").val()) {
            fnDefaultAlert("하차지 적용주소가 변경되었습니다.<br/>오더 등록 후 복사하실 수 있습니다.");
            return false;
        }

        if (!$("#OldGetPlaceFullAddr").val() || !$("#GetPlaceFullAddr").val()) {
            fnDefaultAlert("하차지 적용주소 정보가 없습니다.<br/>우편번호 검색 후 복사하실 수 있습니다.");
            return false;
        }

        document.location.replace("/TMS/Inout/InoutIns?OrderNo=" + $("#OrderNo").val() + "&CopyFlag=Y");
        return false;
    });

    //오더대량복사
    $("#BtnCopyOrders").on("click", function (e) {
        if (!$("#OrderNo").val() || !$("#CenterCode").val()) {
            return false;
        }

        if (!$("#OldPickupPlaceFullAddr").val() && $("#PickupPlaceFullAddr").val()) {
            fnDefaultAlert("상차지 적용주소가 변경되었습니다.<br/>오더 등록 후 복사하실 수 있습니다.");
            return false;
        }

        if (!$("#OldPickupPlaceFullAddr").val() || !$("#PickupPlaceFullAddr").val()) {
            fnDefaultAlert("상차지 적용주소 정보가 없습니다.<br/>우편번호 검색 후 복사하실 수 있습니다.");
            return false;
        }

        if (!$("#OldGetPlaceFullAddr").val() && $("#GetPlaceFullAddr").val()) {
            fnDefaultAlert("하차지 적용주소가 변경되었습니다.<br/>오더 등록 후 복사하실 수 있습니다.");
            return false;
        }

        if (!$("#OldGetPlaceFullAddr").val() || !$("#GetPlaceFullAddr").val()) {
            fnDefaultAlert("하차지 적용주소 정보가 없습니다.<br/>우편번호 검색 후 복사하실 수 있습니다.");
            return false;
        }

        window.open("/TMS/Common/OrderCopy?OrderType=2&CenterCode=" + $("#CenterCode").val() + "&OrderNos=" + $("#OrderNo").val(), "오더대량복사", "width=1140, height=850, scrollbars=Yes");
        return false;
    });

    //새로등록
    $("#BtnGoWrite").on("click", function (e) {
        document.location.replace("/TMS/Inout/InoutIns");
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

    //업체정보 다시 입력
    $("#BtnResetClient").on("click", function (e) {

        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 수정하실 수 없습니다.");
            return false;
        }

        $(".TdClient input").val("");
        $("#SpanOrderClientMisuAmt").text("");
        $("#BtnOrderClientMisuAmt").hide();
        $("#SpanPayClientMisuAmt").text("");
        $("#BtnPayClientMisuAmt").hide();
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

    //상차지 특이사항 조회
    $("#BtnOpenPickupPlaceNote").on("click", function (e) {
        fnOpenPlaceNote(1);
        return;
    });

    //상차지 주소 검색
    $("#BtnSearchAddrPickupPlace").on("click", function (e) {
        fnOpenAddress("PickupPlace");
        return;
    });

    //상차지 다시 입력 
    $("#BtnResetPickupPlace").on("click", function (e) {

        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 수정하실 수 없습니다.");
            return false;
        }

        $(".TdPickup input").val("");
        $(".TdPickup select").val("");
        $("#PickupYMD").datepicker("setDate", GetDateToday("-"));
        return;
    });

    //하차지 특이사항 조회
    $("#BtnOpenGetPlaceNote").on("click", function (e) {
        fnOpenPlaceNote(2);
        return;
    });

    //하차지 주소 검색
    $("#BtnSearchAddrGetPlace").on("click", function (e) {
        fnOpenAddress("GetPlace");
        return;
    });

    //하차지 다시 입력
    $("#BtnResetGetPlace").on("click", function (e) {

        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 수정하실 수 없습니다.");
            return false;
        }

        $(".TdGet input").val("");
        $(".TdGet select").val("");
        $("#GetYMD").datepicker("setDate", GetDateToday("-"));
        return;
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

        if ($("#FTLFlag").is(":checked") && $("#PayType").val() === "1" && $("#ItemCode").val() === "OP001") {
            fnDefaultAlert("비용 입력 전, 자동운임 확인이 필요합니다.");
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

        fnPayUpdRow();
        return false;
    });

    //삭제
    $("#BtnDelPay").on("click", function (e) {
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


    //자동운임
    $("#BtnCallTransRate").on("click", function () {
        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 사용하실 수 없습니다.");
            return false;
        }

        fnCallTransRate();
        return false;
    });

    //자동운임 수정요청
    $("#BtnUpdRequestAmt").on("click", function () {
        fnOpenTransRateAmtRequest();
        return false;
    });

    /**
     * 폼 이벤트
     */
    $("#CenterCode").on("focusin", function () {
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
    }).on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#OrderItemCode").on("change", function (e) {
        fnSetInout();
        //PDF 파일 DROP 영역 세팅
        fnDropPDFAreaSetting();
    }).on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#OrderLocationCode").on("change", function (e) {
            //PDF 파일 DROP 영역 세팅
            fnDropPDFAreaSetting();
    }).on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    //자동운임
    $("#FTLFlag").on("click", function () {
        strFTLFlag = $(this).is(":checked") ? "Y" : "N";
        if ($(this).is(":checked")) {
            $(".TrTransRate").show();
        } else {
            $(".TrTransRate").hide();
        }
        fnSetNoteInside();
        //자동운임 변경 체크
        fnChangeRateChk();        
    });

    $("#CarTonCode").on("focusssin", function () {
        strCarTonCode = $(this).val();
    }).on("change", function () {
        fnSetNoteInside();
    }).on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#CarTypeCode").on("focusin", function () {
        strCarTypeCode = $(this).val();
    }).on("change", function () {
        fnSetNoteInside();
    }).on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#PickupHM").on("blur", function () {
        //자동운임 변경 체크
        fnChangeRateChk();
    });
    $("#PickupPlaceSearch").on("keyup", function (event) {
        if (event.keyCode === 13) {
            $("#BtnSearchAddrPickupPlace").click();
        }
    });

    $("#GetHM").on("blur", function () {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#GetPlaceSearch").on("keyup", function (event) {
        if (event.keyCode === 13) {
            $("#BtnSearchAddrGetPlace").click();
        }
    });

    $("#Volume").on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#CBM").on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#Weight").on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#Length").on("blur", function (event) {
        //자동운임 변경 체크
        fnChangeRateChk();
    });

    $("#GoodsItemVolume").on("keyup", function (event) {
        if (event.keyCode === 13) {
            $("#BtnAddGoodsItem").click();
            return false;
        }
    });

    $("#PayType").on("focusin", function (e) {
        strPayType = $(this).val();
    }).on("change", function (e) {
        fnSetPay();
    });

    $("#TaxKind").on("change", function (e) {
        fnCalcTax($("#SupplyAmt").val(), "TaxAmt", "TaxKind");
    });

    $("#SupplyAmt").on("keyup blur", function(event) {
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

    $("#TaxAmt").on("keyup blur", function (event) {
        if (event.type === "keyup" && event.keyCode === 13) {
            if ($("#BtnUpdPay").css("display") === "none") {
                $("#BtnAddPay").click();
            } else {
                $("#BtnUpdPay").click();
            }
            return;
        }

        $(this).val(fnMoneyComma($(this).val()));
    });

    $("#Rate").on("keyup", function (event) {
        if (event.keyCode === 13) {
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

    if ($("#WoSeqNo").val()) {
        fnCallEdiDetail();
    }

    //상단고정을 위한 margin
    if ($("#HidMode").val() === "Update") {
        if ($("#DropArea").css("display") === "block") { //PDF 파일 DROP 영역이 열려있는 경우
            $("table.order_table").css("margin-top", "20px");
        } else {
            $("table.order_table").css("margin-top", "152px");
        }
    } else {
        if ($("#DropArea").css("display") === "block") { //PDF 파일 DROP 영역이 열려있는 경우
            $("table.order_table").css("margin-top", "20px");
        } else {
            $("table.order_table").css("margin-top", "126px");
        }
    }

    //발주처 자동완성
    if ($("#OrderClientName").length > 0) {
        fnSetAutocomplete({
            formId: "OrderClientName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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

                    //웹오더 접수일 때 처리
                    if ($("#OrderStatus").val() == "1" && ($("#OrderRegType").val() == "5" || $("#OrderRegType").val() == "7")) {
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
                    }
                    fnSetFocus();

                    //PDF 파일 DROP 영역 세팅
                    fnDropPDFAreaSetting();
                },
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
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

                    //자동운임 변경 체크
                    fnChangeRateChk();
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
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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

                    //웹오더 접수일 때 처리
                    if ($("#OrderStatus").val() == "1" && ($("#OrderRegType").val() == "5" || $("#OrderRegType").val() == "7")) {
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
                    }
                    fnSetFocus();

                    //PDF 파일 DROP 영역 세팅
                    fnDropPDFAreaSetting();
                },
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#OrderClientChargeName").val()) {
                        $("#OrderClientChargeName").val("");
                        $("#OrderClientChargePosition").val("");
                        $("#OrderClientChargeTelExtNo").val("");
                        $("#OrderClientChargeTelNo").val("");
                        $("#OrderClientChargeCell").val("");
                    }

                    //자동운임 변경 체크
                    fnChangeRateChk();
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
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
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

                    //자동운임 변경 체크
                    fnChangeRateChk();
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
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
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

                    //자동운임 변경 체크
                    fnChangeRateChk();
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
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
                },
                onBlur: () => {
                    if (!$("#ConsignorName").val()) {
                        $("#ConsignorCode").val("");
                    }

                    //자동운임 변경 체크
                    fnChangeRateChk();
                }
            }
        });
    }

    //상차지 자동완성
    if ($("#PickupPlace").length > 0) {
        fnSetAutocomplete({
            formId: "PickupPlace",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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
                    $("#PickupPlaceLocalCode").val(ui.item.etc.LocalCode);
                    $("#PickupPlaceLocalName").val(ui.item.etc.LocalName);
                    if ($("#OrderItemCode option:selected").text().indexOf("수입") > -1) {
                        $("#PickupPlaceNote").val(ui.item.etc.PlaceRemark2);
                    } else {
                        $("#PickupPlaceNote").val(ui.item.etc.PlaceRemark3);
                    }
                    fnSetFocus();
                },
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
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
                        $("#PickupPlaceLocalCode").val("");
                        $("#PickupPlaceLocalName").val("");
                    }

                    //자동운임 변경 체크
                    fnChangeRateChk();
                }
            }
        });
    }

    //상차지 담당자
    if ($("#PickupPlaceChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "PickupPlaceChargeName",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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
                    $("#PickupPlaceLocalCode").val(ui.item.etc.LocalCode);
                    $("#PickupPlaceLocalName").val(ui.item.etc.LocalName);
                    if ($("#OrderItemCode option:selected").text().indexOf("수입") > -1) {
                        $("#PickupPlaceNote").val(ui.item.etc.PlaceRemark2);
                    } else {
                        $("#PickupPlaceNote").val(ui.item.etc.PlaceRemark3);
                    }
                    fnSetFocus();
                },
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
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

                    //자동운임 변경 체크
                    fnChangeRateChk();
                }
            }
        });
    }

    //하차지 자동완성
    if ($("#GetPlace").length > 0) {
        fnSetAutocomplete({
            formId: "GetPlace",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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
                    $("#GetPlace").val(ui.item.etc.PlaceName);
                    $("#GetPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#GetPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#GetPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#GetPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#GetPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#GetPlacePost").val(ui.item.etc.PlacePost);
                    $("#GetPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#GetPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#GetPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#GetPlaceLocalCode").val(ui.item.etc.LocalCode);
                    $("#GetPlaceLocalName").val(ui.item.etc.LocalName);
                    if ($("#OrderItemCode option:selected").text().indexOf("수입") > -1) {
                        $("#GetPlaceNote").val(ui.item.etc.PlaceRemark2);
                    } else {
                        $("#GetPlaceNote").val(ui.item.etc.PlaceRemark3);
                    }
                    fnSetFocus();
                },
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#GetPlace").val()) {
                        $("#GetPlaceChargeName").val("");
                        $("#GetPlaceChargePosition").val("");
                        $("#GetPlaceChargeTelExtNo").val("");
                        $("#GetPlaceChargeTelNo").val("");
                        $("#GetPlaceChargeCell").val("");
                        $("#GetPlacePost").val("");
                        $("#GetPlaceAddr").val("");
                        $("#GetPlaceAddrDtl").val("");
                        $("#GetPlaceFullAddr").val("");
                        $("#GetPlaceLocalCode").val("");
                        $("#GetPlaceLocalName").val("");
                        $("#GetPlaceNote").val("");
                    }

                    //자동운임 변경 체크
                    fnChangeRateChk();
                }
            }
        });
    }

    //하차지 담당자
    if ($("#GetPlaceChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "GetPlaceChargeName",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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
                    $("#GetPlace").val(ui.item.etc.PlaceName);
                    $("#GetPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#GetPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#GetPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#GetPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#GetPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#GetPlacePost").val(ui.item.etc.PlacePost);
                    $("#GetPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#GetPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#GetPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#GetPlaceLocalCode").val(ui.item.etc.LocalCode);
                    $("#GetPlaceLocalName").val(ui.item.etc.LocalName);
                    if ($("#OrderItemCode option:selected").text().indexOf("수입") > -1) {
                        $("#GetPlaceNote").val(ui.item.etc.PlaceRemark2);
                    } else {
                        $("#GetPlaceNote").val(ui.item.etc.PlaceRemark3);
                    }
                    fnSetFocus();
                },
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#GetPlaceChargeName").val()) {
                        $("#GetPlaceChargePosition").val("");
                        $("#GetPlaceChargeTelExtNo").val("");
                        $("#GetPlaceChargeTelNo").val("");
                        $("#GetPlaceChargeCell").val("");
                    }

                    //자동운임 변경 체크
                    fnChangeRateChk();
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
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
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

    //계산서 담당자 자동완성
    if ($("#TaxClientName").length > 0) {
        fnSetAutocomplete({
            formId: "TaxClientName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Inout/Proc/InoutHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    ChargeBillFlag: "Y",
                    ClientFlag: "N",
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
                    $("#TaxClientName").val(ui.item.etc.ClientName);
                    $("#TaxClientCorpNo").val(ui.item.etc.ClientCorpNo);
                    $("#TaxClientChargeName").val(ui.item.etc.ChargeName);
                    $("#TaxClientChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#TaxClientChargeEmail").val(ui.item.etc.ChargeEmail);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ClientNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#TaxClientName").val()) {
                        $("#TaxClientCorpNo").val("");
                        $("#TaxClientChargeName").val("");
                        $("#TaxClientChargeTelNo").val("");
                        $("#TaxClientChargeEmail").val("");
                    }
                }
            }
        });
    }
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

//수출입에 따른 항목 세팅
function fnSetInout() {
    /*
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
    */
    if (($("#HidMode").val() === "Insert")) {
        if ($("#OrderItemCode option:selected").text().indexOf("해상수출") > -1) { //수입
            $("#ArrivalReportFlag").prop("checked", true);
        } else {
            $("#ArrivalReportFlag").prop("checked", false);
        }
    }
}

//비용정보 세팅
function fnSetPay() {
    if ($("#PayType option:selected").text() === "매입") { //매입
        $(".TrPayClient").show();
        $("#Rate").hide();
        $(".TrPay th").attr("rowspan", "3");
    } else if ($("#PayType option:selected").text() === "선급" || $("#PayType option:selected").text() === "예수") { //선급 or 예수
        $(".TrPayClient").show();
        $("#Rate").hide();
        $(".TrPay th").attr("rowspan", "3");
    } else { //매출 외
        $(".TrPayClient").hide();
        $("#Rate").show();
        $(".TrPay th").attr("rowspan", "2");
    }

    $("#TaxKind").find("option").filter(function (index) {
        return $(this).text() === "과세";
    }).prop("selected", true);


    $("#BtnUpdPay").hide();
    $("#BtnDelPay").hide();

    $("#SeqNo").val("");
    $("#PaySeqNo").val("");
    $("#Rate").val("");

    if (!((strPayType == "1" && $("#PayType").val() == "2") || (strPayType == "2" && $("#PayType").val() == "1"))) {
        $("#ItemCode").find("option:nth-child(2)").prop("selected", true);
        $("#SupplyAmt").val("");
        $("#TaxAmt").val("");        
    }
    
    $.each($(".TrPayClient input"),
        function (index, item) {
            $(item).val("");
        });
}

//오더 데이터 세팅
function fnCallOrderDetail() {

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnOrderDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "InoutList",
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

        if ($("#FTLFlag").is(":checked")) {
            $(".TrTransRate").show();
        }

        if ($("#CopyFlag").val() === "Y") {
            $("#HidMode").val("Insert");
            $("#CnlFlag").val("N");
            $("#OrderNo").val("");
            $("#DivOrderInfo").remove();
            $("#DivButtons").remove();
            $("#PickupYMD").datepicker("setDate", GetDateToday("-"));
            $("#PickupHM").val("");
            $("#GetYMD").datepicker("setDate", GetDateToday("-"));
            $("#GetHM").val("");
            $("#DocumentFlag").prop("checked", false);
            $("#OrderRegType").val("1");
            $(".TrGoods input").val("");
            $(".TrGoods select").val("");
            //PDF 파일 DROP 영역 세팅
            fnDropPDFAreaSetting();
            return false;
        }

        if ($("#CnlFlag").val() === "Y") {
            $("#BtnRegOrder").hide();
            $("#BtnCancelOrder").hide();
        } else {
            //PDF 파일 DROP 영역 세팅
            fnDropPDFAreaSetting();
        }

        //위수탁 정보 조회
        fnCallOrderContract();

        var strTransRateInfo = item.TransRateInfo;
        strTransRateInfo = typeof strTransRateInfo === "undefined" ? "" : strTransRateInfo;

        if (strTransRateInfo.indexOf("Y") === 0) {
            //요율표 조회
            fnCallTransRateData();
        }

        //파일 목록 조회
        fnCallFileData();

        //비용 목록 조회
        fnCallPayGridData(GridPayID);
    } else {
        fnCallDetailFailResult();
    }
}

function fnCallDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

function fnCallOrderContract() {

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCallOrderContractSuccResult";
    var strFailCallBackFunc = "fnCallOrderContractFailResult";

    var objParam = {
        CallType: "InoutContract",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
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
            /*
            if (item.ContractStatus === 2) {
                $("#SpanContract").text(item.ContractInfo);
                $(".NotAllowedContract").show();
            } else {
                $("#SpanContract").text("위탁취소 : " + item.ContractInfo);
            }
            $(".TrContract").show();
            */
        } else if (objRes[0].data.ContractType == 3) {
            $("#SpanContract").text(objRes[0].data.ContractInfo);
            $(".TrContract").show();
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

    if (!$("#OrderLocationCode").val()) {
        fnDefaultAlertFocus("사업장을 선택하세요.", "OrderLocationCode", "warning");
        return false;
    }

    if (!$("#OrderItemCode").val()) {
        fnDefaultAlertFocus("상품을 선택하세요.", "OrderItemCode", "warning");
        return false;
    }

    if (!$("#OrderClientCode").val()) {
        fnDefaultAlertFocus("발주처를 검색하세요.", "OrderClientName", "warning");
        return false;
    }

    if ($("#FTLFlag").is(":checked")) {
        if (!$("#CarTonCode").val()) {
            fnDefaultAlertFocus("요청톤급을 선택하세요.", "CarTonCode", "warning");
            return false;
        }

        if (!$("#CarTypeCode").val()) {
            fnDefaultAlertFocus("요청차종을 선택하세요.", "CarTypeCode", "warning");
            return false;
        }
    }

    if ($("#ContractType").val() !== "3") {
        if (!$("#OrderClientChargeName").val()) {
            fnDefaultAlertFocus("발주처 담당자명을 입력(or 검색)하세요.", "OrderClientChargeName", "warning");
            return;
        }

        if (!$("#OrderClientChargeTelNo").val() && !$("#OrderClientChargeCell").val()) {
            fnDefaultAlertFocus("발주처 담당자의 전화번호나 휴대폰번호를 입력하세요.", "OrderClientChargeTelNo", "warning");
            return;
        }
    }

    if (!$("#PayClientCode").val()) {
        fnDefaultAlertFocus("청구처를 검색하세요.", "PayClientName", "warning");
        return;
    }

    if ($("#ContractType").val() !== "3") {
        if (!$("#PayClientChargeName").val()) {
            fnDefaultAlertFocus("청구처 담당자명을 입력(or 검색)하세요.", "PayClientChargeName", "warning");
            return;
        }

        if (!$("#PayClientChargeTelNo").val() && !$("#PayClientChargeCell").val()) {
            fnDefaultAlertFocus("청구처 담당자의 전화번호나 휴대폰번호를 입력하세요.", "PayClientChargeTelNo", "warning");
            return;
        }

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

    if ($("#WoSeqNo").val() && $("#WoSeqNo").val() != "0") {
        if (!$("#PickupHM").val()) {
            fnDefaultAlertFocus("상차시간을 입력하세요.", "PickupHM", "warning");
            return false;
        }

        if (!UTILJS.Util.fnValidHM($("#PickupHM").val())) {
            fnDefaultAlertFocus("상차시간을 올바르게 입력하세요.", "PickupHM", "warning");
            return false;
        }
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

    if ($("#WoSeqNo").val() && $("#WoSeqNo").val() != "0") {
        if (!$("#GetHM").val()) {
            fnDefaultAlertFocus("하차시간을 입력하세요.", "GetHM", "warning");
            return false;
        }

        if (!UTILJS.Util.fnValidHM($("#GetHM").val())) {
            fnDefaultAlertFocus("하차시간을 올바르게 입력하세요.", "GetHM", "warning");
            return false;
        }
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


    //매출입 체크
    var AutoPay = false;
    var ClosingPay = false;
    if (AUIGrid.getGridData(GridPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridPayID),
            function (index, item) {
                if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                    if (item.PayType == 1) {
                        if (!AutoPay && item.ApplySeqNo > 0) {
                            AutoPay = true;
                        }

                        if (!ClosingPay && item.ItemCode == "OP001" && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) { //마감비용 체크
                            ClosingPay = true;
                        }
                    }
                }
            });
    }

    //자동운임체크
    if ($("#ContractType").val() !== "3" && $("#FTLFlag").is(":checked")) {
        if (!ClosingPay) {
            if (AutoPay) {
                if (fnGetRateConditionChange()) {
                    fnDefaultAlert("자동운임 확인이 필요하여 자동 조회합니다. 변경된 비용정보를 확인해 주세요.", "warning", "$(\"#BtnCallTransRate\").show();$(\"#BtnCallTransRate\").click();");
                    return false;
                }
            } else {
                if ($("#CenterCode").val() && $("#FTLFlag").is(":checked") && $("#CarTonCode").val() && $("#CarTypeCode").val() && $("#PayClientCode").val() && $("#ConsignorCode").val() && $("#PickupPlaceFullAddr").val() && $("#GetPlaceFullAddr").val()) {
                    if (fnGetRateConditionChange()) {
                        fnDefaultAlert("자동운임 확인이 필요하여 자동 조회합니다. 변경된 비용정보를 확인해 주세요.", "warning", "$(\"#BtnCallTransRate\").show();$(\"#BtnCallTransRate\").click();");
                        return false;
                    }
                }
            }
        } else {
            if (AutoPay && fnGetRateConditionChange()) {
                fnDefaultAlert("마감된 자동운임이 있어 항목 변경이 불가능합니다.", "warning");
                return false;
            }
        }
    }

    strCallType = "Inout" + $("#HidMode").val();
    strConfMsg = "오더를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsOrderProc", fnParam);
    return;
};

function fnInsOrderProc(fnParam) {
    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
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
        TaxClientChargeEmail : $("#TaxClientChargeEmail").val(),
        ChgSeqNo: $("#ChgSeqNo").val(),
        WoSeqNo: $("#WoSeqNo").val(),
        OrderRegType: $("#PdfNote").val() !== "" ? "9":"1"
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
        var strHandlerURL = "/TMS/Inout/Proc/InoutFileHandler.ashx";
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
    RowPay.OrderNo = $("#OrderNo").val()
    RowPay.GoodsSeqNo = $("#GoodsSeqNo").val()

    if (RowPay) {
        var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
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
    if ($("#WoSeqNo").val() && $("#WoSeqNo").val() != "0") {
        if (opener.document) {
            if ($("#BtnReset", opener.document).length > 0 && opener.document.location.href.indexOf("InoutEIList") > -1) {
                $("#BtnReset", opener.document).click();
            }
        }
    }
    document.location.replace("/TMS/Inout/InoutIns?OrderNo=" + $("#OrderNo").val());
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

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCnlOrderSuccResult";
    var strFailCallBackFunc = "fnCnlOrderFailResult";
    var objParam = {
        CallType: "InoutOneCancel",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        CnlReason: $("#CnlReason").val(),
        ChgSeqNo: $("#ChgSeqNo").val(),
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

    //PDF 파일 DROP 영역 세팅
    fnDropPDFAreaSetting();
}

//사업장, 비용항목 리셋
function fnSetCodeList() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
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
var GridPayID = "#InoutOrderPayListGrid";

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

    if (typeof objItem.RefSeqNo !== "undefined") {
        if (objItem.RefSeqNo !== "" && objItem.RefSeqNo !== "0") {
            fnDefaultAlert("차량 비용은 수정할 수 없습니다", "error");
            return;
        }
    }

    if (objItem.ClosingFlag !== "N" || objItem.BillStatus !== 1 || objItem.SendStatus !== 1) {
        fnDefaultAlert("매출 마감된 오더입니다. 매출 비용을 수정하시려면 매출 마감취소 후 수정해 주세요.", "error");
        return;
    }

    if (typeof objItem.ApplySeqNo !== "undefined") {
        if (objItem.ApplySeqNo != "0") {
            fnDefaultAlert("자동운임으로 등록된 비용은 수정할 수 없습니다.<br/>\"자동운임 수정요청\" 기능을 이용하세요.", "error");
            return;
        }
    }

    fnDisplayPay(objItem);
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallPayGridData(strGID) {

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
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
    var blRatePayChk = true;
    var intRate = 0;
    var intRateSupplyAmt = 0;
    var intRateTaxAmt = 0;
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
    } else { //매출
        try {
            intRate = parseInt($("#Rate").val());

            if (isNaN(intRate)) {
                intRate = 0;
            }
        } catch (e) {
            intRate = 0;
        }

        //OP037	할증료
        if (intRate > 0) {
            try {
                intRateSupplyAmt = Math.floor(parseFloat($("#SupplyAmt").val().replace(/,/gi, "")) * intRate / 100);

                if (isNaN(intRateSupplyAmt)) {
                    intRateSupplyAmt = 0;
                }

                intRateSupplyAmt = parseInt(intRateSupplyAmt / 100) * 100;

            } catch (e) {
                intRateSupplyAmt = 0;
            }

            //과세구분 (1:과세, 2:면세, 3:간이, 4:간이과세, 5:영세)
            if ($("#TaxKind").val() === "2" || $("#TaxKind").val() === "3" || $("#TaxKind").val() === "5") {
                intRateTaxAmt = 0;
            } else {
                try {
                    intRateTaxAmt = Math.floor(parseFloat(intRateSupplyAmt) * 0.1);

                    if (isNaN(intRateTaxAmt)) {
                        intRateTaxAmt = 0;
                    }

                } catch (e) {
                    intRateTaxAmt = 0;
                }
            }
        } else {
            blRatePayChk = false;
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
    
    if ($("#PayType").val() === "1" && blRatePayChk) { //할증료 등록
        var objItem = new Object();
        objItem.PayTypeM = $("#PayType option:selected").text();
        objItem.TaxKindM = $("#TaxKind option:selected").text();
        objItem.ItemCodeM = "할증료";
        objItem.SupplyAmt = intRateSupplyAmt;
        objItem.TaxAmt = intRateTaxAmt;
        objItem.ClientInfo = strClientInfo;
        objItem.SeqNo = "";
        objItem.PaySeqNo = "";
        objItem.CenterCode = $("#CenterCode").val();
        objItem.OrderNo = $("#OrderNo").val();
        objItem.GoodsSeqNo = $("#GoodsSeqNo").val();
        objItem.PayType = $("#PayType").val();
        objItem.TaxKind = $("#TaxKind").val();
        objItem.ItemCode = "OP037";
        objItem.ClientCode = $("#ClientCode").val();
        objItem.ClientName = $("#ClientName").val();
        objItem.ClosingFlag = "N";
        objItem.BillStatus = 1;
        objItem.SendStatus = 1;
        AUIGrid.addRow(GridPayID, objItem, "last");
    }

    fnSetPay();
}

//비용수정
function fnPayUpdRow() {
    var strClientInfo = "";
    
    if (!$("#PaySeqNo").val()) {
        fnDefaultAlert("선택된 비용정보가 없습니다.", "warning");
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
/*********************************************/

/*********************************************/
/*                파일 첨부                  */
/*********************************************/
$(document).ready(function () {
    $("#FileUpload").fileupload({
        dataType: "json",
        autoUpload: false,
        type: "POST",
        url: "/TMS/Inout/Proc/InoutFileHandler.ashx?CallType=OrderFileUpload",
        add: function (e, data) {
            var uploadErrors = [];

            if (!$("#CenterCode").val()) {
                uploadErrors.push("회원사를 선택하세요.");
                $("#CenterCode").focus();
            }

            var acceptFileTypes = /(jpe?g|jpg|png|pdf|gif|xls|xlsx|doc|docx|ppt|pptx|hwp|hwpx)/i;
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

    var strHandlerURL = "/TMS/Inout/Proc/InoutFileHandler.ashx";
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

    $form.attr('action', '/TMS/Inout/Proc/InoutFileHandler.ashx');
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
    
    var strHandlerURL = "/TMS/Inout/Proc/InoutFileHandler.ashx";
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

    //자동운임 변경 체크
    fnChangeRateChk();
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

    //자동운임 변경 체크
    fnChangeRateChk();
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

    //자동운임 변경 체크
    fnChangeRateChk();
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

/*********************************************/
//웹오더 변경요청 목록
/*********************************************/
var ReqGridID = "#OrderRequestListGrid";
var ReqGridSort = [];

$(document).ready(function () {
    if ($("#OrderNo").val() !== "") {
        // 그리드 초기화
        fnReqGridInit();
    }
});

function fnReqGridInit() {
    // 그리드 레이아웃 생성
    fnReqCreateGridLayout(ReqGridID, "ChgSeqNo");

    fnSetGridEvent(ReqGridID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 900;
    AUIGrid.resize(ReqGridID, $(".req_grid_list").width(), intHeight);

    //그리드에 포커스
    AUIGrid.setFocus(ReqGridID);
}

//기본 레이아웃 세팅
function fnReqCreateGridLayout(strGID, strRowIdField) {

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
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.rowStyleFunction = function (rowIndex, item) {

        if (item.ChgStatus === 4) {
            return "aui-grid-bonded-y-no-accept-row-style";
        }

        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetReqDefaultColumnLayout()");
    var objOriLayout = fnGetReqDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetReqDefaultColumnLayout() {
    var objColumnLayout = [
        {
            dataField: "ChgStatusM",
            headerText: "상태",
            editable: false,
            width: 50,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "RegAdminName",
            headerText: "요청자",
            editable: false,
            width: 80,
            dataType: "string",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "UpdAdminName",
            headerText: "처리자",
            editable: false,
            width: 80,
            dataType: "string",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ChgReqContent",
            headerText: "내용",
            editable: false,
            width: 300,
            dataType: "string",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "RegDate",
            headerText: "요청일",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        }, {
            dataField: "BtnReqCngCancel",
            headerText: "요청취소",
            editable: false,
            width: 60,
            renderer: {
                type: "ButtonRenderer",
                labelText: "취소",
                onClick: function (event) {
                    fnReqChgCancelConfirm(event.item);
                    return;
                },
                visibleFunction: function (rowIndex, columnIndex, value, item, dataField) {
                    // 행 아이템의 name 이 Anna 라면 버튼 표시 하지 않음
                    if (item.ChgStatus == 3 || item.ChgStatus == 4) {
                        return false;
                    }
                    return true;
                }
            }
        },
        //숨김필드
        {
            dataField: "ChgSeqNo",
            headerText: "ChgSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        }, {
            dataField: "OrderNo",
            headerText: "OrderNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnReqCallGridData(strGID) {

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnReqGridSuccResult";


    var objParam = {
        CallType: "OrderRequestChgList",
        ListType: "2", //수출입
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        PageNo: "1",
        PageSize: "3000"
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnReqGridSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(ReqGridID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(ReqGridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(ReqGridID);

        // 그리드 정렬
        AUIGrid.setSorting(ReqGridID, ReqGridSort);
    }
}

function fnOpenOrderReqChg() {
    fnReqCallGridData(ReqGridID);
    $("#DivOrderReq").show();
    AUIGrid.resize(ReqGridID, $("#DivOrderReq .req_grid_list").width(), $("#DivOrderReq .req_grid_list").height());
}

function fnCloseOrderReq() {
    AUIGrid.setGridData(ReqGridID, []);
    $("#DivOrderReq").hide();
    return false;
}

function fnReqChgCancelConfirm(item) {

    if (item.ChgStatus === 3) {
        fnDefaultAlert("이미 처리완료된 요청건입니다.", "warning");
        return;
    }

    fnDefaultConfirm("해당 요청을 취소하시겠습니까?", "fnReqChgCancel", item);
    return;
}

function fnReqChgCancel(item) {

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnReqChgCancelSuccResult";

    var objParam = {
        CallType: "OrderRequestChgUpd",
        ChgSeqNo: item.ChgSeqNo,
        ChgReqContent: item.ChgReqContent,
        ChgMessage: "요청취소",
        ChgStatus: "4"
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(ReqGridID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnReqChgCancelSuccResult(data) {

    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].Errmsg, "warning");
    } else {
        fnDefaultAlert("취소되었습니다.", "success");
    }
    fnReqCallGridData(ReqGridID);
    return;
}

/*****************************************/
//상하차지 특이사항
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
            fnDefaultAlertFocus("상차지를 입력(or 검색)하세요.", "PickupPlace", "warning");
            return false;
        }
    } else if (intType === 2) {
        strPlaceName = $("#GetPlace").val();
        strPlaceAddr = $("#GetPlaceAddr").val();
        strPlaceAddrDtl = $("#GetPlaceAddrDtl").val();
        if (strPlaceName === "") {
            fnDefaultAlertFocus("하차지를 입력(or 검색)하세요.", "GetPlace", "warning");
            return false;
        }
    }

    strPlaceName = encodeURIComponent(strPlaceName);
    strPlaceAddr = encodeURIComponent(strPlaceAddr);
    strPlaceAddrDtl = encodeURIComponent(strPlaceAddrDtl);

    window.open("/TMS/Common/PlaceNote?OrderType=2&CenterCode=" + $("#CenterCode").val() + "&PlaceType=" + intType + "&PlaceName=" + strPlaceName + "&PlaceAddr=" + strPlaceAddr + "&PlaceAddrDtl=" + strPlaceAddrDtl, "상하차지특이사항", "width=650, height=450, scrollbars=Yes");
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
        fnDefaultAlertFocus("상차일을 입력하세요.", "PickupYMD", "warning");
        return;
    }

    var strHandlerUrl = "/TMS/Inout/Proc/InoutHandler.ashx";
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
    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
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

//원본오더 보기
function fnOpenOrderOrgDetail() {
    if ($("#OrderRegType").val() !== "5" && $("#OrderRegType").val() !== "7") {
        fnDefaultAlert("원본오더가 없습니다.");
        return;
    } else {
        window.open("/WEB/Inout/WebInoutOrgDetail?OrderNo=" + $("#OrderNo").val(), "요청 원본 오더", "width=1180, height=700px, scrollbars=Yes");
        return;
    }
}


/*유니페스 팝업 페이지*/
function fnUnipassPopup(type) {
    if ($("#Hawb").val() === "") {
        fnDefaultAlert("H/AWB가 없습니다.");
        return;
    }

    window.open('/TMS/Unipass/UnipassDetailList?Hawb=' + $("#Hawb").val() + "&PickupYMD=" + $("#PickupYMD").val().substring(0, 4) + "&HidMode=Inout", '화물통관 진행정보', 'width=1200px,height=800px,scrollbars=yes');
    return;
}


/*******************************************/
//디에이치엘글로벌포워딩코리아 업체 PDF 인식
/*******************************************/
var files;
function handleDragOver(event) {
    event.stopPropagation();
    event.preventDefault();
    var dropZone = document.getElementById('drop_zone');
    dropZone.innerHTML = "디에이치엘글로벌포워딩코리아 PDF파일을 첨부해주세요.";
}

function handleDnDFileSelect(event) {
    event.stopPropagation();
    event.preventDefault();

    /* Read the list of all the selected files. */
    files = event.dataTransfer.files;

    /* Consolidate the output element. */

    if (files.length > 1) {
        fnDefaultAlert("1개 PDF파일만 가능합니다");
        return;
    }

    if (files[0].name.split(".")[1].toUpperCase() !== "PDF") {
        fnDefaultAlert("PDF확장자가 아닙니다.");
        return;
    }

    var form = document.getElementById('mainform');
    var data = new FormData(form);

    for (var i = 0; i < files.length; i++) {
        data.append(files[i].name, files[i]);
    }

    $.ajax({
        type: "POST",
        url: "/TMS/Inout/Proc/InoutPdfDropFileHandler.ashx?CallType=PdfOrderFileDrop",
        contentType: false,
        processData: false,
        data: data,
        beforeSend: function () {
            UTILJS.Ajax.fnAjaxBlock();
        },
        success: function (result) {
            if ($("#OrderItemCode option:selected").text() === "항공수출") {
                fnOutDhlOrderSetting(result);
                return false;
            } else if ($("#OrderItemCode option:selected").text() === "항공수입") {
                fnInDhlOrderSetting(result);
                return false;
            }
        },
        complete: function () {
            $.unblockUI();
        },
        error: function () {
            $.unblockUI();
            fnDefaultAlert("PDF 파일 인식 실패.");
            return;
        }
    });
}

//수출오더 세팅
function fnOutDhlOrderSetting(objRes) {
    
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnCallDHLOrderDetailFailResult(objRes[0].ErrMsg);
            return false;
        }

        if (objRes.length !== 1) {
            fnCallDHLOrderDetailFailResult(objRes[0].ErrMsg);
            return false;
        }

        var item = objRes[0];
        
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

        //Textarea
        //$.each($("textarea"),
        //    function (index, input) {
        //        if (eval("item." + $(input).attr("id")) != null) {
        //            $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
        //        }
        //    });
        
        $.each($("select"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id")) + "']").length > 0) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });

        $("#PdfNote").val(item.NoteInside);
        $("#GoodsItemCode").val("OD002");
        $("#Quantity").val("");
        $("#GetPlaceNote").val(item.Hawb);

        if (item.APIPlaceFlag == "Y") {
            $("#PickupPlacePost").val(item.APIPlacePost);
            $("#PickupPlaceAddr").val(item.APIPlaceAddr);
            $("#PickupPlaceAddrDtl").val(item.APIPlaceAddrDtl);
            $("#PickupPlaceFullAddr").val(item.APIPlaceFullAddr);
            $("#PickupPlaceLocalCode").val(item.APIPlaceLocalCode);
            $("#PickupPlaceLocalName").val(item.APIPlaceLocalName);
        }

        if (item.APIPlaceChargeFlag == "Y") {
            $("#PickupPlaceChargeName").val(item.APIPlaceChargeName);
            $("#PickupPlaceChargeTelNo").val(item.APIPlaceChargeTelNo);
            $("#PickupPlaceChargeTelExtNo").val(item.APIPlaceChargeTelExtNo);
            $("#PickupPlaceChargeCell").val(item.APIPlaceChargeCell);
            $("#PickupPlaceChargePosition").val(item.APIPlaceChargePosition);
        }

        //화물정보
        if (item.goods.length > 0) {
            
            for (var i = 0; i < item.goods.length; i++) {
                var ItemCode = $("#GoodsItemCode option:selected").text();
                var w = item.goods[i].Width ? item.goods[i].Width : "0";
                var h = item.goods[i].Height ? item.goods[i].Height : "0";
                var l = item.goods[i].Length ? item.goods[i].Length : "0";
                var v = item.goods[i].Volume ? item.goods[i].Volume : "0";
                var itemText = "";
                var totalVolume = $("#Volume").val() ? $("#Volume").val() : "0";
                var totalCbm = $("#CBM").val() ? $("#CBM").val() : "0.0";
                var volume = 0;
                var cbm = 0.0;

                itemText = ItemCode + " " + l + "*" + w + "*" + h + "*" + v;

                if ($("#Quantity").val()) {
                    $("#Quantity").val($("#Quantity").val() + ", " + itemText);
                } else {
                    $("#Quantity").val(itemText);
                }

                $("#GoodsItemWidth").val("");
                $("#GoodsItemHeight").val("");
                $("#GoodsItemLength").val("");
                $("#GoodsItemVolume").val("");
                $("#GoodsItemWidth").focus();
            }
        }

        if ($("#CopyFlag").val() !== "Y") {
            fnSetDHLPlageChargeInfo();
        }
        return false;
    } else {
        fnCallDHLOrderDetailFailResult();
        return false;
    }
}

//수입오더 세팅
function fnInDhlOrderSetting(objRes) {

    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnCallDHLOrderDetailFailResult(objRes[0].ErrMsg);
            return false;
        }

        if (objRes.length !== 1) {
            fnCallDHLOrderDetailFailResult(objRes[0].ErrMsg);
            return false;
        }

        var item = objRes[0];

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

        //Textarea
        //$.each($("textarea"),
        //    function (index, input) {
        //        if (eval("item." + $(input).attr("id")) != null) {
        //            $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
        //        }
        //    });

        $.each($("select"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id")) + "']").length > 0) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });

        $("#PdfNote").val(item.GetPlaceAddr);
        if (typeof item.NoteInside === "string") {
            if (item.NoteInside !== "") {
                $("#PdfNote").val($("#PdfNote").val() + "\n\n" + item.NoteInside);
            }
        }
        $("#GoodsItemCode").val("OD002");
        $("#Quantity").val("");

        if (item.APIPlaceFlag == "Y") {
            $("#GetPlacePost").val(item.APIPlacePost);
            $("#GetPlaceAddr").val(item.APIPlaceAddr);
            $("#GetPlaceAddrDtl").val(item.APIPlaceAddrDtl);
            $("#GetPlaceFullAddr").val(item.APIPlaceFullAddr);
            $("#GetPlaceLocalCode").val(item.APIPlaceLocalCode);
            $("#GetPlaceLocalName").val(item.APIPlaceLocalName);
        }

        if (item.APIPlaceChargeFlag == "Y") {
            $("#GetPlaceChargeName").val(item.APIPlaceChargeName);
            $("#GetPlaceChargeTelNo").val(item.APIPlaceChargeTelNo);
            $("#GetPlaceChargeTelExtNo").val(item.APIPlaceChargeTelExtNo);
            $("#GetPlaceChargeCell").val(item.APIPlaceChargeCell);
            $("#PickupPlaceChargePosition").val(item.APIPlaceChargePosition);
        }

        //화물정보
        if (item.goods.length > 0) {
            for (var i = 0; i < item.goods.length; i++) {
                var ItemCode = $("#GoodsItemCode option:selected").text();
                var w = item.goods[i].Width ? item.goods[i].Width : "0";
                var h = item.goods[i].Height ? item.goods[i].Height : "0";
                var l = item.goods[i].Length ? item.goods[i].Length : "0";
                var v = item.goods[i].Volume ? item.goods[i].Volume : "0";
                var itemText = "";
                var totalVolume = $("#Volume").val() ? $("#Volume").val() : "0";
                var totalCbm = $("#CBM").val() ? $("#CBM").val() : "0.0";
                var volume = 0;
                var cbm = 0.0;

                itemText = ItemCode + " " + l + "*" + w + "*" + h + "*" + v;

                if ($("#Quantity").val()) {
                    $("#Quantity").val($("#Quantity").val() + ", " + itemText);
                } else {
                    $("#Quantity").val(itemText);
                }

                $("#GoodsItemWidth").val("");
                $("#GoodsItemHeight").val("");
                $("#GoodsItemLength").val("");
                $("#GoodsItemVolume").val("");
                $("#GoodsItemWidth").focus();
            }
        }

        if ($("#CopyFlag").val() !== "Y") {
            fnSetDHLPlageChargeInfo();
        }
        return false;
    } else {
        fnCallDHLOrderDetailFailResult();
        return false;
    }
}

function fnCallDHLOrderDetailFailResult(ErrMsg) {
    var strErrMsg = "";

    if (ErrMsg !== "" || ErrMsg !== null) {
        strErrMsg = ErrMsg;
    } else {
        strErrMsg = "데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.";
    }
    fnDefaultAlert(strErrMsg, "error");
    return false;
}

//상하차 담당자 정보 조회
function fnSetDHLPlageChargeInfo() {
    var strHandlerURL = "/TMS/Inout/Proc/InoutPdfDropFileHandler.ashx";
    var strCallBackFunc = "fnSetDHLPlageChargeInfoResult";

    var objParam = {
        CallType: "PlaceChargeList",
        OrderItemCode: $("#OrderItemCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnSetDHLPlageChargeInfoResult(objRes) {
    if (objRes) {
        if (objRes[0].data.RecordCnt === 1) {
            $("#" + objRes[1].SetType + "Place").val(objRes[0].data.list[0].PlaceName);
            $("#" + objRes[1].SetType + "PlaceChargeName").val(objRes[0].data.list[0].ChargeName);
            $("#" + objRes[1].SetType + "PlaceChargePosition").val(objRes[0].data.list[0].ChargePosition);
            $("#" + objRes[1].SetType + "PlaceChargeTelExtNo").val(objRes[0].data.list[0].ChargeTelExtNo);
            $("#" + objRes[1].SetType + "PlaceChargeTelNo").val(objRes[0].data.list[0].ChargeTelNo);
            $("#" + objRes[1].SetType + "PlaceChargeCell").val(objRes[0].data.list[0].ChargeCell);
            $("#" + objRes[1].SetType + "PlacePost").val(objRes[0].data.list[0].PlacePost);
            $("#" + objRes[1].SetType + "PlaceAddr").val(objRes[0].data.list[0].PlaceAddr);
            $("#" + objRes[1].SetType + "PlaceAddrDtl").val(objRes[0].data.list[0].PlaceAddrDtl);
            $("#" + objRes[1].SetType + "PlaceFullAddr").val(objRes[0].data.list[0].FullAddr);
            $("#" + objRes[1].SetType + "PlaceLocalCode").val(objRes[0].data.list[0].LocalCode);
            $("#" + objRes[1].SetType + "PlaceLocalName").val(objRes[0].data.list[0].LocalName);
            if (objRes[1].SetType !== "Get") {
                $("#" + objRes[1].SetType + "PlaceNote").val(objRes[0].data.list[0].PlaceNote);
            }
        }
    }
}

function fnDropPDFAreaOpen() {
    $("#DropArea").show();
    $("table.order_table").css("margin-top", "20px");

    if ($("#HidMode").val() === "Update") {
        $("#DropArea").css("margin", "160px auto 0 auto");
    }

    return false;
}

function fnDropPDFAreaClose() {
    $("#DropArea").hide();
    $("#DropArea").css("margin", "");
    if ($("#HidMode").val() === "Update") {
        $("table.order_table").css("margin-top", "152px");
    } else {
        $("table.order_table").css("margin-top", "126px");
    }
    return false;
}

function fnDropPDFAreaSetting() {
    if ($("#CenterCode").val() === "2" && $("#OrderClientName").val() === "디에이치엘글로벌포워딩코리아" && $("#OrderItemCode option:selected").text() === "항공수출") {
        fnDropPDFAreaOpen();
    } else if ($("#CenterCode").val() === "2" && $("#OrderClientName").val() === "디에이치엘글로벌포워딩코리아" && $("#OrderItemCode option:selected").text() === "항공수입" && $("#OrderLocationCode option:selected").text() === "인천공항") {
        fnDropPDFAreaOpen();
    } else {
        fnDropPDFAreaClose();
    }

    return false;
}
/*******************************************/

/*********************************************/
/* 자동운임 */
/*********************************************/
//오더 자동운임 조회
function fnCallTransRateData() {
    if (!$("#OrderNo").val() || !$("#CenterCode").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCallTransRateDataSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "TransRateOrderList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        CarFixedFlag: $("#HidCarDivType1").val() != "3" ? "Y" : "N"
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
    return false;
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
        $("#SpanTransRateInfo").html("");
        $("#BtnCallTransRate").show();
        $("#BtnUpdRequestAmt").hide();

        //자동운임 항목 초기화
        if (objRes[0].data.RecordCnt <= 0) {
            return false;
        }

        var rateCntType1 = 0;
        $.each(objRes[0].data.list, function (index, item) {
            if (item.RateInfoKind === 1) {
                rateCntType1++;
            }
        });

        $("#ApplySeqNo").val(objRes[0].data.ApplySeqNo);

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
                    $("#SpanTransRateInfo").html($("#SpanTransRateInfo").html() + ($("#SpanTransRateInfo").html() !== "" ? " / " : "") + item.RateInfo);
                } else {
                    $("#SaleUnitAmt").val(item.SaleUnitAmt);
                    $("#SaleUnitAmt").val(fnMoneyComma($("#SaleUnitAmt").val()));
                    $("#FixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                    $("#FixedPurchaseUnitAmt").val(fnMoneyComma($("#FixedPurchaseUnitAmt").val()));
                    $("#PurchaseUnitAmt").val(item.PurchaseUnitAmt);
                    $("#PurchaseUnitAmt").val(fnMoneyComma($("#PurchaseUnitAmt").val()));
                    $("#SpanTransRateInfo").html(item.RateInfo);
                }
            }
        });

        $("#BtnCallTransRate").hide();
        $("#BtnUpdRequestAmt").show();
    } else {
        fnCallDetailFailResult();
    }
}

//자동운임 조회
function fnCallTransRate() {

    $("#HidCenterCode").val($("#CenterCode").val());
    $("#HidOrderLocationCode").val($("#OrderLocationCode").val());
    $("#HidOrderItemCode").val($("#OrderItemCode").val());
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
    $("#HidFTLFlag").val($("#FTLFlag").is(":checked") ? "Y" : "N");

    var PayChk = true;
    if (AUIGrid.getGridData(GridPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridPayID),
            function (index, item) {
                //운임
                if (item.PayType == 1 && item.ItemCode == "OP001" && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) { //마감체크
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

    if (!$("#OrderLocationCode").val()) {
        fnDefaultAlertFocus("사업장을 선택하세요.", "OrderLocationCode", "warning");
        return;
    }

    if (!$("#OrderItemCode").val()) {
        fnDefaultAlertFocus("상품을 선택하세요.", "OrderItemCode", "warning");
        return;
    }

    if ($("#FTLFlag").is(":checked")) {
        if (!$("#CarTonCode").val()) {
            fnDefaultAlertFocus("요청톤급을 선택하세요.", "CarTonCode", "warning");
            return false;
        }

        if (!$("#CarTypeCode").val()) {
            fnDefaultAlertFocus("요청차종을 선택하세요.", "CarTypeCode", "warning");
            return false;
        }
    }

    if (!$("#PayClientCode").val() || $("#PayClientCode").val() === "0") {
        fnDefaultAlertFocus("청구처를 선택하세요.", "PayClientName", "warning");
        return false;
    }

    if (!$("#ConsignorCode").val() || $("#ConsignorCode").val() === "0") {
        fnDefaultAlertFocus("화주를 선택하세요.", "ConsignorName", "warning");
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

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCallTransRateSuccResult";
    var strFailCallBackFunc = "fnCallTransRateFailResult";

    var objParam = {
        CallType: "TransRateOrderApplyList",
        CenterCode: $("#CenterCode").val(),
        OrderLocationCode: $("#OrderLocationCode").val(),
        OrderItemCode: $("#OrderItemCode").val(),
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
        FTLFlag: $("#FTLFlag").is(":checked") ? "Y" : "N",
        CarFixedFlag: $("#HidCarDivType1").val() != "3" ? "Y" : "N"
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
        $("#SpanTransRateInfo").html("");
        $("#BtnUpdRequestAmt").hide();

        //자동운임 항목 초기화
        if (objRes[0].data.RecordCnt <= 0) {
            if (AUIGrid.getGridData(GridPayID).length > 0) {
                var arrRemoveIds = [];
                $.each(AUIGrid.getGridData(GridPayID),
                    function (index, item) {
                        //운임
                        if (item.PayType == 1 && item.ItemCode == "OP001" && (item.ApplySeqNo != "" && item.ApplySeqNo != "0")) {
                            arrRemoveIds.push(item.PaySeqNo);
                        }
                    });

                if (arrRemoveIds.length > 0) {
                    AUIGrid.removeRowByRowId(GridPayID, arrRemoveIds);
                }
            }

            fnDefaultAlert("적용 가능한 자동운임이 없습니다.", "info");
            return false;
        }


        var PayChk = true;
        //마감체크 (운임) 시작
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if (item.PayType == 1 && item.ItemCode == "OP001" && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) {
                        PayChk = false;
                        return false;
                    }
                });
        }

        if (!PayChk) {
            fnDefaultAlert("이미 마감된 운임이 있어 자동운임을 적용할 수 없습니다.", "warning");
            return false;
        }
        //마감체크 (운) 끝

        //기존 항목 삭제
        if (AUIGrid.getGridData(GridPayID).length > 0) {
            var arrRemoveIds = [];

            $.each(AUIGrid.getGridData(GridPayID),
                function (index, item) {
                    if (item.PayType == 1 && item.ItemCode == "OP001") {
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

                    $("#SpanTransRateInfo").html($("#SpanTransRateInfo").html() + ($("#SpanTransRateInfo").html() !== "" ? " / " : "") + item.RateInfo);
                } else {
                    $("#SaleUnitAmt").val(item.SaleUnitAmt);
                    $("#SaleUnitAmt").val(fnMoneyComma($("#SaleUnitAmt").val()));
                    $("#FixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                    $("#FixedPurchaseUnitAmt").val(fnMoneyComma($("#FixedPurchaseUnitAmt").val()));
                    $("#PurchaseUnitAmt").val(item.PurchaseUnitAmt);
                    $("#PurchaseUnitAmt").val(fnMoneyComma($("#PurchaseUnitAmt").val()));
                    $("#SpanTransRateInfo").html(item.RateInfo);
                }
                fnSetTransRate(item);
            }
        });

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

    if (objRateItem.SaleUnitAmt === 0) {
        ApplySale = false;
    }

    if (objRateItem.RateInfoKind === 1) { //운임
        strItemCode = "OP001";
        strItemName = "운임";
    }

    //매출 추가
    if (ApplySale) {

        try {
            intSupplyAmt = objRateItem.SaleUnitAmt;

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
        || $("#HidOrderItemCode").val() !== $("#OrderItemCode").val()
        || $("#HidOrderLocationCode").val() !== $("#OrderLocationCode").val()
        || $("#HidPayClientCode").val() !== $("#PayClientCode").val()
        || $("#HidConsignorCode").val() !== $("#ConsignorCode").val()
        || $("#HidPickupPlaceFullAddr").val() !== $("#PickupPlaceFullAddr").val()
        || $("#HidGetPlaceFullAddr").val() !== $("#GetPlaceFullAddr").val()
        || $("#HidFTLFlag").val() !== ($("#FTLFlag").is(":checked") ? "Y" : "N")) {
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
                            if (!ClosingPay && item.ItemCode == "OP001" && (item.ClosingFlag !== "N" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1)) {
                                ClosingPay = true;
                            }
                        }
                    });
            }

            if (!ClosingPay) {
                if (!$("#FTLFlag").is(":checked")) {

                    if (AUIGrid.getGridData(GridPayID).length > 0) {
                        var objOldItem = null;
                        $.each(AUIGrid.getGridData(GridPayID), function (index, item) {
                            if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                                if (item.PayType == 1 && item.ItemCode == "OP001") {
                                    objOldItem = item;
                                    return false;
                                }
                            }
                        });

                        AUIGrid.removeRowByRowId(GridPayID, objOldItem.PaySeqNo);

                        objOldItem.SeqNo = 0;
                        objOldItem.ApplySeqNo = 0;
                        objOldItem.TransDtlSeqNo = 0;
                        objOldItem.TransRateStatus = 1;
                        objOldItem.ClientInfo = "";
                        objOldItem.DispatchInfo = "";
                        objOldItem.RegAdminName = "";
                        objOldItem.RegDate = "";
                        objOldItem.UpdAdminName = "";
                        objOldItem.UpdDate = "";
                        AUIGrid.addRow(GridPayID, objOldItem, "last");
                    }

                    $("#ApplySeqNo").val("");
                    $("#BtnUpdRequestAmt").hide();
                }
                $("#BtnCallTransRate").show();
                return false;
            } else {
                fnDefaultAlert("마감된 자동운임이 있어 일부 항목 변경이 불가능합니다.", "warning");
                return false;
            }
        }
    }
}

//자동운임 비고 세팅
function fnSetNoteInside() { //스퀘어 요청으로 주석처리 20240701
    //var strNoteInside = $("#NoteInside").val();
    //
    //if (strNoteInside.indexOf("||") > -1) {
    //    strNoteInside = strNoteInside.substr(strNoteInside.indexOf("||") + 3);
    //}
    //
    //if ($("#FTLFlag").is(":checked")) {
    //    var strNote = "";
    //    strNote += "독차";
    //    strNote += $("#CarTonCode").val() !== "" ? $("#CarTonCode option:selected").text() : "";
    //    strNote += $("#CarTypeCode").val() !== "" ? $("#CarTypeCode option:selected").text()  : "";
    //    strNoteInside = strNote + " || " + strNoteInside;
    //}
    //
    //$("#NoteInside").val(strNoteInside);
    //return false;
}
/*********************************************/

/*********************************************/
//자동운임 수정요청
/*********************************************/

var GridTRAID = "#OrderTransRateAmtRequestGrid";
$(document).ready(function () {
    if ($(GridTRAID).length > 0) {
        // 그리드 초기화
        fnGridTRAInit();
    }
});

function fnGridTRAInit() {

    // 그리드 레이아웃 생성
    fnCreateGridTRALayout(GridTRAID, "SeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridTRAID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridTRAID, "", "", "", "", "", "", "", "");

    //에디팅 이벤트 바인딩
    AUIGrid.bind(GridTRAID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd"], fnGridTRACellEditingHandler);

    // 사이즈 세팅
    var intHeight = $("#DivTransRateAmtRequest > div").height() - 50;
    AUIGrid.resize(GridTRAID, $("#DivTransRateAmtRequest > div").width(), intHeight);
}

//기본 레이아웃 세팅
function fnCreateGridTRALayout(strGID, strRowIdField) {

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
    objGridProps.editableOnFixedCell = true; // 고정 칼럼, 행에 있는 셀도 수정 가능 여부(기본값:false)
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.copyDisplayValue = true; //그리드의 셀 또는 행을 복사(Ctrl+C) 할 때 원래 데이터 값을 복사할 지 그리드에 의해 포매팅된 값을 복사할 지 여부

    var objResultLayout = fnGetTRADefaultColumnLayout();

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

function fnGetTRADefaultColumnLayout() {
    var objColumnLayout = [
        
        {
            dataField: "ReqStatusM",
            headerText: "요청상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },{
            dataField: "ReqSupplyAmt",
            headerText: "요청공급가액",
            editable: true,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "ReqTaxAmt",
            headerText: "요청부가세",
            editable: true,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "ReqReason",
            headerText: "요청사유",
            editable: true,
            width: 100,
            viewstatus: false
        },
        {
            dataField: "ReqStatusInfo",
            headerText: "요청정보",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BtnRegRequest",
            headerText: "요청",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                onClick: function (event) {
                    fnRegAmtRequest(event.item);
                    return false;
                }
            },
            viewstatus: true
        },
        {
            dataField: "PayTypeM",
            headerText: "비용구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ItemCodeM",
            headerText: "비용항목",
            editable: false,
            width: 100,
            filter: { showIcon: true }
        },
        {
            dataField: "UnitAmt",
            headerText: "자동운임금액",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (item.PayTypeM == "매입" && item.CarFixedFlag == "Y") {
                    return AUIGrid.formatNumber(item.FixedUnitAmt, "#,##0");
                } else {
                    return AUIGrid.formatNumber(value, "#,##0");
                }
            }
        },
        {
            dataField: "SupplyAmt",
            headerText: "공급가액",
            editable: false,
            width: 100,
            viewstatus: false,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "TaxAmt",
            headerText: "부가세",
            editable: false,
            width: 100,
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
            dataField: "OrderNo",
            headerText: "OrderNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PaySeqNo",
            headerText: "PaySeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ReqSeqNo",
            headerText: "ReqSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ReqStatus",
            headerText: "ReqStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "PayType",
            headerText: "PayType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CarFixedFlag",
            headerText: "CarFixedFlag",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "FixedUnitAmt",
            headerText: "FixedUnitAmt",
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
//그리드 에디팅 이벤트 핸들러
function fnGridTRACellEditingHandler(event) {
    if (event.type === "cellEditBegin") {
        if (event.item.ReqStatus === 1) {
            fnDefaultAlert("현재 처리되지 않은 수정요청 정보가 있습니다. ", "warning");
            return false;
        }
    } else if (event.type === "cellEditEndBefore") {
        var retStr = event.value;

        retStr = retStr.toString().replace(/\t/gi, "");
        retStr = retStr.toString().replace(/\n/gi, "");

        if (event.dataField === "ReqSupplyAmt") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9.,]/gi, "");

            var tax = Math.floor((parseFloat(retStr) / 10));

            if (isNaN(tax)) {
                tax = 0;
            }

            AUIGrid.updateRow(event.pid, {
                ReqTaxAmt: tax
            }, event.rowIndex);
        }

        if (event.dataField === "ReqTaxAmt") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9.,]/gi, "");
        }

        return retStr;
    } else if (event.type === "cellEditEnd") {
        if (event.dataField === "ReqSupplyAmt" || event.dataField === "ReqTaxAmt") {
            AUIGrid.updateRow(event.pid, {
                ReqReason: ""
            }, event.rowIndex);
        }
    }
}
//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridTRAData(strGID) {

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnGridTRASuccResult";

    var objParam = {
        CallType: "AmtRequestOrderList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridTRASuccResult(objRes) {
    if (objRes) {
        AUIGrid.setGridData(GridTRAID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridTRAID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridTRAID);
        return false;
    }
}


function fnRegAmtRequest(objItem) {
    if (objItem.ReqStatus === 1) { //취소
        if (objItem.ReqSeqNo === "0" || typeof objItem.ReqSeqNo === "undefined") {
            fnDefaultAlert("등록된 수정요청 정보가 없습니다.", "warning");
            return false;
        }

        fnDefaultConfirm("수정요청을 취소 하시겠습니까?", "fnCnlAmtRequestProc", objItem);
        return false;
    } else { //요청

        if (objItem.ReqReason === "" || typeof objItem.ReqReason === "undefined") {
            fnDefaultAlert("수정요청 사유를 입력해주세요.", "warning");
            AUIGrid.setSelectionByIndex(GridTRAID, AUIGrid.getRowIndexesByValue(GridTRAID, "SeqNo", objItem.SeqNo)[0], 3);
            return false;
        }

        fnDefaultConfirm("수정요청을 진행 하시겠습니까?", "fnRegAmtRequestProc", objItem);
        return false;
    }
}

//등록
function fnRegAmtRequestProc(objItem) {
    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnRegAmtRequestSuccResult";
    var strFailCallBackFunc = "fnRegAmtRequestFailResult";
    var objParam = {
        CallType: "AmtRequestInsert",
        CenterCode: objItem.CenterCode,
        OrderNo: objItem.OrderNo,
        ReqKind: objItem.PayType,
        PaySeqNo: objItem.PaySeqNo,
        ReqSupplyAmt: objItem.ReqSupplyAmt,
        ReqTaxAmt: objItem.ReqTaxAmt,
        ReqReason: objItem.ReqReason
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnRegAmtRequestSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("수정요청 등록이 완료되었습니다.", "info");
            fnCallGridTRAData(GridTRAID);
            return false;
        } else {
            fnRegAmtRequestFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegAmtRequestFailResult();
        return false;
    }
}

function fnRegAmtRequestFailResult(msg) {
    var alertMsg = "비용 수정요청 등록에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.";
    if (typeof msg != "undefined" && msg !== "") {
        alertMsg += " (" + msg + ")";
    }
    fnDefaultAlert(alertMsg, "warning");
    return false;
}

//취소
function fnCnlAmtRequestProc(objItem) {
    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnCnlAmtRequestSuccResult";
    var strFailCallBackFunc = "fnCnlAmtRequestFailResult";
    var objParam = {
        CallType: "AmtRequestCancel",
        CenterCode: objItem.CenterCode,
        OrderNo: objItem.OrderNo,
        SeqNo: objItem.ReqSeqNo
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnCnlAmtRequestSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("수정요청 취소가 완료되었습니다.", "info");
            fnCallGridTRAData(GridTRAID);
            return false;
        } else {
            fnRegAmtRequestFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnRegAmtRequestFailResult();
        return false;
    }
}

function fnCnlAmtRequestFailResult(msg) {
    var alertMsg = "비용 수정요청 취소에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.";
    if (typeof msg != "undefined" && msg !== "") {
        alertMsg += " (" + msg + ")";
    }
    fnDefaultAlert(alertMsg, "warning");
    return false;
}

function fnOpenTransRateAmtRequest() {
    if (!$("#ApplySeqNo").val() || $("#ApplySeqNo").val() == "0") {
        return false;
    }

    if (!$("#CenterCode").val() || !$("#OrderNo").val()) {
        return false;
    }

    fnCallGridTRAData(GridTRAID);
    $("#DivTransRateAmtRequest").show();
    return false;
}

function fnCloseTransRateAmtRequest() {
    AUIGrid.setGridData(GridTRAID, []);
    //비용 목록 조회
    fnCallPayGridData(GridPayID);
    $("#DivTransRateAmtRequest").hide();
    return false;
}
/*********************************************/

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

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
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

//상하차 정보 변경
function fnChangePlace() {
    if ($("#ContractType").val() === "3") {
        fnDefaultAlert("수탁 오더는 수정하실 수 없습니다.");
        return false;
    }

    var strPickupPlace = $("#PickupPlace").val();
    var strPickupPlaceChargeName = $("#PickupPlaceChargeName").val();
    var strPickupPlaceChargePosition = $("#PickupPlaceChargePosition").val();
    var strPickupPlaceChargeTelExtNo = $("#PickupPlaceChargeTelExtNo").val();
    var strPickupPlaceChargeTelNo = $("#PickupPlaceChargeTelNo").val();
    var strPickupPlaceChargeCell = $("#PickupPlaceChargeCell").val();
    var strPickupWay = $("#PickupWay").val();
    var strPickupPlaceFullAddr = $("#PickupPlaceFullAddr").val();
    var strPickupPlacePost = $("#PickupPlacePost").val();
    var strPickupPlaceAddr = $("#PickupPlaceAddr").val();
    var strPickupPlaceAddrDtl = $("#PickupPlaceAddrDtl").val();
    var strPickupPlaceLocalCode = $("#PickupPlaceLocalCode").val();
    var strPickupPlaceLocalName = $("#PickupPlaceLocalName").val();
    var strPickupPlaceNote = $("#PickupPlaceNote").val();

    $("#PickupPlace").val($("#GetPlace").val());
    $("#PickupPlaceChargeName").val($("#GetPlaceChargeName").val());
    $("#PickupPlaceChargePosition").val($("#GetPlaceChargePosition").val());
    $("#PickupPlaceChargeTelExtNo").val($("#GetPlaceChargeTelExtNo").val());
    $("#PickupPlaceChargeTelNo").val($("#GetPlaceChargeTelNo").val());
    $("#PickupPlaceChargeCell").val($("#GetPlaceChargeCell").val());
    $("#PickupWay").val($("#GetWay").val());
    $("#PickupPlaceFullAddr").val($("#GetPlaceFullAddr").val());
    $("#PickupPlacePost").val($("#GetPlacePost").val());
    $("#PickupPlaceAddr").val($("#GetPlaceAddr").val());
    $("#PickupPlaceAddrDtl").val($("#GetPlaceAddrDtl").val());
    $("#PickupPlaceLocalCode").val($("#GetPlaceLocalCode").val());
    $("#PickupPlaceLocalName").val($("#GetPlaceLocalName").val());
    $("#PickupPlaceNote").val($("#GetPlaceNote").val());

    $("#GetPlace").val(strPickupPlace);
    $("#GetPlaceChargeName").val(strPickupPlaceChargeName);
    $("#GetPlaceChargePosition").val(strPickupPlaceChargePosition);
    $("#GetPlaceChargeTelExtNo").val(strPickupPlaceChargeTelExtNo);
    $("#GetPlaceChargeTelNo").val(strPickupPlaceChargeTelNo);
    $("#GetPlaceChargeCell").val(strPickupPlaceChargeCell);
    $("#GetWay").val(strPickupWay);
    $("#GetPlaceFullAddr").val(strPickupPlaceFullAddr);
    $("#GetPlacePost").val(strPickupPlacePost);
    $("#GetPlaceAddr").val(strPickupPlaceAddr);
    $("#GetPlaceAddrDtl").val(strPickupPlaceAddrDtl);
    $("#GetPlaceLocalCode").val(strPickupPlaceLocalCode);
    $("#GetPlaceLocalName").val(strPickupPlaceLocalName);
    $("#GetPlaceNote").val(strPickupPlaceNote);
}

//Edi 오더 데이터 세팅
function fnCallEdiDetail() {

    var strHandlerURL = "/TMS/Inout/Proc/InoutHandler.ashx";
    var strCallBackFunc = "fnEdiDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "EdiOrderInfo",
        WoSeqNo: $("#WoSeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnEdiDetailSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        var item = objRes[0];

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

    } else {
        fnCallDetailFailResult();
    }
}