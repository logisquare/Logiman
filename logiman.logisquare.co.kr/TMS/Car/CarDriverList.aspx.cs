using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;

namespace TMS.Car
{
    public partial class CarDriverList : PageBase
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
            PageNo.Value = "1";
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.USE_FLAG_DDLB(UseFlag);
        }
    }
}