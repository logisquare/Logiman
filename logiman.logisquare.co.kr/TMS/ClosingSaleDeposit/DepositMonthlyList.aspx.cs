using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Extensions;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClosingSaleDeposit
{
    public partial class DepositMonthlyList : PageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.CLIENT_BUSINESS_STATUS_DDLB(ClientBusinessStatus);
            SearchYear.Items.Clear();
            for (int i = DateTime.Now.Year.ToInt(); i >= 2017; i--)
            {
                SearchYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
            ChkViewMonth.Items.Clear();
            ChkViewMonth.Items.Add(new ListItem("<span class=\"ChkAll\"></span>전체", ""));
            for (int i = 1; i <= 12; i++)
            {
                ChkViewMonth.Items.Add(new ListItem("<span></span>" + i + "월", i.ToString()));
            }

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}