using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;

namespace TMS.Car
{
    public partial class CarDispatchRefIns : PageBase
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
                HidMode.Value  = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"), "");
                RefSeqNo.Value = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"), "0");

                CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
                CommonDDLB.ITEM_DDLB(this, CarTypeCode, "CA", objSes.AccessCenterCode, objSes.AdminID);
                CommonDDLB.ITEM_DDLB(this, CarTonCode, "CB", objSes.AccessCenterCode, objSes.AdminID);
                CommonDDLB.ITEM_DDLB(this, CarBrandCode, "CE", objSes.AccessCenterCode, objSes.AdminID);
                CommonDDLB.BANK_DDLB(BankCode);
                CommonDDLB.CAR_DIV_TYPE_DDLB(CarDivType);
                CommonDDLB.COM_TAX_KIND_DDLB(ComTaxKind);
                CommonDDLB.TMS_USE_FLAG_DDLB(UseFlag);
                CommonDDLB.CAR_PAY_DAY_DDLB(PayDay);
                
                if (HidMode.Value.Equals("Update"))
                {
                    GetCarDispatchDetail();
                    UseFlagArea.Visible       = true;
                    BtnChkCar.Visible         = false;
                    BtnChkDriver.Visible      = false;
                    BtnChkDriverReset.Visible = false;
                    BtnChkCorpNo.Visible      = false;
                    BtnChkCorpNoReset.Visible = false;
                }
                else if (HidMode.Value.Equals("Copy"))
                {
                    GetCarDispatchDetail();
                    RefSeqNo.Value      = "";
                    TrAgreement.Visible = false;
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("CarDispatchRefIns", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9501);
            }
        }

        protected void GetCarDispatchDetail()
        {
            string                            lo_strRefSeqNo            = string.Empty;
            ReqCarDispatchList                lo_objReqCarDispatchList  = null;
            ServiceResult<ResCarDispatchList> lo_objResCarDispatchList  = null;
            CarDispatchDasServices            objCarDispatchDasServices = new CarDispatchDasServices();

            lo_strRefSeqNo = RefSeqNo.Value;

            try
            {
                lo_objReqCarDispatchList = new ReqCarDispatchList
                {
                    RefSeqNo = lo_strRefSeqNo.ToInt64()
                };

                lo_objResCarDispatchList = objCarDispatchDasServices.GetCarDispatchList(lo_objReqCarDispatchList);

                if (lo_objResCarDispatchList.result.ErrorCode.IsFail() || !lo_objResCarDispatchList.data.RecordCnt.Equals(1))
                {
                    Utils.ShowAlert(this, "정보를 조회하지 못했습니다.");
                    return;
                }

                /*TCarDispatchRef*/
                if (!lo_strRefSeqNo.ToInt64().Equals(lo_objResCarDispatchList.data.list[0].RefSeqNo.ToInt64())) {
                    Utils.ShowAlert(this, "정보를 조회하지 못했습니다.");
                    return;
                }

                CenterCode.SelectedValue = lo_objResCarDispatchList.data.list[0].CenterCode.ToString();
                CarDivType.SelectedValue = lo_objResCarDispatchList.data.list[0].CarDivType.ToString();
                RefNote.Text             = lo_objResCarDispatchList.data.list[0].RefNote;
                CargoManFlag.Checked     = lo_objResCarDispatchList.data.list[0].CargoManFlag.Equals("Y") ? true : false;
                UseFlag.SelectedValue    = lo_objResCarDispatchList.data.list[0].RefUseFlag;

                /*TCar*/
                ChkCar.Value               = "Y";
                CarSeqNo.Value             = lo_objResCarDispatchList.data.list[0].CarSeqNo.ToString();
                CarNo.Text                 = lo_objResCarDispatchList.data.list[0].CarNo;
                CarTypeCode.SelectedValue  = lo_objResCarDispatchList.data.list[0].CarTypeCode;
                CarTonCode.SelectedValue   = lo_objResCarDispatchList.data.list[0].CarTonCode;
                CarBrandCode.SelectedValue = lo_objResCarDispatchList.data.list[0].CarBrandCode;
                CarNote.Value              = lo_objResCarDispatchList.data.list[0].CarNote;
                /*TCarDriver*/
                ChkDriver.Value   = "Y";
                DriverSeqNo.Value = lo_objResCarDispatchList.data.list[0].DriverSeqNo.ToString();
                DriverName.Text   = lo_objResCarDispatchList.data.list[0].DriverName;
                DriverCell.Text   = lo_objResCarDispatchList.data.list[0].DriverCell;
                /*TCarCompany*/
                ChkCom.Value = "Y";
                /*TCarCompany HiddenField-->*/
                ComCode.Value   = lo_objResCarDispatchList.data.list[0].ComCode.ToString();
                ComStatus.Value = lo_objResCarDispatchList.data.list[0].ComStatus.ToString();
                /*<--TCarCompany HiddenField*/
                if (lo_objResCarDispatchList.data.list[0].ComStatus.Equals(3) || lo_objResCarDispatchList.data.list[0].ComStatus.Equals(4))
                {
                    SpanComStatusDtl.Text = $"※ {lo_objResCarDispatchList.data.list[0].ComStatusM}사업자 ({lo_objResCarDispatchList.data.list[0].ComCloseYMD})";
                }
                ComName.Text             = lo_objResCarDispatchList.data.list[0].ComName;
                ComCeoName.Text          = lo_objResCarDispatchList.data.list[0].ComCeoName;
                ComCorpNo.Text           = lo_objResCarDispatchList.data.list[0].ComCorpNo;
                ComBizType.Text          = lo_objResCarDispatchList.data.list[0].ComBizType;
                ComBizClass.Text         = lo_objResCarDispatchList.data.list[0].ComBizClass;
                ComTelNo.Text            = lo_objResCarDispatchList.data.list[0].ComTelNo;
                ComFaxNo.Text            = lo_objResCarDispatchList.data.list[0].ComFaxNo;
                ComEmail.Text            = lo_objResCarDispatchList.data.list[0].ComEmail;
                ComPost.Text             = lo_objResCarDispatchList.data.list[0].ComPost;
                ComAddr.Text             = lo_objResCarDispatchList.data.list[0].ComAddr;
                ComAddrDtl.Text          = lo_objResCarDispatchList.data.list[0].ComAddrDtl;
                ComTaxKind.SelectedValue = lo_objResCarDispatchList.data.list[0].ComTaxKind.ToString();
                ComKindM.Value           = lo_objResCarDispatchList.data.list[0].ComKindM;
                /*TCarCompanyDtl*/
                DtlSeqNo.Value         = lo_objResCarDispatchList.data.list[0].DtlSeqNo.ToString();
                PayDay.SelectedValue   = lo_objResCarDispatchList.data.list[0].PayDay.ToString();
                BankCode.SelectedValue = lo_objResCarDispatchList.data.list[0].BankCode;
                EncAcctNo.Text         = Utils.GetDecrypt(lo_objResCarDispatchList.data.list[0].EncAcctNo);
                AcctName.Text          = lo_objResCarDispatchList.data.list[0].AcctName;
                AcctValidFlag.Value    = lo_objResCarDispatchList.data.list[0].AcctValidFlag;
                CooperatorFlag.Checked = lo_objResCarDispatchList.data.list[0].CooperatorFlag.Equals("Y") ? true : false;

                ChargeName.Value  = lo_objResCarDispatchList.data.list[0].ChargeName;
                ChargeTelNo.Value = lo_objResCarDispatchList.data.list[0].ChargeTelNo;
                ChargeEmail.Value = lo_objResCarDispatchList.data.list[0].ChargeEmail;

                TrAgreement.Visible       = lo_objResCarDispatchList.data.list[0].CenterContractFlag.Equals("Y");
                InformationFlagM.Text     = lo_objResCarDispatchList.data.list[0].InformationFlagM;
                AgreementFlagM.Text       = lo_objResCarDispatchList.data.list[0].AgreementFlagM;
                InsureTargetFlagY.Checked = lo_objResCarDispatchList.data.list[0].InsureTargetFlag.Equals("Y");
                InsureTargetFlagN.Checked = !lo_objResCarDispatchList.data.list[0].InsureTargetFlag.Equals("Y");
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                                    "CarDispatchRefIns",
                                    "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    9502);
            }
        }
    }
}