using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.ClosingSale
{
    public partial class SaleClosingDetailList : PageBase
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
            SaleClosingSeqNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"),  "");

            if (string.IsNullOrWhiteSpace(CenterCode.Value) || CenterCode.Value.Equals("0") ||
                string.IsNullOrWhiteSpace(SaleClosingSeqNo.Value) || SaleClosingSeqNo.Value.Equals("0"))
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