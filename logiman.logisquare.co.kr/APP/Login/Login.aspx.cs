using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;
using System.Web.UI;

namespace APP.Login
{
    public partial class LoginApp : PageInit
    {
        protected string strReturnUrl = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            //===============================================================
            // 서비스 점검 페이지 노출 (레지스트리에 등록된 IP만 접근 허용)
            //===============================================================
            CheckServiceStop();

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
                    Response.Redirect("/APP/Login/ServiceStop", true);
                    return;
                }
            }
        }

        protected void GetInitData()
        {
            try
            {
                strReturnUrl = Request.QueryString["returnurl"];
                if (string.IsNullOrWhiteSpace(strReturnUrl))
                {
                    strReturnUrl = CommonConstant.APP_PAGE_1;
                }

                returnurl.Value = strReturnUrl;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("AppLogin", "Exception"
                                  , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9300);
            }
        }
    }
}