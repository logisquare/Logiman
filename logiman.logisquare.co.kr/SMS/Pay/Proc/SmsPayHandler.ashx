<%@ WebHandler Language="C#" Class="SmsPayHandler" %>
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
/// FileName        : SmsPayHandler.ashx
/// Description     : 알림톡 빠른입금  Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-30
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SmsPayHandler : AshxSmsBaseHandler
{
    // 메소드 리스트
    private const string MethodParamChk               = "ParamChk";               //No 체크
    private const string MethodParamChkWithJoin       = "ParamChkWithJoin";       //No 체크
    private const string MethodCorpNoChk              = "CorpNoChk";              //사업자번호 체크
    private const string MethodSmsPurchaseClosingList = "SmsPurchaseClosingList"; //매입마감 목록
    private const string MethodCenterSendFeeD         = "CenterSendFeeD";         //수수료정보
    private const string MethodInsOrderTms            = "InsOrderTms";            //빠른입금신청
    private const string MethodCenterOrder            = "CenterOrder";            //빠른입금신청
    private const string MethodEventAvailCheck        = "EventAvailCheck";        //이벤트대상체크

    SmsDasServices      objSmsDasServices      = new SmsDasServices();
    PurchaseDasServices objPurchaseDasServices = new PurchaseDasServices();

    private string strCallType       = string.Empty;
    private int    intPageSize       = 0;
    private int    intPageNo         = 0;
    private string strDateType       = string.Empty;
    private string strDateFrom       = string.Empty;
    private string strDateTo         = string.Empty;
    private string strNo             = string.Empty;
    private string strCorpNo1        = string.Empty;
    private string strCorpNo2        = string.Empty;
    private string strSendPlanYMD    = string.Empty;
    private string strSendAmt        = string.Empty;
    private string strCooperatorFlag = string.Empty;
    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodParamChk,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodParamChkWithJoin,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCorpNoChk,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSmsPurchaseClosingList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCenterSendFeeD,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInsOrderTms,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCenterOrder,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodEventAvailCheck,        MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SmsPayHandler");
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
            strDateType       = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom       = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo         = SiteGlobal.GetRequestForm("DateTo");
            strNo             = SiteGlobal.GetRequestForm("No");
            strCorpNo1        = SiteGlobal.GetRequestForm("CorpNo1");
            strCorpNo2        = SiteGlobal.GetRequestForm("CorpNo2");
            strSendPlanYMD    = SiteGlobal.GetRequestForm("SendPlanYMD");
            strSendAmt        = Utils.IsNull(SiteGlobal.GetRequestForm("SendAmt"), "0");
            strCooperatorFlag = Utils.IsNull(SiteGlobal.GetRequestForm("CooperatorFlag"), "N");
            strDateFrom       = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo         = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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
                case MethodParamChkWithJoin:
                    GetParamChkWithJoin();
                    break;
                case MethodCorpNoChk:
                    GetCorpNoChk();
                    break;
                case MethodSmsPurchaseClosingList:
                    GetSmsPurchaseClosingList();
                    break;
                case MethodCenterSendFeeD:
                    GetCenterSendFeeD();
                    break;
                case MethodInsOrderTms:
                    SetInsOrderTms();
                    break;
                case MethodCenterOrder:
                    GetCenterOrder();
                    break;
                case MethodEventAvailCheck:
                    GetEventAvailCheck();
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

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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

            objResMap.Add("ComCorpNoPart",    lo_objSmsPayModel.ComCorpNo.Substring(0, 8));
            objResMap.Add("ComCorpNoChkFlag", lo_objSmsPayModel.ComCorpNoChkFlag);
            objResMap.Add("DriverName",       lo_objSmsPayModel.DriverName);
            objResMap.Add("DriverCell",       lo_objSmsPayModel.DriverCell);
            
            DateTime.TryParse(lo_objSmsPayModel.TimeStamp, out lo_objDateTime);
            lo_objTimeDiff = DateTime.Now - lo_objDateTime;
            objResMap.Add("ComCorpNoChkTimeOutFlag", lo_objTimeDiff.TotalMinutes > 60 ? "Y" : "N");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파라메터 체크 + 가입체크
    /// </summary>
    protected void GetParamChkWithJoin()
    {
        SmsPayModel         lo_objSmsPayModel         = null;
        ReqGetCardAgreeInfo lo_objReqGetCardAgreeInfo = null;
        ResGetCardAgreeInfo lo_objResGetCardAgreeInfo = null;
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

            objResMap.Add("ComCorpNoPart",    lo_objSmsPayModel.ComCorpNo.Substring(0, 8));
            objResMap.Add("ComCorpNoChkFlag", lo_objSmsPayModel.ComCorpNoChkFlag);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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

            objResMap.Add("CardAgreeExists", lo_objResGetCardAgreeInfo.Payload.ExistsFlag);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 사업자번호 & 가입 체크
    /// </summary>
    protected void GetCorpNoChkWithJoin()
    {
        SmsPayModel         lo_objSmsPayModel         = null;
        ReqGetCardAgreeInfo lo_objReqGetCardAgreeInfo = null;
        ResGetCardAgreeInfo lo_objResGetCardAgreeInfo = null;
        string              lo_strDecNo               = string.Empty;
        string              lo_strEncNo               = string.Empty;

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

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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

            objResMap.Add("CardAgreeExists", lo_objResGetCardAgreeInfo.Payload.ExistsFlag);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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

            if (!lo_objSmsPayModel.ComCorpNoChkFlag.Equals("Y"))
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "사업자번호 체크 후 이용할 수 있습니다.";
                return;
            }

            lo_strCenterCode           = Utils.IsNull(lo_objSmsPayModel.CenterCode.ToString(), "0");
            lo_strPurchaseClosingSeqNo = Utils.IsNull(lo_objSmsPayModel.PurchaseClosingSeqNo.ToString(), "0");
            lo_strComCorpNo            = Utils.IsNull(lo_objSmsPayModel.ComCorpNo,                       string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 전표 수수료 체크
    /// </summary>
    protected void GetCenterSendFeeD()
    {
        SmsPayModel          lo_objSmsPayModel          = null;
        ReqGetCenterSendFeeD lo_objReqGetCenterSendFeeD = null;
        ResGetCenterSendFeeD lo_objResGetCenterSendFeeD = null;
        string               lo_strDecNo                = string.Empty;
        string               lo_strCenterCode           = string.Empty;
        string               lo_strDriverCell           = string.Empty;
        string               lo_strDriverName           = string.Empty;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSendPlanYMD))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSendAmt))
        {
            objResMap.RetCode = 9003;
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

            if (!lo_objSmsPayModel.ComCorpNoChkFlag.Equals("Y"))
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "사업자번호 체크 후 이용할 수 있습니다.";
                return;
            }

            lo_strCenterCode = Utils.IsNull(lo_objSmsPayModel.CenterCode.ToString(), "0");
            lo_strDriverCell = lo_objSmsPayModel.DriverCell;
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (string.IsNullOrWhiteSpace(lo_strCenterCode) || lo_strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqGetCenterSendFeeD = new ReqGetCenterSendFeeD
            {
                CenterCode = lo_strCenterCode.ToInt(),
                CarDriCell = lo_strDriverCell,
                PayAmt     = strSendAmt.ToDouble(),
                PayYMD     = strSendPlanYMD,
                ExcludeVat = "N"
            };

            lo_objResGetCenterSendFeeD = SiteGlobal.GetCenterSendFeeD(lo_objReqGetCenterSendFeeD);

            objResMap.RetCode = lo_objResGetCenterSendFeeD.Header.ResultCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg  = "수수료 정보 조회에 실패했습니다.(API)";
                return;
            }
            objResMap.Add("FeeRate", strCooperatorFlag.Equals("Y") ? lo_objResGetCenterSendFeeD.Payload.SendFeeRatePartner : lo_objResGetCenterSendFeeD.Payload.SendFeeRateNormal);
            objResMap.Add("Fee", strCooperatorFlag.Equals("Y") ? lo_objResGetCenterSendFeeD.Payload.SendFeePartner : lo_objResGetCenterSendFeeD.Payload.SendFeeNormal);
            objResMap.Add("Amt", strCooperatorFlag.Equals("Y") ? lo_objResGetCenterSendFeeD.Payload.SendAmtPartner : lo_objResGetCenterSendFeeD.Payload.SendAmtNormal);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

    }

    /// <summary>
    /// 빠른입금 신청
    /// </summary>
    protected void SetInsOrderTms()
    {
        SmsPayModel                              lo_objSmsPayModel                   = null;
        ReqSmsPurchaseClosingList                lo_objReqSmsPurchaseClosingList     = null;
        ServiceResult<ResSmsPurchaseClosingList> lo_objResSmsPurchaseClosingList     = null;
        SmsPurchaseClosingGridModel              lo_objSmsPurchaseClosingGridModel   = null;
        ReqGetCenterOrderChk                     lo_objReqGetCenterOrderChk          = null;
        ResGetCenterOrderChk                     lo_objResGetCenterOrderChk          = null;
        ReqInsOrderTMS                           lo_objReqInsOrderTMS                = null;
        ResInsOrderTMS                           lo_objResInsOrderTMS                = null;
        ReqUpdOrderDirect                        lo_objReqUpdOrderDirect             = null;
        ResUpdOrderDirect                        lo_objResUpdOrderDirect             = null;
        ReqPurchaseClosingSendInfoUpd            lo_objReqPurchaseClosingSendInfoUpd = null;
        ServiceResult<bool>                      lo_objResPurchaseClosingSendInfoUpd = null;
        string                                   lo_strDecNo                         = string.Empty;
        string                                   lo_strCenterCode                    = string.Empty;
        string                                   lo_strPurchaseClosingSeqNo          = string.Empty;
        string                                   lo_strComCorpNo                     = string.Empty;
        string                                   lo_strCargopayExistsFlag            = "N";


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

            if (!lo_objSmsPayModel.ComCorpNoChkFlag.Equals("Y"))
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "사업자번호 체크 후 이용할 수 있습니다.";
                return;
            }

            lo_strCenterCode           = Utils.IsNull(lo_objSmsPayModel.CenterCode.ToString(), "0");
            lo_strPurchaseClosingSeqNo = Utils.IsNull(lo_objSmsPayModel.PurchaseClosingSeqNo.ToString(), "0");
            lo_strComCorpNo            = Utils.IsNull(lo_objSmsPayModel.ComCorpNo,                       string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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

            objResMap.RetCode = lo_objResSmsPurchaseClosingList.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSmsPurchaseClosingList.result.ErrorMsg;
                return;
            }

            if (!lo_objResSmsPurchaseClosingList.data.RecordCnt.Equals(1))
            {
                objResMap.ErrMsg = "전표정보 조회에 실패했습니다.";
                return;
            }

            lo_objSmsPurchaseClosingGridModel = lo_objResSmsPurchaseClosingList.data.list[0];

            if (lo_objSmsPurchaseClosingGridModel == null)
            {
                objResMap.RetCode = 9100;
                objResMap.ErrMsg  = "전표정보 조회에 실패했습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqGetCenterOrderChk = new ReqGetCenterOrderChk
            {
                CenterCode   = lo_objSmsPurchaseClosingGridModel.CenterCode,
                ClosingSeqNo = lo_objSmsPurchaseClosingGridModel.PurchaseClosingSeqNo
            };

            lo_objResGetCenterOrderChk = SiteGlobal.GetCenterOrderChk(lo_objReqGetCenterOrderChk);
            objResMap.RetCode          = lo_objResGetCenterOrderChk.Header.ResultCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResGetCenterOrderChk.Header.ResultMessage;
                return;
            }

            if (!(lo_objResGetCenterOrderChk.Payload.PaySendType.Equals(1) || lo_objResGetCenterOrderChk.Payload.PaySendType.Equals(0)))
            {
                objResMap.RetCode = 9100;
                objResMap.ErrMsg  = "빠른입금을 신청할 수 없습니다.";
                return;
            }

            lo_strCargopayExistsFlag = lo_objResGetCenterOrderChk.Payload.ExistsFlag;
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        //송금처리
        try
        {
            if (!lo_strCargopayExistsFlag.Equals("Y"))
            {
                lo_objReqInsOrderTMS = new ReqInsOrderTMS
                {
                    CenterCode   = lo_objSmsPurchaseClosingGridModel.CenterCode,
                    SendCost     = lo_objSmsPurchaseClosingGridModel.SendAmt,
                    SupplyCost   = lo_objSmsPurchaseClosingGridModel.SupplyAmt,
                    TaxCost      = lo_objSmsPurchaseClosingGridModel.TaxAmt,
                    PayWay       = 2, // 지불방법 (1:일반결제, 2:빠른입금 (차), 3:빠른입금(운))
                    CarPay       = lo_objSmsPurchaseClosingGridModel.OrgAmt,
                    CarName      = lo_objSmsPurchaseClosingGridModel.ComName,
                    CarBizNo     = lo_objSmsPurchaseClosingGridModel.ComCorpNo,
                    CarCeo       = lo_objSmsPurchaseClosingGridModel.ComCeoName,
                    CarBankCode  = lo_objSmsPurchaseClosingGridModel.BankCode,
                    CarBankName  = lo_objSmsPurchaseClosingGridModel.BankName,
                    CarAcctName  = lo_objSmsPurchaseClosingGridModel.AcctName,
                    CarAcctNo    = Utils.GetDecrypt(lo_objSmsPurchaseClosingGridModel.EncAcctNo),
                    CarNo        = lo_objSmsPurchaseClosingGridModel.CarNo,
                    CarDriName   = lo_objSmsPurchaseClosingGridModel.DriverName,
                    CarDriCell   = lo_objSmsPurchaseClosingGridModel.DriverCell,
                    TaxReceive   = "Y", //계산서 수신여부 (Y/N), 미입력시 Y
                    ClosingSeqNo = lo_objSmsPurchaseClosingGridModel.PurchaseClosingSeqNo,
                    IssueDate    = lo_objSmsPurchaseClosingGridModel.BillWrite,
                    PayPlanDate  = lo_objSmsPurchaseClosingGridModel.SendPlanYMD,
                    PartnerFlag  = lo_objSmsPurchaseClosingGridModel.CooperatorFlag,
                    PayKind      = 1, //송금유형상세 (1:일반,4:포인트사용)
                    UsedPoint    = 0,
                    Note         = "로지맨 빠른입금(차) - 알림톡"
                };

                lo_objResInsOrderTMS = SiteGlobal.InsOrderTMS(lo_objReqInsOrderTMS);
                objResMap.RetCode    = lo_objResInsOrderTMS.Header.ResultCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = lo_objResInsOrderTMS.Header.ResultMessage;
                    return;
                }
            }
            else
            {
                lo_objReqUpdOrderDirect = new ReqUpdOrderDirect
                {
                    CenterCode   = lo_objSmsPurchaseClosingGridModel.CenterCode,
                    ClosingSeqNo = lo_objSmsPurchaseClosingGridModel.PurchaseClosingSeqNo,
                    PartnerFlag  = lo_objSmsPurchaseClosingGridModel.CooperatorFlag,
                    CarDriCell   = lo_objSmsPurchaseClosingGridModel.DriverCell,
                    PayKind      = 1, //송금유형상세 (1:일반,4:포인트사용)
                    UsedPoint    = 0,
                    ReconcAmt    = lo_objSmsPurchaseClosingGridModel.SendAmt
                };

                lo_objResUpdOrderDirect = SiteGlobal.UpdOrderDirect(lo_objReqUpdOrderDirect);
                objResMap.RetCode       = lo_objResUpdOrderDirect.Header.ResultCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = lo_objResUpdOrderDirect.Header.ResultMessage;
                    return;
                }
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        //송금정보 업데이트
        try
        {
            lo_objReqPurchaseClosingSendInfoUpd = new ReqPurchaseClosingSendInfoUpd
            {
                CenterCode           = lo_objSmsPurchaseClosingGridModel.CenterCode,
                PurchaseClosingSeqNo = lo_objSmsPurchaseClosingGridModel.PurchaseClosingSeqNo,
                SendStatus           = 2, //송금 상태 (1: 미송금, 2 :송금신청. 3: 송금완료) 
                SendType             = 3,//결제 유형(1 : 미선택, 2:일반입금, 3: 빠른입금(차), 4:빠른입금(운) - 바로지급, 5:빠른입금(운) - 14일지급, 6:수기송금, 7 : 카드결제)
                ReqYMD               = lo_objSmsPurchaseClosingGridModel.SendPlanYMD,
                ChkPermFlag          = "N",
                SendAdminID          = "SMS",
                SendAdminName        = "SMS"
            };

            lo_objResPurchaseClosingSendInfoUpd = objPurchaseDasServices.SetPurchaseClosingSendInfoUpd(lo_objReqPurchaseClosingSendInfoUpd);
            objResMap.RetCode       = lo_objResPurchaseClosingSendInfoUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = "카고페이 송금신청은 완료되었으나, 송금상태 업데이트에 실패했습니다.";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    protected void GetCenterOrder()
    {
        SmsPayModel                              lo_objSmsPayModel                 = null;
        ReqSmsPurchaseClosingList                lo_objReqSmsPurchaseClosingList   = null;
        ServiceResult<ResSmsPurchaseClosingList> lo_objResSmsPurchaseClosingList   = null;
        SmsPurchaseClosingGridModel              lo_objSmsPurchaseClosingGridModel = null;
        ReqGetCenterOrderChk                     lo_objReqGetCenterOrderChk        = null;
        ResGetCenterOrderChk                     lo_objResGetCenterOrderChk        = null;
        string                                   lo_strDecNo                       = string.Empty;
        string                                   lo_strCenterCode                  = string.Empty;
        string                                   lo_strPurchaseClosingSeqNo        = string.Empty;
        string                                   lo_strComCorpNo                   = string.Empty;
        
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

            if (!lo_objSmsPayModel.ComCorpNoChkFlag.Equals("Y"))
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "사업자번호 체크 후 이용할 수 있습니다.";
                return;
            }

            lo_strCenterCode           = Utils.IsNull(lo_objSmsPayModel.CenterCode.ToString(),           "0");
            lo_strPurchaseClosingSeqNo = Utils.IsNull(lo_objSmsPayModel.PurchaseClosingSeqNo.ToString(), "0");
            lo_strComCorpNo            = Utils.IsNull(lo_objSmsPayModel.ComCorpNo, string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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
            objResMap.RetCode = 9006;
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

            objResMap.RetCode = lo_objResSmsPurchaseClosingList.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSmsPurchaseClosingList.result.ErrorMsg;
                return;
            }

            if (!lo_objResSmsPurchaseClosingList.data.RecordCnt.Equals(1))
            {
                objResMap.ErrMsg = "전표정보 조회에 실패했습니다.";
                return;
            }

            lo_objSmsPurchaseClosingGridModel = lo_objResSmsPurchaseClosingList.data.list[0];

            if (lo_objSmsPurchaseClosingGridModel == null)
            {
                objResMap.RetCode = 9100;
                objResMap.ErrMsg  = "전표정보 조회에 실패했습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqGetCenterOrderChk = new ReqGetCenterOrderChk
            {
                CenterCode   = lo_objSmsPurchaseClosingGridModel.CenterCode,
                ClosingSeqNo = lo_objSmsPurchaseClosingGridModel.PurchaseClosingSeqNo.ToString()
            };

            lo_objResGetCenterOrderChk = SiteGlobal.GetCenterOrderChk(lo_objReqGetCenterOrderChk);
            objResMap.RetCode          = lo_objResGetCenterOrderChk.Header.ResultCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResGetCenterOrderChk.Header.ResultMessage;
                return;
            }
            
            objResMap.Add("ExistsFlag",      lo_objResGetCenterOrderChk.Payload.ExistsFlag);
            objResMap.Add("PaySendType",     lo_objResGetCenterOrderChk.Payload.PaySendType);
            objResMap.Add("OrgPayYmd",       lo_objResGetCenterOrderChk.Payload.OrgPayYmd);
            objResMap.Add("PayYmd",          lo_objResGetCenterOrderChk.Payload.PayYmd);
            objResMap.Add("SendYmd",         lo_objResGetCenterOrderChk.Payload.SendYmd);
            objResMap.Add("SendFee",         lo_objResGetCenterOrderChk.Payload.SendFee);
            objResMap.Add("ResultAmt",       lo_objResGetCenterOrderChk.Payload.SendAmt);
            objResMap.Add("SendFeeRate",     lo_objResGetCenterOrderChk.Payload.SendFeeRate);
            objResMap.Add("PayStatus",       lo_objResGetCenterOrderChk.Payload.PayStatus);
            objResMap.Add("DeductAmt",       lo_objSmsPurchaseClosingGridModel.DeductAmt);
            objResMap.Add("OrgAmt",          lo_objSmsPurchaseClosingGridModel.OrgAmt);
            objResMap.Add("SendAmt",         lo_objSmsPurchaseClosingGridModel.SendAmt);
            objResMap.Add("SendPlanYMD",     lo_objSmsPurchaseClosingGridModel.SendPlanYMD);
            objResMap.Add("InputDeductAmt",  lo_objSmsPurchaseClosingGridModel.InputDeductAmt);
            objResMap.Add("DriverInsureAmt", lo_objSmsPurchaseClosingGridModel.DriverInsureAmt);

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 이벤트 대상 체크
    /// </summary>
    protected void GetEventAvailCheck()
    {
        SmsPayModel                      lo_objSmsPayModel       = null;
        string                           lo_strDecNo             = string.Empty;
        ReqEventAvailChk                lo_objReqEventAvailChk = null;
        ServiceResult<ResEventAvailChk> lo_objResEventAvailChk = null;

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
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (lo_objSmsPayModel == null)
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
            return;
        }

        try
        {
            lo_objReqEventAvailChk = new ReqEventAvailChk
            {
                CorpNo = lo_objSmsPayModel.ComCorpNo
            };
                
            lo_objResEventAvailChk = objSmsDasServices.GetEventAvailChk(lo_objReqEventAvailChk);
            objResMap.RetCode      = lo_objResEventAvailChk.result.ErrorCode;
            
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResEventAvailChk.result.ErrorMsg;
                return;
            }

            objResMap.Add("EventAvailFlag", lo_objResEventAvailChk.data.EventAvailFlag);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsPayHandler", "Exception",
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