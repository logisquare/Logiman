using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;
using CommonLibrary.Constants;

namespace TMS.Inout
{
    public partial class InoutUpsList : PageBase
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
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ORDER_ITEM_CHKLB(OrderItemCode, false, true, false, false);

            PayClientCode.Value      = SiteGlobal.UPS_CLIENT_CODE;
            CenterCode.SelectedValue = CommonConstant.DEFAULT_CENTER_CODE.ToString();
            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.SelectedIndex = 0;
        }
    }
}