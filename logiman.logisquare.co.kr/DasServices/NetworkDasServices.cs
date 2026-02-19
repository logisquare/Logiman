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
    public class NetworkDasSerivices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 차량조회 리스트
        /// </summary>
        public ServiceResult<ResNetworkList> GetOrderNetworkRuleList(ReqNetworkList objReqClientCsList)
        {
            SiteGlobal.WriteInformation("NetworkDasSerivices", "I", $"[GetOrderNetworkRuleList REQ] {JsonConvert.SerializeObject(objReqClientCsList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResNetworkList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResNetworkList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intRuleSeqNo",      DBType.adInteger,       objReqClientCsList.RuleSeqNo,    0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRuleType",       DBType.adTinyInt,       objReqClientCsList.RuleType,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,       objReqClientCsList.CenterCode,   0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNetworkKind",    DBType.adTinyInt,       objReqClientCsList.NetworkKind,  0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",     DBType.adBigInt,        objReqClientCsList.ClientCode,   0, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strClientName",     DBType.adVarWChar,      objReqClientCsList.ClientName,   50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",        DBType.adChar,          objReqClientCsList.UseFlag,      1,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminName",   DBType.adVarWChar,      objReqClientCsList.RegAdminName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",       DBType.adInteger,       objReqClientCsList.PageSize,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",         DBType.adInteger,       objReqClientCsList.PageNo,       0, ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,       DBNull.Value,                    0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_RULE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResNetworkList
                {
                    list = new List<NetworkListListViewModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<NetworkListListViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderNetworkRuleList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("NetworkDasSerivices", "I", $"[GetOrderNetworkRuleList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        public ServiceResult<NetworkViewModel> InsNetworkRule(NetworkViewModel objInsNetworkViewModel)
        {
            SiteGlobal.WriteInformation("NetworkDasSerivices", "I", $"[InsNetworkRule REQ] {JsonConvert.SerializeObject(objInsNetworkViewModel)}", bLogWrite);

            ServiceResult<NetworkViewModel> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<NetworkViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intRuleType",               DBType.adTinyInt,   objInsNetworkViewModel.RuleType,     0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objInsNetworkViewModel.CenterCode,   0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNetworkKind",            DBType.adTinyInt,   objInsNetworkViewModel.NetworkKind,  0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",             DBType.adBigInt,    objInsNetworkViewModel.ClientCode,   0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",          DBType.adBigInt,    DBNull.Value,                        0, ParameterDirection.Input);
                
                lo_objDas.AddParam("@pi_intRenewalStartMinute",     DBType.adInteger,   objInsNetworkViewModel.RenewalStartMinute,    0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRenewalIntervalMinute",  DBType.adInteger,   objInsNetworkViewModel.RenewalIntervalMinute, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRenewalIntervalPrice",   DBType.adCurrency,  objInsNetworkViewModel.RenewalIntervalPrice, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRenewalModMinute",       DBType.adInteger,   objInsNetworkViewModel.RenewalModMinute, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",             DBType.adVarChar,   objInsNetworkViewModel.RegAdminID,    50, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRegAdminName",           DBType.adVarWChar,  objInsNetworkViewModel.RegAdminName, 50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRuleSeqNo",              DBType.adInteger,   DBNull.Value,       0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,    256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,       0, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,    256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,    0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_RULE_TX_INS");

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
                objInsNetworkViewModel.RuleSeqNo = lo_objDas.GetParam("@po_intRuleSeqNo").ToInt();

                lo_objResult.data = objInsNetworkViewModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(fail to insert adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("NetworkDasSerivices", "I", $"[InsNetworkRule RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<NetworkViewModel> UpdNetworkRule(NetworkViewModel objInsNetworkViewModel)
        {
            SiteGlobal.WriteInformation("NetworkDasSerivices", "I", $"[UpdNetworkRule REQ] {JsonConvert.SerializeObject(objInsNetworkViewModel)}", bLogWrite);

            ServiceResult<NetworkViewModel> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<NetworkViewModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intRuleSeqNo",              DBType.adTinyInt, objInsNetworkViewModel.RuleSeqNo,              0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger, objInsNetworkViewModel.CenterCode,            0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRenewalStartMinute",     DBType.adInteger, objInsNetworkViewModel.RenewalStartMinute,    0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRenewalIntervalMinute",  DBType.adInteger, objInsNetworkViewModel.RenewalIntervalMinute, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRenewalIntervalPrice",   DBType.adCurrency,  objInsNetworkViewModel.RenewalIntervalPrice,  0, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intRenewalModMinute",       DBType.adInteger, objInsNetworkViewModel.RenewalModMinute,      0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",                DBType.adChar,    objInsNetworkViewModel.UseFlag,               1, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",             DBType.adVarChar, objInsNetworkViewModel.RegAdminID,            50, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar, DBNull.Value,                                 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                 DBType.adInteger, DBNull.Value,                                 0, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar, DBNull.Value,                                 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger, DBNull.Value,                                 0, ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_RULE_TX_UPD");

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
                                     , 9101, "System error(fail to insert adminmenu's menugroup" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("NetworkDasSerivices", "I", $"[UpdNetworkRule RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }


        /// <summary>
        /// 자동배차 룰 검색
        /// </summary>
        /// <param name="objReqNetworkRuleSearchList"></param>
        /// <returns></returns>
        public ServiceResult<ResNetworkRuleSearchList> GetOrderNetworkRuleSearchList(ReqNetworkRuleSearchList objReqNetworkRuleSearchList)
        {
            SiteGlobal.WriteInformation("NetworkDasSerivices", "I", $"[GetOrderNetworkRuleSearchList REQ] {JsonConvert.SerializeObject(objReqNetworkRuleSearchList)}", bLogWrite);

            string lo_strJson = string.Empty;

            ServiceResult<ResNetworkRuleSearchList> lo_objResult = null;
            IDasNetCom lo_objDas = null;

            try
            {
                lo_objResult = new ServiceResult<ResNetworkRuleSearchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objReqNetworkRuleSearchList.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intNetworkKind",    DBType.adTinyInt,   objReqNetworkRuleSearchList.NetworkKind,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",     DBType.adBigInt,    objReqNetworkRuleSearchList.ClientCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",  DBType.adBigInt,    objReqNetworkRuleSearchList.ConsignorCode,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",        DBType.adChar,      objReqNetworkRuleSearchList.UseFlag,         1,       ParameterDirection.Input);
                                                            
                lo_objDas.AddParam("@pi_intPageSize",       DBType.adInteger,   objReqNetworkRuleSearchList.PageSize,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",         DBType.adInteger,   objReqNetworkRuleSearchList.PageNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_NETWORK_RULE_SEARCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResNetworkRuleSearchList
                {
                    list      = new List<NetworkRuleGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<NetworkRuleGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetOrderNetworkRuleSearchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("NetworkDasSerivices", "I", $"[GetOrderNetworkRuleSearchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}