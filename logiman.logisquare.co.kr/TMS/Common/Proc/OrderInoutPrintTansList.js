$(document).ready(function () {
    fnSetTransPrintData();
});

function fnWindowClose() {
    self.close();
}

function fnSetTransPrintData() {
    var strOrderNo = $("#OrderNos").val();
    var strHandlerURL = "/TMS/Common/Proc/OrderPrintListHandler.ashx";
    var strCallBackFunc = "fnGridTransSuccResult";

    var objParam = {
        CallType: "OrderDispatchPrintList",
        CenterCode: $("#CenterCode").val(),
        OrderNos: strOrderNo
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}
//운송장 출력
function fnGridTransSuccResult(ObjRes) {
    var strTb = "";
    var uniqueArr = []; // 중복이 제거된 배열이 생성될 변수
    var uniqueArrIndex = []; // 중복이 제거된 배열이 생성될 변수
    if (ObjRes[0].data.RecordCnt > 0) {

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
                    strTb += "<th>포워더</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].OrderClientName + "</td>";
                    strTb += "<th>화주</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].ConsignorName + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>오더번호</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].OrderNo + "</td>";
                    strTb += "<th>상품</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].OrderItemCodeM + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>운송사명</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].CenterNameInfo + "</td>";
                    strTb += "<th>사업장</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].OrderLocationCodeM + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>접수자</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].AcceptAdminName + "</td>";
                    strTb += "<th>전화번호</th>";
                    strTb += "<td>" + (ObjRes[0].data.list[i].AcceptTelNo !== "" ? ObjRes[0].data.list[i].AcceptTelNo : "") + "</td>";
                    strTb += "</tr>";
                    strTb += "</thead>";
                    strTb += "</table>";

                    //상차정보
                    strTb += "<h2>상차정보</h2>";
                    strTb += "<table class=\"type_02\">";
                    strTb += "<colgroup>";
                    strTb += "<col style=\"width:100px\"/>";
                    strTb += "<col style=\"width:260px\"/>";
                    strTb += "<col style=\"width:100px\"/>";
                    strTb += "<col style=\"width:260px\"/>";
                    strTb += "</colgroup>";
                    strTb += "<tbody>";
                    strTb += "<tr>";
                    strTb += "<th>상차일</th>";
                    strTb += "<td>" + fnGetStrDateFormat(ObjRes[0].data.list[i].PickupYMD, "-") + "</td>";
                    strTb += "<th>요청시간</th>";
                    strTb += "<td>" + fnGetHMFormat(ObjRes[0].data.list[i].PickupHM) + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>상차지</th>";
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

                    //하차정보
                    strTb += "<h2>하차정보</h2>";
                    strTb += "<table class=\"type_02\">";
                    strTb += "<colgroup>";
                    strTb += "<col style=\"width:100px\"/>";
                    strTb += "<col style=\"width:260px\"/>";
                    strTb += "<col style=\"width:100px\"/>";
                    strTb += "<col style=\"width:260px\"/>";
                    strTb += "</colgroup>";
                    strTb += "<tbody>";
                    strTb += "<tr>";
                    strTb += "<th>하차일</th>";
                    strTb += "<td>" + fnGetStrDateFormat(ObjRes[0].data.list[i].GetYMD, "-") + "</td>";
                    strTb += "<th>요청시간</th>";
                    strTb += "<td>" + fnGetHMFormat(ObjRes[0].data.list[i].GetHM) + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>하차지</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].GetPlace + "</td>";
                    strTb += "<th>전화번호</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].GetPlaceChargeTelNo + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>담당자</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].GetPlaceChargeName + "</td>";
                    strTb += "<th>휴대폰</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].GetPlaceChargeCell + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>주소</th>";
                    strTb += "<td colspan=\"3\">" + ObjRes[0].data.list[i].GetPlaceAddr + " " + ObjRes[0].data.list[i].GetPlaceAddrDtl + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>전달사항</th>";
                    strTb += "<td colspan=\"3\">" + ObjRes[0].data.list[i].GetPlaceNote + "</td>";
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
                    strTb += "<th>수량</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].Volume + "</td>";
                    strTb += "<th>무게(KG)</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].Weight + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>크기/단위</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].Quantity + "</td>";
                    strTb += "<th>부피(CBM)</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].CBM + "</td>";
                    strTb += "</tr>";
                    strTb += "<tr>";
                    strTb += "<th>목적국</th>";
                    strTb += "<td>" + ObjRes[0].data.list[i].Nation + "</td>";
                    strTb += "<th>B/L(AWB)</th>";
                    strTb += "<td>" + (ObjRes[0].data.list[i].Hawb === null ? "" : ObjRes[0].data.list[i].Hawb) + "</td>";
                    strTb += "</tr>";
                    /*if (ObjRes[0].data.list[i].OrderItemCode === "OA002"
                        || ObjRes[0].data.list[i].OrderItemCode === "OA004"
                        || ObjRes[0].data.list[i].OrderItemCode === "OA006"
                        || ObjRes[0].data.list[i].OrderItemCode === "OA009")
                    {
                        strTb += "<tr>";
                        strTb += "<th>비고</th>";
                        strTb += "<td colspan='3'>" + ObjRes[0].data.list[i].NoteInside + "</td>";
                        strTb += "</tr>";
                    }*/
                    strTb += "</tbody>";
                    strTb += "</table>";

                    //계산서 발행정보
                    if (ObjRes[0].data.list[i].OrderItemCode === "OA002"
                        || ObjRes[0].data.list[i].OrderItemCode === "OA004"
                        || ObjRes[0].data.list[i].OrderItemCode === "OA006"
                        || ObjRes[0].data.list[i].OrderItemCode === "OA009") {
                        strTb += "<h2>계산서 발행정보</h2>";
                        strTb += "<table class=\"type_02\">";
                        strTb += "<colgroup>";
                        strTb += "<col style=\"width:100px\"/>";
                        strTb += "<col style=\"width:260px\"/>";
                        strTb += "<col style=\"width:100px\"/>";
                        strTb += "<col style=\"width:260px\"/>";
                        strTb += "</colgroup>";
                        strTb += "<tbody>";
                        strTb += "<tr>";
                        strTb += "<th>사업자명</th>";
                        strTb += "<td colspan='3'>" + ObjRes[0].data.list[i].TaxClientName + "</td>";
                        strTb += "</tr>";
                        strTb += "<tr>";
                        strTb += "<th>사업자번호</th>";
                        strTb += "<td>" + ObjRes[0].data.list[i].TaxClientCorpNo + "</td>";
                        strTb += "<th>전화번호</th>";
                        strTb += "<td>" + ObjRes[0].data.list[i].TaxClientChargeTelNo + "</td>";
                        strTb += "</tr>";
                        strTb += "<tr>";
                        strTb += "<th>담당자</th>";
                        strTb += "<td>" + ObjRes[0].data.list[i].TaxClientChargeName + "</td>";
                        strTb += "<th>이메일</th>";
                        strTb += "<td>" + ObjRes[0].data.list[i].TaxClientChargeEmail + "</td>";
                        strTb += "</tr>";
                        strTb += "</tbody>";
                        strTb += "</table>";
                    }

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