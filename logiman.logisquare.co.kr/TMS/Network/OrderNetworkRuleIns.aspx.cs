using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using DocumentFormat.OpenXml.Spreadsheet;

using System;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;

namespace TMS.Network
{
    public partial class OrderNetworkRuleIns : PageBase
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
            
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            RenewalStartMinute.Items.Clear();
            RenewalStartMinute.Items.Add(new ListItem("증액시작시간(분)", ""));
            RenewalStartMinute.Items.Add(new ListItem("30분전", "30"));
            RenewalStartMinute.Items.Add(new ListItem("60분전", "60"));
            RenewalStartMinute.Items.Add(new ListItem("90분전", "90"));
            RenewalStartMinute.Items.Add(new ListItem("120분전", "120"));

            NetworkKind.Items.Clear();
            NetworkKind.Items.Add(new ListItem("정보망 선택", ""));
            NetworkKind.Items.Add(new ListItem("전국 24시콜", "1"));
            NetworkKind.Items.Add(new ListItem("화물맨", "2"));
            RuleSeqNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("RuleSeqNo"), "0");
            HidMode.Value = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"), "");

            if (HidMode.Value.Equals("Update")) {
                
            }
        }
    }
}