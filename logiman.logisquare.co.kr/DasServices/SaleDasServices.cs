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
    public class SaleDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 매출 거래처 목록
        /// </summary>
        /// <param name="objReqSaleClientList"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleClientList> GetSaleClientList(ReqSaleClientList objReqSaleClientList)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClientList REQ] {JsonConvert.SerializeObject(objReqSaleClientList)}", bLogWrite);

            string                           lo_strJson   = string.Empty;
            ServiceResult<ResSaleClientList> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleClientList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",               DBType.adInteger,   objReqSaleClientList.CenterCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                 DBType.adTinyInt,   objReqSaleClientList.DateType,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                 DBType.adVarChar,   objReqSaleClientList.DateFrom,                 8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                   DBType.adVarChar,   objReqSaleClientList.DateTo,                   8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",       DBType.adVarChar,   objReqSaleClientList.OrderLocationCodes,       4000,    ParameterDirection.Input);
                                                                                                                                         
                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",    DBType.adVarChar,   objReqSaleClientList.DeliveryLocationCodes,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",           DBType.adVarChar,   objReqSaleClientList.OrderItemCodes,           4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",          DBType.adVarWChar,  objReqSaleClientList.OrderClientName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",            DBType.adVarWChar,  objReqSaleClientList.PayClientName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",      DBType.adVarWChar,  objReqSaleClientList.PayClientChargeName,      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientChargeLocation",  DBType.adVarWChar,  objReqSaleClientList.PayClientChargeLocation,  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",            DBType.adVarWChar,  objReqSaleClientList.ConsignorName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHawb",                     DBType.adVarWChar,  objReqSaleClientList.Hawb,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingFlag",              DBType.adChar,      objReqSaleClientList.ClosingFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarryOverFlag",            DBType.adChar,      objReqSaleClientList.CarryOverFlag,            1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCsAdminID",                DBType.adVarChar,   objReqSaleClientList.CsAdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",         DBType.adVarChar,   objReqSaleClientList.AccessCenterCode,         512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",                 DBType.adInteger,   objReqSaleClientList.PageSize,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                   DBType.adInteger,   objReqSaleClientList.PageNo,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",                DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLIENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResSaleClientList
                {
                    list      = new List<SaleClientGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SaleClientGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetSaleClientList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매출 거래처 별 오더 목록
        /// </summary>
        /// <param name="objReqSaleClientOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleClientOrderList> GetSaleClientOrderList(ReqSaleClientOrderList objReqSaleClientOrderList)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClientOrderList REQ] {JsonConvert.SerializeObject(objReqSaleClientOrderList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResSaleClientOrderList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleClientOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                DBType.adInteger,   objReqSaleClientOrderList.CenterCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayClientCode",             DBType.adBigInt,    objReqSaleClientOrderList.PayClientCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                  DBType.adTinyInt,   objReqSaleClientOrderList.DateType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                  DBType.adVarChar,   objReqSaleClientOrderList.DateFrom,                  8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                    DBType.adVarChar,   objReqSaleClientOrderList.DateTo,                    8,       ParameterDirection.Input);
                                                                                                                          
                lo_objDas.AddParam("@pi_strOrderLocationCodes",        DBType.adVarChar,   objReqSaleClientOrderList.OrderLocationCodes,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",     DBType.adVarChar,   objReqSaleClientOrderList.DeliveryLocationCodes,     4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",            DBType.adVarChar,   objReqSaleClientOrderList.OrderItemCodes,            4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",           DBType.adVarWChar,  objReqSaleClientOrderList.OrderClientName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",             DBType.adVarWChar,  objReqSaleClientOrderList.PayClientName,             50,      ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strPayClientChargeName",       DBType.adVarWChar,  objReqSaleClientOrderList.PayClientChargeName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",   DBType.adVarWChar,  objReqSaleClientOrderList.PayClientChargeLocation,   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",             DBType.adVarWChar,  objReqSaleClientOrderList.ConsignorName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHawb",                      DBType.adVarWChar,  objReqSaleClientOrderList.Hawb,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingFlag",               DBType.adChar,      objReqSaleClientOrderList.ClosingFlag,               1,       ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strCarryOverFlag",             DBType.adChar,      objReqSaleClientOrderList.CarryOverFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",          DBType.adVarChar,   objReqSaleClientOrderList.AccessCenterCode,          512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLIENT_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResSaleClientOrderList
                {
                    list      = new List<SaleClientOrderGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SaleClientOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetSaleClientOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClientOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매출 이월 등록
        /// </summary>
        /// <param name="objReqSaleCarryoverUpd"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleCarryoverUpd> SetSaleCarryoverUpd(ReqSaleCarryoverUpd objReqSaleCarryoverUpd)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleCarryoverUpd REQ] {JsonConvert.SerializeObject(objReqSaleCarryoverUpd)}", bLogWrite);

            ServiceResult<ResSaleCarryoverUpd> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleCarryoverUpd>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objReqSaleCarryoverUpd.CenterCode,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos1",     DBType.adVarChar,   objReqSaleCarryoverUpd.OrderNos1,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos2",     DBType.adVarChar,   objReqSaleCarryoverUpd.OrderNos2,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos3",     DBType.adVarChar,   objReqSaleCarryoverUpd.OrderNos3,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos4",     DBType.adVarChar,   objReqSaleCarryoverUpd.OrderNos4,      4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderNos5",     DBType.adVarChar,   objReqSaleCarryoverUpd.OrderNos5,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",    DBType.adVarChar,   objReqSaleCarryoverUpd.UpdAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",  DBType.adVarWChar,  objReqSaleCarryoverUpd.UpdAdminName,   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalCnt",      DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intSuccessCnt",    DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CARRYOVER_TX_UPD");

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

                lo_objResult.data = new ResSaleCarryoverUpd
                {
                    TotalCnt   = lo_objDas.GetParam("@po_intTotalCnt").ToInt(),
                    SuccessCnt = lo_objDas.GetParam("@po_intSuccessCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetSaleCarryoverUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleCarryoverUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매출 이월 삭제
        /// </summary>
        /// <param name="objReqSaleCarryoverDel"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleCarryoverDel> SetSaleCarryoverDel(ReqSaleCarryoverDel objReqSaleCarryoverDel)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleCarryoverDel REQ] {JsonConvert.SerializeObject(objReqSaleCarryoverDel)}", bLogWrite);

            ServiceResult<ResSaleCarryoverDel> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleCarryoverDel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objReqSaleCarryoverDel.CenterCode,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos1",     DBType.adVarChar,   objReqSaleCarryoverDel.OrderNos1,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos2",     DBType.adVarChar,   objReqSaleCarryoverDel.OrderNos2,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos3",     DBType.adVarChar,   objReqSaleCarryoverDel.OrderNos3,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos4",     DBType.adVarChar,   objReqSaleCarryoverDel.OrderNos4,      4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderNos5",     DBType.adVarChar,   objReqSaleCarryoverDel.OrderNos5,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",    DBType.adVarChar,   objReqSaleCarryoverDel.DelAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminName",  DBType.adVarWChar,  objReqSaleCarryoverDel.DelAdminName,   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalCnt",      DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intSuccessCnt",    DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CARRYOVER_TX_DEL");

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

                lo_objResult.data = new ResSaleCarryoverDel
                {
                    TotalCnt   = lo_objDas.GetParam("@po_intTotalCnt").ToInt(),
                    SuccessCnt = lo_objDas.GetParam("@po_intSuccessCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetSaleCarryoverDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleCarryoverDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매출 마감 등록
        /// </summary>
        /// <param name="objReqSaleClosingIns"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleClosingIns> SetSaleClosingIns(ReqSaleClosingIns objReqSaleClosingIns)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingIns REQ] {JsonConvert.SerializeObject(objReqSaleClosingIns)}", bLogWrite);

            ServiceResult<ResSaleClosingIns> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleClosingIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqSaleClosingIns.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos1",           DBType.adVarChar,   objReqSaleClosingIns.OrderNos1,          8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos2",           DBType.adVarChar,   objReqSaleClosingIns.OrderNos2,          8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos3",           DBType.adVarChar,   objReqSaleClosingIns.OrderNos3,          8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos4",           DBType.adVarChar,   objReqSaleClosingIns.OrderNos4,          8000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderNos5",           DBType.adVarChar,   objReqSaleClosingIns.OrderNos5,          8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleOrgAmt",          DBType.adCurrency,  objReqSaleClosingIns.SaleOrgAmt,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClosingKind",         DBType.adTinyInt,   objReqSaleClosingIns.ClosingKind,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingAdminID",      DBType.adVarChar,   objReqSaleClosingIns.ClosingAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingAdminName",    DBType.adVarWChar,  objReqSaleClosingIns.ClosingAdminName,   50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_intSaleClosingSeqNo",    DBType.adBigInt,    DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intSaleOrgAmt",          DBType.adCurrency,  DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                                                                                                                              
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLOSING_TX_INS");

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

                lo_objResult.data = new ResSaleClosingIns
                {
                    SaleClosingSeqNo = lo_objDas.GetParam("@po_intSaleClosingSeqNo").ToInt64(),
                    SaleOrgAmt       = lo_objDas.GetParam("@po_intSaleOrgAmt").ToDouble()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetSaleClosingIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 매출 마감 취소
        /// </summary>
        /// <param name="objReqSaleClosingCnl"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetSaleClosingCnl(ReqSaleClosingCnl objReqSaleClosingCnl)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingCnl REQ] {JsonConvert.SerializeObject(objReqSaleClosingCnl)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqSaleClosingCnl.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSaleClosingSeqNos",   DBType.adVarChar,   objReqSaleClosingCnl.SaleClosingSeqNos,   8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminID",          DBType.adVarChar,   objReqSaleClosingCnl.CnlAdminID,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminName",        DBType.adVarWChar,  objReqSaleClosingCnl.CnlAdminName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                                                                                                                               
                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLOSING_TX_CNL");

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
                                     , 9101, "System error(SetSaleClosingCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 매출 전표 목록(현황)
        /// </summary>
        /// <param name="objReqSaleClosingList"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleClosingList> GetSaleClosingList(ReqSaleClosingList objReqSaleClosingList)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClosingList REQ] {JsonConvert.SerializeObject(objReqSaleClosingList)}", bLogWrite);

            string                            lo_strJson   = string.Empty;
            ServiceResult<ResSaleClosingList> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleClosingList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",       DBType.adBigInt,    objReqSaleClosingList.SaleClosingSeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayClientCode",          DBType.adBigInt,    objReqSaleClosingList.PayClientCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqSaleClosingList.CenterCode,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",               DBType.adTinyInt,   objReqSaleClosingList.DateType,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",               DBType.adVarChar,   objReqSaleClosingList.DateFrom,                8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateTo",                 DBType.adVarChar,   objReqSaleClosingList.DateTo,                  8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",     DBType.adVarChar,   objReqSaleClosingList.OrderLocationCodes,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",  DBType.adVarChar,   objReqSaleClosingList.DeliveryLocationCodes,   4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminID",              DBType.adVarChar,   objReqSaleClosingList.CsAdminID,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",          DBType.adVarWChar,  objReqSaleClosingList.PayClientName,           50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClosingAdminName",       DBType.adVarWChar,  objReqSaleClosingList.ClosingAdminName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClosingKind",            DBType.adTinyInt,   objReqSaleClosingList.ClosingKind,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",       DBType.adVarChar,   objReqSaleClosingList.AccessCenterCode,        512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",               DBType.adInteger,   objReqSaleClosingList.PageSize,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                 DBType.adInteger,   objReqSaleClosingList.PageNo,                  0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",              DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLOSING_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResSaleClosingList
                {
                    list = new List<SaleClosingGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {

                    lo_objDas.objDT.Columns.Add("IssuSeqNo", typeof(string));

                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        if (row["BillKind"].ToString().Equals("1") && (row["BillStatus"].ToString().Equals("2") 
                                                                       || (row["BillStatus"].ToString().Equals("3") && !string.IsNullOrWhiteSpace(row["NtsConfirmNum"].ToString()))
                                                                       || row["BillStatus"].ToString().Equals("4")))
                        {
                            row["IssuSeqNo"] = CommonConstant.TAX_PREFIX_TMS_SALE + string.Format("{0:D4}", row["CenterCode"].ToInt()) + row["SaleClosingSeqNo"] + "01";
                        }
                        else
                        {
                            row["IssuSeqNo"] = string.Empty;
                        }
                    }

                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SaleClosingGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetSaleClosingList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClosingList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 매출 전표 오더 목록
        /// </summary>
        /// <param name="objReqSaleClosingOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleClosingOrderList> GetSaleClosingOrderList(ReqSaleClosingOrderList objReqSaleClosingOrderList)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClosingOrderList REQ] {JsonConvert.SerializeObject(objReqSaleClosingOrderList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResSaleClosingOrderList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleClosingOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",   DBType.adBigInt,    objReqSaleClosingOrderList.SaleClosingSeqNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqSaleClosingOrderList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqSaleClosingOrderList.AccessCenterCode,   512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLOSING_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResSaleClosingOrderList
                {
                    list = new List<SaleClosingOrderGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SaleClosingOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetSaleClosingOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClosingOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 매출 전표 비용 목록
        /// </summary>
        /// <param name="objReqSaleClosingPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleClosingPayList> GetSaleClosingPayList(ReqSaleClosingPayList objReqSaleClosingPayList)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClosingPayList REQ] {JsonConvert.SerializeObject(objReqSaleClosingPayList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResSaleClosingPayList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleClosingPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",     DBType.adBigInt,    objReqSaleClosingPayList.SaleClosingSeqNo,     0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqSaleClosingPayList.CenterCode,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqSaleClosingPayList.AccessCenterCode,     512,    ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLOSING_PAY_DR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResSaleClosingPayList
                {
                    list = new List<SaleClosingPayModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SaleClosingPayModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetSaleClosingPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[GetSaleClosingPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 매출 전표 계산서 정보 변경
        /// </summary>
        /// <param name="objReqSaleClosingBillInfoUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetSaleClosingBillInfoUpd(ReqSaleClosingBillInfoUpd objReqSaleClosingBillInfoUpd)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingBillInfoUpd REQ] {JsonConvert.SerializeObject(objReqSaleClosingBillInfoUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqSaleClosingBillInfoUpd.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSaleClosingSeqNos", DBType.adVarChar,   objReqSaleClosingBillInfoUpd.SaleClosingSeqNos,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBillStatus",        DBType.adTinyInt,   objReqSaleClosingBillInfoUpd.BillStatus,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBillKind",          DBType.adTinyInt,   objReqSaleClosingBillInfoUpd.BillKind,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillChargeName",    DBType.adVarWChar,  objReqSaleClosingBillInfoUpd.BillChargeName,     50,      ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@pi_strBillChargeTelNo",   DBType.adVarChar,   objReqSaleClosingBillInfoUpd.BillChargeTelNo,    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillChargeEmail",   DBType.adVarChar,   objReqSaleClosingBillInfoUpd.BillChargeEmail,    100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillWrite",         DBType.adVarChar,   objReqSaleClosingBillInfoUpd.BillWrite,          8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillYMD",           DBType.adVarChar,   objReqSaleClosingBillInfoUpd.BillYMD,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillAdminID",       DBType.adVarChar,   objReqSaleClosingBillInfoUpd.BillAdminID,        50,      ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@pi_strBillAdminName",     DBType.adVarWChar,  objReqSaleClosingBillInfoUpd.BillAdminName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNtsConfirmNum",     DBType.adVarChar,   objReqSaleClosingBillInfoUpd.NtsConfirmNum,      24,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChkPermFlag",       DBType.adChar,      "Y",                                             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLOSING_BILLINFO_TX_UPD");

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
                                     , 9101, "System error(SetSaleClosingBillInfoUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingBillInfoUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 매출 전표 계산서 정보 변경
        /// </summary>
        /// <param name="objReqSaleClosingNoteUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetSaleClosingNoteUpd(ReqSaleClosingNoteUpd objReqSaleClosingNoteUpd)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingNoteUpd REQ] {JsonConvert.SerializeObject(objReqSaleClosingNoteUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqSaleClosingNoteUpd.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",   DBType.adBigInt,    objReqSaleClosingNoteUpd.SaleClosingSeqNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",               DBType.adVarWChar,  objReqSaleClosingNoteUpd.Note,               500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",         DBType.adVarChar,   objReqSaleClosingNoteUpd.UpdAdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",       DBType.adVarWChar,  objReqSaleClosingNoteUpd.UpdAdminName,       50,      ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLOSING_NOTE_TX_UPD");

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
                                     , 9101, "System error(SetSaleClosingNoteUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingNoteUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매출 전표 계산서 발행 취소
        /// </summary>
        /// <param name="objReqSaleClosingBillCnl"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleClosingBillCnl> SetSaleClosingBillCnl(ReqSaleClosingBillCnl objReqSaleClosingBillCnl)
        {
            SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingBillCnl REQ] {JsonConvert.SerializeObject(objReqSaleClosingBillCnl)}", bLogWrite);

            ServiceResult<ResSaleClosingBillCnl> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleClosingBillCnl>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqSaleClosingBillCnl.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSaleClosingSeqNos",  DBType.adVarChar,   objReqSaleClosingBillCnl.SaleClosingSeqNos,   4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objReqSaleClosingBillCnl.AdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalCnt",           DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCancelCnt",          DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);
                                                                                                                                  
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_SALE_CLOSING_BILL_TX_CNL");

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
                lo_objResult.data = new ResSaleClosingBillCnl
                {
                    TotalCnt  = lo_objDas.GetParam("@po_intTotalCnt").ToInt(),
                    CancelCnt = lo_objDas.GetParam("@po_intCancelCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetSaleClosingBillCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SaleDasServices", "I", $"[SetSaleClosingBillCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}