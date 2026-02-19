<%@ WebHandler Language="C#" Class="SmsContent" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using System;
using System.Web;
using CommonLibrary.Extensions;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : MsgSendHandler.ashx
/// Description     : 오더 SMS Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemSmsContent
/// Author          : sybyun96@logislab.com, 2022-08-11
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SmsContent : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Common/MsgSend"; //필수

    // 메소드 리스트
    private const string MethodAllOrderList         = "AllOrderList";         //오더 목록
    private const string MethodSmsContentList       = "SmsContentList";       //문자 즐겨찾기 목록
    private const string MethodSmsContentIns        = "SmsContentIns";        //문자 즐겨찾기 등록
    private const string MethodSmsContentDel        = "SmsContentDel";        //문자 즐겨찾기 삭제
    private const string MethodSendSms              = "SendSms";              //문자 전송
    private const string MethodSendKakaoTalk        = "SendKakaoTalk";        //알림톡 전송
    private const string MethodDriverCellList       = "DriverCellList";       //기사 전화번호, 이름 목록
    private const string MethodCertificateIns       = "CertificateIns";       //표준화물위탁증 SMS
    private const string MethodCarDispatchRefSearch = "CarDispatchRefSearch"; //차량업체 목록
    private const string MethodCMSendSms            = "CMSendSms";            //콜매니저 문자 전송
    
    OrderDasServices         objOrderDasServices         = new OrderDasServices();
    MsgDasServices           objMsgDasServices           = new MsgDasServices();
    OrderDispatchDasServices objOrderDispatchDasServices = new OrderDispatchDasServices();
    CarDispatchDasServices   objCarDispatchDasServices   = new CarDispatchDasServices();
    CallManageDasServices    objCallManageDasServices    = new CallManageDasServices();

    private string strCallType           = string.Empty;
    private int    intPageSize           = 0;
    private int    intPageNo             = 0;
    private string strSmsSeqNo           = string.Empty;
    private string strAdminID            = string.Empty;
    private string strDelFlag            = string.Empty;
    private string strSmsSendCell        = string.Empty;
    private string strSmsTitle           = string.Empty;
    private string strSmsContent         = string.Empty;
    private string strCenterCode         = string.Empty;
    private string strDriverCells        = string.Empty;
    private string strDriverName         = string.Empty;
    private string strOrderNo            = string.Empty;
    private string strOrderNos           = string.Empty;
    private string strSendType           = string.Empty;
    private string strSendUrl            = string.Empty;
    private string strSendCell           = string.Empty;
    private string strRefSeqNo           = string.Empty;
    private string strPickupYMD          = string.Empty;
    private string strPickupHM           = string.Empty;
    private string strPickupPlaceAddr    = string.Empty;
    private string strPickupPlaceAddrDtl = string.Empty;
    private string strCarNo              = string.Empty;
    private string strSndTelNo           = string.Empty;
    private string strRcvName            = string.Empty;
    private string strRcvTelNo           = string.Empty;
    private string strMobileFlag         = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAllOrderList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSmsContentList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSmsContentIns,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSmsContentDel,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSendSms,              MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSendKakaoTalk,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDriverCellList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCertificateIns,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarDispatchRefSearch, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMSendSms,            MenuAuthType.ReadWrite);
        
        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType = SiteGlobal.GetRequestForm("CallType");
            intPageSize = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo   = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

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

            SiteGlobal.WriteLog("SmsContent", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SmsContent");
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
            strSmsSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("SmsSeqNo"), "0");
            strAdminID            = SiteGlobal.GetRequestForm("AdminID");
            strDelFlag            = SiteGlobal.GetRequestForm("DelFlag");
            strSmsSendCell        = SiteGlobal.GetRequestForm("SmsSendCell");
            strSmsTitle           = SiteGlobal.GetRequestForm("SmsTitle");
            strSmsContent         = SiteGlobal.GetRequestForm("SmsContent");
            strDriverCells        = SiteGlobal.GetRequestForm("DriverCells");
            strDriverName         = Utils.IsNull(SiteGlobal.GetRequestForm("DriverName"), "차량기사");
            strCenterCode         = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderNo            = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strOrderNos           = SiteGlobal.GetRequestForm("OrderNos");
            strSendType           = Utils.IsNull(SiteGlobal.GetRequestForm("SendType"), "0");
            strRefSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"), "0");
            strSendUrl            = SiteGlobal.GetRequestForm("SendUrl");
            strSendCell           = Utils.IsNull(SiteGlobal.GetRequestForm("SendCell"), CommonConstant.DEFAULT_SMS_TEL);
            strPickupYMD          = SiteGlobal.GetRequestForm("PickupYMD");
            strPickupHM           = SiteGlobal.GetRequestForm("PickupHM");
            strPickupPlaceAddr    = SiteGlobal.GetRequestForm("PickupPlaceAddr");
            strPickupPlaceAddrDtl = SiteGlobal.GetRequestForm("PickupPlaceAddrDtl");
            strCarNo              = SiteGlobal.GetRequestForm("CarNo");
            strSndTelNo           = SiteGlobal.GetRequestForm("SndTelNo");
            strRcvName            = SiteGlobal.GetRequestForm("RcvName");
            strRcvTelNo           = SiteGlobal.GetRequestForm("RcvTelNo");
            strMobileFlag         = SiteGlobal.GetRequestForm("MobileFlag");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsContent", "Exception",
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
                case MethodSmsContentList:
                    GetSmsContentList();
                    break;
                case MethodSmsContentIns:
                    SetSmsContentIns();
                    break;
                case MethodSmsContentDel:
                    SetSmsContentDel();
                    break;
                case MethodSendSms:
                    SetSendSms();
                    break;
                case MethodSendKakaoTalk:
                    SendKakaoTalk();
                    break;
                case MethodDriverCellList:
                    GetDriverCellList();
                    break;
                case MethodCertificateIns:
                    GetCertificateIns();
                    break;
                case MethodAllOrderList:
                    GetAllOrderList();
                    break;
                case MethodCarDispatchRefSearch:
                    GetCarDispatchRefList();
                    break;
                case MethodCMSendSms:
                    SetCMSendSms();
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

            SiteGlobal.WriteLog("SmsContent", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// sms 즐겨찾기 조회
    /// </summary>
    protected void GetSmsContentList()
    {
        ReqSmsContentList                    lo_objReqSmsContentList     = null;
        ServiceResult<ResSmsContentList>     lo_objResSmsContentList     = null;

        try
        {
            lo_objReqSmsContentList = new ReqSmsContentList
            {
                SmsSeqNo = strSmsSeqNo.ToInt(),
                AdminID  = objSes.AdminID,
                DelFlag  = "N",
                SmsSendCell = strSmsSendCell,
                SmsTitle    = strSmsTitle
            };

            lo_objResSmsContentList = objMsgDasServices.GetSmsContentList(lo_objReqSmsContentList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResSmsContentList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsContent", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

    }

    protected void SetSmsContentIns() {
        SmsContentModel                    lo_objReqSmsContentModel     = null;
        ServiceResult<SmsContentModel>     lo_objResSmsContentModel     = null;


        if (string.IsNullOrWhiteSpace(strSmsTitle))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[제목]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSmsContent))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[내용]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSmsSendCell))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[발신자 번호]";
            return;
        }

        try
        {
            lo_objReqSmsContentModel = new SmsContentModel
            {
                SmsSendCell = strSmsSendCell,
                SmsTitle    = strSmsTitle,
                SmsContent  = strSmsContent,
                AdminID     = objSes.AdminID
            };

            lo_objResSmsContentModel = objMsgDasServices.InsSmsContent(lo_objReqSmsContentModel);
            objResMap.RetCode = lo_objResSmsContentModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSmsContentModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsContent", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

    }

    protected void SetSmsContentDel() {
        SmsContentModel                    lo_objReqSmsContentModel     = null;
        ServiceResult<SmsContentModel>     lo_objResSmsContentModel     = null;


        if (string.IsNullOrWhiteSpace(strSmsSeqNo) || strSmsSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[일련번호]";
            return;
        }

        try
        {
            lo_objReqSmsContentModel = new SmsContentModel
            {
                SmsSeqNo = strSmsSeqNo.ToInt(),
                AdminID  = objSes.AdminID
            };

            lo_objResSmsContentModel = objMsgDasServices.DelSmsContent(lo_objReqSmsContentModel);
            objResMap.RetCode = lo_objResSmsContentModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSmsContentModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsContent", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

    }
    protected void SetSendSms() {
        SmsContentModel                    lo_objReqSmsContentModel     = null;
        ServiceResult<SmsContentModel>     lo_objResSmsContentModel     = null;

        try
        {
            lo_objReqSmsContentModel = new SmsContentModel
            {
                CenterCode  = strCenterCode,
                SmsSendCell = strSmsSendCell,
                DriverCells  = strDriverCells,
                DriverName  = strDriverName,
                SmsTitle    = strSmsTitle,
                SmsContent = strSmsContent
            };

            lo_objResSmsContentModel = objMsgDasServices.InsSmsSendRequest(lo_objReqSmsContentModel);
            objResMap.RetCode = lo_objResSmsContentModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSmsContentModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsContent", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void SendKakaoTalk() {
        KakaoTalkModel                    lo_objReqKakaoTalkModel     = null;
        ServiceResult<KakaoTalkModel>     lo_objResKakaoTalkModel     = null;

        try
        {
            if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
            {
                objResMap.RetCode = 9001;
                objResMap.ErrMsg  = "필요한 값이 없습니다.[오더번호]";
                return;
            }

            if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사코드]";
                return;
            }

            if (string.IsNullOrWhiteSpace(strRefSeqNo) || strRefSeqNo.Equals("0"))
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            lo_objReqKakaoTalkModel = new KakaoTalkModel
            {
                CenterCode         = strCenterCode.ToInt(),
                SendType           = strSendType.ToInt(),
                OrderNo            = strOrderNo.ToInt64(),
                RefSeqNo           = strRefSeqNo.ToInt64(),
                PickupYMD          = strPickupYMD,
                PickupHM           = strPickupHM,
                PickupPlaceAddr    = strPickupPlaceAddr,
                PickupPlaceAddrDtl = strPickupPlaceAddrDtl,
                RegAdminID         = objSes.AdminID
            };

            lo_objResKakaoTalkModel = objMsgDasServices.InsKakaoSendRequest(lo_objReqKakaoTalkModel);
            objResMap.RetCode = lo_objResKakaoTalkModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResKakaoTalkModel.result.ErrorMsg;
            }else{
                objResMap.Add("TotalCnt", lo_objResKakaoTalkModel.data.TotalCnt);
                objResMap.Add("ResultCnt", lo_objResKakaoTalkModel.data.ResultCnt);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsContent", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    /// <summary>
    /// sms 즐겨찾기 조회
    /// </summary>
    protected void GetDriverCellList()
    {
        ReqOrderDispatchList                    lo_objReqOrderDispatchList     = null;
        ServiceResult<ResOrderDispatchList>     lo_objResOrderDispatchList     = null;

        try
        {
            lo_objReqOrderDispatchList = new ReqOrderDispatchList
            {
                CenterCode = strCenterCode.ToInt(),
                OrderNos  = strOrderNos
            };

            lo_objResOrderDispatchList = objOrderDispatchDasServices.GetDispatchDriverCellList(lo_objReqOrderDispatchList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderDispatchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsContent", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

    }

    protected void GetCertificateIns() {
        SmsContentModel                    lo_objReqSmsContentModel     = null;
        ServiceResult<SmsContentModel>     lo_objResSmsContentModel     = null;

        try
        {
            lo_objReqSmsContentModel = new SmsContentModel
            {
                CenterCode  = strCenterCode,
                OrderNos    = strOrderNos,
                SendUrl     = SiteGlobal.SMS_DOMAIN + strSendUrl,
                SendNum     = strSendCell
            };

            lo_objResSmsContentModel = objMsgDasServices.InsCertSendRequest(lo_objReqSmsContentModel);
            objResMap.RetCode = lo_objResSmsContentModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSmsContentModel.result.ErrorMsg;
            }
            else { 
                objResMap.Add("SuccCnt", lo_objResSmsContentModel.data.SuccCnt);    
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9506;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsContent", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 통합 오더 현황 목록
    /// </summary>
    protected void GetAllOrderList()
    {
        ReqOrderList                lo_objReqOrderList = null;
        ServiceResult<ResOrderList> lo_objResOrderList = null;
        int                         lo_intListType     = 3;

        if (strOrderNo.Equals("0") && strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderList = new ReqOrderList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                ListType                = lo_intListType.ToInt(),
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode
            };

            lo_objResOrderList = objOrderDasServices.GetOrderList(lo_objReqOrderList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9507;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsContent", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    
    /// <summary>
    /// 배차 차량검색
    /// </summary>
    protected void GetCarDispatchRefList()
    {
        ReqCarDispatchRefSearchList                lo_objReqCarDispatchRefSearchList = null;
        ServiceResult<ResCarDispatchRefSearchList> lo_objResCarDispatchRefSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarDispatchRefSearchList = new ReqCarDispatchRefSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                CarNo            = strCarNo,
                UseFlag          = "Y",
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResCarDispatchRefSearchList = objCarDispatchDasServices.GetCarDispatchRefSearchList(lo_objReqCarDispatchRefSearchList);
            objResMap.strResponse             = "[" + JsonConvert.SerializeObject(lo_objResCarDispatchRefSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9502;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MsgSendHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 콜매니저 문자전송
    /// </summary>
    protected void SetCMSendSms()
    {
        ReqCMAdminList                     lo_objReqCMAdminList                  = null;
        ServiceResult<ResCMAdminList>      lo_objResCMAdminList                  = null;
        ReqCMOutBoundCall                  lo_objReqCMOutBoundCall               = null;
        ResCMCommon                        lo_objResCMOutBoundCall               = null;
        ReqCMAdminPhoneList                lo_objReqCMAdminPhoneList             = null;
        ServiceResult<ResCMAdminPhoneList> lo_objResCMAdminPhoneList             = null;
        ReqCMSendGoogleDataMessage         lo_objReqCMSendGoogleDataMessage      = null;
        ResCMSendGoogleDataMessage         lo_objResCMSendGoogleDataMessage      = null;
        CMSendGoogleDataMessageDataJson    lo_objCMSendGoogleDataMessageDataJson = null;
        ReqCMLogIns                        lo_objReqCMLogIns                     = null;

        if (string.IsNullOrWhiteSpace(strSndTelNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRcvTelNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            if (strMobileFlag.Equals("Y")) //휴대폰 어플 호출
            {
                lo_objReqCMAdminList = new ReqCMAdminList
                {
                    AdminID  = objSes.AdminID,
                    PageSize = 1,
                    PageNo   = 1
                };

                lo_objResCMAdminList = objCallManageDasServices.GetCMAdminList(lo_objReqCMAdminList);

                if (lo_objResCMAdminList.result.ErrorCode.IsFail())
                {
                    objResMap.RetCode = lo_objResCMAdminList.result.ErrorCode;
                    objResMap.ErrMsg  = lo_objResCMAdminList.result.ErrorMsg;
                    return;
                }

                if (!lo_objResCMAdminList.data.RecordCnt.Equals(1))
                {
                    objResMap.RetCode = 9003;
                    objResMap.ErrMsg  = "조회된 콜매니저 설정 정보가 없습니다.";
                    return;
                }

                if (!lo_objResCMAdminList.data.list[0].AppUseFlag.Equals("Y"))
                {
                    objResMap.RetCode = 9004;
                    objResMap.ErrMsg  = "콜매니저 어플리케이션 사용 설정이 올바르지 않습니다.(1)";
                    return;
                }

                if (!lo_objResCMAdminList.data.list[0].AppMobileNo.Equals(strSndTelNo))
                {
                    objResMap.RetCode = 9005;
                    objResMap.ErrMsg  = "콜매니저 어플리케이션 사용 설정이 올바르지 않습니다.(2)";
                    return;
                }

                lo_objCMSendGoogleDataMessageDataJson = new CMSendGoogleDataMessageDataJson
                {
                    MsgType = "SendSMS",
                    Title   = "콜매니저 문자전송",
                    MsgBody = Utils.SetPhoneNoDashed(strRcvTelNo) + "로 문자전송을 요청합니다.",
                    SMSText = strSmsContent,
                    PhoneNo = strRcvTelNo
                };

                lo_objReqCMSendGoogleDataMessage = new ReqCMSendGoogleDataMessage
                {
                    ProjectID = "callmanagerapp",
                    Token     = lo_objResCMAdminList.data.list[0].AppDeviceToken,
                    DataJson  = JsonConvert.SerializeObject(lo_objCMSendGoogleDataMessageDataJson)
                };

                lo_objResCMSendGoogleDataMessage = ApiCallManager.SetSendGoogleDataMessage(lo_objReqCMSendGoogleDataMessage);

                if (lo_objResCMSendGoogleDataMessage.Header.ResultCode.IsFail())
                {
                    objResMap.RetCode = 9007;
                    objResMap.ErrMsg  = "어플리케이션 문자전송요청에 실패했습니다.";
                    return;
                }

                lo_objReqCMLogIns = new ReqCMLogIns
                {
                    CenterCode  = strCenterCode.ToInt(),
                    CallType    = 2,
                    CallKind    = "sms",
                    ChannelType = "callmanagerapp",
                    CallNumber  = strRcvTelNo,
                    SendName    = objSes.AdminName,
                    SendNumber  = strSndTelNo,
                    RcvName     = strRcvName,
                    RcvNumber   = strRcvTelNo,
                    Message     = strSmsContent
                };
                    
                SetCMLogIns(lo_objReqCMLogIns);

                objResMap.RetCode = 0;
                objResMap.ErrMsg  = "어플리케이션 문자전송요청에 성공했습니다.";
            }
            else //DAPI 호출
            {
                lo_objReqCMAdminPhoneList = new ReqCMAdminPhoneList
                {
                    AdminID     = objSes.AdminID,
                    PhoneSeqNo  = 0,
                    PhoneNo     = strSndTelNo,
                    MainUseFlag = "",
                    UseFlag     = "Y",
                    PageSize    = 1,
                    PageNo      = 1
                };

                lo_objResCMAdminPhoneList = objCallManageDasServices.GetCMAdminPhoneList(lo_objReqCMAdminPhoneList);

                if (lo_objResCMAdminPhoneList.result.ErrorCode.IsFail())
                {
                    objResMap.RetCode = lo_objResCMAdminPhoneList.result.ErrorCode;
                    objResMap.ErrMsg  = lo_objResCMAdminPhoneList.result.ErrorMsg;
                    return;
                }

                if (!lo_objResCMAdminPhoneList.data.RecordCnt.Equals(1))
                {
                    objResMap.RetCode = 9006;
                    objResMap.ErrMsg  = "조회된 콜매니저 연락처 정보가 없습니다.";
                    return;
                }

                lo_objReqCMOutBoundCall = new ReqCMOutBoundCall
                {
                    caller       = strSndTelNo,
                    callee       = strRcvTelNo,
                    channel_type = lo_objResCMAdminPhoneList.data.list[0].ChannelType,
                    kind         = "sms",
                    message      = strSmsContent,
                    site_code    = "logiman"
                };

                lo_objResCMOutBoundCall = ApiCallManager.InsOutboundCall(lo_objReqCMOutBoundCall);

                if (lo_objResCMOutBoundCall.ResultCode.IsFail())
                {
                    objResMap.RetCode = 9007;
                    objResMap.ErrMsg  = "문자전송요청에 실패했습니다.";
                    return;
                }

                lo_objReqCMLogIns = new ReqCMLogIns
                {
                    CenterCode  = strCenterCode.ToInt(),
                    CallType    = 2,
                    CallKind    = "sms",
                    ChannelType = lo_objResCMAdminPhoneList.data.list[0].ChannelType,
                    CallNumber  = strRcvTelNo,
                    SendName    = objSes.AdminName,
                    SendNumber  = strSndTelNo,
                    RcvName     = strRcvName,
                    RcvNumber   = strRcvTelNo,
                    AuthID      = lo_objResCMAdminPhoneList.data.list[0].AuthID,
                    Message     = strSmsContent
                };
                    
                SetCMLogIns(lo_objReqCMLogIns);

                objResMap.RetCode = 0;
                objResMap.ErrMsg  = "문자전송요청에 성공했습니다.";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MsgSendHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

    }

    /// <summary>
    /// 로그 등록
    /// </summary>
    /// <param name="objReqCmLogIns"></param>
    /// <returns></returns>
    protected ServiceResult<ResCMLogIns> SetCMLogIns(ReqCMLogIns objReqCmLogIns)
    {
        ServiceResult<ResCMLogIns>      lo_objResCMLogIns      = null;
        ReqCallerInfoGet                lo_objReqCallerInfoGet = null;
        ServiceResult<ResCallerInfoGet> lo_objResCallerInfoGet = null;
        try
        {
            if (string.IsNullOrWhiteSpace(objReqCmLogIns.RcvName))
            {
                lo_objReqCallerInfoGet = new ReqCallerInfoGet
                {
                    CenterCode = objReqCmLogIns.CenterCode,
                    CustTelNo  = objReqCmLogIns.RcvNumber
                };

                lo_objResCallerInfoGet = objCallManageDasServices.GetCallerInfo(lo_objReqCallerInfoGet);

                if (lo_objResCallerInfoGet.result.ErrorCode.IsSuccess())
                {
                    objReqCmLogIns.RcvName = string.IsNullOrWhiteSpace(lo_objResCallerInfoGet.data.ComName)
                        ? lo_objResCallerInfoGet.data.Name
                        : lo_objResCallerInfoGet.data.Name + "(" + lo_objResCallerInfoGet.data.ComName + ")";
                }
            }

            lo_objResCMLogIns = objCallManageDasServices.SetCMLogIns(objReqCmLogIns);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("MsgSendHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        return lo_objResCMLogIns;
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