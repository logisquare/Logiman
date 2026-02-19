<%@ WebHandler Language="C#" Class="SmsSafetyCheckHandler" %>
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
/// FileName        : SmsSafetyCheckHandler.ashx
/// Description     : 안전점검리스트 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2023-10-27
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SmsSafetyCheckHandler : AshxSmsBaseHandler
{
    // 메소드 리스트
    private const string MethodParamChk = "ParamChk"; //No 체크
    private const string MethodReplyUpd = "ReplyUpd"; //답변 업데이트

    SmsDasServices objSmsDasServices = new SmsDasServices();

    private string strCallType     = string.Empty;
    private string strNo           = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodParamChk, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodReplyUpd, MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("SmsSafetyCheckHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SmsSafetyCheckHandler");
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
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsSafetyCheckHandler", "Exception",
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
                case MethodReplyUpd:
                    SetReplyUpd();
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

            SiteGlobal.WriteLog("SmsSafetyCheckHandler", "Exception",
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
        SmsSafetyModel lo_objSmsSafetyModel = null;
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

            lo_objSmsSafetyModel = JsonConvert.DeserializeObject<SmsSafetyModel>(lo_strDecNo);

            if (lo_objSmsSafetyModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            DateTime.TryParse(lo_objSmsSafetyModel.TimeStamp, out lo_objDateTime);
            lo_objTimeDiff = DateTime.Now - lo_objDateTime;
            objResMap.Add("TimeOutFlag", lo_objTimeDiff.TotalDays > 7 ? "Y" : "N");

            lo_strEncNo                          = Utils.GetEncrypt(JsonConvert.SerializeObject(lo_objSmsSafetyModel));
            objResMap.Add("No",         lo_strEncNo);
            objResMap.Add("DriverName", lo_objSmsSafetyModel.DriverName);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsSafetyCheckHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 개인정보 수정
    /// </summary>
    protected void SetReplyUpd()
    {
        SmsSafetyModel          lo_objSmsSafetyModel          = null;
        string                  lo_strDecNo                   = string.Empty;
        string                  lo_strEncNo                   = string.Empty;
        ReqSafetyCheckReplayUpd lo_objReqSafetyCheckReplayUpd = null;
        ServiceResult<bool>     lo_objResSafetyCheckReplayUpd = null;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9931;
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

            lo_objSmsSafetyModel = JsonConvert.DeserializeObject<SmsSafetyModel>(lo_strDecNo);

            if (lo_objSmsSafetyModel == null)
            {
                objResMap.RetCode = 9934;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9939;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsSafetyCheckHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqSafetyCheckReplayUpd = new ReqSafetyCheckReplayUpd
            {
                CenterCode    = lo_objSmsSafetyModel.CenterCode,
                OrderNo       = lo_objSmsSafetyModel.OrderNo,
                DispatchSeqNo = lo_objSmsSafetyModel.DispatchSeqNo,
                RefSeqNo      = lo_objSmsSafetyModel.RefSeqNo,
                SeqNo         = lo_objSmsSafetyModel.SeqNo
            };

            lo_objResSafetyCheckReplayUpd = objSmsDasServices.SetSafetyCheckReplyUpd(lo_objReqSafetyCheckReplayUpd);

            objResMap.RetCode = lo_objResSafetyCheckReplayUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSafetyCheckReplayUpd.result.ErrorMsg;
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9940;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsSafetyCheckHandler", "Exception",
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