/*LOCAL, DEV, STAGE, LIVE 호출 URL 구분 변수 시작*/
var HostType = $(location).attr('host').split(".")[0];
var GetUrl = "";
var JsonUrl = "";
if (HostType == "logimanlocal" || HostType == "logimandev" || HostType == "logimantest") {
    GetUrl = "http://" + $(location).attr('host') + "/";
} else if (HostType == "logiman") {
    GetUrl = "https://" + $(location).attr('host') + "/";
}

/*LOCAL, DEV, STAGE, LIVE 호출 URL 구분 변수 시작*/
if (HostType == "logimanlocal") {
    JsonUrl = "http://localpaas.cargomanager.co.kr";
} else if (HostType == "logimandev" ) {
    JsonUrl = "http://devpaas.cargomanager.co.kr";
} else if (HostType == "logimantest" ) {
    JsonUrl = "http://testpaas.cargomanager.co.kr";
} else if (HostType == "logiman" ) {
    JsonUrl = "https://paas.cargomanager.co.kr";
}

var countdown = 3;

var CARGOPAYJS =
{
    System      : "CargoPay",
    SystemKorName : "로지맨알림톡", 
    ProgramID   : "CARGOPAYJS.js",
    ProgramName : "Common Javascript",
    Author      : "leejy",
    CreateDate  : "2020.04.16",
    MenuName    : "오더정보",
    CommonBannerJson: JsonUrl + "/BANNER/json/CommonBannerjson.aspx"  //하드코딩된 것. 수정 必
}

/*************************************************************
*                          Ajax
**************************************************************/
CARGOPAYJS.Ajax =
{
    strAjaxLoaderImg: JsonUrl + "/BANNER/images/ajax-loader.gif",

    /* Ajax - (파라미터, 호출할URL, Ajax 성공 시 이동할 함수명, Ajax 실패 시 이동할 함수명, 로딩바 구현 여부, 블락할 id(#를 붙일것)) */
    fnRequest: function (arrParam, strCallUrl, strFnSuccess, strFnFailure, blnLoading, strBlockID, blnAsync)
    {
        var blnAsync = typeof blnAsync !== "undefined" ? blnAsync : true;
        
        $.ajax({
            cache       : false,
            type        : "POST",
            url         : strCallUrl,
            data        : JSON.stringify(arrParam),
            //contentType : "application/json; charset=utf-8",
            dataType    : "json",
            async       : blnAsync,
            success     : function (data)
            {
                eval(strFnSuccess)(data);
            },
            failure    : function (XMLHttpRequest, textStatus, errorThrown)
            {
                eval(strFnFailure)(XMLHttpRequest, textStatus, errorThrown);
            },
            error      : function (XMLHttpRequest, textStatus, errorThrown)
            {
                console.log(XMLHttpRequest);
                eval(strFnFailure)(XMLHttpRequest, textStatus, errorThrown);
            },
            beforeSend : function()
            {
                if(blnLoading)
                {
                    CARGOPAYJS.Ajax.fnAjaxBlock(strBlockID);
                }
            },
            complete   : function()
            {
                if(blnLoading)
                {
                    $(strBlockID).unblock();
                }
            }
        });
    },

    /* Block 옵션*/
    fnAjaxBlock: function (strBlockID)
    {
        $(strBlockID).block({
            message: "<img src='" + CARGOPAYJS.Ajax.strAjaxLoaderImg + "' />",
            css: {
                padding        : 0,
                margin         : 0,
                border         : "none",
                backgroundColor: "transparent",
                opacity        : 1,
                color          : "#000"
            }, overlayCSS: {
                backgroundColor: "#F00",
                opacity        : 0.0,
                cursor         : "wait"
            }
        });
    }
}

