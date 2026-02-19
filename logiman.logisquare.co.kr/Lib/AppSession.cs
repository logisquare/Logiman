using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using System;
using System.Text;
using System.Web;
using System.Web.UI;

//===============================================================
// FileName       : AppSession.cs
// Description    : 로지맨앱 세션 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : pckeeper@logislab.com, 2022-11-23
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.Session
{
    public class AppSession
    {
        #region Define Variables
        AppSession_Member objSesMember = new AppSession_Member();
        private string    strDomainName;
        #endregion

        public AppSession()
        {
            strDomainName = SiteGlobal.GetHttpHost(HttpContext.Current.Request);
        }

        public AppSession(Page p)
        {
            //======================================================================
            //서비스 점검 체크
            //======================================================================
            string strServiceStopFlag = CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_FLAG).ToString();
            if (strServiceStopFlag.Equals("Y"))
            {
                if (!CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_ALLOWIP).ToString().Contains(SiteGlobal.GetRemoteAddr()))
                {
                    HttpContext.Current.Response.Redirect("/APP/Login/ServiceStop", false);
                    return;
                }
            }

            strDomainName = SiteGlobal.GetHttpHost(HttpContext.Current.Request);

            GetSessionCookie();
            if(IsLogin.Equals(false))
            {
                GoLogin("");
            }
        }

        public void GoLogin(string strErrMsg)
        {
            string lo_strUrl      = HttpContext.Current.Request.ServerVariables.Get("URL");
            string lo_strProtocol = SiteGlobal.GetHttpProtocol();
            string lo_strHost     = HttpContext.Current.Request.ServerVariables.Get("HTTP_HOST");
            string lo_strRetUrl   = CommonConstant.APP_LOGIN_PAGE + "?returnurl=" + lo_strProtocol + "://" + lo_strHost + lo_strUrl;

            if (!string.IsNullOrWhiteSpace(strErrMsg))
            {
                lo_strRetUrl += "&errmsg=" + strErrMsg;
            }

            // 리다이렉트 URL 에는 줄바꿈이 있으면 안된다.
            lo_strRetUrl = lo_strRetUrl.Replace("\r", "").Replace("\n", "");

            HttpContext.Current.Response.Redirect(lo_strRetUrl, true);
        }

        public void CreateAuthCookieInfo(AppSession_Member cookie)
        {
            string lo_strCookieInfo = string.Empty;

            ExpireSessionCookie();

            lo_strCookieInfo = 
                cookie.AdminID                  + CommonConstant.APP_DELIMETER +
                cookie.MobileNo                 + CommonConstant.APP_DELIMETER +
                cookie.AdminName                + CommonConstant.APP_DELIMETER +
                cookie.DeptName                 + CommonConstant.APP_DELIMETER +
                cookie.Position                 + CommonConstant.APP_DELIMETER +
                cookie.TelNo                    + CommonConstant.APP_DELIMETER +
                cookie.Email                    + CommonConstant.APP_DELIMETER +
                cookie.GradeCode                + CommonConstant.APP_DELIMETER +
                cookie.GradeName                + CommonConstant.APP_DELIMETER +
                cookie.LastLoginDate            + CommonConstant.APP_DELIMETER +
                cookie.LastLoginIP              + CommonConstant.APP_DELIMETER +
                cookie.PwdUpdDate               + CommonConstant.APP_DELIMETER +
                cookie.AccessCenterCode         + CommonConstant.APP_DELIMETER +
                cookie.AccessCorpNo             + CommonConstant.APP_DELIMETER +
                cookie.Network24DDID            + CommonConstant.APP_DELIMETER +
                cookie.NetworkHMMID             + CommonConstant.APP_DELIMETER +
                cookie.NetworkOneCallID         + CommonConstant.APP_DELIMETER +
                cookie.NetworkHmadangID         + CommonConstant.APP_DELIMETER +
                cookie.ExpireYmd                + CommonConstant.APP_DELIMETER +
                cookie.OrderItemCodes           + CommonConstant.APP_DELIMETER +
                cookie.OrderLocationCodes       + CommonConstant.APP_DELIMETER +
                cookie.OrderStatusCodes         + CommonConstant.APP_DELIMETER +
                cookie.DeliveryLocationCodes    + CommonConstant.APP_DELIMETER +
                cookie.MyOrderFlag              + CommonConstant.APP_DELIMETER +
                cookie.PrivateAvailFlag         + CommonConstant.APP_DELIMETER +
                DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            HttpCookie objCookie = new HttpCookie(CommonConstant.APP_COOKIE_NAME)
            {
                Value    = CommonUtils.Utils.GetEncrypt(lo_strCookieInfo),
                Domain   = strDomainName,
                Expires  = DateTime.Now.AddMonths(1),
                HttpOnly = true
            };

            HttpContext.Current.Response.Cookies.Add(objCookie);
        }

        private void ExpireSessionCookie()
        {
            HttpCookie lo_objCookie = new HttpCookie(CommonConstant.APP_COOKIE_NAME)
            {
                Value    = null,
                Domain   = strDomainName,
                Expires  = DateTime.Now.AddDays(-1),
                HttpOnly = true
            };

            HttpContext.Current.Response.Cookies.Add(lo_objCookie);
        }

        public void GetSessionCookie()
        {
            string     lo_strCookie = string.Empty;
            string[]   lo_arrSession;
            HttpCookie lo_objCookie = null;

            IsLogin = false;    // 초기값 설정

            lo_objCookie = HttpContext.Current.Request.Cookies[CommonConstant.APP_COOKIE_NAME];
            if (null == lo_objCookie || string.IsNullOrWhiteSpace(lo_objCookie.Value))
            {
                return;
            }

            lo_strCookie = CommonUtils.Utils.GetDecrypt(lo_objCookie.Value);
            if (null == lo_strCookie || string.IsNullOrWhiteSpace(lo_strCookie))
            {
                return;
            }

            lo_arrSession = lo_strCookie.Split(CommonConstant.APP_DELIMETER);
            if (!lo_arrSession.Length.Equals(26))
            {
                ExpireSessionCookie();
                return;
            }

            AdminID               = lo_arrSession[0];
            MobileNo              = lo_arrSession[1];
            AdminName             = lo_arrSession[2];
            DeptName              = lo_arrSession[3];
            Position              = lo_arrSession[4];
            TelNo                 = lo_arrSession[5];
            Email                 = lo_arrSession[6];
            GradeCode             = lo_arrSession[7].ToInt();
            GradeName             = lo_arrSession[8];
            LastLoginDate         = lo_arrSession[9];
            LastLoginIP           = lo_arrSession[10];
            PwdUpdDate            = lo_arrSession[11];
            AccessCenterCode      = lo_arrSession[12];
            AccessCorpNo          = lo_arrSession[13];
            Network24DDID         = lo_arrSession[14];
            NetworkHMMID          = lo_arrSession[15];
            NetworkOneCallID      = lo_arrSession[16];
            NetworkHmadangID      = lo_arrSession[17];
            ExpireYmd             = lo_arrSession[18];
            OrderItemCodes        = lo_arrSession[19];
            OrderLocationCodes    = lo_arrSession[20];
            OrderStatusCodes      = lo_arrSession[21];
            DeliveryLocationCodes = lo_arrSession[22];
            MyOrderFlag           = lo_arrSession[23];
            PrivateAvailFlag      = lo_arrSession[24];
            SessionCreateDate     = lo_arrSession[25].ToDateTime();

            if (string.IsNullOrWhiteSpace(AdminID))
            {
                IsLogin = false;
                return;
            }

            if (SessionCreateDate < DateTime.Now.AddMonths(-1))  // 쿠키생성된지 1달이상 지난경우
            {
                IsLogin = false;
            }
            else
            {
                if (SessionCreateDate < DateTime.Now.AddDays(-1)) // 마지막 쿠키 시간 갱신 후 1일 이상 지났으면 쿠키의 시간을 변경해 준다.
                {
                    CreateAuthCookieInfo(objSesMember);
                }
            }

            IsLogin = true;
        }

        public void goLogout()
        {
            ExpireSessionCookie();

            StringBuilder sb = new StringBuilder();
            sb.Append("\n   <!DOCTYPE html>");
            sb.Append("\n   <script type=\"text/javascript\">");
            sb.Append("\n   location.href='" + CommonConstant.APP_LOGIN_PAGE + "';");
            sb.Append("\n   </script>");

            HttpContext.Current.Response.Write(sb.ToString());
            HttpContext.Current.Response.End();
        }

        public bool IsLogin
        {
            get { return objSesMember.IsLogin; }
            set { objSesMember.IsLogin = value; }
        }
        public string AdminID
        {
            get { return objSesMember.AdminID; }
            set { objSesMember.AdminID = value; }
        }
        public string MobileNo
        {
            get { return objSesMember.MobileNo; }
            set { objSesMember.MobileNo = value; }
        }
        public string AdminName
        {
            get { return objSesMember.AdminName; }
            set { objSesMember.AdminName = value; }
        }
        public int GradeCode
        {
            get { return objSesMember.GradeCode; }
            set { objSesMember.GradeCode = value; }
        }
        public string GradeName
        {
            get { return objSesMember.GradeName; }
            set { objSesMember.GradeName = value; }
        }
        public string LastLoginDate
        {
            get { return objSesMember.LastLoginDate; }
            set { objSesMember.LastLoginDate = value; }
        }
        public string LastLoginIP
        {
            get { return objSesMember.LastLoginIP; }
            set { objSesMember.LastLoginIP = value; }
        }
        public string PwdUpdDate
        {
            get { return objSesMember.PwdUpdDate; }
            set { objSesMember.PwdUpdDate = value; }
        }
        public string AccessCenterCode
        {
            get { return objSesMember.AccessCenterCode; }
            set { objSesMember.AccessCenterCode = value; }
        }
        public string AccessCorpNo
        {
            get { return objSesMember.AccessCorpNo; }
            set { objSesMember.AccessCorpNo = value; }
        }
        public string Network24DDID
        {
            get { return objSesMember.Network24DDID; }
            set { objSesMember.Network24DDID = value; }
        }
        public string NetworkHMMID
        {
            get { return objSesMember.NetworkHMMID; }
            set { objSesMember.NetworkHMMID = value; }
        }
        public string NetworkOneCallID
        {
            get { return objSesMember.NetworkOneCallID; }
            set { objSesMember.NetworkOneCallID = value; }
        }
        public string NetworkHmadangID
        {
            get { return objSesMember.NetworkHmadangID; }
            set { objSesMember.NetworkHmadangID = value; }
        }
        public string DeptName
        {
            get { return objSesMember.DeptName; }
            set { objSesMember.DeptName = value; }
        }
        public string Position
        {
            get { return objSesMember.Position; }
            set { objSesMember.Position = value; }
        }
        public string TelNo
        {
            get { return objSesMember.TelNo; }
            set { objSesMember.TelNo = value; }
        }
        public string Email
        {
            get { return objSesMember.Email; }
            set { objSesMember.Email = value; }
        }
        public string ExpireYmd
        {
            get { return objSesMember.ExpireYmd; }
            set { objSesMember.ExpireYmd = value; }
        }
        public string OrderLocationCodes
        {
            get { return objSesMember.OrderLocationCodes; }
            set { objSesMember.OrderLocationCodes = value; }
        }
        public string OrderItemCodes
        {
            get { return objSesMember.OrderItemCodes; }
            set { objSesMember.OrderItemCodes = value; }
        }
        public string OrderStatusCodes
        {
            get { return objSesMember.OrderStatusCodes; }
            set { objSesMember.OrderStatusCodes = value; }
        }
        public string DeliveryLocationCodes
        {
            get { return objSesMember.DeliveryLocationCodes; }
            set { objSesMember.DeliveryLocationCodes = value; }
        }

        public string MyOrderFlag
        {
            get { return objSesMember.MyOrderFlag; }
            set { objSesMember.MyOrderFlag = value; }
        }
        public string PrivateAvailFlag
        {
            get { return objSesMember.PrivateAvailFlag; }
            set { objSesMember.PrivateAvailFlag = value; }
        }

        public DateTime SessionCreateDate
        {
            get { return objSesMember.SessionCreateDate; }
            set { objSesMember.SessionCreateDate = value; }
        }
    }

    public class AppSession_Member
    {
        public bool     IsLogin               { get; set; }
        public string   AdminID               { get; set; } = string.Empty;
        public string   MobileNo              { get; set; } = string.Empty;
        public string   AdminName             { get; set; } = string.Empty;
        public int      GradeCode             { get; set; }
        public string   GradeName             { get; set; } = string.Empty;
        public string   LastLoginDate         { get; set; } = string.Empty;
        public string   LastLoginIP           { get; set; } = string.Empty;
        public string   PwdUpdDate            { get; set; } = string.Empty;
        public string   AccessCenterCode      { get; set; } = string.Empty;
        public string   AccessCorpNo          { get; set; } = string.Empty;
        public string   Network24DDID         { get; set; } = string.Empty;
        public string   NetworkHMMID          { get; set; } = string.Empty;
        public string   NetworkOneCallID      { get; set; } = string.Empty;
        public string   NetworkHmadangID      { get; set; } = string.Empty;
        public string   DeptName              { get; set; } = string.Empty;
        public string   Position              { get; set; } = string.Empty;
        public string   TelNo                 { get; set; } = string.Empty;
        public string   Email                 { get; set; } = string.Empty;
        public string   ExpireYmd             { get; set; } = string.Empty;
        public string   OrderLocationCodes    { get; set; } = string.Empty;
        public string   OrderItemCodes        { get; set; } = string.Empty;
        public string   OrderStatusCodes      { get; set; } = string.Empty;
        public string   DeliveryLocationCodes { get; set; } = string.Empty;
        public string   MyOrderFlag           { get; set; } = string.Empty;
        public string   PrivateAvailFlag      { get; set; } = string.Empty;
        public DateTime SessionCreateDate     { get; set; }
    }
}