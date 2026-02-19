$(document).ready(function () {
    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // f2
        if (event.keyCode === 113) {
            $("#BtnRegOrder").click();
            return false;
        }
    });

    $("#PickupYMD").datepicker({
        dateFormat: "yy-mm-dd",
        onSelect: function (dateFromText, inst) {
            var GetYMDText = $("#GetYMD").val().replace(/-/gi, "");
            if (GetYMDText.length !== 8) {
                GetYMDText = GetDateToday("");
            }

            if (parseInt(dateFromText.replace(/-/gi, "")) > parseInt(GetYMDText)) {
                $("#GetYMD").datepicker("setDate", dateFromText);
            }
        },
        minDate : 0
    });
    $("#PickupYMD").datepicker("setDate", GetDateToday("-"));

    $("#GetYMD").datepicker({
        dateFormat: "yy-mm-dd",
        minDate: 0
    });
    $("#GetYMD").datepicker("setDate", GetDateToday("-"));

    //웹오더등록
    $("#BtnRegOrder").on("click", function (e) {
        fnInsOrder();
        return false;
    });
    //웹오더취소
    $("#BtnCancelOrder").on("click", function (e) {
        fnCancelOrderConfirm();
        return false;
    });
    //웹오더복사
    $("#BtnCopyOrder").on("click", function (e) {
        fnCopyOrderConfirm();
        return false;
    });
    //원본오더보기
    $("#BtnOrgOrderView").on("click", function (e) {
        fnOrgOrderDetail();
        return false;
    });
    //변경요청보기
    $("#BtnChangeReq").on("click", function (e) {
        fnChangeReq();
        return false;
    });
    //상차지 주소 검색
    $("#BtnSearchAddrPickupPlace").on("click", function (e) {
        fnOpenAddress("PickupPlace");
        return;
    });

    //하차지 주소 검색
    $("#BtnSearchAddrGetPlace").on("click", function (e) {
        fnOpenAddress("GetPlace");
        return;
    });

    if ($("#HidMode").val() === "Update") {
        $("#BtnRegOrder").text("수정(F2)");
        $("#BtnCancelOrder").show();
    } else {
        $("#BtnChangeReq").remove();
        $("#BtnOrgOrderView").remove();
        $("#BtnCopyOrder").remove();
    }

    if ($("#HidMode").val() === "Update" || ($("#HidMode").val() === "Insert" && $("#CopyFlag").val() === "Y")) {
        fnCallWebOrderDetail();
    }

    fnSetInitAutoComplete();
    fnFileUpload();

    $("#PickupPlaceSearch").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#BtnSearchAddrPickupPlace").click();
            }
        });

    $("#GetPlaceSearch").on("keyup",
        function (event) {
            if (event.keyCode === 13) {
                $("#BtnSearchAddrGetPlace").click();
            }
        });
});

