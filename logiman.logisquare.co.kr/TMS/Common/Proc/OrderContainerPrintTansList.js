$(document).ready(function () {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("필요한 값이 없습니다.", "warning", "fnWindowClose", "");
    }

    fnSetTransPrintData();
});

function fnWindowClose() {
    self.close();
}

function fnSetTransPrintData() {
    
    var strHandlerURL = "/TMS/Common/Proc/OrderPrintListHandler.ashx";
    var strCallBackFunc = "fnGridTransSuccResult";

    var objParam = {
        CallType: "OrderDispatchPrintList",
        CenterCode: $("#CenterCode").val(),
        OrderNos : $("#OrderNos").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}
//운송장 출력
function fnGridTransSuccResult(ObjRes) {
    var strTb = "";
    var uniqueArr = []; // 중복이 제거된 배열이 생성될 변수
    var uniqueArrIndex = []; // 중복이 제거된 배열이 생성될 변수

    if (ObjRes[0].data.list.length > 0) {

        $.each(ObjRes[0].data.list, function (k, val) {
            if ($.inArray(val.OrderNo, uniqueArr) === -1) {
                uniqueArr.push(val.OrderNo);
                uniqueArrIndex.push(k);
            }
        });
        for (var j = 0; j < uniqueArrIndex.length; j++) {
            for (var i = 0; i < ObjRes[0].data.list.length; i++) {
                if (i === uniqueArrIndex[j]) {
                    strTb += "<div class=\"page_line\">";
                    strTb += "<ul class=\"top_ul\">";
                    strTb += "<li>" + ObjRes[0].data.list[i].CenterName + "</li>"
                    strTb += "<li>출력일 : " + fnGetDateToday("-") + "</li>"
                    strTb += "</ul>";
                    strTb += "<h1>운송장(" + ObjRes[0].data.list[i].OrderItemCodeM + ")</h1>";
                    strTb += "<table class=\"type_01\">";
                    strTb += "<colgroup>";
                    strTb += "<col style=\"width:33.33333333333333%\"/>";
                    strTb += "<col style=\"width:33.33333333333333%\"/>";
                    strTb += "<col style=\"width:33.33333333333333%\"/>";
                    strTb += "<thead>";
                    strTb += "<tr>";
                    strTb += "<th>오더번호</th>";
                    strTb += "<th>상품</th>";
                    strTb += "<th>화주</th>";
                    strTb += "</tr>";
                    strTb += "</thead>"
                    strTb += "<tbody>";
                    strTb += "<tr>";
                    strTb += "<td>" + ObjRes[0].data.list[i].OrderNo + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].OrderItemCodeM + "</td>";
                    strTb += "<td>" + ObjRes[0].data.list[i].ConsignorName + "</td>";
                    strTb += "</tr>";
                    strTb += "</tbody>";
                    strTb += "</table>";

                    //운송사 정보
                    strTb += "<h2>운송사 정보</h2>";
                    strTb += "<table class=\"type_02\">";
                    strTb += "<colgroup>";
                    strTb += "<col style=\"width:20%\"/>";
                    strTb += "<col style=\"width:30%\"/>";
                    strTb += "<col style=\"width:20%\"/>";
                    strTb += "<col style=\"width:30%\"/>";
                    strTb += "</colgroup>";
                    strTb += "<thead class=\"tleft\">";
                    strTb += "<tr>";
                    strTb += "<th>운송사명</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].CenterNameInfo + "</td>";
                    strTb += "<th>[사업장]접수자</th>";
                    strTb += "<td>" + (ObjRes[0].data.list[i].OrderLocationCodeM != "" ? "[" + ObjRes[0].data.list[i].OrderLocationCodeM + "]" : "") + "접수자 : " + ObjRes[0].data.list[i].AcceptAdminName + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>대표번호</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].TelNoInfo + "</td>";
                    strTb += "<th>팩스번호</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].FaxNoInfo + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>주소</th>";
                    strTb += "<td colspan=\"3\">";
                    strTb += ObjRes[0].data.list[i].AddrInfo + "(우편번호 " + ObjRes[0].data.list[i].AddrPostInfo + ")";
                    strTb += "</td>";
                    strTb += "</tr>";
                    strTb += "</thead>";
                    strTb += "</table>";

                    //작업정보
                    strTb += "<h2>작업정보</h2>";
                    strTb += "<table class=\"type_02\">";
                    strTb += "<colgroup>";
                    strTb += "<col style=\"width:100px\"/>";
                    strTb += "<col style=\"width:260px\"/>";
                    strTb += "<col style=\"width:100px\"/>";
                    strTb += "<col style=\"width:260px\"/>";
                    strTb += "</colgroup>";
                    strTb += "<tbody>";
                    strTb += "<tr>";
                    strTb += "<th>작업일</th>";
                    strTb += "<td>" + fnGetStrDateFormat(ObjRes[0].data.list[i].PickupYMD, "-") + "</td>";
                    strTb += "<th>요청시간</th>";
                    strTb += "<td>" + fnGetHMFormat(ObjRes[0].data.list[i].PickupHM) + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>작업지</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].PickupPlace + "</td>";
                    strTb += "<th>전화번호</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].PickupPlaceChargeTelNo + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>담당자</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].PickupPlaceChargeName + "</td>";
                    strTb += "<th>휴대폰</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].PickupPlaceChargeCell + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>주소</th>";
                    strTb += "<td colspan=\"3\">" + ObjRes[0].data.list[i].PickupPlaceAddr + " " + ObjRes[0].data.list[i].PickupPlaceAddrDtl + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>전달사항</th>";
                    strTb += "<td colspan=\"3\">" + ObjRes[0].data.list[i].PickupPlaceNote + "</td>";
                    strTb += "</tr>";
                    strTb += "</tbody>";
                    strTb += "</table>";

                    //화물정보
                    strTb += "<h2>화물정보</h2>";
                    strTb += "<table class=\"type_02\">";
                    strTb += "<colgroup>";
                    strTb += "<col style=\"width:100px\"/>";
                    strTb += "<col style=\"width:260px\"/>";
                    strTb += "<col style=\"width:100px\"/>";
                    strTb += "<col style=\"width:260px\"/>";
                    strTb += "</colgroup>";
                    strTb += "<tbody>";
                    strTb += "<tr>";
                    strTb += "<th>품목</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].GoodsItemCodeM + "</td>";
                    strTb += "<th>무게(KG)</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].Weight + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>선사</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].ShippingCompany + "</td>";
                    strTb += "<th>선명</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].ShippingShipName + "</td>";
                    strTb += "</tr>";
                    strTb += "<th>픽업CY</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].PickupCY + "</td>";
                    strTb += "<th>하차CY</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].GetCY + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>B/L No</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].BLNo + "</td>";
                    strTb += "<th>D/O No</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].DONo + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>CNTR NO</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].CntrNo + "</td>";
                    strTb += "<th>SEAL NO</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].SealNo + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>B.K NO</th>";
                    strTb += "<td colspan='3'>" + ObjRes[0].data.list[i].BookingNo + "</td>";
                    strTb += "</tr>";
                    strTb += "</tbody>";
                    strTb += "</table>";

                    strTb += "</div>";
                    if (j + 1 != uniqueArrIndex.length) {
                        strTb += "<div style=\"page-break-before:always;\"></div>";
                    }
                }
            }
        }
    }

    $("div.transport_print").html(strTb);
}