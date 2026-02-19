using CommonLibrary.Session;
using CommonLibrary.CommonUtils;
using System;
using System.Web;
using System.Web.UI;
using CommonLibrary.CommonModule;

namespace logiman.logisquare.co.kr
{
    public partial class AppPopupMaster : MasterPage
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
            pMenu.Value  = Utils.IsNull(SiteGlobal.GetRequestForm("pMenu"), "/APP/TMS/Domestic/DomesticList");
            pParam.Value = SiteGlobal.GetRequestForm("pParam");

            hid_MOBILE_DEVICE.Value = Utils.IsMobileBrowser(HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"]);
            PopMastertitle.Text = Utils.IsNull(SiteGlobal.GetRequestForm("PopMastertitle"), "");
        }

        protected void GetPostBackData()
        {
            string lo_strEventTarget = SiteGlobal.GetRequestForm("__EVENTTARGET");
        }
    }
}