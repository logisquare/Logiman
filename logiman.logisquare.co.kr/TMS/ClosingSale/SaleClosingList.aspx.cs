using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClosingSale
{
    public partial class SaleClosingList : PageBase
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
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            ClosingKind.Items.Clear();
            ClosingKind.Items.Add(new ListItem("청구방식", ""));
            ClosingKind.Items.Add(new ListItem("계산서",   "1"));
            ClosingKind.Items.Add(new ListItem("카드",  "2"));
            ClosingKind.SelectedIndex = 0;
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode,    "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ITEM_CHKLB(Page, DeliveryLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("마감일", "4"));
            DateType.Items.Add(new ListItem("작성일", "9"));
            DateType.SelectedIndex = 0;

            CommonDDLB.BILL_KIND_DDLB(BillKind);
            if (BillKind.Items.FindByValue("2") != null)
            {
                BillKind.Items.Remove(BillKind.Items.FindByValue("2"));
            }

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }

            SpanCnlBillSU.Visible = objSes.GradeCode <= 4; //관리자 이상 권한

            string strClientName = Utils.IsNull(SiteGlobal.GetRequestForm("ClientName"), "");

            if (!string.IsNullOrWhiteSpace(strClientName))
            {
                PayClientName.Text = strClientName;
            }
        }
    }
}