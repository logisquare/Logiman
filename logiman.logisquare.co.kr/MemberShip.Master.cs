using System;
using System.Web.UI;
using CommonLibrary.CommonModule;

namespace logiman.logisquare.co.kr
{
    public partial class MemberShip : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DisplayThemeMode();
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