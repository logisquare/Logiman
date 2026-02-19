using CommonLibrary.CommonModule;
using System;

///================================================================
/// <summary>
/// FileName        : Logout.cs
/// Description     : 로그아웃 처리 페이지
/// Copyright ⓒ 2018 by LOGISLAB. All rights reserved.
/// Author          : pckeeper@logislab.com, 2022-12-26
/// Modify History  : Just Created.
/// </summary>
///================================================================
namespace APP.Login
{
    public partial class Logout : AppPageBase
    {

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
            // Debug-shadow54 : Logout SP 호출 구현해야 함... 2022-03-01
            objSes.goLogout();
        }
    }
}