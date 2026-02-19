using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace WEB.Closing
{
    public partial class WebClosingList : PageBase
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
            PageNo.Value   = "1";
            PageSize.Value = CommonConstant.GRID_PAGENAVIGATION_LIST;

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);

            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("마감일",  "4"));
            DateType.Items.Add(new ListItem("운송기간", "1"));

            BillStatus.Items.Clear();
            BillStatus.Items.Add(new ListItem("전체",   ""));
            BillStatus.Items.Add(new ListItem("미발행",  "1"));
            BillStatus.Items.Add(new ListItem("발행요청", "2"));
            BillStatus.Items.Add(new ListItem("발행완료", "3"));
            BillStatus.Items.Add(new ListItem("발행실패", "4"));
        }
    }
}