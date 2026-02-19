using System;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;

namespace SMS.SafetyCheck
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
            string lo_strTitle = string.Empty;
            string lo_strMsg   = string.Empty;

            lo_strTitle = Utils.IsNull(SiteGlobal.GetRequestForm("Title"), "안내");
            lo_strMsg   = Utils.IsNull(SiteGlobal.GetRequestForm("Msg"), "본 서비스의 이용이 불가능합니다.");

            MsgTitle.Text = lo_strTitle;
            Msg.Text      = lo_strMsg;
        }
    }
}