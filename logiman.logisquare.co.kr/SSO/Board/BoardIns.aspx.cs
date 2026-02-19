using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.Web;
using System.Web.UI.WebControls;

namespace SSO.Board
{
    public partial class BoardIns : PageBase
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
            var lo_strMode = string.Empty;
            var lo_strSeqNo = string.Empty;
            CommonDDLB.CENTER_CODE_CHKLB(AccessCenterCode, objSes.AdminID);
            CommonDDLB.USE_FLAG_DDLB(UseFlag);
            UseFlag.SelectedValue = "Y";
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

            BoardGradeCode.Items.Clear();
            BoardGradeCode.Items.Add(new ListItem("전체", ""));
            BoardGradeCode.Items.Add(new ListItem("운송사", "5"));
            BoardGradeCode.Items.Add(new ListItem("고객(화주)", "6"));

            lo_strMode = SiteGlobal.GetRequestForm("HidMode");
            Mode.Value = lo_strMode;
            if (lo_strMode.Equals("Update")) {
                lo_strSeqNo = SiteGlobal.GetRequestForm("SeqNo");
                SeqNo.Value = lo_strSeqNo;
                GetBoardDetail(lo_strSeqNo);
                GetBoardFileDetail(lo_strSeqNo);
            }
            
            
        }

        protected void GetBoardDetail(string lo_strSeqNo) 
        {
            ReqBoardList lo_objReqBoardList = null;
            ServiceResult<ResBoardList> lo_objResBoardList = null;
            BoardDasServices lo_objBoardDasServices = null;
            try
            {
                lo_objBoardDasServices = new BoardDasServices();

                lo_objReqBoardList = new ReqBoardList
                {
                    SeqNo = lo_strSeqNo.ToInt()
                };

                lo_objResBoardList = lo_objBoardDasServices.GetBoardList(lo_objReqBoardList);
                if (lo_objResBoardList.result.ErrorCode.IsFail() || !lo_objResBoardList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "데이터를 불러오지 못했습니다.";
                    return;
                }

                BoardViewType.SelectedValue = lo_objResBoardList.data.list[0].BoardViewType.ToString();
                MainDisplayFlag.SelectedValue = lo_objResBoardList.data.list[0].MainDisplayFlag.ToString();
                BoardGradeCode.SelectedValue = lo_objResBoardList.data.list[0].AccessGradeCode.ToString();
                if (!lo_objResBoardList.data.list[0].AccessCenterCode.Split(',').Length.Equals(0))
                {
                    for (var iFor = 0; iFor < lo_objResBoardList.data.list[0].AccessCenterCode.Split(',').Length; iFor++)
                    {
                        for (var jFor = 0; jFor < AccessCenterCode.Items.Count; jFor++)
                        {
                            if (lo_objResBoardList.data.list[0].AccessCenterCode.Split(',')[iFor].Equals(AccessCenterCode.Items[jFor].Value))
                            {
                                AccessCenterCode.Items.FindByValue(lo_objResBoardList.data.list[0].AccessCenterCode.Split(',')[iFor].ToString()).Selected = true;
                            }
                        }
                    }
                }

                BoardTitle.Text = lo_objResBoardList.data.list[0].BoardTitle.ToString();
                BoardContent.Text = HttpUtility.HtmlDecode(lo_objResBoardList.data.list[0].BoardContent.ToString());
                UseFlag.Text = lo_objResBoardList.data.list[0].UseFlag.ToString();
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("BoardIns", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }
        }

        protected void GetBoardFileDetail(string lo_strSeqNo)
        {
            string lo_objText = "";
            ReqBoardList lo_objReqBoardList = null;
            ServiceResult<ResBoardList> lo_objResBoardList = null;
            BoardDasServices lo_objBoardDasServices = null;
            try
            {
                lo_objBoardDasServices = new BoardDasServices();

                lo_objReqBoardList = new ReqBoardList
                {
                    SeqNo = lo_strSeqNo.ToInt()
                };

                lo_objResBoardList = lo_objBoardDasServices.GetBoardFileList(lo_objReqBoardList);
                if (lo_objResBoardList.result.ErrorCode.IsFail())
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "파일 데이터를 불러오지 못했습니다.";
                    return;
                }
                if (lo_objResBoardList.data.RecordCnt > 0) {
                    foreach (var row in lo_objResBoardList.data.list)
                    {
                        lo_objText += "<li seq=\""+ Utils.GetEncrypt(row.FileSeqNo.ToString()) +"\" fname=\""+ row.FileNameNew +"\" flag=\"N\">";
                        lo_objText += "<a href=\"#\" onclick=\"fnDownloadFile(this); return false;\">" + row.FileName + "</a> ";
                        lo_objText += "<a href=\"#\" onclick=\"fnDeleteFile(this); return false;\" class=\"file_del\" title=\"파일삭제\">삭제</a>";
                        lo_objText += "</li>\n";
                    }
                    UlFileList.InnerHtml = lo_objText;
                }
                


            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("BoardIns", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }
        }
    }
}