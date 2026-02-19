using CommonLibrary.CommonModule;
using System;
using CommonLibrary.CommonUtils;

namespace APP.TMS.Inout
{
    public partial class InoutDetail : AppPageBase
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
            string lo_strOrderNo = string.Empty;

            lo_strOrderNo = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "");

            HidOrderNo.Value = lo_strOrderNo;

            if (string.IsNullOrWhiteSpace(lo_strOrderNo))
            {
                HidErrMsg.Value = "필요한 값이 없습니다.";
            }

            CommonDDLB.ITEM_DDLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID, "사업장");

            HidParam.Value = Utils.IsNull(SiteGlobal.GetRequestForm("HidParam"), "");
        }
    }
}