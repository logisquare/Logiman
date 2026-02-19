using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace SSO.Admin
{
    public partial class AdminList : PageBase
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
            PageNo.Value   =   "1";
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;
            CommonDDLB.ADMIN_GRADE_DDLB(GradeCode, objSes.GradeCode);
            CommonDDLB.USE_ADMIN_FLAG_DDLB(UseFlag);

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체 검색", ""));
            SearchType.Items.Add(new ListItem("사용자 아이디", "AdminID"));
            SearchType.Items.Add(new ListItem("사용자 명", "AdminName"));
            SearchType.Items.Add(new ListItem("휴대폰 번호", "MobileNo"));
            SearchType.SelectedValue = "AdminName";
            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}