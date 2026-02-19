<%@ WebHandler Language="C#" Class="CMCallMemoHandler" %>
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
/// FileName        : CMCallMemoHandler.ashx
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
public class CMCallMemoHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/CallManager/CMCallMemoList"; //필수
        
    // 메소드 리스트
    private const string MethodCMMemoList = "CMMemoList";   //메모목록
    private const string MethodCMMemoDel  = "CMMemoDelete"; //메모삭제
        
    CallManageDasServices objCallManageDasServices = new CallManageDasServices();

    private string strCallType          = string.Empty;
    private int    intPageSize          = 0;
    private int    intPageNo            = 0;
    private string strSeqNo             = string.Empty;
    private string strCenterCode        = string.Empty;
    private string strDateFrom          = string.Empty;
    private string strDateTo            = string.Empty;
    private string strCallerDetailTypes = string.Empty;
    private string strCallNumber        = string.Empty;
    private string strCompanyName       = string.Empty;
    private string strCompanyCeoName    = string.Empty;
    private string strCompanyChargeName = string.Empty;
    private string strAdminName         = string.Empty;
    private string strMyMemoFlag        = string.Empty;

    private HttpContext objHttpContext = null;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCMMemoList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMMemoDel,  MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("CMCallMemoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CMCallMemoHandler");
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
            strSeqNo             = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),      "0");
            strCenterCode        = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateFrom          = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo            = SiteGlobal.GetRequestForm("DateTo");
            strCallerDetailTypes = SiteGlobal.GetRequestForm("CallerDetailTypes");
            strCallNumber        = SiteGlobal.GetRequestForm("CallNumber");
            strCompanyName       = SiteGlobal.GetRequestForm("CompanyName");
            strCompanyCeoName    = SiteGlobal.GetRequestForm("CompanyCeoName");
            strCompanyChargeName = SiteGlobal.GetRequestForm("CompanyChargeName");
            strAdminName         = SiteGlobal.GetRequestForm("AdminName");
            strMyMemoFlag        = SiteGlobal.GetRequestForm("MyMemoFlag");
            
            strDateFrom    = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo      = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallMemoHandler", "Exception",
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
                case MethodCMMemoList:
                    GetCMMemoList();
                    break;
                case MethodCMMemoDel:
                    SetCMMemoDel();
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

            SiteGlobal.WriteLog("CMCallMemoHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 메모 목록
    /// </summary>
    protected void GetCMMemoList()
    {
            
        ReqCMMemoList                lo_objReqCMMemoList = null;
        ServiceResult<ResCMMemoList> lo_objResCMMemoList = null;

        try
        {
            lo_objReqCMMemoList = new ReqCMMemoList
            {
                SeqNo             = strSeqNo.ToInt(),
                CenterCode        = strCenterCode.ToInt(),
                DateFrom          = strDateFrom,
                DateTo            = strDateTo,
                CallerDetailTypes = strCallerDetailTypes,
                CallNumber        = strCallNumber, 
                CompanyName       = strCompanyName,
                CompanyCeoName    = strCompanyCeoName,
                CompanyChargeName = strCompanyChargeName,
                AdminName         = strAdminName,
                MyMemoFlag        = strMyMemoFlag,
                AdminID           = objSes.AdminID,
                AccessCenterCode  = objSes.AccessCenterCode,
                PageSize          = intPageSize,
                PageNo            = intPageNo
            };

            lo_objResCMMemoList   = objCallManageDasServices.GetCMMemoList(lo_objReqCMMemoList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCMMemoList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallMemoHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 메모 삭제
    /// </summary>
    protected void SetCMMemoDel()
    {
        ReqCMMemoDel        lo_objReqCMMemoDel = null;
        ServiceResult<bool> lo_objResCMMemoDel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSeqNo) || strSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCMMemoDel = new ReqCMMemoDel
            {
                CenterCode = strCenterCode.ToInt(),
                SeqNo      = strSeqNo.ToInt(),
                AdminID    = objSes.AdminID
            };

            lo_objResCMMemoDel = objCallManageDasServices.SetCMMemoDel(lo_objReqCMMemoDel);
            objResMap.RetCode  = lo_objResCMMemoDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCMMemoDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallMemoHandler", "Exception",
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