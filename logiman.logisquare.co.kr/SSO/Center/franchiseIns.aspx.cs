using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;

namespace SSO.Center
{
    public partial class FranchiseIns : PageBase
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
            hidCenterCode.Value = SiteGlobal.GetRequestForm("CenterCode");
            GradeCode.Value     = objSes.GradeCode.ToString();

            CommonDDLB.USE_FLAG_DDLB(UseFlag);
            CommonDDLB.CENTER_TYPE_DDLB(CenterType, objSes.GradeCode);
            CommonDDLB.BANK_DDLB(BankCode);
            CommonDDLB.CONTRACT_FLAG_DDLB(ContractFlag);

            ContractFlag.SelectedIndex = 2;
            if (objSes.GradeCode.Equals(1) || objSes.GradeCode.Equals(2))
            {
                TrContract.Style.Remove("display");
            }

            if (string.IsNullOrWhiteSpace(hidCenterCode.Value))
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
            ReqCenterList                lo_objReqCenterList     = null;
            ServiceResult<ResCenterList> lo_objResCenterList     = null;
            CenterDasServices            lo_objCenterDasServices = null;

            try
            {
                if (objSes.AuthCode.Equals(3)) {
                    InsRegBtn.Visible = false;
                }
                lo_objCenterDasServices = new CenterDasServices();

                lo_objReqCenterList = new ReqCenterList
                {
                    AdminID    = objSes.AdminID,
                    CenterCode = hidCenterCode.Value.ToInt(),
                    PageSize   = CommonConstant.PAGENAVIGATION_LIST.ToInt(),
                    PageNo     = 1
                };

                lo_objResCenterList = lo_objCenterDasServices.GetCenterList(lo_objReqCenterList);
                if (lo_objResCenterList.result.ErrorCode.IsFail() || !lo_objResCenterList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "코드 정보를 조회하지 못했습니다.";
                    return;
                }

                CenterID.Text              = lo_objResCenterList.data.list[0].CenterID;
                CenterKey.Text             = lo_objResCenterList.data.list[0].CenterKey;
                CenterName.Text            = lo_objResCenterList.data.list[0].CenterName;
                CorpNo.Text                = lo_objResCenterList.data.list[0].CorpNo;
                CeoName.Text               = lo_objResCenterList.data.list[0].CeoName;
                BizType.Text               = lo_objResCenterList.data.list[0].BizType;
                BizClass.Text              = lo_objResCenterList.data.list[0].BizClass;
                TelNo.Text                 = lo_objResCenterList.data.list[0].TelNo;
                FaxNo.Text                 = lo_objResCenterList.data.list[0].FaxNo;
                Email.Text                 = lo_objResCenterList.data.list[0].Email;
                AddrPost.Text              = lo_objResCenterList.data.list[0].AddrPost;
                Addr.Text                  = lo_objResCenterList.data.list[0].Addr;
                CenterNote.Text            = lo_objResCenterList.data.list[0].CenterNote;
                TransSaleRate.Text         = lo_objResCenterList.data.list[0].TransSaleRate.ToString();
                BankCode.SelectedValue     = lo_objResCenterList.data.list[0].BankCode;
                AcctName.Text              = lo_objResCenterList.data.list[0].AcctName;
                EncAcctNo.Text             = Utils.GetDecrypt(lo_objResCenterList.data.list[0].EncAcctNo);
                CenterType.SelectedValue   = lo_objResCenterList.data.list[0].CenterType.ToString();
                ContractFlag.SelectedValue = lo_objResCenterList.data.list[0].ContractFlag;
                UseFlag.SelectedValue      = lo_objResCenterList.data.list[0].UseFlag;
                AcctValidFlag.Value        = lo_objResCenterList.data.list[0].AcctValidFlag;

            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Center", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }
        }

    }
}