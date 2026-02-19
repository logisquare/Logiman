using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Cargopass
{
    public partial class CargopassError : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadWrite;
        }

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