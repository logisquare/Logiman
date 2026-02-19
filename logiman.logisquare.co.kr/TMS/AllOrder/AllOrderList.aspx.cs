using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.AllOrder
{
    public partial class AllOrderList : PageBase
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
            CommonDDLB.ORDER_ITEM_CHKLB(OrderItemCode, true, true, false, false);
            CommonDDLB.ORDER_STATUS_CHKLB(OrderStatus);
            CommonDDLB.ORDER_CLIENT_COMMON_TYPE_DDLB(SearchClientType);
            SearchClientType.SelectedIndex = 1;
            CommonDDLB.ORDER_PLACE_TYPE_DDLB(SearchPlaceType);
            SearchPlaceType.SelectedIndex = 1;
            CommonDDLB.ORDER_CHARGE_TYPE_DDLB(SearchChargeType);
            SearchChargeType.SelectedIndex = 1;
            CommonDDLB.SORT_TYPE_DDLB(SortType);
            SortType.SelectedIndex = 1;

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.Items.Add(new ListItem("하차일", "2"));
            DateType.Items.Add(new ListItem("접수일", "3"));
            DateType.SelectedIndex = 0;

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }

            CommonDDLB.ITEM_DDLB(Page, ChgOrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
        }
    }
}