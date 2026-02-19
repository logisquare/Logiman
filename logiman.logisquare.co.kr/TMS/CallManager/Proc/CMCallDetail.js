window.name = "CMCallDetail";
$(document).ready(function () {
    //class
    $(".info_con .more li:first-child").on("click", function () {
        if ($(this).parent("ul").parent("div").height() <= 26) {
            $(this).parent("ul").parent("div").animate({ height: '147px' }, { duration: 100, complete: function () { } });
        } else {
            $(this).parent("ul").parent("div").animate({ height: '26px' }, { duration: 100, complete: function () { } });
        }
    });

    //수발신 내역 표시
    $("#ChkCallViewFlag").on("click", function () {
        setTimeout(function () {
            fnGetResetCallLogList();
        }, 300);
    });

    //로그 스크롤 
    $("#DivCallList").scroll(function () {
        if ($(this)[0].scrollHeight - Math.round($(this).scrollTop()) == $(this).outerHeight()) {
            setTimeout(function () {
                fnGetMoreCallLogList();
            }, 300);
        }         
    });

    fnSetMasterCard();
});

//기본카드 정보 세팅
function fnSetMasterCard() {
    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        fnDefaultAlert("정보를 불러오는데 실패했습니다.", "error", "window.close();");
        return false;
    }
    
    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        fnDefaultAlert("정보를 불러오는데 실패했습니다.", "error", "window.close();");
        return false;
    }

    $("div.cont_lnb").addClass("type0" + objCMJsonParam.CallerType);
    $("div.cont_lnb div.info_con div.more ul li:first-child").addClass("class" + objCMJsonParam.ClassType);
    $("div.cont_lnb div.info_con div.info_tit h6").html(objCMJsonParam.Name);
    $("div.cont_lnb div.info_con div.info_group span").addClass(fnGetOjClass(objCMJsonParam.CallerDetailType, objCMJsonParam.CallerDetailText));
    $("div.cont_lnb div.info_con div.info_group span").html(objCMJsonParam.CallerDetailText);
    $("div.cont_lnb div.info_con div.info_group p").html(fnMakeCellNo(objCMJsonParam.SndTelNo));
    $("div.cont_memo div.memo_head > div").html("<span>MEMO</span>" + fnMakeCellNo(objCMJsonParam.SndTelNo));

    if (objCMJsonParam.CallerDetailType == 31) {
        $("div.info_con div.info_btn a.icon_local").show();
    }

    if (isMobilePhone(objCMJsonParam.SndTelNo)) {
        $("div.info_con div.info_btn a.icon_mms").show();
    }

    fnSetCMAdminPhoneList("CMAdminPhoneList", objCMJsonParam.RcvTelNo, "", true); // 연락처목록
    fnGetCardList(); //카드 목록
    fnGetInfoList(); //정보 목록
    fnGetCallLogList(); //수발신 목록
}

function fnGetOjClass(intCallerDetailType, strCallerDetailText) {
    var strOjClass = "oj09";
    if (strCallerDetailText == "차량업체" || strCallerDetailText == "포워더") {
        strOjClass = "oj01";
    } else if (strCallerDetailText == "협력업체" || strCallerDetailText == "화주") {
        strOjClass = "oj02";
    } else if (strCallerDetailText == "직영" || strCallerDetailText == "운송") {
        strOjClass = "oj03";
    } else if (strCallerDetailText == "단기" || strCallerDetailText == "창고") {
        strOjClass = "oj04";
    } else if (strCallerDetailText == "지입" || (strCallerDetailText == "기타" && (intCallerDetailType == 51 || intCallerDetailType == 52))) {
        strOjClass = "oj05";
    } else if (strCallerDetailText == "협력" || (strCallerDetailText == "상하차지" && intCallerDetailType == 53)) {
        strOjClass = "oj06";
    } else if (strCallerDetailText == "고정" || (strCallerDetailText == "상하차지" && intCallerDetailType == 72)) {
        strOjClass = "oj07";
    } else if (strCallerDetailText == "로지맨" || strCallerDetailText == "내부관리자" || strCallerDetailText == "웹오더") {
        strOjClass = "oj08";
    }
    return strOjClass;
}

//왼쪽 목록(카드목록)
function fnGetCardList() {
    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    if (objCMJsonParam.CallerType == "4") {
        return false;
    }

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnGetCardListSuccResult";
    var strFailCallBackFunc = "fnGetCardListFailResult";
    var objParam = objCMJsonParam;
    objParam.CallType = "CMDetailCardList";
    objParam.PageSize = 10;
    objParam.PageNo = 1;

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnGetCardListSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                fnGetCardListFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode) {
            if (objRes[0].result.ErrorCode != 0) {
                fnGetCardListFailResult();
                return false;
            }
        }

        fnSetCardList(objRes[0]);
    } else {
        fnGetCardListFailResult();
        return false;
    }
}

function fnGetCardListFailResult() {
    fnDefaultAlert("정보 조회에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning", "window.close()");
    return false;
}

