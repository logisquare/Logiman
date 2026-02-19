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
    public class OrderDispatchDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 배차현황
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchList> GetOrderDispatchList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",                    DBType.adBigInt,    objReqOrderDispatchList.OrderNo,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                 DBType.adInteger,   objReqOrderDispatchList.CenterCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",                   DBType.adTinyInt,   objReqOrderDispatchList.ListType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                   DBType.adTinyInt,   objReqOrderDispatchList.DateType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                   DBType.adVarChar,   objReqOrderDispatchList.DateFrom,                  8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateTo",                     DBType.adVarChar,   objReqOrderDispatchList.DateTo,                    8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsDispatchType",          DBType.adTinyInt,   objReqOrderDispatchList.GoodsDispatchType,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",         DBType.adVarChar,   objReqOrderDispatchList.OrderLocationCodes,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",             DBType.adVarChar,   objReqOrderDispatchList.OrderItemCodes,            4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderStatuses",              DBType.adVarChar,   objReqOrderDispatchList.OrderStatuses,             4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderClientName",            DBType.adVarWChar,  objReqOrderDispatchList.OrderClientName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientChargeName",      DBType.adVarWChar,  objReqOrderDispatchList.OrderClientChargeName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientName",              DBType.adVarWChar,  objReqOrderDispatchList.PayClientName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeName",        DBType.adVarWChar,  objReqOrderDispatchList.PayClientChargeName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayClientChargeLocation",    DBType.adVarWChar,  objReqOrderDispatchList.PayClientChargeLocation,   50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strConsignorName",              DBType.adVarWChar,  objReqOrderDispatchList.ConsignorName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlace",                DBType.adVarWChar,  objReqOrderDispatchList.PickupPlace,               200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlace",                   DBType.adVarWChar,  objReqOrderDispatchList.GetPlace,                  200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGoodsName",                  DBType.adVarWChar,  objReqOrderDispatchList.GoodsName,                 100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",                    DBType.adVarWChar,  objReqOrderDispatchList.ComName,                   50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strComCorpNo",                  DBType.adVarChar,   objReqOrderDispatchList.ComCorpNo,                 20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",                 DBType.adVarWChar,  objReqOrderDispatchList.DriverName,                20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                      DBType.adVarWChar,  objReqOrderDispatchList.CarNo,                     20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo2",                     DBType.adVarWChar,  objReqOrderDispatchList.CarNo2,                    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo3",                     DBType.adVarWChar,  objReqOrderDispatchList.CarNo3,                    20,      ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strNoteClient",                 DBType.adVarWChar,  objReqOrderDispatchList.NoteClient,                1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransCenterCode",            DBType.adInteger,   objReqOrderDispatchList.TransCenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intContractCenterCode",         DBType.adInteger,   objReqOrderDispatchList.ContractCenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminID",                  DBType.adVarChar,   objReqOrderDispatchList.CsAdminID,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcceptAdminName",            DBType.adVarWChar,  objReqOrderDispatchList.AcceptAdminName,           50,      ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strMyChargeFlag",               DBType.adChar,      objReqOrderDispatchList.MyChargeFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",                DBType.adChar,      objReqOrderDispatchList.MyOrderFlag,               1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",                    DBType.adChar,      objReqOrderDispatchList.CnlFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchAdminName",          DBType.adVarWChar,  objReqOrderDispatchList.DispatchAdminName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportFlag",          DBType.adChar,      objReqOrderDispatchList.ArrivalReportFlag,         1,       ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intArrivalReportClientCode",    DBType.adBigInt,    objReqOrderDispatchList.ArrivalReportClientCode,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportClientName",    DBType.adVarWChar,  objReqOrderDispatchList.ArrivalReportClientName,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGetStandardType",            DBType.adTinyInt,   objReqOrderDispatchList.GetStandardType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                    DBType.adVarChar,   objReqOrderDispatchList.AdminID,                   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",      DBType.adVarChar,   objReqOrderDispatchList.DeliveryLocationCodes,     4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDispatchType",               DBType.adTinyInt,   objReqOrderDispatchList.DispatchType,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderByPageType",            DBType.adTinyInt,   objReqOrderDispatchList.OrderByPageType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",           DBType.adVarChar,   objReqOrderDispatchList.AccessCenterCode,          512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",                   DBType.adInteger,   objReqOrderDispatchList.PageSize,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                     DBType.adInteger,   objReqOrderDispatchList.PageNo,                    0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",                  DBType.adInteger,   DBNull.Value,                                      0,       ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchList
                {
                    list      = new List<OrderDispatchGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("ContractStatusMView",  typeof(string));
                    lo_objDas.objDT.Columns.Add("JContractStatusMView", typeof(string));
                    lo_objDas.objDT.Columns.Add("GContractStatusMView", typeof(string));

                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["ContractStatusMView"] = row["ContractStatusM"].ToString();

                        if (row["ContractStatusM"].ToString().Equals("위탁") && row["ContractInfo"].ToString().IndexOf("/", StringComparison.Ordinal) > -1)
                        {
                            row["ContractStatusMView"] += "접수";
                        }

                        row["JContractStatusMView"] = row["JContractStatusM"].ToString();

                        if (row["JContractStatusM"].ToString().Equals("위탁") && row["JContractInfo"].ToString().IndexOf("/", StringComparison.Ordinal) > -1)
                        {
                            row["JContractStatusMView"] += "접수";
                        }

                        row["GContractStatusMView"] = row["GContractStatusM"].ToString();

                        if (row["GContractStatusM"].ToString().Equals("위탁") && row["GContractInfo"].ToString().IndexOf("/", StringComparison.Ordinal) > -1)
                        {
                            row["GContractStatusMView"] += "접수";
                        }
                    }

                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderDispatchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 직송/집하 구분 변경
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchUpd> UpdDispatchType(ReqOrderDispatchUpd objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdDispatchType REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<ResOrderDispatchUpd> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchUpd>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strOrderNos",            DBType.adVarChar,   objInsReqOrderDispatchUpd.OrderNos,               8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objInsReqOrderDispatchUpd.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsDispatchType",   DBType.adTinyInt,   objInsReqOrderDispatchUpd.GoodsDispatchType,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",           DBType.adVarWChar,  objInsReqOrderDispatchUpd.AdminName,              50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_GOODS_DISPATCH_TYPE_TX_UPD");

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
                                     , 9102, "System error(UpdDispatchType)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdDispatchType RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 수출입/컨테이너 출력물
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchList> GetOrderDispatchPrintList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchPrintList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strOrderNos1",          DBType.adVarChar, objReqOrderDispatchList.OrderNos1,          8000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos2",          DBType.adVarChar, objReqOrderDispatchList.OrderNos2,          8000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger, objReqOrderDispatchList.CenterCode,         0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",   DBType.adBigInt,  objReqOrderDispatchList.SaleClosingSeqNo,   0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,  objReqOrderDispatchList.ClientCode,         0,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intListType",           DBType.adTinyInt, objReqOrderDispatchList.ListType,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",           DBType.adTinyInt, objReqOrderDispatchList.DateType,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar, objReqOrderDispatchList.DateFrom,           8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar, objReqOrderDispatchList.DateTo,             8,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar, objReqOrderDispatchList.AccessCenterCode,   512,    ParameterDirection.Input);

                lo_objDas.AddParam("@po_intOrgAmtTotal",        DBType.adDouble,  DBNull.Value,                               0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_intSupplyAmtTotal",     DBType.adDouble,  DBNull.Value,                               0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTaxAmtTotal",        DBType.adDouble,  DBNull.Value,                               0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger, DBNull.Value,                               0,      ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_PRINT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchList
                {
                    list           = new List<OrderDispatchGridModel>(),
                    RecordCnt      = lo_objDas.GetParam("@po_intRecordCnt").ToInt(),
                    SupplyAmtTotal = lo_objDas.GetParam("@po_intSupplyAmtTotal").ToDouble(),
                    TaxAmtTotal    = lo_objDas.GetParam("@po_intTaxAmtTotal").ToDouble(),
                    OrgAmtTotal    = lo_objDas.GetParam("@po_intOrgAmtTotal").ToDouble()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("AcctNo", typeof(string));

                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["AcctNo"] = CommonUtils.Utils.GetDecrypt(row["EncAcctNoInfo"].ToString());
                    }

                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9106, "System error(GetOrderDispatchPrintList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchPrintList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 내수 출력물
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchList> GetOrderDispatchDomesticPrintList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchDomesticPrintList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strOrderNos1",          DBType.adVarChar,   objReqOrderDispatchList.OrderNos1,           8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos2",          DBType.adVarChar,   objReqOrderDispatchList.OrderNos2,           8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",   DBType.adBigInt,    objReqOrderDispatchList.SaleClosingSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqOrderDispatchList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,    objReqOrderDispatchList.ClientCode,          0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intListType",           DBType.adTinyInt,   objReqOrderDispatchList.ListType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",           DBType.adTinyInt,   objReqOrderDispatchList.DateType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar,   objReqOrderDispatchList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar,   objReqOrderDispatchList.DateTo,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqOrderDispatchList.AccessCenterCode,    512,     ParameterDirection.Input);

                lo_objDas.AddParam("@po_intOrgAmtTotal",        DBType.adDouble,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intSupplyAmtTotal",     DBType.adDouble,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTaxAmtTotal",        DBType.adDouble,    DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_DOMESTIC_PRINT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchList
                {
                    list            = new List<OrderDispatchGridModel>(),
                    RecordCnt       = lo_objDas.GetParam("@po_intRecordCnt").ToInt(),
                    SupplyAmtTotal  = lo_objDas.GetParam("@po_intSupplyAmtTotal").ToDouble(),
                    TaxAmtTotal     = lo_objDas.GetParam("@po_intTaxAmtTotal").ToDouble(),
                    OrgAmtTotal     = lo_objDas.GetParam("@po_intOrgAmtTotal").ToDouble()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("AcctNo", typeof(string));
                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["AcctNo"] = CommonUtils.Utils.GetDecrypt(row["EncAcctNoInfo"].ToString());
                    }

                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9106, "System error(GetOrderDispatchDomesticPrintList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchDomesticPrintList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 비용등록 목록
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchPayList> GetOrderDispatchPayList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchPayList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchPayList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,   objReqOrderDispatchList.OrderNo,              0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,  objReqOrderDispatchList.CenterCode,           0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",           DBType.adTinyInt,  objReqOrderDispatchList.ListType,             0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",           DBType.adTinyInt,  objReqOrderDispatchList.DateType,             0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar,  objReqOrderDispatchList.DateFrom,             8,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar,  objReqOrderDispatchList.DateTo,               8,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsDispatchType",  DBType.adTinyInt,  objReqOrderDispatchList.GoodsDispatchType,    0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes", DBType.adVarChar,  objReqOrderDispatchList.OrderLocationCodes,   4000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",     DBType.adVarChar,  objReqOrderDispatchList.OrderItemCodes,       4000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",            DBType.adVarWChar, objReqOrderDispatchList.ComName,              100,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarNo",              DBType.adVarWChar, objReqOrderDispatchList.CarNo,                20,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseItemCode",   DBType.adVarChar,  objReqOrderDispatchList.PurchaseItemCode,     5,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",            DBType.adChar,     objReqOrderDispatchList.CnlFlag,              1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,  objReqOrderDispatchList.AccessCenterCode,     512,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,  objReqOrderDispatchList.PageSize,             0,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,  objReqOrderDispatchList.PageNo,               0,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,  DBNull.Value,                                 0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchPayList
                {
                    list      = new List<OrderDispatchPayGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9206, "System error(GetOrderDispatchPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 도착보고 비용등록 목록
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchList> GetOrderDispatchArrivalPayList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchArrivalPayList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",              DBType.adBigInt,    objReqOrderDispatchList.OrderNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqOrderDispatchList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",             DBType.adTinyInt,   objReqOrderDispatchList.ListType,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",             DBType.adTinyInt,   objReqOrderDispatchList.DateType,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",             DBType.adVarChar,   objReqOrderDispatchList.DateFrom,              8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDateTo",               DBType.adVarChar,   objReqOrderDispatchList.DateTo,                8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",   DBType.adVarChar,   objReqOrderDispatchList.OrderLocationCodes,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",       DBType.adVarChar,   objReqOrderDispatchList.OrderItemCodes,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",           DBType.adVarWChar,  objReqOrderDispatchList.OrderClientName,       100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseItemCode",     DBType.adVarChar,   objReqOrderDispatchList.PurchaseItemCode,      5,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCnlFlag",              DBType.adChar,      objReqOrderDispatchList.CnlFlag,               1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportFlag",    DBType.adChar,      objReqOrderDispatchList.ArrivalReportFlag,     1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqOrderDispatchList.AccessCenterCode,      512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objReqOrderDispatchList.PageSize,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objReqOrderDispatchList.PageNo,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_ARRIVAL_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchList
                {
                    list      = new List<OrderDispatchGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9206, "System error(GetOrderDispatchArrivalPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchArrivalPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 배송 사업장 변경(요청)
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchUpd> UpdOrderDeliveryLocationReq(ReqOrderDispatchUpd objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdOrderDeliveryLocationReq REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<ResOrderDispatchUpd> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchUpd>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strOrderNos",              DBType.adVarChar,   objInsReqOrderDispatchUpd.OrderNos,               8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objInsReqOrderDispatchUpd.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryLocationCode",  DBType.adVarChar,   objInsReqOrderDispatchUpd.DeliveryLocationCode,   5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",               DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",             DBType.adVarWChar,  objInsReqOrderDispatchUpd.AdminName,              50,      ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DELIVERY_LOCATION_REQ_TX_UPD");

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
                                     , 9105, "System error(UpdOrderDeliveryLocationReq)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdOrderDeliveryLocationReq RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 집하/간선 적재 비용등록 목록
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchList> GetCollectPayList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetCollectPayList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objReqOrderDispatchList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",              DBType.adTinyInt,   objReqOrderDispatchList.ListType,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",              DBType.adTinyInt,   objReqOrderDispatchList.DateType,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",              DBType.adVarChar,   objReqOrderDispatchList.DateFrom,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                DBType.adVarChar,   objReqOrderDispatchList.DateTo,                8,       ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_intGoodsDispatchType",     DBType.adTinyInt,   objReqOrderDispatchList.GoodsDispatchType,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",          DBType.adTinyInt,   objReqOrderDispatchList.DispatchType,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",    DBType.adVarChar,   objReqOrderDispatchList.OrderLocationCodes,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",        DBType.adVarChar,   objReqOrderDispatchList.OrderItemCodes,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",       DBType.adVarWChar,  objReqOrderDispatchList.OrderClientName,       50,      ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strPayClientName",         DBType.adVarWChar,  objReqOrderDispatchList.PayClientName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",         DBType.adVarWChar,  objReqOrderDispatchList.ConsignorName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",               DBType.adVarWChar,  objReqOrderDispatchList.ComName,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                 DBType.adVarWChar,  objReqOrderDispatchList.CarNo,                 20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",               DBType.adChar,      objReqOrderDispatchList.CnlFlag,               1,       ParameterDirection.Input);
                                                                   
                lo_objDas.AddParam("@pi_strDispatchAdminName",     DBType.adVarWChar,  objReqOrderDispatchList.DispatchAdminName,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",               DBType.adVarChar,   objReqOrderDispatchList.AdminID,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",      DBType.adVarChar,   objReqOrderDispatchList.AccessCenterCode,      512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_COLLECT_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchList
                {
                    list = new List<OrderDispatchGridModel>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9301, "System error(GetCollectPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetCollectPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 적재 비용 등록
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<OrderDispatchModel> InsCarLoadPay(OrderDispatchModel objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsCarLoadPay REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<OrderDispatchModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderDispatchModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objInsReqOrderDispatchUpd.CenterCode,           0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",               DBType.adTinyInt,   objInsReqOrderDispatchUpd.ListType,             0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",               DBType.adTinyInt,   objInsReqOrderDispatchUpd.DateType,             0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",               DBType.adVarChar,   objInsReqOrderDispatchUpd.DateFrom,             8,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                 DBType.adVarChar,   objInsReqOrderDispatchUpd.DateTo,               8,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intGoodsDispatchType",      DBType.adTinyInt,   objInsReqOrderDispatchUpd.GoodsDispatchType,    0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",           DBType.adTinyInt,   objInsReqOrderDispatchUpd.DispatchType,         0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",     DBType.adVarChar,   objInsReqOrderDispatchUpd.OrderLocationCodes,   4000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",         DBType.adVarChar,   objInsReqOrderDispatchUpd.OrderItemCodes,       4000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderClientName",        DBType.adVarWChar,  objInsReqOrderDispatchUpd.OrderClientName,      50,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayClientName",          DBType.adVarWChar,  objInsReqOrderDispatchUpd.PayClientName,        50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",          DBType.adVarWChar,  objInsReqOrderDispatchUpd.ConsignorName,        50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",                DBType.adVarWChar,  objInsReqOrderDispatchUpd.ComName,              50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                  DBType.adVarWChar,  objInsReqOrderDispatchUpd.CarNo,                20,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlFlag",                DBType.adChar,      objInsReqOrderDispatchUpd.CnlFlag,              1,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDispatchAdminName",      DBType.adVarWChar,  objInsReqOrderDispatchUpd.DispatchAdminName,    50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",       DBType.adVarWChar,  objInsReqOrderDispatchUpd.AccessCenterCode,     512,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchInfos",          DBType.adVarChar,   objInsReqOrderDispatchUpd.DispatchInfo,         8000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseSupplyAmt",      DBType.adDouble,    objInsReqOrderDispatchUpd.PurchaseSupplyAmt,    0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intProcType",               DBType.adTinyInt,   objInsReqOrderDispatchUpd.ProcType,             0,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminID,              50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",              DBType.adVarWChar,  objInsReqOrderDispatchUpd.AdminName,            50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                                   256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                                   0,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                                   256,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                                   0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CAR_LOAD_PAY_TX_INS");

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
                                     , 9302, "System error(InsCarLoadPay)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsCarLoadPay RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 위탁 요청
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<OrderDispatchModel> InsContractMultiReq(OrderDispatchModel objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsContractMultiReq REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<OrderDispatchModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderDispatchModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objInsReqOrderDispatchUpd.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",             DBType.adVarChar,   objInsReqOrderDispatchUpd.OrderNos,               8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intContractCenterCode",   DBType.adInteger,   objInsReqOrderDispatchUpd.ContractCenterCode,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strContractInfo",         DBType.adVarWChar,  objInsReqOrderDispatchUpd.ContractInfo,           200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",         DBType.adTinyInt,   objInsReqOrderDispatchUpd.DispatchType,           0,       ParameterDirection.Input);
                                                                                                                                        
                lo_objDas.AddParam("@pi_strAdminID",              DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",            DBType.adVarWChar,  objInsReqOrderDispatchUpd.AdminName,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminTelNo",           DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminTelNo,             20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminMobileNo",        DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminMobileNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalCnt",             DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                                                                                                                                        
                lo_objDas.AddParam("@po_intSuccCnt",              DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intFailCnt",              DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",               DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",               DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",             DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                                                                                                                                        
                lo_objDas.AddParam("@po_intDBRetVal",             DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTRACT_MULTI_REQ_TX_INS");

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
                objInsReqOrderDispatchUpd.TotalCnt = lo_objDas.GetParam("@po_intTotalCnt").ToInt();
                objInsReqOrderDispatchUpd.SuccCnt  = lo_objDas.GetParam("@po_intSuccCnt").ToInt();
                objInsReqOrderDispatchUpd.FailCnt  = lo_objDas.GetParam("@po_intFailCnt").ToInt();
                lo_objResult.data                  = objInsReqOrderDispatchUpd;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9302, "System error(InsContractMultiReq)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsContractMultiReq RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 배차 처리
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<OrderDispatchModel> InsOrderDispatchMulti(OrderDispatchModel objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsOrderDispatchMulti REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<OrderDispatchModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderDispatchModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,     objInsReqOrderDispatchUpd.CenterCode,         0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",         DBType.adVarChar,     objInsReqOrderDispatchUpd.OrderNos,           8000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",         DBType.adBigInt,      objInsReqOrderDispatchUpd.RefSeqNo,           0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",     DBType.adTinyInt,     objInsReqOrderDispatchUpd.DispatchType,       0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intQuickType",        DBType.adTinyInt,     objInsReqOrderDispatchUpd.QuickType,          0,     ParameterDirection.Input);
                                                                                    
                lo_objDas.AddParam("@pi_intInsureExceptKind", DBType.adTinyInt,     objInsReqOrderDispatchUpd.InsureExceptKind,   0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",          DBType.adVarChar,     objInsReqOrderDispatchUpd.AdminID,            50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",        DBType.adVarWChar,    objInsReqOrderDispatchUpd.AdminName,          50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,     DBNull.Value,                                 256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,     DBNull.Value,                                 0,     ParameterDirection.Output);
                                                                                                                                  
                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,     DBNull.Value,                                 256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,     DBNull.Value,                                 0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_MULTI_TX_PROC");

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
                                     , 9705, "System error(fail to insert adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsOrderDispatchMulti RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 위탁 요청 취소
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<OrderDispatchModel> InsContractMultiReqCnl(OrderDispatchModel objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsContractMultiReqCnl REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<OrderDispatchModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderDispatchModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",      DBType.adInteger,   objInsReqOrderDispatchUpd.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",        DBType.adVarChar,   objInsReqOrderDispatchUpd.OrderNos,        8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",    DBType.adTinyInt,   objInsReqOrderDispatchUpd.DispatchType,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",         DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",       DBType.adVarWChar,  objInsReqOrderDispatchUpd.AdminName,       50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_intTotalCnt",        DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,   DBNull.Value,                              256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,   DBNull.Value,                              256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CONTRACT_MULTI_REQ_TX_CNL");

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
                objInsReqOrderDispatchUpd.TotalCnt = lo_objDas.GetParam("@po_intTotalCnt").ToInt();
                lo_objResult.data                  = objInsReqOrderDispatchUpd;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9706, "System error(InsContractMultiReqCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsContractMultiReqCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 도착보고 담당자 배정(수정/취소)
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<OrderDispatchModel> UpdOrderGoodsArrival(OrderDispatchModel objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdOrderGoodsArrival REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<OrderDispatchModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderDispatchModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strGoodsSeqNos",        DBType.adVarChar,   objInsReqOrderDispatchUpd.GoodsSeqNos,      8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objInsReqOrderDispatchUpd.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,    objInsReqOrderDispatchUpd.ClientCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intChargeSeqNo",        DBType.adBigInt,    objInsReqOrderDispatchUpd.ChargeSeqNo,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportNo",    DBType.adVarWChar,  objInsReqOrderDispatchUpd.ArrivalReportNo,  100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strArrivalCnlFlag",     DBType.adChar,      objInsReqOrderDispatchUpd.CnlFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminID,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                               256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                               256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_ARRIVAL_TX_UPD");

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
                                     , 9706, "System error(UpdOrderGoodsArrival)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdOrderGoodsArrival RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 도착보고 서류등록 (수정/취소)
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<OrderDispatchModel> UpdOrderGoodsArrivalDocument(OrderDispatchModel objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdOrderGoodsArrivalDocument REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<OrderDispatchModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderDispatchModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strGoodsSeqNos",          DBType.adVarChar,   objInsReqOrderDispatchUpd.GoodsSeqNos,   8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",             DBType.adVarChar,   objInsReqOrderDispatchUpd.OrderNos,      8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objInsReqOrderDispatchUpd.CenterCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalDocumentFlag",  DBType.adChar,      objInsReqOrderDispatchUpd.CnlFlag,       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",              DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminID,       50,      ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@po_strErrMsg",               DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",               DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",             DBType.adVarChar,   DBNull.Value,                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",             DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_ARRIVAL_DOCUMENT_TX_UPD");

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
                                     , 9706, "System error(UpdOrderGoodsArrivalDocument)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdOrderGoodsArrivalDocument RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 간선 작업지시서 차량 목록
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchList> GetOrderDispatchCollectWorkCarList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchCollectWorkCarList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqOrderDispatchList.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",             DBType.adTinyInt,   objReqOrderDispatchList.ListType,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",             DBType.adTinyInt,   objReqOrderDispatchList.DateType,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",             DBType.adVarChar,   objReqOrderDispatchList.DateFrom,               8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",               DBType.adVarChar,   objReqOrderDispatchList.DateTo,                 8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intDispatchType",         DBType.adTinyInt,   objReqOrderDispatchList.DispatchType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",   DBType.adVarChar,   objReqOrderDispatchList.OrderLocationCodes,     4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",       DBType.adVarChar,   objReqOrderDispatchList.OrderItemCodes,         4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                DBType.adVarWChar,  objReqOrderDispatchList.CarNo,                  20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchAdminName",    DBType.adVarWChar,  objReqOrderDispatchList.DispatchAdminName,      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCnlFlag",              DBType.adChar,      objReqOrderDispatchList.CnlFlag,                1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqOrderDispatchList.AccessCenterCode,       512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_COLLECT_WORK_CAR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchList
                {
                    list      = new List<OrderDispatchGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9106, "System error(GetOrderDispatchCollectWorkCarList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchCollectWorkCarList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 도보 작업지시서 업체 목록
        /// </summary>
        /// <param name="objReqOrderDispatchArrivalWorkList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchArrivalWorkList> GetOrderDispatchArrivalWorkList(ReqOrderDispatchArrivalWorkList objReqOrderDispatchArrivalWorkList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchArrivalWorkList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchArrivalWorkList)}", bLogWrite);

            string                                         lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchArrivalWorkList> lo_objResult = null;
            IDasNetCom                                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchArrivalWorkList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                DBType.adInteger,   objReqOrderDispatchArrivalWorkList.CenterCode,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",                  DBType.adTinyInt,   objReqOrderDispatchArrivalWorkList.ListType,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                  DBType.adTinyInt,   objReqOrderDispatchArrivalWorkList.DateType,                   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                  DBType.adVarChar,   objReqOrderDispatchArrivalWorkList.DateFrom,                   8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                    DBType.adVarChar,   objReqOrderDispatchArrivalWorkList.DateTo,                     8,       ParameterDirection.Input);
                                                                                                                                                          
                lo_objDas.AddParam("@pi_strOrderLocationCodes",        DBType.adVarChar,   objReqOrderDispatchArrivalWorkList.OrderLocationCodes,         4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",            DBType.adVarChar,   objReqOrderDispatchArrivalWorkList.OrderItemCodes,             4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportClientName",   DBType.adVarWChar,  objReqOrderDispatchArrivalWorkList.ArrivalReportClientName,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",          DBType.adVarChar,   objReqOrderDispatchArrivalWorkList.AccessCenterCode,           512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",                 DBType.adInteger,   DBNull.Value,                                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_ARRIVAL_WORK_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchArrivalWorkList
                {
                    list      = new List<OrderDispatchArrivalWorkModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchArrivalWorkModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9106, "System error(GetOrderDispatchArrivalWorkList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchArrivalWorkList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 배차 취소
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<OrderDispatchModel> UpdOrderDispatchCnl(OrderDispatchModel objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdOrderDispatchCnl REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<OrderDispatchModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderDispatchModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strDispatchSeqNos",   DBType.adVarChar,   objInsReqOrderDispatchUpd.DispatchSeqNos,    8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   objInsReqOrderDispatchUpd.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",          DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminID,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",        DBType.adVarWChar,  objInsReqOrderDispatchUpd.AdminName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                                                                                                                               
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_TX_CNL");

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
                                     , 9801, "System error(UpdOrderDispatchCnl" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdOrderDispatchCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 도착보고 비용 등록
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<OrderDispatchModel> InsOrderArrivalPay(OrderDispatchModel objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsOrderArrivalPay REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<OrderDispatchModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderDispatchModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   objInsReqOrderDispatchUpd.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",         DBType.adVarChar,   objInsReqOrderDispatchUpd.OrderNos,          8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseSeqNos",   DBType.adVarChar,   objInsReqOrderDispatchUpd.PurchaseSeqNos,    8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strItemCode",         DBType.adVarChar,   objInsReqOrderDispatchUpd.GoodsItemCode,     5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSupplyAmt",        DBType.adDouble,    objInsReqOrderDispatchUpd.SupplyAmt,         0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intTaxAmt",           DBType.adDouble,    objInsReqOrderDispatchUpd.TaxAmt,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseType",     DBType.adTinyInt,   objInsReqOrderDispatchUpd.PurchaseType,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",          DBType.adVarChar,   objInsReqOrderDispatchUpd.AdminID,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",        DBType.adVarWChar,  objInsReqOrderDispatchUpd.AdminName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                                                                                                                               
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_ARRIVAL_PAY_TX_INS");

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
                                     , 9801, "System error(InsOrderArrivalPay)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[InsOrderArrivalPay RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 배차 차량 기사 목록(SMS) 
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchList> GetDispatchDriverCellList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetDispatchDriverCellList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqOrderDispatchList.CenterCode,        0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",           DBType.adVarChar,   objReqOrderDispatchList.OrderNos,          8000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqOrderDispatchList.AccessCenterCode,  512,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                              0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_DRIVER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchList
                {
                    list      = new List<OrderDispatchGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9806, "System error(GetDispatchDriverCellList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetDispatchDriverCellList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 실적 신고 내역
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchList> GetOrderFpisList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderFpisList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                              lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchList> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqOrderDispatchList.CenterCode,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar,   objReqOrderDispatchList.DateFrom,           8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar,   objReqOrderDispatchList.DateTo,             8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,  objReqOrderDispatchList.OrderClientName,    50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderFPISFlag",      DBType.adChar,      objReqOrderDispatchList.orderFPISFlag,      1,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarNo",              DBType.adVarWChar,  objReqOrderDispatchList.CarNo,              50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",          DBType.adVarChar,   objReqOrderDispatchList.ComCorpNo,          20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",            DBType.adVarWChar,  objReqOrderDispatchList.ComName,            50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqOrderDispatchList.AccessCenterCode,   512,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqOrderDispatchList.PageSize,           0,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqOrderDispatchList.PageNo,             0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                               0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_FPIS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchList
                {
                    list      = new List<OrderDispatchGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9807, "System error(GetOrderFpisList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderFpisList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 오더 상하차지 파일 목록
        /// </summary>
        /// <param name="objReqDispatchOrderFileList"></param>
        /// <returns></returns>
        public ServiceResult<ResDispatchOrderFileList> GetOrderDispatchFile(ReqDispatchOrderFileList objReqDispatchOrderFileList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchFile REQ] {JsonConvert.SerializeObject(objReqDispatchOrderFileList)}", bLogWrite);

            string                                  lo_strJson   = string.Empty;
            ServiceResult<ResDispatchOrderFileList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResDispatchOrderFileList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intFileSeqNo",          DBType.adBigInt,    objReqDispatchOrderFileList.FileSeqNo,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    objReqDispatchOrderFileList.OrderNo,            0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchSeqNo",      DBType.adBigInt,    objReqDispatchOrderFileList.DispatchSeqNo,      0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqDispatchOrderFileList.CenterCode,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFileType",           DBType.adTinyInt,   objReqDispatchOrderFileList.FileType,           0,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intFileGubun",          DBType.adTinyInt,   objReqDispatchOrderFileList.FileGubun,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,      objReqDispatchOrderFileList.DelFlag,            1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqDispatchOrderFileList.AccessCenterCode,   512,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqDispatchOrderFileList.PageSize,           0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqDispatchOrderFileList.PageNo,             0,    ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                                   0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_FILE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResDispatchOrderFileList
                {
                    list      = new List<OrderDispatchFileGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchFileGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9807, "System error(GetOrderDispatchFile)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchFile RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 도보 작업지시서 엑셀 목록
        /// </summary>
        /// <param name="objReqOrderDispatchArrivalWorkExcelList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchArrivalWorkExcelList> GetOrderDispatchArrivalWorkExcelList(ReqOrderDispatchArrivalWorkExcelList objReqOrderDispatchArrivalWorkExcelList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchArrivalWorkExcelList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchArrivalWorkExcelList)}", bLogWrite);

            string                                              lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchArrivalWorkExcelList> lo_objResult = null;
            IDasNetCom                                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchArrivalWorkExcelList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                DBType.adInteger,   objReqOrderDispatchArrivalWorkExcelList.CenterCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intListType",                  DBType.adTinyInt,   objReqOrderDispatchArrivalWorkExcelList.ListType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                  DBType.adTinyInt,   objReqOrderDispatchArrivalWorkExcelList.DateType,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                  DBType.adVarChar,   objReqOrderDispatchArrivalWorkExcelList.DateFrom,                  8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                    DBType.adVarChar,   objReqOrderDispatchArrivalWorkExcelList.DateTo,                    8,       ParameterDirection.Input);
                                                                                                                                              
                lo_objDas.AddParam("@pi_strOrderLocationCodes",        DBType.adVarChar,   objReqOrderDispatchArrivalWorkExcelList.OrderLocationCodes,        4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",            DBType.adVarChar,   objReqOrderDispatchArrivalWorkExcelList.OrderItemCodes,            4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intArrivalReportClientCode",   DBType.adBigInt,    objReqOrderDispatchArrivalWorkExcelList.ArrivalReportClientCode,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportChargeName",   DBType.adVarWChar,  objReqOrderDispatchArrivalWorkExcelList.ArrivalReportChargeName,   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",          DBType.adVarChar,   objReqOrderDispatchArrivalWorkExcelList.AccessCenterCode,          512,     ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",                 DBType.adInteger,   DBNull.Value,                                                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_ARRIVAL_WORK_EXCEL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchArrivalWorkExcelList
                {
                    list      = new List<OrderDispatchArrivalWorkExcelModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchArrivalWorkExcelModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9808, "System error(GetOrderDispatchArrivalWorkExcelList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchArrivalWorkExcelList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        ///  오더 선급금, 예수금 목록
        /// </summary>
        /// <param name="objReqOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchAdvanceList> GetOrderDispatchAdvanceList(ReqOrderDispatchList objReqOrderDispatchList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchAdvanceList REQ] {JsonConvert.SerializeObject(objReqOrderDispatchList)}", bLogWrite);

            string                                     lo_strJson   = string.Empty;
            ServiceResult<ResOrderDispatchAdvanceList> lo_objResult = null;
            IDasNetCom                                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchAdvanceList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqOrderDispatchList.CenterCode,         0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos1",          DBType.adVarChar,   objReqOrderDispatchList.OrderNos1,          8000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos2",          DBType.adVarChar,   objReqOrderDispatchList.OrderNos2,          8000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",   DBType.adVarChar,   objReqOrderDispatchList.SaleClosingSeqNo,   0,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTotalAmt",           DBType.adDouble,    DBNull.Value,                               0,      ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                               0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_ADVANCE_PRINT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchAdvanceList
                {
                    list      = new List<OrderDispatchAdvanceGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt(),
                    TotalAmt  = lo_objDas.GetParam("@po_intTotalAmt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<OrderDispatchAdvanceGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9706, "System error(GetOrderDispatchAdvanceList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchAdvanceList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 일일안전점검
        /// </summary>
        /// <param name="objReqDailySafetyCheckList"></param>
        /// <returns></returns>
        public ServiceResult<ResDailySafetyCheckList> GetDailySafetyCheckList(ReqDailySafetyCheckList objReqDailySafetyCheckList)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetDailySafetyCheckList REQ] {JsonConvert.SerializeObject(objReqDailySafetyCheckList)}", bLogWrite);
            
            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResDailySafetyCheckList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResDailySafetyCheckList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqDailySafetyCheckList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",             DBType.adTinyInt,   objReqDailySafetyCheckList.DateType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateYMD",              DBType.adVarChar,   objReqDailySafetyCheckList.DateYMD,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",              DBType.adVarWChar,  objReqDailySafetyCheckList.ComName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",            DBType.adVarChar,   objReqDailySafetyCheckList.ComCorpNo,           20,      ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_strCarNo",                DBType.adVarWChar,  objReqDailySafetyCheckList.CarNo,               20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",           DBType.adVarWChar,  objReqDailySafetyCheckList.DriverName,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",           DBType.adVarChar,   objReqDailySafetyCheckList.DriverCell,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReplyFlag",            DBType.adChar,      objReqDailySafetyCheckList.ReplyFlag,           1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",              DBType.adVarChar,   objReqDailySafetyCheckList.AdminID,             50,      ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqDailySafetyCheckList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_DAILY_SAFETY_CHECK_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResDailySafetyCheckList
                {
                    list       = new List<DailySafetyCheckListModel>()
                    ,RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<DailySafetyCheckListModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetDailySafetyCheckList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetDailySafetyCheckList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 안전점검 리스트 등록 및 발송
        /// </summary>
        /// <param name="objDailySafetyCheckInsModel"></param>
        /// <returns></returns>
        public ServiceResult<DailySafetyCheckInsModel> SetDailySafetyCheckIns(DailySafetyCheckInsModel objDailySafetyCheckInsModel)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[SetDailySafetyCheckIns REQ] {JsonConvert.SerializeObject(objDailySafetyCheckInsModel)}", bLogWrite);

            ServiceResult<DailySafetyCheckInsModel> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<DailySafetyCheckInsModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objDailySafetyCheckInsModel.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",        DBType.adBigInt,    objDailySafetyCheckInsModel.OrderNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchSeqNo",  DBType.adBigInt,    objDailySafetyCheckInsModel.DispatchSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",       DBType.adBigInt,    objDailySafetyCheckInsModel.RefSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,   objDailySafetyCheckInsModel.AdminID,          50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminName",      DBType.adVarWChar,  objDailySafetyCheckInsModel.AdminName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",          DBType.adBigInt,    DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                                 256,     ParameterDirection.Output);
                                                                                                                              
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_DAILY_SAFETY_CHECK_TX_INS");

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

                objDailySafetyCheckInsModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt64();
                lo_objResult.data                 = objDailySafetyCheckInsModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9801, "System error(SetDailySafetyCheckIns) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[SetDailySafetyCheckIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 내역서 메일발송 히스토리 등록
        /// </summary>
        /// <param name="objPrintHistoryModel"></param>
        /// <returns></returns>
        public ServiceResult<PrintHistoryModel> SetOrderPrintHistIns(PrintHistoryModel objPrintHistoryModel)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[SetOrderPrintHistIns REQ] {JsonConvert.SerializeObject(objPrintHistoryModel)}", bLogWrite);

            ServiceResult<PrintHistoryModel> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<PrintHistoryModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,  objPrintHistoryModel.CenterCode,          0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos1",        DBType.adVarChar,  objPrintHistoryModel.OrderNos1,           8000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos2",        DBType.adVarChar,  objPrintHistoryModel.OrderNos2,           8000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleClosingSeqNo", DBType.adBigInt,   objPrintHistoryModel.SaleClosingSeqNo,    0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRecName",          DBType.adVarWChar, objPrintHistoryModel.RecName,             50,     ParameterDirection.Input);
                                                                                                                                   
                lo_objDas.AddParam("@pi_strRecMail",          DBType.adVarChar,  objPrintHistoryModel.RecMail,             20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendName",         DBType.adVarWChar, objPrintHistoryModel.SendName,            50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendMail",         DBType.adVarChar,  objPrintHistoryModel.SendMail,            20,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingFlag",      DBType.adChar,     objPrintHistoryModel.ClosingFlag,         1,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,  DBNull.Value,                             256,    ParameterDirection.Output);
                                                                                                                           
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,  DBNull.Value,                             0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,  DBNull.Value,                             256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,  DBNull.Value,                             0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PRINT_HIST_TX_INS");

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
                lo_objResult.data                 = objPrintHistoryModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9801, "System error(SetOrderPrintHistIns) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[SetDailySafetyCheckIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 내역서 히스토리 조회
        /// </summary>
        /// <param name="objReqPrintHistory"></param>
        /// <returns></returns>
        public ServiceResult<ResPrintHistory> GetOrderPrintHistList(ReqPrintHistory objReqPrintHistory)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderPrintHistList REQ] {JsonConvert.SerializeObject(objReqPrintHistory)}", bLogWrite);

            string                         lo_strJson   = string.Empty;
            ServiceResult<ResPrintHistory> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPrintHistory>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",               DBType.adInteger,   objReqPrintHistory.SeqNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqPrintHistory.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",             DBType.adBigInt,    objReqPrintHistory.OrderNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleClosingSeqNo",    DBType.adBigInt,    objReqPrintHistory.SaleClosingSeqNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRecName",             DBType.adVarWChar,  objReqPrintHistory.RecName,            50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strSendName",            DBType.adVarWChar,  objReqPrintHistory.SendName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",            DBType.adVarChar,   objReqPrintHistory.DateFrom,           8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",              DBType.adVarChar,   objReqPrintHistory.DateTo,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objReqPrintHistory.PageSize,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objReqPrintHistory.PageNo,             0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PRINT_HIST_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPrintHistory
                {
                    list      = new List<ResPrintHistoryListModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ResPrintHistoryListModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderPrintHistList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetDailySafetyCheckList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 도착보고 입고 번호 수정
        /// </summary>
        /// <param name="objInsReqOrderDispatchUpd"></param>
        /// <returns></returns>
        public ServiceResult<OrderDispatchModel> UpdArrivalReportNo(OrderDispatchModel objInsReqOrderDispatchUpd)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdArrivalReportNo REQ] {JsonConvert.SerializeObject(objInsReqOrderDispatchUpd)}", bLogWrite);

            ServiceResult<OrderDispatchModel> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<OrderDispatchModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intGoodsSeqNo",        DBType.adBigInt,       objInsReqOrderDispatchUpd.GoodsSeqNo,        0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,      objInsReqOrderDispatchUpd.CenterCode,        0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strArrivalReportNo",   DBType.adVarWChar,     objInsReqOrderDispatchUpd.ArrivalReportNo,   100,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",           DBType.adVarChar,      objInsReqOrderDispatchUpd.AdminID,           50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,      DBNull.Value,                                256,   ParameterDirection.Output);
                                                                                                                                          
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,      DBNull.Value,                                0,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,      DBNull.Value,                                256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,      DBNull.Value,                                0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_ARRIVAL_REPORTNO_TX_UPD");

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
                                     , 9709, "System error(UpdArrivalReportNo)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[UpdArrivalReportNo RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        

        /// <summary>
        /// 배차 오더 카운트
        /// </summary>
        /// <param name="objReqOrderDispatchCount"></param>
        /// <returns></returns>
        public ServiceResult<ResOrderDispatchCount> GetOrderDispatchCount(ReqOrderDispatchCount objReqOrderDispatchCount)
        {
            SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchCount REQ] {JsonConvert.SerializeObject(objReqOrderDispatchCount)}", bLogWrite);

            ServiceResult<ResOrderDispatchCount> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResOrderDispatchCount>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_NOLOG);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAccessCenterCode",         DBType.adVarChar,   objReqOrderDispatchCount.AccessCenterCode,       512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                  DBType.adVarChar,   objReqOrderDispatchCount.AdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intNetworkDispatchCnt",       DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intNetworkDispatchType1Cnt",  DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intNetworkDispatchType2Cnt",  DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                
                lo_objDas.AddParam("@po_intNetworkDispatchType3Cnt",  DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intAmtRequestCnt",            DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                   DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                   DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                 DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",                 DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_COUNT_NT_GET");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResOrderDispatchCount
                {
                    NetworkDispatchCnt      = lo_objDas.GetParam("@po_intNetworkDispatchCnt").ToInt(),
                    NetworkDispatchType1Cnt = lo_objDas.GetParam("@po_intNetworkDispatchType1Cnt").ToInt(),
                    NetworkDispatchType2Cnt = lo_objDas.GetParam("@po_intNetworkDispatchType2Cnt").ToInt(),
                    NetworkDispatchType3Cnt = lo_objDas.GetParam("@po_intNetworkDispatchType3Cnt").ToInt(),
                    AmtRequestCnt           = lo_objDas.GetParam("@po_intAmtRequestCnt").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderDispatchCount)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("OrderDispatchDasServices", "I", $"[GetOrderDispatchCount RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}