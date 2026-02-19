$(document).ready(function () {
    if ($("#HidCallType").val() !== "") {
        fnCallResultData(1);
    }
});

var intListNumber = 2; //리스트 더보기 기본 2부터 셋팅
//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallResultData(Number) {

    var strHandlerURL = "/APP/TMS/Car/Proc/AppCarDispatchRefHandler.ashx";
    var strCallBackFunc = "";
    var strFailFunc = "fnfailResult";
    if (Number === 1) {
        strCallBackFunc = "fnDataSuccResult";
    } else {
        intListNumber++;
        strCallBackFunc = "fnDataPageSuccResult";
    }
    

    var objParam = {
        CallType: "CarDispatchList",
        CenterCode: $("#CenterCode").val(),
        UseFlag: $("#UseFlag").val(),
        ComName: $("#ComName").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        CarDivType: $("#CarDivType").val(),
        CarNo: $("#CarNo").val(),
        DriverName: $("#DriverName").val(),
        DriverCell: $("#DriverCell").val(),
        CooperatorFlag: $("#CooperatorFlag").is(":checked") ? "Y" : "",
        CargoManFlag: $("#CargoManFlag").is(":checked") ? "Y" : "",
        PageNo: Number,
        PageSize: $("#PageSize").val(),
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
                strText += "<li onclick=\"fnLocationDetail(" + objRes[0].data.list[i].RefSeqNo + ");\">";
                strText += "<table><colgroup><col style=\"width:40%\"/><col style=\"width:60%\"/></colgroup>";
                strText += "<thead>";
                strText += "<tr>";
                strText += "<th>";
                strText += "<strong>" + objRes[0].data.list[i].CenterName + "</strong>";
                strText += "</th>";
                strText += "<th style=\"text-align:right;\">";
                strText += "<span class=\"car_div_type\">" + objRes[0].data.list[i].CarDivTypeM + "</span>";
                if (objRes[0].data.list[i].CooperatorFlag === "Y") {
                    strText += "<span class=\"flag\">협력업체</span>";
                }
                if (objRes[0].data.list[i].CargoManFlag === "Y") {
                    strText += "<span class=\"flag\">카고맨</span>";
                }
                strText += "</th>";
                strText += "</tr>";
                strText += "</thead>";
                strText += "<tbody>";
                strText += "<tr>";
                strText += "<td>차량번호</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].CarNo + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>차종</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].CarTypeCodeM + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>톤수</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].CarTonCodeM + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>기사명</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].DriverName + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>휴대폰</td>";
                strText += "<td>";
                strText += "<span>" + fnMakeCellNo(objRes[0].data.list[i].DriverCell) + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>사업자번호</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ComCorpNo + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>업체명</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ComName + "</span>";
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
        $("#CarData").html(strText);
    }
    fnSlideSearch();
}

function fnDataPageSuccResult(objRes) {
    var strText = "";
    if (objRes) {
        if (objRes[0].data.RecordCnt > 0) {
            for (var i = 0; i < objRes[0].data.list.length; i++) {
                strText += "<li onclick=\"fnLocationDetail(" + objRes[0].data.list[i].RefSeqNo +");\">";
                strText += "<table><colgroup><col style=\"width:40%\"/><col style=\"width:60%\"/></colgroup>";
                strText += "<thead>";
                strText += "<tr>";
                strText += "<th>";
                strText += "<strong>" + objRes[0].data.list[i].CenterName + "</strong>";
                strText += "</th>";
                strText += "<th style=\"text-align:right;\">";
                strText += "<span class=\"car_div_type\">" + objRes[0].data.list[i].CarDivTypeM + "</span>";
                if (objRes[0].data.list[i].CooperatorFlag === "Y") {
                    strText += "<span class=\"flag\">협력업체</span>";
                }
                if (objRes[0].data.list[i].CargoManFlag === "Y") {
                    strText += "<span class=\"flag\">카고맨</span>";
                }
                strText += "</th>";
                strText += "</tr>";
                strText += "</thead>";
                strText += "<tbody>";
                strText += "<tr>";
                strText += "<td>차량번호</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].CarNo + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>차종</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].CarTypeCodeM + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>톤수</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].CarTonCodeM + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>기사명</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].DriverName + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>휴대폰</td>";
                strText += "<td>";
                strText += "<span>" + fnMakeCellNo(objRes[0].data.list[i].DriverCell) + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>사업자번호</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ComCorpNo + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "<tr>";
                strText += "<td>업체명</td>";
                strText += "<td>";
                strText += "<span>" + objRes[0].data.list[i].ComName + "</span>";
                strText += "</td>";
                strText += "</tr>";
                strText += "</tbody>";
                strText += "</table>";
                strText += "</li>";
            }
            $("div.more_list button").attr("onclick", "fnCallResultData(" + intListNumber + ")");
            $("#CarData").append(strText);
            if (objRes[0].data.RecordCnt === $("#CarData li").size()) {
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

function fnLocationDetail(RefSeqNo) {
    location.href = "/APP/TMS/Car/CarDispatchRefIns?HidMode=Update&RefSeqNo=" + RefSeqNo + "&HidParam=" + $("#HidParam").val();
    return;
}

function fnDataIns() {
    location.href = '/APP/TMS/Car/CarDispatchRefIns?HidMode=Insert&HidParam=' + $("#HidParam").val();
}