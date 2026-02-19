using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.Container
{
    public partial class ContainerList : PageBase
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

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ORDER_ITEM_CHKLB(OrderItemCode, false, false, true, false);
            CommonDDLB.ORDER_CLIENT_TYPE_DDLB(SearchClientType);
            SearchClientType.SelectedIndex = 1;
            CommonDDLB.ORDER_CHARGE_TYPE_DDLB(SearchChargeType);
            SearchChargeType.SelectedIndex = 1;
            CommonDDLB.ITEM_DDLB(Page, GoodsItemCode, "OE", objSes.AccessCenterCode, objSes.AdminID, "품목");
            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("구분", ""));
            SearchType.Items.Add(new ListItem("선사", "1"));
            SearchType.Items.Add(new ListItem("CNTR No", "2"));
            SearchType.Items.Add(new ListItem("BL No", "3"));
            SearchType.SelectedIndex = 1;
            CommonDDLB.SORT_TYPE_DDLB(SortType);
            SortType.SelectedIndex = 1;

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }

            CommonDDLB.ITEM_DDLB(Page, ChgOrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
        }
    }
}