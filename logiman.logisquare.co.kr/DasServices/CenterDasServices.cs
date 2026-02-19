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
    public class CenterDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        public ServiceResult<ResCenterList> GetCenterList(ReqCenterList objReqCenterList)
        {
            SiteGlobal.WriteInformation("CenterDasServices", "I", $"[GetCenterList REQ] {JsonConvert.SerializeObject(objReqCenterList)}", bLogWrite);

            string                       lo_strJson   = string.Empty;
            ServiceResult<ResCenterList> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCenterList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,  objReqCenterList.CenterCode, 0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterType", DBType.adTinyInt,  objReqCenterList.CenterType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCorpNo",     DBType.adVarChar,  objReqCenterList.CorpNo,     20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterName", DBType.adVarChar,  objReqCenterList.CenterName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarWChar, objReqCenterList.AdminID,    50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",   DBType.adInteger,  objReqCenterList.PageSize,   0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",     DBType.adInteger,  objReqCenterList.PageNo,     0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger,  DBNull.Value,                0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CENTER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCenterList
                {
                    list = new List<CenterViewModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CenterViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCenterList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CenterDasServices", "I", $"[GetCenterList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<CenterViewModel> InsCenter(CenterViewModel objInsCenter)
        {
            SiteGlobal.WriteInformation("CenterDasServices", "I", $"[InsCenter REQ] {JsonConvert.SerializeObject(objInsCenter)}", bLogWrite);

            ServiceResult<CenterViewModel> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<CenterViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,       objInsCenter.CenterCode,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterID",       DBType.adVarChar,       objInsCenter.CenterID,         10,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterKey",      DBType.adVarChar,       objInsCenter.CenterKey,        256,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterName",     DBType.adVarWChar,      objInsCenter.CenterName,       50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCorpNo",         DBType.adVarChar,       objInsCenter.CorpNo,           20,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCeoName",        DBType.adVarWChar,      objInsCenter.CeoName,          30,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBizType",        DBType.adVarWChar,      objInsCenter.BizType,          40,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBizClass",       DBType.adVarWChar,      objInsCenter.BizClass,         40,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTelNo",          DBType.adVarChar,       objInsCenter.TelNo,            20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFaxNo",          DBType.adVarChar,       objInsCenter.FaxNo,            20,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strEmail",          DBType.adVarWChar,      objInsCenter.Email,            100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddrPost",       DBType.adVarChar,       objInsCenter.AddrPost,         10,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddr",           DBType.adVarWChar,      objInsCenter.Addr,             256,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHeadCenterCodes", DBType.adVarChar,      objInsCenter.HeadCenterCodes,  4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransSaleRate",  DBType.adDouble,        objInsCenter.TransSaleRate,    0,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intCenterType",     DBType.adTinyInt,       objInsCenter.CenterType,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderType",      DBType.adTinyInt,       objInsCenter.OrderType,        0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBankCode",       DBType.adVarChar,       objInsCenter.BankCode,         3,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBankName",       DBType.adVarWChar,      objInsCenter.BankName,         50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEncAcctNo",      DBType.adVarChar,       objInsCenter.EncAcctNo,        256,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strSearchAcctNo",   DBType.adVarChar,       objInsCenter.SearchAcctNo,     4,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcctName",       DBType.adVarWChar,      objInsCenter.AcctName,         50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcctValidFlag",  DBType.adChar,          objInsCenter.AcctValidFlag,    1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterNote",     DBType.adVarWChar,      objInsCenter.CenterNote,       500,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strContractFlag",   DBType.adChar,          objInsCenter.ContractFlag,     1,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUseFlag",        DBType.adChar,          objInsCenter.UseFlag,          1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,       objInsCenter.RegAdminID,       50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,       DBNull.Value,                  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,       DBNull.Value,                  0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,       DBNull.Value,                  256,  ParameterDirection.Output);
                                                                                                                   
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,       DBNull.Value,                  0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CENTER_TX_INS");

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

                lo_objResult.data = objInsCenter;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert center)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CenterDasServices", "I", $"[InsCenter RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> UpdCenter(CenterViewModel objUpdCenter)
        {
            SiteGlobal.WriteInformation("CenterDasServices", "I", $"[UpdCenter REQ] {JsonConvert.SerializeObject(objUpdCenter)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;


                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   objUpdCenter.CenterCode,       0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterID",         DBType.adVarChar,   objUpdCenter.CenterID,         10,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterKey",        DBType.adVarChar,   objUpdCenter.CenterKey,        256,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterName",       DBType.adVarWChar,  objUpdCenter.CenterName,       50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCorpNo",           DBType.adVarChar,   objUpdCenter.CorpNo,           20,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCeoName",          DBType.adVarWChar,  objUpdCenter.CeoName,          30,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBizType",          DBType.adVarWChar,  objUpdCenter.BizType,          40,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBizClass",         DBType.adVarWChar,  objUpdCenter.BizClass,         40,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTelNo",            DBType.adVarChar,   objUpdCenter.TelNo,            20,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFaxNo",            DBType.adVarChar,   objUpdCenter.FaxNo,            20,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strEmail",            DBType.adVarWChar,  objUpdCenter.Email,            100,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddrPost",         DBType.adVarChar,   objUpdCenter.AddrPost,         10,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddr",             DBType.adVarWChar,  objUpdCenter.Addr,             256,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHeadCenterCodes",  DBType.adVarChar,   objUpdCenter.HeadCenterCodes,  4000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransSaleRate",    DBType.adDouble,    objUpdCenter.TransSaleRate,    0,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intCenterType",       DBType.adTinyInt,   objUpdCenter.CenterType,       0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBankCode",         DBType.adVarChar,   objUpdCenter.BankCode,         3,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBankName",         DBType.adVarWChar,  objUpdCenter.BankName,         50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEncAcctNo",        DBType.adVarChar,   objUpdCenter.EncAcctNo,        256,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchAcctNo",     DBType.adVarChar,   objUpdCenter.SearchAcctNo,     4,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAcctName",         DBType.adVarWChar,  objUpdCenter.AcctName,         50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcctValidFlag",    DBType.adChar,      objUpdCenter.AcctValidFlag,    1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCenterNote",       DBType.adVarWChar,  objUpdCenter.CenterNote,       500,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strContractFlag",     DBType.adChar,      objUpdCenter.ContractFlag,     1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,      objUpdCenter.UseFlag,          1,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminID",          DBType.adVarChar,   objUpdCenter.UpdAdminID,       50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,   DBNull.Value,                  256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,   DBNull.Value,                  0,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,   DBNull.Value,                  256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,   DBNull.Value,                  0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CENTER_TX_UPD");

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
                                     , 9101, "System error(fail to update center)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CenterDasServices", "I", $"[UpdCenter RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 계열사 목록
        /// </summary>
        /// <param name="objReqCenterFranchiseList"></param>
        /// <returns></returns>
        public ServiceResult<ResCenterFranchiseList> GetCenterFranchiseList(ReqCenterFranchiseList objReqCenterFranchiseList)
        {
            SiteGlobal.WriteInformation("CenterDasServices", "I", $"[GetCenterFranchiseList REQ] {JsonConvert.SerializeObject(objReqCenterFranchiseList)}", bLogWrite);
            
            string                                lo_strJson   = string.Empty;
            ServiceResult<ResCenterFranchiseList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCenterFranchiseList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqCenterFranchiseList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqCenterFranchiseList.AccessCenterCode,   4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intHeadCenterCode",     DBType.adInteger,   objReqCenterFranchiseList.HeadCenterCode,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddHeadFlag",        DBType.adChar,      objReqCenterFranchiseList.AddHeadFlag,        1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAddBranchFlag",      DBType.adChar,      objReqCenterFranchiseList.AddBranchFlag,      1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAddContractFlag",    DBType.adChar,      objReqCenterFranchiseList.AddContractFlag,    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CENTER_FRANCHISE_DR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCenterFranchiseList
                {
                    list = new List<CenterViewModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CenterViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCenterFranchiseList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CenterDasServices", "I", $"[GetCenterFranchiseList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}