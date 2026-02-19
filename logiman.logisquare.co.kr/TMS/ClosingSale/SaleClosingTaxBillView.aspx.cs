using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.ClosingSale
{
    public partial class SaleClosingTaxBillView : PageBase
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
            string lo_strIssuSeqNo  = string.Empty;
            string lo_strCenterCode = string.Empty;

            lo_strIssuSeqNo  = Utils.IsNull(SiteGlobal.GetRequestForm("IssuSeqNo"), "");
            lo_strCenterCode = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),    "");

            IssuSeqNo.Value  = lo_strIssuSeqNo;
            CenterCode.Value = lo_strCenterCode;
            
            if (string.IsNullOrWhiteSpace(lo_strIssuSeqNo) && string.IsNullOrWhiteSpace(lo_strCenterCode))
            {
                HidErrMsg.Value = "필요한 값이 없습니다.";
                return;
            }

            PModTaxBill.Visible   = objSes.GradeCode <= 4; //관리자 이상 권한
            BtnModTaxBill.Visible = objSes.GradeCode <= 4; //관리자 이상 권한
        }
    }
}