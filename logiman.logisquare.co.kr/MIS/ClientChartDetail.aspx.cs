using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace MIS
{
    public partial class ClientChartDetail : PageBase
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
            PageNo.Value   = "1";

            CHART_YEAR_DDLB(DateYear);//년도 가져오기 - 2019년 이후
            CenterCode.Value       = SiteGlobal.GetRequestForm("CenterCode");
            ClientCode.Value       = SiteGlobal.GetRequestForm("ClientCode");
            DateYear.SelectedValue = SiteGlobal.GetRequestForm("DateYear");
            ClientName.InnerText   = SiteGlobal.GetRequestForm("ClientName");
            OrderItemCodes.Value   = SiteGlobal.GetRequestForm("OrderItemCodes");
        }

        public static void CHART_YEAR_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            int startYear = 2019;
            int currYear  = DateTime.Now.Year;

            for (int i = startYear; i <= currYear; i++)
            {
                DDLB.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }

            DDLB.SelectedValue = currYear.ToString();
        }
    }
}