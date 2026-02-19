<%@ WebHandler Language="C#" Class="SmsCommonHandler" %>
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
/// FileName        : SmsCommonHandler.ashx
/// Description     : 알림톡 일반  Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-30
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SmsCommonHandler : AshxSmsBaseHandler
{
    // 메소드 리스트
    private const string MethodParamChk               = "ParamChk";               //No 체크
    private const string MethodCorpNoChk              = "CorpNoChk";              //사업자번호 체크
    private const string MethodSmsPurchaseClosingList = "SmsPurchaseClosingList"; //매입마감 목록
    private const string MethodUpdAgreement           = "UpdAgreement";           //회원가입

    SmsDasServices objSmsDasServices = new SmsDasServices();

    private string strCallType = string.Empty;
    private int    intPageSize = 0;
    private int    intPageNo   = 0;
    private string strDateType = string.Empty;
    private string strDateFrom = string.Empty;
    private string strDateTo   = string.Empty;
    private string strNo       = string.Empty;
    private string strCorpNo1  = string.Empty;
    private string strCorpNo2  = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodParamChk,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCorpNoChk,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSmsPurchaseClosingList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodUpdAgreement,           MenuAuthType.ReadWrite);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType = SiteGlobal.GetRequestForm("CallType");
            intPageSize = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo   = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

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

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SmsCommonHandler");
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
            strDateType = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "0");
            strDateFrom = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo   = SiteGlobal.GetRequestForm("DateTo");
            strNo       = SiteGlobal.GetRequestForm("No");
            strCorpNo1  = SiteGlobal.GetRequestForm("CorpNo1");
            strCorpNo2  = SiteGlobal.GetRequestForm("CorpNo2");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
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
                case MethodCorpNoChk:
                    GetCorpNoChk();
                    break;
                case MethodSmsPurchaseClosingList:
                    GetSmsPurchaseClosingList();
                    break;
                case MethodUpdAgreement:
                    SetUpdAgreement();
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

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
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
        SmsPayModel lo_objSmsPayModel = null;
        string      lo_strDecNo       = string.Empty;
        DateTime    lo_objDateTime;
        TimeSpan    lo_objTimeDiff;

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

            lo_objSmsPayModel = JsonConvert.DeserializeObject<SmsPayModel>(lo_strDecNo);

            if (lo_objSmsPayModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            objResMap.Add("CorpNoChkPassFlag", lo_objSmsPayModel.CorpNoChkPassFlag);
            objResMap.Add("ComCorpNoPart",     lo_objSmsPayModel.ComCorpNo.Substring(0, 8));
            objResMap.Add("ComCorpNoChkFlag",  lo_objSmsPayModel.ComCorpNoChkFlag);
            
            DateTime.TryParse(lo_objSmsPayModel.TimeStamp, out lo_objDateTime);
            lo_objTimeDiff = DateTime.Now - lo_objDateTime;
            objResMap.Add("ComCorpNoChkTimeOutFlag", lo_objTimeDiff.TotalMinutes > 60 ? "Y" : "N");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 사업자번호 체크
    /// </summary>
    protected void GetCorpNoChk()
    {
        SmsPayModel lo_objSmsPayModel = null;
        string      lo_strDecNo       = string.Empty;
        string      lo_strEncNo       = string.Empty;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCorpNo1) || string.IsNullOrWhiteSpace(strCorpNo2))
        {
            objResMap.RetCode = 9002;
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

            lo_objSmsPayModel = JsonConvert.DeserializeObject<SmsPayModel>(lo_strDecNo);

            if (lo_objSmsPayModel == null)
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            if (!lo_objSmsPayModel.ComCorpNo.Substring(8, 1).Equals(strCorpNo1) || !lo_objSmsPayModel.ComCorpNo.Substring(9, 1).Equals(strCorpNo2))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "사업자번호가 올바르지 않습니다.";
                return;
            }

            lo_objSmsPayModel.ComCorpNoChkFlag = "Y";
            lo_objSmsPayModel.TimeStamp        = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            lo_strEncNo = Utils.GetEncrypt(JsonConvert.SerializeObject(lo_objSmsPayModel));

            objResMap.Add("No", lo_strEncNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감 목록
    /// </summary>
    protected void GetSmsPurchaseClosingList()
    {
        SmsPayModel                              lo_objSmsPayModel               = null;
        ReqSmsPurchaseClosingList                lo_objReqSmsPurchaseClosingList = null;
        ServiceResult<ResSmsPurchaseClosingList> lo_objResSmsPurchaseClosingList = null;
        string                                   lo_strCenterCode                = string.Empty;
        string                                   lo_strPurchaseClosingSeqNo      = string.Empty;
        string                                   lo_strComCorpNo                 = string.Empty;
        string                                   lo_strDecNo                     = string.Empty;

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

            lo_objSmsPayModel = JsonConvert.DeserializeObject<SmsPayModel>(lo_strDecNo);

            if (lo_objSmsPayModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            if (!lo_objSmsPayModel.CorpNoChkPassFlag.Equals("Y"))
            {
                if (!lo_objSmsPayModel.ComCorpNoChkFlag.Equals("Y"))
                {
                    objResMap.RetCode = 9004;
                    objResMap.ErrMsg  = "사업자번호 체크 후 이용할 수 있습니다.";
                    return;
                }
            }

            lo_strCenterCode           = Utils.IsNull(lo_objSmsPayModel.CenterCode.ToString(), "0");
            lo_strPurchaseClosingSeqNo = Utils.IsNull(lo_objSmsPayModel.PurchaseClosingSeqNo.ToString(), "0");
            lo_strComCorpNo            = Utils.IsNull(lo_objSmsPayModel.ComCorpNo,                       string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (string.IsNullOrWhiteSpace(lo_strCenterCode) || lo_strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(lo_strPurchaseClosingSeqNo) || lo_strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(lo_strComCorpNo))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSmsPurchaseClosingList = new ReqSmsPurchaseClosingList
            {
                PurchaseClosingSeqNo = lo_strPurchaseClosingSeqNo.ToInt64(),
                CenterCode           = lo_strCenterCode.ToInt(),
                DateType             = strDateType.ToInt(),
                DateFrom             = strDateFrom,
                DateTo               = strDateTo,
                ComCorpNo            = lo_strComCorpNo,
                PageSize             = intPageSize,
                PageNo               = intPageNo
            };

            lo_objResSmsPurchaseClosingList = objSmsDasServices.GetSmsPurchaseClosingList(lo_objReqSmsPurchaseClosingList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResSmsPurchaseClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 회원가입
    /// </summary>
    protected void SetUpdAgreement()
    {
        SmsPayModel         lo_objSmsPayModel         = null;
        ReqGetCardAgreeInfo lo_objReqGetCardAgreeInfo = null;
        ResGetCardAgreeInfo lo_objResGetCardAgreeInfo = null;
        ReqUpdCardAgreeInfo lo_objReqUpdCardAgreeInfo = null;
        ResUpdCardAgreeInfo lo_objResUpdCardAgreeInfo = null;

        string              lo_strDecNo               = string.Empty;

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

            lo_objSmsPayModel = JsonConvert.DeserializeObject<SmsPayModel>(lo_strDecNo);

            if (lo_objSmsPayModel == null)
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

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqGetCardAgreeInfo = new ReqGetCardAgreeInfo
            {
                CorpNo = lo_objSmsPayModel.ComCorpNo
            };

            lo_objResGetCardAgreeInfo = SiteGlobal.GetCardAgreeInfo(lo_objReqGetCardAgreeInfo);

            if (lo_objResGetCardAgreeInfo.Header.ResultCode.IsFail())
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "카드결제 동의정보 조회에 실패했습니다.(API)";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (lo_objResGetCardAgreeInfo.Payload.ExistsFlag.Equals("Y"))
        {
            objResMap.RetCode = 0;
            objResMap.ErrMsg  = "사용자 인증이 완료되었습니다.";
            return;
        }

        try
        {
            lo_objReqUpdCardAgreeInfo = new ReqUpdCardAgreeInfo
            {
                CenterCode    = lo_objSmsPayModel.CenterCode,
                CorpNo        = lo_objSmsPayModel.ComCorpNo,
                AuthTel       = lo_objSmsPayModel.DriverCell,
                CardAgreeFlag = lo_objResGetCardAgreeInfo.Payload.CardAgreeFlag
            };

            lo_objResUpdCardAgreeInfo = SiteGlobal.UpdCardAgreeInfo(lo_objReqUpdCardAgreeInfo);

            objResMap.RetCode = lo_objResUpdCardAgreeInfo.Header.ResultCode;

            if (lo_objResUpdCardAgreeInfo.Header.ResultCode.IsFail())
            {
                objResMap.ErrMsg = "사용자 인증에 실패했습니다.";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsCommonHandler", "Exception",
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