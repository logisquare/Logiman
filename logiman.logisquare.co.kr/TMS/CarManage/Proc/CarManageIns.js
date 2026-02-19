var objJsonData = null;
$(document).ready(function () {
    $("#ComName").attr("readonly", true);
    $("#ComCorpNo").attr("readonly", true);
    $("#CarNo").attr("readonly", true);
    $("#CarTonCodeM").attr("readonly", true);
    $("#CarTypeCodeM").attr("readonly", true);
    $("#DriverName").attr("readonly", true);
    $("#DriverCell").attr("readonly", true);

    if ($("#HidMode").val() === "Insert") {
        objJsonData = JSON.parse($("#HidParam").val());
        if (objJsonData) {
            $("#ComCode").val(objJsonData.ComCode);
            $("#ComName").val(objJsonData.ComName);
            $("#ComCorpNo").val(objJsonData.ComCorpNo);
            $("#CarSeqNo").val(objJsonData.CarSeqNo);
            $("#CarNo").val(objJsonData.CarNo);
            $("#CarTonCodeM").val(objJsonData.CarTonCodeM);
            $("#CarTonCode").val(objJsonData.CarTonCode);
            $("#CarTypeCodeM").val(objJsonData.CarTypeCodeM);
            $("#CarTypeCode").val(objJsonData.CarTypeCode);
            $("#DriverName").val(objJsonData.DriverName);
            $("#DriverCell").val(objJsonData.DriverCell);
            $("#DriverSeqNo").val(fnMakeCellNo(objJsonData.DriverSeqNo));
            $("#PickupFullAddr1").val(objJsonData.PickupPlaceFullAddr);
            $("#PickupFullAddr1").attr("readonly", true);
            $("#GetFullAddr1").val(objJsonData.GetPlaceFullAddr);
            $("#GetFullAddr1").attr("readonly", true);
        }
    } else {
        $("#InsBtn").text("수정");
        fnCarManageDetail(); //관리차량 상세
    }
    
    fnCheckBoxEvent();    //체크박스
    fnSetInitAutoComplete(); //KKO_FULLADDR 불러오기

});

function fnSetInitAutoComplete() {
    if ($("#PickupFullAddr1").length > 0) {
        fnSetAutocomplete({
            formId: "PickupFullAddr1",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/CarManage/Proc/CarManageHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "AddrList",
                    AddrText: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.KKO_FULLADDR,
                getValue: (item) => item.KKO_FULLADDR,
                onSelect: (event, ui) => {
                    $("#PickupFullAddr1").val(ui.item.etc.KKO_FULLADDR);
                    $("#PickupFullAddr1").attr("readonly", true);
                    $("#GetFullAddr1").focus();
                }
            }
        });
    }

    if ($("#PickupFullAddr2").length > 0) {
        fnSetAutocomplete({
            formId: "PickupFullAddr2",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/CarManage/Proc/CarManageHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "AddrList",
                    AddrText: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.KKO_FULLADDR,
                getValue: (item) => item.KKO_FULLADDR,
                onSelect: (event, ui) => {
                    $("#PickupFullAddr2").val(ui.item.etc.KKO_FULLADDR);
                    $("#PickupFullAddr2").attr("readonly", true);
                    $("#GetFullAddr2").focus();
                }
            }
        });
    }

    if ($("#PickupFullAddr3").length > 0) {
        fnSetAutocomplete({
            formId: "PickupFullAddr3",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/CarManage/Proc/CarManageHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "AddrList",
                    AddrText: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.KKO_FULLADDR,
                getValue: (item) => item.KKO_FULLADDR,
                onSelect: (event, ui) => {
                    $("#PickupFullAddr3").val(ui.item.etc.KKO_FULLADDR);
                    $("#PickupFullAddr3").attr("readonly", true);
                    $("#GetFullAddr3").focus();
                }
            }
        });
    }

    if ($("#GetFullAddr1").length > 0) {
        fnSetAutocomplete({
            formId: "GetFullAddr1",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/CarManage/Proc/CarManageHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "AddrList",
                    AddrText: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.KKO_FULLADDR,
                getValue: (item) => item.KKO_FULLADDR,
                onSelect: (event, ui) => {
                    $("#GetFullAddr1").val(ui.item.etc.KKO_FULLADDR);
                    $("#GetFullAddr1").attr("readonly", true);
                }
            }
        });
    }

    if ($("#GetFullAddr2").length > 0) {
        fnSetAutocomplete({
            formId: "GetFullAddr2",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/CarManage/Proc/CarManageHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "AddrList",
                    AddrText: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.KKO_FULLADDR,
                getValue: (item) => item.KKO_FULLADDR,
                onSelect: (event, ui) => {
                    $("#GetFullAddr2").val(ui.item.etc.KKO_FULLADDR);
                    $("#GetFullAddr2").attr("readonly", true);
                }
            }
        });
    }

    if ($("#GetFullAddr3").length > 0) {
        fnSetAutocomplete({
            formId: "GetFullAddr3",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/CarManage/Proc/CarManageHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "AddrList",
                    AddrText: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    return true;
                },
                getLabel: (item) => item.KKO_FULLADDR,
                getValue: (item) => item.KKO_FULLADDR,
                onSelect: (event, ui) => {
                    $("#GetFullAddr3").val(ui.item.etc.KKO_FULLADDR);
                    $("#GetFullAddr3").attr("readonly", true);
                }
            }
        });
    }
}

