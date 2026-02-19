using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;
using CommonLibrary.Constants;

namespace TMS.Common
{
    public partial class OrderPrintHistList : PageBase
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
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;
            PageNo.Value   = "1";

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체검색", ""));
            SearchType.Items.Add(new ListItem("수신자", "RecName"));
            SearchType.Items.Add(new ListItem("발신자", "SendName"));
            SearchType.SelectedIndex = 0;
        }
    }
}