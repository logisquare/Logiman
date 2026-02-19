$(document).ready(function () {
    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // f2
        if (event.keyCode === 113) {
            $("#BtnRegSQI").click();
            return false;
        }
    });

    $("#YMD").datepicker({
        dateFormat: "yy-mm-dd"
    });
    $("#YMD").datepicker("setDate", GetDateToday("-"));

    /**
      * 버튼 이벤트
      */
    //등록
    $("#BtnRegSQI").on("click", function (e) {
        fnInsSQI();
        return false;
    });

    //삭제
    $("#BtnDelSQI").on("click", function (e) {
        if (!$("#SQISeqNo").val()) {
            return false;
        }
        fnDelSQI();
        return false;
    });

    fnSetInitData();
});

//기본정보 세팅
function fnSetInitData() {
    fnCallSQIDetail();
    $("#ItemSeqNo").focus();
}

//데이터 세팅
function fnCallSQIDetail() {
    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnSQIDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";
    var strCallType = $("#HidMode").val() === "Update" ? "SQIList" : "OrderList";
    var objParam = {
        CallType: strCallType,
        OrderType: $("#OrderType").val(),
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        SQISeqNo: $("#SQISeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

var strItemSeqNo = "";
function fnSQIDetailSuccResult(objRes) {
    strItemSeqNo = "";

    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnCallDetailFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];

        $("#OrderItemCode").val(item.OrderItemCode);

        //Textbox
        $.each($("input[type='text']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($(input).attr("id").indexOf("YMD") > -1) {
                        if (eval("item." + $(input).attr("id")).length == 8) {
                            $("#" + $(input).attr("id")).val(fnGetStrDateFormat(eval("item." + $(input).attr("id")), "-"));
                        } else {
                            $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                        }
                    } else {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });

        //Textarea
        $.each($("textarea"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //Select
        $.each($("select"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id")) + "']").length > 0) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });

        //Span
        $.each($("Span"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).text(eval("item." + $(input).attr("id")));
                }
            });
        strItemSeqNo = item.ItemSeqNo;
        fnCallSQIItem();
    } else {
        fnCallDetailFailResult();
    }
}

function fnCallDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

function fnCallSQIItem(intItemSeqNo) {
    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnCallSQIItemSuccResult";
    var strFailCallBackFunc = "fnCallSQIItemFailResult";
    var objParam = {
        CallType: "SQIItemList",
        CenterCode: $("#CenterCode").val(),
        OrderItemCode: $("#OrderItemCode").val(),
        SelectedItemSeqNo : intItemSeqNo
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCallSQIItemSuccResult(objRes ) {

    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSQIItemFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt === 0) {
            fnCallSQIItemFailResult();
            return false;
        }

        $("#ItemSeqNo option").remove();
        $("#ItemSeqNo").append("<option value=''>선택</option>");
        $.each(objRes[0].data.list,
            function(index, item) {
                $("#ItemSeqNo").append("<option value='" + item.ItemSeqNo + "' " + (item.ItemSeqNo == strItemSeqNo ? "selected" : "") + ">" + item.ItemName + "</option>");
            });
    } else {
        fnCallSQIItemFailResult();
    }
}

function fnCallSQIItemFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

//SQI 등록/수정
function fnInsSQI() {
    var strConfMsg = "";
    var strCallType = "";

    if (!$("#ItemSeqNo").val()) {
        fnDefaultAlertFocus("이슈 유형을 선택하세요.", "ItemSeqNo", "warning");
        return;
    }

    if (!$("#YMD").val()) {
        fnDefaultAlertFocus("발생일을 선택하세요.", "YMD", "warning");
        return;
    }

    if (!$("#Team").val()) {
        fnDefaultAlertFocus("담당팀 / 성명을 입력하세요.", "Team", "warning");
        return;
    }

    if (!$("#Contents").val()) {
        fnDefaultAlertFocus("이슈 내용을 입력하세요.", "Contents", "warning");
        return;
    }

    strCallType = "SQI" + $("#HidMode").val();
    strConfMsg = "서비스 이슈를 " + ($("#HidMode").val() === "Update" ? "수정" : "등록");
    strConfMsg += "하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsSQIProc", fnParam);
    return;
};

function fnInsSQIProc(fnParam) {
    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnAjaxInsSQI";

    var objParam = {
        CallType: fnParam,
        SQISeqNo: $("#SQISeqNo").val(),
        OrderType: $("#OrderType").val(),
        OrderNo: $("#OrderNo").val(),
        CenterCode: $("#CenterCode").val(),
        ItemSeqNo: $("#ItemSeqNo").val(),
        YMD: $("#YMD").val(),
        Detail: $("#Detail").val(),
        Team: $("#Team").val(),
        Contents: $("#Contents").val(),
        Action: $("#Action").val(),
        Cause: $("#Cause").val(),
        FollowUp: $("#FollowUp").val(),
        Cost: $("#Cost").val(),
        Measure: $("#Measure").val(),
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsSQI(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
    } else {
        if ($("#HidMode").val() === "Insert") {
            $("#SQISeqNo").val(objRes[0].SQISeqNo);
        }
        fnDefaultAlert("서비스 이슈가 " + ($("#HidMode").val() === "Update" ? "수정" : "등록") + "되었습니다.", "info", "fnGoSQIView()");
        return false;
    }
}

//서비스 이슈 삭제
function fnDelSQI() {
    fnDefaultConfirm("서비스 이슈 정보를 삭제 하시겠습니까?", "fnDelSQIProc", "");
}

//서비스 이슈 삭제처리
function fnDelSQIProc() {
    if (!$("#SQISeqNo").val()) {
        fnDefaultAlert("삭제할 서비스 이슈 정보가 없습니다.", "info");
        return false;
    }

    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnDelSQISuccResult";
    var strFailCallBackFunc = "fnDelSQIFailResult";
    var objParam = {
        CallType: "SQIDelete",
        OrderType: $("#OrderType").val(),
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        SQISeqNo: $("#SQISeqNo").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnDelSQISuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("서비스 이슈가 삭제되었습니다.", "info", "fnGoSQIList()");
            return false;
        } else {
            fnDelSQIFailResult();
            return false;
        }
    } else {
        fnDelSQIFailResult();
        return false;
    }
}

function fnDelSQIFailResult() {
    fnDefaultAlert("서비스 이슈 삭제에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning");
    return false;
}

//뷰페이지로 이동
function fnGoSQIView() {
    if (!$("#OrderType").val() || !$("#CenterCode").val() || !$("#OrderNo").val() || !$("#SQISeqNo").val()) {
        return false;
    }
    var url = "/TMS/Common/SQIDetailView?OrderType=" + $("#OrderType").val() + "&CenterCode=" + $("#CenterCode").val() + "&OrderNo=" + $("#OrderNo").val() + "&SQISeqNo=" + $("#SQISeqNo").val();
    document.location.replace(url);
}

//목록페이지로 이동
function fnGoSQIList() {
    if (!$("#OrderType").val() || !$("#CenterCode").val() || !$("#OrderNo").val()) {
        return false;
    }
    var url = "/TMS/Common/SQIDetailList?OrderType=" + $("#OrderType").val() + "&CenterCode=" + $("#CenterCode").val() + "&OrderNo=" + $("#OrderNo").val();
    document.location.replace(url);
}
