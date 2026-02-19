$(function(){

	
	/* 네비 메뉴 */
	$(document).on("click",".onoff",function(){
		
		if($(this).attr("class") == "onoff act"){			
			$(this).find("ul").slideUp(300);			
		}else{
			$(this).find("ul").slideDown(300);			
		}
		
		$(this).toggleClass("act");
		$(this).siblings("li").removeClass("act");
		$(this).siblings("li").find("ul").slideUp();
	
	});

	/* 헤더 메뉴버튼 */
	dh = $(document).height();
	$(".btn_menu").click(function(){
						
		$("#bgblack").height(dh).show();
		$(".gnb_mobile").height(dh).show().animate({right:0},400);
	
	});
	
	/* 헤더 검색버튼 */
	$(".btn_search").click(function(){
		
		$(".gnb_mobile").hide();
	})


	/* 검정배경 클릭시 */
	$("#bgblack").click(function(){
		
		$("#bgblack").hide();
		$(".gnb_mobile").animate({right:-70+"%"},400,function(){
			$(".gnb_mobile").hide();
		});
	
	});


	/* gnb닫기버튼 클릭시 */
	$(".gnb_close").click(function(){
		
		$("#bgblack").hide();
		$(".gnb_mobile").animate({right:-70+"%"},400,function(){
			$(".gnb_mobile").hide();
		});
		
	
	});

	
	/* tabs */
	$(".tabs").each(function(){
        $(".tabs>ul.tab>li").click(function(e){
            e.preventDefault();
            $(".tabs>ul.tab>li").removeClass("active");
            $(this).addClass("active");
        });
    });
})

function fnMakeCellNo(strCellNo) {
    if (typeof strCellNo !== "string") {
        return strCellNo;
    }

    if (strCellNo === "") {
        return strCellNo;
    }

    strCellNo = strCellNo.replace(/-/gi, "");

    if (!fnChkNum(strCellNo)) {
        return strCellNo;
    }

    var arrCell = ["010", "011", "016", "017", "018", "019"];
    var arrTel = ["02", "031", "032", "033", "041", "042", "043", "044", "051", "052", "053", "054", "055", "061", "062", "063", "064", "070"];
    var strRetCellNo = "";

    $.each(arrCell, function (index, item) {
        if (strCellNo.indexOf(item) === 0) {
            if (strCellNo.length === 10) {
                strRetCellNo = item + "-" + strCellNo.substr(3, 3) + "-" + strCellNo.substr(6);
                return false;
            } else if (strCellNo.length === 11) {
                strRetCellNo = item + "-" + strCellNo.substr(3, 4) + "-" + strCellNo.substr(7);
                return false;
            } else {
                strRetCellNo = strCellNo;
                return false;
            }
        }
    });

    if (strRetCellNo !== "") {
        return strRetCellNo;
    }

    $.each(arrTel, function (index, item) {
        if (strCellNo.indexOf(item) === 0) {
            if (item.length === 2) {
                if (strCellNo.length === 9) {
                    strRetCellNo = item + "-" + strCellNo.substr(2, 3) + "-" + strCellNo.substr(5);
                    return false;
                } else if (strCellNo.length === 10) {
                    strRetCellNo = item + "-" + strCellNo.substr(2, 4) + "-" + strCellNo.substr(6);
                    return false;
                } else {
                    strRetCellNo = strCellNo;
                    return false;
                }
            } else {
                if (strCellNo.length === 10) {
                    strRetCellNo = item + "-" + strCellNo.substr(3, 3) + "-" + strCellNo.substr(6);
                    return false;
                } else if (strCellNo.length === 11) {
                    strRetCellNo = item + "-" + strCellNo.substr(3, 4) + "-" + strCellNo.substr(7);
                    return false;
                } else {
                    strRetCellNo = strCellNo;
                    return false;
                }
            }
        }
    });

    if (strRetCellNo !== "") {
        return strRetCellNo;
    }

    if (strCellNo.length === 8) {
        strCellNo = strCellNo.substr(0, 4) + "-" + strCellNo.substr(4);
    }

    return strCellNo;
}

function fnChkNum(s) {
    s += ""; // 문자열로 변환
    s = s.replace(/^\s*|\s*$/g, ""); // 좌우 공백 제거
    if (s === "" || isNaN(s)) return false;
    return true;
}

