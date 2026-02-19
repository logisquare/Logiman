using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace WEB.Domestic
{
    public partial class WebDomesticList : PageBase
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

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("상차일", "1"));
            DateType.Items.Add(new ListItem("요청일", "2"));

            OrderStatus.Items.Clear();
            OrderStatus.Items.Add(new ListItem("전체", ""));
            OrderStatus.Items.Add(new ListItem("등록", "1"));
            OrderStatus.Items.Add(new ListItem("접수", "2"));
            OrderStatus.Items.Add(new ListItem("배차", "3"));
            OrderStatus.Items.Add(new ListItem("상차", "4"));
            OrderStatus.Items.Add(new ListItem("하차", "5"));

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체검색", ""));
            SearchType.Items.Add(new ListItem("화주명", "ConsignorName"));
            SearchType.Items.Add(new ListItem("상차지명", "PickupPlace")); 
            SearchType.Items.Add(new ListItem("하차지명", "GetPlace")); 
            SearchType.Items.Add(new ListItem("화물(제품)명", "GoodsName")); 

            if (!objSes.AuthCode.Equals(MenuAuthType.All.GetHashCode()))
            {
                BtnSaveExcel.Style.Add("display", "none");
            }
        }
    }
}