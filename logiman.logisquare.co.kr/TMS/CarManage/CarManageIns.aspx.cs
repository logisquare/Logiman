using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.CarManage
{
    public partial class CarManageIns : PageBase
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
            string lo_strParam       = string.Empty;
            string lo_strHidMode     = string.Empty;
            string lo_strManageSeqNo = string.Empty;

            lo_strParam    = Utils.IsNull(SiteGlobal.GetRequestForm("Param", false), "");
            lo_strHidMode  = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"), "");
            HidParam.Value = lo_strParam;
            HidMode.Value  = lo_strHidMode;

            if (HidMode.Value.Equals("Update"))
            {
                lo_strManageSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("ManageSeqNo"), "0");
                ManageSeqNo.Value = lo_strManageSeqNo;
            }
        }
    }
}