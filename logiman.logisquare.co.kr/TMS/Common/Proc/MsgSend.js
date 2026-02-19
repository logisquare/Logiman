$(document).ready(function () {
    fnSetInitAutoComplete();
    fnGetSmsContentList();

    if ($("#OrderType").val() === "2") { //오더정보
        fnGetOrderDetail();
    } else if ($("#OrderType").val() === "3") { //머핀트럭 다운로드 안내
        fnGetMuffinDownload();
    } else if ($("#OrderType").val() === "4") { //배차정보전송
        fnGetOrderDispatchDetail();
    }

    if (!$("#RcvTelNo").val() && $("#OrderNo").val()) {
        fnGetDriverCell();
    }

    if ($("#RcvTelNo").val()) {
        var strRcvTelNo = $("#RcvTelNo").val().replace(/-/g, '');
        var strCellText = "<li onclick='fnCelListDel(this);'><input type='hidden' id='CellAdd_" + strRcvTelNo + "' name='DriverCells' value='" + strRcvTelNo + "'/>" + fnMakeCellNo(strRcvTelNo) + "<span><img src='/images/icon/minus_icon.png' alt=''></span></li>";        
        $("#CellList").html(strCellText);
    }

    fnSetCMAdminPhoneList("SmsSendCell", $("#SndTelNo").val(), "[C] ", false);
});

function fnSetInitAutoComplete() {
    //차량번호 검색
    if ($("#CarNo").length > 0) {
        fnSetAutocomplete({
            formId: "CarNo",
            width: 800,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Common/Proc/MsgSendHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "CarDispatchRefSearch",
                    CenterCode: $("#CenterCode").val(),
                    CarNo: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if ($("#CenterCode").val() === "") {
                        fnDefaultAlert("회원사를 선택해주세요.", "warning");
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
                    if ($("#CellAdd_" + ui.item.etc.DriverCell + "").val() == ui.item.etc.DriverCell.replace(/-/g, "")) {
                        fnDefaultAlert("이미 추가 된 번호입니다.", "warning");
                        return;
                    }

                    $("#CellList").prepend("<li onclick='fnCelListDel(this);' title='목록에서 제거'><input type='hidden' id='CellAdd_" + ui.item.etc.DriverCell + "' name='DriverCells' value='" + ui.item.etc.DriverCell.replace(/-/gi, "") + "' />" + ui.item.etc.DriverCell.replace(/-/gi, "") + "<span><img src='/images/icon/minus_icon.png' alt=''></span></li>");
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("CarDispatchRef", ul, item);
                }
            }
        });
    }
}

function fnGetOrderDetail() {
    if ($("#OrderNo").val() != "" && $("#CenterCode").val() != "") {
        var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
        var strCallBackFunc = "fnGridAllOrderSuccResult";

        var objParam = {
            CallType: "AllOrderList",
            CenterCode: $("#CenterCode").val(),
            OrderNo: $("#OrderNo").val()
        };

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    }
}

