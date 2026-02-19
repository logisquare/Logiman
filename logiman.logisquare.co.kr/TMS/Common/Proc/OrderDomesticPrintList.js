$(document).ready(function () {
    if ($("#HidGridID").val() === "") {
        fnDefaultAlert("필요한 값이 없습니다.", "warning", "fnWindowClose", "");
    }
    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("필요한 값이 없습니다.", "warning", "fnWindowClose", "");
    }
    if ($("#ClientCode").val() === "") {
        fnDefaultAlert("필요한 값이 없습니다.", "warning", "fnWindowClose", "");
    }

    $("#ChargeNameList").on("change", function () {
        $("#RecMail").val($(this).val().split("^")[0]);
        $("#RecName").val($(this).val().split("^")[1]);
    });

    $("#CheckMail").on("click", function () {
        if ($(this).is(":checked")) {
            $("#SendMail").val("shtax@logisquare.co.kr");
        } else {
            $("#SendMail").val("");
            $("#SendMail").focus();
        }
    });
    //fnSetTransPrintData();
    fnSetInitAutoComplete();
});

function fnWindowClose() {
    self.close();
}

/*function fnSetTransPrintData() {
    var strHandlerURL = "/TMS/Common/Proc/OrderPrintListHandler.ashx";
    var strCallBackFunc = "fnGridTransSuccResult";

    var objParam = {
        CallType: "OrderDispatchDomesticPrintList",
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        SaleClosingSeqNo: $("#SaleClosingSeqNo").val(),
        OrderNos: $("#OrderNos").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}
//운송장 출력
function fnGridTransSuccResult(ObjRes) {
    var objStyleW = "";
    var strTb = "";

    if (ObjRes[0].data.RecordCnt > 0) {
        for (var f = 0; f < ObjRes[0].data.RecordCnt; f++) {
            if (f === 0) {
                $("#SupplyAmtTotal").val(ObjRes[0].data.SupplyAmtTotal);
                $("#TaxAmtTotal").val(ObjRes[0].data.TaxAmtTotal);
                $("#OrgAmtTotal").val(ObjRes[0].data.OrgAmtTotal);
                strTb += "<div class=\"page_line\">";
                strTb += "<ul class=\"top_ul\">";
                strTb += "<li>" + ObjRes[0].data.list[f].CenterNameInfo + "</li>"
                strTb += "<li>출력일 : " + fnGetDateToday("-") + "</li>"
                strTb += "</ul>";
                strTb += "<h1>거래명세서(" + fnGetStrDateFormat(ObjRes[0].data.list[0].PickupYMD, ".") + " ~ " + fnGetStrDateFormat(ObjRes[0].data.list[ObjRes[0].data.RecordCnt - 1].PickupYMD, ".") + ")</h1>";

                //운송사 정보
                strTb += "<h2>운송사 정보</h2>";
                strTb += "<table class=\"type_02\">";
                strTb += "<colgroup>";
                strTb += "<col style=\"width:20%\"/>";
                strTb += "<col style=\"width:30%\"/>";
                strTb += "<col style=\"width:20%\"/>";
                strTb += "<col style=\"width:30%\"/>";
                strTb += "</colgroup>";
                strTb += "<thead class=\"tleft\">";
                strTb += "<tr>";
                strTb += "<th>운송사명</th>";
                strTb += "<td>" + ObjRes[0].data.list[f].CenterNameInfo + "</td>";
                strTb += "<th>대표번호/팩스</th>";
                strTb += "<td>" + ObjRes[0].data.list[f].TelNoInfo + " / " + ObjRes[0].data.list[f].FaxNoInfo + "</td>";
                strTb += "</tr>";
                strTb += "<tr>";
                strTb += "<th>주소</th>";
                strTb += "<td colspan=\"3\">";
                strTb += ObjRes[0].data.list[f].AddrInfo + "(우편번호 " + ObjRes[0].data.list[f].AddrPostInfo + ")";
                strTb += "</td>";
                strTb += "</tr>";
                strTb += "<tr>";
                strTb += "<th>계좌정보</th>";
                strTb += "<td colspan=\"3\">";
                strTb += "예금주 : " + ObjRes[0].data.list[f].AcctNameInfo + "&nbsp;&nbsp;|&nbsp;&nbsp;은행명 : " + ObjRes[0].data.list[f].BankNameInfo + "&nbsp;&nbsp;|&nbsp;&nbsp;계좌번호 : " + ObjRes[0].data.list[f].AcctNo;
                strTb += "</td>"
                strTb += "</tr>";
                strTb += "</thead>";
                strTb += "</table>";

                strTb += "<h2>요약정보</h2>";
                strTb += "<table class=\"type_01\">";
                strTb += "<colgroup>";
                strTb += "<col style=\"width:25%\"/>";
                strTb += "<col style=\"width:25%\"/>";
                strTb += "<col style=\"width:25%\"/>";
                strTb += "<col style=\"width:25%\"/>";
                strTb += "<thead>";
                strTb += "<tr>";
                strTb += "<th>총 운송건수</th>";
                strTb += "<th>공급가액</th>";
                strTb += "<th>부가세</th>";
                strTb += "<th>운송료합계</th>";
                strTb += "</tr>";
                strTb += "</thead>"
                strTb += "<tbody>";
                strTb += "<tr>";
                strTb += "<td>" + ObjRes[0].data.RecordCnt + "건</td>";
                strTb += "<td>" + fnMoneyComma(Number(ObjRes[0].data.SupplyAmtTotal)) + "</td>";
                strTb += "<td>" + fnMoneyComma(Number(ObjRes[0].data.TaxAmtTotal)) + "</td>";
                strTb += "<td>" + fnMoneyComma(Number(ObjRes[0].data.OrgAmtTotal)) + "</td>";
                strTb += "</tr>";
                strTb += "</tbody>";
                strTb += "</table>";

                //상세내역
                strTb += "<h2>상세내역</h2>";
                strTb += "<div " + objStyleW + ">";

                strTb += "<table class=\"type_02\">";
                strTb += "<colgroup>";
                strTb += "<col style=\"width:40px\"/>";
                strTb += "<col style=\"width:80px\"/>";
                strTb += "<col style=\"width:auto;\"/>";
                strTb += "<col style=\"width:auto;\"/>";
                strTb += "<col style=\"width:100px\"/>";
                strTb += "<col style=\"width:100px\"/>";
                strTb += "<col style=\"width:80px\"/>";
                strTb += "<col style=\"width:80px\"/>";
                strTb += "</colgroup>";
                strTb += "<thead>";
                strTb += "<tr>";
                strTb += "<th>No</th>";
                strTb += "<th>운송일</th>";
                strTb += "<th>상차지</th>";
                strTb += "<th>하차지</th>";
                strTb += "<th>차량번호</th>";
                strTb += "<th>화물명</th>";
                strTb += "<th>차량톤수</th>";
                strTb += "<th>운송료</th>";
                strTb += "</tr>";
                strTb += "</thead>";
                strTb += "<tbody>";
            }

            strTb += "<tr>";
            strTb += "<td>" + (f + 1) + "</td>";
            strTb += "<td>" + fnGetStrDateFormat(ObjRes[0].data.list[f].PickupYMD, "-") + "</td>";
            strTb += "<td>" + ObjRes[0].data.list[f].PickupPlace + "</td>";
            strTb += "<td>" + ObjRes[0].data.list[f].GetPlace + "</td>";
            strTb += "<td>" + ObjRes[0].data.list[f].CarNo + "</td>";
            strTb += "<td>" + ObjRes[0].data.list[f].GoodsName + "</td>";
            strTb += "<td>" + ObjRes[0].data.list[f].CarTonCodeM + "</td>";
            strTb += "<td>" + fnMoneyComma(Number(ObjRes[0].data.list[f].SupplyAmt)) + "</td>";
            strTb += "</tr>";
        }
        strTb += "</tbody>";
        strTb += "</table>";
        strTb += "</div>";
        strTb += "</div>";
    }

    $("div.print_area").html(strTb);
}*/

