using CommonLibrary.CommonModel;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using CommonLibrary.Utils;
using log4net;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

//===============================================================
// FileName       : SiteGlobal.cs
// Description    : Site 공통 모듈 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonModule
{
    public static class SiteGlobal
    {
        public static string AES2_ENC_KEY_VALUE           = string.Empty;
        public static string AES2_ENC_IV_VALUE            = string.Empty;
        public static string AES2_ENC_KEY_CARGOPASS_VALUE = string.Empty;
        public static string AES2_ENC_IV_CARGOPASS_VALUE  = string.Empty;

        // 서버 환경 변수
        public static string APP_HOST_IP                   = string.Empty;
        public static string HOST_DAS                      = string.Empty;
        public static string HOST_DAS_NOLOG                = string.Empty;
        public static string HOST_DAS_TAX                  = string.Empty;
        public static string HOST_DAS_STAT                 = string.Empty;
        public static string DOMAINNAME                    = string.Empty;
        public static string MAIL_SERVER                   = string.Empty;
        public static int    MAIL_PORTNO                   = 25;
        public static string SERVICE_TYPE_NAME             = string.Empty;
        public static string GA_TMS_ID                     = string.Empty;
        public static string GTM_TMS_CODE                  = string.Empty;
        public static string WS_LOGISQUARE_API_HEADER_AUTH = string.Empty;
        public static string LOGIMAN_ADDR_LAT              = "37.491007";
        public static string LOGIMAN_ADDR_LNG              = "127.030254";
        public static string KAKAO_APP_KEY                 = "b62b7e77ba0236e506f24ba4dbca6ff6"; // [logimanDebug] 카카오 키 설정
        public static bool   B_LOG_WRITE                   = false;

        // 도메인 변수
        public static string WS_LQ_DOMAIN                = string.Empty;
        public static string WS_LQ_DOMAIN_NAME           = string.Empty;
        public static string WS_DOMAIN                   = string.Empty;
        public static string WS_REAL_DOMAIN              = "https://api.logislab.com/API";
        public static string WS_DOMAIN_NAME              = string.Empty;
        public static string PAAS_DOMAIN                 = string.Empty;
        public static string FILE_DOMAIN                 = string.Empty;
        public static string FILE_SERVER_ROOT            = string.Empty;
        public static string TMS_DOMAIN                  = string.Empty;
        public static string SMS_DOMAIN                  = string.Empty;
        public static string WS_DAPI_DOMAIN              = string.Empty;
        public static string WS_DAPI_REAL_DOMAIN         = "https://dapi.logislab.com/zip";
        public static string WS_DAPI_CALLMGR_REAL_DOMAIN = "https://dapi.logislab.com/callmgr";
        public static string WS_CALLMANAGER_QRCODE_IMAGE = string.Empty;

        //메뉴 롤
        public static string CLIENT_DOMESTIC_MENU_ROLE_NO = string.Empty;
        public static string CLIENT_INOUT_MENU_ROLE_NO    = string.Empty;

        //GA
        public static string GA_CODE_WEB = string.Empty;
        public static string GA_CODE_APP = string.Empty;
        public static string GA_CODE_SMS = string.Empty;

        //시스템 점검
        public static bool SERVICE_STOP_FLAG = false;

        //유피에스에스씨에스코리아(주) 내역서 ClientCode
        public static string UPS_CLIENT_CODE = string.Empty;

        // KCP 모바일 인증 변수
        public static string M_KCP_AUTH_SITE_CD    = string.Empty; //[logimanDebug]
        public static string M_KCP_AUTH_WEB_SITEID = string.Empty; //[logimanDebug]
        public static string M_KCP_AUTH_ENC_KEY    = string.Empty; //[logimanDebug]
        public static string M_KCP_AUTH_RET_URL    = string.Empty;
        public static string M_KCP_AUTH_GW_URL     = string.Empty;

        //카고패스
        public static string CARGOPASS_DOMAIN   = string.Empty;
        public static string CARGOPASS_INS_URL  = string.Empty;
        public static string CARGOPASS_LIST_URL = string.Empty;
        public static string CARGOPASS_TEST_URL = string.Empty;

        //구글 QR코드 생성 API 변수
        public static string GOOGLE_SECRET_KEY                = "NRXW63LNNBQXE2LFOJXGS3THEBTDAX2A";     //[logimanDebug]
        public static string GOOGLE_ISSUER                    = "logiman";                              //[logimanDebug]
        private const string WS_API_COMMAND_GOOGLE_OTP_AUTH   = "/Google/OTP_Auth";
        private const string WS_API_COMMAND_GOOGLE_OTP_KEYGEN = "/Google/OTP_KeyGen";

        static SiteGlobal()
        {
            DOMAINNAME                   = CommonUtils.Utils.GetRegistryValue(CommonConstant.WEBSERVICE_DOMAIN_NAME).ToString();
            AES2_ENC_KEY_VALUE           = CommonUtils.Utils.GetRegistryValue(CommonConstant.AES_ENC_KEY_NAME).ToString();
            AES2_ENC_IV_VALUE            = CommonUtils.Utils.GetRegistryValue(CommonConstant.AES_ENC_IV_NAME).ToString();
            AES2_ENC_KEY_CARGOPASS_VALUE = CommonUtils.Utils.GetRegistryValue(CommonConstant.AES_ENC_KEY_CARGOPASS_NAME).ToString();
            AES2_ENC_IV_CARGOPASS_VALUE  = CommonUtils.Utils.GetRegistryValue(CommonConstant.AES_ENC_IV_CARGOPASS_NAME).ToString();

            // 서비스 환경에 따른 변수값 선언
            switch (DOMAINNAME.ToLower())
            {
                case CommonConstant.LOCALDEV_DOMAIN:
                    APP_HOST_IP                   = "211.253.25.147";
                    HOST_DAS                      = APP_HOST_IP + ":41951";
                    HOST_DAS_NOLOG                = APP_HOST_IP + ":41952";
                    HOST_DAS_STAT                 = APP_HOST_IP + ":41953";
                    HOST_DAS_TAX                  = APP_HOST_IP + ":41970";
                    MAIL_SERVER                   = "211.253.25.147";
                    MAIL_PORTNO                   = 25;
                    PAAS_DOMAIN                   = "http://localpaas.cargomanager.co.kr";
                    WS_LQ_DOMAIN                  = "http://devapi.logisquare.co.kr/API";
                    WS_LQ_DOMAIN_NAME             = "devapi.logisquare.co.kr";
                    WS_LOGISQUARE_API_HEADER_AUTH = "LLT MjA5OTEyMzE6ZGV2YXBpLmxvZmlzcXVhcmUuY28ua3I=";
                    WS_DOMAIN                     = "http://devapi.logislab.com/API";
                    WS_DOMAIN_NAME                = "devapi.logislab.com";
                    SERVICE_TYPE_NAME             = "개발자PC";
                    FILE_DOMAIN                   = "http://logimanfilelocal.logisquare.co.kr";
                    FILE_SERVER_ROOT              = @"D:\LocalDevEnv\logimanfile.logisquare.co.kr";
                    GA_TMS_ID                     = "";
                    GTM_TMS_CODE                  = "";
                    CLIENT_DOMESTIC_MENU_ROLE_NO  = "2";
                    CLIENT_INOUT_MENU_ROLE_NO     = "5";
                    TMS_DOMAIN                    = "http://locallogiman.logisquare.co.kr/";
                    SMS_DOMAIN                    = "http://locallogiman.logisquare.co.kr/";
                    B_LOG_WRITE                   = true;
                    GA_CODE_WEB                   = string.Empty;
                    GA_CODE_APP                   = string.Empty;
                    GA_CODE_SMS                   = string.Empty;
                    UPS_CLIENT_CODE               = "363";
                    M_KCP_AUTH_SITE_CD            = "S61";
                    M_KCP_AUTH_WEB_SITEID         = string.Empty;
                    M_KCP_AUTH_ENC_KEY            = "E66DCEB95BFBD45DF";
                    M_KCP_AUTH_RET_URL            = "http://" + CommonConstant.LOCALDEV_DOMAIN + "/KCP/SmartCertRes";
                    M_KCP_AUTH_GW_URL             = "https://testcert.kcp.co.kr/kcp_cert/cert_view.jsp";
                    CARGOPASS_DOMAIN              = "http://localcargopass.cargomanager.co.kr";
                    CARGOPASS_INS_URL             = CARGOPASS_DOMAIN + "/NETWORK/Order/ExtOrderIns";
                    CARGOPASS_LIST_URL            = CARGOPASS_DOMAIN + "/NETWORK/Order/ExtOrderList";
                    CARGOPASS_TEST_URL            = CARGOPASS_DOMAIN + "/CenterTestPage";
                    WS_CALLMANAGER_QRCODE_IMAGE   = TMS_DOMAIN + "images/callmanager/CallManager_Android_Stage.png";
                    break;
                case CommonConstant.DEV_DOMAIN:
                    APP_HOST_IP                   = "127.0.0.1";
                    HOST_DAS                      = APP_HOST_IP + ":41951";
                    HOST_DAS_NOLOG                = APP_HOST_IP + ":41952";
                    HOST_DAS_STAT                 = APP_HOST_IP + ":41953";
                    HOST_DAS_TAX                  = APP_HOST_IP + ":41970";
                    MAIL_SERVER                   = "127.0.0.1";
                    MAIL_PORTNO                   = 25;
                    PAAS_DOMAIN                   = "http://devpaas.cargomanager.co.kr";
                    WS_LQ_DOMAIN                  = "http://devapi.logisquare.co.kr/API";
                    WS_LQ_DOMAIN_NAME             = "devapi.logisquare.co.kr";
                    WS_LOGISQUARE_API_HEADER_AUTH = "LLT MjA5OTEyMzE6ZGV2YXBpLmxvZmlzcXVhcmUuY28ua3I=";
                    WS_DOMAIN                     = "http://devapi.logislab.com/API";
                    WS_DOMAIN_NAME                = "devapi.logislab.com";
                    SERVICE_TYPE_NAME             = "개발서버";
                    FILE_DOMAIN                   = "https://logimanfiledev.logisquare.co.kr";
                    FILE_SERVER_ROOT              = @"D:\WebSite10\logimanfile.logisquare.co.kr";
                    GA_TMS_ID                     = "";
                    GTM_TMS_CODE                  = "";
                    CLIENT_DOMESTIC_MENU_ROLE_NO  = "2";
                    CLIENT_INOUT_MENU_ROLE_NO     = "5";
                    TMS_DOMAIN                    = "http://devlogiman.logisquare.co.kr/";
                    SMS_DOMAIN                    = "http://devlogiman.logisquare.co.kr/";
                    B_LOG_WRITE                   = true;
                    GA_CODE_WEB                   = string.Empty;
                    GA_CODE_APP                   = string.Empty;
                    GA_CODE_SMS                   = string.Empty;
                    UPS_CLIENT_CODE               = "363";
                    M_KCP_AUTH_SITE_CD            = "S61";
                    M_KCP_AUTH_WEB_SITEID         = string.Empty;
                    M_KCP_AUTH_ENC_KEY            = "E66DCEB95BFBD45DF";
                    M_KCP_AUTH_RET_URL            = "http://" + CommonConstant.DEV_DOMAIN + "/KCP/SmartCertRes";
                    M_KCP_AUTH_GW_URL             = "https://testcert.kcp.co.kr/kcp_cert/cert_view.jsp";
                    CARGOPASS_DOMAIN              = "http://devcargopass.cargomanager.co.kr";
                    CARGOPASS_INS_URL             = CARGOPASS_DOMAIN + "/NETWORK/Order/ExtOrderIns";
                    CARGOPASS_LIST_URL            = CARGOPASS_DOMAIN + "/NETWORK/Order/ExtOrderList";
                    CARGOPASS_TEST_URL            = CARGOPASS_DOMAIN + "/CenterTestPage";
                    WS_CALLMANAGER_QRCODE_IMAGE   = TMS_DOMAIN + "images/callmanager/CallManager_Android_Stage.png";
                    break;
                case CommonConstant.TEST_DOMAIN:
                    APP_HOST_IP                   = "127.0.0.1";
                    HOST_DAS                      = APP_HOST_IP + ":41951";
                    HOST_DAS_NOLOG                = APP_HOST_IP + ":41952";
                    HOST_DAS_STAT                 = APP_HOST_IP + ":41953";
                    HOST_DAS_TAX                  = APP_HOST_IP + ":41970";
                    MAIL_SERVER                   = "127.0.0.1";
                    MAIL_PORTNO                   = 25;
                    PAAS_DOMAIN                   = "http://testpaas.cargomanager.co.kr";
                    WS_LQ_DOMAIN                  = "https://testapi.logisquare.co.kr/API";
                    WS_LQ_DOMAIN_NAME             = "testapi.logisquare.co.kr";
                    WS_LOGISQUARE_API_HEADER_AUTH = "LLT MjA5OTEyMzE6dGVzdGFwaS5sb2dpc3F1YXJlLmNvLmty";
                    WS_DOMAIN                     = "https://testapi.logislab.com/API";
                    WS_DOMAIN_NAME                = "testapi.logislab.com";
                    SERVICE_TYPE_NAME             = "데모서버";
                    FILE_DOMAIN                   = "https://logimanfiletest.logisquare.co.kr";
                    FILE_SERVER_ROOT              = @"D:\WebSite10\logimanfile.logisquare.co.kr";
                    GA_TMS_ID                     = "";
                    GTM_TMS_CODE                  = "";
                    CLIENT_DOMESTIC_MENU_ROLE_NO  = "2";
                    CLIENT_INOUT_MENU_ROLE_NO     = "16";
                    TMS_DOMAIN                    = "https://testlogiman.logisquare.co.kr/";
                    SMS_DOMAIN                    = "https://testlogiman.logisquare.co.kr/";
                    B_LOG_WRITE                   = true;
                    GA_CODE_WEB                   = string.Empty;
                    GA_CODE_APP                   = string.Empty;
                    GA_CODE_SMS                   = string.Empty;
                    UPS_CLIENT_CODE               = "22191";
                    M_KCP_AUTH_SITE_CD            = "S61";
                    M_KCP_AUTH_WEB_SITEID         = string.Empty;
                    M_KCP_AUTH_ENC_KEY            = "E66DCEB95BFBD45DF";
                    M_KCP_AUTH_RET_URL            = "https://" + CommonConstant.TEST_DOMAIN + "/KCP/SmartCertRes";
                    M_KCP_AUTH_GW_URL             = "https://testcert.kcp.co.kr/kcp_cert/cert_view.jsp";
                    CARGOPASS_DOMAIN              = "https://testcargopass.cargomanager.co.kr";
                    CARGOPASS_INS_URL             = CARGOPASS_DOMAIN + "/NETWORK/Order/ExtOrderIns";
                    CARGOPASS_LIST_URL            = CARGOPASS_DOMAIN + "/NETWORK/Order/ExtOrderList";
                    CARGOPASS_TEST_URL            = CARGOPASS_DOMAIN + "/CenterTestPage";
                    WS_CALLMANAGER_QRCODE_IMAGE   = TMS_DOMAIN + "images/callmanager/CallManager_Android_Stage.png";
                    break;
                case CommonConstant.REAL_DOMAIN:
                    APP_HOST_IP                   = "x.x.x.x";
                    HOST_DAS                      = APP_HOST_IP + ":41951";
                    HOST_DAS_NOLOG                = APP_HOST_IP + ":41952";
                    HOST_DAS_STAT                 = APP_HOST_IP + ":41953";
                    HOST_DAS_TAX                  = APP_HOST_IP + ":41970";
                    MAIL_SERVER                   = "127.0.0.1";
                    MAIL_PORTNO                   = 25;
                    PAAS_DOMAIN                   = "https://paas.cargomanager.co.kr";
                    WS_LQ_DOMAIN                  = "https://api.logisquare.co.kr/API";
                    WS_LQ_DOMAIN_NAME             = "api.logisquare.co.kr";
                    WS_LOGISQUARE_API_HEADER_AUTH = "LLT MjA5OTEyMzE6YXBpLmxvZ2lzcXVhcmUuY28ua3I=";
                    WS_DOMAIN                     = "https://api.logislab.com/API";
                    WS_DOMAIN_NAME                = "api.logislab.com";
                    SERVICE_TYPE_NAME             = "실서버";
                    FILE_DOMAIN                   = "https://logimanfile.logisquare.co.kr";
                    FILE_SERVER_ROOT              = @"\\x.x.x.x\WebSite\logimanfile.logisquare.co.kr";
                    GA_TMS_ID                     = "";
                    GTM_TMS_CODE                  = "";
                    CLIENT_DOMESTIC_MENU_ROLE_NO  = "2";
                    CLIENT_INOUT_MENU_ROLE_NO     = "16";
                    TMS_DOMAIN                    = "https://logiman.logisquare.co.kr/";
                    SMS_DOMAIN                    = "https://logiman.logisquare.co.kr/";
                    B_LOG_WRITE                   = false;
                    GA_CODE_WEB                   = "G-WDQHKC5G8X";
                    GA_CODE_APP                   = "G-DLJTJXW2Q5";
                    GA_CODE_SMS                   = "G-JG3NVXZRBZ";
                    UPS_CLIENT_CODE               = "1423";
                    M_KCP_AUTH_SITE_CD            = "AJK";
                    M_KCP_AUTH_WEB_SITEID         = "J2308010";
                    M_KCP_AUTH_ENC_KEY            = "14f46bbf0e47bcb21304dde6125527056ac1ad9f8ab25";
                    M_KCP_AUTH_RET_URL            = "https://" + CommonConstant.REAL_DOMAIN + "/KCP/SmartCertRes";
                    M_KCP_AUTH_GW_URL             = "https://cert.kcp.co.kr/kcp_cert/cert_view.jsp";
                    CARGOPASS_DOMAIN              = "https://cargopass.cargomanager.co.kr";
                    CARGOPASS_INS_URL             = CARGOPASS_DOMAIN + "/NETWORK/Order/ExtOrderIns";
                    CARGOPASS_LIST_URL            = CARGOPASS_DOMAIN + "/NETWORK/Order/ExtOrderList";
                    CARGOPASS_TEST_URL            = CARGOPASS_DOMAIN + "/CenterTestPage";
                    WS_CALLMANAGER_QRCODE_IMAGE   = TMS_DOMAIN + "images/callmanager/CallManager_Android_Live.png";
                    break;
            }
        }

        /// <summary>
        /// Filtering GET/POST parameter
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="blnHtmlDecode">Option to set whether Html-decoding</param>
        /// <param name="blnFilter">Option to set whether filtering SQL injection</param>
        /// <return>Filtered value</return>
        public static string GetValue(string strVal, bool blnHtmlDecode = false, bool blnFilter = true)
        {
            string lo_strRet = string.Empty;
            //string lo_strRet = null;

            try
            {
                if (!string.IsNullOrEmpty(strVal))
                {
                    if (blnHtmlDecode)
                    {
                        strVal = HttpUtility.HtmlDecode(strVal);
                    }

                    if (blnFilter)
                    {
                        strVal = strVal.Replace("'", "");
                        strVal = strVal.Replace("\"", "");
                        strVal = strVal.Replace("\\", "");
                        strVal = strVal.Replace("#", "");
                        strVal = strVal.Replace("||", "");

                        strVal = strVal.Replace(">", "");
                        strVal = strVal.Replace("--", "");
                        strVal = strVal.Replace("/*", "");
                        strVal = strVal.Replace("*/", "");
                        strVal = strVal.Replace("xp_", "");
                    }

                    lo_strRet = strVal;
                }
            }
            catch (Exception)
            {
                return lo_strRet;
            }

            return lo_strRet;
        }

        public static string GetRequestForm(string name, bool isReplace=true)
        {
            string[] lo_arrVars;
            int      lo_intCount;

            foreach (string var in HttpContext.Current.Request.QueryString)
            {
                if (!string.IsNullOrWhiteSpace(var))
                {
                    lo_arrVars  = var.Split('$');
                    lo_intCount = lo_arrVars.Length;
                    if (lo_arrVars[lo_intCount - 1].Equals(name))
                    {
                        return isReplace ? GetValue(HttpContext.Current.Request.QueryString[var]) : HttpContext.Current.Request.QueryString[var];
                    }
                }
            }

            foreach (string var in HttpContext.Current.Request.Form)
            {
                if (!string.IsNullOrWhiteSpace(var))
                {
                    lo_arrVars  = var.Split('$');
                    lo_intCount = lo_arrVars.Length;
                    if (lo_arrVars[lo_intCount - 1].Equals(name))
                    {
                        return isReplace ? GetValue(HttpContext.Current.Request.Form[var]) : HttpContext.Current.Request.Form[var];
                    }
                }
            }

            return "";
        }

        public static string GetAllRequestForm()
        {
            string[] lo_arrVars;
            string   lo_strAllVars = string.Empty;

            foreach (string var in HttpContext.Current.Request.QueryString)
            {
                if (!string.IsNullOrWhiteSpace(var))
                {
                    if (var.StartsWith("__"))
                    {
                        continue;
                    }

                    lo_arrVars = var.Split('$');

                    if (string.IsNullOrWhiteSpace(lo_strAllVars))
                    {
                        lo_strAllVars += "?";
                    }
                    else
                    {
                        lo_strAllVars += "&";
                    }

                    if (!string.IsNullOrWhiteSpace(GetValue(HttpContext.Current.Request.QueryString[var])))
                    {
                        lo_strAllVars += lo_arrVars[lo_arrVars.Length - 1] + "=" + GetValue(HttpContext.Current.Request.QueryString[var]);
                    }
                }
            }

            foreach (string var in HttpContext.Current.Request.Form)
            {
                if (!string.IsNullOrWhiteSpace(var))
                {
                    if (var.StartsWith("__"))
                    {
                        continue;
                    }

                    lo_arrVars = var.Split('$');

                    if (string.IsNullOrWhiteSpace(lo_strAllVars))
                    {
                        lo_strAllVars += "?";
                    }
                    else
                    {
                        lo_strAllVars += "&";
                    }

                    if (!string.IsNullOrWhiteSpace(GetValue(HttpContext.Current.Request.Form[var])))
                    {
                        lo_strAllVars += lo_arrVars[lo_arrVars.Length - 1] + "=" + GetValue(HttpContext.Current.Request.Form[var]);
                    }
                }
            }

            return lo_strAllVars;
        }

        public static string GetAllRequestLog()
        {
            string[] lo_arrVars;

            Dictionary<String, Object> lo_objDic            = new Dictionary<string, object>();
            JavaScriptSerializer       lo_objJsonSerializer = new JavaScriptSerializer();

            foreach (string var in HttpContext.Current.Request.QueryString)
            {
                if (!string.IsNullOrWhiteSpace(var))
                {
                    if (var.StartsWith("__") || var.StartsWith("hid_LAYER_"))
                    {
                        continue;
                    }

                    lo_arrVars = var.Split('$');

                    if (!string.IsNullOrWhiteSpace(GetValue(HttpContext.Current.Request.QueryString[var])))
                    {
                        string lo_strSecretData = ConvSecreFiledData(lo_arrVars[lo_arrVars.Length - 1], GetValue(HttpContext.Current.Request.QueryString[var]));
                        lo_objDic.Add(lo_arrVars[lo_arrVars.Length - 1], lo_strSecretData);
                    }
                }
            }

            foreach (string var in HttpContext.Current.Request.Form)
            {
                if (!string.IsNullOrWhiteSpace(var))
                {
                    if (var.StartsWith("__") || var.StartsWith("hid_LAYER_"))
                    {
                        continue;
                    }

                    lo_arrVars = var.Split('$');

                    if (!string.IsNullOrWhiteSpace(GetValue(HttpContext.Current.Request.Form[var])))
                    {
                        string lo_strSecretData = ConvSecreFiledData(lo_arrVars[lo_arrVars.Length - 1], GetValue(HttpContext.Current.Request.Form[var]));
                        if (!lo_objDic.ContainsKey(lo_arrVars[lo_arrVars.Length - 1]))
                        {
                            lo_objDic.Add(lo_arrVars[lo_arrVars.Length - 1], lo_strSecretData);
                        }
                    }
                }
            }

            return lo_objJsonSerializer.Serialize(lo_objDic);
        }

        public static string ConvSecreFiledData(string strKey, string strValue)
        {
            string lo_strSecretData = string.Empty;
            bool   lo_bSecretFlag   = false;
            int    lo_intSecretLen  = 0;

            try
            {
                lo_bSecretFlag = false;
                for (int nLoop = 0; nLoop < CommonConstant.SECRETFIELD.Length; nLoop++)
                {
                    if (strKey.ToLower().Trim().Equals(CommonConstant.SECRETFIELD[nLoop].Split(':')[0].Trim()))
                    {
                        lo_bSecretFlag  = true;
                        lo_intSecretLen = Convert.ToInt32(CommonConstant.SECRETFIELD[nLoop].Split(':')[1]);
                        break;
                    }
                }

                if (lo_bSecretFlag)
                {
                    int lo_intShowLen = strValue.Length - lo_intSecretLen;
                    if (lo_intShowLen < 0)
                    {
                        lo_intShowLen = 0;
                    }

                    lo_strSecretData = strValue.Substring(0, lo_intShowLen);
                    lo_strSecretData = lo_strSecretData.PadRight(strValue.Length, '*');
                }
                else
                {
                    lo_strSecretData = strValue;
                }
            }
            catch
            {
                lo_strSecretData = strValue;
            }

            return lo_strSecretData;
        }

        #region DataTable to JSON
        public static string DataTableToRestJson(int intRetCode, string strErrMsg, DataTable objDT, int intTotalCount = 0)
        {
            string                  lo_strJson        = string.Empty;
            RestDataTableToJsonRslt lo_objJson        = null;
            JavaScriptSerializer    lo_objJSerializer = null;

            try
            {
                lo_objJson = new RestDataTableToJsonRslt
                {
                    RetCode    = intRetCode,
                    ErrMsg     = strErrMsg,
                    ListCount  = objDT.Rows.Count,
                    TotalCount = intTotalCount,
                    List       = DataTableToList(objDT)
                };

                //string lo_strDT = DataTableToJson(objDT);

                lo_objJSerializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
                lo_strJson        = lo_objJSerializer.Serialize(lo_objJson);
            }
            finally
            {
                lo_objJSerializer = null;
            }

            return lo_strJson;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Name           : DataTableToJSON
        /// Discription    : Record set을 JSON으로 반환하는 메서드
        /// <param name="objDataTable">JSON으로 반환할 데이터테이블</param>
        /// </summary>
        ///----------------------------------------------------------------------
        public static string DataTableToJson(DataTable objDataTable)
        {
            string               lo_strJsonData    = string.Empty;
            JavaScriptSerializer lo_objJSerializer = null;
            try
            {
                lo_objJSerializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
                lo_strJsonData    = lo_objJSerializer.Serialize(DataTableToList(objDataTable));
            }
            finally
            {
                lo_objJSerializer = null;
            }
            return lo_strJsonData;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// DataTableToList()
        /// <param name="objDataTable">JSON으로 반환할 데이터테이블</param>
        /// </summary>
        ///----------------------------------------------------------------------
        private static List<Hashtable> DataTableToList(DataTable objDataTable)
        {
            List<Hashtable> lo_objList = null;

            lo_objList = new List<Hashtable>();

            foreach (DataRow lo_objRow in objDataTable.Rows)
            {
                lo_objList.Add(DataRowToHashTable(objDataTable.Columns, lo_objRow));
            }

            return lo_objList;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// DataRowToHashTable()
        /// <param name="objCols">Data Column</param>
        /// <param name="objRow">Data Row</param>
        /// </summary>
        ///----------------------------------------------------------------------
        private static Hashtable DataRowToHashTable(DataColumnCollection objCols, DataRow objRow)
        {
            Hashtable lo_objHashTable = null;

            lo_objHashTable = new Hashtable();
            foreach (DataColumn lo_objCol in objCols)
            {
                lo_objHashTable.Add(lo_objCol.ColumnName, objRow[lo_objCol.ColumnName]);
            }

            return lo_objHashTable;
        }
        #endregion

        public static string GetLogisquareAPIHeaderAuth(string strTestFlag = "N")
        {
            int    lo_intRetVal        = 0;
            string lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            string lo_strYMD           = DateTime.Now.ToString("yyyyMMdd");

            try
            {
                if (strTestFlag.EndsWith("Y"))
                {
                    lo_strAuthirization = WS_LOGISQUARE_API_HEADER_AUTH;
                }
                else
                {
                    lo_strAuthirization = "LLT " + Hash.Base64Encode($"{lo_strYMD}:{WS_LQ_DOMAIN_NAME.ToLower()}");
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9911;
                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_strAuthirization;
        }
        
        public static string GetLogislabAPIHeaderAuth()
        {
            int    lo_intRetVal        = 0;
            string lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            string lo_strYMD           = DateTime.Now.ToString("yyyyMMdd");

            try
            {
                lo_strAuthirization = "LLT " + Hash.Base64Encode($"{lo_strYMD}:{WS_DOMAIN_NAME.ToLower()}");
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9991;
                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_strAuthirization;
        }

        public static ResSendSMS CallSMS(int intCenterCode, string strSendNum, string strRcvNum, string strContent)
        {
            int        lo_intRetVal        = 0;
            string     lo_strPostData      = string.Empty;
            string     lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader lo_objHeader        = null;
            HttpAction lo_objHttp          = null;
            ReqSendSMS lo_objRequest       = new ReqSendSMS();
            ResSendSMS lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResSendSMS();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogisquareAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_objRequest.CenterCode = intCenterCode;
                lo_objRequest.Sender     = strSendNum;
                lo_objRequest.SendTo     = strRcvNum;
                lo_objRequest.Message    = strContent;

                lo_strPostData = JsonConvert.SerializeObject(lo_objRequest);

                lo_objHttp = new HttpAction(WS_LQ_DOMAIN + CommonConstant.WS_API_COMMAND_SENDSMS, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"SMS 전송 웹서비스 호출 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResSendSMS>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage     = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        public static ResSMSAuth CallSMSAuth(ReqSMSAuth objRequest)
        {
            int        lo_intRetVal        = 0;
            string     lo_strPostData      = string.Empty;
            string     lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader lo_objHeader        = null;
            HttpAction lo_objHttp          = null;
            ResSMSAuth lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResSMSAuth();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogisquareAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_LQ_DOMAIN + CommonConstant.WS_API_COMMAND_CALLSMSAUTH, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"SMS 인증 웹서비스 호출 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse                   = JsonConvert.DeserializeObject<ResSMSAuth>(lo_objHttp.ResponseData);
                lo_objResponse.Header.ResultCode = 0;
                /*
                [logimandebug] : 임시로 주석처리 함
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
                */

                lo_objResponse.Payload.EncSMSAuthNum = $"{DateTime.Now:yyyy-MM-dd HH:mm:ss}|{lo_objResponse.Payload.receiptNum}|{objRequest.SendTo}";
                lo_objResponse.Payload.EncSMSAuthNum = CommonUtils.Utils.GetEncrypt(lo_objResponse.Payload.EncSMSAuthNum); ;
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode    = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        public static int CheckSMSAuthNum(string strEncSMSAuthNum, string strAuthNum, out string strErrMsg)
        {
            int      lo_intRetVal        = 0;
            string   lo_strDecSMSAuthNum = string.Empty;
            string[] lo_arrDecSMSAuthNum = null;

            strErrMsg = string.Empty;

            try
            {
                lo_strDecSMSAuthNum = CommonUtils.Utils.GetDecrypt(strEncSMSAuthNum);
                lo_arrDecSMSAuthNum = lo_strDecSMSAuthNum.Split('|');

                // 1. 해시체크 : -5 ~ + 10분 내에 시도를 해야 한다.
                TimeSpan pl_dateTimeDifference = Convert.ToDateTime(lo_arrDecSMSAuthNum[0]).AddMinutes(10).Subtract(DateTime.Now);
                double pl_intNumberOfSeconds = pl_dateTimeDifference.TotalSeconds;

                if (pl_intNumberOfSeconds < -300)
                {
                    strErrMsg    = "유효 시간이 지났습니다.(인증 유효 시간 : 10분)";
                    lo_intRetVal = 9002;
                }
                else if (!lo_arrDecSMSAuthNum[1].Equals(strAuthNum))
                {
                    strErrMsg    = "인증번호가 유효하지 않습니다.";
                    lo_intRetVal = 9003;
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9575;
                strErrMsg    = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_intRetVal;
        }

        /// <summary>
        /// 사업자 휴폐업 조회
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResChkCorpNo ChkCorpNo(ReqChkCorpNo objRequest)
        {
            int          lo_intRetVal        = 0;
            string       lo_strPostData      = string.Empty;
            string       lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader   lo_objHeader        = null;
            HttpAction   lo_objHttp          = null;
            ResChkCorpNo lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResChkCorpNo();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogisquareAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_LQ_DOMAIN + CommonConstant.WS_API_COMMAND_CHKCORPNO, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"사업자 휴폐업조회 웹서비스 호출 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResChkCorpNo>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode    = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// SSO - 사업자번호로 운송사 가입확인
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResChkCenterExists ChkCenterExists(ReqChkCenterExists objRequest)
        {
            int lo_intRetVal = 0;
            string lo_strPostData = string.Empty;
            string lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader lo_objHeader = null;
            HttpAction lo_objHttp = null;
            ResChkCenterExists lo_objResponse = null;

            try
            {
                lo_objResponse = new ResChkCenterExists();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_DOMAIN + CommonConstant.WS_CP_API_COMMAND_CHKCENTEREXISTS, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"운송사 가입확인 웹서비스 호출 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResChkCenterExists>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 예금주명 조회
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResGetAcctRealName GetAcctRealName(ReqGetAcctRealName objRequest)
        {
            int                lo_intRetVal        = 0;
            string             lo_strPostData      = string.Empty;
            string             lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader         lo_objHeader        = null;
            HttpAction         lo_objHttp          = null;
            ResGetAcctRealName lo_objResponse      = null;
            string lo_strYMD = DateTime.Now.ToString("yyyyMMdd");

            try
            {
                lo_objResponse = new ResGetAcctRealName();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = "LLT " + Hash.Base64Encode($"{lo_strYMD}:api.logislab.com");
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_REAL_DOMAIN + CommonConstant.WS_CP_API_COMMAND_GETACCTREALNAME, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"예금주명 조회 웹서비스 호출 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResGetAcctRealName>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// SSO - 운송사 등록
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResInsCenter InsCenter(ReqInsCenter objRequest)
        {
            int          lo_intRetVal        = 0;
            string       lo_strPostData      = string.Empty;
            string       lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader   lo_objHeader        = null;
            HttpAction   lo_objHttp          = null;
            ResInsCenter lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResInsCenter();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(SiteGlobal.WS_DOMAIN + CommonConstant.WS_CP_API_COMMAND_INSCENTER, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"운송사 등록 웹서비스 호출 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResInsCenter>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// SSO - 운송사 수정
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResUpdCenter UpdCenter(ReqUpdCenter objRequest)
        {
            int          lo_intRetVal        = 0;
            string       lo_strPostData      = string.Empty;
            string       lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader   lo_objHeader        = null;
            HttpAction   lo_objHttp          = null;
            ResUpdCenter lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResUpdCenter();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_DOMAIN + CommonConstant.WS_CP_API_COMMAND_UPDCENTER, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"운송사 등록 웹서비스 호출 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResUpdCenter>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 카고페이 송금신청
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResInsOrderTMS InsOrderTMS(ReqInsOrderTMS objRequest)
        {
            int            lo_intRetVal        = 0;
            string         lo_strPostData      = string.Empty;
            string         lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader     lo_objHeader        = null;
            HttpAction     lo_objHttp          = null;
            ResInsOrderTMS lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResInsOrderTMS();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_DOMAIN + CommonConstant.WS_CP_API_CENTERORDER_INS, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"카고페이 송금신청 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResInsOrderTMS>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 카고페이 송금 빠른입금(차)으로 변경
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResUpdOrderDirect UpdOrderDirect(ReqUpdOrderDirect objRequest)
        {
            int               lo_intRetVal        = 0;
            string            lo_strPostData      = string.Empty;
            string            lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader        lo_objHeader        = null;
            HttpAction        lo_objHttp          = null;
            ResUpdOrderDirect lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResUpdOrderDirect();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_DOMAIN + CommonConstant.WS_CP_API_CENTERORDER_UPD_DIRECT, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"카고페이 송금 빠른입금(차)으로 변경 신청 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResUpdOrderDirect>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 카고페이 송금 빠른입금(운)으로 변경
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResUpdOrderDirectCompany UpdOrderDirectCompany(ReqUpdOrderDirectCompany objRequest)
        {
            int                      lo_intRetVal        = 0;
            string                   lo_strPostData      = string.Empty;
            string                   lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader               lo_objHeader        = null;
            HttpAction               lo_objHttp          = null;
            ResUpdOrderDirectCompany lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResUpdOrderDirectCompany();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_DOMAIN + CommonConstant.WS_CP_API_CENTERORDER_UPD_DIRECT_COMPANY, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"카고페이 송금 빠른입금(운)으로 변경 신청 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResUpdOrderDirectCompany>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 카고페이 송금 정보
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResGetCenterOrderChk GetCenterOrderChk(ReqGetCenterOrderChk objRequest)
        {
            int                  lo_intRetVal        = 0;
            string               lo_strPostData      = string.Empty;
            string               lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader           lo_objHeader        = null;
            HttpAction           lo_objHttp          = null;
            ResGetCenterOrderChk lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResGetCenterOrderChk();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_DOMAIN + CommonConstant.WS_CP_API_CENTERORDER_CHK, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"카고페이 송금정보 조회 오류 {lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResGetCenterOrderChk>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 카드결제 동의
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResUpdCardAgreeInfo UpdCardAgreeInfo(ReqUpdCardAgreeInfo objRequest)
        {
            int                 lo_intRetVal        = 0;
            string              lo_strPostData      = string.Empty;
            string              lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader          lo_objHeader        = null;
            HttpAction          lo_objHttp          = null;
            ResUpdCardAgreeInfo lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResUpdCardAgreeInfo();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(SiteGlobal.WS_DOMAIN + CommonConstant.WS_CP_API_CARD_AGREE_INFO_UPD, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"카드결제 동의 정보 업데이트 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResUpdCardAgreeInfo>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 카드결제 동의 정보 조회
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResGetCardAgreeInfo GetCardAgreeInfo(ReqGetCardAgreeInfo objRequest)
        {
            int                 lo_intRetVal        = 0;
            string              lo_strPostData      = string.Empty;
            string              lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader          lo_objHeader        = null;
            HttpAction          lo_objHttp          = null;
            ResGetCardAgreeInfo lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResGetCardAgreeInfo();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(SiteGlobal.WS_DOMAIN + CommonConstant.WS_CP_API_CARD_AGREE_INFO_GET, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"카드결제 동의 정보 조회 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResGetCardAgreeInfo>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 송금 수수료 정보 조회
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResGetCenterSendFeeD GetCenterSendFeeD(ReqGetCenterSendFeeD objRequest)
        {
            int                  lo_intRetVal        = 0;
            string               lo_strPostData      = string.Empty;
            string               lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader           lo_objHeader        = null;
            HttpAction           lo_objHttp          = null;
            ResGetCenterSendFeeD lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResGetCenterSendFeeD();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(SiteGlobal.WS_DOMAIN + CommonConstant.WS_CP_API_CENTER_SEND_FEED_GET, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"수수료 정보 조회 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResGetCenterSendFeeD>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /*
        //strLogFileName : 파일명(/AdminLog 밑에 파일명_yyyyMMdd.txt 형식으로 파일 생성
        //strLogPreFix : 파일명 뒤 Prefix [Prefix : [IPAddr , FilePath]] 형식으로 생성
        //strLogData : 로그
        //intRetVal : 에러코드
        //intSendMail : 메일전송 여부(0 : 미전송, 1:전송)
        */
        public static void WriteLog(string strLogFileName, string strLogPreFix, string strLogData, int intRetVal = 9000, int intSendMail = 1)
        {
            try
            {
                GlobalContext.Properties["LogPath"]   = CommonConstant.DEFAULT_FILE_LOGPATH + strLogFileName;       // 웹사이트 경로에서부터 지정
                GlobalContext.Properties["LogPreFix"] = strLogPreFix + " : [" + SiteGlobal.DOMAINNAME + " , " + HttpContext.Current.Request.FilePath + "]";   // web.config에서 이용 가능함.

                log4net.Config.XmlConfigurator.Configure();
                ILog objLog = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod()?.DeclaringType);
                objLog.Info("\r\n\t[RetVal : " + intRetVal + "] " + "[Http Referer : " + HttpContext.Current.Request.ServerVariables["HTTP_REFERER"] + "] " + strLogData);

                strLogData = strLogData + "\nUserHostAddrss : " + HttpContext.Current.Request.UserHostAddress;

                //5000번대 에러는 메일을 보내지 않는다.
                if (intRetVal >= 5000 && intRetVal < 6000)
                {
                    intSendMail = 0;
                }

                if (intSendMail.Equals(1))
                {
                    string strSubject = "[어드민 에러][" + GlobalContext.Properties["LogPreFix"] + "][RetVal : " + intRetVal + "]";

                    foreach (var adminToEmail in CommonConstant.ADMIN_TO_EMAIL)
                    {
                        SendMail(CommonConstant.ADMIN_FROM_EMAIL, adminToEmail, strSubject, "[Http Referer : " + HttpContext.Current.Request.ServerVariables["HTTP_REFERER"] + "] " + strLogData, false, "");
                    }
                }
            }
            catch (Exception)
            {
                // ignored
            }
        }

        public static void WriteInformation(string strLogFileName, string strLogPreFix, string strLogData, bool bWrite=true)
        {
            try
            {
                if (!bWrite) return;

                GlobalContext.Properties["LogPath"]   = CommonConstant.DEFAULT_FILE_INFO_LOGPATH + strLogFileName;       // 웹사이트 경로에서부터 지정
                GlobalContext.Properties["LogPreFix"] = strLogPreFix + " : [" + SiteGlobal.DOMAINNAME + " , " + HttpContext.Current.Request.FilePath + "]";   // web.config에서 이용 가능함.

                log4net.Config.XmlConfigurator.Configure();
                ILog objLog = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod()?.DeclaringType);
                objLog.Info("\r\n\t " + strLogData);

                strLogData = strLogData + "\nUserHostAddrss : " + HttpContext.Current.Request.UserHostAddress;
            }
            catch (Exception)
            {
                // ignored
            }
        }

        public static bool SendMail(string from, string to, string subject, string body, bool isHtml, string strAttach)
        {
            bool lo_result;
            try
            {
                MailMessage message = new MailMessage(from, to, subject, body) { IsBodyHtml = isHtml };

                if (!String.IsNullOrWhiteSpace(strAttach))
                {
                    message.Attachments.Add(new Attachment(strAttach));
                }

                lo_result = SendMail(message);

            }
            catch (Exception lo_ex)
            {
                HttpContext.Current.Response.Write(lo_ex.ToString());
                lo_result = false;

                WriteLog("SiteGlobal", "Exception"
                       , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9002);
            }

            return lo_result;
        }

        public static bool SendMail(MailMessage message)
        {
            bool lo_result = true;

            try
            {
                SmtpClient client = new SmtpClient(SiteGlobal.MAIL_SERVER, SiteGlobal.MAIL_PORTNO)
                {
                    Credentials = CredentialCache.DefaultNetworkCredentials
                };
                client.Send(message);
            }
            catch (Exception e)
            {
                HttpContext.Current.Response.Write("<br />" + e);
                lo_result = false;
            }
            finally
            {
                message.Dispose();
            }

            return lo_result;
        }

        public static bool LogisquareSendMail(string from, string to, string subject, string body, bool isHtml, string strAttach, string strAttachName, string AdminMail)
        {
            bool lo_result;
            try
            {
                MailMessage message = new MailMessage(from, to, subject, body) { IsBodyHtml = isHtml};

                if (!string.IsNullOrWhiteSpace(strAttach))
                {
                    Attachment lo_objAttachment = new Attachment(strAttach);

                    if (!string.IsNullOrWhiteSpace(strAttachName))
                    {
                        lo_objAttachment.Name         = strAttachName;
                        lo_objAttachment.NameEncoding = Encoding.UTF8;
                    }
                    message.Attachments.Add(lo_objAttachment);
                }

                lo_result = LogisquareSendMail(message);
            }
            catch (Exception lo_ex)
            {
                HttpContext.Current.Response.Write(lo_ex.ToString());
                lo_result = false;

                WriteLog("SiteGlobal", "Exception"
                       , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9002);
            }

            return lo_result;
        }

        public static bool LogisquareSendMail(MailMessage message)
        {
            bool lo_result = true;

            try
            {
                SmtpClient client = new SmtpClient("gw.logisquare.co.kr", 587)
                {
                    Credentials = new NetworkCredential("shtax@logisquare.co.kr", CommonUtils.Utils.GetDecrypt("MzMyNmVmZWI1NmQyMzNmNLQ6azhhnYH31lXCBmiGsHCkRJHfCxMYwiY=")),
                    EnableSsl   = true
                };
                client.Send(message);
            }
            catch (Exception e)
            {
                HttpContext.Current.Response.Write("<br />" + e);
                lo_result = false;
            }
            finally
            {
                message.Dispose();
            }

            return lo_result;
        }

        public static string GetHttpHost(HttpRequest httpRequest)
        {
            return httpRequest.ServerVariables.Get("HTTP_HOST");
        }

        public static string GetHttpProtocol()
        {
            string lo_strVal;
            string lo_strRetVal;

            lo_strVal = HttpContext.Current.Request.ServerVariables.Get("HTTPS");
            if (lo_strVal == "off" || lo_strVal == null || lo_strVal.Equals(""))
            {
                lo_strVal    = HttpContext.Current.Request.ServerVariables.Get("HTTP_X_FORWARDED_PROTO");
                lo_strRetVal = !string.IsNullOrWhiteSpace(lo_strVal) ? lo_strVal : "http";
            }
            else
            {
                lo_strRetVal = "https";
            }

            return lo_strRetVal;
        }

        public static string GetRemoteAddr()
        {
            IPAddress ipAddress;
            string lo_strRemoteAddr = string.Empty;

            lo_strRemoteAddr = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            if (lo_strRemoteAddr.Contains(","))
            {
                lo_strRemoteAddr = lo_strRemoteAddr.Split(',').First().Trim();
            }
            if (IPAddress.TryParse(lo_strRemoteAddr, out ipAddress))    // 정상적인 IP 주소체계이면
            {
                return lo_strRemoteAddr;
            }

            // REMOTE_ADDR 에서 정상적인 IP 주소체계를 찾지못했다면, HTTP_X_FORWARDED_FOR 에서 찾는다.
            lo_strRemoteAddr = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (lo_strRemoteAddr.Contains(","))
            {
                lo_strRemoteAddr = lo_strRemoteAddr.Split(',').First().Trim();
            }
            if (IPAddress.TryParse(lo_strRemoteAddr, out ipAddress))    // 정상적인 IP 주소체계이면
            {
                return lo_strRemoteAddr;
            }

            return string.Empty;
        }

        public static void ReadPageCache_JsonData_AddrList(Page page)
        {
            try
            {
                if (null != page.Cache[CommonConstant.M_PAGE_CACHE_ADDRLIST])
                {
                    return;
                }

                string lo_strFileName = CommonConstant.M_PAGE_CACHE_ADDRLIST_JSON;
                if (!File.Exists(lo_strFileName))
                {
                    return;
                }

                string lo_strJson = File.ReadAllText(lo_strFileName);
                DataTable list = JsonConvert.DeserializeObject<DataTable>(lo_strJson);

                if (null != page.Cache[CommonConstant.M_PAGE_CACHE_ADDRLIST])
                {
                    page.Cache.Remove(CommonConstant.M_PAGE_CACHE_ADDRLIST);
                }

                page.Cache.Insert(CommonConstant.M_PAGE_CACHE_ADDRLIST, list, null, DateTime.Now.AddMonths(1), TimeSpan.Zero);
            }
            catch (Exception ex)
            {
                WriteLog("SiteGlobal", "Exception", "ReadPageCache_JsonData_AddrList\r\n\t[ex.Message] : " + ex.Message + "\r\n\t[ex.StackTrace] : " + ex.StackTrace, 9999);
            }
        }

        public static DataTable ReadAddrList_DataTable(Page page)
        {
            if (null == page.Cache[CommonConstant.M_PAGE_CACHE_ADDRLIST])
            {
                return null;
            }

            DataTable list = page.Cache.Get(CommonConstant.M_PAGE_CACHE_ADDRLIST) as DataTable;
            return list;
        }

        public static void ReadPageCache_JsonData_CarTon(Page page)
        {
            try
            {
                if (null != page.Cache[CommonConstant.M_PAGE_CACHE_CARTON])
                {
                    return;
                }

                string lo_strFileName = CommonConstant.M_PAGE_CACHE_CARTON_JSON;
                if (!File.Exists(lo_strFileName))
                {
                    return;
                }

                string    lo_strJson = File.ReadAllText(lo_strFileName);
                DataTable list       = JsonConvert.DeserializeObject<DataTable>(lo_strJson);

                if (null != page.Cache[CommonConstant.M_PAGE_CACHE_CARTON])
                {
                    page.Cache.Remove(CommonConstant.M_PAGE_CACHE_CARTON);
                }

                page.Cache.Insert(CommonConstant.M_PAGE_CACHE_CARTON, list, null, DateTime.Now.AddMonths(1), TimeSpan.Zero);
            }
            catch (Exception ex)
            {
                WriteLog("SiteGlobal", "Exception", "ReadPageCache_JsonData_CarTon\r\n\t[ex.Message] : " + ex.Message + "\r\n\t[ex.StackTrace] : " + ex.StackTrace, 9999);
            }
        }

        public static DataTable ReadCarTon_DataTable(Page page)
        {
            if (null == page.Cache[CommonConstant.M_PAGE_CACHE_CARTON])
            {
                return null;
            }

            DataTable list = page.Cache.Get(CommonConstant.M_PAGE_CACHE_CARTON) as DataTable;
            return list;
        }

        internal static void WriteLog(string v1, string v2, object p, int lo_intRetVal)
        {
            throw new NotImplementedException();
        }

        public static int CallWebServicePost(string strUrl, string strWebServiceHeader, string strMethod, string strContentType, string strPostData, out string strJsonData, out string strErrMsg)
        {
            HttpWebRequest req = null;
            Stream reqStream = null;
            HttpWebResponse res = null;
            StreamReader reader = null;

            strJsonData = string.Empty;
            strErrMsg = string.Empty;

            try
            {
                // SSL/TLS 보안 채널을 만들 수 없다는 에러가 발생되어 아래를 추가.
                // .NET Framework 버젼 및 SSL/TLS 세팅에 따라 이 경우가 불필요한 경우 아래 2라인을 제거한다.
                if (strUrl.StartsWith("https"))
                {
                    ServicePointManager.Expect100Continue = true;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                }

                req = (HttpWebRequest)WebRequest.Create(strUrl);

                if (!string.IsNullOrWhiteSpace(strWebServiceHeader))
                {
                    req.Headers.Add("Authorization", " " + strWebServiceHeader);
                }

                if (!string.IsNullOrWhiteSpace(strContentType))
                {
                    req.ContentType = strContentType;
                }
                else
                {
                    req.ContentType = "application/json";
                }
                req.Method = strMethod;
                if (req.Method.Equals("POST"))
                {
                    byte[] sendData = UTF8Encoding.UTF8.GetBytes(strPostData);
                    req.ContentLength = sendData.Length;
                    req.Timeout = System.Threading.Timeout.Infinite;
                    reqStream = req.GetRequestStream();
                    reqStream.Write(sendData, 0, sendData.Length);
                }

                res = (HttpWebResponse)req.GetResponse();
                string status = res.StatusCode.ToString();
                if (status.Equals("OK"))
                {
                    reader = new StreamReader(res.GetResponseStream(), Encoding.GetEncoding("UTF-8"));

                    strJsonData = reader.ReadToEnd();

                    if (strJsonData.StartsWith("["))
                    {
                        strJsonData = strJsonData.Substring(1, strJsonData.Length - 2);
                    }

                    return 0;
                }
                else
                {
                    strErrMsg = $"CallWebServicePost 결과 수신:({strUrl}), ({strMethod}) ==> STATUS:({status})";
                    return -1;
                }
            }
            catch (WebException ex)
            {
                if (ex.Response != null)
                {
                    HttpWebResponse ex_res = (HttpWebResponse)ex.Response;
                    StreamReader ex_reader = new StreamReader(ex_res.GetResponseStream(), Encoding.GetEncoding("UTF-8"));
                    strJsonData = ex_reader.ReadToEnd();

                    strErrMsg = $"CallWebServicePost CALL ERROR RETURN : ({strUrl}), ({strMethod}, {strPostData}) ==> (HttpCode:{ex_res.StatusCode.GetHashCode()},{ex_res.StatusCode})({strJsonData})";
                }
                else
                {
                    strErrMsg = $"CallWebServicePost CALL ERROR RETURN : ({strUrl}), ({strMethod}, {strPostData}) ==> (HttpCode:{ex.Status},{ex.InnerException})({strJsonData})";
                }

                return 9999;
            }
            catch (Exception ex)
            {
                strErrMsg = $"CallWebServicePost Exception : ({strUrl}), ({strMethod}, {strPostData}) ==> ({ex.Message})";
                return -1;
            }
            finally
            {
                if (reqStream != null)
                {
                    reqStream.Close();
                }
                if (reader != null)
                {
                    reader.Close();
                }
                if (res != null)
                {
                    res.Close();
                }
            }
        }

        public static int CallWebServicePostWithCookie(string strUrl, string strWebServiceHeader, string strMethod, string strContentType, string strUserAgent, string strRequestData, string strRequestCookie, out string strResponseData, out string strResponseCookie)
        {
            HttpWebRequest req = null;
            Stream reqStream = null;
            HttpWebResponse res = null;
            StreamReader reader = null;
            strResponseData = string.Empty;
            strResponseCookie = string.Empty;
            int lo_intRetVal = -1;

            try
            {
                // SSL/TLS 보안 채널을 만들 수 없다는 에러가 발생되어 아래를 추가.
                // .NET Framework 버젼 및 SSL/TLS 세팅에 따라 이 경우가 불필요한 경우 아래 2라인을 제거한다.
                if (strUrl.StartsWith("https"))
                {
                    ServicePointManager.Expect100Continue = true;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                }

                req = (HttpWebRequest)WebRequest.Create(strUrl);

                byte[] sendData = Encoding.UTF8.GetBytes(strRequestData);

                if (!string.IsNullOrWhiteSpace(strWebServiceHeader))
                {
                    req.Headers.Add("Authorization", " " + strWebServiceHeader);
                }

                if (string.IsNullOrWhiteSpace(strContentType))
                {
                    req.ContentType = "application/json";
                }
                else
                {
                    req.ContentType = strContentType;
                }

                if (!string.IsNullOrWhiteSpace(strUserAgent))
                {
                    req.UserAgent = strUserAgent;
                }

                req.Headers["Cache-Control"] = "no-cache";
                req.Method = strMethod;

                if (!string.IsNullOrWhiteSpace(strRequestCookie))
                {
                    req.Headers.Add("Cookie", strRequestCookie);
                }

                req.ContentLength = sendData.Length;
                reqStream = req.GetRequestStream();
                reqStream.Write(sendData, 0, sendData.Length);

                res = (HttpWebResponse)req.GetResponse();
                string status = res.StatusCode.ToString();
                if (status.Equals(HttpStatusCode.OK.ToString()))
                {
                    reader = new StreamReader(res.GetResponseStream(), Encoding.GetEncoding("UTF-8"));
                    strResponseData = reader.ReadToEnd();

                    lo_intRetVal = 0;
                }
                else
                {
                    lo_intRetVal = -2;
                }

                strResponseCookie = res.Headers["Set-Cookie"];

            }
            catch (WebException lo_ex)
            {
                lo_intRetVal = 0;
                WebResponse webresponse = lo_ex.Response;
                HttpWebResponse httpErr = (HttpWebResponse)webresponse;

                Stream errStream = webresponse.GetResponseStream();
                StreamReader errStreamReader = new StreamReader(errStream, Encoding.UTF8);
                strResponseData = errStreamReader.ReadToEnd();

                errStreamReader.Close();
                errStream.Close();
                httpErr.Close();
            }
            catch (Exception)
            {
            }
            finally
            {
                if (reqStream != null)
                {
                    reqStream.Close();
                    reqStream = null;
                }

                if (reader != null)
                {
                    reader.Close();
                    reader = null;
                }

                if (res != null)
                {
                    res.Close();
                    res = null;
                }
            }
            return lo_intRetVal;
        }

        //-----------------------------------------------------------------------------------------------------------------------
        //웹페이지를 PDF 로 저장하여 이메일로 전송한다.
        //-----------------------------------------------------------------------------------------------------------------------

        public static bool SendWebUrlPdfToEmail(string strUrl, string strPostParam, int nOrientation, int nTopMargin, int nBottomMargin, int nLeftMargin, int nRightMargin, int nZoom, string strFileName, string strFileSendName, string strSender, string strRcpt, string strTitle, string strBody, string strAdminMail)
        {
            int    nRetVal           = 0;
            string strErrMsg         = string.Empty;
            bool   bRslt             = false;
            GenPdf pdf               = new GenPdf();
            string strWebData        = string.Empty;
            string strRequestCookie  = string.Empty;
            string strResponseCookie = string.Empty;
            string strFilePath       = FILE_SERVER_ROOT + @"\PDFIMAGE\";

            strFileSendName = string.IsNullOrWhiteSpace(strFileSendName) ? strFileName : strFileSendName;

            if (!Directory.Exists(strFilePath))
            {
                Directory.CreateDirectory(strFilePath);
            }

            strFilePath += strFileName;

            HttpCookie lo_objCookie = HttpContext.Current.Request.Cookies[CommonConstant.COOKIE_NAME];

            if (null == lo_objCookie || string.IsNullOrWhiteSpace(lo_objCookie.Value))
            {
                return bRslt;
            }

            strRequestCookie = $"{CommonConstant.COOKIE_NAME}={lo_objCookie.Value}";
            nRetVal          = CallWebServicePostWithCookie(strUrl, "", "POST", "application/x-www-form-urlencoded; charset=UTF-8", "", strPostParam, strRequestCookie, out strWebData, out strResponseCookie);

            if (!nRetVal.Equals(0))
            {
                return bRslt;
            }

            pdf.SetOrientation(nOrientation);  // 0:가로, 1:세로
            pdf.SetMargin(nTopMargin, nBottomMargin, nLeftMargin, nRightMargin);  //Top, Bottom,Left,Right
            pdf.SetZoom(nZoom);   //Zoom Level
            bRslt = pdf.CreatePdfFromString(strWebData, strFilePath);

            if (bRslt.Equals(false))
            {
                return bRslt;
            }

            bRslt = LogisquareSendMail(strSender, strRcpt, strTitle, strBody, true, strFilePath, strFileSendName, strAdminMail);

            File.Delete(strFilePath);

            return bRslt;
        }

        public static bool DownloadWebUrlPdf(string strUrl, string strPostParam, int nOrientation, int nTopMargin, int nBottomMargin, int nLeftMargin, int nRightMargin, int nZoom, string strFileName, string strFileDownName)
        {
            int    nRetVal           = 0;
            string strErrMsg         = string.Empty;
            bool   bRslt             = false;
            GenPdf pdf               = new GenPdf();
            string strWebData        = string.Empty;
            string strRequestCookie  = string.Empty;
            string strResponseCookie = string.Empty;
            string strFilePath       = FILE_SERVER_ROOT + @"\PDFIMAGE\";

            strFileDownName = string.IsNullOrWhiteSpace(strFileDownName) ? strFileName : strFileDownName;

            if (!Directory.Exists(strFilePath))
            {
                Directory.CreateDirectory(strFilePath);
            }

            strFilePath += strFileName;

            HttpCookie lo_objCookie = HttpContext.Current.Request.Cookies[CommonConstant.COOKIE_NAME];

            if (null == lo_objCookie || string.IsNullOrWhiteSpace(lo_objCookie.Value))
            {
                return bRslt;
            }

            strRequestCookie = $"{CommonConstant.COOKIE_NAME}={lo_objCookie.Value}";
            nRetVal          = CallWebServicePostWithCookie(strUrl, "", "POST", "application/x-www-form-urlencoded; charset=UTF-8", "", strPostParam, strRequestCookie, out strWebData, out strResponseCookie);

            if (!nRetVal.Equals(0))
            {
                return bRslt;
            }

            pdf.SetOrientation(nOrientation);  // 0:가로, 1:세로
            pdf.SetMargin(nTopMargin, nBottomMargin, nLeftMargin, nRightMargin);  //Top, Bottom,Left,Right
            pdf.SetZoom(nZoom);   //Zoom Level
            bRslt = pdf.CreatePdfFromString(strWebData, strFilePath);
            if (bRslt.Equals(false))
            {
                return bRslt;
            }

            byte[] Contents = File.ReadAllBytes(strFilePath);

            File.Delete(strFilePath);
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            HttpContext.Current.Response.ContentType = "application/pdf";
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=" + strFileDownName);
            HttpContext.Current.Response.BufferOutput = true;
            HttpContext.Current.Response.OutputStream.Write(Contents, 0, Contents.Length);

            return true;
        }

        public static void ConvertXmlDataToDataTable(string strXmlData, ref DataTable dt)
        {
            System.Xml.XmlDocument xmlDoc = new System.Xml.XmlDocument();
            xmlDoc.LoadXml(strXmlData);
            System.Xml.XmlReader reader = new System.Xml.XmlNodeReader(xmlDoc);
            DataSet ds = new DataSet();
            ds.ReadXml(reader, XmlReadMode.Auto);

            dt = ds.Tables[0];
        }

        public static int DownloadWebUrlToFile(string strUrl, string strSaveFileName, ref string strErrMsg)
        {
            int nRetVal = 0;
            WebClient client = null;
            byte[] byteData = null;
            string strExtension = string.Empty;
            string strNewFileName = string.Empty;

            try
            {
                if (string.IsNullOrWhiteSpace(strUrl))
                {
                    strErrMsg = "다운로드 URL 누락";
                    return -1;
                }

                strExtension = Path.GetExtension(strUrl.ToLower()).Replace(".", "");
                if (!strExtension.Equals("jpg") &&
                    !strExtension.Equals("jpeg") &&
                    !strExtension.Equals("png") &&
                    !strExtension.Equals("gif") &&
                    !strExtension.Equals("pdf"))
                {
                    strErrMsg = "다운로드 파일의 확장자는 지원하지 않습니다.";
                    return -1;
                }

                strNewFileName = strSaveFileName.Split('.')[0] + "." + strExtension;

                client = new WebClient();
                MemoryStream ms = new MemoryStream(client.DownloadData(strUrl));
                byteData = ms.ToArray();

                if (strExtension.Equals("jpg") ||
                    strExtension.Equals("jpeg") ||
                    strExtension.Equals("png") ||
                    strExtension.Equals("gif"))
                {
                    HttpContext.Current.Response.ContentType = $"image/{strExtension}";
                }
                else if (strExtension.Equals("pdf"))
                {
                    HttpContext.Current.Response.ContentType = $"application/{strExtension}";
                }

                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=" + strNewFileName);
                HttpContext.Current.Response.BufferOutput = true;
                HttpContext.Current.Response.OutputStream.Write(byteData, 0, byteData.Length);
            }
            catch (Exception ex)
            {
                strErrMsg = ex.Message;
                nRetVal = -1;
            }

            return nRetVal;
        }

        /// <summary>
        /// 구글 OTP 인증요청
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResGoogleOTPAuth GoogleOtpAuth(ReqGoogleOTPAuth objRequest)
        {
            int lo_intRetVal = 0;
            string lo_strPostData = string.Empty;
            string lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader lo_objHeader = null;
            HttpAction lo_objHttp = null;
            ResGoogleOTPAuth lo_objResponse = null;

            try
            {
                lo_objResponse = new ResGoogleOTPAuth();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogisquareAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_LQ_DOMAIN + WS_API_COMMAND_GOOGLE_OTP_AUTH, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"구글 OTP 인증요청{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResGoogleOTPAuth>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage =
                        $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9333;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode    = 9334;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 구글 OTP KEYGEN
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResGoogleOTPKeyGen GoogleOtpKeyGen(ReqGoogleOTPKeyGen objRequest)
        {
            int lo_intRetVal = 0;
            string lo_strPostData = string.Empty;
            string lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader lo_objHeader = null;
            HttpAction lo_objHttp = null;
            ResGoogleOTPKeyGen lo_objResponse = null;

            try
            {
                lo_objResponse = new ResGoogleOTPKeyGen();
                lo_objHeader = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = GetLogisquareAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_LQ_DOMAIN + WS_API_COMMAND_GOOGLE_OTP_KEYGEN, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"구글 OTP 설정키 생성{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResGoogleOTPKeyGen>(lo_objHttp.ResponseData);
                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage =
                        $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode = 9233;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode    = 9335;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 주소정보 파싱
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResContactInfo GetContactInfo(ReqContactInfo objRequest)
        {
            int            lo_intRetVal        = 0;
            string         lo_strPostData      = string.Empty;
            HttpHeader     lo_objHeader        = null;
            HttpAction     lo_objHttp          = null;
            ResContactInfo lo_objResponse      = null;
            string         lo_strYMD           = DateTime.Now.ToString("yyyyMMdd");

            try
            {
                lo_objResponse = new ResContactInfo();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_DAPI_DEFAULT_CONTENTTYPE };
                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(WS_DAPI_REAL_DOMAIN + CommonConstant.WS_DAPI_CONTACT_INFO, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.ResultMessage = $"주소 조회 웹서비스 호출 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResContactInfo>(lo_objHttp.ResponseData);
                if (lo_objResponse.ResultCode.IsFail())
                {
                    lo_objResponse.ResultMessage = $"{lo_objResponse.ResultMessage}({lo_objResponse.ResultCode})";
                    lo_objResponse.ResultCode    = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.ResultCode    = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        public static CheckIPNation_Response CheckIPNation()
        {
            CheckIPNation_Request  lo_objRequest       = null;
            int                    lo_intRetVal        = 0;
            string                 lo_strPostData      = string.Empty;
            string                 lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader             lo_objHeader        = null;
            HttpAction             lo_objHttp          = null;
            CheckIPNation_Response lo_objResponse      = null;

            try
            {
                lo_objRequest = new CheckIPNation_Request {
                    IPAddress = GetRemoteAddr()
                };

                lo_objResponse      = new CheckIPNation_Response();
                lo_objHeader        = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };
                lo_strAuthirization = GetLogisquareAPIHeaderAuth();

                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(lo_objRequest);
                lo_objHttp     = new HttpAction(WS_LQ_DOMAIN + CommonConstant.WS_API_COMMAND_CHECKIPNATION, lo_objHeader, lo_strPostData);

                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;

                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"IP국가 체크 웹서비스 호출 오류{lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<CheckIPNation_Response>(lo_objHttp.ResponseData);

                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResponse.Header.ResultMessage = $"{lo_objResponse.Header.ResultMessage}({lo_objResponse.Header.ResultCode})";
                    lo_objResponse.Header.ResultCode    = 9013;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.Header.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.Header.ResultCode    = 9014;
                }

                WriteLog("SiteGlobal", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }
    }
}