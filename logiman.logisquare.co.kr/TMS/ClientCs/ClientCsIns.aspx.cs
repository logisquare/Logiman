using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;

namespace TMS.ClientCs
{
    public partial class ClientCsIns : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadOnly;
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
            
            PageSize.Value = CommonConstant.PAGENAVIGATION_LIST;
            PageNo.Value = "1";
            GradeCode.Value = objSes.GradeCode.ToString();

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.CS_ADMIN_TYPE_DDLB(CsAdminType);
            CommonDDLB.ORDER_ITEM_DDLB(OrderItemCode, true, true, true, true);
            CommonDDLB.ITEM_DDLB(this, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);

            HidMode.Value = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"), "");
        }
    }
}