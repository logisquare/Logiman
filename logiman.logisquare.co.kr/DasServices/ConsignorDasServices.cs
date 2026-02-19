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
    public class ConsignorDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 화주 목록
        /// </summary>
        /// <param name="objReqConsignorList"></param>
        /// <returns></returns>
        public ServiceResult<ResConsignorList> GetConsignorList(ReqConsignorList objReqConsignorList)
        {
            SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[GetConsignorList REQ] {JsonConvert.SerializeObject(objReqConsignorList)}", bLogWrite);
            
            string                          lo_strJson   = string.Empty;
            ServiceResult<ResConsignorList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResConsignorList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intConsignorCode",    DBType.adBigInt,   objReqConsignorList.ConsignorCode,    0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,  objReqConsignorList.CenterCode,       0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",    DBType.adVarWChar, objReqConsignorList.ConsignorName,    50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,     objReqConsignorList.UseFlag,          1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,  objReqConsignorList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,  objReqConsignorList.PageSize,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,  objReqConsignorList.PageNo,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,  DBNull.Value,                         0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CONSIGNOR_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResConsignorList
                {
                    list      = new List<ConsignorModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ConsignorModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetConsignorList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[GetConsignorList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 화주 등록
        /// </summary>
        /// <param name="objConsignorModel"></param>
        /// <returns></returns>
        public ServiceResult<ConsignorModel> SetConsignorIns(ConsignorModel objConsignorModel)
        {
            SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorIns REQ] {JsonConvert.SerializeObject(objConsignorModel)}", bLogWrite);

            ServiceResult<ConsignorModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ConsignorModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objConsignorModel.CenterCode,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",          DBType.adVarWChar,  objConsignorModel.ConsignorName,        50,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorNote",          DBType.adVarWChar,  objConsignorModel.ConsignorNote,        1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objConsignorModel.RegAdminID,           50,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intConsignorCode",          DBType.adBigInt,    DBNull.Value,                           0,      ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                           256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                           0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                           256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                           0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CONSIGNOR_TX_INS");


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
                objConsignorModel.ConsignorCode = lo_objDas.GetParam("@po_intConsignorCode").ToInt();

                lo_objResult.data = objConsignorModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert admin login log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 화주 수정
        /// </summary>
        /// <param name="objConsignorModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetConsignorUpd(ConsignorModel objConsignorModel)
        {
            SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorUpd REQ] {JsonConvert.SerializeObject(objConsignorModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intConsignorCode",          DBType.adBigInt,    objConsignorModel.ConsignorCode,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objConsignorModel.CenterCode,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorNote",          DBType.adVarWChar,  objConsignorModel.ConsignorNote,        1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",                DBType.adChar,      objConsignorModel.UseFlag,              1,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   objConsignorModel.UpdAdminID,           50,     ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                           256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                           0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                           256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                           0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CONSIGNOR_TX_UPD");


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
                                     , 9101, "System error(fail to insert admin login log)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 화주 목록 검색(수출입, 컨테이너 오더)
        /// </summary>
        /// <param name="objReqConsignorSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResConsignorSearchList> GetConsignorSearchList(ReqConsignorSearchList objReqConsignorSearchList)
        {
            SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[GetConsignorSearchList REQ] {JsonConvert.SerializeObject(objReqConsignorSearchList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResConsignorSearchList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResConsignorSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,  objReqConsignorSearchList.CenterCode,       0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",       DBType.adBigInt,   objReqConsignorSearchList.ClientCode,       0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",    DBType.adVarWChar, objReqConsignorSearchList.ConsignorName,    50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,     objReqConsignorSearchList.UseFlag,          1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar,  objReqConsignorSearchList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCorpNo",     DBType.adVarChar,  objReqConsignorSearchList.AccessCorpNo,    512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,  objReqConsignorSearchList.PageSize,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,  objReqConsignorSearchList.PageNo,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,  DBNull.Value,                               0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CONSIGNOR_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResConsignorSearchList
                {
                    list      = new List<ConsignorSearchModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ConsignorSearchModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetConsignorSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[GetConsignorSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 화주 목록 검색(내수오더)
        /// </summary>
        /// <param name="objReqConsignorMapSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResConsignorMapSearchList> GetConsignorMapSearchList(ReqConsignorMapSearchList objReqConsignorMapSearchList)
        {
            SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[GetConsignorMapSearchList REQ] {JsonConvert.SerializeObject(objReqConsignorMapSearchList)}", bLogWrite);

            string                                   lo_strJson   = string.Empty;
            ServiceResult<ResConsignorMapSearchList> lo_objResult = null;
            IDasNetCom                               lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResConsignorMapSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqConsignorMapSearchList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",     DBType.adVarWChar,  objReqConsignorMapSearchList.ConsignorName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",           DBType.adChar,      objReqConsignorMapSearchList.UseFlag,            1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqConsignorMapSearchList.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objReqConsignorMapSearchList.PageSize,           0,       ParameterDirection.Input);
                                                                                                                                    
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objReqConsignorMapSearchList.PageNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);


                lo_objDas.SetQuery("dbo.UP_CONSIGNOR_MAP_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResConsignorMapSearchList
                {
                    list      = new List<ConsignorMapSearchModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ConsignorMapSearchModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetConsignorMapSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[GetConsignorMapSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// GM 화주 목록
        /// </summary>
        /// <param name="objReqConsignorGMList"></param>
        /// <returns></returns>
        public ServiceResult<ResConsignorGMList> GetConsignorGMList(ReqConsignorGMList objReqConsignorGMList)
        {
            SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[GetConsignorGMList REQ] {JsonConvert.SerializeObject(objReqConsignorGMList)}", bLogWrite);

            string                            lo_strJson   = string.Empty;
            ServiceResult<ResConsignorGMList> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResConsignorGMList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intGMSeqNo",            DBType.adBigInt,    objReqConsignorGMList.GMSeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqConsignorGMList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",      DBType.adVarWChar,  objReqConsignorGMList.ConsignorName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLocationAlias",      DBType.adVarWChar,  objReqConsignorGMList.LocationAlias,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipper",            DBType.adVarWChar,  objReqConsignorGMList.Shipper,            50,      ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@pi_strOrigin",             DBType.adVarWChar,  objReqConsignorGMList.Origin,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,      objReqConsignorGMList.DelFlag,            1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqConsignorGMList.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqConsignorGMList.PageSize,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqConsignorGMList.PageNo,             0,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CONSIGNOR_GM_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResConsignorGMList
                {
                    list      = new List<ConsignorGMGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ConsignorGMGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetConsignorGMList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[GetConsignorGMList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// GM 화주 등록
        /// </summary>
        /// <param name="objConsignorGMModel"></param>
        /// <returns></returns>
        public ServiceResult<ConsignorGMModel> SetConsignorGMIns(ConsignorGMModel objConsignorGMModel)
        {
            SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorGMIns REQ] {JsonConvert.SerializeObject(objConsignorGMModel)}", bLogWrite);

            ServiceResult<ConsignorGMModel> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ConsignorGMModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                  DBType.adInteger,   objConsignorGMModel.CenterCode,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",               DBType.adBigInt,    objConsignorGMModel.ConsignorCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLocationAlias",               DBType.adVarWChar,  objConsignorGMModel.LocationAlias,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipper",                     DBType.adVarWChar,  objConsignorGMModel.Shipper,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrigin",                      DBType.adVarWChar,  objConsignorGMModel.Origin,                      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlace",                 DBType.adVarWChar,  objConsignorGMModel.PickupPlace,                 200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlacePost",             DBType.adVarChar,   objConsignorGMModel.PickupPlacePost,             6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddr",             DBType.adVarWChar,  objConsignorGMModel.PickupPlaceAddr,             100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddrDtl",          DBType.adVarWChar,  objConsignorGMModel.PickupPlaceAddrDtl,          100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceFullAddr",         DBType.adVarWChar,  objConsignorGMModel.PickupPlaceFullAddr,         150,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelExtNo",   DBType.adVarChar,   objConsignorGMModel.PickupPlaceChargeTelExtNo,   20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelNo",      DBType.adVarChar,   objConsignorGMModel.PickupPlaceChargeTelNo,      20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeCell",       DBType.adVarChar,   objConsignorGMModel.PickupPlaceChargeCell,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeName",       DBType.adVarWChar,  objConsignorGMModel.PickupPlaceChargeName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargePosition",   DBType.adVarWChar,  objConsignorGMModel.PickupPlaceChargePosition,   50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceLocalCode",        DBType.adVarChar,   objConsignorGMModel.PickupPlaceLocalCode,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceLocalName",        DBType.adVarWChar,  objConsignorGMModel.PickupPlaceLocalName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",                  DBType.adVarChar,   objConsignorGMModel.RegAdminID,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",                DBType.adVarWChar,  objConsignorGMModel.RegAdminName,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intGMSeqNo",                     DBType.adBigInt,    DBNull.Value,                                    0,       ParameterDirection.Output);
                                                                                                                                              
                lo_objDas.AddParam("@po_strErrMsg",                      DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                      DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                    DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                    DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CONSIGNOR_GM_TX_INS");

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
                objConsignorGMModel.GMSeqNo = lo_objDas.GetParam("@po_intGMSeqNo").ToInt64();

                lo_objResult.data = objConsignorGMModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetConsignorGMIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorGMIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// GM 화주 수정
        /// </summary>
        /// <param name="objConsignorGMModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetConsignorGMUpd(ConsignorGMModel objConsignorGMModel)
        {
            SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorGMUpd REQ] {JsonConvert.SerializeObject(objConsignorGMModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intGMSeqNo",                    DBType.adBigInt,    objConsignorGMModel.GMSeqNo,                     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                 DBType.adInteger,   objConsignorGMModel.CenterCode,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLocationAlias",              DBType.adVarWChar,  objConsignorGMModel.LocationAlias,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strShipper",                    DBType.adVarWChar,  objConsignorGMModel.Shipper,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrigin",                     DBType.adVarWChar,  objConsignorGMModel.Origin,                      50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlace",                DBType.adVarWChar,  objConsignorGMModel.PickupPlace,                 200,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlacePost",            DBType.adVarChar,   objConsignorGMModel.PickupPlacePost,             6,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddr",            DBType.adVarWChar,  objConsignorGMModel.PickupPlaceAddr,             100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddrDtl",         DBType.adVarWChar,  objConsignorGMModel.PickupPlaceAddrDtl,          100,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceFullAddr",        DBType.adVarWChar,  objConsignorGMModel.PickupPlaceFullAddr,         150,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelExtNo",  DBType.adVarChar,   objConsignorGMModel.PickupPlaceChargeTelExtNo,   20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeTelNo",     DBType.adVarChar,   objConsignorGMModel.PickupPlaceChargeTelNo,      20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeCell",      DBType.adVarChar,   objConsignorGMModel.PickupPlaceChargeCell,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargeName",      DBType.adVarWChar,  objConsignorGMModel.PickupPlaceChargeName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceChargePosition",  DBType.adVarWChar,  objConsignorGMModel.PickupPlaceChargePosition,   50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPickupPlaceLocalCode",       DBType.adVarChar,   objConsignorGMModel.PickupPlaceLocalCode,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceLocalName",       DBType.adVarWChar,  objConsignorGMModel.PickupPlaceLocalName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",                 DBType.adVarChar,   objConsignorGMModel.UpdAdminID,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminName",               DBType.adVarWChar,  objConsignorGMModel.UpdAdminName,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                     DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                                                                                                                                             
                lo_objDas.AddParam("@po_intRetVal",                     DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                   DBType.adVarChar,   DBNull.Value,                                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                   DBType.adInteger,   DBNull.Value,                                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CONSIGNOR_GM_TX_UPD");

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
                                     , 9101, "System error(SetConsignorGMUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorGMUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// GM 화주 삭제
        /// </summary>
        /// <param name="objConsignorGMModel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetConsignorGMDel(ConsignorGMModel objConsignorGMModel)
        {
            SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorGMDel REQ] {JsonConvert.SerializeObject(objConsignorGMModel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objConsignorGMModel.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGMSeqNo",        DBType.adBigInt,    objConsignorGMModel.GMSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminID",     DBType.adVarChar,   objConsignorGMModel.DelAdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelAdminName",   DBType.adVarWChar,  objConsignorGMModel.DelAdminName,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                                                                                                                    
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CONSIGNOR_GM_TX_DEL");

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
                                     , 9101, "System error(SetConsignorGMDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ConsignorDasServices", "I", $"[SetConsignorGMDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}