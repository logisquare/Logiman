using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClosingPurchase
{
    public partial class PurchaseInsureList : PageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.FPIS_INFORMATION_FLAG_DDLB(InformationFlag);

            CommonDDLB.INSURE_EXCEPT_KIND_DDLB(InsureExceptKind);
            InsureExceptKind.SelectedIndex = 1;

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.SelectedIndex = 0;

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}