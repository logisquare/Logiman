using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.Inout
{
    public partial class InoutEIList : PageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("등록일", "1"));
            DateType.Items.Add(new ListItem("상차일", "2"));
            DateType.SelectedIndex = 0;

            WorkOrderStatuses.Items.Clear();
            WorkOrderStatuses.Items.Add(new ListItem("연동오더상태",          ""));
            WorkOrderStatuses.Items.Add(new ListItem("Create",          "1"));
            WorkOrderStatuses.Items.Add(new ListItem("Scheduled",       "2,3,4"));
            WorkOrderStatuses.Items.Add(new ListItem("Actual Pickup",   "6"));
            WorkOrderStatuses.Items.Add(new ListItem("Actual Delivery", "6"));
            WorkOrderStatuses.Items.Add(new ListItem("Actual",          "5,6"));
            WorkOrderStatuses.Items.Add(new ListItem("POD",             "7"));
            WorkOrderStatuses.Items.Add(new ListItem("Reject",          "9"));
            WorkOrderStatuses.SelectedIndex = 0;

            RejectReasonCode.Items.Clear();
            RejectReasonCode.Items.Add(new ListItem("ReasonCode",             ""));
            RejectReasonCode.Items.Add(new ListItem("Capacity Type",          "CPT"));
            RejectReasonCode.Items.Add(new ListItem("Capacity Unavailable",   "CPU"));
            RejectReasonCode.Items.Add(new ListItem("Equipment Unavailable ", "EQU"));
            RejectReasonCode.Items.Add(new ListItem("Equipment Type",         "EQT"));
            RejectReasonCode.Items.Add(new ListItem("Length of Haul",         "LNH"));
            RejectReasonCode.Items.Add(new ListItem("Permits",                "PRM"));
            RejectReasonCode.Items.Add(new ListItem("Rate",                   "RAT"));
            RejectReasonCode.Items.Add(new ListItem("Weight",                 "WGT"));
            RejectReasonCode.SelectedIndex = 0;
            
            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}