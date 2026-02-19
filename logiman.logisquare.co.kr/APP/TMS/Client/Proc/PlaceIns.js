var strListDataParam = "";
$(document).ready(function () {
    if ($("#Mode").val() === "Insert") {
        $("#PopMastertitle").text("상하차지 등록");
    } else {
        SetInitData(); //수정시 기본세팅
        $("#PopMastertitle").text("상하차지 수정");
        $("#BtnReg").hide();
        $("#BtnUpd").show();
        $("#BtnChargeReg").show();
        $("#BtnChargeDel").show();
    }

    //우편번호 검색
    $("#BtnSearchAddrPickupPlace").on("click", function (e) {
        e.preventDefault();
        fnOpenAddress("Place");
        return false;
    });

    var strListData = $("#HidParam").val();
    strListDataParam = strListData.replace(/:/g, "=").replace(/,/g, "&").replace(/{/g, "").replace(/}/g, "");
});


function SetInitData() {
    if ($("#Mode").val() === "Update") {
        $("#CenterCode").addClass("read").removeClass("essential");
        $("#PlaceName").attr("readonly", true).removeClass("essential");
        $("#PlacePost").removeClass("essential");
        $("#PlaceAddr").removeClass("essential");
        $("#Sido").attr("readonly", true);
        $("#Gugun").attr("readonly", true);
        $("#Dong").attr("readonly", true);
        $("#BtnPlaceNameChk").hide();

        fnCallClientPlaceDetail();
    } else {
        $("#ChargeName").removeClass("essential");
    }
}

