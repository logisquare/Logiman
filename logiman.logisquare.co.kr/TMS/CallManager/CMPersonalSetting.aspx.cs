using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.CallManager
{

    public partial class CMPersonalSetting : PageBase
    {
        public string strQRCodeImg = SiteGlobal.WS_CALLMANAGER_QRCODE_IMAGE;

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
            AppMobileNo.Text = $"({Utils.GetMobileNoDashed(objSes.MobileNo)})";
        }
    }
}