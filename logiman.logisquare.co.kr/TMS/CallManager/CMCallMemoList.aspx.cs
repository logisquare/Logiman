using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.CallManager
{
    public partial class CMCallMemoList : PageBase
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

            CallerDetailTypes.Items.Clear();
            CallerDetailTypes.Items.Add(new ListItem("전체",      ""));
            CallerDetailTypes.Items.Add(new ListItem("기사",      "31"));
            CallerDetailTypes.Items.Add(new ListItem("차량/협력업체", "32,33"));
            CallerDetailTypes.Items.Add(new ListItem("고객사/웹오더", "51,52,71"));
            CallerDetailTypes.Items.Add(new ListItem("상하차지",    "53,72"));
            CallerDetailTypes.Items.Add(new ListItem("로지맨",     "21,22"));

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("검색구분", ""));
            SearchType.Items.Add(new ListItem("전화번호", "1"));
            SearchType.Items.Add(new ListItem("업체명",  "2"));
            SearchType.Items.Add(new ListItem("대표자명", "3"));
            SearchType.Items.Add(new ListItem("담당자",  "4"));
            SearchType.Items.Add(new ListItem("등록자명", "5"));

            string strTelNo = Utils.IsNull(SiteGlobal.GetRequestForm("TelNo"), "");

            if (!string.IsNullOrWhiteSpace(strTelNo))
            {
                SearchType.SelectedValue = "1";
                SearchText.Text          = strTelNo;
            }
        }
    }
}