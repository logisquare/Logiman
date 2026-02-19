using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;
using CommonLibrary.Constants;

namespace TMS.Common
{
    public partial class WebOrderRequestChgList : PageBase
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
            PageNo.Value = "1";
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);

            HidListType.Value = SiteGlobal.GetRequestForm("ListType");
        }
    }
}