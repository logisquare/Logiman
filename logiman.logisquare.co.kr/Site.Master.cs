using System;
using System.Web;
using System.Web.UI;

namespace logiman.logisquare.co.kr
{
    public partial class SiteMaster : MasterPage
    {
        protected string strThemeStyle = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            mainform.Action = HttpContext.Current.Request.Url.AbsolutePath;

            DisplayThemeMode();
        }

        protected void DisplayThemeMode()
        {
            
            if (Request.Cookies["ThemeStyle"] != null)
            {
                if (Request.Cookies["ThemeStyle"].Value.Equals("dark"))
                {
                    ThemeStyle.Attributes["href"] = "/css/theme-dark.css?ver=" + DateTime.Now.ToString("yyyyMMddHHmmss"); //다크모드
                }
                else {
                    ThemeStyle.Attributes["href"] = "/css/theme-default.css?ver=" + DateTime.Now.ToString("yyyyMMddHHmmss"); //일반모드
                }
            }
            else {
                ThemeStyle.Attributes["href"] = "/css/theme-default.css?ver=" + DateTime.Now.ToString("yyyyMMddHHmmss"); //일반모드
            }
        }
    }
}