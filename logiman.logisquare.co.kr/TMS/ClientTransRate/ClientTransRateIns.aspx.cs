using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClientTransRate
{
    public partial class ClientTransRateIns : PageBase
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
            PageNo.Value   = "1";
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            RateType.Items.Clear();
            RateType.Items.Add(new ListItem("차량 요율", "1"));
            //RateType.Items.Add(new ListItem("중량 요율", "2"));

            HidMode.Value = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"), "");
            if (HidMode.Value.Equals("Update")) {
                CenterCode.SelectedValue = Utils.IsNull(SiteGlobal.GetRequestForm("ParamCenterCode"), "");
                ClientCode.Text         = Utils.IsNull(SiteGlobal.GetRequestForm("ParamClientCode"), "0");
                ClientName.Text          = Utils.IsNull(SiteGlobal.GetRequestForm("ParamClientName"), "");
                ConsignorCode.Value      = Utils.IsNull(SiteGlobal.GetRequestForm("ParamConsignorCode"), "0");
                ConsignorName.Text       = Utils.IsNull(SiteGlobal.GetRequestForm("ParamConsignorName"), "");
                RateType.SelectedValue   = Utils.IsNull(SiteGlobal.GetRequestForm("ParamRateType"), "");

                FromYMD.Text             = Utils.DateFormatter(Utils.IsNull(SiteGlobal.GetRequestForm("ParamFromYMD"), ""), "yyyyMMdd", "yyyy-MM-dd", "");
            }
        }
    }
}