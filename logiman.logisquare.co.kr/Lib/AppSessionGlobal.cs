using CommonLibrary.Constants;
using CommonLibrary.Session;
using System;
using System.Web;

//===============================================================
// FileName       : AppSessionGlobal.cs
// Description    : 로지맨앱 세션 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : pckeeper@logislab.com, 2022-11-23
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonModule
{
    public class AppPageBase : PageInit
    {
        public AppPageBase()
        {
        }
        
		public bool IsPageRefresh
		{
			get
			{
				object o = HttpContext.Current.Items[RefreshAction.PageRefreshEntry];

				if (o == null)
					return false;

				return (bool)o;
			}
		}

        public AppSession objSes;

        ///----------------------------------------------------------------------
        /// <summary>        
        /// OnPreInit()
        /// OnPreInit 메소드를 재정의 한다(적용할 Themes 설정)
        /// </summary>
        ///----------------------------------------------------------------------
        protected override void OnPreInit(EventArgs e)
        {
            base.OnPreInit(e);
        }

        ///----------------------------------------------------------------------
        /// <summary>        
        /// OnInit()
        /// Page_Init 메소드를 재정의 한다
        /// </summary>
        ///----------------------------------------------------------------------
        protected override void OnInit(EventArgs e)
        {
            // POSTBACK 이 발생되도록 설정
            Page.ClientScript.GetPostBackEventReference(this, "");
            Page.Title = CommonConstant.APP_SITE_TITLE;

            objSes = new AppSession(this);
            
            SiteGlobal.ReadPageCache_JsonData_CarTon(this.Page);
            SiteGlobal.ReadPageCache_JsonData_AddrList(this.Page);
            CommonUtils.Utils.SetCacheItemGroupJson(this.Page);
            CommonUtils.Utils.SetCacheItemJson(this.Page);
            CommonUtils.Utils.SetCacheItemCenterJson(this.Page);
            CommonUtils.Utils.SetCacheItemAdminJson(this.Page);
            base.OnInit(e);
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
        }
    }
}