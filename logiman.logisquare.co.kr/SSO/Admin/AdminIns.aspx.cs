using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web.UI.WebControls;

namespace SSO.Admin
{
    public partial class AdminIns : PageBase
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
            hidAdminID.Value = SiteGlobal.GetRequestForm("AdminID");

            AccessIPChkFlag.Items.Clear();
            AccessIPChkFlag.Items.Add(new ListItem("제한함", "Y"));
            AccessIPChkFlag.Items.Add(new ListItem("제한안함", "N"));
            AccessIPChkFlag.SelectedValue = "N";

            DupLoginFlag.Items.Clear();
            DupLoginFlag.Items.Add(new ListItem("불가", "N"));
            DupLoginFlag.Items.Add(new ListItem("허용", "Y"));

            MyOrderFlag.Items.Clear();
            MyOrderFlag.Items.Add(new ListItem("전체",   "N"));
            MyOrderFlag.Items.Add(new ListItem("내오더", "Y"));

            UseFlag.Items.Clear();
            UseFlag.Items.Add(new ListItem("사용 여부", ""));
            UseFlag.Items.Add(new ListItem("사용", "Y"));
            UseFlag.Items.Add(new ListItem("사용중지", "N"));
            UseFlag.Items.Add(new ListItem("대기", "P"));

            PrivateAvailFlag.Items.Clear();
            PrivateAvailFlag.Items.Add(new ListItem("가능 여부", ""));
            PrivateAvailFlag.Items.Add(new ListItem("가능",    "Y"));
            PrivateAvailFlag.Items.Add(new ListItem("불가능",    "N"));
            PrivateAvailFlag.SelectedIndex = 2;
            if (objSes.GradeCode.Equals(1) || objSes.GradeCode.Equals(2))
            {
                TrPrivate.Style.Remove("display");
            }

