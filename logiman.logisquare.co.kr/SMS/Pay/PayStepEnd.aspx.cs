using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI;


namespace SMS.Pay
{
    public partial class PayStepEnd : PageInit
    {
        /*
        protected string strComCode = string.Empty;
        protected string strCenterCode = string.Empty;
        protected string strCardAgreeExistsFlag = "N";
        protected string strCenterAuth = "N";
        */

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            string lo_strNo = string.Empty;

            lo_strNo = Utils.IsNull(SiteGlobal.GetRequestForm("No"), "");

            if (string.IsNullOrWhiteSpace(lo_strNo))
            {
                DisplayMode.Value = "N";
                ErrMsg.Value      = "페이지를 표시할 수 없습니다.";
                return;
            }

            No.Value = lo_strNo;
            /*
            string lo_strErrMsg = string.Empty;
            int    lo_intRetVal = 0;
            string lo_strNo     = string.Empty;

            try
            {
                lo_strNo = SiteGlobal.IsNull(SiteGlobal.GetRequestForm("No"), "");

                if (string.IsNullOrWhiteSpace(lo_strNo))
                {
                    SiteGlobal.ShowAlert(this, "올바르지 않은 접속입니다.");
                    return;
                }

                No.Value = lo_strNo;

                //전송정보
                lo_intRetVal = UP_ORDER_SEND_NT_GET(SiteGlobal.GetDecrypt(SiteGlobal.M_SITECODE_SMS, lo_strNo),
                    out lo_strErrMsg);
                if (!lo_intRetVal.Equals(0))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "IndexScript",
                        "<script type=\"text/javascript\"> alert('" + lo_strErrMsg + "'); fnPopupClose(); </script>");
                    return;
                }

                //사업자 정보
                lo_intRetVal = UP_CAR_COMPANY_AR_LST(out lo_strErrMsg);
                if (!lo_intRetVal.Equals(0))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "IndexScript",
                        "<script type=\"text/javascript\"> alert('" + lo_strErrMsg + "'); fnPopupClose(); </script>");
                    return;
                }

                //가입 정보
                GetCardAgreeInfo(out lo_strErrMsg);
                if (!strCardAgreeExistsFlag.Equals("Y"))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "IndexScript",
                        "<script type=\"text/javascript\"> fnGoJoin('카고페이 사용자 인증 후 이용이 가능합니다.') </script>");
                    return;
                }

                DisplayData();
            }

            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "SMS-Cargopay",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9001);
            }
        }

        // 상세화면 디스플레이
        protected void DisplayData()
        {
            int    lo_intRetVal = 0;
            string lo_strErrMsg = string.Empty;

            try
            {
                // 오더 상세정보
                lo_intRetVal = UP_ORDER_SEND_ORDER_AR_LST(out lo_strErrMsg);
                if (!lo_intRetVal.Equals(0))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "IndexScript",
                        "<script type=\"text/javascript\"> fnGoReturn('" + lo_strErrMsg + "') </script>");
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9001;
                SiteGlobal.WriteLog(
                    "SMS-Cargopay",
                    "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9001);
            }
            finally
            {
            }
            */
        }

