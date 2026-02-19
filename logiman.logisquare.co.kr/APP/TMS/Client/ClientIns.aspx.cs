using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace APP.TMS.Client
{
    public partial class ClientIns : AppPageBase
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
            string lo_strClientCode = string.Empty;
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.COM_TAX_KIND_DDLB(ClientTaxKind);
            CommonDDLB.ITEM_DDLB(Page, ClientType, "PA", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.BANK_DDLB(ClientBankCode);

            lo_strClientCode = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            ClientCode.Value = lo_strClientCode;
            HidParam.Value = Utils.IsNull(SiteGlobal.GetRequestForm("HidParam"), "");

            if (!string.IsNullOrWhiteSpace(lo_strClientCode) && !lo_strClientCode.Equals("0"))
            {
                HidMode.Value = "Update";
                ClientCorpNo.Attributes.Add("readonly", "readonly");
                BtnCorpNoChk.Visible = false;
                BtnCorpNoReChk.Visible = false;
            }
            else
            {
                HidMode.Value = "Insert";
                BtnCorpNoChk.Visible = true;
                BtnCorpNoReChk.Visible = true;
            }
        }
    }
}