function fnSetCardList(objRes) {
    if (typeof objRes == "undefined") {
        return false;
    }

    if (objRes.data.RecordCnt == 0) {
        return false;
    }

    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    var strHtml = "";
    $.each(objRes.data.list, function (index, item) {
        var strEq = "";

        if (objCMJsonParam.CallerType == item.CallerType && objCMJsonParam.CallerDetailType == item.CallerDetailType && objCMJsonParam.CallerDetailText == item.CallerDetailText
            && objCMJsonParam.Name == item.Name
            && objCMJsonParam.RefSeqNo == item.RefSeqNo && objCMJsonParam.ComCode == item.ComCode
            && objCMJsonParam.ClientCode == item.ClientCode
            && objCMJsonParam.ClientAdminID == item.ClientAdminID
            && objCMJsonParam.Position == item.Position
            && objCMJsonParam.DeptName == item.DeptName) {
            strEq = " equal";
        }

        if (item.CallerDetailType == 31) { //기사
            strHtml += "<div class=\"card_sec type01" + strEq + (objCMJsonParam.CallerType != item.CallerType ? " other" : "") + "\" onclick=\"fnGoCallDetailFromCard(event, this); return false;\">";
            strHtml += "<input type=\"hidden\" id=\"CardCMJsonParam" + index + "\">";
            strHtml += "<div class=\"card_more\">";
            strHtml += "<a href=\"#\" title=\"정보수정\" onclick=\"fnEditInfo(event); return false;\"></a>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_info\">";
            strHtml += "<div class=\"card_tit\">";
            strHtml += "<div class=\"tt\"><p>" + item.Name + "</p><span class=\"ojspan " + fnGetOjClass(item.CallerDetailType, item.CallerDetailText) + "\">" + item.CallerDetailText + "</span></div>";
            strHtml += "<div class=\"st\">" + item.CarNo + " " + item.CarTon + " " + item.CarType + "</div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_view\">";
            strHtml += "<ul>";
            strHtml += "<li class=\"office\">" + item.ComName + "</li>";
            strHtml += "<li class=\"user\">" + item.CeoName + "</li>";
            strHtml += "<li class=\"number\">" + fnMakeCorpNo(item.CorpNo) + " <span>(" + item.TaxMsg + ")</span></li>";
            strHtml += "</ul>";
            strHtml += "</div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_more\">";
            strHtml += "<a href=\"#\" onclick=\"fnGoMenuNewTab(event, 10, 'DriverCell=" + objCMJsonParam.SndTelNo + "'); return false;\"></a>";
            strHtml += "</div>";
            strHtml += "</div>";

        } else if (item.CallerDetailType == 32 || item.CallerDetailType == 33) { //차량업체 - 일반, 협력
            strHtml += "<div class=\"card_sec type01" + strEq + (objCMJsonParam.CallerType != item.CallerType ? " other" : "") + "\" onclick=\"fnGoCallDetailFromCard(event, this); return false;\">";
            strHtml += "<input type=\"hidden\" id=\"CardCMJsonParam" + index + "\">";
            strHtml += "<div class=\"card_info\">";
            strHtml += "<div class=\"card_tit\">";
            strHtml += "<div class=\"tt\"><p>" + item.Name + "</p><span class=\"ojspan " + fnGetOjClass(item.CallerDetailType, item.CallerDetailText) + "\">" + item.CallerDetailText + "</span></div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_view\">";
            strHtml += "<ul>";
            strHtml += "<li class=\"office\">" + item.ComName + "</li>";
            strHtml += "<li class=\"user\">" + item.CeoName + "</li>";
            strHtml += "<li class=\"number\">" + fnMakeCorpNo(item.CorpNo) + " <span>(" + item.TaxMsg + ")</span></li>";
            strHtml += "</ul>";
            strHtml += "</div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_more\">";
            strHtml += "<a href=\"#\" onclick=\"fnGoMenuNewTab(event, 10, 'ComCorpNo=" + item.CorpNo + "'); return false;\"></a>";
            strHtml += "</div>";
            strHtml += "</div>";

        } else if (item.CallerDetailType == 51) { //고객사 담당자
            strHtml += "<div class=\"card_sec type02" + strEq + (objCMJsonParam.CallerType != item.CallerType ? " other" : "") + "\" onclick=\"fnGoCallDetailFromCard(event, this); return false;\">";
            strHtml += "<input type=\"hidden\" id=\"CardCMJsonParam" + index + "\">";
            strHtml += "<div class=\"card_info\">";
            strHtml += "<div class=\"card_tit\">";
            strHtml += "<div class=\"tt\"><p>" + item.Name + " " + item.Position + "</p><span class=\"ojspan " + fnGetOjClass(item.CallerDetailType, item.CallerDetailText) + "\">" + item.CallerDetailText + "</span></div>";
            strHtml += "<div class=\"st\">" + item.DeptName + "</div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_view\">";
            strHtml += "<ul>";
            strHtml += "<li class=\"office\">" + item.ComName + "</li>";
            strHtml += "<li class=\"user\">" + item.CeoName + "</li>";
            strHtml += "<li class=\"number\">" + fnMakeCorpNo(item.CorpNo) + " <span>(" + item.TaxMsg + ")</span></li>";
            strHtml += "</ul>";
            strHtml += "</div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_more\">";
            strHtml += "<a href=\"#\" onclick=\"fnGoMenuNewTab(event, 9, 'ClientCorpNo=" + item.CorpNo + "'); return false;\"></a>";
            strHtml += "</div>";
            strHtml += "</div>";

        } else if (item.CallerDetailType == 52 || item.CallerDetailType == 71) { //고객사, 오더 고객사
            strHtml += "<div class=\"card_sec type02" + strEq + (objCMJsonParam.CallerType != item.CallerType ? " other" : "") + "\" onclick=\"fnGoCallDetailFromCard(event, this); return false;\">";
            strHtml += "<input type=\"hidden\" id=\"CardCMJsonParam" + index + "\">";
            strHtml += "<div class=\"card_info\">";
            strHtml += "<div class=\"card_tit\">";
            strHtml += "<div class=\"tt\"><p>" + item.Name + "</p><span class=\"ojspan " + fnGetOjClass(item.CallerDetailType, item.CallerDetailText) + "\">" + item.CallerDetailText + "</span></div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_view\">";
            strHtml += "<ul>";
            strHtml += "<li class=\"office\">" + item.ComName + "</li>";
            strHtml += "<li class=\"user\">" + item.CeoName + "</li>";
            strHtml += "<li class=\"number\">" + fnMakeCorpNo(item.CorpNo) + " <span>(" + item.TaxMsg + ")</span></li>";
            strHtml += "</ul>";
            strHtml += "</div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_more\">";
            strHtml += "<a href=\"#\" onclick=\"fnGoMenuNewTab(event, 9, 'ClientCorpNo=" + item.CorpNo + "'); return false;\"></a>";
            strHtml += "</div>";
            strHtml += "</div>";

        } else if (item.CallerDetailType == 53 || item.CallerDetailType == 72) { //고객사 상하차지, 오더 상하차지
            strHtml += "<div class=\"card_sec type02" + strEq + (objCMJsonParam.CallerType != item.CallerType ? " other" : "") + "\" onclick=\"fnGoCallDetailFromCard(event, this); return false;\">";
            strHtml += "<input type=\"hidden\" id=\"CardCMJsonParam" + index + "\">";
            strHtml += "<div class=\"card_info\">";
            strHtml += "<div class=\"card_tit\">";
            strHtml += "<div class=\"tt\"><p>" + item.Name + "</p><span class=\"ojspan " + fnGetOjClass(item.CallerDetailType, item.CallerDetailText) + "\">" + item.CallerDetailText + "</span></div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_view\">";
            strHtml += "<ul>";
            strHtml += "<li class=\"office\">" + item.PlaceName + "</li>";
            strHtml += "<li class=\"number\">" + item.PlaceAddr + "</li>";
            strHtml += "</ul>";
            strHtml += "</div>";
            strHtml += "</div>";
            strHtml += "</div>";

        } else if (item.CallerDetailType == 11) { //웹오더
            strHtml += "<div class=\"card_sec type02" + strEq + (objCMJsonParam.CallerType != item.CallerType ? " other" : "") + "\" onclick=\"fnGoCallDetailFromCard(event, this); return false;\">";
            strHtml += "<input type=\"hidden\" id=\"CardCMJsonParam" + index + "\">";
            strHtml += "<div class=\"card_info\">";
            strHtml += "<div class=\"card_tit\">";
            strHtml += "<div class=\"tt\"><p>" + item.Name + " " + item.Position + "</p><span class=\"ojspan " + fnGetOjClass(item.CallerDetailType, item.CallerDetailText) + "\">" + item.CallerDetailText + "</span></div>";
            strHtml += "<div class=\"st\">" + item.DeptName + "</div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_view\">";
            strHtml += "<ul>";
            strHtml += "<li class=\"office\">" + item.ComName + "</li>";
            strHtml += "<li class=\"user\">" + item.CeoName + "</li>";
            strHtml += "<li class=\"number\">" + fnMakeCorpNo(item.CorpNo) + " <span>(" + item.TaxMsg + ")</span></li>";
            strHtml += "</ul>";
            strHtml += "</div>";
            strHtml += "</div>";
            strHtml += "</div>";

        } else if (item.CallerDetailType == 21 || item.CallerDetailType == 22) { //로지맨, 내부관리자
            strHtml += "<div class=\"card_sec type03" + strEq + (objCMJsonParam.CallerType != item.CallerType ? " other" : "") + "\" onclick=\"fnGoCallDetailFromCard(event, this); return false;\">";
            strHtml += "<input type=\"hidden\" id=\"CardCMJsonParam" + index + "\">";
            strHtml += "<div class=\"card_info\">";
            strHtml += "<div class=\"card_tit\">";
            strHtml += "<div class=\"tt\"><p>" + item.Name + " " + item.Position + "</p><span class=\"ojspan " + fnGetOjClass(item.CallerDetailType, item.CallerDetailText) + "\">" + item.CallerDetailText + "</span></div>";
            strHtml += "<div class=\"st\">" + item.DeptName + "</div>";
            strHtml += "</div>";
            strHtml += "<div class=\"card_view\">";
            strHtml += "<ul>";
            strHtml += "<li class=\"office\">" + item.CenterName + "</li>";
            strHtml += "</ul>";
            strHtml += "</div>";
            strHtml += "</div>";
            strHtml += "</div>";
        }
    });

    $("#DivCardList").html(strHtml);

    $.each(objRes.data.list, function (index, item) {
        $("#CardCMJsonParam" + index).val(JSON.stringify(item));
    });
}

