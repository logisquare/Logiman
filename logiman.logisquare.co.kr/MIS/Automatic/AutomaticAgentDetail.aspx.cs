using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace MIS.Automatic
{
    public partial class AutomaticAgentDetail : PageBase
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
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;
            PageNo.Value   = "1";

            DateType.Value      = SiteGlobal.GetRequestForm("DateType");
            DateFrom.Value      = SiteGlobal.GetRequestForm("DateFrom");
            DateTo.Value        = SiteGlobal.GetRequestForm("DateTo");
            CenterCode.Value    = SiteGlobal.GetRequestForm("CenterCode");
            AgentCode.Value     = SiteGlobal.GetRequestForm("AgentCode");
            AgentName.InnerText = SiteGlobal.GetRequestForm("AgentName");
            OrderItemCode.Value = SiteGlobal.GetRequestForm("OrderItemCodes");
        }
    }
}