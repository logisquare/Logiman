
//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallResultData() {

    var strHandlerURL = "/APP/Main/Proc/MainHandler.ashx";
    var strCallBackFunc = "fnDataSuccResult";
    var strFailFunc = "fnfailResult";

    var objParam = {
        CallType: "MainList",
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailFunc, "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDataSuccResult(objRes) {
    var strText = "";
    $("#OrderDispatchData").html("");
    if (objRes) {
        $("#AcceptOrderCnt").text(objRes[0].data.AcceptOrderCnt);
        $("#DispatchOrderCnt").text(objRes[0].data.DispatchOrderCnt);
        if (objRes[0].data.list.length > 0) {
            for (var i = 0; i < objRes[0].data.list.length; i++) {
                strText += "<tr>";
                strText += "<td>";
                strText += objRes[0].data.list[0].PickupYMD.substring(4, 6) + "-" + objRes[0].data.list[0].PickupYMD.substring(6, 8);
                strText += "</td>";
                strText += "<td>";
                strText += fnMoneyComma(objRes[0].data.list[0].SaleAmt);
                strText += "</td>";
                strText += "<td>";
                strText += fnMoneyComma(objRes[0].data.list[0].PurchaseAmt);
                strText += "</td>";
                strText += "<td>";
                strText += fnMoneyComma(objRes[0].data.list[0].ProfitAmt);
                strText += "</td>";
                strText += "<td>";
                strText += objRes[0].data.list[0].ProfitRate + "%";
                strText += "</td>";
                strText += "</tr>";
            }

            $("#OrderDispatchData").html(strText);
        } else {
            strText += "<tr>";
            strText += "<td colspan=\"5\">";
            strText += "조회 된 내역이 없습니다.";
            strText += "</td>";
            strText += "</tr>";

            $("#OrderDispatchData").html(strText);
        }
    }
}