/*************************************************************
*                      Utility Function
**************************************************************/
CARGOPAYJS.Util =
{
    /* 금액 컴마 */
    fnComma: function (strAmt)
    {
        strAmt = String(strAmt);
        return strAmt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    },

    /* 이메일 벨리데이션 */
    fnValidEmail: function (strEmail)
    {
        var regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
        return regex.test(strEmail);
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

/*************************************************************
*                          Banner
**************************************************************/
CARGOPAYJS.Banner =
{
    //intSlideWidth  : "100%", //배너 슬라이드 가로 길이
    //intSlideHeight : 60, //배너 슬라이드 세로 길이

    strDefaultImg0 : "",

    strDefaultUrl  : GetUrl, //하드코딩된 것. 수정 必
    strImgClass    : "rollBanner",
    strImgPath     : JsonUrl + "/BANNER/images/sub/", //하드코딩된 것. 수정 必

    strFnSucc      : "CARGOPAYJS.Banner.fnDisplayBanner",
    strFnFail      : "CARGOPAYJS.Banner.fnFailGetBanner",
    strErrImg      : "errimg.png",

    objSlides: "#CARGOPAY_BANNER",
    objSlidesPagination: ".slidesjs-pagination",
    objRollBanner  : ".rollBanner",

    // 이벤트 등록 및 배너 스타트
    fnInit: function ()
    {
        CARGOPAYJS.Banner.fnGetBanner();
        $(document).on("click", ".aBanner", function (event) {
            var $objThis = $(this);

            CARGOPAYJS.Util.fnDataLayerPush("ctm.clickBanner", "banner", $objThis.children().attr("title"));
            var url = $objThis.children().attr("url");
            window.open(url);

            event.preventDefault();
        });
    },

    // 배너 가져오기
    fnGetBanner: function ()
    {
        $(CARGOPAYJS.Banner.objSlides).children().remove();
        var objParam = {};
        objParam["POSITION"] = $("#HidBannerPosition").val();
        objParam["SIZE"] = $("#HidImageSize").val();
        CARGOPAYJS.Ajax.fnRequest(objParam, CARGOPAYJS.CommonBannerJson, CARGOPAYJS.Banner.strFnSucc, CARGOPAYJS.Banner.strFnFail);
    },

    //배너를 성공적으로 가져왔을 경우
    fnDisplayBanner: function (data)
    {
        var strHtmlTag = "";
        var objResult  = data;

        if (objResult != null && objResult.length > 0)
        {
            strHtmlTag = CARGOPAYJS.Banner.fnMakeBanner(objResult);
            CARGOPAYJS.Banner.fnSetBanner(strHtmlTag, parseInt(objResult.intRollTerm, 10), parseInt(objResult.intBannerCnt, 10));
        }
        else
        {
            CARGOPAYJS.Banner.fnFailGetBanner();
        }
    },

    //배너 셋팅
    fnSetBanner: function (strHtmlTag, intRollTerm, intBannerCnt)
    {
        var $objImg = {};
        $(CARGOPAYJS.Banner.objSlides).append(strHtmlTag);

        //이미지 크기 slide에 맞추기
        $(CARGOPAYJS.Banner.objRollBanner).each(function () {
            $objImg = $(this);
            /*$objImg.css("width", "100%");
            $objImg.css("height", "63px");*/
        });

        CARGOPAYJS.Banner.fnSlideBanner(intRollTerm, intBannerCnt);
        
    },
    
    //배너 만들기
    fnMakeBanner: function (objResult)
    {
        var strHtmlTag = "";
        var strBannerUrl = "";
        var strClickEvent = "";
        
        if ($("#hid_ClickType").val() != "N") {
            strClickEvent = "onclick='CargoShopLink(\"" + HostType + "\",\"" + CARGOPAYJS.SystemKorName + "-" + $("#HidPageTitle").val() + "-" + objResult[0].BannerName + "\", \"" + objResult[0].BannerLink + "\", \"" + objResult[0].ParaMeter + "\", \"" + objResult[0].BannerKind + "\", \"" + objResult[0].BannerName + "\", 2);'";
        }

        strHtmlTag += "<div><img style='" + objResult[0].ImageSize + "' class='" + CARGOPAYJS.Banner.strImgClass + "' src='" + objResult[0].ImageUrl + "' title='" + objResult[0].BannerName + "' url='" + strBannerUrl + "' onError='CARGOPAYJS.Banner.fnImgError(this);' " + strClickEvent + "/></div>";

        if ($("#hid_Banner_Init").val() != "N") {
            fnBannerEventHistRequest(1, objResult[0].BannerKind, objResult[0].BannerName);
        }
        
        return strHtmlTag;
    },

    //배너 슬라이드
    fnSlideBanner: function (intRollTerm, intBannerCnt)
    {
        $(CARGOPAYJS.Banner.objSlides).show();
        /*if (intBannerCnt === 1)
        {
            $(CARGOPAYJS.Banner.objSlides).show();
        }
        else
        {
            $(CARGOPAYJS.Banner.objSlides).slidesjs({
                width: $(".rollBanner").width(),
                height: $(".rollBanner").height(),
                navigation: {
                    active: false, // 네비게이션 사용 유무(이전 다음 보기 버튼)
                    effect: "slide"
                },
                pagination: {
                    effect: "slide",
                    active: false
                },
                effect: {
                    fade: {
                        speed: 600
                    }
                },
                play: {
                    active: false,
                    auto: true,
                    swap: false,
                    interval: 5000,
                    effect: "slide"
                }
            });
        }*/
    },

    //배너 페이지네이션 설정
    fnSetPageNation : function(intFlag)
    {
        if (intFlag == 0)
        {
            $(CARGOPAYJS.Banner.objSlidesPagination).hide();
        }
        else if(intFlag == 1)
        {
            $(CARGOPAYJS.Banner.objSlidesPagination).show();
        }
        else
        {
            $(CARGOPAYJS.Banner.objSlidesPagination).hide();
        }
    },

    fnFailGetBanner: function ()
    {
        console.log("FailGetBanner");
    },

    /* 이미지를 가져오지 못할 경우 대체 이미지*/
    fnImgError : function(objImg)
    {
        objImg.src = CARGOPAYJS.Banner.strImgPath + CARGOPAYJS.Banner.strErrImg;
        objImg.onerror = "";
        return true;
    }
}

function fnBannerEventResult(data) {
    //console.log(data);
}

function fnBannerEventFail(data) {
    //console.log(data);
}

//카고샵 전면배너 링크 -- 이준영 20200421
function CargoShopLink(szDomain, szBannerName, url, parm, BnKind, BnName, AjaxNo) {
    var parameterVal = "";
    // Tag Manager Event
    var szBannerInfo = szBannerName + "(" + szDomain + ")";
    fnDataLayerPush("gtm.sms20.clickBanner", "BannerName", szBannerInfo);
    // Tag Manager Event

    if (parm == "Y") {
        parameterVal = "?USE_NAME=" + $("#HidUserName").val() + "&USE_CELL=" + $("#HidUserCell").val() + "&INFLOW_TYPE=2" + "&GA_TYPE=gtm.sms20.clickBanner" + "&GTM_ID=" + $("#hid_GTM_ID").val();
    }

    //window.open($("#hid_PaasUrl").val());
    window.open(url + parameterVal, szBannerName, "width=" + screen.availWidth + ",height=" + screen.availHeight + ",scrollbars=yes");

    fnBannerEventHistRequest(AjaxNo, BnKind, BnName);
}

/* Google Tag Manager Event Push */
function fnDataLayerPush(strEventName, strMsgName, strMsg) {
    if (typeof dataLayer != "undefined") {
        var obj = {};

        obj["event"] = strEventName;
        obj[strMsgName] = strMsg;

        dataLayer.push(obj);
    }
}

function fnBannerEventHistRequest(n, BnKind, BnName) {
    var strHandlerURL = JsonUrl + "/BANNER/json/BannerEventHandler.ashx";
    var strCallBackFunc = "fnBannerEventResult";
    var strAjaxFailFunc = "fnBannerEventFail";
    var objParam = {};

    if (n == 1) {
        objParam["EVENT_TYPE"] = n;
        objParam["USER_NO"] = $("#HidUserNo").val();
        objParam["USER_CELL"] = $("#HidUserCell").val();
        objParam["USER_NAME"] = $("#HidUserName").val();
        objParam["BANNER_KIND"] = BnKind;
        objParam["BANNER_NAME"] = BnName;
        objParam["MENU_NAME"] = $("#HidPageTitle").val();
        objParam["INFLOW_TYPE"] = 2;
    } else {
        objParam["EVENT_TYPE"] = n;
        objParam["USER_NO"] = $("#HidUserNo").val();
        objParam["USER_CELL"] = $("#HidUserCell").val();
        objParam["USER_NAME"] = $("#HidUserName").val();
        objParam["BANNER_KIND"] = BnKind;
        objParam["BANNER_NAME"] = BnName;
        objParam["MENU_NAME"] = $("#HidPageTitle").val();
        objParam["INFLOW_TYPE"] = 2;
    }

    console.log(objParam);

    CARGOPAYJS.Ajax.fnRequest(objParam, strHandlerURL, strCallBackFunc, strAjaxFailFunc, null, null, true);
}
