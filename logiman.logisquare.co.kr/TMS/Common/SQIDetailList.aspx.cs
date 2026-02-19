using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Common
{
    public partial class SQIDetailList : PageBase
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
            string lo_strOrderType  = string.Empty;
            string lo_strCenterCode = string.Empty;
            string lo_strOrderNo    = string.Empty;
            lo_strOrderType  = Utils.IsNull(SiteGlobal.GetRequestForm("OrderType"),  string.Empty);
            lo_strCenterCode = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), string.Empty);
            lo_strOrderNo    = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    string.Empty);

            OrderType.Value       = lo_strOrderType;
            CenterCode.Value      = lo_strCenterCode;
            OrderNo.Value         = lo_strOrderNo;
            OrderNoView.InnerText = lo_strOrderNo;
        }
    }
}