//중간 목록(오더현황 등)
function fnGetInfoList() {
    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    if (objCMJsonParam.CallerType == "4") {
        return false;
    }

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnGetInfoListSuccResult";
    var strFailCallBackFunc = "fnGetInfoListFailResult";
    var objParam = objCMJsonParam;
    objParam.CallType = "CMDetailInfoList";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnGetInfoListSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnSetInfoList(objRes[0]);
            return false;
        } else {
            fnGetInfoListFailResult();
            return false;
        }
    } else {
        fnGetInfoListFailResult();
        return false;
    }
}

function fnGetInfoListFailResult() {
    fnDefaultAlert("정보 조회에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning", "window.close()");
    return false;
}

function fnSetInfoList(objRes) {
    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        fnDefaultAlert("정보를 불러오는데 실패했습니다.", "error", "window.close();");
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        fnDefaultAlert("정보를 불러오는데 실패했습니다.", "error", "window.close();");
        return false;
    }

    //메시지 전송 내역

    if (objCMJsonParam.CallerType == 1) { //차량
        var strListHtml = "";

        if (objCMJsonParam.CallerDetailType == 31) { //기사
            $("div.only_company").remove();
            //차량비고
            $("#RefNote").html(objRes.RefNote);
        } else if (objCMJsonParam.CallerDetailType == 32 || objCMJsonParam.CallerDetailType == 33) { //차량업체
            $("div.only_car").remove();

            //차량현황
            strListHtml = "";
            if (objRes.CarDispatchRefRecordCnt > 0) {
                $.each(objRes.CarDispatchRefList, function (index, item) {
                    strListHtml += `<tr refseqno="${item.RefSeqNo}" centercode="${item.CenterCode}">
                                        <td>${item.CarDivTypeM}</td>
                                        <td class="opencar">${item.CarNo}</td>
                                        <td>${item.CarTypeCodeM}</td>
                                        <td>${item.CarTonCodeM}</td>
                                        <td>${item.DriverName}</td>
                                        <td class="callpopup">${fnMakeCellNo(item.DriverCell)}</td>
                                    </tr>`;
                });
            } else {
                strListHtml = "<td colspan='6' class='emptydata'>조회된 오더가 없습니다.</td>";
            }

            $("#TbodyCarDispatchRefList").html(strListHtml);
        }

        //오더현황
        strListHtml = "";
        if (objRes.OrderDispatchRecordCnt > 0) {
            $.each(objRes.OrderDispatchList, function (index, item) {
                strListHtml += `<tr orderno="${item.OrderNo}" orderitemcode="${item.OrderItemCode}" centercode="${item.CenterCode}">
	                                <td class="sj openorder">${item.OrderNo}<br/><span class="gray">${item.DispatchTypeM + " / " + item.DispatchStatusM + " / " + item.OrderItemCodeM}</span></td>
	                                <td class="tv">${item.OrderClientName + "<br/>" + item.ConsignorName}</td>
	                                <td class="callpopup">${item.OrderClientChargeName + "<br/>(" + fnMakeCellNo(item.OrderClientChargeTelNo) + ")"}</td>
	                                <td>${item.PickupPlace + "<br/>(" + fnGetStrDateFormat(item.PickupYMD, "-") + " " + fnGetHMFormat(item.PickupHM) + ")"}</td>
	                                <td>${item.GetPlace + "<br/>(" + fnGetStrDateFormat(item.GetYMD, "-") + " " + fnGetHMFormat(item.GetHM) + ")"}</td>
	                                <td class="callpopup carinfo">${item.DriverName + " / " + item.CarNo + "<br/>(" + fnMakeCellNo(item.DriverCell) + ")"}</td>
	                                <td class="pay">${"&#8361; " + fnMoneyComma(item.PurchaseSupplyAmt)}</td>
	                                <td class="callpopup">${item.AcceptAdminName + "<br/>(" + fnMakeCellNo(item.AcceptAdminTelNo) + ")"}</td>
	                                <td class="callpopup">${item.UpdAdminName == "" ? "" : (item.UpdAdminName + "<br/>(" + fnMakeCellNo(item.UpdAdminTelNo) + ")")}</td>
	                                <td class="callpopup">${item.DispatchAdminName + "<br/>(" + fnMakeCellNo(item.DispatchAdminTelNo) + ")"}</td>
	                                <td class="sendorder"><img src="/images/callmanager/btn_send.svg" alt="오더전송" title="오더전송" /></td>
                                </tr>`;
            });
        } else {
            strListHtml = "<td colspan='11' class='emptydata'>조회된 오더가 없습니다.</td>";
        }

        $("#TbodyOrderDispatchList").html(strListHtml);

        if (objCMJsonParam.CallerDetailType == 31) { //기사
            $("#TbodyOrderDispatchList").parent("table").children("thead").children("tr").children("th.carinfo").remove();
            $("#TbodyOrderDispatchList td.carinfo").remove();
            $("#TbodyOrderDispatchList").parent("table").children("colgroup").children("col.carinfo").remove();
        }

        //매입마감현황
        strListHtml = "";
        if (objRes.OrderPurchaseClosingRecordCnt > 0) {
            $.each(objRes.OrderPurchaseClosingList, function (index, item) {
                strListHtml += `<tr purchaseclosingseqno="${item.PurchaseClosingSeqNo}" centercode="${item.CenterCode}">
	                                <td class="openpurchase">${item.PurchaseClosingSeqNo}</td>
	                                <td>${item.SendTypeM + " / <strong class=\"fcblue\">" + item.SendStatusM + "</strong>"}</td>
	                                <td>${fnGetStrDateFormat(item.ClosingYMD, "-") + " / " + fnGetStrDateFormat(item.SendPlanYMD, "-") + " / " + fnGetStrDateFormat(item.SendYMD, "-")}</td>
	                                <td>${"&#8361; " + fnMoneyComma(item.SupplyAmt) + " / &#8361; " + fnMoneyComma(item.TaxAmt)}</td>
	                                <td>${"&#8361; " + fnMoneyComma(item.DeductAmt)}</td>
	                                <td>${"&#8361; " + fnMoneyComma(item.NotiDriverInsureAmt)}</td>
	                                <td class="pay">${"&#8361; " + fnMoneyComma(item.SendAmt)}</td>
	                                <td>${(item.SendStatus > 1 ? item.SendBankName : item.BankName) + " / " + (item.SendStatus > 1 ? item.SendSearchAcctNo : item.SearchAcctNo) + " / " + (item.SendStatus > 1 ? item.SendAcctName : item.AcctName)}</td>
	                                <td class="callpopup">${item.ClosingAdminName + "<br/>(" + fnMakeCellNo(item.ClosingAdminTelNo) + ")"}</td>
                                </tr>`;
            });
        } else {
            strListHtml = "<td colspan='9' class='emptydata'>조회된 마감정보가 없습니다.</td>";
        }

        $("#TbodyOrderPurchaseClosingList").html(strListHtml);

        //메시지 전송 내역
        strListHtml = "";
        if (objRes.MessageSendLogRecordCnt > 0) {
            $.each(objRes.MessageSendLogList, function (index, item) {
                strListHtml += `<tr centercode="${item.CenterCode}">
                                    <td class="sj"><span class="green">${item.CallKind}</span></td>
                                    <td class="tb callpopup">${fnMakeCellNo(item.SendNumber)}</td>
                                    <td class="tv">${item.RegDate}</td>
                                    <td class="tt">${item.Message}</td>
                                </tr>`;
            });
        } else {
            strListHtml = "<td colspan='4' class='emptydata'>조회된 전송내역이 없습니다.</td>";
        }

        $("#TbodyMessageSendLogList").html(strListHtml);

        if (objRes.CompanyViewFlag != "Y") {
            $("#TbodyCarDispatchRefList").parent("table").parent("div").parent("div").parent("div").remove();
        }

        if (objRes.OrderViewFlag != "Y") {
            $("#TbodyOrderDispatchList").parent("table").parent("div").parent("div").parent("div").remove();
        }

        if (objRes.PurchaseViewFlag != "Y") {
            $("#TbodyOrderPurchaseClosingList").parent("table").parent("div").parent("div").parent("div").remove();
        } 
    } else if (objCMJsonParam.CallerType == 2) { //고객사
        if (objCMJsonParam.CallerDetailType == "72") {
            $("div.only_client").remove();

            //오더현황
            strListHtml = "";
            if (objRes.OrderRecordCnt > 0) {
                $.each(objRes.OrderList, function (index, item) {
                    strListHtml += `<tr orderno="${item.OrderNo}" orderitemcode="${item.OrderItemCode}" centercode="${item.CenterCode}">
	                                    <td class="sj openorder">${item.OrderNo}<br/><span class="gray">${item.OrderStatusM + " / " + item.OrderItemCodeM + (item.OrderLocationCodeM == "" ? "" : (" / " + item.OrderLocationCodeM))}</span></td>
	                                    <td class="tv">${item.OrderClientName + "<br/>" + item.PayClientName + "<br/>" + item.ConsignorName}</td>
	                                    <td class="callpopup">${item.OrderClientChargeName + "<br/>(" + fnMakeCellNo(item.OrderClientChargeTelNo) + ")"}</td>
	                                    <td>${item.PickupPlace + "<br/>" + fnGetStrDateFormat(item.PickupYMD, "-") + " " + fnGetHMFormat(item.PickupHM)}</td>
	                                    <td>${item.GetPlace + "<br/>" + fnGetStrDateFormat(item.GetYMD, "-") + " " + fnGetHMFormat(item.GetHM)}</td>
	                                    <td class="callpopup">${item.PickupCarNo == "" ? "" : (item.PickupDriverName + " / " + item.PickupCarNo + "<br/>(" + fnMakeCellNo(item.PickupDriverCell) + ")")}</td>
	                                    <td class="callpopup">${item.GetCarNo == "" ? "" : (item.GetDriverName + " / " + item.GetCarNo + "<br/>(" + fnMakeCellNo(item.GetDriverCell) + ")")}</td>
	                                    <td class="callpopup">${item.AcceptAdminName + "<br/>(" + fnMakeCellNo(item.AcceptAdminTelNo) + ")"}</td>
	                                    <td class="callpopup">${item.UpdAdminName == "" ? "" : (item.UpdAdminName + "<br/>(" + fnMakeCellNo(item.UpdAdminTelNo) + ")")}</td>
	                                    <td class="senddispatch"><img src="/images/callmanager/btn_send.svg" alt="배차정보전송" title="배차정보전송" /></td>
                                    </tr>`;
                });
            } else {
                strListHtml = "<td colspan='10' class='emptydata'>조회된 오더가 없습니다.</td>";
            }

            $("#TbodyOrderListForPlace").html(strListHtml);
        } else {
            $("div.only_place").remove();
            $("#PClientNote1").html("<span>거래정지사유</span><br/>" + (objRes.ClientNote1 == null ? "" : objRes.ClientNote1.replace(/\n/gi, "<br/>")));
            $("#PClientNote2").html("<span>업무특이사항</span><br/>" + (objRes.ClientNote2 == null ? "" : objRes.ClientNote2.replace(/\n/gi, "<br/>")));
            $("#PClientNote3").html("<span>영업특이사항</span><br/>" + (objRes.ClientNote3 == null ? "" : objRes.ClientNote3.replace(/\n/gi, "<br/>")));
            $("#PClientNote4").html("<span>청구특이사항</span><br/>" + (objRes.ClientNote4 == null ? "" : objRes.ClientNote4.replace(/\n/gi, "<br/>")));

            //오더현황
            strListHtml = "";
            if (objRes.OrderRecordCnt > 0) {
                $.each(objRes.OrderList, function (index, item) {
                    strListHtml += `<tr orderno="${item.OrderNo}" orderitemcode="${item.OrderItemCode}" centercode="${item.CenterCode}">
	                                    <td class="sj openorder">${item.OrderNo}<br/><span class="gray">${item.OrderStatusM + " / " + item.OrderItemCodeM + (item.OrderLocationCodeM == "" ? "" : (" / " + item.OrderLocationCodeM))}</span></td>
	                                    <td class="tv">${item.OrderClientName + "<br/>" + item.PayClientName + "<br/>" + item.ConsignorName}</td>
	                                    <td class="callpopup">${item.OrderClientChargeName + "<br/>(" + fnMakeCellNo(item.OrderClientChargeTelNo) + ")"}</td>
	                                    <td>${item.PickupPlace + "<br/>" + fnGetStrDateFormat(item.PickupYMD, "-") + " " + fnGetHMFormat(item.PickupHM)}</td>
	                                    <td>${item.GetPlace + "<br/>" + fnGetStrDateFormat(item.GetYMD, "-") + " " + fnGetHMFormat(item.GetHM)}</td>
	                                    <td class="pay">${"&#8361; " + fnMoneyComma(item.SaleSupplyAmt) + "<br/>" + (item.SaleClosingSeqNo == "" ? "미마감" : ("마감(" + item.SaleClosingSeqNo + ")"))}</td>
	                                    <td class="callpopup">${item.PickupCarNo == "" ? "" : (item.PickupDriverName + " / " + item.PickupCarNo + "<br/>(" + fnMakeCellNo(item.PickupDriverCell) + ")")}</td>
	                                    <td class="callpopup">${item.GetCarNo == "" ? "" : (item.GetDriverName + " / " + item.GetCarNo + "<br/>(" + fnMakeCellNo(item.GetDriverCell) + ")")}</td>
	                                    <td class="callpopup">${item.AcceptAdminName + "<br/>(" + fnMakeCellNo(item.AcceptAdminTelNo) + ")"}</td>
	                                    <td class="callpopup">${item.UpdAdminName == "" ? "" : (item.UpdAdminName + "<br/>(" + fnMakeCellNo(item.UpdAdminTelNo) + ")")}</td>
	                                    <td class="senddispatch"><img src="/images/callmanager/btn_send.svg" alt="배차정보전송" title="배차정보전송" /></td>
                                    </tr>`;
                });
            } else {
                strListHtml = "<td colspan='11' class='emptydata'>조회된 오더가 없습니다.</td>";
            }

            $("#TbodyOrderListForClient").html(strListHtml);

            //매출 마감현황
            strListHtml = "";
            if (objRes.OrderSaleClosingRecordCnt > 0) {
                $.each(objRes.OrderSaleClosingList, function (index, item) {
                    strListHtml += `<tr saleclosingseqno="${item.SaleClosingSeqNo}" centercode="${item.CenterCode}">
	                                    <td class="opensale">${item.SaleClosingSeqNo}</td>
	                                    <td>${item.ClosingKindM + " / " + item.BillKindM + " / " + item.BillStatusM}</td>
	                                    <td>${fnGetStrDateFormat(item.BillWrite, "-") + " / " + fnGetStrDateFormat(item.BillYMD, "-")}</td>
	                                    <td>${item.BillChargeEmail}</td>
	                                    <td class="pay">${"&#8361; " + fnMoneyComma(item.SupplyAmt)}</td>
	                                    <td class="pay">${"&#8361; " + fnMoneyComma(item.TaxAmt)}</td>
	                                    <td>${item.CsAdminNames}</td>
	                                    <td>${item.Note}</td>
	                                    <td class="callpopup">${item.ClosingAdminName + "<br/>(" + fnMakeCellNo(item.ClosingAdminTelNo) + ")"}</td>
                                    </tr>`;
                });
            } else {
                strListHtml = "<td colspan='9' class='emptydata'>조회된 마감정보가 없습니다.</td>";
            }

            $("#TbodyOrderSaleClosingList").html(strListHtml);
        }

        if (objRes.OrderViewFlag != "Y") {
            $("#TbodyOrderListForPlace").parent("table").parent("div").parent("div").parent("div").remove();
            $("#TbodyOrderListForClient").parent("table").parent("div").parent("div").parent("div").remove();
        }

        if (objRes.SaleViewFlag != "Y") {
            $("#TbodyOrderSaleClosingList").parent("table").parent("div").parent("div").parent("div").remove();
            $("#DivClientClosing").remove();
        } 
    }

    fnSetBindEvent();
}

