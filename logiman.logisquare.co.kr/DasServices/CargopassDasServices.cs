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
    public class CargopassDasSerivices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 카고패스 현황 조회
        /// </summary>
        /// <param name="objReqCargopassList"></param>
        /// <returns></returns>
        public ServiceResult<ResCargopassList> GetCargopassList(ReqCargopassList objReqCargopassList)
        {
            SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[GetCargopassList REQ] {JsonConvert.SerializeObject(objReqCargopassList)}", bLogWrite);
            
            string                          lo_strJson   = string.Empty;
            ServiceResult<ResCargopassList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCargopassList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCargopassOrderNo",    DBType.adBigInt,    objReqCargopassList.CargopassOrderNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqCargopassList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",            DBType.adTinyInt,   objReqCargopassList.DateType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",            DBType.adVarChar,   objReqCargopassList.DateFrom,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",              DBType.adVarChar,   objReqCargopassList.DateTo,               8,       ParameterDirection.Input);
                                                                                                                               
                lo_objDas.AddParam("@pi_strComCorpNo",           DBType.adVarWChar,  objReqCargopassList.ComCorpNo,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",               DBType.adVarWChar,  objReqCargopassList.CarNo,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",          DBType.adVarWChar,  objReqCargopassList.DriverName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",          DBType.adVarWChar,  objReqCargopassList.DriverCell,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",             DBType.adBigInt,    objReqCargopassList.OrderNo,              0,       ParameterDirection.Input);
                                                                                                                               
                lo_objDas.AddParam("@pi_strCargopassStatuses",   DBType.adVarChar,   objReqCargopassList.CargopassStatuses,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyOrderFlag",         DBType.adChar,      objReqCargopassList.MyOrderFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",          DBType.adVarChar,   objReqCargopassList.RegAdminID,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",        DBType.adVarWChar,  objReqCargopassList.RegAdminName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqCargopassList.AccessCenterCode,     512,     ParameterDirection.Input);
                                                                                                                               
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objReqCargopassList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objReqCargopassList.PageNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CARGOPASS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCargopassList
                {
                    list      = new List<CargopassGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CargopassGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCargopassList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[GetCargopassList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 카고패스 연동 상하차정보 목록
        /// </summary>
        /// <param name="objReqCargopassOrderPlaceList"></param>
        /// <returns></returns>
        public ServiceResult<ResCargopassOrderPlaceList> GetCargopassOrderPlaceList(ReqCargopassOrderPlaceList objReqCargopassOrderPlaceList)
        {
            SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[GetCargopassOrderPlaceList REQ] {JsonConvert.SerializeObject(objReqCargopassOrderPlaceList)}", bLogWrite);
            
            string                                    lo_strJson   = string.Empty;
            ServiceResult<ResCargopassOrderPlaceList> lo_objResult = null;
            IDasNetCom                                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCargopassOrderPlaceList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCargopassOrderNo",   DBType.adBigInt,    objReqCargopassOrderPlaceList.CargopassOrderNo,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqCargopassOrderPlaceList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",           DBType.adVarChar,   objReqCargopassOrderPlaceList.OrderNos,           4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objReqCargopassOrderPlaceList.AdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqCargopassOrderPlaceList.AccessCenterCode,   512,     ParameterDirection.Input);

                lo_objDas.AddParam("@po_intOrderCnt",           DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intVolume",             DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCBM",                DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intWeight",             DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCarTon",             DBType.adVarWChar,  DBNull.Value,                                     50,      ParameterDirection.Output);

                lo_objDas.AddParam("@po_strCarTruck",           DBType.adVarWChar,  DBNull.Value,                                     50,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CARGOPASS_ORDER_PLACE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCargopassOrderPlaceList
                {
                    list      = new List<CargopassOrderPlaceGridModel>(),
                    OrderCnt  = lo_objDas.GetParam("@po_intOrderCnt").ToInt(),
                    Volume    = lo_objDas.GetParam("@po_intVolume").ToInt(),
                    CBM       = lo_objDas.GetParam("@po_intCBM").ToDouble(),
                    Weight    = lo_objDas.GetParam("@po_intWeight").ToInt(),
                    CarTon    = lo_objDas.GetParam("@po_strCarTon"),
                    CarTruck  = lo_objDas.GetParam("@po_strCarTruck"),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CargopassOrderPlaceGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCargopassOrderPlaceList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[GetCargopassOrderPlaceList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 카고패스 연동정보 등록
        /// </summary>
        /// <param name="objCargopassModel"></param>
        /// <returns></returns>
        public ServiceResult<CargopassModel> SetCargopassIns(CargopassModel objCargopassModel)
        {
            SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[SetCargopassIns REQ] {JsonConvert.SerializeObject(objCargopassModel)}", bLogWrite);

            ServiceResult<CargopassModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<CargopassModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                                
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objCargopassModel.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",            DBType.adVarChar,   objCargopassModel.OrderNos,             4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchType",        DBType.adTinyInt,   objCargopassModel.DispatchType,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",       DBType.adVarWChar,  objCargopassModel.ConsignorName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",           DBType.adVarChar,   objCargopassModel.PickupYMD,            8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupHM",            DBType.adVarChar,   objCargopassModel.PickupHM,             4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupAddr",          DBType.adVarWChar,  objCargopassModel.PickupAddr,           100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupAddrDtl",       DBType.adVarWChar,  objCargopassModel.PickupAddrDtl,        100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupWay",           DBType.adVarWChar,  objCargopassModel.PickupWay,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",              DBType.adVarChar,   objCargopassModel.GetYMD,               8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetHM",               DBType.adVarChar,   objCargopassModel.GetHM,                4,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetAddr",             DBType.adVarWChar,  objCargopassModel.GetAddr,              100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetAddrDtl",          DBType.adVarWChar,  objCargopassModel.GetAddrDtl,           100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetWay",              DBType.adVarWChar,  objCargopassModel.GetWay,               20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetTelNo",            DBType.adVarChar,   objCargopassModel.GetTelNo,             20,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intWeight",              DBType.adDouble,    objCargopassModel.Weight,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intVolume",              DBType.adInteger,   objCargopassModel.Volume,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCBM",                 DBType.adDouble,    objCargopassModel.CBM,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTon",              DBType.adVarWChar,  objCargopassModel.CarTon,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTruck",            DBType.adVarWChar,  objCargopassModel.CarTruck,             50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intQuickType",           DBType.adTinyInt,   objCargopassModel.QuickType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayPlanYMD",          DBType.adVarChar,   objCargopassModel.PayPlanYMD,           8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSupplyAmt",           DBType.adCurrency,  objCargopassModel.SupplyAmt,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLayerFlag",           DBType.adChar,      objCargopassModel.LayerFlag,            1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUrgentFlag",          DBType.adChar,      objCargopassModel.UrgentFlag,           1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strShuttleFlag",         DBType.adChar,      objCargopassModel.ShuttleFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNote",                DBType.adVarWChar,  objCargopassModel.Note,                 200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTelNo",               DBType.adVarChar,   objCargopassModel.TelNo,                20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetwork24DDID",       DBType.adVarChar,   objCargopassModel.Network24DDID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkHMMID",        DBType.adVarWChar,  objCargopassModel.NetworkHMMID,         50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNetworkOneCallID",    DBType.adVarWChar,  objCargopassModel.NetworkOneCallID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkHmadangID",    DBType.adVarWChar,  objCargopassModel.NetworkHmadangID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",          DBType.adVarChar,   objCargopassModel.RegAdminID,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",        DBType.adVarWChar,  objCargopassModel.RegAdminName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intCargopassOrderNo",    DBType.adBigInt,    DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,                           256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CARGOPASS_TX_INS");
                
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
                objCargopassModel.CargopassOrderNo = lo_objDas.GetParam("@po_intCargopassOrderNo").ToInt64();
                lo_objResult.data                  = objCargopassModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetCargopassIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[SetCargopassIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 카고패스 연동정보 수정
        /// </summary>
        /// <param name="objCargopassModel"></param>
        /// <returns></returns>
        public ServiceResult<CargopassModel> SetCargopassUpd(CargopassModel objCargopassModel)
        {
            SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[SetCargopassUpd REQ] {JsonConvert.SerializeObject(objCargopassModel)}", bLogWrite);

            ServiceResult<CargopassModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<CargopassModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intCargopassOrderNo",    DBType.adBigInt,    objCargopassModel.CargopassOrderNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objCargopassModel.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",       DBType.adVarWChar,  objCargopassModel.ConsignorName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",           DBType.adVarChar,   objCargopassModel.PickupYMD,           8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupHM",            DBType.adVarChar,   objCargopassModel.PickupHM,            4,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupAddr",          DBType.adVarWChar,  objCargopassModel.PickupAddr,          100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupAddrDtl",       DBType.adVarWChar,  objCargopassModel.PickupAddrDtl,       100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupWay",           DBType.adVarWChar,  objCargopassModel.PickupWay,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",              DBType.adVarChar,   objCargopassModel.GetYMD,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetHM",               DBType.adVarChar,   objCargopassModel.GetHM,               4,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strGetAddr",             DBType.adVarWChar,  objCargopassModel.GetAddr,             100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetAddrDtl",          DBType.adVarWChar,  objCargopassModel.GetAddrDtl,          100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetWay",              DBType.adVarWChar,  objCargopassModel.GetWay,              20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetTelNo",            DBType.adVarChar,   objCargopassModel.GetTelNo,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intWeight",              DBType.adDouble,    objCargopassModel.Weight,               0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intVolume",              DBType.adInteger,   objCargopassModel.Volume,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCBM",                 DBType.adDouble,    objCargopassModel.CBM,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTon",              DBType.adVarWChar,  objCargopassModel.CarTon,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTruck",            DBType.adVarWChar,  objCargopassModel.CarTruck,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intQuickType",           DBType.adTinyInt,   objCargopassModel.QuickType,           0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPayPlanYMD",          DBType.adVarChar,   objCargopassModel.PayPlanYMD,          8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSupplyAmt",           DBType.adCurrency,  objCargopassModel.SupplyAmt,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLayerFlag",           DBType.adChar,      objCargopassModel.LayerFlag,           1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUrgentFlag",          DBType.adChar,      objCargopassModel.UrgentFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShuttleFlag",         DBType.adChar,      objCargopassModel.ShuttleFlag,         1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNote",                DBType.adVarWChar,  objCargopassModel.Note,                200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTelNo",               DBType.adVarChar,   objCargopassModel.TelNo,               20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetwork24DDID",       DBType.adVarChar,   objCargopassModel.Network24DDID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkHMMID",        DBType.adVarWChar,  objCargopassModel.NetworkHMMID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkOneCallID",    DBType.adVarWChar,  objCargopassModel.NetworkOneCallID,    50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strNetworkHmadangID",    DBType.adVarWChar,  objCargopassModel.NetworkHmadangID,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",          DBType.adVarChar,   objCargopassModel.UpdAdminID,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",        DBType.adVarWChar,  objCargopassModel.UpdAdminName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strNetwork24DDID",       DBType.adVarChar,   DBNull.Value,                          50,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNetworkHMMID",        DBType.adVarWChar,  DBNull.Value,                          50,      ParameterDirection.Output);

                lo_objDas.AddParam("@po_strNetworkOneCallID",    DBType.adVarWChar,  DBNull.Value,                          50,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strNetworkHmadangID",    DBType.adVarWChar,  DBNull.Value,                          50,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CARGOPASS_TX_UPD");
                
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
                objCargopassModel.Network24DDID    = lo_objDas.GetParam("@po_strNetwork24DDID");
                objCargopassModel.NetworkHMMID     = lo_objDas.GetParam("@po_strNetworkHMMID");
                objCargopassModel.NetworkOneCallID = lo_objDas.GetParam("@po_strNetworkOneCallID");
                objCargopassModel.NetworkHmadangID = lo_objDas.GetParam("@po_strNetworkHmadangID");
                lo_objResult.data                  = objCargopassModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetCargopassUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[SetCargopassUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 카고패스 Noti 처리
        /// </summary>
        /// <param name="objCargopassModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> UpdOrderCargopassNoti(CargopassNotiOrder objReqCargopassNotiOrder)
        {
            SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[UpdOrderCargopassNoti REQ] {JsonConvert.SerializeObject(objReqCargopassNotiOrder)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strCenterCode",           DBType.adVarChar,  objReqCargopassNotiOrder.CenterCode,           30,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterOrderNo",        DBType.adVarChar,  objReqCargopassNotiOrder.CenterOrderNo,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCPOrderNo",            DBType.adBigInt,   objReqCargopassNotiOrder.CPOrderNo,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNetworkOrdNo",         DBType.adVarChar,  objReqCargopassNotiOrder.NetworkOrdNo,         50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCargopassNetworkKind", DBType.adTinyInt,  objReqCargopassNotiOrder.CargopassNetworkKind, 0,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strStartWide",            DBType.adVarWChar, objReqCargopassNotiOrder.startWide,            50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStartSgg",             DBType.adVarWChar, objReqCargopassNotiOrder.startSgg,             50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStartDong",            DBType.adVarWChar, objReqCargopassNotiOrder.startDong,            50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStartDetail",          DBType.adVarWChar, objReqCargopassNotiOrder.startDetail,          100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndWide",              DBType.adVarWChar, objReqCargopassNotiOrder.endWide,              50,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strEndSgg",               DBType.adVarWChar, objReqCargopassNotiOrder.endSgg,               50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndDong",              DBType.adVarWChar, objReqCargopassNotiOrder.endDong,              50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndDetail",            DBType.adVarWChar, objReqCargopassNotiOrder.endDetail,            100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMultiCargoGub",        DBType.adVarWChar, objReqCargopassNotiOrder.multiCargoGub,        10,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUrgent",               DBType.adVarWChar, objReqCargopassNotiOrder.urgent,               10,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strShuttleCargoInfo",     DBType.adVarWChar, objReqCargopassNotiOrder.shuttleCargoInfo,     10,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCargoTon",             DBType.adVarWChar, objReqCargopassNotiOrder.cargoTon,             10,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTruckType",            DBType.adVarWChar, objReqCargopassNotiOrder.truckType,            10,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFrgton",               DBType.adVarWChar, objReqCargopassNotiOrder.frgton,               10,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStartPlanDt",          DBType.adVarChar,  objReqCargopassNotiOrder.startPlanDt,          8,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strStartPlanTm",          DBType.adVarChar,  objReqCargopassNotiOrder.StartPlanTm,          4,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndPlanDt",            DBType.adVarChar,  objReqCargopassNotiOrder.endPlanDt,            8,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndPlanTm",            DBType.adVarChar,  objReqCargopassNotiOrder.EndPlanTm,            4,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strStartLoad",            DBType.adVarWChar, objReqCargopassNotiOrder.startLoad,            20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndLoad",              DBType.adVarWChar, objReqCargopassNotiOrder.endLoad,              20,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCargoDsc",             DBType.adVarWChar, objReqCargopassNotiOrder.cargoDsc,             100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFarePaytype",          DBType.adVarWChar, objReqCargopassNotiOrder.farePaytype,          20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFare",                 DBType.adDouble,   objReqCargopassNotiOrder.fare,                 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFee",                  DBType.adDouble,   objReqCargopassNotiOrder.fee,                  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndAreaPhone",         DBType.adVarChar,  objReqCargopassNotiOrder.endAreaPhone,         20,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strTaxbillType",          DBType.adChar,     objReqCargopassNotiOrder.taxbillType,          1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPayPlanYmd",           DBType.adVarChar,  objReqCargopassNotiOrder.payPlanYmd,           8,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",        DBType.adVarWChar, objReqCargopassNotiOrder.ConsignorName,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTelephone",            DBType.adVarChar,  objReqCargopassNotiOrder.Telephone,            20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCPOrderStatus",        DBType.adTinyInt,  objReqCargopassNotiOrder.CPOrderStatus,        0,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDriverBizName",        DBType.adVarWChar, objReqCargopassNotiOrder.DriverName,           100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverBizNo",          DBType.adVarWChar, objReqCargopassNotiOrder.DriverBizNo,          10,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",           DBType.adVarWChar, objReqCargopassNotiOrder.DriverBizName,        50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",           DBType.adVarWChar, objReqCargopassNotiOrder.DriverCell,           20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCarNo",          DBType.adVarWChar, objReqCargopassNotiOrder.DriverCarNo,          20,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDriverCarTon",         DBType.adVarWChar, objReqCargopassNotiOrder.DriverCarTon,         20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCarType",        DBType.adVarWChar, objReqCargopassNotiOrder.DriverCarType,        20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",              DBType.adVarChar,  objReqCargopassNotiOrder.AdminID,              50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",            DBType.adVarWChar, objReqCargopassNotiOrder.AdminName,            50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",               DBType.adVarChar,  DBNull.Value,                                  256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",               DBType.adInteger,  DBNull.Value,                                  0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",             DBType.adVarChar,  DBNull.Value,                                  256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",             DBType.adInteger,  DBNull.Value,                                  0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CARGOPASS_NOTI_TX_UPD");
                
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
                                     , 9101, "System error(UpdOrderCargopassNoti)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CargopassDasSerivices", "I", $"[UpdOrderCargopassNoti RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}