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
    public class MsgDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 메시지 전송 로그 목록
        /// </summary>
        /// <param name="objReqMsgSendLogList"></param>
        /// <returns></returns>
        public ServiceResult<ResMsgSendLogList> GetMsgSendLogList(ReqMsgSendLogList objReqMsgSendLogList)
        {
            SiteGlobal.WriteInformation("MsgDasServices", "I", $"[GetMsgSendLogList REQ] {JsonConvert.SerializeObject(objReqMsgSendLogList)}", bLogWrite);
            
            string                           lo_strJson   = string.Empty;
            ServiceResult<ResMsgSendLogList> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResMsgSendLogList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",            DBType.adInteger, objReqMsgSendLogList.SeqNo,            0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger, objReqMsgSendLogList.CenterCode,       0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intMsgType",          DBType.adTinyInt, objReqMsgSendLogList.MsgType,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRcvNum",           DBType.adVarChar, objReqMsgSendLogList.RcvNum,           20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendNum",          DBType.adVarChar, objReqMsgSendLogList.SendNum,          20,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intRetCodeType",      DBType.adTinyInt, objReqMsgSendLogList.RetCodeType,      0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strFromYMD",          DBType.adVarChar, objReqMsgSendLogList.FromYMD,          8,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strToYMD",            DBType.adVarChar, objReqMsgSendLogList.ToYMD,            8,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqMsgSendLogList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger, objReqMsgSendLogList.PageSize,         0,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger, objReqMsgSendLogList.PageNo,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger, DBNull.Value,                          0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_MSG_SEND_LOG_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResMsgSendLogList
                {
                    list      = new List<MsgSendLogViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<MsgSendLogViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult?.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                    CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9101, "System error(GetMsgSendLogList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MsgDasServices", "I", $"[GetMsgSendLogList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 문자 즐겨찾기 리스트
        /// </summary>
        /// <param name="objReqMsgSendLogList"></param>
        /// <returns></returns>
        public ServiceResult<ResSmsContentList> GetSmsContentList(ReqSmsContentList objReqSmsContentList)
        {
            SiteGlobal.WriteInformation("MsgDasServices", "I", $"[GetSmsContentList REQ] {JsonConvert.SerializeObject(objReqSmsContentList)}", bLogWrite);

            string                           lo_strJson   = string.Empty;
            ServiceResult<ResSmsContentList> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSmsContentList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSmsSeqNo",       DBType.adBigInt,    objReqSmsContentList.SmsSeqNo,      0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,   objReqSmsContentList.AdminID,       50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDelFlag",        DBType.adChar,      objReqSmsContentList.DelFlag,       1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSmsSendCell",    DBType.adVarChar,   objReqSmsContentList.SmsSendCell,   20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSmsTitle",       DBType.adVarWChar,  objReqSmsContentList.SmsTitle,      150, ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,   DBNull.Value,                       0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SMS_CONTENT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResSmsContentList
                {
                    list      = new List<SmsContentViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SmsContentViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult?.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                    CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9102, "System error(GetSmsContentList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MsgDasServices", "I", $"[GetSmsContentList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<SmsContentModel> InsSmsContent(SmsContentModel objInsSmsContentModel)
        {
            SiteGlobal.WriteInformation("MsgDasServices", "I", $"[InsSmsContent REQ] {JsonConvert.SerializeObject(objInsSmsContentModel)}", bLogWrite);

            ServiceResult<SmsContentModel> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<SmsContentModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strSmsSendCell",    DBType.adVarChar,   objInsSmsContentModel.SmsSendCell,     20,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSmsTitle",       DBType.adVarWChar,  objInsSmsContentModel.SmsTitle,        150,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSmsContent",     DBType.adVarWChar,  objInsSmsContentModel.SmsContent,      4000,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,   objInsSmsContentModel.AdminID,         50,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSmsSeqNo",       DBType.adInteger,   DBNull.Value,                          0,     ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                          256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                          0,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                          256,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                          0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SMS_CONTENT_TX_INS");

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
                                     , 9102, "System error(InsSmsContent) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MsgDasServices", "I", $"[InsSmsContent RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<SmsContentModel> DelSmsContent(SmsContentModel objInsSmsContentModel)
        {
            SiteGlobal.WriteInformation("MsgDasServices", "I", $"[DelSmsContent REQ] {JsonConvert.SerializeObject(objInsSmsContentModel)}", bLogWrite);

            ServiceResult<SmsContentModel> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<SmsContentModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSmsSeqNo",     DBType.adInteger,   objInsSmsContentModel.SmsSeqNo,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",      DBType.adVarChar,   objInsSmsContentModel.AdminID,     50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar,   DBNull.Value,                      256,     ParameterDirection.Output);
                                                          
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_SMS_CONTENT_TX_DEL");

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
                                     , 9102, "System error(DelSmsContent) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MsgDasServices", "I", $"[DelSmsContent RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<SmsContentModel> InsSmsSendRequest(SmsContentModel objInsSmsContentModel)
        {
            SiteGlobal.WriteInformation("MsgDasServices", "I", $"[InsSmsSendRequest REQ] {JsonConvert.SerializeObject(objInsSmsContentModel)}", bLogWrite);

            ServiceResult<SmsContentModel> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<SmsContentModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,   objInsSmsContentModel.CenterCode,   0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendNum",    DBType.adVarChar,   objInsSmsContentModel.SmsSendCell,  20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRcvNum",     DBType.adVarChar,   objInsSmsContentModel.DriverCells,  20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRcvName",    DBType.adVarWChar,  objInsSmsContentModel.DriverName,   50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSubject",    DBType.adVarWChar,  objInsSmsContentModel.SmsTitle,     50,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strContents",   DBType.adVarWChar,  objInsSmsContentModel.SmsContent,   4000, ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",      DBType.adBigInt,    DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,   DBNull.Value,                       256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,   DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,   DBNull.Value,                       256,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,   DBNull.Value,                       0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_MSG_SEND_REQUEST_XMS_TX_INS");

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
                                     , 9102, "System error(InsSmsSendRequest) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                    lo_objDas = null;
                }

                SiteGlobal.WriteInformation("MsgDasServices", "I", $"[InsSmsSendRequest RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<KakaoTalkModel> InsKakaoSendRequest(KakaoTalkModel objInsKakaoTalkModel)
        {
            SiteGlobal.WriteInformation("MsgDasServices", "I", $"[InsKakaoSendRequest REQ] {JsonConvert.SerializeObject(objInsKakaoTalkModel)}", bLogWrite);

            ServiceResult<KakaoTalkModel> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<KakaoTalkModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",         DBType.adInteger,       objInsKakaoTalkModel.CenterCode,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSendType",           DBType.adTinyInt,       objInsKakaoTalkModel.SendType,             0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,        objInsKakaoTalkModel.OrderNo,              0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",           DBType.adBigInt,        objInsKakaoTalkModel.RefSeqNo,             0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupYMD",          DBType.adVarChar,       objInsKakaoTalkModel.PickupYMD,            8,   ParameterDirection.Input);
                                                                                                                                   
                lo_objDas.AddParam("@pi_strPickupHM",           DBType.adVarChar,       objInsKakaoTalkModel.PickupHM,             4,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddr",    DBType.adVarWChar,      objInsKakaoTalkModel.PickupPlaceAddr,      100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPickupPlaceAddrDtl", DBType.adVarWChar,      objInsKakaoTalkModel.PickupPlaceAddrDtl,   100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetYMD",             DBType.adVarChar,       objInsKakaoTalkModel.GetYMD,               8,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetHM",              DBType.adVarChar,       objInsKakaoTalkModel.GetHM,                4,   ParameterDirection.Input);
                                                                                                                                   
                lo_objDas.AddParam("@pi_strGetPlaceAddr",       DBType.adVarWChar,      objInsKakaoTalkModel.GetPlaceAddr,         100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strGetPlaceAddrDtl",    DBType.adVarWChar,      objInsKakaoTalkModel.GetPlaceAddrDtl,      100, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRegAdminID",         DBType.adVarChar,       objInsKakaoTalkModel.RegAdminID,           50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",              DBType.adBigInt,        DBNull.Value,                              0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,       DBNull.Value,                              256, ParameterDirection.Output);
                                                                                                                                   
                lo_objDas.AddParam("@po_intRetVal",             DBType.adInteger,       DBNull.Value,                              0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,       DBNull.Value,                              256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,       DBNull.Value,                              0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_DISPATCH_KAKAO_TX_INS");

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

                objInsKakaoTalkModel.SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt();
                lo_objResult.data          = objInsKakaoTalkModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9102, "System error(InsKakaoSendRequest) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MsgDasServices", "I", $"[InsKakaoSendRequest RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        public ServiceResult<SmsContentModel> InsCertSendRequest(SmsContentModel objInsSmsContentModel)
        {
            SiteGlobal.WriteInformation("MsgDasServices", "I", $"[InsCertSendRequest REQ] {JsonConvert.SerializeObject(objInsSmsContentModel)}", bLogWrite);

            ServiceResult<SmsContentModel> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<SmsContentModel>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,   objInsSmsContentModel.CenterCode,   0,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderNos",   DBType.adVarChar,   objInsSmsContentModel.OrderNos,     8000,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendUrl",    DBType.adVarWChar,  objInsSmsContentModel.SendUrl,      256,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendNum",    DBType.adVarChar,   objInsSmsContentModel.SendNum,      20,     ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSuccCnt",    DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);

                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,   DBNull.Value,                       256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,   DBNull.Value,                       256,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_MSG_SEND_REQUEST_CERT_TX_INS");

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

                objInsSmsContentModel.SuccCnt = lo_objDas.GetParam("@po_intSuccCnt").ToInt();
                lo_objResult.data             = objInsSmsContentModel;
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9102, "System error(InsCertSendRequest) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MsgDasServices", "I", $"[InsCertSendRequest RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 표준화물위탁증 SMS
        /// </summary>
        /// <param name="objReqSmsContentList"></param>
        /// <returns></returns>
        public ServiceResult<ResSmsContentList> GetOrderCertList(ReqSmsContentList objReqSmsContentList)
        {
            SiteGlobal.WriteInformation("MsgDasServices", "I", $"[GetOrderCertList REQ] {JsonConvert.SerializeObject(objReqSmsContentList)}", bLogWrite);

            string                           lo_strJson   = string.Empty;
            ServiceResult<ResSmsContentList> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResSmsContentList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intOrderNo",        DBType.adBigInt,  objReqSmsContentList.OrderNo,    0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger, DBNull.Value,                    0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_ORDER_CERT_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResSmsContentList
                {
                    list      = new List<SmsContentViewModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<SmsContentViewModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult?.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                    CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                    , 9908, "System error(GetOrderCertList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("MsgDasServices", "I", $"[GetOrderCertList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

    }
}