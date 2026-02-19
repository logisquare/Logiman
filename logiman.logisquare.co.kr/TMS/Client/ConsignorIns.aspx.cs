using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Client
{
    public partial class ConsignorIns : PageBase
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
            string lo_strConsignorCode = string.Empty;

            lo_strConsignorCode = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            ConsignorCode.Value = lo_strConsignorCode;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);

            if (!string.IsNullOrWhiteSpace(lo_strConsignorCode) && !lo_strConsignorCode.Equals("0"))
            {
                HidMode.Value = "Update";
                ConsignorName.Attributes.Add("readonly", "readonly");
                TrClient.Visible  = true;
                TrUseFlag.Visible = true;
            }
            else
            {
                HidMode.Value     = "Insert";
                TrClient.Visible  = false;
                TrUseFlag.Visible = false;
            }
        }
    }
}