<%@ WebHandler Language="C#" Class="CMCallRecordHandler" %>
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
/// FileName        : CMCallRecordHandler.ashx
/// Description     : 콜매니저
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2025-08-21
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class CMCallRecordHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/CallManager/CMCallRecordList"; //필수
        
    // 메소드 리스트
    private const string MethodCMLogList = "CMLogList"; //수발신목록

    CallManageDasServices objCallManageDasServices = new CallManageDasServices();

    private string strCallType    = string.Empty;
    private int    intPageSize    = 0;
    private int    intPageNo      = 0;
    private string strSeqNo       = string.Empty;
    private string strCenterCode  = string.Empty;
    private string strDateFrom    = string.Empty;
    private string strDateTo      = string.Empty;
    private string strLogCallType = string.Empty;
    private string strCallKind    = string.Empty;
    private string strChannelType = string.Empty;
    private string strCallNumber  = string.Empty;
    private string strSendNumber  = string.Empty;
    private string strRcvNumber   = string.Empty;
    private string strMyPhoneFlag = string.Empty;
    private string strMessage     = string.Empty;

    private HttpContext objHttpContext = null;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCMLogList, MenuAuthType.ReadOnly);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        objHttpContext = context;

        try
        {
            strCallType  = SiteGlobal.GetRequestForm("CallType");
            intPageSize  = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo    = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

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

            SiteGlobal.WriteLog("CMCallRecordHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CMCallRecordHandler");
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
            strSeqNo       = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),      "0");
            strCenterCode  = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateFrom    = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo      = SiteGlobal.GetRequestForm("DateTo");
            strLogCallType = Utils.IsNull(SiteGlobal.GetRequestForm("LogCallType"), "0");
            strCallKind    = SiteGlobal.GetRequestForm("CallKind");
            strChannelType = SiteGlobal.GetRequestForm("ChannelType");
            strCallNumber  = SiteGlobal.GetRequestForm("CallNumber");
            strSendNumber  = SiteGlobal.GetRequestForm("SendNumber");
            strRcvNumber   = SiteGlobal.GetRequestForm("RcvNumber");
            strMyPhoneFlag = SiteGlobal.GetRequestForm("MyPhoneFlag");
            strMessage     = SiteGlobal.GetRequestForm("Message");
            
            strDateFrom    = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo      = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallRecordHandler", "Exception",
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
                case MethodCMLogList:
                    GetCMLogList();
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

            SiteGlobal.WriteLog("CMCallRecordHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 콜수발신 목록
    /// </summary>
    protected void GetCMLogList()
    {
            
        ReqCMLogList                lo_objReqCMLogList = null;
        ServiceResult<ResCMLogList> lo_objResCMLogList = null;

        strMyPhoneFlag = objSes.GradeCode <= 2 ? "" : "Y";

        try
        {
            lo_objReqCMLogList = new ReqCMLogList
            {
                SeqNo            = strSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                CallType         = strLogCallType.ToInt(),
                CallKind         = strCallKind,
                ChannelType      = strChannelType,
                CallNumber       = strCallNumber,
                SendNumber       = strSendNumber,
                RcvNumber        = strRcvNumber,
                Message          = strMessage,
                MyPhoneFlag      = strMyPhoneFlag,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCMLogList    = objCallManageDasServices.GetCMLogList(lo_objReqCMLogList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCMLogList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallRecordHandler", "Exception",
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
            // ignored
        }
    }
}