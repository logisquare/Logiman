$(document).ready(function () {
    if ($("#hidDisplayMode").val() == "Y") {
        if (parent) {
            parent.fnReloadPageNotice($("#hidErrMsg").val());
        }
        else if (opener) {
            opener.fnReloadPageNotice($("#hidErrMsg").val());
        }
    }

    $("#ExpireYMD").datepicker({
        changeMonth: true,
        changeYear: true,
        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dateFormat: "yy-mm-dd"
    });

    $("#AccessIPChkFlag").change(function () {
        fnSetInitData();
    });

    fnSetInitData();
    fnSetInitAutoComplete();
});

function fnSetInitData() {
    if ($("#hidMode").val() === "insert") {
        $("#lblMode").html("등록");
        
    }
    else {
        $("#lblMode").html("수정");
        $("#CorpNo").attr("readonly", true);
        $("#CorpNo").css("background-color", "#e7e7e7");
        $("#CorpNo").addClass("readonly");
        $("#CorpName").show();
        $("#CorpNoBtn").hide();

        $("#AdminID").attr("readonly", true);
        $("#AdminID").css("background-color", "#e7e7e7");
        $("#AdminID").addClass("readonly");
        $("#AdminIDBtn").hide();
        $("#GradeTable").show();
        if ($("#GradeCode").val() === "6") {
            $("#GradeCode option:not(:selected)").attr("disabled", true);
            $("#GradeCode").addClass("read");
            $("#ClientTb").show();
            $("#ClientName").attr("readonly", true);
            $("#ClientResetBtn").show();
            $("#CenterCodes").hide();
            $("#CenterCode").show();
        }
    }

    $("#GradeCode").on("change", function () {

        if ($("#GradeCode").val() != "") {
            $("#GradeTable").show();
        }

        if ($("#GradeCode").val() == "1" || $("#GradeCode").val() == "2") {
            $("#CenterCodeTr").hide();
        } else {
            $("#CenterCodeTr").show();
        }
        if ($("#GradeCode").val() === "6") {
            $("#ClientTb").show();
            $("#CenterCodes").hide();
            $("#CenterCode").show();
        } else {
            $("#ClientTb").hide();
            $("#ClientName").val("");
            $("#ClientCorpNo").val("");
            $("#CenterCodes").show();
            $("#CenterCode").hide();
        }
    });

    if ($("#AccessIPChkFlag").val() === "Y") {
        $(".clsAccessIP").attr("readonly", false);
        if ($(".clsAccessIP").hasClass("readonly")) {
            $(".clsAccessIP").removeClass("readonly");
        }
    }
    else {
        $(".clsAccessIP").attr("readonly", true);
        if (!$(".clsAccessIP").hasClass("readonly")) {
            $(".clsAccessIP").addClass("readonly");
        }
    }

    if ($("#GradeCode").val() === "6") {
        $(".network_tr").hide();
    }

    $("#CorpName").attr("readonly", true);
       

    $("#AdminID").keypress(function (e) {
        $("#hidAdminIDFlag").val("");
        if (e.keyCode === 13) {
            fnChkAdminID(1);
            return false;
        }
    });

    $("#CenterCode").on("change", function () {
        fnClientReset();
    });
}

function fnSetInitAutoComplete() {
    //고객사명
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/SSO/Admin/Proc/AdminHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
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
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#ClientCorpNo").val(ui.item.etc.ClientCorpNo);
                    $("#ClientName").val(ui.item.etc.ClientName);
                    $("#ClientName").attr("readonly", true);
                    $("#ClientResetBtn").show();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                }
            }
        });
    }
}

function fnCloseThisLayer() {
    parent.fnClosePopUpLayer();
}

