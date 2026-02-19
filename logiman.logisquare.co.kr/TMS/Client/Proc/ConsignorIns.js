$(document).ready(function () {

    if ($("#hidDisplayMode").val() === "Y") {
        if (parent) {
            parent.fnReloadPageNotice($("#HidErrMsg").val());
        }
        else if (opener) {
            opener.fnReloadPageNotice($("#HidErrMsg").val());
        }
    }

    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Client/Proc/ConsignorHandler.ashx";
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
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                }
            }
        });
    }

    fnSetInitData();
});

function fnSetInitData() {
    if ($("#HidMode").val() === "Update") {
        fnCallConsignorDetail();
        fnCallClientConsignorDetail();
    }
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnReloadPageNotice(strMsg) {
    fnClosePopUpLayer();
    fnDefaultAlert(strMsg, "info");
}

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
    strConfMsg = "화주를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록") ;
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsConsignorProc", fnParam);
    return;
}

function fnInsConsignorProc(fnParam) {
    var strHandlerURL = "/TMS/Client/Proc/ConsignorHandler.ashx";
    var strCallBackFunc = "fnAjaxInsConsignor";

    var objParam = {
        CallType: fnParam,
        ConsignorCode: $("#ConsignorCode").val(),
        CenterCode: $("#CenterCode").val(),
        ConsignorName: $("#ConsignorName").val(),
        ConsignorNote: $("#ConsignorNote").val(),
        UseFlag: $("input[name$='UseFlag']:checked").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);

}

function fnAjaxInsConsignor(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        var msg = "화주 " + ($("#HidMode").val() === "Update" ? "수정" : "등록") + "에 성공하였습니다.";
        parent.fnReloadPageNotice(msg);
    }
}

function fnCallConsignorDetail() {

    var strHandlerURL = "/TMS/Client/Proc/ConsignorHandler.ashx";
    var strCallBackFunc = "fnDetailSuccResult";
    var strFailCallBackFunc = "fnDetailFailResult";

    var objParam = {
        CallType: "ConsignorList",
        ConsignorCode: $("#ConsignorCode").val()
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

        var Item = objRes[0].data.list[0];

        $("#CenterCode").val(Item.CenterCode);
        $("#CenterCode option").not(":selected").attr("disabled", "disabled");
        $("#ConsignorName").val(Item.ConsignorName);
        $("#ConsignorNote").val(Item.ConsignorNote);
        $("#UseFlagY").prop("checked", Item.UseFlag === "Y");
        $("#UseFlagN").prop("checked", Item.UseFlag === "N");
    }
    else
    {
        fnDetailFailResult();
    }
}

function fnDetailFailResult() {
    parent.fnReloadPageNotice("데이터를 불러올 수 없습니다.");
}

//고객사-화주 연결정보 등록
function fnInsClientConsignor() {
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return;
    }

    if (!$("#ClientCode").val() || !$("#ClientName").val()) {
        fnDefaultAlertFocus("고객사명을 검색하세요.", "ClientName", "warning");
        return;
    }

    var strHandlerURL = "/TMS/Client/Proc/ConsignorHandler.ashx";
    var strCallBackFunc = "fnAjaxInsClientConsignor";

    var objParam = {
        CallType: "ClientConsignorInsert",
        CenterCode: $("#CenterCode").val(),
        ConsignorCode: $("#ConsignorCode").val(),
        ClientCode: $("#ClientCode").val(),
        ClientName: $("#ClientName").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsClientConsignor(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("고객사 추가가 완료되었습니다.", "info");
        $("#UlClientList").append("<li onclick=\"fnDelClientConsignor('" + data[0].EncSeqNo + "'); return false;\">" + $("#ClientName").val() + "<span></span></li>\n");
        $("#ClientCode").val("");
        $("#ClientName").val("");
        $("#ClientName").focus();
    }
}

//고객사 - 화주 정보 삭제
var strDelEncSeqNo = "";
function fnDelClientConsignor(strEncSeqNo) {

    var strHandlerURL = "/TMS/Client/Proc/ConsignorHandler.ashx";
    var strCallBackFunc = "fnAjaxDelClientConsignor";

    var objParam = {
        CallType: "ClientConsignorDelete",
        EncSeqNo: strEncSeqNo
    };

    strDelEncSeqNo = strEncSeqNo;

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxDelClientConsignor(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("고객사 삭제 완료되었습니다.", "info");
        $.each($("#UlClientList li"), function (index, item) {
            if ($(item).attr("onclick").indexOf(strDelEncSeqNo) > -1) {
                $("#UlClientList li:nth-child("+(index+1)+")").remove();
            }
        });
    }
}

//고객사-화주 연결정보 목록
function fnCallClientConsignorDetail() {

    var strHandlerURL = "/TMS/Client/Proc/ConsignorHandler.ashx";
    var strCallBackFunc = "fnClientConsignorDetailSuccResult";

    var objParam = {
        CallType: "ClientConsignorList",
        ConsignorCode: $("#ConsignorCode").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true);
}

function fnClientConsignorDetailSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            return false;
        }

        $("#UlClientList li").remove();

        var strHtml = "";
        $.each(objRes[0].data.list,
            function (index, item) {
                strHtml += "<li onclick=\"fnDelClientConsignor('" + item.EncSeqNo + "'); return false;\">" + item.ClientName + "<span></span></li>\n";
            });

        $("#UlClientList").append(strHtml);
    }
}
