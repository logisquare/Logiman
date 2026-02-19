using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;

namespace SSO.Server
{
    public partial class SecurityFieldList : PageBase
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
            PageSize.Value = CommonConstant.PAGENAVIGATION_LIST;
        }

    }
}