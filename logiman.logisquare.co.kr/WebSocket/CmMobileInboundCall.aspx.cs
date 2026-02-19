using System;
using System.IO;
using System.Linq;
using System.Web;
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;

namespace WebSocket
{
    public partial class CmMobileInboundCall : System.Web.UI.Page
    {
        private readonly CallManageDasServices objCallManageDasServices = new CallManageDasServices();
        private const    string                objJosnString            = "{{\"ResultCode\":{0},\"ResultMessage\":\"{1}\"}}";
        private CMMobileInboundCallView objCMMobileInboundCallView;

        protected void Page_Load(object sender, EventArgs e)
        {
            HttpContext.Current.Response.ContentType = "application/json";

            ResponseMap                       lo_objResMap   = new ResponseMap();
            ServiceResult<ResCalleeInfoList>  lo_objResCalleeInfoList;

            long   lo_intLogSeqNo = 0;
            string lo_strAdminName;

            try
            {
                if (IsPostBack) return;

                //Step0. 요청 정보 파싱
                lo_objResMap = SetInitData();
                if (lo_objResMap.RetCode.IsFail())
                {
                    return;
                }

                //Step1. 수신자 정보 조회
                lo_objResCalleeInfoList = GetMobileCalleeInfoList();
                if (lo_objResCalleeInfoList.result.ErrorCode.IsFail())
                {
                    lo_objResMap.RetCode = lo_objResCalleeInfoList.result.ErrorCode;
                    lo_objResMap.ErrMsg  = lo_objResCalleeInfoList.result.ErrorMsg;
                    return;
                }

                if (lo_objResCalleeInfoList.data.RecordCnt.Equals(0))
                {
                    lo_objResMap.RetCode = 0;
                    lo_objResMap.ErrMsg  = "수신자 전화번호 없음";
                    return;
                }

                //Step3. CallManager Log 등록
                lo_strAdminName = lo_objResCalleeInfoList.data.RecordCnt.Equals(1)
                    ? lo_objResCalleeInfoList.data.list[0].AdminName
                    : $"{lo_objResCalleeInfoList.data.list[0].AdminName} 외 {lo_objResCalleeInfoList.data.RecordCnt - 1}명";

                if (!objCMMobileInboundCallView.CallerType.Equals(4))
                {
                    lo_objResMap = CMLogInboundIns(lo_strAdminName, out lo_intLogSeqNo);
                    if (lo_objResMap.RetCode.IsFail())
                    {
                        return;
                    }
                }

                //Step4. SignalR Noti....
                lo_objResMap = SendNoti(lo_intLogSeqNo, lo_objResCalleeInfoList);

            }
            catch (Exception lo_ex)
            {
                lo_objResMap.RetCode = 9401;
                lo_objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("WebSocket", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    lo_objResMap.RetCode);
            }
            finally
            {
                //3. 결과 출력 - 종료
                WriteJsonResponse(lo_objResMap);
            }
        }

