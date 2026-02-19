using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace APP.TMS.Client
{
    public partial class ConsignorList : AppPageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData() {
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.USE_FLAG_DDLB(UseFlag);
            HidCallType.Value           = Utils.IsNull(SiteGlobal.GetRequestForm("CallType"), "");
            CenterCode.SelectedValue    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "");
            UseFlag.SelectedValue       = Utils.IsNull(SiteGlobal.GetRequestForm("UseFlag"), "");
            ConsignorName.Text          = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorName"), "");
            PageNo.Value                = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"), "1");
            PageSize.Value              = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "10");
        }
    }
}