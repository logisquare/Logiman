using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;

namespace TMS.Car
{
    public partial class CarDispatchRefList : PageBase
    {
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
            PageNo.Value      = "1";
            PageSize.Value    = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CarNo.Text      = Utils.IsNull(SiteGlobal.GetRequestForm("CarNo"),      "");
            ComCorpNo.Text  = Utils.IsNull(SiteGlobal.GetRequestForm("ComCorpNo"),  "");
            DriverCell.Text = Utils.IsNull(SiteGlobal.GetRequestForm("DriverCell"), "");

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.USE_FLAG_DDLB(UseFlag);
            CommonDDLB.CAR_DIV_TYPE_DDLB(CarDivType);
            
            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}