        ///--------------------------------------------
        /// <summary>
        /// 수진자 정보 리스트 조회
        /// </summary>
        ///--------------------------------------------
        private ResponseMap SetInitData()
        {
            string      lo_strJsonBody;
            ResponseMap lo_objResMap   = new ResponseMap();

            try
            {
                using (var reader = new StreamReader(Request.InputStream))
                {
                    lo_strJsonBody = reader.ReadToEnd();
                }

                // 파싱
                if (!string.IsNullOrEmpty(lo_strJsonBody))
                {
                    objCMMobileInboundCallView = JsonConvert.DeserializeObject<CMMobileInboundCallView>(lo_strJsonBody);
                }
                else
                {
                    lo_objResMap.RetCode = 9999;
                    lo_objResMap.ErrMsg  = "요청정보가 없습니다.";
                    return lo_objResMap;
                }

                if (string.IsNullOrWhiteSpace(objCMMobileInboundCallView.ChannelType) || objCMMobileInboundCallView.ChannelType.Equals(""))
                {
                    lo_objResMap.RetCode = 9001;
                    lo_objResMap.ErrMsg  = "필요한 값이 없습니다.(채널타입)";
                    return lo_objResMap;
                }

                if (string.IsNullOrWhiteSpace(objCMMobileInboundCallView.SendNumber) || objCMMobileInboundCallView.SendNumber.Equals(""))
                {
                    lo_objResMap.RetCode = 9002;
                    lo_objResMap.ErrMsg  = "필요한 값이 없습니다.(발신자번호)";
                    return lo_objResMap;
                }

                if (string.IsNullOrWhiteSpace(objCMMobileInboundCallView.RcvNumber) || objCMMobileInboundCallView.RcvNumber.Equals(""))
                {
                    lo_objResMap.RetCode = 9003;
                    lo_objResMap.ErrMsg  = "필요한 값이 없습니다.(수신자번호)";
                    return lo_objResMap;
                }

            }
            catch (Exception lo_ex)
            {
                lo_objResMap.RetCode = 9404;
                lo_objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("WebSocket", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    lo_objResMap.RetCode);
            }

            return lo_objResMap;
        }

        ///--------------------------------------------
        /// <summary>
        /// 수진자 정보 리스트 조회
        /// </summary>
        ///--------------------------------------------
        private ServiceResult<ResCalleeInfoList> GetMobileCalleeInfoList()
        {
            ReqCalleeInfoList                lo_objReqCalleeInfoList;
            ServiceResult<ResCalleeInfoList> lo_objResCalleeInfoList = null;

            try
            {
                lo_objReqCalleeInfoList = new ReqCalleeInfoList
                {
                    PhoneNo     = objCMMobileInboundCallView.RcvNumber
                };

                lo_objResCalleeInfoList = objCallManageDasServices.GetMobileCalleeInfoList(lo_objReqCalleeInfoList);
            }
            catch (Exception lo_ex)
            {
                if (lo_objResCalleeInfoList == null)
                {
                    lo_objResCalleeInfoList = new ServiceResult<ResCalleeInfoList>(CommonConstant.DAS_RET_VAL_CODE);
                }

                lo_objResCalleeInfoList.result.ErrorCode = 9410;
                lo_objResCalleeInfoList.result.ErrorMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("WebSocket", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    lo_objResCalleeInfoList.result.ErrorCode);
            }

            return lo_objResCalleeInfoList;
        }

