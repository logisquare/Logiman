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
    public class ServerDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        public ServiceResult<ResSecurityFieldList> GetSecurityFieldList(ReqSecurityFieldList objReqSecurityFieldList)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetSecurityFieldList REQ] {JsonConvert.SerializeObject(objReqSecurityFieldList)}", bLogWrite);
            
            string lo_strJson = string.Empty;

            ServiceResult<ResSecurityFieldList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResSecurityFieldList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strFieldName",  DBType.adVarChar, objReqSecurityFieldList.FieldName,  20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",   DBType.adInteger, objReqSecurityFieldList.PageSize,   0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",     DBType.adInteger, objReqSecurityFieldList.PageNo,     0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger, DBNull.Value,                       0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SECURITY_FIELD_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResSecurityFieldList
                {
                    list = new List<SecurityFieldViewModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SecurityFieldViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetSecurityFieldList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetSecurityFieldList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> InsSecurityField(SecurityFieldViewModel objInsSecurityField)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[InsSecurityField REQ] {JsonConvert.SerializeObject(objInsSecurityField)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strFieldName",   DBType.adVarChar,  objInsSecurityField.FieldName,   20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMarkCharCnt", DBType.adTinyInt,  objInsSecurityField.MarkCharCnt, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFieldDesc",   DBType.adVarWChar, objInsSecurityField.FieldDesc,   256, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",     DBType.adChar,     objInsSecurityField.UseFlag,     1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",     DBType.adVarChar,  objInsSecurityField.AdminID,     50,  ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,  DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,  DBNull.Value, 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,  DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,  DBNull.Value, 0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SECURITY_FIELD_TX_INS");

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
                                     , 9101, "System error(fail to insert security field)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[InsSecurityField RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> UpdSecurityField(SecurityFieldViewModel objUpdSecurityField)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[UpdSecurityField REQ] {JsonConvert.SerializeObject(objUpdSecurityField)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strFieldName",   DBType.adVarChar,  objUpdSecurityField.FieldName,   20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMarkCharCnt", DBType.adTinyInt,  objUpdSecurityField.MarkCharCnt, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFieldDesc",   DBType.adVarWChar, objUpdSecurityField.FieldDesc,   256, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",     DBType.adChar,     objUpdSecurityField.UseFlag,     1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",     DBType.adVarChar,  objUpdSecurityField.AdminID,     50,  ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,  DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,  DBNull.Value, 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,  DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,  DBNull.Value, 0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SECURITY_FIELD_TX_UPD");

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
                                     , 9101, "System error(fail to update security field)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[UpdSecurityField RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResServerAllowipList> GetServerAllowipList(ReqServerAllowipList objReqServerAllowipList)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetServerAllowipList REQ] {JsonConvert.SerializeObject(objReqServerAllowipList)}", bLogWrite);
            
            string lo_strJson = string.Empty;

            ServiceResult<ResServerAllowipList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResServerAllowipList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strServerType",  DBType.adVarChar, objReqServerAllowipList.ServerType,  20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",  DBType.adInteger, objReqServerAllowipList.CenterCode,  0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAllowIPAddr", DBType.adVarChar, objReqServerAllowipList.AllowIPAddr, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",     DBType.adChar,    objReqServerAllowipList.UseFlag,     1,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",    DBType.adInteger, objReqServerAllowipList.PageSize,    0,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",      DBType.adInteger, objReqServerAllowipList.PageNo,      0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",   DBType.adInteger, DBNull.Value,                        0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SERVER_ALLOWIP_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResServerAllowipList
                {
                    list = new List<ServerAllowipViewModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ServerAllowipViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetServerAllowipList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetServerAllowipList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> InsServerAllowip(ServerAllowipViewModel objInsServerAllowip)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[InsServerAllowip REQ] {JsonConvert.SerializeObject(objInsServerAllowip)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strServerType",  DBType.adVarChar,  objInsServerAllowip.ServerType,  20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",  DBType.adInteger,  objInsServerAllowip.CenterCode,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAllowIPAddr", DBType.adVarChar,  objInsServerAllowip.AllowIPAddr, 50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAllowIPDesc", DBType.adVarWChar, objInsServerAllowip.AllowIPDesc, 50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",     DBType.adChar,     objInsServerAllowip.UseFlag,     1,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminID",     DBType.adVarChar,  objInsServerAllowip.AdminID,     50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,  DBNull.Value,                    256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,  DBNull.Value,                    256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SERVER_ALLOWIP_TX_INS");

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
                                     , 9101, "System error(fail to insert server's allowed ip)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[InsServerAllowip RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> UpdServerAllowip(ServerAllowipViewModel objUpdServerAllowip)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[UpdServerAllowip REQ] {JsonConvert.SerializeObject(objUpdServerAllowip)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strServerType",  DBType.adVarChar,  objUpdServerAllowip.ServerType,  20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",  DBType.adInteger,  objUpdServerAllowip.CenterCode,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAllowIPAddr", DBType.adVarChar,  objUpdServerAllowip.AllowIPAddr, 50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAllowIPDesc", DBType.adVarWChar, objUpdServerAllowip.AllowIPDesc, 50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",     DBType.adChar,     objUpdServerAllowip.UseFlag,     1,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminID",     DBType.adVarChar,  objUpdServerAllowip.AdminID,     50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,  DBNull.Value,                    256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,  DBNull.Value,                    256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SERVER_ALLOWIP_TX_UPD");

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
                                     , 9101, "System error(fail to update server's allowed ip)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[UpdServerAllowip RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> DelServerAllowip(ServerAllowipViewModel objDelServerAllowip)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[DelServerAllowip REQ] {JsonConvert.SerializeObject(objDelServerAllowip)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strServerType",  DBType.adVarChar,  objDelServerAllowip.ServerType,  20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",  DBType.adInteger,  objDelServerAllowip.CenterCode,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAllowIPAddr", DBType.adVarChar,  objDelServerAllowip.AllowIPAddr, 50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,  DBNull.Value,                    256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,  DBNull.Value,                    256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,  DBNull.Value,                    0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SERVER_ALLOWIP_TX_DEL");

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
                                     , 9101, "System error(fail to delete server's allowed ip)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[DelServerAllowip RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResServerList> GetServerList(ReqServerList objReqServerList)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetServerList REQ] {JsonConvert.SerializeObject(objReqServerList)}", bLogWrite);
            
            string lo_strJson = string.Empty;

            ServiceResult<ResServerList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResServerList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strServerType", DBType.adVarChar, objReqServerList.ServerType, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",   DBType.adInteger, objReqServerList.PageSize,   0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",     DBType.adInteger, objReqServerList.PageNo,     0,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger, DBNull.Value,                0,  ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SERVER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResServerList
                {
                    list = new List<ServerViewModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ServerViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetServerList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetServerList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResServerConfigList> GetServerConfigList(ReqServerConfigList objReqServerConfigList)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetServerConfigList REQ] {JsonConvert.SerializeObject(objReqServerConfigList)}", bLogWrite);
            
            string lo_strJson = string.Empty;

            ServiceResult<ResServerConfigList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResServerConfigList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strServerType", DBType.adVarChar,  objReqServerConfigList.ServerType, 20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strKeyName",    DBType.adVarChar,  objReqServerConfigList.KeyName,    100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strKeyVal",     DBType.adVarWChar, objReqServerConfigList.KeyVal,     4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",   DBType.adInteger,  objReqServerConfigList.PageSize,   0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",     DBType.adInteger,  objReqServerConfigList.PageNo,     0,    ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger,  DBNull.Value,                      0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SERVER_CONFIG_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResServerConfigList
                {
                    list = new List<ServerConfigViewModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ServerConfigViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetServerConfigList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetServerConfigList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> InsServerConfig(ServerConfigViewModel objInsServerConfig)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[InsServerConfig REQ] {JsonConvert.SerializeObject(objInsServerConfig)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strServerType", DBType.adVarChar,  objInsServerConfig.ServerType, 20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strKeyName",    DBType.adVarChar,  objInsServerConfig.KeyName,    100,  ParameterDirection.Input);            
                lo_objDas.AddParam("@pi_strKeyVal",     DBType.adVarWChar, objInsServerConfig.KeyVal,     4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarChar,  objInsServerConfig.AdminID,    50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,  DBNull.Value,                  256,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,  DBNull.Value,                  0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,  DBNull.Value,                  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,  DBNull.Value,                  0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SERVER_CONFIG_TX_INS");

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
                                     , 9101, "System error(InsServerConfig)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[InsServerConfig RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> UpdServerConfig(ServerConfigViewModel objUpdServerConfig)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[UpdServerConfig REQ] {JsonConvert.SerializeObject(objUpdServerConfig)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strServerType", DBType.adVarChar,  objUpdServerConfig.ServerType, 20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strKeyName",    DBType.adVarChar,  objUpdServerConfig.KeyName,    100,  ParameterDirection.Input);            
                lo_objDas.AddParam("@pi_strKeyVal",     DBType.adVarWChar, objUpdServerConfig.KeyVal,     4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarChar,  objUpdServerConfig.AdminID,    50,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,  DBNull.Value,                  256,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,  DBNull.Value,                  0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,  DBNull.Value,                  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,  DBNull.Value,                  0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SERVER_CONFIG_TX_UPD");

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
                                     , 9101, "System error(UpdServerConfig)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[UpdServerConfig RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> DelServerConfig(ServerConfigViewModel objDelServerConfig)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[DelServerConfig REQ] {JsonConvert.SerializeObject(objDelServerConfig)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strServerType", DBType.adVarChar, objDelServerConfig.ServerType, 20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strKeyName",    DBType.adVarChar, objDelServerConfig.KeyName,    100, ParameterDirection.Input);            
                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarChar, objDelServerConfig.AdminID,    50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar, DBNull.Value,                  256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger, DBNull.Value,                  0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar, DBNull.Value,                  256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger, DBNull.Value,                  0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SERVER_CONFIG_TX_DEL");

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
                                     , 9101, "System error(DelServerConfig)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[DelServerConfig RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<ResCodeList> GetCodeList(ReqCodeList objReqCodeList)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetCodeList REQ] {JsonConvert.SerializeObject(objReqCodeList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResCodeList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResCodeList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strCodeName", DBType.adVarChar, objReqCodeList.CodeName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCodeVal", DBType.adVarWChar, objReqCodeList.CodeVal, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCodeDesc", DBType.adVarWChar, objReqCodeList.CodeDesc, 256, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize", DBType.adInteger, objReqCodeList.PageSize, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo", DBType.adInteger, objReqCodeList.PageNo, 0, ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CODE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCodeList
                {
                    list = new List<CodeViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CodeViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCodeList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[GetCodeList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> InsCode(CodeViewModel objInsCode)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[InsCode REQ] {JsonConvert.SerializeObject(objInsCode)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strCodeName", DBType.adVarChar, objInsCode.CodeName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCodeVal", DBType.adVarWChar, objInsCode.CodeVal, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCodeDesc", DBType.adVarWChar, objInsCode.CodeDesc, 256, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID", DBType.adVarChar, objInsCode.RegAdminID, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CODE_TX_INS");

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
                                     , 9101, "System error(fail to insert code)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[InsCode RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<bool> UpdCode(CodeViewModel objUpdCode)
        {
            SiteGlobal.WriteInformation("ServerDasServices", "I", $"[UpdCode REQ] {JsonConvert.SerializeObject(objUpdCode)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strCodeName", DBType.adVarChar, objUpdCode.CodeName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCodeVal", DBType.adVarWChar, objUpdCode.CodeVal, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCodeDesc", DBType.adVarWChar, objUpdCode.CodeDesc, 256, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID", DBType.adVarChar, objUpdCode.UpdAdminID, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CODE_TX_UPD");

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
                                     , 9101, "System error(fail to update code)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ServerDasServices", "I", $"[UpdCode RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

    }
}