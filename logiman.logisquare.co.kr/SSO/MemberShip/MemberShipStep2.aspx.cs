using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

///================================================================
/// <summary>
/// FileName        : Login.cs
/// Description     : 로그인 페이지
/// Copyright ⓒ 2018 by LOGISLAB. All rights reserved.
/// Author          : shadow54@logislab.com, 2022-03-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
namespace logiman.logisquare.co.kr
{
    public partial class MemberShipStep2 : PageInit
    {
        protected string strReturnUrl   = string.Empty;
        protected string strWebTemplate = string.Empty;

        ///----------------------------------------------------------------------
        /// <summary>
        /// Name          : Page_Load()
        /// Description   : 페이지 로드(포스트백인지 체크)
        /// Special Logic : NONE    
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        ///----------------------------------------------------------------------
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            try
            {
                CenterCode.Items.Clear();
                CenterCode.Items.Add(new ListItem("로지스퀘어", CommonConstant.DEFAULT_CENTER_CODE.ToString()));
                RegReqType.Items.Clear();
                RegReqType.Items.Add(new ListItem("운송구분", ""));
                RegReqType.Items.Add(new ListItem("내수", "2"));
                RegReqType.Items.Add(new ListItem("수출/입", "3"));
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("MemberShipStep1", "Exception"
                                  , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9300);
            }
        }
    }
}