        ///--------------------------------------------
        /// <summary>
        /// 인/아웃바운드 콜 로그 전체 등록
        /// </summary>
        ///--------------------------------------------
        private ResponseMap CMLogInboundIns(string lo_strAdminName, out long lo_intLogSeqNo)
        {
            ResponseMap                       lo_objResMap             = new ResponseMap();
            ReqCMLogInboundIns                lo_objReqCMLogInboundIns;
            ServiceResult<ResCMLogInboundIns> lo_objResCMLogInboundIns;
            CMLogView                         lo_objCmLog;
            CMLogDtlView                      lo_objCmLogDtl;
            string                            lo_strSendName;

            lo_intLogSeqNo = 0;

            try
            {
                lo_strSendName = $"[{objCMMobileInboundCallView.CallerDetailText}] {objCMMobileInboundCallView.Name}";
                if (!string.IsNullOrWhiteSpace(objCMMobileInboundCallView.ComName) && !objCMMobileInboundCallView.ComName.Equals(objCMMobileInboundCallView.Name))
                {
                    lo_strSendName += " / " + objCMMobileInboundCallView.ComName;
                }

                lo_objCmLog = new CMLogView
                {
                    CenterCode    = objCMMobileInboundCallView.CenterCode.ToInt(),
                    CallType      = 1,
                    CallKind      = "call",
                    ChannelType   = objCMMobileInboundCallView.ChannelType,
                    CallNumber    = objCMMobileInboundCallView.SendNumber,
                    SendNumber    = objCMMobileInboundCallView.SendNumber,
                    SendName      = lo_strSendName,
                    RcvNumber     = objCMMobileInboundCallView.RcvNumber,
                    RcvName       = lo_strAdminName,
                    Message       = objCMMobileInboundCallView.Message
                };

                lo_objCmLogDtl = new CMLogDtlView
                {
                    CustTelNo        = objCMMobileInboundCallView.SendNumber,
                    CallerType       = objCMMobileInboundCallView.CallerType,
                    CallerDetailType = objCMMobileInboundCallView.CallerDetailType,
                    CallerDetailText = objCMMobileInboundCallView.CallerDetailText,
                    RefSeqNo         = objCMMobileInboundCallView.RefSeqNo,
                    ComCode          = objCMMobileInboundCallView.ComCode,
                    ClientCode       = objCMMobileInboundCallView.ClientCode,
                    Name             = objCMMobileInboundCallView.Name,
                    ComName          = objCMMobileInboundCallView.ComName,
                    CorpNo           = objCMMobileInboundCallView.CorpNo,
                    CeoName          = objCMMobileInboundCallView.CeoName,
                    CarNo            = objCMMobileInboundCallView.CarNo,
                    CarTon           = objCMMobileInboundCallView.CarTon,
                    CarType          = objCMMobileInboundCallView.CarType,
                    PlaceName        = objCMMobileInboundCallView.PlaceName,
                    PlaceAddr        = objCMMobileInboundCallView.PlaceAddr,
                    Position         = objCMMobileInboundCallView.Position,
                    DeptName         = objCMMobileInboundCallView.DeptName,
                    TaxMsg           = objCMMobileInboundCallView.TaxMsg,
                    ClassType        = objCMMobileInboundCallView.ClassType
                };

                lo_objReqCMLogInboundIns = new ReqCMLogInboundIns
                {
                    CmLog    = lo_objCmLog,
                    CmLogDtl = lo_objCmLogDtl
                };

                lo_objResCMLogInboundIns = objCallManageDasServices.InsCMLogInbound(lo_objReqCMLogInboundIns);
                if (lo_objResCMLogInboundIns.result.ErrorCode.IsFail())
                {
                    lo_objResMap.RetCode = lo_objResCMLogInboundIns.result.ErrorCode;
                    lo_objResMap.ErrMsg  = lo_objResCMLogInboundIns.result.ErrorMsg;
                    return lo_objResMap;
                }

                lo_intLogSeqNo = lo_objResCMLogInboundIns.data.SeqNo;
            }
            catch (Exception lo_ex)
            {
                lo_objResMap.RetCode = 9420;
                lo_objResMap.ErrMsg = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("WebSocket", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    lo_objResMap.RetCode);
            }

            return lo_objResMap;
        }

