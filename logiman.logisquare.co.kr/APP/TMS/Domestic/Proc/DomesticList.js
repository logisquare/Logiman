$(document).ready(function () {
    fnSetDate();
    fnBtnCheckOn();
    if ($("#HidCallType").val() !== "") {
        if ($("#HidCode").val() !== "") {
            var strCodeText = "";
            var strCodes = $("#HidCode").val().split("^");
            for (var nArrCnt in strCodes) {
                $("#OrderLocationCode input[value=" + strCodes[nArrCnt] + "]").prop("checked", true);
                strCodeText += $("#OrderLocationCode input[value=" + strCodes[nArrCnt] + "] + label").text() + ",";
            }
            if (strCodes.length === $("#OrderLocationCode input").length - 1) {
                $("#OrderLocationCode input[value='']").prop("checked", true);
            }
            $("#ViewOrderLocationCode").val(strCodeText.substr(0, strCodeText.length - 1));
        }
        $("#DateChoice li").removeClass("check");
        $("#DateChoice li:nth-child(" + $("#HidDateSel").val() +")").addClass("check");
        fnDateChoice(Number($("#HidDateSel").val()));
        fnCallData();
    } else {
        $("#ChkMyCharge").prop("checked", true);
    }
});

function fnSetDate() {
    if ($("#HidCallType").val() === "") {
        fnChangeDate("1", "DateYMD");
        $("#HidDateSel").val("1");
    }
    
}

function fnBtnCheckOn() {
    $("#DateChoice li").on("click", function () {
        $("#DateChoice li").removeClass("check");
        $(this).addClass("check");
    });

    $("#OrderChoice li").on("click", function () {
        $("#OrderChoice li").removeClass("check");
        $(this).addClass("check");
    });

    $("#ViewOrderLocationCode").on("click", function () {
        fnLocationView();
    });
}

function fnDateChoice(type) {
    $("table#DateTable").hide();
    if (type === 1) {
        //오늘
        fnChangeDate("1", "DateYMD");
    } else if (type === 2) {
        //내일
        fnChangeDate("2", "DateYMD");
    } else if (type === 3) {
        //직접선택
        $("table.tb_type_date").show();
    }
    $("#HidDateSel").val(type);
}

function fnSlideSearch() {
    $("div.search_area").slideToggle(500);
    $("div.search_up button").toggleClass("down");
}

function fnLocationView() {
    $("#OrderLocationMulti").toggle();
}

function fnMoveToPage(goPage) {
    //이동할 페이지 세팅
    $("#PageNo").val(goPage);

    // rowCount 만큼 데이터 요청
    fnCallData();
}