//이벤트 바인드
function fnSetBindEvent() {
    //오더 상세 열기
    $("td.openorder").off("click").on("click", function () {
        var strOrderNo = $(this).parent("tr").attr("orderno");
        var strOrderItemCode = $(this).parent("tr").attr("orderitemcode");
        if (typeof strOrderNo != "undefined" && typeof strOrderItemCode != "undefined") {
            var objItem = {
                "OrderNo": strOrderNo,
                "OrderItemCode": strOrderItemCode,
            }
            fnCommonOpenOrder(objItem, "");
        }
        return false;
    });

    //매출 상세 열기
    $("td.opensale").off("click").on("click", function () {
        var strCenterCode = $(this).parent("tr").attr("centercode");
        var strSaleClosingSeqNo = $(this).parent("tr").attr("saleclosingseqno");
        if (typeof strCenterCode != "undefined" && typeof strSaleClosingSeqNo != "undefined") {
            var objItem = {
                "CenterCode": strCenterCode,
                "SaleClosingSeqNo": strSaleClosingSeqNo,
            }
            fnOpenRightSubLayer("매출 마감 상세", "/TMS/ClosingSale/SaleClosingDetailList?ClosingCenterCode=" + objItem.CenterCode + "&SaleClosingSeqNo=" + objItem.SaleClosingSeqNo, "500px", "700px", "80%");
        }
        return false;
    });

    //매입전표 상세 열기
    $("td.openpurchase").off("click").on("click", function () {
        var strCenterCode = $(this).parent("tr").attr("centercode");
        var strPurchaseClosingSeqNo = $(this).parent("tr").attr("purchaseclosingseqno");
        if (typeof strCenterCode != "undefined" && typeof strPurchaseClosingSeqNo != "undefined") {
            var objItem = {
                "CenterCode": strCenterCode,
                "PurchaseClosingSeqNo": strPurchaseClosingSeqNo,
            }
            fnOpenRightSubLayer("매입 마감 상세", "/TMS/ClosingPurchase/PurchaseClosingDetailList?ClosingCenterCode=" + objItem.CenterCode + "&PurchaseClosingSeqNo=" + objItem.PurchaseClosingSeqNo, "500px", "700px", "80%");
            return false;
        }
        return false;
    });

    //전화, 문자 팝업 열기
    $("td.callpopup").off("click").on("click", function () {

        if ($("#DivConnectCall").length > 1 || $("#DivConnectCall").css("display") != "none") {
            $("#DivConnectCall > button").click();
        }

        var strText = $(this).text();

        // 전화번호 정규식 (국내용)
        var strPhoneRegex = /\b(01[016789]-?\d{3,4}-?\d{4}|0\d{1,2}-?\d{3,4}-?\d{4}|15\d{2}-?\d{4})\b/g;

        // 모든 번호 추출
        var arrPhones = strText.match(strPhoneRegex);

        if (arrPhones == null) {
            fnDefaultAlert("연락처 정보가 올바르지 않습니다.", "warning");
            return false;
        }

        fnOpenConnectCall($(this), arrPhones, "", $(this).parent("tr").attr("centercode"), $(this).parent("tr").attr("orderno"), "1");
        return false;
    });

    //오더전송
    $("td.sendorder").off("click").on("click", function () {
        var strCMJsonParam = $("#CMJsonParam").val();
        if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
            return false;
        }

        var objCMJsonParam = JSON.parse(strCMJsonParam);
        if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
            return false;
        }

        var strRcvTelNo = objCMJsonParam.SndTelNo;
        var strSndTelNo = objCMJsonParam.RcvTelNo;
        var strSMSType = "2";
        var strCenterCode = $(this).parent("tr").attr("centercode");
        var strOrderNo = $(this).parent("tr").attr("orderno");
        fnCMSendSMS(null, strRcvTelNo, strSndTelNo, strSMSType, strCenterCode, strOrderNo);
        return false;
    });

    //배차정보전송
    $("td.senddispatch").off("click").on("click", function () {
        var strCMJsonParam = $("#CMJsonParam").val();
        if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
            return false;
        }

        var objCMJsonParam = JSON.parse(strCMJsonParam);
        if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
            return false;
        }

        var strRcvTelNo = objCMJsonParam.SndTelNo;
        var strSndTelNo = objCMJsonParam.RcvTelNo;
        var strSMSType = "4";
        var strCenterCode = $(this).parent("tr").attr("centercode");
        var strOrderNo = $(this).parent("tr").attr("orderno");
        fnCMSendSMS(null, strRcvTelNo, strSndTelNo, strSMSType, strCenterCode, strOrderNo);
        return false;
    });

    //차량정보 상세
    $("td.opencar").off("click").on("click", function (event) {
        var strRefSeqNo = $(this).parent("tr").attr("refseqno");
        var strCenterCode = $(this).parent("tr").attr("centercode");
        if (typeof strRefSeqNo != "undefined" && typeof strCenterCode != "strOrderItemCode") {
            fnEditInfo(event, "Car", strRefSeqNo);
        }
        return false;
    });
}

