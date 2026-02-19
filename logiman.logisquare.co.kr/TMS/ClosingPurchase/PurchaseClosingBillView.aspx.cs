using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.ClosingPurchase
{
    public partial class PurchaseClosingBillView : PageBase
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
            string lo_strPurchaseClosingSeqNo = string.Empty;
            string lo_strNtsConfirmNum        = string.Empty;
            string lo_strCenterCode           = string.Empty;

            lo_strPurchaseClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseClosingSeqNo"), "");
            lo_strNtsConfirmNum        = Utils.IsNull(SiteGlobal.GetRequestForm("NtsConfirmNum"),        "");
            lo_strCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),           "");

            PurchaseClosingSeqNo.Value = lo_strPurchaseClosingSeqNo;
            NtsConfirmNum.Value        = lo_strNtsConfirmNum;
            CenterCode.Value           = lo_strCenterCode;

            if (string.IsNullOrWhiteSpace(lo_strPurchaseClosingSeqNo) || string.IsNullOrWhiteSpace(lo_strNtsConfirmNum) || string.IsNullOrWhiteSpace(lo_strCenterCode))
            {
                HidErrMsg.Value = "필요한 값이 없습니다.";
                return;
            }

            BtnCnlPreMatching.Visible = objSes.GradeCode <= 4;
        }
    }
}