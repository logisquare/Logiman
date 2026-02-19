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
    public class CarMapDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// GPS 정보 조회(기사정보)
        /// </summary>
        /// <param name="objReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResCarMapList> GetGPSDriverList(ReqCarMapList objReqCarMapList)
        {
            SiteGlobal.WriteInformation("CarMapDasServices", "I", $"[GetCarMapControlList REQ] {JsonConvert.SerializeObject(objReqCarMapList)}", bLogWrite);
            
            string                       lo_strJson   = string.Empty;
            ServiceResult<ResCarMapList> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarMapList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,  objReqCarMapList.CenterCode, 0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell", DBType.adVarChar,  objReqCarMapList.DriverCell, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",      DBType.adVarWChar, objReqCarMapList.CarNo,      50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",   DBType.adVarChar,  objReqCarMapList.DateFrom,   8,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarDivType", DBType.adTinyInt,  objReqCarMapList.CarDivType, 0,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",   DBType.adInteger,  objReqCarMapList.PageSize,   0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",     DBType.adInteger,  objReqCarMapList.PageNo,     0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger,  DBNull.Value,                0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_GPS_USE_DRIVER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarMapList
                {
                    list = new List<CarMapGridModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarMapGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarMapControlList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarMapDasServices", "I", $"[GetCarMapControlList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// GPS 정보 조회(기사정보)
        /// </summary>
        /// <param name="objReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResCarMapList> GetGPSOrderList(ReqCarMapList objReqCarMapList)
        {
            SiteGlobal.WriteInformation("CarMapDasServices", "I", $"[GetGPSOrderList REQ] {JsonConvert.SerializeObject(objReqCarMapList)}", bLogWrite);
            
            string                       lo_strJson   = string.Empty;
            ServiceResult<ResCarMapList> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarMapList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",    DBType.adBigInt,   objReqCarMapList.OrderNo,    0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,  objReqCarMapList.CenterCode, 0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",   DBType.adTinyInt,  objReqCarMapList.DateType,   0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",   DBType.adVarChar,  objReqCarMapList.DateFrom,   8,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",      DBType.adVarWChar, objReqCarMapList.CarNo,      50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDriverCell", DBType.adVarChar,  objReqCarMapList.DriverCell, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarDivType", DBType.adTinyInt,  objReqCarMapList.CarDivType, 0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",   DBType.adInteger,  objReqCarMapList.PageSize,   0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",     DBType.adInteger,  objReqCarMapList.PageNo,     0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger,  DBNull.Value,                0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_GPS_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarMapList
                {
                    list = new List<CarMapGridModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarMapGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetGPSOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarMapDasServices", "I", $"[GetGPSOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 전체 차량 목록
        /// </summary>
        /// <param name="objReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResGpsList> GetGPSDayAllCarsList(ReqCarMapList objReqCarMapList)
        {
            SiteGlobal.WriteInformation("CarMapDasServices", "I", $"[GetGPSDayAllCarsList REQ] {JsonConvert.SerializeObject(objReqCarMapList)}", bLogWrite);
            
            string                    lo_strJson   = string.Empty;
            ServiceResult<ResGpsList> lo_objResult = null;
            IDasNetCom                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResGpsList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,  objReqCarMapList.CenterCode,    0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strYMD",           DBType.adVarChar,  objReqCarMapList.YMD,           8,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTotalCarsFlag", DBType.adVarChar,  objReqCarMapList.TotalCarsFlag, 10, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_GPS_DAY_ALL_CARS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResGpsList
                {
                    list = new List<GpsGridModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<GpsGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetGPSDayAllCarsList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarMapDasServices", "I", $"[GetGPSDayAllCarsList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// GPS 정보 조회
        /// </summary>
        /// <param name="objReqOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResGpsList> GetGPSList(ReqCarMapList objReqCarMapList)
        {
            SiteGlobal.WriteInformation("CarMapDasServices", "I", $"[GetGPSList REQ] {JsonConvert.SerializeObject(objReqCarMapList)}", bLogWrite);

            string                    lo_strJson   = string.Empty;
            ServiceResult<ResGpsList> lo_objResult = null;
            IDasNetCom                lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResGpsList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAuthTel",        DBType.adVarChar, objReqCarMapList.AuthTel,        20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD",        DBType.adVarChar, objReqCarMapList.DateFrom,       8,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD",          DBType.adVarChar, objReqCarMapList.DateTo,         8,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMaxLinearMeter", DBType.adInteger, objReqCarMapList.MaxLinearMeter, 0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMaxMinutes",     DBType.adInteger, objReqCarMapList.MaxMinutes,     0,  ParameterDirection.Input);

                lo_objDas.AddParam("@po_intTotalDistance", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strTotalElapsedTime", DBType.adVarWChar, DBNull.Value, 100, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_GPS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResGpsList
                {
                    list             = new List<GpsGridModel>(),
                    RecordCnt        = lo_objDas.RecordCount,
                    TotalDistance    = lo_objDas.GetParam("@po_intTotalDistance").ToInt(),
                    TotalElapsedTime = lo_objDas.GetParam("@po_strTotalElapsedTime")
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<GpsGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetGPSList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarMapDasServices", "I", $"[GetGPSDayAllCarsList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        public ServiceResult<GpsInfo> GetGpsLastLocation(ReqCarMapList objReqCarMapList)
        {
            SiteGlobal.WriteInformation("CarMapDasServices", "I", $"[GetGPSDayAllCarsList REQ] {JsonConvert.SerializeObject(objReqCarMapList)}", bLogWrite);

            ServiceResult<GpsInfo> lo_objResult = null;
            IDasNetCom             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<GpsInfo>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAuthTel",         DBType.adVarChar,  objReqCarMapList.AuthTel, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strYMD",             DBType.adVarChar,  objReqCarMapList.YMD,     8,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegDate",         DBType.adVarChar,  objReqCarMapList.RegDate, 19, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strExists",          DBType.adChar,     DBNull.Value,  1,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intSeqNo",           DBType.adBigInt,   DBNull.Value,  0,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strComCorpNo",       DBType.adVarChar,  DBNull.Value,  20,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAuthTel",         DBType.adVarChar,  DBNull.Value,  20,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDeviceModel",     DBType.adVarWChar, DBNull.Value,  50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strOSVersion",       DBType.adVarChar,  DBNull.Value,  20,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAPIVersion",      DBType.adVarChar,  DBNull.Value,  20,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_strLat",             DBType.adVarChar,  DBNull.Value,  50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strLng",             DBType.adVarChar,  DBNull.Value,  50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strRegYMD",          DBType.adVarChar,  DBNull.Value,  8,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strRegDate",         DBType.adVarChar,  DBNull.Value,  19,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,  DBNull.Value,  256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,  DBNull.Value,  0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,  DBNull.Value,  256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,  DBNull.Value,  0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_GPS_LAST_LOCATION_NT_GET");

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

                lo_objResult.data = new GpsInfo
                {   
                    Exists      = lo_objDas.GetParam("@po_strExists"),
                    SeqNo       = lo_objDas.GetParam("@po_intSeqNo"),
                    ComCorpNo   = lo_objDas.GetParam("@po_strComCorpNo"),
                    AuthTel     = lo_objDas.GetParam("@po_strAuthTel"),
                    DeviceModel = lo_objDas.GetParam("@po_strDeviceModel"),
                    OSVersion   = lo_objDas.GetParam("@po_strOSVersion"),
                    APIVersion  = lo_objDas.GetParam("@po_strAPIVersion"),
                    Lat         = lo_objDas.GetParam("@po_strLat"),
                    Lng         = lo_objDas.GetParam("@po_strLng"),
                    RegYMD      = lo_objDas.GetParam("@po_strRegYMD"),
                    RegDate     = lo_objDas.GetParam("@po_strRegDate")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetGpsLastLocation)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetGpsLastLocation RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}