<%@ WebHandler Language="C#" Class="DailySafetyCheckHandler" %>
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
/// FileName        : DailySafetyCheckHandler.ashx
/// Description     : 일일안전점검 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2023-10-31
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class DailySafetyCheckHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Dispatch/DailySafetyCheckList"; //필수

    // 메소드 리스트
    private const string MethodDailySafetyCheckList = "DailySafetyCheckList";   //일일안전점검 목록
    private const string MethodDailySafetyCheckIns  = "DailySafetyCheckInsert"; //일일안전점검 발송

    OrderDispatchDasServices objOrderDispatchDasServices = new OrderDispatchDasServices();

    private HttpContext objHttpContext = null;

    private string strCallType      = string.Empty;
    private int    intPageSize      = 0;
    private int    intPageNo        = 0;
    private string strCenterCode    = string.Empty;
    private string strDateType      = string.Empty;
    private string strDateYMD       = string.Empty;
    private string strComName       = string.Empty;
    private string strComCorpNo     = string.Empty;
    private string strCarNo         = string.Empty;
    private string strDriverName    = string.Empty;
    private string strDriverCell    = string.Empty;
    private string strReplyFlag     = string.Empty;
    private string strOrderNo       = string.Empty;
    private string strDispatchSeqNo = string.Empty;
    private string strRefSeqNo      = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodDailySafetyCheckList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDailySafetyCheckIns,  MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("DailySafetyCheckHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("DailySafetyCheckHandler");
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
            strCenterCode    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType      = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateYMD       = SiteGlobal.GetRequestForm("DateYMD");
            strComName       = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo     = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarNo         = SiteGlobal.GetRequestForm("CarNo");
            strDriverName    = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell    = SiteGlobal.GetRequestForm("DriverCell");
            strReplyFlag     = SiteGlobal.GetRequestForm("ReplyFlag");
            strOrderNo       = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),       "0");
            strDispatchSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strRefSeqNo      = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"),      "0");
            strDateYMD       = string.IsNullOrWhiteSpace(strDateYMD) ? strDateYMD : strDateYMD.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DailySafetyCheckHandler", "Exception",
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
                case MethodDailySafetyCheckList:
                    GetDailySafetyCheckList();
                    break;
                case MethodDailySafetyCheckIns: 
                    SetDailySafetyCheckIns();
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

            SiteGlobal.WriteLog("DailySafetyCheckHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 배차 현황 목록
    /// </summary>
    protected void GetDailySafetyCheckList()
    {
        ReqDailySafetyCheckList                lo_objReqDailySafetyCheckList  = null;
        ServiceResult<ResDailySafetyCheckList> lo_objResDailySafetyCheckList  = null;

        if (string.IsNullOrWhiteSpace(strDateYMD))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqDailySafetyCheckList  = new ReqDailySafetyCheckList
            {
                CenterCode       = strCenterCode.ToInt(),
                DateType         = strDateType.ToInt(),
                DateYMD          = strDateYMD,
                ComName          = strComName,
                ComCorpNo        = strComCorpNo,
                CarNo            = strCarNo,
                DriverName       = strDriverName,
                DriverCell       = strDriverCell,
                ReplyFlag        = strReplyFlag,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResDailySafetyCheckList  = objOrderDispatchDasServices.GetDailySafetyCheckList(lo_objReqDailySafetyCheckList );

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResDailySafetyCheckList ) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DailySafetyCheckHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 일일안전점검 발송
    /// </summary>
    protected void SetDailySafetyCheckIns()
    {
        DailySafetyCheckInsModel                lo_objReqDailySafetyCheckIns = null;
        ServiceResult<DailySafetyCheckInsModel> lo_objResDailySafetyCheckIns = null;

        if (strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strOrderNo.Equals("0") || string.IsNullOrWhiteSpace(strOrderNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strDispatchSeqNo.Equals("0") || string.IsNullOrWhiteSpace(strDispatchSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strRefSeqNo.Equals("0") || string.IsNullOrWhiteSpace(strRefSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqDailySafetyCheckIns = new DailySafetyCheckInsModel
            {
                CenterCode    = strCenterCode.ToInt(),
                OrderNo       = strOrderNo.ToInt64(),
                DispatchSeqNo = strDispatchSeqNo.ToInt64(),
                RefSeqNo      = strRefSeqNo.ToInt64(),
                AdminID       = objSes.AdminID,
                AdminName     = objSes.AdminName
            };

            lo_objResDailySafetyCheckIns = objOrderDispatchDasServices.SetDailySafetyCheckIns(lo_objReqDailySafetyCheckIns);

            objResMap.RetCode = lo_objResDailySafetyCheckIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResDailySafetyCheckIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SeqNo", lo_objResDailySafetyCheckIns.data.SeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DailySafetyCheckHandler", "Exception",
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