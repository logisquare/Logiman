<%@ WebHandler Language="C#" Class="AdminMenuHandler" %>
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
/// FileName        : AdminMenuHandler.ashx
/// Description     : 어드민메뉴 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jtoh@logislab.com, 2022-04-05
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class AdminMenuHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink            = "/SSO/Admin/AdminMenuList"; //필수

    // 메소드 리스트
    private const string MethodAdminMenuList        = "AdminMenuList";
    private const string MethodAdminMenuGroupInfo   = "AdminMenuGroupInfo";
    private const string MethodAdminMenuInsert      = "AdminMenuInsert";
    private const string MethodAdminMenuUpdate      = "AdminMenuUpdate";
    private const string MethodAdminMenuUpdateList  = "AdminMenuUpdateList";
    
    private const string MethodAdminMenuDelete      = "AdminMenuDelete";

    private const string MethodAdminMenuGroupUpdate = "AdminMenuGroupUpdate";
    private const string MethodAdminMenuGroupDelete = "AdminMenuGroupDelete";

    AdminMenuDasServices objAdminMenuDasServices    = new AdminMenuDasServices();

    private string strCallType     = string.Empty;
    private int    intPageSize     = 0;
    private int    intPageNo       = 0;

    private string strMenuNo       = string.Empty;
    private string strMenuName     = string.Empty;
    private string strMenuLink     = string.Empty;
    private int    intMenuSort     = 0;
    private string strMenuDesc     = string.Empty;

    private int    intUseStateCode = 0;
    private string strMenuGroupNo  = string.Empty;
    private string strAllParam     = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAdminMenuList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAdminMenuGroupInfo,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAdminMenuInsert,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminMenuUpdate,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminMenuUpdateList,  MenuAuthType.ReadWrite);
        
        objMethodAuthList.Add(MethodAdminMenuDelete,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminMenuGroupUpdate, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminMenuGroupDelete, MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AdminMenuHandler");
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
            // AdminMenu List
            strMenuNo       = SiteGlobal.GetRequestForm("MenuNo");
            strMenuName     = SiteGlobal.GetRequestForm("MenuName");
            strMenuLink     = SiteGlobal.GetRequestForm("MenuLink");
            intMenuSort     = Utils.IsNull(SiteGlobal.GetRequestForm("MenuSort"), "0").ToInt();
            strMenuDesc     = SiteGlobal.GetRequestForm("MenuDesc");

            intUseStateCode = Utils.IsNull(SiteGlobal.GetRequestForm("UseStateCode"), "0").ToInt();
            strMenuGroupNo  = SiteGlobal.GetRequestForm("MenuGroupNo");
            strAllParam     = SiteGlobal.GetRequestForm("AllParam");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
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
                case MethodAdminMenuList:
                    GetAdminMenuList();
                    break;
                case MethodAdminMenuGroupInfo:
                    GetAdminMenuGroupInfo();
                    break;
                case MethodAdminMenuInsert:
                    InsAdminMenu();
                    break;
                case MethodAdminMenuUpdate:
                    UpdAdminMenu();
                    break;
                case MethodAdminMenuUpdateList:
                    UpdAdminMenuList(strAllParam);
                    break;
                case MethodAdminMenuDelete:
                    DelAdminMenu(strMenuNo);
                    break;
                case MethodAdminMenuGroupUpdate:
                    UpdAdminMenuGroup(strAllParam);
                    break;
                case MethodAdminMenuGroupDelete:
                    DelAdminMenuGroup(strMenuGroupNo);
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

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    protected void GetAdminMenuList()
    {
        ReqAdminMenuList                lo_objReqAdminMenuList = null;
        ServiceResult<ResAdminMenuList> lo_objResAdminMenuList = null;

        try
        {
            lo_objReqAdminMenuList = new ReqAdminMenuList
            {
                MenuNo = strMenuNo.ToInt()
            };

            lo_objResAdminMenuList = objAdminMenuDasServices.GetAdminMenuList(lo_objReqAdminMenuList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResAdminMenuList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetAdminMenuGroupInfo()
    {
        ReqAdminMenuGroupList                lo_objReqAdminMenuGroupList = null;
        ServiceResult<ResAdminMenuGroupList> lo_objResAdminMenuGroupList = null;
        try
        {
            lo_objReqAdminMenuGroupList = new ReqAdminMenuGroupList
            {
                MenuGroupNo = strMenuGroupNo
            };

            lo_objResAdminMenuGroupList = objAdminMenuDasServices.GetAdminMenuGroupInfo(lo_objReqAdminMenuGroupList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResAdminMenuGroupList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void InsAdminMenu()
    {
        AdminMenuViewModel  lo_objReqInsAdminMenu = null;
        ServiceResult<bool> lo_objResInsAdminMenu = null;

        try
        {
            lo_objReqInsAdminMenu = new AdminMenuViewModel
            {
                MenuGroupNo  = strMenuGroupNo.ToInt(),
                MenuName     = strMenuName,
                MenuLink     = strMenuLink,
                MenuDesc     = strMenuDesc,
                UseStateCode = intUseStateCode,
            };

            lo_objResInsAdminMenu = objAdminMenuDasServices.InsAdminMenu(lo_objReqInsAdminMenu);
            objResMap.RetCode = lo_objResInsAdminMenu.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsAdminMenu.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }

    }
    protected void UpdAdminMenuGroup(string lo_strEventArgument)
    {
        int lo_intLoop = 0;
        int lo_intRetVal = 0;

        try
        {
            string[] lo_arrAllParam      = lo_strEventArgument.Split('|');

            string[] lo_arrMenuGroupNo   = lo_arrAllParam[0].Split(',');
            string[] lo_arrMenuGroupKind = lo_arrAllParam[1].Split(',');
            string[] lo_arrMenuGroupName = lo_arrAllParam[2].Split(',');
            string[] lo_arrMenuGroupSort = lo_arrAllParam[3].Split(',');
            string[] lo_arrDisplayFlag   = lo_arrAllParam[4].Split(',');

            string[] lo_arrUseFlag       = lo_arrAllParam[5].Split(',');

            for (lo_intLoop = 0; lo_intLoop < lo_arrMenuGroupNo.Length; lo_intLoop++)
            {
                lo_intRetVal = UpdMenu(lo_arrMenuGroupNo[lo_intLoop], lo_arrMenuGroupKind[lo_intLoop], lo_arrMenuGroupName[lo_intLoop], lo_arrMenuGroupSort[lo_intLoop], lo_arrDisplayFlag[lo_intLoop], lo_arrUseFlag[lo_intLoop]);
                if (!lo_intRetVal.Equals(0))
                {
                    return;
                }
            }
        }
        catch (Exception lo_ex)
        {
            SiteGlobal.WriteLog(
                "AdminMenuGroupList",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9139);
        }
    }


    protected void UpdAdminMenu()
    {
        AdminMenuViewModel lo_objReqInsAdminMenu = null;
        ServiceResult<bool> lo_objResInsAdminMenu = null;

        try
        {

            lo_objReqInsAdminMenu = new AdminMenuViewModel
            {
                MenuNo       = strMenuNo,
                MenuName     = strMenuName,
                MenuLink     = strMenuLink,
                MenuSort     = intMenuSort,
                MenuDesc     = strMenuDesc,
                UseStateCode = intUseStateCode,
            };

            lo_objResInsAdminMenu = objAdminMenuDasServices.UpdAdminMenu(lo_objReqInsAdminMenu);
            objResMap.RetCode = lo_objResInsAdminMenu.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsAdminMenu.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void DelAdminMenu(string lo_strMenuNo)
    {

        ServiceResult<bool> lo_objResDelAdminMenu = null;

        try
        {
            lo_objResDelAdminMenu = objAdminMenuDasServices.DelAdminMenu(lo_strMenuNo);
            objResMap.RetCode     = lo_objResDelAdminMenu.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResDelAdminMenu.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void UpdAdminMenuList(string lo_strEventArgument)
    {
        int lo_intLoop = 0;
        int lo_intRetVal = 0;

        try
        {
            string[] lo_arrAllParam     = lo_strEventArgument.Split('|');
            string[] lo_arrMenuNo       = lo_arrAllParam[0].Split(',');
            string[] lo_arrMenuSort     = lo_arrAllParam[1].Split(',');
            string[] lo_arrUseStateCode = lo_arrAllParam[2].Split(',');

            for (lo_intLoop = 0; lo_intLoop < lo_arrMenuNo.Length; lo_intLoop++)
            {
                lo_intRetVal = UpMenuList(lo_arrMenuNo[lo_intLoop], lo_arrMenuSort[lo_intLoop], lo_arrUseStateCode[lo_intLoop]);
                if (!lo_intRetVal.Equals(0))
                {
                    return;
                }
            }
        }
        catch (Exception lo_ex)
        {
            SiteGlobal.WriteLog(
                "AdminMenuGroupList",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9139);
        }
    }

    protected int UpMenuList(string lo_strMenuNo, string lo_strMenuSort, string lo_strUseStateCode)
    {
        AdminMenuViewModel    lo_objReqUpdAdminMenu = null;
        ServiceResult<bool>   lo_objResUpdAdminMenu = null;

        int lo_intRetVal = 0;
        try
        {
            lo_objReqUpdAdminMenu = new AdminMenuViewModel
            {
                MenuNo       = lo_strMenuNo,
                MenuSort     = lo_strMenuSort.ToInt(),
                UseStateCode = lo_strUseStateCode.ToInt()

            };

            lo_objResUpdAdminMenu = objAdminMenuDasServices.UpdAdminMenu(lo_objReqUpdAdminMenu);

            objResMap.RetCode     = lo_objResUpdAdminMenu.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdAdminMenu.result.ErrorMsg;
                return objResMap.RetCode;
            }

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }

        return lo_intRetVal;
    }

    protected int UpdMenu(string lo_strMenuGroupNo, string lo_strMenuGroupKind, string lo_strMenuGroupName, string lo_strMenuGroupSort, string lo_strDisplayFlag, string lo_strUseFlag)
    {
        ReqAdminMenuGroupList lo_objReqDelAdminMenuGroup = null;
        ServiceResult<bool>   lo_objResDelAdminMenuGroup = null;
        
        int lo_intRetVal = 0;
        try
        {
            lo_objReqDelAdminMenuGroup = new ReqAdminMenuGroupList
            {
                MenuGroupNo   = lo_strMenuGroupNo,
                MenuGroupKind = lo_strMenuGroupKind,
                MenuGroupName = lo_strMenuGroupName,
                MenuGroupSort = lo_strMenuGroupSort,
                DisplayFlag   = lo_strDisplayFlag,
                UseFlag       = lo_strUseFlag
            };

            lo_objResDelAdminMenuGroup = objAdminMenuDasServices.UpAdminMenuGroup(lo_objReqDelAdminMenuGroup);
            objResMap.RetCode          = lo_objResDelAdminMenuGroup.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResDelAdminMenuGroup.result.ErrorMsg + "1";
                return objResMap.RetCode;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }

        return lo_intRetVal;
    }
    protected void DelAdminMenuGroup(string lo_strMenuGroupNo)
    {
        ServiceResult<bool> lo_objResInsAdminMenuRole = null;

        try
        {
            lo_objResInsAdminMenuRole = objAdminMenuDasServices.DelAdminMenuGroup(lo_strMenuGroupNo);
            objResMap.RetCode         = lo_objResInsAdminMenuRole.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsAdminMenuRole.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuHandler", "Exception",
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