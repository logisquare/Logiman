using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace WEB.Closing
{
    public partial class WebClosingDetailList : PageBase
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
            string lo_strSaleClosingSeqNo = string.Empty;
            string lo_strCenterCode       = string.Empty;

            lo_strSaleClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("HidSaleClosingSeqNo"), "0");
            lo_strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("HidCenterCode"),       "0");

            HidSaleClosingSeqNo.Value = lo_strSaleClosingSeqNo;
            HidCenterCode.Value       = lo_strCenterCode;
        }
    }
}