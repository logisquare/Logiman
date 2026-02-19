<%@ WebHandler Language="C#" Class="ServerHandler" %>
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
/// FileName        : ServerHandler.ashx
/// Description     : 서버 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : ehdus0665@logislab.com, 2022-03-30
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ServerHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Server/ServerList"; //필수

    // 메소드 리스트
    private const string MethodServerList     = "ServerList";

    private const string MethodServerIPList   = "ServerIPList";
    private const string MethodServerIPInsert = "ServerIPInsert";
    private const string MethodServerIPUpdate = "ServerIPUpdate";
    private const string MethodServerIPDelete = "ServerIPDelete";

    private const string MethodServerConfigList   = "ServerConfigList";
    private const string MethodServerConfigInsert = "ServerConfigInsert";
    private const string MethodServerConfigUpdate = "ServerConfigUpdate";
    private const string MethodServerConfigDelete = "ServerConfigDelete";

    private const string MethodCodeList   = "CodeList";
    private const string MethodCodeInsert = "CodeInsert";
    private const string MethodCodeUpdate = "CodeUpdate";

    private const string MethodSecurityFieldList   = "SecurityFieldList";
    private const string MethodSecurityFieldInsert = "SecurityFieldInsert";
    private const string MethodSecurityFieldUpdate = "SecurityFieldUpdate";

    ServerDasServices    objServerDasServices = new ServerDasServices();

    private string strCallType = string.Empty;
    private int    intPageSize = 0;
    private int    intPageNo   = 0;

    private int    intGradeCode   = 0;
    private int    intCenterCode  = 0;
    private int    intMarkCharCnt = 0;

    private string strUseFlag     = string.Empty;
    private string strSearchType  = string.Empty;
    private string strListSearch  = string.Empty;

    private string strServerType      = string.Empty;
    private string strServerName      = string.Empty;
    private string strServerPort      = string.Empty;
    private string strServerIPAddr1   = string.Empty;
    private string strServerIPAddr2   = string.Empty;
    private string strServerStateCode = string.Empty;
    private string strStartDate       = string.Empty;
    private string strStopDate        = string.Empty;
    private string strRegDate         = string.Empty;
    private string strAllowIPAddr     = string.Empty;
    private string strAllowIPDesc     = string.Empty;
    private string strKeyName         = string.Empty;
    private string strKeyVal          = string.Empty;
    private string strCodeName        = string.Empty;
    private string strCodeVal         = string.Empty;
    private string strCodeDesc        = string.Empty;
    private string strFieldName       = string.Empty;
    private string strFieldDesc       = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodServerList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodServerIPList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodServerIPInsert,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodServerIPUpdate,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodServerIPDelete,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodServerConfigList,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodServerConfigInsert,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodServerConfigUpdate,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodServerConfigDelete,  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCodeList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCodeInsert,          MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCodeUpdate,          MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSecurityFieldList,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSecurityFieldInsert, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSecurityFieldUpdate, MenuAuthType.ReadWrite);

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
            intPageSize = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo   = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"), "0").ToInt();

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

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ServerHandler");
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
            intCenterCode  = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0").ToInt();
            intMarkCharCnt = Utils.IsNull(SiteGlobal.GetRequestForm("MarkCharCnt"), "0").ToInt();

            strUseFlag         = SiteGlobal.GetRequestForm("UseFlag");
            strSearchType      = SiteGlobal.GetRequestForm("SearchType");
            strListSearch      = SiteGlobal.GetRequestForm("ListSearch");
            strServerType      = SiteGlobal.GetRequestForm("ServerType");
            strServerName      = SiteGlobal.GetRequestForm("ServerName");
            strServerPort      = SiteGlobal.GetRequestForm("ServerPort");
            strServerIPAddr1   = SiteGlobal.GetRequestForm("ServerIPAddr1");
            strServerIPAddr2   = SiteGlobal.GetRequestForm("ServerIPAddr2");
            strServerStateCode = SiteGlobal.GetRequestForm("ServerStateCode");
            strStartDate       = SiteGlobal.GetRequestForm("StartDate");
            strStopDate        = SiteGlobal.GetRequestForm("StopDate");
            strAllowIPAddr     = SiteGlobal.GetRequestForm("AllowIPAddr");
            strAllowIPDesc     = SiteGlobal.GetRequestForm("AllowIPDesc");
            strKeyName         = SiteGlobal.GetRequestForm("KeyName");
            strKeyVal          = SiteGlobal.GetRequestForm("KeyVal");
            strCodeName        = SiteGlobal.GetRequestForm("CodeName");
            strCodeVal         = SiteGlobal.GetRequestForm("CodeVal");
            strCodeDesc        = SiteGlobal.GetRequestForm("CodeDesc");
            strFieldName       = SiteGlobal.GetRequestForm("FieldName");
            strFieldDesc       = SiteGlobal.GetRequestForm("FieldDesc");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
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
                case MethodServerList:
                    GetServerList();
                    break;
                case MethodServerIPList:
                    GetServerIPList();
                    break;
                case MethodServerIPInsert:
                    InsServerIP();
                    break;
                case MethodServerIPUpdate:
                    UpdServerIP();
                    break;
                case MethodServerIPDelete:
                    DelServerIP();
                    break;
                case MethodServerConfigList:
                    GetServerConfigList();
                    break;
                case MethodServerConfigInsert:
                    InsServerConfig();
                    break;
                case MethodServerConfigUpdate:
                    UpdServerConfig();
                    break;
                case MethodServerConfigDelete:
                    DelServerConfig();
                    break;
                case MethodCodeList:
                    GetCodeList();
                    break;
                case MethodCodeInsert:
                    InsCode();
                    break;
                case MethodCodeUpdate:
                    UpdCode();
                    break;
                case MethodSecurityFieldList:
                    GetSecurityFieldList();
                    break;
                case MethodSecurityFieldInsert:
                    InsSecurityField();
                    break;
                case MethodSecurityFieldUpdate:
                    UpdSecurityField();
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

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    protected void GetServerList()
    {
        string lo_strServerType = string.Empty;

        ReqServerList                lo_objReqServerList = null;
        ServiceResult<ResServerList> lo_objResServerList = null;

        try
        {
            switch (strSearchType)
            {
                case "ServerType":
                    lo_strServerType = strListSearch;
                    break;
            }

            lo_objReqServerList = new ReqServerList
            {
                ServerType   = lo_strServerType,
                PageSize     = intPageSize,
                PageNo       = intPageNo
            };

            lo_objResServerList    = objServerDasServices.GetServerList(lo_objReqServerList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResServerList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetServerIPList()
    {
        int lo_intCenterCode = 0;
        string lo_strServerType = string.Empty;
        string lo_strAllowIPAddr = string.Empty;

        ReqServerAllowipList                lo_objReqServerAllowipList = null;
        ServiceResult<ResServerAllowipList> lo_objResServerAllowipList = null;

        try
        {
            switch (strSearchType)
            {
                case "ServerType":
                    lo_strServerType = strListSearch;
                    break;
                case "CenterCode":
                    lo_intCenterCode = Convert.ToInt32(strListSearch);
                    break;
                case "AllowIPAddr":
                    lo_strAllowIPAddr = strListSearch;
                    break;
            }

            lo_objReqServerAllowipList = new ReqServerAllowipList
            {
                ServerType   = lo_strServerType,
                CenterCode   = lo_intCenterCode,
                AllowIPAddr  = lo_strAllowIPAddr,
                UseFlag      = strUseFlag,
                PageSize     = intPageSize,
                PageNo       = intPageNo
            };

            lo_objResServerAllowipList  = objServerDasServices.GetServerAllowipList(lo_objReqServerAllowipList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResServerAllowipList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void InsServerIP()
    {
        ServerAllowipViewModel lo_objReqInsServerIP  = null;
        ServiceResult<bool>    lo_objResInsServerIP  = null;

        try
        {
            lo_objReqInsServerIP = new ServerAllowipViewModel
            {
                ServerType  = strServerType,
                CenterCode  = intCenterCode,
                AllowIPAddr = strAllowIPAddr,
                AllowIPDesc = strAllowIPDesc,
                UseFlag     = strUseFlag,
                AdminID     = objSes.AdminID
            };

            lo_objResInsServerIP = objServerDasServices.InsServerAllowip(lo_objReqInsServerIP);
            objResMap.RetCode = lo_objResInsServerIP.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsServerIP.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void UpdServerIP()
    {
        ServerAllowipViewModel  lo_objReqUpdServerIP = null;
        ServiceResult<bool>     lo_objResUpdServerIP = null;

        try
        {
            lo_objReqUpdServerIP = new ServerAllowipViewModel
            {
                ServerType  = strServerType,
                CenterCode  = intCenterCode,
                AllowIPAddr = strAllowIPAddr,
                AllowIPDesc = strAllowIPDesc,
                UseFlag     = strUseFlag,
                AdminID     = objSes.AdminID,
            };

            lo_objResUpdServerIP = objServerDasServices.UpdServerAllowip(lo_objReqUpdServerIP);
            objResMap.RetCode = lo_objResUpdServerIP.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdServerIP.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void DelServerIP()
    {
        ServerAllowipViewModel  lo_objReqUpdServerIP = null;
        ServiceResult<bool>     lo_objResUpdServerIP = null;

        try
        {
            lo_objReqUpdServerIP = new ServerAllowipViewModel
            {
                ServerType  = strServerType,
                CenterCode  = intCenterCode,
                AllowIPAddr = strAllowIPAddr,
            };

            lo_objResUpdServerIP = objServerDasServices.DelServerAllowip(lo_objReqUpdServerIP);
            objResMap.RetCode = lo_objResUpdServerIP.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdServerIP.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }


    protected void GetServerConfigList()
    {
        string lo_strServerType = string.Empty;
        string lo_strKeyName = string.Empty;
        string lo_strKeyVal = string.Empty;

        ReqServerConfigList                lo_objReqServerConfigList = null;
        ServiceResult<ResServerConfigList> lo_objResServerConfigList = null;

        try
        {
            switch (strSearchType)
            {
                case "ServerType":
                    lo_strServerType = strListSearch;
                    break;
                case "KeyName":
                    lo_strKeyName = strListSearch;
                    break;
                case "KeyVal":
                    lo_strKeyVal = strListSearch;
                    break;
            }

            lo_objReqServerConfigList = new ReqServerConfigList
            {
                ServerType  = lo_strServerType,
                KeyName     = lo_strKeyName,
                KeyVal      = lo_strKeyVal,
                PageSize    = intPageSize,
                PageNo      = intPageNo
            };

            lo_objResServerConfigList  = objServerDasServices.GetServerConfigList(lo_objReqServerConfigList);
            objResMap.strResponse      = "[" + JsonConvert.SerializeObject(lo_objResServerConfigList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void InsServerConfig()
    {
        ServerConfigViewModel lo_objReqInsServerConfig  = null;
        ServiceResult<bool>   lo_objResInsServerConfig  = null;

        try
        {
            lo_objReqInsServerConfig = new ServerConfigViewModel
            {
                ServerType  = strServerType,
                KeyName     = strKeyName,
                KeyVal      = strKeyVal,
                AdminID     = objSes.AdminID
            };

            lo_objResInsServerConfig = objServerDasServices.InsServerConfig(lo_objReqInsServerConfig);
            objResMap.RetCode = lo_objResInsServerConfig.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsServerConfig.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void UpdServerConfig()
    {
        ServerConfigViewModel  lo_objReqUpdServerConfig = null;
        ServiceResult<bool>    lo_objResUpdServerConfig = null;

        try
        {
            lo_objReqUpdServerConfig = new ServerConfigViewModel
            {
                ServerType  = strServerType,
                KeyName     = strKeyName,
                KeyVal      = strKeyVal,
                AdminID     = objSes.AdminID
            };

            lo_objResUpdServerConfig = objServerDasServices.UpdServerConfig(lo_objReqUpdServerConfig);
            objResMap.RetCode = lo_objResUpdServerConfig.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdServerConfig.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void DelServerConfig()
    {
        ServerConfigViewModel lo_objReqUpdServerConfig = null;
        ServiceResult<bool>   lo_objResUpdServerConfig = null;

        try
        {
            lo_objReqUpdServerConfig = new ServerConfigViewModel
            {
                ServerType  = strServerType,
                KeyName     = strKeyName,
                AdminID     = objSes.AdminID
            };

            lo_objResUpdServerConfig = objServerDasServices.DelServerConfig(lo_objReqUpdServerConfig);
            objResMap.RetCode = lo_objResUpdServerConfig.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdServerConfig.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetCodeList()
    {
        ReqCodeList                lo_objReqCodeList = null;
        ServiceResult<ResCodeList> lo_objResCodeList = null;

        try
        {
            lo_objReqCodeList = new ReqCodeList
            {
                CodeName = strCodeName,
                CodeVal = strCodeVal,
                CodeDesc = strCodeDesc,
                PageSize = intPageSize,
                PageNo = intPageNo
            };

            lo_objResCodeList = objServerDasServices.GetCodeList(lo_objReqCodeList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCodeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
        
    protected void InsCode()
    {
        CodeViewModel       lo_objReqInsCode  = null;
        ServiceResult<bool> lo_objResInsCode  = null;

        try
        {
            lo_objReqInsCode = new CodeViewModel
            {
                CodeName    = strCodeName,
                CodeVal     = strCodeVal,
                CodeDesc    = strCodeDesc,
                RegAdminID  = objSes.AdminID
            };

            lo_objResInsCode = objServerDasServices.InsCode(lo_objReqInsCode);
            objResMap.RetCode = lo_objResInsCode.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsCode.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void UpdCode()
    {
        CodeViewModel       lo_objReqUpdCode = null;
        ServiceResult<bool> lo_objResUpdCode = null;

        try
        {
            lo_objReqUpdCode = new CodeViewModel
            {
                CodeName    = strCodeName,
                CodeVal     = strCodeVal,
                CodeDesc    = strCodeDesc,
                UpdAdminID  = objSes.AdminID
            };

            lo_objResUpdCode = objServerDasServices.UpdCode(lo_objReqUpdCode);
            objResMap.RetCode = lo_objResUpdCode.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdCode.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetSecurityFieldList()
    {
        string lo_strFieldName = string.Empty;

        ReqSecurityFieldList                lo_objReqSecurityFieldList = null;
        ServiceResult<ResSecurityFieldList> lo_objResSecurityFieldList = null;

        try
        {
            lo_objReqSecurityFieldList = new ReqSecurityFieldList
            {
                FieldName = lo_strFieldName,
                PageSize = intPageSize,
                PageNo = intPageNo
            };

            lo_objResSecurityFieldList = objServerDasServices.GetSecurityFieldList(lo_objReqSecurityFieldList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResSecurityFieldList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void InsSecurityField()
    {
        SecurityFieldViewModel lo_objReqInsSecurityField  = null;
        ServiceResult<bool>    lo_objResInsSecurityField  = null;

        try
        {
            lo_objReqInsSecurityField = new SecurityFieldViewModel
            {
                FieldName   = strFieldName,
                MarkCharCnt = intMarkCharCnt,
                FieldDesc   = strFieldDesc,
                UseFlag     = strUseFlag,
                AdminID     = objSes.AdminID
            };

            lo_objResInsSecurityField = objServerDasServices.InsSecurityField(lo_objReqInsSecurityField);
            objResMap.RetCode = lo_objResInsSecurityField.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsSecurityField.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void UpdSecurityField()
    {
        SecurityFieldViewModel  lo_objReqUpdSecurityField = null;
        ServiceResult<bool>     lo_objResUpdSecurityField = null;

        try
        {
            lo_objReqUpdSecurityField = new SecurityFieldViewModel
            {
                FieldName   = strFieldName,
                MarkCharCnt = intMarkCharCnt,
                FieldDesc   = strFieldDesc,
                UseFlag     = strUseFlag,
                AdminID     = objSes.AdminID
            };

            lo_objResUpdSecurityField = objServerDasServices.UpdSecurityField(lo_objReqUpdSecurityField);
            objResMap.RetCode = lo_objResUpdSecurityField.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdSecurityField.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ServerHandler", "Exception",
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