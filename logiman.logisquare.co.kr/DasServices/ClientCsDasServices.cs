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
    public class ClientCsDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 차량조회 리스트
        /// </summary>
        public ServiceResult<ResClientCsList> GetClientCsList(ReqClientCsList objReqClientCsList)
        {
            SiteGlobal.WriteInformation("ClientCsDasServices", "I", $"[GetClientCsList REQ] {JsonConvert.SerializeObject(objReqClientCsList)}", bLogWrite);

            string                         lo_strJson   = string.Empty;
            ServiceResult<ResClientCsList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientCsList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCsSeqNo",            DBType.adBigInt,        objReqClientCsList.CsSeqNo,             0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,        objReqClientCsList.ClientCode,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,       objReqClientCsList.CenterCode,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",      DBType.adVarChar,       objReqClientCsList.OrderItemCode,       5,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",  DBType.adVarChar,       objReqClientCsList.OrderLocationCode,   5,    ParameterDirection.Input);
                                                                                                                                      
                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,      objReqClientCsList.ClientName,          50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCsAdminType",        DBType.adTinyInt,       objReqClientCsList.CsAdminType,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminID",          DBType.adVarChar,       objReqClientCsList.CsAdminID,           50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminName",        DBType.adVarWChar,      objReqClientCsList.CsAdminName,         50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,          objReqClientCsList.DelFlag,             1,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,       objReqClientCsList.PageSize,            0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,       objReqClientCsList.PageNo,              0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,       DBNull.Value,                           0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CS_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientCsList
                {
                    list      = new List<ClientCsListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientCsListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientCsList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientCsDasServices", "I", $"[GetClientCsList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        public ServiceResult<ClientCsViewModel> InsClientCs(ClientCsViewModel objInsClientCsViewModel)
        {
            SiteGlobal.WriteInformation("ClientCsDasServices", "I", $"[InsClientCs REQ] {JsonConvert.SerializeObject(objInsClientCsViewModel)}", bLogWrite);

            ServiceResult<ClientCsViewModel> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ClientCsViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",          DBType.adBigInt,    objInsClientCsViewModel.ClientCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objInsClientCsViewModel.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",       DBType.adVarChar,   objInsClientCsViewModel.OrderItemCode,         5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",   DBType.adVarChar,   objInsClientCsViewModel.OrderLocationCode,     5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCsAdminType",         DBType.adTinyInt,   objInsClientCsViewModel.CsAdminType,           0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCsAdminID",           DBType.adVarChar,   objInsClientCsViewModel.CsAdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminName",         DBType.adVarWChar,  objInsClientCsViewModel.CsAdminName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",          DBType.adVarChar,   objInsClientCsViewModel.AdminID,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intCsSeqNo",             DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,                                  256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,                                  256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CS_TX_INS");

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

                objInsClientCsViewModel.CsSeqNo = lo_objDas.GetParam("@po_intCsSeqNo").ToInt();
                lo_objResult.data               = objInsClientCsViewModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(InsClientCs) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientCsDasServices", "I", $"[InsClientCs RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ClientCsViewModel> DelClientCs(ClientCsViewModel objInsClientCsViewModel)
        {
            SiteGlobal.WriteInformation("ClientCsDasServices", "I", $"[DelClientCs REQ] {JsonConvert.SerializeObject(objInsClientCsViewModel)}", bLogWrite);

            ServiceResult<ClientCsViewModel> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ClientCsViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_strCsSeqNos1",      DBType.adVarChar,   objInsClientCsViewModel.CsSeqNos1,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsSeqNos2",      DBType.adVarChar,   objInsClientCsViewModel.CsSeqNos2,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsSeqNos3",      DBType.adVarChar,   objInsClientCsViewModel.CsSeqNos3,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsSeqNos4",      DBType.adVarChar,   objInsClientCsViewModel.CsSeqNos4,    4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsSeqNos5",      DBType.adVarChar,   objInsClientCsViewModel.CsSeqNos5,    4000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDelAdminID",     DBType.adVarChar,   objInsClientCsViewModel.AdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intResultCount",    DBType.adTinyInt,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                                                                                                                      
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CS_SELECTED_TX_DEL");

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
                                     , 9301, "System error(DelClientCs) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientCsDasServices", "I", $"[DelClientCs RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        
        /// <summary>
        /// 업무담당검색(자동완성)
        /// </summary>
        public ServiceResult<ResClientCsSearchList> GetClientCsSearchList(ReqClientCsSearchList objReqClientCsSearchList)
        {
            SiteGlobal.WriteInformation("ClientCsDasServices", "I", $"[GetClientCsSearchList REQ] {JsonConvert.SerializeObject(objReqClientCsSearchList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResClientCsSearchList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientCsSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,        objReqClientCsSearchList.ClientCode,          0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,       objReqClientCsSearchList.CenterCode,          0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",      DBType.adVarChar,       objReqClientCsSearchList.OrderItemCode,       5,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",  DBType.adVarChar,       objReqClientCsSearchList.OrderLocationCode,   5,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,      objReqClientCsSearchList.ClientName,          50, ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intCsAdminType",        DBType.adTinyInt,       objReqClientCsSearchList.CsAdminType,         0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminID",          DBType.adVarChar,       objReqClientCsSearchList.CsAdminID,           50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCsAdminName",        DBType.adVarWChar,      objReqClientCsSearchList.CsAdminName,         50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,          objReqClientCsSearchList.DelFlag,             1,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,       objReqClientCsSearchList.AccessCenterCode,    50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,       objReqClientCsSearchList.PageSize,            0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,       objReqClientCsSearchList.PageNo,              0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,       DBNull.Value,                                 0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CS_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientCsSearchList
                {
                    list      = new List<ClientCsSearchListModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientCsSearchListModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientCsSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientCsDasServices", "I", $"[GetClientCsSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResAdminList> GetClientCsAdminList(ReqAdminList objReqAdminList)
        {
            SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetClientCsAdminList REQ] {JsonConvert.SerializeObject(objReqAdminList)}", bLogWrite);

            string                      lo_strJson   = string.Empty;
            ServiceResult<ResAdminList> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAdminList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",            DBType.adVarChar,   objReqAdminList.AdminID,          50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMobileNo",           DBType.adVarChar,   objReqAdminList.MobileNo,         20,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",          DBType.adVarWChar,  objReqAdminList.AdminName,        50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",            DBType.adChar,      objReqAdminList.UseFlag,          1,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessGradeCode",    DBType.adVarChar,   objReqAdminList.AccessGradeCode,  512,   ParameterDirection.Input);
                                                                                                                             
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqAdminList.AccessCenterCode, 512,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqAdminList.PageSize,         0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqAdminList.PageNo,           0,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                     0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_CS_ADMIN_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAdminList
                {
                    list      = new List<AdminViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AdminViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientCsAdminList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("AdminDasServices", "I", $"[GetClientCsAdminList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}