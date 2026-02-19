using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.ClosingSaleDeposit
{
    public partial class DepositMonthlyNoteIns : PageBase
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

            string lo_strCenterCode = string.Empty;
            string lo_strClientCode = string.Empty;

            lo_strCenterCode    = Utils.IsNull(SiteGlobal.GetRequestForm("DepositCenterCode"), string.Empty);
            lo_strClientCode    = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"),        string.Empty);
            if (string.IsNullOrWhiteSpace(lo_strCenterCode) || string.IsNullOrWhiteSpace(lo_strClientCode))
            {
                HidErrMsg.Value = "올바르지 않은 접근입니다.";
                return;
            }

            HidCenterCode.Value = lo_strCenterCode;
            HidClientCode.Value = lo_strClientCode;
            CenterCode.SelectedValue = CenterCode.Items.FindByValue(lo_strCenterCode) == null ? string.Empty : lo_strCenterCode;
        }
    }
}