        /*
        public int UP_ORDER_SEND_NT_GET(string strNo, out string strErrMsg)
        {
            int        lo_intRetVal       = 9999;
            IDasNetCom lo_objDas          = null;
            string     lo_strClosingSeqNo = string.Empty;
            strErrMsg = string.Empty;

            if (string.IsNullOrWhiteSpace(strNo))
            {
                strErrMsg = "필요한 값이 없습니다.";
                return lo_intRetVal;
            }

            try
            {
                lo_objDas = new IDasNetCom();
                lo_objDas.Open(SiteGlobal.M_HOST_DAS_TMS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSEQ_NO", DBType.adInteger, strNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intORDER_NO", DBType.adBigInt, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCENTER_CODE", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intSEND_TYPE", DBType.adTinyInt, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strSEND_URL", DBType.adVarWChar, DBNull.Value, 256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strEXPIRE_YMD", DBType.adVarChar, DBNull.Value, 8,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strSEND_CELL",  DBType.adVarChar, DBNull.Value, 20, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strRCV_CELL",   DBType.adVarChar, DBNull.Value, 20, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCLOSING_SEQ_NO", DBType.adVarChar, DBNull.Value, 30,
                    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCOM_CODE", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDRIVER_SEQ_NO", DBType.adInteger, DBNull.Value, 0,
                    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCONFIRM_TYPE", DBType.adTinyInt, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCONFIRM_YMD", DBType.adVarChar, DBNull.Value, 8, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strVIEW_FLAG", DBType.adChar, DBNull.Value, 1, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strVIEW_DATE", DBType.adVarChar, DBNull.Value, 16, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strREG_YMD", DBType.adVarChar, DBNull.Value, 8, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strREG_ADMIN_ID", DBType.adVarChar, DBNull.Value, 50,
                    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strREG_DATE",    DBType.adVarChar, DBNull.Value, 16, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strUPD_DATE",    DBType.adVarChar, DBNull.Value, 16, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strEXISTS_FLAG", DBType.adChar,    DBNull.Value, 1,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_strEXPIRED_FLAG", DBType.adChar, DBNull.Value, 1, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNETWORK_FLAG", DBType.adChar, DBNull.Value, 1, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRESULT_CNT", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strERR_MSG", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRET_VAL", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDB_ERR_MSG", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDB_RET_VAL", DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SEND_NT_GET");

                strErrMsg    = lo_objDas.GetParam("@po_strERR_MSG");
                lo_intRetVal = Convert.ToInt32(lo_objDas.GetParam("@po_intRET_VAL"));

                if (!lo_objDas.LastErrorCode.Equals(0))
                {
                    lo_intRetVal = lo_objDas.LastErrorCode;
                    strErrMsg    = lo_objDas.LastErrorMessage;
                    return lo_intRetVal;
                }

                if (Convert.ToInt32(lo_objDas.GetParam("@po_intRESULT_CNT")).Equals(0) ||
                    lo_objDas.GetParam("@po_strEXISTS_FLAG").Equals("N"))
                {
                    lo_intRetVal = 9998;
                    strErrMsg    = "검색된 데이터가 없습니다.";
                    return lo_intRetVal;
                }

                if (lo_objDas.GetParam("@po_strEXPIRED_FLAG").Equals("Y"))
                {
                    lo_intRetVal = 9998;
                    strErrMsg    = "조회기간이 만료되었습니다.";
                    return lo_intRetVal;
                }

                strComCode          = lo_objDas.GetParam("@po_intCOM_CODE");
                strCenterCode       = lo_objDas.GetParam("@po_intCENTER_CODE");
                lo_strClosingSeqNo  = lo_objDas.GetParam("@po_strCLOSING_SEQ_NO");
                EncCenterCode.Value = SiteGlobal.GetEncrypt(strCenterCode + DateTime.Now.ToString("yyyyMMddHHmmss"));
                EncClosingSeqNo.Value =
                    SiteGlobal.GetEncrypt(lo_strClosingSeqNo + DateTime.Now.ToString("yyyyMMddHHmmss"));
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9001;
                SiteGlobal.WriteLog(
                    "SMS-Cargopay",
                    "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9001);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }
            }

            return lo_intRetVal;
        }

        /// <summary>
        /// 차량업체정보
        /// </summary>
        /// <param name="ErrMsg"></param>
        /// <returns></returns>
        protected int UP_CAR_COMPANY_AR_LST(out string ErrMsg)
        {
            int lo_intRetVal = 9999;
            ErrMsg = string.Empty;
            IDasNetCom lo_objDas       = null;
            DataRow    lo_drRow        = null;
            string     lo_strComCorpNo = string.Empty;

            if (string.IsNullOrWhiteSpace(strComCode) || string.IsNullOrWhiteSpace(strCenterCode))
            {
                lo_intRetVal = 9998;
                ErrMsg       = "차량업체 정보를 조회하지 못했습니다.";
                return lo_intRetVal;
            }

            //차량 사업자 조회
            try
            {
                lo_objDas = new IDasNetCom();
                lo_objDas.Open(SiteGlobal.M_HOST_DAS_TMS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCOM_CODE", DBType.adBigInt,   strComCode,   0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCOM_NAME", DBType.adVarWChar, DBNull.Value, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCOM_CEO_NAME", DBType.adVarWChar, DBNull.Value, 50,
                    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCOM_CORP_NO", DBType.adVarChar, DBNull.Value, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPAGE_SIZE",   DBType.adInteger, 1,            0,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPAGE_NO",    DBType.adInteger, 1,            0, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRECORD_CNT", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_COMPANY_AR_LST");
                if (!lo_objDas.RecordCount.Equals(1) || !lo_objDas.LastErrorCode.Equals(0))
                {
                    ErrMsg = "차량업체 정보를 조회하지 못했습니다.";
                    return lo_intRetVal;
                }

                lo_drRow        = lo_objDas.objDT.Select()[0];
                lo_strComCorpNo = lo_drRow["COM_CORP_NO"].ToString();
                EncCorpNo.Value = SiteGlobal.GetEncrypt(lo_strComCorpNo + DateTime.Now.ToString("yyyyMMddHHmmss"));
            }
            catch (Exception lo_ex)
            {
                ErrMsg = "차량업체 정보를 조회하지 못했습니다.";
                SiteGlobal.WriteLog(
                    "SMS-Cargopay",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9001);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }
            }

            if (string.IsNullOrWhiteSpace(lo_strComCorpNo))
            {
                lo_intRetVal = 9997;
                ErrMsg       = "차량업체 정보를 조회하지 못했습니다.";
                return lo_intRetVal;
            }

            lo_intRetVal = 0;
            ErrMsg       = string.Empty;

            return lo_intRetVal;
        }

        protected int UP_ORDER_SEND_ORDER_AR_LST(out string ErrMsg)
        {
            ErrMsg = string.Empty;
            int        lo_intRetVal       = 9999;
            IDasNetCom lo_objDas          = null;
            DataRow    lo_drRow           = null;
            string     lo_strClosingSeqNo = SiteGlobal.GetDecrypt(EncClosingSeqNo.Value);
            string     lo_strCenterCode   = SiteGlobal.GetDecrypt(EncCenterCode.Value);
            string     lo_strCorpNo       = SiteGlobal.GetDecrypt(EncCorpNo.Value);
            string     lo_strSendPlanDate = string.Empty;
            string     lo_strPostData     = string.Empty;
            string     lo_strJsonData     = string.Empty;

            try
            {

                lo_strClosingSeqNo = lo_strClosingSeqNo.Substring(0, lo_strClosingSeqNo.Length - 14);
                lo_strCenterCode   = lo_strCenterCode.Substring(0, lo_strCenterCode.Length - 14);
                lo_strCorpNo       = lo_strCorpNo.Substring(0, lo_strCorpNo.Length - 14);

                if (string.IsNullOrWhiteSpace(lo_strClosingSeqNo) || string.IsNullOrWhiteSpace(lo_strCenterCode))
                {
                    lo_intRetVal = 9901;
                    ErrMsg       = "전표 정보 조회에 필요한 값이 없습니다.";
                    return lo_intRetVal;
                }

                lo_objDas = new IDasNetCom();
                lo_objDas.Open(SiteGlobal.M_HOST_DAS_TMS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strCLOSING_SEQ_NO", DBType.adVarChar, lo_strClosingSeqNo, 30,
                    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCENTER_CODE", DBType.adBigInt, lo_strCenterCode, 0,
                    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strACCESS_CENTER_CODE", DBType.adVarChar, lo_strCenterCode, 512,
                    ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_SEND_BILL_NT_GET");
                if (!lo_objDas.RecordCount.Equals(1) || !lo_objDas.LastErrorCode.Equals(0))
                {
                    lo_intRetVal = 9902;
                    ErrMsg       = "계산서 정보를 조회하지 못했습니다.";
                    return lo_intRetVal;
                }

                lo_drRow = lo_objDas.objDT.Select()[0];
                if (!lo_strCorpNo.Equals(lo_drRow["COM_CORP_NO"].ToString()))
                {
                    lo_intRetVal = 9903;
                    ErrMsg       = "계산서 정보를 조회하지 못했습니다.";
                    return lo_intRetVal;
                }

                lo_strSendPlanDate = lo_drRow["SEND_PLAN_YMD"].ToString();

                //빠른입금이 선택된 경우
                if (!lo_drRow["PAY_SEND_TYPE"].ToString().Equals("2"))
                {
                    lo_intRetVal = 9994;
                    ErrMsg       = "빠른입금 신청된 전표가 아닙니다.";
                    return lo_intRetVal;
                }

                LitOrgAmt.Text    = SiteGlobal.ConvertMoneyFormat(lo_drRow["ORG_AMT"].ToString());
                LitDeductAmt.Text = SiteGlobal.ConvertMoneyFormat(lo_drRow["DEDUCT_AMT"].ToString());
                LitSendAmt.Text   = SiteGlobal.ConvertMoneyFormat(lo_drRow["SEND_AMT"].ToString());
                if (Convert.ToInt64(lo_drRow["DEDUCT_AMT"].ToString()) <= 0)
                {
                    TrDeductInfo1.Visible = false;
                    TrDeductInfo2.Visible = false;
                }

                //카고페이 오더 체크
                lo_strPostData =  "CenterID=" + Server.HtmlEncode(lo_drRow["CENTER_ID"].ToString());
                lo_strPostData += "&CenterKey=" + Server.HtmlEncode(lo_drRow["CENTER_KEY"].ToString());
                lo_strPostData += "&ClosingSeqNo=" + Server.HtmlEncode(lo_drRow["CLOSING_SEQ_NO"].ToString());
                lo_intRetVal = SiteGlobal.CallWebServicePost(SiteGlobal.M_WS_DOMAIN + "/GetCenterOrderChk",
                    lo_strPostData, out lo_strJsonData);

                Res_GetCenterOrderChk res = JsonConvert.DeserializeObject<Res_GetCenterOrderChk>(lo_strJsonData);

                if (!lo_intRetVal.Equals(0) || !res.RetCode.Equals(0))
                {
                    lo_intRetVal = 9997;
                    ErrMsg       = "카고페이에 신청된 전표 정보를 조회하지 못했습니다.";
                    return lo_intRetVal;
                }

                LitResultAmt.Text     = SiteGlobal.ConvertMoneyFormat(res.SendAmt.ToString());
                LitResultAmtView.Text = SiteGlobal.ConvertMoneyFormat(res.SendAmt.ToString());
                LitRateAmt.Text       = SiteGlobal.ConvertMoneyFormat(res.SendFee.ToString());
                LitRatePer.Text       = res.SendFeeRate + " %";

                lo_intRetVal = 0;
                ErrMsg       = string.Empty;
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "SMS-Cargopay",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9001);
                ErrMsg = "오더 정보를 조회하지 못했습니다.";
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }
            }

            return lo_intRetVal;
        }

        /// <summary>
        /// 카드결제 동의 정보
        /// </summary>
        /// <returns></returns>
        protected int GetCardAgreeInfo(out string strErrMsg)
        {
            strErrMsg = string.Empty;
            int                 lo_intRetVal              = 9999;
            string              lo_strCorpNo              = string.Empty;
            ResGetCardAgreeInfo lo_objResGetCardAgreeInfo = null;

            try
            {
                lo_strCorpNo = SiteGlobal.GetDecrypt(EncCorpNo.Value);
                if (string.IsNullOrWhiteSpace(lo_strCorpNo) || lo_strCorpNo.Length <= 10)
                {
                    strErrMsg = "필요한 값이 없습니다";
                    return lo_intRetVal;
                }

                lo_strCorpNo = lo_strCorpNo.Substring(0, lo_strCorpNo.Length - 14);

                lo_objResGetCardAgreeInfo = SiteGlobal.GetCardAgreeInfo(lo_strCorpNo, out lo_intRetVal, out strErrMsg);

                if (!lo_intRetVal.Equals(0))
                {
                    return lo_intRetVal;
                }

                strCardAgreeExistsFlag = lo_objResGetCardAgreeInfo.ExistsFlag;

                lo_intRetVal = 0;
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9001;
                SiteGlobal.WriteLog(
                    "SMS-Cargopay",
                    "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9001);
            }

            return lo_intRetVal;
        }
        */
    }
}