function fnSetInitAutoComplete() {
    if ($("#ConsignorName").length > 0) {
        fnSetAutocomplete({
            formId: "ConsignorName",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ConsignorList",
                    ConsignorName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ConsignorName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ConsignorName,
                getValue: (item) => item.ConsignorName,
                onSelect: (event, ui) => {
                    $("#ConsignorCode").val(ui.item.etc.ConsignorCode);
                    $("#ConsignorName").val(ui.item.etc.ConsignorName);
                    $("#BtnReset").show();
                    $("#ConsignorName").attr("readonly", true);
                }
            }
        });
    }

    //작업지 자동완성
    if ($("#PickupPlace").length > 0) {
        fnSetAutocomplete({
            formId: "PickupPlace",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "PlaceList",
                    PlaceName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.PlaceName,
                getValue: (item) => item.PlaceName,
                onSelect: (event, ui) => {
                    $("#PickupPlace").val(ui.item.etc.PlaceName);
                    $("#PickupPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#PickupPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#PickupPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#PickupPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#PickupPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#PickupPlacePost").val(ui.item.etc.PlacePost);
                    $("#PickupPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#PickupPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#PickupPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#PickupPlaceNote").val(ui.item.etc.PlaceRemark4);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#PickupPlace").val()) {
                        $("#PickupPlaceChargeName").val("");
                        $("#PickupPlaceChargePosition").val("");
                        $("#PickupPlaceTelExtNo").val("");
                        $("#PickupPlaceTelNo").val("");
                        $("#PickupPlaceChargeCell").val("");
                        $("#PickupPlacePost").val("");
                        $("#PickupPlaceAddr").val("");
                        $("#PickupPlaceAddrDtl").val("");
                        $("#PickupPlaceFullAddr").val("");
                        $("#PickupPlaceNote").val("");
                    }
                }
            }
        });
    }

    //하차지 자동완성
    if ($("#GetPlace").length > 0) {
        fnSetAutocomplete({
            formId: "GetPlace",
            width: 650,
            callbacks: {
                getUrl: () => {
                    return "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "PlaceList",
                    PlaceName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.PlaceName,
                getValue: (item) => item.PlaceName,
                onSelect: (event, ui) => {
                    $("#GetPlace").val(ui.item.etc.PlaceName);
                    $("#GetPlaceChargeName").val(ui.item.etc.ChargeName);
                    $("#GetPlaceChargePosition").val(ui.item.etc.ChargePosition);
                    $("#GetPlaceChargeTelExtNo").val(ui.item.etc.ChargeTelExtNo);
                    $("#GetPlaceChargeTelNo").val(ui.item.etc.ChargeTelNo);
                    $("#GetPlaceChargeCell").val(ui.item.etc.ChargeCell);
                    $("#GetPlacePost").val(ui.item.etc.PlacePost);
                    $("#GetPlaceAddr").val(ui.item.etc.PlaceAddr);
                    $("#GetPlaceAddrDtl").val(ui.item.etc.PlaceAddrDtl);
                    $("#GetPlaceFullAddr").val(ui.item.etc.FullAddr);
                    $("#GetPlaceNote").val(ui.item.etc.PlaceRemark4);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("PlaceNCharge", ul, item);
                },
                onBlur: () => {
                    if (!$("#GetPlace").val()) {
                        $("#GetPlaceChargeName").val("");
                        $("#GetPlaceChargePosition").val("");
                        $("#GetPlaceTelExtNo").val("");
                        $("#GetPlaceTelNo").val("");
                        $("#GetPlaceChargeCell").val("");
                        $("#GetPlacePost").val("");
                        $("#GetPlaceAddr").val("");
                        $("#GetPlaceAddrDtl").val("");
                        $("#GetPlaceFullAddr").val("");
                        $("#GetPlaceNote").val("");
                    }
                }
            }
        });
    }
}

function fnFileUpload() {
    $("#FileUpload").fileupload({
        dataType: "json",
        autoUpload: false,
        type: "POST",
        url: "/WEB/Domestic/Proc/WebDomesticFileHandler.ashx?CallType=OrderFileUpload",
        add: function (e, data) {
            var uploadErrors = [];

            if (!$("#CenterCode").val()) {
                uploadErrors.push("회원사를 선택하세요.");
                $("#CenterCode").focus();
            }

            var acceptFileTypes = /(gif|jpe?g|jpg|png|bmp|txt|hwp|doc|docx|pptx?|xlsx?|pdf|zip|tif)/i;
            var fileExt = data.originalFiles[0]["name"].substring(data.originalFiles[0]["name"].lastIndexOf('.') + 1);

            if (!acceptFileTypes.test(fileExt)) {
                uploadErrors.push("첨부할 수 없는 파일확장자입니다.");
            }
            if (data.originalFiles[0]["size"] > 1024 * 1024 * 10) {
                uploadErrors.push("첨부파일 용량은 10MB 이내로 등록가능합니다.");
            }
            if (uploadErrors.length > 0) {
                fnDefaultAlert(uploadErrors.join("<br>"), "warning");
            } else {
                FileDisabled = $("#mainform").find("select:disabled").removeAttr("disabled");
                data.submit();
            }
        },
        success: function (response, status) {
            FileDisabled.attr("disabled", "disabled");
            if (response[0].RetCode == 0) {
                if ($("#OrderStatus").val() === "2") {
                    fnDefaultConfirm("파일 첨부 요청을 하시겠습니까?", "fnReqInsFile", response[0], "", "");
                    return;
                }
                fnAddFile(response[0]);
                return;
            } else {
                fnDefaultAlert(response[0].ErrMsg, "error");
                return;
            }
        },
        error: function (error) {
            FileDisabled.attr("disabled", "disabled");
            // Error callback
            //console.log('error', error);
        }
    });
}

//파일 첨부 요청
function fnReqInsFile(Res) {
    fnAddFile(Res);
    setTimeout(function () {
        fnInsFile();
    }, 200);
}

//파일 목록 추가
function fnAddFile(obj) {
    var addHtml = "";
    addHtml = "<li seq = '" + obj.EncFileSeqNo + "' fname='" + obj.EncFileNameNew + "' flag='" + obj.TempFlag + "' >";
    addHtml += "<a href=\"#\" onclick=\"fnDownloadFile(this); return false;\">" + obj.FileName + "</a> ";
    if ($("#OrderStatus").val() === "2") {
        addHtml += "<a href=\"#\" onclick=\"fnDeleteReqFile(this); return false;\" class=\"file_del\" title=\"파일삭제\">삭제</a>";
    } else {
        addHtml += "<a href=\"#\" onclick=\"fnDeleteFile(this); return false;\" class=\"file_del\" title=\"파일삭제\">삭제</a>";
    }
    addHtml += "</li>\n";
    $("#UlFileList").append(addHtml);
}