function fnResetAddr(id) {
    $("#" + id).attr("readonly", false);
    $("#" + id).val("");
    $("#" + id).focus();
}

function fnCheckBoxEvent() {
    if (!$("#EndYMDFlag").is(":checked")) {
        $("#EndYMD").attr("readonly", true);
    } else {
        $("#EndYMD").datepicker({
            dateFormat: "yy-mm-dd",
            onSelect: function (dateFromText, inst) {
                var dateToText = $("#EndYMD").val().replace(/-/gi, "");
                if (dateToText.length !== 8) {
                    dateToText = GetDateToday("");
                }

                if (parseInt(dateFromText.replace(/-/gi, "")) > parseInt(dateToText)) {
                    $("#EndYMD").datepicker("setDate", dateFromText);
                }
            }
        });
        $("#EndYMD").datepicker("setDate", GetDateToday("-"));
    }

    $("#EndYMDFlag").click(function () {
        if ($(this).prop("checked")) {
            $("#EndYMD").datepicker({
                dateFormat: "yy-mm-dd",
                onSelect: function (dateFromText, inst) {
                    var dateToText = $("#EndYMD").val().replace(/-/gi, "");
                    if (dateToText.length !== 8) {
                        dateToText = GetDateToday("");
                    }

                    if (parseInt(dateFromText.replace(/-/gi, "")) > parseInt(dateToText)) {
                        $("#EndYMD").datepicker("setDate", dateFromText);
                    }
                }
            });
            $("#EndYMD").datepicker("setDate", GetDateToday("-"));
        } else {
            $("#EndYMD").val("");
            $("#EndYMD").datepicker("destroy");
        }
    });

    $("#AllCheck").click(function () {
        if ($(this).prop("checked")) {
            $("input[name=DayInfo]").prop("checked", true);
        } else {
            $("input[name=DayInfo]").prop("checked", false);
        }
    });
}

