$(document).ready(function () {
    if ($("#OrderNos").val() === "") {
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

    //fnCallAdvanceList();
    //fnSetTransPrintData();
    fnSetInitAutoComplete();
});

function fnWindowClose() {
    self.close();
}

//선급, 예수금
var strObjAdvance;
function fnCallAdvanceList() {
    var OrderNos = $("#OrderNos").val();
    var strHandlerURL = "/TMS/Common/Proc/OrderPrintListHandler.ashx";
    var strCallBackFunc = "fnGridAdvanceTransSuccResult";

    var objParam = {
        CallType: "OrderDispatchAdvanceList",
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        OrderNos: OrderNos
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridAdvanceTransSuccResult(objRusult) {
    if (objRusult) {
        strObjAdvance = objRusult;
    } else {
        fnDefaultAlert("선급/예수금을 불러오지 못했습니다.");
        return;
    }
    
}

function fnSetTransPrintData() {
    var OrderNos = $("#OrderNos").val();
    var strHandlerURL = "/TMS/Common/Proc/OrderPrintListHandler.ashx";
    var strCallBackFunc = "fnGridTransSuccResult";

    var objParam = {
        CallType: "OrderDispatchPrintList",
        CenterCode: $("#CenterCode").val(),
        ClientCode : $("#ClientCode").val(),
        SaleClosingSeqNo: $("#SaleClosingSeqNo").val(),
        OrderNos: OrderNos
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}
//운송장 출력
function fnGridTransSuccResult(ObjRes) {
    var objStyleW = "";
    var strTb = "";
    var strTbList = "";
    var strAdvanceTbList = "";
    var page = 0;
    var uniqueArr = [];             // 중복이 제거된 배열이 생성될 변수
    var uniqueItemCodeArr   = [];   // 중복이 제거된 배열이 생성될 변수
    var uniqueItemCodeMArr   = [];   // 중복이 제거된 배열이 생성될 변수
    var uniqueArrIndex = [];   // 인덱스
    var TotalSupplyAmt = 0;
    var TotalTaxAmt = 0;
    var TotalAdvanceOrgAmt = 0;
    
    if (ObjRes[0].data.list.length > 0) {
        
        $.each(ObjRes[0].data.list, function (k, val) {
            if ($.inArray(val.OrderNo, uniqueArr) === -1) {
                uniqueArr.push(val.OrderNo);
                uniqueArrIndex.push(k);
            }

            if ($.inArray(val.ItemCode, uniqueItemCodeArr) === -1) {
                uniqueItemCodeArr.push(val.ItemCode);
                uniqueItemCodeMArr.push(val.ItemCodeM);
            }

            TotalSupplyAmt += Number(val.SupplyAmt);
            TotalTaxAmt += Number(val.TaxAmt);
            
        });
        
        for (var i = 0; i < uniqueItemCodeArr.length; i++) {
            if (uniqueItemCodeArr[i] !== "") {
                var intSupplyAmtTotal = 0;
                var intTaxAmtTotal = 0;
                for (var v = 0; v < ObjRes[0].data.list.length; v++) {
                    if (uniqueItemCodeArr[i] == ObjRes[0].data.list[v].ItemCode) {
                        intSupplyAmtTotal += Number(ObjRes[0].data.list[v].SupplyAmt);
                        intTaxAmtTotal += Number(ObjRes[0].data.list[v].TaxAmt);
                    }
                }
                strTbList += "<tr>";
                strTbList += "<th>" + uniqueItemCodeMArr[i] + "</th>";
                strTbList += "<td>" + fnMoneyComma(intSupplyAmtTotal) + "</td>";
                strTbList += "<td>" + fnMoneyComma(intTaxAmtTotal) + "</td>";
                strTbList += "</tr>";
            }
        }

        for (var i = 0; i < strObjAdvance[0].data.RecordCnt; i++) {
            TotalAdvanceOrgAmt += Number(strObjAdvance[0].data.list[i].SupplyAmt);
            strAdvanceTbList += "<tr>";
            strAdvanceTbList += "<th>" + (strObjAdvance[0].data.list[i].PayType === 3 ? "대납금" : "대납금") + "(" + strObjAdvance[0].data.list[i].ItemCodeM + ")</th>";
            strAdvanceTbList += "<td>" + fnMoneyComma(strObjAdvance[0].data.list[i].SupplyAmt)  + "</td>";
            strAdvanceTbList += "<td>0</td>";
            strAdvanceTbList += "</tr>";
        }
        
        strTb += "<div class=\"page_line\">";
        
        for (var f = 0; f < uniqueArrIndex.length; f++) {
            if (uniqueArrIndex.length < 12) {
                objStyleW = "style=\"height:500px\"";
            } else {
                objStyleW = "style=\"height:auto\"";
            }
            if (f === 0) {
                strTb += "<ul class=\"top_ul\">";
                strTb += "<li>" + ObjRes[0].data.list[f].CenterName + "</li>"
                strTb += "<li>출력일 : " + fnGetDateToday("-") + "</li>"
                strTb += "</ul>";
                strTb += "<h1>운송내역서(기간)_(" + fnGetStrDateFormat(ObjRes[0].data.list[0].PickupYMD, ".") + " ~ " + fnGetStrDateFormat(ObjRes[0].data.list[ObjRes[0].data.list.length - 1].PickupYMD, ".") + ")</h1>";
                strTb += "<table class=\"type_02\">";
                strTb += "<colgroup>";
                strTb += "<col style=\"width:20%\"/>";
                strTb += "<col style=\"width:30%\"/>";
                strTb += "<col style=\"width:20%\"/>";
                strTb += "<col style=\"width:30%\"/>";
                strTb += "<thead>";
                strTb += "<tr>";
                strTb += "<th>고객사</th>";
                strTb += "<td>" + ObjRes[0].data.list[f].ClientName + "</td>";
                strTb += "<th>FAX</th>";
                strTb += "<td>" + ObjRes[0].data.list[f].ClientFaxNo + "</td>";
                strTb += "</tr>";
                strTb += "</thead>";
                strTb += "</table>";

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
                strTb += "<td>" + ObjRes[0].data.list[f].CenterNameInfo  + "</td>";
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

                //청구내역
                strTb += "<h2>청구내역</h2>";
                strTb += "<table class=\"type_02\">";
                strTb += "<colgroup>";
                strTb += "<col style=\"width:20%\"/>";
                strTb += "<col style=\"width:40%\"/>";
                strTb += "<col style=\"width:40%\"/>";
                strTb += "</colgroup>";
                strTb += "<thead>";
                strTb += "<tr>";
                strTb += "<th>항목</th>";
                strTb += "<th>공급가액(원)</th>";
                strTb += "<th>부가세(원)</th>";
                strTb += "</tr>";
                strTb += "</thead>";
                strTb += "<tbody class=\"amt\">";
                strTb += strTbList;
                strTb += "<tr>";
                strTb += "<th style='border-bottom:1px solid #000;'>소계</th>";
                strTb += "<td style='border-bottom:1px solid #000;'>" + fnMoneyComma(TotalSupplyAmt) +"</td>";
                strTb += "<td style='border-bottom:1px solid #000;'>" + fnMoneyComma(TotalTaxAmt) + "</td>";
                strTb += "</tr>";
                strTb += strAdvanceTbList;
                strTb += "<tr>";
                strTb += "<th>총청구금액</th>";
                strTb += "<td colspan='2'>" + fnMoneyComma(TotalSupplyAmt + TotalTaxAmt + TotalAdvanceOrgAmt) + "</td>";
                strTb += "</tr>";
                strTb += "</tbody>";
                strTb += "</table>";

                //상세내역
                strTb += "<h2>상세내역</h2>";
                strTb += "<div " + objStyleW +">";

                strTb += "<table class=\"type_02\">";
                strTb += "<colgroup>";
                strTb += "<col style=\"width:20px\"/>";
                strTb += "<col style=\"width:40px\"/>";
                strTb += "<col style=\"width:50px\"/>";
                strTb += "<col style=\"width:118px\"/>";
                strTb += "<col style=\"width:30px\"/>";
                strTb += "<col style=\"width:30px\"/>";
                strTb += "<col style=\"width:30px\"/>";
                strTb += "<col style=\"width:80px\"/>";
                strTb += "<col style=\"width:80px\"/>";
                strTb += "<col style=\"width:55px\"/>";
                strTb += "<col style=\"width:55px\"/>";
                strTb += "<col style=\"width:48px\"/>";
                strTb += "<col style=\"width:48px\"/>";
                strTb += "<col style=\"width:48px\"/>";
                strTb += "</colgroup>";
                strTb += "<thead>";
                strTb += "<tr>";
                strTb += "<th>No</th>";
                strTb += "<th>상차일</th>";
                strTb += "<th>상품</th>";
                strTb += "<th>화주</th>";
                strTb += "<th>수량</th>";
                strTb += "<th>무게</th>";
                strTb += "<th>부피</th>";
                strTb += "<th>상차지</th>";
                strTb += "<th>하차지</th>";
                strTb += "<th>목적국</th>";
                strTb += "<th>B/L(AWB)</th>";
                strTb += "<th>운송료</th>";
                strTb += "<th>대납금</th>";
                strTb += "<th>담당자</th>";
                strTb += "</tr>";
                strTb += "</thead>";
                strTb += "<tbody>";
            }
            
            for (var i = 0; i < ObjRes[0].data.list.length; i++) {
                if (i === uniqueArrIndex[f]) {
                    var SupplyAmtTotal = 0;
                    for (var y = 0; y < ObjRes[0].data.list.length; y++) {
                        if (ObjRes[0].data.list[y].OrderNo === uniqueArr[f]) {
                            //운임
                            SupplyAmtTotal += Number(ObjRes[0].data.list[y].SupplyAmt);
                        }

                    }
                    strTb += "<tr class=\"pd0\">";
                    strTb += "<td>" + (f + 1) + "</td>";
                    strTb += "<td>" + fnGetStrDateFormat(ObjRes[0].data.list[i].PickupYMD, "-").substr(5) + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].OrderItemCodeM + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].ConsignorName + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].Volume + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].Weight + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].CBM + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].PickupPlace + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].GetPlace + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].Nation + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].Hawb + "</td>";
                    strTb += "<td>" + fnMoneyComma(SupplyAmtTotal) + "</td>";
                    strTb += "<td>" + fnMoneyComma(Number(ObjRes[0].data.list[i].AdvanceOrgAmt)) + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].PayClientChargeName + "</td>";
                    strTb += "</tr>";
                }
            }
        }
        strTb += "</tbody>";
        strTb += "</table>";
        strTb += "</div>";
        strTb += "</div>";
    }

    $("div.print_area").html(strTb);
}

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
        PrintUrl: $(location).attr('href'),
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