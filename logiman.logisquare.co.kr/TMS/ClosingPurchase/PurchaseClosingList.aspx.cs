using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClosingPurchase
{
    public partial class PurchaseClosingList : PageBase
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
            SendStatus.Items.Clear();
            SendStatus.Items.Add(new ListItem("송금상태",    ""));
            SendStatus.Items.Add(new ListItem("미송금",     "1"));
            SendStatus.Items.Add(new ListItem("송금신청",    "2"));
            SendStatus.Items.Add(new ListItem("송금완료", "3"));
            SendStatus.SelectedIndex = 0;
            SendType.Items.Clear();
            SendType.Items.Add(new ListItem("결제방식",          ""));
            SendType.Items.Add(new ListItem("미선택",           "1"));
            SendType.Items.Add(new ListItem("일반입금",          "2"));
            SendType.Items.Add(new ListItem("빠른입금(차)",       "3"));
            SendType.Items.Add(new ListItem("빠른입금(운)-바로지급",  "4"));
            SendType.Items.Add(new ListItem("빠른입금(운)-14일지급", "5"));
            SendType.Items.Add(new ListItem("별도송금",       "6"));
            SendType.Items.Add(new ListItem("카드결제",       "7"));
            SendType.SelectedIndex = 0;
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode,    "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ITEM_CHKLB(Page, DeliveryLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);
            CommonDDLB.ORDER_ITEM_CHKLB(OrderItemCode, true, true, true, true);

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("마감일", "4"));
            DateType.SelectedIndex = 0;

            CommonDDLB.BANK_DDLB(PopBankCode);

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }

            if (objSes.GradeCode <= 4)
            {
                BtnRegOtherPay.Visible = true;
            }

            string strDriverCell = Utils.IsNull(SiteGlobal.GetRequestForm("DriverCell"), "");
            string strComCorpNo  = Utils.IsNull(SiteGlobal.GetRequestForm("ComCorpNo"),  "");

            if (!string.IsNullOrWhiteSpace(strDriverCell))
            {
                DriverCell.Text = strDriverCell;
            }

            if (!string.IsNullOrWhiteSpace(strComCorpNo))
            {
                ComCorpNo.Text = strComCorpNo;
            }
        }
    }
}