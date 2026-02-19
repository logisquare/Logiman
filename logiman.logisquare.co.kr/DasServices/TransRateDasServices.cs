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
    public class TransRateDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 요율표 정보 관리 리스트 신규
        /// </summary>
        public ServiceResult<ResTransRateList> GetTransRateList(ReqTransRateList objReqTransRateList)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateList REQ] {JsonConvert.SerializeObject(objReqTransRateList)}", bLogWrite);

            string                          lo_strJson   = string.Empty;
            ServiceResult<ResTransRateList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTransRateList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intTransSeqNo",        DBType.adBigInt,    objReqTransRateList.TransSeqNo,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqTransRateList.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind",       DBType.adTinyInt,   objReqTransRateList.RateRegKind,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",          DBType.adTinyInt,   objReqTransRateList.RateType,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFTLFlag",           DBType.adChar,      objReqTransRateList.FTLFlag,           1,       ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@pi_strTransRateName",     DBType.adVarWChar,  objReqTransRateList.TransRateName,     150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",           DBType.adChar,      objReqTransRateList.DelFlag,           1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqTransRateList.AccessCenterCode,  512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objReqTransRateList.PageSize,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objReqTransRateList.PageNo,            0,       ParameterDirection.Input);
                                                               
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

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
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
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

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 적용 고객사 리스트
        /// </summary>
        public ServiceResult<ResTransRateApplyClientList> GetTransRateApplyClientList(ReqTransRateList objReqTransRateList)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateApplyClientList REQ] {JsonConvert.SerializeObject(objReqTransRateList)}", bLogWrite);

            string                                     lo_strJson   = string.Empty;
            ServiceResult<ResTransRateApplyClientList> lo_objResult = null;
            IDasNetCom                                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTransRateApplyClientList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intApplySeqNo",         DBType.adBigInt,    objReqTransRateList.ApplySeqNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransSeqNo",         DBType.adBigInt,    objReqTransRateList.TransSeqNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqTransRateList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind",        DBType.adTinyInt,   objReqTransRateList.RateRegKind,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFTLFlag",            DBType.adChar,      objReqTransRateList.FTLFlag,             1,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqTransRateList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqTransRateList.PageSize,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqTransRateList.PageNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                            0,       ParameterDirection.Output);

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
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
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

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateApplyClientList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 상세 내역 등록
        /// </summary>
        /// <param name="objTransRateModel"></param>
        /// <returns></returns>
        public ServiceResult<TransRateModel> SetTransRateDtlIns(TransRateModel objTransRateModel)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateDtlIns REQ] {JsonConvert.SerializeObject(objTransRateModel)}", bLogWrite);

            ServiceResult<TransRateModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<TransRateModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intTransSeqNo",                 DBType.adBigInt,    objTransRateModel.TransSeqNo,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                 DBType.adInteger,   objTransRateModel.CenterCode,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind",                DBType.adTinyInt,   objTransRateModel.RateRegKind,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",                   DBType.adTinyInt,   objTransRateModel.RateType,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFTLFlag",                    DBType.adChar,      objTransRateModel.FTLFlag,                     1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strTransRateName",              DBType.adVarWChar,  objTransRateModel.TransRateName,               150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsRunType",               DBType.adTinyInt,   objTransRateModel.GoodsRunType,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromSido",                   DBType.adVarWChar,  objTransRateModel.FromSido,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromGugun",                  DBType.adVarWChar,  objTransRateModel.FromGugun,                   50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromDong",                   DBType.adVarWChar,  objTransRateModel.FromDong,                    50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strFromAreaCode",               DBType.adVarChar,   objTransRateModel.FromAreaCode,                10,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToSido",                     DBType.adVarWChar,  objTransRateModel.ToSido,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToGugun",                    DBType.adVarWChar,  objTransRateModel.ToGugun,                     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToDong",                     DBType.adVarWChar,  objTransRateModel.ToDong,                      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToAreaCode",                 DBType.adVarChar,   objTransRateModel.ToAreaCode,                  10,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarTonCode",                 DBType.adVarChar,   objTransRateModel.CarTonCode,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTypeCode",                DBType.adVarChar,   objTransRateModel.CarTypeCode,                 50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTypeValueFrom",              DBType.adDouble,    objTransRateModel.TypeValueFrom,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTypeValueTo",                DBType.adDouble,    objTransRateModel.TypeValueTo,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleUnitAmt",                DBType.adDouble,    objTransRateModel.SaleUnitAmt,                 0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPurchaseUnitAmt",            DBType.adDouble,    objTransRateModel.PurchaseUnitAmt,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFixedPurchaseUnitAmt",       DBType.adDouble,    objTransRateModel.FixedPurchaseUnitAmt,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intExtSaleUnitAmt",             DBType.adDouble,    objTransRateModel.ExtSaleUnitAmt,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intExtPurchaseUnitAmt",         DBType.adDouble,    objTransRateModel.ExtPurchaseUnitAmt,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intExtFixedPurchaseUnitAmt",    DBType.adDouble,    objTransRateModel.ExtFixedPurchaseUnitAmt,     0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strRegAdminID",                 DBType.adVarChar,   objTransRateModel.RegAdminID,                  50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTransSeqNo",                 DBType.adBigInt,    DBNull.Value,                                  0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDtlSeqNo",                   DBType.adBigInt,    DBNull.Value,                                  0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                     DBType.adVarChar,   DBNull.Value,                                  256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                     DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);
                                                                                                                                           
                lo_objDas.AddParam("@po_strDBErrMsg",                   DBType.adVarChar,   DBNull.Value,                                  256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                   DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_DTL_TX_INS");

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
                objTransRateModel.OutTransSeqNo = lo_objDas.GetParam("@po_intTransSeqNo").ToInt64();
                objTransRateModel.DtlSeqNo      = lo_objDas.GetParam("@po_intDtlSeqNo").ToInt64();
                lo_objResult.data               = objTransRateModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9203, "System error(SetTransRateDtlIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateDtlIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 상세 히스토리 리스트
        /// </summary>
        public ServiceResult<ResTransRateDtlList> GetTransRateDtlHistList(ReqTransRateList objReqTransRateList)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateDtlHistList REQ] {JsonConvert.SerializeObject(objReqTransRateList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResTransRateDtlList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTransRateDtlList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intDtlSeqNo",          DBType.adBigInt,    objReqTransRateList.DtlSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransSeqNo",        DBType.adBigInt,    objReqTransRateList.TransSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqTransRateList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objReqTransRateList.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objReqTransRateList.PageSize,           0,       ParameterDirection.Input);
                                                                                                                           
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objReqTransRateList.PageNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                           0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_DTL_HIST_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTransRateDtlList
                {
                    list      = new List<TransRateDtlList>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TransRateDtlList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9204, "System error(GetTransRateDtlHistList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateDtlHistList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 상세 리스트
        /// </summary>
        public ServiceResult<ResTransRateDtlList> GetTransRateDtlList(ReqTransRateList objReqTransRateList)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateDtlList REQ] {JsonConvert.SerializeObject(objReqTransRateList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResTransRateDtlList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTransRateDtlList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intTransSeqNo",          DBType.adBigInt,    objReqTransRateList.TransSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objReqTransRateList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind",         DBType.adTinyInt,   objReqTransRateList.RateRegKind,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",            DBType.adTinyInt,   objReqTransRateList.RateType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGoodsRunType",        DBType.adTinyInt,   objReqTransRateList.GoodsRunType,         0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strTransRateName",       DBType.adVarWChar,  objReqTransRateList.TransRateName,        150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromFullAddr",        DBType.adVarWChar,  objReqTransRateList.FromFullAddr,         150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToFullAddr",          DBType.adVarWChar,  objReqTransRateList.ToFullAddr,           150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",             DBType.adChar,      objReqTransRateList.DelFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objReqTransRateList.AccessCenterCode,     512,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objReqTransRateList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objReqTransRateList.PageNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                             0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_DTL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTransRateDtlList
                {
                    list      = new List<TransRateDtlList>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TransRateDtlList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9205, "System error(GetTransRateDtlList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateDtlList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 상세 내역 수정
        /// </summary>
        /// <param name="objTransRateModel"></param>
        /// <returns></returns>
        public ServiceResult<TransRateModel> SetTransRateDtlUpd(TransRateModel objTransRateModel)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateDtlUpd REQ] {JsonConvert.SerializeObject(objTransRateModel)}", bLogWrite);

            ServiceResult<TransRateModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<TransRateModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",                DBType.adInteger,   objTransRateModel.CenterCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDtlSeqNo",                  DBType.adBigInt,    objTransRateModel.DtlSeqNo,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTransSeqNo",                DBType.adBigInt,    objTransRateModel.TransSeqNo,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind",               DBType.adTinyInt,   objTransRateModel.RateRegKind,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSaleUnitAmt",               DBType.adCurrency,  objTransRateModel.SaleUnitAmt,               0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPurchaseUnitAmt",           DBType.adCurrency,  objTransRateModel.PurchaseUnitAmt,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFixedPurchaseUnitAmt",      DBType.adCurrency,  objTransRateModel.FixedPurchaseUnitAmt,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intExtSaleUnitAmt",            DBType.adCurrency,  objTransRateModel.ExtSaleUnitAmt,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intExtPurchaseUnitAmt",        DBType.adCurrency,  objTransRateModel.ExtPurchaseUnitAmt,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intExtFixedPurchaseUnitAmt",   DBType.adCurrency,  objTransRateModel.ExtFixedPurchaseUnitAmt,   0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intTypeValueFrom",             DBType.adCurrency,  objTransRateModel.TypeValueFrom,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intTypeValueTo",               DBType.adCurrency,  objTransRateModel.TypeValueTo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",                   DBType.adChar,      objTransRateModel.DelFlag,                   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",                DBType.adVarChar,   objTransRateModel.UpdAdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                    DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                                                                                                                                     
                lo_objDas.AddParam("@po_intRetVal",                    DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                  DBType.adVarChar,   DBNull.Value,                                256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                  DBType.adInteger,   DBNull.Value,                                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_DTL_TX_UPD");

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
                lo_objResult.data = objTransRateModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9206, "System error(SetTransRateDtlUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateDtlUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 수정
        /// </summary>
        /// <param name="objTransRateModel"></param>
        /// <returns></returns>
        public ServiceResult<TransRateModel> SetTransRateUpd(TransRateModel objTransRateModel)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateUpd REQ] {JsonConvert.SerializeObject(objTransRateModel)}", bLogWrite);

            ServiceResult<TransRateModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<TransRateModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intTransSeqNo",     DBType.adBigInt,    objTransRateModel.TransSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objTransRateModel.CenterCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind",    DBType.adTinyInt,   objTransRateModel.RateRegKind,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUpdAdminID",     DBType.adVarChar,   objTransRateModel.UpdAdminID,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",        DBType.adChar,      objTransRateModel.DelFlag,       1,       ParameterDirection.Input);
                                                            
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                    0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_TX_UPD");

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
                lo_objResult.data = objTransRateModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9207, "System error(SetTransRateUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
        /// <summary>
        /// 요율표 고객사/화주 적용 관리 삭제
        /// </summary>
        /// <param name="objTransRateModel"></param>
        /// <returns></returns>
        public ServiceResult<TransRateModel> SetTransRateApplyDel(TransRateModel objTransRateModel)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateApplyDel REQ] {JsonConvert.SerializeObject(objTransRateModel)}", bLogWrite);

            ServiceResult<TransRateModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<TransRateModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intTransSeqNo",    DBType.adBigInt,    objTransRateModel.TransSeqNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intApplySeqNo",    DBType.adBigInt,    objTransRateModel.ApplySeqNo,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",    DBType.adInteger,   objTransRateModel.CenterCode,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intUpdType",       DBType.adTinyInt,   objTransRateModel.UpdType,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind",   DBType.adTinyInt,   objTransRateModel.RateRegKind,    0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUpdAdminID",    DBType.adVarChar,   objTransRateModel.UpdAdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,   DBNull.Value,                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,   DBNull.Value,                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,   DBNull.Value,                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,   DBNull.Value,                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_APPLY_TX_DEL");

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
                lo_objResult.data = objTransRateModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9208, "System error(SetTransRateApplyDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateApplyDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 정보 관리 리스트 신규
        /// </summary>
        public ServiceResult<ResTransRateApplyList> GetTransRateApplyList(ReqTransRateApplyList objReqTransRateApplyList)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateApplyList REQ] {JsonConvert.SerializeObject(objReqTransRateApplyList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResTransRateApplyList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTransRateApplyList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intApplySeqNo",         DBType.adBigInt,    objReqTransRateApplyList.ApplySeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",         DBType.adBigInt,    objReqTransRateApplyList.ClientCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strClientName",         DBType.adVarWChar,  objReqTransRateApplyList.ClientName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqTransRateApplyList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",      DBType.adBigInt,    objReqTransRateApplyList.ConsignorCode,        0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strConsignorName",      DBType.adVarWChar,  objReqTransRateApplyList.ConsignorName,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",      DBType.adVarChar,   objReqTransRateApplyList.OrderItemCode,        5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCode",  DBType.adVarChar,   objReqTransRateApplyList.OrderLocationCode,    5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",            DBType.adChar,      objReqTransRateApplyList.DelFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqTransRateApplyList.AccessCenterCode,     512,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqTransRateApplyList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqTransRateApplyList.PageNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_APPLY_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTransRateApplyList
                {
                    list      = new List<TransRateApplyList>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TransRateApplyList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9209, "System error(GetTransRateApplyList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 등록 중복확인
        /// </summary>
        /// <param name="objTransRateModel"></param>
        /// <returns></returns>
        public ServiceResult<TransRateModel> GetTransRateGet(TransRateModel objTransRateModel)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateGet REQ] {JsonConvert.SerializeObject(objTransRateModel)}", bLogWrite);

            ServiceResult<TransRateModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<TransRateModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intTransSeqNo",      DBType.adBigInt,     objTransRateModel.TransSeqNo,       0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",      DBType.adInteger,    objTransRateModel.CenterCode,       0,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateRegKind",     DBType.adTinyInt,    objTransRateModel.RateRegKind,      50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRateType",        DBType.adTinyInt,    objTransRateModel.RateType,         50,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFTLFlag",         DBType.adVarChar,    objTransRateModel.FTLFlag,          50,    ParameterDirection.Input);
                                                                                                                             
                lo_objDas.AddParam("@pi_strTransRateName",   DBType.adVarWChar,   objTransRateModel.TransRateName,    50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intTransSeqNo",      DBType.adBigInt,     objTransRateModel.OutTransSeqNo,    50,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strExists",          DBType.adChar,       objTransRateModel.Exists,           1,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDelFlag",         DBType.adChar,       objTransRateModel.UpdAdminID,       1,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,    DBNull.Value,                       256,   ParameterDirection.Output);
                                                                                                                      
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,    DBNull.Value,                       0,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,    DBNull.Value,                       256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,    DBNull.Value,                       0,     ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_NT_GET");

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
                objTransRateModel.OutTransSeqNo = lo_objDas.GetParam("@po_intTransSeqNo").ToInt64();
                objTransRateModel.Exists        = lo_objDas.GetParam("@po_strExists");
                objTransRateModel.DelFlag       = lo_objDas.GetParam("@po_strDelFlag");
                lo_objResult.data               = objTransRateModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9208, "System error(GetTransRateGet)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateGet RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 적용관리 중복확인
        /// </summary>
        /// <param name="objTransRateModel"></param>
        /// <returns></returns>
        public ServiceResult<TransRateModel> GetTransRateApplyGet(TransRateModel objTransRateModel)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateApplyGet REQ] {JsonConvert.SerializeObject(objTransRateModel)}", bLogWrite);

            ServiceResult<TransRateModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<TransRateModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intApplySeqNo",              DBType.adBigInt,      objTransRateModel.ApplySeqNo,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",              DBType.adBigInt,      objTransRateModel.ClientCode,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",              DBType.adInteger,     objTransRateModel.CenterCode,           0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",           DBType.adBigInt,      objTransRateModel.ConsignorCode,        0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",           DBType.adVarChar,     objTransRateModel.OrderItemCode,        5,      ParameterDirection.Input);
                                                                                           
                lo_objDas.AddParam("@pi_strOrderLocationCodes",      DBType.adVarChar,     objTransRateModel.OrderLocationCodes,   1000,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intApplySeqNo",              DBType.adBigInt,      objTransRateModel.OutApplySeqNo,        0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strExists",                  DBType.adChar,        objTransRateModel.Exists,               1,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDelFlag",                 DBType.adChar,        objTransRateModel.UpdAdminID,           1,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strRegOrderLocationCodes",   DBType.adVarChar,     DBNull.Value,                           1000,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",                  DBType.adVarChar,     DBNull.Value,                           256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                  DBType.adInteger,     DBNull.Value,                           0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                DBType.adVarChar,     DBNull.Value,                           256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                DBType.adInteger,     DBNull.Value,                           0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_APPLY_NT_GET");

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

                objTransRateModel.OutApplySeqNo         = lo_objDas.GetParam("@po_intApplySeqNo").ToInt64();
                objTransRateModel.Exists                = lo_objDas.GetParam("@po_strExists");
                objTransRateModel.DelFlag               = lo_objDas.GetParam("@po_strDelFlag");
                objTransRateModel.RegOrderLocationCodes = lo_objDas.GetParam("@po_strRegOrderLocationCodes");
                lo_objResult.data                       = objTransRateModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9301, "System error(GetTransRateApplyGet)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateApplyGet RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 유가 평균
        /// </summary>
        /// <param name="objTransRateOilModel"></param>
        /// <returns></returns>
        public ServiceResult<TransRateOilModel> GetOilAvgPriceGet(TransRateOilModel objTransRateOilModel)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetOilAvgPriceGet REQ] {JsonConvert.SerializeObject(objTransRateOilModel)}", bLogWrite);

            ServiceResult<TransRateOilModel> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<TransRateOilModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strStdYMD",        DBType.adVarChar,     objTransRateOilModel.StdYMD,     8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOilType",       DBType.adTinyInt,     objTransRateOilModel.OilType,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAvgType",       DBType.adTinyInt,     objTransRateOilModel.AvgType,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSido",          DBType.adVarWChar,    objTransRateOilModel.Sido,       150,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intAvgPrice",      DBType.adDouble,      DBNull.Value,                    0,       ParameterDirection.Output);
                                                                                 
                lo_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,     DBNull.Value,                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",        DBType.adInteger,     DBNull.Value,                    0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,     DBNull.Value,                    256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,     DBNull.Value,                    0,       ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_OIL_AVG_PRICE_NT_GET");

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
                objTransRateOilModel.AvgPrice = lo_objDas.GetParam("@po_intAvgPrice").ToDouble();
                lo_objResult.data             = objTransRateOilModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9302, "System error(GetOilAvgPriceGet)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetOilAvgPriceGet RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 상세 내역 등록
        /// </summary>
        /// <param name="objTransRateApplyModel"></param>
        /// <returns></returns>
        public ServiceResult<TransRateApplyModel> SetTransRateApplyIns(TransRateApplyModel objTransRateApplyModel)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateApplyIns REQ] {JsonConvert.SerializeObject(objTransRateApplyModel)}", bLogWrite);

            ServiceResult<TransRateApplyModel> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<TransRateApplyModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intClientCode",              DBType.adBigInt,    objTransRateApplyModel.ClientCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",              DBType.adInteger,   objTransRateApplyModel.CenterCode,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intConsignorCode",           DBType.adBigInt,    objTransRateApplyModel.ConsignorCode,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderItemCode",           DBType.adVarChar,   objTransRateApplyModel.OrderItemCode,             5,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",      DBType.adVarChar,   objTransRateApplyModel.OrderLocationCodes,        1000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intFtlSPTransSeqNo",         DBType.adBigInt,    objTransRateApplyModel.FtlSPTransSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlSTransSeqNo",          DBType.adBigInt,    objTransRateApplyModel.FtlSTransSeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlPTransSeqNo",          DBType.adBigInt,    objTransRateApplyModel.FtlPTransSeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFtlPRateFlag",            DBType.adChar,      objTransRateApplyModel.FtlPRateFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlPurchaseRate",         DBType.adCurrency,  objTransRateApplyModel.FtlPurchaseRate,           0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intFtlFixedPurchaseRate",    DBType.adCurrency,  objTransRateApplyModel.FtlFixedPurchaseRate,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlRoundAmtKind",         DBType.adInteger,   objTransRateApplyModel.FtlRoundAmtKind,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFtlRoundType",            DBType.adChar,      objTransRateApplyModel.FtlRoundType,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLtlSPTransSeqNo",         DBType.adBigInt,    objTransRateApplyModel.LtlSPTransSeqNo,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLtlSTransSeqNo",          DBType.adBigInt,    objTransRateApplyModel.LtlSTransSeqNo,            0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intLtlPTransSeqNo",          DBType.adBigInt,    objTransRateApplyModel.LtlPTransSeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLtlPRateFlag",            DBType.adChar,      objTransRateApplyModel.LtlPRateFlag,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLtlPurchaseRate",         DBType.adCurrency,  objTransRateApplyModel.LtlPurchaseRate,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLtlFixedPurchaseRate",    DBType.adCurrency,  objTransRateApplyModel.LtlFixedPurchaseRate,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLtlRoundAmtKind",         DBType.adInteger,   objTransRateApplyModel.LtlRoundAmtKind,           0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strLtlRoundType",            DBType.adChar,      objTransRateApplyModel.LtlRoundType,              1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLayoverTransSeqNo",       DBType.adBigInt,    objTransRateApplyModel.LayoverTransSeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOilTransSeqNo",           DBType.adBigInt,    objTransRateApplyModel.OilTransSeqNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOilPeriodType",           DBType.adTinyInt,   objTransRateApplyModel.OilPeriodType,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilSearchArea",           DBType.adVarWChar,  objTransRateApplyModel.OilSearchArea,             150,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intOilPrice",                DBType.adCurrency,  objTransRateApplyModel.OilPrice,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilGetPlace1",            DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace1,              150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilGetPlace2",            DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace2,              150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilGetPlace3",            DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace3,              150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilGetPlace4",            DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace4,              150,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOilGetPlace5",            DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace5,              150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOilSaleRoundAmtKind",     DBType.adInteger,   objTransRateApplyModel.OilSaleRoundAmtKind,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilSaleRoundType",        DBType.adChar,      objTransRateApplyModel.OilSaleRoundType,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOilPurchaseRoundAmtKind", DBType.adInteger,   objTransRateApplyModel.OilPurchaseRoundAmtKind,   0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilPurchaseRoundType",    DBType.adChar,      objTransRateApplyModel.OilPurchaseRoundType,      1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intOilFixedRoundAmtKind",    DBType.adInteger,   objTransRateApplyModel.OilFixedRoundAmtKind,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilFixedRoundType",       DBType.adChar,      objTransRateApplyModel.OilFixedRoundType,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",              DBType.adVarChar,   objTransRateApplyModel.RegAdminID,                50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intApplySeqNo",              DBType.adBigInt,    DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",                  DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                                                                                                                                           
                lo_objDas.AddParam("@po_intRetVal",                  DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                DBType.adVarChar,   DBNull.Value,                                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",                DBType.adInteger,   DBNull.Value,                                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_APPLY_TX_INS");

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
                objTransRateApplyModel.ApplySeqNo = lo_objDas.GetParam("@po_intApplySeqNo").ToInt64();
                lo_objResult.data                 = objTransRateApplyModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9303, "System error(SetTransRateApplyIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateApplyIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 상세 내역 수정
        /// </summary>
        /// <param name="objTransRateApplyModel"></param>
        /// <returns></returns>
        public ServiceResult<TransRateApplyModel> SetTransRateApplyUpd(TransRateApplyModel objTransRateApplyModel)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateApplyUpd REQ] {JsonConvert.SerializeObject(objTransRateApplyModel)}", bLogWrite);

            ServiceResult<TransRateApplyModel> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<TransRateApplyModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;
                
                lo_objDas.AddParam("@pi_intApplySeqNo",                  DBType.adBigInt,    objTransRateApplyModel.ApplySeqNo,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",                  DBType.adInteger,   objTransRateApplyModel.CenterCode,                    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlSPTransSeqNo",             DBType.adBigInt,    objTransRateApplyModel.FtlSPTransSeqNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlSTransSeqNo",              DBType.adBigInt,    objTransRateApplyModel.FtlSTransSeqNo,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlPTransSeqNo",              DBType.adBigInt,    objTransRateApplyModel.FtlPTransSeqNo,                0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strFtlPRateFlag",                DBType.adChar,      objTransRateApplyModel.FtlPRateFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlPurchaseRate",             DBType.adCurrency,  objTransRateApplyModel.FtlPurchaseRate,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlFixedPurchaseRate",        DBType.adCurrency,  objTransRateApplyModel.FtlFixedPurchaseRate,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intFtlRoundAmtKind",             DBType.adInteger,   objTransRateApplyModel.FtlRoundAmtKind,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFtlRoundType",                DBType.adChar,      objTransRateApplyModel.FtlRoundType,                  1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intLtlSPTransSeqNo",             DBType.adBigInt,    objTransRateApplyModel.LtlSPTransSeqNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLtlSTransSeqNo",              DBType.adBigInt,    objTransRateApplyModel.LtlSTransSeqNo,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLtlPTransSeqNo",              DBType.adBigInt,    objTransRateApplyModel.LtlPTransSeqNo,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLtlPRateFlag",                DBType.adChar,      objTransRateApplyModel.LtlPRateFlag,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLtlPurchaseRate",             DBType.adCurrency,  objTransRateApplyModel.LtlPurchaseRate,               0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intLtlFixedPurchaseRate",        DBType.adCurrency,  objTransRateApplyModel.LtlFixedPurchaseRate,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLtlRoundAmtKind",             DBType.adInteger,   objTransRateApplyModel.LtlRoundAmtKind,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strLtlRoundType",                DBType.adChar,      objTransRateApplyModel.LtlRoundType,                  1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intLayoverTransSeqNo",           DBType.adBigInt,    objTransRateApplyModel.LayoverTransSeqNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOilTransSeqNo",               DBType.adBigInt,    objTransRateApplyModel.OilTransSeqNo,                 0,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intOilPeriodType",               DBType.adTinyInt,   objTransRateApplyModel.OilPeriodType,                 0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilSearchArea",               DBType.adVarWChar,  objTransRateApplyModel.OilSearchArea,                 150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOilPrice",                    DBType.adCurrency,  objTransRateApplyModel.OilPrice,                      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilGetPlace1",                DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace1,                  150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilGetPlace2",                DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace2,                  150,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strOilGetPlace3",                DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace3,                  150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilGetPlace4",                DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace4,                  150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilGetPlace5",                DBType.adVarWChar,  objTransRateApplyModel.OilGetPlace5,                  150,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOilSaleRoundAmtKind",         DBType.adInteger,   objTransRateApplyModel.OilSaleRoundAmtKind,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilSaleRoundType",            DBType.adChar,      objTransRateApplyModel.OilSaleRoundType,              1,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intOilPurchaseRoundAmtKind",     DBType.adInteger,   objTransRateApplyModel.OilPurchaseRoundAmtKind,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilPurchaseRoundType",        DBType.adChar,      objTransRateApplyModel.OilPurchaseRoundType,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOilFixedRoundAmtKind",        DBType.adInteger,   objTransRateApplyModel.OilFixedRoundAmtKind,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOilFixedRoundType",           DBType.adChar,      objTransRateApplyModel.OilFixedRoundType,             1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderLocationCodes",          DBType.adVarWChar,  objTransRateApplyModel.OrderLocationCodes,            1000,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strUpdAdminID",                  DBType.adVarChar,   objTransRateApplyModel.RegAdminID,                    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",                     DBType.adChar,      objTransRateApplyModel.DelFlag,                       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",                      DBType.adVarChar,   DBNull.Value,                                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",                      DBType.adInteger,   DBNull.Value,                                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",                    DBType.adVarChar,   DBNull.Value,                                         256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",                    DBType.adInteger,   DBNull.Value,                                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_APPLY_TX_UPD");

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
                lo_objResult.data = objTransRateApplyModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9303, "System error(SetTransRateApplyUpd)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[SetTransRateApplyUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 요율표 정보 관리 히스토리 리스트
        /// </summary>
        public ServiceResult<ResTransRateApplyList> GetTransRateApplyHistList(ReqTransRateApplyList objReqTransRateApplyList)
        {
            SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateApplyHistList REQ] {JsonConvert.SerializeObject(objReqTransRateApplyList)}", bLogWrite);

            string                               lo_strJson   = string.Empty;
            ServiceResult<ResTransRateApplyList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResTransRateApplyList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intApplySeqNo",         DBType.adBigInt,    objReqTransRateApplyList.ApplySeqNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,   objReqTransRateApplyList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",   DBType.adVarChar,   objReqTransRateApplyList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",           DBType.adInteger,   objReqTransRateApplyList.PageSize,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",             DBType.adInteger,   objReqTransRateApplyList.PageNo,              0,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@po_intRecordCnt",          DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_TRANS_RATE_APPLY_HIST_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResTransRateApplyList
                {
                    list      = new List<TransRateApplyList>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<TransRateApplyList>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9304, "System error(GetTransRateApplyHistList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("TransRateDasServices", "I", $"[GetTransRateApplyHistList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}