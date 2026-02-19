var UTILJS =
{
    CSRFID: "__RequestVerificationToken",
    BLOCKDIVID: "divLoadingImage",
    COMMONERRORMSG: "처리 중 오류가 발생했습니다.",
    COMMONPAGESIZE: 10
}

/********************************************************************************************
* Init
********************************************************************************************/
UTILJS.Init =
{
    /********************************************************************************************
    * Load Js
    ********************************************************************************************/
    fnLoadPageEvent: function () {

        // 숫자만 입력
        /********************************************************************************/
        /*							숫자만 입력 가능한 input						         */
        /*																		         */
        /*사용법 : <input type="text" class="OnlyNumber"/>--input에 onlyNumber 클래스 추가   */
        /********************************************************************************/
        $('.OnlyNumber').on('keyup blur', function () {
            $(this).val($(this).val().replace(/[^0-9]/g, ""));
        });

        // 숫자,소수점만 입력
        /********************************************************************************/
        /*							숫자,소수점만 입력 가능한 input						         */
        /*																		         */
        /*사용법 : <input type="text" class="OnlyNumberPoint"/>--input에 onlyNumberPoint 클래스 추가   */
        /********************************************************************************/
        $('.OnlyNumberPoint').on('keyup blur', function () {
            $(this).val($(this).val().replace(/[^0-9\.]/g, ""));
        });

        // 금액 입력
        /********************************************************************************/
        /*							금액 input						         */
        /*																		         */
        /*사용법 : <input type="text" class="Money"/>--input에 OnlyMoney 클래스 추가   */
        /********************************************************************************/
        $('.Money').on('keyup blur', function () {
            $(this).val($(this).val().replace(/[^0-9\.,-]/g, ""));
        });

        // 수량 입력
        /********************************************************************************/
        /*							수량 input						         */
        /*																		         */
        /*사용법 : <input type="text" class="OnlyMoney"/>--input에 OnlyMoney 클래스 추가   */
        /********************************************************************************/
        $('.Volume').on('keyup blur', function () {
            $(this).val($(this).val().replace(/[^0-9]/g, ""));
        });

        // 중량 입력
        /********************************************************************************/
        /*							중량 input						         */
        /*																		         */
        /*사용법 : <input type="text" class="Weight"/>--input에 OnlyMoney 클래스 추가   */
        /********************************************************************************/
        $('.Weight').on('keyup blur', function () {
            $(this).val($(this).val().replace(/[^0-9\.,]/g, ""));
        });

        // CBM 입력
        /********************************************************************************/
        /*							CBM input						         */
        /*																		         */
        /*사용법 : <input type="text" class="Weight"/>--input에 OnlyMoney 클래스 추가   */
        /********************************************************************************/
        $('.Cbm').on('keyup blur', function () {
            $(this).val($(this).val().replace(/[^0-9\.,]/g, ""));
        });

        /**********************************************************************************/
        /*							영문만 입력 가능한 input						          */
        /*																		          */
        /*사용법 : <input type="text" class="onlyAlphabet"/>--input에 onlyAlphabet 클래스 추가*/
        /*********************************************************************************/
        $(".onlyAlphabet").on('keyup blur', function () {
            if (!(event.keyCode >= 37 && event.keyCode <= 40)) {
                var inputVal = $(this).val();
                $(this).val(inputVal.replace(/[^a-z]/gi, ''));
            }
        });

        //영숫자 입력
        /********************************************************************************/
        /*							영문대/소문자,숫자 입력 가능한 input							*/
        /*																		        */
        /*사용법 : <input type="text" class="onlyAlphabetNum"/>							*/
        /*		  --input에 onlyAlphabetNum 클래스 추가									*/
        /********************************************************************************/
        $(".onlyAlphabetNum").on('keyup blur', function () {
            if (!(event.keyCode >= 37 && event.keyCode <= 40)) {
                var inputVal = $(this).val();
                $(this).val(inputVal.replace(/[^a-zA-Z0-9]/gi, ''));
            }
        });

        //이메일
        /********************************************************************************/
        /*						이메일 입력 가능한 input							*/
        /*																		        */
        /*사용법 : <input type="text" class="Email"/>							*/
        /*		  --input에 Email 클래스 추가									*/
        /********************************************************************************/
        $(".OnlyEmail").on('keyup blur', function () {
            if (!(event.keyCode >= 37 && event.keyCode <= 40)) {
                var inputVal = $(this).val();
                $(this).val(inputVal.replace(/[^a-zA-Z0-9@-_.]/gi, ''));
            }
        });

        /********************************************************************************/
        /*							한글만 입력 가능한 input						        */
        /*																		        */
        /*사용법 : <input type="text" class="onlyHangul"/>--input에 onlyHangul 클래스 추가  */
        /********************************************************************************/
        $(".onlyHangul").on('keyup blur', function () {
            if (!(event.keyCode >= 37 && event.keyCode <= 40)) {
                var inputVal = $(this).val();
                $(this).val(inputVal.replace(/[a-z0-9]/gi, ''));
            }
        });

        $(".readonly").focus(function () {
            $(".readonly").blur();
        });
    }
}

