using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;

namespace SSO.Admin
{
    public partial class AdminMyInfo : PageBase
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
            else
            {
                GetPostBackData();
            }

            DisplayData();
        }

        protected void GetInitData()
        {
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);
            GradeCode.Value = objSes.GradeCode.ToString();
        }

        protected void GetPostBackData()
        {
            string lo_strEventTarget = SiteGlobal.GetRequestForm("__EVENTTARGET");

            if (lo_strEventTarget.Equals("logout"))
            {
                objSes.goLogout();
                objSes.GoLogin("");
            }
        }
        protected void DisplayData()
        {
            ReqAdminList lo_objReqAdminList = null;
            ServiceResult<ResAdminList> lo_objResAdminList = null;
            AdminDasServices lo_objAdminDasServices = null;

            try
            {
                lo_objAdminDasServices = new AdminDasServices();

                lo_objReqAdminList = new ReqAdminList
                {
                    AdminID          = objSes.AdminID,
                    SesGradeCode     = objSes.GradeCode,
                    AccessCenterCode = objSes.AccessCenterCode
                };

                lo_objResAdminList = lo_objAdminDasServices.GetAdminList(lo_objReqAdminList);
                if (lo_objResAdminList.result.ErrorCode.IsFail() || !lo_objResAdminList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "사용자 정보를 조회하지 못했습니다.";
                    return;
                }

                AdminID.Text           = lo_objResAdminList.data.list[0].AdminID;
                HidEncCode.Value       = lo_objResAdminList.data.list[0].AdminPwd; 
                MobileNo.Text          = lo_objResAdminList.data.list[0].MobileNo;
                AdminName.Text         = lo_objResAdminList.data.list[0].AdminName;
                Email.Text             = lo_objResAdminList.data.list[0].Email;
                DeptName.Text          = lo_objResAdminList.data.list[0].DeptName;

                AdminPosition.Text     = lo_objResAdminList.data.list[0].AdminPosition; 
                TelNo.Text             = lo_objResAdminList.data.list[0].TelNo;
                MobileNoAuthFlag.Value = "Y";
                Network24DDID.Text     = lo_objResAdminList.data.list[0].Network24DDID;
                NetworkHMMID.Text      = lo_objResAdminList.data.list[0].NetworkHMMID;
                NetworkOneCallID.Text  = lo_objResAdminList.data.list[0].NetworkOneCallID;
                NetworkHmadangID.Text  = lo_objResAdminList.data.list[0].NetworkHmadangID;
                AdminCorpName.Text     = lo_objResAdminList.data.list[0].AdminCorpName;
                RegReqTypeM.Text       = lo_objResAdminList.data.list[0].RegReqTypeM;
                
                AdminCorpNo.Text       = Utils.GetCorpNoDashed(lo_objResAdminList.data.list[0].AdminCorpNo);

                //등급 코드(1:슈퍼관리자,2:내부 관리자,3:최고관리자, 4:관리자, 5:담당자,6:고객웹 담당자)
                if (lo_objResAdminList.data.list[0].GradeCode.Equals("5") || lo_objResAdminList.data.list[0].GradeCode.Equals("6") || lo_objResAdminList.data.list[0].GradeCode.Equals("7"))
                {
                    TrEtc1.Visible = true;
                    TrEtc2.Visible = true;
                }
                else
                {
                    //TrOp1.Visible = true;
                    TrOp2.Visible = true;
                    TrOp3.Visible = true;
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("AdminMyInfo", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }
        }
    }
}