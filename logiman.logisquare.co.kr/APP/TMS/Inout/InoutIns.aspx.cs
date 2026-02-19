using CommonLibrary.CommonModule;
using System;
using CommonLibrary.CommonUtils;

namespace APP.TMS.Inout
{
    public partial class InoutIns : AppPageBase
    {
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

            lo_strOrderNo       = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),  "");
            lo_strCopyFlag      = Utils.IsNull(SiteGlobal.GetRequestForm("CopyFlag"), "N");
            OrderNo.Value       = lo_strOrderNo;
            CopyFlag.Value      = lo_strCopyFlag;

            if (!string.IsNullOrWhiteSpace(lo_strOrderNo) && !lo_strCopyFlag.Equals("Y"))
            {
                HidMode.Value = "Update";
            }
            else
            {
                HidMode.Value = "Insert";
            }

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.ITEM_DDLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID, "사업장");
            CommonDDLB.PAY_TYPE_DDLB(PayType);
            PayType.SelectedValue = PayType.Items.FindByText("매출") == null ? string.Empty : PayType.Items.FindByText("매출").Value;
            CommonDDLB.PAY_TAX_KIND_DDLB(TaxKind);
            TaxKind.SelectedValue = TaxKind.Items.FindByText("과세") == null ? string.Empty : TaxKind.Items.FindByText("과세").Value;
            CommonDDLB.ITEM_DDLB(Page, ItemCode, "OP", objSes.AccessCenterCode, objSes.AdminID, "비용항목");
            ItemCode.SelectedValue = ItemCode.Items.FindByText("운임") == null ? string.Empty : ItemCode.Items.FindByText("운임").Value;

            CommonDDLB.ORDER_ITEM_DDLB(OrderItemCode, false, true, false, false);
            CommonDDLB.ITEM_DDLB(Page, GoodsItemCode, "OD", objSes.AccessCenterCode, objSes.AdminID, "품목");

            HidParam.Value = Utils.IsNull(SiteGlobal.GetRequestForm("HidParam"), "");
        }
    }
}