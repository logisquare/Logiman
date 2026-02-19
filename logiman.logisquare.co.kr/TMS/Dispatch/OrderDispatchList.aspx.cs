using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.Dispatch
{
    public partial class OrderDispatchList : PageBase
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
            PageNo.Value   = "1";
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ORDER_ITEM_CHKLB(OrderItemCode, true, true, false, false);
            CommonDDLB.ITEM_DDLB(this, LocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);

            GoodsDispatchType.Items.Clear();
            GoodsDispatchType.Items.Add(new ListItem("배차구분", ""));
            GoodsDispatchType.Items.Add(new ListItem("미배차", "1"));
            GoodsDispatchType.Items.Add(new ListItem("직송", "2"));
            GoodsDispatchType.Items.Add(new ListItem("집하", "3"));

            DispatchType.Items.Clear();
            DispatchType.Items.Add(new ListItem("배차구분", ""));
            DispatchType.Items.Add(new ListItem("미배차", "1"));
            DispatchType.Items.Add(new ListItem("직송", "2"));
            DispatchType.Items.Add(new ListItem("집하", "3"));

            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ORDER_CLIENT_COMMON_TYPE_DDLB(SearchClientType);
            SearchClientType.SelectedIndex = 3;

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.Items.Add(new ListItem("하차일", "2"));
            DateType.Items.Add(new ListItem("접수일", "3"));
            DateType.SelectedIndex = 0;

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }

            string strCarNo      = Utils.IsNull(SiteGlobal.GetRequestForm("CarNo"),      "");
            string strCarComName = Utils.IsNull(SiteGlobal.GetRequestForm("CarComName"), "");
            string strClientName = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");

            if (!string.IsNullOrWhiteSpace(strCarNo))
            {
                CarNo.Text = strCarNo;
            }

            if (!string.IsNullOrWhiteSpace(strCarComName))
            {
                ComName.Text = strCarComName;
            }

            if (!string.IsNullOrWhiteSpace(strClientName))
            {
                SearchClientType.SelectedValue = "1";
                SearchClientText.Text          = strClientName;
            }
        }
    }
}