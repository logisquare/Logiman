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
    public partial class ServerConfigIns : PageBase
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
            hidKeyName.Value = SiteGlobal.GetRequestForm("KeyName");

            CommonDDLB.SERVER_TYPE_DDLB(ServerType);

            if (string.IsNullOrWhiteSpace(hidServerType.Value) && string.IsNullOrWhiteSpace(hidKeyName.Value))
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
            ReqServerConfigList lo_objReqServerConfigList = null;
            ServiceResult<ResServerConfigList> lo_objResServerConfigList = null;
            ServerDasServices lo_objServerDasServices = null;

            try
            {
                lo_objServerDasServices = new ServerDasServices();

                lo_objReqServerConfigList = new ReqServerConfigList
                {
                    ServerType = hidServerType.Value,
                    KeyName = hidKeyName.Value,
                    PageSize = CommonConstant.PAGENAVIGATION_LIST.ToInt(),
                    PageNo = 1
                };

                lo_objResServerConfigList = lo_objServerDasServices.GetServerConfigList(lo_objReqServerConfigList);
                if (lo_objResServerConfigList.result.ErrorCode.IsFail() || !lo_objResServerConfigList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "설정값 정보를 조회하지 못했습니다.";
                    return;
                }

                ServerType.SelectedValue = lo_objResServerConfigList.data.list[0].ServerType;
                KeyName.Text = lo_objResServerConfigList.data.list[0].KeyName;
                KeyVal.Text = lo_objResServerConfigList.data.list[0].KeyVal;
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