function fnCarManagerInsConfirm() {
    var ArrDayInfo = [];
    var strMsg = "관리 차량을 등록 하시겠습니까?";
    var strCallType = "CarManageIns";

    if ($("#ComCode").val() === "") {
        fnDefaultAlert("업체정보가 없습니다.");
        return;
    }

    if ($("#CarSeqNo").val() === "") {
        fnDefaultAlert("차량정보가 없습니다.");
        return;
    }

    if ($("#DriverSeqNo").val() === "") {
        fnDefaultAlert("기사정보가 없습니다.");
        return;
    }

    if ($("#PickupFullAddr1").val() === "") {
        fnDefaultAlertFocus("상차지주소1은 필수입니다.", "PickupFullAddr1");
        return;
    }

    if ($("#PickupFullAddr1").attr("readonly") !== "readonly") {
        fnDefaultAlertFocus("상차지주소1을 검색하여 입력하세요.", "PickupFullAddr1");
        return;
    }

    if ($("#GetFullAddr1").val() === "") {
        fnDefaultAlertFocus("하차지주소1은 필수입니다.", "GetFullAddr1");
        return;
    }

    if ($("#GetFullAddr1").attr("readonly") !== "readonly") {
        fnDefaultAlertFocus("하차지주소1을 검색하여 입력하세요.", "GetFullAddr1");
        return;
    }

    if ($("#PickupFullAddr2").val() !== "") {
        if ($("#GetFullAddr2").val() === "") {
            fnDefaultAlertFocus("하차지주소2를 입력해주세요.", "GetFullAddr2");
            fnResetAddr('GetFullAddr2');
            return;
        }

        if ($("#PickupFullAddr2").attr("readonly") !== "readonly") {
            fnDefaultAlertFocus("상차지주소2를 검색하여 입력하세요.", "PickupFullAddr2");
            return;
        }
    }

    if ($("#GetFullAddr2").val() !== "") {
        if ($("#PickupFullAddr2").val() === "") {
            fnDefaultAlertFocus("상차지주소2를 입력해주세요.", "PickupFullAddr2");
            fnResetAddr('PickupFullAddr2');
            return;
        }
        if ($("#GetFullAddr2").attr("readonly") !== "readonly") {
            fnDefaultAlertFocus("하차지주소2를 검색하여 입력하세요.", "GetFullAddr2");
            return;
        }
    }

    if ($("#PickupFullAddr3").val() !== "") {
        if ($("#GetFullAddr3").val() === "") {
            fnDefaultAlertFocus("하차지주소3를 입력해주세요.", "GetFullAddr3");
            fnResetAddr('GetFullAddr3');
            return;
        }

        if ($("#PickupFullAddr3").attr("readonly") !== "readonly") {
            fnDefaultAlertFocus("상차지주소3를 검색하여 입력하세요.", "PickupFullAddr3");
            return;
        }
    }

    if ($("#GetFullAddr3").val() !== "") {
        if ($("#PickupFullAddr3").val() === "") {
            fnDefaultAlertFocus("상차지주소2를 입력해주세요.", "PickupFullAddr3");
            fnResetAddr('PickupFullAddr3');
            return;
        }
        if ($("#GetFullAddr3").attr("readonly") !== "readonly") {
            fnDefaultAlertFocus("하차지주소2를 검색하여 입력하세요.", "GetFullAddr3");
            return;
        }
    }

    $.each($("input[name=DayInfo]:checked"), function (i, el) {
        if ($(el).val() != "") {
            ArrDayInfo.push($(el).val());
        }
    });

    if ($("#EndYMDFlag").is(":checked")){
        if ($("#EndYMD").val() === "") {
            fnDefaultAlert("종요일 선택시 종요일 날짜 지정은 필수입니다.");
            return;
        }
        if (ArrDayInfo.length === 0) {
            fnDefaultAlert("종요일 선택시 요일선택은 필수입니다.");
            return;
        }
    }
    

    if ($("#HidMode").val() === "Update") {
        if ($("#ManageSeqNo").val() === "0") {
            fnDefaultAlert("관리차량 일련번호가 없습니다.");
            return;
        }
        strMsg = "관리 차량을 수정 하시겠습니까?";
        var strCallType = "CarManageUpd";
    }

    fnDefaultConfirm(strMsg, "fnCarManagerIns", strCallType);
    return;
}

