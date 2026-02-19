using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Wnd
{
    public partial class WmsGoodsList : PageBase
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

            CenterCode.Value = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "");
            OrderNo.Value    = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "");
            DeliveryNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("DeliveryNo"), "");

            if (string.IsNullOrWhiteSpace(CenterCode.Value) || CenterCode.Value.Equals("0") ||
                string.IsNullOrWhiteSpace(OrderNo.Value) || OrderNo.Value.Equals("0"))
            {
                HidErrMsg.Value = "오더 조회에 필요한 값이 없습니다.";
            }
        }
    }
}