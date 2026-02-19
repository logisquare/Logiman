using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.Dispatch
{
    public partial class OrderDispatchArrivalList : PageBase
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
            PageNo.Value = "1";
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ORDER_CLIENT_COMMON_TYPE_DDLB(SearchClientType);
            SearchClientType.SelectedIndex = 3;

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.Items.Add(new ListItem("하차일", "2"));
            DateType.Items.Add(new ListItem("접수일", "3"));
            DateType.SelectedIndex = 0;

            GetStandardType.Items.Clear();
            GetStandardType.Items.Add(new ListItem("당착+익일", ""));
            GetStandardType.Items.Add(new ListItem("당일하차", "1"));
            GetStandardType.Items.Add(new ListItem("익일하차", "2"));

            OrderItemCodes.Value = "OA003,OA002"; //외주 상품조회 제한

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}