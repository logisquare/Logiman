using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.Common
{
    public partial class ClientDetailList : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadWrite;
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
            string lo_strType       = string.Empty;
            string lo_strCenterCode = string.Empty;
            lo_strType       = Utils.IsNull(SiteGlobal.GetRequestForm("Type"),       string.Empty);
            lo_strCenterCode = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), string.Empty);

            Type.Value       = lo_strType;
            CenterCode.Value = lo_strCenterCode;

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("구분",    ""));
            SearchType.Items.Add(new ListItem("고객사명",   "1"));
            SearchType.Items.Add(new ListItem("사업자번호", "2"));
            SearchType.Items.Add(new ListItem("담당자명",  "3"));
        }
    }
}