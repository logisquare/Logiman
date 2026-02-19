$(document).ready(function () {
    if ($("#HidCallType").val() !== "") {
        fnCallResultData(1);
    }
});

var intListNumber = 2; //리스트 더보기 기본 2부터 셋팅
//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallResultData(Number) {

    var strHandlerURL = "/APP/TMS/Client/Proc/ClientHandler.ashx";
    var strCallBackFunc = "";
    var strFailFunc = "fnfailResult";
    if (Number === 1) {
        strCallBackFunc = "fnDataSuccResult";
    } else {
        intListNumber++;
        strCallBackFunc = "fnDataPageSuccResult";
    }
    

    var objParam = {
        CallType: "ClientList",
        CenterCode: $("#CenterCode").val(),
        UseFlag: $("#UseFlag").val(),
        ClientType: $("#ClientType").val(),
        ClientCorpNo: $("#ClientCorpNo").val(),
        ClientName: $("#ClientName").val(),
        PageNo: Number,
        PageSize: $("#PageSize").val()
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
                strText += "<li onclick=\"fnLocationDetail(" + objRes[0].data.list[i].ClientCode +");\">";
                strText += "<table><colgroup><col style=\"width:35%\"/><col style=\"width:65%\"/></colgroup>";
                strText += "<thead>";
                strText += "<tr>";
                strText += "<th>";
                strText += "<strong>" + objRes[0].data.list[i].CenterName  +"</strong>";
                strText += "</th>";
                strText += "<th style=\"text-align:right;\">";
                strText += "<span class=\"car_div_type\">" + objRes[0].data.list[i].ClientTypeM + "</span>";
                strText += "</th>";
                strText += "</tr>";
                strText += "</thead>";
                strText += "<tbody>";
                strText += "<tr>";
                strText += "<td>사업자번호</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientCorpNo +"</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>업체명</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientName +"</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>대표자</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientCeoName + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>전화번호</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientTelNo + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>주소</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientAddr + "</span>";
                strText += "</td>";
                strText += "</tr>";
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
        $("#ClientData").html(strText);
    }
    fnSlideSearch();
}

function fnDataPageSuccResult(objRes) {
    var strText = "";
    if (objRes) {
        if (objRes[0].data.RecordCnt > 0) {
            for (var i = 0; i < objRes[0].data.list.length; i++) {
                strText += "<li onclick=\"fnLocationDetail(" + objRes[0].data.list[i].ClientCode +");\">";
                strText += "<table><colgroup><col style=\"width:35%\"/><col style=\"width:65%\"/></colgroup>";
                strText += "<thead>";
                strText += "<tr>";
                strText += "<th>";
                strText += "<strong>" + objRes[0].data.list[i].CenterName + "</strong>";
                strText += "</th>";
                strText += "<th style=\"text-align:right;\">";
                strText += "<span class=\"car_div_type\">" + objRes[0].data.list[i].ClientTypeM + "</span>";
                strText += "</th>";
                strText += "</tr>";
                strText += "</thead>";
                strText += "<tbody>";
                strText += "<tr>";
                strText += "<td>사업자번호</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientCorpNo + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>업체명</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientName + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>대표자</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientCeoName + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>전화번호</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientTelNo + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>주소</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ClientAddr + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "</tbody>";
                strText += "</table>";
                strText += "</li>";
            }
            $("div.more_list button").attr("onclick", "fnCallResultData(" + intListNumber + ")");
            $("#ClientData").append(strText);
            if (objRes[0].data.RecordCnt === $("#ClientData li").size()) {
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

function fnLocationDetail(ClientCode) {
    location.href = "/APP/TMS/Client/ClientIns?HidMode=Update&ClientCode=" + ClientCode + "&HidParam=" + $("#HidParam").val();
    return;
}

function fnDataIns() {
    location.href = '/APP/TMS/Client/ClientIns?HidMode=Insert&HidParam=' + $("#HidParam").val();
}