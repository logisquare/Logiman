$(document).ready(function () {
	$("#AllCenterCodeChk").click(function () {
		if ($("#AllCenterCodeChk").is(":checked")) {
			$("table#AccessCenterCode input[type=checkbox]").prop("checked", true);
		} else {
			$("table#AccessCenterCode input[type=checkbox]").prop("checked", false);
		}
	});

	//파일업로드
	$("#BoardFileUpload").fileupload({
		dataType: "json",
		autoUpload: false,
		type: "POST",
		url: "/SSO/Board/Proc/BoardFileHandler.ashx?CallType=BoardFileUpload",
		add: function (e, data) {
			var uploadErrors = [];

			var acceptFileTypes = /(jpe?g|jpg|png|pdf|xlsx)/i;
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
			// Success callback
			//console.log(response);
			if (response[0].RetCode == 0) {
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
			console.log('error', error);
		}
	});
});

function fnAddFile(obj) {
	var addHtml = "";
	addHtml = "<li seq = '" + obj.EncFileSeqNo + "' fname='" + obj.EncFileNameNew + "' flag='" + obj.TempFlag + "' >";
	addHtml += "<a href=\"#\" onclick=\"fnDownloadFile(this); return false;\">" + obj.FileName + "</a> ";
	addHtml += "<a href=\"#\" onclick=\"fnDeleteFile(this); return false;\" class=\"file_del\" title=\"파일삭제\">삭제</a>";
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

	$form.attr('action', '/SSO/Board/Proc/BoardFileHandler.ashx');
	$form.attr('method', 'post');
	$form.attr('target', 'ifrmFiledown');
	var f1 = $('<input type="hidden" name="CallType" value="BoardFileDownload">');
	var f2 = $('<input type="hidden" name="FileSeqNo" value="' + seq + '">');
	var f3 = $('<input type="hidden" name="FileName" value="' + foname + '">');
	var f4 = $('<input type="hidden" name="FileNameNew" value="' + fnname + '">');
	var f5 = $('<input type="hidden" name="TempFlag" value="' + flag + '">');

	$form.append(f1).append(f2).append(f3).append(f4).append(f5);
	$form.submit();
	$form.remove();
}

//파일 삭제
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

	var strHandlerURL = "/SSO/Board/Proc/BoardFileHandler.ashx";
	var strCallBackFunc = "fnDeleteFileSuccResult";
	var strCallBackFailFunc = "fnDeleteFileFailResult";

	var objParam = {
		CallType: "BoardFileDelete",
		FileSeqNo: seq,
		FileName: encodeURI(foname),
		FileNameNew: fnname,
		TempFlag: flag
	};
	UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strCallBackFailFunc, "", true);
}

function fnDeleteFileSuccResult(objRes) {
	if (objRes) {
		if (objRes[0].RetCode !== 0) {
			fnCallDetailFailResult();
			return false;
		} else {
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

function fnCallDetailFailResult() {
	fnDefaultAlert("데이터를 불러오는데 실패했습니다. 잠시 후 시도해 주세요.", "error");
	return;
}

//파일 등록
var FileList = null;
var FileCnt = 0;
var FileProcCnt = 0;
var FileSuccessCnt = 0;
var FileFailCnt = 0;
function fnInsFile(SeqNo) {
	FileList = [];
	$.each($("#UlFileList li"), function (index, item) {
		if ($(item).attr("flag") === "Y") {
			FileList.push({
				CallType: "BoardInsFileUpload",
				SeqNo: SeqNo,
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
		fnInsFileProc(SeqNo);
		return false;
	} 
}

function fnInsFileProc(SeqNo) {
	
	var RowFile = FileList[FileProcCnt];

	if (RowFile) {
		var strHandlerURL = "/SSO/Board/Proc/BoardFileHandler.ashx";
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
	setTimeout(fnInsFileProc($("#SeqNo").val()), 500);
}

function fnInsFileFailResult() {
	FileProcCnt++;
	FileFailCnt++;
	setTimeout(fnInsFileProc($("#SeqNo").val()), 500);
	return false;
}

function fnBoardConfirm() {
	var confMsg = "";
	oEditors.getById["BoardContent"].exec("UPDATE_CONTENTS_FIELD", []);

	if ($("#BoardViewType").val() === "") {
		fnDefaultAlertFocus("게시판 유형을 선택해주세요.", "BoardViewType", "warning");
		return;
	}
	if ($("#MainDisplayFlag").val() === "") {
		fnDefaultAlertFocus("메인 팝업 설정을 선택해주세요.", "MainDisplayFlag", "warning");
		return;
	}
	if ($("#AccessCenterCode input[type=checkbox]:checked").length === 0) {
		fnDefaultAlertFocus("게시회원을 체크해주세요.", "AllCenterCodeChk", "warning");
		return;
	}
	if ($("#BoardTitle").val() === "") {
		fnDefaultAlertFocus("제목을 입력해주세요.", "BoardTitle", "warning");
		return;
	}
	if ($("#BoardContent").val() === "") {
		fnDefaultAlertFocus("내용을 입력해주세요.", "BoardContent", "warning");
		return;
	}
	if ($("#Mode").val() == "Insert") {
		confMsg = "등록하시겠습니까?";
	}
	else {
		confMsg = "수정하시겠습니까?";
	}
	fnDefaultConfirm(confMsg, "fnBoardIns", "");
	return;
}

function fnBoardIns() {
	var strAccessCenterCode = [];
	var strHandlerURL = "/SSO/Board/Proc/BoardHandler.ashx";
	var strCallBackFunc = "fnGridInsSuccResult";

	$.each($("#AccessCenterCode input[type='checkbox']:checked"), function (i, el) {
		if ($(el).val() != "") {
			strAccessCenterCode += $(el).val() + ",";
		}
	});

	var objParam = {
		CallType: "Board" + $("#Mode").val(),
		SeqNo : $("#SeqNo").val(),
		BoardViewType: $("#BoardViewType").val(),
		MainDisplayFlag: $("#MainDisplayFlag").val(),
		AccessCenterCode: strAccessCenterCode.slice(0, -1),
		AccessGradeCode: $("#BoardGradeCode").val(),
		BoardTitle: $("#BoardTitle").val(),
		BoardContent: $("#BoardContent").val(),
		UseFlag: $("#UseFlag").val()
	};
	UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridInsSuccResult(data) {
	
	if (data[0].RetCode !== 0) {
		fnDefaultAlert(data[0].ErrMsg);
		return;
	} else {
		var strMsg = "";
		var SeqNo;
		if ($("#Mode").val() === "Insert") {
			strMsg = "등록";
			SeqNo = data[0].SeqNo;
			$("#SeqNo").val(SeqNo);
		} else {
			strMsg = "수정";
			SeqNo = $("#SeqNo").val();
		}
		 $("#Mode").val() === "Insert" ? "등록" : "수정";
		fnDefaultAlert(strMsg + "되었습니다.", "success", "fnUpdPageGo", SeqNo);
		parent.fnCallGridData("#BoardManagerListGrid");
		fnInsFile(SeqNo);
		return;
	}
}

function fnUpdPageGo(SeqNo) {
	document.location.replace("/SSO/Board/BoardIns?HidMode=Update&SeqNo=" + SeqNo);
}