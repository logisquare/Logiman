using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Extensions;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClosingSaleDeposit
{
    public partial class DepositList : PageBase
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
            SetOffExcelYear.Items.Clear();
            for (int i = DateTime.Now.Year.ToInt(); i >= 2017; i--)
            {
                SetOffExcelYear.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }

            SetOffType.Items.Clear();
            SetOffType.Items.Add(new ListItem("선수", "3"));
            SetOffType.Items.Add(new ListItem("예수", "4"));


            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {

                BtnTotalExcel.Style.Add("display", "none");
                BtnSaleExcel.Style.Add("display", "none");
                BtnDepositExcel.Style.Add("display", "none");
                BtnSetOffExcel.Style.Add("display", "none");
            }
        }
    }
}