//오른쪽 목록(수발신로그)
function fnGetResetCallLogList() {
    $("#CallTotalCnt").val("0");
    $("#CallPageNo").val("1");
    $("#DivCallList").html("");
    logBlock = true;
    fnGetCallLogList();
}

function fnGetMoreCallLogList() {
    var strTotalCnt = $("#CallTotalCnt").val();
    var strPageNo = $("#CallPageNo").val();
    var strPageSize = $("#CallPageSize").val();
    var intTotalPageCnt = 0;
    var intNextPageNo = 0;

    if (!$.isNumeric(strTotalCnt) || !$.isNumeric(strPageNo) || !$.isNumeric(strPageSize)) {
        return;
    }

    intTotalPageCnt = parseInt(strTotalCnt) / parseInt(strPageSize) + (strTotalCnt % strPageSize > 0 ? 1 : 0);
    intNextPageNo = parseInt(strPageNo) + 1;

    if (intNextPageNo <= intTotalPageCnt) {
        $("#CallPageNo").val(intNextPageNo);
        logBlock = true;
        fnGetCallLogList();
    }
}

var logBlock = false;
function fnGetCallLogList() { 

    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnGetCallLogListSuccResult";
    var strFailCallBackFunc = "fnGetCallLogListFailResult";
    var objParam = objCMJsonParam;
    objParam.CallType = "CMDetailCallLogList";
    objParam.PageSize = $("#CallPageSize").val();
    objParam.PageNo = $("#CallPageNo").val();
    objParam.CallViewFlag = $("#ChkCallViewFlag").is(":checked") ? "Y" : "";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, logBlock, strFailCallBackFunc, "", true);
}

function fnGetCallLogListSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode != 0) {
                fnGetCallLogListFailResult();
                return false;
            } 
        }

        if (objRes[0].result.ErrorCode) {
            if (objRes[0].result.ErrorCode != 0) {
                fnGetCallLogListFailResult();
                return false;
            }
        }

        fnSetCallLogList(objRes[0]);
        return false;
    } else {
        fnGetCallLogListFailResult();
        return false;
    }
}

function fnGetCallLogListFailResult() {
    fnDefaultAlert("정보 조회에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning", "window.close()");
    return false;
}

function fnSetCallLogList(objRes) {
    $("#CallTotalCnt").val(objRes.data.RecordCnt);

    if (objRes.data.list.length > 0) {
        var strHtml = "";
        $.each(objRes.data.list, function (index, item) {
            if (item.LogType == "1") { //구분변경
                var strMsg = item.Msg;
                strMsg = strMsg.replace("|", "<span class=\"");
                strMsg = strMsg.replace("|", "\"></span>");

                strHtml += "<div class=\"memo_box\">";
                strHtml += "<div class=\"memo_use\">" + item.AdminName + " <span>" + item.RegDateView + "</span></div>";
                strHtml += "<div class=\"memo_txt\">" + strMsg + "</div>";
                strHtml += "</div>";
            } else if (item.LogType == "2" || item.LogType == "3") { //메모 3은 삭제함
                strHtml += "<div class=\"memo_box\">";
                strHtml += "<div class=\"memo_use\">" + item.AdminName + " <span>" + item.RegDateView + "</span></div>";
                strHtml += "<div class=\"memo_txt\">" + item.Msg + "</div>";
                if (item.ModifyFlag == "Y") {
                    strHtml += "<div class=\"memo_btn\"><a href=\"#\" onclick=\"fnSetDelMemo('" + item.SeqNo + "'); return false;\">삭제</a></div>";
                }
                strHtml += "</div>";

            } else if (item.LogType == "4" || item.LogType == "5") { //수신, 발신
                if (item.Msg != "") {
                    strHtml += "<div class=\"memo_box phone\">";
                }

                var strMainName = item.SubMsg.substring(0, item.SubMsg.indexOf("<br/>"));
                var strName = item.SubMsg.substring(item.SubMsg.indexOf("<br/>") + 5, item.SubMsg.length);

                strHtml += "<div class=\"phone_box " + (item.LogType == "4" ? "receipt" : "outgoing") + "\">";
                //strHtml += "<div class=\"ico_tit\">" + item.LogTypeM + "<span>" + item.SubMsg + "</span></div>";
                strHtml += "<div class=\"ico_tit\">" + strMainName + "</div>";
                strHtml += "<div class=\"date_detail\"><span>" + strName + "</span><br/>" + item.RegDateView + "</div>";
                strHtml += "</div>";

                if (item.Msg != "") {
                    strHtml += "<div class=\"memo_txt\">" + item.Msg + "</div>";
                    strHtml += "</div>";
                }
            }
        });

        $("#DivCallList").append(strHtml);
    } else {
        $("#DivCallList").html("<div class=\"emptydata\">본 전화와 관련하여 기록이 필요하거나<br/>다른 직원에게 알리고 싶은 내용이 있나요?<br/></br/>메모로 간편하게 기록하고 공유해 보세요.</div>");
    }    
}

