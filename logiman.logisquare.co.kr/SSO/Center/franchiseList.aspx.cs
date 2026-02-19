using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace SSO.Center
{
    public partial class FranchiseList : PageBase
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
            PageSize.Value = CommonConstant.PAGENAVIGATION_LIST;
            PageNo.Value = "1";
            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체 검색", ""));
            SearchType.Items.Add(new ListItem("사업자번호", "CorpNo"));
            SearchType.Items.Add(new ListItem("회원사명", "CenterName"));

            if (objSes.AuthCode.Equals(3)) {
                RegBtn.Visible = false;
            }
        }

    }
}