function fnCarManagerIns(fnParam) {
    var ArrDayInfo = [];
    var strHandlerURL = "/TMS/CarManage/Proc/CarManageHandler.ashx";
    var strCallBackFunc = "fnAjaxInsCarManage";

    $.each($("input[name=DayInfo]:checked"), function (i, el) {
        if ($(el).val() != "") {
            ArrDayInfo.push($(el).val());
        }
    });

    var objParam = {
        CallType: fnParam,

        ManageSeqNo: $("#ManageSeqNo").val(),
        ComCode: $("#ComCode").val(),
        ComName: $("#ComName ").val(),
        ComCorpNo: $("#ComCorpNo").val(),
        CarSeqNo: $("#CarSeqNo").val(),
        CarNo: $("#CarNo").val(),

        CarTypeCode: $("#CarTypeCode").val(),
        CarTonCode: $("#CarTonCode").val(),
        DriverSeqNo: $("#DriverSeqNo").val(),
        DriverName: $("#DriverName").val(),
        DriverCell: $("#DriverCell").val().replace(/-/gi, ""),

        PickupFullAddr1: $("#PickupFullAddr1").val(),
        GetFullAddr1: $("#GetFullAddr1").val(),
        PickupFullAddr2: $("#PickupFullAddr2").val(),
        GetFullAddr2: $("#GetFullAddr2").val(),
        PickupFullAddr3: $("#PickupFullAddr3").val(),

        GetFullAddr3: $("#GetFullAddr3").val(),
        DayInfo: ArrDayInfo.join(","),
        EndYMDFlag: $("#EndYMDFlag").is(":checked") ? "Y" : "N",
        EndYMD: $("#EndYMD").val().replace(/-/gi, ""),
        ShareFlag: $("#ShareFlag").is(":checked") ? "N" : "Y"
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsCarManage(objData) {
    if (objData[0].RetCode !== 0) {
        fnDefaultAlert(objData[0].ErrMsg);
        return;
    } else {

        var strConfMsg = "";
        strConfMsg = $("#HidMode").val() === "Update" ? "수정" : "등록";
        strConfMsg += " 성공하였습니다.";

        if ($("#HidMode").val() === "Insert") {
            fnDefaultAlert(strConfMsg, "success", "fnLocalCloseCpLayer", "");
        } else {
            fnDefaultAlert(strConfMsg, "success", "fnLocationDetail", "");
        }
    }

    $("#divLoadingImage").hide();
}

function fnLocalCloseCpLayer() {
    parent.$("#cp_layer").css("left", "");
    parent.$("#cp_layer").toggle();
    parent.fnMoveToPage(1);
}

function fnLocationDetail() {
    location.href = "/TMS/CarManage/CarManageIns?ManageSeqNo=" + $("#ManageSeqNo").val() + "&HidMode=Update";
    return;
}

function fnCarManageDetail() {
    var strHandlerURL = "/TMS/CarManage/Proc/CarManageHandler.ashx";
    var strCallBackFunc = "fnDetailSuccResult";

    var objParam = {
        CallType: "CarManageList",
        ManageSeqNo: $("#ManageSeqNo").val(),
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnDetailSuccResult(objData) {
    if (objData) {
        if (objData[0].data.RecordCnt > 0) {
            var item = objData[0].data.list[0];
            //hidden
            $.each($("input[type='hidden']"),
                function (index, input) {
                    if (eval("item." + $(input).attr("id")) != null) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                });

            //textbox
            $.each($("input[type='text']"),
                function (index, input) {
                    if (eval("item." + $(input).attr("id")) != null) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                });

            $("#EndYMD").val(item.EndYMD !== "" ? fnGetStrDateFormat(item.EndYMD, "-") : "");

            if (item.DayInfo !== "") {
                $(item.DayInfo.split(",")).each(function (i, val) {
                    $("input[name=DayInfo][value=" + val + "]").prop("checked", true);
                });
                if (item.DayInfo.split(",").length === 7) {
                    $("#AllCheck").prop("checked", true);
                }
            }

            if (item.EndYMDFlag === "Y") {
                $("#EndYMDFlag").prop("checked", true);
            }

            if (item.ShareFlag === "N") {
                $("#ShareFlag").prop("checked", true);
            }

            $("#PickupFullAddr1").attr("readonly", true);
            $("#GetFullAddr1").attr("readonly", true);
            $("#PickupFullAddr2").attr("readonly", true);
            $("#GetFullAddr2").attr("readonly", true);
            $("#PickupFullAddr3").attr("readonly", true);
            $("#GetFullAddr3").attr("readonly", true);


        } else {
            fnDefaultAlert("데이터를 불러올 수 없습니다.");
            return;
        }
    }
}