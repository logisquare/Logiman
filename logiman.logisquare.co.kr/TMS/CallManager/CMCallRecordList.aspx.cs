using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.CallManager
{
    public partial class CMCallRecordList : PageBase
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
            PageNo.Value    = "1";
            PageSize.Value  = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);

            CallType.Items.Clear();
            CallType.Items.Add(new ListItem("전체", ""));
            CallType.Items.Add(new ListItem("전화수신", "1"));
            CallType.Items.Add(new ListItem("전화발신", "2"));
            CallType.Items.Add(new ListItem("문자수신", "3"));
            CallType.Items.Add(new ListItem("문자발신", "4"));

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("검색구분",   ""));
            SearchType.Items.Add(new ListItem("수발신번호", "1"));
            SearchType.Items.Add(new ListItem("수신번호", "2"));
            SearchType.Items.Add(new ListItem("발신번호", "3"));
            SearchType.Items.Add(new ListItem("문자내용", "4"));

            string strTelNo = Utils.IsNull(SiteGlobal.GetRequestForm("TelNo"), "");

            if (!string.IsNullOrWhiteSpace(strTelNo))
            {
                SearchType.SelectedValue = "1";
                SearchText.Text          = strTelNo;
            }
        }
    }
}