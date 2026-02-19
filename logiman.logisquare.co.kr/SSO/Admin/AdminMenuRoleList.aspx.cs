using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;

namespace SSO.Admin
{
    public partial class AdminMenuRoleList : PageBase
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
            PageSize.Value = CommonConstant.PAGENAVIGATION_LIST;
        }
    }
}