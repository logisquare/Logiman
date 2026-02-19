using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.TransRate
{
    public partial class TransRateApplyIns : PageBase
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
            string lo_strApplySeqNo    = string.Empty;
            lo_strApplySeqNo = SiteGlobal.GetRequestForm("ApplySeqNo");

            GradeCode.Value = objSes.GradeCode.ToString();

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.ORDER_ITEM_DDLB(OrderItemCode, true, true, false, false);
            CommonDDLB.ITEM_CHKLB(Page, OrderLocationCode, "OL", objSes.AccessCenterCode, objSes.AdminID);

            CommonDDLB.ROUND_AMT_KIND_DDLB(FtlRoundAmtKind, "단위");
            CommonDDLB.ROUND_TYPE_DDLB(FtlRoundType, "단위조건");
            CommonDDLB.ROUND_AMT_KIND_DDLB(LtlRoundAmtKind, "단위");
            CommonDDLB.ROUND_TYPE_DDLB(LtlRoundType, "단위조건");

            CommonDDLB.ROUND_AMT_KIND_DDLB(OilSaleRoundAmtKind, "매출단위");
            CommonDDLB.ROUND_TYPE_DDLB(OilSaleRoundType, "매출단위조건");
            CommonDDLB.ROUND_AMT_KIND_DDLB(OilFixedRoundAmtKind, "매입(고정)단위");
            CommonDDLB.ROUND_TYPE_DDLB(OilFixedRoundType, "매입(고정)단위조건");
            CommonDDLB.ROUND_AMT_KIND_DDLB(OilPurchaseRoundAmtKind, "매입(용차)단위");
            CommonDDLB.ROUND_TYPE_DDLB(OilPurchaseRoundType, "매입(용차)단위조건");
            CommonDDLB.OIL_AREA_DDLB(OilSearchArea);
            CommonDDLB.OIL_AREA_DDLB(OilGetPlace1, "지역1(전국)");
            CommonDDLB.OIL_AREA_DDLB(OilGetPlace2, "지역2(전국)");
            CommonDDLB.OIL_AREA_DDLB(OilGetPlace3, "지역3(전국)");

            if (!string.IsNullOrWhiteSpace(lo_strApplySeqNo))
            {
                HidMode.Value    = "Update";
                ApplySeqNo.Value = lo_strApplySeqNo;
            }
            else
            {
                HidMode.Value = "Insert";
            }

            if (objSes.GradeCode > 4)
            {
                BtnTransRateApplyIns.Visible          = false;
                BtnTransRateOilReset.Visible          = false;
                BtnLayoverTransRateReset.Visible      = false;
                BtnTransRateApplyDetailYReset.Visible = false;
                BtnTransRateApplyDetailNReset.Visible = false;
            }
        }
    }
}