function fnGetDateFormat(date, delimiter) {

    var newDate = new Date();

    if (date != null) newDate = date;

    var yy = newDate.getFullYear();
    var mm = newDate.getMonth() + 1;
    if (mm < 10) mm = "0" + mm;

    var dd = newDate.getDate();
    if (dd < 10) dd = "0" + dd;

    if (delimiter == null) delimiter = "";
    return yy + delimiter + mm + delimiter + dd;
}

function fnChangeDate(val, id) {
    //val => 1 금일, 2 익일, 3 전일, 4 금월, 5 전월, 6 금주
    var date = new Date();
    var yy = date.getFullYear();
    var mm = date.getMonth() + 1;
    var dd = date.getDate();
    var date_ymd = "";

    if (val === "1") {
        date_ymd = fnGetDateFormat(date, "-");
    } else if (val === "2") {
        date = new Date(yy, mm - 1, dd + 1);
        date_ymd = fnGetDateFormat(date, "-");
    } else if (val === "3") {
        date = new Date(yy, mm - 1, dd - 1);
        date_ymd = fnGetDateFormat(date, "-");
    } else if (val === "4") {
        date = new Date(yy, mm, 0);
        date_ymd = fnGetDateFormat(date, "-");
    } else if (val === "5") {
        date = new Date(yy, mm - 1, 0);
        date_ymd = fnGetDateFormat(date, "-");
    } else if (val === "6") {
        var weekday = date.getDay();
        date = new Date(yy, mm - 1, dd + 6 - weekday);
        date_ymd = fnGetDateFormat(date, "-");
    }

    if (date_ymd !== "") {
        $("#" + id).val(date_ymd);
    }
}

//검색조건
$(document).ready(function () {

    $.each($(".DivSearchConditions"), function (index, objItem) {
        fnGetSearchCondition($(objItem).attr("id"));
    });

    $(".DDSearchConditions input[type='checkbox']").bind("change", function (e) {
        e.preventDefault();
        var id = $(this).attr("id");
        var chkAllID = "";
        id = id.substring(0, id.lastIndexOf("_"));
        chkAllID = $("label[for^='" + id + "'] span.ChkAll").parent("label").attr("for");
        if ($(this).attr("id") !== chkAllID) {
            if ($("input[type='checkbox'][id^='" + id + "']:checked").filter(function () { return $(this).attr("id") !== chkAllID }).length + 1 === $("input[type='checkbox'][id^='" + id + "']").length) {
                $("input[type='checkbox'][id='" + chkAllID + "']").prop("checked", true);
            } else {
                $("input[type='checkbox'][id='" + chkAllID + "']").prop("checked", false);
            }
        } else {
            $("input[type='checkbox'][id^='" + id + "']").prop("checked", $(this).is(":checked"));
        }

        fnSetChkSearchConditions(id);
    });
});

//검색 체크 레이어 - 텍스트 세팅
function fnSetChkSearchConditions(id) {
    var resultTxt = "";
    $("input[type='checkbox'][id^='" + id + "']:checked").each(function (index, item) {
        if ($(item).val() != "") {
            var labelTxt = $("label[for='" + $(item).attr("id") + "']").text();
            if (resultTxt == "") {
                resultTxt = labelTxt;
            } else {
                resultTxt += "," + labelTxt;
            }
        }
    });

    $("#View" + id).val(resultTxt);
}

