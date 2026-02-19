using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace APP.TMS.Domestic
{
    public partial class DomesticList : AppPageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string strChkMyCharge   = string.Empty;
            string strChkMyOrder    = string.Empty;
            string strChkCnl        = string.Empty;

            PageNo.Value   = "1";
            PageSize.Value = "10";

            HidMyOrderFlag.Value = objSes.MyOrderFlag;
            if (!HidMyOrderFlag.Value.Equals("Y"))
            {
                ChkMyOrder.Checked = false;
            }

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.Items.Add(new ListItem("하차일", "2"));
            DateType.Items.Add(new ListItem("접수일", "3"));

            CommonDDLB.ORDER_CLIENT_COMMON_TYPE_DDLB(SearchClientType);
            SearchClientType.SelectedIndex = 3;
            CommonDDLB.ORDER_PLACE_TYPE_DDLB(SearchPlaceType);
            SearchPlaceType.SelectedIndex = 1;
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);

            HidCallType.Value               = Utils.IsNull(SiteGlobal.GetRequestForm("CallType"), "");
            CenterCode.SelectedValue        = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "");
            DateType.SelectedValue          = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "");
            DateYMD.Text                    = Utils.IsNull(SiteGlobal.GetRequestForm("DateYMD"), "");
            HidCode.Value                   = Utils.IsNull(SiteGlobal.GetRequestForm("OrderLocationCodes"), "");
            SearchClientType.SelectedValue  = Utils.IsNull(SiteGlobal.GetRequestForm("SearchClientType"), "");
            SearchClientText.Text           = Utils.IsNull(SiteGlobal.GetRequestForm("SearchClientText"), "");
            SearchPlaceType.SelectedValue   = Utils.IsNull(SiteGlobal.GetRequestForm("SearchPlaceType"), "");
            SearchPlaceText.Text            = Utils.IsNull(SiteGlobal.GetRequestForm("SearchPlaceText"), "");
            ComCorpNo.Text                  = Utils.IsNull(SiteGlobal.GetRequestForm("ComCorpNo"), "");
            CarNo.Text                      = Utils.IsNull(SiteGlobal.GetRequestForm("CarNo"), "");
            DriverName.Text                 = Utils.IsNull(SiteGlobal.GetRequestForm("DriverName"), "");
            strChkMyCharge                  = Utils.IsNull(SiteGlobal.GetRequestForm("MyChargeFlag"), "N");
            strChkMyOrder                   = Utils.IsNull(SiteGlobal.GetRequestForm("MyOrderFlag"), "N");
            strChkCnl                       = Utils.IsNull(SiteGlobal.GetRequestForm("CnlFlag"), "N");
            SortType.Value                  = Utils.IsNull(SiteGlobal.GetRequestForm("SortType"), "");
            HidDateSel.Value                = Utils.IsNull(SiteGlobal.GetRequestForm("HidDateSel"), "");

            if (strChkMyCharge.Equals("Y")) {
                ChkMyCharge.Checked = true;
            }
            if (strChkMyOrder.Equals("Y"))
            {
                ChkMyOrder.Checked = true;
            }
            if (strChkCnl.Equals("Y"))
            {
                ChkCnl.Checked = true;
            }

        }
    }
}