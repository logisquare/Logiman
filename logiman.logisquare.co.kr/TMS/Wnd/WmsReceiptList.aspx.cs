using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Wnd
{
    public partial class WmsReceiptList : PageBase
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
            string lo_strCenterCode  = string.Empty;
            string lo_strOrderNo     = string.Empty;
            string lo_strDeliveryNo  = string.Empty;
            string lo_strReceiptType = string.Empty;

            lo_strCenterCode  = SiteGlobal.GetRequestForm("ParamCenterCode");
            lo_strOrderNo     = SiteGlobal.GetRequestForm("ParamOrderNo");
            lo_strDeliveryNo  = SiteGlobal.GetRequestForm("ParamDeliveryNo");
            lo_strReceiptType = SiteGlobal.GetRequestForm("ParamReceiptType");

            CenterCode.Value  = lo_strCenterCode;
            OrderNo.Value     = lo_strOrderNo;
            DeliveryNo.Value  = lo_strDeliveryNo;
            ReceiptType.Value = lo_strReceiptType;

            HidFileUrl.Value = SiteGlobal.FILE_DOMAIN;
        }
    }
}