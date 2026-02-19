<%@ WebHandler Language="C#" Class="AppVersionHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using CommonLibrary.Session;
using System;
using System.Web;
using PBSDasNetCom;
using Newtonsoft.Json;
///================================================================
/// <summary>
/// FileName        : AppVersionHandler.ashx
/// Description     : Get App Version Information
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : pckeeper@logislab.com, 2022-09-14
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class AppVersionHandler : AppAshxBaseHandler
{
    AppVersionDasServices     objDas = new AppVersionDasServices();

    private string      strCallType    = string.Empty;
    private int         nDeviceKind    = 0;
    private int         nAppKind       = 0;

    /// <summary>
    /// You will need to configure this handler in the Web.config file of your 
    /// web and register it with IIS before being able to use it. For more information
    /// see the following link: https://go.microsoft.com/?linkid=8101007
    /// </summary>
    #region IHttpHandler Members

    public override void ProcessRequest(HttpContext context)
    {
        //NOTICE:로그인 체크가 필요없는 핸들러인 경우 호출 - 반드시 base.ProcessRequest 구문상단에서 호출해야 함
        IgnoreCheckLogin();

        //0.초기화 및 세션티켓 검증
        //# 부모 클래스의 함수 호출
        base.ProcessRequest(context);

        try
        {
            //1.Request
            GetData();
            if (objResMap.RetCode.IsFail())
            {
                return;
            }

            //2.처리
            Process();
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9401;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppVersionHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse();
        }
    }

    #endregion

    ///------------------------------
    /// <summary>
    /// 파라미터 데이터 설정
    /// </summary>
    ///------------------------------
    private void GetData()
    {
        try
        {
            strCallType = SiteGlobal.GetRequestForm("CallType");

            // 로그인 체크
            nDeviceKind = Convert.ToInt32(Utils.IsNull(SiteGlobal.GetRequestForm("DeviceKind"), "0"));
            nAppKind    = Convert.ToInt32(Utils.IsNull(SiteGlobal.GetRequestForm("AppKind"), "0"));
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppVersionHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    ///------------------------------
    /// <summary>
    /// 실행 메소드 처리함수
    /// </summary>
    ///------------------------------
    private void Process()
    {
        try
        {
            switch (strCallType)
            {
                case "getAppVersion":
                    GetAppVersion();
                    break;
                default:
                    objResMap.RetCode = 9500;
                    objResMap.ErrMsg  = "Wrong Method" + strCallType;
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9403;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppVersionHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region IHttpHandler Process

    protected void GetAppVersion()
    {
        string lo_strErrMsg            = string.Empty;
        string lo_strLastLoginNotice   = string.Empty;
        string lo_strCookie            = string.Empty;
        ServiceResult<ResAppVersionChk> lo_objResAppVersionChk = null;
        ReqAppVersionChk lo_objReqAppVersionChk = null;

        try
        {
            lo_objReqAppVersionChk = new ReqAppVersionChk
            {
                DeviceKind  = nDeviceKind,
                AppKind     = nAppKind
            };
            // 앱버젼 정보조회
            lo_objResAppVersionChk = objDas.GetAppVersionChk(lo_objReqAppVersionChk);

            objResMap.RetCode     = lo_objResAppVersionChk.result.ErrorCode;
            if (objResMap.RetCode.IsSuccess())
            {
                objResMap.Add("data", lo_objResAppVersionChk.data);
            }
            else
            {
                objResMap.ErrMsg = HttpUtility.JavaScriptStringEncode(lo_objResAppVersionChk.result.ErrorMsg);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppVersionHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #endregion


    ///--------------------------------------------
    /// <summary>
    /// 페이지 기본 Json 응답 출력
    /// </summary>
    ///--------------------------------------------
    private void WriteJsonResponse()
    {
        string lo_strResponse = string.Empty;
        string lo_strErrMsg   = string.Empty;

        try
        {
            lo_strResponse = objResMap.ToJsonString();
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode   = -21003;
            objResMap.ErrMsg    = CommonConstant.COMMON_EXCEPTION_MESSAGE;
            lo_strErrMsg        = "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace;
            lo_strResponse      = string.Format(ERROR_JSON_STRING, objResMap.RetCode, objResMap.ErrMsg);
        }
        finally
        {
            // 출력
            objResponse.Write(lo_strResponse);

            if (objResMap.RetCode < 0)
            {
                // 익셉션 발생시 처리 - File Logging & Send Mail
                SiteGlobal.WriteLog("AppVersionHandler", "Exception", lo_strErrMsg, objResMap.RetCode);
            }
        }
    }
}