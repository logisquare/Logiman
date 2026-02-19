using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;
using System.Web.UI.WebControls;

namespace SSO.Board
{
    public partial class BoardDetail : PageBase
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
            
            lo_strSeqNo = SiteGlobal.GetRequestForm("SeqNo");
            SeqNo.Value = lo_strSeqNo;
            GetBoardDetail(lo_strSeqNo);
            GetBoardFileDetail(lo_strSeqNo);
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

                BoardViewTypeM.Text = lo_objResBoardList.data.list[0].BoardViewTypeM.ToString();
                MainDisplayFlagM.Text = lo_objResBoardList.data.list[0].MainDisplayFlagM.ToString();

                BoardTitle.Text = lo_objResBoardList.data.list[0].BoardTitle.ToString();
                BoardContent.InnerHtml = HttpUtility.HtmlDecode(lo_objResBoardList.data.list[0].BoardContent.ToString());
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("BoardDetail", "Exception",
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
                if (lo_objResBoardList.data.RecordCnt > 0)
                {
                    foreach (var row in lo_objResBoardList.data.list)
                    {
                        lo_objText += "<li seq=\"" + Utils.GetEncrypt(row.FileSeqNo.ToString()) + "\" fname=\"" + row.FileNameNew + "\" flag=\"N\">";
                        lo_objText += "<a href=\"#\" onclick=\"fnDownloadFile(this); return false;\" class=\"download\">" + row.FileName + "</a> ";
                        lo_objText += "</li>\n";
                    }
                    UlFileList.InnerHtml = lo_objText;
                }



            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("BoardDetail", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9103);
            }
        }
    }
}