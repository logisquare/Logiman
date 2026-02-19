using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI;

namespace SMS.Common
{
    public partial class Join : PageInit
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            string lo_strNo     = string.Empty;
            string lo_strRetUrl = string.Empty;

            lo_strNo     = Utils.IsNull(SiteGlobal.GetRequestForm("No"),     string.Empty);
            lo_strRetUrl = Utils.IsNull(SiteGlobal.GetRequestForm("RetUrl"), string.Empty);

            if (string.IsNullOrWhiteSpace(lo_strNo) || string.IsNullOrWhiteSpace(lo_strRetUrl))
            {
                DisplayMode.Value = "N";
                ErrMsg.Value      = "페이지를 표시할 수 없습니다.";
                return;
            }
            No.Value     = lo_strNo;
            RetUrl.Value = lo_strRetUrl;
        }
    }
}