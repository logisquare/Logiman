using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using CommonLibrary.Constants;

namespace TMS.Common
{
    public partial class SQIList : PageBase
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

            string lo_strOrderType = string.Empty;
            lo_strOrderType = Utils.IsNull(SiteGlobal.GetRequestForm("OrderType"), "0");
            OrderType.Value      = lo_strOrderType;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ORDER_ITEM_CHKLB(OrderItemCode, false, true, false, false);
            CommonDDLB.ORDER_CLIENT_COMMON_TYPE_DDLB(SearchClientType);
        }
    }
}