function fnSetInitAutoComplete() {
    //담당자 자동완성
    if ($("#ChargeName").length > 0) {
        fnSetAutocomplete({
            formId: "ChargeName",
            width: 250,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Common/Proc/OrderPrintListHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ChargeNameList",
                    ChargeName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    ClientCode: $("#ClientCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlert("회원사코드가 없습니다.");
                        return false;
                    }

                    if (!$("#ClientCode").val()) {
                        fnDefaultAlert("청구처코드가 없습니다.");
                        return false;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ChargeName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ChargeName + " (" + (item.ChargeEmail !== "" ? item.ChargeEmail : "미등록") + ")",
                getValue: (item) => item.ChargeName,
                onSelect: (event, ui) => {
                    $("#RecMail").val(ui.item.etc.ChargeEmail);
                    $("#RecName").val(ui.item.etc.ChargeName);
                },
                onBlur: () => {
                    if (!$("ChargeName").val()) {
                        $("#RecMail").val("");
                        $("#RecName").val("");
                    }
                }
            }
        });
    }
}

function fnMailSendConfirm() {
    var strMsg = "";
    var strCallType = "";

    if ($("#RecName").val() === "") {
        fnDefaultAlertFocus("청구처 담당자를 선택해주세요.", "RecName");
        return;
    }

    if ($("#RecMail").val() === "") {
        fnDefaultAlertFocus("청구처 담당자를 선택해주세요.", "RecMail");
        return;
    }

    if ($("#SendMail").val() === "") {
        fnDefaultAlertFocus("발신자 메일을 입력해주세요.", "SendMail");
        return;
    }
    
    if ($("#SaleClosingChk").is(':checked')) {
        var SupplyAmtTotal = Number($("#SupplyAmtTotal").val());
        var TaxAmtTotal = Number($("#TaxAmtTotal").val());
        var OrgAmtTotal = Number($("#OrgAmtTotal").val());
        var AmtResultValue = (SupplyAmtTotal * 10) / 100;
        if (OrgAmtTotal === 0) {
            fnDefaultAlert("매출마감 금액이 0원입니다.");
            return;
        }
        if (Math.floor(AmtResultValue) === Number(TaxAmtTotal)) {
            strMsg = "매출마감 후 메일발송 하시겠습니까?";
        } else {
            strMsg = "오더의 부가세가 공급가액의 10%와 일치하지 않습니다.<br/>그래도 마감하시겠습니까?";
        }
        
        strCallType = "SaleClosingSendMail";
    } else {
        strMsg = "메일발송 하시겠습니까?";
        strCallType = "PrintSendMail";
    }
    fnDefaultConfirm(strMsg, "fnMailSend", strCallType);
}

