using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.IO;

namespace SSO.Admin
{
    public partial class AdminMenuGroupList : PageBase
    {
        public string[] arrImageName;

        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadOnly;
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
            GetLeftMenuImageList(out arrImageName);
        }

        protected void GetLeftMenuImageList(out string[] lo_arrImageFileName)
        {
            lo_arrImageFileName = null;
            int lo_intLoop = 0;

            try
            {
                DirectoryInfo dir = new DirectoryInfo(Server.MapPath("/") + "/images/common");
                FileInfo[] fileList = dir.GetFiles("*.*", SearchOption.AllDirectories);
                lo_arrImageFileName = new string[fileList.Length + 1];
                lo_arrImageFileName[lo_intLoop++] = "";
                foreach (FileInfo FI in fileList)
                {
                    lo_arrImageFileName[lo_intLoop++] = FI.Name;

                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "AdminMenuGroupList",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9137);
            }
        }

        protected void DisplayData()
        {
            ReqAdminMenuGroupList                lo_objReqAdminMenuGroupList = null;
            ServiceResult<ResAdminMenuGroupList> lo_objRResAdminMenuGroupList = null;
            AdminMenuDasServices                 lo_objAdminMenuDasServices = null;
            DataTable                            lo_objDt = null;
            try
            {
                lo_objAdminMenuDasServices  = new AdminMenuDasServices();
                lo_objReqAdminMenuGroupList = new ReqAdminMenuGroupList
                {
                    MenuGroupNo =null
                };

                lo_objRResAdminMenuGroupList = lo_objAdminMenuDasServices.GetAdminMenuGroupInfo(lo_objReqAdminMenuGroupList);


                if (lo_objRResAdminMenuGroupList.result.ErrorCode.IsFail())
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "메뉴 그룹 정보를 읽지 못했습니다.";
                    return;
                }

                RecordCnt.Value = lo_objRResAdminMenuGroupList.data.RecordCnt.ToString();

                lo_objDt = lo_objRResAdminMenuGroupList.data.list.GetConvertListToDataTable();
                repList.DataSource = lo_objDt;
                repList.DataBind();

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