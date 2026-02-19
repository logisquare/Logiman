using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace MIS.ExclusiveCar
{
    public partial class CarPossessAgent : PageBase
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
            OrderItemCode.Value = "OA007";
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
        }
    }
}