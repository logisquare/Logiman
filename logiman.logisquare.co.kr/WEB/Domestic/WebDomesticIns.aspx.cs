using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace WEB.Domestic
{
    public partial class WebDomesticIns : PageBase
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

            lo_strOrderNo = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),  "");
            lo_strReqSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("ReqSeqNo"),  "");
            lo_strCopyFlag      = Utils.IsNull(SiteGlobal.GetRequestForm("CopyFlag"), "N");
            OrderNo.Value       = lo_strOrderNo;
            ReqSeqNo.Value      = lo_strReqSeqNo;
            CopyFlag.Value      = lo_strCopyFlag;
            OrderItemCode.Value = "OA007";

            if (!string.IsNullOrWhiteSpace(lo_strOrderNo) && !lo_strCopyFlag.Equals("Y"))
            {
                HidMode.Value        = "Update";
                BtnCancelOrder.Visible   = true;
                AcceptView.Visible = true;
            }
            else
            {
                HidMode.Value        = "Insert";
                BtnCancelOrder.Visible   = false;
                BtnChangeReq.Visible = false;
                BtnOrgOrderView.Visible = false;
                BtnCopyOrder.Visible = false;
                ReqRegDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                ReqChargeTeam.Text = objSes.DeptName;
                ReqChargeName.Text = objSes.AdminName;
            }

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
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
        }
    }
}