using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace WEB.Domestic
{
    public partial class WebDomesticReqIns : PageBase
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
            PageNo.Value = "1";
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            string lo_strOrderNo            = string.Empty;
            string lo_strCenterCode         = string.Empty;
            string lo_strOrderClientCode    = string.Empty;
            lo_strOrderNo = Utils.IsNull(SiteGlobal.GetRequestForm("HidOrderNo"), "");
            lo_strCenterCode = Utils.IsNull(SiteGlobal.GetRequestForm("HidCenterCode"), "");
            lo_strOrderClientCode = Utils.IsNull(SiteGlobal.GetRequestForm("HidOrderClientCode"), "");

            OrderNo.Value = lo_strOrderNo;
            CenterCode.Value = lo_strCenterCode;
            OrderClientCode.Value = lo_strOrderClientCode;

            if (string.IsNullOrWhiteSpace(lo_strOrderNo) || string.IsNullOrWhiteSpace(lo_strCenterCode))
            {
                DisplayMode.Value = "Y";
                ErrMsg.Value = "필요한 정보가 없습니다.";
                return;
            }
        }
    }
}