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
    public class SmsDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 매입 마감 현황 목록
        /// </summary>
        /// <param name="objReqSmsPurchaseClosingList"></param>
        /// <returns></returns>
        public ServiceResult<ResSmsPurchaseClosingList> GetSmsPurchaseClosingList(ReqSmsPurchaseClosingList objReqSmsPurchaseClosingList)
        {
            SiteGlobal.WriteInformation("PurchaseDasServices", "I", $"[GetSmsPurchaseClosingList REQ] {JsonConvert.SerializeObject(objReqSmsPurchaseClosingList)}", bLogWrite);

            string                                   lo_strJson   = string.Empty;
            ServiceResult<ResSmsPurchaseClosingList> lo_objResult = null;
            IDasNetCom                               lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSmsPurchaseClosingList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPurchaseClosingSeqNo",   DBType.adBigInt,    objReqSmsPurchaseClosingList.PurchaseClosingSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",             DBType.adInteger,   objReqSmsPurchaseClosingList.CenterCode,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDateType",               DBType.adTinyInt,   objReqSmsPurchaseClosingList.DateType,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",               DBType.adVarChar,   objReqSmsPurchaseClosingList.DateFrom,                8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",                 DBType.adVarChar,   objReqSmsPurchaseClosingList.DateTo,                  8,       ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strComCorpNo",              DBType.adVarChar,   objReqSmsPurchaseClosingList.ComCorpNo,               20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",               DBType.adInteger,   objReqSmsPurchaseClosingList.PageSize,                0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",                 DBType.adInteger,   objReqSmsPurchaseClosingList.PageNo,                  0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",              DBType.adInteger,   DBNull.Value,                                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SMS_ORDER_PURCHASE_CLOSING_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResSmsPurchaseClosingList
                {
                    list      = new List<SmsPurchaseClosingGridModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SmsPurchaseClosingGridModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetSmsPurchaseClosingList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SmsDasServices", "I", $"[GetSmsPurchaseClosingList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 안전점검 체크리스트 동의처리
        /// </summary>
        /// <param name="objInsReqSafetyCheckReplayUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetSafetyCheckReplyUpd(ReqSafetyCheckReplayUpd objInsReqSafetyCheckReplayUpd)
        {
            SiteGlobal.WriteInformation("SmsDasServices", "I", $"[SetSafetyCheckReplyUpd REQ] {JsonConvert.SerializeObject(objInsReqSafetyCheckReplayUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",           DBType.adBigInt,    objInsReqSafetyCheckReplayUpd.SeqNo,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",      DBType.adInteger,   objInsReqSafetyCheckReplayUpd.CenterCode,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",         DBType.adBigInt,    objInsReqSafetyCheckReplayUpd.OrderNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intDispatchSeqNo",   DBType.adBigInt,    objInsReqSafetyCheckReplayUpd.DispatchSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",        DBType.adBigInt,    objInsReqSafetyCheckReplayUpd.RefSeqNo,         0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar,   DBNull.Value,                                   256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_DAILY_SAFETY_CHECK_REPLY_TX_UPD");

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
                                     , 9102, "System error(SetSafetyCheckReplyUpd" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SmsDasServices", "I", $"[SetSafetyCheckReplyUpd RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 이벤트 대상 여부 조회
        /// </summary>
        /// <param name="objReqEventAvailChk"></param>
        /// <returns></returns>
        public ServiceResult<ResEventAvailChk> GetEventAvailChk(ReqEventAvailChk objReqEventAvailChk)
        {
            SiteGlobal.WriteInformation("SmsDasServices", "I", $"[GetEventAvailChk REQ] {JsonConvert.SerializeObject(objReqEventAvailChk)}", bLogWrite);

            ServiceResult<ResEventAvailChk> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResEventAvailChk>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                //lo_objDas.Open(SiteGlobal.HOST_DAS_CARGOPAY); //[logimanDebug]
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strCORP_NO",            DBType.adVarChar,   objReqEventAvailChk.CorpNo,    20,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_strEVENT_AVAIL_FLAG",   DBType.adChar,      DBNull.Value,                  1,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strERR_MSG",            DBType.adVarChar,   DBNull.Value,                  256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRET_VAL",            DBType.adInteger,   DBNull.Value,                  0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDB_ERR_MSG",         DBType.adVarChar,   DBNull.Value,                  256,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDB_RET_VAL",         DBType.adInteger,   DBNull.Value,                  0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CENTER_ORDER_EVENT_POINT10X_CHK_GET");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //트랜잭션이없다.
                if (lo_objDas.GetParam("@po_intRET_VAL").ToInt().IsFail())
                {
                    lo_objResult.SetResult(lo_objDas.GetParam("@po_intRET_VAL").ToInt(), lo_objDas.GetParam("@po_strERR_MSG")
                        , lo_objDas.GetParam("@po_intDB_RET_VAL").ToInt(), lo_objDas.GetParam("@po_strDB_ERR_MSG"));
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
                lo_objResult.data = new ResEventAvailChk
                {
                    EventAvailFlag = lo_objDas.GetParam("@po_strEVENT_AVAIL_FLAG")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetEventAvailChk)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("SmsDasServices", "I", $"[GetEventAvailChk RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}