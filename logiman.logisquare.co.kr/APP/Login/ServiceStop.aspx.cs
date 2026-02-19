using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;
using System.Web.UI;

///================================================================
/// <summary>
/// FileName        : ServiceStop.cs
/// Description     : 서비스 점검페이지
/// Copyright ⓒ 2018 by LOGISLAB. All rights reserved.
/// Author          : shadow54@logislab.com, 2022-03-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
namespace APP.Login
{
    public partial class ServiceStop : PageInit
    {
        public string m_Title       = string.Empty;
        public string m_Contents    = string.Empty;

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
            // iframe 안에 창이 구동된 경우, top window로 redirect 한다.
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                                                "if(window != window.top) {window.top.location = '/';}", true);

            m_Title = CommonLibrary.CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_TITLE).ToString();
            if (string.IsNullOrWhiteSpace(m_Title))
            {
                m_Title = "서비스 준비중";
            }
            m_Contents = CommonLibrary.CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_CONTENT).ToString();
            if (string.IsNullOrWhiteSpace(m_Contents))
            {
                m_Contents = "시스템 점검중으로 서비스 이용이 불가합니다.";
            }
        }
    }
}