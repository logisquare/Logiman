using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web;
using System.Web.UI;

namespace KCP.SmartCert
{
    public partial class SmartCertRes : PageInit
    {
        private string tmp_form      = string.Empty;
        private string mobile_device = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            mobile_device = Utils.IsMobileBrowser(HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"]);

            // request 로 넘어온 값 처리
            foreach (string item in Request.Form)
            {
                // 부모창으로 넘기는 form 데이터 생성 필드
                tmp_form += "<input type='hidden' name='" + item + "' value='" + Request.Form[item] + "'>";
            } // foreach (string item in Request.Form) - END

            tmp_form += "<input type='hidden' id='mobile_device' value='" + mobile_device + "'>";

            form_auth.InnerHtml = tmp_form;
        }
    }
}

