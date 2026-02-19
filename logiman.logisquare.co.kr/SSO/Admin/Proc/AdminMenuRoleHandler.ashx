<%@ WebHandler Language="C#" Class="AdminMenuRoleHandler" %>
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
/// FileName        : AdminMenuRoleHandler.ashx
/// Description     : 어드민 메뉴 열할 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jtoh@logislab.com, 2022-04-05
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class AdminMenuRoleHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Admin/AdminMenuRoleList"; //필수

    // 메소드 리스트
    private const string MethodAdminMenuRoleList   = "AdminMenuRoleList";
    private const string MethodAdminMenuRoleDelete = "AdminMenuRoleDelete";
    private const string MethodAdminMenuRoleInsert = "AdminMenuRoleInsert";
    private const string MethodAdminMenuRoleUpdate = "AdminMenuRoleUpdate";
    AdminMenuDasServices objAdminMenuDasServices   = new AdminMenuDasServices();

    private string strCallType = string.Empty;
    private int    intPageSize = 0;
    private int    intPageNo   = 0;

    private int    intMenuRoleNo   = 0;
    private string strMenuRoleName = string.Empty;
    private string strUseFlag      = string.Empty;
    private int    intMenuNo       = 0;
    private string strAuthCode     = string.Empty;

    private int    intUseStateCode = 0;
    private int    intMenuGroupNo  = 0;
    private string strAddMenuList   = string.Empty;
    private string strRmMenuList    = string.Empty;
    private string strAllAuthCode   = string.Empty;

    private string strRoAuthCode    = string.Empty;
    private string strRwAuthCode = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAdminMenuRoleList,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAdminMenuRoleDelete, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminMenuRoleInsert, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAdminMenuRoleUpdate, MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("AdminMenuRoleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AdminMenuRoleHandler");
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
            // AdminMenuRole List

            intMenuRoleNo    = Utils.IsNull(SiteGlobal.GetRequestForm("MenuRoleNo"), "0").ToInt();
            strMenuRoleName  = SiteGlobal.GetRequestForm("MenuRoleName");
            strUseFlag       = SiteGlobal.GetRequestForm("UseFlag");
            intMenuNo        = Utils.IsNull(SiteGlobal.GetRequestForm("MenuNo"), "0").ToInt();
            strAuthCode      = SiteGlobal.GetRequestForm("AuthCode");
                             
            intUseStateCode  = Utils.IsNull(SiteGlobal.GetRequestForm("UseStateCode"), "0").ToInt();
            intMenuGroupNo   = Utils.IsNull(SiteGlobal.GetRequestForm("MenuGroupNo"), "0").ToInt();
            strAddMenuList   = SiteGlobal.GetRequestForm("AddMenuList");
            strRmMenuList    = SiteGlobal.GetRequestForm("RmMenuList");
            strAllAuthCode   = SiteGlobal.GetRequestForm("AllAuthCode");

            strRoAuthCode    = SiteGlobal.GetRequestForm("RoAuthCode");
            strRwAuthCode    = SiteGlobal.GetRequestForm("RwAuthCode");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuRoleHandler", "Exception",
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
                case MethodAdminMenuRoleList:
                    GetAdminMenuRoleList();
                    break;
                case MethodAdminMenuRoleDelete:
                    GetAdminMenuRoleDelete();
                    break;
                case MethodAdminMenuRoleInsert:
                    GetAdminMenuRoleInsert();
                    break;
                case MethodAdminMenuRoleUpdate:
                    GetAdminMenuRoleUpdate();
                    break;
                default:
                    objResMap.RetCode = 9500;
                    objResMap.ErrMsg = "Wrong Method" + strCallType;
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9403;
            objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuRoleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    protected void GetAdminMenuRoleList()
    {
        ReqAdminMenuRoleList                lo_objReqAdminMenuRoleList = null;
        ServiceResult<ResAdminMenuRoleList> lo_objResAdminMenuRoleList = null;

        try
        {
            lo_objReqAdminMenuRoleList = new ReqAdminMenuRoleList
            {
                MenuRoleNo = 0
            };

            lo_objResAdminMenuRoleList = objAdminMenuDasServices.GetAdminMenuRoleList(lo_objReqAdminMenuRoleList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResAdminMenuRoleList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuRoleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    protected void GetAdminMenuRoleDelete()
    {
        AdminMenuRoleViewModel lo_objReqInsAdminMenuRole = null;
        ServiceResult<bool>    lo_objResInsAdminMenuRole = null;

        try
        {
            lo_objReqInsAdminMenuRole = new AdminMenuRoleViewModel
            {
                MenuRoleNo = intMenuRoleNo,
            };

            lo_objResInsAdminMenuRole = objAdminMenuDasServices.DelAdminMenuRole(lo_objReqInsAdminMenuRole);
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

            SiteGlobal.WriteLog("AdminMenuRoleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }


    protected void GetAdminMenuRoleInsert()
    {
        ServiceResult<bool> lo_objResInsAdminMenuRole = null;

        try
        {
            lo_objResInsAdminMenuRole = objAdminMenuDasServices.InsRole(strMenuRoleName, strAddMenuList, strAllAuthCode, strRwAuthCode , strRoAuthCode,strUseFlag);

            objResMap.RetCode = lo_objResInsAdminMenuRole.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsAdminMenuRole.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuRoleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetAdminMenuRoleUpdate()
    {
        ServiceResult<bool> lo_objResAdminMenuRoleUpdate = null;

        try
        {
            lo_objResAdminMenuRoleUpdate = objAdminMenuDasServices.UpdRole(intMenuRoleNo.ToString(), strMenuRoleName, strAddMenuList, strRmMenuList, strAllAuthCode, strRoAuthCode, strRwAuthCode, strUseFlag);

            objResMap.RetCode = lo_objResAdminMenuRoleUpdate.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResAdminMenuRoleUpdate.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuRoleHandler", "Exception",
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