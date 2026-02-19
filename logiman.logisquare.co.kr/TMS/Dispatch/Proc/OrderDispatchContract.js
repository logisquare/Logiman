$(document).ready(function () {
    if ($("#HidCenterCode").val() === "") {
        parent.fnReloadPageNotice("운송사 정보가 없습니다.");
        return;
    }

    if ($("#HidDispatchType").val() === "") {
        fnDefaultAlert("집하/간선 선택정보가 없습니다.", "warning", "fnClosePopUpLayer", "");
        return;
    }

    if ($("#HidGridID").val() === "") {
        fnDefaultAlert("오더정보가 없습니다.", "warning", "fnClosePopUpLayer", "");
        return;
    }

    fnPopContractCenterInit();//위탁운송사 호출
});

function fnContractInsConfirm() {
    var OrderNos = [];
    var GridID = $("#HidGridID").val();
    GridID = "#" + GridID;
    var CheckedItems = parent.AUIGrid.getCheckedRowItems(GridID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("위탁 운송사를 선택해주세요.", "ContractCenterCode", "warning");
        return;
    }

    if (CheckedItems.length === 0) {
        parent.fnReloadPageNotice("선택된 오더가 없습니다.");
        return;
    }

    if ($("#HidDispatchType").val() === "1") {
        $.each(CheckedItems, function (index, item) {
            if (item.item.DispatchRefSeqNo1 == "0" && item.item.CnlFlag == "N" && !(item.item.ContractType == 2 && item.item.ContractStatus == 2) && item.item.ContractType != 3 && $("#HidCenterCode").val() == item.item.CenterCode) {
                OrderNos.push(item.item.OrderNo);
            }
        });
    }else if ($("#HidDispatchType").val() === "2") {
        $.each(CheckedItems, function (index, item) {
            if (item.item.GoodsDispatchType == 3 && item.item.DispatchRefSeqNo1 == "0" && item.item.CnlFlag == "N" && !(item.item.ContractType == 2 && item.item.ContractStatus == 2) && item.item.ContractType != 3 && $("#HidCenterCode").val() == item.item.CenterCode) {
                OrderNos.push(item.item.OrderNo);
            }
        });
    } else if ($("#HidDispatchType").val() === "3") {
        $.each(CheckedItems, function (index, item) {
            if (item.item.GoodsDispatchType == 3 && item.item.CnlFlag == "N" && (item.item.DispatchRefSeqNo2 == 0 || item.item.DispatchRefSeqNo3 == 0) && !(item.item.ContractType == 2 && item.item.ContractStatus == 2) && item.item.ContractType != 3 && $("#HidCenterCode").val() == item.item.CenterCode) {
                OrderNos.push(item.item.OrderNo);
            }
        });
    }
    
    fnDefaultConfirm("오더 : " + OrderNos.length + ", 위탁운송사 : " + $("#ContractCenterCode option:selected").text() + "<br>위탁하시겠습니까?", "fnContractIns", OrderNos);
    return;
}
function fnContractIns(OrderNos) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchHandler.ashx";
    var strCallBackFunc = "fnGridContractInsSuccResult";

    var objParam = {
        CallType: "OrderDispatchContractIns",
        CenterCode: $("#HidCenterCode").val(),
        OrderNos: OrderNos.join(","),
        ContractCenterCode: $("#ContractCenterCode").val(),
        DispatchType: $("#HidDispatchType").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridContractInsSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "error");
        return;
    } else {
        parent.fnReloadPageNotice("총 " + data[0].TotalCnt + "건 중 " + "성공 : " + data[0].SuccCnt + "/ 실패 : " + data[0].FailCnt + " 하였습니다.");
        return;
    }
}

function fnPopContractCenterInit() {
    $("#ContractCenterCode option").remove();
    $("#ContractCenterCode").append("<option value=''>위탁운송사</option>");

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchHandler.ashx";
    var strCallBackFunc = "fnPopContractCenterSuccResult";

    var objParam = {
        CallType: "ContractCenterList",
        CenterCode: $("#HidCenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnPopContractCenterSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                return false;
            }
        }

        $.each(objRes[0].List, function (index, item) {
            $("#ContractCenterCode").append("<option value=\"" + item.CenterCode + "\">" + item.CenterName + "</option>");
        });
    }
}