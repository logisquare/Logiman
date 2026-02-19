using System.Web;

//===============================================================
// FileName       : CommonConstant.cs
// Description    : 공통 상수 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.Constants
{
    public class CommonConstant
    {
        public static string SITE_TITLE          = ":::: 로지스퀘어 매니저 ::::";
        public static int    SITE_CODE           = 1;
        public static string SMS_TITLE           = ":::: 로지스퀘어 매니저 알림톡 ::::";
        public static string SMS_TITLE_SIMPLE    = ":::: 로지맨 알림톡 ::::";
        public static int    DEFAULT_CENTER_CODE = 2; //로지스퀘어 운송사 코드
        public static string DEFAULT_CENTER_TEL  = "042-935-3100";
        public static string DEFAULT_SMS_TEL     = "042-935-3100"; //로지스퀘어 SMS 대표번호

        // 사이트의 도메인 정보 관리 변수
        public const string WEBSERVICE_REGISTRY        = "TMSDomain";
        public const string WEBSERVICE_REGISTRY_KEY    = "logiman.logisquare.co.kr";
        public const string WEBSERVICE_DOMAIN_NAME     = "DomainName";
        public const string AES_ENC_KEY_NAME           = "AesEncKey";
        public const string AES_ENC_IV_NAME            = "AesEncIV";
        public const string AES_ENC_KEY_CARGOPASS_NAME = "AesEncKey_Cargopass";
        public const string AES_ENC_IV_CARGOPASS_NAME  = "AesEncIV_Cargopass";
        public const string COOKIE_NAME                = "TMSADM";
        public const string ADMIN_FROM_EMAIL           = "Logiman_Admin<logiman.send@logisquare.co.kr>";
        public const string LOCALDEV_DOMAIN            = "locallogiman.logisquare.co.kr";
        public const string DEV_DOMAIN                 = "devlogiman.logisquare.co.kr";
        public const string TEST_DOMAIN                = "testlogiman.logisquare.co.kr";
        public const string REAL_DOMAIN                = "logiman.logisquare.co.kr";
        public static string[] ADMIN_TO_EMAIL          = { "pckeeper@logislab.com", "shadow54@logislab.com", "sybyun96@logislab.com", "logiman.receive@logisquare.co.kr" };

        // 서비스 점검
        public const string SERVICE_STOP_FLAG       = "ServiceStopFlag";
        public const string SERVICE_STOP_ALLOWIP    = "ServiceStopAllowIP";
        public const string SERVICE_STOP_TITLE      = "ServiceStopTitle";
        public const string SERVICE_STOP_CONTENT    = "ServiceStopContent";

        // API 변수
        public const string WS_API_DEFAULT_CONTENTTYPE            = "application/json; charset=utf-8";    //Default content type
        public const string WS_API_CONTENTTYPE                    = "application/x-www-form-urlencoded";
        
        // 로지스퀘어 API
        public const string WS_API_COMMAND_SENDSMS            = "/SendSMS";
        public const string WS_API_COMMAND_CALLSMSAUTH        = "/CallSMSAuth";
        public const string WS_API_COMMAND_CHKCORPNO          = "/ChkCorpNo";
        public const string WS_API_UNIPAAS_CARGO_INFO_GET     = "/retrieveCargCsclPrgsInfo";
        public const string WS_API_UNIPAAS_CONTAINER_LIST_GET = "/retrieveCntrQryBrkd";
        public const string WS_API_UNIPAAS_SHED_INFO_GET      = "/retrieveShedInfo";
        public const string WS_API_COMMAND_CHECKIPNATION      = "/CheckIPNation";

        // 로지스랩 API
        public const string WS_CP_API_COMMAND_GETACCTREALNAME           = "/GetAcctRealName";
        public const string WS_CP_API_COMMAND_CHKCENTEREXISTS           = "/ChkCenterExists";
        public const string WS_CP_API_COMMAND_INSCENTER                 = "/InsCenter";
        public const string WS_CP_API_COMMAND_UPDCENTER                 = "/UpdCenter";
        public const string WS_CP_API_CENTERORDER_CHK                   = "/GetCenterOrderChk";
        public const string WS_CP_API_CENTERORDER_INS                   = "/InsOrderTMS";
        public const string WS_CP_API_CENTERORDER_UPD_DIRECT            = "/UpdOrderDirect";
        public const string WS_CP_API_CENTERORDER_UPD_DIRECT_COMPANY    = "/UpdOrderDirectCompany";
        public const string WS_CP_API_CARD_AGREE_INFO_GET               = "/GetCardAgreeInfo";
        public const string WS_CP_API_CARD_AGREE_INFO_UPD               = "/UpdCardAgreeInfo";
        public const string WS_CP_API_CENTER_SEND_FEED_GET              = "/GetCenterSendFeeD";
        public const string WS_CP_API_COMMAND_SENDGOOGLEDATAMESSAGE     = "/SendGoogleDataMessage";
        public const string WS_CP_API_COMMAND_GETAPPROVEHOMETAXV2       = "/GetApproveHomeTaxV2";
        public const string WS_CP_API_COMMAND_GETAPPROVEHOMETAXITEMLIST = "/GetApproveHometaxItemList";

        public const string WS_DAPI_DEFAULT_CONTENTTYPE = "application/json; charset=utf-8"; //Default content type
        public const string WS_DAPI_CONTACT_INFO        = "/contactinfo";

        // 콜매니저
        public const string WS_DAPI_CM_SITE_CODE       = "logiman";
        public const string WS_DAPI_CM_AUTHINFO        = "/api/site/authinfo";
        public const string WS_DAPI_CM_DELETE_AUTHINFO = "/api/site/delete_authinfo";
        public const string WS_DAPI_CM_OUTBOUNDCALL    = "/api/site/outboundcall";
        public const string WS_DAPI_CM_PHONENOINFO     = "/api/site/phonenoinfo";

        //알림톡
        public static string M_GTM_ID = "GTM-MHF74B4";

        // 텍스빌 계산서
        public const string TAX_PREFIX_KAKAO        = "62";
        public const string TAX_PREFIX_MUFFIN       = "63";
        public const string TAX_PREFIX_TMS_PURCHASE = "64";
        public const string TAX_PREFIX_TMS_SALE     = "65";
        public const string TAX_BROK_CORP_NO        = "1908700380";
        public const string TAX_BROK_CORP_NM        = "(주)로지스랩";
        public const string TAX_BROK_CEO            = "김인석";
        public const string TAX_BROK_ADDR           = "서울시 강남구 남부순환로 2621 디앤오강남빌딩 13층";
        public const string TAX_BROK_TEL            = "15229766";
        public const string TAX_BROK_BUSS_CONS      = "서비스";
        public const string TAX_BROK_BUSS_TYPE      = "운송주선";

        // 일반변수
        public static string LOGIN_PAGE               = "/SSO/Login/Login.aspx";
        public static string MAIN_PAGE_1              = "/Index";
        public static string MAIN_PAGE_2              = "/Index.aspx";
        public static string MAIN_PAGE_3              = "/SSO/Board/BoardNoticeMain";
        public static string MAIN_PAGE_4              = "/";
        public static string PAGENAVIGATION_LIST      = "20";
        public static string GRID_PAGENAVIGATION_LIST = "3000";
        public static string[] SECRETFIELD            = { "card_no:8", "expire_date:2", "batch_key:8" }; // 로그에 남기지 않을 REQUEST 필드명(:Hidden 길이)

        // 로지맨앱 변수
        public static string APP_SITE_TITLE  = ":::: 로지맨앱 ::::";
        public const  string APP_COOKIE_NAME = "LOGIMAN_APP";
        public static char   APP_DELIMETER   = (char)2;
        public static string APP_LOGIN_PAGE  = "/APP/Login/Login";
        public static string APP_PAGE_1      = "/APP/Main/Main";

        public static readonly string DEFAULT_FILE_LOGPATH      = HttpContext.Current.Request.ServerVariables["APPL_PHYSICAL_PATH"] + "..\\logfiles\\TMSLog\\";
        public static readonly string DEFAULT_FILE_INFO_LOGPATH = HttpContext.Current.Request.ServerVariables["APPL_PHYSICAL_PATH"] + "..\\logfiles\\TMSInfoLog\\";

        public const string M_PAGE_CACHE_CARTON = "CARTON";
        public const string M_PAGE_CACHE_CARTON_APP = "CARTON_APP";
        public static string M_PAGE_CACHE_CARTON_JSON = HttpContext.Current.Request.PhysicalApplicationPath + @"\Lib\CarTon.json";

        public const string M_PAGE_CACHE_ADDRLIST = "ADDRLIST";
        public const string M_PAGE_CACHE_ADDRLIST_APP = "ADDRLIST_APP";
        public static string M_PAGE_CACHE_ADDRLIST_JSON = HttpContext.Current.Request.PhysicalApplicationPath + @"\Lib\AddrList.json";


        public const string M_PAGE_CACHE_ITEM_GROUP_LIST = "ITEMGROUPLIST";
        public static string M_PAGE_CACHE_ITEM_GROUP_LIST_JSON = HttpContext.Current.Request.PhysicalApplicationPath + @"\Lib\ItemGroupList.json";
        public const string M_PAGE_CACHE_ITEM_LIST = "ITEMLIST";
        public static string M_PAGE_CACHE_ITEM_LIST_JSON = HttpContext.Current.Request.PhysicalApplicationPath + @"\Lib\ItemList.json";
        public const string M_PAGE_CACHE_ITEM_CENTER_LIST = "ITEMCENTERLIST";
        public static string M_PAGE_CACHE_ITEM_CENTER_LIST_JSON = HttpContext.Current.Request.PhysicalApplicationPath + @"\Lib\ItemCenterList.json";
        public const string M_PAGE_CACHE_ITEM_ADMIN_LIST = "ITEMADMINLIST";
        public static string M_PAGE_CACHE_ITEM_ADMIN_LIST_JSON = HttpContext.Current.Request.PhysicalApplicationPath + @"\Lib\ItemAdminList.json";

        public static string M_PAGE_CENTER_PRIVATE_INFO_JSON = HttpContext.Current.Request.PhysicalApplicationPath + @"\Lib\CenterPrivateInfo.json";

        //카고패스
        public static string M_CARGOPASS_CARTON_JSON = HttpContext.Current.Request.PhysicalApplicationPath + @"\Lib\CargopassCarTon.json";
        public static string M_CARGOPASS_CARTRUCK_JSON = HttpContext.Current.Request.PhysicalApplicationPath + @"\Lib\CargopassCarTruck.json";

        #region Custom Message For HttpStatusCode
        public const int    HTTP_STATUS_CODE_999         = 999;
        public const string HTTP_STATUS_CODE_999_MESSAGE = "예기치 않은 오류가 발생하였습니다.";
        public const string COMMON_EXCEPTION_MESSAGE     = "예기치 않은 오류가 발생하였습니다.";

        public const int    HTTP_STATUS_CODE_401         = 401;
        public const string HTTP_STATUS_CODE_401_MESSAGE = "You do not have permission. Please access the correct path.";

        public const int    HTTP_STATUS_CODE_403         = 403;
        public const string HTTP_STATUS_CODE_403_MESSAGE = "An exception error occurred.";

        public const int    HTTP_STATUS_CODE_404         = 404;
        public const string HTTP_STATUS_CODE_404_MESSAGE = "Page Not Found Error(The wrong approach.)";

        public const int    HTTP_STATUS_CODE_500         = 500;
        public const string HTTP_STATUS_CODE_500_MESSAGE = "An error occurred while processing.";

        public const int    HTTP_STATUS_CODE_503         = 503;
        public const string HTTP_STATUS_CODE_503_MESSAGE = "HTTP Specific error occurred.";
        #endregion

        #region Custom Message For DAS
        public const int    DAS_SUCCESS_CODE                    = 0;
        public const int    DAS_RET_VAL_CODE                    = 999;
        public const string DAS_ERR_MESSAGE                     = "DAS error occurred.";
        public const int    DAS_DATA_ACCESS_SERVICE_ERR_CODE    = 998;
        public const string DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE = "An unexpected error occurred during accessing data.";
        #endregion
    }
}