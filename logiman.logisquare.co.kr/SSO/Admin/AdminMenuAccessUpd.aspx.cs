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
    public partial class AdminMenuAccessUpd : PageBase
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
            }

            DisplayData();
        }

        protected void GetInitData()
        {
            AdminID.Text     = SiteGlobal.GetRequestForm("AdminID");
            hidAdminID.Value = AdminID.Text;
            hidMode.Value    = !string.IsNullOrWhiteSpace(hidAdminID.Value) ? "update" : "insert";
            hidGradeCode.Value = objSes.GradeCode.ToString();
        }

        protected void DisplayData()
        {
            AdminDasServices                          lo_objAdminDasServices           = null;
            ServiceResult<ResAdminMenuAccessList>     lo_objResAdminMenuAccessList     = null;
            ServiceResult<ResAdminMenuRoleAccessList> lo_objResAdminMenuRoleAccessList = null;
            GridViewRow                               lo_objGridRow                    = null;
            DataTable                                 lo_objDt                         = null;
            Literal                                   lo_objPrintChecked               = null;

            //개별메뉴
            try
            {
                lo_objAdminDasServices = new AdminDasServices();

                lo_objResAdminMenuAccessList = lo_objAdminDasServices.GetAdminMenuAccessList(hidAdminID.Value);

                if (lo_objResAdminMenuAccessList.result.ErrorCode.IsFail() ||
                    lo_objResAdminMenuAccessList.data.RecordCnt.Equals(0))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value      = "메뉴 정보를 조회하지 못했습니다.";
                    return;
                }

                lo_objDt                 = lo_objResAdminMenuAccessList.data.list.GetConvertListToDataTable();
                repAccessList.DataSource = lo_objDt;
                repAccessList.DataBind();

                for (int r = 0; r < lo_objDt.Rows.Count; r++)
                {
                    lo_objGridRow = repAccessList.Rows[r];
                    //row.Height = 20;
                    if (lo_objDt.Rows[r]["Depth"].ToString() == "1")
                    {
                        if (hidMode.Value == "insert")
                        {
                            lo_objGridRow.Cells[2].Text = "-";
                        }
                    }
                    else
                    {
                        if (hidMode.Value == "insert")
                        {
                            lo_objGridRow.Cells[2].Text = "-";
                        }
                        else if (hidMode.Value == "update")
                        {
                            if (lo_objDt.Rows[r]["AuthCode"].ToString().Equals("1")) //모두
                            {
                                lo_objPrintChecked          = (Literal)lo_objGridRow.FindControl("allChk");
                                lo_objPrintChecked.Text     = "checked=\"checked\"";
                                lo_objGridRow.Cells[1].Text = "-";
                            }
                            else if (lo_objDt.Rows[r]["AuthCode"].ToString().Equals("2")) //읽기쓰기
                            {
                                lo_objPrintChecked          = (Literal)lo_objGridRow.FindControl("rwChk");
                                lo_objPrintChecked.Text     = "checked=\"checked\"";
                                lo_objGridRow.Cells[1].Text = "-";
                            }
                            else if (lo_objDt.Rows[r]["AuthCode"].ToString().Equals("3")) //읽기
                            {
                                lo_objPrintChecked          = (Literal)lo_objGridRow.FindControl("roChk");
                                lo_objPrintChecked.Text     = "checked=\"checked\"";
                                lo_objGridRow.Cells[1].Text = "-";
                            }
                            else
                            {
                                lo_objGridRow.Cells[2].Text = "-";
                            }
                        }
                    }
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "Admin",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9124);
            }

            //메뉴 역할
            try
            {
                lo_objResAdminMenuRoleAccessList = lo_objAdminDasServices.GetAdminMenuRoleAccessList(hidAdminID.Value);

                if (lo_objResAdminMenuRoleAccessList.result.ErrorCode.IsFail() || lo_objResAdminMenuRoleAccessList.data.RecordCnt.Equals(0))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value      = "역할 정보를 조회하지 못했습니다.";
                    return;
                }

                lo_objDt               = lo_objResAdminMenuRoleAccessList.data.list.GetConvertListToDataTable();
                repRoleList.DataSource = lo_objDt;
                repRoleList.DataBind();

                for (int r = 0; r < lo_objDt.Rows.Count; r++)
                {
                    lo_objGridRow = repRoleList.Rows[r];
                    if (lo_objDt.Rows[r]["UseFlag"].ToString().Equals("Y"))
                    {
                        lo_objGridRow.Cells[1].Text = "-";
                    }
                    else
                    {
                        lo_objGridRow.Cells[2].Text = "-";
                    }
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "Admin",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9124);
            }
        }

        protected void OnRowDataBound_AccessList(object sender, GridViewRowEventArgs e)
        {
            try
            {
                GrvwRowDataBound(e);

                if (e.Row.RowType != DataControlRowType.Header) return;

                e.Row.Height = 30;
                e.Row.Style.Add("background-color", "#e5e4e3");

                e.Row.Cells[0].Text = "메뉴 명";
                e.Row.Cells[1].Text = "추가";
                e.Row.Cells[2].Text = "삭제";
                e.Row.Cells[3].Text = "전체";
                e.Row.Cells[4].Text = "읽기+쓰기";
                e.Row.Cells[5].Text = "읽기";

                e.Row.Cells[0].Font.Bold = true;
                e.Row.Cells[1].Font.Bold = true;
                e.Row.Cells[2].Font.Bold = true;
                e.Row.Cells[3].Font.Bold = true;
                e.Row.Cells[4].Font.Bold = true;
                e.Row.Cells[5].Font.Bold = true;

                e.Row.Cells[0].Width = Unit.Percentage(50);
                e.Row.Cells[1].Width = Unit.Percentage(10);
                e.Row.Cells[2].Width = Unit.Percentage(10);
                e.Row.Cells[3].Width = Unit.Percentage(10);
                e.Row.Cells[4].Width = Unit.Percentage(10);
                e.Row.Cells[5].Width = Unit.Percentage(10);
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "Admin",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9126);
            }
        }

        protected void OnRowDataBound_RoleList(object sender, GridViewRowEventArgs e)
        {

            try
            {
                GrvwRowDataBound(e);

                if (e.Row.RowType != DataControlRowType.Header) return;

                e.Row.Height = 30;
                e.Row.Style.Add("background-color", "#e5e4e3");

                e.Row.Cells[0].Text = "메뉴 명";
                e.Row.Cells[1].Text = "추가";
                e.Row.Cells[2].Text = "삭제";

                e.Row.Cells[0].Font.Bold = true;
                e.Row.Cells[1].Font.Bold = true;
                e.Row.Cells[2].Font.Bold = true;

                e.Row.Cells[0].Width = Unit.Percentage(80);
                e.Row.Cells[1].Width = Unit.Percentage(10);
                e.Row.Cells[2].Width = Unit.Percentage(10);
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "Admin",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9127);
            }
        }

        public static void GrvwRowDataBound(GridViewRowEventArgs e)
        {
        }
    }
}