using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Container
{
    public partial class ContainerIns : PageBase
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
            string lo_strOrderNo  = string.Empty;
            string lo_strCopyFlag = string.Empty;

            lo_strOrderNo    = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),  "");
            lo_strCopyFlag   = Utils.IsNull(SiteGlobal.GetRequestForm("CopyFlag"), "N");
            OrderNo.Value    = lo_strOrderNo;
            OrderNoInfo.Text = lo_strOrderNo;
            CopyFlag.Value   = lo_strCopyFlag;

            if (!string.IsNullOrWhiteSpace(lo_strOrderNo) && !lo_strCopyFlag.Equals("Y"))
            {
                HidMode.Value        = "Update";
                DivButtons.Visible   = true;
                DivOrderInfo.Visible = true;
            }
            else
            {
                HidMode.Value        = "Insert";
                DivButtons.Visible   = false;
                DivOrderInfo.Visible = false;
            }

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.ITEM_DDLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID, "사업장");
            CommonDDLB.ORDER_ITEM_DDLB(OrderItemCode, false, false, true, false);
            CommonDDLB.ITEM_DDLB(Page, GoodsItemCode, "OE", objSes.AccessCenterCode, objSes.AdminID, "품목");
            CommonDDLB.PAY_TYPE_DDLB(PayType);
            PayType.SelectedValue = PayType.Items.FindByText("매출").Value;
            CommonDDLB.PAY_TAX_KIND_DDLB(TaxKind);
            TaxKind.SelectedValue = TaxKind.Items.FindByText("과세").Value;
            CommonDDLB.ITEM_DDLB(Page, ItemCode, "OP", objSes.AccessCenterCode, objSes.AdminID, "비용항목");
            ItemCode.SelectedValue = ItemCode.Items.FindByText("운임").Value;
            CommonDDLB.CAR_DIV_TYPE_DDLB(CarDivType);
            CommonDDLB.DOOR_PLACE_DDLB(PickupPlaceLocal);
            CommonDDLB.INSURE_EXCEPT_KIND_DDLB(InsureExceptKind);
        }
    }
}