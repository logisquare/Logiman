$(document).ready(function () {
    $("input[ID=AdminID]").keypress(function (event) {
        if (event.which == 13) {
            event.preventDefault();
            fnGoLogin();
        }
    });

    $("input[ID=AdminPwd]").keypress(function (event) {
        if (event.which == 13) {
            event.preventDefault();
            fnGoLogin();
        }
    });

    $("#btnLogin").on("click", function () {
        event.preventDefault();
        fnGoLogin();
    });
});

function fnGoLogin() {
    var strHandlerURL = "/APP/Login/Proc/LoginHandler.ashx";
    var strCallBackFunc = "fnAjaxLoginSuccResult";
    if (false == fnChkLogin()) {
        return;
    }

    var objParam = {
        CallType: "chkLogin",
        AdminID: $("#AdminID").val(),
        AdminPwd: $("#AdminPwd").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnChkLogin() {
    if ($("#AdminID").val() == "") {
        alert("로그인 아이디를 입력하세요.");
        return false;
    }
    if ($("#AdminPwd").val() == "") {
        alert("패스워드를 입력하세요.");
        return false;
    }
}

function fnAjaxLoginSuccResult(data) {

    if (data[0].RetCode !== 0) {
        if (data[0].RetCode == 22000) {
            fnDefaultAlert("비밀번호 설정이 필요한 최초 로그인입니다.<br/>비밀번호 설정 후 다시 로그인해 주세요.");
            return;
        }

        fnDefaultAlert("로그인을 실패하였습니다. 나중에 다시 시도해 주세요.<br/>(" + data[0].ErrMsg + ")");
    } else {
        //alert(data[0].LastLoginNotice);
        //location.href = $("#returnurl").val();
        fnDefaultAlert(data[0].LastLoginNotice, "success", "fnRootPageReplace", $("#returnurl").val());
    }
    return;
}