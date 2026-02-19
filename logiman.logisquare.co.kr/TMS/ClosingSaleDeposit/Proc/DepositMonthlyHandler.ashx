<%@ WebHandler Language="C#" Class="DepositMonthlyHandler" %>
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
/// FileName        : DepositMonthlyHandler.ashx
/// Description     : 미수업체관리 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-26
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class DepositMonthlyHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingSaleDeposit/DepositMonthlyList"; //필수

    // 메소드 리스트
    private const string MethodPayMisuList     = "PayMisuList";       //미수 목록
    private const string MethodPayMisuIns      = "PayMisuInsert";     //미수 등록
    private const string MethodClientList      = "ClientList";        //고객사 조회
    private const string MethodPayMisuNoteList = "PayMisuNoteList";   //미수 확인내용 목록
    private const string MethodPayMisuNoteIns  = "PayMisuNoteInsert"; //미수 확인내용 등록
    private const string MethodPayMisuNoteUpd  = "PayMisuNoteUpdate"; //미수 확인내용 수정
    private const string MethodPayMisuNoteDel  = "PayMisuNoteDelete"; //미수 확인내용 삭제

    DepositDasServices  objDepositDasServices = new DepositDasServices();
    ClientDasServices   objClientDasServices  = new ClientDasServices();
    private HttpContext objHttpContext        = null;

    private string strCallType             = string.Empty;
    private int    intPageSize             = 0;
    private int    intPageNo               = 0;
    private string strCenterCode           = string.Empty;
    private string strYear                 = string.Empty;
    private string strClientBusinessStatus = string.Empty;
    private string strClientName           = string.Empty;
    private string strUpdateYM             = string.Empty;
    private string strClientCode           = string.Empty;
    private string strDateFrom             = string.Empty;
    private string strDateTo               = string.Empty;
    private string strNoteSeqNo            = string.Empty;
    private string strNoteYMD              = string.Empty;
    private string strNote                 = string.Empty;
    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPayMisuList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPayMisuIns,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPayMisuNoteList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPayMisuNoteIns,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPayMisuNoteUpd,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPayMisuNoteDel,  MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("DepositMonthlyHandler");
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
            strCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateFrom             = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo               = SiteGlobal.GetRequestForm("DateTo");
            strClientBusinessStatus = Utils.IsNull(SiteGlobal.GetRequestForm("ClientBusinessStatus"), "0");
            strYear                 = SiteGlobal.GetRequestForm("Year");
            strClientName           = SiteGlobal.GetRequestForm("ClientName");
            strUpdateYM             = SiteGlobal.GetRequestForm("UpdateYM");
            strClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strNoteSeqNo            = Utils.IsNull(SiteGlobal.GetRequestForm("NoteSeqNo"),  "0");
            strNoteYMD              = SiteGlobal.GetRequestForm("NoteYMD");
            strNote                 = SiteGlobal.GetRequestForm("Note");

            strUpdateYM = string.IsNullOrWhiteSpace(strUpdateYM) ? strUpdateYM : strUpdateYM.Replace("-", "");
            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
            strNoteYMD  = string.IsNullOrWhiteSpace(strNoteYMD) ? strNoteYMD : strNoteYMD.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
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
                case MethodPayMisuList:
                    GetPayMisuList();
                    break;
                case MethodPayMisuIns:
                    SetPayMisuIns();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodPayMisuNoteList:
                    GetPayMisuNoteList();
                    break;
                case MethodPayMisuNoteIns:
                    SetPayMisuNoteIns();
                    break;
                case MethodPayMisuNoteUpd:
                    SetPayMisuNoteUpd();
                    break;
                case MethodPayMisuNoteDel:
                    SetPayMisuNoteDel();
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

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 미수업체내역
    /// </summary>
    protected void GetPayMisuList()
    {
        ReqPayMisuList                lo_objReqPayMisuList = null;
        ServiceResult<ResPayMisuList> lo_objResPayMisuList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strYear))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPayMisuList = new ReqPayMisuList
            {
                CenterCode           = strCenterCode.ToInt(),
                Year                 = strYear,
                ClientBusinessStatus = strClientBusinessStatus.ToInt(),
                ClientName           = strClientName,
                AccessCenterCode     = objSes.AccessCenterCode
            };

            lo_objResPayMisuList = objDepositDasServices.GetPayMisuList(lo_objReqPayMisuList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPayMisuList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 미수 집계 등록
    /// </summary>
    protected void SetPayMisuIns()
    {
        ReqPayMisuIns       lo_objReqPayMisuIns = null;
        ServiceResult<bool> lo_objResPayMisuIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strUpdateYM))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPayMisuIns = new ReqPayMisuIns
            {
                CenterCode   = strCenterCode.ToInt(),
                YM           = strUpdateYM,
                RegAdminID   = objSes.AdminID,
                RegAdminName = objSes.AdminName
            };

            lo_objResPayMisuIns = objDepositDasServices.SetPayMisuIns(lo_objReqPayMisuIns);
            objResMap.RetCode   = lo_objResPayMisuIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayMisuIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 목록
    /// </summary>
    protected void GetClientList()
    {
        ReqClientList                lo_objReqClientList = null;
        ServiceResult<ResClientList> lo_objResClientList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientList = new ReqClientList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientList = objClientDasServices.GetClientList(lo_objReqClientList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 미수 확인내용 목록
    /// </summary>
    protected void GetPayMisuNoteList()
    {
        ReqPayMisuNoteList                lo_objReqPayMisuNoteList = null;
        ServiceResult<ResPayMisuNoteList> lo_objResPayMisuNoteList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPayMisuNoteList = new ReqPayMisuNoteList
            {
                NoteSeqNo        = strNoteSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt64(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                Note             = strNote,
                DelFlag          = "N",
                PageNo           = intPageNo,
                PageSize         = intPageSize,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResPayMisuNoteList = objDepositDasServices.GetPayMisuNoteList(lo_objReqPayMisuNoteList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResPayMisuNoteList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 미수 확인내용 등록
    /// </summary>
    protected void SetPayMisuNoteIns()
    {
        PayMisuNoteModel                lo_objPayMisuNoteModel  = null;
        ServiceResult<PayMisuNoteModel> lo_objResPayMisuNoteIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNoteYMD))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNote))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objPayMisuNoteModel = new PayMisuNoteModel
            {
                CenterCode   = strCenterCode.ToInt(),
                ClientCode   = strClientCode.ToInt64(),
                NoteYMD      = strNoteYMD,
                Note         = strNote,
                RegAdminID   = objSes.AdminID,
                RegAdminName = objSes.AdminName
            };

            lo_objResPayMisuNoteIns = objDepositDasServices.SetPayMisuNoteIns(lo_objPayMisuNoteModel);
            objResMap.RetCode       = lo_objResPayMisuNoteIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayMisuNoteIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("NoteSeqNo", lo_objResPayMisuNoteIns.data.NoteSeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 미수 확인내용 수정
    /// </summary>
    protected void SetPayMisuNoteUpd()
    {
        PayMisuNoteModel    lo_objPayMisuNoteModel  = null;
        ServiceResult<bool> lo_objResPayMisuNoteUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNoteYMD))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNote))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNoteSeqNo) || strNoteSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objPayMisuNoteModel = new PayMisuNoteModel
            {
                NoteSeqNo    = strNoteSeqNo.ToInt64(),
                CenterCode   = strCenterCode.ToInt(),
                ClientCode   = strClientCode.ToInt64(),
                NoteYMD      = strNoteYMD,
                Note         = strNote,
                UpdAdminID   = objSes.AdminID,
                UpdAdminName = objSes.AdminName
            };

            lo_objResPayMisuNoteUpd = objDepositDasServices.SetPayMisuNoteUpd(lo_objPayMisuNoteModel);
            objResMap.RetCode       = lo_objResPayMisuNoteUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayMisuNoteUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 미수 확인내용 삭제
    /// </summary>
    protected void SetPayMisuNoteDel()
    {
        PayMisuNoteModel    lo_objPayMisuNoteModel  = null;
        ServiceResult<bool> lo_objResPayMisuNoteDel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strNoteSeqNo) || strNoteSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objPayMisuNoteModel = new PayMisuNoteModel
            {
                NoteSeqNo    = strNoteSeqNo.ToInt64(),
                CenterCode   = strCenterCode.ToInt(),
                ClientCode   = strClientCode.ToInt64(),
                DelAdminID   = objSes.AdminID,
                DelAdminName = objSes.AdminName
            };

            lo_objResPayMisuNoteDel = objDepositDasServices.SetPayMisuNoteDel(lo_objPayMisuNoteModel);
            objResMap.RetCode       = lo_objResPayMisuNoteDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayMisuNoteDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositMonthlyHandler", "Exception",
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