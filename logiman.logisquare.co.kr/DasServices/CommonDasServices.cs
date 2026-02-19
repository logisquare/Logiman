using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using Newtonsoft.Json;
using PBSDasNetCom;
using System;
using System.Collections.Generic;
using System.Data;

namespace CommonLibrary.DasServices
{
    public class CommonDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 은행 목록
        /// </summary>
        /// <param name="objReqBankList"></param>
        /// <returns></returns>
        public ServiceResult<ResBankList> GetBankList(ReqBankList objReqBankList)
        {
            SiteGlobal.WriteInformation("CommonDasServices", "I", $"[GetBankList REQ] {JsonConvert.SerializeObject(objReqBankList)}", bLogWrite);
            
            string                     lo_strJson   = string.Empty;
            ServiceResult<ResBankList> lo_objResult = null;
            IDasNetCom                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResBankList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strBankCode",      DBType.adVarChar,  objReqBankList.BankCode,    0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBankName",      DBType.adVarWChar, objReqBankList.BankName,    50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",      DBType.adInteger,  objReqBankList.PageSize,    0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",        DBType.adInteger,  objReqBankList.PageNo,      0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",     DBType.adInteger,  DBNull.Value,               0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_BANK_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResBankList
                {
                    list = new List<BankModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<BankModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetBankList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CommonDasServices", "I", $"[GetBankList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 휴대폰 실명 인증 로그 등록
        /// </summary>
        /// <param name="objMobileAuthLogModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetMobileAuthLogIns(MobileAuthLogModel objMobileAuthLogModel)
        {
            SiteGlobal.WriteInformation("CommonDasServices", "I", $"[SetMobileAuthLogIns REQ] {JsonConvert.SerializeObject(objMobileAuthLogModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strMobileNo",    DBType.adVarChar, objMobileAuthLogModel.MobileNo,   20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTryYMD",      DBType.adVarChar, objMobileAuthLogModel.TryYMD,     8,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTryCnt",      DBType.adInteger,   DBNull.Value,                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,   DBNull.Value,                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,   DBNull.Value,                   0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,   DBNull.Value,                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,   DBNull.Value,                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_MOBILE_AUTH_LOG_TX_INS");


                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                         , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert admin login log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CommonDasServices", "I", $"[SetMobileAuthLogIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 휴대폰 실명 인증 로그 리셋
        /// </summary>
        /// <param name="objMobileAuthLogModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetMobileAuthLogReset(MobileAuthLogModel objMobileAuthLogModel)
        {
            SiteGlobal.WriteInformation("CommonDasServices", "I", $"[SetMobileAuthLogReset REQ] {JsonConvert.SerializeObject(objMobileAuthLogModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strMobileNo",    DBType.adVarChar,   objMobileAuthLogModel.MobileNo,    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTryYMD",      DBType.adVarChar,   objMobileAuthLogModel.TryYMD,      8,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_MOBILE_AUTH_LOG_RESET_TX_UPD");


                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                         , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetMobileAuthLogReset)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CommonDasServices", "I", $"[SetMobileAuthLogReset RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 휴대폰 실명 인증 로그 조회
        /// </summary>
        /// <param name="objMobileAuthLogModel"></param>
        /// <returns></returns>
        public ServiceResult<MobileAuthLogModel> GetMobileAuthLog(MobileAuthLogModel objMobileAuthLogModel)
        {
            SiteGlobal.WriteInformation("CommonDasServices", "I", $"[GetMobileAuthLog REQ] {JsonConvert.SerializeObject(objMobileAuthLogModel)}", bLogWrite);

            ServiceResult<MobileAuthLogModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<MobileAuthLogModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strMobileNo",   DBType.adVarChar,   objMobileAuthLogModel.MobileNo,    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTryYMD",     DBType.adVarChar,   objMobileAuthLogModel.TryYMD,      8,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTryCnt",     DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intResetCnt",   DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strRegDate",    DBType.adVarChar,   DBNull.Value,                      20,      ParameterDirection.Output);

                lo_objDas.AddParam("@po_strUpdDate",    DBType.adVarChar,   DBNull.Value,                      20,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_MOBILE_AUTH_LOG_NT_GET");


                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                            , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRetVal").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRetVal").ToInt(), lo_objDas.GetParam("@po_strErrMsg")
                                         , lo_objDas.GetParam("@po_intDBRetVal").ToInt(), lo_objDas.GetParam("@po_strDBErrMsg"));
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                objMobileAuthLogModel.TryCnt   = lo_objDas.GetParam("@po_intTryCnt").ToInt();
                objMobileAuthLogModel.ResetCnt = lo_objDas.GetParam("@po_intResetCnt").ToInt();
                objMobileAuthLogModel.RegDate  = lo_objDas.GetParam("@po_strRegDate");
                objMobileAuthLogModel.UpdDate  = lo_objDas.GetParam("@po_strUpdDate");

                lo_objResult.data              = objMobileAuthLogModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetMobileAuthLog)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CommonDasServices", "I", $"[GetMobileAuthLog RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}