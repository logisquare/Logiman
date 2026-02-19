<%@ WebHandler Language="C#" Class="AdminMyInfoHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;
    using Newtonsoft.Json;
///================================================================
/// <summary>
/// FileName        : AdminMyInfoHandler.ashx
/// Description     : 내정보 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jtoh@logislab.com, 2022-04-12
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class AdminMyInfoHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Admin/AdminMyInfo"; //필수

    // 메소드 리스트
    private const string MethodAdminMenuDelete   = "AdminMyInfoDelete";
    private const string MethodAdminMyInfoUpdate = "AdminMyInfoUpdate";
    private const string MethodUpdAdminPwd       = "UpdAdminPwd";
    private const string MethodUpdAuthMobileNo   = "UpdAuthMobileNo";
    private const string MethodCallSMSAuth       = "CallSMSAuth";
    private const string MethodAdminClientIns    = "AdminClientIns";
    private const string MethodAdminClientList   = "AdminClientList";
    private const string MethodAdminClientDel    = "AdminClientDel";
    private const string MethodClientSearchList  = "ClientSearchList";

    AdminDasServices objAdminDasServices         = new AdminDasServices();
    ClientDasServices objClientDasServices         = new ClientDasServices();

    private string strCallType      = string.Empty;

    private string strAdminID          = string.Empty;
    private string strMobileNo         = string.Empty;
    private string strDeptName         = string.Empty;
    private string strTelNo            = string.Empty;
    private string strNetwork24DDID    = string.Empty;
    private string strNetworkHMMID     = string.Empty;
    private string strNetworkOneCallID = string.Empty;
    private string strNetworkHmadangID = string.Empty;
    private string strEmail            = string.Empty;
    private string strUseFlag          = string.Empty;
    private string strAdminResetPwd    = string.Empty;
    private string strAdminPosition    = string.Empty;
    private string strHidAuthCode      = string.Empty;
    private string strSmsAuthNo        = string.Empty;
    private string strHidEncCode       = string.Empty;
    private string strOrgAdminPwd      = string.Empty;
    private string strCenterCode       = string.Empty;
    private string strClientCode       = string.Empty;
    private string strSeqNo            = string.Empty;
    private string strClientName       = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAdminMenuDelete,    MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminMyInfoUpdate,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodUpdAdminPwd,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodUpdAuthMobileNo,    MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCallSMSAuth,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminClientIns,     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminClientList,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAdminClientDel,     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientSearchList,   MenuAuthType.ReadWrite);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType = SiteGlobal.GetRequestForm("CallType");

            //1.Request
            GetData();
            if (!objResMap.RetCode.Equals(0))
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

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AdminMenuHandler");
        }
    }

    ///------------------------------
    /// <summary>
    /// 파라미터 데이터 설정
    /// </summary>
    ///------------------------------
    private void GetData()
    {
        try
        {
            // AdminMyInfo List
            strAdminID          = SiteGlobal.GetRequestForm("AdminID");
            strMobileNo         = SiteGlobal.GetRequestForm("MobileNo");
            strDeptName         = Utils.IsNull(SiteGlobal.GetRequestForm("DeptName"),         "");
            strTelNo            = Utils.IsNull(SiteGlobal.GetRequestForm("TelNo"),            "");
            strNetwork24DDID    = Utils.IsNull(SiteGlobal.GetRequestForm("Network24DDID"),    "");
            strNetworkHMMID     = Utils.IsNull(SiteGlobal.GetRequestForm("NetworkHMMID"),     "");
            strNetworkOneCallID = Utils.IsNull(SiteGlobal.GetRequestForm("NetworkOneCallID"), "");
            strNetworkHmadangID = Utils.IsNull(SiteGlobal.GetRequestForm("NetworkHmadangID"), "");
            strEmail            = Utils.IsNull(SiteGlobal.GetRequestForm("Email"),            "");
            strUseFlag          = SiteGlobal.GetRequestForm("UseFlag");
            strAdminResetPwd    = Utils.IsNull(SiteGlobal.GetRequestForm("AdminResetPwd"), "");
            strAdminPosition    = Utils.IsNull(SiteGlobal.GetRequestForm("AdminPosition"), "");
            strHidAuthCode      = Utils.IsNull(SiteGlobal.GetRequestForm("HidAuthCode"),   "");
            strSmsAuthNo        = Utils.IsNull(SiteGlobal.GetRequestForm("SmsAuthNo"),     "");
            strHidEncCode       = Utils.IsNull(SiteGlobal.GetRequestForm("HidEncCode"),    "");
            strOrgAdminPwd      = Utils.IsNull(SiteGlobal.GetRequestForm("OrgAdminPwd"),   "");
            strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),    "0");
            strClientCode       = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"),    "0");
            strSeqNo            = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),         "0");
            strClientName       = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"),    "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
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
                case MethodAdminMyInfoUpdate:
                    UpdAdminMyInfo();
                    break;
                case MethodAdminMenuDelete:
                    DelAdminMyInfo();
                    break;
                case MethodUpdAdminPwd:
                    UpdAdminPwd();
                    break;
                case MethodCallSMSAuth:
                    GetCallSMSAuth();
                    break;
                case MethodUpdAuthMobileNo:
                    UpdAuthMobileNo();
                    break;
                case MethodAdminClientIns:
                    AdminClientIns();
                    break;
                case MethodAdminClientList:
                    GetAdminClientList();
                    break;
                case MethodAdminClientDel:
                    GetAdminClientDel();
                    break;
                case MethodClientSearchList:
                    GetClientSearchList();
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

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process


    protected void UpdAdminMyInfo()
    {
        AdminViewModel      lo_objReqUpdAdminMyInfo = null;
        ServiceResult<bool> lo_objResUpdAdminMyInfo = null;

        try
        {
            lo_objReqUpdAdminMyInfo = new AdminViewModel
            {
                AdminID          = strAdminID,
                MobileNo         = strMobileNo,
                AdminPosition    = strAdminPosition,
                DeptName         = strDeptName,
                TelNo            = strTelNo,
                Network24DDID    = strNetwork24DDID,
                NetworkHMMID     = strNetworkHMMID,
                NetworkOneCallID = strNetworkOneCallID,
                NetworkHmadangID = strNetworkHmadangID,
                Email            = strEmail,
                UseFlag          = "Y",
            };

            lo_objResUpdAdminMyInfo = objAdminDasServices.UpdAdminMyInfo(lo_objReqUpdAdminMyInfo);
            objResMap.RetCode       = lo_objResUpdAdminMyInfo.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdAdminMyInfo.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }


    protected void DelAdminMyInfo()
    {
        AdminViewModel      lo_objReqDelAdminMyInfo = null;
        ServiceResult<bool> lo_objResDelAdminMyInfo = null;

        try
        {
            lo_objReqDelAdminMyInfo = new AdminViewModel
            {
                AdminID       = strAdminID,
                DeptName      = strDeptName,
                TelNo         = strTelNo,
                Network24DDID = strNetwork24DDID,
                NetworkHMMID  = strNetworkHMMID,
                Email         = strEmail,
                UseFlag       = "D",
            };

            lo_objResDelAdminMyInfo = objAdminDasServices.UpdAdminMyInfo(lo_objReqDelAdminMyInfo);
            objResMap.RetCode       = lo_objResDelAdminMyInfo.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResDelAdminMyInfo.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void UpdAdminPwd()
    {

        string              lo_strEncAdminResetPwd  = string.Empty;
        BCrypt              lo_objBCrypt            = new BCrypt();
        ServiceResult<bool> lo_objResDelAdminMyInfo = null;

        if (!lo_objBCrypt.CheckPassword(strOrgAdminPwd, strHidEncCode))
        {
            objResMap.RetCode = 9599;
            objResMap.ErrMsg = "현재 비밀번호가 일치하지 않습니다.";
            return;
        }

        try
        {
            lo_strEncAdminResetPwd = lo_objBCrypt.HashPassword(strAdminResetPwd, lo_objBCrypt.GenerateSaltByRandom());
            lo_objResDelAdminMyInfo = objAdminDasServices.UpdAdminPwd(strAdminID, lo_strEncAdminResetPwd, strAdminID, 1);
            objResMap.RetCode       = lo_objResDelAdminMyInfo.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResDelAdminMyInfo.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.RetCode = 9404;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
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
                objResMap.ErrMsg  = lo_objResponse.Header.ResultMessage;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            if (lo_objResponse?.Payload.EncSMSAuthNum != null)
            {
                objResMap.Add("EncSMSAuthNum", Utils.GetDecrypt(lo_objResponse.Payload.EncSMSAuthNum));
                objResMap.Add("receiptNum", Utils.GetEncrypt(lo_objResponse.Payload.receiptNum));
            }
        }
    }

    protected void UpdAuthMobileNo()
    {
        AdminViewModel      lo_objReqUpdAdminMyInfo = null;
        ServiceResult<bool> lo_objResUpdAdminMyInfo = null;
        if (!strSmsAuthNo.Equals(Utils.GetDecrypt(strHidAuthCode)))
        {
            objResMap.RetCode = 9555;
            objResMap.ErrMsg  = "인증번호가 일치하지 않습니다.";
            return;
        }

        try
        {
            lo_objReqUpdAdminMyInfo = new AdminViewModel
            {
                AdminID          = strAdminID,
                MobileNo         = strMobileNo,
                AdminPosition    = strAdminPosition,
                DeptName         = strDeptName,
                TelNo            = strTelNo,
                Network24DDID    = strNetwork24DDID,
                NetworkHMMID     = strNetworkHMMID,
                NetworkOneCallID = strNetworkOneCallID,
                NetworkHmadangID = strNetworkHmadangID,
                Email            = strEmail,
                UseFlag          = "Y",
            };

            lo_objResUpdAdminMyInfo = objAdminDasServices.UpdAdminMyInfo(lo_objReqUpdAdminMyInfo);
            objResMap.RetCode       = lo_objResUpdAdminMyInfo.result.ErrorCode;
            objResMap.Add("MobileNo", strMobileNo);

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdAdminMyInfo.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void AdminClientIns() {
        AdminViewModel      lo_objReqUpdAdminMyInfo = null;
        ServiceResult<bool> lo_objResUpdAdminMyInfo = null;
        if (!strSmsAuthNo.Equals(Utils.GetDecrypt(strCenterCode)))
        {
            objResMap.RetCode = 9601;
            objResMap.ErrMsg  = "필요한 정보가 없습니다.[회원사 코드]";
            return;
        }
        if (!strSmsAuthNo.Equals(Utils.GetDecrypt(strClientCode)))
        {
            objResMap.RetCode = 9602;
            objResMap.ErrMsg  = "필요한 정보가 없습니다.[고객사 코드]";
            return;
        }

        try
        {
            lo_objReqUpdAdminMyInfo = new AdminViewModel
            {
                CenterCode    = strCenterCode.ToInt(),
                ClientCode    = strClientCode.ToInt(),
                AdminID       = objSes.AdminID
            };

            lo_objResUpdAdminMyInfo = objAdminDasServices.InsAdminClient(lo_objReqUpdAdminMyInfo);
            objResMap.RetCode       = lo_objResUpdAdminMyInfo.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdAdminMyInfo.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetAdminClientList() { 
        ReqAdminList                lo_objReqAdminClientList = null;
        ServiceResult<ResAdminList> lo_objResAdminClientList = null;


        try
        {
            lo_objReqAdminClientList = new ReqAdminList
            {
                CenterCode    = strCenterCode.ToInt(),
                ClientCode    = strClientCode.ToInt(),
                AdminID       = objSes.AdminID,
                UseFlag       = "Y"
            };

            lo_objResAdminClientList = objAdminDasServices.GetAdminClientList(lo_objReqAdminClientList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResAdminClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9505;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }    
    }

    protected void GetAdminClientDel() {
        AdminViewModel      lo_objReqUpdAdminMyInfo = null;
        ServiceResult<bool> lo_objResUpdAdminMyInfo = null;
        if (!strSmsAuthNo.Equals(Utils.GetDecrypt(strSeqNo)))
        {
            objResMap.RetCode = 9702;
            objResMap.ErrMsg  = "필요한 정보가 없습니다.[고객사 일련번호]";
            return;
        }

        try
        {
            lo_objReqUpdAdminMyInfo = new AdminViewModel
            {
                SeqNo         = strSeqNo.ToInt(),
                UseFlag       = "N",
                AdminID       = objSes.AdminID
            };

            lo_objResUpdAdminMyInfo = objAdminDasServices.UpdAdminClient(lo_objReqUpdAdminMyInfo);
            objResMap.RetCode       = lo_objResUpdAdminMyInfo.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdAdminMyInfo.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 목록
    /// </summary>
    protected void GetClientSearchList()
    {
        ReqClientSearchList                lo_objReqClientList = null;
        ServiceResult<ResClientSearchList> lo_objResClientList = null;

        try
        {
            lo_objReqClientList = new ReqClientSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientName       = strClientName,
                ClientFlag       = "Y",
                ChargeFlag       = "N",
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResClientList   = objClientDasServices.GetClientSearchList(lo_objReqClientList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9608;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMyInfoHandler", "Exception",
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