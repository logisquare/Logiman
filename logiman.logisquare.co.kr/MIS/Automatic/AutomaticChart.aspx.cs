using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace MIS.Automatic
{
    public partial class AutomaticChart : PageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            OrderItemCode.Value = "OA007";
            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체", ""));
            SearchType.Items.Add(new ListItem("고객사", "Client"));
            SearchType.Items.Add(new ListItem("담당자", "Charge"));
        }
    }
}