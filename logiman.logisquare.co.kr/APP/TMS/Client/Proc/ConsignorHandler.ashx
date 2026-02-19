<%@ WebHandler Language="C#" Class="ConsignorHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Data;
using System.IO;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : ConsignorHandler.ashx
/// Description     : APP 화주 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemAdminHandler
/// Author          : jylee88@logislab.com, 2022-12-21
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ConsignorHandler : AppAshxBaseHandler
{
    private const string MethodConsignorList       = "ConsignorList";
    private const string MethodConsignorIns        = "ConsignorInsert";
    private const string MethodConsignorUpd        = "ConsignorUpdate";
    // 메소드 리스트
    ConsignorDasServices objConsignorDasServices   = new ConsignorDasServices();
    AppConsignorDasServices objAppConsignorDasServices   = new AppConsignorDasServices();

    private string strCallType      = string.Empty;
    private int    intPageSize      = 0;
    private int    intPageNo        = 0;
    private string strConsignorCode = string.Empty;
    private string strCenterCode    = string.Empty;
    private string strConsignorName = string.Empty;
    private string strConsignorNote = string.Empty;
    private string strUseFlag       = string.Empty;
    private string strClientCode    = string.Empty;
    private string strClientName    = string.Empty;
    private string strEncSeqNo      = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        base.ProcessRequest(context);

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

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ConsignorHandler");
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
            strConsignorCode = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strCenterCode    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),    "0");
            strConsignorName = SiteGlobal.GetRequestForm("ConsignorName");
            strConsignorNote = SiteGlobal.GetRequestForm("ConsignorNote");
            strUseFlag       = SiteGlobal.GetRequestForm("UseFlag");
            strClientCode    = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strEncSeqNo      = Utils.IsNull(SiteGlobal.GetRequestForm("EncSeqNo"),   "");
            strClientName    = SiteGlobal.GetRequestForm("ClientName");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
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
                case MethodConsignorList:
                    GetConsignorList();
                    break;
                case MethodConsignorIns:
                    SetConsignorIns();
                    break;
                case MethodConsignorUpd:
                    SetConsignorUpd();
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

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// 화주 목록
    /// </summary>
    protected void GetConsignorList()
    {
        ReqAppConsignorList                lo_objReqConsignorList = null;
        ServiceResult<ResAppConsignorList> lo_objResConsignorList = null;

        try
        {
            lo_objReqConsignorList = new ReqAppConsignorList
            {
                ConsignorCode    = strConsignorCode.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                UseFlag          = strUseFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResConsignorList = objAppConsignorDasServices.GetAppConsignorList(lo_objReqConsignorList);
            objResMap.strResponse      = "[" + JsonConvert.SerializeObject(lo_objResConsignorList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 등록
    /// </summary>
    protected void SetConsignorIns()
    {
        ConsignorModel                lo_objConsignorModel  = null;
        ServiceResult<ConsignorModel> lo_objResConsignorIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objConsignorModel = new ConsignorModel
            {
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                ConsignorNote    = strConsignorNote,
                RegAdminID       = objSes.AdminID
            };

            lo_objResConsignorIns = objConsignorDasServices.SetConsignorIns(lo_objConsignorModel);
            objResMap.RetCode     = lo_objResConsignorIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResConsignorIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("ConsignorCode",    lo_objResConsignorIns.data.ConsignorCode);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 수정
    /// </summary>
    protected void SetConsignorUpd()
    {
        ConsignorModel      lo_objConsignorModel  = null;
        ServiceResult<bool> lo_objResConsignorUpd = null;

        strUseFlag = Utils.IsNull(strUseFlag, "N");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objConsignorModel = new ConsignorModel
            {
                CenterCode       = strCenterCode.ToInt(),
                ConsignorCode    = strConsignorCode.ToInt(),
                ConsignorNote    = strConsignorNote,
                UseFlag          = strUseFlag,
                UpdAdminID       = objSes.AdminID
            };

            lo_objResConsignorUpd = objConsignorDasServices.SetConsignorUpd(lo_objConsignorModel);
            objResMap.RetCode     = lo_objResConsignorUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResConsignorUpd.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("ConsignorCode", strConsignorCode);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ConsignorHandler", "Exception",
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