function fnGetSearchCondition(strID) {
    var intCodeType = 0;
    if (strID.indexOf("OrderLocation") !== -1) {
        intCodeType = 1;
    } else if (strID.indexOf("OrderItem") !== -1) {
        intCodeType = 2;
    } else if (strID.indexOf("OrderStatus") !== -1) {
        intCodeType = 3;
    } else if (strID.indexOf("DeliveryLocation") !== -1) {
        intCodeType = 4;
    }

    var strHandlerUrl = "/Lib/SearchConditionAppHandler.ashx";
    var strCallBackFunc = "fnGetSearchConditionSuccResult";
    var strFailCallBackFunc = "fnGetSearchConditionFailResult";
    var objParam = {
        CallType: "SearchConditionGet",
        CodeType: intCodeType,
        CodeID: strID
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnGetSearchConditionSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            if (typeof objRes[0].Codes !== "string" || typeof objRes[0].CodeID !== "string") {
                return false;
            }

            if (objRes[0].Codes === "") {
                return false;
            }

            var arrCode = objRes[0].Codes.split(",");
            var strUlID = "";
            if (arrCode.length > 0) {
                for (var i = 0; i < arrCode.length; i++) {
                    $.each($("#" + objRes[0].CodeID + " input[type='checkbox']"), function (index, item) {
                        if ($(item).val() == arrCode[i]) {
                            $(item).prop("checked", true);
                            strUlID = $(item).parent("li").parent("ul").attr("id");
                        }
                    });
                }

                if ($("#" + objRes[0].CodeID + " input[type='checkbox']").length - 1 === $("#" + objRes[0].CodeID + " input[type='checkbox']:checked").length) {
                    $("#" + objRes[0].CodeID + " input[type='checkbox']").prop("checked", true);
                }

                fnSetChkSearchConditions(strUlID);
            }

            return false;
        } else {
            fnGetSearchConditionFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnGetSearchConditionFailResult();
        return false;
    }
}

function fnGetSearchConditionFailResult(strMsg) {
    strMsg = typeof strMsg === "string" ? strMsg : "";
    fnDefaultAlert("일시적인 오류가 발생했습니다." + (strMsg === "" ? "" : ("(" + strMsg + ")")), "warning");
    return false;
}

function fnSetSaveSearchCondition(objSearch) {
    var strID = $(objSearch).parent().attr("id");
    var intCodeType = 0;
    var strCodes = "";
    var arrCodes = [];
    if (strID.indexOf("OrderLocation") !== -1) {
        intCodeType = 1;
    } else if (strID.indexOf("OrderItem") !== -1) {
        intCodeType = 2;
    } else if (strID.indexOf("OrderStatus") !== -1) {
        intCodeType = 3;
    } else if (strID.indexOf("DeliveryLocation") !== -1) {
        intCodeType = 4;
    }

    $.each($("#" + strID + " input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() !== "") {
            arrCodes.push($(el).val());
        }
    });

    if (intCodeType === 0) {
        return false;
    }

    strCodes = arrCodes.join(",");

    var strHandlerUrl = "/Lib/SearchConditionAppHandler.ashx";
    var strCallBackFunc = "fnSetSaveSearchConditionSuccResult";
    var strFailCallBackFunc = "fnSetSaveSearchConditionFailResult";
    var objParam = {
        CallType: "SearchConditionUpdate",
        CodeType: intCodeType,
        Codes: strCodes
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerUrl, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnSetSaveSearchConditionSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("검색조건이 저장되었습니다.", "info");
            return false;
        } else {
            fnSetSaveSearchConditionFailResult(objRes[0].ErrMsg);
            return false;
        }
    } else {
        fnSetSaveSearchConditionFailResult();
        return false;
    }
}

function fnSetSaveSearchConditionFailResult(strMsg) {
    strMsg = typeof strMsg === "string" ? strMsg : "";
    fnDefaultAlert("일시적인 오류가 발생했습니다." + (strMsg === "" ? "" : ("(" + strMsg + ")")), "warning");
    return false;
}


/***************************************************************************/
/*							디자인 Alert 실행함수							   */
/***************************************************************************/
function fnDefaultAlert(msg, type = "error", closeFunction = "", closeParam = null, title = "로지스퀘어 매니저") {
    Swal.fire({
        icon: type, //error,info,success,warning,question
        title: title,
        html: msg,
        didClose: function () {
            if (typeof closeFunction === "undefined") {
                closeFunction = "";
            }

            if (closeFunction !== "") {
                if (closeParam !== null) {
                    eval(closeFunction)(closeParam);
                } else {
                    eval(closeFunction);
                }
            }
        }
    });
}

function fnDefaultAlertFocus(msg, focusId = "", type = "error", closeFunction = "", closeParam = null, title = "로지스퀘어 매니저") {
    Swal.fire({
        icon: type, //error,info,success,warning,question
        title: title,
        html: msg,
        didClose: function () {

            if (typeof closeFunction === "undefined") {
                closeFunction = "";
            }

            if (closeFunction !== "") {
                if (closeParam !== null) {
                    eval(closeFunction)(closeParam);
                } else {
                    eval(closeFunction);
                }
            }

            if (typeof focusId === "undefined") {
                focusId = "";
            }

            if ($("#" + focusId).length > 0) {
                $("#" + focusId).focus();
            }
        }
    });
}

