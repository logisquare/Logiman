using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClosingAdvance
{
    public partial class AdvanceDepositList : PageBase
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

            PayType.Items.Clear();
            PayType.Items.Add(new ListItem("전체",  ""));
            PayType.Items.Add(new ListItem("선급금", "3"));
            PayType.Items.Add(new ListItem("예수금", "4"));
            PayType.SelectedIndex = 0;

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("입금일", "7"));
            DateType.SelectedIndex = 0;

            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);

        }
    }
}