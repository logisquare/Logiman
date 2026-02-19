$(document).ready(function () {
    if ($("#HidCallType").val() !== "") {
        fnCallResultData(1);
    }
});

var intListNumber = 2; //리스트 더보기 기본 2부터 셋팅
//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallResultData(Number) {

    var strHandlerURL = "/APP/TMS/Client/Proc/PlaceHandler.ashx";
    var strCallBackFunc = "";
    var strFailFunc = "fnfailResult";
    if (Number === 1) {
        strCallBackFunc = "fnDataSuccResult";
    } else {
        intListNumber++;
        strCallBackFunc = "fnDataPageSuccResult";
    }
    

    var objParam = {
        CallType: "PlaceList",
        CenterCode: $("#CenterCode").val(),
        UseFlag: $("#UseFlag").val(),
        PlaceName: $("#PlaceName").val(),
        PageSize: $("#PageSize").val(),
        PageNo: Number,
    };
    $("#HidParam").val(JSON.stringify(objParam));
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailFunc, "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDataSuccResult(objRes) {
    var strText = "";
    if (objRes) {
        if (objRes[0].data.RecordCnt > 0) {
            for (var i = 0; i < objRes[0].data.list.length; i++) {
                strText += "<li onclick=\"fnPlaceDetail(" + objRes[0].data.list[i].PlaceSeqNo  +");\">";
                strText += "<table><colgroup><col style=\"width:15%\"/><col style=\"width:85%\"/></colgroup>";
                strText += "<thead>";
                strText += "<tr>";
                strText += "<th colspan=\"2\">";
                strText += "<strong>" + objRes[0].data.list[i].PlaceName  +"</strong>";
                strText += "</th>";
                strText += "</tr>";
                strText += "</thead>";
                strText += "<tbody>";
                strText += "<tr>";
                strText += "<td>주소</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].PlaceAddr +"</span>";
                strText += "</td>";
                /*strText += "</tr>";
                strText += "<tr>";
                strText += "<td>담당자</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ChargeName + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>전화번호</td>";
                strText += "<td>";
                strText += "<span>" + fnMakeCellNo(objRes[0].data.list[i].ChargeTelNo) + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>휴대폰</td>";
                strText += "<td>";
                strText += "<span>" + fnMakeCellNo(objRes[0].data.list[i].ChargeCell) + "</span>";
                strText += "</td>";
                strText += "</tr>";*/
                strText += "</tbody>";
                strText += "</table>";
                strText += "</li>";
            }
            if (objRes[0].data.RecordCnt > 10) {
                $("div.more_list").show();
                $("div.more_list button").attr("onclick", "fnCallResultData(" + intListNumber + ")");
            } else {
                $("div.more_list").hide();
                $("div.more_list button").attr("onclick", "");
            }
        }
        $("#TotalCount").text(UTILJS.Util.fnComma(objRes[0].data.RecordCnt));
        $("#PlaceData").html(strText);
    }
    fnSlideSearch();
}

function fnDataPageSuccResult(objRes) {
    var strText = "";
    if (objRes) {
        if (objRes[0].data.RecordCnt > 0) {
            for (var i = 0; i < objRes[0].data.list.length; i++) {
                strText += "<li onclick=\"fnPlaceDetail(" + objRes[0].data.list[i].SeqNo + ");\">";
                strText += "<table><colgroup><col style=\"width:15%\"/><col style=\"width:85%\"/></colgroup>";
                strText += "<thead>";
                strText += "<tr>";
                strText += "<th colspan=\"2\">";
                strText += "<strong>" + objRes[0].data.list[i].PlaceName + "</strong>";
                strText += "</th>";
                strText += "</tr>";
                strText += "</thead>";
                strText += "<tbody>";
                strText += "<tr>";
                strText += "<th>주소</th>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].PlaceAddr + "</span>";
                strText += "</td>";
                strText += "</tr>";
                /*strText += "<tr>";
                strText += "<th>담당자</th>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ChargeName + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<th>전화번호</th>";
                strText += "<td>";
                strText += "<span>" + fnMakeCellNo(objRes[0].data.list[i].ChargeTelNo) + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<th>휴대폰</th>";
                strText += "<td>";
                strText += "<span>" + fnMakeCellNo(objRes[0].data.list[i].ChargeCell) + "</span>";
                strText += "</td>";
                strText += "</tr>";*/
                strText += "</tbody>";
                strText += "</table>";
                strText += "</li>";
            }
            $("div.more_list button").attr("onclick", "fnCallResultData(" + intListNumber + ")");
            $("#PlaceData").append(strText);
            if (objRes[0].data.RecordCnt === $("#PlaceData li").size()) {
                $("div.more_list button").attr("onclick", "");
                $("div.more_list").hide();
            } else {
                $("div.more_list button").attr("onclick", "fnCallResultData(" + intListNumber + ")");
            }
        }
    }
}

function fnfailResult(obj) {
    console.log(obj);
}

function fnPlaceDetail(SeqNo) {
    location.href = '/APP/TMS/Client/PlaceIns?Mode=Update&PlaceSeqNo=' + SeqNo + "&HidParam=" + $("#HidParam").val();
}

function fnDataIns() {
    location.href = '/APP/TMS/Client/PlaceIns?Mode=Insert&HidParam=' + $("#HidParam").val();
}
