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
    public class WebOrderDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 오더
        /// </summary>
        /// <param name="objWebReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<WebResOrderList> GetWebOrderList(WebReqOrderList objWebReqOrderList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebOrderList REQ] {JsonConvert.SerializeObject(objWebReqOrderList)}", bLogWrite);

            string                         lo_strJson   = string.Empty;
            ServiceResult<WebResOrderList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<WebResOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",                    DBType.adBigInt,    objWebReqOrderList.OrderNo,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                 DBType.adInteger,   objWebReqOrderList.CenterCode,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",                   DBType.adTinyInt,   objWebReqOrderList.ListType,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                   DBType.adTinyInt,   objWebReqOrderList.DateType,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                   DBType.adVarChar,   objWebReqOrderList.DateFrom,                   8,       ParameterDirection.Input);
                                                                                                                                           
                lo_objDas.AddParam("@pi_strDateTo",                     DBType.adVarChar,   objWebReqOrderList.DateTo,                     8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",         DBType.adVarChar,   objWebReqOrderList.OrderLocationCodes,         4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",             DBType.adVarChar,   objWebReqOrderList.OrderItemCodes,             4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderStatuses",              DBType.adVarChar,   objWebReqOrderList.OrderStatuses,              4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",            DBType.adVarWChar,  objWebReqOrderList.OrderClientName,            50,      ParameterDirection.Input);
                                                                                                                                           
                lo_objDas.AddParam("@pi_strOrderClientChargeName",      DBType.adVarWChar,  objWebReqOrderList.OrderClientChargeName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",              DBType.adVarWChar,  objWebReqOrderList.PayClientName,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",        DBType.adVarWChar,  objWebReqOrderList.PayClientChargeName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",    DBType.adVarWChar,  objWebReqOrderList.PayClientChargeLocation,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",              DBType.adVarWChar,  objWebReqOrderList.ConsignorName,              50,      ParameterDirection.Input);
                                                                                                                                           
                lo_objDas.AddParam("@pi_strPickupPlace",                DBType.adVarWChar,  objWebReqOrderList.PickupPlace,                200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlace",                   DBType.adVarWChar,  objWebReqOrderList.GetPlace,                   200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsName",                  DBType.adVarWChar,  objWebReqOrderList.GoodsName,                  100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",                    DBType.adVarWChar,  objWebReqOrderList.ComName,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",                  DBType.adVarChar,   objWebReqOrderList.ComCorpNo,                  20,      ParameterDirection.Input);
                                                                                                                                           
                lo_objDas.AddParam("@pi_strDriverName",                 DBType.adVarWChar,  objWebReqOrderList.DriverName,                 20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                      DBType.adVarWChar,  objWebReqOrderList.CarNo,                      20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClient",                 DBType.adVarWChar,  objWebReqOrderList.NoteClient,                 1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransCenterCode",            DBType.adInteger,   objWebReqOrderList.TransCenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intContractCenterCode",         DBType.adInteger,   objWebReqOrderList.ContractCenterCode,         0,       ParameterDirection.Input);
                                                                                                                                           
                lo_objDas.AddParam("@pi_strCsAdminID",                  DBType.adVarChar,   objWebReqOrderList.CsAdminID,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcceptAdminName",            DBType.adVarWChar,  objWebReqOrderList.AcceptAdminName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyChargeFlag",               DBType.adChar,      objWebReqOrderList.MyChargeFlag,               1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",                DBType.adChar,      objWebReqOrderList.MyOrderFlag,                1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",                    DBType.adChar,      objWebReqOrderList.CnlFlag,                    1,       ParameterDirection.Input);
                                                                                                                                           
                lo_objDas.AddParam("@pi_strAccessCorpNo",               DBType.adVarChar,   objWebReqOrderList.AccessCorpNo,               512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                    DBType.adVarChar,   objWebReqOrderList.AdminID,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",           DBType.adVarChar,   objWebReqOrderList.AccessCenterCode,           512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",                   DBType.adInteger,   objWebReqOrderList.PageSize,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                     DBType.adInteger,   objWebReqOrderList.PageNo,                     0,       ParameterDirection.Input);
                                                                        
                lo_objDas.AddParam("@po_intRecordCnt",                  DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_WEBORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new WebResOrderList
                {
                    list      = new List<WebOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<WebOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetWebOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 등록
        /// </summary>
        /// <param name="objWebOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<WebOrderModel> SetWebOrderIns(WebOrderModel objWebOrderModel)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderIns REQ] {JsonConvert.SerializeObject(objWebOrderModel)}", bLogWrite);

            ServiceResult<WebOrderModel> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<WebOrderModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                     DBType.adInteger,   objWebOrderModel.CenterCode,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",                DBType.adBigInt,    objWebOrderModel.OrderClientCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPayClientCode",                  DBType.adBigInt,    objWebOrderModel.PayClientCode,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",                  DBType.adVarWChar,  objWebOrderModel.ConsignorName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",                  DBType.adVarChar,   objWebOrderModel.OrderItemCode,                 5,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strReqNo",                          DBType.adVarWChar,  objWebOrderModel.ReqNo,                         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqChargeName",                  DBType.adVarWChar,  objWebOrderModel.ReqChargeName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqChargeTeam",                  DBType.adVarWChar,  objWebOrderModel.ReqChargeTeam,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqChargePosition",              DBType.adVarWChar,  objWebOrderModel.ReqChargePosition,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqChargeTel",                   DBType.adVarChar,   objWebOrderModel.ReqChargeTel,                  20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strReqChargeCell",                  DBType.adVarChar,   objWebOrderModel.ReqChargeCell,                 20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",                      DBType.adVarChar,   objWebOrderModel.PickupYMD,                     8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",                       DBType.adVarChar,   objWebOrderModel.PickupHM,                      4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",                    DBType.adVarWChar,  objWebOrderModel.PickupPlace,                   200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlacePost",                DBType.adVarChar,   objWebOrderModel.PickupPlacePost,               6,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceAddr",                DBType.adVarWChar,  objWebOrderModel.PickupPlaceAddr,               100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddrDtl",             DBType.adVarWChar,  objWebOrderModel.PickupPlaceAddrDtl,            100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceFullAddr",            DBType.adVarWChar,  objWebOrderModel.PickupPlaceFullAddr,           150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeName",          DBType.adVarWChar,  objWebOrderModel.PickupPlaceChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargePosition",      DBType.adVarWChar,  objWebOrderModel.PickupPlaceChargePosition,     50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelExtNo",      DBType.adVarChar,   objWebOrderModel.PickupPlaceChargeTelExtNo,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelNo",         DBType.adVarChar,   objWebOrderModel.PickupPlaceChargeTelNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeCell",          DBType.adVarChar,   objWebOrderModel.PickupPlaceChargeCell,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceNote",                DBType.adVarWChar,  objWebOrderModel.PickupPlaceNote,               300,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",                         DBType.adVarChar,   objWebOrderModel.GetYMD,                        8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetHM",                          DBType.adVarChar,   objWebOrderModel.GetHM,                         4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlace",                       DBType.adVarWChar,  objWebOrderModel.GetPlace,                      200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlacePost",                   DBType.adVarChar,   objWebOrderModel.GetPlacePost,                  6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddr",                   DBType.adVarWChar,  objWebOrderModel.GetPlaceAddr,                  100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddrDtl",                DBType.adVarWChar,  objWebOrderModel.GetPlaceAddrDtl,               100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlaceFullAddr",               DBType.adVarWChar,  objWebOrderModel.GetPlaceFullAddr,              150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeName",             DBType.adVarWChar,  objWebOrderModel.GetPlaceChargeName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargePosition",         DBType.adVarWChar,  objWebOrderModel.GetPlaceChargePosition,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeTelExtNo",         DBType.adVarChar,   objWebOrderModel.GetPlaceChargeTelExtNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeTelNo",            DBType.adVarChar,   objWebOrderModel.GetPlaceChargeTelNo,           20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlaceChargeCell",             DBType.adVarChar,   objWebOrderModel.GetPlaceChargeCell,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceNote",                   DBType.adVarWChar,  objWebOrderModel.GetPlaceNote,                  300,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",                     DBType.adVarChar,   objWebOrderModel.CarTonCode,                    5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",                    DBType.adVarChar,   objWebOrderModel.CarTypeCode,                   5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClient",                     DBType.adVarWChar,  objWebOrderModel.NoteClient,                    1000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGoodsName",                      DBType.adVarWChar,  objWebOrderModel.GoodsName,                     100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsItemCode",                  DBType.adVarChar,   objWebOrderModel.GoodsItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsRunType",                   DBType.adTinyInt,   objWebOrderModel.GoodsRunType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFTLFlag",                        DBType.adChar,      objWebOrderModel.FTLFlag,                       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLength",                         DBType.adInteger,   objWebOrderModel.Length,                        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intVolume",                         DBType.adInteger,   objWebOrderModel.Volume,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",                         DBType.adDouble,    objWebOrderModel.Weight,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strQuantity",                       DBType.adVarWChar,  objWebOrderModel.Quantity,                      500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsNote",                      DBType.adVarWChar,  objWebOrderModel.GoodsNote,                     500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShuttleEtc",                     DBType.adVarWChar,  objWebOrderModel.ShuttleEtc,                    50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strArrivalReportFlag",              DBType.adChar,      objWebOrderModel.ArrivalReportFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBondedFlag",                     DBType.adChar,      objWebOrderModel.BondedFlag,                    1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNation",                         DBType.adVarWChar,  objWebOrderModel.Nation,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHawb",                           DBType.adVarChar,   objWebOrderModel.Hawb,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMawb",                           DBType.adVarChar,   objWebOrderModel.Mawb,                          50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strInvoiceNo",                      DBType.adVarChar,   objWebOrderModel.InvoiceNo,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBookingNo",                      DBType.adVarChar,   objWebOrderModel.BookingNo,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStockNo",                        DBType.adVarChar,   objWebOrderModel.StockNo,                       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCBM",                            DBType.adCurrency,  objWebOrderModel.CBM,                           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",              DBType.adVarChar,   objWebOrderModel.OrderLocationCode,             5,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminCorpNo",                    DBType.adVarChar,   objWebOrderModel.AdminCorpNo,                   20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",                     DBType.adVarChar,   objWebOrderModel.RegAdminID,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",                   DBType.adVarWChar,  objWebOrderModel.RegAdminName,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intReqSeqNo",                       DBType.adBigInt,    DBNull.Value,                                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intOrderNo",                        DBType.adBigInt,    DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                         DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                         DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                       DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                       DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_TX_INS");

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

                objWebOrderModel.OrderNo  = lo_objDas.GetParam("@po_intOrderNo").ToInt64();
                objWebOrderModel.ReqSeqNo = lo_objDas.GetParam("@po_intReqSeqNo").ToInt64();
                lo_objResult.data         = objWebOrderModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9102, "System error(SetWebOrderIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 오더 수정
        /// </summary>
        /// <param name="objWebOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<WebOrderModel> SetWebOrderUpd(WebOrderModel objWebOrderModel)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderUpd REQ] {JsonConvert.SerializeObject(objWebOrderModel)}", bLogWrite);

            ServiceResult<WebOrderModel> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<WebOrderModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intReqSeqNo",                       DBType.adBigInt,    objWebOrderModel.ReqSeqNo,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                     DBType.adInteger,   objWebOrderModel.CenterCode,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",                  DBType.adVarWChar,  objWebOrderModel.ConsignorName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",                  DBType.adVarChar,   objWebOrderModel.OrderItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqNo",                          DBType.adVarWChar,  objWebOrderModel.ReqNo,                         50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strReqChargeName",                  DBType.adVarWChar,  objWebOrderModel.ReqChargeName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqChargeTeam",                  DBType.adVarWChar,  objWebOrderModel.ReqChargeTeam,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqChargeTel",                   DBType.adVarChar,   objWebOrderModel.ReqChargeTel,                  20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqChargeCell",                  DBType.adVarChar,   objWebOrderModel.ReqChargeCell,                 20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",                      DBType.adVarChar,   objWebOrderModel.PickupYMD,                     8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupHM",                       DBType.adVarChar,   objWebOrderModel.PickupHM,                      4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",                    DBType.adVarWChar,  objWebOrderModel.PickupPlace,                   200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlacePost",                DBType.adVarChar,   objWebOrderModel.PickupPlacePost,               6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddr",                DBType.adVarWChar,  objWebOrderModel.PickupPlaceAddr,               100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddrDtl",             DBType.adVarWChar,  objWebOrderModel.PickupPlaceAddrDtl,            100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceFullAddr",            DBType.adVarWChar,  objWebOrderModel.PickupPlaceFullAddr,           150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeName",          DBType.adVarWChar,  objWebOrderModel.PickupPlaceChargeName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargePosition",      DBType.adVarWChar,  objWebOrderModel.PickupPlaceChargePosition,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelExtNo",      DBType.adVarChar,   objWebOrderModel.PickupPlaceChargeTelExtNo,     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelNo",         DBType.adVarChar,   objWebOrderModel.PickupPlaceChargeTelNo,        20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceChargeCell",          DBType.adVarChar,   objWebOrderModel.PickupPlaceChargeCell,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceNote",                DBType.adVarWChar,  objWebOrderModel.PickupPlaceNote,               300,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",                         DBType.adVarChar,   objWebOrderModel.GetYMD,                        8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetHM",                          DBType.adVarChar,   objWebOrderModel.GetHM,                         4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlace",                       DBType.adVarWChar,  objWebOrderModel.GetPlace,                      200,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlacePost",                   DBType.adVarChar,   objWebOrderModel.GetPlacePost,                  6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddr",                   DBType.adVarWChar,  objWebOrderModel.GetPlaceAddr,                  100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddrDtl",                DBType.adVarWChar,  objWebOrderModel.GetPlaceAddrDtl,               100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceFullAddr",               DBType.adVarWChar,  objWebOrderModel.GetPlaceFullAddr,              150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeName",             DBType.adVarWChar,  objWebOrderModel.GetPlaceChargeName,            50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetPlaceChargePosition",         DBType.adVarWChar,  objWebOrderModel.GetPlaceChargePosition,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeTelExtNo",         DBType.adVarChar,   objWebOrderModel.GetPlaceChargeTelExtNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeTelNo",            DBType.adVarChar,   objWebOrderModel.GetPlaceChargeTelNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceChargeCell",             DBType.adVarChar,   objWebOrderModel.GetPlaceChargeCell,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceNote",                   DBType.adVarWChar,  objWebOrderModel.GetPlaceNote,                  300,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarTonCode",                     DBType.adVarChar,   objWebOrderModel.CarTonCode,                    5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",                    DBType.adVarChar,   objWebOrderModel.CarTypeCode,                   5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNoteClient",                     DBType.adVarWChar,  objWebOrderModel.NoteClient,                    1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsItemCode",                  DBType.adVarChar,   objWebOrderModel.GoodsItemCode,                 5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsRunType",                   DBType.adTinyInt,   objWebOrderModel.GoodsRunType,                  0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strFTLFlag",                        DBType.adChar,      objWebOrderModel.FTLFlag,                       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLength",                         DBType.adInteger,   objWebOrderModel.Length,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intVolume",                         DBType.adInteger,   objWebOrderModel.Volume,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",                         DBType.adDouble,    objWebOrderModel.Weight,                        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strQuantity",                       DBType.adVarWChar,  objWebOrderModel.Quantity,                      500,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intCBM",                            DBType.adDouble,    objWebOrderModel.CBM,                           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsNote",                      DBType.adVarWChar,  objWebOrderModel.GoodsNote,                     500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShuttleEtc",                     DBType.adVarWChar,  objWebOrderModel.ShuttleEtc,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportFlag",              DBType.adChar,      objWebOrderModel.ArrivalReportFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBondedFlag",                     DBType.adChar,      objWebOrderModel.BondedFlag,                    1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intReqTransType",                   DBType.adTinyInt,   objWebOrderModel.ReqTransType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNation",                         DBType.adVarWChar,  objWebOrderModel.Nation,                        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strHawb",                           DBType.adVarChar,   objWebOrderModel.Hawb,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMawb",                           DBType.adVarChar,   objWebOrderModel.Mawb,                          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInvoiceNo",                      DBType.adVarChar,   objWebOrderModel.InvoiceNo,                     50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strBookingNo",                      DBType.adVarChar,   objWebOrderModel.BookingNo,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStockNo",                        DBType.adVarChar,   objWebOrderModel.StockNo,                       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",                     DBType.adVarChar,   objWebOrderModel.UpdAdminID,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",                   DBType.adVarWChar,  objWebOrderModel.UpdAdminName,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                         DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",                         DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                       DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                       DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);
                 
                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_TX_UPD");

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
                                     , 9103, "System error(SetWebOrderUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 취소
        /// </summary>
        /// <param name="objWebOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<WebOrderModel> SetWebOrderCancel(WebOrderModel objWebOrderModel)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderCancel REQ] {JsonConvert.SerializeObject(objWebOrderModel)}", bLogWrite);

            ServiceResult<WebOrderModel> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<WebOrderModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intReqSeqNo",   DBType.adBigInt,    objWebOrderModel.ReqSeqNo,      0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarChar,   objWebOrderModel.UpdAdminID,    50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",  DBType.adVarWChar,  objWebOrderModel.UpdAdminName,  50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,   DBNull.Value,                   256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,   DBNull.Value,                   0,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,   DBNull.Value,                   256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,   DBNull.Value,                   0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_TX_CNL");

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
                                     , 9104, "System error(SetWebOrderCancel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderCancel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더원본
        /// </summary>
        /// <param name="objWebReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<WebResOrderList> GetWebRequestOrderList(WebReqOrderList objWebReqOrderList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebRequestOrderList REQ] {JsonConvert.SerializeObject(objWebReqOrderList)}", bLogWrite);

            string                         lo_strJson   = string.Empty;
            ServiceResult<WebResOrderList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<WebResOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intReqSeqNo",           DBType.adBigInt,    objWebReqOrderList.ReqSeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objWebReqOrderList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",           DBType.adTinyInt,   objWebReqOrderList.DateType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar,   objWebReqOrderList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar,   objWebReqOrderList.DateTo,              8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    objWebReqOrderList.OrderNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",    DBType.adVarWChar,  objWebReqOrderList.OrderClientName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",      DBType.adVarWChar,  objWebReqOrderList.PayClientName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",      DBType.adVarWChar,  objWebReqOrderList.ConsignorName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqChargeName",      DBType.adVarWChar,  objWebReqOrderList.ReqChargeName,       50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGoodsName",          DBType.adVarWChar,  objWebReqOrderList.GoodsName,           100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intReqStatus",          DBType.adTinyInt,   objWebReqOrderList.ReqStatus,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objWebReqOrderList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objWebReqOrderList.PageSize,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objWebReqOrderList.PageNo,              0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new WebResOrderList
                {
                    list      = new List<WebOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<WebOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9105, "System error(GetWebRequestOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebRequestOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 변경요청
        /// </summary>
        /// <param name="objWebOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<WebOrderModel> SetWebOrderRequestChgIns(WebOrderModel objWebOrderModel)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderRequestChgIns REQ] {JsonConvert.SerializeObject(objWebOrderModel)}", bLogWrite);

            ServiceResult<WebOrderModel> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<WebOrderModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objWebOrderModel.CenterCode,        0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    objWebOrderModel.OrderNo,           0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",    DBType.adInteger,   objWebOrderModel.OrderClientCode,   0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChgReqContent",      DBType.adVarWChar,  objWebOrderModel.ChgReqContent,     4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChgMessage",         DBType.adVarWChar,  objWebOrderModel.ChgMessage,        4000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intChgStatus",          DBType.adTinyInt,   objWebOrderModel.ChgStatus,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",         DBType.adVarChar,   objWebOrderModel.RegAdminID,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",       DBType.adVarWChar,  objWebOrderModel.RegAdminName,      50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intChgSeqNo",           DBType.adBigInt,    DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                       256,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                       256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                       0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_CHG_TX_INS");

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

                objWebOrderModel.ChgSeqNo = lo_objDas.GetParam("@po_intChgSeqNo").ToInt64();
                lo_objResult.data         = objWebOrderModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9106, "System error(SetWebOrderRequestChgIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderRequestChgIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 변경요청
        /// </summary>
        /// <param name="objWebOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<WebOrderModel> SetWebOrderRequestChgUpd(WebOrderModel objWebOrderModel)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderRequestChgUpd REQ] {JsonConvert.SerializeObject(objWebOrderModel)}", bLogWrite);

            ServiceResult<WebOrderModel> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<WebOrderModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intChgSeqNo",       DBType.adInteger,   objWebOrderModel.ChgSeqNo,      0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChgReqContent",  DBType.adVarWChar,  objWebOrderModel.ChgReqContent, 4000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChgMessage",     DBType.adVarWChar,  objWebOrderModel.ChgMessage,    4000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intChgStatus",      DBType.adTinyInt,   objWebOrderModel.ChgStatus,     0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",     DBType.adVarChar,   objWebOrderModel.UpdAdminID,    50,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUpdAdminName",   DBType.adVarWChar,  objWebOrderModel.UpdAdminName,  50,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                   256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                   256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_CHG_TX_UPD");

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
                                     , 9106, "System error(SetWebOrderRequestChgUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetWebOrderRequestChgUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 변경요청
        /// </summary>
        /// <param name="objWebReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<WebResOrderList> GetWebRequestChgList(WebReqOrderList objWebReqOrderList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebRequestChgList REQ] {JsonConvert.SerializeObject(objWebReqOrderList)}", bLogWrite);

            string                         lo_strJson   = string.Empty;
            ServiceResult<WebResOrderList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<WebResOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intChgSeqNo",             DBType.adBigInt,    objWebReqOrderList.ChgSeqNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objWebReqOrderList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",              DBType.adBigInt,    objWebReqOrderList.OrderNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",      DBType.adInteger,   objWebReqOrderList.OrderClientCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intChgStatus",            DBType.adTinyInt,   objWebReqOrderList.ChgStatus,             0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateFrom",             DBType.adVarChar,   objWebReqOrderList.DateFrom,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",               DBType.adVarChar,   objWebReqOrderList.DateTo,                8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objWebReqOrderList.AccessCenterCode,      512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objWebReqOrderList.PageSize,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objWebReqOrderList.PageNo,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_CHG_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new WebResOrderList
                {
                    list      = new List<WebOrderGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<WebOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9107, "System error(GetWebRequestChgList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebRequestChgList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        /// <summary>
        /// 청구내역
        /// </summary>
        /// <param name="objReqOrderSaleClosingList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderSaleClosingList> GetOrderSaleClosingClientList(ReqOrderSaleClosingList objReqOrderSaleClosingList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetOrderSaleClosingClientList REQ] {JsonConvert.SerializeObject(objReqOrderSaleClosingList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResOrderSaleClosingList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderSaleClosingList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",   DBType.adBigInt,  objReqOrderSaleClosingList.SaleClosingSeqNo,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger, objReqOrderSaleClosingList.CenterCode,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",           DBType.adTinyInt, objReqOrderSaleClosingList.DateType,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar, objReqOrderSaleClosingList.DateFrom,          8,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar, objReqOrderSaleClosingList.DateTo,            8,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intBillStatus",         DBType.adTinyInt, objReqOrderSaleClosingList.BillStatus,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",          DBType.adTinyInt, objReqOrderSaleClosingList.GradeCode,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar, objReqOrderSaleClosingList.AccessCenterCode,  512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",       DBType.adVarChar, objReqOrderSaleClosingList.AccessCorpNo,      512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger, objReqOrderSaleClosingList.PageSize,          0,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger, objReqOrderSaleClosingList.PageNo,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger, DBNull.Value,                                 0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_SALE_CLOSING_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderSaleClosingList
                {
                    list      = new List<OrderSaleClosingListGrid>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderSaleClosingListGrid>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9108, "System error(GetOrderSaleClosingClientList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetOrderSaleClosingClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 청구내역 상세
        /// </summary>
        /// <param name="objWebReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderSaleClosingList> GetOrderSaleClosingClientDtlList(ReqOrderSaleClosingList objWebReqOrderList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetOrderSaleClosingClientDtlList REQ] {JsonConvert.SerializeObject(objWebReqOrderList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResOrderSaleClosingList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderSaleClosingList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",     DBType.adBigInt,    objWebReqOrderList.SaleClosingSeqNo,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objWebReqOrderList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",            DBType.adTinyInt,   objWebReqOrderList.GradeCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objWebReqOrderList.AccessCenterCode,      512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",         DBType.adVarChar,   objWebReqOrderList.AccessCorpNo,          512,     ParameterDirection.Input);

                lo_objDas.AddParam("@po_intAdvanceOrgAmt",        DBType.adCurrency,  DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_SALE_CLOSING_DTL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderSaleClosingList
                {
                    list          = new List<OrderSaleClosingListGrid>(),
                    AdvanceOrgAmt = lo_objDas.GetParam("@po_intAdvanceOrgAmt").ToDouble()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderSaleClosingListGrid>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9109, "System error(GetOrderSaleClosingClientDtlList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetOrderSaleClosingClientDtlList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 영보공업 입출차 관리
        /// </summary>
        /// <param name="objWebOrderModel"></param>
        /// <returns></returns>
        public ServiceResult<WebOrderModel> SetOrderDispatchInOutUpd(WebOrderModel objWebOrderModel)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetOrderDispatchInOutUpd REQ] {JsonConvert.SerializeObject(objWebOrderModel)}", bLogWrite);

            ServiceResult<WebOrderModel> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<WebOrderModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intDispatchSeqNo",    DBType.adBigInt,    objWebOrderModel.DispatchSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   objWebOrderModel.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intInOutType",        DBType.adTinyInt,   objWebOrderModel.InOutType,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",          DBType.adChar,      objWebOrderModel.CnlFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInOutEtc",         DBType.adVarWChar,  objWebOrderModel.InOutEtc,         500,     ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_CAR_INOUT_TX_UPD");

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
                                     , 9110, "System error(SetOrderDispatchInOutUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[SetOrderDispatchInOutUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 웹오더 수정요청
        /// </summary>
        /// <param name="objReqOrderSaleClosingList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderRequestChgList> GetOrderRequestWeborderChgList(ReqOrderRequestChgList objReqOrderRequestChgList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetOrderRequestWeborderChgList REQ] {JsonConvert.SerializeObject(objReqOrderRequestChgList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResOrderRequestChgList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderRequestChgList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intChgSeqNo",           DBType.adBigInt,    objReqOrderRequestChgList.ChgSeqNo,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqOrderRequestChgList.CenterCode,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    objReqOrderRequestChgList.OrderNo,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderClientCode",    DBType.adInteger,   objReqOrderRequestChgList.OrderClientCode,  0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intChgStatus",          DBType.adTinyInt,   objReqOrderRequestChgList.ChgStatus,        0,    ParameterDirection.Input);
                                                                                                                                      
                lo_objDas.AddParam("@pi_intListType",           DBType.adTinyInt,   objReqOrderRequestChgList.ListType,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar,   objReqOrderRequestChgList.DateFrom,         8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar,   objReqOrderRequestChgList.DateTo,           8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyChargeFlag",       DBType.adChar,      objReqOrderRequestChgList.MyChargeFlag,     0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objReqOrderRequestChgList.AdminID,          0,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqOrderRequestChgList.AccessCenterCode, 512,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqOrderRequestChgList.PageSize,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqOrderRequestChgList.PageNo,           0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                               0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_WEBORDER_CHG_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderRequestChgList
                {
                    list      = new List<OrderRequestChgListGrid>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderRequestChgListGrid>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9111, "System error(GetOrderRequestWeborderChgList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetOrderRequestWeborderChgList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사 - 화주 연결 목록
        /// </summary>
        /// <param name="objReqWebConsignorList"></param>
        /// <returns></returns>
        public ServiceResult<ResWebConsignorList> GetWebConsignorList(ReqWebConsignorList objReqWebConsignorList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebConsignorList REQ] {JsonConvert.SerializeObject(objReqWebConsignorList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResWebConsignorList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResWebConsignorList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intConsignorCode",      DBType.adBigInt,    objReqWebConsignorList.ConsignorCode,    0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqWebConsignorList.CenterCode,       0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",      DBType.adVarWChar,  objReqWebConsignorList.ConsignorName,    50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_IntGradeCode",          DBType.adTinyInt,   objReqWebConsignorList.GradeCode,        0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqWebConsignorList.AccessCenterCode, 512,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCorpNo",       DBType.adVarChar,   objReqWebConsignorList.AccessCorpNo,     512,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,      objReqWebConsignorList.UseFlag,          1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqWebConsignorList.PageSize,         0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqWebConsignorList.PageNo,           0,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                            0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_CONSIGNOR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResWebConsignorList
                {
                    list      = new List<WebConsignorModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<WebConsignorModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetWebConsignorList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebConsignorList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 상하차지 리스트
        /// </summary>
        public ServiceResult<ResClientPlaceChargeList> GetWebOrderPlaceChargeList(ReqClientPlaceChargeList objClientPlaceChargeList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebOrderPlaceChargeList REQ] {JsonConvert.SerializeObject(objClientPlaceChargeList)}", bLogWrite);

            string                                  lo_strJson   = string.Empty;
            ServiceResult<ResClientPlaceChargeList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientPlaceChargeList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",                DBType.adBigInt,    objClientPlaceChargeList.SeqNo,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPlaceSeqNo",           DBType.adBigInt,    objClientPlaceChargeList.PlaceSeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objClientPlaceChargeList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",              DBType.adChar,      objClientPlaceChargeList.UseFlag,               1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",           DBType.adVarWChar,  objClientPlaceChargeList.ChargeName,            50,      ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_strChargeTelNo",          DBType.adVarChar,   objClientPlaceChargeList.ChargeTelNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeCell",           DBType.adVarChar,   objClientPlaceChargeList.ChargeCell,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",            DBType.adVarWChar,  objClientPlaceChargeList.PlaceName,             100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeUseFlag",        DBType.adChar,      objClientPlaceChargeList.ChargeUseFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",            DBType.adTinyInt,   objClientPlaceChargeList.GradeCode,             0,       ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objClientPlaceChargeList.AccessCenterCode,      512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",         DBType.adVarChar,   objClientPlaceChargeList.AccessCorpNo,          512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objClientPlaceChargeList.PageSize,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objClientPlaceChargeList.PageNo,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_PLACE_CHARGE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientPlaceChargeList
                {
                    list      = new List<ClientPlaceChargeListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientPlaceChargeListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetWebOrderPlaceChargeList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebOrderPlaceChargeList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ClientPlaceChargeViewModel> InsWebOrderPlace(ClientPlaceChargeViewModel objInsWebOrderPlace)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[InsWebOrderPlace REQ] {JsonConvert.SerializeObject(objInsWebOrderPlace)}", bLogWrite);

            ServiceResult<ClientPlaceChargeViewModel> lo_objResult = null;
            IDasNetCom                                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ClientPlaceChargeViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objInsWebOrderPlace.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCorpNo",           DBType.adVarChar,   objInsWebOrderPlace.ClientCorpNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",              DBType.adVarWChar,  objInsWebOrderPlace.PlaceName,             100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlacePost",              DBType.adVarChar,   objInsWebOrderPlace.PlacePost,             6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddr",              DBType.adVarWChar,  objInsWebOrderPlace.PlaceAddr,             100,     ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strPlaceAddrDtl",           DBType.adVarWChar,  objInsWebOrderPlace.PlaceAddrDtl,          100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSido",                   DBType.adVarWChar,  objInsWebOrderPlace.Sido,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGugun",                  DBType.adVarWChar,  objInsWebOrderPlace.Gugun,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDong",                   DBType.adVarWChar,  objInsWebOrderPlace.Dong,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFullAddr",               DBType.adVarWChar,  objInsWebOrderPlace.FullAddr,              150,     ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strChargeName",             DBType.adVarWChar,  objInsWebOrderPlace.ChargeName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelNo",            DBType.adVarChar,   objInsWebOrderPlace.ChargeTelNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelExtNo",         DBType.adVarChar,   objInsWebOrderPlace.ChargeTelExtNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeCell",             DBType.adVarChar,   objInsWebOrderPlace.ChargeCell,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeFaxNo",            DBType.adVarChar,   objInsWebOrderPlace.ChargeFaxNo,           20,      ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strChargeEmail",            DBType.adVarChar,   objInsWebOrderPlace.ChargeEmail,           100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargePosition",         DBType.adVarWChar,  objInsWebOrderPlace.ChargePosition,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeDepartment",       DBType.adVarWChar,  objInsWebOrderPlace.ChargeDepartment,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeNote",             DBType.adVarWChar,  objInsWebOrderPlace.ChargeNote,            500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceNote",              DBType.adVarWChar,  objInsWebOrderPlace.PlaceNote,             500,     ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strRegAdminID",             DBType.adVarChar,   objInsWebOrderPlace.AdminID,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",           DBType.adVarWChar,  objInsWebOrderPlace.AdminName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intPlaceSeqNo",             DBType.adBigInt,    DBNull.Value,                              0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                              256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);
                                                                                                                                   
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                              256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_PLACE_TX_INS");

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

                objInsWebOrderPlace.PlaceSeqNo = lo_objDas.GetParam("@po_intPlaceSeqNo").ToInt64();
                lo_objResult.data              = objInsWebOrderPlace;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(InsWebOrderPlace) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[InsWebOrderPlace RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        //상하차지 수정
        public ServiceResult<ClientPlaceChargeViewModel> UpdWebOrderPlace(ClientPlaceChargeViewModel objInsWebOrderPlace)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[UpdWebOrderPlace REQ] {JsonConvert.SerializeObject(objInsWebOrderPlace)}", bLogWrite);

            ServiceResult<ClientPlaceChargeViewModel> lo_objResult = null;
            IDasNetCom                                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ClientPlaceChargeViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPlaceSeqNo",      DBType.adBigInt,    objInsWebOrderPlace.PlaceSeqNo,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",      DBType.adInteger,   objInsWebOrderPlace.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddrDtl",    DBType.adVarWChar,  objInsWebOrderPlace.PlaceAddrDtl,    100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceNote",       DBType.adVarWChar,  objInsWebOrderPlace.PlaceNote,       500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",         DBType.adChar,      objInsWebOrderPlace.UseFlag,         1,       ParameterDirection.Input);
                                                             
                lo_objDas.AddParam("@pi_strUpdAdminID",      DBType.adVarChar,   objInsWebOrderPlace.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",    DBType.adVarWChar,  objInsWebOrderPlace.AdminName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                                                                                                                   
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_PLACE_TX_UPD");

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
                                     , 9101, "System error(UpdWebOrderPlace) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[UpdWebOrderPlace RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> InsWebOrderPlaceCharge(ClientPlaceChargeViewModel objInsClientPlaceCharge)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[InsWebOrderPlaceCharge REQ] {JsonConvert.SerializeObject(objInsClientPlaceCharge)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPlaceSeqNo",            DBType.adBigInt,    objInsClientPlaceCharge.PlaceSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeName",            DBType.adVarWChar,  objInsClientPlaceCharge.ChargeName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelNo",           DBType.adVarChar,   objInsClientPlaceCharge.ChargeTelNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeTelExtNo",        DBType.adVarChar,   objInsClientPlaceCharge.ChargeTelExtNo,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeCell",            DBType.adVarChar,   objInsClientPlaceCharge.ChargeCell,           20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strChargeFaxNo",           DBType.adVarChar,   objInsClientPlaceCharge.ChargeFaxNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeEmail",           DBType.adVarChar,   objInsClientPlaceCharge.ChargeEmail,          100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargePosition",        DBType.adVarWChar,  objInsClientPlaceCharge.ChargePosition,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeDepartment",      DBType.adVarWChar,  objInsClientPlaceCharge.ChargeDepartment,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChargeNote",            DBType.adVarWChar,  objInsClientPlaceCharge.ChargeNote,           500,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRegAdminID",            DBType.adVarChar,   objInsClientPlaceCharge.AdminID,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",                 DBType.adBigInt,    DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                                                                                                                                     
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_PLACE_CHARGE_TX_INS");

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
                                     , 9601, "System error(InsWebOrderPlaceCharge) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[InsWebOrderPlaceCharge RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResClientPlaceChargeList> GetWebOrderPlaceList(ReqClientPlaceChargeList objClientPlaceChargeList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebOrderPlaceList REQ] {JsonConvert.SerializeObject(objClientPlaceChargeList)}", bLogWrite);

            string                                  lo_strJson   = string.Empty;
            ServiceResult<ResClientPlaceChargeList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientPlaceChargeList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPlaceSeqNo",          DBType.adBigInt,    objClientPlaceChargeList.PlaceSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objClientPlaceChargeList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",          DBType.adVarWChar,  objClientPlaceChargeList.ClientName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",          DBType.adBigInt,    objClientPlaceChargeList.ClientCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",             DBType.adChar,      objClientPlaceChargeList.UseFlag,              1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPlaceName",           DBType.adVarWChar,  objClientPlaceChargeList.PlaceName,            200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddr",           DBType.adVarWChar,  objClientPlaceChargeList.PlaceAddr,            100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFullAddr",            DBType.adVarWChar,  objClientPlaceChargeList.FullAddr,             150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",           DBType.adTinyInt,   objClientPlaceChargeList.GradeCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objClientPlaceChargeList.AccessCenterCode,     512,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCorpNo",        DBType.adVarChar,   objClientPlaceChargeList.AccessCorpNo,         512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objClientPlaceChargeList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objClientPlaceChargeList.PageNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_PLACE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientPlaceChargeList
                {
                    list      = new List<ClientPlaceChargeListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientPlaceChargeListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetWebOrderPlaceList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetWebOrderPlaceList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> DelWebOrderPlaceCharge(ClientPlaceChargeViewModel objInsClientPlaceCharge)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[DelWebOrderPlaceCharge REQ] {JsonConvert.SerializeObject(objInsClientPlaceCharge)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",      DBType.adInteger,   objInsClientPlaceCharge.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPlaceSeqNo",      DBType.adBigInt,    objInsClientPlaceCharge.PlaceSeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSeqNos1",         DBType.adVarChar,   objInsClientPlaceCharge.SeqNos1,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSeqNos2",         DBType.adVarChar,   objInsClientPlaceCharge.SeqNos2,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSeqNos3",         DBType.adVarChar,   objInsClientPlaceCharge.SeqNos3,          4000,    ParameterDirection.Input);
                                                                                                                           
                lo_objDas.AddParam("@pi_strSeqNos4",         DBType.adVarChar,   objInsClientPlaceCharge.SeqNos4,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSeqNos5",         DBType.adVarChar,   objInsClientPlaceCharge.SeqNos5,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",      DBType.adVarChar,   objInsClientPlaceCharge.AdminID,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalCount",      DBType.adTinyInt,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intResultCount",     DBType.adTinyInt,   DBNull.Value,                             0,       ParameterDirection.Output);
                                                                                                                           
                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_PLACE_CHARGE_SELECTED_TX_DEL");

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
                                     , 9101, "System error(DelWebOrderPlaceCharge) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[DelWebOrderPlaceCharge RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 비용 목록
        /// </summary>
        /// <param name="objReqOrderPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderPayList> GetOrderRequestPayList(int intCenterCode, Int64 intOrderNo, Int64 intClientCode, string strAccessCenterCode, string strAccessCorpNo)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetOrderRequestPayList REQ] {intCenterCode} | {intOrderNo} | {strAccessCenterCode}", bLogWrite);

            string                         lo_strJson   = string.Empty;
            ServiceResult<ResOrderPayList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   intCenterCode,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    intOrderNo,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,    intClientCode,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   strAccessCenterCode,  512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCorpNo",       DBType.adVarChar,   strAccessCorpNo,      512, ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,         0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderPayList
                {
                    list      = new List<OrderPayGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderRequestPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetOrderRequestPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매출 전표 오더 목록
        /// </summary>
        /// <param name="objReqSaleClosingOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResSaleClosingOrderList> GetRequestSaleClosingOrderList(ReqSaleClosingOrderList objReqSaleClosingOrderList)
        {
            SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetRequestSaleClosingOrderList REQ] {JsonConvert.SerializeObject(objReqSaleClosingOrderList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResSaleClosingOrderList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSaleClosingOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",      DBType.adBigInt,      objReqSaleClosingOrderList.SaleClosingSeqNo,    0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,     objReqSaleClosingOrderList.CenterCode,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",      DBType.adVarChar,     objReqSaleClosingOrderList.AccessCenterCode,    512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_REQUEST_SALE_CLOSING_ORDER_AR_LST");

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
                    list      = new List<SaleClosingOrderGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SaleClosingOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetRequestSaleClosingOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("WebOrderDasServices", "I", $"[GetRequestSaleClosingOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}