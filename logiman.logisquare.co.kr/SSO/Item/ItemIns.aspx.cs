using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace SSO.Item
{
    public partial class ItemIns : PageBase
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
            string lo_strGroupCode = string.Empty;
            string lo_strGroupName = string.Empty;

            lo_strGroupCode = Utils.IsNull(SiteGlobal.GetRequestForm("GroupCode"), "");
            lo_strGroupName = Utils.IsNull(SiteGlobal.GetRequestForm("GroupName"), "");

            if (string.IsNullOrWhiteSpace(lo_strGroupCode) || string.IsNullOrWhiteSpace(lo_strGroupCode))
            {
                hidDisplayMode.Value = "N";
                hidErrMsg.Value      = "그룹 코드 값이 없습니다.";
                return;
            }

            hidGroupCode.Value = lo_strGroupCode;
            GroupCode.Text     = lo_strGroupCode;
            GroupName.Text     = lo_strGroupName;

            GroupCode.Attributes.Add("readonly", "readonly");
            GroupName.Attributes.Add("readonly", "readonly");
        }
    }
}