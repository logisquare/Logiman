using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.Client
{
    public partial class ClientList : PageBase
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

            ClientName.Text   = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");
            ClientCorpNo.Text = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCorpNo"), "");

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.USE_FLAG_DDLB(UseFlag);
            CommonDDLB.ITEM_DDLB(Page, ClientType, "PA", objSes.AccessCenterCode, objSes.AdminID);

            SaleLimitAmtFlag.Items.Clear();
            SaleLimitAmtFlag.Items.Add(new ListItem("매출한도", ""));
            SaleLimitAmtFlag.Items.Add(new ListItem("설정", "Y"));
            SaleLimitAmtFlag.Items.Add(new ListItem("미설정", "N"));

            RevenueLimitPerFlag.Items.Clear();
            RevenueLimitPerFlag.Items.Add(new ListItem("원가율한도", ""));
            RevenueLimitPerFlag.Items.Add(new ListItem("설정", "Y"));
            RevenueLimitPerFlag.Items.Add(new ListItem("미설정", "N"));

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}