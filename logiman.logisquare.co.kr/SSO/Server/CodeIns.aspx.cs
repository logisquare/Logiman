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
    public partial class CodeIns : PageBase
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
            hidCodeName.Value = SiteGlobal.GetRequestForm("CodeName");

            if (string.IsNullOrWhiteSpace(hidCodeName.Value))
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
            ReqCodeList lo_objReqCodeList = null;
            ServiceResult<ResCodeList> lo_objResCodeList = null;
            ServerDasServices lo_objServerDasServices = null;

            try
            {
                lo_objServerDasServices = new ServerDasServices();

                lo_objReqCodeList = new ReqCodeList
                {
                    CodeName = hidCodeName.Value,
                    PageSize = CommonConstant.PAGENAVIGATION_LIST.ToInt(),
                    PageNo = 1
                };

                lo_objResCodeList = lo_objServerDasServices.GetCodeList(lo_objReqCodeList);
                if (lo_objResCodeList.result.ErrorCode.IsFail() || !lo_objResCodeList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "코드 정보를 조회하지 못했습니다.";
                    return;
                }

                CodeName.Text = lo_objResCodeList.data.list[0].CodeName;
                CodeVal.Text = lo_objResCodeList.data.list[0].CodeVal;
                CodeDesc.Text = lo_objResCodeList.data.list[0].CodeDesc;
                AdminID.Text = lo_objResCodeList.data.list[0].RegAdminID;
                RegDate.Text = lo_objResCodeList.data.list[0].RegDate;
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