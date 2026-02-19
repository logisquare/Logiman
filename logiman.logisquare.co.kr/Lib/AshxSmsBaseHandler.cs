using CommonLibrary.CommonModel;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web;

//===============================================================
// FileName       : AshxSmsBaseHandler.cs
// Description    : Ashx 페이지에서 기본으로 상속받는 클래스
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-09-30
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonModule
{
    public class AshxSmsBaseHandler : IHttpHandler
    {
        private   const string RESPONSE_CHARSET_UTF8     = "utf-8";
        protected const string ERROR_JSON_STRING         = "[{{\"RetCode\":{0},\"ErrMsg\":\"{1}\"}}]";
        public    const string RESPONSE_CONTENTTYPE_JSON = "application/json";

        protected HttpContext  objContext  = null;
        protected HttpResponse objResponse = null;
        protected HttpRequest  objRequest  = null;
        protected ResponseMap  objResMap   = null; //Ashx전역 ResMap

        protected string                           strMethod         = string.Empty; //요청 메소드 명
        protected Dictionary<string, MenuAuthType> objMethodAuthList = null;         //메소드 별 접근권한을 담는 Dictionary
        public bool IsHandlerStop { get; set; }

        protected AshxSmsBaseHandler()
        {
            try
            {
                HttpContext.Current.Response.ContentType = RESPONSE_CONTENTTYPE_JSON;
                HttpContext.Current.Response.Charset     = RESPONSE_CHARSET_UTF8;

                objResMap         = new ResponseMap();
                objMethodAuthList = new Dictionary<string, MenuAuthType>();
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "AshxSmsBaseHandler",
                    "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    -20001);

                HttpContext.Current.Response.Write(string.Format(ERROR_JSON_STRING, -20001, CommonConstant.HTTP_STATUS_CODE_999_MESSAGE));
                HttpContext.Current.Response.End();
            }
        }
        ~AshxSmsBaseHandler()
        {
            objResMap = null;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        //오버라이드 가능하도록 virtual 메소드로 정의
        public virtual void ProcessRequest(HttpContext context)
        {
            try
            {
                Init(context);
                if (IsHandlerStop.Equals(true))
                {
                    return;
                }

                //==================================================
                //서비스 점검중 체크
                //==================================================
                CheckServiceStop();
                if (IsHandlerStop.Equals(true))
                {
                    return;
                }

                //메소드 유효성 검증 - 메뉴 접근권한 확인 시에만 검증한다.
                if (string.IsNullOrEmpty(strMethod) || !objMethodAuthList.ContainsKey(strMethod))
                {
                    //Return400Status(28000, "Wrong Method(" + strMethod + ")");
                    WriteJsonResponse("AshxSmsBaseHandler", 9999, $"잘못된 메서드({strMethod}) 호출입니다.");
                    IsHandlerStop = true;
                    return;
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("AshxSmsBaseHandler", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9312);
            }
            finally
            {
                if (IsHandlerStop)
                {
                    objResponse.End();
                }
            }
        }

        protected void CheckServiceStop()
        {
            string lo_strServiceStopFlag = string.Empty;
            string lo_strServiceStopAllowIP = string.Empty;

            //===============================================================
            // 서비스 점검 페이지 노출 (레지스트리에 등록된 IP만 접근 허용)
            //===============================================================
            lo_strServiceStopFlag = CommonLibrary.CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_FLAG).ToString();
            if (lo_strServiceStopFlag.Equals("Y"))
            {
                string strServiceStop = string.Empty;

                if (!CommonLibrary.CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_ALLOWIP).ToString().Contains(SiteGlobal.GetRemoteAddr()))
                {
                    strServiceStop = CommonLibrary.CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_CONTENT).ToString();
                    if (string.IsNullOrWhiteSpace(strServiceStop))
                    {
                        strServiceStop = "시스템 점검중으로 서비스 이용이 불가합니다.";
                    }

                    WriteJsonResponse("AshxSmsBaseHandler", 9999, strServiceStop);
                    IsHandlerStop = true;
                }
            }
        }

        ///--------------------------------------------
        /// <summary>
        /// 페이지 기본 Json 응답 출력
        /// </summary>
        ///--------------------------------------------
        private void WriteJsonResponse(string strLogName, int nErrorCode, string strErrorMsg)
        {
            string lo_strResponse = string.Empty;
            string lo_strErrMsg = string.Empty;
            ErrorResponse response = new ErrorResponse();

            try
            {
                response.result.ErrorCode = nErrorCode;
                response.result.ErrorMsg = strErrorMsg;

                lo_strResponse = "[" + JsonConvert.SerializeObject(response) + "]";
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = -21003;
                objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                lo_strErrMsg = "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace;
                lo_strResponse = string.Format(ERROR_JSON_STRING, objResMap.RetCode, objResMap.ErrMsg);
            }
            finally
            {
                // 출력
                objResponse.Write(lo_strResponse);

                // intRetVal 이 마이너스인 경우는 익셉션 에러임
                if (response.result.ErrorCode < 0)
                {
                    // 익셉션 발생시 처리 - File Logging & Send Mail
                    SiteGlobal.WriteLog(strLogName, "Exception", lo_strErrMsg, objResMap.RetCode);
                }
            }
        }

        ///--------------------------------------------
        /// <summary>
        /// 페이지 기본 Json 응답 출력
        /// </summary>
        ///--------------------------------------------
        public virtual void WriteJsonResponse(string strLogFileName)
        {
            string lo_strResponse = string.Empty;
            string lo_strErrMsg = string.Empty;

            try
            {
                //toJsonString() 제어 로직 - strResponse 판단.
                // - Not Null : strResponse 를 리턴
                // - Null     : intRetVal(ErrCode), strErrMsg(ErrMsg)를 Json String 으로 시리얼라이즈하여 리턴                
                lo_strResponse = objResMap.ToJsonString();
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = -21003;
                objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                lo_strErrMsg = "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace;
                lo_strResponse = string.Format(ERROR_JSON_STRING, objResMap.RetCode, objResMap.ErrMsg);
            }
            finally
            {
                // 출력
                objResponse.Write(lo_strResponse);

                // intRetVal 이 마이너스인 경우는 익셉션 에러임
                if (objResMap.RetCode < 0)
                {
                    SiteGlobal.WriteLog(strLogFileName, "Exception", lo_strErrMsg, objResMap.RetCode);
                }
            }
        }

        protected void Init(HttpContext context)
        {
            objContext = context;

            objRequest  = context.Request;
            objResponse = context.Response;
            strMethod   = objRequest.Params["CallType"];

            // 접근한 IP 주소의 국가를 조회하여 접근 허용/불가를 판단
            CheckIPNation();
        }

        protected void CheckIPNation()
        {
            CheckIPNation_Response lo_objResponse  = SiteGlobal.CheckIPNation();
            string                 lo_strIPAddress = SiteGlobal.GetRemoteAddr();

            if (!lo_objResponse.Header.ResultCode.Equals(0))
            {
                WriteJsonResponse("AshxSmsBaseHandler", 9991, $"403 Forbidden({lo_strIPAddress})");
                IsHandlerStop = true;
                return;
            }

            if (lo_objResponse.Payload.AccessFlag != "Y")
            {
                WriteJsonResponse("AshxSmsBaseHandler", 9992, $"403 Forbidden / Not Allowed({lo_strIPAddress})");
                IsHandlerStop = true;
                return;
            }
        }

        private void Return400Status(int intRetVal, string strErrMsg)
        {
            // Put the Header
            objResponse.Status     = "400 Bad request";
            objResponse.StatusCode = 400;
            objResponse.Write(string.Format(ERROR_JSON_STRING, intRetVal, strErrMsg));
            objResponse.End();
        }
    }
}