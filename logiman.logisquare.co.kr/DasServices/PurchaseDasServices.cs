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
    public class PurchaseDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 매입 사업자 목록
        /// </summary>
        /// <param name="objReqPurchaseCarCompanyList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseCarCompanyList> GetPurchaseCarCompanyList(ReqPurchaseCarCompanyList objReqPurchaseCarCompanyList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseCarCompanyList REQ] {JsonConvert.SerializeObject(objReqPurchaseCarCompanyList)}", bLogWrite);

            string                                   lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseCarCompanyList> lo_objResult = null;
            IDasNetCom                               lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseCarCompanyList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",               DBType.adInteger,   objReqPurchaseCarCompanyList.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                 DBType.adTinyInt,   objReqPurchaseCarCompanyList.DateType,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                 DBType.adVarChar,   objReqPurchaseCarCompanyList.DateFrom,               8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                   DBType.adVarChar,   objReqPurchaseCarCompanyList.DateTo,                 8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",       DBType.adVarChar,   objReqPurchaseCarCompanyList.OrderLocationCodes,     4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",    DBType.adVarChar,   objReqPurchaseCarCompanyList.DeliveryLocationCodes,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",           DBType.adVarChar,   objReqPurchaseCarCompanyList.OrderItemCodes,         4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarDivType",               DBType.adTinyInt,   objReqPurchaseCarCompanyList.CarDivType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",                  DBType.adVarWChar,  objReqPurchaseCarCompanyList.ComName,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",                DBType.adVarChar,   objReqPurchaseCarCompanyList.ComCorpNo,              20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarNo",                    DBType.adVarWChar,  objReqPurchaseCarCompanyList.CarNo,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",               DBType.adVarWChar,  objReqPurchaseCarCompanyList.DriverName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",               DBType.adVarChar,   objReqPurchaseCarCompanyList.DriverCell,             20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCooperatorFlag",           DBType.adChar,      objReqPurchaseCarCompanyList.CooperatorFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingFlag",              DBType.adChar,      objReqPurchaseCarCompanyList.ClosingFlag,            1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strMyOrderFlag",              DBType.adChar,      objReqPurchaseCarCompanyList.MyOrderFlag,            1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                  DBType.adVarChar,   objReqPurchaseCarCompanyList.AdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",         DBType.adVarChar,   objReqPurchaseCarCompanyList.AccessCenterCode,       512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",                 DBType.adInteger,   objReqPurchaseCarCompanyList.PageSize,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                   DBType.adInteger,   objReqPurchaseCarCompanyList.PageNo,                 0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",                DBType.adInteger,   DBNull.Value,                                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CAR_COMPANY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseCarCompanyList
                {
                    list      = new List<PurchaseCarCompanyGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseCarCompanyGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseCarCompanyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseCarCompanyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        
        /// <summary>
        /// 매입 사업자 비용 목록
        /// </summary>
        /// <param name="objReqPurchaseCarCompanyPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseCarCompanyPayList> GetPurchaseCarCompanyPayList(ReqPurchaseCarCompanyPayList objReqPurchaseCarCompanyPayList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseCarCompanyPayList REQ] {JsonConvert.SerializeObject(objReqPurchaseCarCompanyPayList)}", bLogWrite);

            string                                      lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseCarCompanyPayList> lo_objResult = null;
            IDasNetCom                                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseCarCompanyPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqPurchaseCarCompanyPayList.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComCode",                DBType.adBigInt,    objReqPurchaseCarCompanyPayList.ComCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",               DBType.adTinyInt,   objReqPurchaseCarCompanyPayList.DateType,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",               DBType.adVarChar,   objReqPurchaseCarCompanyPayList.DateFrom,               8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                 DBType.adVarChar,   objReqPurchaseCarCompanyPayList.DateTo,                 8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderLocationCodes",     DBType.adVarChar,   objReqPurchaseCarCompanyPayList.OrderLocationCodes,     4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",  DBType.adVarChar,   objReqPurchaseCarCompanyPayList.DeliveryLocationCodes,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",         DBType.adVarChar,   objReqPurchaseCarCompanyPayList.OrderItemCodes,         4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarDivType",             DBType.adTinyInt,   objReqPurchaseCarCompanyPayList.CarDivType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",                DBType.adVarWChar,  objReqPurchaseCarCompanyPayList.ComName,                50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strComCorpNo",              DBType.adVarChar,   objReqPurchaseCarCompanyPayList.ComCorpNo,              20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                  DBType.adVarWChar,  objReqPurchaseCarCompanyPayList.CarNo,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",             DBType.adVarWChar,  objReqPurchaseCarCompanyPayList.DriverName,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",             DBType.adVarChar,   objReqPurchaseCarCompanyPayList.DriverCell,             20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCooperatorFlag",         DBType.adChar,      objReqPurchaseCarCompanyPayList.CooperatorFlag,         1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClosingFlag",            DBType.adChar,      objReqPurchaseCarCompanyPayList.ClosingFlag,            1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",            DBType.adChar,      objReqPurchaseCarCompanyPayList.MyOrderFlag,            1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objReqPurchaseCarCompanyPayList.AdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",       DBType.adVarChar,   objReqPurchaseCarCompanyPayList.AccessCenterCode,       512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CAR_COMPANY_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseCarCompanyPayList
                {
                    list      = new List<PurchaseCarCompanyPayGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseCarCompanyPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseCarCompanyPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseCarCompanyPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 마감 등록(차량)
        /// </summary>
        /// <param name="objReqPurchaseClosingCarIns"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseClosingCarIns> SetPurchaseClosingCarIns(ReqPurchaseClosingCarIns objReqPurchaseClosingCarIns)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingCarIns REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingCarIns)}", bLogWrite);

            ServiceResult<ResPurchaseClosingCarIns> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseClosingCarIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqPurchaseClosingCarIns.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos1",        DBType.adVarChar,   objReqPurchaseClosingCarIns.DispatchSeqNos1,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos2",        DBType.adVarChar,   objReqPurchaseClosingCarIns.DispatchSeqNos2,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos3",        DBType.adVarChar,   objReqPurchaseClosingCarIns.DispatchSeqNos3,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos4",        DBType.adVarChar,   objReqPurchaseClosingCarIns.DispatchSeqNos4,    4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDispatchSeqNos5",        DBType.adVarChar,   objReqPurchaseClosingCarIns.DispatchSeqNos5,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos6",        DBType.adVarChar,   objReqPurchaseClosingCarIns.DispatchSeqNos6,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos7",        DBType.adVarChar,   objReqPurchaseClosingCarIns.DispatchSeqNos7,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos8",        DBType.adVarChar,   objReqPurchaseClosingCarIns.DispatchSeqNos8,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBillStatus",             DBType.adTinyInt,   objReqPurchaseClosingCarIns.BillStatus,         0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intBillKind",               DBType.adTinyInt,   objReqPurchaseClosingCarIns.BillKind,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillWrite",              DBType.adVarChar,   objReqPurchaseClosingCarIns.BillWrite,          8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillYMD",                DBType.adVarChar,   objReqPurchaseClosingCarIns.BillYMD,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillDate",               DBType.adVarChar,   objReqPurchaseClosingCarIns.BillDate,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNtsConfirmNum",          DBType.adVarChar,   objReqPurchaseClosingCarIns.NtsConfirmNum,      24,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPurchaseOrgAmt",         DBType.adCurrency,  objReqPurchaseClosingCarIns.PurchaseOrgAmt,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDeductAmt",              DBType.adCurrency,  objReqPurchaseClosingCarIns.DeductAmt,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeductReason",           DBType.adVarWChar,  objReqPurchaseClosingCarIns.DeductReason,       100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intIssueTaxAmt",            DBType.adCurrency,  objReqPurchaseClosingCarIns.IssueTaxAmt,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInsureFlag",             DBType.adChar,      objReqPurchaseClosingCarIns.InsureFlag,         1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNote",                   DBType.adVarWChar,  objReqPurchaseClosingCarIns.Note,               500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingAdminID",         DBType.adVarChar,   objReqPurchaseClosingCarIns.ClosingAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingAdminName",       DBType.adVarWChar,  objReqPurchaseClosingCarIns.ClosingAdminName,   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intPurchaseClosingSeqNo",   DBType.adBigInt,    DBNull.Value,                                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intPurchaseOrgAmt",         DBType.adCurrency,  DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intPurchaseDeductAmt",      DBType.adCurrency,  DBNull.Value,                                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strSendPlanYMD",            DBType.adVarChar,   DBNull.Value,                                   8,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_CAR_TX_INS");

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

                lo_objResult.data = new ResPurchaseClosingCarIns
                {
                    PurchaseClosingSeqNo = lo_objDas.GetParam("@po_intPurchaseClosingSeqNo").ToInt64(),
                    PurchaseOrgAmt       = lo_objDas.GetParam("@po_intPurchaseOrgAmt").ToDouble(),
                    PurchaseDeductAmt    = lo_objDas.GetParam("@po_intPurchaseDeductAmt").ToDouble(),
                    SendPlanYMD          = lo_objDas.GetParam("@po_strSendPlanYMD")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetPurchaseClosingCarIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingCarIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 마감 산재 보험료 체크(차량)
        /// </summary>
        /// <returns></returns>
        public ServiceResult<ResPurchaseCarCompanyInsureCheck> GetPurchaseCarCompanyInsureCheck(ReqPurchaseCarCompanyInsureCheck objReqPurchaseCarCompanyInsureCheck)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseCarCompanyInsureCheck REQ] {JsonConvert.SerializeObject(objReqPurchaseCarCompanyInsureCheck)}", bLogWrite);

            ServiceResult<ResPurchaseCarCompanyInsureCheck> lo_objResult = null;
            IDasNetCom                                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseCarCompanyInsureCheck>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqPurchaseCarCompanyInsureCheck.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComCode",            DBType.adBigInt,    objReqPurchaseCarCompanyInsureCheck.ComCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInsureYMD",          DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.InsureYMD,          8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos1",    DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.DispatchSeqNos1,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos2",    DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.DispatchSeqNos2,    4000,    ParameterDirection.Input);
 
                lo_objDas.AddParam("@pi_strDispatchSeqNos3",    DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.DispatchSeqNos3,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos4",    DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.DispatchSeqNos4,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos5",    DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.DispatchSeqNos5,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos6",    DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.DispatchSeqNos6,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchSeqNos7",    DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.DispatchSeqNos7,    4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDispatchSeqNos8",    DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.DispatchSeqNos8,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objReqPurchaseCarCompanyInsureCheck.AdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strApplyFlag",          DBType.adChar,      DBNull.Value,                                           1,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intSupplyAmt",          DBType.adCurrency,  DBNull.Value,                                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTransAmt",           DBType.adCurrency,  DBNull.Value,                                           0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intTransCost",          DBType.adCurrency,  DBNull.Value,                                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intInsureRateAmt",      DBType.adCurrency,  DBNull.Value,                                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intInsureReduceAmt",    DBType.adCurrency,  DBNull.Value,                                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intInsurePayAmt",       DBType.adCurrency,  DBNull.Value,                                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCenterInsureAmt",    DBType.adCurrency,  DBNull.Value,                                           0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDriverInsureAmt",    DBType.adCurrency,  DBNull.Value,                                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CAR_COMPANY_INSURE_NT_GET");

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

                lo_objResult.data = new ResPurchaseCarCompanyInsureCheck
                {
                    ApplyFlag       = lo_objDas.GetParam("@po_strApplyFlag"),
                    SupplyAmt       = lo_objDas.GetParam("@po_intSupplyAmt").ToDouble(),
                    TransAmt        = lo_objDas.GetParam("@po_intTransAmt").ToDouble(),
                    TransCost       = lo_objDas.GetParam("@po_intTransCost").ToDouble(),
                    InsureRateAmt   = lo_objDas.GetParam("@po_intInsureRateAmt").ToDouble(),
                    InsureReduceAmt = lo_objDas.GetParam("@po_intInsureReduceAmt").ToDouble(),
                    InsurePayAmt    = lo_objDas.GetParam("@po_intInsurePayAmt").ToDouble(),
                    CenterInsureAmt = lo_objDas.GetParam("@po_intCenterInsureAmt").ToDouble(),
                    DriverInsureAmt = lo_objDas.GetParam("@po_intDriverInsureAmt").ToDouble()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseCarCompanyInsureCheck)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseCarCompanyInsureCheck RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 마감 취소
        /// </summary>
        /// <param name="objReqPurchaseClosingCnl"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPurchaseClosingCnl(ReqPurchaseClosingCnl objReqPurchaseClosingCnl)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingCnl REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingCnl)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqPurchaseClosingCnl.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseClosingSeqNos",  DBType.adVarChar,   objReqPurchaseClosingCnl.PurchaseClosingSeqNos,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChkPermFlag",            DBType.adChar,      objReqPurchaseClosingCnl.ChkPermFlag,            1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminID",             DBType.adVarChar,   objReqPurchaseClosingCnl.CnlAdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCnlAdminName",           DBType.adVarWChar,  objReqPurchaseClosingCnl.CnlAdminName,           50,      ParameterDirection.Input);
                                                                    
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_TX_CNL");

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
                                     , 9101, "System error(SetPurchaseClosingCnl)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingCnl RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 마감 현황 목록
        /// </summary>
        /// <param name="objReqPurchaseClosingList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseClosingList> GetPurchaseClosingList(ReqPurchaseClosingList objReqPurchaseClosingList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingList REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseClosingList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseClosingList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPurchaseClosingSeqNo",   DBType.adBigInt,    objReqPurchaseClosingList.PurchaseClosingSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqPurchaseClosingList.CenterCode,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",               DBType.adTinyInt,   objReqPurchaseClosingList.DateType,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",               DBType.adVarChar,   objReqPurchaseClosingList.DateFrom,                8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                 DBType.adVarChar,   objReqPurchaseClosingList.DateTo,                  8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderLocationCodes",     DBType.adVarChar,   objReqPurchaseClosingList.OrderLocationCodes,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",  DBType.adVarChar,   objReqPurchaseClosingList.DeliveryLocationCodes,   4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",         DBType.adVarChar,   objReqPurchaseClosingList.OrderItemCodes,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSendStatus",             DBType.adTinyInt,   objReqPurchaseClosingList.SendStatus,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSendType",               DBType.adTinyInt,   objReqPurchaseClosingList.SendType,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strComName",                DBType.adVarWChar,  objReqPurchaseClosingList.ComName,                 100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",              DBType.adVarChar,   objReqPurchaseClosingList.ComCorpNo,               20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                  DBType.adVarWChar,  objReqPurchaseClosingList.CarNo,                   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",             DBType.adVarWChar,  objReqPurchaseClosingList.DriverName,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",             DBType.adVarChar,   objReqPurchaseClosingList.DriverCell,              20,      ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strClosingAdminName",       DBType.adVarWChar,  objReqPurchaseClosingList.ClosingAdminName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strQuickFlag",              DBType.adChar,      objReqPurchaseClosingList.QuickFlag,               1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeductFlag",             DBType.adChar,      objReqPurchaseClosingList.DeductFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInsureFlag",             DBType.adChar,      objReqPurchaseClosingList.InsureFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",       DBType.adVarChar,   objReqPurchaseClosingList.AccessCenterCode,        512,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",               DBType.adInteger,   objReqPurchaseClosingList.PageSize,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                 DBType.adInteger,   objReqPurchaseClosingList.PageNo,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",              DBType.adInteger,   DBNull.Value,                                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseClosingList
                {
                    list = new List<PurchaseClosingGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("AcctNo",   typeof(string));
                    lo_objDas.objDT.Columns.Add("SendAcctNo", typeof(string));
                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        if (!string.IsNullOrWhiteSpace(row["EncAcctNo"].ToString()))
                        {
                            row["AcctNo"] = CommonUtils.Utils.GetDecrypt(row["EncAcctNo"].ToString());
                        }

                        if (!string.IsNullOrWhiteSpace(row["SendEncAcctNo"].ToString()))
                        {
                            row["SendAcctNo"] = CommonUtils.Utils.GetDecrypt(row["SendEncAcctNo"].ToString());
                        }
                    }

                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseClosingGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseClosingList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 마감 현황 상세 목록
        /// </summary>
        /// <param name="objReqPurchaseClosingPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseClosingPayList> GetPurchaseClosingPayList(ReqPurchaseClosingPayList objReqPurchaseClosingPayList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingPayList REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingPayList)}", bLogWrite);

            string                                   lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseClosingPayList> lo_objResult = null;
            IDasNetCom                               lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseClosingPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPurchaseClosingSeqNo",  DBType.adBigInt,   objReqPurchaseClosingPayList.PurchaseClosingSeqNo,  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,  objReqPurchaseClosingPayList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",      DBType.adVarChar,  objReqPurchaseClosingPayList.AccessCenterCode,      512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseClosingPayList
                {
                    list      = new List<PurchaseClosingPayGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseClosingPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseClosingPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 빠른입금마감 오더 목록
        /// </summary>
        /// <param name="objReqPurchaseQuickPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseQuickPayList> GetPurchaseQuickPayList(ReqPurchaseQuickPayList objReqPurchaseQuickPayList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseQuickPayList REQ] {JsonConvert.SerializeObject(objReqPurchaseQuickPayList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseQuickPayList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseQuickPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqPurchaseQuickPayList.CenterCode,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",               DBType.adTinyInt,   objReqPurchaseQuickPayList.DateType,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",               DBType.adVarChar,   objReqPurchaseQuickPayList.DateFrom,                8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                 DBType.adVarChar,   objReqPurchaseQuickPayList.DateTo,                  8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",     DBType.adVarChar,   objReqPurchaseQuickPayList.OrderLocationCodes,      4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",  DBType.adVarChar,   objReqPurchaseQuickPayList.DeliveryLocationCodes,   4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",         DBType.adVarChar,   objReqPurchaseQuickPayList.OrderItemCodes,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",          DBType.adVarWChar,  objReqPurchaseQuickPayList.ConsignorName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intQuickType",              DBType.adTinyInt,   objReqPurchaseQuickPayList.QuickType,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarDivType",             DBType.adTinyInt,   objReqPurchaseQuickPayList.CarDivType,              0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strComName",                DBType.adVarWChar,  objReqPurchaseQuickPayList.ComName,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",              DBType.adVarChar,   objReqPurchaseQuickPayList.ComCorpNo,               20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",                  DBType.adVarWChar,  objReqPurchaseQuickPayList.CarNo,                   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",             DBType.adVarWChar,  objReqPurchaseQuickPayList.DriverName,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",             DBType.adVarChar,   objReqPurchaseQuickPayList.DriverCell,              20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClosingFlag",            DBType.adChar,      objReqPurchaseQuickPayList.ClosingFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAcceptAdminName",        DBType.adVarWChar,  objReqPurchaseQuickPayList.AcceptAdminName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchAdminName",      DBType.adVarWChar,  objReqPurchaseQuickPayList.DispatchAdminName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",       DBType.adVarChar,   objReqPurchaseQuickPayList.AccessCenterCode,        512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",               DBType.adInteger,   objReqPurchaseQuickPayList.PageSize,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",                 DBType.adInteger,   objReqPurchaseQuickPayList.PageNo,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",              DBType.adInteger,   DBNull.Value,                                       0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_QUICK_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseQuickPayList
                {
                    list      = new List<PurchaseQuickPayGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseQuickPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseQuickPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseQuickPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 미마감 내역(월별)
        /// </summary>
        /// <param name="objReqPurchaseClosingPayMonthList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseClosingPayMonthList> GetPurchaseClosingPayMonthList(ReqPurchaseClosingPayMonthList objReqPurchaseClosingPayMonthList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingPayMonthList REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingPayMonthList)}", bLogWrite);

            string                                        lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseClosingPayMonthList> lo_objResult = null;
            IDasNetCom                                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseClosingPayMonthList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqPurchaseClosingPayMonthList.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strYear",              DBType.adVarChar,   objReqPurchaseClosingPayMonthList.Year,              4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingFlag",       DBType.adChar,      objReqPurchaseClosingPayMonthList.ClosingFlag,       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strQuickFlag",         DBType.adChar,      objReqPurchaseClosingPayMonthList.QuickFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqPurchaseClosingPayMonthList.AccessCenterCode,  512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_PAY_MONTH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseClosingPayMonthList
                {
                    list = new List<PurchaseClosingPayMonthModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseClosingPayMonthModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseClosingPayMonthList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingPayMonthList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 마감 송금정보 수정
        /// </summary>
        /// <param name="objReqPurchaseClosingSendInfoUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPurchaseClosingSendInfoUpd(ReqPurchaseClosingSendInfoUpd objReqPurchaseClosingSendInfoUpd)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingSendInfoUpd REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingSendInfoUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objReqPurchaseClosingSendInfoUpd.CenterCode,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseClosingSeqNo",  DBType.adVarChar,   objReqPurchaseClosingSendInfoUpd.PurchaseClosingSeqNo,    8000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSendStatus",            DBType.adTinyInt,   objReqPurchaseClosingSendInfoUpd.SendStatus,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSendType",              DBType.adTinyInt,   objReqPurchaseClosingSendInfoUpd.SendType,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strReqYMD",                DBType.adVarChar,   objReqPurchaseClosingSendInfoUpd.ReqYMD,                  8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strChkPermFlag",           DBType.adChar,      objReqPurchaseClosingSendInfoUpd.ChkPermFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendAdminID",           DBType.adVarChar,   objReqPurchaseClosingSendInfoUpd.SendAdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendAdminName",         DBType.adVarWChar,  objReqPurchaseClosingSendInfoUpd.SendAdminName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,   DBNull.Value,                                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,   DBNull.Value,                                             0,       ParameterDirection.Output);
                                                                                                                                                 
                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,   DBNull.Value,                                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,   DBNull.Value,                                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_SENDINFO_TX_UPD");

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
                                     , 9101, "System error(SetPurchaseClosingSendInfoUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingSendInfoUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 전표 메모 정보 변경
        /// </summary>
        /// <param name="objReqPurchaseClosingNoteUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPurchaseClosingNoteUpd(ReqPurchaseClosingNoteUpd objReqPurchaseClosingNoteUpd)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingNoteUpd REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingNoteUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqPurchaseClosingNoteUpd.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseClosingSeqNo",   DBType.adBigInt,    objReqPurchaseClosingNoteUpd.PurchaseClosingSeqNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",                   DBType.adVarWChar,  objReqPurchaseClosingNoteUpd.Note,                   500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",             DBType.adVarChar,   objReqPurchaseClosingNoteUpd.UpdAdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",           DBType.adVarWChar,  objReqPurchaseClosingNoteUpd.UpdAdminName,           50,      ParameterDirection.Input);
                                                                    
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                                        0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_NOTE_TX_UPD");

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
                                     , 9101, "System error(SetPurchaseClosingNoteUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingNoteUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }



        /// <summary>
        /// 매입 전표 계산서 정보 업데이트
        /// </summary>
        /// <param name="objReqPurchaseClosingBillInfoUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPurchaseClosingBillInfoUpd(ReqPurchaseClosingBillInfoUpd objReqPurchaseClosingBillInfoUpd)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingBillInfoUpd REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingBillInfoUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objReqPurchaseClosingBillInfoUpd.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseClosingSeqNos", DBType.adVarChar,   objReqPurchaseClosingBillInfoUpd.PurchaseClosingSeqNos,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBillStatus",            DBType.adTinyInt,   objReqPurchaseClosingBillInfoUpd.BillStatus,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intBillKind",              DBType.adTinyInt,   objReqPurchaseClosingBillInfoUpd.BillKind,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strBillWrite",             DBType.adVarChar,   objReqPurchaseClosingBillInfoUpd.BillWrite,              8,       ParameterDirection.Input);
                                                                                                                                                
                lo_objDas.AddParam("@pi_strBillYMD",               DBType.adVarChar,   objReqPurchaseClosingBillInfoUpd.BillYMD,                8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNtsConfirmNum",         DBType.adVarChar,   objReqPurchaseClosingBillInfoUpd.NtsConfirmNum,          24,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChkPermFlag",           DBType.adChar,      objReqPurchaseClosingBillInfoUpd.ChkPermFlag,            1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",            DBType.adVarChar,   objReqPurchaseClosingBillInfoUpd.UpdAdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",          DBType.adVarWChar,  objReqPurchaseClosingBillInfoUpd.UpdAdminName,           50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,   DBNull.Value,                                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,   DBNull.Value,                                            0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,   DBNull.Value,                                            256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,   DBNull.Value,                                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_BILLINFO_TX_UPD");

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
                                     , 9101, "System error(SetPurchaseClosingBillInfoUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingBillInfoUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 카고페이송금신청 - 송금예정일목록
        /// </summary>
        /// <param name="objReqPurchaseClosingSendList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseClosingSendList> GetPurchaseClosingSendList(ReqPurchaseClosingSendList objReqPurchaseClosingSendList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingSendList REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingSendList)}", bLogWrite);

            string                                    lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseClosingSendList> lo_objResult = null;
            IDasNetCom                                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseClosingSendList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPurchaseClosingSeqNo",    DBType.adBigInt,    objReqPurchaseClosingSendList.PurchaseClosingSeqNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",              DBType.adInteger,   objReqPurchaseClosingSendList.CenterCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",                DBType.adTinyInt,   objReqPurchaseClosingSendList.DateType,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",                DBType.adVarChar,   objReqPurchaseClosingSendList.DateFrom,               8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                  DBType.adVarChar,   objReqPurchaseClosingSendList.DateTo,                 8,       ParameterDirection.Input);
                                                                                                                                      
                lo_objDas.AddParam("@pi_strOrderLocationCodes",      DBType.adVarChar,   objReqPurchaseClosingSendList.OrderLocationCodes,     4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeliveryLocationCodes",   DBType.adVarChar,   objReqPurchaseClosingSendList.DeliveryLocationCodes,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",          DBType.adVarChar,   objReqPurchaseClosingSendList.OrderItemCodes,         4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",                 DBType.adVarWChar,  objReqPurchaseClosingSendList.ComName,                100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",               DBType.adVarChar,   objReqPurchaseClosingSendList.ComCorpNo,              20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClosingAdminName",        DBType.adVarWChar,  objReqPurchaseClosingSendList.ClosingAdminName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeductFlag",              DBType.adChar,      objReqPurchaseClosingSendList.DeductFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInsureFlag",              DBType.adChar,      objReqPurchaseClosingSendList.InsureFlag,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",        DBType.adVarChar,   objReqPurchaseClosingSendList.AccessCenterCode,       512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",                DBType.adInteger,   objReqPurchaseClosingSendList.PageSize,               0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",                  DBType.adInteger,   objReqPurchaseClosingSendList.PageNo,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",               DBType.adInteger,   DBNull.Value,                                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_SEND_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseClosingSendList
                {
                    list      = new List<PurchaseClosingSendModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseClosingSendModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseClosingSendList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingSendList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 사업자 목록(업체마감)
        /// </summary>
        /// <param name="objReqPurchaseClientList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseClientList> GetPurchaseClientList(ReqPurchaseClientList objReqPurchaseClientList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClientList REQ] {JsonConvert.SerializeObject(objReqPurchaseClientList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseClientList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseClientList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqPurchaseClientList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",             DBType.adTinyInt,   objReqPurchaseClientList.DateType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",             DBType.adVarChar,   objReqPurchaseClientList.DateFrom,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",               DBType.adVarChar,   objReqPurchaseClientList.DateTo,               8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",   DBType.adVarChar,   objReqPurchaseClientList.OrderLocationCodes,   4000,    ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_strOrderItemCodes",       DBType.adVarChar,   objReqPurchaseClientList.OrderItemCodes,       4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",           DBType.adVarWChar,  objReqPurchaseClientList.ClientName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCorpNo",         DBType.adVarChar,   objReqPurchaseClientList.ClientCorpNo,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingFlag",          DBType.adChar,      objReqPurchaseClientList.ClosingFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objReqPurchaseClientList.AccessCenterCode,     512,     ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objReqPurchaseClientList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objReqPurchaseClientList.PageNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLIENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseClientList
                {
                    list = new List<PurchaseClientGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseClientGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseClientList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 비용 목록(업체마감)
        /// </summary>
        /// <param name="objReqPurchaseClientPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseClientPayList> GetPurchaseClientPayList(ReqPurchaseClientPayList objReqPurchaseClientPayList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClientPayList REQ] {JsonConvert.SerializeObject(objReqPurchaseClientPayList)}", bLogWrite);

            string                                  lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseClientPayList> lo_objResult = null;
            IDasNetCom                              lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseClientPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqPurchaseClientPayList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",          DBType.adBigInt,    objReqPurchaseClientPayList.ClientCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",            DBType.adTinyInt,   objReqPurchaseClientPayList.DateType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",            DBType.adVarChar,   objReqPurchaseClientPayList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",              DBType.adVarChar,   objReqPurchaseClientPayList.DateTo,              8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderLocationCodes",  DBType.adVarChar,   objReqPurchaseClientPayList.OrderLocationCodes,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",      DBType.adVarChar,   objReqPurchaseClientPayList.OrderItemCodes,      4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",          DBType.adVarWChar,  objReqPurchaseClientPayList.ClientName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientCorpNo",        DBType.adVarChar,   objReqPurchaseClientPayList.ClientCorpNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingFlag",         DBType.adChar,      objReqPurchaseClientPayList.ClosingFlag,         1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqPurchaseClientPayList.AccessCenterCode,    512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLIENT_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseClientPayList
                {
                    list = new List<PurchaseClientPayGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseClientPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseClientPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClientPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 매입 마감 등록(차량)
        /// </summary>
        /// <param name="objReqPurchaseClosingClientIns"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseClosingClientIns> SetPurchaseClosingClientIns(ReqPurchaseClosingClientIns objReqPurchaseClosingClientIns)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingClientIns REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingClientIns)}", bLogWrite);

            ServiceResult<ResPurchaseClosingClientIns> lo_objResult = null;
            IDasNetCom                                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseClosingClientIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,   objReqPurchaseClosingClientIns.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",            DBType.adBigInt,    objReqPurchaseClosingClientIns.ClientCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseSeqNos1",       DBType.adVarChar,   objReqPurchaseClosingClientIns.PurchaseSeqNos1,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseSeqNos2",       DBType.adVarChar,   objReqPurchaseClosingClientIns.PurchaseSeqNos2,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseSeqNos3",       DBType.adVarChar,   objReqPurchaseClosingClientIns.PurchaseSeqNos3,    4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPurchaseSeqNos4",       DBType.adVarChar,   objReqPurchaseClosingClientIns.PurchaseSeqNos4,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseSeqNos5",       DBType.adVarChar,   objReqPurchaseClosingClientIns.PurchaseSeqNos5,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseOrgAmt",        DBType.adCurrency,  objReqPurchaseClosingClientIns.PurchaseOrgAmt,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDeductAmt",             DBType.adCurrency,  objReqPurchaseClosingClientIns.DeductAmt,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeductReason",          DBType.adVarWChar,  objReqPurchaseClosingClientIns.DeductReason,       100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNote",                  DBType.adVarWChar,  objReqPurchaseClosingClientIns.Note,               500,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingAdminID",        DBType.adVarChar,   objReqPurchaseClosingClientIns.ClosingAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClosingAdminName",      DBType.adVarWChar,  objReqPurchaseClosingClientIns.ClosingAdminName,   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intPurchaseClosingSeqNo",  DBType.adBigInt,    DBNull.Value,                                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intPurchaseOrgAmt",        DBType.adCurrency,  DBNull.Value,                                      0,       ParameterDirection.Output);
                                                                                                                                          
                lo_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,   DBNull.Value,                                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                DBType.adInteger,   DBNull.Value,                                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,   DBNull.Value,                                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,   DBNull.Value,                                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_CLIENT_TX_INS");

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

                lo_objResult.data = new ResPurchaseClosingClientIns
                {
                    PurchaseClosingSeqNo = lo_objDas.GetParam("@po_intPurchaseClosingSeqNo").ToInt64(),
                    PurchaseOrgAmt       = lo_objDas.GetParam("@po_intPurchaseOrgAmt").ToDouble()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetPurchaseClosingClientIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingClientIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 업체 매입 마감 현황 상세 목록
        /// </summary>
        /// <param name="objReqPurchaseClosingClientPayList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseClosingClientPayList> GetPurchaseClosingClientPayList(ReqPurchaseClosingClientPayList objReqPurchaseClosingClientPayList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingClientPayList REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingClientPayList)}", bLogWrite);

            string                                         lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseClosingClientPayList> lo_objResult = null;
            IDasNetCom                                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseClosingClientPayList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPurchaseClosingSeqNo",  DBType.adBigInt,   objReqPurchaseClosingClientPayList.PurchaseClosingSeqNo,  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",            DBType.adInteger,  objReqPurchaseClosingClientPayList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",      DBType.adVarChar,  objReqPurchaseClosingClientPayList.AccessCenterCode,      512,     ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_CLIENT_PAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseClosingClientPayList
                {
                    list      = new List<PurchaseClosingClientPayGridModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseClosingClientPayGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseClosingClientPayList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseClosingClientPayList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        

        /// <summary>
        /// 매입 전표 공제 정보 변경
        /// </summary>
        /// <param name="objReqPurchaseClosingDeductUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPurchaseClosingDeductUpd(ReqPurchaseClosingDeductUpd objReqPurchaseClosingDeductUpd)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingDeductUpd REQ] {JsonConvert.SerializeObject(objReqPurchaseClosingDeductUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqPurchaseClosingDeductUpd.CenterCode,             0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPurchaseClosingSeqNo",   DBType.adBigInt,    objReqPurchaseClosingDeductUpd.PurchaseClosingSeqNo,   0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intInputDeductAmt",         DBType.adCurrency,  objReqPurchaseClosingDeductUpd.InputDeductAmt,         0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeductReason",           DBType.adVarWChar,  objReqPurchaseClosingDeductUpd.DeductReason,           100,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",             DBType.adVarChar,   objReqPurchaseClosingDeductUpd.UpdAdminID,             50,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUpdAdminName",           DBType.adVarWChar,  objReqPurchaseClosingDeductUpd.UpdAdminName,           50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                                          256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                                          0,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                                          256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                                          0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_CLOSING_DEDUCT_TX_UPD");

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
                                     , 9101, "System error(SetPurchaseClosingDeductUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[SetPurchaseClosingDeductUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 산재보험현황
        /// </summary>
        /// <param name="objReqPurchaseInsureList"></param>
        /// <returns></returns>
        public ServiceResult<ResPurchaseInsureList> GetPurchaseInsureList(ReqPurchaseInsureList objReqPurchaseInsureList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseInsureList REQ] {JsonConvert.SerializeObject(objReqPurchaseInsureList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResPurchaseInsureList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResPurchaseInsureList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqPurchaseInsureList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",           DBType.adTinyInt,   objReqPurchaseInsureList.DateType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar,   objReqPurchaseInsureList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar,   objReqPurchaseInsureList.DateTo,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",          DBType.adVarChar,   objReqPurchaseInsureList.ComCorpNo,           20,      ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@pi_strCarNo",              DBType.adVarWChar,  objReqPurchaseInsureList.CarNo,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",         DBType.adVarWChar,  objReqPurchaseInsureList.DriverName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",         DBType.adVarChar,   objReqPurchaseInsureList.DriverCell,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strInformationFlag",    DBType.adChar,      objReqPurchaseInsureList.InformationFlag,     1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intInsureExceptKind",   DBType.adTinyInt,   objReqPurchaseInsureList.InsureExceptKind,    0,       ParameterDirection.Input); 
                
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqPurchaseInsureList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_PURCHASE_INSURE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResPurchaseInsureList
                {
                    list      = new List<PurchaseInsureGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<PurchaseInsureGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetPurchaseInsureList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetPurchaseInsureList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}