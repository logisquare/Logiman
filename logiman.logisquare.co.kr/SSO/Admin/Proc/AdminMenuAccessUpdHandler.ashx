<%@ WebHandler Language="C#" Class="AdminMenuAccessUpdHandler" %>
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
/// FileName        : AdminMenuAccessUpdHandler.ashx
/// Description     : 어드민 메뉴 권한 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-04-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class AdminMenuAccessUpdHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Admin/AdminMenuAccessUpd"; //필수

    // 메소드 리스트
    private const string MethodAdminMenuAccessInsert   = "AdminMenuAccessInsert";

    AdminDasServices objAdminDasServices = new AdminDasServices();

    private string strCallType = string.Empty;
    private int    intPageSize = 0;
    private int    intPageNo   = 0;

    private int    intAccessTypeCode = 0;
    private string strAdminID        = string.Empty;
    private string strAddMenuList    = string.Empty;
    private string strRmMenuList     = string.Empty;
    private string strAllAuthCode    = string.Empty;
    private string strRwAuthCode     = string.Empty;
    private string strRoAuthCode     = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAdminMenuAccessInsert,    MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("AdminMenuAccessUpdHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AdminMenuAccessUpdHandler");
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
            strAddMenuList    = SiteGlobal.GetRequestForm("AddMenuList");
            strAdminID        = SiteGlobal.GetRequestForm("AdminID");;
            intAccessTypeCode = Utils.IsNull(SiteGlobal.GetRequestForm("AccessTypeCode"), "0").ToInt();
            strRmMenuList     = SiteGlobal.GetRequestForm("RmMenuList");
            strAllAuthCode    = SiteGlobal.GetRequestForm("AllAuthCode");
            strRwAuthCode     = SiteGlobal.GetRequestForm("RwAuthCode");
            strRoAuthCode     = SiteGlobal.GetRequestForm("RoAuthCode");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuAccessUpdHandler", "Exception",
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
                case MethodAdminMenuAccessInsert:
                    InsMenuAccessAdmin();
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

            SiteGlobal.WriteLog("AdminMenuAccessUpdHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    protected void InsMenuAccessAdmin()
    {
        AdminMenuAccessViewModel lo_objAdminMenuAccessViewModel = null;
        ServiceResult<bool>      lo_objResInsMenuAccessAdmin    = null;
            

        if (!intAccessTypeCode.Equals(1) && !intAccessTypeCode.Equals(2))
        {
            objResMap.RetCode = 9901;
            objResMap.ErrMsg  = "전송된 데이터가 올바르지 않습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strAdminID))
        {
            objResMap.RetCode = 9902;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objAdminMenuAccessViewModel = new AdminMenuAccessViewModel
            {
                AdminID        = strAdminID,
                AddMenuList    = strAddMenuList,
                RmMenuList     = strRmMenuList,
                AllAuthCode    = strAllAuthCode,
                RwAuthCode     = strRwAuthCode,
                RoAuthCode     = strRoAuthCode,
                AccessTypeCode = intAccessTypeCode
            };

            lo_objResInsMenuAccessAdmin = objAdminDasServices.InsMenuAccessAdmin(lo_objAdminMenuAccessViewModel);
            objResMap.RetCode           = lo_objResInsMenuAccessAdmin.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsMenuAccessAdmin.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AdminMenuAccessUpdHandler", "Exception",
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