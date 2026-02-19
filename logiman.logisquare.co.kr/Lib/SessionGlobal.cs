using CommonLibrary.CommonModel;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using CommonLibrary.Session;
using PBSDasNetCom;
using System;
using System.Web;

//===============================================================
// FileName       : SessionGlobal.cs
// Description    : 세션 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonModule
{

    public class RefreshModule : IHttpModule
    {
        #region RefreshModule
        // IHttpModule::Init
        public void Init(HttpApplication app)
        {
            // 파이프라인 이벤트에 등록합니다.
            app.AcquireRequestState += new EventHandler(OnAcquireRequestState);
        }

        // IHttpModule::Dispose

        public void Dispose() { }

        // F5 또는 뒤로/앞으로 동작이 진행 중인지 확인합니다.

        private void OnAcquireRequestState(object sender, EventArgs e)
        {
            // HTTP 컨텍스트에 액세스합니다.
            HttpApplication app = (HttpApplication)sender;
            HttpContext     ctx = app.Context;
            // F5 동작을 확인합니다.
            RefreshAction.Check(ctx);
        }

        #endregion
    }

    public class RefreshAction
    {
        #region RefreshAction
        public const string LastRefreshTicketEntry    = "__LASTREFRESHTICKET";
        public const string CurrentRefreshTicketEntry = "__CURRENTREFRESHTICKET";
        public const string PageRefreshEntry          = "IsPageRefresh";

        public static void Check(HttpContext ctx)
        {
            // 티켓 슬롯을 초기화합니다.
            EnsureRefreshTicket(ctx);

            // 마지막으로 사용한 티켓을 세션으로부터 읽습니다.
            int lastTicket = GetLastRefreshTicket(ctx);

            // 현재 요청의 티켓을 숨겨진 필드로부터 읽습니다.
            int thisTicket = GetCurrentRefreshTicket(ctx);

            // 티켓을 비교합니다.
            if (thisTicket > lastTicket || (thisTicket == lastTicket && thisTicket == 0))
            {
                UpdateLastRefreshTicket(ctx, thisTicket);
                ctx.Items[PageRefreshEntry] = false;
            }
            else
            {
                ctx.Items[PageRefreshEntry] = true;
            }
        }

        private static void EnsureRefreshTicket(HttpContext ctx)
        {
            try
            {
                if (ctx.Session == null)
                {
                    return;
                }

                if (ctx.Session[LastRefreshTicketEntry] == null)
                    ctx.Session[LastRefreshTicketEntry] = 0;
            }
            catch
            {
                // ignored
            }
        }

        private static int GetLastRefreshTicket(HttpContext ctx)
        {
            try
            {
                if (ctx.Session == null)
                {
                    return 0;
                }
                return ctx.Session[LastRefreshTicketEntry].ToInt();
            }
            catch
            {
                return 0;
            }
        }

        private static int GetCurrentRefreshTicket(HttpContext ctx)
        {
            try
            {
                if (ctx.Session == null)
                {
                    return 0;
                }

                return ctx.Request[CurrentRefreshTicketEntry].ToInt();
            }
            catch
            {
                return 0;
            }
        }

        private static void UpdateLastRefreshTicket(HttpContext ctx, int ticket)
        {
            try
            {
                if (ctx.Session == null)
                {
                    return;
                }

                ctx.Session[LastRefreshTicketEntry] = ticket;
            }
            catch
            {
                // ignored
            }
        }

        #endregion
    }

    // 로그인 전단계에서의 페이지 객체 상속
    public class PageInit : System.Web.UI.Page
    {
        protected override void OnPreInit(EventArgs e)
        {
            // 접근한 IP 주소의 국가를 조회하여 접근 허용/불가를 판단
            CheckIPNation();

            base.OnPreInit(e);
        }

        protected void CheckIPNation()
        {
            CheckIPNation_Response lo_objResponse  = SiteGlobal.CheckIPNation();
            string                 lo_strIPAddress = SiteGlobal.GetRemoteAddr();

            if (!lo_objResponse.Header.ResultCode.Equals(0))
            {
                Response.StatusCode = 403;
                Response.StatusDescription = $"Forbidden : {lo_strIPAddress} => {lo_objResponse.Header.ResultMessage}";
                Response.End();
            }

            if (lo_objResponse.Payload.AccessFlag != "Y")
            {
                Response.StatusCode = 403;
                Response.StatusDescription = $"Forbidden : {lo_strIPAddress} => Not Allowed IP Address";
                Response.End();
            }
        }
    }

    public class PageBase : PageInit
    {
        private string strSetMenuLink = string.Empty; //페이지 링크
        private bool   IsCheckAuth { get; set; }      //메뉴권한 체크 여부

        public PageBase()
        {
            IsCheckAuth = true;
        }

        /// <summary>
        /// 페이지 링크를 지정한다.(필수)
        /// </summary>
        protected void SetMenuLink(string strCurrMenuLink)
        {
            strSetMenuLink = strCurrMenuLink;
        }

        /// <summary>
        /// 메뉴권한 체크가 필요없는 경우 호출한다
        /// </summary>
        protected void IgnoreCheckMenuAuth()
        {
            IsCheckAuth = false;
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

        public SiteSession    objSes;
        public PageAccessType _pageAccessType;

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
            Page.Title = CommonConstant.SITE_TITLE;

            _pageAccessType   = PageAccessType.ReadOnly;

            string lo_strCookie = string.Empty;
            if (null == Request.Cookies[CommonConstant.COOKIE_NAME] || 
                string.IsNullOrWhiteSpace(Request.Cookies.ToString()) ||
                string.IsNullOrWhiteSpace(Request.Cookies[CommonConstant.COOKIE_NAME].ToString()))
            {
                lo_strCookie = "";
            }
            else
            {
                lo_strCookie = Request.Cookies[CommonConstant.COOKIE_NAME].Value;
                if (String.IsNullOrWhiteSpace(lo_strCookie))
                {
                    lo_strCookie = "";
                }
            }

            objSes = new SiteSession(this);
            
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
            bool       lo_bResult         = true;
            string     lo_strCurrMenuLink = Request.Path;
            string     lo_strErrMsg       = string.Empty;
            IDasNetCom lo_objDas          = null;

            try
            {

                lo_strCurrMenuLink = string.IsNullOrEmpty(strSetMenuLink) ? Request.Path : strSetMenuLink;

                //관리자 등급을 확인 하지 못했을 경우 메뉴 권한을 체크할 필요 없음
                if (objSes.GradeCode.Equals(0))
                {
                    CommonUtils.Utils.ReplaceRootPageWithURL(this, "/");
                    return;
                }

                //메뉴접근 권한 확인
                if (IsCheckAuth && !string.IsNullOrWhiteSpace(lo_strCurrMenuLink))
                {
                    lo_objDas = new IDasNetCom();
                    lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);

                    if (!lo_strCurrMenuLink.ToLower().Equals(CommonConstant.MAIN_PAGE_1.ToLower()) && 
                        !lo_strCurrMenuLink.ToLower().Equals(CommonConstant.MAIN_PAGE_2.ToLower()) &&
                        !lo_strCurrMenuLink.ToLower().Equals(CommonConstant.MAIN_PAGE_3.ToLower()))
                    {
                        lo_bResult = CheckAdminMenu(ref lo_objDas, lo_strCurrMenuLink, out lo_strErrMsg);
                        if (false == lo_bResult)
                        {
                            CommonUtils.Utils.ShowAlertCheckMenu(this, lo_strErrMsg);
                            //CommonUtils.Utils.ReplaceRootPageWithURL(this, "/");
                        }
                        else
                        {
                            // 메뉴 호출 로그를 DB에 기록한다.
                            string lo_strCallParam = SiteGlobal.GetAllRequestLog();
                            AdminDasServices lo_objAdminDasServices = new AdminDasServices();

                            lo_strCallParam = lo_strCallParam != null && lo_strCallParam.Length > 4000 ? lo_strCallParam.Substring(0, 3999) : lo_strCallParam;
                            lo_strCallParam = lo_strCallParam.Replace((char)3, '[');
                            lo_strCallParam = lo_strCallParam.Replace((char)2, ']');

                            lo_objAdminDasServices.InsAdminLog(ref lo_objDas, objSes.AdminID, 0, lo_strCurrMenuLink, _pageAccessType.GetHashCode(), 1, lo_strCallParam);
                        }
                    }
                }
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                base.OnLoad(e);
            }
        }

        protected bool CheckAdminMenu(ref IDasNetCom objDas, string strMenuLink, out string strErrMsg)
        {
            AdminDasServices            lo_objAdminDasServices = new AdminDasServices();
            ServiceResult<AdminMenuChk> lo_objResAdminMenuChk  = null;
            
            strErrMsg = "";

            try
            {
                lo_objResAdminMenuChk = lo_objAdminDasServices.CheckAdminMenu(ref objDas, objSes.AdminID, objSes.GradeCode, strMenuLink);
                if (lo_objResAdminMenuChk.result.ErrorCode.IsFail())
                {
                    strErrMsg = lo_objResAdminMenuChk.result.ErrorMsg;
                    return false;
                }
                else
                {
                    objSes.AuthCode = lo_objResAdminMenuChk.data.AuthCode;
                }

                if (objSes.AuthCode > _pageAccessType.GetHashCode() || objSes.AuthCode < 1)
                {
                    strErrMsg = "메뉴 사용 권한이 없습니다.";
                    return false;
                }
            }
            catch
            {
                strErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                return false;
            }

            return true;
        }
    }

}