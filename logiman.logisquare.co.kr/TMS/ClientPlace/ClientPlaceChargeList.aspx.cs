using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace TMS.ClientPlace
{
    public partial class ClientPlaceChargeList : PageBase
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
            PageNo.Value = "1";
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CommonDDLB.USE_FLAG_DDLB(UseFlag);
            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체검색", ""));
            SearchType.Items.Add(new ListItem("상하차지명", "PlaceName"));
            SearchType.Items.Add(new ListItem("담당자명", "ChargeName"));
            
            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}