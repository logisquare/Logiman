<%@ WebHandler Language="C#" Class="LoginHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using CommonLibrary.Session;
using System;
using System.Web;

///================================================================
/// <summary>
/// FileName        : LoginHandler.ashx
/// Description     : Get Login/Mebership Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : pckeeper@logislab.com, 2022-12-26
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class LoginHandler : AppAshxBaseHandler
{
    AdminDasServices     objAdminDasServices = new AdminDasServices();

    private string       strCallType            = string.Empty;

    private string strAdminID     = string.Empty;
    private string strAdminPwd    = string.Empty;

    /// <summary>
    /// You will need to configure this handler in the Web.config file of your 
    /// web and register it with IIS before being able to use it. For more information
    /// see the following link: https://go.microsoft.com/?linkid=8101007
    /// </summary>
    #region IHttpHandler Members

    public override void ProcessRequest(HttpContext context)
    {
        IgnoreCheckLogin();

        //0.초기화 및 세션티켓 검증
        //# 부모 클래스의 함수 호출
        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

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

            SiteGlobal.WriteLog("LoginHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("LoginHandler");
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
            strAdminID       = Utils.IsNull(SiteGlobal.GetRequestForm("AdminID"), "");
            strAdminPwd      = Utils.IsNull(SiteGlobal.GetRequestForm("AdminPwd"), "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("LoginHandler", "Exception",
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
                case "chkLogin":
                    ChkAdminLogin();
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

            SiteGlobal.WriteLog("LoginHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region IHttpHandler Process
    protected void ChkAdminLogin()
    {
        string lo_strErrMsg          = string.Empty;
        string lo_strLastLoginNotice = string.Empty;
        int    lo_intGradeCode       = 0;

        ServiceResult<AdminViewModel> lo_objResAdminInfo = null;
        AppSession_Member             cookie             = null;

        try
        {
            // 관리자 비밀번호 체크
            objResMap.RetCode = PasswordManager.CheckEnteredPassword(strAdminID, strAdminPwd, out lo_intGradeCode, out lo_strErrMsg);
            if (objResMap.RetCode.IsFail())
            {
                // 비밀번호가 틀린 경우, 관리자 로그인 실패 로그 등록
                if (objResMap.RetCode.Equals(ErrorHandler.COMMON_LIB_ERR_22009))
                {
                    objAdminDasServices.InsAdminLoginFail(strAdminID, lo_strErrMsg);
                }

                objResMap.ErrMsg = lo_strErrMsg;
                return;
            }

            lo_objResAdminInfo = objAdminDasServices.GetAdminInfo(strAdminID);
            objResMap.RetCode  = lo_objResAdminInfo.result.ErrorCode;
            if (!objResMap.RetCode.IsSuccess())
            {
                objResMap.ErrMsg = HttpUtility.JavaScriptStringEncode(lo_objResAdminInfo.result.ErrorMsg);
                return;
            }

            cookie                       = new AppSession_Member();
            cookie.AdminID               = strAdminID;
            cookie.MobileNo              = lo_objResAdminInfo.data.MobileNo;
            cookie.AdminName             = lo_objResAdminInfo.data.AdminName;
            cookie.DeptName              = lo_objResAdminInfo.data.DeptName;
            cookie.Position              = lo_objResAdminInfo.data.AdminPosition;
            cookie.TelNo                 = lo_objResAdminInfo.data.TelNo;
            cookie.Email                 = lo_objResAdminInfo.data.Email;
            cookie.GradeCode             = lo_objResAdminInfo.data.GradeCode;
            cookie.GradeName             = lo_objResAdminInfo.data.GradeName;
            cookie.LastLoginDate         = lo_objResAdminInfo.data.LastLoginDate;
            cookie.LastLoginIP           = lo_objResAdminInfo.data.LastLoginIP;
            cookie.PwdUpdDate            = lo_objResAdminInfo.data.PwdUpdDate;
            cookie.AccessCenterCode      = lo_objResAdminInfo.data.AccessCenterCode;
            cookie.AccessCorpNo          = lo_objResAdminInfo.data.AccessCorpNo;
            cookie.Network24DDID         = lo_objResAdminInfo.data.Network24DDID;
            cookie.NetworkHMMID          = lo_objResAdminInfo.data.NetworkHMMID;
            cookie.NetworkOneCallID      = lo_objResAdminInfo.data.NetworkOneCallID;
            cookie.NetworkHmadangID      = lo_objResAdminInfo.data.NetworkHmadangID;
            cookie.ExpireYmd             = lo_objResAdminInfo.data.ExpireYMD;
            cookie.OrderItemCodes        = lo_objResAdminInfo.data.OrderItemCodes;
            cookie.OrderLocationCodes    = lo_objResAdminInfo.data.OrderLocationCodes;
            cookie.OrderStatusCodes      = lo_objResAdminInfo.data.OrderStatusCodes;
            cookie.DeliveryLocationCodes = lo_objResAdminInfo.data.DeliveryLocationCodes;
            cookie.MyOrderFlag           = lo_objResAdminInfo.data.MyOrderFlag;
            cookie.PrivateAvailFlag      = lo_objResAdminInfo.data.PrivateAvailFlag;

            AppSession lo_objSes = new AppSession();
            lo_objSes.CreateAuthCookieInfo(cookie);

            lo_strLastLoginNotice = $"\n최종 접속일시 : {cookie.LastLoginDate:yyyy-MM-dd HH:mm:ss}"
                                                   + $"<br/>최종 접속 IP : {cookie.LastLoginIP}"
                                                   + $"<br/>계정 만료일 : {Utils.ConvertDateFormat(cookie.ExpireYmd)}"
                                                   + $"<br/><br/>안녕하세요. {cookie.AdminName}님은 현재 로지맨 시스템을 이용하고 있습니다.";

            objResMap.Add("LastLoginNotice", lo_strLastLoginNotice);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("LoginHandler", "Exception",
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
    public override void WriteJsonResponse(string strLogFileName)
    {
        try
        {
            base.WriteJsonResponse(strLogFileName);
        }
        catch
        {
        }
    }
}