using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.Wnd
{
    public partial class WmsIns : PageBase
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

            lo_strOrderNo       = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),  "");
            lo_strCopyFlag      = Utils.IsNull(SiteGlobal.GetRequestForm("CopyFlag"), "N");
            lo_strChgSeqNo      = Utils.IsNull(SiteGlobal.GetRequestForm("ChgSeqNo"), "");
            OrderNo.Value       = lo_strOrderNo;
            OrderNoInfo.Text    = lo_strOrderNo;
            CopyFlag.Value      = lo_strCopyFlag;
            ChgSeqNo.Value      = lo_strChgSeqNo;
            OrderItemCode.Value = "OA010";

            if (!string.IsNullOrWhiteSpace(lo_strOrderNo) && !lo_strCopyFlag.Equals("Y"))
            {
                HidMode.Value          = "Update";
                BtnCancelOrder.Visible = true;
                DivOrderInfo.Visible   = true;
            }
            else
            {
                HidMode.Value          = "Insert";
                BtnCancelOrder.Visible = false;
                DivOrderInfo.Visible   = false;
            }

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            GoodsDispatchType.Items.Clear();
            GoodsDispatchType.Items.Add(new ListItem("직송", "2"));
            GoodsDispatchType.SelectedIndex = 1;
            CommonDDLB.ITEM_DDLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID, "사업장");
            CommonDDLB.ITEM_DDLB(Page, CarTypeCode,       "CA", objSes.AccessCenterCode, objSes.AdminID, "요청차종");
            CommonDDLB.ITEM_DDLB(Page, CarTonCode,        "CB", objSes.AccessCenterCode, objSes.AdminID, "요청톤급");
            CommonDDLB.ITEM_DDLB(Page, GoodsItemCode,     "OF", objSes.AccessCenterCode, objSes.AdminID, "품목");
            GoodsItemCode.SelectedIndex = 1;

            CommonDDLB.FTL_FLAG_DDLB(FTLFlag);
            FTLFlag.Items.RemoveAt(0);
            FTLFlag.SelectedIndex = 1;

            CommonDDLB.RUN_TYPE_DDLB(GoodsRunType);
            GoodsRunType.Items.RemoveAt(0);
            GoodsRunType.SelectedIndex = 0;

            CommonDDLB.CAR_FIXED_FLAG_DDLB(CarFixedFlag);
            CarFixedFlag.Items.RemoveAt(0);
            CarFixedFlag.SelectedIndex = 0;

            CommonDDLB.PAY_TYPE_DOMESTIC_DDLB(PayType);
            PayType.SelectedValue = PayType.Items.FindByText("매출") == null ? string.Empty : PayType.Items.FindByText("매출").Value;
            CommonDDLB.PAY_TAX_KIND_DDLB(TaxKind);
            TaxKind.SelectedValue = TaxKind.Items.FindByText("과세") == null ? string.Empty : TaxKind.Items.FindByText("과세").Value;
            CommonDDLB.ITEM_DDLB(Page, ItemCode, "OP", objSes.AccessCenterCode, objSes.AdminID, "비용항목");
            ItemCode.SelectedValue = ItemCode.Items.FindByText("운임") == null ? string.Empty : ItemCode.Items.FindByText("운임").Value;
            CommonDDLB.PICKUP_WAY_DDLB(PickupWay);
            CommonDDLB.GET_WAY_DDLB(GetWay);

            QuickType.Items.Clear();
            QuickType.Items.Add(new ListItem("일반지급","1"));
            QuickType.Items.Add(new ListItem("바로지급","2"));
            QuickType.Items.Add(new ListItem("14일지급","3"));

            CommonDDLB.INSURE_EXCEPT_KIND_DDLB(InsureExceptKind);
            InsureExceptKind.Items.RemoveAt(0);
        }
    }
}