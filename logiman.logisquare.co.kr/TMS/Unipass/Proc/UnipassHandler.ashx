<%@ WebHandler Language="C#" Class="UnipassHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.Utils;
using CommonLibrary.Extensions;
using System;
using System.Web;
using CommonLibrary.DasServices;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : UnipassHandler.ashx
/// Description     : 관세청 API 연동 관련
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2023-06-09
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class UnipassHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Unipass/UnipassDetailList"; //필수

    // 메소드 리스트
    private const string MethodGetUnipassDetailInfo = "GetUnipassDetailInfo";
    private const string MethodUnipassContainerList = "GetUnipassContainerList";
    private const string MethodUnipassShedInfo   = "GetUnipassShedInfo";

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string strcargMtNo   = string.Empty;
    private string strmblNo      = string.Empty;
    private string strhblNo      = string.Empty;
    private string strblYy       = string.Empty;
    private string strshedSgn    = string.Empty;
    private string strSearchType = string.Empty;
    private string strSearchText = string.Empty;
    private string strSearchYear = string.Empty;


    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodGetUnipassDetailInfo, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodUnipassContainerList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodUnipassShedInfo, MenuAuthType.ReadOnly);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType  = SiteGlobal.GetRequestForm("CallType");
            intPageSize  = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo    = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

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

            SiteGlobal.WriteLog("UnipassHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("UnipassHandler");
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
            strcargMtNo   = Utils.IsNull(SiteGlobal.GetRequestForm("cargMtNo"), "");
            strmblNo      = Utils.IsNull(SiteGlobal.GetRequestForm("mblNo"), "");
            strhblNo      = Utils.IsNull(SiteGlobal.GetRequestForm("hblNo"), "");
            strblYy       = Utils.IsNull(SiteGlobal.GetRequestForm("blYy"), "");
            strshedSgn    = Utils.IsNull(SiteGlobal.GetRequestForm("shedSgn"), "");
            strSearchType = Utils.IsNull(SiteGlobal.GetRequestForm("SearchType"), "");
            strSearchText = Utils.IsNull(SiteGlobal.GetRequestForm("SearchText"), "");
            strSearchYear = Utils.IsNull(SiteGlobal.GetRequestForm("SearchYear"), "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("UnipassHandler", "Exception",
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
                case MethodGetUnipassDetailInfo:
                    GetUnipassDetailInfo();
                    break;
                case MethodUnipassContainerList:
                    GetUnipassContainerList();
                    break;
                case MethodUnipassShedInfo:
                    GetUnipassShedInfo();
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

            SiteGlobal.WriteLog("UnipassHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 화물통관 진행전보
    /// </summary>
    protected void GetUnipassDetailInfo()
    {
        int                  lo_intRetVal               = 0;
        string               lo_strPostData             = string.Empty;
        string               lo_strAuthirization        = string.Empty; //api.logislab.com 연동 시 인증 값 전송
        HttpHeader           lo_objHeader               = null;
        HttpAction           lo_objHttp                 = null;
        ReqUnipassDetailList lo_objReqUnipassDetailList = null;
        switch (strSearchType)
        {
            case "cargMtNo":
                strcargMtNo   = strSearchText;
                strSearchYear = "";
                break;
            case "MBL":
                strmblNo = strSearchText;
                break;
            case "HBL":
                strhblNo = strSearchText;
                break;
        }
        try
        {
            lo_objReqUnipassDetailList = new ReqUnipassDetailList
            {
                cargMtNo = strcargMtNo,
                mblNo    = strmblNo,
                hblNo    = strhblNo,
                blYy     = strSearchYear
            };

            lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

            lo_strAuthirization = SiteGlobal.GetLogisquareAPIHeaderAuth();
            lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

            lo_strPostData = JsonConvert.SerializeObject(lo_objReqUnipassDetailList);

            lo_objHttp = new HttpAction(SiteGlobal.WS_LQ_DOMAIN + CommonConstant.WS_API_UNIPAAS_CARGO_INFO_GET, lo_objHeader, lo_strPostData);
            lo_objHttp.SendHttpAction();

            lo_intRetVal = lo_objHttp.RetVal;
            
            objResMap.strResponse = "[" + JsonConvert.DeserializeObject(lo_objHttp.ResponseData) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("UnipassHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 내역
    /// </summary>
    protected void GetUnipassContainerList()
    {
        int                  lo_intRetVal               = 0;
        string               lo_strPostData             = string.Empty;
        string               lo_strAuthirization        = string.Empty; //api.logislab.com 연동 시 인증 값 전송
        HttpHeader           lo_objHeader               = null;
        HttpAction           lo_objHttp                 = null;
        ReqUnipassDetailList lo_objReqUnipassDetailList = null;

        try
        {
            lo_objReqUnipassDetailList = new ReqUnipassDetailList
            {
                cargMtNo = strcargMtNo
            };

            lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

            lo_strAuthirization = SiteGlobal.GetLogisquareAPIHeaderAuth();
            lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

            lo_strPostData = JsonConvert.SerializeObject(lo_objReqUnipassDetailList);

            lo_objHttp = new HttpAction(SiteGlobal.WS_LQ_DOMAIN + CommonConstant.WS_API_UNIPAAS_CONTAINER_LIST_GET, lo_objHeader, lo_strPostData);
            lo_objHttp.SendHttpAction();

            lo_intRetVal = lo_objHttp.RetVal;
            
            objResMap.strResponse = "[" + JsonConvert.DeserializeObject(lo_objHttp.ResponseData) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("UnipassHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 장치장 정보
    /// </summary>
    protected void GetUnipassShedInfo()
    {
        int                  lo_intRetVal               = 0;
        string               lo_strPostData             = string.Empty;
        string               lo_strAuthirization        = string.Empty; //api.logislab.com 연동 시 인증 값 전송
        HttpHeader           lo_objHeader               = null;
        HttpAction           lo_objHttp                 = null;
        ReqUnipassDetailList lo_objReqUnipassDetailList = null;

        try
        {
            lo_objReqUnipassDetailList = new ReqUnipassDetailList
            {
                snarSgn = strshedSgn
            };

            lo_objHeader   = new HttpHeader(HttpAction.MethodType.Post) { ConentType = CommonConstant.WS_API_DEFAULT_CONTENTTYPE };

            lo_strAuthirization = SiteGlobal.GetLogisquareAPIHeaderAuth();
            lo_objHeader.AddCustomHeader("Authorization", lo_strAuthirization);

            lo_strPostData = JsonConvert.SerializeObject(lo_objReqUnipassDetailList);

            lo_objHttp = new HttpAction(SiteGlobal.WS_LQ_DOMAIN + CommonConstant.WS_API_UNIPAAS_SHED_INFO_GET, lo_objHeader, lo_strPostData);
            lo_objHttp.SendHttpAction();

            lo_intRetVal = lo_objHttp.RetVal;
            
            objResMap.strResponse = "[" + JsonConvert.DeserializeObject(lo_objHttp.ResponseData) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("UnipassHandler", "Exception",
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