//파일 다운로드
function fnDownloadFile(obj) {
    var seq = "";
    var foname = "";
    var fnname = "";
    var flag = "";

    seq = $(obj).parent("li").attr("seq");
    foname = $(obj).text();
    fnname = $(obj).parent("li").attr("fname");
    flag = $(obj).parent("li").attr("flag");

    if (seq == "" || seq == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (foname == "" || foname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (fnname == "" || fnname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (flag == "" || flag == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    var $form = null;

    if ($("form[name=dlFrm]").length == 0) {
        $form = $('<form name="dlFrm"></form>');
        $form.appendTo('body');
    } else {
        $form = $("form[name=dlFrm]");
    }

    $form.attr('action', '/WEB/Domestic/Proc/WebDomesticFileHandler.ashx');
    $form.attr('method', 'post');
    $form.attr('target', 'ifrmFiledown');

    var f1 = $('<input type="hidden" name="CallType" value="OrderFileDownload">');
    var f2 = $('<input type="hidden" name="FileSeqNo" value="' + seq + '">');
    var f3 = $('<input type="hidden" name="FileName" value="' + encodeURI(foname) + '">');
    var f4 = $('<input type="hidden" name="FileNameNew" value="' + fnname + '">');
    var f5 = $('<input type="hidden" name="TempFlag" value="' + flag + '">');
    var f6 = $('<input type="hidden" name="CenterCode" value="' + $("#CenterCode").val() + '">');
    var f7 = $('<input type="hidden" name="OrderNo" value="' + $("#OrderNo").val() + '">');

    $form.append(f1).append(f2).append(f3).append(f4).append(f5).append(f6).append(f7);
    $form.submit();
    $form.remove();
}

//파일 삭제
function fnDeleteReqFile(obj) {
    fnDefaultConfirm("파일 삭제 요청을 하시겠습니까?", "fnDeleteFile", obj);
    return;
}


var objDeleteFile = null;
function fnDeleteFile(obj) {
    
    var seq = "";
    var foname = "";
    var fnname = "";
    var flag = "";
    objDeleteFile = obj;

    seq = $(obj).parent("li").attr("seq");
    foname = $(obj).parent("li").children("a:first-child").text();
    fnname = $(obj).parent("li").attr("fname");
    flag = $(obj).parent("li").attr("flag");

    if (seq == "" || seq == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (foname == "" || foname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (fnname == "" || fnname == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    if (flag == "" || flag == null) {
        fnDefaultAlert("필요한 값이 없습니다.", "warning");
        return;
    }

    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticFileHandler.ashx";
    var strCallBackFunc = "fnDeleteFileSuccResult";
    var strCallBackFailFunc = "fnDeleteFileFailResult";

    var objParam = {
        CallType: "OrderFileDelete",
        FileSeqNo: seq,
        FileName: encodeURI(foname),
        FileNameNew: fnname,
        TempFlag: flag,
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strCallBackFailFunc, "", true);
}

function fnDeleteFileSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnCallDetailFailResult();
            return false;
        } else {
            if ($("#OrderStatus").val() === "2") {
                fnWebOrderFileDelReqIns(objDeleteFile);
                return;
            }
            fnDefaultAlert("파일이 삭제되었습니다");
            if ($(objDeleteFile) !== null) {
                $(objDeleteFile).parent("li").remove();
            }
            return false;
        }
    } else {
        fnDeleteFileSuccResult();
    }
}

function fnDeleteFileFailResult() {
    fnDefaultAlert("파일 삭제에 실패했습니다.", "error");
    return false;
}

function fnConsReset() {
    $("#ConsignorCode").val("");
    $("#ConsignorName").val("");
    $("#ConsignorName").attr("readonly", false);
    $("#BtnReset").hide();
}

function fnInsOrder() {
    var strMsg = "";

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return;
    }
    if ($("#ConsignorName").val() === "") {
        fnDefaultAlertFocus("화주명을 입력해주세요.", "ConsignorName", "warning");
        return;
    }
    if ($("#ReqChargeName").val() === "") {
        fnDefaultAlertFocus("요청자를 입력해주세요.", "ReqChargeName", "warning");
        return;
    }
    
    //상차지
    if ($("#PickupYMD").val() === "") {
        fnDefaultAlertFocus("상차일을 입력해주세요.", "PickupYMD", "warning");
        return;
    }
    if ($("#PickupHM").val() === "") {
        fnDefaultAlertFocus("상차시간을 입력해주세요.", "PickupHM", "warning");
        return;
    }
    if ($("#PickupPlace").val() === "") {
        fnDefaultAlertFocus("상차지명을 입력해주세요.", "PickupPlace", "warning");
        return;
    }
    if ($("#PickupPlaceChargeName").val() === "") {
        fnDefaultAlertFocus("담당자를 입력해주세요.", "PickupPlaceChargeName", "warning");
        return;
    }
    if ($("#PickupPlaceChargeTelNo").val() === "") {
        if ($("#PickupPlaceChargeCell").val() === "") {
            fnDefaultAlertFocus("담당자 전화번호를 입력해주세요.", "PickupPlaceChargeTelNo", "warning");
            return;
        }
    }
    if ($("#PickupPlaceChargeCell").val() === "") {
        if ($("#PickupPlaceChargeTelNo").val() === "") {
            fnDefaultAlertFocus("담당자 휴대폰번호를 입력해주세요.", "PickupPlaceChargeCell", "warning");
            return;
        }
    }
    if ($("#PickupPlacePost").val() === "") {
        fnDefaultAlertFocus("우편번호를 검색해주세요.", "PickupPlacePost", "warning");
        return;
    }
    if ($("#PickupPlaceAddr").val() === "") {
        fnDefaultAlertFocus("주소를 입력해주세요.", "PickupPlaceAddr", "warning");
        return;
    }
    //하차지
    if ($("#GetYMD").val() === "") {
        fnDefaultAlertFocus("하차일을 입력해주세요.", "GetYMD", "warning");
        return;
    }
    if ($("#GetHM").val() === "") {
        fnDefaultAlertFocus("하차시간을 입력해주세요.", "GetHM", "warning");
        return;
    }
    if ($("#GetPlace").val() === "") {
        fnDefaultAlertFocus("하차지명을 입력해주세요.", "GetPlace", "warning");
        return;
    }
    if ($("#GetPlaceChargeName").val() === "") {
        fnDefaultAlertFocus("담당자를 입력해주세요.", "GetPlaceChargeName", "warning");
        return;
    }
    if ($("#GetPlaceChargeTelNo").val() === "") {
        if ($("#GetPlaceChargeCell").val() === "") {
            fnDefaultAlertFocus("담당자 전화번호를 입력해주세요.", "GetPlaceChargeTelNo", "warning");
            return;
        }
    }
    if ($("#GetPlaceChargeCell").val() === "") {
        if ($("#GetPlaceChargeTelNo").val() === "") {
            fnDefaultAlertFocus("담당자 휴대폰번호를 입력해주세요.", "GetPlaceChargeCell", "warning");
            return;
        }
    }
    if ($("#GetPlacePost").val() === "") {
        fnDefaultAlertFocus("우편번호를 검색해주세요.", "GetPlacePost", "warning");
        return;
    }
    if ($("#GetPlaceAddr").val() === "") {
        fnDefaultAlertFocus("주소를 입력해주세요.", "GetPlaceAddr", "warning");
        return;
    }
    strMsg = "오더를 " + ($("#HidMode").val() == "Update" ? "수정" : "등록") + "하시겠습니까?";

    var objParam = {
        CallType: "WebOrder" + ($("#HidMode").val() === "Update" ? "Update" : "Insert"),
        ReqSeqNo: $("#ReqSeqNo").val(), //요청 일련번호
        OrderItemCode: $("#OrderItemCode").val(), //내수 코드
        CenterCode: $("#CenterCode").val(),
        ConsignorName: $("#ConsignorName").val(),

        ReqChargeName: $("#ReqChargeName").val(),
        ReqChargeTeam: $("#ReqChargeTeam").val(),
        PickupYMD: $("#PickupYMD").val(),
        PickupHM: $("#PickupHM").val(),
        PickupWay: $("#PickupWay").val(),
        PickupPlace: $("#PickupPlace").val(),
        PickupPlaceChargeName: $("#PickupPlaceChargeName").val(),
        PickupPlaceChargePosition: $("#PickupPlaceChargePosition").val(),
        PickupPlaceChargeTelNo: $("#PickupPlaceChargeTelNo").val(),
        PickupPlaceChargeTelExtNo: $("#PickupPlaceChargeTelExtNo").val(),
        PickupPlaceChargeCell: $("#PickupPlaceChargeCell").val(),
        PickupPlacePost: $("#PickupPlacePost").val(),
        PickupPlaceAddr: $("#PickupPlaceAddr").val(),
        PickupPlaceFullAddr: $("#PickupPlaceFullAddr").val(),
        PickupPlaceAddrDtl: $("#PickupPlaceAddrDtl").val(),
        PickupPlaceNote: $("#PickupPlaceNote").val(),

        GetYMD: $("#GetYMD").val(),
        GetHM: $("#GetHM").val(),
        GetWay: $("#GetWay").val(),
        GetPlace: $("#GetPlace").val(),
        GetPlaceChargeName: $("#GetPlaceChargeName").val(),
        GetPlaceChargePosition: $("#GetPlaceChargePosition").val(),
        GetPlaceChargeTelNo: $("#GetPlaceChargeTelNo").val(),
        GetPlaceChargeTelExtNo: $("#GetPlaceChargeTelExtNo").val(),
        GetPlaceChargeCell: $("#GetPlaceChargeCell").val(),
        GetPlacePost: $("#GetPlacePost").val(),
        GetPlaceAddr: $("#GetPlaceAddr").val(),
        GetPlaceAddrDtl: $("#GetPlaceAddrDtl").val(),
        GetPlaceFullAddr: $("#GetPlaceFullAddr").val(),
        GetPlaceNote: $("#GetPlaceNote").val(),

        CarTonCode: $("#CarTonCode").val(),
        CarTypeCode: $("#CarTypeCode").val(),
        GoodsItemCode: $("#GoodsItemCode").val(),
        FTLFlag: $("#FTLFlag").val(),
        GoodsRunType: $("#GoodsRunType").val(),
        Weight: $("#Weight").val(),
        Volume: $("#Volume").val(),
        Length: $("#Length").val(),
        GoodsName: $("#GoodsName").val(),
        GoodsNote: $("#GoodsNote").val(),
        NoteClient: $("#NoteClient").val()
    };

    fnDefaultConfirm(strMsg, "fnWebDomesticIns", objParam);
    return;
}

function fnWebDomesticIns(objParam) {
    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
    var strCallBackFunc = "fnAjaxWebDomesticIns";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxWebDomesticIns(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "warning");
        return;
    } else {
        if ($("#HidMode").val() === "Insert") {
            $("#OrderNo").val(data[0].OrderNo);
            $("#ReqSeqNo").val(data[0].ReqSeqNo);
        }
        fnInsFile();
    }
    
}

//오더 취소(요청)
function fnCancelOrderConfirm() {
    fnDefaultConfirm("오더를 " + ($("#OrderStatus").val() === "1" ? "취소" : "취소 요청") +"하시겠습니까?", "fnCancelOrder", "");
    return;
}

function fnCancelOrder() {
    var strCallType = "";

    if ($("#OrderStatus").val() === "1") {
        strCallType = "WebOrderCancel";
    } else {
        strCallType = "WebOrderRequestCnlUpdate";
        fnRequestChgInsConfirm()
        return;
    }

    var objParam = {
        CallType: strCallType,
        ReqSeqNo: $("#ReqSeqNo").val() //요청 일련번호
    };

    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
    var strCallBackFunc = "fnAjaxWebOrderCancel";

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxWebOrderCancel(data) {
    var ResultMsg = "";

    if ($("#OrderStatus").val() === "1") {
        ResultMsg = "오더 요청을 취소했습니다.";
    } else {
        ResultMsg = "오더 취소를 요청했습니다.";
    }
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "warning");
        return;
    } else {
        fnDefaultAlert(ResultMsg, "success", "window.close();");
        parent.opener.fnCallGridData("#WebDomesticListGrid");
        return;
    }
}

//요청등록
function fnRequestChgInsConfirm() {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("필요한 값이 없습니다.(회원사)", "warning");
        return;
    }

    if ($("#OrderNo").val() === "") {
        fnDefaultAlert("필요한 값이 없습니다.(접수번호)", "warning");
        return;
    }

    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
    var strCallBackFunc = "fnAjaxWebOrderCancel";

    var objParam = {
        CallType: "WebOrderRequestCnlInsert",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        OrderClientCode: $("#OrderClientCode").val(),
        ChgReqContent: "오더 취소 요청",
        ChgStatus: 1
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}


//오더복사
function fnCopyOrderConfirm() {
    document.location.replace("/WEB/Domestic/WebDomesticIns?OrderNo=" + $("#OrderNo").val() + "&ReqSeqNo=" + $("#ReqSeqNo").val() + "&CopyFlag=Y");
}

//원본오더보기
function fnOrgOrderDetail() {
    if ($("#ReqSeqNo").val() != "0") {
        window.open("/WEB/Domestic/WebDomesticOrgDetail?OrderNo=" + $("#OrderNo").val() + "&ReqSeqNo=" + $("#ReqSeqNo").val(), "요청 원본 오더", "width=1180, height=700px, scrollbars=Yes");
        return;
    } else {
        fnDefaultAlert("고객사웹 등록 오더만 원본보기 가능합니다.");
        return;
    }
}

//파일 등록
var FileList = null;
var FileCnt = 0;
var FileProcCnt = 0;
var FileSuccessCnt = 0;
var FileFailCnt = 0;
function fnInsFile() {
    FileList = [];
    $.each($("#UlFileList li"), function (index, item) {
        if ($(item).attr("flag") === "Y") {
            FileList.push({
                FileSeqNo: $(item).attr("seq"),
                FileName: $(item).children("a:first-child").text(),
                FileNameNew: $(item).attr("fname"),
                TempFlag: $(item).attr("flag")
            });
        }
    });
    
    if (FileList.length > 0) {
        FileCnt = FileList.length;
        FileProcCnt = 0;
        FileSuccessCnt = 0;
        FileFailCnt = 0;
        fnInsFileProc();
        return false;
    } else {
        fnOrderInsEnd();
    }
}

function fnInsFileProc() {
    
    if (FileProcCnt >= FileCnt) {
        if ($("#OrderStatus").val() === "2") {
            fnFileRquestIns(FileList);
            return;
        }
        fnOrderInsEnd();
        return;
    }

    var RowFile = FileList[FileProcCnt];
    RowFile.CallType = "OrderInsFileUpload";
    RowFile.CenterCode = $("#CenterCode").val();
    RowFile.OrderNo = $("#OrderNo").val();
    RowFile.ReqSeqNo = $("#ReqSeqNo").val();

    if (RowFile) {
        var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticFileHandler.ashx";
        var strCallBackFunc = "fnInsFileSuccResult";
        var strFailCallBackFunc = "fnInsFileFailResult";
        var objParam = RowFile;
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
    }
}

function fnInsFileSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            FileSuccessCnt++;
        } else {
            FileFailCnt++;
        }
    } else {
        FileFailCnt++;
    }
    FileProcCnt++;
    setTimeout(fnInsFileProc(), 500);
}

