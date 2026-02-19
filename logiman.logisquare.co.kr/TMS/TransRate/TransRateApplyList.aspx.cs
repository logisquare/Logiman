using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;

namespace TMS.TransRate
{
    public partial class TransRateApplyList : PageBase
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
            PageNo.Value   = "1";
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.ORDER_ITEM_DDLB(OrderItemCode, true, true, false, false);
            CommonDDLB.ITEM_DDLB(this, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID, "사업장");

            GradeCode.Value = objSes.GradeCode.ToString();
            
            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }

            if (objSes.GradeCode > 4)
            {
                BtnTransRateReg.Style.Add("display", "none");
            }
        }
    }
}