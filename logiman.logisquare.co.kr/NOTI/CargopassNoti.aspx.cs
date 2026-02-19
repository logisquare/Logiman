using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using Microsoft.Ajax.Utilities;
using Newtonsoft.Json;

namespace NOTI.Cargopass
{
    public partial class CargopassNoti : PageInit
    {
        private CargopassDasSerivices objCargopassDasSerivices = new CargopassDasSerivices();

        private string             strNotiParam          = string.Empty;
        private string             strSessionKey         = string.Empty;
        private string             strNotiParamDec       = string.Empty;
        private CargopassNotiOrder objCargopassNotiOrder = null;
        private ResponseMap        objResMapNoti         = null;
        private string             strErrorJsonString    = "[{{\"RetCode\":{0},\"ErrMsg\":\"{1}\"}}]";

        protected void Page_Init(object sender, EventArgs e)
        {
            objResMapNoti = new ResponseMap();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string lo_strUserAddr = Request.UserHostAddress;

            try
            {
                SiteGlobal.WriteLog("CargopassNotiParam", "Request", "\r\n\t[RequestParam] : " + lo_strUserAddr + " : " + SiteGlobal.GetAllRequestForm(), 0, 0);

                // 서비스 환경에 따른 변수값 선언
                // [logimanDebug] IP 변경
                switch (SiteGlobal.DOMAINNAME.ToLower())
                {
                    case CommonConstant.TEST_DOMAIN:
                        if (!lo_strUserAddr.Equals("211.253.28.210") && !lo_strUserAddr.Equals("172.27.0.62"))
                        {
                            objResMapNoti.RetCode = 9402;
                            objResMapNoti.ErrMsg  = CommonConstant.HTTP_STATUS_CODE_404_MESSAGE;
                        }
                        break;
                    case CommonConstant.REAL_DOMAIN:
                        if (!lo_strUserAddr.Equals("x.x.x.x") && !lo_strUserAddr.Equals("x.x.x.x"))
                        {
                            objResMapNoti.RetCode = 9403;
                            objResMapNoti.ErrMsg  = CommonConstant.HTTP_STATUS_CODE_404_MESSAGE;
                        }
                        break;
                    default:
                        objResMapNoti.RetCode = 0;
                        break;
                }

                if (objResMapNoti.RetCode.Equals(0))
                {
                    GetInitData();
                    if (!objResMapNoti.RetCode.Equals(0))
                    {
                        return;
                    }

                    ProcCargopassNoti();
                }
            }
            catch (Exception lo_ex)
            {
                objResMapNoti.RetCode = 9401;
                objResMapNoti.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("CargopassNoti", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                    objResMapNoti.RetCode);
            }
            finally
            {
                //3. 결과 출력 - 종료
                WriteNotiResponse();
            }
        }

        protected void GetInitData()
        {
            try
            {
                //strNotiParam    = HttpUtility.UrlDecode(SiteGlobal.GetRequestForm("NotiParam", false));
                strNotiParam  = SiteGlobal.GetRequestForm("NotiParam", false);
                strSessionKey = SiteGlobal.GetRequestForm("SessionKey");

                if (strNotiParam.IsNullOrWhiteSpace())
                {
                    objResMapNoti.RetCode = 9402;
                    objResMapNoti.ErrMsg  = "요청 정보가 없습니다.";
                    return;
                }

                if (strSessionKey.IsNullOrWhiteSpace())
                {
                    objResMapNoti.RetCode = 9403;
                    objResMapNoti.ErrMsg  = "요청 세션 정보가 없습니다.";
                    return;
                }

                strNotiParamDec = Utils.GetDecrypt4Cargopass(strNotiParam, strSessionKey);
                if (strNotiParamDec.IsNullOrWhiteSpace())
                {
                    objResMapNoti.RetCode = 9404;
                    objResMapNoti.ErrMsg  = "요청 정보를 처리할 수 없습니다.";
                    return;
                }

                SiteGlobal.WriteLog("CargopassNotiParam", " strNotiParamDec",
                                    "\r\n\t[ex.Message] : " + strNotiParamDec, 0, 0);


                objCargopassNotiOrder = JsonConvert.DeserializeObject<CargopassNotiOrder>(strNotiParamDec);
                if (objCargopassNotiOrder == null)
                {
                    objResMapNoti.RetCode = 9405;
                    objResMapNoti.ErrMsg  = "요청 정보가 올바르지 않습니다.";
                    return;
                }
            }
            catch (Exception lo_ex)
            {
                objResMapNoti.RetCode = 9410;
                objResMapNoti.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("CargopassNoti", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, objResMapNoti.RetCode);
            }
        }


        protected void ProcCargopassNoti()
        {
            ServiceResult<bool> lo_objUpdOrderCargopassNoti = null;

            try
            {
                lo_objUpdOrderCargopassNoti = objCargopassDasSerivices.UpdOrderCargopassNoti(objCargopassNotiOrder);
                objResMapNoti.RetCode       = lo_objUpdOrderCargopassNoti.result.ErrorCode;
                objResMapNoti.ErrMsg        = lo_objUpdOrderCargopassNoti.result.ErrorMsg;
            }
            catch (Exception lo_ex)
            {
                objResMapNoti.RetCode = 9420;
                objResMapNoti.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;
                SiteGlobal.WriteLog("CargopassNoti", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, objResMapNoti.RetCode);
            }
        }

        ///--------------------------------------------
        /// <summary>
        /// 페이지 기본 Json 응답 출력
        /// </summary>
        ///--------------------------------------------
        private void WriteNotiResponse()
        {
            string                     lo_strResponse       = string.Empty;
            string                     lo_strErrMsg         = string.Empty;
            Dictionary<String, Object> dic                  = new Dictionary<string, object>();
            JavaScriptSerializer       lo_objJsonSerializer = new JavaScriptSerializer();

            try
            {
                dic.Add("ErrMsg", objResMapNoti.RetCode < 0 ? "Exception Error" : objResMapNoti.ErrMsg);
                dic.Add("RetCode", objResMapNoti.RetCode);

                lo_strResponse = "[" + lo_objJsonSerializer.Serialize(dic) + "]";
            }
            catch (Exception lo_ex)
            {
                objResMapNoti.RetCode = 9430;
                objResMapNoti.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                lo_strErrMsg   = "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace;
                lo_strResponse = string.Format(strErrorJsonString, objResMapNoti.RetCode, objResMapNoti.ErrMsg);
            }
            finally
            {
                // 출력
                Response.Write(lo_strResponse);

                if (objResMapNoti.RetCode < 0)
                {
                    // 익셉션 발생시 처리 - File Logging & Send Mail
                    SiteGlobal.WriteLog("CargopassNoti", "Exception", lo_strErrMsg, objResMapNoti.RetCode);
                }
            }
        }
    }
}