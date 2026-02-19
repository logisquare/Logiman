$(document).ready(function () {
    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // f2
        if (event.keyCode === 113) {
            $("#BtnRegSQI").click();
            return false;
        }
    });
    fnSetInitData();
});

function fnSetInitData() {
    fnCallOrderDetail();
}

function fnCallOrderDetail() {
    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnCallOrderDetailSuccResult";
    var strFailCallBackFunc = "fnCallOrderDetailFailResult";
    var strCallType = "OrderList";
    var objParam = {
        CallType: strCallType,
        OrderType: $("#OrderType").val(),
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnCallOrderDetailSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnCallOrderDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnCallOrderDetailFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];
        //Span
        $.each($("Span"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).text(eval("item." + $(input).attr("id")));
                }
            });
        fnCallSQIList();
    } else {
        fnCallOrderDetailFailResult();
    }
}

function fnCallOrderDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

function fnCallSQIList() {
    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnCallSQIListSuccResult";
    var strFailCallBackFunc = "fnCallSQIListFailResult";
    var strCallType = "SQIList";
    var objParam = {
        CallType: strCallType,
        OrderType: $("#OrderType").val(),
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}


function fnCallSQIListSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSQIListFailResult();
            return false;
        }

        var html = "";
        $.each(objRes[0].data.list,
            function(index, item) {
                html += "<tr>\n";
                html += "\t<td><a href=\"#\" onclick=\"fnGoViewSQI(" + item.SQISeqNo + "); \">" + item.Contents + " [" + item.CommentCnt + "]</a></td>\n";
                html += "\t<td>" + item.YMD + "</td>\n";
                html += "\t<td>" + item.RegAdminName + "</td>\n";
                html += "\t<td>" + item.RegDate + "</td>\n";
                html += "\t<td>\n";
                html += "\t\t<button type=\"button\" class=\"btn_02\" onclick=\"fnGoEditSQI(" + item.SQISeqNo + "); \">수정</button>\n";
                html += "\t\t<button type=\"button\" class=\"btn_03\" onclick=\"fnDelSQI(" + item.SQISeqNo + "); \">삭제</button>\n";
                html += "\t</td>\n";
                html += "</tr>\n";
            });

        $("#SQIList").html(html);
    } else {
        fnCallSQIListFailResult();
    }
}

function fnCallSQIListFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

//서비스 이슈 등록
function fnGoInsSQI() {
    if (!$("#OrderType").val() || !$("#CenterCode").val() || !$("#OrderNo").val()) {
        return false;
    }
    var url = "/TMS/Common/SQIDetailIns?OrderType=" + $("#OrderType").val() + "&CenterCode=" + $("#CenterCode").val() + "&OrderNo=" + $("#OrderNo").val();
    document.location.href = url;
}

//서비스 이슈 수정
function fnGoEditSQI(intSeqNo) {
    if (!$("#OrderType").val() || !$("#CenterCode").val() || !$("#OrderNo").val()) {
        return false;
    }
    var url = "/TMS/Common/SQIDetailIns?OrderType=" + $("#OrderType").val() + "&CenterCode=" + $("#CenterCode").val() + "&OrderNo=" + $("#OrderNo").val() + "&SQISeqNo=" + intSeqNo;
    document.location.href = url;
}


//서비스 이슈 보기
function fnGoViewSQI(intSeqNo) {
    if (!$("#OrderType").val() || !$("#CenterCode").val() || !$("#OrderNo").val()) {
        return false;
    }
    var url = "/TMS/Common/SQIDetailView?OrderType=" + $("#OrderType").val() + "&CenterCode=" + $("#CenterCode").val() + "&OrderNo=" + $("#OrderNo").val() + "&SQISeqNo=" + intSeqNo;
    document.location.href = url;
}


//서비스 이슈 삭제
function fnDelSQI(intSeqNo) {
    fnDefaultConfirm("서비스 이슈 정보를 삭제 하시겠습니까?", "fnDelSQIProc", intSeqNo);
}

//서비스 시유 삭제처리
function fnDelSQIProc(intSeqNo) {
    if (intSeqNo == null || intSeqNo == 0) {
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
        SQISeqNo: intSeqNo
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

//목록페이지로 이동
function fnGoSQIList() {
    if (!$("#OrderType").val() || !$("#CenterCode").val() || !$("#OrderNo").val()) {
        return false;
    }
    var url = "/TMS/Common/SQIDetailList?OrderType=" + $("#OrderType").val() + "&CenterCode=" + $("#CenterCode").val() + "&OrderNo=" + $("#OrderNo").val();
    document.location.replace(url);
}