function fnCallData() {

    $("#RecordCnt").val("0");
    $("#TotalPageCnt").val("0");
    $("#TotalCount").html("0");
    $(".more_list").hide();

    if ($("#PageNo").val() == "1") {
        $("ul.domestic").html("");
    }

    var LocationCode = [];

    var strHandlerURL = "/APP/TMS/Domestic/Proc/DomesticHandler.ashx";
    var strCallBackFunc = "fnCallDataSuccResult";

    $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            LocationCode.push($(el).val());
        }
    });

    var objParam = {
        CallType: "DomesticList",
        CenterCode: $("#CenterCode").val(),
        DateType: $("#DateType").val(),
        DateYMD: $("#DateYMD").val(),
        OrderLocationCodes: LocationCode.join("^"),
        SearchClientType: $("#SearchClientType").val(),
        SearchClientText: $("#SearchClientText").val(),
        SearchPlaceType: $("#SearchPlaceType").val(),
        SearchPlaceText: $("#SearchPlaceText").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        CarNo: $("#CarNo").val(),
        DriverName: $("#DriverName").val(),
        MyChargeFlag: $("#ChkMyCharge").is(":checked") ? "Y" : "N",
        MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N",
        CnlFlag: $("#ChkCnl").is(":checked") ? "Y" : "N",
        SortType: $("#SortType").val(),
        PageNo: $("#PageNo").val(),
        PageSize: $("#PageSize").val(),
        //백버튼에 사용 될 파라미터(오늘,내일,날짜 선택 타입)
        HidDateSel: $("#HidDateSel").val()
    };
    $("#HidParam").val(JSON.stringify(objParam));
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDataSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        var TotalCnt = objRes[0].data.RecordCnt;
        var PageSize = $("#PageSize").val();
        var TotalPageCnt = 0;

        try {
            TotalCnt = parseInt(TotalCnt);
        } catch (e) {
            TotalCnt = 0;
        }

        try {
            PageSize = parseInt(PageSize);
        } catch (e) {
            PageSize = 0;
        }

        if (PageSize > 0) {
            TotalPageCnt = parseInt(TotalCnt / PageSize) + (TotalCnt % PageSize > 0 ? 1 : 0);
        }

        $("#RecordCnt").val(TotalCnt);
        $("#TotalCount").text(UTILJS.Util.fnComma(TotalCnt));
        $("#TotalPageCnt").val(TotalPageCnt);

        var html = $("ul.domestic").html();
        $.each(objRes[0].data.list, function (index, item) {

            html += "<li onclick=\"fnOrderDetail('" + item.OrderNo + "'); return false;\">";
            html += "\t<table>";
            html += "\t\t<colgroup>";
            html += "\t\t\t<col style=\"width: 35%\"/>";
            html += "\t\t\t<col style=\"width: 30%\"/>";
            html += "\t\t\t<col style=\"width: 35%\"/>";
            html += "\t\t</colgroup>";
            html += "\t\t<thead>";
            html += "\t\t\t<tr>";
            html += "\t\t\t\t<th>";
            html += "\t\t\t\t\t<span>" + fnGetStrDateFormat(item.PickupYMD.toString(),".") + " " + fnGetHMFormat(item.PickupHM.toString()) + "</span>";
            html += "\t\t\t\t\t<strong>" + item.PickupPlace + "</strong>";
            html += "\t\t\t\t</th>";
            html += "\t\t\t\t<th>";
            html += "\t\t\t\t\t<img src=\"/APP/images/navi_icon.png\" class=\"navi_icon\"/>";
            html += "\t\t\t\t</th>";
            html += "\t\t\t\t<th>";
            html += "\t\t\t\t\t<span>" + fnGetStrDateFormat(item.GetYMD.toString(), ".") + " " + fnGetHMFormat(item.GetHM.toString()) + "</span>";
            html += "\t\t\t\t\t<strong>" + item.GetPlace + "</strong>";
            html += "\t\t\t\t</th>";
            html += "\t\t\t</tr>";
            html += "\t\t</thead>";
            html += "\t\t<tbody>";
            html += "\t\t\t<tr>";
            html += "\t\t\t\t<td colspan=\"3\">";
            html += "\t\t\t\t\t<span class=\"dispatch_" + item.GoodsDispatchType + "\">" + item.GoodsDispatchTypeM + "</span>";
            html += "\t\t\t\t\t<span class=\"status_" + item.OrderStatusNumber + "\">" + item.OrderStatusM + "</span>";
            if (item.TransType > 1) {
                html += "\t\t\t\t\t<span class=\"trans_" + item.TransType + "\">" + item.TransTypeM + "</span>";
            }
            if (item.ContractType > 1) {
                html += "\t\t\t\t\t<span class=\"contract_" + item.ContractType + "\">" + item.ContractTypeM + "</span>";
            }
            html += "\t\t\t\t</td>";
            html += "\t\t\t</tr>";
            html += "\t\t\t<tr>";
            html += "\t\t\t\t<td>오더번호</td>";
            html += "\t\t\t\t<td colspan=\"2\">";
            html += "\t\t\t\t\t<span>" + item.OrderNo + "</span>";
            html += "\t\t\t\t</td>";
            html += "\t\t\t</tr>";
            html += "\t\t\t<tr>";
            html += "\t\t\t\t<td>회원사</td>";
            html += "\t\t\t\t<td colspan=\"2\">";
            html += "\t\t\t\t\t<span>" + item.CenterName + "</span>";
            html += "\t\t\t\t</td>";
            html += "\t\t\t</tr>";
            html += "\t\t\t<tr>";
            html += "\t\t\t\t<td>화주명</td>";
            html += "\t\t\t\t<td colspan=\"2\">";
            html += "\t\t\t\t\t<span>" + item.ConsignorName + "</span>";
            html += "\t\t\t\t</td>";
            html += "\t\t\t</tr>";
            html += "\t\t\t<tr>";
            html += "\t\t\t\t<td>매출</td>";
            html += "\t\t\t\t<td colspan=\"2\">";
            html += "\t\t\t\t\t<span class=\"point\">" + fnMoneyComma(item.SaleSupplyAmt.toString()) + "</span>";
            html += "\t\t\t\t</td>";
            html += "\t\t\t</tr>";
            html += "\t\t\t<tr>";
            html += "\t\t\t\t<td>매입</td>";
            html += "\t\t\t\t<td colspan=\"2\">";
            html += "\t\t\t\t\t<span class=\"point2\">" + fnMoneyComma(item.PurchaseSupplyAmt.toString()) + "</span>";
            html += "\t\t\t\t</td>";
            html += "\t\t\t</tr>";
            html += "\t\t\t<tr>";
            html += "\t\t\t\t<td>배차차량번호</td>";
            html += "\t\t\t\t<td colspan=\"2\">";
            html += "\t\t\t\t\t<span>" + item.PickupDispatchCarNo + "</span>";
            html += "\t\t\t\t</td>";
            html += "\t\t\t</tr>";
            html += "\t\t\t<tr>";
            html += "\t\t\t\t<td>요청톤급 / 차종</td>";
            html += "\t\t\t\t<td colspan=\"2\">";
            html += "\t\t\t\t\t<span>" + item.CarTonCodeM + "</span> / <span>" + item.CarTypeCodeM + "</span>";
            html += "\t\t\t\t</td>";
            html += "\t\t\t</tr>";
            html += "\t\t</tbody>";
            html += "\t</table>";
            html += "</li>";
        });

        $("ul.domestic").html(html);
        
        if (TotalPageCnt > 1 && $("#PageNo").val() != $("#TotalPageCnt").val()) {
            $(".more_list").show();
            $(".more_list button").text("더보기 (" + $("#PageNo").val() + "/" + $("#TotalPageCnt").val() +")");
        }

        if ($(".search_area").css("display") != "none") {
            fnSlideSearch();
        }
    }
}

function fnCallDataMore() {
    if ($("#PageNo").val() == $("#TotalPageCnt").val()) {
        return false;
    }
    var PageNo = $("#PageNo").val();

    try {
        PageNo = parseInt(PageNo);
    } catch (e) {
        PageNo = 0;
    }

    $("#PageNo").val(PageNo + 1);
    fnCallData();
};

//오더 상세
function fnOrderDetail(strOrderNo) {
    document.location.href = "/APP/TMS/Domestic/DomesticDetail?OrderNo=" + strOrderNo + "&HidParam=" + $("#HidParam").val();
}

function fnDataIns() {
    document.location.href = '/APP/TMS/Domestic/DomesticIns?HidMode=Insert&HidParam=' + $("#HidParam").val();
}