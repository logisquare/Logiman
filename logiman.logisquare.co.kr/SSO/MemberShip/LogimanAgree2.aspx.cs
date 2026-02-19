using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;
using System.Web.UI;

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
    public partial class LogimanAgree2 : PageInit
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
                
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("LogimanAgree1", "Exception"
                                  , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9300);
            }
        }
    }
}