using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace SSO.Item
{
    public partial class ItemAdminList : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadOnly;
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
        }
    }
}