using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using CommonLibrary.Utils;
using Newtonsoft.Json;
using PBSDasNetCom;
using System;
using System.Collections;
using System.Data;

namespace CommonLibrary.DasServices
{
    public class CargopayDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 계산서 목록
        /// </summary>
        /// <param name="objReqApproveHometaxApiList"></param>
        /// <returns></returns>
        public ServiceResult<ResApproveHometaxApiList> GetApproveHometaxApiList(ReqApproveHometaxApiList objReqApproveHometaxApiList)
        {
            SiteGlobal.WriteInformation("CargopayDasServices", "I", $"[GetApproveHometaxApiList REQ] {JsonConvert.SerializeObject(objReqApproveHometaxApiList)}", bLogWrite);
            
            int                                     lo_intRetVal        = 0;
            string                                  lo_strPostData      = string.Empty;
            string                                  lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader                              lo_objHeader        = null;
            HttpAction                              lo_objHttp          = null;
            ResApproveHometaxApiListFromAPI         lo_objResponse      = null;
            ServiceResult<ResApproveHometaxApiList> lo_objResult        = null;

            try
            {
                lo_objResponse = new ResApproveHometaxApiListFromAPI();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = SiteGlobal.GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = JsonConvert.SerializeObject(objReqApproveHometaxApiList);

                lo_objHttp = new HttpAction(SiteGlobal.WS_DOMAIN + CommonConstant.WS_CP_API_COMMAND_GETAPPROVEHOMETAXV2, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResult.SetResult(lo_intRetVal, $"웹서비스 호출 오류 - {lo_objHttp.ErrMsg}"
                        , 0, $"[{lo_intRetVal}] 웹서비스 호출 오류 - {lo_objHttp.ErrMsg}");
                    return lo_objResult;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResApproveHometaxApiListFromAPI>(lo_objHttp.ResponseData);

                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResult.SetResult(lo_objResponse.Header.ResultCode, $"웹서비스 호출 오류 - {lo_objResponse.Header.ResultMessage}"
                        , 0, $"[{lo_objResponse.Header.ResultCode}] 웹서비스 호출 오류 - {lo_objResponse.Header.ResultMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data            = new ResApproveHometaxApiList();
                lo_objResult.data.list       = lo_objResponse.Payload.List;
                lo_objResult.data.RECORD_CNT = lo_objResponse.Payload.ListCount;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9101, "System error(GetApproveHometaxApiList)" + ex.Message);
            }
            finally
            {
                SiteGlobal.WriteInformation("CargopayDasServices", "I", $"[GetApproveHometaxApiList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 계산서 항목 목록
        /// </summary>
        /// <param name="objReqApproveHometaxItemList"></param>
        /// <returns></returns>
        public ServiceResult<ResApproveHometaxItemList> GetApproveHometaxItemList(string strNtsConfirmNum)
        {
            SiteGlobal.WriteInformation("CargopayDasServices", "I", $"[GetApproveHometaxItemList REQ] {strNtsConfirmNum}", bLogWrite);

            int                                      lo_intRetVal        = 0;
            string                                   lo_strPostData      = string.Empty;
            string                                   lo_strAuthirization = string.Empty; //api.logislab.com 연동 시 인증 값 전송
            HttpHeader                               lo_objHeader        = null;
            HttpAction                               lo_objHttp          = null;
            ResApproveHometaxItemListFromAPI         lo_objResponse      = null;
            ServiceResult<ResApproveHometaxItemList> lo_objResult        = null;

            try
            {
                lo_objResponse = new ResApproveHometaxItemListFromAPI();
                lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

                lo_strAuthirization = SiteGlobal.GetLogislabAPIHeaderAuth();
                lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

                lo_strPostData = "{\"NTS_CONFIRM_NUM\": \"" + strNtsConfirmNum + "\"}";

                lo_objHttp = new HttpAction(SiteGlobal.WS_DOMAIN + CommonConstant.WS_CP_API_COMMAND_GETAPPROVEHOMETAXITEMLIST, lo_objHeader, lo_strPostData);
                lo_objHttp.SendHttpAction();

                lo_intRetVal = lo_objHttp.RetVal;
                if (!lo_intRetVal.Equals(0))
                {
                    lo_objResult.SetResult(lo_intRetVal, $"웹서비스 호출 오류 - {lo_objHttp.ErrMsg}"
                        , 0, $"[{lo_intRetVal}] 웹서비스 호출 오류 - {lo_objHttp.ErrMsg}");
                    return lo_objResult;
                }

                lo_objResponse = JsonConvert.DeserializeObject<ResApproveHometaxItemListFromAPI>(lo_objHttp.ResponseData);

                if (lo_objResponse.Header.ResultCode.IsFail())
                {
                    lo_objResult.SetResult(lo_objResponse.Header.ResultCode, $"웹서비스 호출 오류 - {lo_objResponse.Header.ResultMessage}"
                        , 0, $"[{lo_objResponse.Header.ResultCode}] 웹서비스 호출 오류 - {lo_objResponse.Header.ResultMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data           = new ResApproveHometaxItemList();
                lo_objResult.data.list      = lo_objResponse.Payload.List;
                lo_objResult.data.RecordCnt = lo_objResponse.Payload.ListCount;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9101, "System error(GetApproveHometaxItemList)" + ex.Message);
            }
            finally
            {
                SiteGlobal.WriteInformation("CargopayDasServices", "I", $"[GetApproveHometaxItemList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 계산서 매칭 등록
        /// </summary>
        /// <param name="objReqPreMatchingIns"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPreMatchingIns(ReqPreMatchingIns objReqPreMatchingIns)
        {
            SiteGlobal.WriteInformation("CargopayDasServices", "I", $"[SetPreMatchingIns REQ] {JsonConvert.SerializeObject(objReqPreMatchingIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                //lo_objDas.Open(SiteGlobal.HOST_DAS_CARGOPAY); //[logimanDebug]
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCENTER_CODE",        DBType.adInteger,   objReqPreMatchingIns.CENTER_CODE,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCLOSING_SEQ_NO",     DBType.adVarChar,   objReqPreMatchingIns.CLOSING_SEQ_NO,   30,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strNTS_CONFIRM_NUM",    DBType.adVarChar,   objReqPreMatchingIns.NTS_CONFIRM_NUM,  24,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSEQ_NO",             DBType.adBigInt,    DBNull.Value,                          0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strERR_MSG",            DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRET_VAL",            DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDB_ERR_MSG",         DBType.adVarChar,   DBNull.Value,                          256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDB_RET_VAL",         DBType.adInteger,   DBNull.Value,                          0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORD_PRE_MATCHING_TX_INS");

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
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetPreMatchingIns)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CargopayDasServices", "I", $"[SetPreMatchingIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 계산서 매칭 삭제
        /// </summary>
        /// <param name="objReqPreMatchingDel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetPreMatchingDel(ReqPreMatchingDel objReqPreMatchingDel)
        {
            SiteGlobal.WriteInformation("CargopayDasServices", "I", $"[SetPreMatchingDel REQ] {JsonConvert.SerializeObject(objReqPreMatchingDel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                //lo_objDas.Open(SiteGlobal.HOST_DAS_CARGOPAY); //[logimanDebug]
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCENTER_CODE",     DBType.adInteger,   objReqPreMatchingDel.CENTER_CODE,     0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCLOSING_SEQ_NO",  DBType.adVarChar,   objReqPreMatchingDel.CLOSING_SEQ_NO,  30,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_strERR_MSG",         DBType.adVarChar,   DBNull.Value,                         256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRET_VAL",         DBType.adInteger,   DBNull.Value,                         0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDB_ERR_MSG",      DBType.adVarChar,   DBNull.Value,                         256,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDB_RET_VAL",      DBType.adInteger,   DBNull.Value,                         0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORD_PRE_MATCHING_TX_DEL");

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
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetPreMatchingDel)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CargopayDasServices", "I", $"[SetPreMatchingDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 계산서 항목 목록
        /// </summary>
        /// <param name="objReqApproveHometaxItemList"></param>
        /// <returns></returns>
        public ServiceResult<ResNoMatchTaxList> GetApproveHometaxAPICntGet(int nCenterCode, string strFromYMD, string strToYMD)
        {
            SiteGlobal.WriteInformation("CargopayDasServices", "I", $"[GetApproveHometaxAPICntGet REQ] {nCenterCode},{strFromYMD}, {strToYMD}", bLogWrite);

            string                           lo_strJson   = string.Empty;
            ServiceResult<ResNoMatchTaxList> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResNoMatchTaxList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                //lo_objDas.Open(SiteGlobal.HOST_DAS_CARGOPAY); //[logimanDebug]
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCENTER_CODE", DBType.adInteger, nCenterCode, 0, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFROM_YMD",    DBType.adVarChar, strFromYMD,  8, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strTO_YMD",      DBType.adVarChar, strToYMD,    8, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_APPROVE_HOMETAX_API_CNT_GET");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResNoMatchTaxList
                {
                    list = new Hashtable(),
                    RECORD_CNT = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount.Equals(0))
                {
                    return lo_objResult;
                }

                for (int nLoop = 0; nLoop < lo_objDas.objDT.Rows.Count; nLoop++)
                {
                    lo_objResult.data.list.Add(lo_objDas.objDT.Rows[nLoop]["CorpNo"].ToString(), lo_objDas.objDT.Rows[nLoop]["XMLData"].ToString());
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetApproveHometaxAPICntGet)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }
            }

            return lo_objResult;
        }
    }
}