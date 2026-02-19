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
    public class MisStatDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 경영정보시스템 전체 - 월별
        /// </summary>
        /// <param name="objReqStatOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResStatOrderList> GetStatOrderTotalMonthList(ReqStatOrderList objReqStatOrderList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderTotalMonthList REQ] {JsonConvert.SerializeObject(objReqStatOrderList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResStatOrderList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResStatOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSearchYMD",           DBType.adVarChar,   objReqStatOrderList.SearchYMD,          8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqStatOrderList.CenterCode,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",      DBType.adVarChar,   objReqStatOrderList.OrderItemCodes,     4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",          DBType.adVarWChar,  objReqStatOrderList.ClientName,         50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName",           DBType.adVarWChar,  objReqStatOrderList.AgentName,          50,   ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqStatOrderList.AccessCenterCode,   512,  ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_ORDER_TOTAL_MONTHLY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResStatOrderList(null)
                {
                    data = new List<StatOrderGridModel>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<StatOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetStatOrderTotalMonthList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderTotalMonthList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 경영정보시스템 전체 - 일별
        /// </summary>
        /// <param name="objReqStatOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResStatOrderList> GetStatOrderTotalDailyList(ReqStatOrderList objReqStatOrderList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderTotalDailyList REQ] {JsonConvert.SerializeObject(objReqStatOrderList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResStatOrderList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResStatOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSearchYMD", DBType.adVarChar, objReqStatOrderList.SearchYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatOrderList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatOrderList.OrderItemCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName", DBType.adVarWChar, objReqStatOrderList.ClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar, objReqStatOrderList.AgentName, 50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatOrderList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_ORDER_TOTAL_DAILY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResStatOrderList(null)
                {
                    data = new List<StatOrderGridModel>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<StatOrderGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9102, "System error(GetStatOrderTotalDailyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderTotalDailyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 경영정보시스템 고객사 - 월별
        /// </summary>
        /// <param name="objReqStatOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResponseClientGrouping> GetStatOrderClientMonthlyList(ReqStatOrderList objReqStatOrderList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderClientMonthlyList REQ] {JsonConvert.SerializeObject(objReqStatOrderList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResponseClientGrouping> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResponseClientGrouping>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSearchYMD", DBType.adVarChar,        objReqStatOrderList.SearchYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,       objReqStatOrderList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode", DBType.adBigInt,        objReqStatOrderList.ClientCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatOrderList.OrderItemCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName", DBType.adVarWChar,      objReqStatOrderList.ClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar,       objReqStatOrderList.AgentName, 50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatOrderList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_ORDER_CLIENT_MONTHLY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResponseClientGrouping
                {
                    data = new List<ResultDataClientGrouping>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<ResultDataClientGrouping>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9103, "System error(GetStatOrderClientMonthlyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderClientMonthlyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 경영정보시스템 고객사 - 일별
        /// </summary>
        /// <param name="objReqStatOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResponseClientGrouping> GetStatOrderClientDailyList(ReqStatOrderList objReqStatOrderList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderClientDailyList REQ] {JsonConvert.SerializeObject(objReqStatOrderList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResponseClientGrouping> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResponseClientGrouping>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSearchYMD",      DBType.adVarChar,   objReqStatOrderList.SearchYMD,      8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objReqStatOrderList.CenterCode,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatOrderList.OrderItemCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",     DBType.adVarWChar,  objReqStatOrderList.ClientName,     50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName",      DBType.adVarWChar,  objReqStatOrderList.AgentName,      50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatOrderList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_ORDER_CLIENT_DAILY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResponseClientGrouping
                {
                    data = new List<ResultDataClientGrouping>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<ResultDataClientGrouping>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9103, "System error(GetStatOrderClientDailyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderClientDailyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 경영정보시스템 담당자 - 월별
        /// </summary>
        /// <param name="objReqStatOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResponseAgentGrouping> GetStatOrderAgentMonthlyList(ReqStatOrderList objReqStatOrderList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderAgentMonthlyList REQ] {JsonConvert.SerializeObject(objReqStatOrderList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResponseAgentGrouping> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResponseAgentGrouping>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSearchYMD",        DBType.adVarChar,  objReqStatOrderList.SearchYMD,        8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,  objReqStatOrderList.CenterCode,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",   DBType.adVarChar,  objReqStatOrderList.OrderItemCodes,   4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentCode",        DBType.adVarChar,  objReqStatOrderList.AgentCode,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName",        DBType.adVarWChar, objReqStatOrderList.AgentName,        50,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,  objReqStatOrderList.AccessCenterCode, 512,  ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_ORDER_AGENT_MONTHLY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResponseAgentGrouping
                {
                    data = new List<ResultDataAgentGrouping>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<ResultDataAgentGrouping>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9106, "System error(GetStatOrderAgentMonthlyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderAgentMonthlyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 경영정보시스템 담당자 - 일별
        /// </summary>
        /// <param name="objReqStatOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResponseAgentGrouping> GetStatOrderAgentDailyList(ReqStatOrderList objReqStatOrderList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderAgentDailyList REQ] {JsonConvert.SerializeObject(objReqStatOrderList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResponseAgentGrouping> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResponseAgentGrouping>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSearchYMD", DBType.adVarChar, objReqStatOrderList.SearchYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatOrderList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatOrderList.OrderItemCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentCode", DBType.adVarChar, objReqStatOrderList.AgentCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar, objReqStatOrderList.AgentName, 50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatOrderList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_ORDER_AGENT_DAILY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResponseAgentGrouping
                {
                    data = new List<ResultDataAgentGrouping>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<ResultDataAgentGrouping>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9107, "System error(GetStatOrderAgentDailyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatOrderAgentDailyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 경영정보시스템 월 목록 + 워킹데이 수
        /// </summary>
        /// <param name="objReqMonthList"></param>
        /// <returns></returns>
        public ServiceResult<ResMonthList> GetMonthList(ReqMonthList objReqMonthList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetMonthList REQ] {JsonConvert.SerializeObject(objReqMonthList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResMonthList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResMonthList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strDateFrom",   DBType.adVarChar, objReqMonthList.DateFrom,    6, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",     DBType.adVarChar, objReqMonthList.DateTo,      6, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_UTIL_MONTH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResMonthList
                {
                    list = new List<MonthModel>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<MonthModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9108, "System error(GetMonthList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetMonthList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 경영정보시스템 월 목록 + 워킹데이 수
        /// </summary>
        /// <param name="objReqMonthList"></param>
        /// <returns></returns>
        public ServiceResult<ResMonthList> GetDailyList(ReqMonthList objReqMonthList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetDailyList REQ] {JsonConvert.SerializeObject(objReqMonthList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResMonthList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResMonthList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strDateFrom", DBType.adVarChar, objReqMonthList.DateFrom, 6, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo", DBType.adVarChar, objReqMonthList.DateTo, 6, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_UTIL_DAY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResMonthList
                {
                    list = new List<MonthModel>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<MonthModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9108, "System error(GetDailyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetDailyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 자동운임현황 - 전체
        /// </summary>
        /// <param name="objReqMonthList"></param>
        /// <returns></returns>
        public ServiceResult<ResAutometicList> GetAutomaticSummaryList(ReqAutometicList objReqAutometicList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetAutomaticSummaryList REQ] {JsonConvert.SerializeObject(objReqAutometicList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResAutometicList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResAutometicList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSearchType",         DBType.adTinyInt,   objReqAutometicList.SearchType,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchYMD",          DBType.adVarChar,   objReqAutometicList.SearchYMD,        8,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqAutometicList.CenterCode,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",     DBType.adVarChar,   objReqAutometicList.OrderItemCodes,   4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,  objReqAutometicList.ClientName,       50,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAgentName",          DBType.adVarWChar,  objReqAutometicList.AgentName,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",      DBType.adVarWChar,  objReqAutometicList.ConsignorName,    50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqAutometicList.AccessCenterCode, 512,  ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_CLIENT_TRANS_RATE_SUMMARY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAutometicList
                {
                    list = new List<AutometicList>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AutometicList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9108, "System error(GetAutomaticSummaryList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetAutomaticSummaryList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 자동운임현황 - 전체
        /// </summary>
        /// <param name="objReqMonthList"></param>
        /// <returns></returns>
        public ServiceResult<ResAutometicList> GetAutomaticBarList(ReqAutometicList objReqAutometicList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetAutomaticBarList REQ] {JsonConvert.SerializeObject(objReqAutometicList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResAutometicList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResAutometicList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSearchType",         DBType.adTinyInt,   objReqAutometicList.SearchType,         0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchYMD",          DBType.adVarChar,   objReqAutometicList.SearchYMD,          8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqAutometicList.CenterCode,         0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",     DBType.adVarChar,   objReqAutometicList.OrderItemCodes,     4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,  objReqAutometicList.ClientName,         50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAgentName",          DBType.adVarWChar,  objReqAutometicList.AgentName,          50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",      DBType.adVarWChar,  objReqAutometicList.ConsignorName,      50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqAutometicList.AccessCenterCode,   512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_CLIENT_TRANS_RATE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAutometicList
                {
                    Barlist = new List<AutometicBarList>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.Barlist = JsonConvert.DeserializeObject<List<AutometicBarList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9110, "System error(GetAutomaticBarList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetAutomaticBarList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 자동운임 적용현황
        /// </summary>
        /// <param name="objReqMonthList"></param>
        /// <returns></returns>
        public ServiceResult<ResAutometicList> GetAutomaticDetailList(ReqAutometicList objReqAutometicList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetAutomaticDetailList REQ] {JsonConvert.SerializeObject(objReqAutometicList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResAutometicList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResAutometicList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intGroupType",          DBType.adTinyInt,   objReqAutometicList.GroupType,      0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqAutometicList.CenterCode,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",           DBType.adVarChar,   objReqAutometicList.DataFrom,       8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",             DBType.adVarChar,   objReqAutometicList.DataTo,         8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes",     DBType.adVarChar,   objReqAutometicList.OrderItemCodes, 4000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,  objReqAutometicList.ClientName,         50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName",          DBType.adVarWChar,  objReqAutometicList.AgentName,          50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",      DBType.adVarWChar,  objReqAutometicList.ConsignorName,      50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqAutometicList.AccessCenterCode,   512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_CLIENT_TRANS_RATE_DETAIL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAutometicList
                {
                    Detaillist = new List<AutometicDetaillistList>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.Detaillist = JsonConvert.DeserializeObject<List<AutometicDetaillistList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9110, "System error(GetAutomaticDetailList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetAutomaticDetailList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        /// <summary>
        /// 자동운임 수정현황
        /// </summary>
        /// <param name="objReqMonthList"></param>
        /// <returns></returns>
        public ServiceResult<ResAutometicList> GetAutomaticModList(ReqAutometicList objReqAutometicList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetAutomaticModList REQ] {JsonConvert.SerializeObject(objReqAutometicList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResAutometicList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResAutometicList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intGroupType", DBType.adTinyInt, objReqAutometicList.GroupType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqAutometicList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom", DBType.adVarChar, objReqAutometicList.DataFrom, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo", DBType.adVarChar, objReqAutometicList.DataTo, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqAutometicList.OrderItemCodes, 4000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientName", DBType.adVarWChar, objReqAutometicList.ClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar, objReqAutometicList.AgentName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName", DBType.adVarWChar, objReqAutometicList.ConsignorName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqAutometicList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_CLIENT_TRANS_RATE_MODIFY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAutometicList
                {
                    Modlist = new List<AutometicModList>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.Modlist = JsonConvert.DeserializeObject<List<AutometicModList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9110, "System error(GetAutomaticModList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetAutomaticModList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 차량구분별 담당자 실적
        /// </summary>
        /// <param name="objReqStatCarDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResStatCarDispatchList> GetStatCarDispatchAgentList(ReqStatCarDispatchList objReqStatCarDispatchList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatCarDispatchAgentList REQ] {JsonConvert.SerializeObject(objReqStatCarDispatchList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResStatCarDispatchList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResStatCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatCarDispatchList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatCarDispatchList.OrderItemCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom", DBType.adVarChar, objReqStatCarDispatchList.DateFrom, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo", DBType.adVarChar, objReqStatCarDispatchList.DateTo, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentCode", DBType.adVarChar, objReqStatCarDispatchList.AgentCode, 50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar, objReqStatCarDispatchList.AgentName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatCarDispatchList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.SetQuery("dbo.UP_STAT_CAR_DISPATCH_AGENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResStatCarDispatchList()
                {
                    list = new List<ResultStatCarDispatcList>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ResultStatCarDispatcList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9111, "System error(GetStatCarDispatchAgentList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatCarDispatchAgentList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 차량구분별 고객사 전담율
        /// </summary>
        /// <param name="objReqStatCarDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResStatCarDispatchList> GetStatCarDispatchClientList(ReqStatCarDispatchList objReqStatCarDispatchList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatCarDispatchClientList REQ] {JsonConvert.SerializeObject(objReqStatCarDispatchList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResStatCarDispatchList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResStatCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatCarDispatchList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatCarDispatchList.OrderItemCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom", DBType.adVarChar, objReqStatCarDispatchList.DateFrom, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo", DBType.adVarChar, objReqStatCarDispatchList.DateTo, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName", DBType.adVarWChar, objReqStatCarDispatchList.ClientName, 50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strConsignorName", DBType.adVarWChar, objReqStatCarDispatchList.ConsignorName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatCarDispatchList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.SetQuery("dbo.UP_STAT_CAR_DISPATCH_CLIENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResStatCarDispatchList()
                {
                    list = new List<ResultStatCarDispatcList>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ResultStatCarDispatcList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9111, "System error(GetStatCarDispatchClientList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatCarDispatchClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 전담차량 보유현황 - 전체 조회(월별)
        /// </summary>
        /// <param name="objReqStatCarDivTypeListList"></param>
        /// <returns></returns>
        public ServiceResult<ResStatCarDivTypeList> GetStatCarDivTypeList(ReqStatCarDivTypeList objReqStatCarDivTypeListList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatCarDivTypeList REQ] {JsonConvert.SerializeObject(objReqStatCarDivTypeListList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResStatCarDivTypeList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResStatCarDivTypeList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSearchYM", DBType.adVarChar, objReqStatCarDivTypeListList.SearchYM, 6, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatCarDivTypeListList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatCarDivTypeListList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intCarDivType1Cnt", DBType.adDouble, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarDivType4Cnt", DBType.adDouble, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intCarDivType6Cnt", DBType.adDouble, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.SetQuery("dbo.UP_STAT_CAR_DIV_TYPE_MONTHLY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResStatCarDivTypeList()
                {
                    list = new List<ResultStatCarDivTypeList>(),
                    CarDivType1Cnt = lo_objDas.GetParam("@po_intCarDivType1Cnt").ToDouble(),
                    CarDivType4Cnt = lo_objDas.GetParam("@po_intCarDivType4Cnt").ToDouble(),
                    CarDivType6Cnt = lo_objDas.GetParam("@po_intCarDivType6Cnt").ToDouble()
            };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ResultStatCarDivTypeList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9112, "System error(GetStatCarDivTypeList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatCarDispatchClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 전다차량 12개월 전 목록 + 워킹데이 수
        /// </summary>
        /// <param name="objReqMonthList"></param>
        /// <returns></returns>
        public ServiceResult<ResMonthList> GetMonthPrevList(ReqMonthList objReqMonthList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetMonthPrevList REQ] {JsonConvert.SerializeObject(objReqMonthList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResMonthList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResMonthList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSearchYM", DBType.adVarChar, objReqMonthList.DateFrom, 6, ParameterDirection.Input);
                lo_objDas.SetQuery("dbo.UP_UTIL_MONTH_PREV_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResMonthList
                {
                    list = new List<MonthModel>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<MonthModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9113, "System error(GetMonthPrevList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetMonthPrevList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 전담차량 사용실정
        /// </summary>
        /// <param name="objReqStatCarDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResStatCarDispatchList> GetStatCarDispatchList(ReqStatCarDispatchList objReqStatCarDispatchList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatCarDispatchList REQ] {JsonConvert.SerializeObject(objReqStatCarDispatchList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResStatCarDispatchList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResStatCarDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatCarDispatchList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatCarDispatchList.OrderItemCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSearchYM", DBType.adVarChar, objReqStatCarDispatchList.SearchYM, 6, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatCarDispatchList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intCarDivTypeCnt", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intCarDivType3Cnt", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarDivType5Cnt", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarDivTypeSale", DBType.adDouble, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarDivType3Sale", DBType.adDouble, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarDivType5Sale", DBType.adDouble, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intCarDivTypePurchase", DBType.adDouble, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarDivType3Purchase", DBType.adDouble, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarDivType5Purchase", DBType.adDouble, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.SetQuery("dbo.UP_STAT_CAR_DISPATCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResStatCarDispatchList()
                {
                    list                = new List<ResultStatCarDispatcList>(),
                    CarDivTypeCnt       = lo_objDas.GetParam("@po_intCarDivTypeCnt").ToInt(),
                    CarDivType3Cnt      = lo_objDas.GetParam("@po_intCarDivType3Cnt").ToInt(),
                    CarDivType5Cnt      = lo_objDas.GetParam("@po_intCarDivType5Cnt").ToInt(),
                    CarDivTypeSale      = lo_objDas.GetParam("@po_intCarDivTypeSale").ToDouble(),
                    CarDivType3Sale     = lo_objDas.GetParam("@po_intCarDivType3Sale").ToDouble(),
                    CarDivType5Sale     = lo_objDas.GetParam("@po_intCarDivType5Sale").ToDouble(),
                    CarDivTypePurchase  = lo_objDas.GetParam("@po_intCarDivTypePurchase").ToDouble(),
                    CarDivType3Purchase = lo_objDas.GetParam("@po_intCarDivType3Purchase").ToDouble(),
                    CarDivType5Purchase = lo_objDas.GetParam("@po_intCarDivType5Purchase").ToDouble()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ResultStatCarDispatcList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9114, "System error(GetStatCarDispatchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatCarDispatchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 전다차량 12개월 전 목록 + 워킹데이 수
        /// </summary>
        /// <param name="objReqMonthList"></param>
        /// <returns></returns>
        public ServiceResult<ResStatTransRateSummaryList> GetTransRateSummaryList(ReqStatTransRateSummaryList objReqStatTransRateSummaryList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetTransRateSummaryList REQ] {JsonConvert.SerializeObject(objReqStatTransRateSummaryList)}", bLogWrite);

            string                                     lo_strJson   = string.Empty;
            ServiceResult<ResStatTransRateSummaryList> lo_objResult = null;
            IDasNetCom                                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResStatTransRateSummaryList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strFromYMD", DBType.adVarChar, objReqStatTransRateSummaryList.FromYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD", DBType.adVarChar, objReqStatTransRateSummaryList.ToYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPreMonFromYMD", DBType.adVarChar, objReqStatTransRateSummaryList.PreMonFromYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPreMonToYMD", DBType.adVarChar, objReqStatTransRateSummaryList.PreMonToYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatTransRateSummaryList.CenterCode, 0, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatTransRateSummaryList.OrderItemCodes, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName", DBType.adVarWChar, objReqStatTransRateSummaryList.ClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar, objReqStatTransRateSummaryList.AgentName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName", DBType.adVarWChar, objReqStatTransRateSummaryList.ConsignorName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatTransRateSummaryList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.AddParam("@po_strPreWeekFromYMD", DBType.adVarWChar, DBNull.Value, 8, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPreWeekToYMD", DBType.adVarWChar, DBNull.Value, 8, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_STAT_TRANS_RATE_SUMMARY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResStatTransRateSummaryList
                {
                    list = new List<ResultStatTransRateSummaryList>(),
                    PreWeekFromYMD = lo_objDas.GetParam("@po_strPreWeekFromYMD"),
                    PreWeekToYMD = lo_objDas.GetParam("@po_strPreWeekToYMD")
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ResultStatTransRateSummaryList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9115, "System error(GetTransRateSummaryList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetTransRateSummaryList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사별 현황
        /// </summary>
        /// <param name="objReqStatCarDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResponseClientGrouping> GetStatTransRateClientMonthlyList(ReqStatOrderList objReqStatCarDispatchList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatTransRateClientMonthlyList REQ] {JsonConvert.SerializeObject(objReqStatCarDispatchList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResponseClientGrouping> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResponseClientGrouping>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intListType", DBType.adTinyInt, objReqStatCarDispatchList.ListType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD", DBType.adVarChar, objReqStatCarDispatchList.DateFrom, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD", DBType.adVarChar, objReqStatCarDispatchList.DateTo, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatCarDispatchList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatCarDispatchList.OrderItemCodes, 4000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientCode", DBType.adBigInt, objReqStatCarDispatchList.ClientCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName", DBType.adVarWChar, objReqStatCarDispatchList.ClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar, objReqStatCarDispatchList.AgentName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatCarDispatchList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_TRANS_RATE_CLIENT_MONTHLY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResponseClientGrouping
                {
                    data = new List<ResultDataClientGrouping>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<ResultDataClientGrouping>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9116, "System error(GetStatTransRateClientMonthlyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatTransRateClientMonthlyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사별 현황 일별
        /// </summary>
        /// <param name="objReqStatCarDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResponseClientGrouping> GetStatTransRateClientDailyList(ReqStatOrderList objReqStatCarDispatchList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatTransRateClientDailyList REQ] {JsonConvert.SerializeObject(objReqStatCarDispatchList)}", bLogWrite);

            string lo_strJson = string.Empty;
            ServiceResult<ResponseClientGrouping> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResponseClientGrouping>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intListType", DBType.adTinyInt, objReqStatCarDispatchList.ListType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD", DBType.adVarChar, objReqStatCarDispatchList.DateFrom, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD", DBType.adVarChar, objReqStatCarDispatchList.DateTo, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatCarDispatchList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatCarDispatchList.OrderItemCodes, 4000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientCode", DBType.adBigInt, objReqStatCarDispatchList.ClientCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName", DBType.adVarWChar, objReqStatCarDispatchList.ClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar, objReqStatCarDispatchList.AgentName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatCarDispatchList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_TRANS_RATE_CLIENT_DAILY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResponseClientGrouping
                {
                    data = new List<ResultDataClientGrouping>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<ResultDataClientGrouping>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9116, "System error(GetStatTransRateClientDailyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatTransRateClientDailyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 담당자별 현황 월조회
        /// </summary>
        /// <param name="objReqStatOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResponseClientGrouping> GetStatTransRateAgentMonthlyList(ReqStatOrderList objReqStatOrderList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatTransRateClientMonthlyList REQ] {JsonConvert.SerializeObject(objReqStatOrderList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResponseClientGrouping> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResponseClientGrouping>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intListType", DBType.adTinyInt, objReqStatOrderList.ListType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD", DBType.adVarChar, objReqStatOrderList.DateFrom, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD", DBType.adVarChar, objReqStatOrderList.DateTo, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatOrderList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatOrderList.OrderItemCodes, 4000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientName", DBType.adVarWChar, objReqStatOrderList.ClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentCode", DBType.adVarWChar, objReqStatOrderList.AgentCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar, objReqStatOrderList.AgentName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatOrderList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_TRANS_RATE_AGENCY_MONTHLY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResponseClientGrouping
                {
                    data = new List<ResultDataClientGrouping>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<ResultDataClientGrouping>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9117, "System error(GetStatTransRateAgentMonthlyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatTransRateAgentMonthlyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 담당자별 현황 월조회
        /// </summary>
        /// <param name="objReqStatOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResponseClientGrouping> GetStatTransRateAgentDaillyList(ReqStatOrderList objReqStatOrderList)
        {
            SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatTransRateAgentDaillyList REQ] {JsonConvert.SerializeObject(objReqStatOrderList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResponseClientGrouping> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResponseClientGrouping>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS_STAT);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intListType", DBType.adTinyInt, objReqStatOrderList.ListType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD", DBType.adVarChar, objReqStatOrderList.DateFrom, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD", DBType.adVarChar, objReqStatOrderList.DateTo, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqStatOrderList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCodes", DBType.adVarChar, objReqStatOrderList.OrderItemCodes, 4000, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientName", DBType.adVarWChar, objReqStatOrderList.ClientName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentCode", DBType.adVarWChar, objReqStatOrderList.AgentCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAgentName", DBType.adVarWChar, objReqStatOrderList.AgentName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqStatOrderList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_STAT_TRANS_RATE_AGENCY_DAILY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResponseClientGrouping
                {
                    data = new List<ResultDataClientGrouping>()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.data = JsonConvert.DeserializeObject<List<ResultDataClientGrouping>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9118, "System error(GetStatTransRateAgentDaillyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MisStatDasServices", "I", $"[GetStatTransRateAgentDaillyList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}