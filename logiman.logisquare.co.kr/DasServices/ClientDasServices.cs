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
    public class ClientDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 고객사 목록
        /// </summary>
        /// <param name="objReqClientList"></param>
        /// <returns></returns>
        public ServiceResult<ResClientList> GetClientList(ReqClientList objReqClientList)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[GetClientList REQ] {JsonConvert.SerializeObject(objReqClientList)}", bLogWrite);
            
            string                       lo_strJson   = string.Empty;
            ServiceResult<ResClientList> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",          DBType.adBigInt,   objReqClientList.ClientCode,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,  objReqClientList.CenterCode,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",          DBType.adVarWChar, objReqClientList.ClientName,          50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientType",          DBType.adVarChar,  objReqClientList.ClientType,          5,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCeoName",       DBType.adVarWChar, objReqClientList.ClientCeoName,       50,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientCorpNo",        DBType.adVarChar,  objReqClientList.ClientCorpNo,        20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSaleLimitAmtFlag",    DBType.adChar,     objReqClientList.SaleLimitAmtFlag,    1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRevenueLimitPerFlag", DBType.adChar,     objReqClientList.RevenueLimitPerFlag, 1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",             DBType.adChar,     objReqClientList.UseFlag,             1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,  objReqClientList.AccessCenterCode,    512, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,  objReqClientList.PageSize,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,  objReqClientList.PageNo,              0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,  DBNull.Value,                         0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientList
                {
                    list      = new List<ClientModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("ClientAcctNo", typeof(string));
                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["ClientAcctNo"] = CommonUtils.Utils.GetDecrypt(row["ClientEncAcctNo"].ToString());
                    }

                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[GetClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사 등록
        /// </summary>
        /// <param name="objClientModel"></param>
        /// <returns></returns>
        public ServiceResult<ClientModel> SetClientIns(ClientModel objClientModel)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientIns REQ] {JsonConvert.SerializeObject(objClientModel)}", bLogWrite);

            ServiceResult<ClientModel> lo_objResult = null;
            IDasNetCom                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ClientModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",               DBType.adInteger,             objClientModel.CenterCode,                 0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientType",               DBType.adVarChar,             objClientModel.ClientType,                 5,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",               DBType.adVarWChar,            objClientModel.ClientName,                 50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCeoName",            DBType.adVarWChar,            objClientModel.ClientCeoName,              50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCorpNo",             DBType.adVarChar,             objClientModel.ClientCorpNo,               20,     ParameterDirection.Input);
                                                                                                                                               
                lo_objDas.AddParam("@pi_strClientBizType",            DBType.adVarWChar,            objClientModel.ClientBizType,              100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientBizClass",           DBType.adVarWChar,            objClientModel.ClientBizClass,             100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientTelNo",              DBType.adVarChar,             objClientModel.ClientTelNo,                20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientFaxNo",              DBType.adVarChar,             objClientModel.ClientFaxNo,                20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientEmail",              DBType.adVarChar,             objClientModel.ClientEmail,                256,    ParameterDirection.Input);
                                                                                                                                               
                lo_objDas.AddParam("@pi_strClientPost",               DBType.adVarChar,             objClientModel.ClientPost,                 6,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientAddr",               DBType.adVarWChar,            objClientModel.ClientAddr,                 100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientAddrDtl",            DBType.adVarWChar,            objClientModel.ClientAddrDtl,              100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientStatus",             DBType.adTinyInt,             objClientModel.ClientStatus,               0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCloseYMD",           DBType.adVarChar,             objClientModel.ClientCloseYMD,             8,      ParameterDirection.Input);
                                                                                                                                               
                lo_objDas.AddParam("@pi_strClientUpdYMD",             DBType.adVarChar,             objClientModel.ClientUpdYMD,               8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientTaxKind",            DBType.adTinyInt,             objClientModel.ClientTaxKind,              0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientTaxMsg",             DBType.adVarWChar,            objClientModel.ClientTaxMsg,               50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCheckYMD",           DBType.adVarChar,             objClientModel.ClientCheckYMD,             8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientClosingType",        DBType.adTinyInt,             objClientModel.ClientClosingType,          0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientPayDay",             DBType.adVarWChar,            objClientModel.ClientPayDay,               20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientBusinessStatus",     DBType.adTinyInt,             objClientModel.ClientBusinessStatus,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientDMPost",             DBType.adVarChar,             objClientModel.ClientDMPost,               6,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientDMAddr",             DBType.adVarWChar,            objClientModel.ClientDMAddr,               100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientDMAddrDtl",          DBType.adVarWChar,            objClientModel.ClientDMAddrDtl,            100,    ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strClientFPISFlag",           DBType.adChar,                objClientModel.ClientFPISFlag,             1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientBankCode",           DBType.adVarChar,             objClientModel.ClientBankCode,             3,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientEncAcctNo",          DBType.adVarChar,             objClientModel.ClientEncAcctNo,            256,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientSearchAcctNo",       DBType.adVarChar,             objClientModel.ClientSearchAcctNo,         10,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientAcctName",           DBType.adVarWChar,            objClientModel.ClientAcctName,             50,     ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intTransCenterCode",          DBType.adInteger,             objClientModel.TransCenterCode,            0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientNote1",              DBType.adVarWChar,            objClientModel.ClientNote1,                1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientNote2",              DBType.adVarWChar,            objClientModel.ClientNote2,                1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientNote3",              DBType.adVarWChar,            objClientModel.ClientNote3,                1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientNote4",              DBType.adVarWChar,            objClientModel.ClientNote4,                1000,   ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intSaleLimitAmt",             DBType.adCurrency,            objClientModel.SaleLimitAmt,               0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRevenueLimitPer",          DBType.adCurrency,            objClientModel.RevenueLimitPer,            0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDouzoneCode",              DBType.adVarChar,             objClientModel.DouzoneCode,                50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                  DBType.adVarChar,             objClientModel.RegAdminID,                 50,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intClientCode",               DBType.adBigInt,              DBNull.Value,                              0,      ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                   DBType.adVarChar,             DBNull.Value,                              256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                   DBType.adInteger,             DBNull.Value,                              0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                 DBType.adVarChar,             DBNull.Value,                              256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                 DBType.adInteger,             DBNull.Value,                              0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_TX_INS");


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
                objClientModel.ClientCode = lo_objDas.GetParam("@po_intClientCode").ToInt();

                lo_objResult.data = objClientModel;
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

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 고객사 수정
        /// </summary>
        /// <param name="objClientModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetClientUpd(ClientModel objClientModel)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientUpd REQ] {JsonConvert.SerializeObject(objClientModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",               DBType.adBigInt,              objClientModel.ClientCode,                 0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",               DBType.adInteger,             objClientModel.CenterCode,                 0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientType",               DBType.adVarChar,             objClientModel.ClientType,                 5,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",               DBType.adVarWChar,            objClientModel.ClientName,                 50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCeoName",            DBType.adVarWChar,            objClientModel.ClientCeoName,              50,     ParameterDirection.Input);
                                                                                                    
                lo_objDas.AddParam("@pi_strClientBizType",            DBType.adVarWChar,            objClientModel.ClientBizType,              100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientBizClass",           DBType.adVarWChar,            objClientModel.ClientBizClass,             100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientTelNo",              DBType.adVarChar,             objClientModel.ClientTelNo,                20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientFaxNo",              DBType.adVarChar,             objClientModel.ClientFaxNo,                20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientEmail",              DBType.adVarChar,             objClientModel.ClientEmail,                256,    ParameterDirection.Input);
                                                                                                    
                lo_objDas.AddParam("@pi_strClientPost",               DBType.adVarChar,             objClientModel.ClientPost,                 6,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientAddr",               DBType.adVarWChar,            objClientModel.ClientAddr,                 100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientAddrDtl",            DBType.adVarWChar,            objClientModel.ClientAddrDtl,              100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientClosingType",        DBType.adTinyInt,             objClientModel.ClientClosingType,          0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientPayDay",             DBType.adVarWChar,            objClientModel.ClientPayDay,               20,     ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intClientBusinessStatus",     DBType.adTinyInt,             objClientModel.ClientBusinessStatus,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientDMPost",             DBType.adVarChar,             objClientModel.ClientDMPost,               6,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientDMAddr",             DBType.adVarWChar,            objClientModel.ClientDMAddr,               100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientDMAddrDtl",          DBType.adVarWChar,            objClientModel.ClientDMAddrDtl,            100,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientFPISFlag",           DBType.adChar,                objClientModel.ClientFPISFlag,             1,      ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strClientBankCode",           DBType.adVarChar,             objClientModel.ClientBankCode,             3,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientEncAcctNo",          DBType.adVarChar,             objClientModel.ClientEncAcctNo,            256,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientSearchAcctNo",       DBType.adVarChar,             objClientModel.ClientSearchAcctNo,         10,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientAcctName",           DBType.adVarWChar,            objClientModel.ClientAcctName,             50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransCenterCode",          DBType.adInteger,             objClientModel.TransCenterCode,            0,      ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strClientNote1",              DBType.adVarWChar,            objClientModel.ClientNote1,                1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientNote2",              DBType.adVarWChar,            objClientModel.ClientNote2,                1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientNote3",              DBType.adVarWChar,            objClientModel.ClientNote3,                1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientNote4",              DBType.adVarWChar,            objClientModel.ClientNote4,                1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleLimitAmt",             DBType.adCurrency,            objClientModel.SaleLimitAmt,               0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intRevenueLimitPer",          DBType.adCurrency,            objClientModel.RevenueLimitPer,            0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDouzoneCode",              DBType.adVarChar,             objClientModel.DouzoneCode,                50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",                  DBType.adChar,                objClientModel.UseFlag,                    1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                  DBType.adVarChar,             objClientModel.UpdAdminID,                 50,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                   DBType.adVarChar,             DBNull.Value,                              256,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",                   DBType.adInteger,             DBNull.Value,                              0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                 DBType.adVarChar,             DBNull.Value,                              256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                 DBType.adInteger,             DBNull.Value,                              0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_TX_UPD");


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

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        
        /// <summary>
        /// 고객사 담당자 목록
        /// </summary>
        /// <param name="objReqClientChargeList"></param>
        /// <returns></returns>
        public ServiceResult<ResClientChargeList> GetClientChargeList(ReqClientChargeList objReqClientChargeList)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[GetClientChargeList REQ] {JsonConvert.SerializeObject(objReqClientChargeList)}", bLogWrite);
            
            string                             lo_strJson   = string.Empty;
            ServiceResult<ResClientChargeList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientChargeList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intChargeSeqNo",        DBType.adBigInt,     objReqClientChargeList.ChargeSeqNo,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,     objReqClientChargeList.ClientCode,         0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,    objReqClientChargeList.CenterCode,         0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,       objReqClientChargeList.UseFlag,            1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",         DBType.adVarWChar,   objReqClientChargeList.ChargeName,         50,     ParameterDirection.Input);
                                                                                              
                lo_objDas.AddParam("@pi_strChargeCell",         DBType.adVarChar,    objReqClientChargeList.ChargeCell,         20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelNo",        DBType.adVarChar,    objReqClientChargeList.ChargeTelNo,        20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderFlag",          DBType.adChar,       objReqClientChargeList.OrderFlag,          1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayFlag",            DBType.adChar,       objReqClientChargeList.PayFlag,            1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalFlag",        DBType.adChar,       objReqClientChargeList.ArrivalFlag,        1,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBillFlag",           DBType.adChar,       objReqClientChargeList.BillFlag,           1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,    objReqClientChargeList.AccessCenterCode,   512,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,    objReqClientChargeList.PageSize,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,    objReqClientChargeList.PageNo,             0,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,    DBNull.Value,                              0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CHARGE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientChargeList
                {
                    list = new List<ClientChargeModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientChargeModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientChargeList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[GetClientChargeList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 고객사 담당자 등록
        /// </summary>
        /// <param name="objClientChargeModel"></param>
        /// <returns></returns>
        public ServiceResult<ClientChargeModel> SetClientChargeIns(ClientChargeModel objClientChargeModel)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientChargeIns REQ] {JsonConvert.SerializeObject(objClientChargeModel)}", bLogWrite);

            ServiceResult<ClientChargeModel> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ClientChargeModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",           DBType.adBigInt,      objClientChargeModel.ClientCode,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,     objClientChargeModel.CenterCode,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",           DBType.adVarWChar,    objClientChargeModel.ChargeName,           50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeCell",           DBType.adVarChar,     objClientChargeModel.ChargeCell,           20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelNo",          DBType.adVarChar,     objClientChargeModel.ChargeTelNo,          20,     ParameterDirection.Input);
                                                                                                                                   
                lo_objDas.AddParam("@pi_strChargeTelExtNo",       DBType.adVarChar,     objClientChargeModel.ChargeTelExtNo,       20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeFaxNo",          DBType.adVarChar,     objClientChargeModel.ChargeFaxNo,          20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeEmail",          DBType.adVarChar,     objClientChargeModel.ChargeEmail,          256,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargePosition",       DBType.adVarWChar,    objClientChargeModel.ChargePosition,       50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeDepartment",     DBType.adVarWChar,    objClientChargeModel.ChargeDepartment,     50,     ParameterDirection.Input);
                                                                                                                                   
                lo_objDas.AddParam("@pi_strChargeLocation",       DBType.adVarWChar,    objClientChargeModel.ChargeLocation,       50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderFlag",            DBType.adChar,        objClientChargeModel.OrderFlag,            1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayFlag",              DBType.adChar,        objClientChargeModel.PayFlag,              1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalFlag",          DBType.adChar,        objClientChargeModel.ArrivalFlag,          1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillFlag",             DBType.adChar,        objClientChargeModel.BillFlag,             1,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUseFlag",              DBType.adChar,        objClientChargeModel.UseFlag,              1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",           DBType.adVarChar,     objClientChargeModel.RegAdminID,           50,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intChargeSeqNo",          DBType.adBigInt,      DBNull.Value,                              0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",               DBType.adVarChar,     DBNull.Value,                              256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",               DBType.adInteger,     DBNull.Value,                              0,      ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",             DBType.adVarChar,     DBNull.Value,                              256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",             DBType.adInteger,     DBNull.Value,                              0,      ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_CLIENT_CHARGE_TX_INS");
                
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
                objClientChargeModel.ChargeSeqNo = lo_objDas.GetParam("@po_intChargeSeqNo").ToInt();

                lo_objResult.data = objClientChargeModel;
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

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientChargeIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 고객사 담당자 수정
        /// </summary>
        /// <param name="objClientChargeModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetClientChargeUpd(ClientChargeModel objClientChargeModel)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientChargeUpd REQ] {JsonConvert.SerializeObject(objClientChargeModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intChargeSeqNo",       DBType.adBigInt,     objClientChargeModel.ChargeSeqNo,       0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",        DBType.adVarWChar,   objClientChargeModel.ChargeName,        50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeCell",        DBType.adVarChar,    objClientChargeModel.ChargeCell,        20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelNo",       DBType.adVarChar,    objClientChargeModel.ChargeTelNo,       20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelExtNo",    DBType.adVarChar,    objClientChargeModel.ChargeTelExtNo,    20,     ParameterDirection.Input);
                                                                                                                            
                lo_objDas.AddParam("@pi_strChargeFaxNo",       DBType.adVarChar,    objClientChargeModel.ChargeFaxNo,       20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeEmail",       DBType.adVarChar,    objClientChargeModel.ChargeEmail,       256,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargePosition",    DBType.adVarWChar,   objClientChargeModel.ChargePosition,    50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeDepartment",  DBType.adVarWChar,   objClientChargeModel.ChargeDepartment,  50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeLocation",    DBType.adVarWChar,   objClientChargeModel.ChargeLocation,    50,     ParameterDirection.Input);
                                                                                                                            
                lo_objDas.AddParam("@pi_strOrderFlag",         DBType.adChar,       objClientChargeModel.OrderFlag,         1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayFlag",           DBType.adChar,       objClientChargeModel.PayFlag,           1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalFlag",       DBType.adChar,       objClientChargeModel.ArrivalFlag,       1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillFlag",          DBType.adChar,       objClientChargeModel.BillFlag,          1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",           DBType.adChar,       objClientChargeModel.UseFlag,           1,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUpdAdminID",        DBType.adVarChar,    objClientChargeModel.UpdAdminID,        50,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,    DBNull.Value,                           256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,    DBNull.Value,                           0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,    DBNull.Value,                           256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,    DBNull.Value,                           0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CHARGE_TX_UPD");


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

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientChargeUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사 담당자 삭제
        /// </summary>
        /// <param name="intClientChargeSeqNo"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetClientChargeDel(int intClientChargeSeqNo)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientChargeDel REQ] {intClientChargeSeqNo}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intChargeSeqNo",       DBType.adBigInt,     intClientChargeSeqNo,  0,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,    DBNull.Value,          256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,    DBNull.Value,          0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,    DBNull.Value,          256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,    DBNull.Value,          0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CHARGE_TX_DEL");


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

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientChargeDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사 - 화주 연결 목록
        /// </summary>
        /// <param name="objReqClientConsignorList"></param>
        /// <returns></returns>
        public ServiceResult<ResClientConsignorList> GetClientConsignorList(ReqClientConsignorList objReqClientConsignorList)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[GetClientConsignorList REQ] {JsonConvert.SerializeObject(objReqClientConsignorList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResClientConsignorList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientConsignorList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",              DBType.adBigInt,     objReqClientConsignorList.SeqNo,              0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,    objReqClientConsignorList.CenterCode,         0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,     objReqClientConsignorList.ClientCode,         0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,   objReqClientConsignorList.ClientName,         50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",      DBType.adBigInt,     objReqClientConsignorList.ConsignorCode,      0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strConsignorName",      DBType.adVarWChar,   objReqClientConsignorList.ConsignorName,      50,     ParameterDirection.Input);                                                                             
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,    objReqClientConsignorList.AccessCenterCode,   512,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,       objReqClientConsignorList.DelFlag,            1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,    objReqClientConsignorList.PageSize,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,    objReqClientConsignorList.PageNo,             0,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,    DBNull.Value,                                 0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CONSIGNOR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientConsignorList
                {
                    list = new List<ClientConsignorModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("EncSeqNo", typeof(string));

                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["EncSeqNo"] = CommonUtils.Utils.GetEncrypt(row["SeqNo"].ToString()); 
                    }

                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientConsignorModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientConsignorList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[GetClientConsignorList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 고객사 - 화주 연결정보 등록
        /// </summary>
        /// <param name="objClientConsignorModel"></param>
        /// <returns></returns>
        public ServiceResult<ClientConsignorModel> SetClientConsignorIns(ClientConsignorModel objClientConsignorModel)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientConsignorIns REQ] {JsonConvert.SerializeObject(objClientConsignorModel)}", bLogWrite);

            ServiceResult<ClientConsignorModel> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ClientConsignorModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",           DBType.adBigInt,      objClientConsignorModel.ClientCode,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,     objClientConsignorModel.CenterCode,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",        DBType.adBigInt,      objClientConsignorModel.ConsignorCode,     0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",           DBType.adVarChar,     objClientConsignorModel.RegAdminID,        50,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",                DBType.adBigInt,      DBNull.Value,                              0,      ParameterDirection.Output);
                
                lo_objDas.AddParam("@po_strErrMsg",               DBType.adVarChar,     DBNull.Value,                              256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",               DBType.adInteger,     DBNull.Value,                              0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",             DBType.adVarChar,     DBNull.Value,                              256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",             DBType.adInteger,     DBNull.Value,                              0,      ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_CLIENT_CONSIGNOR_TX_INS");
                
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
                objClientConsignorModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt();

                lo_objResult.data = objClientConsignorModel;
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

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientConsignorIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사 - 화주 연결정보 삭제
        /// </summary>
        /// <param name="intClientConsignorSeqNo"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetClientConsignorDel(int intClientConsignorSeqNo, string strAdminID)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientConsignorDel REQ] {intClientConsignorSeqNo}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",      DBType.adBigInt,  intClientConsignorSeqNo, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID", DBType.adVarChar, strAdminID,              50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar, DBNull.Value,            256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger, DBNull.Value,            0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar, DBNull.Value,            256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger, DBNull.Value,            0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CONSIGNOR_TX_DEL");


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

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientConsignorDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사 + 담당자 목록 검색(오더)
        /// </summary>
        /// <param name="objReqClientSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResClientSearchList> GetClientSearchList(ReqClientSearchList objReqClientSearchList)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[GetClientSearchList REQ] {JsonConvert.SerializeObject(objReqClientSearchList)}", bLogWrite);
            
            string                             lo_strJson   = string.Empty;
            ServiceResult<ResClientSearchList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",        DBType.adBigInt,   objReqClientSearchList.ClientCode,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,  objReqClientSearchList.CenterCode,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",        DBType.adVarWChar, objReqClientSearchList.ClientName,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientType",        DBType.adVarChar,  objReqClientSearchList.ClientType,        5,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCeoName",     DBType.adVarWChar, objReqClientSearchList.ClientCeoName,     50,  ParameterDirection.Input);
                                                                                                                             
                lo_objDas.AddParam("@pi_strClientCorpNo",      DBType.adVarChar,  objReqClientSearchList.ClientCorpNo,      20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",           DBType.adChar,     objReqClientSearchList.UseFlag,           1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",        DBType.adVarWChar, objReqClientSearchList.ChargeName,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeOrderFlag",   DBType.adChar,     objReqClientSearchList.ChargeOrderFlag,   1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargePayFlag",     DBType.adChar,     objReqClientSearchList.ChargePayFlag,     1,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strChargeArrivalFlag", DBType.adChar,     objReqClientSearchList.ChargeArrivalFlag, 1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeBillFlag",    DBType.adChar,     objReqClientSearchList.ChargeBillFlag,    1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeUseFlag",     DBType.adChar,     objReqClientSearchList.ChargeUseFlag,     1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientFlag",        DBType.adChar,     objReqClientSearchList.ClientFlag,        1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeFlag",        DBType.adChar,     objReqClientSearchList.ChargeFlag,        1,   ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,  objReqClientSearchList.AccessCenterCode,  512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,  objReqClientSearchList.PageSize,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,  objReqClientSearchList.PageNo,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,  DBNull.Value,                             0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientSearchList
                {
                    list      = new List<ClientSearchModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientSearchModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[GetClientSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 비고 수정/등록
        /// </summary>
        /// <param name="objReqClientNoteUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetClientNoteUpd(ReqClientNoteUpd objReqClientNoteUpd)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientNoteUpd REQ] {JsonConvert.SerializeObject(objReqClientNoteUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objReqClientNoteUpd.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",    DBType.adBigInt,    objReqClientNoteUpd.ClientCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode", DBType.adBigInt,    objReqClientNoteUpd.ConsignorCode,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intType",          DBType.adTinyInt,   objReqClientNoteUpd.Type,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",          DBType.adVarWChar,  objReqClientNoteUpd.Note,            1000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar,   objReqClientNoteUpd.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_NOTE_TX_UPD");

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
                                     , 9101, "System error(SetClientNoteUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientNoteUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사 미수 업데이트
        /// </summary>
        public ServiceResult<ResClientMisuUpd> SetClientMisuUpd(ReqClientMisuUpd objReqClientMisuUpd)
        {
            SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientMisuUpd REQ] {JsonConvert.SerializeObject(objReqClientMisuUpd)}", bLogWrite);

            ServiceResult<ResClientMisuUpd> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientMisuUpd>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",    DBType.adBigInt,    objReqClientMisuUpd.ClientCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objReqClientMisuUpd.CenterCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar,   objReqClientMisuUpd.AdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strMisuFlag",      DBType.adChar,      DBNull.Value,                      1,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTotalMisuAmt",  DBType.adCurrency,  DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intMisuAmt",       DBType.adCurrency,  DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intNoMatchingCnt", DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_MISU_TX_UPD");

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
                lo_objResult.data = new ResClientMisuUpd
                {
                    MisuFlag      = lo_objDas.GetParam("@po_strMisuFlag"),
                    TotalMisuAmt  = lo_objDas.GetParam("@po_intTotalMisuAmt").ToDouble(),
                    MisuAmt       = lo_objDas.GetParam("@po_intMisuAmt").ToDouble(),
                    NoMatchingCnt = lo_objDas.GetParam("@po_intNoMatchingCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetClientMisuUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientDasServices", "I", $"[SetClientMisuUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}