using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;
using CommonLibrary.Constants;

namespace TMS.ClosingSale
{
    public partial class SaleClosingTaxBillList : PageBase
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
            PageSize.Value    = CommonConstant.GRID_PAGENAVIGATION_LIST;

            ClosingType.Value = Utils.IsNull(SiteGlobal.GetRequestForm("ClosingType"), "1");

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode, 2);
            CommonDDLB.DATE_CHOICE_DDLB(DateChoice);
            DateType.Items.Clear();
            DateType.Items.Add(new ListItem("작성일", "1"));
            DateType.SelectedIndex = 0;

            ReqStatCode.Items.Clear();
            ReqStatCode.Items.Add(new ListItem("요청상태", ""));
            ReqStatCode.Items.Add(new ListItem("신규발행요청", "01"));
            ReqStatCode.Items.Add(new ListItem("매입승인요청", "02"));
            ReqStatCode.Items.Add(new ListItem("승인취소요청",    "03"));
            ReqStatCode.Items.Add(new ListItem("발행취소확인요청",    "05"));
            ReqStatCode.Items.Add(new ListItem("수정발행요청",    "06"));
            ReqStatCode.Items.Add(new ListItem("역발행등록요청",    "08"));
            ReqStatCode.Items.Add(new ListItem("임시저장요청",    "09"));
            ReqStatCode.SelectedIndex = 0;

            StatCode.Items.Clear();
            StatCode.Items.Add(new ListItem("응답상태", ""));
            StatCode.Items.Add(new ListItem("등록", "01"));
            StatCode.Items.Add(new ListItem("승인", "02"));
            StatCode.Items.Add(new ListItem("승인취소", "03"));
            StatCode.Items.Add(new ListItem("발행취소", "05"));
            StatCode.Items.Add(new ListItem("수정등록", "06"));
            StatCode.Items.Add(new ListItem("발행처리중", "07"));
            StatCode.Items.Add(new ListItem("역발행등록", "08"));
            StatCode.Items.Add(new ListItem("임시저장", "09"));
            StatCode.Items.Add(new ListItem("국세청처리오류", "99"));
            StatCode.Items.Add(new ListItem("국세청정상", "00"));
            StatCode.SelectedIndex = 0;
        }
    }
}