using CommonLibrary.Session;
using CommonLibrary.CommonUtils;
using System;
using System.Web;
using System.Web.UI;
using CommonLibrary.CommonModule;

namespace logiman.logisquare.co.kr
{
    public partial class AppSiteMaster : MasterPage
    {
        AppSession objSes = new AppSession();

        protected void Page_Load(object sender, EventArgs e)
        {
            objSes.GetSessionCookie();

            if (!IsPostBack)
            {
                SetInitData();
            }
            else
            {
                GetPostBackData();
            }
        }
        protected void SetInitData()
        {
            hid_MOBILE_DEVICE.Value = Utils.IsMobileBrowser(HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"]);
        }

        protected void GetPostBackData()
        {
            string lo_strEventTarget = SiteGlobal.GetRequestForm("__EVENTTARGET");
            if (lo_strEventTarget.Equals("LogOut"))
            {
                objSes.goLogout();
            }
        }
    }
}