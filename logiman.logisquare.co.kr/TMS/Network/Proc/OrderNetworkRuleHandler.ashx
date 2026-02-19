<%@ WebHandler Language="C#" Class="NetworkRuleHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Data;
using System.IO;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : NetworkRuleHandler.ashx
/// Description     : 담당 고객사 관리
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-08-02
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class NetworkRuleHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Network/OrderNetworkRuleList"; //필수

    // 메소드 리스트
    private const string MethodNetworkRuleList   = "NetworkRuleList";
    private const string MethodNetworkRuleInsert = "NetworkRuleInsert";
    private const string MethodNetworkRuleUpdate = "NetworkRuleUpdate";
    private const string MethodClientList        = "ClientList";
        
    ClientDasServices   objClientDasServices   = new ClientDasServices();
    NetworkDasSerivices objNetworkDasSerivices = new NetworkDasSerivices();

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string strRuleSeqNo             = string.Empty;
    private string strRuleType              = string.Empty;
    private string strCenterCode            = string.Empty;
    private string strNetworkKind           = string.Empty;
    private string strClientCode            = string.Empty;
    private string strConsignorCode         = string.Empty;
    private string strRenewalStartMinute    = string.Empty;
    private string strRenewalIntervalMinute = string.Empty;
    private string strRenewalIntervalPrice  = string.Empty;
    private string strRenewalModMinute      = string.Empty;
    private string strUseFlag               = string.Empty;
    private string strRegAdminName          = string.Empty;
    private string strClientName            = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodNetworkRuleList,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodNetworkRuleInsert, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodNetworkRuleUpdate, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientList,        MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("NetworkRuleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("NetworkRuleHandler");
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
            strRuleSeqNo             = Utils.IsNull(SiteGlobal.GetRequestForm("RuleSeqNo"),                             "0");
            strRuleType              = Utils.IsNull(SiteGlobal.GetRequestForm("RuleType"),                              "0");
            strCenterCode            = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),                            "0");
            strNetworkKind           = Utils.IsNull(SiteGlobal.GetRequestForm("NetworkKind"),                           "0");
            strClientCode            = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"),                            "0");
            strConsignorCode         = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"),                         "0");
            strRenewalStartMinute    = Utils.IsNull(SiteGlobal.GetRequestForm("RenewalStartMinute"),                    "0");
            strRenewalIntervalMinute = Utils.IsNull(SiteGlobal.GetRequestForm("RenewalIntervalMinute"),                 "0");
            strRenewalIntervalPrice  = Utils.IsNull(SiteGlobal.GetRequestForm("RenewalIntervalPrice").Replace(",", ""), "0");
            strRenewalModMinute      = Utils.IsNull(SiteGlobal.GetRequestForm("RenewalModMinute"),                      "0");
            strClientName            = SiteGlobal.GetRequestForm("ClientName");
            strUseFlag               = SiteGlobal.GetRequestForm("UseFlag");
            strRegAdminName          = SiteGlobal.GetRequestForm("RegAdminName");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("NetworkRuleHandler", "Exception",
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
                case MethodNetworkRuleList:
                    GetNetworkRuleList();
                    break;
                case MethodNetworkRuleInsert:
                    SetNetworkRuleInsert();
                    break;
                case MethodNetworkRuleUpdate:
                    SetNetworkRuleUpdate();
                    break;
                case MethodClientList:
                    GetClientList();
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

            SiteGlobal.WriteLog("NetworkRuleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 자동배차 룰관리 목록
    /// </summary>
    protected void GetNetworkRuleList()
    {
        ReqNetworkList                             lo_objReqNetworkList  = null;
        ServiceResult<ResNetworkList>              lo_objResNetworkList = null;

        try
        {
            lo_objReqNetworkList = new ReqNetworkList
            {
                RuleSeqNo       = strRuleSeqNo.ToInt(),
                CenterCode      = strCenterCode.ToInt(),
                ClientCode      = strClientCode.ToInt(),
                ClientName      = strClientName,
                UseFlag         = strUseFlag,
                RegAdminName    = strRegAdminName,
                PageSize        = intPageSize,
                PageNo          = intPageNo
            };

            lo_objResNetworkList    = objNetworkDasSerivices.GetOrderNetworkRuleList(lo_objReqNetworkList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResNetworkList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("NetworkRuleHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetNetworkRuleInsert()
    {
        NetworkViewModel                        lo_objNetworkRule    = null;
        ServiceResult<NetworkViewModel>         lo_objResNetworkRule = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[고객사코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNetworkKind))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[정보망 구분]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRenewalStartMinute))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[증액시작시간(분)]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRenewalIntervalMinute))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[증액주기(분)]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRenewalIntervalPrice))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[증액금액]";
            return;
        }


        try
        {
            lo_objNetworkRule = new NetworkViewModel
            {
                RuleType                    = strRuleType.ToInt(),
                CenterCode                  = strCenterCode.ToInt(),
                NetworkKind                 = strNetworkKind.ToInt(),
                ClientCode                  = strClientCode.ToInt(),
                ConsignorCode               = strConsignorCode.ToInt(),
                RenewalStartMinute          = strRenewalStartMinute.ToInt(),
                RenewalIntervalMinute       = strRenewalIntervalMinute.ToInt(),
                RenewalIntervalPrice        = strRenewalIntervalPrice.ToDouble(),
                RenewalModMinute            = strRenewalModMinute.ToInt(),
                RegAdminID                  = objSes.AdminID,
                RegAdminName                  = objSes.AdminName
            };

            lo_objResNetworkRule = objNetworkDasSerivices.InsNetworkRule(lo_objNetworkRule);
            objResMap.RetCode  = lo_objResNetworkRule.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResNetworkRule.result.ErrorMsg;
            }
            else{
                objResMap.Add("RuleSeqNo", lo_objResNetworkRule.data.RuleSeqNo);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("NetworkRuleHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void SetNetworkRuleUpdate()
    {
        NetworkViewModel                        lo_objNetworkRule    = null;
        ServiceResult<NetworkViewModel>         lo_objResNetworkRule = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[고객사코드]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNetworkKind))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[정보망 구분]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRenewalStartMinute))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[증액시작시간(분)]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRenewalIntervalMinute))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[증액주기(분)]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRenewalIntervalPrice))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[증액금액]";
            return;
        }


        try
        {
            lo_objNetworkRule = new NetworkViewModel
            {
                RuleSeqNo                   = strRuleSeqNo.ToInt(),
                RuleType                    = strRuleType.ToInt(),
                CenterCode                  = strCenterCode.ToInt(),
                NetworkKind                 = strNetworkKind.ToInt(),
                ClientCode                  = strClientCode.ToInt(),
                ConsignorCode               = strConsignorCode.ToInt(),
                RenewalStartMinute          = strRenewalStartMinute.ToInt(),
                RenewalIntervalMinute       = strRenewalIntervalMinute.ToInt(),
                RenewalIntervalPrice        = strRenewalIntervalPrice.ToDouble(),
                RenewalModMinute            = strRenewalModMinute.ToInt(),
                UseFlag                     = strUseFlag,
                RegAdminID                  = objSes.AdminID
            };

            lo_objResNetworkRule = objNetworkDasSerivices.UpdNetworkRule(lo_objNetworkRule);
            objResMap.RetCode  = lo_objResNetworkRule.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResNetworkRule.result.ErrorMsg;
            }
            else { 
                objResMap.Add("RuleSeqNo", strRuleSeqNo.ToInt());    
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9454;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("NetworkRuleHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 고객사 목록
    /// </summary>
    protected void GetClientList()
    {
        ReqClientList                lo_objReqClientList = null;
        ServiceResult<ResClientList> lo_objResClientList = null;

        try
        {
            lo_objReqClientList = new ReqClientList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientName       = strClientName,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientList   = objClientDasServices.GetClientList(lo_objReqClientList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("NetworkRuleHandler", "Exception",
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