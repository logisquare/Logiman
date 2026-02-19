using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.Inout
{
    public partial class InoutPayList : PageBase
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
            CommonDDLB.ORDER_CLIENT_COMMON_TYPE_DDLB(SearchClientType);

            PayType.Items.Clear();
            PayType.Items.Add(new ListItem("매출", "1"));
            PayType.Items.Add(new ListItem("매입", "2"));
            PayType.Items.Add(new ListItem("매출+선급금", "3"));
            PayType.Items.Add(new ListItem("매출+예수금", "4"));
            PayType.SelectedIndex = 0;

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.SelectedIndex = 0;
        }
    }
}