function fnInsAdmin() {
    var strConfMsg;
    var strCallType;
    var arrCenterCode = $("input[name='CenterCodes']");
    var arrCenterCode = $('#CenterCodes input:checkbox:checked').map(function () { return this.value; }).get().join(",");
    
    if ($("#GradeCode").val() !== "1" && $("#GradeCode").val() !== "2") {
        if ($("#GradeCode").val() === "6") {
            if ($("#CenterCode").val() === "") {
                fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                return;
            }
        } else {
            if (arrCenterCode === "") {
                fnDefaultAlert("회원사를 선택하세요.", "warning");
                return;
            }
        }
    }

    if (!$("#GradeCode").val()) {
        fnDefaultAlertFocus("사용자 등급을 선택하세요.", "GradeCode", "warning");
        return;
    }

    if ($("#GradeCode").val() === "6") {
        if ($("#ClientCorpNo").val() === "") {
            fnDefaultAlertFocus("고객사를 검색 등록해주세요.", "ClientName", "warning");
            return;
        }
    }

    if (!$("#AdminID").val() ) {
        fnDefaultAlertFocus("아이디를 입력하세요.", "AdminID", "warning");
        return;
    }

    if ($("#hidMode").val() === "insert") {
        if (!UTILJS.Util.fnValidId($("#AdminID").val())) {
            fnDefaultAlertFocus("아이디는 영문자 또는 숫자 조합 6~20자로 입력하세요.", "AdminID", "warning");
            return;
        }

        if ($("#hidAdminIDFlag").val() === "") {
            fnDefaultAlert("아이디 중복 확인이 필요합니다.", "warning");
            return;
        }
    }

    if (!$("#AdminName").val()) {
        fnDefaultAlertFocus("이름을 입력하세요.", "AdminName", "warning");
        return;
    }

    if (!$("#MobileNo").val()) {
        fnDefaultAlertFocus("휴대폰 번호를 입력하세요.", "MobileNo", "warning");
        return;
    }

    if (!UTILJS.Util.fnCellNoChk($("#MobileNo").val())) {
        fnDefaultAlertFocus("휴대폰번호가 올바르지 않습니다.", "MobileNo", "warning");
        return;
    }

    if ($("#Email").val()) {
        if (!UTILJS.Util.fnValidEmail($("#Email").val())) {
            fnDefaultAlertFocus("이메일이 올바르지 않습니다.", "Email", "warning");
            return;
        }
    }

    if (!$("#UseFlag").val()) {
        fnDefaultAlertFocus("계정 사용 여부를 선택하세요.", "UseFlag", "warning");
        return;
    }

    if ($("#hidMode").val() === "update") {
        strCallType = "AdminUpdate";
        strConfMsg = "수정하시겠습니까?";
    }
    else {
        strCallType = "AdminInsert";
        strConfMsg = "등록하시겠습니까?";
    }

    //Confirm
    var objFnParam = { CallType: strCallType };
    fnDefaultConfirm(strConfMsg, "fnInsAdminProc", objFnParam);

    return;
}

