using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using PBSDasNetCom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;

namespace logiman.logisquare.co.kr
{
    public partial class Index : PageBase
    {
        protected string strLeftMenu_B_List  = string.Empty;
        protected string strDocumentTitle    = string.Empty;
        protected string strLogoImage        = string.Empty;
        protected string strSiteMap          = string.Empty;
        protected int    intGradeCode        = 0;
        AdminDasServices objAdminDasServices = new AdminDasServices();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
            else
            {
                GetPostBackData();
            }

            DisplayThemeMode();
        }

        protected void GetInitData()
        {
            try
            {
                // iframe 안에 로그인 창이 구동된 경우, top window로 redirect 한다.
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                                                    "if(window != window.top) {window.top.location = '/';}", true);

                GetLeftMenuGroup();
                //GetNoticeNewDb();
                intGradeCode       = objSes.GradeCode;
                HidGradeCode.Value = objSes.GradeCode.ToString();

                HidMNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("MNo"), "");
                HidMPra.Value = Utils.IsNull(SiteGlobal.GetRequestForm("MPra"), "");

                DivCMSetting.Visible = objSes.GradeCode <= 5;
                DivCMNotice.Visible  = objSes.GradeCode <= 5;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Index", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9310);
            }
        }

        protected void GetPostBackData()
        {
            if (SiteGlobal.GetRequestForm("__EVENTTARGET").Equals("logout"))
            {
                objSes.goLogout();
                objSes.GoLogin("");
            }
        }

        protected void GetLeftMenuGroup()
        {
            ServiceResult<ResAdminLeftMenuAllList> lo_objResAdminLeftMenuAllList = null;
            StringBuilder                          lo_sb_b                       = null;
            StringBuilder                          lo_sb_SiteMap                 = null;
            int                                    nIndexNo                      = 0;
            string                                 lo_text                       = string.Empty;
            string                                 lo_strMenuGroupName           = string.Empty;
            string                                 lo_strMenuName                = string.Empty;

            Dictionary<int, string> menuGroupKind = new Dictionary<int, string>()
            {
                { 1, "오더관리" },
                { 2, "배차관리" },
                { 3, "매출관리" },
                { 4, "매입관리" },
                { 8, "요율표관리" },
                { 5, "정보관리" },
                { 7, "데이터경영" },
                { 6, "시스템관리" },
            };

            Dictionary<int, string> menuGroupList = new Dictionary<int, string>();
            bool                    bFound        = false;

            try
            {
                lo_objResAdminLeftMenuAllList = objAdminDasServices.GetAdminLeftMenuAllList(objSes.AdminID);
                lo_sb_b                       = new StringBuilder();
                lo_sb_SiteMap                 = new StringBuilder();

                if (lo_objResAdminLeftMenuAllList.result.ErrorCode.IsFail())
                {
                    return;
                }

                for (int i = 0; i < menuGroupKind.Count; i++)
                {
                    for (int j = 0; j < lo_objResAdminLeftMenuAllList.data.list.Count; j++)
                    {
                        if (menuGroupKind.Keys.ElementAt(i).Equals(lo_objResAdminLeftMenuAllList.data.list[j].MenuGroupKind))
                        {
                            lo_text += menuGroupKind.Values.ElementAt(i) + ",";
                        }
                    }
                }

                for (int i = 0; i < menuGroupKind.Count; i++)
                {
                    for (int y = 0; y < lo_text.TrimEnd(',').Split(',').Distinct().ToArray().Length; y++) {

                        if (menuGroupKind.Values.ElementAt(i).Equals(lo_text.TrimEnd(',').Split(',').Distinct().ToArray()[y])) {
                            menuGroupList.Clear();
                            for (int j = 0; j < lo_objResAdminLeftMenuAllList.data.list.Count; j++)
                            {
                                if (!lo_objResAdminLeftMenuAllList.data.list[j].MenuGroupKind.Equals(menuGroupKind.Keys.ElementAt(i)))
                                {
                                    continue;
                                }
                                else
                                {
                                    lo_text += menuGroupKind.Values.ElementAt(i) + ",";
                                }

                                bFound = false;
                                for (int k = 0; k < menuGroupList.Count; k++)
                                {
                                    if (lo_objResAdminLeftMenuAllList.data.list[j].MenuGroupNo.Equals(menuGroupList.Keys.ElementAt(k)) &&
                                       lo_objResAdminLeftMenuAllList.data.list[j].MenuGroupName.Equals(menuGroupList.Values.ElementAt(k)))
                                    {
                                        bFound = true;
                                        break;
                                    }
                                }

                                if (bFound.Equals(false))
                                {
                                    menuGroupList.Add(lo_objResAdminLeftMenuAllList.data.list[j].MenuGroupNo, lo_objResAdminLeftMenuAllList.data.list[j].MenuGroupName);
                                }
                            }

                            /*메뉴*/
                            lo_sb_b.AppendLine("<li class=\"m\"><span>" + menuGroupKind.Values.ElementAt(i) + "</span>");
                            lo_sb_b.AppendLine("<ul class=\"sub_depth1\">");
                            /*사이트맵*/
                            lo_sb_SiteMap.AppendLine("<dl>");
                            lo_sb_SiteMap.AppendLine("<dt>" + menuGroupKind.Values.ElementAt(i) + "</dt>");


                            for (int j = 0; j < menuGroupList.Count; j++)
                            {

                                lo_strMenuGroupName = HttpUtility.JavaScriptStringEncode(menuGroupList.Values.ElementAt(j));
                                lo_strMenuGroupName = lo_strMenuGroupName.Replace("\\u0026", "&amp;");

                                /*사이트맵*/
                                lo_sb_SiteMap.AppendLine("<dd><h3>" + lo_strMenuGroupName + "</h3>");

                                /*메뉴*/
                                lo_sb_b.AppendLine("<li>");
                                lo_sb_b.AppendLine("<dl>");
                                lo_sb_b.AppendLine("<dt>" + lo_strMenuGroupName + "</dt>");
                                lo_sb_b.AppendLine("<dd>");
                                lo_sb_b.AppendLine("<ul class=\"menu" + menuGroupList.Keys.ElementAt(j) + "\">");
                                /*사이트맵*/
                                lo_sb_SiteMap.AppendLine("<ul>");

                                nIndexNo = 0;
                                for (int k = 0; k < lo_objResAdminLeftMenuAllList.data.list.Count; k++)
                                {
                                    if (lo_objResAdminLeftMenuAllList.data.list[k].MenuGroupNo.Equals(menuGroupList.Keys.ElementAt(j)) &&
                                       lo_objResAdminLeftMenuAllList.data.list[k].MenuGroupName.Equals(menuGroupList.Values.ElementAt(j)))
                                    {

                                        lo_strMenuName = HttpUtility.JavaScriptStringEncode(lo_objResAdminLeftMenuAllList.data.list[k].MenuName);
                                        lo_strMenuName = lo_strMenuName.Replace("\\u0026", "&amp;");

                                        lo_sb_b.AppendLine("<li><a href=\"javascript:fnGoPage('" + menuGroupKind.Values.ElementAt(i) + "','" + lo_strMenuGroupName + "', '" + lo_strMenuName + "','" + lo_objResAdminLeftMenuAllList.data.list[k].MenuLink + "','" + lo_objResAdminLeftMenuAllList.data.list[k].MenuGroupNo + "', " + nIndexNo + ");\">" + lo_strMenuName + "</a></li>");
                                        /*사이트맵*/
                                        lo_sb_SiteMap.AppendLine("<li><a href=\"javascript:fnGoPage('" + menuGroupKind.Values.ElementAt(i) + "','" + lo_strMenuGroupName + "', '" + lo_strMenuName + "','" + lo_objResAdminLeftMenuAllList.data.list[k].MenuLink + "','" + lo_objResAdminLeftMenuAllList.data.list[k].MenuGroupNo + "', " + nIndexNo + ");\">" + lo_strMenuName + "</a></li>");
                                        nIndexNo++;
                                    }
                                }

                                lo_sb_SiteMap.AppendLine("</ul>");
                                lo_sb_SiteMap.AppendLine("</dd>");
                                lo_sb_b.AppendLine("</ul>");
                                lo_sb_b.AppendLine("</dd>");
                                lo_sb_b.AppendLine("</dl>");
                                lo_sb_b.AppendLine("</li>");
                            }

                            lo_sb_b.AppendLine("</ul>");
                            lo_sb_b.AppendLine("</li>");
                            lo_sb_SiteMap.AppendLine("</dl>");
                        }
                    }
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Index", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9312);
            }

            strLeftMenu_B_List += lo_sb_b.ToString();
            strSiteMap         += lo_sb_SiteMap.ToString();
        }


        protected void GetLeftMenuGroup_old()
        {
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objDas = new IDasNetCom();
                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);

                strLeftMenu_B_List = string.Empty;

                GetLeftMenuGroupSub(ref lo_objDas, 1, "오더관리");
                GetLeftMenuGroupSub(ref lo_objDas, 2, "배차관리");
                GetLeftMenuGroupSub(ref lo_objDas, 3, "매출관리");
                GetLeftMenuGroupSub(ref lo_objDas, 4, "매입관리");
                GetLeftMenuGroupSub(ref lo_objDas, 5, "정보관리");
                GetLeftMenuGroupSub(ref lo_objDas, 6, "시스템관리");
                GetLeftMenuGroupSub(ref lo_objDas, 7, "데이터경영");
                GetLeftMenuGroupSub(ref lo_objDas, 7, "요율표관리");
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Index", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9312);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }
            }
        }

        protected void GetLeftMenuGroupSub(ref IDasNetCom objDas, int lo_intMenuGroupKind, string lo_strGroupTitle)
        {
            ReqAdminLeftMenuList                     lo_objReqAdminLeftMenuGroupList = null;
            ReqAdminLeftMenuList                     lo_objReqAdminLeftMenuList      = null;
            ServiceResult<ResAdminLeftMenuGroupList> lo_objResAdminLeftMenuGroupList = null;
            ServiceResult<ResAdminLeftMenuList>      lo_objResAdminLeftMenuList      = null;
            StringBuilder                            lo_sb_b                         = null;
            StringBuilder                            lo_sb_SiteMap                   = null;
            string                                   lo_strHeaderTitle               = string.Empty;
            string                                   lo_strMenuGroupName             = string.Empty;
            string                                   lo_strMenuName                  = string.Empty;

            try
            {
                lo_objReqAdminLeftMenuGroupList = new ReqAdminLeftMenuList
                {
                    AdminID       = objSes.AdminID,
                    MenuGroupKind = lo_intMenuGroupKind
                };

                lo_objResAdminLeftMenuGroupList = objAdminDasServices.GetAdminLeftMenuGroupList(ref objDas, lo_objReqAdminLeftMenuGroupList);
                lo_sb_b = new StringBuilder();
                lo_sb_SiteMap = new StringBuilder();

                if (lo_objResAdminLeftMenuGroupList.result.ErrorCode.IsFail()) {
                    return;
                }
                if (lo_objResAdminLeftMenuGroupList.data.RecordCnt > 0 && !string.IsNullOrWhiteSpace(lo_strGroupTitle))
                {   /*메뉴*/
                    lo_sb_b.AppendLine("<li class=\"m\"><span>" + lo_strGroupTitle + "</span>");
                    lo_sb_b.AppendLine("<ul class=\"sub_depth1\">");
                    /*사이트맵*/
                    lo_sb_SiteMap.AppendLine("<dl>");
                    lo_sb_SiteMap.AppendLine("<dt>"+ lo_strGroupTitle + "</dt>");
                    for (int iFor = 0; iFor < lo_objResAdminLeftMenuGroupList.data.RecordCnt; iFor++)
                    {
                        lo_objReqAdminLeftMenuList = new ReqAdminLeftMenuList
                        {
                            AdminID = objSes.AdminID,
                            MenuGroupNo = lo_objResAdminLeftMenuGroupList.data.list[iFor].MenuGroupNo
                        };
                        lo_objResAdminLeftMenuList = objAdminDasServices.GetAdminLeftMenuList(lo_objReqAdminLeftMenuList);

                        if (lo_intMenuGroupKind.Equals(lo_objResAdminLeftMenuGroupList.data.list[iFor].MenuGroupKind))
                        {
                            lo_strMenuGroupName = HttpUtility.JavaScriptStringEncode(lo_objResAdminLeftMenuGroupList.data.list[iFor].MenuGroupName);
                            lo_strMenuGroupName = lo_strMenuGroupName.Replace("\\u0026", "&amp;");

                            /*사이트맵*/
                            lo_sb_SiteMap.AppendLine("<dd><h3>" + lo_strMenuGroupName + "</h3>");

                            /*메뉴*/
                            lo_sb_b.AppendLine("<li>");
                            lo_sb_b.AppendLine("<dl>");
                            lo_sb_b.AppendLine("<dt>" + lo_strMenuGroupName + "</dt>");
                            lo_sb_b.AppendLine("<dd>");
                            lo_sb_b.AppendLine("<ul class=\"menu" + lo_strMenuGroupName + "\">");
                            /*사이트맵*/
                            lo_sb_SiteMap.AppendLine("<ul>");
                            if (!lo_objResAdminLeftMenuList.data.RecordCnt.Equals(null)) {
                                for (int sFor = 0; sFor < lo_objResAdminLeftMenuList.data.RecordCnt; sFor++)
                                {
                                    if (lo_objResAdminLeftMenuList.data.list[sFor].MenuLink.IndexOf("http://", StringComparison.Ordinal) < 0 && lo_objResAdminLeftMenuList.data.list[sFor].MenuLink.IndexOf("https://", StringComparison.Ordinal) < 0)
                                    {
                                        lo_strMenuName = HttpUtility.JavaScriptStringEncode(lo_objResAdminLeftMenuList.data.list[sFor].MenuName);
                                        lo_strMenuName = lo_strMenuName.Replace("\\u0026", "&amp;");

                                        lo_strHeaderTitle = lo_strGroupTitle + " <span class=\"arrow\"></span> " + lo_strMenuGroupName + " <span class=\"arrow\"></span> " + lo_strMenuName;
                                        lo_sb_b.AppendLine("<li><a href=\"javascript:fnGoPage('" + lo_strGroupTitle + "','" + lo_strMenuGroupName + "', '" + lo_strMenuName + "','" + lo_objResAdminLeftMenuList.data.list[sFor].MenuLink + "','" + lo_objResAdminLeftMenuGroupList.data.list[iFor].MenuGroupNo + "', " + sFor + ");\">" + lo_strMenuName + "</a></li>");
                                        /*사이트맵*/
                                        lo_sb_SiteMap.AppendLine("<li><a href=\"javascript:fnGoPage('" + lo_strGroupTitle + "','" + lo_strMenuGroupName + "', '" + lo_strMenuName + "','" + lo_objResAdminLeftMenuList.data.list[sFor].MenuLink + "','" + lo_objResAdminLeftMenuGroupList.data.list[iFor].MenuGroupNo + "', " + sFor + ");\">" + lo_strMenuName + "</a></li>");
                                    }
                                }
                            }
                            lo_sb_SiteMap.AppendLine("</ul>");
                            lo_sb_SiteMap.AppendLine("</dd>");
                            lo_sb_b.AppendLine("</ul>");
                            lo_sb_b.AppendLine("</dd>");
                            lo_sb_b.AppendLine("</dl>");
                            lo_sb_b.AppendLine("</li>");
                        }
                    }
                    lo_sb_b.AppendLine("</ul>");
                    lo_sb_b.AppendLine("</li>");
                    lo_sb_SiteMap.AppendLine("</dl>");
                }


            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Index", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9312);
            }

            strLeftMenu_B_List += lo_sb_b.ToString();
            strSiteMap         += lo_sb_SiteMap.ToString();
        }

        protected void DisplayThemeMode() {
            if (Request.Cookies["ThemeStyle"] != null)
            {
                BtnTheme.Attributes["aria-pressed"] = "true";
                if (Request.Cookies["ThemeStyle"].Value.Equals("dark"))
                {
                    ThemeStyle.Attributes["href"] = "/css/theme-dark.css?ver=" + DateTime.Now.ToString("yyyyMMddHHmmss"); //다크모드
                }
                else
                {
                    ThemeStyle.Attributes["href"] = "/css/theme-default.css?ver=" + DateTime.Now.ToString("yyyyMMddHHmmss"); //일반모드
                }
            }
            else
            {
                BtnTheme.Attributes["aria-pressed"] = "false";
                ThemeStyle.Attributes["href"] = "/css/theme-default.css?ver=" + DateTime.Now.ToString("yyyyMMddHHmmss"); //일반모드
            }
        }

        protected void BtnThemeCookieOnClick(object sender, EventArgs e)
        {
            try
            {
                if (BtnTheme.Attributes["aria-pressed"].Equals("false"))
                {
                    Response.Cookies["ThemeStyle"].Value = "dark";
                    Response.Cookies["ThemeStyle"].Expires = DateTime.Now.AddDays(7);
                }
                else {
                    Response.Cookies["ThemeStyle"].Expires = DateTime.Now.AddDays(-1);
                }
                
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Index", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9320);
            }
            Response.AddHeader("Refresh", "0");
        }
    }
}