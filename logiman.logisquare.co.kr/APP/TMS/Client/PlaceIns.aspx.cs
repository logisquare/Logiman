using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace APP.TMS.Client
{
    public partial class PlaceIns : AppPageBase
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
            Mode.Value          = Utils.IsNull(SiteGlobal.GetRequestForm("Mode"), "");
            PlaceSeqNo.Value    = Utils.IsNull(SiteGlobal.GetRequestForm("PlaceSeqNo"), "");
            HidParam.Value      = Utils.IsNull(SiteGlobal.GetRequestForm("HidParam"), "");

            if (Mode.Value.Equals("Update")) {
                ChargeList.Visible = true;
            }
        }
    }
}