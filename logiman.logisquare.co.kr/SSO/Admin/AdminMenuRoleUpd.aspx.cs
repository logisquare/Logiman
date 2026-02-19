using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace SSO.Admin
{
    public partial class AdminMenuRoleUpd : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadWrite;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
                DisplayData();
            }
        }

        protected void GetInitData()
        {
            hidMenuRoleNo.Value = SiteGlobal.GetRequestForm("MenuRoleNo");

            CommonDDLB.USE_FLAG_DDLB(DDLUseFlag);

            try
            {
                if (!string.IsNullOrWhiteSpace(hidMenuRoleNo.Value))
                {
                    hidMode.Value = "update";
                    GetMenuRoleInfo();
                }
                else
                {
                    hidMode.Value = "insert";
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "AdminMenuRoleUpd",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9170);
            }
        }

      

        protected void GetMenuRoleInfo()
        {
            ReqAdminMenuRoleList                lo_objReqAdminMenuRoleList = null;
            ServiceResult<ResAdminMenuRoleList> lo_objResAdminMenuRoleList = null;
            AdminMenuDasServices                lo_objAdminMenuDasServices = null;

            try
            {
                lo_objAdminMenuDasServices = new AdminMenuDasServices();

                lo_objReqAdminMenuRoleList = new ReqAdminMenuRoleList
                {
                    MenuRoleNo = hidMenuRoleNo.Value.ToInt()
                };

                lo_objResAdminMenuRoleList = lo_objAdminMenuDasServices.GetAdminMenuRoleList(lo_objReqAdminMenuRoleList);


                if (lo_objResAdminMenuRoleList.result.ErrorCode.IsFail())
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "메뉴 역할 정보를 읽지 못했습니다.";
                    return;
                }

                MenuRoleName.Text        = lo_objResAdminMenuRoleList.data.list[0].MenuRoleName;
                DDLUseFlag.SelectedValue = lo_objResAdminMenuRoleList.data.list[0].UseFlag;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("AdminMenuRoleUpd", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }
        }

        protected void DisplayData()
        {
            ReqAdminMenuRoleDtlList                lo_objReqAdminMenuRoleDtlList = null;
            ServiceResult<ResAdminMenuRoleDtlList> lo_objResAdminMenuRoleDtlList = null;
            AdminMenuDasServices                   lo_objAdminMenuDasServices    = null;
            DataTable lo_objDt = null;
            try
            {
                lo_objAdminMenuDasServices    = new AdminMenuDasServices();

                lo_objReqAdminMenuRoleDtlList = new ReqAdminMenuRoleDtlList
                {
                    MenuRoleNo = hidMenuRoleNo.Value
                };

                lo_objResAdminMenuRoleDtlList = lo_objAdminMenuDasServices.GetAdminMenuRoleDtlList(lo_objReqAdminMenuRoleDtlList);
                if (lo_objResAdminMenuRoleDtlList.result.ErrorCode.IsFail())
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "메뉴 역할 정보를 조회하지 못했습니다.";
                    return;
                }

                lo_objDt = lo_objResAdminMenuRoleDtlList.data.list.GetConvertListToDataTable();

                repList.DataSource = lo_objDt;
                repList.DataBind();
               
                RebuildGridView(lo_objDt);

            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("AdminMenuRoleUpd", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }


        }

        protected void RebuildGridView(DataTable dt)
        {
            GridViewRow lo_row = null;
            Literal lo_printChecked = null;

            try
            {
                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    lo_row = repList.Rows[r];

                    //row.Height = 20;
                    if (dt.Rows[r]["Depth"].ToString() == "1")
                    {
                        if (hidMode.Value == "insert")
                        {
                            lo_row.Cells[2].Text = "-";
                        }
                    }
                    else
                    {
                        if (hidMode.Value == "insert")
                        {
                            lo_row.Cells[2].Text = "-";
                        }
                        else if (hidMode.Value == "update")
                        {
                            if (dt.Rows[r]["AuthCode"].ToString() == "1") //모두
                            {
                                lo_printChecked = (Literal)lo_row.FindControl("allChk");
                                lo_printChecked.Text = "checked=\"checked\"";
                                lo_row.Cells[1].Text = "-";
                            }
                            else if (dt.Rows[r]["AuthCode"].ToString() == "2")//읽기/쓰기
                            {
                                lo_printChecked = (Literal)lo_row.FindControl("rwChk");
                                lo_printChecked.Text = "checked=\"checked\"";
                                lo_row.Cells[1].Text = "-";
                            }
                            else if (dt.Rows[r]["AuthCode"].ToString() == "3")//읽기
                            {
                                lo_printChecked = (Literal)lo_row.FindControl("roChk");
                                lo_printChecked.Text = "checked=\"checked\"";
                                lo_row.Cells[1].Text = "-";
                            }
                            else
                            {
                                lo_row.Cells[2].Text = "-";
                            }
                        }
                    }
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "AdminMenuRoleUpd",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9174);
            }
        }

        public static void GrvwRowDataBound(GridViewRowEventArgs e)
        {
        }

        protected void OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                GrvwRowDataBound(e);

                if (e.Row.RowType == DataControlRowType.Header)
                {
                    e.Row.Height = 30;
                    e.Row.Style.Add("background-color", "#e5e4e3");

                    e.Row.Cells[0].Text = "메뉴 명";
                    e.Row.Cells[1].Text = "추가";
                    e.Row.Cells[2].Text = "삭제";
                    e.Row.Cells[3].Text = "전체";
                    e.Row.Cells[4].Text = "읽기";
                    e.Row.Cells[5].Text = "읽기/쓰기";

                    e.Row.Cells[0].Font.Bold = true;
                    e.Row.Cells[1].Font.Bold = true;
                    e.Row.Cells[2].Font.Bold = true;
                    e.Row.Cells[3].Font.Bold = true;
                    e.Row.Cells[4].Font.Bold = true;
                    e.Row.Cells[5].Font.Bold = true;
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "AdminMenuRoleUpd",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9175);
            }
        }

       
    }
}