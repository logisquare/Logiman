using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace MIS.Automatic
{
    public partial class AutomaticClientList : PageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            OrderItemCode.Value = "OA007";
            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("월별", "M"));
            DateType.Items.Add(new ListItem("일별", "D"));
            
        }
    }
}