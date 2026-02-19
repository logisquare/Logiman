using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web;
using System.Web.UI;

namespace SMS.Insure
{
    public partial class Index : PageInit
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Title = CommonConstant.SMS_TITLE_SIMPLE;

            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            string lo_strNo = string.Empty;

            lo_strNo = Utils.IsNull(SiteGlobal.GetRequestForm("No"), "");

            if (string.IsNullOrWhiteSpace(lo_strNo))
            {
                DisplayMode.Value = "N";
                ErrMsg.Value      = "페이지를 표시할 수 없습니다.";
                return;
            }

            No.Value           = lo_strNo;
            MobileDevice.Value = Utils.IsMobileBrowser(HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"]);

            //============================================
            // KCP 모바일 인증 변수 초기값 설정
            //============================================
            site_cd.Value    = SiteGlobal.M_KCP_AUTH_SITE_CD;
            web_siteid.Value = SiteGlobal.M_KCP_AUTH_WEB_SITEID;
            Ret_URL.Value    = SiteGlobal.M_KCP_AUTH_RET_URL;
        }
    }
}