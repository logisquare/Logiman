using CommonLibrary.CommonModule;
using System;
using CommonLibrary.CommonUtils;

namespace APP.TMS.Domestic
{
    public partial class DomesticDetail : AppPageBase
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
            string lo_strOrderNo    = string.Empty;

            lo_strOrderNo    = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "");
            HidOrderNo.Value = lo_strOrderNo;
            HidParam.Value   = Utils.IsNull(SiteGlobal.GetRequestForm("HidParam"), "");

            if (string.IsNullOrWhiteSpace(lo_strOrderNo))
            {
                HidErrMsg.Value = "필요한 값이 없습니다.";
            }

            CommonDDLB.INSURE_EXCEPT_KIND_DDLB(InsureExceptKind);
        }
    }
}