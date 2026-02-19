<%@ WebHandler Language="C#" Class="SmsInsureHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : SmsInsureHandler.ashx
/// Description     : 알림톡 산재보험 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2023-07-31
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SmsInsureHandler : AshxSmsBaseHandler
{
    // 메소드 리스트
    private const string MethodParamChk         = "ParamChk";         //No 체크
    private const string MethodParamChkWithAuth = "ParamChkWithAuth"; //No 체크 + 인증정보
    private const string MethodAuthLogInfo      = "AuthLogInfo";      //본인인증 로그 조회
    private const string MethodAuthLogChk       = "AuthLogChk";       //본인인증 로그 체크
    private const string MethodInsureIns        = "InsureIns";        //개인정보 등록
    private const string MethodInsureUpd        = "InsureUpd";        //개인정보 수정

    CommonDasServices      objCommonDasServices      = new CommonDasServices();
    CarDispatchDasServices objCarDispatchDasServices = new CarDispatchDasServices();

    private string strCallType     = string.Empty;
    private string strNo           = string.Empty;
    private string strResCd        = string.Empty;
    private string strResMsg       = string.Empty;
    private string strEncCertData2 = string.Empty;
    private string strCertNo       = string.Empty;
    private string strDnHash       = string.Empty;
    private string strUpHash       = string.Empty;
    private string strVariUpHash   = string.Empty;
    private string strOrdrIdxx     = string.Empty;
    private string strName         = string.Empty;
    private string strPersonalNo   = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodParamChk,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodParamChkWithAuth, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAuthLogInfo,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAuthLogChk,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInsureIns,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInsureUpd,        MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SmsInsureHandler");
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
            strNo           = SiteGlobal.GetRequestForm("No");
            strResCd        = SiteGlobal.GetRequestForm("ResCd");
            strResMsg       = SiteGlobal.GetRequestForm("ResMsg");
            strEncCertData2 = SiteGlobal.GetRequestForm("EncCertData2", false);
            strCertNo       = SiteGlobal.GetRequestForm("CertNo",       false);
            strDnHash       = SiteGlobal.GetRequestForm("DnHash",       false);
            strUpHash       = SiteGlobal.GetRequestForm("UpHash",       false);
            strVariUpHash   = SiteGlobal.GetRequestForm("VariUpHash",   false);
            strOrdrIdxx     = SiteGlobal.GetRequestForm("OrdrIdxx",     false);
            strName         = SiteGlobal.GetRequestForm("Name");
            strPersonalNo   = SiteGlobal.GetRequestForm("PersonalNo");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
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
                case MethodParamChk:
                    GetParamChk();
                    break;
                case MethodParamChkWithAuth:
                    GetParamChkWithAuth();
                    break;
                case MethodAuthLogInfo:
                    GetAuthLogInfo();
                    break;
                case MethodAuthLogChk:
                    SetAuthLogChk();
                    break;
                case MethodInsureIns:
                    SetInsureIns();
                    break;
                case MethodInsureUpd:
                    SetInsureUpd();
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

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 파라메터 체크 
    /// </summary>
    protected void GetParamChk()
    {
        SmsInsureModel lo_objSmsInsureModel = null;
        string         lo_strDecNo          = string.Empty;
        string         lo_strEncNo          = string.Empty;
        DateTime       lo_objDateTime;
        TimeSpan       lo_objTimeDiff;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsInsureModel = JsonConvert.DeserializeObject<SmsInsureModel>(lo_strDecNo);

            if (lo_objSmsInsureModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            DateTime.TryParse(lo_objSmsInsureModel.TimeStamp, out lo_objDateTime);
            lo_objTimeDiff = DateTime.Now - lo_objDateTime;
            objResMap.Add("TimeOutFlag", lo_objTimeDiff.TotalDays > 7 ? "Y" : "N");

            lo_objSmsInsureModel.ChkPassFlag = "Y";
            lo_strEncNo                          = Utils.GetEncrypt(JsonConvert.SerializeObject(lo_objSmsInsureModel));
            objResMap.Add("No", lo_strEncNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파라메터 체크 + 인증
    /// </summary>
    protected void GetParamChkWithAuth()
    {
        SmsInsureModel                     lo_objSmsInsureModel      = null;
        string                             lo_strDecNo               = string.Empty;
        string                             lo_strEncNo               = string.Empty;
        ReqCarDriverDtlList                lo_objReqCarDriverDtlList = null;
        ServiceResult<ResCarDriverDtlList> lo_objResCarDriverDtlList = null;
        string                             lo_strExistsFlag          = "N";
        DataTable                          lo_objCenterPrivateInfo   = null;
        DateTime                           lo_objDateTime;
        TimeSpan                           lo_objTimeDiff;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsInsureModel = JsonConvert.DeserializeObject<SmsInsureModel>(lo_strDecNo);

            if (lo_objSmsInsureModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsInsureModel.ChkPassFlag = "Y";

            DateTime.TryParse(lo_objSmsInsureModel.TimeStamp, out lo_objDateTime);
            lo_objTimeDiff = DateTime.Now - lo_objDateTime;
            objResMap.Add("TimeOutFlag", lo_objTimeDiff.TotalDays > 7 ? "Y" : "N");

            if (lo_objTimeDiff.TotalDays > 7)
            {
                return;
            }

            objResMap.Add("ChkCertFlag", lo_objSmsInsureModel.ChkCertFlag);
            DateTime.TryParse(lo_objSmsInsureModel.ChkCertTimeStamp, out lo_objDateTime);
            lo_objTimeDiff = DateTime.Now - lo_objDateTime;
            objResMap.Add("CertTimeOutFlag", lo_objTimeDiff.TotalMinutes > 60 ? "Y" : "N");

            lo_strEncNo                          = Utils.GetEncrypt(JsonConvert.SerializeObject(lo_objSmsInsureModel));
            objResMap.Add("No",         lo_strEncNo);

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqCarDriverDtlList = new ReqCarDriverDtlList
            {
                CenterCode  = lo_objSmsInsureModel.CenterCode,
                DriverSeqNo = lo_objSmsInsureModel.DriverSeqNo
            };

            lo_objResCarDriverDtlList = objCarDispatchDasServices.GetCarDriverDtlList(lo_objReqCarDriverDtlList);

            objResMap.RetCode = lo_objResCarDriverDtlList.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarDriverDtlList.result.ErrorMsg;
                return;
            }

            if (lo_objResCarDriverDtlList.data.RecordCnt > 0)
            {
                lo_strExistsFlag = "Y";
                objResMap.Add("InformationDate", lo_objResCarDriverDtlList.data.list[0].InformationDate);
                objResMap.Add("AgreementDate",   lo_objResCarDriverDtlList.data.list[0].AgreementDate);
            }

            objResMap.Add("ExistsFlag",      lo_strExistsFlag);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9633;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objCenterPrivateInfo = Utils.GetCenterPrivateInfo(lo_objSmsInsureModel.CenterCode);
            
            if (lo_objCenterPrivateInfo == null)
            {
                objResMap.RetCode = 9633;
                objResMap.ErrMsg  = "담당자 정보 조회에 실패했습니다.";
                return;
            }
            
            objResMap.Add("CenterName",        lo_objCenterPrivateInfo.Rows[0]["CenterName"]);
            objResMap.Add("ChiefName",         lo_objCenterPrivateInfo.Rows[0]["ChiefName"]);
            objResMap.Add("ChiefPosition",     lo_objCenterPrivateInfo.Rows[0]["ChiefPosition"]);
            objResMap.Add("ChiefEmail",        lo_objCenterPrivateInfo.Rows[0]["ChiefEmail"]);
            objResMap.Add("ManagerName",       lo_objCenterPrivateInfo.Rows[0]["ManagerName"]);
            objResMap.Add("ManagerDepartment", lo_objCenterPrivateInfo.Rows[0]["ManagerDepartment"]);
            objResMap.Add("ManagerTelNo",      lo_objCenterPrivateInfo.Rows[0]["ManagerTelNo"]);
            objResMap.Add("ManagerEmail",      lo_objCenterPrivateInfo.Rows[0]["ManagerEmail"]);
            objResMap.Add("FromYMD",           lo_objCenterPrivateInfo.Rows[0]["FromYMD"]);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9634;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 실명 인증 로그 정보 조회
    /// </summary>
    protected void GetAuthLogInfo()
    {
        SmsInsureModel                    lo_objSmsInsureModel      = null;
        MobileAuthLogModel                lo_objReqGetMobileAuthLog = null;
        ServiceResult<MobileAuthLogModel> lo_objResGetMobileAuthLog = null;
        string                            lo_strDecNo               = string.Empty;
        Random                            lo_objRandom              = new Random();
        string                            lo_strOrderId             = string.Empty;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsInsureModel = JsonConvert.DeserializeObject<SmsInsureModel>(lo_strDecNo);

            if (lo_objSmsInsureModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqGetMobileAuthLog = new MobileAuthLogModel
            {
                MobileNo = lo_objSmsInsureModel.DriverCell,
                TryYMD   = DateTime.Now.ToString("yyyyMMdd")
            };

            lo_objResGetMobileAuthLog = objCommonDasServices.GetMobileAuthLog(lo_objReqGetMobileAuthLog);

            objResMap.RetCode = lo_objResGetMobileAuthLog.result.ErrorCode;
            objResMap.ErrMsg  = lo_objResGetMobileAuthLog.result.ErrorMsg;

            if (objResMap.RetCode.IsSuccess())
            {
                lo_strOrderId = DateTime.Now.ToString("yyyyMMddHHmmss") + lo_objRandom.Next(100000, 999999);
            }

            objResMap.Add("TryCnt",    lo_objResGetMobileAuthLog.data.TryCnt);
            objResMap.Add("TryYMD",    lo_objResGetMobileAuthLog.data.TryYMD);
            objResMap.Add("ordr_idxx", lo_strOrderId);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 실명 인증 로그 등록 및 기타 체크
    /// </summary>
    protected void SetAuthLogChk()
    {
        SmsInsureModel                     lo_objSmsInsureModel      = null;
        MobileAuthLogModel                 lo_objReqMobileAuthLogIns = null;
        ServiceResult<bool>                lo_objResMobileAuthLogIns = null;
        string                             lo_strDecNo               = string.Empty;
        string                             lo_strEncNo               = string.Empty;
        ct_cli_comLib.CTKCP                ct_cert                   = null;
        string                             lo_strVariString          = string.Empty;
        ReqCarDriverDtlList                lo_objReqCarDriverDtlList = null;
        ServiceResult<ResCarDriverDtlList> lo_objResCarDriverDtlList = null;
        string                             lo_strExistsFlag          = "N";

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strResCd) || string.IsNullOrWhiteSpace(strEncCertData2))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsInsureModel = JsonConvert.DeserializeObject<SmsInsureModel>(lo_strDecNo);

            if (lo_objSmsInsureModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9631;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqMobileAuthLogIns = new MobileAuthLogModel
            {
                MobileNo = lo_objSmsInsureModel.DriverCell,
                TryYMD   = DateTime.Now.ToString("yyyyMMdd")
            };

            lo_objResMobileAuthLogIns = objCommonDasServices.SetMobileAuthLogIns(lo_objReqMobileAuthLogIns);

            objResMap.RetCode = lo_objResMobileAuthLogIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResMobileAuthLogIns.result.ErrorMsg;
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9632;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqCarDriverDtlList = new ReqCarDriverDtlList
            {
                CenterCode  = lo_objSmsInsureModel.CenterCode,
                DriverSeqNo = lo_objSmsInsureModel.DriverSeqNo
            };

            lo_objResCarDriverDtlList = objCarDispatchDasServices.GetCarDriverDtlList(lo_objReqCarDriverDtlList);

            objResMap.RetCode = lo_objResCarDriverDtlList.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarDriverDtlList.result.ErrorMsg;
                return;
            }

            if (lo_objResCarDriverDtlList.data.RecordCnt > 0)
            {
                lo_strExistsFlag = "Y";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9633;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (!strResCd.Equals("0000"))
        {
            objResMap.RetCode = 9601;
            objResMap.ErrMsg  = strResMsg;
            return;
        }

        if (!strVariUpHash.Equals(strUpHash))
        {
            objResMap.RetCode = 9602;
            objResMap.ErrMsg  = "본인 인증 데이터에 위변조값이 발견되었습니다.(1)";
            return;
        }

        try
        {
            ct_cert = new ct_cli_comLib.CTKCP();

            // dn_hash 검증
            // KCP 가 리턴해 드리는 dn_hash 와 사이트 코드, 주문번호 , 인증번호를 검증하여
            // 해당 데이터의 위변조를 방지합니다
            lo_strVariString = SiteGlobal.M_KCP_AUTH_SITE_CD + strOrdrIdxx + strCertNo;

            if (ct_cert.lf_CT_CLI__check_valid_hash(SiteGlobal.M_KCP_AUTH_ENC_KEY, strDnHash, lo_strVariString).Equals("FAIL"))
            {
                objResMap.RetCode = 9603;
                objResMap.ErrMsg  = "본인 인증 데이터에 위변조값이 발견되었습니다.(2)";
                return;
            }

            ct_cert.lf_CT_CLI__decrypt_enc_cert(SiteGlobal.M_KCP_AUTH_ENC_KEY,  SiteGlobal.M_KCP_AUTH_SITE_CD, strCertNo, strEncCertData2); // 암호화 V2

            //if (!ct_cert.lf_CT_CLI__get_key_value("user_name").Equals(lo_objSmsInsureModel.DriverName))
            //{
            //    objResMap.RetCode = 9604;
            //    objResMap.ErrMsg  = "본인 인증 정보와 차주 정보가 일치하지 않습니다.(1)";
            //    return;
            //}

            if (!ct_cert.lf_CT_CLI__get_key_value("phone_no").Equals(lo_objSmsInsureModel.DriverCell))
            {
                objResMap.RetCode = 9605;
                objResMap.ErrMsg  = "본인 인증 정보와 차주 정보가 일치하지 않습니다.(1)";
                return;
            }

            lo_objSmsInsureModel.ChkCertFlag      = "Y";
            lo_objSmsInsureModel.ChkCertTimeStamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            lo_objSmsInsureModel.AuthName         = ct_cert.lf_CT_CLI__get_key_value("user_name");
            lo_objSmsInsureModel.CI               = HttpUtility.UrlDecode(ct_cert.lf_CT_CLI__get_key_value("ci_url"));
            lo_objSmsInsureModel.DI               = HttpUtility.UrlDecode(ct_cert.lf_CT_CLI__get_key_value("di_url"));
            lo_objSmsInsureModel.BirthDay         = ct_cert.lf_CT_CLI__get_key_value("birth_day");
            lo_objSmsInsureModel.SexCode          = ct_cert.lf_CT_CLI__get_key_value("sex_code");
            lo_strEncNo                           = Utils.GetEncrypt(JsonConvert.SerializeObject(lo_objSmsInsureModel));

            objResMap.Add("No",         lo_strEncNo);
            objResMap.Add("ExistsFlag", lo_strExistsFlag);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9634;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 개인정보 등록
    /// </summary>
    protected void SetInsureIns()
    {
        SmsInsureModel                     lo_objSmsInsureModel      = null;
        string                             lo_strDecNo               = string.Empty;
        ReqCarDriverDtlList                lo_objReqCarDriverDtlList = null;
        ServiceResult<ResCarDriverDtlList> lo_objResCarDriverDtlList = null;
        CarDriverDtlModel                  lo_objReqCarDriverDtlIns  = null;
        ServiceResult<CarDriverDtlModel>   lo_objResCarDriverDtlIns  = null;
        string                             lo_strEncNo               = string.Empty;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9931;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strName) || string.IsNullOrWhiteSpace(strPersonalNo))
        {
            objResMap.RetCode = 9932;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9933;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsInsureModel = JsonConvert.DeserializeObject<SmsInsureModel>(lo_strDecNo);

            if (lo_objSmsInsureModel == null)
            {
                objResMap.RetCode = 9934;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            if (!lo_objSmsInsureModel.ChkCertFlag.Equals("Y"))
            {
                objResMap.RetCode = 9935;
                objResMap.ErrMsg  = "휴대폰 본인인증 후 이용이 가능합니다.";
                return;
            }

            if (!lo_objSmsInsureModel.DriverName.Equals(strName))
            {
                objResMap.RetCode = 9936;
                objResMap.ErrMsg  = "입력한 정보와 차주 정보가 일치하지 않습니다.";
                return;
            }

            //if (!lo_objSmsInsureModel.BirthDay.Substring(2, 6).Equals(strPersonalNo.Substring(0, 6)))
            //{
            //    objResMap.RetCode = 9937;
            //    objResMap.ErrMsg  = "입력한 정보와 본인인증 정보가 일치하지 않습니다.(1)";
            //    return;
            //}

            //if (!(strPersonalNo.Substring(6, 1).ToInt() % lo_objSmsInsureModel.SexCode.ToInt()).Equals(0))
            //{
            //    objResMap.RetCode = 9938;
            //    objResMap.ErrMsg  = "입력한 정보와 본인인증 정보가 일치하지 않습니다.(2)";
            //    return;
            //}
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9939;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqCarDriverDtlList = new ReqCarDriverDtlList
            {
                CenterCode  = lo_objSmsInsureModel.CenterCode,
                DriverSeqNo = lo_objSmsInsureModel.DriverSeqNo
            };

            lo_objResCarDriverDtlList = objCarDispatchDasServices.GetCarDriverDtlList(lo_objReqCarDriverDtlList);

            objResMap.RetCode = lo_objResCarDriverDtlList.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarDriverDtlList.result.ErrorMsg;
                return;
            }

            if (lo_objResCarDriverDtlList.data.RecordCnt > 0)
            {
                objResMap.RetCode = 9940;
                objResMap.ErrMsg  = "이미 등록된 주민등록 정보가 있습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9941;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqCarDriverDtlIns = new CarDriverDtlModel
            {
                CenterCode      = lo_objSmsInsureModel.CenterCode,
                DriverSeqNo     = lo_objSmsInsureModel.DriverSeqNo,
                DriverName      = strName,
                DriverCell      = lo_objSmsInsureModel.DriverCell,
                EncPersonalNo   = Utils.GetEncrypt(strPersonalNo, SiteGlobal.AES2_ENC_IV_VALUE),
                AuthName        = lo_objSmsInsureModel.AuthName,
                CI              = lo_objSmsInsureModel.CI,
                DI              = lo_objSmsInsureModel.DI,
                InformationFlag = "Y",
                AgreementFlag   = "Y"
            };

            lo_objResCarDriverDtlIns = objCarDispatchDasServices.SetCarDriverDtlIns(lo_objReqCarDriverDtlIns);

            objResMap.RetCode = lo_objResCarDriverDtlIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarDriverDtlIns.result.ErrorMsg;
                return;
            }

            lo_strEncNo = Utils.GetEncrypt(JsonConvert.SerializeObject(lo_objSmsInsureModel));
            objResMap.Add("No", lo_strEncNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9940;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 개인정보 수정
    /// </summary>
    protected void SetInsureUpd()
    {
        SmsInsureModel                     lo_objSmsInsureModel      = null;
        string                             lo_strDecNo               = string.Empty;
        ReqCarDriverDtlList                lo_objReqCarDriverDtlList = null;
        ServiceResult<ResCarDriverDtlList> lo_objResCarDriverDtlList = null;
        CarDriverDtlModel                  lo_objReqCarDriverDtlIns  = null;
        ServiceResult<CarDriverDtlModel>   lo_objResCarDriverDtlIns  = null;
        string                             lo_strEncNo               = string.Empty;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9931;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strName) || string.IsNullOrWhiteSpace(strPersonalNo))
        {
            objResMap.RetCode = 9932;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9933;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsInsureModel = JsonConvert.DeserializeObject<SmsInsureModel>(lo_strDecNo);

            if (lo_objSmsInsureModel == null)
            {
                objResMap.RetCode = 9934;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            if (!lo_objSmsInsureModel.ChkCertFlag.Equals("Y"))
            {
                objResMap.RetCode = 9935;
                objResMap.ErrMsg  = "휴대폰 본인인증 후 이용이 가능합니다.";
                return;
            }

            if (!lo_objSmsInsureModel.DriverName.Equals(strName))
            {
                objResMap.RetCode = 9936;
                objResMap.ErrMsg  = "입력한 정보와 차주 정보가 일치하지 않습니다.";
                return;
            }

            //if (!lo_objSmsInsureModel.BirthDay.Substring(2, 6).Equals(strPersonalNo.Substring(0, 6)))
            //{
            //    objResMap.RetCode = 9937;
            //    objResMap.ErrMsg  = "입력한 정보와 본인인증 정보가 일치하지 않습니다.(1)";
            //    return;
            //}

            //if (!(strPersonalNo.Substring(6, 1).ToInt() % lo_objSmsInsureModel.SexCode.ToInt()).Equals(0))
            //{
            //    objResMap.RetCode = 9938;
            //    objResMap.ErrMsg  = "입력한 정보와 본인인증 정보가 일치하지 않습니다.(2)";
            //    return;
            //}
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9939;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqCarDriverDtlList = new ReqCarDriverDtlList
            {
                CenterCode  = lo_objSmsInsureModel.CenterCode,
                DriverSeqNo = lo_objSmsInsureModel.DriverSeqNo
            };

            lo_objResCarDriverDtlList = objCarDispatchDasServices.GetCarDriverDtlList(lo_objReqCarDriverDtlList);

            objResMap.RetCode = lo_objResCarDriverDtlList.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarDriverDtlList.result.ErrorMsg;
                return;
            }

            if (lo_objResCarDriverDtlList.data.RecordCnt.Equals(0))
            {
                objResMap.RetCode = 9940;
                objResMap.ErrMsg  = "등록된 주민등록 정보가 없습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9941;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqCarDriverDtlIns = new CarDriverDtlModel
            {
                CenterCode      = lo_objSmsInsureModel.CenterCode,
                DriverSeqNo     = lo_objSmsInsureModel.DriverSeqNo,
                DriverName      = strName,
                DriverCell      = lo_objSmsInsureModel.DriverCell,
                EncPersonalNo   = Utils.GetEncrypt(strPersonalNo, SiteGlobal.AES2_ENC_IV_VALUE),
                AuthName        = lo_objSmsInsureModel.AuthName,
                CI              = lo_objSmsInsureModel.CI,
                DI              = lo_objSmsInsureModel.DI,
                InformationFlag = "Y",
                AgreementFlag   = "Y"
            };

            lo_objResCarDriverDtlIns = objCarDispatchDasServices.SetCarDriverDtlIns(lo_objReqCarDriverDtlIns);

            objResMap.RetCode = lo_objResCarDriverDtlIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarDriverDtlIns.result.ErrorMsg;
                return;
            }

            lo_strEncNo = Utils.GetEncrypt(JsonConvert.SerializeObject(lo_objSmsInsureModel));
            objResMap.Add("No", lo_strEncNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9940;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsInsureHandler", "Exception",
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