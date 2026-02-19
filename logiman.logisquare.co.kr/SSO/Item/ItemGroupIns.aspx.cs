using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace SSO.Item
{
    public partial class ItemGroupIns : PageBase
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
            CenterFlag.Items.Clear();
            CenterFlag.Items.Add(new ListItem("N", "N"));
            CenterFlag.Items.Add(new ListItem("Y", "Y"));

            AdminFlag.Items.Clear();
            AdminFlag.Items.Add(new ListItem("N", "N"));
            AdminFlag.Items.Add(new ListItem("Y", "Y"));
        }
    }
}