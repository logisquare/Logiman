using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;
using CommonLibrary.Extensions;

namespace TMS.TransRate
{
    public partial class TransRateList : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadOnly;
            SetMenuLink("/TMS/TransRate/TransRateList?RateRegKind=1");
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
            string lo_strRateRegKind = string.Empty;

            PageNo.Value    = "1";
            PageSize.Value  = CommonConstant.GRID_PAGENAVIGATION_LIST;
            GradeCode.Value = objSes.GradeCode.ToString();

            lo_strRateRegKind = Utils.IsNull(SiteGlobal.GetRequestForm("RateRegKind"), "0");
            RateRegKind.Value = lo_strRateRegKind;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            
            if (lo_strRateRegKind.ToInt().Equals(4))
            {
                CommonDDLB.RATE_TYPE_DDLB(RateType, 4);
            }
            else if(lo_strRateRegKind.ToInt().Equals(5))
            {
                CommonDDLB.RATE_TYPE_DDLB(RateType, 5);
            }
            else
            {
                CommonDDLB.RATE_TYPE_DDLB(RateType);
            }

            CommonDDLB.FTL_FLAG_DDLB(FTLFlag);

            DelFlag.Items.Clear();
            DelFlag.Items.Add(new ListItem("사용여부", ""));
            DelFlag.Items.Add(new ListItem("사용중", "N"));
            DelFlag.Items.Add(new ListItem("사용중지", "Y"));

            if (objSes.GradeCode > 4)
            {
                BtnTransRateIns.Visible = false;
                BtnSaveExcel.Visible    = false;
            }
        }
    }
}