function fnGridAllOrderSuccResult(objRes) {
    var strSmsText = "";
    if (objRes[0].data.RecordCnt > 0) {
        var OrderClientName = objRes[0].data.list[0].OrderClientName; //포워더(발주처)
        var ConsignorName = objRes[0].data.list[0].ConsignorName; //화주명
        var PickupPlace = objRes[0].data.list[0].PickupPlace; //상차지
        var PickupPlaceChargeTelNo = objRes[0].data.list[0].PickupPlaceChargeTelNo; //상차지 담당자 전화번호
        var PickupPlaceChargeCell = objRes[0].data.list[0].PickupPlaceChargeCell; //상차지 담당자 휴대폰
        var PickupPlaceChargeName = objRes[0].data.list[0].PickupPlaceChargeName; //상차지 담당자 이름
        var PickupPlaceAddr = objRes[0].data.list[0].PickupPlaceAddr; //상차지 주소
        var PickupPlaceAddrDtl = objRes[0].data.list[0].PickupPlaceAddrDtl; //상차지 상세주소
        var PickupHM = objRes[0].data.list[0].PickupHM;  //상차시간
        var Nation = objRes[0].data.list[0].Nation;  //목적국
        var Volume = objRes[0].data.list[0].Volume;  //수량
        var Weight = objRes[0].data.list[0].Weight;  //중량
        var CBM = objRes[0].data.list[0].CBM;  //부피
        var GoodsItemCodeM = objRes[0].data.list[0].GoodsItemCodeM;  //품목
        var Quantity = objRes[0].data.list[0].Quantity;  //대량화물
        var GetPlace = objRes[0].data.list[0].GetPlace;  //하차지
        var GetYMD = objRes[0].data.list[0].GetYMD;  //하차일
        var GetHM = objRes[0].data.list[0].GetHM; //하차일시
        var GetPlaceAddr = objRes[0].data.list[0].GetPlaceAddr;  //하차주소
        var GetPlaceAddrDtl = objRes[0].data.list[0].GetPlaceAddrDtl;  //하차상세주소
        var GetPlaceChargeName = objRes[0].data.list[0].GetPlaceChargeName; //하차상세주소
        var GetPlaceChargeCell = objRes[0].data.list[0].GetPlaceChargeCell;  //하차상세주소
        var GetPlaceChargeTelNo = objRes[0].data.list[0].GetPlaceChargeTelNo;  //하차상세주소
        var PickupPlaceNote = objRes[0].data.list[0].PickupPlaceNote;  //하차상세주소
        var GetPlaceNote = objRes[0].data.list[0].GetPlaceNote;  //하차상세주소
        var BLNo = objRes[0].data.list[0].Hawb;  //BLNo

        strSmsText += "포워더 : " + OrderClientName;
        strSmsText += "\n화주/상차지 : " + ConsignorName + "/" + PickupPlace;
        strSmsText += "\n담당자 : " + PickupPlaceChargeTelNo + "/" + PickupPlaceChargeName;
        strSmsText += "\n담당자HP : " + PickupPlaceChargeCell;
        strSmsText += "\n주소 : " + PickupPlaceAddr + " " + PickupPlaceAddrDtl;
        strSmsText += "\n픽업시간 : " + PickupHM;
        strSmsText += "\n상차지 전달사항 : " + PickupPlaceNote;
        strSmsText += "\n";
        strSmsText += "\n목적국 : " + Nation;
        strSmsText += "\n화물 : " + Volume + "개 " + Weight + "kg " + CBM + "cbm " + GoodsItemCodeM + " " + Quantity;
        strSmsText += "\n";
        strSmsText += "\n하차 : " + GetYMD + " " + GetHM;
        strSmsText += "\n하차지 : " + GetPlace;
        strSmsText += "\n주소 : " + GetPlaceAddr + " " + GetPlaceAddrDtl;
        strSmsText += "\n담당자 : " + GetPlaceChargeCell + "/" + GetPlaceChargeName;
        strSmsText += "\n담당자HP : " + GetPlaceChargeTelNo;
        strSmsText += "\n";
        
        strSmsText += "\n하차지 전달사항 : " + GetPlaceNote;
        strSmsText += "\nB/L : " + BLNo;

        $("#SmsContents").val(strSmsText);
    }
}

function fnGetMuffinDownload() {
    var strSmsText = "";
    strSmsText = "안녕하세요.\n";
    strSmsText += $("#CenterCode option:selected").text() + "입니다.";
    strSmsText += "\n오더정보 확인을 위해 머핀트럭을 다운로드하여 연동해주세요.";
    strSmsText += "\n■ 머핀트럭 다운로드";
    strSmsText += "\nhttps://play.google.com/store/apps/details?id=com.ske.muffintruck";
    strSmsText += "\n\n오더 내역 확인부터  운송료 카드청구까지  상용차 전용 플랫폼  ‘머핀트럭’";
    $("#SmsContents").val(strSmsText);
}

function fnGetOrderDispatchDetail() {
    if ($("#OrderNo").val() != "" && $("#CenterCode").val() != "") {
        var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
        var strCallBackFunc = "fnGetOrderDispatchDetailSuccResult";

        var objParam = {
            CallType: "AllOrderList",
            CenterCode: $("#CenterCode").val(),
            OrderNo: $("#OrderNo").val()
        };

        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    }
}

