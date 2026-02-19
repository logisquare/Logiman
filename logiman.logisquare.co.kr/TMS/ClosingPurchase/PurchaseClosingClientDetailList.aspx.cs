using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.ClosingPurchase
{
    public partial class PurchaseClosingClientDetailList : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadWrite;
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

            CenterCode.Value = Utils.IsNull(SiteGlobal.GetRequestForm("ClosingCenterCode"), "");
            PurchaseClosingSeqNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseClosingSeqNo"),  "");

            if (string.IsNullOrWhiteSpace(CenterCode.Value) || CenterCode.Value.Equals("0") ||
                string.IsNullOrWhiteSpace(PurchaseClosingSeqNo.Value) || PurchaseClosingSeqNo.Value.Equals("0"))
            {
                HidErrMsg.Value = "오더 조회에 필요한 값이 없습니다.";
            }

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}