//카드에서 상세페이지로 이동
function fnGoCallDetailFromCard(event, obj) {
    if ($(obj).children("input[type='hidden']").length > 0) {
        var strCMJsonParam = $(obj).children("input[type='hidden']").val();
        if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
            return false;
        }

        fnOpenCMDetailPage(strCMJsonParam, false);
        return false;
    }
}

//정보수정페이지 이동
function fnEditInfo(e, strType, strCode) {
    e.stopPropagation();
    if (strType == "Car") {
        if (typeof strCode == "undefined") {
            var strCMJsonParam = $("#CMJsonParam").val();
            if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
                return false;
            }

            var objCMJsonParam = JSON.parse(strCMJsonParam);
            if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
                return false;
            }

            strCode = objCMJsonParam.RefSeqNo;
        }

        if (strCode == "0") {
            fnOpenRightSubLayer("차량업체 통합등록", "/TMS/Car/CarDispatchRefins?HidMode=Insert", "1024px", "700px", "80%");
        } else { 
            fnOpenRightSubLayer("차량업체 통합등록", "/TMS/Car/CarDispatchRefins?HidMode=Update&RefSeqNo=" + strCode, "1024px", "700px", "80%");
        }

    } else if (strType == "Client") {
        if (typeof strCode == "undefined") {
            var strCMJsonParam = $("#CMJsonParam").val();
            if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
                return false;
            }

            var objCMJsonParam = JSON.parse(strCMJsonParam);
            if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
                return false;
            }

            strCode = objCMJsonParam.ClientCode;
        }

        if (strCode == "0") {
            fnOpenRightSubLayer("고객사 등록", "/TMS/Client/ClientIns", "500px", "700px", "80%");
        } else {
            fnOpenRightSubLayer("고객사 수정", "/TMS/Client/ClientIns?ClientCode=" + strCode, "500px", "700px", "80%");
        }
    }
    return false;
}

//메뉴 열기
function fnGoMenuOpener(intMenuType) {
    //1: 수발신내역, 2: 메시지 전송 내역, 3: 오더현황(내수), 4: 오더현황(수출입), 5: 오더현황(통합), 6: 배차현황, 7: 매마감현황, 8: 매입마감현황, 9: 고객사조회, 10: 차량조회, 11: 업체매입마감, 12: 메모내역
    if (window.opener) {
        window.opener.fnGoMenu(intMenuType);
        return false;
    }
}

//메뉴 열기
function fnGoMenuNewTab(e, intMenuType, strParam) {
    e.stopPropagation();

    //1: 수발신내역, 2: 메시지 전송 내역, 3: 오더현황(내수), 4: 오더현황(수출입), 5: 오더현황(통합), 6: 배차현황, 7: 매출마감현황, 8: 매입마감현황, 9: 고객사조회, 10: 차량조회, 11: 업체매입마감, 12: 메모내역
    strParam = typeof strParam == "undefined" ? "" : strParam;
    strParam = strParam == null ? "" : strParam;

    if (strParam == "") {
        var strCMJsonParam = $("#CMJsonParam").val();
        if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
            return false;
        }

        var objCMJsonParam = JSON.parse(strCMJsonParam);
        if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
            return false;
        }

        if (intMenuType == 3 || intMenuType == 4) { //내수, 수출입
            if (objCMJsonParam.CallerDetailType == 31) {
                strParam = "CarNo=" + objCMJsonParam.CarNo;
            } else if (objCMJsonParam.CallerDetailType == 32 || objCMJsonParam.CallerDetailType == 33) {
                strParam = "ComCorpNo=" + objCMJsonParam.CorpNo;
            } else if (objCMJsonParam.CallerDetailType == 51 || objCMJsonParam.CallerDetailType == 52 || objCMJsonParam.CallerDetailType == 71 || objCMJsonParam.CallerDetailType == 11) {
                strParam = "ClientName=" + objCMJsonParam.ComName;
            } else if (objCMJsonParam.CallerDetailType == 53 || objCMJsonParam.CallerDetailType == 72) { //
                strParam = "PlaceName=" + objCMJsonParam.PlaceName;
            }
        } else if (intMenuType == 6) { //배차현황
            if (objCMJsonParam.CallerDetailType == 31) {
                strParam = "CarNo=" + objCMJsonParam.CarNo;
            } else if (objCMJsonParam.CallerDetailType == 32 || objCMJsonParam.CallerDetailType == 33) {
                strParam = "CarComName=" + objCMJsonParam.ComName;
            } else if (objCMJsonParam.CallerDetailType == 51 || objCMJsonParam.CallerDetailType == 52 || objCMJsonParam.CallerDetailType == 71 || objCMJsonParam.CallerDetailType == 11) {
                strParam = "ClientName=" + objCMJsonParam.ComName;
            }
        } else if (intMenuType == 7) { //매출마감현황
            if (objCMJsonParam.CallerDetailType == 51 || objCMJsonParam.CallerDetailType == 52 || objCMJsonParam.CallerDetailType == 53 || objCMJsonParam.CallerDetailType == 71 || objCMJsonParam.CallerDetailType == 11) {
                strParam = "ClientName=" + objCMJsonParam.ComName;
            }
        } else if (intMenuType == 8) { //매입마감현황
            if (objCMJsonParam.CallerDetailType == 31) {
                strParam = "DriverCell=" + objCMJsonParam.SndTelNo;
            } else if (objCMJsonParam.CallerDetailType == 32 || objCMJsonParam.CallerDetailType == 33) {
                strParam = "ComCorpNo=" + objCMJsonParam.CorpNo;
            }
        } else if (intMenuType == 11) { //업체매입마감
            if (objCMJsonParam.CallerDetailType == 51 || objCMJsonParam.CallerDetailType == 52 || objCMJsonParam.CallerDetailType == 53 || objCMJsonParam.CallerDetailType == 71 || objCMJsonParam.CallerDetailType == 11) {
                strParam = "ClientCorpNo=" + objCMJsonParam.CorpNo;
            }
        } else if (intMenuType == 1 || intMenuType == 2 || intMenuType == 12) { //수발신내역, 메시지전송내역, 메모내역
            strParam = "TelNo=" + objCMJsonParam.SndTelNo;
        } else if (intMenuType == 10) { //차량조회
            if (objCMJsonParam.CallerDetailType == 32 || objCMJsonParam.CallerDetailType == 33) {
                strParam = "ComCorpNo=" + objCMJsonParam.CorpNo;
            }
        }
    }

    var strUrl = "/?MNo=" + intMenuType;
    if (strParam != "") {
        strUrl += "&MPra=" + encodeURIComponent(strParam);
    }
    window.open(strUrl, "_blank");
    return false;
}

