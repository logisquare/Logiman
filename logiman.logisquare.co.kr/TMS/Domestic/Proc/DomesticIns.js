var strCenterCode = "";
var strGoodsDispatchType = "";
var strPayType = "";
var strSaleClosingFlag = "N";
var strPurchaseClosingFlag = "N";

$(document).ready(function () {

    if ($("#HidDisplayMode").val() === "Y") {
        if (parent) {
            parent.fnReloadPageNotice($("#HidErrMsg").val());
        }
        else if (opener) {
            opener.fnReloadPageNotice($("#HidErrMsg").val());
        }
    }

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

    /**
      * 버튼 이벤트
      */
    //오더등록
    $("#BtnRegOrder").on("click", function (e) {
        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 수정하실 수 없습니다.");
            return false;
        }
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

        document.location.replace("/TMS/Domestic/DomesticIns?OrderNo=" + $("#OrderNo").val() + "&CopyFlag=Y");
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

        window.open("/TMS/Common/OrderCopy?OrderType=1&CenterCode=" + $("#CenterCode").val() + "&OrderNos=" + $("#OrderNo").val(), "오더대량복사", "width=1140, height=850, scrollbars=Yes");
        return false;
    });

    //새로등록
    $("#BtnGoWrite").on("click", function (e) {
        document.location.replace("/TMS/Domestic/DomesticIns");
        return false;
    });

    //오더취소
    $("#BtnCancelOrder").on("click", function (e) {
        if (!$("#OrderNo").val()) {
            return false;
        }

        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 취소하실 수 없습니다.");
            return false;
        }

        fnCnlOrder();
        return false;
    });

    //오더 이관
    $("#BtnRegTrans").on("click", function (e) {
        fnRegTrans();
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
    
    //업체정보 다시 입력 
    $("#BtnResetClient").on("click", function (e) {
        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 수정하실 수 없습니다.");
            return false;
        }

        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 수정하실 수 없습니다.");
            return false;
        }
        $(".TdClient input").val("");
        $(".TdClient select").val("");
        $("#SpanOrderClientMisuAmt").text("");
        $("#BtnOrderClientMisuAmt").hide();
        $("#SpanPayClientMisuAmt").text("");
        $("#BtnPayClientMisuAmt").hide();
        return;
    });

    //상차지 다시 입력 
    $("#BtnResetPickupPlace").on("click", function (e) {
        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 수정하실 수 없습니다.");
            return false;
        }

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
        if ($("#TransType").val() === "3") {
            fnDefaultAlert("이관받은 오더는 수정하실 수 없습니다.");
            return false;
        }

        if ($("#ContractType").val() === "3") {
            fnDefaultAlert("수탁 오더는 취소하실 수 없습니다.");
            return false;
        }
        $(".TdGet input").val("");
        $(".TdGet select").val("");
        $("#GetYMD").datepicker("setDate", GetDateToday("-"));
        return;
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

        if (!($("#CargopassOrderNo").val() === "0" || $("#CargopassOrderNo").val() === "")) {
            fnDefaultAlert("카고패스에 등록된 오더입니다.");
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

        $(".TrDispatch input").val("");
        $(".TrDispatch select option:nth-child(1)").prop("selected", true);
        $(".TrDispatch span").text("");
        $(".TrDispatch span#SpanDispatchTypeM").text("직송");
        return;
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
        fnOpenTransRateAmtRequest();
        return false;
    });

    //고정/용차
    $("#BtnCarFixedFlagHelp").on("click", function () {
        fnDefaultAlert("고정/용차 선택은 요율표 검색을 위한 지표로 차량구분 값과는 별개입니다.");
        return false;
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


    //관리차량 - 열기
    $("#BtnOpenCarManage").on("click", function (e) {
        if (!($("#CargopassOrderNo").val() === "0" || $("#CargopassOrderNo").val() === "")) {
            fnDefaultAlert("카고패스에 등록된 오더입니다.");
            return false;
        }

        fnOpenCarManage();
        return false;
    });

    //카고패스 - 연동
    $("#BtnRegCargopass").on("click", function (e) {
        fnRegCargopass();        
        return false;
    });

    //카고패스 - 연동상세
    $("#BtnDetailCargopass").on("click", function (e) {
        fnDetailCargopass();
        return false;
    });

    /**
     * 폼 이벤트
     */

    //결제정보(빠른입금 일시 제한 20250903)
    $("#QuickType").on("change", function () {
        if ($(this).val() != "1" && fnGetToday() <= "20251214") {
            fnDefaultAlert("[빠른입금 서비스 점검 안내]<br/>12월 14일까지 빠른입금 마감 메뉴 이용이 제한됩니다.</br>이용에 불편을 드려 죄송합니다.", "info");
            $(this).val("1");
            return false;
        }
    });

    //회원사
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

            if (strGoodsDispatchType === "3" && $(".DispatchType3 tr").length > 0) {
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

    $("#PickupPlaceSearch").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#BtnSearchAddrPickupPlace").click();
            }
        });

    $("#GetHM").on("blur",
        function () {
            //자동운임 변경 체크
            fnChangeRateChk();
        });

    $("#GetPlaceSearch").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#BtnSearchAddrGetPlace").click();
            }
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
    //기본 설정 값
    fnSetPay();
    fnSetInitData();

});

