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
    public class ClientTransRateDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 요율표 그룹 리스트
        /// </summary>
        public ServiceResult<ResClientTransRateList> GetClientTransRateGroupList(ReqClientTransRateList objClientTransRateList)
        {
            SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetClientTransRateGroupList REQ] {JsonConvert.SerializeObject(objClientTransRateList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResClientTransRateList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientTransRateList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,      objClientTransRateList.ClientName,          50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,       objClientTransRateList.CenterCode,          0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strConsignorName",      DBType.adVarWChar,      objClientTransRateList.ConsignorName,       50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",           DBType.adTinyInt,       objClientTransRateList.RateType,            0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD",            DBType.adVarChar,       objClientTransRateList.FromYMD,             8, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,          objClientTransRateList.DelFlag,             1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,       objClientTransRateList.AccessCenterCode,    512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,       objClientTransRateList.PageSize,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,       objClientTransRateList.PageNo,              0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,       DBNull.Value,                               0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_TRANS_RATE_GROUP_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientTransRateList
                {
                    list = new List<ClientTransRateListViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientTransRateListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientTransRateGroupList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetClientTransRateGroupList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 그룹 리스트
        /// </summary>
        public ServiceResult<ResClientTransRateList> GetClientTransRateList(ReqClientTransRateList objClientTransRateList)
        {
            SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetClientTransRateList REQ] {JsonConvert.SerializeObject(objClientTransRateList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResClientTransRateList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientTransRateList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,    objClientTransRateList.ClientCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objClientTransRateList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",      DBType.adBigInt,    objClientTransRateList.ConsignorCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",           DBType.adTinyInt,   objClientTransRateList.RateType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromFullAddr",       DBType.adVarWChar,  objClientTransRateList.FromFullAddr, 150, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strToFullAddr",         DBType.adVarWChar,  objClientTransRateList.ToFullAddr, 150, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",         DBType.adVarChar,   objClientTransRateList.CarTonCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",        DBType.adVarChar,   objClientTransRateList.CarTypeCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strApplyYMD",           DBType.adVarChar,   objClientTransRateList.FromYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,      objClientTransRateList.DelFlag, 1, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar, objClientTransRateList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger, objClientTransRateList.PageSize, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger, objClientTransRateList.PageNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_TRANS_RATE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientTransRateList
                {
                    list = new List<ClientTransRateListViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientTransRateListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9102, "System error(GetClientTransRateList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetClientTransRateList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        //요율표 등록
        public ServiceResult<bool> InsTransRateItem(ClientTransRateModel objTransRateItemIns)
        {
            SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[TransRateItemIns REQ] {JsonConvert.SerializeObject(objTransRateItemIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,    objTransRateItemIns.ClientCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objTransRateItemIns.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",      DBType.adBigInt,    objTransRateItemIns.ConsignorCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",           DBType.adTinyInt,   objTransRateItemIns.RateType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromSido",           DBType.adVarWChar,  objTransRateItemIns.FromSido, 50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strFromGugun",          DBType.adVarWChar,  objTransRateItemIns.FromGugun, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromDong",           DBType.adVarWChar,  objTransRateItemIns.FromDong, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromAreaCode",       DBType.adVarChar,   objTransRateItemIns.FromAreaCode, 10, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToSido",             DBType.adVarWChar,  objTransRateItemIns.ToSido, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToGugun",            DBType.adVarWChar,  objTransRateItemIns.ToGugun, 50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strToDong",             DBType.adVarWChar,  objTransRateItemIns.ToDong, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToAreaCode",         DBType.adVarChar,   objTransRateItemIns.ToAreaCode, 10, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",         DBType.adVarChar,   objTransRateItemIns.CarTonCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",        DBType.adVarChar,   objTransRateItemIns.CarTypeCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleUnitAmt",        DBType.adInteger,   objTransRateItemIns.SaleUnitAmt, 0, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPurchaseUnitAmt",    DBType.adInteger,   objTransRateItemIns.PurchaseUnitAmt, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD",            DBType.adVarWChar,  objTransRateItemIns.FromYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD",              DBType.adVarWChar,  objTransRateItemIns.ToYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",         DBType.adVarChar,   objTransRateItemIns.AdminID, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",              DBType.adBigInt,    DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_TRANS_RATE_TX_INS");

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
                                     , 9103, "System error(fail to insert adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[TransRateItemIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        //요율표 수정
        public ServiceResult<bool> UpdTransRateItem(ClientTransRateModel objTransRateItemIns)
        {
            SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[UpdTransRateItem REQ] {JsonConvert.SerializeObject(objTransRateItemIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",          DBType.adBigInt,        objTransRateItemIns.SeqNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",     DBType.adBigInt,        objTransRateItemIns.ClientCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,       objTransRateItemIns.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",  DBType.adBigInt,        objTransRateItemIns.ConsignorCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",       DBType.adTinyInt,       objTransRateItemIns.RateType, 0, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strFromSido",       DBType.adVarWChar,      objTransRateItemIns.FromSido, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromGugun",      DBType.adVarWChar,      objTransRateItemIns.FromGugun, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromDong",       DBType.adVarWChar,      objTransRateItemIns.FromDong, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToSido",         DBType.adVarWChar,      objTransRateItemIns.ToSido, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToGugun",        DBType.adVarWChar,      objTransRateItemIns.ToGugun, 50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strToDong",         DBType.adVarWChar,      objTransRateItemIns.ToDong, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToFullAddr",     DBType.adVarWChar,      objTransRateItemIns.ToFullAddr, 150, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",     DBType.adVarChar,       objTransRateItemIns.CarTonCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",    DBType.adVarChar,       objTransRateItemIns.CarTypeCode, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleUnitAmt",    DBType.adInteger,       objTransRateItemIns.SaleUnitAmt, 0, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPurchaseUnitAmt", DBType.adInteger,      objTransRateItemIns.PurchaseUnitAmt, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD",        DBType.adVarWChar,      objTransRateItemIns.FromYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD",          DBType.adVarWChar,      objTransRateItemIns.ToYMD, 8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",     DBType.adVarChar,       objTransRateItemIns.AdminID, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",        DBType.adChar,          objTransRateItemIns.DelFlag, 1, ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,       DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,       DBNull.Value, 0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,       DBNull.Value, 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,       DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_TRANS_RATE_TX_UPD");

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
                                     , 9104, "System error(fail to insert adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[UpdTransRateItem RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        //요율표 전체 삭제
        public ServiceResult<bool> DelTransRateItem(ClientTransRateModel objTransRateItemIns)
        {
            SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[DelTransRateItem REQ] {JsonConvert.SerializeObject(objTransRateItemIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",     DBType.adBigInt,    objTransRateItemIns.ClientCode,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objTransRateItemIns.CenterCode,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",  DBType.adBigInt,    objTransRateItemIns.ConsignorCode,  0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",       DBType.adTinyInt,   objTransRateItemIns.RateType,       0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD",        DBType.adVarWChar,  objTransRateItemIns.FromYMD,        8, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUpdAdminID",     DBType.adVarChar,   objTransRateItemIns.AdminID,        50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                       256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                       0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                       256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                       0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_TRANS_RATE_TX_DEL");

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
                                     , 9105, "System error(fail to insert adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[DelTransRateItem RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        
        /// <summary>
        /// 오더 요율표 검색
        /// </summary>
        public ServiceResult<ResClientTransRateSearchList> GetClientTransRateSearchList(ReqClientTransRateSearchList objReqClientTransRateSearchList)
        {
            SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetClientTransRateSearchList REQ] {JsonConvert.SerializeObject(objReqClientTransRateSearchList)}", bLogWrite);

            string                                      lo_strJson   = string.Empty;
            ServiceResult<ResClientTransRateSearchList> lo_objResult = null;
            IDasNetCom                                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResClientTransRateSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,    objReqClientTransRateSearchList.ClientCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqClientTransRateSearchList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",      DBType.adBigInt,    objReqClientTransRateSearchList.ConsignorCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",           DBType.adTinyInt,   objReqClientTransRateSearchList.RateType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromAddrs",          DBType.adVarWChar,  objReqClientTransRateSearchList.FromAddrs,          4000,    ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@pi_strToAddrs",            DBType.adVarWChar,  objReqClientTransRateSearchList.ToAddrs,            4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTonCode",         DBType.adVarChar,   objReqClientTransRateSearchList.CarTonCode,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",        DBType.adVarChar,   objReqClientTransRateSearchList.CarTypeCode,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strApplyYMD",           DBType.adVarChar,   objReqClientTransRateSearchList.ApplyYMD,           8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,      objReqClientTransRateSearchList.DelFlag,            1,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqClientTransRateSearchList.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                                       0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CLIENT_TRANS_RATE_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResClientTransRateSearchList
                {
                    list      = new List<ClientTransRateSearchListViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<ClientTransRateSearchListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetClientTransRateSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetClientTransRateSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 정보 관리 리스트 신규
        /// </summary>
        public ServiceResult<ResTransRateList> GetTransRateList(ReqTransRateList objReqTransRateList)
        {
            SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetTransRateList REQ] {JsonConvert.SerializeObject(objReqTransRateList)}", bLogWrite);

            string                          lo_strJson   = string.Empty;
            ServiceResult<ResTransRateList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTransRateList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intTransSeqNo", DBType.adBigInt, objReqTransRateList.TransSeqNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqTransRateList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind", DBType.adTinyInt, objReqTransRateList.RateRegKind, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType", DBType.adTinyInt, objReqTransRateList.RateType, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFTLFlag", DBType.adChar, objReqTransRateList.FTLFlag, 1, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strTransRateName", DBType.adVarWChar, objReqTransRateList.TransRateName, 150, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag", DBType.adChar, objReqTransRateList.DelFlag, 1, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqTransRateList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize", DBType.adInteger, objReqTransRateList.PageSize, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo", DBType.adInteger, objReqTransRateList.PageNo, 0, ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTransRateList
                {
                    list      = new List<TransRateList>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TransRateList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9201, "System error(GetTransRateList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetTransRateList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 적용 고객사 리스트
        /// </summary>
        public ServiceResult<ResTransRateApplyClientList> GetTransRateApplyClientList(ReqTransRateList objReqTransRateList)
        {
            SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetTransRateApplyClientList REQ] {JsonConvert.SerializeObject(objReqTransRateList)}", bLogWrite);

            string                                     lo_strJson   = string.Empty;
            ServiceResult<ResTransRateApplyClientList> lo_objResult = null;
            IDasNetCom                                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTransRateApplyClientList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intApplySeqNo", DBType.adBigInt, objReqTransRateList.TransSeqNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransSeqNo", DBType.adBigInt, objReqTransRateList.TransSeqNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger, objReqTransRateList.CenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind", DBType.adTinyInt, objReqTransRateList.RateRegKind, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFTLFlag", DBType.adChar, objReqTransRateList.FTLFlag, 1, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqTransRateList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize", DBType.adInteger, objReqTransRateList.PageSize, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo", DBType.adInteger, objReqTransRateList.PageNo, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt", DBType.adInteger, DBNull.Value, 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_APPLY_CLIENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTransRateApplyClientList
                {
                    list      = new List<TransRateApplyClientList>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TransRateApplyClientList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9202, "System error(GetTransRateApplyClientList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("ClientTransRateDasServices", "I", $"[GetTransRateApplyClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}