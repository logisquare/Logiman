using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using System;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;

namespace logiman.logisquare.co.kr
{
    public class Global : HttpApplication
    {
        void Application_BeginRequest(object sender, EventArgs e)
        {

            var application = sender as HttpApplication;
            if (application != null && application.Context != null)
            {
                application.Context.Response.Headers.Remove("Server");
            }

            HttpContext.Current.Response.AddHeader("x-frame-options", "SAMEORIGIN");
        }

        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        void Application_Error(Object sender, EventArgs e)
        {
            // At this point we have information about the error       

            string lo_strErrInfo;
            string lo_strMailBody;
            string lo_strSMTPServer;
            string lo_strMailFrom;
            string lo_strMailSuject;

            HttpContext lo_ctx    = HttpContext.Current;
            Exception   lo_objErr = lo_ctx.Server.GetLastError();

            if (lo_objErr != null)
            {
                //------------------------------------------------------------            
                lo_strSMTPServer = SiteGlobal.MAIL_SERVER;
                lo_strMailFrom   = "Logiman_Admin<logiman.send@logisquare.co.kr>";
                //------------------------------------------------------------

                lo_strMailSuject = "[Exception error]" + lo_ctx.Request.ServerVariables.Get("HTTP_HOST") + "-" +
                                   lo_ctx.Request.FilePath;

                lo_strErrInfo =  "<B>Server </B> <BR/> ";
                lo_strErrInfo += "ServerName: " + lo_ctx.Request.ServerVariables.Get("HTTP_HOST");
                lo_strErrInfo += "<br>ServerIP: " + lo_ctx.Request.ServerVariables.Get("LOCAL_ADDR");
                lo_strErrInfo += "<br>RemoteIP: " + lo_ctx.Request.ServerVariables.Get("REMOTE_ADDR");
                lo_strErrInfo += "<br>Http Referer: " + lo_ctx.Request.ServerVariables.Get("HTTP_REFERER");

                lo_strErrInfo += "<BR><BR> ";
                lo_strErrInfo += "<B>Error Message</B><BR>";
                lo_strErrInfo += lo_objErr.Message;

                lo_strErrInfo += "<BR><BR> ";
                lo_strErrInfo += "<B>Browser</B><BR>";
                lo_strErrInfo += lo_ctx.Request.UserAgent;

                lo_strErrInfo += "<BR><BR> ";
                lo_strErrInfo += "<B>Offending URL</B><BR>";
                lo_strErrInfo += lo_ctx.Request.Url.ToString();

                lo_strErrInfo += "<BR><BR> ";
                lo_strErrInfo += "<B>Stack trace</B><BR>";
                lo_strErrInfo += lo_objErr.StackTrace;

                //ctx.Response.Write(strErrInfo);

                // --------------------------------------------------
                // To let the page finish running we clear the error
                // --------------------------------------------------
                //ctx.Server.ClearError();

                lo_strMailBody =
                    "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'> ";
                lo_strMailBody += "<HTML> ";
                lo_strMailBody += "	<HEAD> ";
                lo_strMailBody += "		<META HTTP-EQUIV='Content-Type' Content='text/html; charset=ks_c_5601-1987'> ";
                lo_strMailBody += "		<STYLE type='text/css'> ";
                lo_strMailBody += "		  BODY { font: 9pt/12pt Tahoma } ";
                lo_strMailBody += "		  H1 { font: 13pt/15pt Tahoma } ";
                lo_strMailBody += "		  H2 { font: 9pt/12pt Tahoma } ";
                lo_strMailBody += "		  A:link { color: red } ";
                lo_strMailBody += "		  A:visited { color: maroon } ";
                lo_strMailBody += "		</STYLE> ";
                lo_strMailBody += "	</HEAD> ";
                lo_strMailBody += "	<BODY> ";
                lo_strMailBody += "		<TABLE width=500 border=0 cellspacing=10> ";
                lo_strMailBody += "			<TR> ";
                lo_strMailBody += "				<TD> ";
                lo_strMailBody += lo_strErrInfo;
                lo_strMailBody += "					</TD>  ";
                lo_strMailBody += "				</TR> ";
                lo_strMailBody += "			</TABLE> ";
                lo_strMailBody += "		</BODY> ";
                lo_strMailBody += "	</HTML> ";

                foreach (var strMailTo in CommonConstant.ADMIN_TO_EMAIL)
                {
                    SiteGlobal.SendMail(lo_strMailFrom, strMailTo, lo_strMailSuject, lo_strMailBody, true, "");
                }
            }
        }
    }
}