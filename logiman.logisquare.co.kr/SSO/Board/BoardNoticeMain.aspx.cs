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
    public partial class BoardNoticeMain : PageBase
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
            ReqBoardList lo_objReqBoardList = null;
            ServiceResult<ResBoardList> lo_objResBoardList = null;

            ReqBoardList lo_objReqBoardFileList = null;
            ServiceResult<ResBoardList> lo_objResBoardFileList = null;

            BoardDasServices lo_objBoardDasServices = null;
            string lo_strContents = string.Empty;
            string lo_strNewFlag = string.Empty;

            lo_objBoardDasServices = new BoardDasServices();

            lo_objReqBoardList = new ReqBoardList
            {
                MainDisplayFlag = "Y",
                UseFlag = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                GradeCode = objSes.GradeCode
            };

            lo_objResBoardList = lo_objBoardDasServices.GetBoardList(lo_objReqBoardList);
            if (lo_objResBoardList.result.ErrorCode.IsFail())
            {
                NOTICE_NO_DATA.Visible = true;
            }

            if (lo_objResBoardList.data.RecordCnt > 0)
            {
                foreach (var row in lo_objResBoardList.data.list)
                {
                    lo_objReqBoardFileList = new ReqBoardList
                    {
                        SeqNo = row.SeqNo.ToInt()
                    };
                    if (row.YMD.Equals(DateTime.Now.ToString("yyyyMMdd"))) {
                        lo_strNewFlag = "Y";
                    }
                    lo_objResBoardFileList = lo_objBoardDasServices.GetBoardFileList(lo_objReqBoardFileList);
                    
                    lo_strContents += "<div style=\"position: relative; height:100%;\">";
                    lo_strContents += "<div class=\"hc_notice_title\">";
                    lo_strContents += "<h3>" + row.BoardTitle + " <strong> As of " + row.RegDate + "</strong></h3>";
                    lo_strContents += "</div>";
                    lo_strContents += "<div class=\"hc_notice_cnts\">" + HttpUtility.HtmlDecode(row.BoardContent) + "</div>";
                    lo_strContents += "<div class=\"notice_files\">";
                    lo_strContents += "<strong>Ã·ºÎÆÄÀÏ : </strong>";
                    lo_strContents += "<ul>";
                    foreach (var Filerow in lo_objResBoardFileList.data.list)
                    {
                        lo_strContents += "<li style=\"margin-right:5px;\" seq=\"" + Utils.GetEncrypt(Filerow.FileSeqNo.ToString()) + "\" fname=\"" + Filerow.FileNameNew + "\" flag=\"N\">";
                        lo_strContents += "<a href=\"#\" onclick=\"fnDownloadFile(this); return false;\">" + Filerow.FileName + "</a> ";
                        lo_strContents += "</li>";
                    }
                    lo_strContents += "</ul>";
                    lo_strContents += "</div>";
                    lo_strContents += "</div>";
                }

                HidNewFlag.Value = lo_strNewFlag;
                HidNoticeDataFlag.Value = "Y";
            }
            else {
                NOTICE_NO_DATA.Visible = true;
                NoticeBody.Visible = false;
                HidNoticeDataFlag.Value = "N";
            }

            NoticeBody.InnerHtml = lo_strContents;
        }
    }
}