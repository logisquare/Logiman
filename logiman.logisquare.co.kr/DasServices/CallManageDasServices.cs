using System;
using System.Collections.Generic;
using System.Data;
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using CommonLibrary.Extensions;
using Newtonsoft.Json;
using PBSDasNetCom;

namespace CommonLibrary.DasServices
{
    public class CallManageDasServices
    {
        private bool bLogWrite = SiteGlobal.B_LOG_WRITE;

        /// <summary>
        /// 수신 번호로 수신자 어드민 아이디 조회
        /// </summary>
        /// <param name="objReqCalleeInfoList"></param>
        /// <returns></returns>
        public ServiceResult<ResCalleeInfoList> GetCalleeInfoList(ReqCalleeInfoList objReqCalleeInfoList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCalleeInfoList REQ] {JsonConvert.SerializeObject(objReqCalleeInfoList)}", bLogWrite);

            string                           lo_strJson;
            ServiceResult<ResCalleeInfoList> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCalleeInfoList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strChannelType", DBType.adVarChar, objReqCalleeInfoList.ChannelType, 20, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAuthID",      DBType.adVarChar, objReqCalleeInfoList.AuthID,      50, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPhoneNo",     DBType.adVarChar, objReqCalleeInfoList.PhoneNo,     20, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_CM_CALLEE_INFO_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCalleeInfoList
                {
                    list = new List<CalleeInfoListModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CalleeInfoListModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9101, "System error(GetCalleeInfoList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCalleeInfoList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 수신 번호로 수신자 어드민 아이디 조회(모바일)
        /// </summary>
        /// <param name="objReqCalleeInfoList"></param>
        /// <returns></returns>
        public ServiceResult<ResCalleeInfoList> GetMobileCalleeInfoList(ReqCalleeInfoList objReqCalleeInfoList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetMobileCalleeInfoList REQ] {JsonConvert.SerializeObject(objReqCalleeInfoList)}", bLogWrite);

            string                           lo_strJson;
            ServiceResult<ResCalleeInfoList> lo_objResult = null;
            IDasNetCom                       lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCalleeInfoList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strPhoneNo",     DBType.adVarChar, objReqCalleeInfoList.PhoneNo,     20, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_CM_MOBILE_CALLEE_INFO_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCalleeInfoList
                {
                    list = new List<CalleeInfoListModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CalleeInfoListModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9102, "System error(GetMobileCalleeInfoList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetMobileCalleeInfoList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 발신자 전화 번호 정보 조회
        /// </summary>
        /// <param name="objReqCallerInfoGet"></param>
        /// <returns></returns>
        public ServiceResult<ResCallerInfoGet> GetCallerInfo(ReqCallerInfoGet objReqCallerInfoGet)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCallerInfo REQ] {JsonConvert.SerializeObject(objReqCallerInfoGet)}", bLogWrite);

            ServiceResult<ResCallerInfoGet> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCallerInfoGet>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,  objReqCallerInfoGet.CenterCode, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCustTelNo",        DBType.adVarChar,  objReqCallerInfoGet.CustTelNo,  20,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intCallerType",       DBType.adTinyInt,  DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCallerDetailType", DBType.adTinyInt,  DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCallerDetailText", DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRefSeqNo",         DBType.adBigInt,   DBNull.Value,                   0,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intComCode",          DBType.adBigInt,   DBNull.Value,                   0,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intClientCode",       DBType.adBigInt,   DBNull.Value,                   0,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strName",             DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strComName",          DBType.adVarWChar, DBNull.Value,                   100, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strCorpNo",           DBType.adVarChar,  DBNull.Value,                   20,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCeoName",          DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCarNo",            DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCarTon",           DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCarType",          DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_strPlaceName",        DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPlaceAddr",        DBType.adVarWChar, DBNull.Value,                   500, ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCenterName",       DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPosition",         DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDeptName",         DBType.adVarWChar, DBNull.Value,                   256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_strTaxMsg",           DBType.adVarWChar, DBNull.Value,                   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intClassType",        DBType.adTinyInt,  DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strClientAdminID",    DBType.adVarChar,  DBNull.Value,                   50,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,  DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,  DBNull.Value,                   0,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,  DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,  DBNull.Value,                   0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_CALLER_INFO_NT_GET");

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

                lo_objResult.data = new ResCallerInfoGet
                {
                    CallerType       = lo_objDas.GetParam("@po_intCallerType").ToInt(),
                    CallerDetailType = lo_objDas.GetParam("@po_intCallerDetailType").ToInt(),
                    CallerDetailText = lo_objDas.GetParam("@po_strCallerDetailText"),
                    RefSeqNo         = lo_objDas.GetParam("@po_intRefSeqNo").ToInt64(),
                    ComCode          = lo_objDas.GetParam("@po_intComCode").ToInt64(),
                    ClientCode       = lo_objDas.GetParam("@po_intClientCode").ToInt64(),
                    Name             = lo_objDas.GetParam("@po_strName"),
                    ComName          = lo_objDas.GetParam("@po_strComName"),
                    CorpNo           = lo_objDas.GetParam("@po_strCorpNo"),
                    CeoName          = lo_objDas.GetParam("@po_strCeoName"),
                    CarNo            = lo_objDas.GetParam("@po_strCarNo"),
                    CarTon           = lo_objDas.GetParam("@po_strCarTon"),
                    CarType          = lo_objDas.GetParam("@po_strCarType"),
                    PlaceName        = lo_objDas.GetParam("@po_strPlaceName"),
                    PlaceAddr        = lo_objDas.GetParam("@po_strPlaceAddr"),
                    CenterName       = lo_objDas.GetParam("@po_strCenterName"),
                    Position         = lo_objDas.GetParam("@po_strPosition"),
                    DeptName         = lo_objDas.GetParam("@po_strDeptName"),
                    TaxMsg           = lo_objDas.GetParam("@po_strTaxMsg"),
                    ClassType        = lo_objDas.GetParam("@po_intClassType").ToInt(),
                    ClientAdminID    = lo_objDas.GetParam("@po_strClientAdminID")
                };

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9103, "System error(GetCallerInfo)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCallerInfo RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 - 인/아웃바운드 콜 로그(전체코그 / 상세 내역 포함)
        /// </summary>
        /// <param name="objReqCMLogInboundIns"></param>
        /// <returns></returns>
        public ServiceResult<ResCMLogInboundIns> InsCMLogInbound(ReqCMLogInboundIns objReqCMLogInboundIns)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[InsCMLogInbound REQ] {JsonConvert.SerializeObject(objReqCMLogInboundIns)}", bLogWrite);

            ServiceResult<ResCMLogInboundIns> lo_objResult = null;
            IDasNetCom                        lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMLogInboundIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger,   objReqCMLogInboundIns.CmLog.CenterCode,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallType",         DBType.adTinyInt,   objReqCMLogInboundIns.CmLog.CallType,            0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallKind",         DBType.adVarChar,   objReqCMLogInboundIns.CmLog.CallKind,            10,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChannelType",      DBType.adVarChar,   objReqCMLogInboundIns.CmLog.ChannelType,         20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallNumber",       DBType.adVarChar,   objReqCMLogInboundIns.CmLog.CallNumber,          20,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strSendNumber",       DBType.adVarChar,   objReqCMLogInboundIns.CmLog.SendNumber,          20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendName",         DBType.adVarWChar,  objReqCMLogInboundIns.CmLog.SendName,            256,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRcvNumber",        DBType.adVarChar,   objReqCMLogInboundIns.CmLog.RcvNumber,           20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRcvName",          DBType.adVarWChar,  objReqCMLogInboundIns.CmLog.RcvName,             256,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallSessionID",    DBType.adVarChar,   objReqCMLogInboundIns.CmLog.CallSessionID,       50,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAuthID",           DBType.adVarChar,   objReqCMLogInboundIns.CmLog.AuthID,              50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMessage",          DBType.adVarWChar,  objReqCMLogInboundIns.CmLog.Message,             4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCustTelNo",        DBType.adVarChar,   objReqCMLogInboundIns.CmLogDtl.CustTelNo,        20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerType",       DBType.adTinyInt,   objReqCMLogInboundIns.CmLogDtl.CallerType,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerDetailType", DBType.adTinyInt,   objReqCMLogInboundIns.CmLogDtl.CallerDetailType, 0,    ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCallerDetailText", DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.CallerDetailText, 50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",         DBType.adBigInt,    objReqCMLogInboundIns.CmLogDtl.RefSeqNo,         0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intComCode",          DBType.adBigInt,    objReqCMLogInboundIns.CmLogDtl.ComCode,          0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",       DBType.adBigInt,    objReqCMLogInboundIns.CmLogDtl.ClientCode,       0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strName",             DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.Name,             50,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strComName",          DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.ComName,          100,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCorpNo",           DBType.adVarChar,   objReqCMLogInboundIns.CmLogDtl.CorpNo,           20,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCeoName",          DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.CeoName,          50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarNo",            DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.CarNo,            50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCarTon",           DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.CarTon,           50,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCarType",          DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.CarType,          50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceName",        DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.PlaceName,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPlaceAddr",        DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.PlaceAddr,        50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPosition",         DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.Position,         50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDeptName",         DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.DeptName,         256,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strTaxMsg",           DBType.adVarWChar,  objReqCMLogInboundIns.CmLogDtl.TaxMsg,           50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClassType",        DBType.adTinyInt,   objReqCMLogInboundIns.CmLogDtl.ClassType,        0,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",            DBType.adBigInt,    DBNull.Value,                                    0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCenterCode",       DBType.adInteger,   DBNull.Value,                                    0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",           DBType.adVarChar,   DBNull.Value,                                    256,  ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",           DBType.adInteger,   DBNull.Value,                                    0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",         DBType.adVarChar,   DBNull.Value,                                    256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",         DBType.adInteger,   DBNull.Value,                                    0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_LOG_INBOUND_TX_INS");

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