/*****************/
// 콜백아이콘
/*****************/
//전화
function fnCallToCaller() {
    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    var strCenterCode = objCMJsonParam.CenterCode;
    var strRcvTelNo = objCMJsonParam.SndTelNo;
    var strSndTelNo = $("#CMAdminPhoneList").val();

    if (typeof strRcvTelNo === "undefined" || strRcvTelNo == null) {
        return false;
    }

    if (typeof strSndTelNo === "undefined" || strSndTelNo == null) {
        fnDefaultAlert("발신자 전화번호가 없습니다.", "warning");
        return false;
    }

    fnCMConnectCall(null, strCenterCode, strRcvTelNo, strSndTelNo);
    return false;
}

//문자
function fnSmsToCaller() {
    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    var strRcvTelNo = objCMJsonParam.SndTelNo;
    var strSndTelNo = $("#CMAdminPhoneList").val();

    if (typeof strRcvTelNo === "undefined" || strRcvTelNo == null) {
        return false;
    }

    fnCMSendSMS(null, strRcvTelNo, strSndTelNo, 1, objCMJsonParam.CenterCode, null, null);
    return false;
}

//GPS 마지막 위치
function fnOpenLastLocation() {
    fnDefaultAlert("서비스 준비중입니다.", "info");
    return false;
}

//다시 조회
function fnCallInfo() {
    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    fnGetCMCallerInfo(null, objCMJsonParam.CenterCode, objCMJsonParam.SndTelNo, objCMJsonParam.RcvTelNo);
    return false;
}

/*****************/

/*****************/
// 분류 변경
/*****************/
function fnChangeClassType(intClassType) {
    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    if (typeof intClassType == undefined || intClassType == null) {
        return false;
    }

    if (objCMJsonParam.ClassType == intClassType) {
        fnDefaultAlert("이전 분류와 변경할 분류가 동일합니다.", "warning");
        return false;
    }

    var strConfMsg = "본 연락처의 분류를 변경하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnChangeClassTypeProc", intClassType, "fnChangeClassTypeClose");
    return false;
}

function fnChangeClassTypeProc(fnParam) {
    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnChangeClassTypeProcSuccResult";
    var strFailCallBackFunc = "fnChangeClassTypeProcFailResult";
    var objParam = {
        CallType: "CMClassifyInsert",
        CenterCode: objCMJsonParam.CenterCode,
        SndTelNo: objCMJsonParam.SndTelNo,
        ClassType: fnParam
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnChangeClassTypeProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("본 연락처의 분류가 변경되었습니다.", "info", "fnGetResetCallLogList(); fnChangeClassTypeClose('" + objRes[0].ClassType + "');");
            return false;
        } else {
            fnChangeClassTypeProcFailResult();
            return false;
        }
    } else {
        fnChangeClassTypeProcFailResult();
        return false;
    }
}

function fnChangeClassTypeProcFailResult() {
    fnDefaultAlert("분류 변경에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning", "fnChangeClassTypeClose()");
    return false;
}

function fnChangeClassTypeClose(intClassType) {
    if (typeof intClassType != "undefined") {
        $(".info_con .more li:first-child").removeClass(function (i, c) {
            return (c.match(/\bclass\S+/g) || []).join(" ");
        });
        $(".info_con .more li:first-child").addClass("class" + intClassType);
    }
    $(".info_con .more li:first-child").click();
}
/*****************/

/*****************/
//메모
/*****************/
//메모 삭제
function fnSetDelMemo(intMemoSeqNo){
    if (typeof intMemoSeqNo == "undefined" || intMemoSeqNo == "") {
        return false;
    }

    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    var strConfMsg = "메모를 삭제 하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnSetDelMemoProc", intMemoSeqNo);
    return false;
}

function fnSetDelMemoProc(intMemoSeqNo) {
    if (typeof intMemoSeqNo == "undefined" || intMemoSeqNo == "") {
        return false;
    }


    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnSetDelMemoProcSuccResult";
    var strFailCallBackFunc = "fnSetDelMemoProcFailResult";
    objCMJsonParam.CallType = "CMMemoDelete";
    objCMJsonParam.MemoSeqNo = intMemoSeqNo;

    UTILJS.Ajax.fnHandlerRequest(objCMJsonParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetDelMemoProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("메모가 삭제되었습니다.", "info", "fnGetResetCallLogList();");
            return false;
        } else {
            fnSetDelMemoProcFailResult();
            return false;
        }
    } else {
        fnSetDelMemoProcFailResult();
        return false;
    }
}

function fnSetDelMemoProcFailResult() {
    fnDefaultAlert("메모 삭제에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning");
    return false;
}

//메모 등록
function fnSetInsMemo() {
    if (!$("#CompanyMemo").val()) {
        fnDefaultAlertFocus("메모 내용을 입력하세요.", "CompanyMemo", "warning");
        return false;
    }

    var strCMJsonParam = $("#CMJsonParam").val();
    if (typeof strCMJsonParam === "undefined" || strCMJsonParam == "") {
        return false;
    }

    var objCMJsonParam = JSON.parse(strCMJsonParam);
    if (typeof objCMJsonParam === "undefined" || objCMJsonParam == null) {
        return false;
    }

    var strHandlerURL = "/TMS/CallManager/Proc/CMCallDetailHandler.ashx";
    var strCallBackFunc = "fnInsMemoProcSuccResult";
    var strFailCallBackFunc = "fnInsMemoProcFailResult";
    objCMJsonParam.CallType = "CMMemoInsert";
    objCMJsonParam.CompanyMemo = $("#CompanyMemo").val();

    UTILJS.Ajax.fnHandlerRequest(objCMJsonParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnInsMemoProcSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("메모가 등록되었습니다.", "info", "fnGetResetCallLogList(); fnResetMemo();");            
            return false;
        } else {
            fnInsMemoProcFailResult();
            return false;
        }
    } else {
        fnInsMemoProcFailResult();
        return false;
    }
}

function fnInsMemoProcFailResult() {
    fnDefaultAlert("메모 등록에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning");
    return false;
}

//메모 폼 리셋
function fnResetMemo() {
    $("#CompanyMemo").val("");
    return false;
}
/*****************/