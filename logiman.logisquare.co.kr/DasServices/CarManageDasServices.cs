using System;
using System.Collections.Generic;
using System.Data;
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using Newtonsoft.Json;
using PBSDasNetCom;

namespace CommonLibrary.DasServices
{
    public class CarManageDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;
        

        /// <summary>
        /// 용차현황
        /// </summary>
        /// <param name="objReqDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResDispatchList> GetDispatchList(ReqDispatchList objReqDispatchList)
        {
            SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[GetDispatchList REQ] {JsonConvert.SerializeObject(objReqDispatchList)}", bLogWrite);
            
            string                         lo_strJson   = string.Empty;
            ServiceResult<ResDispatchList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqDispatchList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",            DBType.adTinyInt,   objReqDispatchList.DateType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",            DBType.adVarChar,   objReqDispatchList.DateFrom,           8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",              DBType.adVarChar,   objReqDispatchList.DateTo,             8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",             DBType.adVarWChar,  objReqDispatchList.ComName,            100,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strComCorpNo",           DBType.adVarChar,   objReqDispatchList.ComCorpNo,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",               DBType.adVarWChar,  objReqDispatchList.CarNo,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",          DBType.adVarWChar,  objReqDispatchList.DriverName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",          DBType.adVarChar,   objReqDispatchList.DriverCell,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDispatchAdminID",     DBType.adVarChar,   objReqDispatchList.DispatchAdminID,    50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqDispatchList.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objReqDispatchList.PageSize,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objReqDispatchList.PageNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_MANAGE_DISPATCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResDispatchList
                {
                    list      = new List<DispatchListGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<DispatchListGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetDispatchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[GetDispatchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 연계 및 공유차량 목록(오더)
        /// </summary>
        /// <param name="objReqCarManageDispatchSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResCarManageDispatchSearchList> GetCarManageDispatchSearchList(ReqCarManageDispatchSearchList objReqCarManageDispatchSearchList)
        {
            SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[GetCarManageDispatchSearchList REQ] {JsonConvert.SerializeObject(objReqCarManageDispatchSearchList)}", bLogWrite);
            
            string                                        lo_strJson   = string.Empty;
            ServiceResult<ResCarManageDispatchSearchList> lo_objResult = null;
            IDasNetCom                                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarManageDispatchSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   objReqCarManageDispatchSearchList.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",          DBType.adBigInt,    objReqCarManageDispatchSearchList.OrderNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",        DBType.adVarChar,   objReqCarManageDispatchSearchList.PickupYMD,       8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupFullAddr",   DBType.adVarWChar,  objReqCarManageDispatchSearchList.PickupFullAddr,  150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",          DBType.adVarChar,   objReqCarManageDispatchSearchList.AdminID,         50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,   objReqCarManageDispatchSearchList.PageSize,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,   objReqCarManageDispatchSearchList.PageNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,   DBNull.Value,                                      0,       ParameterDirection.Output);


                lo_objDas.SetQuery("dbo.UP_CAR_MANAGE_DISPATCH_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarManageDispatchSearchList
                {
                    list      = new List<CarManageDispatchGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarManageDispatchGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarManageDispatchSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[GetCarManageDispatchSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 관리 차량 배차 목록(오더)
        /// </summary>
        /// <param name="objReqCarManageSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResCarManageSearchList> GetCarManageSearchList(ReqCarManageSearchList objReqCarManageSearchList)
        {
            SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[GetCarManageSearchList REQ] {JsonConvert.SerializeObject(objReqCarManageSearchList)}", bLogWrite);
            
            string                                lo_strJson   = string.Empty;
            ServiceResult<ResCarManageSearchList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarManageSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strPickupYMD",        DBType.adVarChar,   objReqCarManageSearchList.PickupYMD,       8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupFullAddr",   DBType.adVarWChar,  objReqCarManageSearchList.PickupFullAddr,  150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetFullAddr",      DBType.adVarWChar,  objReqCarManageSearchList.GetFullAddr,     150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",          DBType.adVarChar,   objReqCarManageSearchList.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,   objReqCarManageSearchList.PageSize,        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,   objReqCarManageSearchList.PageNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,   DBNull.Value,                              0,       ParameterDirection.Output);


                lo_objDas.SetQuery("dbo.UP_CAR_MANAGE_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarManageSearchList
                {
                    list      = new List<CarManageGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarManageGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarManageSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[GetCarManageSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 관리 차량 목록
        /// </summary>
        /// <param name="objReqCarManageList"></param>
        /// <returns></returns>
        public ServiceResult<ResCarManageList> GetCarManageList(ReqCarManageList objReqCarManageList)
        {
            SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[GetCarManageList REQ] {JsonConvert.SerializeObject(objReqCarManageList)}", bLogWrite);
            
            string                          lo_strJson   = string.Empty;
            ServiceResult<ResCarManageList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCarManageList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intManageSeqNo",       DBType.adBigInt,    objReqCarManageList.ManageSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqCarManageList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",           DBType.adVarWChar,  objReqCarManageList.ComName,             100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",         DBType.adVarChar,   objReqCarManageList.ComCorpNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",             DBType.adVarWChar,  objReqCarManageList.CarNo,               50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDriverName",        DBType.adVarWChar,  objReqCarManageList.DriverName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",        DBType.adVarChar,   objReqCarManageList.DriverCell,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShareFlag",         DBType.adChar,      objReqCarManageList.ShareFlag,           1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",           DBType.adVarChar,   objReqCarManageList.AdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqCarManageList.AccessCenterCode,    512,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objReqCarManageList.PageSize,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objReqCarManageList.PageNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_MANAGE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCarManageList
                {
                    list      = new List<CarManageGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CarManageGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCarManageList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[GetCarManageList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 관리차량 삭제
        /// </summary>
        /// <param name="objCarManageDel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetCarManageDel(ReqCarManageDel objCarManageDel)
        {
            SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[SetCarManageDel REQ] {JsonConvert.SerializeObject(objCarManageDel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strManageSeqNos",   DBType.adVarChar,   objCarManageDel.ManageSeqNos,  4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",     DBType.adVarChar,   objCarManageDel.DelAdminID,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                  256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                  0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                  256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_MANAGE_TX_DEL");

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
                                     , 9101, "System error(SetCarManageDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[SetCarManageDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 관리차량 등록
        /// </summary>
        /// <param name="objCarManageIns"></param>
        /// <returns></returns>
        public ServiceResult<CarManageGridModel> SetCarManageIns(CarManageGridModel objCarManageIns)
        {
            SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[SetCarManageIns REQ] {JsonConvert.SerializeObject(objCarManageIns)}", bLogWrite);

            ServiceResult<CarManageGridModel> lo_objResult             = null;
            IDasNetCom                        lo_objDas                = null;
            CarManageGridModel                lo_objCarManageGridModel = null;

            try
            {
                lo_objResult = new ServiceResult<CarManageGridModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intComCode",           DBType.adBigInt,    objCarManageIns.ComCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",           DBType.adVarWChar,  objCarManageIns.ComName,             100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",         DBType.adVarChar,   objCarManageIns.ComCorpNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCarSeqNo",          DBType.adBigInt,    objCarManageIns.CarSeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",             DBType.adVarWChar,  objCarManageIns.CarNo,               50,      ParameterDirection.Input);
                                                                                                                        
                lo_objDas.AddParam("@pi_strCarTypeCode",       DBType.adVarChar,   objCarManageIns.CarTypeCode,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",        DBType.adVarChar,   objCarManageIns.CarTonCode,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDriverSeqNo",       DBType.adBigInt,    objCarManageIns.DriverSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",        DBType.adVarWChar,  objCarManageIns.DriverName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",        DBType.adVarChar,   objCarManageIns.DriverCell,          20,      ParameterDirection.Input);
                                                                                                                        
                lo_objDas.AddParam("@pi_strPickupFullAddr1",   DBType.adVarWChar,  objCarManageIns.PickupFullAddr1,     150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetFullAddr1",      DBType.adVarWChar,  objCarManageIns.GetFullAddr1,        150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupFullAddr2",   DBType.adVarWChar,  objCarManageIns.PickupFullAddr2,     150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetFullAddr2",      DBType.adVarWChar,  objCarManageIns.GetFullAddr2,        150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupFullAddr3",   DBType.adVarWChar,  objCarManageIns.PickupFullAddr3,     150,     ParameterDirection.Input);
                                                                                                                        
                lo_objDas.AddParam("@pi_strGetFullAddr3",      DBType.adVarWChar,  objCarManageIns.GetFullAddr3,        150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDayInfo",           DBType.adVarWChar,  objCarManageIns.DayInfo,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndYMDFlag",        DBType.adChar,      objCarManageIns.EndYMDFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndYMD",            DBType.adVarChar,   objCarManageIns.EndYMD,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShareFlag",         DBType.adChar,      objCarManageIns.ShareFlag,           1,       ParameterDirection.Input);
                                                                                                                        
                lo_objDas.AddParam("@pi_strRegAdminID",        DBType.adVarChar,   objCarManageIns.RegAdminID,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",      DBType.adVarWChar,  objCarManageIns.RegAdminName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intManageSeqNo",       DBType.adBigInt,    DBNull.Value,                        0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);
                                                                                                                        
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_MANAGE_TX_INS");

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

                lo_objCarManageGridModel             = objCarManageIns;
                lo_objCarManageGridModel.ManageSeqNo = lo_objDas.GetParam("@po_intManageSeqNo");

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
                lo_objResult.data = lo_objCarManageGridModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetCarManageIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[SetCarManageIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 관리차량 수정
        /// </summary>
        /// <param name="objCarManageUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetCarManageUpd(CarManageGridModel objCarManageUpd)
        {
            SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[SetCarManageUpd REQ] {JsonConvert.SerializeObject(objCarManageUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intManageSeqNo",       DBType.adBigInt,    objCarManageUpd.ManageSeqNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupFullAddr1",   DBType.adVarWChar,  objCarManageUpd.PickupFullAddr1,   150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetFullAddr1",      DBType.adVarWChar,  objCarManageUpd.GetFullAddr1,      150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupFullAddr2",   DBType.adVarWChar,  objCarManageUpd.PickupFullAddr2,   150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetFullAddr2",      DBType.adVarWChar,  objCarManageUpd.GetFullAddr2,      150,     ParameterDirection.Input);
                                                                                                                      
                lo_objDas.AddParam("@pi_strPickupFullAddr3",   DBType.adVarWChar,  objCarManageUpd.PickupFullAddr3,   150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetFullAddr3",      DBType.adVarWChar,  objCarManageUpd.GetFullAddr3,      150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDayInfo",           DBType.adVarWChar,  objCarManageUpd.DayInfo,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndYMDFlag",        DBType.adChar,      objCarManageUpd.EndYMDFlag,        1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strEndYMD",            DBType.adVarChar,   objCarManageUpd.EndYMD,            8,       ParameterDirection.Input);
                                                                                                                      
                lo_objDas.AddParam("@pi_strShareFlag",         DBType.adChar,      objCarManageUpd.ShareFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",        DBType.adVarChar,   objCarManageUpd.UpdAdminID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",      DBType.adVarWChar,  objCarManageUpd.UpdAdminName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                                                               
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_MANAGE_TX_UPD");

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
                                     , 9101, "System error(SetCarManageUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[SetCarManageUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 배차 기록 등록
        /// </summary>
        /// <param name="objCarManageDispatchIns"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetCarManageDispatchIns(ReqCarManageDispatchIns objCarManageDispatchIns)
        {
            SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[SetCarManageDispatchIns REQ] {JsonConvert.SerializeObject(objCarManageDispatchIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCarDispatchType",  DBType.adTinyInt,   objCarManageDispatchIns.CarDispatchType,  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",         DBType.adBigInt,    objCarManageDispatchIns.RefSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComName",          DBType.adVarWChar,  objCarManageDispatchIns.ComName,          100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strComCorpNo",        DBType.adVarChar,   objCarManageDispatchIns.ComCorpNo,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",            DBType.adVarWChar,  objCarManageDispatchIns.CarNo,            50,      ParameterDirection.Input);
                                                                                  
                lo_objDas.AddParam("@pi_strCarTypeCode",      DBType.adVarChar,   objCarManageDispatchIns.CarTypeCode,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",       DBType.adVarChar,   objCarManageDispatchIns.CarTonCode,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverName",       DBType.adVarWChar,  objCarManageDispatchIns.DriverName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDriverCell",       DBType.adVarChar,   objCarManageDispatchIns.DriverCell,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrgCenterCode",    DBType.adInteger,   objCarManageDispatchIns.OrgCenterCode,    0,       ParameterDirection.Input);
                                                                                  
                lo_objDas.AddParam("@pi_intOrgOrderNo",       DBType.adBigInt,    objCarManageDispatchIns.OrgOrderNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   objCarManageDispatchIns.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",          DBType.adBigInt,    objCarManageDispatchIns.OrderNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAreaDistance",     DBType.adDouble,    objCarManageDispatchIns.AreaDistance,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",       DBType.adVarChar,   objCarManageDispatchIns.RegAdminID,       50,      ParameterDirection.Input);

                lo_objDas.AddParam("@po_intSeqNo",            DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,   DBNull.Value,                             256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CAR_MANAGE_DISPATCH_TX_INS");

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
                                     , 9101, "System error(SetCarManageDispatchIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CarManageDasServices", "I", $"[SetCarManageDispatchIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}