using System;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;

namespace SMS.Common
{
    public partial class Error : PageInit
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
            string lo_strMsg = string.Empty;
            lo_strMsg = Utils.IsNull(SiteGlobal.GetRequestForm("Msg"), "");
            Msg.Text  = lo_strMsg;
        }
    }
}