                lo_objResult.data = new ResCMLogInboundIns
                {
                    SeqNo      = lo_objDas.GetParam("@po_intSeqNo").ToInt64(),
                    CenterCode = lo_objDas.GetParam("@po_intCenterCode").ToInt()
                };

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9104, "System error(InsCMLogInbound)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[InsCMLogInbound RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 발신자 전화 번호 정보 조회
        /// </summary>
        /// <param name="objReqCMOrderTelInfoGet"></param>
        /// <returns></returns>
        public ServiceResult<ResCMOrderTelInfoGet> GetCMOrderTelInfo(ReqCMOrderTelInfoGet objReqCMOrderTelInfoGet)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderTelInfo REQ] {JsonConvert.SerializeObject(objReqCMOrderTelInfoGet)}", bLogWrite);

            ServiceResult<ResCMOrderTelInfoGet> lo_objResult = null;
            IDasNetCom                          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMOrderTelInfoGet>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,  objReqCMOrderTelInfoGet.CenterCode, 0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCustTelNo",           DBType.adVarChar,  objReqCMOrderTelInfoGet.CustTelNo,  20,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intCustType",            DBType.adTinyInt,  DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intOrderTelType",        DBType.adTinyInt,  DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRefSeqNo",            DBType.adBigInt,   DBNull.Value,                       0,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_intComCode",             DBType.adBigInt,   DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_intClientCode",          DBType.adBigInt,   DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strClientName",          DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAdminName",           DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strAdminPosition",       DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDeptName",            DBType.adVarWChar, DBNull.Value,                       256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCarNo",               DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCarDivType",          DBType.adTinyInt,  DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCarDivTypeM",         DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCarTypeCodeM",        DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strCarTonCodeM",         DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDriverCell",          DBType.adVarChar,  DBNull.Value,                       20,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDriverName",          DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_intTaxKind",             DBType.adTinyInt,  DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@@po_strTaxMsg",             DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strComName",             DBType.adVarWChar, DBNull.Value,                       100,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strComCorpNo",           DBType.adVarChar,  DBNull.Value,                       20,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strComCeoName",          DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strCooperatorFlag",      DBType.adChar,     DBNull.Value,                       1,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strChargeName",          DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strChargePosition",      DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strChargeDepartment",    DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strClientType",          DBType.adVarChar,  DBNull.Value,                       5,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strClientTypeM",         DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strClientCorpNo",        DBType.adVarChar,  DBNull.Value,                       20,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strClientCeoName",       DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPlace",               DBType.adVarWChar, DBNull.Value,                       200,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPlaceAddr",           DBType.adVarWChar, DBNull.Value,                       500,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPlaceChargeName",     DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPlaceChargePosition", DBType.adVarWChar, DBNull.Value,                       50,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strClientAdminID",       DBType.adVarChar,  DBNull.Value,                       50,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,  DBNull.Value,                       256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,  DBNull.Value,                       0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,  DBNull.Value,                       256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,  DBNull.Value,                       0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_ORDER_TEL_INFO_NT_GET");

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

                lo_objResult.data = new ResCMOrderTelInfoGet
                {
                    CustType            = lo_objDas.GetParam("@po_intCustType").ToInt(),
                    OrderTelType        = lo_objDas.GetParam("@po_intOrderTelType").ToInt(),
                    RefSeqNo            = lo_objDas.GetParam("@po_intRefSeqNo").ToInt64(),
                    ComCode             = lo_objDas.GetParam("@po_intComCode").ToInt64(),
                    ClientCode          = lo_objDas.GetParam("@po_intClientCode").ToInt64(),
                    ClientName          = lo_objDas.GetParam("@po_strClientName"),
                    AdminName           = lo_objDas.GetParam("@po_strAdminName"),
                    AdminPosition       = lo_objDas.GetParam("@po_strAdminPosition"),
                    DeptName            = lo_objDas.GetParam("@po_strDeptName"),
                    CarNo               = lo_objDas.GetParam("@po_strCarNo"),
                    CarDivType          = lo_objDas.GetParam("@po_intCarDivType").ToInt(),
                    CarDivTypeM         = lo_objDas.GetParam("@po_strCarDivTypeM"),
                    CarTypeCodeM        = lo_objDas.GetParam("@po_strCarTypeCodeM"),
                    CarTonCodeM         = lo_objDas.GetParam("@po_strCarTonCodeM"),
                    DriverCell          = lo_objDas.GetParam("@po_strDriverCell"),
                    DriverName          = lo_objDas.GetParam("@po_strDriverName"),
                    TaxKind             = lo_objDas.GetParam("@po_intTaxKind").ToInt(),
                    TaxMsg              = lo_objDas.GetParam("@po_strTaxMsg"),
                    ComName             = lo_objDas.GetParam("@po_strComName"),
                    ComCorpNo           = lo_objDas.GetParam("@po_strComCorpNo"),
                    ComCeoName          = lo_objDas.GetParam("@po_strComCeoName"),
                    CooperatorFlag      = lo_objDas.GetParam("@po_strCooperatorFlag"),
                    ChargeName          = lo_objDas.GetParam("@po_strChargeName"),
                    ChargePosition      = lo_objDas.GetParam("@po_strChargePosition"),
                    ChargeDepartment    = lo_objDas.GetParam("@po_strChargeDepartment"),
                    ClientType          = lo_objDas.GetParam("@po_strClientType"),
                    ClientTypeM         = lo_objDas.GetParam("@po_strClientTypeM"),
                    ClientCorpNo        = lo_objDas.GetParam("@po_strClientCorpNo"),
                    ClientCeoName       = lo_objDas.GetParam("@po_strClientCeoName"),
                    Place               = lo_objDas.GetParam("@po_strPlace"),
                    PlaceAddr           = lo_objDas.GetParam("@po_strPlaceAddr"),
                    PlaceChargeName     = lo_objDas.GetParam("@po_strPlaceChargeName"),
                    PlaceChargePosition = lo_objDas.GetParam("@po_strPlaceChargePosition"),
                    ClientAdminID       = lo_objDas.GetParam("@po_strClientAdminID")
                };

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9105, "System error(GetCMOrderTelInfo)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderTelInfo RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 계정 정보 조회
        /// </summary>
        /// <param name="objReqAuthInfoList"></param>
        /// <returns></returns>
        public ServiceResult<ResAuthInfoList> GetAuthInfoList(ReqAuthInfoList objReqAuthInfoList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetAuthInfoList REQ] {JsonConvert.SerializeObject(objReqAuthInfoList)}", bLogWrite);

            string                         lo_strJson;
            ServiceResult<ResAuthInfoList> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAuthInfoList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intAuthSeqNo",        DBType.adInteger, objReqAuthInfoList.AuthSeqNo,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger, objReqAuthInfoList.CenterCode,       0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChannelType",      DBType.adVarChar, objReqAuthInfoList.ChannelType,      20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAuthID",           DBType.adVarChar, objReqAuthInfoList.AuthID,           50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqAuthInfoList.AccessCenterCode, 512, ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger, objReqAuthInfoList.PageSize,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger, objReqAuthInfoList.PageNo,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger, DBNull.Value,                        0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_AUTH_INFO_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAuthInfoList
                {
                    list = new List<AuthInfoListModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_objDas.objDT.Columns.Add("MaskAuthPwd", typeof(string));
                    foreach (DataRow row in lo_objDas.objDT.Rows)
                    {
                        row["MaskAuthPwd"] = (string.IsNullOrWhiteSpace(row["AuthPwd"].ToString())) ? "" : "****";
                    }

                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AuthInfoListModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9106, "System error(GetAuthInfoList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetAuthInfoList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 계정정보 등록
        /// </summary>
        /// <param name="objReqAuthInfoIns"></param>
        /// <returns></returns>
        public ServiceResult<ResAuthInfoIns> InsAuthInfo(ReqAuthInfoIns objReqAuthInfoIns)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[InsAuthInfo REQ] {JsonConvert.SerializeObject(objReqAuthInfoIns)}", bLogWrite);

            ServiceResult<ResAuthInfoIns> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAuthInfoIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",  DBType.adInteger,  objReqAuthInfoIns.CenterCode,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChannelType", DBType.adVarChar,  objReqAuthInfoIns.ChannelType, 20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAuthID",      DBType.adVarChar,  objReqAuthInfoIns.AuthID,      50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAuthPwd",     DBType.adVarChar,  objReqAuthInfoIns.AuthPwd,     512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",     DBType.adVarChar,  objReqAuthInfoIns.AdminID,     50,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAdminName",   DBType.adVarWChar, objReqAuthInfoIns.AdminName,   50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_intAuthSeqNo",   DBType.adInteger,  DBNull.Value,                  0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,  DBNull.Value,                  256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,  DBNull.Value,                  0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,  DBNull.Value,                  256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,  DBNull.Value,                  0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_AUTH_INFO_TX_INS");

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

                lo_objResult.data = new ResAuthInfoIns
                {
                    AuthSeqNo = lo_objDas.GetParam("@po_intAuthSeqNo").ToInt()
                };

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9107, "System error(InsAuthInfo)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[InsAuthInfo RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 계정정보 삭제
        /// </summary>
        /// <param name="objReqAuthInfoDel"></param>
        /// <returns></returns>
        public ServiceResult<bool> DelAuthInfo(ReqAuthInfoDel objReqAuthInfoDel)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[DelAuthInfo REQ] {JsonConvert.SerializeObject(objReqAuthInfoDel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode", DBType.adInteger,  objReqAuthInfoDel.CenterCode, 0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAuthSeqNo",  DBType.adInteger,  objReqAuthInfoDel.AuthSeqNo,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarChar,  objReqAuthInfoDel.AdminID,    50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",  DBType.adVarWChar, objReqAuthInfoDel.AdminName,  50,  ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,  DBNull.Value,                 256, ParameterDirection.Output);

                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,  DBNull.Value,                 0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,  DBNull.Value,                 256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,  DBNull.Value,                 0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_AUTH_INFO_TX_DEL");

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
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9108, "System error(DelAuthInfo)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[DelAuthInfo RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 계정 연동 전화번호 조회
        /// </summary>
        /// <param name="objReqAuthPhoneList"></param>
        /// <returns></returns>
        public ServiceResult<ResAuthPhoneList> GetAuthPhoneList(ReqAuthPhoneList objReqAuthPhoneList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetAuthPhoneList REQ] {JsonConvert.SerializeObject(objReqAuthPhoneList)}", bLogWrite);

            string                          lo_strJson;
            ServiceResult<ResAuthPhoneList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAuthPhoneList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPhoneSeqNo",       DBType.adInteger, objReqAuthPhoneList.PhoneSeqNo,       0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAuthIdx",          DBType.adInteger, objReqAuthPhoneList.AuthIdx,          0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPhoneIdx",         DBType.adInteger, objReqAuthPhoneList.PhoneIdx,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAuthSeqNo",        DBType.adInteger, objReqAuthPhoneList.AuthSeqNo,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChannelType",      DBType.adVarChar, objReqAuthPhoneList.ChannelType,      20,  ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strPhoneNo",          DBType.adVarChar, objReqAuthPhoneList.PhoneNo,          20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,    objReqAuthPhoneList.UseFlag,          1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqAuthPhoneList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger, objReqAuthPhoneList.PageSize,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger, objReqAuthPhoneList.PageNo,           0,   ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger, DBNull.Value,                         0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_AUTH_PHONE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAuthPhoneList
                {
                    list = new List<AuthPhoneListModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AuthPhoneListModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9109, "System error(GetAuthPhoneList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetAuthPhoneList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 계정정보/연동전화번호 연동 가능 정보 조회
        /// </summary>
        /// <param name="objReqAuthPhoneAvailList"></param>
        /// <returns></returns>
        public ServiceResult<ResAuthPhoneAvailList> GetAuthPhoneAvailList(ReqAuthPhoneAvailList objReqAuthPhoneAvailList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetAuthPhoneAvailList REQ] {JsonConvert.SerializeObject(objReqAuthPhoneAvailList)}", bLogWrite);

            string                               lo_strJson;
            ServiceResult<ResAuthPhoneAvailList> lo_objResult = null;
            IDasNetCom                           lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAuthPhoneAvailList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intAuthSeqNo",        DBType.adInteger, objReqAuthPhoneAvailList.AuthSeqNo,        0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",       DBType.adInteger, objReqAuthPhoneAvailList.CenterCode,       0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChannelType",      DBType.adVarChar, objReqAuthPhoneAvailList.ChannelType,      20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAuthID",           DBType.adVarChar, objReqAuthPhoneAvailList.AuthID,           50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,    objReqAuthPhoneAvailList.UseFlag,          1,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strAccessCenterCode", DBType.adVarChar, objReqAuthPhoneAvailList.AccessCenterCode, 512, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger, objReqAuthPhoneAvailList.PageSize,         0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger, objReqAuthPhoneAvailList.PageNo,           0,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger, DBNull.Value,                              0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_AUTH_PHONE_AVAIL_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResAuthPhoneAvailList
                {
                    list = new List<AuthPhoneAvailListModel>(), RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<AuthPhoneAvailListModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9110, "System error(GetAuthPhoneAvailList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetAuthPhoneAvailList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 계정정보 연동 전화번호 등록
        /// </summary>
        /// <param name="objReqAuthPhoneIns"></param>
        /// <returns></returns>
        public ServiceResult<ResAuthPhoneIns> InsAuthPhone(ReqAuthPhoneIns objReqAuthPhoneIns)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[InsAuthPhone REQ] {JsonConvert.SerializeObject(objReqAuthPhoneIns)}", bLogWrite);

            ServiceResult<ResAuthPhoneIns> lo_objResult = null;
            IDasNetCom                     lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResAuthPhoneIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",  DBType.adInteger,  objReqAuthPhoneIns.CenterCode,  0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChannelType", DBType.adVarChar,  objReqAuthPhoneIns.ChannelType, 20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAuthID",      DBType.adVarChar,  objReqAuthPhoneIns.AuthID,      50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAuthSeqNo",   DBType.adInteger,  objReqAuthPhoneIns.AuthSeqNo,   0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intAuthIdx",     DBType.adInteger,  objReqAuthPhoneIns.AuthIdx,     0,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPhoneIdx",    DBType.adInteger,  objReqAuthPhoneIns.PhoneIdx,    0,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCreateTs",    DBType.adVarChar,  objReqAuthPhoneIns.CreateTs,    20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPhoneNo",     DBType.adVarChar,  objReqAuthPhoneIns.PhoneNo,     20,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",     DBType.adVarChar,  objReqAuthPhoneIns.AdminID,     50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",   DBType.adVarWChar, objReqAuthPhoneIns.AdminName,   50,  ParameterDirection.Input);

                lo_objDas.AddParam("@po_intPhoneSeqNo",  DBType.adInteger,  DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,  DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",      DBType.adInteger,  DBNull.Value,                   0,   ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,  DBNull.Value,                   256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,  DBNull.Value,                   0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_AUTH_PHONE_TX_INS");

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

                lo_objResult.data = new ResAuthPhoneIns
                {
                    PhoneSeqNo = lo_objDas.GetParam("@po_intPhoneSeqNo").ToInt()
                };

                //Response 값 셋팅
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);
            }
            catch (Exception ex)
            {
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9111, "System error(InsAuthPhone)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[InsAuthPhone RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 계정정보 연동 전화번호 수정
        /// </summary>
        /// <param name="objReqAuthPhoneUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> UpdAuthPhone(ReqAuthPhoneUpd objReqAuthPhoneUpd)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[UpdAuthPhone REQ] {JsonConvert.SerializeObject(objReqAuthPhoneUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intPhoneSeqNo", DBType.adInteger,  objReqAuthPhoneUpd.PhoneSeqNo, 0,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPhoneMemo",  DBType.adVarWChar, objReqAuthPhoneUpd.PhoneMemo,  4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",    DBType.adChar,     objReqAuthPhoneUpd.UseFlag,    1,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",    DBType.adVarChar,  objReqAuthPhoneUpd.AdminID,    50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",  DBType.adVarWChar, objReqAuthPhoneUpd.AdminName,  50,   ParameterDirection.Input);

                lo_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,  DBNull.Value,                  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",     DBType.adInteger,  DBNull.Value,                  0,    ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,  DBNull.Value,                  256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,  DBNull.Value,                  0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_AUTH_PHONE_TX_UPD");

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
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9112, "System error(UpdAuthPhone)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[UpdAuthPhone RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 어드민 설정 정보 등록/수정
        /// </summary>
        /// <param name="objReqCMAdminIns"></param>
        /// <returns></returns>
        public ServiceResult<bool> InsCMAdmin(ReqCMAdminIns objReqCMAdminIns)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[InsCMAdmin REQ] {JsonConvert.SerializeObject(objReqCMAdminIns)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",         DBType.adVarChar, objReqCMAdminIns.AdminID,          50,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strWebAlarmFlag",    DBType.adChar,    objReqCMAdminIns.WebAlarmFlag,     1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPCAlarmFlag",     DBType.adChar,    objReqCMAdminIns.PCAlarmFlag,      1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAutoPopupFlag",   DBType.adChar,    objReqCMAdminIns.AutoPopupFlag,    1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strOrderViewFlag",   DBType.adChar,    objReqCMAdminIns.OrderViewFlag,    1,   ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCompanyViewFlag", DBType.adChar,    objReqCMAdminIns.CompanyViewFlag,  1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPurchaseViewFlag",DBType.adChar,    objReqCMAdminIns.PurchaseViewFlag, 1,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSaleViewFlag",    DBType.adChar,    objReqCMAdminIns.SaleViewFlag,     1,   ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar, DBNull.Value,                      256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",          DBType.adInteger, DBNull.Value,                      0,   ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar, DBNull.Value,                      256, ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger, DBNull.Value,                      0,   ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_ADMIN_TX_INS");

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
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9112, "System error(InsCMAdmin)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[InsCMAdmin RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 콜매니저 관리자 연동 전화 번호 관리
        /// </summary>
        /// <param name="objReqCMAdminPhoneMultiUpd"></param>
        /// <returns></returns>
        public ServiceResult<bool> UpdCMAdminPhoneMulti(ReqCMAdminPhoneMultiUpd objReqCMAdminPhoneMultiUpd)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[UpdCMAdminPhoneMulti REQ] {JsonConvert.SerializeObject(objReqCMAdminPhoneMultiUpd)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",      DBType.adVarChar, objReqCMAdminPhoneMultiUpd.AdminID,      50,   ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPhoneSeqNos",  DBType.adVarChar, objReqCMAdminPhoneMultiUpd.PhoneSeqNos,  4000, ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMainUseFlags", DBType.adVarChar, objReqCMAdminPhoneMultiUpd.MainUseFlags, 4000, ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",       DBType.adVarChar, DBNull.Value,                            256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",       DBType.adInteger, DBNull.Value,                            0,    ParameterDirection.Output);

                lo_objDas.AddParam("@po_strDBErrMsg",     DBType.adVarChar, DBNull.Value,                            256,  ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",     DBType.adInteger, DBNull.Value,                            0,    ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_ADMIN_PHONE_MULTI_TX_UPD");

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
                if (lo_objResult != null)
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE,
                                           CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 9112, "System error(UpdCMAdminPhoneMulti)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[UpdCMAdminPhoneMulti RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }




        /// <summary>
        /// 평가구분 등록(수정)
        /// </summary>
        /// <param name="objReqCMClassifyIns"></param>
        /// <returns></returns>
        public ServiceResult<ResCMClassifyIns> SetCMClassifyIns(ReqCMClassifyIns objReqCMClassifyIns)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[SetCMClassifyIns REQ] {JsonConvert.SerializeObject(objReqCMClassifyIns)}", bLogWrite);

            ServiceResult<ResCMClassifyIns> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMClassifyIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objReqCMClassifyIns.CenterCode,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallerNumber",   DBType.adVarChar,   objReqCMClassifyIns.CallerNumber,    20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClassType",      DBType.adTinyInt,   objReqCMClassifyIns.ClassType,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,   objReqCMClassifyIns.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",      DBType.adVarWChar,  objReqCMClassifyIns.AdminName,       50,      ParameterDirection.Input);
                                                        
                lo_objDas.AddParam("@po_intSeqNo",          DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intClassType",      DBType.adTinyInt,   DBNull.Value,                        0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                        256,     ParameterDirection.Output);
                                                                                                               
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_CLASSIFY_TX_INS");

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

                lo_objResult.data = new ResCMClassifyIns
                {
                    SeqNo     = lo_objDas.GetParam("@po_intSeqNo").ToInt(),
                    ClassType = lo_objDas.GetParam("@po_intClassType").ToInt()
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetCMClassifyIns) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[SetCMClassifyIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사, 고객사 담당자, 상하차지 담당자 오더 조회
        /// </summary>
        /// <param name="objCMOrderList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMOrderList> GetCMOrderList(ReqCMOrderList objCMOrderList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderList REQ] {JsonConvert.SerializeObject(objCMOrderList)}", bLogWrite);

            string                        lo_strJson   = string.Empty;
            ServiceResult<ResCMOrderList> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMOrderList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objCMOrderList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerType",          DBType.adTinyInt,   objCMOrderList.CallerType,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerDetailType",    DBType.adTinyInt,   objCMOrderList.CallerDetailType,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSndTelNo",            DBType.adVarChar,   objCMOrderList.SndTelNo,            20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",          DBType.adBigInt,    objCMOrderList.ClientCode,          0,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@pi_strClientAdminID",       DBType.adVarChar,   objCMOrderList.ClientAdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objCMOrderList.AdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objCMOrderList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objCMOrderList.PageSize,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objCMOrderList.PageNo,              0,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                       0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_ORDER_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMOrderList
                {
                    list      = new List<CMOrderModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMOrderModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMOrderList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 고객사, 고객사 담당자 매출마감 조회
        /// </summary>
        /// <param name="objCMOrderSaleClosingList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMOrderSaleClosingList> GetCMOrderSaleClosingList(ReqCMOrderSaleClosingList objCMOrderSaleClosingList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderSaleClosingList REQ] {JsonConvert.SerializeObject(objCMOrderSaleClosingList)}", bLogWrite);

            string                                   lo_strJson   = string.Empty;
            ServiceResult<ResCMOrderSaleClosingList> lo_objResult = null;
            IDasNetCom                               lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMOrderSaleClosingList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objCMOrderSaleClosingList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerType",          DBType.adTinyInt,   objCMOrderSaleClosingList.CallerType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerDetailType",    DBType.adTinyInt,   objCMOrderSaleClosingList.CallerDetailType,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSndTelNo",            DBType.adVarChar,   objCMOrderSaleClosingList.SndTelNo,             20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intClientCode",          DBType.adBigInt,    objCMOrderSaleClosingList.ClientCode,           0,       ParameterDirection.Input);
                                                                                                                                     
                lo_objDas.AddParam("@pi_strClientAdminID",       DBType.adVarChar,   objCMOrderSaleClosingList.ClientAdminID,        50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objCMOrderSaleClosingList.AdminID,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objCMOrderSaleClosingList.AccessCenterCode,     512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objCMOrderSaleClosingList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objCMOrderSaleClosingList.PageNo,               0,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                                   0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_ORDER_SALE_CLOSING_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMOrderSaleClosingList
                {
                    list      = new List<CMOrderSaleClosingModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMOrderSaleClosingModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMOrderSaleClosingList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderSaleClosingList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 차량, 차량업체 차량 조회
        /// </summary>
        /// <param name="objCMCarDispatchRefList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMCarDispatchRefList> GetCMCarDispatchRefList(ReqCMCarDispatchRefList objCMCarDispatchRefList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMCarDispatchRefList REQ] {JsonConvert.SerializeObject(objCMCarDispatchRefList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResCMCarDispatchRefList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMCarDispatchRefList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objCMCarDispatchRefList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerType",          DBType.adTinyInt,   objCMCarDispatchRefList.CallerType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerDetailType",    DBType.adTinyInt,   objCMCarDispatchRefList.CallerDetailType,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSndTelNo",            DBType.adVarChar,   objCMCarDispatchRefList.SndTelNo,              20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",            DBType.adBigInt,    objCMCarDispatchRefList.RefSeqNo,              0,       ParameterDirection.Input);
                                                                                                                                    
                lo_objDas.AddParam("@pi_intComCode",             DBType.adBigInt,    objCMCarDispatchRefList.ComCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objCMCarDispatchRefList.AdminID,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objCMCarDispatchRefList.AccessCenterCode,      512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objCMCarDispatchRefList.PageSize,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objCMCarDispatchRefList.PageNo,                0,       ParameterDirection.Input);
                                                                 
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_CAR_DISPATCH_REF_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMCarDispatchRefList
                {
                    list      = new List<CMCarDispatchRefModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMCarDispatchRefModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMCarDispatchRefList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMCarDispatchRefList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 차량, 차량업체 오더 조회
        /// </summary>
        /// <param name="objCMOrderDispatchList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMOrderDispatchList> GetCMOrderDispatchList(ReqCMOrderDispatchList objCMOrderDispatchList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderDispatchList REQ] {JsonConvert.SerializeObject(objCMOrderDispatchList)}", bLogWrite);

            string                                lo_strJson   = string.Empty;
            ServiceResult<ResCMOrderDispatchList> lo_objResult = null;
            IDasNetCom                            lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMOrderDispatchList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objCMOrderDispatchList.CenterCode,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerType",          DBType.adTinyInt,   objCMOrderDispatchList.CallerType,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerDetailType",    DBType.adTinyInt,   objCMOrderDispatchList.CallerDetailType,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSndTelNo",            DBType.adVarChar,   objCMOrderDispatchList.SndTelNo,              20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",            DBType.adBigInt,    objCMOrderDispatchList.RefSeqNo,              0,       ParameterDirection.Input);
                                                                                                                                   
                lo_objDas.AddParam("@pi_intComCode",             DBType.adBigInt,    objCMOrderDispatchList.ComCode,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objCMOrderDispatchList.AdminID,               50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objCMOrderDispatchList.AccessCenterCode,      512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objCMOrderDispatchList.PageSize,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objCMOrderDispatchList.PageNo,                0,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                                 0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_ORDER_DISPATCH_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMOrderDispatchList
                {
                    list      = new List<CMOrderDispatchModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMOrderDispatchModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMOrderDispatchList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderDispatchList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 차량, 차량업체 매입마감 조회
        /// </summary>
        /// <param name="objCMOrderPurchaseClosingList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMOrderPurchaseClosingList> GetCMOrderPurchaseClosingList(ReqCMOrderPurchaseClosingList objCMOrderPurchaseClosingList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderPurchaseClosingList REQ] {JsonConvert.SerializeObject(objCMOrderPurchaseClosingList)}", bLogWrite);

            string                                       lo_strJson   = string.Empty;
            ServiceResult<ResCMOrderPurchaseClosingList> lo_objResult = null;
            IDasNetCom                                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMOrderPurchaseClosingList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objCMOrderPurchaseClosingList.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerType",          DBType.adTinyInt,   objCMOrderPurchaseClosingList.CallerType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerDetailType",    DBType.adTinyInt,   objCMOrderPurchaseClosingList.CallerDetailType,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSndTelNo",            DBType.adVarChar,   objCMOrderPurchaseClosingList.SndTelNo,             20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intRefSeqNo",            DBType.adBigInt,    objCMOrderPurchaseClosingList.RefSeqNo,             0,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@pi_intComCode",             DBType.adBigInt,    objCMOrderPurchaseClosingList.ComCode,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objCMOrderPurchaseClosingList.AdminID,              50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objCMOrderPurchaseClosingList.AccessCenterCode,     512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objCMOrderPurchaseClosingList.PageSize,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objCMOrderPurchaseClosingList.PageNo,               0,       ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                                       0,       ParameterDirection.Output);
                
                lo_objDas.SetQuery("dbo.UP_CM_ORDER_PURCHASE_CLOSING_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMOrderPurchaseClosingList
                {
                    list      = new List<CMOrderPurchaseClosingModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMOrderPurchaseClosingModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMOrderPurchaseClosingList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMOrderPurchaseClosingList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 메모, 수발신내역
        /// </summary>
        /// <param name="objCMCallLogList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMCallLogList> GetCMCallLogList(ReqCMCallLogList objCMCallLogList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMCallLogList REQ] {JsonConvert.SerializeObject(objCMCallLogList)}", bLogWrite);

            string                          lo_strJson   = string.Empty;
            ServiceResult<ResCMCallLogList> lo_objResult = null;
            IDasNetCom                      lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMCallLogList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objCMCallLogList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSndTelNo",            DBType.adVarChar,   objCMCallLogList.SndTelNo,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallViewFlag",        DBType.adChar,      objCMCallLogList.CallViewFlag,       1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objCMCallLogList.AdminID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objCMCallLogList.AccessCenterCode,   512,     ParameterDirection.Input);
                                                                
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objCMCallLogList.PageSize,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objCMCallLogList.PageNo,             0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_CALL_LOG_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMCallLogList
                {
                    list      = new List<CMCallLogModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMCallLogModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMCallLogList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMCallLogList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 메모 등록
        /// </summary>
        /// <param name="objReqCMMemoIns"></param>
        /// <returns></returns>
        public ServiceResult<ResCMMemoIns> SetCMMemoIns(ReqCMMemoIns objReqCMMemoIns)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[SetCMMemoIns REQ] {JsonConvert.SerializeObject(objReqCMMemoIns)}", bLogWrite);

            ServiceResult<ResCMMemoIns> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMMemoIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objReqCMMemoIns.CenterCode,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallNumber",           DBType.adVarChar,   objReqCMMemoIns.CallNumber,           20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerType",           DBType.adTinyInt,   objReqCMMemoIns.CallerType,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallerDetailType",     DBType.adTinyInt,   objReqCMMemoIns.CallerDetailType,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallerDetailText",     DBType.adVarWChar,  objReqCMMemoIns.CallerDetailText,     50,      ParameterDirection.Input);
                                                                 
                lo_objDas.AddParam("@pi_strCompanyName",          DBType.adVarWChar,  objReqCMMemoIns.CompanyName,          50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCompanyCeoName",       DBType.adVarWChar,  objReqCMMemoIns.CompanyCeoName,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCompanyChargeName",    DBType.adVarWChar,  objReqCMMemoIns.CompanyChargeName,    50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCompanyMemo",          DBType.adVarWChar,  objReqCMMemoIns.CompanyMemo,          4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",              DBType.adVarChar,   objReqCMMemoIns.AdminID,              50,      ParameterDirection.Input);
                                                                 
                lo_objDas.AddParam("@pi_strAdminName",            DBType.adVarWChar,  objReqCMMemoIns.AdminName,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",                DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",               DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",               DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",             DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                                                                                                                        
                lo_objDas.AddParam("@po_intDBRetVal",             DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_MEMO_TX_INS");

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

                lo_objResult.data = new ResCMMemoIns
                {
                    SeqNo = lo_objDas.GetParam("@po_intSeqNo").ToInt()
                };

            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetCMMemoIns) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[SetCMMemoIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 메모 등록
        /// </summary>
        /// <param name="objReqCMMemoDel"></param>
        /// <returns></returns>
        public ServiceResult<bool> SetCMMemoDel(ReqCMMemoDel objReqCMMemoDel)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[SetCMMemoDel REQ] {JsonConvert.SerializeObject(objReqCMMemoDel)}", bLogWrite);

            ServiceResult<bool> lo_objResult = null;
            IDasNetCom          lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<bool>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",     DBType.adInteger,   objReqCMMemoDel.CenterCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intSeqNo",          DBType.adInteger,   objReqCMMemoDel.SeqNo,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",        DBType.adVarChar,   objReqCMMemoDel.AdminID,       50,      ParameterDirection.Input);
                lo_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar,   DBNull.Value,                  256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",         DBType.adInteger,   DBNull.Value,                  0,       ParameterDirection.Output);
                                                                                                              
                lo_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar,   DBNull.Value,                  256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger,   DBNull.Value,                  0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_MEMO_TX_DEL");

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
                                     , 9101, "System error(SetCMMemoDel) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[SetCMMemoDel RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 관리자 연동 전화번호 조회
        /// </summary>
        /// <param name="objCMAdminPhoneList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMAdminPhoneList> GetCMAdminPhoneList(ReqCMAdminPhoneList objCMAdminPhoneList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMAdminPhoneList REQ] {JsonConvert.SerializeObject(objCMAdminPhoneList)}", bLogWrite);

            string                             lo_strJson   = string.Empty;
            ServiceResult<ResCMAdminPhoneList> lo_objResult = null;
            IDasNetCom                         lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMAdminPhoneList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",          DBType.adVarChar,   objCMAdminPhoneList.AdminID,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPhoneSeqNo",       DBType.adInteger,   objCMAdminPhoneList.PhoneSeqNo,      0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strPhoneNo",          DBType.adVarChar,   objCMAdminPhoneList.PhoneNo,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMainUseFlag",      DBType.adChar,      objCMAdminPhoneList.MainUseFlag,     1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strUseFlag",          DBType.adChar,      objCMAdminPhoneList.UseFlag,         1,       ParameterDirection.Input);
                                                             
                lo_objDas.AddParam("@pi_intPageSize",         DBType.adInteger,   objCMAdminPhoneList.PageSize,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",           DBType.adInteger,   objCMAdminPhoneList.PageNo,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",        DBType.adInteger,   DBNull.Value,                        0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_ADMIN_PHONE_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMAdminPhoneList
                {
                    list      = new List<CMAdminPhoneModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMAdminPhoneModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMAdminPhoneList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMAdminPhoneList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 발신번호 등록 정보
        /// </summary>
        /// <param name="objCMCallerDetailInfoList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMCallerDetailInfoList> GetCMCallerDetailInfoList(ReqCMCallerDetailInfoList objCMCallerDetailInfoList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMCallerDetailInfoList REQ] {JsonConvert.SerializeObject(objCMCallerDetailInfoList)}", bLogWrite);

            string                                   lo_strJson   = string.Empty;
            ServiceResult<ResCMCallerDetailInfoList> lo_objResult = null;
            IDasNetCom                               lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMCallerDetailInfoList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",   DBType.adInteger,  objCMCallerDetailInfoList.CenterCode,  0,  ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCustTelNo",    DBType.adVarChar,  objCMCallerDetailInfoList.CustTelNo,   20, ParameterDirection.Input);

                lo_objDas.SetQuery("dbo.UP_CM_CALLER_DETAIL_INFO_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMCallerDetailInfoList
                {
                    list      = new List<CMJsonParamModel>(),
                    RecordCnt = lo_objDas.RecordCount
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMJsonParamModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMCallerDetailInfoList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMCallerDetailInfoList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 발신번호 등록 정보
        /// </summary>
        /// <param name="objCMMessageSendLogList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMMessageSendLogList> GetCMMessageSendLogList(ReqCMMessageSendLogList objCMMessageSendLogList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMMessageSendLogList REQ] {JsonConvert.SerializeObject(objCMMessageSendLogList)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResCMMessageSendLogList> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMMessageSendLogList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",          DBType.adInteger,   objCMMessageSendLogList.CenterCode,         0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRcvNumber",           DBType.adVarChar,   objCMMessageSendLogList.RcvNumber,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",    DBType.adVarChar,   objCMMessageSendLogList.AccessCenterCode,   512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",            DBType.adInteger,   objCMMessageSendLogList.PageSize,           0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",              DBType.adInteger,   objCMMessageSendLogList.PageNo,             0,       ParameterDirection.Input);

                lo_objDas.AddParam("@po_intRecordCnt",           DBType.adInteger,   DBNull.Value,                               0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_MESSAGE_SEND_LOG_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMMessageSendLogList
                {
                    list      = new List<CMMessageSendLogModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMMessageSendLogModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMMessageSendLogList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMMessageSendLogList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 관리자 설정 정보
        /// </summary>
        /// <param name="objCMAdminList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMAdminList> GetCMAdminList(ReqCMAdminList objCMAdminList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMAdminList REQ] {JsonConvert.SerializeObject(objCMAdminList)}", bLogWrite);

            string                        lo_strJson   = string.Empty;
            ServiceResult<ResCMAdminList> lo_objResult = null;
            IDasNetCom                    lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMAdminList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",      DBType.adVarChar,   objCMAdminList.AdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAppUseFlag",   DBType.adChar,      objCMAdminList.AppUseFlag,   1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",     DBType.adInteger,   objCMAdminList.PageSize,     0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",       DBType.adInteger,   objCMAdminList.PageNo,       0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",    DBType.adInteger,   DBNull.Value,                0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_ADMIN_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMAdminList
                {
                    list      = new List<CMAdminModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMAdminModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMAdminList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMAdminList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 수발신 목록
        /// </summary>
        /// <param name="objCMLogList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMLogList> GetCMLogList(ReqCMLogList objCMLogList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMLogList REQ] {JsonConvert.SerializeObject(objCMLogList)}", bLogWrite);

            string                      lo_strJson   = string.Empty;
            ServiceResult<ResCMLogList> lo_objResult = null;
            IDasNetCom                  lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMLogList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",             DBType.adBigInt,    objCMLogList.SeqNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objCMLogList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",          DBType.adVarChar,   objCMLogList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",            DBType.adVarChar,   objCMLogList.DateTo,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallType",          DBType.adTinyInt,   objCMLogList.CallType,            0,       ParameterDirection.Input);
                                                                                                                     
                lo_objDas.AddParam("@pi_strCallKind",          DBType.adVarChar,   objCMLogList.CallKind,            10,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChannelType",       DBType.adVarChar,   objCMLogList.ChannelType,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallNumber",        DBType.adVarChar,   objCMLogList.CallNumber,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendNumber",        DBType.adVarChar,   objCMLogList.SendNumber,          20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRcvNumber",         DBType.adVarChar,   objCMLogList.RcvNumber,           20,      ParameterDirection.Input);
                                                                                                                     
                lo_objDas.AddParam("@pi_strMessage",           DBType.adVarWChar,  objCMLogList.Message,             4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyPhoneFlag",       DBType.adChar,      objCMLogList.MyPhoneFlag,         1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",           DBType.adVarChar,   objCMLogList.AdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",  DBType.adVarChar,   objCMLogList.AccessCenterCode,    512,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageSize",          DBType.adInteger,   objCMLogList.PageSize,            0,       ParameterDirection.Input);
                                                                                                                     
                lo_objDas.AddParam("@pi_intPageNo",            DBType.adInteger,   objCMLogList.PageNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",         DBType.adInteger,   DBNull.Value,                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_LOG_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMLogList
                {
                    list      = new List<CMLogModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMLogModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMLogList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMLogList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 메모 목록
        /// </summary>
        /// <param name="objCMMemoList"></param>
        /// <returns></returns>
        public ServiceResult<ResCMMemoList> GetCMMemoList(ReqCMMemoList objCMMemoList)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMMemoList REQ] {JsonConvert.SerializeObject(objCMMemoList)}", bLogWrite);

            string                       lo_strJson   = string.Empty;
            ServiceResult<ResCMMemoList> lo_objResult = null;
            IDasNetCom                   lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMMemoList>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intSeqNo",                DBType.adInteger,   objCMMemoList.SeqNo,               0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCenterCode",           DBType.adInteger,   objCMMemoList.CenterCode,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateFrom",             DBType.adVarChar,   objCMMemoList.DateFrom,            8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strDateTo",               DBType.adVarChar,   objCMMemoList.DateTo,              8,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallNumber",           DBType.adVarChar,   objCMMemoList.CallNumber,          20,      ParameterDirection.Input);
                                                                  
                lo_objDas.AddParam("@pi_intCallerType",           DBType.adTinyInt,   objCMMemoList.CallerType,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallerDetailTypes",    DBType.adVarChar,   objCMMemoList.CallerDetailTypes,   1000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCompanyName",          DBType.adVarWChar,  objCMMemoList.CompanyName,         50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCompanyCeoName",       DBType.adVarWChar,  objCMMemoList.CompanyCeoName,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCompanyChargeName",    DBType.adVarWChar,  objCMMemoList.CompanyChargeName,   50,      ParameterDirection.Input);

                lo_objDas.AddParam("@pi_strCompanyMemo",          DBType.adVarWChar,  objCMMemoList.CompanyMemo,         4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminName",            DBType.adVarWChar,  objCMMemoList.AdminName,           50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMyMemoFlag",           DBType.adChar,      objCMMemoList.MyMemoFlag,          1,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAdminID",              DBType.adVarChar,   objCMMemoList.AdminID,             50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strAccessCenterCode",     DBType.adVarChar,   objCMMemoList.AccessCenterCode,    512,     ParameterDirection.Input);

                lo_objDas.AddParam("@pi_intPageSize",             DBType.adInteger,   objCMMemoList.PageSize,            0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intPageNo",               DBType.adInteger,   objCMMemoList.PageNo,              0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_intRecordCnt",            DBType.adInteger,   DBNull.Value,                      0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_MEMO_AR_LST");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMMemoList
                {
                    list      = new List<CMMemoModel>(),
                    RecordCnt = lo_objDas.GetParam("@po_intRecordCnt").ToInt()
                };

                if (lo_objDas.RecordCount > 0)
                {
                    lo_strJson             = JsonConvert.SerializeObject(lo_objDas.objDT.Rows[0].Table);
                    lo_objResult.data.list = JsonConvert.DeserializeObject<List<CMMemoModel>>(lo_strJson);
                }
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMMemoList)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMMemoList RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 메뉴별 권한 체크
        /// </summary>
        /// <param name="objCMAdminMenuAccessChk"></param>
        /// <returns></returns>
        public ServiceResult<ResCMAdminMenuAccessChk> GetCMAdminMenuAccessChk(ReqCMAdminMenuAccessChk objCMAdminMenuAccessChk)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMAdminMenuAccessChk REQ] {JsonConvert.SerializeObject(objCMAdminMenuAccessChk)}", bLogWrite);

            string                                 lo_strJson   = string.Empty;
            ServiceResult<ResCMAdminMenuAccessChk> lo_objResult = null;
            IDasNetCom                             lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMAdminMenuAccessChk>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_strAdminID",             DBType.adVarChar,   objCMAdminMenuAccessChk.AdminID,      50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intGradeCode",           DBType.adTinyInt,   objCMAdminMenuAccessChk.GradeCode,    0,       ParameterDirection.Input);
                lo_objDas.AddParam("@po_strOrderViewFlag",       DBType.adChar,      DBNull.Value,                         1,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strSaleViewFlag",        DBType.adChar,      DBNull.Value,                         1,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strPurchaseViewFlag",    DBType.adChar,      DBNull.Value,                         1,       ParameterDirection.Output);
                                                                                                                       
                lo_objDas.AddParam("@po_strCompanyViewFlag",     DBType.adChar,      DBNull.Value,                         1,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intRetVal",              DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,   DBNull.Value,                         256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,   DBNull.Value,                         0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_ADMIN_MENU_ACCESS_NT_CHK");

                //DAS 통신 실패이면 오류로 리턴
                if (lo_objDas.LastErrorCode.IsFail())
                {
                    lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                         , 0, $"[{lo_objDas.LastErrorCode}]{lo_objDas.LastErrorMessage}");
                    return lo_objResult;
                }

                //Response 값 셋팅                
                lo_objResult.SetResult(CommonConstant.DAS_SUCCESS_CODE);

                lo_objResult.data = new ResCMAdminMenuAccessChk
                {
                    OrderViewFlag    = lo_objDas.GetParam("@po_strOrderViewFlag"),
                    SaleViewFlag     = lo_objDas.GetParam("@po_strSaleViewFlag"),
                    PurchaseViewFlag = lo_objDas.GetParam("@po_strPurchaseViewFlag"),
                    CompanyViewFlag  = lo_objDas.GetParam("@po_strCompanyViewFlag")
                };
            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(GetCMAdminMenuAccessChk)" + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[GetCMAdminMenuAccessChk RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }

        /// <summary>
        /// 로그등록
        /// </summary>
        /// <param name="objReqCMLogIns"></param>
        /// <returns></returns>
        public ServiceResult<ResCMLogIns> SetCMLogIns(ReqCMLogIns objReqCMLogIns)
        {
            SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[SetCMLogIns REQ] {JsonConvert.SerializeObject(objReqCMLogIns)}", bLogWrite);

            ServiceResult<ResCMLogIns> lo_objResult = null;
            IDasNetCom                 lo_objDas    = null;

            try
            {
                lo_objResult = new ServiceResult<ResCMLogIns>(CommonConstant.DAS_RET_VAL_CODE);
                lo_objDas    = new IDasNetCom();

                lo_objDas.Open(SiteGlobal.HOST_DAS);
                lo_objDas.CommandType = CommandType.StoredProcedure;

                lo_objDas.AddParam("@pi_intCenterCode",        DBType.adInteger,   objReqCMLogIns.CenterCode,        0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_intCallType",          DBType.adTinyInt,   objReqCMLogIns.CallType,          0,       ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallKind",          DBType.adVarChar,   objReqCMLogIns.CallKind,          10,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strChannelType",       DBType.adVarChar,   objReqCMLogIns.ChannelType,       20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallNumber",        DBType.adVarChar,   objReqCMLogIns.CallNumber,        20,      ParameterDirection.Input);
                                                              
                lo_objDas.AddParam("@pi_strSendNumber",        DBType.adVarChar,   objReqCMLogIns.SendNumber,        20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strSendName",          DBType.adVarWChar,  objReqCMLogIns.SendName,          256,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRcvNumber",         DBType.adVarChar,   objReqCMLogIns.RcvNumber,         20,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strRcvName",           DBType.adVarWChar,  objReqCMLogIns.RcvName,           256,     ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strCallSessionID",     DBType.adVarChar,   objReqCMLogIns.CallSessionID,     50,      ParameterDirection.Input);
                                                              
                lo_objDas.AddParam("@pi_strAuthID",            DBType.adVarChar,   objReqCMLogIns.AuthID,            50,      ParameterDirection.Input);
                lo_objDas.AddParam("@pi_strMessage",           DBType.adVarWChar,  objReqCMLogIns.Message,           4000,    ParameterDirection.Input);
                lo_objDas.AddParam("@po_intSeqNo",             DBType.adBigInt,    DBNull.Value,                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_intCenterCode",        DBType.adInteger,   DBNull.Value,                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar,   DBNull.Value,                     256,     ParameterDirection.Output);
                                                              
                lo_objDas.AddParam("@po_intRetVal",            DBType.adInteger,   DBNull.Value,                     0,       ParameterDirection.Output);
                lo_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar,   DBNull.Value,                     256,     ParameterDirection.Output);
                lo_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger,   DBNull.Value,                     0,       ParameterDirection.Output);

                lo_objDas.SetQuery("dbo.UP_CM_LOG_TX_INS");

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

                lo_objResult.data = new ResCMLogIns
                {
                    SeqNo      = lo_objDas.GetParam("@po_intSeqNo"),
                    CenterCode = lo_objDas.GetParam("@po_intCenterCode").ToInt()
                };

            }
            catch (Exception ex)
            {
                lo_objResult.SetResult(CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_CODE, CommonConstant.DAS_DATA_ACCESS_SERVICE_ERR_MESSAGE
                                     , 9101, "System error(SetCMLogIns) " + ex.Message);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.CloseTable();
                    lo_objDas.Close();
                }

                SiteGlobal.WriteInformation("CallManageDasServices", "I", $"[SetCMLogIns RES] {JsonConvert.SerializeObject(lo_objResult)}", bLogWrite);
            }

            return lo_objResult;
        }
    }
}