$(document).ready(function () {
    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // f2
        if (event.keyCode === 113) {
            $("#BtnEditSQI").click();
            return false;
        }
    });

    /**
      * 버튼 이벤트
      */
    //삭제
    $("#BtnDelSQI").on("click", function (e) {
        if (!$("#SQISeqNo").val()) {
            return false;
        }
        fnDelSQI();
        return false;
    });

    $("#BtnRegComment").on("click", function (e) {
        if (!$("#SQISeqNo").val()) {
            return false;
        }
        fnInsSQIComment();
        return false;
    });

    
    fnSetInitData();
});

//기본정보 세팅
function fnSetInitData() {
    fnCallSQIDetail();
}

//오더 데이터 세팅
function fnCallSQIDetail() {
    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnSQIDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";
    var strCallType = "SQIList";
    var objParam = {
        CallType: strCallType,
        OrderType: $("#OrderType").val(),
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        SQISeqNo: $("#SQISeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnSQIDetailSuccResult(objRes) {

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

        //Span
        $.each($("Span"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).text(eval("item." + $(input).attr("id")));
                }
            });

        fnCallSQICommentList();
    } else {
        fnCallDetailFailResult();
    }
}

function fnCallDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

//댓글 목록
function fnCallSQICommentList() {
    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnCallSQICommentListSuccResult";
    var strFailCallBackFunc = "fnCallSQICommentListFailResult";
    var strCallType = "SQICommentList";
    var objParam = {
        CallType: strCallType,
        OrderType: $("#OrderType").val(),
        CenterCode: $("#CenterCode").val(),
        SQISeqNo: $("#SQISeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}


function fnCallSQICommentListSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.RetCode) {
            if (objRes[0].result.RetCode !== 0) {
                fnCallSQICommentListFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallSQICommentListFailResult();
            return false;
        }

        var html = "";
        $.each(objRes[0].data.list,
            function (index, item) {
                html += "<tr>\n";
                html += "\t<td>" + item.Contents + "</td>\n";
                html += "\t<td>" + item.RegAdminName + "</td>\n";
                html += "\t<td>" + item.RegDate + "</td>\n";
                html += "\t<td>\n";
                html += "\t\t<button type=\"button\" class=\"btn_03\" onclick=\"fnDelSQIComment(" + item.CommentSeqNo + "); \">삭제</button>\n";
                html += "\t</td>\n";
                html += "</tr>\n";
            });
        $("#SQICommentList").html(html);
    } else {
        fnCallSQICommentListFailResult();
    }
}

function fnCallSQICommentListFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
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

//수정 이동
function fnGoSQIEdit() {
    if (!$("#OrderType").val() || !$("#CenterCode").val() || !$("#OrderNo").val() || !$("#SQISeqNo").val()) {
        return false;
    }
    var url = "/TMS/Common/SQIDetailIns?OrderType=" + $("#OrderType").val() + "&CenterCode=" + $("#CenterCode").val() + "&OrderNo=" + $("#OrderNo").val() + "&SQISeqNo=" + $("#SQISeqNo").val();
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

//코멘트 등록
function fnInsSQIComment() {
    var strConfMsg = "";
    var strCallType = "";

    if (!$("#CommentContents").val()) {
        fnDefaultAlertFocus("댓글 내용을 입력하세요.", "CommentContents", "warning");
        return;
    }

    strCallType = "SQICommentInsert";
    strConfMsg = "댓글을 등록 하시겠습니까?";

    var fnParam = strCallType;
    fnDefaultConfirm(strConfMsg, "fnInsSQICommentProc", fnParam);
    return;
}

function fnInsSQICommentProc(fnParam) {
    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnAjaxInsSQIComment";

    var objParam = {
        CallType: fnParam,
        SQISeqNo: $("#SQISeqNo").val(),
        CenterCode: $("#CenterCode").val(),
        Contents: $("#CommentContents").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsSQIComment(objRes) {
    if (objRes[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + objRes[0].ErrMsg + ")");
    } else {
        fnDefaultAlert("댓글이 등록 되었습니다.", "info", "fnCallSQICommentList()");
        $("#CommentContents").val("");
        return false;
    }
}

//코멘트 삭제
function fnDelSQIComment(intCommentSeqNo) {
    fnDefaultConfirm("댓글을 삭제 하시겠습니까?", "fnDelSQICommentProc", intCommentSeqNo);
}

function fnDelSQICommentProc(intCommentSeqNo) {
    if (intCommentSeqNo == null || intCommentSeqNo == "0") {
        fnDefaultAlert("삭제할 댓글 정보가 없습니다.", "info");
        return false;
    }

    var strHandlerURL = "/TMS/Common/Proc/SQIHandler.ashx";
    var strCallBackFunc = "fnDelSQICommentSuccResult";
    var strFailCallBackFunc = "fnDelSQICommentFailResult";
    var objParam = {
        CallType: "SQICommentDelete",
        CenterCode: $("#CenterCode").val(),
        SQISeqNo: $("#SQISeqNo").val(),
        CommentSeqNo: intCommentSeqNo
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", true);
}

function fnDelSQICommentSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("댓글이 삭제되었습니다.", "info", "fnCallSQICommentList()");
            return false;
        } else {
            fnDelSQICommentFailResult();
            return false;
        }
    } else {
        fnDelSQICommentFailResult();
        return false;
    }
}

function fnDelSQICommentFailResult() {
    fnDefaultAlert("댓글이 삭제에 실패했습니다. 나중에 다시 시도해 주시기 바랍니다.", "warning");
    return false;
}