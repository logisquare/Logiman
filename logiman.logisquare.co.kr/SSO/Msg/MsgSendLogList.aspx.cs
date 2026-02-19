using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace SSO.Msg
{
    public partial class MsgSendLogList : PageBase
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
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;
            PageNo.Value   = "1";

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.MSG_TYPE_DDLB(objSes.GradeCode, MsgType);
            CommonDDLB.RET_CODE_TYPE_DDLB(RetCodeType);

            MsgType.SelectedValue = "1";

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체 검색", ""));
            SearchType.Items.Add(new ListItem("발신번호",  "SendNum"));
            SearchType.Items.Add(new ListItem("수신번호",  "RcvNum"));

            if (string.IsNullOrWhiteSpace(FromYMD.Text) || string.IsNullOrWhiteSpace(ToYMD.Text))
            {
                FromYMD.Text = DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd");
                ToYMD.Text   = DateTime.Now.ToString("yyyy-MM-dd");
            }

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }

            string strTelNo = Utils.IsNull(SiteGlobal.GetRequestForm("TelNo"), "");

            if (!string.IsNullOrWhiteSpace(strTelNo))
            {
                SearchType.SelectedValue = "RcvNum";
                ListSearch.Text          = strTelNo;
            }
        }
    }
}