function fnInsAdminProc(objParam) {
    var strHandlerURL = "/SSO/Admin/Proc/AdminHandler.ashx";
    var strCallBackFunc = "fnAjaxInsAdmin";

    var objParam = {
        CallType: objParam.CallType,
        AdminID: $("#AdminID").val(),
        AdminPwd: $("#AdminPwd").val(),
        MobileNo: $("#MobileNo").val(),
        AdminName: $("#AdminName").val(),
        GradeCode: $("#GradeCode").val(),
        AdminCorpNo: $("#GradeCode").val() === "6" ? $("#ClientCorpNo").val() : $("#AdminCorpNo").val(),
        AdminCorpName: $("#GradeCode").val() === "6" ? $("#ClientName").val() : $("#AdminCorpName").val(),
        AccessCorpNo: $("#ClientCorpNo").val(),
        DeptName: $("#DeptName").val(),
        TelNo: $("#TelNo").val(),
        Email: $("#Email").val(),
        AdminPosition: $("#AdminPosition").val(),
        AccessIPChkFlag: $("#AccessIPChkFlag").val(),
        AccessIP1: $("#AccessIP1_1").val() + "." + $("#AccessIP1_2").val() + "." + $("#AccessIP1_3").val() + "." + $("#AccessIP1_4").val(),
        AccessIP2: $("#AccessIP2_1").val() + "." + $("#AccessIP2_2").val() + "." + $("#AccessIP2_3").val() + "." + $("#AccessIP2_4").val(),
        AccessIP3: $("#AccessIP3_1").val() + "." + $("#AccessIP3_2").val() + "." + $("#AccessIP3_3").val() + "." + $("#AccessIP3_4").val(),
        LastLoginDate: $("#LastLoginDate").val(),
        LastLoginIP: $("#LastLoginIP").val(),
        JoinYMD: $("#JoinYMD").val(),
        ExpireYMD: $("#ExpireYMD").val(),
        PwdUpdDate: $("#PwdUpdDate").val(),
        AccessCenterCode: $("#GradeCode").val() === "6" ? $("#CenterCode").val() : $('#CenterCodes input:checkbox:checked').map(function () { return this.value; }).get().join(","),
        Network24DDID: $("#Network24DDID").val(),
        NetworkHMMID: $("#NetworkHMMID").val(),
        NetworkOneCallID: $("#NetworkOneCallID").val(),
        NetworkHmadangID: $("#NetworkHmadangID").val(),
        DupLoginFlag: $("#DupLoginFlag").val(),
        MyOrderFlag: $("#MyOrderFlag").val(),
        UseFlag: $("#UseFlag").val(),
        PrivateAvailFlag: $("#PrivateAvailFlag").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxInsAdmin(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
        return;
    } else {
        fnDefaultAlert("요청을 성공하였습니다.", "success", "fnAjaxInsAdminComplete", { AdminID: $("#AdminID").val() });
        parent.fnCallGridData("#AdminListGrid");
        return;
    }
}

function fnAjaxInsAdminComplete(objParam) {
    
    if (typeof objParam.AdminID === "undefined") {
        return false;
    }

    document.location.replace("/SSO/Admin/AdminIns?AdminID=" + objParam.AdminID);
}

function fnAjaxChkCorpNo(data) {

    if (data[0].RetCode === 0) {
        //가입가능
        $("span.corpno_fail").hide();
        $("span.corpno_fail").text("");
        $("span.corpno_pass").show();
        $("#CorpName").show();
        $("#CorpName").val(data[0].CorpName);
        $("#hidCorpNoFlag").val("Y");
        $("#divLoadingImage").hide();
        $("#CorpNo").attr("readonly", true);
        $("#CorpNoBtn").hide();
        $("#CorpNoBtnReturn").show();
    } else {
        //가입 불가능
        $("span.corpno_fail").show();
        $("span.corpno_fail").text(data[0].ErrMsg);
        $("span.corpno_pass").hide();
        $("#CorpName").hide();
        $("#hidCorpNoFlag").val("");
        $("#divLoadingImage").hide();
        $("#CorpNo").attr("readonly", false);
        $("#CorpNoBtn").show();
        $("#CorpNoBtnReturn").hide();
    }

    return;
}

//아이디 중복체크
function fnChkAdminID(type) {
    if (type === 2) {
        $("#AdminID").attr("readonly", false);
        $("#AdminID").val("");
        $("#AdminID").focus();
        $("#hidAdminIDFlag").val("");
        $("#AdminIDBtn").show();
        $("#AdminIDBtnReturn").hide();
        $("span.id_fail").hide();
        $("span.id_pass").hide();
        return;
    }

    if (!$("#AdminID").val()) {
        fnDefaultAlertFocus("아이디를 입력해주세요.", "AdminID", "warning");
        return;
    }

    if (!UTILJS.Util.fnValidId($("#AdminID").val())) {
        fnDefaultAlertFocus("아이디는 영문자 또는 숫자 조합 6~20자로 입력하세요.", "AdminID", "warning");
        return;
    }

    var strHandlerURL = "/SSO/Login/Proc/MemberShipInfoHandler.ashx";
    var strCallBackFunc = "fnAjaxChkAdminID";

    var objParam = {
        CallType: "AdminIDCheck",
        AdminID: $("#AdminID").val(),
        MemberType: type
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxChkAdminID(data) {

    if (data[0].RetCode === 0) {
        //가입가능
        $("span.id_fail").hide();
        $("span.id_pass").show();
        $("#hidAdminIDFlag").val("Y");
        $("#divLoadingImage").hide();
        $("#AdminID").attr("readonly", true);
        $("#AdminIDBtn").hide();
        $("#AdminIDBtnReturn").show();
    } else {
        //가입 불가능
        $("span.id_fail").show();
        $("span.id_pass").hide();
        $("#hidAdminIDFlag").val("");
        $("#divLoadingImage").hide();
    }

    return;
}

function fnClientReset() {
    $("#ClientName").val("");
    $("#ClientName").attr("readonly", false);
    $("#ClientName").focus();
    $("#ClientCorpNo").val("");
    $("#ClientResetBtn").hide();
    fnClientAutoComplete();
}