            CommonDDLB.ADMIN_GRADE_DDLB(GradeCode, objSes.GradeCode);
            CommonDDLB.CENTER_CODE_CHKLB(CenterCodes, objSes.AdminID);
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID, CenterCode);

            if (!string.IsNullOrWhiteSpace(hidAdminID.Value))
            {
                hidMode.Value = "update";
                DisplayData();
            }
            else
            {
                hidMode.Value  = "insert";
                ExpireYMD.Text = Convert.ToDateTime(DateTime.Now.AddYears(10)).ToString("yyyy-MM-dd");
                
            }
        }

        protected void DisplayData()
        {
            ReqAdminList                lo_objReqAdminList     = null;
            ServiceResult<ResAdminList> lo_objResAdminList     = null;
            AdminDasServices            lo_objAdminDasServices = null;

            try
            {
                lo_objAdminDasServices = new AdminDasServices();

                lo_objReqAdminList = new ReqAdminList
                {
                    AdminID          = hidAdminID.Value,
                    SesGradeCode     = objSes.GradeCode,
                    AccessCenterCode = objSes.AccessCenterCode,
                    PageSize         = CommonConstant.PAGENAVIGATION_LIST.ToInt(),
                    PageNo           = 1
                };

                lo_objResAdminList = lo_objAdminDasServices.GetAdminList(lo_objReqAdminList);
                if (lo_objResAdminList.result.ErrorCode.IsFail() || !lo_objResAdminList.data.RecordCnt.Equals(1))
                {
                    hidDisplayMode.Value = "Y";
                    hidErrMsg.Value = "관리자 정보를 조회하지 못했습니다.";
                    return;
                }

                AdminCorpNo.Value   = lo_objResAdminList.data.list[0].AdminCorpNo;
                AdminCorpName.Value = lo_objResAdminList.data.list[0].AdminCorpName;
                AdminID.Text        = lo_objResAdminList.data.list[0].AdminID;
                AdminName.Text      = lo_objResAdminList.data.list[0].AdminName;
                AdminPosition.Text  = lo_objResAdminList.data.list[0].AdminPosition;

                if (!lo_objResAdminList.data.list[0].AdminID.Equals(""))
                {
                    hidAdminIDFlag.Value = "Y";
                }

                AccessIPChkFlag.SelectedValue = lo_objResAdminList.data.list[0].AccessIPChkFlag;
                if (AccessIPChkFlag.SelectedValue.Equals("Y"))
                {
                    string[] arrIP1 = lo_objResAdminList.data.list[0].AccessIP1.Split('.');
                    AccessIP1_1.Text = arrIP1[0];
                    AccessIP1_2.Text = arrIP1[1];
                    AccessIP1_3.Text = arrIP1[2];
                    AccessIP1_4.Text = arrIP1[3];
                    string[] arrIP2 = lo_objResAdminList.data.list[0].AccessIP2.Split('.');
                    AccessIP2_1.Text = arrIP2[0];
                    AccessIP2_2.Text = arrIP2[1];
                    AccessIP2_3.Text = arrIP2[2];
                    AccessIP2_4.Text = arrIP2[3];
                    string[] arrIP3 = lo_objResAdminList.data.list[0].AccessIP3.Split('.');
                    AccessIP3_1.Text = arrIP3[0];
                    AccessIP3_2.Text = arrIP3[1];
                    AccessIP3_3.Text = arrIP3[2];
                    AccessIP3_4.Text = arrIP3[3];
                }

                DeptName.Text           = lo_objResAdminList.data.list[0].DeptName;
                TelNo.Text              = lo_objResAdminList.data.list[0].TelNo;
                MobileNo.Text           = lo_objResAdminList.data.list[0].MobileNo;
                Email.Text              = lo_objResAdminList.data.list[0].Email;
                GradeCode.SelectedValue = lo_objResAdminList.data.list[0].GradeCode.ToString();

                if (!lo_objResAdminList.data.list[0].AccessCenterCode.Split(',').Length.Equals(0)) {
                    for (var iFor = 0; iFor < lo_objResAdminList.data.list[0].AccessCenterCode.Split(',').Length; iFor++) {
                        for (var jFor = 0; jFor < CenterCodes.Items.Count; jFor++) {
                            if (lo_objResAdminList.data.list[0].AccessCenterCode.Split(',')[iFor].Equals(CenterCodes.Items[jFor].Value)) {
                                CenterCodes.Items.FindByValue(lo_objResAdminList.data.list[0].AccessCenterCode.Split(',')[iFor].ToString()).Selected = true;
                            }
                        }
                    }
                }
                if (GradeCode.SelectedValue.Equals("6"))
                {
                    ClientCorpNo.Value = lo_objResAdminList.data.list[0].AccessCorpNo;
                    ClientName.Text = lo_objResAdminList.data.list[0].AdminCorpName + "(" + lo_objResAdminList.data.list[0].AdminCorpNo + ")";
                    CenterCode.SelectedValue = lo_objResAdminList.data.list[0].AccessCenterCode;
                }

                Network24DDID.Text             = lo_objResAdminList.data.list[0].Network24DDID;
                NetworkHMMID.Text              = lo_objResAdminList.data.list[0].NetworkHMMID;
                NetworkOneCallID.Text          = lo_objResAdminList.data.list[0].NetworkOneCallID;
                NetworkHmadangID.Text          = lo_objResAdminList.data.list[0].NetworkHmadangID;
                DupLoginFlag.SelectedValue     = lo_objResAdminList.data.list[0].DupLoginFlag;
                MyOrderFlag.SelectedValue      = lo_objResAdminList.data.list[0].MyOrderFlag;
                UseFlag.SelectedValue          = lo_objResAdminList.data.list[0].UseFlag;
                ExpireYMD.Text                 = lo_objResAdminList.data.list[0].ExpireYMD;
                PrivateAvailFlag.SelectedValue = lo_objResAdminList.data.list[0].PrivateAvailFlag;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Admin", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }
        }
    }
}