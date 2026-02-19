$(document).ready(function () {
    //담당구분
    $("#CsAdminType").on("change", function () {
        if ($(this).val() === "1") {
            $("#TrDetail").show();
        } else if ($(this).val() === "2") {
            $("#OrderItemCode").val("");
            $("#OrderLocationCode").val("");
            $("#TrDetail").hide();
        }
    });

    //고객사명
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/ClientCs/Proc/ClientCsHandler.ashx";
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

    //담당자명
    if ($("#AdminName").length > 0) {
        fnSetAutocomplete({
            formId: "AdminName",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/ClientCs/Proc/ClientCsHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "AdminUserList",
                    AdminName: request.term,
                    UseFlag: "Y",
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.AdminName + " (" + item.AdminID + ")",
                getValue: (item) => item.AdminName,
                onSelect: (event, ui) => {
                    $("#CsAdminName").val(ui.item.etc.AdminName);
                    $("#CsAdminID").val(ui.item.etc.AdminID);
                }
            }
        });
    }
});

function fnClientCsInsConfirm() {
    var strConfMsg = "";
    var strCallType = "";

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return;
    }

    if ($("#ClientCode").val() === "") {
        fnDefaultAlertFocus("고객사명을 입력해주세요.", "ClientName", "warning");
        return;
    }

    if ($("#CsAdminType").val() === "") {
        fnDefaultAlertFocus("담당구분을 선택해주세요.", "CsAdminType", "warning");
        return;
    }

    if ($("#CsAdminID").val() === "") {
        fnDefaultAlertFocus("담당자를 검색해주세요.", "CsAdminName", "warning");
        return;
    }

    if ($("#CsAdminType").val() === "1") {
        if ($("#OrderItemCode").val() === "") {
            fnDefaultAlertFocus("상품구분을 선택해주세요.", "OrderItemCode", "warning");
            return;
        }

        if ($("#OrderItemCode").val() !== "OA007") {
            if ($("#OrderLocationCode").val() === "") {
                fnDefaultAlertFocus("사업장을 선택해주세요.", "OrderLocationCode", "warning");
                return;
            }
        }
    }

    strCallType = "ClientCsIns";
    strConfMsg = "고객사 담당자를 추가하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnClientCsIns", fnParam);
    return;
}

function fnClientCsIns(fnParam) {
    var strHandlerURL = "/TMS/ClientCs/Proc/ClientCsHandler.ashx";
    var strCallBackFunc = "fnAjaxClientCs";

    var objParam = {
        CallType    : fnParam,
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        CsAdminType: $("#CsAdminType").val(),
        CsAdminID: $("#CsAdminID").val(),
        CsAdminName: $("#CsAdminName").val(),
        OrderItemCode: $("#OrderItemCode").val(),
        OrderLocationCode: $("#OrderLocationCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxClientCs(data) {
    
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {
        var objParam = {
            CsSeqNo: data[0].CsSeqNo,
            ClientName: $("#ClientName").val(),
            CsAdminTypeM: $("#CsAdminType option:selected").text(),
            OrderItemCodeM: $("#OrderItemCode option:selected").text(),
            OrderLocationCodeM: $("#OrderLocationCode option:selected").text()
        };

        fnDefaultAlert("추가되었습니다.", "success", "fnClientCsAddData", objParam);
        return;
    }

    $("#divLoadingImage").hide();
}

function fnClientCsAddData(objParam) {
    
    var strContents = "";
    var CsSeqNo = objParam.CsSeqNo;
    var ClientName = objParam.ClientName;
    var CsAdminTypeM = objParam.CsAdminTypeM;
    var OrderItemCodeM = objParam.CsAdminTypeM == "업무" ? objParam.OrderItemCodeM : "";
    var OrderLocationCodeM = objParam.CsAdminTypeM == "업무" ? objParam.OrderLocationCodeM : "";
    
    strContents = "<tr id=\"DataRow_" + CsSeqNo +"\">"
    strContents += "<td class=\"al_c\">" + ClientName + "</td>";
    strContents += "<td class=\"al_c\">" + CsAdminTypeM + "</td>";
    strContents += "<td class=\"al_c\">" + OrderItemCodeM +"</td>";
    strContents += "<td class=\"al_c\">" + OrderLocationCodeM +"</td>";
    strContents += "<td class=\"al_c\"><button type=\"button\" class=\"btn_03\" onclick=\"fnClientCsDelConfirm(" + CsSeqNo +")\">삭제</button></td>"
    strContents += "</tr>"

    $("#ClientCsAddList").append(strContents);

    $("#CenterCode", parent.document.body).val($("#CenterCode").val());
    parent.fnCallGridData("#CarDispatchListGrid");
}

function fnClientCsDelConfirm(CsSeqNo) {
    strCallType = "ClientCsDel";
    strConfMsg = "삭제하시겠습니까?";

    var objParam = {
        CallType: strCallType,
        CsSeqNo: CsSeqNo,
        CsSeqNos1: CsSeqNo
    };
    fnDefaultConfirm(strConfMsg, "fnClientCsDel", objParam);
    return;
}

function fnClientCsDel(objParam) {
    var strHandlerURL = "/TMS/ClientCs/Proc/ClientCsHandler.ashx";
    var strCallBackFunc = "fnAjaxDelClientCs";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxDelClientCs(data) {
    
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg);
        return;
    } else {
        fnDefaultAlert("삭제되었습니다.", "success", "fnClientCsRemoveData", data[0].CsSeqNo);
        return;
    }
}

function fnClientCsRemoveData(csSeqNo) {
    $("#DataRow_" + csSeqNo).remove();

    $("#CenterCode", parent.document.body).val($("#CenterCode").val());
    parent.fnCallGridData("#CarDispatchListGrid");
    return;
}

function fnClientCsReset() {
    $("#CenterCode").val("");
    $("#ClientName").val("");
    $("#ClientCode").val("");
    $("#CsAdminType").val("");
    $("#AdminName").val("");
    $("#CsAdminID").val("");
    $("#OrderItemCode").val("");
    $("#OrderLocationCode").val("");
    $("#TrDetail").hide();
    $("#ClientCsAddList re").remove();
    return;
}