using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace CENTER.Center
{
    public partial class CenterList : PageBase
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
            PageSize.Value  = CommonConstant.PAGENAVIGATION_LIST;
            PageNo.Value    = "1";
            GradeCode.Value = objSes.GradeCode.ToString();

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체 검색", ""));
            SearchType.Items.Add(new ListItem("사업자번호", "CorpNo"));
            SearchType.Items.Add(new ListItem("회원사명", "CenterName"));
        }

    }
}