        ///--------------------------------------------
        /// <summary>
        /// SignalR Noti 전송
        /// </summary>
        ///--------------------------------------------
        private ResponseMap SendNoti(long lo_LogSeqNo, ServiceResult<ResCalleeInfoList> lo_objResCalleeInfoList)
        {
            ResponseMap lo_objResMap       = new ResponseMap();
            string      lo_strJsonParam;

            try
            {
                CMJsonParamModel lo_objJsonParam = new CMJsonParamModel
                {
                    SeqNo            = lo_LogSeqNo.ToString(),
                    CenterCode       = objCMMobileInboundCallView.CenterCode.ToInt(),
                    SndTelNo         = objCMMobileInboundCallView.SendNumber,
                    RcvTelNo         = objCMMobileInboundCallView.RcvNumber,
                    CallerType       = objCMMobileInboundCallView.CallerType,
                    CallerDetailType = objCMMobileInboundCallView.CallerDetailType,
                    CallerDetailText = objCMMobileInboundCallView.CallerDetailText,
                    RefSeqNo         = objCMMobileInboundCallView.RefSeqNo.ToString(),
                    ComCode          = objCMMobileInboundCallView.ComCode.ToString(),
                    ClientCode       = objCMMobileInboundCallView.ClientCode.ToString(),
                    Name             = objCMMobileInboundCallView.Name,
                    ComName          = objCMMobileInboundCallView.ComName,
                    CorpNo           = objCMMobileInboundCallView.CorpNo,
                    CeoName          = objCMMobileInboundCallView.CeoName,
                    CarNo            = objCMMobileInboundCallView.CarNo,
                    CarTon           = objCMMobileInboundCallView.CarTon,
                    CarType          = objCMMobileInboundCallView.CarType,
                    PlaceName        = objCMMobileInboundCallView.PlaceName,
                    PlaceAddr        = objCMMobileInboundCallView.PlaceAddr,
                    CenterName       = objCMMobileInboundCallView.CenterName,
                    Position         = objCMMobileInboundCallView.Position,
                    DeptName         = objCMMobileInboundCallView.DeptName,
                    ClassType        = objCMMobileInboundCallView.ClassType,
                    ClientAdminID    = objCMMobileInboundCallView.ClientAdminID
                };

                lo_strJsonParam = JsonConvert.SerializeObject(lo_objJsonParam);

                var hub = GlobalHost.ConnectionManager.GetHubContext("NotiHub");
                if (hub != null)
                {
                    foreach (var CalleeInfoList in lo_objResCalleeInfoList.data.list)
                    {
                        /*
                        string lo_strConnectionId = SignalRUsers._joinedUsers.FirstOrDefault(u => u.AdminID == CalleeInfoList.AdminID) ?.ConnectionId;
                        if (lo_strConnectionId != null)
                        {
                            hub.Clients.Client(lo_strConnectionId).cidReceived(lo_strJsonParam, CalleeInfoList.WebAlarmFlag, CalleeInfoList.PCAlarmFlag, CalleeInfoList.AutoPopupFlag);
                        }
                        */

                        if (SignalRUsers._joinedUsers != null)
                        {
                            var ids = SignalRUsers._joinedUsers
                                .Where(u => u.AdminID == CalleeInfoList.AdminID)
                                .Select(u => u.ConnectionId)
                                .Where(id => !string.IsNullOrEmpty(id))
                                .Distinct()
                                .ToList();

                            if (ids.Count > 0)
                            {
                                hub.Clients.Clients(ids).cidReceived(lo_strJsonParam, CalleeInfoList.WebAlarmFlag,
                                    CalleeInfoList.PCAlarmFlag, CalleeInfoList.AutoPopupFlag);
                            }
                        }
                    }
                }
            }
            catch (Exception lo_ex)
            {
                lo_objResMap.RetCode = 9425;
                lo_objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("WebSocket", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    lo_objResMap.RetCode);
            }

            return lo_objResMap;
        }

        ///--------------------------------------------
        /// <summary>
        /// 페이지 기본 Json 응답 출력
        /// </summary>
        ///--------------------------------------------
        private void WriteJsonResponse(ResponseMap objResMap)
        {
            string lo_strResponse = string.Empty;
            string lo_strErrMsg   = string.Empty;

            try
            {
                lo_strResponse = string.Format(objJosnString, objResMap.RetCode, objResMap.ErrMsg);
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                lo_strErrMsg      = "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace;
                lo_strResponse    = string.Format(objJosnString, objResMap.RetCode, objResMap.ErrMsg);
            }
            finally
            {
                // 출력
                Response.Write(lo_strResponse);

                if (objResMap.RetCode < 0)
                {
                    // 익셉션 발생시 처리 - File Logging & Send Mail
                    SiteGlobal.WriteLog("WebSocket", "Exception", lo_strErrMsg, objResMap.RetCode);
                }
            }
        }
    }
}