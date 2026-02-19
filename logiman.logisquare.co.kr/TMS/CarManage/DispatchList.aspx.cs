using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.CarManage
{
    public partial class DispatchList : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadOnly;

            if (!(objSes.GradeCode.Equals(1) 
                  || objSes.AdminID.Equals("j20120187")
                  || objSes.AdminID.Equals("pyy8606")
                  || objSes.AdminID.Equals("j20120182d")
                  || objSes.AdminID.Equals("j20120182")
                  || objSes.AdminID.Equals("msdjsl")
                  || objSes.AdminID.Equals("tkaejr1029")
                  || objSes.AdminID.Equals("jks1123wl")))
            {
                this.ClientScript.RegisterStartupScript(this.GetType(), "fnPageReplace", "location.replace(\"/Default\");", true);
                return;
            }
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
            
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("검색조건", ""));
            SearchType.Items.Add(new ListItem("차량번호", "1"));
            SearchType.Items.Add(new ListItem("기사명", "2"));
            SearchType.Items.Add(new ListItem("기사휴대폰번호", "3"));
            SearchType.SelectedIndex = 1;

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.Items.Add(new ListItem("하차일", "2"));
            DateType.Items.Add(new ListItem("접수일", "3"));

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}