<%@ WebHandler Language="C#" Class="MemberShipInfoHandler" %>
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
/// FileName        : MemberShipInfoHandler.ashx
/// Description     : Get Login/Mebership Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : shadow54@logislab.com, 2022-03-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class MemberShipInfoHandler : AshxBaseHandler
{
    AdminDasServices objAdminDasServices = new AdminDasServices();

    private string strCallType = string.Empty;

    private string strAdminID    = string.Empty;
    private string strAdminPwd   = string.Empty;
    private string strOtpCode    = string.Empty;
    private string strOtpFlag    = string.Empty;
    private string strCorpNo     = string.Empty;
    private string strMemberType = string.Empty;
    private string strMobileNo   = string.Empty;

    // 아이디 찾기
    private string strIdMobileNo    = string.Empty;
    private string strIdAdminCorpNo = string.Empty;
    private string strIdAdminName   = string.Empty;

    // 본인인증 / 인증체크
    private string strEncSMSAuthNum = string.Empty;
    private string strAuthNumber    = string.Empty;
    private string strAuthInfo      = string.Empty;
    private string strAdminResetPwd = string.Empty;

    //구글 QR 불러오기
    private string strAdminAuthNumber = string.Empty;
    private string strAuthAdminID     = string.Empty;

    /// <summary>
    /// You will need to configure this handler in the Web.config file of your 
    /// web and register it with IIS before being able to use it. For more information
    /// see the following link: https://go.microsoft.com/?linkid=8101007
    /// </summary>
    #region IHttpHandler Members

    public override void ProcessRequest(HttpContext context)
    {
        //NOTICE:로그인 체크가 필요없는 핸들러인 경우 호출 - 반드시 base.ProcessRequest 구문상단에서 호출해야 함
        IgnoreCheckSession();

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

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("MemberShipInfoHandler");
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

            // 아이디 찾기
            strIdMobileNo    = Utils.IsNull(SiteGlobal.GetRequestForm("IdMobileNo"), "");
            strIdAdminCorpNo = Utils.IsNull(SiteGlobal.GetRequestForm("IdAdminCorpNo"), "");
            strIdAdminName   = Utils.IsNull(SiteGlobal.GetRequestForm("IdAdminName"), "");

            // 로그인 체크
            strAdminID  = Utils.IsNull(SiteGlobal.GetRequestForm("AdminID"), "");
            strAdminPwd = Utils.IsNull(SiteGlobal.GetRequestForm("AdminPwd"), "");
            strOtpCode  = Utils.IsNull(SiteGlobal.GetRequestForm("OtpCode"), "");
            strOtpFlag  = Utils.IsNull(SiteGlobal.GetRequestForm("OtpFlag"), "N");

            // 사업자번호 체크
            strCorpNo          = Utils.IsNull(SiteGlobal.GetRequestForm("CorpNo"),          "");
            strMemberType      = Utils.IsNull(SiteGlobal.GetRequestForm("MemberType"),      "");
            strAdminID         = Utils.IsNull(SiteGlobal.GetRequestForm("AdminID"),         "");
            strMobileNo        = Utils.IsNull(SiteGlobal.GetRequestForm("MobileNo"),        "");
            strEncSMSAuthNum   = Utils.IsNull(SiteGlobal.GetRequestForm("EncSMSAuthNum"),   "");
            strAuthNumber      = Utils.IsNull(SiteGlobal.GetRequestForm("AuthNumber"),      "");
            strAuthInfo        = Utils.IsNull(SiteGlobal.GetRequestForm("AuthInfo"),        "");
            strAdminResetPwd   = Utils.IsNull(SiteGlobal.GetRequestForm("AdminResetPwd"),   "");
            strAdminAuthNumber = Utils.IsNull(SiteGlobal.GetRequestForm("AdminAuthNumber"), "");
            strAuthAdminID     = Utils.IsNull(SiteGlobal.GetRequestForm("AuthAdminID"),     "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
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
                case "chkAuthID":
                    ChkAdminIDByMobileNo();
                    break;
                case "chkLogin":
                    ChkAdminLogin();
                    break;
                case "CorpNoCheck":
                    GetCorpNoCheck();
                    break;
                case "AdminIDCheck":
                    GetAdminIDCheckCheck();
                    break;
                case "CallSMSAuth":         // 본인인증 문자 전송
                    GetCallSMSAuth();
                    break;
                case "CheckSMSAuthNum":     // 본인인증 문자 체크(검증)
                    CheckSMSAuthNum();
                    break;
                case "AdminPwdReset":
                    ReqAdminPwdReset();
                    break;
                case "UpdAdminPwd": //휴대폰 인증코드 인증 및 비밀번호 변경
                    CheckAdminPwd();
                    break;
                case "InitAdminPwd": //최초 로그인 비밀번호 설정(비밀번호미설정상태)
                    InitAdminPwd();
                    break;
                case "CheckAdminPwdPolicy": //휴대폰 인증코드 인증 및 비밀번호 변경
                    CheckAdminPwdPolicy();
                    break;
                case "GetAuthNumberCheck": //구글 QR코드 생성
                    GetAuthNumberCheck();
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

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region IHttpHandler Process
    protected void ChkAdminIDByMobileNo()
    {
        string                       lo_strContents                = string.Empty;
        ResSendSMS                   lo_objResponse                = null;
        ServiceResult<PasswordReset> lo_objResGetAdminIDByMObileNo = null;
        string                       lo_strAdminID                 = string.Empty;

        try
        {
            lo_objResGetAdminIDByMObileNo = objAdminDasServices.GetAdminIDByMObileNo(strIdMobileNo, strIdAdminName, strIdAdminCorpNo, 0);
            objResMap.RetCode             = lo_objResGetAdminIDByMObileNo.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResGetAdminIDByMObileNo.result.ErrorMsg;
                return;
            }

            lo_strAdminID = lo_objResGetAdminIDByMObileNo.data.AdminID;
            lo_strAdminID = lo_strAdminID.Substring(0, lo_strAdminID.Length - 2) + "**";

            lo_strContents = $"가입하신 아이디는 {lo_strAdminID} 입니다.";

            // 변경된 임시 비밀번호를 문자로 전송
            lo_objResponse = SiteGlobal.CallSMS(CommonConstant.DEFAULT_CENTER_CODE, CommonConstant.DEFAULT_SMS_TEL.Replace("-", ""), strIdMobileNo.Replace("-", ""), lo_strContents);

            objResMap.RetCode = lo_objResponse.Header.ResultCode;
            objResMap.ErrMsg  = objResMap.RetCode.IsSuccess() ? "입력하신 휴대폰번호로 아이디를 전송했습니다." : "일시적 오류가 발생하여 서비스를 이용하실 수 없습니다. 잠시후 다시 시도해 주시기 바랍니다.";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void ChkAdminLogin()
    {
        string           lo_strErrMsg          = string.Empty;
        string           lo_strLastLoginNotice = string.Empty;
        int              lo_intRetVal          = 99;
        bool             lo_intIsValid         = false; //결과 값
        int              lo_intGradeCode       = 0;
        ReqGoogleOTPAuth lo_ReqGoogleOTPAuth   = null;
        ResGoogleOTPAuth lo_ResGoogleOTPAuth   = null;

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

            if (!lo_intGradeCode.Equals(6))
            {
                if (strOtpFlag.Equals("N") && string.IsNullOrEmpty(strOtpCode))
                {
                    objResMap.Add("GradeCode", lo_intGradeCode);
                    objResMap.Add("OtpFlag", "Y");
                    return;
                }
                
                if (strOtpFlag.Equals("Y") && !string.IsNullOrEmpty(strOtpCode))
                {
                    lo_ReqGoogleOTPAuth = new ReqGoogleOTPAuth()
                    {
                        AccountID  = strAdminID,
                        SecretKey  = SiteGlobal.GOOGLE_SECRET_KEY,
                        TokenValue = strOtpCode
                    };

                    lo_ResGoogleOTPAuth = SiteGlobal.GoogleOtpAuth(lo_ReqGoogleOTPAuth);

                    lo_intRetVal  = lo_ResGoogleOTPAuth.Header.ResultCode;
                    lo_strErrMsg  = lo_ResGoogleOTPAuth.Header.ResultMessage;
                    lo_intIsValid = lo_ResGoogleOTPAuth.Payload.isValid;

                    if (lo_intRetVal.IsFail())
                    {
                        objResMap.RetCode = lo_intRetVal;
                        objResMap.ErrMsg  = lo_strErrMsg;
                        return;
                    }
                    else
                    {
                        if (!lo_intIsValid)
                        {
                            objResMap.RetCode = 9901;
                            objResMap.ErrMsg  = "구글 OTP 인증코드 값이 잘못되었습니다.";
                            return;
                        }
                        else
                        {
                            SetAdminLogin();
                        }
                    }
                }
            }
            else
            {
                SetAdminLogin();
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetAdminLogin()
    {
        string                          lo_strErrMsg             = string.Empty;
        string                          lo_strLastLoginNotice    = string.Empty;
        int                             lo_intRetVal             = 99;
        bool                            lo_intIsValid            = false; //결과 값
        ServiceResult<AdminSessionInfo> lo_objResInsAdminSession = null;

        try
        {
            // 세션 생성
            lo_objResInsAdminSession = objAdminDasServices.InsAdminSession(strAdminID, SiteGlobal.GetRemoteAddr());
            objResMap.RetCode        = lo_objResInsAdminSession.result.ErrorCode;

            if (objResMap.RetCode.IsSuccess())
            {
                SiteSession             lo_objSes = new SiteSession();
                PBSDasNetCom.IDasNetCom lo_objDas = null;

                lo_objSes.SiteSessionSub4NoSession(ref lo_objDas, lo_objResInsAdminSession.data.SessionKey);

                lo_strLastLoginNotice = $"\n최종 접속일시 : {lo_objResInsAdminSession.data.LastLoginDate:yyyy-MM-dd HH:mm:ss}"
                                      + $"<br/>최종 접속 IP : {lo_objResInsAdminSession.data.LastLoginIP}"
                                      + $"<br/>계정 만료일 : {Utils.ConvertDateFormat(lo_objSes.ExpireYmd)}"
                                      + $"<br/><br/>안녕하세요. {lo_objSes.AdminName}님은 현재 로지맨 시스템을 이용하고 있습니다.";

                objResMap.Add("LastLoginNotice", lo_strLastLoginNotice);
            }
            else
            {
                objResMap.ErrMsg = HttpUtility.JavaScriptStringEncode(lo_objResInsAdminSession.result.ErrorMsg);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetCorpNoCheck()
    {
        ServiceResult<CorpNoCheck> lo_objResGetCorpNoCheck = null;

        try
        {
            if (string.IsNullOrEmpty(strCorpNo))
            {
                objResMap.RetCode = 9450;
                objResMap.ErrMsg  = "사업자 번호가 필요합니다.";
                return;
            }

            if (string.IsNullOrEmpty(strMemberType))
            {
                objResMap.RetCode = 9451;
                objResMap.ErrMsg  = "필요한 정보가 없습니다.";
                return;
            }
            
            lo_objResGetCorpNoCheck = objAdminDasServices.GetCorpNoCheck(strCorpNo, strMemberType);
            objResMap.RetCode       = lo_objResGetCorpNoCheck.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResGetCorpNoCheck.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            if (lo_objResGetCorpNoCheck?.data.ExistsFlag != null)
            {
                objResMap.Add("ExistsFlag", lo_objResGetCorpNoCheck.data.ExistsFlag);
                objResMap.Add("CorpName",   lo_objResGetCorpNoCheck.data.CorpName);
            }
        }
    }

    protected void GetAdminIDCheckCheck()
    {
        ReqAdminList                lo_objReqAdminList = null;
        ServiceResult<ResAdminList> lo_objResAdminList = null;

        try
        {
            lo_objReqAdminList = new ReqAdminList
            {
                AdminID      = strAdminID,
                MobileNo     = strMobileNo,
                SesGradeCode = 1,
                PageSize     = 1,
                PageNo       = 1
            };

            lo_objResAdminList = objAdminDasServices.GetAdminList(lo_objReqAdminList);
            objResMap.RetCode  = lo_objResAdminList.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResAdminList.result.ErrorMsg;
                return;
            }

            if (lo_objResAdminList.data.RecordCnt.Equals(0))
            {
                objResMap.RetCode = 0;
                objResMap.ErrMsg  = "등록가능";
                return;
            }
           
            objResMap.RetCode = 9460;
            objResMap.ErrMsg  = lo_objResAdminList.data.list[0].AdminID;
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetCallSMSAuth()
    {
        ReqSMSAuth lo_objRequest  = null;
        ResSMSAuth lo_objResponse = null;

        try
        {
            if (string.IsNullOrEmpty(strMobileNo))
            {
                objResMap.RetCode = 9550;
                objResMap.ErrMsg  = "휴대폰번호가 필요합니다.";
                return;
            }

            lo_objRequest = new ReqSMSAuth
            {
                CenterCode = CommonConstant.DEFAULT_CENTER_CODE,
                Sender     = CommonConstant.DEFAULT_SMS_TEL.Replace("-", ""),
                SendTo     = strMobileNo
            };


            // 사용자가 입력한 핸드폰 번호를 받아서 본인인증 문자를 보낸다.
            lo_objResponse    = SiteGlobal.CallSMSAuth(lo_objRequest);
            objResMap.RetCode = lo_objResponse.Header.ResultCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResponse.Header.ResultMessage;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            if (lo_objResponse?.Payload.EncSMSAuthNum != null)
            {
                objResMap.Add("EncSMSAuthNum", lo_objResponse.Payload.EncSMSAuthNum);
            }
        }
    }

    protected void CheckSMSAuthNum()
    {
        string lo_strErrMsg = string.Empty;

        try
        {
            if (string.IsNullOrEmpty(strEncSMSAuthNum))
            {
                objResMap.RetCode = 9551;
                objResMap.ErrMsg  = "인증값이 없습니다.";
                return;
            }

            if (string.IsNullOrEmpty(strAuthNumber))
            {
                objResMap.RetCode = 9552;
                objResMap.ErrMsg  = "인증번호가 입력되지 않았습니다.";
                return;
            }

            // 사용자가 입력한 핸드폰 번호를 받아서 본인인증 문자를 보낸다.
            objResMap.RetCode = SiteGlobal.CheckSMSAuthNum(strEncSMSAuthNum, strAuthNumber, out lo_strErrMsg);
            if (!objResMap.RetCode.Equals(0))
            {
                objResMap.ErrMsg = lo_strErrMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9553;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog(
                                "MemberShipInfo",
                                "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void ReqAdminPwdReset()
    {
        string                        lo_strEncAuthInfo  = string.Empty;
        ServiceResult<AdminViewModel> lo_objResAdminList = null;

        try
        {
            lo_objResAdminList = objAdminDasServices.GetAdminInfo(strAdminID);
            objResMap.RetCode  = lo_objResAdminList.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResAdminList.result.ErrorMsg;
                return;
            }

            if (!lo_objResAdminList.data.UseFlag.Equals("Y"))
            {
                objResMap.RetCode = 9199;
                objResMap.ErrMsg  = "정상 관리자만 비밀번호를 변경할 수 있습니다.";
                return;
            }

            if (strMobileNo.Equals(lo_objResAdminList.data.MobileNo))
            {
                // 등록된 휴대폰 번호로 인증번호 발송
                GetCallSMSAuth();

                if (objResMap.RetCode.IsSuccess())
                {
                    lo_strEncAuthInfo = Utils.GetEncrypt($"{DateTime.Now:yyyy-MM-dd HH:mm:ss}|{strAdminID}|{strMobileNo}");
                    objResMap.Add("AuthInfo", lo_strEncAuthInfo);
                }
            }
            else
            {
                objResMap.RetCode = 9200;
                objResMap.ErrMsg  = "등록된 정보와 다릅니다.";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9465;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void CheckAdminPwd()
    {
        string              lo_strDecAuthInfo      = string.Empty;
        string[]            lo_arrDecAuthInfo      = null;
        string              lo_strEncAdminResetPwd = string.Empty;
        BCrypt              lo_objBCrypt           = new BCrypt();
        ServiceResult<bool> lo_objResUpdAdminPwd   = null;

        try
        {
            if (string.IsNullOrEmpty(strAdminResetPwd)) {
                objResMap.RetCode = 9467;
                objResMap.ErrMsg = "변경 비밀번호가 없습니다.";
                return;
            }


            // Step 1 : 인증정보 체크
            CheckSMSAuthNum();

            // Step 2 : 비밀번호 체크
            CheckAdminPwdPolicy();
            if (objResMap.RetCode.IsSuccess())
            {
                if (string.IsNullOrEmpty(strAuthInfo))
                {
                    objResMap.RetCode = 9468;
                    objResMap.ErrMsg = "관리자 인증정보가 없습니다.";
                    return;
                }

                lo_strDecAuthInfo = Utils.GetDecrypt(strAuthInfo);
                lo_arrDecAuthInfo = lo_strDecAuthInfo.Split('|');

                // 1. 해시체크 : -5 ~ + 10분 내에 시도를 해야 한다.
                TimeSpan pl_dateTimeDifference = Convert.ToDateTime(lo_arrDecAuthInfo[0]).AddMinutes(10).Subtract(DateTime.Now);
                double   pl_intNumberOfSeconds = pl_dateTimeDifference.TotalSeconds;

                if (pl_intNumberOfSeconds < -300)
                {
                    objResMap.RetCode = 9470;
                    objResMap.ErrMsg = "유효 시간이 지났습니다.(인증 유효 시간 : 10분)";

                }
                else if (!lo_arrDecAuthInfo[1].Equals(strAdminID))
                {
                    objResMap.RetCode = 9471;
                    objResMap.ErrMsg = "인증된 아이디 정보가 다릅니다.";
                }
                else if (!lo_arrDecAuthInfo[2].Equals(strMobileNo))
                {
                    objResMap.RetCode = 9472;
                    objResMap.ErrMsg = "인증된 휴대폰 정보가 다릅니다.";
                }
            }

            // Step 3 : 인증정보 체크 성공 시 어드민 패스워드 변경
            if (objResMap.RetCode.IsSuccess())
            {
                lo_strEncAdminResetPwd = lo_objBCrypt.HashPassword(strAdminResetPwd, lo_objBCrypt.GenerateSaltByRandom());
                lo_objResUpdAdminPwd   = objAdminDasServices.UpdAdminPwd(strAdminID, lo_strEncAdminResetPwd, strAdminID, 2);
                objResMap.RetCode      = lo_objResUpdAdminPwd.result.ErrorCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = lo_objResUpdAdminPwd.result.ErrorMsg;
                }
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9403;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void InitAdminPwd()
    {
        string              lo_strEncAdminResetPwd = string.Empty;
        BCrypt              lo_objBCrypt           = new BCrypt();
        ServiceResult<bool> lo_objResUpdAdminPwd   = null;

        try
        {
            if (string.IsNullOrEmpty(strAdminResetPwd)) {
                objResMap.RetCode = 9467;
                objResMap.ErrMsg = "변경 비밀번호가 없습니다.";
                return;
            }


            // Step 2 : 비밀번호 체크
            CheckAdminPwdPolicy();
            if (objResMap.RetCode.IsSuccess())
            {
                if (string.IsNullOrWhiteSpace(strAdminID))
                {
                    objResMap.RetCode = 9471;
                    objResMap.ErrMsg = "아이디 정보 누락";
                }
            }

            // Step 3 : 인증정보 체크 성공 시 어드민 패스워드 변경
            if (objResMap.RetCode.IsSuccess())
            {
                lo_strEncAdminResetPwd = lo_objBCrypt.HashPassword(strAdminResetPwd, lo_objBCrypt.GenerateSaltByRandom());
                lo_objResUpdAdminPwd   = objAdminDasServices.UpdAdminPwd(strAdminID, lo_strEncAdminResetPwd, strAdminID, 2);
                objResMap.RetCode      = lo_objResUpdAdminPwd.result.ErrorCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = lo_objResUpdAdminPwd.result.ErrorMsg;
                }
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9403;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void CheckAdminPwdPolicy()
    {
        int    lo_intRetVal = 0;
        string lo_strErrMsg = string.Empty;

        try
        {
            // Step 1 : 인증정보 체크
            lo_intRetVal = PasswordManager.ValidatePasswordPolicy(strAdminResetPwd, out lo_strErrMsg);

            if (lo_intRetVal.IsFail())
            {
                objResMap.RetCode = lo_intRetVal;
                objResMap.ErrMsg  = lo_strErrMsg;
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9403;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MemberShipInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetAuthNumberCheck()
    {
        ReqGoogleOTPKeyGen lo_ReqGoogleOTPKeyGen = null;
        ResGoogleOTPKeyGen lo_ResGoogleOTPKeyGen = null;

        try
        {
            if (string.IsNullOrWhiteSpace(strAuthAdminID))
            {
                objResMap.RetCode = 9001;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strAdminAuthNumber))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strAuthNumber))
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            if (!strAdminAuthNumber.Equals(Utils.GetDecrypt(strAuthNumber).Split('|')[1]))
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "인증번호가 일치하지 않습니다.";
                return;
            }

            lo_ReqGoogleOTPKeyGen = new ReqGoogleOTPKeyGen()
            {
                Issuer    = SiteGlobal.GOOGLE_ISSUER,
                AccountID = strAuthAdminID,
                SecretKey = SiteGlobal.GOOGLE_SECRET_KEY,
                QrPixel   = 3

            };

            lo_ResGoogleOTPKeyGen = SiteGlobal.GoogleOtpKeyGen(lo_ReqGoogleOTPKeyGen);
                
            objResMap.RetCode = 0;
            objResMap.ErrMsg  = lo_ResGoogleOTPKeyGen.Header.ResultMessage;

            objResMap.Add("QrCodeSetupImageUrl", lo_ResGoogleOTPKeyGen.Payload.QrCodeSetupImageUrl);
        }
        catch (Exception lo_ex)
        {
            SiteGlobal.WriteLog(
                                "LoginHandler",
                                "Exception"
                              , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                9455);
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