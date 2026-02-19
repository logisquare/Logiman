using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace TMS.Common
{
    public partial class MsgSend : PageBase
    {
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
        }

        protected void GetInitData()
        {
            string lo_strCenterCode = string.Empty;
            string lo_strOrderNos   = string.Empty;
            string lo_strOrderType  = string.Empty;
            string lo_strSndTelNo   = string.Empty;
            string lo_strRcvTelNo   = string.Empty;

            lo_strCenterCode = SiteGlobal.GetRequestForm("ParamCenterCode");
            lo_strOrderNos   = SiteGlobal.GetRequestForm("ParamOrderNos");
            lo_strOrderType  = SiteGlobal.GetRequestForm("ParamOrderType"); //1:기본, 2:오더내용 불러오기, 3:머핀트럭 다운로드 안내, 4: 배차정보전송
            lo_strSndTelNo   = SiteGlobal.GetRequestForm("ParamSndTelNo");
            lo_strRcvTelNo   = SiteGlobal.GetRequestForm("ParamRcvTelNo");

            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);

            CenterCode.SelectedValue = lo_strCenterCode;
            OrderNo.Value            = lo_strOrderNos;
            OrderType.Value          = lo_strOrderType;
            SndTelNo.Value           = lo_strSndTelNo;
            RcvTelNo.Value           = lo_strRcvTelNo;

            SmsSendCell.Items.Clear();
            SmsSendCell.Items.Add(new ListItem("[L] " + Utils.SetPhoneNoDashed(objSes.MobileNo), objSes.MobileNo));

            if (!string.IsNullOrWhiteSpace(objSes.TelNo) && !objSes.TelNo.Equals(objSes.MobileNo))
            {
                SmsSendCell.Items.Add(new ListItem("[L] " + Utils.SetPhoneNoDashed(objSes.TelNo), objSes.TelNo));
            }

            //if (!string.IsNullOrWhiteSpace(lo_strSndTelNo))
            //{
            //    SmsSendCell.Items.Add(new ListItem("[C] " + Utils.SetPhoneNoDashed(lo_strSndTelNo), lo_strSndTelNo));
            //    SmsSendCell.SelectedValue = lo_strSndTelNo;
            //}
        }
    }
}