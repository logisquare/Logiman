using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.Domestic
{
    public partial class DomesticList : PageBase
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

            HidMyOrderFlag.Value = objSes.MyOrderFlag;
            if (!HidMyOrderFlag.Value.Equals("Y"))
            {
                ChkMyOrder.Checked = false;
            }

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ORDER_STATUS_CHKLB(OrderStatus);
            CommonDDLB.ORDER_CLIENT_COMMON_TYPE_DDLB(SearchClientType);
            SearchClientType.SelectedIndex = 3;
            CommonDDLB.ORDER_PLACE_TYPE_DDLB(SearchPlaceType);
            SearchPlaceType.SelectedIndex = 1;
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

            if (objSes.GradeCode > 4)
            {
                BtnAmtRequest.Style.Add("display", "none");
            }

            TransCenterCode.Items.Clear();
            TransCenterCode.Items.Add(new ListItem("이관운송사", ""));

            ContractCenterCode.Items.Clear();
            ContractCenterCode.Items.Add(new ListItem("위탁운송사", ""));

            CommonDDLB.ITEM_DDLB(Page, ChgOrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);

            string strCarNo      = Utils.IsNull(SiteGlobal.GetRequestForm("CarNo"),      "");
            string strComCorpNo  = Utils.IsNull(SiteGlobal.GetRequestForm("ComCorpNo"),  "");
            string strClientName = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");
            string strPlaceName  = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceName"),  "");

            if (!string.IsNullOrWhiteSpace(strCarNo))
            {
                CarNo.Text = strCarNo;
            }

            if (!string.IsNullOrWhiteSpace(strComCorpNo))
            {
                ComCorpNo.Text = strComCorpNo;
            }

            if (!string.IsNullOrWhiteSpace(strClientName))
            {
                SearchClientType.SelectedValue = "1";
                SearchClientText.Text          = strClientName;
            }

            if (!string.IsNullOrWhiteSpace(strPlaceName))
            {
                SearchPlaceType.SelectedValue = "1";
                SearchPlaceText.Text           = strClientName;
            }
        }
    }
}