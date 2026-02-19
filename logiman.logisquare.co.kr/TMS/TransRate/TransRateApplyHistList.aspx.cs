using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;

namespace TMS.TransRate
{
    public partial class TransRateApplyHistList : PageBase
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
            string lo_strCenterCode     = string.Empty;
            string lo_strApplySeqNo     = string.Empty;
            string lo_strCenterName     = string.Empty;
            string lo_strClientName     = string.Empty;
            string lo_strConsignorName  = string.Empty;
            string lo_strOrderItemCodeM = string.Empty;

            lo_strCenterCode     = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            lo_strApplySeqNo     = Utils.IsNull(SiteGlobal.GetRequestForm("ApplySeqNo"), "0");
            lo_strCenterName     = SiteGlobal.GetRequestForm("CenterName");
            lo_strClientName     = SiteGlobal.GetRequestForm("ClientName");
            lo_strConsignorName  = SiteGlobal.GetRequestForm("ConsignorName");
            lo_strOrderItemCodeM = SiteGlobal.GetRequestForm("OrderItemCodeM");

            CenterCode.Value    = lo_strCenterCode;
            ApplySeqNo.Value    = lo_strApplySeqNo;
            CenterName.Text     = lo_strCenterName;
            ClientName.Text     = lo_strClientName;
            ConsignorName.Text  = lo_strConsignorName;
            OrderItemCodeM.Text = lo_strOrderItemCodeM;

            PageNo.Value   = "1";
            PageSize.Value = "100000";
        }
    }
}