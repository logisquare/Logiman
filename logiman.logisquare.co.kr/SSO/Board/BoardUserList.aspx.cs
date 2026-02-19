using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using System;
using System.Web.UI.WebControls;

namespace SSO.Board
{
    public partial class BoardUserList : PageBase
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
            BoardViewType.Items.Clear();
            BoardViewType.Items.Add(new ListItem("게시판 유형", ""));
            BoardViewType.Items.Add(new ListItem("공지사항", "1"));
            BoardViewType.Items.Add(new ListItem("작업공지", "2"));
            BoardViewType.Items.Add(new ListItem("업데이트", "3"));
            BoardViewType.Items.Add(new ListItem("이벤트", "4"));

            MainDisplayFlag.Items.Clear();
            MainDisplayFlag.Items.Add(new ListItem("게시물 선택", ""));
            MainDisplayFlag.Items.Add(new ListItem("메인", "Y"));
            MainDisplayFlag.Items.Add(new ListItem("일반", "N"));

            SearchType.Items.Clear();
            SearchType.Items.Add(new ListItem("전체검색", ""));
            SearchType.Items.Add(new ListItem("제목", "Title"));
        }
    }
}