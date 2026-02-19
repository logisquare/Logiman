using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace WEB.Inout
{
    public partial class WebInoutIns : PageBase
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
            string lo_strOrderNo = string.Empty;
            string lo_strReqSeqNo = string.Empty;
            string lo_strCopyFlag = string.Empty;

            lo_strOrderNo = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "");
            lo_strReqSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("ReqSeqNo"), "");
            lo_strCopyFlag = Utils.IsNull(SiteGlobal.GetRequestForm("CopyFlag"), "N");
            OrderNo.Value       = lo_strOrderNo;
            OrderNoInfo.Text    = lo_strOrderNo;
            CopyFlag.Value = lo_strCopyFlag;
            CommonDDLB.ORDER_ITEM_DDLB(OrderItemCode, false, true, false, false);

            if (!string.IsNullOrWhiteSpace(lo_strOrderNo) && !lo_strCopyFlag.Equals("Y"))
            {
                HidMode.Value = "Update";
                BtnCancelOrder.Visible = true;
            }
            else
            {
                HidMode.Value           = "Insert";
                BtnCancelOrder.Visible  = false;
                BtnChangeReq.Visible    = false;
                BtnOrgOrderView.Visible = false;
                BtnCopyOrder.Visible    = false;
                OrderInfo.Visible       = false;
                ReqRegDate.Text         = DateTime.Now.ToString("yyyy-MM-dd");
                ReqChargeTeam.Text      = objSes.DeptName;
                ReqChargeName.Text      = objSes.AdminName;
                ReqChargeTel.Text       = objSes.TelNo;
                ReqChargeCell.Text      = objSes.MobileNo;
            }

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.ITEM_DDLB(Page, GoodsItemCode, "OD", objSes.AccessCenterCode, objSes.AdminID, "품목");
            GoodsItemCode.SelectedIndex = 1;
            CommonDDLB.ITEM_DDLB(Page, PopGoodsItemCode, "OD", objSes.AccessCenterCode, objSes.AdminID, "품목");
        }
    }
}