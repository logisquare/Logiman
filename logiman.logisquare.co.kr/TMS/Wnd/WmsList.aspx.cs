using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.Wnd
{
    public partial class WmsList : PageBase
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
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.SelectedIndex = 0;

            //if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            //{
            //    BtnSaveExcel.Style.Add("display", "none");
            //}

            //if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            //{
            //    BtnDetailSaveExcel.Style.Add("display", "none");
            //}
        }
    }
}