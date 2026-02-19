<%@ WebHandler Language="C#" Class="CallManagerHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : CallManagerHandler.ashx
/// Description     : 콜매니저
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2025-07-16
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class CallManagerHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/CallManager/CMCallRecordList"; //필수

    // 메소드 리스트
    private const string MethodCMAuthInfoList          = "CMAuthInfoList";
    private const string MethodCMAuthInfoInsert        = "CMAuthInfoInsert";
    private const string MethodCMAuthInfoDelete        = "CMAuthInfoDelete";
    private const string MethodCMAuthPhoneList         = "CMAuthPhoneList";
    private const string MethodCMAuthPhoneAvailList    = "CMAuthPhoneAvailList";
    private const string MethodCMAuthPhoneInsert       = "CMAuthPhoneInsert";
    private const string MethodCMAuthPhoneUpdate       = "CMAuthPhoneUpdate";
    private const string MethodCMPhoneListSearch       = "CMPhoneListSearch";
    private const string MethodCMAdminList             = "CMAdminList";
    private const string MethodCMAdminInsert           = "CMAdminInsert";
    private const string MethodCMAdminPhoneMultiUpdate = "CMAdminPhoneMultiUpdate";
        
    private readonly CallManageDasServices  objCallManageDasServices  = new();

   private string strCallType = string.Empty;
   private int    intPageSize;
   private int    intPageNo;

   private int    intAuthSeqNo;
   private int    intCenterCode;
   private string strCenterName;
   private string strChannelType;
   private string strAuthID;
   private string strUseFlag;
   private string strAuthPwd;
   private int    intPhoneSeqNo;
   private int    intAuthIdx;
   private int    intPhoneIdx;
   private string strPhoneNo;
   private string strCreateTs;
   private string strPhoneMemo;
   private string strWebAlarmFlag;
   private string strPCAlarmFlag;
   private string strAutoPopupFlag;
   private string strOrderViewFlag;
   private string strCompanyViewFlag;
   private string strPurchaseViewFlag;
   private string strSaleViewFlag;
   private string strPhoneSeqNos;
   private string strMainUseFlags;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCMAuthInfoList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMAuthInfoInsert,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCMAuthInfoDelete,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCMAuthPhoneList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMAuthPhoneAvailList,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMAuthPhoneInsert,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCMAuthPhoneUpdate,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCMPhoneListSearch,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCMAdminList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMAdminInsert,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCMAdminPhoneMultiUpdate, MenuAuthType.ReadWrite);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(IsHandlerStop.Equals(true))
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
            objResMap.RetCode = 9421;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CallManagerHandler");
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
            intAuthSeqNo        = Utils.IsNull(SiteGlobal.GetRequestForm("AuthSeqNo"),  "0").ToInt();
            intCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0").ToInt();
            strCenterName       = SiteGlobal.GetRequestForm("CenterName");
            strChannelType      = SiteGlobal.GetRequestForm("ChannelType");
            strAuthID           = SiteGlobal.GetRequestForm("AuthID");
            strUseFlag          = SiteGlobal.GetRequestForm("UseFlag");
            strAuthPwd          = SiteGlobal.GetRequestForm("AuthPwd", false);
            intAuthSeqNo        = Utils.IsNull(SiteGlobal.GetRequestForm("AuthSeqNo"),  "0").ToInt();
            intPhoneSeqNo       = Utils.IsNull(SiteGlobal.GetRequestForm("PhoneSeqNo"), "0").ToInt();
            intAuthIdx          = Utils.IsNull(SiteGlobal.GetRequestForm("AuthIdx"),    "0").ToInt();
            intPhoneIdx         = Utils.IsNull(SiteGlobal.GetRequestForm("PhoneIdx"),   "0").ToInt();
            strPhoneNo          = SiteGlobal.GetRequestForm("PhoneNo");
            strCreateTs         = SiteGlobal.GetRequestForm("CreateTs");
            strPhoneMemo        = SiteGlobal.GetRequestForm("PhoneMemo");
            strWebAlarmFlag     = SiteGlobal.GetRequestForm("WebAlarmFlag");
            strPCAlarmFlag      = SiteGlobal.GetRequestForm("PCAlarmFlag");
            strAutoPopupFlag    = SiteGlobal.GetRequestForm("AutoPopupFlag");
            strOrderViewFlag    = SiteGlobal.GetRequestForm("OrderViewFlag");
            strCompanyViewFlag  = SiteGlobal.GetRequestForm("CompanyViewFlag");
            strPurchaseViewFlag = SiteGlobal.GetRequestForm("PurchaseViewFlag");
            strSaleViewFlag     = SiteGlobal.GetRequestForm("SaleViewFlag");
            strPhoneSeqNos      = SiteGlobal.GetRequestForm("PhoneSeqNos");
            strMainUseFlags     = SiteGlobal.GetRequestForm("MainUseFlags");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9422;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
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
                case MethodCMAuthInfoList:
                    GetCMAuthInfoList();
                    break;
                case MethodCMAuthInfoInsert:
                    SetCMAuthInfoInsert();
                    break;
                case MethodCMAuthInfoDelete:
                    SetCMAuthInfoDelete();
                    break;
                case MethodCMAuthPhoneList:
                    GetCMAuthPhoneList();
                    break;
                case MethodCMAuthPhoneAvailList:
                    GetCMAuthPhoneAvailList();
                    break;
                case MethodCMAuthPhoneInsert:
                    SetCMAuthPhoneInsert();
                    break;
                case MethodCMAuthPhoneUpdate:
                    SetCMAuthPhoneUpdate();
                    break;
                case MethodCMPhoneListSearch:
                    GetCMDapiPhoneList();
                    break;
                case MethodCMAdminList:
                    GetCMAdminList();
                    break;
                case MethodCMAdminInsert:
                    SetCMAdminInsert();
                    break;
                case MethodCMAdminPhoneMultiUpdate:
                    SetCMAdminPhoneMultiUpdate();
                    break;
                default:
                    objResMap.RetCode = 9423;
                    objResMap.ErrMsg  = "Wrong Method" + strCallType;
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9424;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process


    /// <summary>
    /// 콜매니저 계정 정보 조회
    /// </summary>
    protected void GetCMAuthInfoList()
    {
        ReqAuthInfoList                lo_objReqAuthInfoList;
        ServiceResult<ResAuthInfoList> lo_objResAuthInfoList;

        try
        {
            lo_objReqAuthInfoList = new ReqAuthInfoList
            {
                AuthSeqNo        = intAuthSeqNo,
                CenterCode       = intCenterCode,
                ChannelType      = strChannelType,
                AuthID           = strAuthID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResAuthInfoList = objCallManageDasServices.GetAuthInfoList(lo_objReqAuthInfoList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResAuthInfoList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9425;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 계정 정보 등록
    /// </summary>
    protected void SetCMAuthInfoInsert()
    {
        ReqCMAuthInfo                 lo_objReqCMAuthInfo;
        ResCMCommon                   lo_objResCMAuthInfo;
        ReqAuthInfoIns                lo_objReqAuthInfoIns;
        ServiceResult<ResAuthInfoIns> lo_objResAuthInfoIns;

        try
        {
            if (intCenterCode.Equals(0))
            {
                objResMap.RetCode = 9501;
                objResMap.ErrMsg  = "운송사가 선택되지 않았습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strChannelType))
            {
                objResMap.RetCode = 9502;
                objResMap.ErrMsg  = "통신사 정보가 입력되지 않았습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strAuthID))
            {
                objResMap.RetCode = 9503;
                objResMap.ErrMsg  = "계정정보가 입력되지 않았습니다.";
                return;
            }

            lo_objReqCMAuthInfo = new ReqCMAuthInfo
            {
                auth_id          = strAuthID,
                auth_mac         = "",
                auth_pwd         = strAuthPwd,
                channel_type     = strChannelType,
                site_code        = CommonConstant.WS_DAPI_CM_SITE_CODE,
                site_custom_code = intCenterCode.ToString(),
                site_custom_name = strCenterName
            };

            lo_objResCMAuthInfo = ApiCallManager.SetCMAuthInfo(lo_objReqCMAuthInfo);
            if (lo_objResCMAuthInfo.ResultCode.IsFail())
            {
                objResMap.RetCode = lo_objResCMAuthInfo.ResultCode;
                objResMap.ErrMsg  = lo_objResCMAuthInfo.ResultMessage;
                return;
            }

            lo_objReqAuthInfoIns = new ReqAuthInfoIns
            {
                CenterCode  = intCenterCode,
                ChannelType = strChannelType,
                AuthID      = strAuthID,
                AuthPwd     = string.IsNullOrWhiteSpace(strAuthPwd) ? "" : Utils.GetEncrypt(strAuthPwd),
                AdminID     = objSes.AdminID,
                AdminName   = objSes.AdminName
            };

            lo_objResAuthInfoIns = objCallManageDasServices.InsAuthInfo(lo_objReqAuthInfoIns);
            objResMap.RetCode    = lo_objResAuthInfoIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResAuthInfoIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9426;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 계정 정보 삭제
    /// </summary>
    protected void SetCMAuthInfoDelete()
    {
        ReqCMDeleteAuthInfo lo_objReqCMDeleteAuthInfo;
        ResCMCommon         lo_objResCMDeleteAuthInfo;
        ReqAuthInfoDel      lo_objReqAuthInfoDel;
        ServiceResult<bool> lo_objResAuthInfoDel;

        try
        {
            lo_objReqCMDeleteAuthInfo = new ReqCMDeleteAuthInfo
            {
                site_code        = CommonConstant.WS_DAPI_CM_SITE_CODE,
                site_custom_code = intCenterCode.ToString(),
                channel_type     = strChannelType,
                auth_id          = strAuthID
            };

            lo_objResCMDeleteAuthInfo = ApiCallManager.DelCMAuthInfo(lo_objReqCMDeleteAuthInfo);
            if (lo_objResCMDeleteAuthInfo.ResultCode.IsFail())
            {
                objResMap.RetCode = lo_objResCMDeleteAuthInfo.ResultCode;
                objResMap.ErrMsg  = lo_objResCMDeleteAuthInfo.ResultMessage;
                return;
            }

            lo_objReqAuthInfoDel = new ReqAuthInfoDel
            {
                CenterCode = intCenterCode,
                AuthSeqNo  = intAuthSeqNo,
                AdminID    = objSes.AdminID,
                AdminName  = objSes.AdminName
            };

            lo_objResAuthInfoDel = objCallManageDasServices.DelAuthInfo(lo_objReqAuthInfoDel);
            objResMap.RetCode    = lo_objResAuthInfoDel.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResAuthInfoDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9427;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 계정 연동 전화번호 조회
    /// </summary>
    protected void GetCMAuthPhoneList()
    {
        ReqAuthPhoneList                lo_objReqAuthPhoneList;
        ServiceResult<ResAuthPhoneList> lo_objResAuthPhoneList;

        try
        {
            lo_objReqAuthPhoneList = new ReqAuthPhoneList
            {
                PhoneSeqNo       = intPhoneSeqNo,
                AuthIdx          = intAuthIdx,
                PhoneIdx         = intPhoneIdx,
                AuthSeqNo        = intAuthSeqNo,
                ChannelType      = strChannelType,
                PhoneNo          = strPhoneNo,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResAuthPhoneList = objCallManageDasServices.GetAuthPhoneList(lo_objReqAuthPhoneList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResAuthPhoneList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9428;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 계정 연동 전화번호 조회
    /// </summary>
    protected void GetCMAuthPhoneAvailList()
    {
        ReqAuthPhoneAvailList                lo_objReqAuthPhoneAvailList;
        ServiceResult<ResAuthPhoneAvailList> lo_objResAuthPhoneAvailList;

        try
        {
            lo_objReqAuthPhoneAvailList = new ReqAuthPhoneAvailList
            {
                AuthSeqNo        = intAuthSeqNo,
                CenterCode       = intCenterCode,
                ChannelType      = strChannelType,
                AuthID           = strAuthID,
                UseFlag          = strUseFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResAuthPhoneAvailList = objCallManageDasServices.GetAuthPhoneAvailList(lo_objReqAuthPhoneAvailList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResAuthPhoneAvailList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9429;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 계정 연동 전화번호 등록
    /// </summary>
    protected void SetCMAuthPhoneInsert()
    {
        ReqAuthPhoneIns                lo_objReqAuthPhoneIns;
        ServiceResult<ResAuthPhoneIns> lo_objResAuthPhoneIns;

        try
        {
            lo_objReqAuthPhoneIns = new ReqAuthPhoneIns
            {
                CenterCode  = intCenterCode,
                ChannelType = strChannelType,
                AuthID      = strAuthID,
                AuthSeqNo   = intAuthSeqNo,
                AuthIdx     = intAuthIdx,
                PhoneIdx    = intPhoneIdx,
                CreateTs    = strCreateTs,
                PhoneNo     = strPhoneNo,
                AdminID     = objSes.AdminID,
                AdminName   = objSes.AdminName
            };

            lo_objResAuthPhoneIns = objCallManageDasServices.InsAuthPhone(lo_objReqAuthPhoneIns);
            objResMap.RetCode     = lo_objResAuthPhoneIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResAuthPhoneIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9430;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 계정 연동 전화번호 수정
    /// </summary>
    protected void SetCMAuthPhoneUpdate()
    {
        ReqAuthPhoneUpd     lo_objReqAuthPhoneUpd;
        ServiceResult<bool> lo_objResAuthPhoneUpd;

        try
        {
            lo_objReqAuthPhoneUpd = new ReqAuthPhoneUpd
            {
                PhoneSeqNo = intPhoneSeqNo,
                PhoneMemo  = strPhoneMemo,
                UseFlag    = strUseFlag,
                AdminID    = objSes.AdminID,
                AdminName  = objSes.AdminName
            };

            lo_objResAuthPhoneUpd = objCallManageDasServices.UpdAuthPhone(lo_objReqAuthPhoneUpd);
            objResMap.RetCode     = lo_objResAuthPhoneUpd.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResAuthPhoneUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9431;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 - DAPI 에서 전화번호 조회 후 등록/수정
    /// </summary>
    protected void GetCMDapiPhoneList()
    {
        ReqCMPhonenoInfo               lo_objReqCMPhonenoInfo;
        ResCMPhonenoInfo               lo_objResCMPhonenoInfo;
        ReqAuthPhoneIns                lo_objReqAuthPhoneIns;
        ServiceResult<ResAuthPhoneIns> lo_objResAuthPhoneIns;

        try
        {
            if (intCenterCode.Equals(0))
            {
                objResMap.RetCode = 9511;
                objResMap.ErrMsg  = "운송사가 선택되지 않았습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strChannelType))
            {
                objResMap.RetCode = 9512;
                objResMap.ErrMsg  = "통신사 정보가 입력되지 않았습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strAuthID))
            {
                objResMap.RetCode = 9513;
                objResMap.ErrMsg  = "계정정보가 입력되지 않았습니다.";
                return;
            }

            lo_objReqCMPhonenoInfo = new ReqCMPhonenoInfo
            {
                site_code        = CommonConstant.WS_DAPI_CM_SITE_CODE,
                site_custom_code = intCenterCode.ToString(),
                channel_type     = strChannelType,
                auth_id          = strAuthID
            };

            lo_objResCMPhonenoInfo = ApiCallManager.GetPhonenoInfo(lo_objReqCMPhonenoInfo);
            if (lo_objResCMPhonenoInfo.ResultCode.IsFail())
            {
                objResMap.RetCode = lo_objResCMPhonenoInfo.ResultCode;
                objResMap.ErrMsg  = lo_objResCMPhonenoInfo.ResultMessage;
                return;
            }

            foreach (var cmResultBody in lo_objResCMPhonenoInfo.ResultBody)
            {
                lo_objReqAuthPhoneIns = new ReqAuthPhoneIns
                {
                    CenterCode  = intCenterCode,
                    ChannelType = strChannelType,
                    AuthID      = strAuthID,
                    AuthSeqNo   = intAuthSeqNo,
                    AuthIdx     = cmResultBody.auth_idx,
                    PhoneIdx    = cmResultBody.idx,
                    CreateTs    = cmResultBody.create_ts,
                    PhoneNo     = cmResultBody.phone_no,
                    AdminID     = objSes.AdminID,
                    AdminName   = objSes.AdminName
                };

                lo_objResAuthPhoneIns = objCallManageDasServices.InsAuthPhone(lo_objReqAuthPhoneIns);
                objResMap.RetCode     = lo_objResAuthPhoneIns.result.ErrorCode;
                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = lo_objResAuthPhoneIns.result.ErrorMsg;
                    return;
                }
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9426;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 어드민 설정 정보 조회
    /// </summary>
    protected void GetCMAdminList()
    {
        ReqCMAdminList                lo_objReqCMAdminList;
        ServiceResult<ResCMAdminList> lo_objResCMAdminList;

        try
        {
            lo_objReqCMAdminList = new ReqCMAdminList
            {
                AdminID  = objSes.AdminID,
                PageSize = intPageSize,
                PageNo   = intPageNo
            };

            lo_objResCMAdminList  = objCallManageDasServices.GetCMAdminList(lo_objReqCMAdminList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCMAdminList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9427;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 어드민 설정 정보 등록/수정
    /// </summary>
    protected void SetCMAdminInsert()
    {
        ReqCMAdminIns       lo_objReqCMAdminIns;
        ServiceResult<bool> lo_objResCMAdminIns;

        try
        {
            lo_objReqCMAdminIns = new ReqCMAdminIns
            {
                AdminID          = objSes.AdminID,
                WebAlarmFlag     = strWebAlarmFlag,
                PCAlarmFlag      = strPCAlarmFlag,
                AutoPopupFlag    = strAutoPopupFlag,
                OrderViewFlag    = strOrderViewFlag,
                CompanyViewFlag  = strCompanyViewFlag,
                PurchaseViewFlag = strPurchaseViewFlag,
                SaleViewFlag     = strSaleViewFlag
            };

            lo_objResCMAdminIns = objCallManageDasServices.InsCMAdmin(lo_objReqCMAdminIns);
            objResMap.RetCode   = lo_objResCMAdminIns.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCMAdminIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9428;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 관리자 연동 전화 번호 관리
    /// </summary>
    protected void SetCMAdminPhoneMultiUpdate()
    {
        ReqCMAdminPhoneMultiUpd lo_objReqCMAdminPhoneMultiUpd;
        ServiceResult<bool>     lo_objResCMAdminPhoneMultiUpd;

        try
        {
            lo_objReqCMAdminPhoneMultiUpd = new ReqCMAdminPhoneMultiUpd
            {
                AdminID      = objSes.AdminID,
                PhoneSeqNos  = strPhoneSeqNos,
                MainUseFlags = strMainUseFlags
            };

            lo_objResCMAdminPhoneMultiUpd = objCallManageDasServices.UpdCMAdminPhoneMulti(lo_objReqCMAdminPhoneMultiUpd);
            objResMap.RetCode             = lo_objResCMAdminPhoneMultiUpd.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCMAdminPhoneMultiUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9428;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CallManagerHandler", "Exception",
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
            // ignored
        }
    }
}