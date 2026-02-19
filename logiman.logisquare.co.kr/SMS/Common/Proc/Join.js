var CardAgreeExists = "N";

$(document).ready(function () {
    fnSetInit();
});

function fnSetInit() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Common/Proc/SmsCommonHandler.ashx";
    var strCallBackFunc = "fnSetInitSuccResult";
    var strFailCallBackFunc = "fnSetInitFailResult";

    var objParam = {
        CallType: "ParamChk",
        No: $("#No").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetInitSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            if (objRes[0].CorpNoChkPassFlag !== "Y") {
                if (objRes[0].ComCorpNoChkFlag !== "Y") {
                    fnSetInitFailResult("사업자번호 체크 후 이용이 가능합니다.");
                    return false;
                }

                if (objRes[0].ComCorpNoChkTimeOutFlag === "Y") {
                    fnSetInitFailResult("사업자번호 체크 후 1시간이 초과하여 이용이 불가능합니다.");
                    return false;
                }
            }

            CardAgreeExists = objRes[0].CardAgreeExists;

            fnGetBillInfo();
        } else {
            fnSetInitFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetInitFailResult();
        return false;
    }
}

function fnSetInitFailResult(msg) {

    if (typeof msg !== "string") {
        msg = "";
    }
    fnGoError(msg);
    return false;
}

function fnGetBillInfo() {
    if (!$("#No").val()) {
        fnDefaultAlert("올바르지 않은 접근입니다.", "info", "fnPopupClose()");
        return false;
    }

    var strHandlerUrl = "/SMS/Common/Proc/SmsCommonHandler.ashx";
    var strCallBackFunc = "fnGetBillInfoSuccResult";
    var strFailCallBackFunc = "fnGetBillInfoFailResult";

    var objParam = {
        CallType: "SmsPurchaseClosingList",
        No: $("#No").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnGetBillInfoSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnGetBillInfoFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnGetBillInfoFailResult("전표정보를 찾을 수 없습니다.");
            return false;
        }

        var item = objRes[0].data.list[0];
        $("#ComName").text(item.ComName);
        $("#ComCorpNo").text(item.ComCorpNo);
        $("#ComCeoName").text(item.ComCeoName);
        $("#DriverCell").text(item.DriverCell.substr(0, 3) + "-****-" + item.DriverCell.substr(7, 4)) ;
    } else {
        fnGetBillInfoFailResult();
        return false;
    }
}

function fnGetBillInfoFailResult(msg) {

    if (typeof msg !== "string") {
        msg = "";
    }

    fnGoError(msg);
    return false;
}


//약관보기
function fnAgreeView(type) {
    if (type == 1) {
        $("div.agree1").toggle();
    } else if (type == 2) {
        $("div.agree2").toggle();
    } else if (type == 3) {
        $("div.agree3").toggle();
    }
}

function fnJoin() {
    if (!$("#check").is(":checked")) {
        fnDefaultAlert("약관 동의 후 인증이 가능합니다.", "info");
        return false;
    }

    fnDefaultConfirm("사용자 인증을 진행하시겠습니까?", "fnJoinProc", "");
}

function fnJoinProc() {
    var strHandlerUrl = "/SMS/Common/Proc/SmsCommonHandler.ashx";
    var strCallBackFunc = "fnJoinSuccResult";
    var strFailCallBackFunc = "fnJoinFailResult";

    var objParam = {
        CallType: "UpdAgreement",
        No: $("#No").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnJoinSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnJoinFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        $(".auth_area").hide();
        $(".auth_btn2").hide();
        $(".fast_area").hide();
        fnGoReturn("사용자 인증이 완료되었습니다.");
    } else {
        fnJoinFailResult();
        return false;
    }
}

function fnJoinFailResult(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }else {
        msg = " (" + msg + ")";
    }
    fnDefaultAlert("나중에 다시 시도해주세요." + msg);
    return false;
}

function fnGoReturn(strMsg) {
    if (typeof strMsg === "string") {
        fnDefaultAlert(strMsg, "info", "fnGoAction()");
        return false;
    } else {
        fnGoAction();
        return false;
    }
}

function fnGoAction() {
    var url = $("#RetUrl").val() + "?No=" + encodeURIComponent($("#No").val());
    document.location.replace(url);
    return false;
}