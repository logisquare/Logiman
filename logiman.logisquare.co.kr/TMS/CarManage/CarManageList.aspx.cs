using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;

namespace TMS.CarManage
{
    public partial class CarManageList : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadOnly;

            if (!(objSes.GradeCode.Equals(1)
                  || objSes.AdminID.Equals("j20120187")
                  || objSes.AdminID.Equals("pyy8606")
                  || objSes.AdminID.Equals("j20120182d")
                  || objSes.AdminID.Equals("j20120182")
                  || objSes.AdminID.Equals("msdjsl")
                  || objSes.AdminID.Equals("tkaejr1029")
                  || objSes.AdminID.Equals("jks1123wl")))
            {
                this.ClientScript.RegisterStartupScript(this.GetType(), "fnPageReplace", "location.replace(\"/Default\");", true);
                return;
            }
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
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }

        }
    }
}