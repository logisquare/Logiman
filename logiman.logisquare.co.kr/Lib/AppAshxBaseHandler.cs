using CommonLibrary.CommonModel;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using CommonLibrary.Session;
using Newtonsoft.Json;
using System;
using System.Web;
using System.Web.SessionState;

//===============================================================
// FileName       : AppAshxBaseHandler.cs
// Description    : Ashx 페이지에서 기본으로 상속받는 로지맨앱 클래스
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : pckeeper@logislab.com, 2022-11-23
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonModule
{
    public class AppAshxBaseHandler : IHttpHandler, IRequiresSessionState
    {
        private   const string RESPONSE_CHARSET_UTF8     = "utf-8";
        protected const string ERROR_JSON_STRING         = "[{{\"RetCode\":{0},\"ErrMsg\":\"{1}\"}}]";
        public    const string RESPONSE_CONTENTTYPE_JSON = "application/json";

        protected HttpContext  objContext  = null;
        protected HttpResponse objResponse = null;
        protected HttpRequest  objRequest  = null;
        protected ResponseMap  objResMap   = null; //Ashx전역 ResMap

        protected string strMethod = string.Empty; //요청 메소드 명

        public bool IsHandlerStop { get; set; }
        private bool IsCheckLogin { get; set; } //로그인 체크 여부

        #region 로그인 정보
        protected AppSession objSes { get; private set; }
        #endregion

        protected AppAshxBaseHandler()
        {
            try
            {
                HttpContext.Current.Response.ContentType = RESPONSE_CONTENTTYPE_JSON;
                HttpContext.Current.Response.Charset     = RESPONSE_CHARSET_UTF8;

                objResMap         = new ResponseMap();

                IsCheckLogin = true;
                IsHandlerStop = false;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "AppAshxBaseHandler",
                    "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    -20001);

                HttpContext.Current.Response.Status     = "400 Bad request";
                HttpContext.Current.Response.StatusCode = 400;
                HttpContext.Current.Response.Write(string.Format(ERROR_JSON_STRING, -20001, CommonConstant.HTTP_STATUS_CODE_999_MESSAGE));
                HttpContext.Current.Response.End();
            }
        }
        ~AppAshxBaseHandler()
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
            int        lo_intRetVal = -9999;

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
                if(IsHandlerStop.Equals(true))
                {
                    return;
                }

                //로그인 검증
                if (IsCheckLogin)
                {
                    lo_intRetVal = CheckLogin();
                    if (lo_intRetVal.IsFail())
                    {
                        WriteJsonResponse("AppAshxBaseHandler", 9999, "로그인 정보가 없습니다.<br>다시 로그인해 주세요.");
                        IsHandlerStop = true;
                        return;
                    }
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("AppAshxBaseHandler", "Exception"
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

                    WriteJsonResponse("AppAshxBaseHandler", 9999, strServiceStop);
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

        /// <summary>
        /// 메뉴권한 체크가 필요없는 경우 호출한다
        /// </summary>
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
                WriteJsonResponse("AppAshxBaseHandler", 9991, $"403 Forbidden({lo_strIPAddress})");
                IsHandlerStop = true;
                return;
            }

            if (lo_objResponse.Payload.AccessFlag != "Y")
            {
                WriteJsonResponse("AppAshxBaseHandler", 9992, $"403 Forbidden / Not Allowed({lo_strIPAddress})");
                IsHandlerStop = true;
                return;
            }
        }

        /// <summary>
        /// 로그인 세션 체크 후 실패시 실패 응답
        /// </summary>
        private int CheckLogin()
        {
            string lo_strJson       = string.Empty;
            int    lo_intRetVal     = 0;

            //세션 생성
            objSes = new AppSession();
            objSes.GetSessionCookie();
            if (objSes.IsLogin.Equals(false))
            {
                lo_intRetVal = 9999;
            }

            return lo_intRetVal;
        }

        protected void IgnoreCheckLogin()
        {
            IsCheckLogin = false;
        }
    }
}