/*************************************************************
*                          Ajax
**************************************************************/
UTILJS.Ajax =
{
    fnRequest: function (arrParameter, strCallUrl, strCallBack, isBlock, strFailCallBack, strCompleteCallBack, isaSync, strMethod) {

        if (typeof isBlock == "undefined") {
            isBlock = true;
        }

        if (typeof strFailCallBack == "undefined") {
            strFailCallBack = "";
        }

        if (typeof strCompleteCallBack == "undefined") {
            strCompleteCallBack = "";
        }

        if (typeof isaSync == "undefined") {
            isaSync = true;
        }

        if (typeof strMethod == "undefined") {
            strMethod = "POST";
        }

        $.ajax({
            cache: false,
            async: isaSync,
            type: strMethod,
			data: JSON.stringify(arrParameter),
            url: strCallUrl,
			contentType: "application/json; charset=utf-8",
			headers: { "__RequestVerificationToken": UTILJS.AntiCSRF.getVerificationToken() },
            beforeSend: function () {
                if (isBlock) {
                    UTILJS.Ajax.fnAjaxBlock();
                }
            },
            success: function (data) {
                if (typeof (data) === "object") {
                    eval(strCallBack)(data);
                }
                else if (typeof (data) === "string") {
                    eval(strCallBack)($.parseJSON(data));
                }
            },
            complete: function () {
                if (isBlock) {
                    $.unblockUI();
                }
                if (strCompleteCallBack != "") {
                    eval(strCompleteCallBack)();
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                if (isBlock) {
                    $.unblockUI();
                }

                if (strFailCallBack == "") {
                    fnDefaultAlert(UTILJS.COMMONERRORMSG);
                } else {
                    eval(strFailCallBack)(XMLHttpRequest, textStatus, errorThrown);
                }
            }
        });
    },

    fnHandlerRequest: function (strParameter, strCallUrl, strCallBack, isBlock, strFailCallBack, strCompleteCallBack, isaSync) {

        if (typeof isBlock == "undefined") {
            isBlock = true;
        }

        if (typeof isaSync == "undefined") {
            isaSync = true;
        }

        if (typeof strFailCallBack == "undefined") {
            strFailCallBack = "";
        }

        if (strFailCallBack == "") {
            strFailCallBack = "fnAjaxFailResult";
        }

        if (typeof strCompleteCallBack == "undefined") {
            strCompleteCallBack = "";
        }

        var strMethod           = "POST";

        $.ajax({
            cache: false,
            async: isaSync,
            type: strMethod,
            data: strParameter,
            url: strCallUrl,
            headers: { "__RequestVerificationToken": UTILJS.AntiCSRF.getVerificationToken() },
            beforeSend: function () {
                if (isBlock) {
                    UTILJS.Ajax.fnAjaxBlock();
                }
            },
            success: function (data) {
                if (typeof (data) === "object") {
                    eval(strCallBack)(data);
                }
                else if (typeof (data) === "string") {
                    eval(strCallBack)($.parseJSON(data));
                }
            },
            complete: function () {
                if (isBlock) {
                    $.unblockUI();
                }
                if (strCompleteCallBack != "") {
                    eval(strCompleteCallBack)();
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                if (isBlock) {
                    $.unblockUI();
                }

                if (strFailCallBack == "") {
                    alert(UTILJS.COMMONERRORMSG);
                } else {
                    eval(strFailCallBack)(XMLHttpRequest, textStatus, errorThrown);
                }
            }
        });
    },

    /* Block 옵션*/
    fnAjaxBlock: function () {
        try {
            $.blockUI({
                message: $("#" + UTILJS.BLOCKDIVID)
            });
        }
        catch (ex)
        { }
    }
}

/********************************************************************************************
* Anti CSRF
********************************************************************************************/
UTILJS.AntiCSRF =
{
    /*-----------------------------------------------------------
    * Description : Get CSRF ID
    * Parameter : -
    * Return : -
    -----------------------------------------------------------*/
    getVerificationToken: function () {
        var strCSRFValue = "";

        strCSRFValue = $("input[name='" + UTILJS.CSRFID + "']").val();

        return strCSRFValue;
    }
}

/*************************************************************
*                      Utility Function
**************************************************************/
UTILJS.Util =
{
    fnGetBoolean: function (val) {
        var strRegx = /^(?:f(?:alse)?|no?|0+)$/i;

        return !strRegx.test(val) && !!val;
    },

    /* 금액 컴마 */
    fnComma: function (strAmt) {
        strAmt = String(strAmt);
        strAmt = strAmt.replace(/\,/gi, '');    //콤마제거

        return strAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    },

    /* 이메일 벨리데이션 */
    fnValidId: function (strId) {
        var regex = /^[a-z]+[a-z0-9]{5,19}$/g;
        return regex.test(strId);
    },

    /* 이메일 벨리데이션 */
    fnValidEmail: function (strEmail) {
        //var regex = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
        var regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
        return regex.test(strEmail);
    },

    /* 휴대폰번호 체크 */
    fnCellNoChk: function (strNumber) {
        var regex = /^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$/;
        return regex.test(strNumber);
    },

    /* 사업자번호 체크 */
    fnBizNoChk: function(strNumber) {
        var numberMap = strNumber.replace(/-/gi, '').split('').map(function (d) {
            return parseInt(d, 10);
        });

        if (numberMap.length == 10) {
            var keyArr = [1, 3, 7, 1, 3, 7, 1, 3, 5];
            var chk = 0;

            keyArr.forEach(function (d, i) {
                chk += d * numberMap[i];
            });

            chk += parseInt((keyArr[8] * numberMap[8]) / 10, 10);
            return Math.floor(numberMap[9]) === ((10 - (chk % 10)) % 10);
        }

        return false;
    },

    /* 차량번호 체크 */
    fnCarNoChk: function (strNumber) {
        //var pattern1 = /^\d{2}[가-힣ㄱ-ㅎㅏ-ㅣ\x20]\d{4}$/g; // 12저1234
        var pattern2 = /^[가-힣ㄱ-ㅎㅏ-ㅣ\x20]{2}\d{2}[가-힣ㄱ-ㅎㅏ-ㅣ\x20]\d{4}$/g; // 서울12치1233

        return pattern2.test(strNumber);
    },

    /* 한글,숫자 */
    fnChkKorNum: function (str, id) {
        var ptn = /^[가-힣0-9]*$/;
        if (!ptn.test($("#" + id).val())) {
            alter(str + ' 한글과 숫자만 입력 가능합니다.', id);
            return false;
        }
        return true;
    },

    /* 한글,쉼표 */
    fnChkKor: function (str, id) {
        var ptn = /^[가-힣,]*$/;
        if (!ptn.test($("#" + id).val())) {
            alter(str + ' 한글과 (,)만 입력 가능합니다.', id);
            return false;
        }
        return true;
    },

    /* Google Tag Manager Event Push */
    fnDataLayerPush: function (strEventName, strMsgName, strMsg)
    {
        if (typeof dataLayer != "undefined")
        {
            var obj = {};

            obj["event"]     = strEventName;
            obj[strMsgName]  = strMsg;

            dataLayer.push(obj);
        }
    },

    /* 브라우저 체크 */
    fnChkBrowser : function()
    {
        var strUA = navigator.userAgent.toLowerCase();

        if (strUA.indexOf("chrome") != -1) return 'Chrome';
        if (strUA.indexOf("opera") != -1) return 'Opera';
        if (strUA.indexOf("staroffice") != -1) return 'Star Office';
        if (strUA.indexOf("webtv") != -1) return 'WebTV';
        if (strUA.indexOf("beonex") != -1) return 'Beonex';
        if (strUA.indexOf("chimera") != -1) return 'Chimera';
        if (strUA.indexOf("netpositive") != -1) return 'NetPositive';
        if (strUA.indexOf("phoenix") != -1) return 'Phoenix';
        if (strUA.indexOf("firefox") != -1) return 'Firefox';
        if (strUA.indexOf("safari") != -1) return 'Safari';
        if (strUA.indexOf("skipstone") != -1) return 'SkipStone';
        if (strUA.indexOf("netscape") != -1) return 'Netscape';
        if (strUA.indexOf("mozilla/5.0") != -1) return 'Mozilla';
        return "";
    },

    /* Block 옵션*/
    /* style css --> .loading-pay .dim-pay {position:fixed;top:0;left:0;width:100%;height:100%;background-color:#ffffff;opacity:0.5;-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=50)";filter: alpha(opacity=50);z-index:99;} */
    fnBlock: function (strButtonID, strAddClass)
    {
        if(typeof strButtonID != "undefined" && strButtonID != null && typeof strAddClass != "undefined" && strAddClass != null)
        {
            $(strButtonID).addClass(strAddClass);
        }
        
        $("html").addClass("loading-pay");
        $("body").append("<div class='dim-pay'></div>");
    },

    fnUnBlock: function(strButtonID, strRemoveClass)
    {
        if(typeof strButtonID != "undefined" && strButtonID != null && typeof strRemoveClass != "undefined" && strRemoveClass != null)
        {
            $(strButtonID).removeClass(strRemoveClass);
        }

		$("html").removeClass("loading-pay");
		$(".dim-pay").remove();
    }
}

/********************************************************************************************
* Dom Ready
********************************************************************************************/
$(document).ready(function () {
    UTILJS.Init.fnLoadPageEvent();
}).on("keydown", function (e) {
    // 새로고침 방지
    var allowPageList = new Array('/sample/index'); // 허용 세그먼트
    var bBlockF5Key = true;
/*
    for (number in allowPageList) {
        var regExp = new RegExp('^' + allowPageList[number] + '.*', 'i');

        if (regExp.test(document.location.pathname)) {
            bBlockF5Key = false;
            break;
        }
    }

    if (bBlockF5Key) {
        if (e.which === 116) {
            if (typeof event == "object") {
                event.keyCode = 0;
            }

            return false;
        }
        else if (e.which === 82 && e.ctrlKey) {
            return false;
        }
        else if (e.which === 78 && e.ctrlKey) {
            return false;
        }
    }*/
})/*.on("contextmenu", function (e) {
    // 우클릭 메뉴 방지
    return false;
}).on("selectstart", function (e) {
    // 마우스 클릭 후 드레그 방지
    return false;
}).on("dragstart", function (e) {
    // 마우스 드레그 방지
    return false;
})*/;

function GetDateToday(str) {
    var date = new Date();

    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();

    if (m < 10) {
        m = "0" + m;
    } else {
        m = m.toString();
    }


    if (d < 10) {
        d = "0" + d;
    } else {
        d = d.toString();
    }

    return y + str + m + str + d;
}