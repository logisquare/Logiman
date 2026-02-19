using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.ClosingPurchase
{
    public partial class PurchaseQuickMonthlyList : PageBase
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
            string lo_strCenterCode = string.Empty;
            lo_strCenterCode = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), string.Empty);
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            HidYear.Value = DateTime.Now.Year.ToString();

            if (!string.IsNullOrWhiteSpace(lo_strCenterCode))
            {
                CenterCode.SelectedValue = CenterCode.Items.FindByValue(lo_strCenterCode) == null ? string.Empty : lo_strCenterCode;
            }
        }
    }
}