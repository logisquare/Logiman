$(document).ready(function () {
    fnSetInitData();
    $("#CenterCode").on("change", function () {
        $("#ClientName").val("");
        $("#ClientCode").val("");
    });

    //고객사명
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Network/Proc/OrderNetworkRuleHandler.ashx";
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
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ClientName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#ClientCode").val(ui.item.etc.ClientCode);
                    $("#ClientName").val(ui.item.etc.ClientName);
                    $("#RenewalModMinute").focus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                }
            }
        });
    }
});

function fnSetInitData() {
    if ($("#HidMode").val() === "Update") {
        fnCallNetworkRuleDetail();
    }
}

function fnCallNetworkRuleDetail() {

    var strHandlerURL = "/TMS/Network/Proc/OrderNetworkRuleHandler.ashx";
    var strCallBackFunc = "fnDetailSuccResult";
    var strFailCallBackFunc = "fnDetailFailResult";

    var objParam = {
        CallType: "NetworkRuleList",
        RuleSeqNo: $("#RuleSeqNo").val()
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
        $("#CenterCode").addClass("read");
        $("#ClientName").attr("readonly", true);
        $("#NetworkKind option:not(:selected)").prop("disabled", true);
        $("#NetworkKind").addClass("read");
        $("#BtnNetworkRule").text("수정");
        $("#RenewalIntervalPrice").val(UTILJS.Util.fnComma($("#RenewalIntervalPrice").val()));
        
    }
    else {
        fnDetailFailResult();
    }
}

function fnDetailFailResult() {
    parent.fnReloadPageNotice("데이터를 불러올 수 없습니다.");
}

function fnNetworkRuleConfirm() {
    var strConfMsg = "";
    var strCallType = "";

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return;
    }
   
    if ($("#ClientCode").val() === "") {
        fnDefaultAlertFocus("고객사를 검색해주세요.", "ClientName", "warning");
        return;
    }

    if ($("#RenewalModMinute").val() === "") {
        fnDefaultAlertFocus("수정주기(분)을 입력해주세요.", "RenewalModMinute", "warning");
        return;
    }

    if ($("#RenewalStartMinute").val() === "") {
        fnDefaultAlertFocus("증액시작시간(분)을 입력해주세요.", "RenewalStartMinute", "warning");
        return;
    }

    if ($("#RenewalIntervalMinute").val() === "") {
        fnDefaultAlertFocus("증액주기(분)을 선택해주세요.", "RenewalIntervalMinute", "warning");
        return;
    }

    if ($("#RenewalIntervalPrice").val() === "") {
        fnDefaultAlertFocus("증액금액을 입력해주세요.", "RenewalStartMinute", "warning");
        return;
    }

    if ($("#NetworkKind").val() === "") {
        fnDefaultAlertFocus("정보망을 선택해주세요.", "NetworkKind", "warning");
        return;
    }

    strCallType = "NetworkRule" + $("#HidMode").val();
    strConfMsg = "자동배차 룰을 " + ($("#HidMode").val() === "Insert" ? "등록" : "수정") +"하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnNetworkRuleIns", fnParam);
    return;
}

function fnNetworkRuleIns(fnParam) {
    var strHandlerURL = "/TMS/Network/Proc/OrderNetworkRuleHandler.ashx";
    var strCallBackFunc = "fnAjaxNetworkRule";

    var objParam = {
        CallType: fnParam,
        RuleSeqNo: $("#RuleSeqNo").val(),
        RuleType  : "1",
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        RenewalModMinute: $("#RenewalModMinute").val(),
        RenewalStartMinute: $("#RenewalStartMinute").val(),
        RenewalIntervalMinute: $("#RenewalIntervalMinute").val(),
        RenewalIntervalPrice: $("#RenewalIntervalPrice").val(),
        NetworkKind: $("#NetworkKind").val(),
        UseFlag : "Y"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxNetworkRule(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {
        fnDefaultAlert("저장되었습니다.", "success", "fnNetworkLocation", data[0].RuleSeqNo);
        return;
    }
}

function fnNetworkLocation(RuleSeqNo) {
    document.location.replace("/TMS/Network/OrderNetworkRuleIns?HidMode=Update&RuleSeqNo=" + RuleSeqNo);
    parent.fnCallGridData("#NetworkRuleListGrid");
    return;
}

