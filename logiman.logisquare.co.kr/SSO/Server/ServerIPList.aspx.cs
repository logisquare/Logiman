using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace SSO.Server
{
    public partial class ServerIPList : PageBase
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

            CommonDDLB.USE_FLAG_DDLB(UseFlag);

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체 검색", ""));
            SearchType.Items.Add(new ListItem("서버 유형", "ServerType"));
            SearchType.Items.Add(new ListItem("운송사 코드", "CenterCode"));
            SearchType.Items.Add(new ListItem("허용 IP", "AllowIPAddr"));
        }

    }
}