function fnMailSend(strCallType) {
    var strHandlerURL = "/TMS/Common/Proc/OrderPrintListHandler.ashx";
    var strCallBackFunc = "fnSendTransSuccResult";

    var objParam = {
        CallType: strCallType,
        PrintUrl: $(location).attr('href'),
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        RecName: $("#RecName").val(),
        RecMail: $("#RecMail").val(),
        SendMail: $("#SendMail").val(),
        ClosingFlag: $("#SaleClosingChk").is(':checked') ? "Y" : "N",
        SaleClosingSeqNo: $("#SaleClosingSeqNo").val(),
        OrderNos1: $("#OrderNos1").val(),
        OrderNos2: $("#OrderNos2").val(),
        SaleOrgAmt: Number($("#OrgAmtTotal").val()),
        AdminName: $("#AdminName").val(),
        AdminID: $("#AdminID").val(),
        CenterName: $("#CenterName").val(),
        ClientName: $("#ClientName").val(),
        MailTitle: $("#MailTitle").text(),
        AdminTel: $("#AdminTel").val(),
        AdminMobile: $("#AdminMobile").val(),
        DeptName: $("#DeptName").val(),
        AdminMail: $("#AdminMail").val(),
        AdminPosition: $("#AdminPosition").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnSendTransSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("처리되었습니다.", "success");
            return;
        } else {
            fnDefaultAlert(objRes[0].ErrMsg);
            return;
        }
    }
}

function fnPdfSave() {
    var objParam = {
        CallType: "DownloadPdfPrint",
        PrintUrl: $("#hidPage").val(),
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        SaleClosingSeqNo: $("#SaleClosingSeqNo").val(),
        OrderNos1: $("#OrderNos1").val(),
        OrderNos2: $("#OrderNos2").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val()
    };
    
    $.fileDownload("/TMS/Common/Proc/OrderPrintListHandler.ashx", {
        httpMethod: "POST",
        data: objParam,
        prepareCallback: function (html, url) {
            UTILJS.Ajax.fnAjaxBlock();
        },
        successCallback: function (url) {
            $.unblockUI();
            fnDefaultAlert("다운로드 완료되면 확인을 눌러주세요.", "success");
        },
        failCallback: function (html, url) {
            $.unblockUI();
            fnDefaultAlert("나중에 다시 시도해 주세요.");
        }
    });
}