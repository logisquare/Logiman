using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using CommonLibrary.Extensions;

namespace SMS.Pay
{
    public partial class Index : PageInit
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            string lo_strNo = string.Empty;

            lo_strNo = Utils.IsNull(SiteGlobal.GetRequestForm("No"), "");

            if (string.IsNullOrWhiteSpace(lo_strNo))
            {
                DisplayMode.Value = "N";
                ErrMsg.Value      = "페이지를 표시할 수 없습니다.";
                return;
            }

            No.Value                   = lo_strNo;
            HidEventViewFlag.Value     = DateTime.Now.ToString("yyyyMMdd").ToInt() >= 20240701 && DateTime.Now.ToString("yyyyMMdd").ToInt() <= 20241231 ? "Y" : "N";
            HidEventAvailChkFlag.Value = "Y";
        }
    }
}