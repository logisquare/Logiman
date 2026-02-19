$(document).ready(function () {
    fnSetInitData();
    fnSetFocus();
});

//기본정보 세팅
function fnSetInitData() {
    if ($("#HidErrMsg").val()) {
        fnDefaultAlert($("#HidErrMsg").val(), "warning", "fnWindowClose()");
        return false;
    }

    var cnt = $("#OrderNos").val().split(",").length;
    $(".title_cnt").text(cnt);

    fnCallOrderCopyCalendar();
}

function fnSetFocus() {
    if ($("#OrderCnt option").length === 1) {
        $("#GetYMDType").focus();
    } else {
        $("#OrderCnt").focus();
    }
}

//오더 데이터 세팅
function fnCallOrderCopyCalendar() {

    var strHandlerURL = "/TMS/Common/Proc/OrderCopyHandler.ashx";
    var strCallBackFunc = "fnCallOrderCopyCalendarSuccResult";
    var strFailCallBackFunc = "fnCallOrderCopyCalendarFailResult";

    var objParam = {
        CallType: "CalendarList"
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCallOrderCopyCalendarSuccResult(objRes) {
    var strYM = "";
    var strBYM = "";
    var strYMD = "";
    var strMaxDay = "";
    var strHolidayFlag = "";
    var strOnOff = "";
    var intWeekNum = 0;
    var strHtml = "";

    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnCallOrderCopyCalendarFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnCallOrderCopyCalendarFailResult();
            return false;
        }

        $.each(objRes[0].data.list, function (index, item) {
            strYM = item.YMD.substr(0, 6);
            strMaxDay = item.MaxDay;
            strYMD = item.YMD;
            strHolidayFlag = item.HolidayFlag;
            strOnOff = item.OnOff;
            intWeekNum = parseInt(item.WeekNum);

            if (index === 0 || strYM !== strBYM) {
                if (index !== 0) {
                    strHtml += "</tbody>";
                    strHtml += "</table>";
                    strHtml += "</li>";
                }
                strHtml += "<li>";
                strHtml += "<table class=\"copy_table\" > ";
                strHtml += "<colgroup>";
                strHtml += "<col style=\"width: 14.28571428571429 %;\">";
                strHtml += "<col style=\"width: 14.28571428571429 %;\">";
                strHtml += "<col style=\"width: 14.28571428571429 %;\">";
                strHtml += "<col style=\"width: 14.28571428571429 %;\">";
                strHtml += "<col style=\"width: 14.28571428571429 %;\">";
                strHtml += "<col style=\"width: 14.28571428571429 %;\">";
                strHtml += "<col style=\"width: 14.28571428571429 %;\">";
                strHtml += "</colgroup>";
                strHtml += "<thead>";
                strHtml += "<tr>";
                strHtml += "<th colspan=\"7\">";
                strHtml += strYM.substr(0, 4) + "." + strYM.substr(4, 2);
                strHtml += "</th>";
                strHtml += "</tr>";
                strHtml += "</thead>";
                strHtml += "<tbody>";
                strHtml += "<tr>";
                strHtml += "<th>일</th>";
                strHtml += "<th>월</th>";
                strHtml += "<th>화</th>";
                strHtml += "<th>수</th>";
                strHtml += "<th>목</th>";
                strHtml += "<th>금</th>";
                strHtml += "<th>토</th>";
                strHtml += "</tr>";
                strHtml += "</thead>";
                strHtml += "<tbody>";
            }

            //월 시작 빈날짜 세팅
            if (intWeekNum === 1 || strYMD.substr(6, 2) === "01") {
                strHtml += "<tr>";
                if (strYMD.substr(6, 2) === "01") {
                    for (var i = 0; i < intWeekNum - 1; i++)
                    {
                        strHtml += "<td class='off'></td>";
                    }
                }
            }

            if (strOnOff === "off") {
                strHtml += "<td class=\"off\">" + parseInt(strYMD.substr(6, 2)) + "</td>";
            } else {
                strHtml += "<td><input type='checkbox' id='c" + strYMD + "' name=\"PickupYMD\" value='" + strYMD + "'";
                if (strHolidayFlag === "N") {
                    strHtml += " class='biz'";
                }
                strHtml += "><label for='c" + strYMD + "'><span>" + parseInt(strYMD.substr(6, 2)) + "</span></label></td>";
            }

            //월 종료 빈날짜 세팅
            if (strYMD.substr(6, 2) === strMaxDay) {
                for (var i = 0; i < 7 - intWeekNum; i++)
                {
                    strHtml += "<td class='off'></td>";
                }
            }

            if (intWeekNum === 7 || strYMD.substr(6, 2) === strMaxDay) {
                strHtml += "</tr>";
            }

            if (index === objRes[0].data.list -1) {
                strHtml += "</tbody>";
                strHtml += "</table>";
                strHtml += "</li>";
            }

            strBYM = strYM;
        });

        $("#UlCalandar").html(strHtml);
    }
    else {
        fnCallOrderCopyCalendarFailResult();
    }
}

