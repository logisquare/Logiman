using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClosingAdvance
{
    public partial class AdvanceList : PageBase
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

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);

            PayType.Items.Clear();
            PayType.Items.Add(new ListItem("전체", ""));
            PayType.Items.Add(new ListItem("선급금", "3"));
            PayType.Items.Add(new ListItem("예수금", "4"));
            PayType.SelectedIndex = 0;

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.Items.Add(new ListItem("하차일", "2"));
            DateType.Items.Add(new ListItem("접수일", "3"));
            DateType.SelectedIndex = 0;

            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ORDER_ITEM_CHKLB(OrderItemCode, false, true, false, false);

            CommonDDLB.ORDER_CLIENT_COMMON_TYPE_DDLB(SearchClientType);
            SearchClientType.SelectedIndex = 2;
            CommonDDLB.ORDER_CHARGE_TYPE_DDLB(SearchChargeType);
            SearchChargeType.SelectedIndex = 2;

            RPayType.Items.Clear();
            RPayType.Items.Add(new ListItem("선급금", "3"));
            RPayType.Items.Add(new ListItem("예수금", "4"));
            RPayType.SelectedIndex = 0;

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}