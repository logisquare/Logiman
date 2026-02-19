$(document).ready(function () {
    $("#CenterCode").on("change", function() {
        if ($(this).val()) {
            fnGoCurrent();
        }
    });

    if ($("#CenterCode").val()) {
        fnGoCurrent();
    }
});

//이전연도
function fnGoPrev() {
    var strYear = $("#HidYear").val();

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (strYear == "") {
        strYear = date.getFullYear() + "";
    }

    $("#HidYear").val(parseInt(strYear) - 1);
    fnGoCurrent();
}

//현재연도
function fnGoCurrent() {
    var strYear = $("#HidYear").val();

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (strYear == "") {
        strYear = date.getFullYear() + "";
    }

    $("#HidYear").val(strYear);
    $("#SpanYear").text($("#HidYear").val());
    $("#SpanTotalCnt").text(0);
    $("#SpanTotalAmt").text(0);
    $(".day_remit_pay_od span").text(0);

    var strHandlerURL = "/TMS/ClosingPurchase/Proc/PurchaseQuickHandler.ashx";
    var strCallBackFunc = "fnGoCurrentSuccResult";
    var strFailCallBackFunc = "fnGoCurrentFailResult";

    var objParam = {
        CallType: "PurchaseQuickMonthPayList",
        CenterCode: $("#CenterCode").val(),
        Year: $("#HidYear").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnGoCurrentSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if(objRes[0].RetCode != 0) {
                fnGoCurrentFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnGoCurrentFailResult(objRes[0].result.ErrorMsg);
            return false;
        }

        var TotalCnt = 0;
        var TotalAmt = 0;
        $.each(objRes[0].data.list, function(index, item) {
            var month = parseInt(item.PickupYM.substr(4, 2));
            $("#SpanCnt" + month).text(UTILJS.Util.fnComma(item.PurchaseCnt));
            $("#SpanAmt" + month).text(fnMoneyComma(item.PurchaseOrgAmt));
            TotalCnt += item.PurchaseCnt;
            TotalAmt += item.PurchaseOrgAmt;
        });

        $("#SpanTotalCnt").text(UTILJS.Util.fnComma(TotalCnt));
        $("#SpanTotalAmt").text(fnMoneyComma(TotalAmt));

        //데이터 세팅
    } else {
        fnGoCurrentFailResult();
    }
}

function fnGoCurrentFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("나중에 다시 시도해 주세요." + msg);
    return false;
}

//다음연도
function fnGoNext() {
    var strYear = $("#HidYear").val();

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (strYear == "") {
        strYear = date.getFullYear() + "";
    }

    $("#HidYear").val(parseInt(strYear) + 1);

    fnGoCurrent();
}

//조회조건 세팅
function fnSetSearchCondition(intMonth) {
    var strY = $("#HidYear").val();

    var date = new Date(strY, intMonth - 1, 1);
    var date_from = fnGetDateFormat(date, "-");
    date = new Date(strY, intMonth, 0);
    var date_to = fnGetDateFormat(date, "-");

    if (!$("#CenterCode").val() || !$("#HidYear").val()) {
        fnDefaultAlert("내역 조회 후 이용할 수 있습니다.", "warning");
        return false;
    }

    parent.$("#BtnResetListSearch").click();
    parent.$("#CenterCode").val($("#CenterCode").val());
    parent.$("#DateFrom").val(date_from);
    parent.$("#DateTo").val(date_to);
    parent.$("#ClosingFlag").val("N");
    parent.$("#BtnListSearch").click();
    parent.fnCloseCpLayer();
}