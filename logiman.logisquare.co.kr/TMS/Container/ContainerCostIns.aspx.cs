using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.Container
{
    public partial class ContainerCostIns : PageBase
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
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ORDER_ITEM_CHKLB(OrderItemCode, false, false, true, false);
            CommonDDLB.ORDER_CLIENT_TYPE_DDLB(SearchClientType);
            SearchClientType.SelectedIndex = 1;
            CommonDDLB.ORDER_CHARGE_TYPE_DDLB(SearchChargeType);
            SearchChargeType.SelectedIndex = 1;
            CommonDDLB.ITEM_DDLB(Page, GoodsItemCode, "OE", objSes.AccessCenterCode, objSes.AdminID, "품목");
            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("구분",      ""));
            SearchType.Items.Add(new ListItem("선사",      "1"));
            SearchType.Items.Add(new ListItem("CNTR No", "2"));
            SearchType.Items.Add(new ListItem("BL No",   "3"));
            SearchType.SelectedIndex = 1;
            CommonDDLB.SORT_TYPE_DDLB(SortType);
            SortType.SelectedIndex = 1;

            CommonDDLB.ITEM_DDLB(Page, GoodsItemCode, "OE", objSes.AccessCenterCode, objSes.AdminID, "품목");
            CommonDDLB.PAY_TYPE_DDLB(PayType);
            PayType.SelectedValue = PayType.Items.FindByText("매출").Value;
            CommonDDLB.PAY_TAX_KIND_DDLB(TaxKind);
            TaxKind.SelectedValue = TaxKind.Items.FindByText("과세").Value;
            CommonDDLB.ITEM_DDLB(Page, ItemCode, "OP", objSes.AccessCenterCode, objSes.AdminID, "비용항목");
            ItemCode.SelectedValue = ItemCode.Items.FindByText("운임").Value;
            CommonDDLB.CAR_DIV_TYPE_DDLB(CarDivType);
            CommonDDLB.INSURE_EXCEPT_KIND_DDLB(InsureExceptKind);
        }
    }
}