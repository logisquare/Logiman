using System;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using CommonLibrary.CommonModule;

namespace logiman.logisquare.co.kr
{
    public partial class MyIP : Page
    {
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
                
                string    lo_strRemoteAddr    = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
                IPAddress lo_objRemoteAddrOut = null;

                if (lo_strRemoteAddr != null)
                {
                    if (lo_strRemoteAddr.Contains(","))

                    {
                        lo_strRemoteAddr = lo_strRemoteAddr.Split(',').First().Trim();
                    }

                    if (IPAddress.TryParse(lo_strRemoteAddr, out lo_objRemoteAddrOut)) // 정상적인 IP 주소체계이면
                    {
                        LitIP1.Text = lo_strRemoteAddr;
                    }
                }

                lo_strRemoteAddr    = string.Empty;
                lo_objRemoteAddrOut = null;

                // REMOTE_ADDR 에서 정상적인 IP 주소체계를 찾지못했다면, HTTP_X_FORWARDED_FOR 에서 찾는다.
                lo_strRemoteAddr = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

                if (lo_strRemoteAddr != null)
                {
                    if (lo_strRemoteAddr.Contains(","))
                    {
                        lo_strRemoteAddr = lo_strRemoteAddr.Split(',').First().Trim();
                    }

                    if (IPAddress.TryParse(lo_strRemoteAddr, out lo_objRemoteAddrOut)) // 정상적인 IP 주소체계이면
                    {
                        LitIP2.Text = lo_strRemoteAddr;
                    }
                }


                LitCheckIP.Text = SiteGlobal.GetRemoteAddr();
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("MyIP", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9310);
            }
        }
    }
}