function fnCallClientPlaceDetail() {

    var strHandlerURL = "/APP/TMS/Client/Proc/PlaceHandler.ashx";
    var strCallBackFunc = "fnDetailSuccResult";
    var strFailCallBackFunc = "fnDetailFailResult";

    var objParam = {
        CallType: "PlaceList",
        PlaceSeqNo: $("#PlaceSeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnDetailSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnDetailFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];

        //hidden
        $.each($("input[type='hidden']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //textbox
        $.each($("input[type='text']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //textarea
        $.each($("textarea"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //select
        $.each($("select"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id")) + "']").length > 0) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });
        $("#CenterCode option:not(:selected)").prop("disabled", true);

        $("#PlaceSido").val(item.Sido);
        $("#PlaceSigungu").val(item.Gugun);
        $("#PlaceDong").val(item.Dong);

        if (item.UseFlag === "Y") {
            $("#UseFlagY").prop("checked", true);
            $("#UseFlagN").prop("checked", false);
        } else {
            $("#UseFlagY").prop("checked", false);
            $("#UseFlagN").prop("checked", true);
        }

        $("#HidPlaceNameChk").val("Y");
        //담당자 목록 조회
        fnCallChargeGridData();
    }
    else {
        fnDetailFailResult();
    }
}

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallChargeGridData() {

    var strHandlerURL = "/APP/TMS/Client/Proc/PlaceHandler.ashx";
    var strCallBackFunc = "fnChargeGridSuccResult";

    var objParam = {
        CallType: "ChargeList",
        PlaceSeqNo: $("#PlaceSeqNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnChargeGridSuccResult(objRes) {
    var strSelOption = "";
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert("담당자 정보를 불러오지 못했습니다.", "error")
            return false;
        } else {
            if (objRes[0].data.RecordCnt > 0) {
                strSelOption += "<option value=\"\">담당자 선택</option>";
                for (var i = 0; i < objRes[0].data.list.length; i++) {
                    strSelOption += "<option value=\"" + objRes[0].data.list[i].SeqNo + "\">" + objRes[0].data.list[i].ChargeName + "(" + objRes[0].data.list[i].ChargePosition + "/" + objRes[0].data.list[i].ChargeCell  + ")</option>"
                }
                
                $("#PlaceChargeList").html(strSelOption);
            }
        }
    }
}

function fnPlaceNameChk() {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요,", "CenterCode", "warning");
        return;
    }

    if ($("#PlaceName").val() === "") {
        fnDefaultAlertFocus("상/하차지명을 입력해주세요,", "PlaceName", "warning");
        return;
    }

    var strHandlerURL = "/APP/TMS/Client/Proc/PlaceHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "PlaceList",
        PlaceSearchType : "1",
        CenterCode: $("#CenterCode").val(),
        PlaceName: $("#PlaceName").val()
    };
    
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridSuccResult(objRes) {
    if (objRes[0].data.RecordCnt > 0) {
        fnDefaultAlertFocus("이미 등록된 상하차지명입니다.(현재 " + objRes[0].data.list[0].UseFlagM + ")", "PlaceName", "warning");
        return;
    } else {
        $("#PlaceName").attr("readonly", true);
        $("#BtnPlaceNameChk").hide();
        $("#BtnPlaceNameReset").show();
        $("#PlaceAddrDtl").focus();
        $("#HidPlaceNameChk").val("Y");
    }
}

function fnPlaceNameReset() {
    $("#PlaceName").attr("readonly", false);
    $("#BtnPlaceNameChk").show();
    $("#BtnPlaceNameReset").hide();
    $("#PlaceName").focus();
    $("#PlaceName").val("");
    $("#HidPlaceNameChk").val("");
}

function fnClientPlaceChargeInsConfirm() {
    var strConfMsg = "";
    var strCallType = "";
    if (fnInsValidCheck()) {
        strCallType = "ClientPlaceCharge" + $("#Mode").val();
        strConfMsg = "상하차지를 " + ($("#Mode").val() === "Update" ? "수정" : "등록");
        strConfMsg += "하시겠습니까?";

        var fnParam = strCallType;
        fnDefaultConfirm(strConfMsg, "fnClientPlaceChargeIns", fnParam);
        return;
    }
}

function fnClientPlaceChargeIns(fnParam) {
    var strHandlerURL = "/APP/TMS/Client/Proc/PlaceHandler.ashx";
    var strCallBackFunc = "fnAjaxInsClientPlaceChargeIns";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        PlaceSeqNo: $("#PlaceSeqNo").val(),
        PlaceName: $("#PlaceName").val(),
        PlacePost: $("#PlacePost").val(),
        PlaceAddr: $("#PlaceAddr").val(),
        PlaceAddrDtl: $("#PlaceAddrDtl").val(),
        Sido: $("#PlaceSido").val(),
        Gugun: $("#PlaceSigungu").val(),
        Dong: $("#PlaceDong").val(),
        ChargeName: $("#ChargeName").val(),
        ChargePosition: $("#ChargePosition").val(),
        ChargeTelExtNo: $("#ChargeTelExtNo").val(),
        ChargeTelNo: $("#ChargeTelNo").val(),
        ChargeCell: $("#ChargeCell").val(),
        ChargeNote: $("#ChargeNote").val(),
        UseFlag: "Y"
    };
    
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsClientPlaceChargeIns(data) {

    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {

        var strConfMsg = "";
        var strCallType = "";
        strConfMsg = $("#Mode").val() === "Update" ? "수정" : "등록";
        strConfMsg += " 성공하였습니다.";

        fnDefaultAlert(strConfMsg, "success", "fnLocationUpdateMode", data[0].PlaceSeqNo);
    }

    $("#divLoadingImage").hide();
}

function fnLocationUpdateMode(PlaceSeqNo) {
    if ($("#Mode").val() === "Insert") {
        location.href = "/APP/TMS/Client/PlaceIns?Mode=Update&PlaceSeqNo=" + PlaceSeqNo + "&HidParam=" + $("#HidParam").val();
        return;
    }
}

function fnInsValidCheck() {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if ($("#PlaceName").val() === "") {
        fnDefaultAlertFocus("상하차지명을 입력하세요.", "PlaceName", "warning");
        return false;
    }

    if ($("#PlacePost").val() === "") {
        fnDefaultAlertFocus("우편번호가 누락되었습니다.", "PlacePost", "warning");
        return false;
    }

    if ($("#PlaceAddr").val() === "") {
        fnDefaultAlertFocus("상하차지 주소를 검색해주세요.", "PlaceAddr", "warning");
        return false;
    }

    if ($("#HidPlaceNameChk").val() !== "Y") {
        fnDefaultAlertFocus("상차지명 중복확인해주세요.", "PlaceName", "warning");
        return false;
    }

    return true;
}

/*담당자 등록*/
function fnChargeInsConfirm() {
    if ($("#ChargeName").val() === "") {
        fnDefaultAlertFocus("담당자명은 필수입니다.", "ChargeName", "warning");
        return;
    }

    var strConfMsg = "";
    var strCallType = "";
    strCallType = "ChargeInsert";
    strConfMsg = "담당자를 추가 하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnChargeIns", fnParam);
    return;
}

function fnChargeIns(fnParam) {
    var strHandlerURL = "/APP/TMS/Client/Proc/PlaceHandler.ashx";
    var strCallBackFunc = "fnAjaxInsChargeIns";

    var objParam = {
        CallType: fnParam,
        PlaceSeqNo: $("#PlaceSeqNo").val(),
        ChargeSeqNo: $("#SeqNo").val(),
        ChargeName: $("#ChargeName").val(),
        ChargePosition: $("#ChargePosition").val(),
        ChargeTelExtNo: $("#ChargeTelExtNo").val(),
        ChargeTelNo: $("#ChargeTelNo").val(),
        ChargeCell: $("#ChargeCell").val(),
        ChargeNote: $("#ChargeNote").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsChargeIns(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {

        var strConfMsg = "";
        strConfMsg = "추가 되었습니다";

        fnDefaultAlert(strConfMsg, "success", "fnCallChargeGridData");
        fnChargeReset("Charge");
        fnCallChargeGridData();
    }
    $("#divLoadingImage").hide();
}

function fnChargeReset(name) {
    $("#" + name + "Name").val("");
    $("#" + name + "Position").val("");
    $("#" + name + "TelExtNo").val("");
    $("#" + name + "TelNo").val("");
    $("#" + name + "Cell").val("");
    $("#" + name + "Note").val("");
    $("#" + name + "Name").focus();
}

function fnChargeDelConfirm() {
    
    if ($("#PlaceChargeList").val() === "") {
        fnDefaultAlert("담당자를 선택해주세요.", "warning");
        return;
    }

    var strConfMsg = "";
    var strCallType = "";
    strCallType = "ChargeDelete";
    strConfMsg = "담당자를 삭제 하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnChargeDel", fnParam);
    return;
}

function fnChargeDel(fnParam) {

    var strHandlerURL = "/TMS/ClientPlace/Proc/ClientPlaceChargeHandler.ashx";
    var strCallBackFunc = "fnAjaxDelCharge";

    var objParam = {
        CallType: fnParam,
        CenterCode: $("#CenterCode").val(),
        PlaceSeqNo: $("#PlaceSeqNo").val(),
        SeqNos1: $("#PlaceChargeList").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxDelCharge(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {

        var strConfMsg = "";
        strConfMsg = "삭제 되었습니다.";

        fnDefaultAlert(strConfMsg, "success");
        fnCallChargeGridData();
    }
    $("#divLoadingImage").hide();
}


function fnListBack() {
    location.href = "/APP/TMS/Client/PlaceList?" + strListDataParam;
}