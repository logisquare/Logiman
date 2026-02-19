using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;
using CommonLibrary.Constants;

namespace TMS.Common
{
    public partial class OrderAmtConfirmList : PageBase
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
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            string lo_strOrderNo  = string.Empty;
            string lo_strListType = string.Empty;
            lo_strOrderNo  = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),  string.Empty);
            lo_strListType = Utils.IsNull(SiteGlobal.GetRequestForm("ListType"), "2");
            OrderNo.Text   = lo_strOrderNo;
            ListType.Value = lo_strListType;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.Items.Add(new ListItem("하차일", "2"));
            DateType.Items.Add(new ListItem("접수일", "3"));
            DateType.Items.Add(new ListItem("요청일", "4"));
            DateType.SelectedIndex = 3;

            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);

            ReqStatus.Items.Clear();
            ReqStatus.Items.Add(new ListItem("요청상태", ""));
            ReqStatus.Items.Add(new ListItem("요청",   "1"));
            ReqStatus.Items.Add(new ListItem("승인",   "2"));
            ReqStatus.Items.Add(new ListItem("반려",   "3"));
            ReqStatus.Items.Add(new ListItem("취소",   "9"));

            PayType.Items.Clear();
            PayType.Items.Add(new ListItem("비용구분", ""));
            PayType.Items.Add(new ListItem("매출",   "1"));
            PayType.Items.Add(new ListItem("매입",   "2"));
        }
    }
}