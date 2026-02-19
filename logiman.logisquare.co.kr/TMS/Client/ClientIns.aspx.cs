using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.Client
{
    public partial class ClientIns : PageBase
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
            string lo_strClientCode = string.Empty;

            lo_strClientCode = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            ClientCode.Value = lo_strClientCode;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.COM_TAX_KIND_DDLB(ClientTaxKind);
            CommonDDLB.ITEM_DDLB(Page, ClientType, "PA", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.BANK_DDLB(ClientBankCode);
            CommonDDLB.CLIENT_CLOSING_TYPE_DDLB(ClientClosingType);
            CommonDDLB.CLIENT_BUSINESS_STATUS_DDLB(ClientBusinessStatus);
            CommonDDLB.CLIENT_PAY_DAY_DDLB(ClientPayDay);

            TransCenterCode.Items.Clear();
            TransCenterCode.Items.Add(new ListItem("계열사 선택", ""));

            SaleLimitAmt.Attributes.Add("readonly", "readonly");
            RevenueLimitPer.Attributes.Add("readonly", "readonly");

            if (objSes.GradeCode <= 3)
            {
                SaleLimitAmt.Attributes.Remove("readonly");
                RevenueLimitPer.Attributes.Remove("readonly");
            }

            if (!string.IsNullOrWhiteSpace(lo_strClientCode) && !lo_strClientCode.Equals("0"))
            {
                HidMode.Value = "Update";
                ClientCorpNo.Attributes.Add("readonly", "readonly");
                BtnCorpNoChk.Visible                = false;
                BtnCorpNoReChk.Visible              = false;
                TrUseFlag.Visible                   = true;
                SpanChargeUseFlag.Visible           = true;
                TdChargeTitle.Attributes["rowspan"] = "3";
            }
            else
            {
                HidMode.Value                       = "Insert";
                BtnCorpNoChk.Visible                = true;
                BtnCorpNoReChk.Visible              = true;
                TrChargeGrid.Visible                = false;
                BtnChargeIns.Visible                = false;
                BtnChargeDel.Visible                = false;
                TrUseFlag.Visible                   = false;
                SpanChargeUseFlag.Visible           = false;
                TdChargeTitle.Attributes["rowspan"] = "2";
            }
        }
    }
}