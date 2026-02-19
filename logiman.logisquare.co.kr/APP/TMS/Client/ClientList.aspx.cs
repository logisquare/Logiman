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
    public partial class ClientList : AppPageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.USE_FLAG_DDLB(UseFlag);
            CommonDDLB.ITEM_DDLB(Page, ClientType, "PA", objSes.AccessCenterCode, objSes.AdminID);
            HidCallType.Value           = Utils.IsNull(SiteGlobal.GetRequestForm("CallType"), "");
            CenterCode.SelectedValue    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "");
            UseFlag.SelectedValue       = Utils.IsNull(SiteGlobal.GetRequestForm("UseFlag"), "");
            ClientType.SelectedValue    = Utils.IsNull(SiteGlobal.GetRequestForm("ClientType"), "");
            ClientCorpNo.Text           = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCorpNo"), "");
            ClientName.Text             = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");
            PageNo.Value = "1";
            PageSize.Value = "10";
        }
    }
}