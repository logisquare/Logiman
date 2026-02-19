using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.TransRate
{
    public partial class TransRateModifyList : PageBase
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
            string lo_strCenterCode    = string.Empty;
            string lo_strTransSeqNo    = string.Empty;
            string lo_strCenterName    = string.Empty;
            string lo_strRateTypeM     = string.Empty;
            string lo_strFTLFlagM      = string.Empty;
            string lo_strTransRateName = string.Empty;
            string lo_strRateRegKind   = string.Empty;
            string lo_strRateType      = string.Empty;

            lo_strCenterCode  = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            lo_strTransSeqNo  = Utils.IsNull(SiteGlobal.GetRequestForm("TransSeqNo"), "0");

            lo_strCenterName    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterName"), "");
            lo_strRateTypeM     = Utils.IsNull(SiteGlobal.GetRequestForm("RateTypeM"), "");
            lo_strFTLFlagM      = Utils.IsNull(SiteGlobal.GetRequestForm("FTLFlagM"), "");
            lo_strTransRateName = Utils.IsNull(SiteGlobal.GetRequestForm("TransRateName"), "");
            lo_strRateRegKind   = Utils.IsNull(SiteGlobal.GetRequestForm("RateRegKind"), "");
            lo_strRateType      = Utils.IsNull(SiteGlobal.GetRequestForm("RateType"), "");

            CenterCode.Value   = lo_strCenterCode;
            TransSeqNo.Value   = lo_strTransSeqNo;
            CenterName.Text    = lo_strCenterName;
            RateTypeM.Text     = lo_strRateTypeM;
            FTLFlagM.Text      = lo_strFTLFlagM;
            TransRateName.Text = lo_strTransRateName;
            RateRegKind.Value  = lo_strRateRegKind;
            RateType.Value     = lo_strRateType;

            PageSize.Value   = CommonConstant.PAGENAVIGATION_LIST;
            PageNo.Value     = "1";
        }
    }
}