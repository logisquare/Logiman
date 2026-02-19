using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace MIS.ExclusiveCar
{
    public partial class CarPossessClient : PageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("没备贸", "Client"));
            SearchType.Items.Add(new ListItem("拳林疙", "Consignor"));
            OrderItemCode.Value = "OA007";
        }
    }
}