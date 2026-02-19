using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Inout
{
    public partial class InoutGMOrderIns : PageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);

            CommonDDLB.ORDER_ITEM_DDLB(OrderItemCode, false, true, false, false);
            OrderItemCode.SelectedValue = OrderItemCode.Items.FindByText("해상수출") == null ? string.Empty : OrderItemCode.Items.FindByText("해상수출").Value;

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}