function fnGetOrderDispatchDetailSuccResult(objRes) {
    var strSmsText = "";
    if (objRes[0].data.RecordCnt > 0) {
        var objItem = objRes[0].data.list[0];
        strSmsText += "[배차정보]\n";
        strSmsText += "차량번호: " + objItem.DispatchCarNo1 + "\n";
        strSmsText += "기사명: " + objItem.DriverName1 + "\n";
        strSmsText += "연락처: " + fnMakeCellNo(objItem.DriverCell1) + "\n";
        strSmsText += "상차일시: " + fnGetStrDateFormat(objItem.PickupYMD, "-") + " " + fnGetHMFormat(objItem.PickupHM) + "\n";
        strSmsText += "상차지명: " + objItem.PickupPlace;
        $("#SmsContents").val(strSmsText);
    }
}

function fnCellAddIns() {
    var obj_val = $("#RcvCell").val();
    if (!obj_val) {
        fnDefaultAlertFocus("휴대폰번호를 입력하세요.", "RcvCell", "warning");
        return;
    }

    if ($("#CellAdd_" + obj_val + "").val() == obj_val.replace(/-/g, "")) {
        fnDefaultAlertFocus("이미 추가 된 번호입니다.", "RcvCell", "warning");
        return;
    }
    $("#CellList").prepend("<li onclick='fnCelListDel(this);'><input type='hidden' id='CellAdd_" + obj_val + "' name='DriverCells' value='" + obj_val.replace(/-/g, '') + "'/>" + obj_val + "<span><img src='/images/icon/minus_icon.png' alt=''></span></li>");
    $("#RcvCell").val("");
    $("#RcvCell").focus();

}

function fnCelListDel(obj) {
    obj.remove();
}

function fnGetSmsContentList() {
    var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "SmsContentList",
        SmsTitle: $("#SearchSmsTitle").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridSuccResult(objRes) {
    $("#SmsContentList li").remove();
    if (objRes[0].data.RecordCnt > 0) {
        for (var i = 0; i < objRes[0].data.RecordCnt; i++) {
            $("#SmsContentList").append("<li><strong onclick='fnSmsView(" + objRes[0].data.list[i].SmsSeqNo + ");'>" + objRes[0].data.list[i].SmsTitle + "</strong> <a href = 'javascript:fnSmsDelConfirm(" + objRes[0].data.list[i].SmsSeqNo + ")'> <img src='/images/icon/minus_icon.png' alt=''></a></li >");
        }
    } else {
        $("#SmsContentList").html("<li style='text-align:center;'>즐겨찾기 목록이 없습니다.</li>");
    }
}

function fnSmsContentConfirm() {

    if ($("#SmsTitle").val() === "") {
        fnDefaultAlertFocus("제목을 입력해주세요.", "SmsTitle", "warning");
        return;
    }
    if ($("#SmsContents").val() === "") {
        fnDefaultAlertFocus("내용을 입력해주세요.", "SmsContents", "warning");
        return;
    }
    if ($("#SmsSendCell").val() === "") {
        fnDefaultAlertFocus("등록된 발신자 번호가 없습니다..", "SmsSendCell", "warning");
        return;
    }

    var objParam = {
        CallType: "SmsContentIns",
        SmsTitle: $("#SmsTitle").val(),
        SmsContent: $("#SmsContents").val(),
        SmsSendCell: $("#SmsSendCell").val(),
    };

    fnDefaultConfirm("즐겨찾기로 등록하시겠습니까?", "fnSmsContentIns", objParam);
}

function fnSmsContentIns(objParam) {
    var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
    var strCallBackFunc = "fnGridInsSuccResult";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridInsSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "error");
        return;
    } else {
        fnDefaultAlert("등록되었습니다.", "success");
        fnGetSmsContentList();
        return;
    }
}

function fnSmsView(SeqNo) {
    var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
    var strCallBackFunc = "fnSmsViewSuccResult";

    var objParam = {
        CallType: "SmsContentList",
        SmsSeqNo: SeqNo,
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnSmsViewSuccResult(objRes) {
    
    if (objRes[0].data.RecordCnt > 0) {
        $("#SmsTitle").val(objRes[0].data.list[0].SmsTitle);
        $("#SmsContents").val(objRes[0].data.list[0].SmsContent);
    }
}

function fnSmsDelConfirm(SeqNo) {
    if (SeqNo == "") {
        fnDefaultAlert("일련번호 정보가 없습니다.", "warning");
        return;
    }
    var objParam = {
        CallType: "SmsContentDel",
        SmsSeqNo: SeqNo,
    };

    fnDefaultConfirm("즐겨찾기를 삭제하시겠습니까?", "fnSmsDel", objParam);
    return;
}

function fnSmsDel(objParam) {
    var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
    var strCallBackFunc = "fnSmsDelSuccResult";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnSmsDelSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "error");
        return;
    } else {
        fnDefaultAlert("삭제되었습니다.", "success");
        fnGetSmsContentList();
        return;
    }
}