/***************************************************************************/
/*							Toast메세지 실행함수							   */
/***************************************************************************/
function fnDefaultToast(msg, type = "error") {
    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer);
            toast.addEventListener('mouseleave', Swal.resumeTimer);
        }
    });

    Toast.fire({
        icon: type,
        title: msg
    });
}

/***************************************************************************/
/*							디자인 Confirm 실행함수						       */
/***************************************************************************/
function fnDefaultConfirm(msg, trueFunction = "", trueParam = null, falseFunction = "", falseParam = null, type = "question", title = "로지스퀘어 매니저") {
    Swal.fire({
        title: title,
        html: msg,
        icon: type, //error,info,success,warning,question
        showCancelButton: true,
        confirmButtonText: "네",
        cancelButtonText: "아니오"
    }).then((result) => {
        if (result.value) {

            if (typeof trueFunction === "undefined") {
                trueFunction = "";
            }

            //true일때 실행시킬 함수
            if (trueFunction !== "") {
                if (trueParam !== null) {
                    eval(trueFunction)(trueParam);
                } else {
                    eval(trueFunction);
                }
            }
        } else {

            if (typeof falseFunction === "undefined") {
                falseFunction = "";
            }

            if (falseFunction !== "") {
                if (falseParam !== null) {
                    eval(falseFunction)(falseParam);
                } else {
                    eval(falseFunction);
                }
            }

        }
    });
}

/***************************************************************************/
/*							디자인 Confirm 결과 함수					       */
/* EX) 데이터를 호출하는 함수 CallFunction에 해당 함수를 넣어 결과 메시지를 보여준다	   */
/***************************************************************************/
function fnResultConfirm(title, msg, type) {
    Swal.fire(
        title,
        msg,
        type
    );
}

//금액 콤마 붙이기
function fnMoneyComma(str) {
    str = String(str);
    var chkMinus = false;
    if (str.indexOf("-") !== -1) {
        str = str.replace(/-/gi, "");
        chkMinus = true;
    }

    if (str.indexOf(",") !== -1) {
        str = str.replace(/,/gi, "");
    }
    str = (chkMinus ? "-" : "") + str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    return str;
}

function fnCalcTax(strSupplyAmt, strTaxAmtID, strTaxKindID) {
    var strTaxKind = $("#" + strTaxKindID).val();
    var strTaxAmt = 0;
    if (strSupplyAmt.indexOf(",") !== -1) {
        strSupplyAmt = strSupplyAmt.replace(/,/gi, "");
    }

    if (strSupplyAmt === "") {
        $("#" + strTaxAmtID).val("");
        return;
    }

    if (strSupplyAmt === "0") {
        $("#" + strTaxAmtID).val("0");
        return;
    }

    //과세구분 (1:과세, 2:면세, 3:간이, 4:간이과세, 5:영세)
    if (strTaxKind === "2" || strTaxKind === "3" || strTaxKind === "5") {
        $("#" + strTaxAmtID).val("0");
        return;
    }

    try {
        strTaxAmt = Math.floor(parseInt(strSupplyAmt) * 0.1);

        if (isNaN(strTaxAmt)) {
            strTaxAmt = 0;
        }

    } catch (e) {
        strTaxAmt = 0;
    }

    $("#" + strTaxAmtID).val(fnMoneyComma(strTaxAmt.toString()));
}

/*시간 포맷 EX) 1000 --> 10:00*/
function fnGetHMFormat(strHM) {
    var strHmFormat = "";
    if (strHM != "" && typeof strHM != "undefined") {
        if (strHM.length === 4) {
            strHmFormat = strHM.substr(0, 2) + ":" + strHM.substr(2, 3);
        } else {
            strHmFormat = strHM;
        }
    }
    return strHmFormat;
}

function fnGetStrDateFormat(ymd, delimiter) {
    var yy = ymd.substring(0, 4);
    var mm = ymd.substring(4, 6);
    var dd = ymd.substring(6, 8);
    if (delimiter == null) delimiter = "";
    return yy + delimiter + mm + delimiter + dd;
}


