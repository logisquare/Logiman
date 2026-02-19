using System;
using System.Web.UI;
using CommonLibrary.CommonModule;

namespace logiman.logisquare.co.kr
{
    public partial class PopupMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DisplayThemeMode();
            }

        }

        protected void GetInitData()
        {
            p_popup.Value = SiteGlobal.GetRequestForm("popup");

            if (!p_popup.Value.Equals("Y"))
            {
                divPOPUP_TITLE_LAYER.Style.Add("margin-top", "10px");
            }
            else
            {
                divPOPUP_TITLE_LAYER.Style.Add("margin-top", "10px");
                if (!string.IsNullOrWhiteSpace(SiteGlobal.GetRequestForm("title")))
                {
                    lblPOPUP_TITLE.Text = SiteGlobal.GetRequestForm("title");
                }
            }
        }

        protected void DisplayThemeMode() {
            if (Request.Cookies["ThemeStyle"] != null)
            {
                if (Request.Cookies["ThemeStyle"].Value.Equals("dark"))
                {
                    ThemeStyle.Attributes["href"] = "/css/theme-dark.css?ver=" + DateTime.Now.ToString("yyyyMMddHHmmss"); //다크모드
                }
                else
                {
                    ThemeStyle.Attributes["href"] = "/css/theme-default.css?ver=" + DateTime.Now.ToString("yyyyMMddHHmmss"); //일반모드
                }
            }
            else
            {
                ThemeStyle.Attributes["href"] = "/css/theme-default.css?ver=" + DateTime.Now.ToString("yyyyMMddHHmmss"); //일반모드
            }
        }
    }
}