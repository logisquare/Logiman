using CommonLibrary.CommonModule;
using System;
using System.Web.UI;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.CommonModel;
using CommonLibrary.Extensions;

namespace SMS
{
    public partial class Certificate : PageInit
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            string lo_strEncNo   = string.Empty;
            string lo_strOrderNo = string.Empty;
            lo_strEncNo = Utils.GetDecrypt(SiteGlobal.GetRequestForm("EncNo"));
            lo_strOrderNo = lo_strEncNo.Split(',')[0];

            GetOrderDetail(lo_strOrderNo);
        }

        protected void GetOrderDetail(string lo_strOrderNo) 
        {
            ReqSmsContentList lo_objReqOrderList = null;
            ServiceResult<ResSmsContentList> lo_objResOrderList = null;
            MsgDasServices objMsgDasServices = new MsgDasServices();

            if (string.IsNullOrWhiteSpace(lo_strOrderNo)) {
                ErrMsg.Value = "필요한 값이 없습니다.";
                DisplayMode.Value = "Y";
                return;
            }

            try
            {
                lo_objReqOrderList = new ReqSmsContentList
                {
                    OrderNo = lo_strOrderNo.ToInt64()
                };

                lo_objResOrderList = objMsgDasServices.GetOrderCertList(lo_objReqOrderList);
                if (lo_objResOrderList.result.ErrorCode.IsFail() || !lo_objResOrderList.data.RecordCnt.Equals(1))
                {
                    ErrMsg.Value = "정보를 조회하지 못했습니다.";
                    DisplayMode.Value = "Y";
                    return;
                }

                ClientName.Text = lo_objResOrderList.data.list[0].ClientName;
                CenterName.Text = lo_objResOrderList.data.list[0].CenterName;
                Addr.Text = lo_objResOrderList.data.list[0].Addr;
                CorpNo.Text = Utils.GetCorpNoDashed(lo_objResOrderList.data.list[0].CorpNo);
                TelNo.Text = Utils.GetMobileNoDashed(lo_objResOrderList.data.list[0].TelNo);
                PickupYMD.Text = lo_objResOrderList.data.list[0].PickupYMD.Substring(0, 4) + "년 " + lo_objResOrderList.data.list[0].PickupYMD.Substring(4, 2) + "월 " + lo_objResOrderList.data.list[0].PickupYMD.Substring(6) + "일";
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Certificate", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9901);
            }
        }
    }
}