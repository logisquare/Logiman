using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;

namespace TMS.Common
{
    public partial class OrderInoutPrintTransport : PageBase
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
            PageSize.Value   = CommonConstant.PAGENAVIGATION_LIST;
            PageNo.Value     = "1";
            HidGridID.Value  = SiteGlobal.GetRequestForm("GridID");
            CenterCode.Value = SiteGlobal.GetRequestForm("CenterCode");
            OrderNos.Value   = SiteGlobal.GetRequestForm("OrderNos");
        }
    }
}