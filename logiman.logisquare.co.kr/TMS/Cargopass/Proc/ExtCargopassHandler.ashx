<%@ WebHandler Language="C#" Class="ExtCargopassHandler" %>
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using Newtonsoft.Json;
using System;
using System.Web;

///================================================================
/// <summary>
/// FileName        : ExtCargopassHandler.ashx
/// Description     : 카고패스 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2024-03-12
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ExtCargopassHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Cargopass/ExtCargopassList"; //필수

    // 메소드 리스트
    private const string MethodCargopassSessionList = "CargopassSessionList"; //연동현황용 세션정보

    private HttpContext objHttpContext       = null;
    private string      strCallType          = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCargopassSessionList, MenuAuthType.ReadOnly);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        objHttpContext = context;

        try
        {
            strCallType = SiteGlobal.GetRequestForm("CallType");

            //1.Request
            GetData();
            if (!objResMap.RetCode.Equals(0))
            {
                return;
            }

            //2.처리
            Process();
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9401;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ExtCargopassHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ExtCargopassHandler");
        }
    }

    ///------------------------------
    /// <summary>
    /// 파라미터 데이터 설정
    /// </summary>
    ///------------------------------
    private void GetData()
    {
        try
        {
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ExtCargopassHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    ///------------------------------
    /// <summary>
    /// 실행 메소드 처리함수
    /// </summary>
    ///------------------------------
    private void Process()
    {
        try
        {
            switch (strCallType)
            {
                case MethodCargopassSessionList:
                    GetCargopassSessionList();
                    break;
                default:
                    objResMap.RetCode = 9500;
                    objResMap.ErrMsg  = "Wrong Method" + strCallType;
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9403;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ExtCargopassHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    //연동현황용 세션정보
    protected void GetCargopassSessionList()
    {
        CenterSessionInfo lo_objCenterSessionInfo = null;
        CenterPageOption  lo_objCenterPageOption  = null;
        string            lo_strSessionKey        = string.Empty;
        string            lo_strEncSession        = string.Empty;

        try
        {
            lo_objCenterSessionInfo = new CenterSessionInfo
            {
                SessionKey       = Utils.GetRandomNumber().ToString().Right(5),
                SiteCode         = CommonConstant.SITE_CODE,
                AdminID          = objSes.AdminID,
                AdminName        = objSes.AdminName,
                LoginIP          = SiteGlobal.GetRemoteAddr(),
                Network24DDID    = objSes.Network24DDID,
                NetworkHMMID     = objSes.NetworkHMMID,
                NetworkOneCallID = objSes.NetworkOneCallID,
                NetworkHmadangID = objSes.NetworkHmadangID,
                MobileNo         = objSes.MobileNo,
                TelNo            = objSes.TelNo,
                AccessCenterCode = objSes.AccessCenterCode,
                TimeStamp        = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };
                
            lo_strSessionKey = lo_objCenterSessionInfo.SessionKey;
            lo_strEncSession = Utils.GetEncrypt4Cargopass(JsonConvert.SerializeObject(lo_objCenterSessionInfo), lo_strSessionKey);

            lo_objCenterPageOption = new CenterPageOption
            {
                PageType          = 2,
                PageTitleViewFlag = "N",
                PageErrRetUrl     = SiteGlobal.TMS_DOMAIN + "TMS/Cargopass/CargopassError",
                PageWidth         = 0,
                PageHeight        = 0
            };
                
            objResMap.Add("SessionKey", lo_strSessionKey);
            objResMap.Add("EncSession", HttpUtility.UrlEncode(lo_strEncSession));
            objResMap.Add("PageOption", JsonConvert.SerializeObject(lo_objCenterPageOption));
            objResMap.Add("ListURL",    SiteGlobal.CARGOPASS_LIST_URL);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ExtCargopassHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    #endregion


    ///--------------------------------------------
    /// <summary>
    /// 페이지 기본 Json 응답 출력
    /// </summary>
    ///--------------------------------------------
    public override void WriteJsonResponse(string strLogFileName)
    {
        try
        {
            base.WriteJsonResponse(strLogFileName);
        }
        catch
        {
        }
    }
}