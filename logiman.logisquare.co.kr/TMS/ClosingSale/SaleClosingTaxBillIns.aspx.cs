using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.ClosingSale
{
    public partial class SaleClosingTaxBillIns : PageBase
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
            string lo_strSaleClosingSeqNo = string.Empty;
            string lo_strCenterCode       = string.Empty;
            lo_strSaleClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"), "");
            lo_strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),       "");

            SaleClosingSeqNo.Value = lo_strSaleClosingSeqNo;
            CenterCode.Value       = lo_strCenterCode;

            if (string.IsNullOrWhiteSpace(lo_strSaleClosingSeqNo) || string.IsNullOrWhiteSpace(lo_strCenterCode))
            {
                HidErrMsg.Value = "필요한 값이 없습니다.";
                return;
            }

            SELR_TEL.Value        = objSes.TelNo;
            SELR_CHRG_NM.Value    = objSes.AdminName;
            SELR_CHRG_EMAIL.Value = objSes.Email;
            SELR_CHRG_MOBL.Value  = objSes.MobileNo;
        }
    }
}