function fnInsFileFailResult() {
    FileProcCnt++;
    FileFailCnt++;
    setTimeout(fnInsFileProc(), 500);
    return false;
}

function fnOrderInsEnd() {
    var msg = "오더 " + ($("#HidMode").val() === "Update" ? "수정" : "등록") + "에 성공하였습니다.";
    fnDefaultAlert(msg, "info", "fnOrderReload()");
}

function fnOrderReload() {
    document.location.replace("/WEB/Domestic/WebDomesticIns?OrderNo=" + $("#OrderNo").val() + "&ReqSeqNo=" + $("#ReqSeqNo").val());
}


//오더 데이터 세팅 상세
function fnCallWebOrderDetail() {

    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
    var strCallBackFunc = "fnOrderDetailSuccResult";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "WebOrderList",
        OrderNo: $("#OrderNo").val(),
        CenterCode: $("#CenterCode").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnOrderDetailSuccResult(objRes) {
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

        if ($("#HidMode").val() === "Update") {
            if (item.OrderStatus !== 1) { //등록(요청) 상태가 아닐때 - 접수,배차,상차,하차 등..
                $("#BtnRegOrder").remove();
                $("#BtnChangeReq").show();
                $("#BtnOrgOrderView").show();
                $("#BtnCopyOrder").show();
                $(".TrDispatch").show();
                $(".TrPay").show();
            } else {
                $("#BtnChangeReq").remove();
                $("#BtnOrgOrderView").remove();
                $("#BtnCopyOrder").remove();
            }
        }
        
        //Hidden
        $.each($("input[type='hidden']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

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
        $("#CenterCode").val(item.CenterCode);
        $("#CenterCode option:not(:selected)").prop("disabled", true);
        $.each($("select"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id")) + "']").length > 0) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });

        //Checkbox

        //RadioButton

        //Span
        if ($("#CopyFlag").val() === "Y") {
            $("#HidMode").val("Insert");
            $("#CopyFlag").val("N");
            $("#CnlFlag").val("N");
            $("#OrderNo").val("");
            $("#TransType").val("");
            $("#ContractType").val("");
            $("#ContractStatus").val("");
            $("#DispatchRefSeqNo1").val("");
            $(".TrNetwork").hide();
            $("#DivOrderInfo").remove();
            $("#DivButtons").remove();
            $("#PickupYMD").datepicker("setDate", GetDateToday("-"));
            $("#GetYMD").datepicker("setDate", GetDateToday("-"));
            $("#OrderStatus").val("");
            return false;
        }
        $("#BtnReset").show();
        $("#ConsignorName").attr("readonly", true);
        $("#ReqChargeName").val(item.ReqChargeName);
        $("#ReqChargeTeam").val(item.ReqChargeTeam);
        $("#ReqRegDate").text(item.ReqRegDate);
        $("#AcceptAdminName").text(item.AcceptAdminName);
        $("#OrderNoView").text(item.OrderNo);
        
        //파일 목록 조회
        fnCallFileData();

        //배차 목록 조회
        fnCallDispatchData(item.GoodsSeqNo);

        //비용 목록 조회
        fnCallPayGridData(GridPayID);
    }
    else {
        fnCallDetailFailResult();
    }
}

// 파일 목록
function fnCallFileData() {
    if (!$("#OrderNo").val() || !$("#CenterCode").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticFileHandler.ashx";
    var strCallBackFunc = "fnCallFileSuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "OrderFileList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strCallBackFailFunc, "", false);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallFileSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        $("#UlFileList li").remove();
        if (objRes[0].data.RecordCnt > 0) {
            $.each(objRes[0].data.list, function (index, item) {
                fnAddFile(item);
            });
        }

    } else {
        fnCallDetailFailResult();
    }
}

function fnCallDetailFailResult() {
    fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error", "window.close();");
}

// 배차 목록
function fnCallDispatchData(strGoodsSeqNo) {
    if (!$("#OrderNo").val() || !$("#CenterCode").val() || !$("#GoodsSeqNo").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
    var strCallBackFunc = "fnCallDispatchSuccResult";
    var strCallBackFailFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "WebDomesticDispatchCarList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        GoodsSeqNo: strGoodsSeqNo
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strCallBackFailFunc, "", false);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDispatchSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.RetCode) {
            if (objRes[0].result.RetCode !== 0) {
                fnCallDetailFailResult();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult();
            return false;
        }

        if (objRes[0].data.RecordCnt > 0) {
            $("#TBodyDispatch").show();
            $("#TBodyDispatch tr").remove();
            var html = "";
            if (objRes[0].data.RecordCnt > 0) {
                $.each(objRes[0].data.list, function (index, item) {
                    var ContractCenter = "";
                    ContractCenter = item.ContractCenterName;
                    if (item.ContractCenterCorpNo !== "") {
                        ContractCenter += " (" + item.ContractCenterCorpNo + ")";
                    }
                    html += "<tr class=\"center\">\n";
                    html += "\t<td>" + item.DispatchTypeM + "</td>\n";
                    html += "\t<td>" + item.CarNo + "</td>\n";
                    html += "\t<td>" + item.DriverName + "</td>\n";
                    html += "\t<td>" + item.DriverCell + "</td>\n";
                    html += "</tr>\n";
                });
            }
            $("#TBodyDispatch").html(html);
        }
    } else {
        fnCallDetailFailResult();
    }
}

/*********************************************/
// 비용 그리드
/*********************************************/
var GridPayID = "#DomesticPayListGrid";

$(document).ready(function () {
    if ($(GridPayID).length > 0) {
        // 그리드 초기화
        fnPayGridInit();
    }
});

function fnPayGridInit() {
    // 그리드 레이아웃 생성
    fnCreatePayGridLayout(GridPayID, "PaySeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridPayID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    var intHeight = 170;
    AUIGrid.resize(GridPayID, $(GridPayID).width(), intHeight);
    // 브라우저 리사이징
    $(window).resize(function () {
        AUIGrid.resize(GridPayID, $(GridPayID).width(), intHeight);
    });
}

//기본 레이아웃 세팅
function fnCreatePayGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleRows"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = true; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = true; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = true; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultPayColumnLayout()");
    var objOriLayout = fnGetDefaultPayColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultPayColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "PayTypeM",
            headerText: "비용구분",
            editable: false,
            width: 150,
            filter: { showIcon: true }
        },
        {
            dataField: "TaxKindM",
            headerText: "과세구분",
            editable: false,
            width: 150,
            filter: { showIcon: true }
        },
        {
            dataField: "ItemCodeM",
            headerText: "비용항목",
            editable: false,
            width: 150,
            filter: { showIcon: true }
        },
        {
            dataField: "SupplyAmt",
            headerText: "공급가액",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.##");
            }
        },
        {
            dataField: "TaxAmt",
            headerText: "부가세",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.##");
            }
        }
        /*숨김필드*/
        , {
            dataField: "SeqNo",
            headerText: "SeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "PaySeqNo",
            headerText: "PaySeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "OrderNo",
            headerText: "OrderNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "GoodsSeqNo",
            headerText: "GoodsSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "GoodsDispatchType",
            headerText: "GoodsDispatchType",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "DispatchSeqNo",
            headerText: "DispatchSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "PayType",
            headerText: "PayType",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "TaxKind",
            headerText: "TaxKind",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ItemCode",
            headerText: "ItemCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClientName",
            headerText: "ClientName",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "OrgAmt",
            headerText: "OrgAmt",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClosingFlag",
            headerText: "ClosingFlag",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ClosingSeqNo",
            headerText: "ClosingSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "BillStatus",
            headerText: "BillStatus",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "SendStatus",
            headerText: "SendStatus",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "RegAdminID",
            headerText: "RegAdminID",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "UpdAdminID",
            headerText: "UpdAdminID",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "RefSeqNo",
            headerText: "RefSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CarDivType",
            headerText: "CarDivType",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ComCode",
            headerText: "ComCode",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ComInfo",
            headerText: "ComInfo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CarSeqNo",
            headerText: "CarSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "CarInfo",
            headerText: "CarInfo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "DriverSeqNo",
            headerText: "DriverSeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "DriverInfo",
            headerText: "DriverInfo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "ApplySeqNo",
            headerText: "ApplySeqNo",
            editable: false,
            visible: false,
            width: 0
        }, {
            dataField: "TransRateStatus",
            headerText: "TransRateStatus",
            editable: false,
            visible: false,
            width: 0
        }
    ];

    return objColumnLayout;
}


