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
    public class AppOrderDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;
        

        /// <summary>
        /// 오더
        /// </summary>
        /// <param name="objReqAppOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResAppOrderList> GetAppOrderList(ReqAppOrderList objReqAppOrderList)
        {
            SiteGlobal.WriteInformation("AppOrderDasServices", "I", $"[GetAppOrderList REQ] {JsonConvert.SerializeObject(objReqAppOrderList)}", bLogWrite);
            
            string                         lo_strJson   = string.Empty;
            ServiceResult<ResAppOrderList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAppOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",               DBType.adBigInt,    objReqAppOrderList.OrderNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objReqAppOrderList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",              DBType.adTinyInt,   objReqAppOrderList.ListType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",              DBType.adTinyInt,   objReqAppOrderList.DateType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateYMD",               DBType.adVarChar,   objReqAppOrderList.DateYMD,              8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderLocationCodes",    DBType.adVarChar,   objReqAppOrderList.OrderLocationCodes,   4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",        DBType.adVarChar,   objReqAppOrderList.OrderItemCodes,       4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",       DBType.adVarWChar,  objReqAppOrderList.OrderClientName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",         DBType.adVarWChar,  objReqAppOrderList.PayClientName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",         DBType.adVarWChar,  objReqAppOrderList.ConsignorName,        50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlace",           DBType.adVarWChar,  objReqAppOrderList.PickupPlace,          200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGETPlace",              DBType.adVarWChar,  objReqAppOrderList.GetPlace,             200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",             DBType.adVarChar,   objReqAppOrderList.ComCorpNo,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",            DBType.adVarWChar,  objReqAppOrderList.DriverName,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                 DBType.adVarWChar,  objReqAppOrderList.CarNo,                20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCsAdminID",             DBType.adVarChar,   objReqAppOrderList.CsAdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcceptAdminName",       DBType.adVarWChar,  objReqAppOrderList.AcceptAdminName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyChargeFlag",          DBType.adChar,      objReqAppOrderList.MyChargeFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",           DBType.adChar,      objReqAppOrderList.MyOrderFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",               DBType.adChar,      objReqAppOrderList.CnlFlag,              1,       ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intSortType",              DBType.adTinyInt,   objReqAppOrderList.SortType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",               DBType.adVarChar,   objReqAppOrderList.AdminID,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",      DBType.adVarChar,   objReqAppOrderList.AccessCenterCode,     512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",              DBType.adInteger,   objReqAppOrderList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                DBType.adInteger,   objReqAppOrderList.PageNo,               0,       ParameterDirection.Input);
                
                lo_objDas.AddParam("@po_intRecordCnt",             DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_APP_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAppOrderList
                {
                    list = new List<AppOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("TransRateFlag", typeof(string));

                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        if (!row["TransRateInfo"].ToString().Equals("||") && !string.IsNullOrWhiteSpace(row["TransRateInfo"].ToString()))
                        {
                            row["TransRateFlag"] = "Y";
                        }
                        else
                        {
                            row["TransRateFlag"] = "N";
                        }
                    }

                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AppOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAppOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AppOrderDasServices", "I", $"[GetAppOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 배차 변경
        /// </summary>
        /// <param name="objReqAppOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetAppOrderDispatchUpd(ReqAppOrderDispatchUpd objReqAppOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("AppOrderDasServices", "I", $"[SetAppOrderDispatchUpd REQ] {JsonConvert.SerializeObject(objReqAppOrderDispatchUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqAppOrderDispatchUpd.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",           DBType.adBigInt,    objReqAppOrderDispatchUpd.OrderNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intQuickType",         DBType.adTinyInt,   objReqAppOrderDispatchUpd.QuickType,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",      DBType.adTinyInt,   objReqAppOrderDispatchUpd.DispatchType,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchKind",      DBType.adTinyInt,   objReqAppOrderDispatchUpd.DispatchKind,      0,       ParameterDirection.Input);
                                                                                                                                
                lo_objDas.AddParam("@pi_intRefSeqNo",          DBType.adBigInt,    objReqAppOrderDispatchUpd.RefSeqNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intInsureExceptKind",  DBType.adTinyInt,   objReqAppOrderDispatchUpd.InsureExceptKind,  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",        DBType.adVarChar,   objReqAppOrderDispatchUpd.UpdAdminID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",      DBType.adVarWChar,  objReqAppOrderDispatchUpd.UpdAdminName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_APP_ORDER_DISPATCH_TX_UPD");

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
                                     , 9101, "System error(SetAppOrderDispatchUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AppOrderDasServices", "I", $"[SetAppOrderDispatchUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 오더 요율표 조회(적용후)
        /// </summary>
        /// <param name="objReqAppTransRateOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResAppTransRateOrderList> GetAppTransRateOrderList(ReqAppTransRateOrderList objReqAppTransRateOrderList)
        {
            SiteGlobal.WriteInformation("AppOrderDasServices", "I", $"[GetAppTransRateOrderList REQ] {JsonConvert.SerializeObject(objReqAppTransRateOrderList)}", bLogWrite);

            string                                  lo_strJson   = string.Empty;
            ServiceResult<ResAppTransRateOrderList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                
                lo_objResult = new ServiceResult<ResAppTransRateOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqAppTransRateOrderList.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",                DBType.adBigInt,    objReqAppTransRateOrderList.OrderNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarFixedFlag",           DBType.adChar,      objReqAppTransRateOrderList.CarFixedFlag,    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objReqAppTransRateOrderList.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intApplySeqNo",             DBType.adBigInt,    DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAppTransRateOrderList
                {
                    list       = new List<AppTransRateOrderModel>(),
                    RecordCnt  = lo_objDas.RecordCount,
                    ApplySeqNo = lo_objDas.GetParam("@po_intApplySeqNo").ToString()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AppTransRateOrderModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAppTransRateOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AppOrderDasServices", "I", $"[GetAppTransRateOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 요율표 조회
        /// </summary>
        /// <param name="objReqAppTransRateOrderApplyList"></param>
        /// <returns></returns>
        public ServiceResult<ResAppTransRateOrderApplyList> GetAppTransRateOrderApplyList(ReqAppTransRateOrderApplyList objReqAppTransRateOrderApplyList)
        {
            SiteGlobal.WriteInformation("AppOrderDasServices", "I", $"[GetAppTransRateOrderApplyList REQ] {JsonConvert.SerializeObject(objReqAppTransRateOrderApplyList)}", bLogWrite);
            
            string                                       lo_strJson   = string.Empty;
            ServiceResult<ResAppTransRateOrderApplyList> lo_objResult = null;
            IDasNetCom                                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAppTransRateOrderApplyList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqAppTransRateOrderApplyList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",             DBType.adBigInt,    objReqAppTransRateOrderApplyList.ClientCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",          DBType.adBigInt,    objReqAppTransRateOrderApplyList.ConsignorCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",          DBType.adVarChar,   objReqAppTransRateOrderApplyList.OrderItemCode,       5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",      DBType.adVarChar,   objReqAppTransRateOrderApplyList.OrderLocationCode,   5,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strFTLFlag",                DBType.adChar,      objReqAppTransRateOrderApplyList.FTLFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarFixedFlag",           DBType.adChar,      objReqAppTransRateOrderApplyList.CarFixedFlag,        1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromAddrs",              DBType.adVarWChar,  objReqAppTransRateOrderApplyList.FromAddrs,           4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToAddrs",                DBType.adVarWChar,  objReqAppTransRateOrderApplyList.ToAddrs,             4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsRunType",           DBType.adTinyInt,   objReqAppTransRateOrderApplyList.GoodsRunType,        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarTonCode",             DBType.adVarChar,   objReqAppTransRateOrderApplyList.CarTonCode,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",            DBType.adVarChar,   objReqAppTransRateOrderApplyList.CarTypeCode,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",              DBType.adVarChar,   objReqAppTransRateOrderApplyList.PickupYMD,           8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",               DBType.adVarChar,   objReqAppTransRateOrderApplyList.PickupHM,            4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",                 DBType.adVarChar,   objReqAppTransRateOrderApplyList.GetYMD,              8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetHM",                  DBType.adVarChar,   objReqAppTransRateOrderApplyList.GetHM,               4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intVolume",                 DBType.adInteger,   objReqAppTransRateOrderApplyList.Volume,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCBM",                    DBType.adDouble,    objReqAppTransRateOrderApplyList.CBM,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",                 DBType.adDouble,    objReqAppTransRateOrderApplyList.Weight,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLength",                 DBType.adInteger,   objReqAppTransRateOrderApplyList.Length,              0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strLayoverFlag",            DBType.adChar,      objReqAppTransRateOrderApplyList.LayoverFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSamePlaceCount",         DBType.adInteger,   objReqAppTransRateOrderApplyList.SamePlaceCount,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNonSamePlaceCount",      DBType.adInteger,   objReqAppTransRateOrderApplyList.NonSamePlaceCount,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objReqAppTransRateOrderApplyList.AdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intApplySeqNo",             DBType.adBigInt,    DBNull.Value,                                         0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_ORDER_APPLY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAppTransRateOrderApplyList
                {
                    list       = new List<AppTransRateOrderModel>(),
                    RecordCnt  = lo_objDas.RecordCount,
                    ApplySeqNo = lo_objDas.GetParam("@po_intApplySeqNo").ToString()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AppTransRateOrderModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetAppTransRateOrderApplyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AppOrderDasServices", "I", $"[GetAppTransRateOrderApplyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}