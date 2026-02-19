using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClosingPurchase
{
    public partial class PurchaseCarList : PageBase
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
            HidMyOrderFlag.Value = objSes.MyOrderFlag;
            if (!HidMyOrderFlag.Value.Equals("Y"))
            {
                ChkMyOrder.Checked = false;
            }

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            ClosingFlag.Items.Clear();
            ClosingFlag.Items.Add(new ListItem("마감여부", ""));
            ClosingFlag.Items.Add(new ListItem("마감", "Y"));
            ClosingFlag.Items.Add(new ListItem("미마감", "N"));
            ClosingFlag.SelectedIndex = 0;
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ITEM_CHKLB(Page, DeliveryLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ORDER_ITEM_CHKLB(OrderItemCode, true, true, true, true);

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.SelectedIndex = 0;

            CommonDDLB.CAR_DIV_TYPE_DDLB(CarDivType);

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
                BtnDetailSaveExcel.Style.Add("display", "none");
            }

            CommonDDLB.BANK_DDLB(PopBankCode);
        }
    }
}