function fnCallOrderCopyCalendarFailResult() {
    fnDefaultAlert("달력 데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "fnWindowClose()");
}

function fnInsOrderCopy() {
    var strConfMsg = "";
    var allCnt = 0;

    if ($("input[id^=c]:checked").length == 0) {
        fnDefaultAlert("상차일을 선택하세요.", "warning");
        return false;
    }

    if ($("input[id^=c]:checked").length > 50) {
        fnDefaultAlert("상차일은 최대 50일까지 선택 가능합니다.", "warning");
        return false;
    }

    if ($("#GetYMDType").length >= 1 && !$("#GetYMDType").val()) {
        fnDefaultAlert("하차일 구분을 선택하세요", "warning", "GetYMDType");
        return false;
    }

    allCnt = $("#OrderNos").val().split(",").length * parseInt($("#OrderCnt").val()) * $("input[id^=c]:checked").length;
    strConfMsg = "[총 " + allCnt + "개] 오더를 복사 하시겠습니까?";

    var fnParam = "";
    if ($("#OrderType").val() === "1") {
        fnParam = "DomesticOrderCopyInsert";
    } else if ($("#OrderType").val() === "2") {
        fnParam = "InoutOrderCopyInsert";
    } else if ($("#OrderType").val() === "3") {
        fnParam = "ContainerOrderCopyInsert";
    }
    fnDefaultConfirm(strConfMsg, "fnInsOrderCopyProc", fnParam);
    return;
}

function fnInsOrderCopyProc(fnParam) {
    var PickupYMDs = [];
    var strHandlerURL = "/TMS/Common/Proc/OrderCopyHandler.ashx";
    var strCallBackFunc = "fnAjaxInsOrderCopy";

    $.each($("input[id ^= c]:checked"), function (i, el) {
        if ($(el).val() !== "") {
            PickupYMDs.push($(el).val());
        }
    });

    var objParam = {
        CallType: fnParam,
        OrderNos: $("#OrderNos").val(),
        CenterCode: $("#CenterCode").val(),
        OrderCnt: $("#OrderCnt").val(),
        PickupYMDs: PickupYMDs.join(","),
        GetYMDType: $("#GetYMDType").val(),
        NoteFlag: $("#NoteFlag").is(":checked") ? "Y" : "N",
        NoteClientFlag: $("#NoteClientFlag").is(":checked") ? "Y" : "N",
        DispatchFlag: $("#DispatchFlag").is(":checked") ? "Y" : "N",
        GoodsFlag: $("#GoodsFlag").is(":checked") ? "Y" : "N",
        ArrivalReportFlag: $("#ArrivalReportFlag").is(":checked") ? "Y" : "N",
        CustomFlag: $("#CustomFlag").is(":checked") ? "Y" : "N",
        BondedFlag: $("#BondedFlag").is(":checked") ? "Y" : "N",
        InTimeFlag: $("#InTimeFlag").is(":checked") ? "Y" : "N",
        QuickGetFlag: $("#QuickGetFlag").is(":checked") ? "Y" : "N",
        TaxChargeFlag: $("#TaxChargeFlag").is(":checked") ? "Y" : "N"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsOrderCopy(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].result.ErrorMsg + ")");
            return false;
        }

        fnDefaultAlert("오더 복사가 완료되었습니다.", "info", "fnWindowClose()");
        return false;
    } else {
        fnDefaultAlert("나중에 다시 시도해 주세요.");
        return false;
    }
}

//영업일 전체 선택
function fnChkAllBizDay(obj) {
    $("input[id^=c]").prop("checked", false);
    if ($(obj).is(":checked")) {
        $("input[id^=c].biz").prop("checked", true);
    }
}