//기본정보 세팅
function fnSetInitData() {
    $("#GoodsDispatchType option:first-child").prop("disabled", true);

    if ($("#HidMode").val() === "Update" || ($("#HidMode").val() === "Insert" && $("#CopyFlag").val() === "Y")) {
        fnCallOrderDetail();
    }

    //상단고정을 위한 margin
    if ($("#HidMode").val() === "Update") {
        $("table.order_table").css("margin-top", "106px");
    } else {
        $("table.order_table").css("margin-top", "77px");
    }

    //화주 자동완성
    if ($("#ConsignorName").length > 0) {
        fnSetAutocomplete({
            formId: "ConsignorName",
            width: 800,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ConsignorMapList",
                    ConsignorName: request.term,
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

                    if (ui.item.etc.OrderClientCode != 0) {
                        $("#OrderClientCode").val(ui.item.etc.OrderClientCode);
                        $("#OrderClientName").val(ui.item.etc.OrderClientName);
                        if (ui.item.etc.OrderClientMisuFlag === "Y") {
                            $("#SpanOrderClientMisuAmt").text("미수금액: " + fnMoneyComma(ui.item.etc.OrderClientMisuAmt) + "원 / " + ui.item.etc.OrderClientNoMatchingCnt + "건");
                            $("#BtnOrderClientMisuAmt").show();
                        } else {
                            $("#SpanOrderClientMisuAmt").text("");
                            $("#BtnOrderClientMisuAmt").hide();
                        }
                    }

                    if (ui.item.etc.PayClientCode != 0) {
                        $("#PayClientCode").val(ui.item.etc.PayClientCode);
                        $("#PayClientName").val(ui.item.etc.PayClientName);
                        if (ui.item.etc.PayClientMisuFlag === "Y") {
                            $("#SpanPayClientMisuAmt").text("미수금액: " + fnMoneyComma(ui.item.etc.PayClientMisuAmt) + "원 / " + ui.item.etc.PayClientNoMatchingCnt + "건");
                            $("#BtnPayClientMisuAmt").show();
                        } else {
                            $("#SpanPayClientMisuAmt").text("");
                            $("#BtnPayClientMisuAmt").hide();
                        }
                    }

                    if (ui.item.etc.PickupPlaceSeqNo != 0) {
                        $("#PickupPlaceSeqNo").val(ui.item.etc.PickupPlaceSeqNo);
                        $("#PickupPlace").val(ui.item.etc.PickupPlaceName);
                        $("#PickupPlacePost").val(ui.item.etc.PickupPlacePost);
                        $("#PickupPlaceAddr").val(ui.item.etc.PickupPlaceAddr);
                        $("#PickupPlaceAddrDtl").val(ui.item.etc.PickupPlaceAddrDtl);
                        $("#PickupPlaceFullAddr").val(ui.item.etc.PickupFullAddr);
                        $("#PickupPlaceLocalCode").val(ui.item.etc.PickupLocalCode);
                        $("#PickupPlaceLocalName").val(ui.item.etc.PickupLocalName);
                        $("#PickupPlaceNote").val(ui.item.etc.PickupPlaceRemark);
                    }

                    if (ui.item.etc.GetPlaceSeqNo != 0) {
                        $("#GetPlaceSeqNo").val(ui.item.etc.GetPlaceSeqNo);
                        $("#GetPlace").val(ui.item.etc.GetPlaceName);
                        $("#GetPlacePost").val(ui.item.etc.GetPlacePost);
                        $("#GetPlaceAddr").val(ui.item.etc.GetPlaceAddr);
                        $("#GetPlaceAddrDtl").val(ui.item.etc.GetPlaceAddrDtl);
                        $("#GetPlaceFullAddr").val(ui.item.etc.GetFullAddr);
                        $("#GetPlaceLocalCode").val(ui.item.etc.GetLocalCode);
                        $("#GetPlaceLocalName").val(ui.item.etc.GetLocalName);
                        $("#GetPlaceNote").val(ui.item.etc.GetPlaceRemark);
                    }
                    fnSetFocus();
                },
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("ConsignorNClient", ul, item);
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

    //발주처 자동완성
    if ($("#OrderClientName").length > 0) {
        fnSetAutocomplete({
            formId: "OrderClientName",
            width: 700,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
                            if (ui.item.etc.MisuFlag === "Y") {
                                $("#SpanPayClientMisuAmt").text("미수금액: " + fnMoneyComma(ui.item.etc.MisuAmt) + "원 / " + ui.item.etc.NoMatchingCnt + "건");
                                $("#BtnPayClientMisuAmt").show();
                            } else {
                                $("#SpanPayClientMisuAmt").text("");
                                $("#BtnPayClientMisuAmt").hide();
                            }
                        }
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
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
                onClose: () => {
                    //자동운임 변경 체크
                    fnChangeRateChk();
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
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
                        $("#PayClientName").val("");
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
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientChargeList",
                    ChargeName: request.term,
                    ChargePayFlag: "Y",
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

    //상차지 자동완성
    if ($("#PickupPlace").length > 0) {
        fnSetAutocomplete({
            formId: "PickupPlace",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
                    $("#PickupPlaceNote").val(ui.item.etc.PlaceRemark1);
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
                        $("#PickupPlaceLocalCode").val("");
                        $("#PickupPlaceLocalName").val("");
                        $("#PickupPlaceNote").val("");
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
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
                    $("#PickupPlaceNote").val(ui.item.etc.PlaceRemark1);
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
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
                    $("#GetPlaceNote").val(ui.item.etc.PlaceRemark1);
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
                        $("#GetPlace").val("");
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
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
                    $("#GetPlaceNote").val(ui.item.etc.PlaceRemark1);
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

    //차량번호(배차) 검색
    if ($("#RefCarNo").length > 0) {
        fnSetAutocomplete({
            formId: "RefCarNo",
            width: 800,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
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

                    if (request.term.length < 4) {
                        fnDefaultAlert("검색어를 4자 이상 입력하세요.", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.CarNo,
                getValue: (item) => item.CarNo,
                onSelect: (event, ui) => {
                    $("#RefSeqNo").val(ui.item.etc.RefSeqNo);
                    $("#RefCarNo").val(ui.item.etc.CarNo);
                    $("#DispatchInfo").val(ui.item.etc.DispatchInfo);
                    $("#SpanDispatchTypeM").text("직송");
                    $("#SpanDispatchInfo").text(ui.item.etc.DispatchInfo);
                    $("#CarManageFlag").val("");
                    $("#CarDispatchType").val("");
                    $("#AreaDistance").val("");
                    $("#OrgCenterCode").val("");
                    $("#OrgOrderNo").val("");
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("CarDispatchRef", ul, item);
                },
                onBlur: () => {
                    if (!$("#RefCarNo").val()) {
                        $("#BtnResetDispatch").click();
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
                    return "/TMS/Domestic/Proc/DomesticHandler.ashx";
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

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnOrderDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "DomesticList",
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

        $(".DispatchType2").hide();
        $(".DispatchType3").hide();
        
        if (item.GoodsDispatchType === 2) {
            if ($("#CopyFlag").val() === "Y") {
                $("#DispatchSeqNo").val("");
                $("#SpanDispatchInfo").text("");
                $("#RefSeqNo").val("");
            } else {
                $("#DispatchSeqNo").val(item.DispatchSeqNo1);
                $("#SpanDispatchInfo").text(item.DispatchCarInfo1);
                $("#RefSeqNo").val(item.DispatchRefSeqNo1);
            }
            $(".DispatchType2").show();

        } else {
            $("#DispatchSeqNo").val("");
            $("#SpanDispatchInfo").text("");
            $("#RefSeqNo").val("");
            $(".DispatchType3").show();
        }

        if ($("#CopyFlag").val() !== "Y") {
            if (item.GoodsDispatchType === 2) {
                if (item.TransType !== 2 && item.TransType !== 3) {
                    $("#BtnRegTrans").show();
                } else {
                    $("#SpanTrans").text(item.TransInfo);
                    $(".TrTrans").show();
                    $(".NotAllowedTrans").show();
                    $("#GoodsDispatchType option:not(:selected)").prop("disabled", true);

                    if (item.TransType == 2) {
                        $(".NotAllowedTrans").hide();
                        $(".TrTransPay").show();
                        //비용 목록 조회
                        fnCallTransPayGridData(GridTransPayID);
                    }
                }

                if (item.ContractType === 2) {
                    if (item.ContractStatus === 2) {
                        $("#SpanContract").text(item.ContractInfo);
                        $(".NotAllowedContract").show();
                        $("#GoodsDispatchType option:not(:selected)").prop("disabled", true);
                    } else {
                        $("#SpanContract").text("위탁취소 : " + item.ContractInfo);
                    }
                    $(".TrContract").show();
                } else if (item.ContractType === 3) {
                    $("#SpanContract").text(item.ContractInfo);
                    $(".TrContract").show();
                    $(".NotAllowedContractTarget").show();
                    $("#GoodsDispatchType option:not(:selected)").prop("disabled", true);
                }
            }
        }

        $("#RefCarNo").removeAttr("readonly");

        if (!($("#CargopassOrderNo").val() === "0" || $("#CargopassOrderNo").val() === "")) {
            $("#BtnRegCargopass").hide();
            $("#BtnDetailCargopass").show();
            $("#RefCarNo").attr("readonly", "readonly");
        }

        if ($("#CopyFlag").val() === "Y") {
            $("#HidMode").val("Insert");
            $("#CopyFlag").val("N");
            $("#CnlFlag").val("N");
            $("#OrderNo").val("");
            $("#NetworkNo").val("");
            $("#CargopassOrderNo").val("");
            $("#TransType").val("");
            $("#ContractType").val("");
            $("#ContractStatus").val("");
            $("#DispatchRefSeqNo1").val("");
            $("#DivOrderInfo").remove();
            $("#DivButtons").remove();
            $("#PickupYMD").datepicker("setDate", GetDateToday("-"));
            $("#GetYMD").datepicker("setDate", GetDateToday("-"));
            $(".TrGoods input").val("");
            $(".TrGoods select").val("");
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
            $(".BtnCargopass").hide();
            $("#RefCarNo").removeAttr("readonly");
            $("#QuickType").val("1");
            $("#InsureExceptKind").val("1");            
            return false;
        }

        if ($("#CnlFlag").val() === "Y") {
            $("#BtnRegOrder").hide();
            $("#BtnCancelOrder").hide();
            $("#BtnRegTrans").hide();
            $(".BtnCargopass").hide();
        }

        if (item.GoodsDispatchType === 1 && item.OrderRegType === 5) {
            fnSetGoodsDispatchType("2");
        }

        $("#SamePlaceCount").val($("#SamePlaceCount").val() === "0" ? "" : $("#SamePlaceCount").val());
        $("#NonSamePlaceCount").val($("#NonSamePlaceCount").val() === "0" ? "" : $("#NonSamePlaceCount").val());

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
    if ($("#ContractType").val() !== "3" && $("#GoodsDispatchType").val() === "2") {
        if (!ClosingPay) {
            if (AutoPay) {
                if (fnGetRateConditionChange()) {
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
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
        InsureExceptKind: $("#InsureExceptKind").val(),
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
        var strHandlerURL = "/TMS/Domestic/Proc/DomesticFileHandler.ashx";
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
        fnInsTransPay();
        return false;
    }
}

function fnInsPayProc() {
    AUIGrid.showAjaxLoader(GridPayID);
    if (PayProcCnt >= PayCnt) {
        AUIGrid.removeAjaxLoader(GridPayID);
        fnInsTransPay();
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
        var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
    document.location.replace("/TMS/Domestic/DomesticIns?OrderNo=" + $("#OrderNo").val());
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

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCnlOrderSuccResult";
    var strFailCallBackFunc = "fnCnlOrderFailResult";
    var objParam = {
        CallType: "DomesticOneCancel",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
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

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
var GridPayID = "#DomesticPayListGrid";

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
        if (item.ClosingFlag == "Y" || item.SendStatus !== 1) { //마감, 송금
            return "aui-grid-closing-y-row-style";
        } else if (item.BillStatus === 2 || item.BillStatus === 3) { //계산서발행
            return "aui-grid-carryover-y-row-style";
        }
        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultPayColumnLayout()");
    var objOriLayout = fnGetDefaultPayColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

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
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallPayGridData(strGID) {

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
            return;
        }
    }

    if ($("#PayType").val() === "2") { //매입
        if ($("#ClientCode").val() && $("#ClientCode").val() !== "0") {
            strClientInfo = $("#ClientInfo").val();
        } else if ($("#GoodsDispatchType").val() === "2") {

            if (!($("#ContractType").val() == "2" && $("#ContractStatus").val() == "2")) { //위탁 아닐때 추가 처리
                if (!($("#SpanDispatchInfo").text() !== "" && $("#RefSeqNo").val() && $("#RefSeqNo").val() !== "0" && strClientInfo === "")) {
                    fnDefaultAlertFocus("업체정보(or 배차정보)를 입력하세요.", "ClientName", "warning");
                    return false;
                }
            }

            $("#ClientCode").val("");
            $("#ClientName").val("");
            strDispatchInfo = $("#SpanDispatchInfo").text();
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
                if (!($("#SpanDispatchInfo").text() !== "" && $("#RefSeqNo").val() && $("#RefSeqNo").val() !== "0" && strClientInfo === "")) {
                    fnDefaultAlertFocus("업체정보(or 배차정보)를 입력하세요.", "ClientName", "warning");
                    return false;
                }
            }

            $("#ClientCode").val("");
            $("#ClientName").val("");
            strDispatchInfo = $("#SpanDispatchInfo").text();
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
    objItem.RefSeqNo = strRefSeqNo
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
/*********************************************/

/*********************************************/
/*                파일 첨부                  */
/*********************************************/
$(document).ready(function () {
    $("#FileUpload").fileupload({
        dataType: "json",
        autoUpload: false,
        type: "POST",
        url: "/TMS/Domestic/Proc/DomesticFileHandler.ashx?CallType=OrderFileUpload",
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

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticFileHandler.ashx";
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

    $form.attr('action', '/TMS/Domestic/Proc/DomesticFileHandler.ashx');
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
    
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticFileHandler.ashx";
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
        } else {
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
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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


// 배차 목록
function fnCallDispatchData() {
    if (!$("#OrderNo").val() || !$("#CenterCode").val() || !$("#GoodsSeqNo").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallDispatchSuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "DomesticDispatchCarList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        GoodsSeqNo: $("#GoodsSeqNo").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strCallBackFailFunc, "", false);
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
            if ($("#GoodsDispatchType").val() === "2") {
                var ContractCenter = "";
                ContractCenter = objRes[0].data.list[0].ContractCenterName;
                if (objRes[0].data.list[0].ContractCenterCorpNo !== "") {
                    ContractCenter += " (" + objRes[0].data.list[0].ContractCenterCorpNo + ")";
                }
                $("#RefCarNo").val(objRes[0].data.list[0].CarNo);
                $("#SpanPickupDT").text(objRes[0].data.list[0].PickupDT);
                $("#SpanGetDT").text(objRes[0].data.list[0].GetDT);
                $("#SpanContractCenter").text(ContractCenter);
            } else if ($("#GoodsDispatchType").val() === "3") {

                $("#TBodyDispatch3 tr").remove();
                var html = "";
                if (objRes[0].data.RecordCnt > 0) {
                    $.each(objRes[0].data.list, function (index, item) {
                        var ContractCenter = "";
                        ContractCenter = item.ContractCenterName;
                        if (item.ContractCenterCorpNo !== "") {
                            ContractCenter += " (" + item.ContractCenterCorpNo + ")";
                        }
                        html += "<tr class=\"center\">\n";
                        html += "\t<td>" + item.DispatchTypeM + "</td>\n";
                        html += "\t<td>" + item.CarNo + "</td>\n";
                        html += "\t<td>" + item.DispatchCarInfo + "</td>\n";
                        html += "\t<td>" + item.PickupDT + "</td>\n";
                        html += "\t<td>" + item.GetDT + "</td>\n";
                        html += "\t<td>" + ContractCenter + "</td>\n";
                        html += "\t<td>" + item.QuickTypeM + "</td>\n";
                        html += "</tr>\n";
                    });
                }
                $("#TBodyDispatch3").html(html);
            }
        }
    } else {
        fnCallDetailFailResult();
    }
}

/************************************************/
// 자동운임
/************************************************/
//오더 자동운임 조회
function fnCallTransRateData() {
    if (!$("#OrderNo").val() || !$("#CenterCode").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
        $("#SpanTransRateInfo").html("");

        $("#LayoverSaleUnitAmt").val("");
        $("#LayoverFixedPurchaseUnitAmt").val("");
        $("#LayoverPurchaseUnitAmt").val("");
        $("#SpanLayoverTransRateInfo").html("");

        $("#OilSaleUnitAmt").val("");
        $("#OilFixedPurchaseUnitAmt").val("");
        $("#OilPurchaseUnitAmt").val("");
        $("#SpanOilTransRateInfo").html("");
        
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
            } else if (item.RateInfoKind === 4) { //경유비
                $("#LayoverSaleUnitAmt").val(item.SaleUnitAmt);
                $("#LayoverSaleUnitAmt").val(fnMoneyComma($("#LayoverSaleUnitAmt").val()));
                $("#LayoverFixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                $("#LayoverFixedPurchaseUnitAmt").val(fnMoneyComma($("#LayoverFixedPurchaseUnitAmt").val()));
                $("#LayoverPurchaseUnitAmt").val(item.PurchaseUnitAmt);
                $("#LayoverPurchaseUnitAmt").val(fnMoneyComma($("#LayoverPurchaseUnitAmt").val()));
                $("#SpanLayoverTransRateInfo").html(item.RateInfo);
            } else if (item.RateInfoKind === 5) { //유가연동
                $("#OilSaleUnitAmt").val(item.SaleUnitAmt);
                $("#OilSaleUnitAmt").val(fnMoneyComma($("#OilSaleUnitAmt").val()));
                $("#OilFixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                $("#OilFixedPurchaseUnitAmt").val(fnMoneyComma($("#OilFixedPurchaseUnitAmt").val()));
                $("#OilPurchaseUnitAmt").val(item.PurchaseUnitAmt);
                $("#OilPurchaseUnitAmt").val(fnMoneyComma($("#OilPurchaseUnitAmt").val()));
                $("#SpanOilTransRateInfo").html(item.RateInfo);
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

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
        $("#SpanTransRateInfo").html("");

        $("#LayoverSaleUnitAmt").val("");
        $("#LayoverFixedPurchaseUnitAmt").val("");
        $("#LayoverPurchaseUnitAmt").val("");
        $("#SpanLayoverTransRateInfo").html("");

        $("#OilSaleUnitAmt").val("");
        $("#OilFixedPurchaseUnitAmt").val("");
        $("#OilPurchaseUnitAmt").val("");
        $("#SpanOilTransRateInfo").html("");

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
                    //이관오더가 아닐 때 삭제 처리
                    if (item.PayType == 1 && (item.ItemCode == "OP001" || item.ItemCode == "OP088" || item.ItemCode == "OP089") && $("#TransType").val() !== "2") {
                        arrRemoveIds.push(item.PaySeqNo);
                    }

                    if (item.PayType == 2 && (item.ItemCode == "OP001" || item.ItemCode == "OP088" || item.ItemCode == "OP089")) {
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
            } else if (item.RateInfoKind === 4) { //경유비
                $("#LayoverSaleUnitAmt").val(item.SaleUnitAmt);
                $("#LayoverSaleUnitAmt").val(fnMoneyComma($("#LayoverSaleUnitAmt").val()));
                $("#LayoverFixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                $("#LayoverFixedPurchaseUnitAmt").val(fnMoneyComma($("#LayoverFixedPurchaseUnitAmt").val()));
                $("#LayoverPurchaseUnitAmt").val(item.PurchaseUnitAmt);
                $("#LayoverPurchaseUnitAmt").val(fnMoneyComma($("#LayoverPurchaseUnitAmt").val()));
                $("#SpanLayoverTransRateInfo").html(item.RateInfo);
                fnSetTransRate(item);
            } else if (item.RateInfoKind === 5) { //유가연동
                $("#OilSaleUnitAmt").val(item.SaleUnitAmt);
                $("#OilSaleUnitAmt").val(fnMoneyComma($("#OilSaleUnitAmt").val()));
                $("#OilFixedPurchaseUnitAmt").val(item.FixedPurchaseUnitAmt);
                $("#OilFixedPurchaseUnitAmt").val(fnMoneyComma($("#OilFixedPurchaseUnitAmt").val()));
                $("#OilPurchaseUnitAmt").val(item.PurchaseUnitAmt);
                $("#OilPurchaseUnitAmt").val(fnMoneyComma($("#OilPurchaseUnitAmt").val()));
                $("#SpanOilTransRateInfo").html(item.RateInfo);
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
/*********************************************/

/*********************************************/
//오더 이관 처리
//오더 이관 
function fnRegTrans() {

    if ($("#HidMode").val() !== "Update") {
        fnDefaultAlert("오더를 등록하고 이용하세요.", "warning");
        return false;
    }

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("취소된 오더입니다.", "warning");
        return false;
    }

    if ($("#GoodsDispatchType").val() !== "2") {
        fnDefaultAlert("직송오더만 이관이 가능합니다.", "warning");
        return false;
    }

    if ($("#TransType").val() === "2" || $("#TransType").val() === "3") {
        fnDefaultAlert("이미 이관되었거나 이관받은 오더입니다.", "warning");
        return false;
    }

    if ($("#ContractType").val() === "3") {
        fnDefaultAlert("수탁 오더는 이관할 수 없습니다.", "warning");
        return false;
    }

    var cnt = 0;
    if (AUIGrid.getGridData(GridPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridPayID),
            function (index, item) {
                if (!AUIGrid.isRemovedById(GridPayID, item.PaySeqNo)) {
                    if (item.PayType == "1" && item.SeqNo != "" && item.SeqNo != "0") {
                        cnt++;
                    }
                }
            });
    }

    if (cnt <= 0) {
        fnDefaultAlert("매출 등록 후 이관이 가능합니다.", "warning");
        return;
    }

    $("#DivTrans").show();
    fnTransHeadCenterInit();
}

function fnTransHeadCenterInit() {
    $("#PopTargetCenterCode option").remove();
    $("#PopTargetCenterCode").append("<option value=''>이관운송사</option>");

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnTransCenterSuccResult";

    var objParam = {
        CallType: "HeadCenterList",
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnTransCenterSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                return false;
            }
        }

        $.each(objRes[0].List, function (index, item) {
            $("#PopTargetCenterCode").append("<option value=\"" + item.CenterCode + "\">" + item.CenterName + "</option>");
        });
    }
}

function fnInsTrans() {

    if ($("#PopTargetCenterCode option").length === 1) {
        fnDefaultAlert("이관할 수 있는 운송사가 없습니다.", "warning");
        return false;
    }

    if (!$("#PopTargetCenterCode").val()) {
        fnDefaultAlertFocus("이관운송사를 선택하세요.", "PopTargetCenterCode", "warning");
        return false;
    }

    fnDefaultConfirm("오더를 " + $("#PopTargetCenterCode option:selected").text() + "에 이관처리 하시겠습니까?", "fnInsTransProc", "", "", "");
}

function fnInsTransProc() {

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnInsTransSuccResult";
    var strFailCallBackFunc = "fnInsTransFailResult";
    var objParam = {
        CallType: "DomesticTransInsert",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        TargetCenterCode: $("#PopTargetCenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnInsTransSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("오더가 이관되었습니다.", "info", "fnCloseTrans()");
            fnCallOrderDetail();
            return false;
        } else {
            fnInsTransFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnInsTransFailResult();
        return false;
    }
}

function fnInsTransFailResult(msg) {
    msg = typeof msg === "undefined" ? "" : msg;
    fnDefaultAlert("오류가 발생했습니다." + msg === "" ? "" : ("(" + msg + ")"), "warning");
    return false;
}

//오더 이관 닫기
function fnCloseTrans() {
    $("#PopTargetCenterCode option").remove();
    $("#PopTargetCenterCode").append("<option value=''>이관운송사</option>");
    $("#DivTrans").hide();
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
    var intHeight = $(document).height() - 880;
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

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnReqGridSuccResult";


    var objParam = {
        CallType: "OrderRequestChgList",
        ListType: "1",
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

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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

    window.open("/TMS/Common/PlaceNote?OrderType=1&CenterCode=" + $("#CenterCode").val() + "&PlaceType=" + intType + "&PlaceName=" + strPlaceName + "&PlaceAddr=" + strPlaceAddr + "&PlaceAddrDtl=" + strPlaceAddrDtl, "상하차지특이사항", "width=650, height=450, scrollbars=Yes");
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

    var strHandlerUrl = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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


/*********************************************/
// 이관비용 그리드
/*********************************************/
var GridTransPayID = "#DomesticTransPayListGrid";

$(document).ready(function () {
    if ($(GridTransPayID).length > 0) {
        // 그리드 초기화
        fnTransPayGridInit();
    }

    //추가
    $("#BtnTransAddPay").on("click", function (e) {
        if ($("#TransType").val() !== "2") {
            fnDefaultAlert("이관한 오더만 사용할 수 있는 기능입니다.");
            return false;
        }
        fnTransPayAddRow();
        return false;
    });

    //수정
    $("#BtnTransUpdPay").on("click", function (e) {
        if ($("#TransType").val() !== "2") {
            fnDefaultAlert("이관한 오더만 사용할 수 있는 기능입니다.");
            return false;
        }
        fnTransPayUpdRow();
        return false;
    });

    //삭제
    $("#BtnTransDelPay").on("click", function (e) {
        if ($("#TransType").val() !== "2") {
            fnDefaultAlert("이관한 오더만 사용할 수 있는 기능입니다.");
            return false;
        }

        fnTransPayDelRow();
        return false;
    });

    //다시입력
    $("#BtnTransResetPay").on("click", function (e) {
        if ($("#TransType").val() !== "2") {
            fnDefaultAlert("이관한 오더만 사용할 수 있는 기능입니다.");
            return false;
        }
        fnTransResetPay();
        return false;
    });

    $("#TransPayType").on("change",
        function (e) {
            fnTransSetPay();
        });

    $("#TransTaxKind").on("change",
        function (e) {
            fnCalcTax($("#TransSupplyAmt").val(), "TransTaxAmt", "TaxKind");
        });

    $("#TransSupplyAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            if ($("#TransPayType").val() == "1" || $("#TransPayType").val() == "2") {
                fnCalcTax($(this).val(), "TransTaxAmt", "TransTaxKind");
            }

            if (event.type === "keyup" && event.keyCode === 13) {
                if ($("#BtnTransUpdPay").css("display") === "none") {
                    $("#BtnTransAddPay").click();
                } else {
                    $("#BtnTransUpdPay").click();
                }
                return;
            }
        });

    $("#TransTaxAmt").on("keyup blur",
        function (event) {
            $(this).val(fnMoneyComma($(this).val()));
            if (event.type === "keyup" && event.keyCode === 13) {
                if ($("#BtnTransUpdPay").css("display") === "none") {
                    $("#BtnTransAddPay").click();
                } else {
                    $("#BtnTransUpdPay").click();
                }
                return;
            }
        });
});

function fnTransPayGridInit() {
    // 그리드 레이아웃 생성
    fnCreateTransPayGridLayout(GridTransPayID, "PaySeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridTransPayID, "", "", "", "", "", "", "", "fnTransPayGridCellDblClick");

    // 사이즈 세팅
    var intHeight = 170;
    AUIGrid.resize(GridTransPayID, $(GridTransPayID).width(), intHeight);
    // 브라우저 리사이징
    $(window).resize(function () {
        AUIGrid.resize(GridTransPayID, $(GridTransPayID).width(), intHeight);
    });
}

//기본 레이아웃 세팅
function fnCreateTransPayGridLayout(strGID, strRowIdField) {

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
        if (item.ClosingFlag == "Y" || item.BillStatus === 2 || item.BillStatus === 3 || item.SendStatus !== 1) { //마감, 계산서발행, 송금
            return "aui-grid-closing-y-row-style";
        }
        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultTransPayColumnLayout()");
    var objOriLayout = fnGetDefaultTransPayColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultTransPayColumnLayout() {
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
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnTransPayGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridTransPayID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return false;
    }

    if (objItem.PayType != "1") {
        fnDefaultAlert("이관 오더는 매출 외 비용을 수정하실 수 없습니다.");
        return false;
    }

    if (objItem.ClosingFlag !== "N" || objItem.BillStatus === 2 || objItem.BillStatus === 3 || objItem.SendStatus !== 1) {
        fnDefaultAlert("마감된 비용은 수정할 수 없습니다", "error");
        return false;
    }

    fnTransDisplayPay(objItem);
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallTransPayGridData(strGID) {

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnTransPayGridSuccResult";

    var objParam = {
        CallType: "DomesticTransPayList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnTransPayGridSuccResult(objRes) {

    if (objRes) {
        AUIGrid.setGridData(GridTransPayID, []);

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridTransPayID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridTransPayID);

        // 푸터
        fnSetTransPayGridFooter(GridTransPayID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetTransPayGridFooter(strGID) {

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
function fnTransDisplayPay(item) {

    if (item.PayType != "1") {
        fnDefaultAlert("이관 오더는 매출 외 비용을 등록하거나 수정하실 수 없습니다.");
        return false;
    }

    $("#TransPayType").val(item.PayType);
    fnTransSetPay();
    $("#TransSeqNo").val(item.SeqNo);
    $("#TransPaySeqNo").val(item.PaySeqNo);
    $("#TransTaxKind").val(item.TaxKind);
    $("#TransItemCode").val(item.ItemCode);
    $("#TransSupplyAmt").val(fnMoneyComma(item.SupplyAmt));
    $("#TransTaxAmt").val(fnMoneyComma(item.TaxAmt));
    $("#BtnTransUpdPay").show();
    $("#BtnTransDelPay").show();
}

//비용정보 세팅
function fnTransSetPay() {
    $("#TransTaxKind").find("option").filter(function (index) {
        return $(this).text() === "과세";
    }).prop("selected", true);

    $("#BtnTransUpdPay").hide();
    $("#BtnTransDelPay").hide();

    $("#TransSeqNo").val("");
    $("#TransPaySeqNo").val("");
    $("#ItemCode").find("option:nth-child(2)").prop("selected", true);
    $("#SupplyAmt").val("");
    $("#TaxAmt").val("");
}

//비용추가
function fnTransPayAddRow() {
    if (!$("#TargetCenterCode").val() || !$("#TargetOrderNo").val()) {
        fnDefaultAlert("이관 오더가 아닙니다.");
        return false;
    }

    if (!$("#TransPayType").val()) {
        fnDefaultAlertFocus("비용 구분을 선택하세요.", "TransPayType", "warning");
        return false;
    }

    if ($("#TransPayType").val() != "1") {
        fnDefaultAlertFocus("이관 오더는 매출 외 비용을 등록하실 수 없습니다.", "TransPayType", "warning");
        return false;
    }

    if (!$("#TransTaxKind").val()) {
        fnDefaultAlertFocus("과세 구분을 선택하세요.", "TransTaxKind", "warning");
        return false;
    }

    if (!$("#TransItemCode").val()) {
        fnDefaultAlertFocus("비용항목을 선택하세요.", "TransItemCode", "warning");
        return false;
    }

    if (!$("#TransSupplyAmt").val()) {
        fnDefaultAlertFocus("공급가액을 입력하세요.", "TransSupplyAmt", "warning");
        return false;
    }

    var cnt = 0;
    if ($("#TransItemCode").val() == "OP001" && $("#TransPayType").val() == "1") {
        if (AUIGrid.getGridData(GridTransPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridTransPayID),
                function (index, item) {
                    if (!AUIGrid.isRemovedById(GridTransPayID, item.PaySeqNo)) {
                        if (item.ItemCode == "OP001" && item.PayType == $("#TransPayType").val()) {
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

    var objItem = new Object();
    objItem.PayTypeM = $("#TransPayType option:selected").text();
    objItem.TaxKindM = $("#TransTaxKind option:selected").text();
    objItem.ItemCodeM = $("#TransItemCode option:selected").text();
    objItem.SupplyAmt = $("#TransSupplyAmt").val();
    objItem.TaxAmt = $("#TransTaxAmt").val();
    objItem.SeqNo = "";
    objItem.PaySeqNo = "";
    objItem.CenterCode = $("#TargetCenterCode").val();
    objItem.OrderNo = $("#TargetOrderNo").val();
    objItem.PayType = $("#TransPayType").val();
    objItem.TaxKind = $("#TransTaxKind").val();
    objItem.ItemCode = $("#TransItemCode").val();
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
    AUIGrid.addRow(GridTransPayID, objItem, "last");
    fnTransSetPay();
}

//비용수정
function fnTransPayUpdRow() {
    if (!$("#TransPaySeqNo").val()) {
        fnDefaultAlert("선택된 비용정보가 없습니다.", "warning");
        return false;
    }

    if (!$("#TargetCenterCode").val() || !$("#TargetOrderNo").val()) {
        fnDefaultAlert("이관 오더가 아닙니다.");
        return false;
    }

    if (!$("#TransPayType").val()) {
        fnDefaultAlertFocus("비용 구분을 선택하세요.", "TransPayType", "warning");
        return false;
    }

    if ($("#TransPayType").val() != "1") {
        fnDefaultAlertFocus("이관 오더는 매출 외 비용을 등록하실 수 없습니다.", "TransPayType", "warning");
        return false;
    }

    if (!$("#TransTaxKind").val()) {
        fnDefaultAlertFocus("과세 구분을 선택하세요.", "TransTaxKind", "warning");
        return false;
    }

    if (!$("#TransItemCode").val()) {
        fnDefaultAlertFocus("비용항목을 선택하세요.", "TransItemCode", "warning");
        return false;
    }

    if (!$("#TransSupplyAmt").val()) {
        fnDefaultAlertFocus("공급가액을 입력하세요.", "TransSupplyAmt", "warning");
        return false;
    }

    var cnt = 0;
    if ($("#TransItemCode").val() == "OP001" && $("#TransPayType").val() == "1") {
        if (AUIGrid.getGridData(GridTransPayID).length > 0) {
            $.each(AUIGrid.getGridData(GridTransPayID),
                function (index, item) {
                    if (!AUIGrid.isRemovedById(GridTransPayID, item.PaySeqNo)) {
                        if (item.ItemCode == "OP001" && item.PayType == $("#TransPayType").val() && item.PaySeqNo != $("#TransPaySeqNo").val()) {
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

    var objItem = new Object();
    objItem.PayTypeM = $("#TransPayType option:selected").text();
    objItem.TaxKindM = $("#TransTaxKind option:selected").text();
    objItem.ItemCodeM = $("#TransItemCode option:selected").text();
    objItem.SupplyAmt = $("#TransSupplyAmt").val();
    objItem.TaxAmt = $("#TransTaxAmt").val();
    objItem.SeqNo = $("#TransSeqNo").val();
    objItem.PaySeqNo = $("#TransPaySeqNo").val();
    objItem.CenterCode = $("#TargetCenterCode").val();
    objItem.OrderNo = $("#TargetOrderNo").val();
    objItem.PayType = $("#TransPayType").val();
    objItem.TaxKind = $("#TransTaxKind").val();
    objItem.ItemCode = $("#TransItemCode").val();
    objItem.ClosingFlag = "N";
    objItem.BillStatus = 1;
    objItem.SendStatus = 1;
    AUIGrid.updateRowsById(GridTransPayID, objItem);
    fnTransSetPay();
}

//비용삭제
function fnTransPayDelRow() {
    if (!$("#TransPaySeqNo").val()) {
        fnDefaultAlert("선택된 비용정보가 없습니다.", "warning");
        return false;
    }

    AUIGrid.removeRowByRowId(GridTransPayID, $("#TransPaySeqNo").val());
    fnTransSetPay();
}

//초기화
function fnTransResetPay() {
    fnTransSetPay();
}

function fnInsTransPay() {

    if ($("#TransType").val() != "2") {
        fnInsCarManageDispach();
        return false;
    }

    var SaleSeqNos = "";
    var ProcTypes = "";
    var TaxKinds = "";
    var ItemCodes = "";
    var SupplyAmts = "";
    var TaxAmts = "";
    var cnt = 0;

    if (AUIGrid.getGridData(GridTransPayID).length > 0) {
        $.each(AUIGrid.getGridData(GridTransPayID),
            function (index, item) {
                if (item.PayType == "1") {
                    var procType = "";
                    var seqNo = "";
                    var supplyAmt = "";
                    var taxAmt = "";

                    if (AUIGrid.isRemovedById(GridTransPayID, item.PaySeqNo)) {
                        procType = "D";
                    } else if (AUIGrid.isEditedById(GridTransPayID, item.PaySeqNo)) {
                        procType = "U";
                    } else if (AUIGrid.isAddedById(GridTransPayID, item.PaySeqNo)) {
                        procType = "I";
                    }
                    
                    if (procType != "") {
                        seqNo = item.SeqNo + "";
                        seqNo = seqNo == "" ? "0" : seqNo;
                        supplyAmt = item.SupplyAmt + "";
                        supplyAmt = supplyAmt == "" ? "0" : supplyAmt;
                        supplyAmt = supplyAmt.replace(/,/gi, "");
                        taxAmt = item.TaxAmt + "";
                        taxAmt = taxAmt == "" ? "0" : taxAmt;
                        taxAmt = taxAmt.replace(/,/gi, "");
                        if (procType === "U") {
                            if (seqNo == "" || seqNo == "0") {
                                procType = "I";
                            }
                        }

                        SaleSeqNos += (cnt > 0 ? "," : "") + seqNo;
                        ProcTypes += (cnt > 0 ? "," : "") + procType;
                        TaxKinds += (cnt > 0 ? "," : "") + item.TaxKind;
                        ItemCodes += (cnt > 0 ? "," : "") + item.ItemCode;
                        SupplyAmts += (cnt > 0 ? "," : "") + supplyAmt;
                        TaxAmts += (cnt > 0 ? "," : "") + taxAmt;
                        cnt++;
                    }
                }
            });
    }

    if (cnt == 0) {
        fnInsCarManageDispach();
        return false;
    }

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnInsTransPaySuccResult";
    var strFailCallBackFunc = "fnInsTransPayFailResult";

    var objParam = {
        CallType: "OrderTransSaleUpdate",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        SaleSeqNos: SaleSeqNos,
        ProcTypes: ProcTypes,
        TaxKinds: TaxKinds,
        ItemCodes: ItemCodes,
        SupplyAmts: SupplyAmts,
        TaxAmts: TaxAmts
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnInsTransPaySuccResult(objRes) {
    fnInsCarManageDispach();
    return false;
}

function fnInsTransPayFailResult() {
    fnInsCarManageDispach();
    return false;
}

//관리차량 - 배차 기록 등록
function fnInsCarManageDispach() {

    if ($("#GoodsDispatchType").val() != "2") {
        fnOrderInsEnd();
        return false;
    }

    if ($("#CarManageFlag").val() != "Y") {
        fnOrderInsEnd();
        return false;
    }

    if (!$("#CarDispatchType").val()) {
        fnOrderInsEnd();
        return false;
    }

    if ($("#CarDispatchType").val() === "2" && (!$("#OrgCenterCode").val() || !$("#OrgOrderNo").val())) {
        fnOrderInsEnd();
        return false;
    }

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnInsCarManageDispachResult";
    var strFailCallBackFunc = "fnInsCarManageDispachResult";

    var objParam = {
        CallType: "CarManageDispatchIns",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        OrgCenterCode: $("#OrgCenterCode").val(),
        OrgOrderNo: $("#OrgOrderNo").val(),
        AreaDistance: $("#AreaDistance").val(),
        CarDispatchType: $("#CarDispatchType").val(),
        RefSeqNo: $("#RefSeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnInsCarManageDispachResult(objRes) {
    fnOrderInsEnd();
    return false;
}

function fnInsCarManageDispachResult() {
    fnOrderInsEnd();
    return false;
}
/*********************************************/

//원본오더 보기
function fnOpenOrderOrgDetail() {
    if ($("#OrderRegType").val() !== "5" && $("#OrderRegType").val() !== "7") {
        fnDefaultAlert("원본오더가 없습니다.");
        return;
    } else {
        window.open("/WEB/Domestic/WebDomesticOrgDetail?OrderNo=" + $("#OrderNo").val(), "요청 원본 오더", "width=1180, height=700px, scrollbars=Yes");
        return;
    }
}


/*********************************************/
// 관리차량 시작
/*********************************************/
var GridCarShareID = "#OrderCarShareListGrid";

$(document).ready(function () {
    if ($(GridCarShareID).length > 0) {
        // 그리드 초기화
        fnCarShareGridInit();
    }
});

function fnCarShareGridInit() {
    // 그리드 레이아웃 생성
    fnCreateCarShareGridLayout(GridCarShareID, "CarShareSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridCarShareID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    var intHeight = 160;
    AUIGrid.resize(GridCarShareID, $("#DivCarManage > div").width() - 20, intHeight);
    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridCarShareID, $("#DivCarManage > div").width() - 20, intHeight);
        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridCarShareID, $("#DivCarManage > div").width() - 20, intHeight);
        }, 100);
    });
}

//기본 레이아웃 세팅
function fnCreateCarShareGridLayout(strGID, strRowIdField) {

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
    objGridProps.showFooter = false; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = true; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultCarShareColumnLayout()");
    var objOriLayout = fnGetDefaultCarShareColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultCarShareColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "BtnReg",
            headerText: "배차",
            editable: false,
            width: 100,
            renderer: {
                type: "ButtonRenderer",
                labelText: "차량배차",
                onClick: function (event) {
                    fnSetCarShareDispatch(event.item);
                    return;
                }
            }
        },{
            dataField: "CarDispatchTypeM",
            headerText: "구분",
            editable: false,
            width: 70,
            filter: { showIcon: true }
        },
        {
            dataField: "DispatchCnt",
            headerText: "배차횟수",
            editable: false,
            width: 80,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.##");
            },
            filter: { showIcon: true }
        },
        {
            dataField: "PickupPlaceFullAddr",
            headerText: "(상)적용주소",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlaceFullAddr",
            headerText: "(하)적용주소",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetYMD",
            headerText: "하차일",
            editable: false,
            width: 80,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetHM",
            headerText: "하차시간",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM",
            headerText: "톤수",
            editable: false,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTypeCodeM",
            headerText: "차종",
            editable: false,
            width: 80,
            visible: true,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverCell",
            headerText: "기사휴대폰",
            editable: false,
            width: 120,
            viewstatus: true,
            filter: { showIcon: true },
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "ComName",
            headerText: "차량업체명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DispatchAdminName",
            headerText: "배차자",
            editable: false,
            width: 80,
            filter: { showIcon: true }
        },
        {
            dataField: "MobileNo",
            headerText: "배차자연락처",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "AreaDistance",
            headerText: "반경(km)",
            editable: false,
            width: 80,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.##");
            },
            filter: { showIcon: true }
        },
        /*숨김필드*/
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "OrderNo",
            headerText: "OrderNo",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "CarDispatchType",
            headerText: "CarDispatchType",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "ComCode",
            headerText: "ComCode",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "CarSeqNo",
            headerText: "CarSeqNo",
            editable: false,
            visible: false,
            width: 0
        },
        {
            dataField: "DriverSeqNo",
            headerText: "DriverSeqNo",
            editable: false,
            visible: false,
            width: 0
        }
    ];

    return objColumnLayout;
}
//---------------------------------------------------------------------------------

//관리차량 레이어 열기
function fnOpenCarManage() {
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

    if (!$("#PickupYMD").val()) {
        fnDefaultAlertFocus("상차일을 입력하세요.", "PickupYMD", "warning");
        return false;
    }

    if (!$("#PickupPlaceFullAddr").val()) {
        fnDefaultAlertFocus("상차지 주소를 검색하세요.", "BtnSearchAddrPickupPlace", "warning");
        return false;
    }

    if (!$("#GetPlaceFullAddr").val()) {
        fnDefaultAlertFocus("하차지 주소를 검색하세요.", "BtnSearchAddrGetPlace", "warning");
        return false;
    }

    $("#DivCarManage").show();
    fnCallCarManage();
    return false;
}

//관리 및 연계차량 조회
function fnCallCarManage() {
    if (!$("#PickupYMD").val() || !$("#PickupPlaceFullAddr").val() || !$("#GetPlaceFullAddr").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallCarManageSuccResult";
    var strFailCallBackFunc = "fnCallCarManageFailResult";

    var objParam = {
        CallType: "CarManageList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        PickupYMD: $("#PickupYMD").val(),
        PickupPlaceFullAddr: $("#PickupPlaceFullAddr").val(),
        GetPlaceFullAddr: $("#GetPlaceFullAddr").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnCallCarManageSuccResult(objRes) {
    
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnCallCarManageFailResult();
            return false;
        }

        $("#OrderCarManageList tbody tr").remove();
        if (objRes[0].CarManageList.RecordCnt !== 0) {
            var html = "";
            $.each(objRes[0].CarManageList.list, function (index, item) {
                html = "<tr>";
                html += "<td>" + item.CarNo;
                if (item.CarTonCodeM != "" || item.CarTypeCodeM != "") {
                    html += " (" + item.CarTonCodeM + ", " + item.CarTypeCodeM + ")";
                }
                html += " / " + item.DriverName;
                html += " (" + item.DriverCell + ")";
                html += " / " + item.ComName;
                html += " (" + item.ComCorpNo + ")";
                html += "<td><button type=\"button\" class=\"btn_01\" onclick=\"fnSetCarManage(this, " + item.ComCode + ", '" + item.ComCorpNo + "'," + item.CarSeqNo + ", '" + item.CarNo + "'," + item.DriverSeqNo + ", '" + item.DriverCell + "'); return false;\">차량배차</button></td>";
                html += "</tr>";
                $("#OrderCarManageList tbody").append(html);
            });
        } else {
            $("#OrderCarManageList tbody").append("<tr><th colspan=\"8\" style=\"height: 60px;\">검색된 데이터가 없습니다.</th></tr>");
        }

        AUIGrid.setGridData(GridCarShareID, []);

        if (objRes[0].CarManageDispatchList.RecordCnt !== 0) {
            AUIGrid.setGridData(GridCarShareID, objRes[0].CarManageDispatchList.list);
        }
    }
}

function fnCallCarManageFailResult() {
    fnDefaultAlert("관리 및 연계차량을 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error");
    return false;
}

//관리차량 배차
function fnSetCarManage(obj, intComCode, strComCorpNo, intCarSeqNo, strCarNo, intDriverSeqNo, strDriverCell) {
    
    strComCorpNo = typeof strComCorpNo === "string" ? strComCorpNo : "";
    strComCorpNo = strComCorpNo.replace(/-/gi, "");

    strDriverCell = typeof strDriverCell === "string" ? strDriverCell : "";
    strDriverCell = strDriverCell.replace(/-/gi, "");

    var strDispatchInfo = $("#SpanDispatchInfo").text();
    if (strDispatchInfo.indexOf(strComCorpNo) > -1 && strDispatchInfo.indexOf(strCarNo) > -1 && strDispatchInfo.indexOf(strDriverCell) > -1) {
        fnDefaultAlert("현재 오더에 배차되어있는 차량과 동일합니다.", "error");
        return false;
    }

    var objParam = {
        ComCode: intComCode,
        ComCorpNo: strComCorpNo,
        CarSeqNo: intCarSeqNo,
        CarNo: strCarNo,
        DriverSeqNo: intDriverSeqNo,
        DriverCell: strDriverCell,
        AreaDistance: 0,
        CarDispatchType: 1,
        OrgCenterCode: 0,
        OrgOrderNo: 0
    }

    fnDefaultConfirm("선택한 차량으로 배차를 진행하시겠습니까?", "fnSetCarManageChange", objParam);
    return false;
}

//연계 공유차량 배차
function fnSetCarShareDispatch(objItem) {
    var strDispatchInfo = $("#SpanDispatchInfo").text();
    if (strDispatchInfo.indexOf(objItem.ComCorpNo) > -1 && strDispatchInfo.indexOf(objItem.CarNo) > -1 && strDispatchInfo.indexOf(objItem.DriverCell) > -1) {
        fnDefaultAlert("현재 오더에 배차되어있는 차량과 동일합니다.", "error");
        return false;
    }

    var objParam = {
        ComCode: objItem.ComCode,
        ComCorpNo: objItem.ComCorpNo,
        CarSeqNo: objItem.CarSeqNo,
        CarNo: objItem.CarNo,
        DriverSeqNo: objItem.DriverSeqNo,
        DriverCell: objItem.DriverCell,
        AreaDistance: objItem.AreaDistance,
        CarDispatchType: objItem.CarDispatchType,
        OrgCenterCode: objItem.CenterCode,
        OrgOrderNo: objItem.OrderNo
    }

    fnDefaultConfirm("선택한 차량으로 배차를 진행하시겠습니까?", "fnSetCarShareChange", objParam);
    return false;
}

//차량등록처리
function fnSetCarShareChange(objParam) {
    objParam.CenterCode = $("#CenterCode").val();
    objParam.CallType = "CarManageIns";

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnSetCarShareChangeSuccResult";
    var strFailCallBackFunc = "fnSetCarShareChangeFailResult";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnSetCarShareChangeSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnSetCarShareChangeFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        $("#RefSeqNo").val(objRes[0].RefSeqNo);
        $("#DispatchInfo").val(objRes[0].DispatchInfo);
        $("#RefCarNo").val(objRes[0].CarNo);
        $("#CarManageFlag").val("Y");
        $("#AreaDistance").val(objRes[0].AreaDistance);
        $("#CarDispatchType").val(objRes[0].CarDispatchType);
        $("#OrgCenterCode").val(objRes[0].OrgCenterCode);
        $("#OrgOrderNo").val(objRes[0].OrgOrderNo);
        
        $("#SpanDispatchTypeM").text("직송");
        $("#SpanDispatchInfo").text(objRes[0].DispatchInfo);

        fnCloseCarManage();
        return false;
    }
}

function fnSetCarShareChangeFailResult(strMsg) {
    if (typeof strMsg !== "string") {
        strMsg = "";
    }
    fnDefaultAlert("차량 등록에 실패했습니다." + (strMsg == "" ? "" : ("<br>(" + strMsg + ")")), "warning");
    return false;
}

//관리차량 레이어 닫기
function fnCloseCarManage() {
    fnCarManageReset();
    $("#DivCarManage").hide();
}

//관리차량 폼 리셋
function fnCarManageReset() {
    $("#OrderCarManageList tr").remove();
    AUIGrid.setGridData(GridCarShareID, []);
}

/*********************************************/
// 관리차량 끝
/*********************************************/


/*********************************************/
// 카고패스 시작
/*********************************************/
//카고패스 연동
function fnCloseRegCargopass() {
    $("#IfrmCargopass").attr("src", "about:blank");
    $("#DivCargopassIns").hide();
    return false;
}

//카고패스 등록 후 콜백
function fnCargopassInsCallback(strCargopassOrderNo) {
    $("#CargopassOrderNo").val(strCargopassOrderNo);
    $("#BtnRegCargopass").hide();
    $("#BtnDetailCargopass").show();
    return false;
}

//카고패스 등록
function fnRegCargopass() {
    if ($("#HidMode").val() === "Insert") {
        fnDefaultAlert("오더 등록 후 카고패스 등록이 가능합니다.");
        return false;
    }

    if ($("#CnlFlag").val() === "Y") {
        fnDefaultAlert("이미 취소된 오더입니다.", "warning");
        return false;
    }

    if (!($("#CargopassOrderNo").val() === "0" || $("#CargopassOrderNo").val() === "")) {
        fnDefaultAlert("카고패스 등록이 완료된 오더입니다.");
        return false;
    }

    if ($("#TransType").val() === "3") {
        fnDefaultAlert("이관받은 오더는 카고패스 등록이 불가능합니다.");
        return false;
    }

    if ($("#ContractType").val() === "2" && $("#ContractStatus").val() === "2") {
        fnDefaultAlert("위탁한 오더는 카고패스 등록이 불가능합니다.");
        return false;
    }

    if ($("#OrderStatusM").text().indexOf("접수") < 0) {
        fnDefaultAlert("접수 상태의 오더만 카고패스 등록이 가능합니다.");
        return false;
    }

    if ($("#HidGoodsDispatchType").val() !== "2") {
        if ($("#GoodsDispatchType").val() === "2") {
            fnDefaultAlert("오더 수정 후 카고패스 등록이 가능합니다.");
            return false;
        }

        fnDefaultAlert("직송 오더만 카고패스 등록이 가능합니다.");
        return false;
    }

    var strCenterCode = $("#CenterCode").val();
    var strOrderNos = $("#OrderNo").val();
    var strURL = "/TMS/Cargopass/CargopassIns?InsCallback=Y&DispatchType=1&CenterCode=" + strCenterCode + "&OrderNos=" + strOrderNos;
    $("#IfrmCargopass").attr("src", strURL);
    $("#DivCargopassIns").show();
    return false;
}

function fnDetailCargopass() {
    if ($("#CargopassOrderNo").val() === "0" || $("#CargopassOrderNo").val() === "") {
        fnDefaultAlert("카고패스 등록이 안된 오더입니다.");
        return false;
    }

    var strCenterCode = $("#CenterCode").val();
    var strCargopassOrderNo = $("#CargopassOrderNo").val();
    var strURL = "/TMS/Cargopass/CargopassIns?CenterCode=" + strCenterCode + "&CargopassOrderNo=" + strCargopassOrderNo;
    $("#IfrmCargopass").attr("src", strURL);
    $("#DivCargopassIns").show();
    return false;
}
/*********************************************/
// 카고패스 끝
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
        }, {
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

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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

    var strHandlerURL = "/TMS/Domestic/Proc/DomesticHandler.ashx";
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
    fnCallDepositGridData(GridDepositID, $("#CenterCode").val(), $("#" + strClientType  + "ClientCode").val())
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
    if ($("#TransType").val() === "3") {
        fnDefaultAlert("이관받은 오더는 수정하실 수 없습니다.");
        return false;
    }

    if ($("#ContractType").val() === "3") {
        fnDefaultAlert("수탁 오더는 수정하실 수 없습니다.");
        return false;
    }

    $("#PickupPlaceSeqNo").val("");
    $("#GetPlaceSeqNo").val("");

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
    $("#GetPlaceNote").val(strPickupPlaceNote);
}