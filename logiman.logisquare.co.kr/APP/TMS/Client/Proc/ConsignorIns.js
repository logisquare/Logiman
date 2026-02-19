var strListDataParam = "";
$(document).ready(function () {
    fnSetInitData();
    var strListData = $("#HidParam").val();
    strListDataParam = strListData.replace(/:/g, "=").replace(/,/g, "&").replace(/{/g, "").replace(/}/g, "");
});
function fnInsConsignor() {
    var strConfMsg = "";
    var strCallType = "";

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if (!$("#ConsignorName").val()) {
        fnDefaultAlertFocus("화주명을 입력하세요.", "ConsignorName", "warning");
        return;
    }

    strCallType = "Consignor" + $("#HidMode").val();
    strConfMsg = "화주를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsConsignorProc", fnParam);
    return;
}

function fnInsConsignorProc(fnParam) {
    var strHandlerURL = "/APP/TMS/Client/Proc/ConsignorHandler.ashx";
    var strCallBackFunc = "fnAjaxInsConsignor";

    var objParam = {
        CallType: fnParam,
        ConsignorCode: $("#ConsignorCode").val(),
        CenterCode: $("#CenterCode").val(),
        ConsignorName: $("#ConsignorName").val(),
        ConsignorNote: $("#ConsignorNote").val(),
        UseFlag: "Y"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);

}

function fnAjaxInsConsignor(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        var msg = "화주 " + ($("#HidMode").val() === "Update" ? "수정" : "등록") + "에 성공하였습니다.";
        fnDefaultAlert(msg, "success", "fnLocationUpdateMode", data[0].ConsignorCode);
    }
}

function fnLocationUpdateMode(ConsignorCode) {
    if ($("#HidMode").val() === "Insert") {
        location.href = "/APP/TMS/Client/ConsignorIns?HidMode=Update&ConsignorCode=" + ConsignorCode + "&HidParam=" + $("#HidParam").val();
        return;
    }
}

function fnSetInitData() {
    if ($("#HidMode").val() === "Update") {
        fnCallConsignorDetail();
    }
}

function fnCallConsignorDetail() {

    var strHandlerURL = "/APP/TMS/Client/Proc/ConsignorHandler.ashx";
    var strCallBackFunc = "fnDetailSuccResult";
    var strFailCallBackFunc = "fnDetailFailResult";

    var objParam = {
        CallType: "ConsignorList",
        ConsignorCode: $("#ConsignorCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnDetailSuccResult(objRes) {
    console.log(objRes);
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnDetailFailResult();
            return false;
        }

        var Item = objRes[0].data.list[0];

        $("#CenterCode").val(Item.CenterCode);
        $("#CenterCode option").not(":selected").attr("disabled", "disabled");
        $("#CenterCode").addClass("read");
        $("#ConsignorName").val(Item.ConsignorName);
        $("#ConsignorNote").val(Item.ConsignorNote);
    }
    else {
        fnDetailFailResult();
    }
}

function fnDetailFailResult() {
    parent.fnReloadPageNotice("데이터를 불러올 수 없습니다.");
}

function fnListBack() {
    location.href = "/APP/TMS/Client/ConsignorList?" + strListDataParam;
}