using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace SSO.Server
{
    public partial class ServerList : PageBase
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
            PageSize.Value = CommonConstant.PAGENAVIGATION_LIST;
            PageNo.Value = "1";
            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체 검색", ""));
            SearchType.Items.Add(new ListItem("서버 유형", "ServerType"));
        }

    }
}