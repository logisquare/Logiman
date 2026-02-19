using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Inout
{
    public partial class InoutIns : PageBase
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
            string lo_strChgSeqNo = string.Empty;
            string lo_strWoSeqNo  = string.Empty;

            lo_strOrderNo    = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),  "");
            lo_strCopyFlag   = Utils.IsNull(SiteGlobal.GetRequestForm("CopyFlag"), "N");
            lo_strChgSeqNo   = Utils.IsNull(SiteGlobal.GetRequestForm("ChgSeqNo"), "");
            lo_strWoSeqNo    = Utils.IsNull(SiteGlobal.GetRequestForm("WoSeqNo"),  "");
            OrderNo.Value    = lo_strOrderNo;
            OrderNoInfo.Text = lo_strOrderNo;
            CopyFlag.Value   = lo_strCopyFlag;
            ChgSeqNo.Value   = lo_strChgSeqNo;
            WoSeqNo.Value    = lo_strWoSeqNo;

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
            CommonDDLB.ITEM_DDLB(Page, OrderLocationCode,    "OL", objSes.AccessCenterCode, objSes.AdminID, "사업장");
            CommonDDLB.ITEM_DDLB(Page, CarTypeCode, "CA", objSes.AccessCenterCode, objSes.AdminID, "요청차종");
            CommonDDLB.ITEM_DDLB(Page, CarTonCode, "CB", objSes.AccessCenterCode, objSes.AdminID, "요청톤급");
            CommonDDLB.ORDER_ITEM_DDLB(OrderItemCode, false, true, false, false);
            CommonDDLB.ITEM_DDLB(Page, GoodsItemCode, "OD", objSes.AccessCenterCode, objSes.AdminID, "품목");
            GoodsItemCode.SelectedValue = GoodsItemCode.Items.FindByText("P/T") == null ? string.Empty : GoodsItemCode.Items.FindByText("P/T").Value;
            CommonDDLB.ITEM_DDLB(Page, PopGoodsItemCode, "OD", objSes.AccessCenterCode, objSes.AdminID, "품목");
            CommonDDLB.PAY_TYPE_DDLB(PayType);
            PayType.SelectedValue = PayType.Items.FindByText("매출") == null ? string.Empty : PayType.Items.FindByText("매출").Value;
            CommonDDLB.PAY_TAX_KIND_DDLB(TaxKind);
            TaxKind.SelectedValue = TaxKind.Items.FindByText("과세") == null ? string.Empty : TaxKind.Items.FindByText("과세").Value;
            CommonDDLB.ITEM_DDLB(Page, ItemCode, "OP", objSes.AccessCenterCode, objSes.AdminID, "비용항목");
            ItemCode.SelectedValue = ItemCode.Items.FindByText("운임") == null ? string.Empty : ItemCode.Items.FindByText("운임").Value;
            CommonDDLB.PICKUP_WAY_DDLB(PickupWay);
            CommonDDLB.GET_WAY_DDLB(GetWay);
        }
    }
}