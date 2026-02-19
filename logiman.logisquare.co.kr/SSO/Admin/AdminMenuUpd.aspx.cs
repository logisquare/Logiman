using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web.UI.WebControls;

namespace SSO.Admin
{
    public partial class AdminMenuUpd : PageBase
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
        }
        protected void GetInitData()
        {
            try
            {
                hidMenuGroupNo.Value = SiteGlobal.GetRequestForm("MenuGroupNo");
                GetMenuGroupInfo();

                hidMenuNo.Value      = SiteGlobal.GetRequestForm("MenuNo");

                DDLUseStateCode.Items.Clear();
                DDLUseStateCode.Items.Add(new ListItem("정상", "1"));
                DDLUseStateCode.Items.Add(new ListItem("비정상", "2 "));
                DDLUseStateCode.Items.Add(new ListItem("팝업 정상", "3"));
                DDLUseStateCode.Items.Add(new ListItem("팝업 비정상", "4"));

                if (!string.IsNullOrWhiteSpace(hidMenuNo.Value))
                {
                    hidMode.Value = "update";
                    DisplayData();
                }
                else
                {
                    hidMode.Value = "insert";
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "AdminMenuUpd",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9180);
            }
        }
        protected void GetMenuGroupInfo()
        {
            ReqAdminMenuGroupList lo_objReqAdminMenuGroupList = null;
            ServiceResult<ResAdminMenuGroupList> lo_objResAdminMenuGroupList = null;
            AdminMenuDasServices lo_objAdminMenuDasServices = null;

            try
            {
                lo_objAdminMenuDasServices = new AdminMenuDasServices();

                lo_objReqAdminMenuGroupList = new ReqAdminMenuGroupList
                {
                    MenuGroupNo = hidMenuGroupNo.Value
                };

                lo_objResAdminMenuGroupList = lo_objAdminMenuDasServices.GetAdminMenuGroupInfo(lo_objReqAdminMenuGroupList);


                if (lo_objResAdminMenuGroupList.result.ErrorCode.IsFail() || !lo_objResAdminMenuGroupList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "메뉴 그룹 정보를 읽지 못했습니다.";
                    return;
                }
                MenuGroupName.Text = lo_objResAdminMenuGroupList.data.list[0].MenuGroupName;

            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("AdminMenuUpd", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }

        }

        protected void DisplayData()
        {
            ReqAdminMenuList                lo_objReqAdminMenuList     = null;
            ServiceResult<ResAdminMenuList> lo_objResAdminMenuList     = null;
            AdminMenuDasServices            lo_objAdminMenuDasServices = null;

            try
            {
                lo_objAdminMenuDasServices = new AdminMenuDasServices();

                lo_objReqAdminMenuList = new ReqAdminMenuList
                {
                    MenuNo = hidMenuNo.Value.ToInt()
                };

                lo_objResAdminMenuList = lo_objAdminMenuDasServices.GetAdminMenuList(lo_objReqAdminMenuList);
                if (lo_objResAdminMenuList.result.ErrorCode.IsFail() || !lo_objResAdminMenuList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "메뉴 정보를 조회하지 못했습니다.";
                    return;
                }

                MenuGroupName.Text            = lo_objResAdminMenuList.data.list[0].MenuGroupName;
                MenuName.Text                 = lo_objResAdminMenuList.data.list[0].MenuName;
                MenuLink.Text                 = lo_objResAdminMenuList.data.list[0].MenuLink;
                MenuDesc.Text                 = lo_objResAdminMenuList.data.list[0].MenuDesc;
                hidMenuSort.Value             = lo_objResAdminMenuList.data.list[0].MenuSort.ToString() ;
                DDLUseStateCode.SelectedValue = lo_objResAdminMenuList.data.list[0].UseStateCode.ToString();

            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("AdminMenuUpd", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }

        }

    }
}