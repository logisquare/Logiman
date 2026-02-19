using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace APP.TMS.Client
{
    public partial class PlaceList : AppPageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.USE_FLAG_DDLB(UseFlag);
            HidCallType.Value = Utils.IsNull(SiteGlobal.GetRequestForm("CallType"), "");
            CenterCode.SelectedValue = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "");
            UseFlag.SelectedValue = Utils.IsNull(SiteGlobal.GetRequestForm("UseFlag"), "");
            PlaceName.Text = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceName"), "");
            PageNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"), "1");
            PageSize.Value = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "10");
        }
    }
}