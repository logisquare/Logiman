using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace APP.TMS.Car
{
    public partial class CarDispatchRefList : AppPageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string strCooperatorFlag = string.Empty;
            string strCargoManFlag   = string.Empty;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.USE_FLAG_DDLB(UseFlag);
            CommonDDLB.CAR_DIV_TYPE_DDLB(CarDivType);

            PageNo.Value             = "1";
            PageSize.Value           = "10";
            HidCallType.Value        = Utils.IsNull(SiteGlobal.GetRequestForm("CallType"),       "");
            CenterCode.SelectedValue = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),     "");
            UseFlag.SelectedValue    = Utils.IsNull(SiteGlobal.GetRequestForm("UseFlag"),        "");
            CarDivType.SelectedValue = Utils.IsNull(SiteGlobal.GetRequestForm("CarDivType"),     "");
            ComName.Text             = Utils.IsNull(SiteGlobal.GetRequestForm("ComName"),        "");
            ComCorpNo.Text           = Utils.IsNull(SiteGlobal.GetRequestForm("ComCorpNo"),      "");
            CarNo.Text               = Utils.IsNull(SiteGlobal.GetRequestForm("CarNo"),          "");
            strCooperatorFlag        = Utils.IsNull(SiteGlobal.GetRequestForm("CooperatorFlag"), "N");
            strCargoManFlag          = Utils.IsNull(SiteGlobal.GetRequestForm("CargoManFlag"),   "N");

            if (strCooperatorFlag.Equals("Y"))
            {
                CooperatorFlag.Checked = true;
            }
            if (strCargoManFlag.Equals("Y"))
            {
                CargoManFlag.Checked = true;
            }
        }
    }
}