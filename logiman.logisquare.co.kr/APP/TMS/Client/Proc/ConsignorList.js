$(document).ready(function () {
    if ($("#HidCallType").val() !== "") {
        fnCallResultData(1);
    }
});

var intListNumber = 2; //리스트 더보기 기본 2부터 셋팅
//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallResultData(Number) {

    var strHandlerURL = "/APP/TMS/Client/Proc/ConsignorHandler.ashx";
    var strCallBackFunc = "";
    var strFailFunc = "fnfailResult";
    if (Number === 1) {
        strCallBackFunc = "fnDataSuccResult";
    } else {
        intListNumber++;
        strCallBackFunc = "fnDataPageSuccResult";
    }
    

    var objParam = {
        CallType: "ConsignorList",
        UseFlag: $("#UseFlag").val(),
        CenterCode: $("#CenterCode").val(),
        ConsignorName: $("#ConsignorName").val(),
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
                strText += "<li onclick=\"fnConsignorDetail(" + objRes[0].data.list[i].ConsignorCode +");\">";
                strText += "<table><colgroup><col style=\"width:20%\"/><col style=\"width:80%\"/></colgroup>";
                strText += "<thead>";
                strText += "<tr>";
                strText += "<th colspan=\"2\">";
                strText += "<strong style=\"opacity:0.7;\">" + objRes[0].data.list[i].CenterName  +"</strong>";
                strText += "</th>";
                strText += "</tr>";
                strText += "</thead>";
                strText += "<tbody>";
                strText += "<tr>";
                strText += "<td>화주명</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ConsignorName +"</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>비고</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ConsignorNote +"</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "</tbody>";
                strText += "</table>";
                strText += "</li>";
            }
            if (objRes[0].data.RecordCnt > 10) {
                $("div.more_list").show();
                $("div.more_list button").attr("onclick", "fnCallResultData(" + intListNumber +")")
            }else{
                $("div.more_list").hide();
                $("div.more_list button").attr("onclick", "");
            }
        }
        $("#TotalCount").text(UTILJS.Util.fnComma(objRes[0].data.RecordCnt));
        $("#ConsignorData").html(strText);
    }
    fnSlideSearch();
}

function fnDataPageSuccResult(objRes) {
    var strText = "";
    if (objRes) {
        if (objRes[0].data.RecordCnt > 0) {
            for (var i = 0; i < objRes[0].data.list.length; i++) {
                strText += "<li onclick=\"fnConsignorDetail(" + objRes[0].data.list[i].ConsignorCode +");\">";
                strText += "<table><colgroup><col style=\"width:20%\"/><col style=\"width:80%\"/></colgroup>";
                strText += "<thead>";
                strText += "<tr>";
                strText += "<th colspan=\"2\">";
                strText += "<strong>" + objRes[0].data.list[i].CenterName + "</strong>";
                strText += "</th>";
                strText += "</tr>";
                strText += "</thead>";
                strText += "<tbody>";
                strText += "<tr>";
                strText += "<td>화주명</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ConsignorName + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>비고</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ConsignorNote + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "</tbody>";
                strText += "</table>";
                strText += "</li>";
            }
            $("div.more_list button").attr("onclick", "fnCallResultData(" + intListNumber + ")");
            $("#ConsignorData").append(strText);
            if (objRes[0].data.RecordCnt === $("#ConsignorData li").size()) {
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

function fnConsignorDetail(ConsignorCode) {
    location.href = '/APP/TMS/Client/ConsignorIns?HidMode=Update&ConsignorCode=' + ConsignorCode + "&HidParam=" + $("#HidParam").val();
}

function fnDataIns() {
    location.href = '/APP/TMS/Client/ConsignorIns?HidMode=Insert&HidParam=' + $("#HidParam").val();
}