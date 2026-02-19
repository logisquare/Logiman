using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI;

namespace SMS.Bill
{
    public partial class BillInfo : PageInit
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

            No.Value        = lo_strNo;
        }
    }
}