//레이어형태
function fnOpenAddress(type) {
    var w = $(document).width() - 25;
    var h = 300;

    if ($("#" + type + "AddrWrap").length === 0) {
        var html = "<div id=\"" + type + "AddrWrap\" style=\"display: none; border: 1px solid; width: " + w + "px; height: " + h + "px; margin: 5px 0; position: relative\">";
        html += "<img src=\"//t1.daumcdn.net/postcode/resource/images/close.png\" class=\"BtnDaumAddrClose\" style=\"cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1\" alt=\"접기 버튼\">";
        html += "</div>";

        $("#Div" + type + "AddrWrap").html(html);
    }

    if ($("#" + type + "AddrWrap .BtnDaumAddrClose").length > 0) {
        $("#" + type + "AddrWrap .BtnDaumAddrClose").off().on("click", function () {
            fnCloseDaumPostcodeLayer(type);
            return false;
        });
    }

    fnOpenDaumPostcodeLayer(type);
}

function fnOpenDaumPostcodeLayer(type) {

    var AddrWrap = document.getElementById(type + "AddrWrap");
    new daum.Postcode({
        oncomplete: function (data) {
            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ""; // 주소 변수
            var extraAddr = ""; // 참고항목 변수
            var post = data.zonecode;
            var sido = "";
            var sigungu = "";
            var dong = "";

            addr = data.sido;
            addr += data.sigungu == "" ? "" : (" " + data.sigungu);
            addr += data.bname1 == "" ? "" : (" " + data.bname1);

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if (data.userSelectedType === "R") {
                addr += data.roadname == "" ? "" : (" " + data.roadname);
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }

                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== "") {
                    extraAddr += (extraAddr !== "" ? ", " + data.buildingName : data.buildingName);
                }

                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraAddr !== "") {
                    extraAddr = " (" + extraAddr + ")";
                }

                extraAddr = data.roadAddress.replace(addr + " ", "") + extraAddr;

            } else {
                addr += data.bname == "" ? "" : (" " + data.bname);
                extraAddr = data.jibunAddress.replace(addr + " ", "") + extraAddr;
            }

            sido = fnGetShortSido(data.sido);
            sigungu = data.sigungu;
            dong = data.bname1;
            if (data.bname !== "" && /[동|로|가]$/g.test(data.bname)) {
                dong += dong === "" ? data.bname2 : (" " + data.bname2);
            }

            fnSetAddress(type, post, addr, extraAddr, sido, sigungu, dong);
            fnCloseDaumPostcodeLayer(type);
        },
        onresize: function (size) {
            AddrWrap.style.height = size.height + "px";
        },
        width: "100%",
        height: "100%"
    }).embed(AddrWrap);

    $("#" + type + "AddrWrap").show();
}

function fnCloseDaumPostcodeLayer(type) {
    $("#" + type + "AddrWrap").hide();
}

function fnSetAddress(type, post, addr, addrDtl, sido, sigungu, dong) {
    var strFullAddr = "";
    if ($("#" + type + "Post").length > 0) {
        $("#" + type + "Post").val(post);
    }

    $("#" + type + "Addr").val(addr);
    $("#" + type + "AddrDtl").val(addrDtl);
    $("#" + type + "AddrDtl").focus();

    if ($("#" + type + "Sido").length > 0) {
        $("#" + type + "Sido").val(sido);
    }

    if ($("#" + type + "Sigungu").length > 0) {
        $("#" + type + "Sigungu").val(sigungu);
    }

    if ($("#" + type + "Dong").length > 0) {
        $("#" + type + "Dong").val(dong);
    }

    strFullAddr = sido;
    if (sigungu != "") {
        strFullAddr += " " + sigungu;
    }
    if (dong != "") {
        strFullAddr += " " + dong;
    }

    if ($("#" + type + "FullAddr").length > 0) {
        $("#" + type + "FullAddr").val(strFullAddr);
    }
}