var UpdRowsCnt = 0;
var UpdRowsCompleteCnt = 0;
var UpdRowsFailCnt = 0;
var UpdRows;
var UpdErrMsg = "";
var i = 0;

function fnSendSms() {
    var strDriverCellAdd = [];
    
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return;
    }

    if ($("#SmsSendCell").val() === "") {
        fnDefaultAlertFocus("발신번호를 선택해주세요.", "SmsSendCell", "warning");
        return;
    }

    if ($("input[name='DriverCells']").length == 0) {
        fnDefaultAlertFocus("수신자 휴대폰번호 추가하세요.", "RcvCell", "warning");
        return false;
    }

    if ($("#SmsContents").val() === "") {
        fnDefaultAlertFocus("내용을 입력해주세요.", "SmsContents", "warning");
        return;
    }

    if ($("input[name='DriverCells']").length > 0) {
        strDriverCellAdd = $("input[name='DriverCells']").map(function () {
            return $(this).val();
        }).get().join(",");
    }

    UpdRows = strDriverCellAdd.split(",");
    UpdRowsCnt = UpdRows.length;

    fnDefaultConfirm("해당 내용으로 문자를 전송하시겠습니까?", "fnSendSmsCall", "");
}


function fnSendSmsCall() {

    if (UpdRowsCnt <= 0) {
        if (UpdRowsFailCnt > 0) {
            fnDefaultAlert("일부 수신자번호로 전송하지 못했습니다.<br>(" + UpdErrMsg + ")", "warning");
            return;
        } else {
            fnDefaultAlert(UpdRowsCompleteCnt + "건의 수신번호로 발송되었습니다.", "success");
            return;
        }
    }

    var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
    var strCallBackFunc = "fnSmsCallSuccResult";

    if ($("#SmsSendCell option:selected").text().indexOf("[C]") > -1) {
        var objParam = {
            CallType: "CMSendSms",
            CenterCode: $("#CenterCode").val(),
            SmsTitle: $("#SmsTitle").val(),
            SmsContent: $("#SmsContents").val(),
            SndTelNo: $("#SmsSendCell").val(),
            RcvTelNo: UpdRows[UpdRowsCnt - 1],
            MobileFlag: isMobilePhone($("#SmsSendCell").val()) ? "Y" : "N"
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    } else {
        var objParam = {
            CallType: "SendSms",
            CenterCode: $("#CenterCode").val(),
            SmsTitle: $("#SmsTitle").val(),
            SmsContent: $("#SmsContents").val(),
            SmsSendCell: $("#SmsSendCell").val(),
            DriverCells: UpdRows[UpdRowsCnt - 1]
        };
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    }
}

function fnSmsCallSuccResult(data) {
    if (data[0].RetCode !== 0) {
        UpdErrMsg = data[0].ErrMsg;
        UpdRowsCnt--;
        UpdRowsFailCnt++;
        fnSendSmsCall();
    } else {
        UpdRowsCnt--;
        UpdRowsCompleteCnt++;
        fnSendSmsCall()
    }

}

function fnGetDriverCell() {
    var strHandlerURL = "/TMS/Common/Proc/MsgSendHandler.ashx";
    var strCallBackFunc = "fnDriverCellSuccResult";

    var objParam = {
        CallType: "DriverCellList",
        CenterCode : $("#CenterCode").val(),
        OrderNos: $("#OrderNo").val(),
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnDriverCellSuccResult(data) {
    var strCellText = "";
    $("#CellList").prepend("");
    if (data[0].data.RecordCnt > 0) {
        for (var i = 0; i < data[0].data.RecordCnt; i++) {
            strCellText += "<li onclick='fnCelListDel(this);'><input type='hidden' id='CellAdd_" + data[0].data.list[i].DriverCell + "' name='DriverCells' value='" + data[0].data.list[i].DriverCell.replace(/-/g, '') + "'/>" + data[0].data.list[i].DriverCell + "<span><img src='/images/icon/minus_icon.png' alt=''></span></li>"
        }
    }
    $("#CellList").html(strCellText);
}
