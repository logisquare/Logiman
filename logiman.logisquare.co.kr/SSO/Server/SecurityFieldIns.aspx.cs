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
    public partial class SecurityFieldIns : PageBase
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
            hidFieldName.Value = SiteGlobal.GetRequestForm("FieldName");

            CommonDDLB.USE_FLAG_DDLB(UseFlag);

            if (string.IsNullOrWhiteSpace(hidFieldName.Value))
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
            ReqSecurityFieldList lo_objReqSecurityFieldList = null;
            ServiceResult<ResSecurityFieldList> lo_objResSecurityFieldList = null;
            ServerDasServices lo_objServerDasServices = null;

            try
            {
                lo_objServerDasServices = new ServerDasServices();

                lo_objReqSecurityFieldList = new ReqSecurityFieldList
                {
                    FieldName = hidFieldName.Value,
                    PageSize = CommonConstant.PAGENAVIGATION_LIST.ToInt(),
                    PageNo = 1
                };

                lo_objResSecurityFieldList = lo_objServerDasServices.GetSecurityFieldList(lo_objReqSecurityFieldList);
                if (lo_objResSecurityFieldList.result.ErrorCode.IsFail() || !lo_objResSecurityFieldList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "필드 정보를 조회하지 못했습니다.";
                    return;
                }

                FieldName.Text = lo_objResSecurityFieldList.data.list[0].FieldName;
                MarkCharCnt.Text = lo_objResSecurityFieldList.data.list[0].MarkCharCnt.ToString();
                FieldDesc.Text = lo_objResSecurityFieldList.data.list[0].FieldDesc;
                UseFlag.SelectedValue = lo_objResSecurityFieldList.data.list[0].UseFlag;
                AdminID.Text = lo_objResSecurityFieldList.data.list[0].AdminID;
                RegDate.Text = lo_objResSecurityFieldList.data.list[0].RegDate;
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