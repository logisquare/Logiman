using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using DocumentFormat.OpenXml.Spreadsheet;

using System;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;

namespace TMS.Common
{
    public partial class OrderContainerPrintTransport : PageBase
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
            PageNo.Value = "1";

            HidGridID.Value = SiteGlobal.GetRequestForm("GridID");
            OrderNos.Value = SiteGlobal.GetRequestForm("OrderNos");
            CenterCode.Value = SiteGlobal.GetRequestForm("CenterCode");
        }
    }
}