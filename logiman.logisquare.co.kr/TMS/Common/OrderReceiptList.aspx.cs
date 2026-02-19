using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.Common
{
    public partial class OrderReceiptList : PageBase
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
            string lo_strCenterCode     = string.Empty;
            string lo_strOrderNo        = string.Empty;
            string lo_strDispatchSeqNo  = string.Empty;

            lo_strCenterCode        = SiteGlobal.GetRequestForm("ParamCenterCode");
            lo_strOrderNo           = SiteGlobal.GetRequestForm("ParamOrderNo");
            lo_strDispatchSeqNo     = SiteGlobal.GetRequestForm("ParamDispatchSeqNo");

            CenterCode.Value        = lo_strCenterCode;
            OrderNo.Value           = lo_strOrderNo;
            DispatchSeqNo.Value     = lo_strDispatchSeqNo;

            HidFileUrl.Value = SiteGlobal.FILE_DOMAIN;
        }
    }
}