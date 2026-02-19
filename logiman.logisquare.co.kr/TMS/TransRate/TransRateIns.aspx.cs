using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;
using CommonLibrary.Extensions;

namespace TMS.TransRate
{
    public partial class TransRateIns : PageBase
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
            string lo_strDtlSeqNo      = string.Empty;
            string lo_strCenterCode    = string.Empty;
            string lo_strTransSeqNo    = string.Empty;
            string lo_strRateRegKind   = string.Empty;
            string lo_strRateType      = string.Empty;
            string lo_strFTLFlag       = string.Empty;
            string lo_strTransRateName = string.Empty;
            string lo_strDelFlag       = string.Empty;

            PageSize.Value = CommonConstant.PAGENAVIGATION_LIST;
            PageNo.Value   = "1";
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.FTL_FLAG_DDLB(FTLFlag);

            lo_strDtlSeqNo      = Utils.IsNull(SiteGlobal.GetRequestForm("DtlSeqNo"), "0");
            lo_strCenterCode    = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "");
            lo_strTransSeqNo    = Utils.IsNull(SiteGlobal.GetRequestForm("TransSeqNo"), "0");
            lo_strRateRegKind   = Utils.IsNull(SiteGlobal.GetRequestForm("RateRegKind"), "0");
            lo_strRateType      = Utils.IsNull(SiteGlobal.GetRequestForm("RateType"), "");
            lo_strFTLFlag       = Utils.IsNull(SiteGlobal.GetRequestForm("FTLFlag"), "");
            lo_strTransRateName = Utils.IsNull(SiteGlobal.GetRequestForm("TransRateName"), "");
            lo_strDelFlag       = Utils.IsNull(SiteGlobal.GetRequestForm("DelFlag"), "");

            DtlSeqNo.Value    = lo_strDtlSeqNo;
            TransSeqNo.Value  = lo_strTransSeqNo;
            RateRegKind.Value = lo_strRateRegKind;

            if (lo_strRateRegKind.ToInt().Equals(4))
            {
                CommonDDLB.RATE_TYPE_DDLB(RateType, 4);
                DefaultExcelSampleBtn.Visible = false;
                AddrExcelBtn.Visible          = false;
                AddExcelSampleBtn.Visible     = true;

            }
            else if (lo_strRateRegKind.ToInt().Equals(5))
            {
                CommonDDLB.RATE_TYPE_DDLB(RateType, 5);
                DefaultExcelSampleBtn.Visible = false;
                AddrExcelBtn.Visible          = false;
                CarTonExcelbtn.Visible        = false;
                CarTruckExcelbtn.Visible      = false;
                AddExcelSampleBtn.Visible     = true;
            }
            else
            {
                CommonDDLB.RATE_TYPE_DDLB(RateType);
            }

            if (!string.IsNullOrWhiteSpace(lo_strTransSeqNo) && !lo_strTransSeqNo.Equals("0"))
            {
                DelFlag.Items.Clear();
                DelFlag.Items.Add(new ListItem("사용중", "N"));
                DelFlag.Items.Add(new ListItem("사용중지", "Y"));

                HidMode.Value            = "Update";
                CenterCode.SelectedValue = lo_strCenterCode;
                RateType.SelectedValue   = lo_strRateType;
                FTLFlag.SelectedValue    = lo_strFTLFlag;
                TransRateName.Text       = lo_strTransRateName;
                HidTransRateChk.Value    = "Y";
                BtnUseFlag.Visible       = true;
                DelFlag.SelectedValue    = lo_strDelFlag;
                GradeCode.Value          = objSes.GradeCode.ToString();
                //관리자 등급만 이벤트 버튼이 보임
                if (objSes.GradeCode >= 5)
                {
                    BtnUseFlag.Visible      = false;
                    BtnTransRateReg.Visible = false;
                }
            }
            else
            {
                HidMode.Value = "Insert";
                DelFlag.Items.Clear();
                DelFlag.Items.Add(new ListItem("사용중", "N"));
            }
        }
    }
}