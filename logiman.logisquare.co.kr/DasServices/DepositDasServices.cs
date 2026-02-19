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
    public class DepositDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 선급금 예수금 목록
        /// </summary>
        /// <param name="objReqOrderAdvanceList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderAdvanceList> GetOrderAdvanceList(ReqOrderAdvanceList objReqOrderAdvanceList)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetOrderAdvanceList REQ] {JsonConvert.SerializeObject(objReqOrderAdvanceList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResOrderAdvanceList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderAdvanceList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intDepositClosingSeqNo",       DBType.adBigInt,    objReqOrderAdvanceList.DepositClosingSeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                DBType.adInteger,   objReqOrderAdvanceList.CenterCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                   DBType.adBigInt,    objReqOrderAdvanceList.OrderNo,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",                DBType.adBigInt,    objReqOrderAdvanceList.ClientCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayType",                   DBType.adTinyInt,   objReqOrderAdvanceList.PayType,                   0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDateType",                  DBType.adTinyInt,   objReqOrderAdvanceList.DateType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                  DBType.adVarChar,   objReqOrderAdvanceList.DateFrom,                  8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                    DBType.adVarChar,   objReqOrderAdvanceList.DateTo,                    8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",        DBType.adVarChar,   objReqOrderAdvanceList.OrderLocationCodes,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",            DBType.adVarChar,   objReqOrderAdvanceList.OrderItemCodes,            4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientName",           DBType.adVarWChar,  objReqOrderAdvanceList.OrderClientName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeName",     DBType.adVarWChar,  objReqOrderAdvanceList.OrderClientChargeName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",             DBType.adVarWChar,  objReqOrderAdvanceList.PayClientName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",       DBType.adVarWChar,  objReqOrderAdvanceList.PayClientChargeName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",   DBType.adVarWChar,  objReqOrderAdvanceList.PayClientChargeLocation,   50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strConsignorName",             DBType.adVarWChar,  objReqOrderAdvanceList.ConsignorName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcceptAdminName",           DBType.adVarWChar,  objReqOrderAdvanceList.AcceptAdminName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrgAmt",                    DBType.adCurrency,  objReqOrderAdvanceList.OrgAmt,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",                DBType.adVarWChar,  objReqOrderAdvanceList.ClientName,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDepositClientName",         DBType.adVarWChar,  objReqOrderAdvanceList.DepositClientName,         50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDepositAmt",                DBType.adCurrency,  objReqOrderAdvanceList.DepositAmt,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDepositNote",               DBType.adVarWChar,  objReqOrderAdvanceList.DepositNote,               500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",          DBType.adVarChar,   objReqOrderAdvanceList.AccessCenterCode,          512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",                  DBType.adInteger,   objReqOrderAdvanceList.PageSize,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                    DBType.adInteger,   objReqOrderAdvanceList.PageNo,                    0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",                 DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_ADVANCE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderAdvanceList
                {
                    list      = new List<OrderAdvanceGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderAdvanceGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderAdvanceList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetOrderAdvanceList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        
        /// <summary>
        /// 입금 목록
        /// </summary>
        /// <param name="objReqPayDepositList"></param>
        /// <returns></returns>
        public ServiceResult<ResPayDepositList> GetPayDepositList(ReqPayDepositList objReqPayDepositList)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetPayDepositList REQ] {JsonConvert.SerializeObject(objReqPayDepositList)}", bLogWrite);

            string                           lo_strJson   = string.Empty;
            ServiceResult<ResPayDepositList> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPayDepositList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intDepositClosingSeqNo",  DBType.adBigInt,    objReqPayDepositList.DepositClosingSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDepositSeqNo",         DBType.adBigInt,    objReqPayDepositList.DepositSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqPayDepositList.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",           DBType.adBigInt,    objReqPayDepositList.ClientCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",           DBType.adVarWChar,  objReqPayDepositList.ClientName,             50,      ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intDepositAmt",           DBType.adCurrency,  objReqPayDepositList.DepositAmt,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDepositTypes",         DBType.adVarChar,   objReqPayDepositList.DepositTypes,           4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",             DBType.adVarChar,   objReqPayDepositList.DateFrom,               8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",               DBType.adVarChar,   objReqPayDepositList.DateTo,                 8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",                 DBType.adVarChar,   objReqPayDepositList.Note,                   500,     ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strNoMatchingFlag",       DBType.adChar,      objReqPayDepositList.NoMatchingFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqPayDepositList.AccessCenterCode,       512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objReqPayDepositList.PageSize,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objReqPayDepositList.PageNo,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPayDepositList
                {
                    list      = new List<PayDepositGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PayDepositGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPayDepositList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetPayDepositList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 입금 등록
        /// </summary>
        /// <param name="objPayDepositModel"></param>
        /// <returns></returns>
        public ServiceResult<PayDepositModel> SetPayDepositIns(PayDepositModel objPayDepositModel)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayDepositIns REQ] {JsonConvert.SerializeObject(objPayDepositModel)}", bLogWrite);

            ServiceResult<PayDepositModel> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<PayDepositModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objPayDepositModel.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",           DBType.adBigInt,    objPayDepositModel.ClientCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",           DBType.adVarWChar,  objPayDepositModel.ClientName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdvanceSeqNos",        DBType.adVarChar,   objPayDepositModel.AdvanceSeqNos,       4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDepositType",          DBType.adTinyInt,   objPayDepositModel.DepositType,         0,       ParameterDirection.Input);
                                                                                                                              
                lo_objDas.AddParam("@pi_strInputYMD",             DBType.adVarChar,   objPayDepositModel.InputYMD,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInputYM",              DBType.adVarChar,   objPayDepositModel.InputYM,             6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAmt",                  DBType.adCurrency,  objPayDepositModel.Amt,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",                 DBType.adVarWChar,  objPayDepositModel.Note,                500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSaleClosingSeqNos",    DBType.adVarChar,   objPayDepositModel.SaleClosingSeqNos,   4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRegAdminID",           DBType.adVarChar,   objPayDepositModel.RegAdminID,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",         DBType.adVarWChar,  objPayDepositModel.RegAdminName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intDepositSeqNo",         DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDepositClosingSeqNo",  DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",               DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                                                                                                                              
                lo_objDas.AddParam("@po_intRetVal",               DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",             DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",             DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_TX_INS");

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
                objPayDepositModel.DepositSeqNo        = lo_objDas.GetParam("@po_intDepositSeqNo").ToInt64();
                objPayDepositModel.DepositClosingSeqNo = lo_objDas.GetParam("@po_intDepositClosingSeqNo").ToInt64();

                lo_objResult.data = objPayDepositModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetPayDepositIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayDepositIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 입금 수정
        /// </summary>
        /// <param name="objPayDepositModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPayDepositUpd(PayDepositModel objPayDepositModel)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayDepositUpd REQ] {JsonConvert.SerializeObject(objPayDepositModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objPayDepositModel.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDepositClosingSeqNo",  DBType.adBigInt,    objPayDepositModel.DepositClosingSeqNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDepositType",          DBType.adTinyInt,   objPayDepositModel.DepositType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInputYMD",             DBType.adVarChar,   objPayDepositModel.InputYMD,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInputYM",              DBType.adVarChar,   objPayDepositModel.InputYM,               6,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intAmt",                  DBType.adCurrency,  objPayDepositModel.Amt,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",                 DBType.adVarWChar,  objPayDepositModel.Note,                  500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",           DBType.adVarChar,   objPayDepositModel.UpdAdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",         DBType.adVarWChar,  objPayDepositModel.UpdAdminName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",               DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",               DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",             DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",             DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_TX_UPD");

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
                                     , 9101, "System error(SetPayDepositUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayDepositUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 입금 삭제
        /// </summary>
        /// <param name="objPayDepositModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPayDepositDel(PayDepositModel objPayDepositModel)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayDepositDel REQ] {JsonConvert.SerializeObject(objPayDepositModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objPayDepositModel.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDepositClosingSeqNos",  DBType.adVarChar,   objPayDepositModel.DepositClosingSeqNos,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",            DBType.adVarChar,   objPayDepositModel.DelAdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminName",          DBType.adVarWChar,  objPayDepositModel.DelAdminName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                                                                                                                                 
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_TX_DEL");

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
                                     , 9101, "System error(SetPayDepositDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayDepositDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 미수관리 - 고객사목록
        /// </summary>
        /// <param name="objReqDepositClientList"></param>
        /// <returns></returns>
        public ServiceResult<ResDepositClientList> GetDepositClientList(ReqDepositClientList objReqDepositClientList)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetDepositClientList REQ] {JsonConvert.SerializeObject(objReqDepositClientList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResDepositClientList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResDepositClientList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,    objReqDepositClientList.CenterCode,           0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",           DBType.adVarWChar,   objReqDepositClientList.ClientName,           50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminName",          DBType.adVarWChar,   objReqDepositClientList.CsAdminName,          50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsClosingAdminName",   DBType.adVarWChar,   objReqDepositClientList.CsClosingAdminName,   50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,    objReqDepositClientList.AccessCenterCode,     512,   ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_CLIENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResDepositClientList
                {
                    list      = new List<DepositClientGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<DepositClientGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetDepositClientList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetDepositClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 미수관리 - 총미수내역
        /// </summary>
        /// <param name="objReqDepositClientTotalList"></param>
        /// <returns></returns>
        public ServiceResult<ResDepositClientTotalList> GetDepositClientTotalList(ReqDepositClientTotalList objReqDepositClientTotalList)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetDepositClientTotalList REQ] {JsonConvert.SerializeObject(objReqDepositClientTotalList)}", bLogWrite);

            string                                   lo_strJson   = string.Empty;
            ServiceResult<ResDepositClientTotalList> lo_objResult = null;
            IDasNetCom                               lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResDepositClientTotalList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;


                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqDepositClientTotalList.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",        DBType.adBigInt,    objReqDepositClientTotalList.ClientCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqDepositClientTotalList.AccessCenterCode,  512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_CLIENT_TOTAL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResDepositClientTotalList
                {
                    list      = new List<DepositClientTotalGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<DepositClientTotalGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetDepositClientTotalList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetDepositClientTotalList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 미수관리 - 매출마감내역
        /// </summary>
        /// <param name="objReqDepositClosingList"></param>
        /// <returns></returns>
        public ServiceResult<ResDepositClosingList> GetDepositClosingList(ReqDepositClosingList objReqDepositClosingList)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetDepositClosingList REQ] {JsonConvert.SerializeObject(objReqDepositClosingList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResDepositClosingList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResDepositClosingList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",  DBType.adBigInt,    objReqDepositClosingList.SaleClosingSeqNo,   0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",        DBType.adBigInt,    objReqDepositClosingList.ClientCode,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqDepositClosingList.CenterCode,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",          DBType.adTinyInt,   objReqDepositClosingList.DateType,           0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",          DBType.adVarChar,   objReqDepositClosingList.DateFrom,           8,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateTo",            DBType.adVarChar,   objReqDepositClosingList.DateTo,             8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingKinds",      DBType.adVarChar,   objReqDepositClosingList.ClosingKinds,       512,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoMatchingFlag",    DBType.adChar,      objReqDepositClosingList.NoMatchingFlag,     1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqDepositClosingList.AccessCenterCode,   512,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objReqDepositClosingList.PageSize,           0,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objReqDepositClosingList.PageNo,             0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                                0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_CLOSING_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                        , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResDepositClosingList
                {
                    list      = new List<DepositClosingGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<DepositClosingGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetDepositClosingList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetDepositClosingList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 입금월 수정
        /// </summary>
        /// <param name="objPayDepositModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPayDepositMonthUpd(PayDepositModel objPayDepositModel)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayDepositMonthUpd REQ] {JsonConvert.SerializeObject(objPayDepositModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objPayDepositModel.CenterCode,            0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDepositClosingSeqNo",   DBType.adBigInt,    objPayDepositModel.DepositClosingSeqNo,   0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInputYM",               DBType.adVarChar,   objPayDepositModel.InputYM,               6,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",            DBType.adVarChar,   objPayDepositModel.UpdAdminID,            50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",          DBType.adVarWChar,  objPayDepositModel.UpdAdminName,          50,   ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,   DBNull.Value,                             256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,   DBNull.Value,                             0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,   DBNull.Value,                             256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,   DBNull.Value,                             0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_MONTH_TX_UPD");

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
                                     , 9101, "System error(SetPayDepositMonthUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayDepositMonthUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 미수업체 목록
        /// </summary>
        /// <param name="objReqPayMisuList"></param>
        /// <returns></returns>
        public ServiceResult<ResPayMisuList> GetPayMisuList(ReqPayMisuList objReqPayMisuList)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetPayMisuList REQ] {JsonConvert.SerializeObject(objReqPayMisuList)}", bLogWrite);

            string                        lo_strJson   = string.Empty;
            ServiceResult<ResPayMisuList> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPayMisuList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqPayMisuList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strYear",                   DBType.adVarChar,   objReqPayMisuList.Year,                  4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientBusinessStatus",   DBType.adTinyInt,   objReqPayMisuList.ClientBusinessStatus,  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",             DBType.adVarWChar,  objReqPayMisuList.ClientName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",       DBType.adVarChar,   objReqPayMisuList.AccessCenterCode,      512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_PAY_MISU_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPayMisuList
                {
                    list      = new List<PayMisuGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PayMisuGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPayMisuList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetPayMisuList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 미수 등록
        /// </summary>
        /// <param name="objReqPayMisuIns"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPayMisuIns(ReqPayMisuIns objReqPayMisuIns)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMisuIns REQ] {JsonConvert.SerializeObject(objReqPayMisuIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objReqPayMisuIns.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strYM",             DBType.adVarChar,   objReqPayMisuIns.YM,              6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",     DBType.adVarChar,   objReqPayMisuIns.RegAdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",   DBType.adVarWChar,  objReqPayMisuIns.RegAdminName,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                     256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_MISU_TX_INS");

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
                                     , 9101, "System error(SetPayMisuIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMisuIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 미수업체 확인내용 목록
        /// </summary>
        /// <param name="objReqPayMisuNoteList"></param>
        /// <returns></returns>
        public ServiceResult<ResPayMisuNoteList> GetPayMisuNoteList(ReqPayMisuNoteList objReqPayMisuNoteList)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetPayMisuNoteList REQ] {JsonConvert.SerializeObject(objReqPayMisuNoteList)}", bLogWrite);

            string                            lo_strJson   = string.Empty;
            ServiceResult<ResPayMisuNoteList> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPayMisuNoteList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intNoteSeqNo",          DBType.adBigInt,    objReqPayMisuNoteList.NoteSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqPayMisuNoteList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,    objReqPayMisuNoteList.ClientCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar,   objReqPayMisuNoteList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar,   objReqPayMisuNoteList.DateTo,              8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNote",               DBType.adVarWChar,  objReqPayMisuNoteList.Note,                4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,      objReqPayMisuNoteList.DelFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqPayMisuNoteList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqPayMisuNoteList.PageSize,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqPayMisuNoteList.PageNo,              0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_MISU_NOTE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPayMisuNoteList
                {
                    list      = new List<PayMisuNoteGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PayMisuNoteGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPayMisuNoteList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetPayMisuNoteList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 미수업체 확인내용 등록
        /// </summary>
        /// <param name="objPayMisuNoteModel"></param>
        /// <returns></returns>
        public ServiceResult<PayMisuNoteModel> SetPayMisuNoteIns(PayMisuNoteModel objPayMisuNoteModel)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMisuNoteIns REQ] {JsonConvert.SerializeObject(objPayMisuNoteModel)}", bLogWrite);

            ServiceResult<PayMisuNoteModel> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<PayMisuNoteModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objPayMisuNoteModel.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",    DBType.adBigInt,    objPayMisuNoteModel.ClientCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteYMD",       DBType.adVarChar,   objPayMisuNoteModel.NoteYMD,          8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",          DBType.adVarWChar,  objPayMisuNoteModel.Note,             4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",    DBType.adVarChar,   objPayMisuNoteModel.RegAdminID,       50,      ParameterDirection.Input);
                                                           
                lo_objDas.AddParam("@pi_strRegAdminName",  DBType.adVarWChar,  objPayMisuNoteModel.RegAdminName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intNoteSeqNo",     DBType.adBigInt,    DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                                                                                                                     
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_MISU_NOTE_TX_INS");

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
                objPayMisuNoteModel.NoteSeqNo = lo_objDas.GetParam("@po_intNoteSeqNo").ToInt64();

                lo_objResult.data = objPayMisuNoteModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetPayMisuNoteIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMisuNoteIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 미수업체 확인내용 수정
        /// </summary>
        /// <param name="objPayMisuNoteModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPayMisuNoteUpd(PayMisuNoteModel objPayMisuNoteModel)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMisuNoteUpd REQ] {JsonConvert.SerializeObject(objPayMisuNoteModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intNoteSeqNo",      DBType.adBigInt,    objPayMisuNoteModel.NoteSeqNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objPayMisuNoteModel.CenterCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",     DBType.adBigInt,    objPayMisuNoteModel.ClientCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteYMD",        DBType.adVarChar,   objPayMisuNoteModel.NoteYMD,       8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",           DBType.adVarWChar,  objPayMisuNoteModel.Note,          4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUpdAdminID",     DBType.adVarChar,   objPayMisuNoteModel.UpdAdminID,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",   DBType.adVarWChar,  objPayMisuNoteModel.UpdAdminName,  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_MISU_NOTE_TX_UPD");

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
                                     , 9101, "System error(SetPayMisuNoteUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMisuNoteUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 미수업체 확인내용 삭제
        /// </summary>
        /// <param name="objPayMisuNoteModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPayMisuNoteDel(PayMisuNoteModel objPayMisuNoteModel)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMisuNoteDel REQ] {JsonConvert.SerializeObject(objPayMisuNoteModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intNoteSeqNo",      DBType.adBigInt,    objPayMisuNoteModel.NoteSeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objPayMisuNoteModel.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",     DBType.adBigInt,    objPayMisuNoteModel.ClientCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",     DBType.adVarChar,   objPayMisuNoteModel.DelAdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminName",   DBType.adVarWChar,  objPayMisuNoteModel.DelAdminName,     50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_MISU_NOTE_TX_DEL");

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
                                     , 9101, "System error(SetPayMisuNoteDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMisuNoteDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매칭 등록
        /// </summary>
        /// <param name="objReqPayMatchingIns"></param>
        /// <returns></returns>
        public ServiceResult<ResPayMatchingIns> SetPayMatchingIns(ReqPayMatchingIns objReqPayMatchingIns)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMatchingIns REQ] {JsonConvert.SerializeObject(objReqPayMatchingIns)}", bLogWrite);

            ServiceResult<ResPayMatchingIns> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPayMatchingIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",              DBType.adInteger,   objReqPayMatchingIns.CenterCode,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",              DBType.adBigInt,    objReqPayMatchingIns.ClientCode,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSaleClosingSeqNos",       DBType.adVarChar,   objReqPayMatchingIns.SaleClosingSeqNos,       4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDepositClosingSeqNos",    DBType.adVarChar,   objReqPayMatchingIns.DepositClosingSeqNos,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",              DBType.adVarChar,   objReqPayMatchingIns.RegAdminID,              50,      ParameterDirection.Input);
                                                                     
                lo_objDas.AddParam("@pi_strRegAdminName",            DBType.adVarWChar,  objReqPayMatchingIns.RegAdminName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSaleOrgAmt",              DBType.adCurrency,  DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDepositAmt",              DBType.adCurrency,  DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intMatchingClosingSeqNo",    DBType.adBigInt,    DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                  DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                                                                                                                                       
                lo_objDas.AddParam("@po_intRetVal",                  DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_MATCHING_TX_INS");

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
                lo_objResult.data = new ResPayMatchingIns
                {
                    SaleOrgAmt           = lo_objDas.GetParam("@po_intSaleOrgAmt").ToDouble(),
                    DepositAmt           = lo_objDas.GetParam("@po_intDepositAmt").ToDouble(),
                    MatchingClosingSeqNo = lo_objDas.GetParam("@po_intMatchingClosingSeqNo").ToInt64()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetPayMatchingIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMatchingIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매칭 해제
        /// </summary>
        /// <param name="objReqPayMatchingDel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPayMatchingDel(ReqPayMatchingDel objReqPayMatchingDel)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMatchingDel REQ] {JsonConvert.SerializeObject(objReqPayMatchingDel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objReqPayMatchingDel.CenterCode,             0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",            DBType.adBigInt,    objReqPayMatchingDel.ClientCode,             0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMatchingClosingSeqNo",  DBType.adBigInt,    objReqPayMatchingDel.MatchingClosingSeqNo,   0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",      DBType.adBigInt,    objReqPayMatchingDel.SaleClosingSeqNo,       0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDepositClosingSeqNo",   DBType.adBigInt,    objReqPayMatchingDel.DepositClosingSeqNo,    0,     ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strDepositFlag",           DBType.adChar,      objReqPayMatchingDel.DepositFlag,            1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",            DBType.adVarChar,   objReqPayMatchingDel.DelAdminID,             50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminName",          DBType.adVarWChar,  objReqPayMatchingDel.DelAdminName,           50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,   DBNull.Value,                                256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,   DBNull.Value,                                0,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,   DBNull.Value,                                256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,   DBNull.Value,                                0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_MATCHING_TX_DEL");

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
                                     , 9101, "System error(SetPayMatchingDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[SetPayMatchingDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 입금 엑셀 등록 체크
        /// </summary>
        /// <param name="objReqPayDepositExcelChk"></param>
        /// <returns></returns>
        public ServiceResult<ResPayDepositExcelChk> GetPayDepositExcelChk(ReqPayDepositExcelChk objReqPayDepositExcelChk)
        {
            SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetPayDepositExcelChk REQ] {JsonConvert.SerializeObject(objReqPayDepositExcelChk)}", bLogWrite);

            ServiceResult<ResPayDepositExcelChk> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPayDepositExcelChk>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqPayDepositExcelChk.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCorpNo",       DBType.adVarChar,   objReqPayDepositExcelChk.ClientCorpNo,    10,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInputYMD",           DBType.adVarChar,   objReqPayDepositExcelChk.InputYMD,        8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objReqPayDepositExcelChk.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strClientExistsFlag",   DBType.adChar,      DBNull.Value,                             1,       ParameterDirection.Output);
                                                                                                                              
                lo_objDas.AddParam("@po_intClientCode",         DBType.adBigInt,    DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strClientName",         DBType.adVarWChar,  DBNull.Value,                             50,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strClientNameSimple",   DBType.adVarWChar,  DBNull.Value,                             50,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strClientPayDay",       DBType.adVarWChar,  DBNull.Value,                             20,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strClientPayDayM",      DBType.adVarWChar,  DBNull.Value,                             20,      ParameterDirection.Output);
                                                                                                                              
                lo_objDas.AddParam("@po_strInputYM",            DBType.adVarChar,   DBNull.Value,                             6,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_PAY_DEPOSIT_EXCEL_NT_CHK");

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
                lo_objResult.data = new ResPayDepositExcelChk
                {
                    ClientExistsFlag = lo_objDas.GetParam("@po_strClientExistsFlag"),
                    ClientCode       = lo_objDas.GetParam("@po_intClientCode").ToInt64(),
                    ClientName       = lo_objDas.GetParam("@po_strClientName"),
                    ClientNameSimple = lo_objDas.GetParam("@po_strClientNameSimple"),
                    ClientPayDay     = lo_objDas.GetParam("@po_strClientPayDay"),
                    ClientPayDayM    = lo_objDas.GetParam("@po_strClientPayDayM"),
                    InputYM          = lo_objDas.GetParam("@po_strInputYM")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPayDepositExcelChk)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("DepositDasServices", "I", $"[GetPayDepositExcelChk RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}