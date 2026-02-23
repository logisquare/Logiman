using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;
using System.Web.UI;

///================================================================
/// <summary>
/// FileName        : Login.cs
/// Description     : 로그인 페이지
/// Copyright ⓒ 2018 by LOGISLAB. All rights reserved.
/// Author          : shadow54@logislab.com, 2022-03-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
namespace SSO.Login
{
    public partial class Login : PageInit
    {
        protected string strReturnUrl   = string.Empty;
        protected string strWebTemplate = string.Empty;

        ///----------------------------------------------------------------------
        /// <summary>
        /// Name          : Page_Load()
        /// Description   : 페이지 로드(포스트백인지 체크)
        /// Special Logic : NONE    
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        ///----------------------------------------------------------------------
        protected void Page_Load(object sender, EventArgs e)
        {
            //===============================================================
            // 서비스 점검 페이지 노출 (레지스트리에 등록된 IP만 접근 허용)
            //===============================================================
            CheckServiceStop();

            // iframe 안에 로그인 창이 구동된 경우, top window로 redirect 한다.
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                                                "if(window != window.top) {window.top.location = '/';}", true);

            Page.ClientScript.GetPostBackEventReference(this, "");

            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void CheckServiceStop()
        {
            string lo_strServiceStopFlag    = string.Empty;
            string lo_strServiceStopAllowIP = string.Empty;

            //===============================================================
            // 서비스 점검 페이지 노출 (레지스트리에 등록된 IP만 접근 허용)
            //===============================================================
            lo_strServiceStopFlag = CommonLibrary.CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_FLAG).ToString();
            if (lo_strServiceStopFlag.Equals("Y"))
            {
                if (!CommonLibrary.CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_ALLOWIP).ToString().Contains(SiteGlobal.GetRemoteAddr()))
                {
                    Response.Redirect("/SSO/Login/ServiceStop", true);
                    return;
                }
            }
        }

        protected void GetInitData()
        {
            try
            {
                strWebTemplate = "default";

                strReturnUrl   = Request.QueryString["returnurl"];

                if (string.IsNullOrWhiteSpace(strReturnUrl))
                {
                    strReturnUrl = CommonConstant.MAIN_PAGE_1;
                }

                returnurl.Value = strReturnUrl;
                errmsg.Value    = Request.QueryString["errmsg"];
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Login", "Exception"
                                  , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9300);
            }
        }
    }
}