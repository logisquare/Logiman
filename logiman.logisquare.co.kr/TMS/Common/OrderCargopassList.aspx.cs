using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.Common
{
    public partial class OrderCargopassList : PageBase
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
            PageNo.Value = "1";

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);

            CargopassStatus.Items.Clear();
            CargopassStatus.Items.Add(new ListItem("<span></span>요청",   "1"));
            CargopassStatus.Items.Add(new ListItem("<span></span>등록",   "2"));
            CargopassStatus.Items.Add(new ListItem("<span></span>배차",   "3"));
            CargopassStatus.Items.Add(new ListItem("<span></span>배차확정", "4"));
            CargopassStatus.Items.Add(new ListItem("<span></span>취소",   "9"));

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.Items.Add(new ListItem("하차일", "2"));
            DateType.Items.Add(new ListItem("등록일", "3"));
            DateType.SelectedIndex = 0;
        }
    }
}