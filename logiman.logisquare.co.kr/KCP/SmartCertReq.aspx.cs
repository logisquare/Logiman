using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace KCP.SmartCert
{
    public partial class SmartCertReq : PageInit
    {
        private string req_tx            = string.Empty;
        private string site_cd           = string.Empty;
        private string ordr_idxx         = string.Empty;
        private string year              = string.Empty;
        private string month             = string.Empty;
        private string day               = string.Empty;
        private string user_name         = string.Empty;
        private string sex_code          = string.Empty;
        private string local_code        = string.Empty;
        private string web_siteid        = string.Empty;
        private string web_siteid_hashYN = string.Empty;
        private string cert_able_yn      = string.Empty;
        private string up_hash           = string.Empty;
        private string tmp_form          = string.Empty;
        private string mobile_device     = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            HtmlInputHidden lo_objHidden = null;

            mobile_device = Utils.IsMobileBrowser(HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"]);

            form_auth.Action = SiteGlobal.M_KCP_AUTH_GW_URL;

            foreach (string item in Request.Form)
            {
                if (item == null)
                {
                    continue;
                }

                string itemname = item.Split('$')[item.Split('$').Length - 1];

                if (itemname.Equals("site_cd"))
                {
                    site_cd = Request.Form[item];
                }

                if (itemname.Equals("req_tx"))
                {
                    req_tx = Request.Form[item];
                }

                if (itemname.Equals("ordr_idxx"))
                {
                    ordr_idxx = Request.Form[item];
                }

                if (itemname.Equals("user_name"))
                {
                    user_name = Request.Form[item];
                }

                if (itemname.Equals("year"))
                {
                    year = Request.Form[item];
                }

                if (itemname.Equals("month"))
                {
                    month = Request.Form[item];
                }

                if (itemname.Equals("day"))
                {
                    day = Request.Form[item];
                }

                if (itemname.Equals("sex_code"))
                {
                    sex_code = Request.Form[item];
                }

                if (itemname.Equals("local_code"))
                {
                    local_code = Request.Form[item];
                }

                if (itemname.Equals("cert_able_yn"))
                {
                    cert_able_yn = Request.Form[item];
                }

                if (itemname.Equals("web_siteid"))
                {
                    web_siteid = Request.Form[item];
                }

                if (itemname.Equals("web_siteid_hashYN"))
                {
                    web_siteid_hashYN = Request.Form[item];
                }


                if (!string.IsNullOrWhiteSpace(itemname))
                {
                    lo_objHidden       = new HtmlInputHidden();
                    lo_objHidden.ID    = itemname;
                    lo_objHidden.Value = Request.Form[item];

                    if (!form_auth.Controls.Contains(lo_objHidden))
                    {
                        form_auth.Controls.Add(lo_objHidden);
                    }
                }
            } // foreach ( string item in Request.Form) - END

            // birth_day 처리 예제
            // !!중요 해당 함수는 year, month, day 변수가 null 일 경우 00 으로 치환합니다
            if (year.Length.Equals(0))
            {
                year = "00";
            }
            else if (year.Length.Equals(1))
            {
                year = "0" + year;
            }

            if (month.Length.Equals(0))
            {
                month = "00";
            }
            else if (month.Length.Equals(1))
            {
                month = "0" + month;
            }

            if (day.Length.Equals(0))
            {
                day = "00";
            }
            else if (day.Length.Equals(1))
            {
                day = "0" + day;
            }

            if (req_tx.Equals("cert"))
            {
                ct_cli_comLib.CTKCP ct_cert = new ct_cli_comLib.CTKCP();

                if (!web_siteid_hashYN.Equals("Y"))
                {
                    web_siteid = "";
                }

                if (cert_able_yn.Equals("Y"))
                {
                    up_hash = ct_cert.lf_CT_CLI__make_hash_data(SiteGlobal.M_KCP_AUTH_ENC_KEY, site_cd + ordr_idxx + web_siteid + "" + "00" + "00" + "00" + "" + "");
                }
                else
                {
                    up_hash = ct_cert.lf_CT_CLI__make_hash_data(SiteGlobal.M_KCP_AUTH_ENC_KEY, site_cd + ordr_idxx + web_siteid + user_name + year + month + day + sex_code + local_code);
                }

                // 인증창으로 넘기는 form 데이터 생성 필드 (up_hash)
                foreach (Control item in form_auth.Controls)
                {
                    if (item.ID == "up_hash")
                    {
                        form_auth.Controls.Remove(item);
                        break; //important step
                    }
                }

                lo_objHidden       = new HtmlInputHidden();
                lo_objHidden.ID    = "up_hash";
                lo_objHidden.Value = up_hash;
                form_auth.Controls.Add(lo_objHidden);

                // KCP 본인확인 라이브러리 버전 정보
                lo_objHidden       = new HtmlInputHidden();
                lo_objHidden.ID    = "kcp_cert_lib_ver";
                lo_objHidden.Value = ct_cert.lf_CT_CLI__get_kcp_lib_ver();
                form_auth.Controls.Add(lo_objHidden);
            }

            lo_objHidden       = new HtmlInputHidden();
            lo_objHidden.ID    = "mobile_device";
            lo_objHidden.Value = mobile_device;
            form_auth.Controls.Add(lo_objHidden);
        }
    }
}
