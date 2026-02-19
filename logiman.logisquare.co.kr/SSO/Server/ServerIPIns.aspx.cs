using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web.UI.WebControls;

namespace SSO.Server
{
    public partial class ServerIPIns : PageBase
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
            hidServerType.Value = SiteGlobal.GetRequestForm("ServerType");
            hidCenterCode.Value = SiteGlobal.GetRequestForm("CenterCode");
            hidAllowIPAddr.Value = SiteGlobal.GetRequestForm("AllowIPAddr");

            CommonDDLB.SERVER_TYPE_DDLB(ServerType);
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            CommonDDLB.USE_FLAG_DDLB(UseFlag);

            if (string.IsNullOrWhiteSpace(hidServerType.Value) && string.IsNullOrWhiteSpace(hidCenterCode.Value) && string.IsNullOrWhiteSpace(hidAllowIPAddr.Value))
            {
                hidMode.Value = "insert";
            }
            else
            {
                hidMode.Value = "update";
                DisplayData();
            }
        }

        protected void DisplayData()
        {
            ReqServerAllowipList lo_objReqServerAllowipList = null;
            ServiceResult<ResServerAllowipList> lo_objResServerAllowipList = null;
            ServerDasServices lo_objServerDasServices = null;

            try
            {
                lo_objServerDasServices = new ServerDasServices();

                lo_objReqServerAllowipList = new ReqServerAllowipList
                {
                    ServerType = hidServerType.Value,
                    CenterCode = Convert.ToInt32(hidCenterCode.Value),
                    AllowIPAddr = hidAllowIPAddr.Value,
                    PageSize = CommonConstant.PAGENAVIGATION_LIST.ToInt(),
                    PageNo = 1
                };

                lo_objResServerAllowipList = lo_objServerDasServices.GetServerAllowipList(lo_objReqServerAllowipList);
                if (lo_objResServerAllowipList.result.ErrorCode.IsFail() || !lo_objResServerAllowipList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "접근 IP 정보를 조회하지 못했습니다.";
                    return;
                }

                ServerType.SelectedValue = lo_objResServerAllowipList.data.list[0].ServerType;
                CenterCode.SelectedValue = lo_objResServerAllowipList.data.list[0].CenterCode.ToString();
                AllowIPAddr.Text = lo_objResServerAllowipList.data.list[0].AllowIPAddr;
                AllowIPDesc.Text = lo_objResServerAllowipList.data.list[0].AllowIPDesc;
                UseFlag.SelectedValue = lo_objResServerAllowipList.data.list[0].UseFlag;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Server", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }
        }

    }
}