function fnGetFullSido(strSido) {
    var strRetSido = "";
    switch (strSido) { // 1번
        case "서울":
            strRetSido = "서울특별시";
            break;
        case "부산":
            strRetSido = "부산광역시";
            break;
        case "인천":
            strRetSido = "인천광역시";
            break;
        case "대구":
            strRetSido = "대구광역시";
            break;
        case "대전":
            strRetSido = "대전광역시";
            break;
        case "광주":
            strRetSido = "광주광역시";
            break;
        case "울산":
            strRetSido = "울산광역시";
            break;
        case "세종":
            strRetSido = "세종특별자치시";
            break;
        case "제주":
            strRetSido = "제주특별자치도";
            break;
        case "경기":
            strRetSido = "경기도";
            break;
        case "강원":
            strRetSido = "강원도";
            break;
        case "충북":
            strRetSido = "충청북도";
            break;
        case "충남":
            strRetSido = "충청남도";
            break;
        case "전북":
            strRetSido = "전북특별자치도";
            break;
        case "전남":
            strRetSido = "전라남도";
            break;
        case "경북":
            strRetSido = "경상북도";
            break;
        case "경남":
            strRetSido = "경상남도";
            break;
        default:
            strRetSido = strSido;
            break;
    }

    return strRetSido;
}

function fnGetShortSido(strSido) {
    var strRetSido = "";
    switch (strSido) { // 1번
        case "서울특별시":
            strRetSido = "서울";
            break;
        case "부산광역시":
            strRetSido = "부산";
            break;
        case "인천광역시":
            strRetSido = "인천";
            break;
        case "대구광역시":
            strRetSido = "대구";
            break;
        case "대전광역시":
            strRetSido = "대전";
            break;
        case "광주광역시":
            strRetSido = "광주";
            break;
        case "울산광역시":
            strRetSido = "울산";
            break;
        case "세종특별자치시":
            strRetSido = "세종";
            break;
        case "제주특별자치도":
            strRetSido = "제주";
            break;
        case "경기도":
            strRetSido = "경기";
            break;
        case "강원도":
            strRetSido = "강원";
            break;
        case "충청북도":
            strRetSido = "충북";
            break;
        case "충청남도":
            strRetSido = "충남";
            break;
        case "전북특별자치도":
            strRetSido = "전북";
            break;
        case "전라남도":
            strRetSido = "전남";
            break;
        case "경상북도":
            strRetSido = "경북";
            break;
        case "경상남도":
            strRetSido = "경남";
            break;
        default:
            strRetSido = strSido;
            break;
    }

    return strRetSido;
}

function fnGetScrollBarWidth() {
    var el = document.createElement("div");
    el.style.cssText = "overflow:scroll; visibility:hidden; position:absolute;";
    document.body.appendChild(el);
    var width = el.offsetWidth - el.clientWidth;
    el.remove();

    if (isNaN(width)) {
        width = 17;
    }

    return width;
}

function fnGetCutStr(str, size, withString) {
    var ret = "";
    var tmp = 0, cnt = 0;
    if (typeof str === "string") {
        if (str === "") {
            return str;
        }
    }

    for (var i = 0; i < str.length; i++) {
        tmp = str[i].charCodeAt();

        if (tmp > 127) {
           // cnt++;
        }

        cnt++;

        if (size < cnt) {
            ret = str.substring(0, i);
            break;
        }
    }

    if (ret.length < str.length) {
        ret += withString;
    }

    return ret;
}

function fnAjaxFailResult(XMLHttpRequest, textStatus, errorThrown) {
    console.log(XMLHttpRequest);
    console.log(textStatus);
    console.log(errorThrown);

    try {
        if (isBlock) {
            $.unblockUI();
        }

        if (XMLHttpRequest.status === 401) {
            var msg = "처리 중 오류가 발생하였습니다.";
            if (XMLHttpRequest.responseText != null) {
                var data = $.parseJSON(XMLHttpRequest.responseText);
                msg = data[0].ErrMsg;
            }
            fnDefaultAlert(msg, "warning", "parent.fnGoLogout()");
            return false;
        }

        if (XMLHttpRequest.responseText != null) {
            var data = $.parseJSON(XMLHttpRequest.responseText);
            fnDefaultAlert(data[0].ErrMsg);
        } else {
            fnDefaultAlert("처리 중 오류가 발생하였습니다.");
        }
    } catch (e) {
        fnDefaultAlert("처리 중 오류가 발생하였습니다.(" + errorThrown + ")");
    }
}