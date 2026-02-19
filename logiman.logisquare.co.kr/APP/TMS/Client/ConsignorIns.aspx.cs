using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace APP.TMS.Client
{
    public partial class ConsignorIns : AppPageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            ConsignorCode.Value = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "");
            HidMode.Value       = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"), "");
            HidParam.Value      = Utils.IsNull(SiteGlobal.GetRequestForm("HidParam"), "");
        }
    }
}