function fnCallPayGridData(strGID) {

    if (!$("#OrderNo").val() || !$("#CenterCode").val() || $("#CopyFlag").val() === "Y") {
        return false;
    }

    var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
    var strCallBackFunc = "fnPayGridSuccResult";

    var objParam = {
        CallType: "WebDomesticPayList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnPayGridSuccResult(objRes) {
    var GridData = [];
    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridPayID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }
        if (objRes[0].data.RecordCnt > 0) {
            for (var i = 0; i < objRes[0].data.RecordCnt; i++) {
                if (objRes[0].data.list[i].PayType != 2) {
                    GridData.push(objRes[0].data.list[i]);
                }
            }
        }

        AUIGrid.setGridData(GridPayID, GridData);
        AUIGrid.removeAjaxLoader(GridPayID);

        // 푸터
        fnSetPayGridFooter(GridPayID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetPayGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "PayTypeM",
            dataField: "PayTypeM",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-my-column-right"
        },
        {
            positionField: "SupplyAmt",
            dataField: "SupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "TaxAmt",
            dataField: "TaxAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}
/*****************************************************************/

function fnChangeReq() {
    window.open("/WEB/Domestic/WebDomesticReqIns?HidOrderNo=" + $("#OrderNo").val() + "&HidCenterCode=" + $("#CenterCode").val() + "&HidOrderClientCode=" + $("#OrderClientCode").val(), "오더 변경요청", "width=1000, height=800px, scrollbars=Yes");
    return;
}

// 파일등록 후 요청등록
function fnFileRquestIns(objResult) {
    if (objResult) {
        if (objResult.length > 0) {
            var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
            var strCallBackFunc = "fnAjaxWebOrderFileReqIns";

            var objParam = {
                CallType: "WebOrderRequestCnlInsert",
                CenterCode: $("#CenterCode").val(),
                OrderNo: $("#OrderNo").val(),
                OrderClientCode: $("#OrderClientCode").val(),
                ChgReqContent: "파일 첨부[" + objResult[objResult.length - 1].FileName + "]",
                ChgStatus: 1
            };
            UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
        }
    }
}
// 파일삭제 후 요청등록
function fnWebOrderFileDelReqIns(objRes) {
    if (objRes) {
        var strHandlerURL = "/WEB/Domestic/Proc/WebDomesticHandler.ashx";
        var strCallBackFunc = "fnAjaxWebOrderFileReqIns";

        var objParam = {
            CallType: "WebOrderRequestCnlInsert",
            CenterCode: $("#CenterCode").val(),
            OrderNo: $("#OrderNo").val(),
            OrderClientCode: $("#OrderClientCode").val(),
            ChgReqContent: "파일 삭제[" + $(objRes).parent("li").children("a:first-child").text() + "]",
            ChgStatus: 1
        };
        $(objRes).parent("li").remove();
        UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
    }
}

function fnAjaxWebOrderFileReqIns(objRes) {
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnDefaultAlert(objRes[0].ErrMsg, "warning");
            return;
        } else {
            fnDefaultAlert("파일 요청을 등록했습니다.", "success", "fnLocationDetail", "");
            return;
        }
    }
}

function fnLocationDetail() {
    location.replace("/WEB/Domestic/WebDomesticIns?OrderNo=" + $("#OrderNo").val() + "&ReqSeqNo=" + $("#ReqSeqNo").val());
}