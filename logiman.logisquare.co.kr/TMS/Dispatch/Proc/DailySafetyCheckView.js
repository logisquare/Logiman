$(document).ready(function () {
    if (!$("#CheckData").val()) {
        fnDefaultAlert("전달된 점검표 데이터가 없습니다.", "warning", "fnWindowClose()");
        return false;
    } else {
        fnSetCheckList();
        return false;
    }
});

function fnWindowClose() {
    self.close();
    return false;
}

function fnSetCheckList() {
    if (!$("#CheckData").val()) {
        return false;
    }

    var objCheckData = JSON.parse($("#CheckData").val());

    var strHtml = "";
    strHtml += "\t\t<h2>" + fnGetDate(objCheckData.PickupYMD) + " (" + fnGetDay(objCheckData.PickupYMD) + ")</h2>\n";
    strHtml += "\t\t<table class=\"type_01\">\n";
    strHtml += "\t\t\t<thead>\n";
    strHtml += "\t\t\t<tr>\n";
    strHtml += "\t\t\t\t<th>" + objCheckData.ComName + "</th>\n";
    strHtml += "\t\t\t\t<th>" + objCheckData.ComCorpNo + "</th>\n";
    strHtml += "\t\t\t\t<th>" + objCheckData.CarNo + "</th>\n";
    strHtml += "\t\t\t\t<th>" + objCheckData.DriverName + "</th>\n";
    strHtml += "\t\t\t\t<th>" + fnMakeCellNo(objCheckData.DriverCell) + "</th>\n";
    strHtml += "\t\t\t</tr>\n";
    strHtml += "\t\t\t</thead>\n";
    strHtml += "\t\t</table>\n";
    strHtml += "\t\t<table class=\"type_02\">\n";
    strHtml += "\t\t\t<colgroup>\n";
    strHtml += "\t\t\t\t<col width=\"20\"/>\n";
    strHtml += "\t\t\t\t<col width=\"*\"/>\n";
    strHtml += "\t\t\t\t<col width=\"70\"/>\n";
    strHtml += "\t\t\t\t<col width=\"70\"/>\n";
    strHtml += "\t\t\t</colgroup>\n";
    strHtml += "\t\t\t<thead>\n";
    strHtml += "\t\t\t<tr>\n";
    strHtml += "\t\t\t\t<th>No.</th>\n";
    strHtml += "\t\t\t\t<th>질문</th>\n";
    strHtml += "\t\t\t\t<th>예</th>\n";
    strHtml += "\t\t\t\t<th>아니오</th>\n";
    strHtml += "\t\t\t</tr>\n";
    strHtml += "\t\t\t</thead>\n";
    strHtml += "\t\t\t<tbody>\n";
    strHtml += "\t\t\t<tr>\n";
    strHtml += "\t\t\t\t<td>1.</td>\n";
    strHtml += "\t\t\t\t<td>적재함 잠금장치 확인하셨나요?</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply1 === "Y" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply1 === "N" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t</tr>\n";
    strHtml += "\t\t\t<tr>\n";
    strHtml += "\t\t\t\t<td>2.</td>\n";
    strHtml += "\t\t\t\t<td>선적서류와 물품의 이상여부 확인하셨나요?</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply2 === "Y" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply2 === "N" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t</tr>\n";
    strHtml += "\t\t\t<tr>\n";
    strHtml += "\t\t\t\t<td>3.</td>\n";
    strHtml += "\t\t\t\t<td>운송수단 등에 폭발물 부착 테러징후 검사 확인하셨나요?</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply3 === "Y" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply3 === "N" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t</tr>\n";
    strHtml += "\t\t\t<tr>\n";
    strHtml += "\t\t\t\t<td>4.</td>\n";
    strHtml += "\t\t\t\t<td>봉인 또는 잠금장치 이상여부 확인하셨나요?</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply4 === "Y" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply4 === "N" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t</tr>\n";
    strHtml += "\t\t\t<tr>\n";
    strHtml += "\t\t\t\t<td>5.</td>\n";
    strHtml += "\t\t\t\t<td>운송수단 내,외부 오염도 이상여부 확인하셨나요?</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply5 === "Y" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply5 === "N" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t</tr>\n";
    strHtml += "\t\t\t<tr>\n";
    strHtml += "\t\t\t\t<td>6.</td>\n";
    strHtml += "\t\t\t\t<td>\n";
    strHtml += "\t\t\t\t\t트럭 구조 검증 – 7가지 지점을 확인하셨나요?<br/>\n";
    strHtml += "\t\t\t\t\t(①범퍼/타이어/외륜 ②문/공구함 ③배터리함 ④공기흡입엔진 ⑤연료탱크 ⑥내부운전실/수면공간 ⑦fairing/지붕)";
    strHtml += "\t\t\t\t</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply6 === "Y" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t\t<td class=\"center\">" + (objCheckData.Reply6 === "N" ? "○" : "") + "</td>\n";
    strHtml += "\t\t\t</tr>\n";
    strHtml += "\t\t\t</tbody>\n";
    strHtml += "\t\t</table>\n";
    strHtml += "\t\t<h1>" + objCheckData.CenterName + "</h1>\n";

    $(".checklist_print").html(strHtml);
}

function fnGetDay(Ymd) {
    var weekName = new Array("일", "월", "화", "수", "목", "금", "토");
    var year = Ymd.substring(0, 4);
    var month = Ymd.substring(4, 6);
    var day = Ymd.substring(6, 8);
    var week = new Date(year, month - 1, day, 0, 0, 0, 0);
    week = weekName[week.getDay()];

    return week;
}

function fnGetDate(ymd) {
    var yy = ymd.substring(0, 4);
    var mm = ymd.substring(4, 6);
    var dd = ymd.substring(6, 8);
    return yy + "년 " + mm + "월 " + dd + "일";
}
