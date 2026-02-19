using CommonLibrary.CommonModel;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using CommonLibrary.Utils;
using Newtonsoft.Json;
using System;

//===============================================================
// FileName       : ApiCallManager.cs
// Description    : CallManager API 연동
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonModule
{
    public static class ApiCallManager
    {
        /// <summary>
        /// Call Manager : 계정정보 업데이트
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResCMCommon SetCMAuthInfo(ReqCMAuthInfo objRequest)
        {
            int         lo_intRetVal   = 0;
            string      lo_strPostData;
            HttpHeader  lo_objHeader   = null;
            HttpAction  lo_objHttp     = null;
            ResCMCommon lo_objResponse = null;

            try
            {
                lo_objResponse = new ResCMCommon();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_DAPI_DEFAULT_CONTENTTYPE };
                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(SiteGlobal.WS_DAPI_CALLMGR_REAL_DOMAIN + CommonConstant.WS_DAPI_CM_AUTHINFO, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                if (!lo_objHttp.HttpStatus.Equals(200))
                {
                    lo_objResponse.ResultMessage = $"계정정보 업데이트 웹서비스 호출 오류({lo_objHttp.HttpStatus})";
                    lo_objResponse.ResultCode    = 9011;
                    return lo_objResponse;
                }

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.ResultMessage = $"계정정보 업데이트 웹서비스 호출 오류({lo_objHttp.ErrMsg})";
                    lo_objResponse.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResCMCommon>(lo_objHttp.ResponseData);
                if (lo_objResponse.ResultCode.IsFail())
                {
                    lo_objResponse.ResultMessage = $"{lo_objResponse.ResultMessage}({lo_objResponse.ResultCode})";
                    lo_objResponse.ResultCode    = 9012;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.ResultCode    = 9013;
                }

                SiteGlobal.WriteLog("ApiCallManager", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// Call Manager : 계정정보 삭제
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResCMCommon DelCMAuthInfo(ReqCMDeleteAuthInfo objRequest)
        {
            int         lo_intRetVal   = 0;
            string      lo_strPostData;
            HttpHeader  lo_objHeader   = null;
            HttpAction  lo_objHttp     = null;
            ResCMCommon lo_objResponse = null;

            try
            {
                lo_objResponse = new ResCMCommon();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_DAPI_DEFAULT_CONTENTTYPE };
                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(SiteGlobal.WS_DAPI_CALLMGR_REAL_DOMAIN + CommonConstant.WS_DAPI_CM_DELETE_AUTHINFO, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                if (!lo_objHttp.HttpStatus.Equals(200))
                {
                    lo_objResponse.ResultMessage = $"계정정보 삭제 웹서비스 호출 오류({lo_objHttp.HttpStatus})";
                    lo_objResponse.ResultCode    = 9016;
                    return lo_objResponse;
                }

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.ResultMessage = $"계정정보 삭제 웹서비스 호출 오류({lo_objHttp.ErrMsg})";
                    lo_objResponse.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResCMCommon>(lo_objHttp.ResponseData);
                if (lo_objResponse.ResultCode.IsFail())
                {
                    lo_objResponse.ResultMessage = $"{lo_objResponse.ResultMessage}({lo_objResponse.ResultCode})";
                    lo_objResponse.ResultCode    = 9017;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.ResultCode    = 9018;
                }

                SiteGlobal.WriteLog("ApiCallManager", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// Call Manager : 전화걸기 및 문자발송
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResCMCommon InsOutboundCall(ReqCMOutBoundCall objRequest)
        {
            int         lo_intRetVal   = 0;
            string      lo_strPostData;
            HttpHeader  lo_objHeader   = null;
            HttpAction  lo_objHttp     = null;
            ResCMCommon lo_objResponse = null;

            try
            {
                lo_objResponse = new ResCMCommon();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_DAPI_DEFAULT_CONTENTTYPE };
                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(SiteGlobal.WS_DAPI_CALLMGR_REAL_DOMAIN + CommonConstant.WS_DAPI_CM_OUTBOUNDCALL, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                if (!lo_objHttp.HttpStatus.Equals(200))
                {
                    lo_objResponse.ResultMessage = $"전화/문자 발송 웹서비스 호출 오류({lo_objHttp.HttpStatus})";
                    lo_objResponse.ResultCode    = 9021;
                    return lo_objResponse;
                }

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.ResultMessage = $"전화/문자 발송 웹서비스 호출 오류({lo_objHttp.ErrMsg})";
                    lo_objResponse.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResCMCommon>(lo_objHttp.ResponseData);
                if (lo_objResponse.ResultCode.IsFail())
                {
                    lo_objResponse.ResultMessage = $"{lo_objResponse.ResultMessage}({lo_objResponse.ResultCode})";
                    lo_objResponse.ResultCode    = 9022;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.ResultCode    = 9023;
                }

                SiteGlobal.WriteLog("ApiCallManager", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// Call Manager : 등록 계정에 연동된 전화번호 조회
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        public static ResCMPhonenoInfo GetPhonenoInfo(ReqCMPhonenoInfo objRequest)
        {
            int              lo_intRetVal   = 0;
            string           lo_strPostData;
            HttpHeader       lo_objHeader   = null;
            HttpAction       lo_objHttp     = null;
            ResCMPhonenoInfo lo_objResponse = null;

            try
            {
                lo_objResponse = new ResCMPhonenoInfo();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Get) { ConentType = CommonConstant.WS_DAPI_DEFAULT_CONTENTTYPE };
                lo_strPostData = $"site_code={objRequest.site_code}&site_custom_code={objRequest.site_custom_code}&channel_type={objRequest.channel_type}&auth_id={objRequest.auth_id}";

                lo_objHttp = new HttpAction(SiteGlobal.WS_DAPI_CALLMGR_REAL_DOMAIN + CommonConstant.WS_DAPI_CM_PHONENOINFO, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                if (!lo_objHttp.HttpStatus.Equals(200))
                {
                    lo_objResponse.ResultMessage = $"계정연동 전호번호 조회 웹서비스 호출 오류({lo_objHttp.HttpStatus})";
                    lo_objResponse.ResultCode    = 9026;
                    return lo_objResponse;
                }

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.ResultMessage = $"계정연동 전호번호 조회 웹서비스 호출 오류({lo_objHttp.ErrMsg})";
                    lo_objResponse.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResCMPhonenoInfo>(lo_objHttp.ResponseData);
                if (lo_objResponse.ResultCode.IsFail())
                {
                    lo_objResponse.ResultMessage = $"{lo_objResponse.ResultMessage}({lo_objResponse.ResultCode})";
                    lo_objResponse.ResultCode    = 9027;
                    return lo_objResponse;
                }
            }
            catch (Exception lo_ex)
            {
                if (lo_objResponse != null)
                {
                    lo_objResponse.ResultMessage = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                    lo_objResponse.ResultCode    = 9028;
                }

                SiteGlobal.WriteLog("ApiCallManager", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }

        /// <summary>
        /// 콜매니저 앱 전송(문자, 통화)
        /// </summary>
        /// <param name="objReqCMSendGoogleDataMessage"></param>
        /// <returns></returns>
        public static ResCMSendGoogleDataMessage SetSendGoogleDataMessage(ReqCMSendGoogleDataMessage objRequest)
        {

            int                        lo_intRetVal        = 0;
            string                     lo_strPostData      = string.Empty;
            string                     lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader                 lo_objHeader        = null;
            HttpAction                 lo_objHttp          = null;
            ResCMSendGoogleDataMessage lo_objResponse      = null;

            try
            {
                lo_objResponse = new ResCMSendGoogleDataMessage();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = SiteGlobal.GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objRequest);

                lo_objHttp = new HttpAction(SiteGlobal.WS_DOMAIN + CommonConstant.WS_CP_API_COMMAND_SENDGOOGLEDATAMESSAGE, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResponse.Header.ResultMessage = $"웹서비스 호출 오류 - {lo_objHttp.ErrMsg}";
                    lo_objResponse.Header.ResultCode    = lo_intRetVal;
                    return lo_objResponse;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResCMSendGoogleDataMessage>(lo_objHttp.ResponseData);

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
                    lo_objResponse.Header.ResultCode = 9014;
                }

                SiteGlobal.WriteLog("ApiCallManager", "Exception", "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_objResponse;
        }
    }
}