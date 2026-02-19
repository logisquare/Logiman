<%@ WebHandler Language="C#" Class="CMCallDetailHandler" %>
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
/// FileName        : CMCallDetailHandler.ashx
/// Description     : 콜매니저
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2025-08-13
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class CMCallDetailHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/CallManager/CMCallDetail"; //필수

    // 메소드 리스트
    private const string MethodCMAdminPhoneList           = "CMAdminPhoneList";           //사용자 수신번호 리스트
    private const string MethodCMDetailCardList           = "CMDetailCardList";           //카드리스트(상세페이지)
    private const string MethodCMDetailInfoList           = "CMDetailInfoList";           //정보리스트(상세페이지)
    private const string MethodCMDetailCallLogList        = "CMDetailCallLogList";        //로그리스트(상세페이지)
    private const string MethodCMSendMsgList              = "CMSendMsgList";              //메시지전송리스트
    private const string MethodCMCarDispatchRefList       = "CMCarDispatchRefList";       //차량리스트
    private const string MethodCMOrderList                = "CMOrderList";                //오더리스트
    private const string MethodCMOrderDispatchList        = "CMOrderDispatchList";        //배차오더리스트
    private const string MethodCMOrderSaleClosingList     = "CMOrderSaleClosingList";     //매출마감리스트
    private const string MethodCMOrderPurchaseClosingList = "CMOrderPurchaseClosingList"; //매입마감리스트
    private const string MethodCMMemoIns                  = "CMMemoInsert";               //메모등록
    private const string MethodCMMemoDel                  = "CMMemoDelete";               //메모삭제
    private const string MethodCMClassifyIns              = "CMClassifyInsert";           //분류 등록수정
    private const string MethodCMCallerInfoGet            = "CMCallerInfoGet";            //발신자 정보 조회
    private const string MethodCMSendCall                 = "CMSendCall";                 //전화걸기
        
    CallManageDasServices  objCallManageDasServices  = new CallManageDasServices();
    ClientDasServices      objClientDasServices      = new ClientDasServices();
    CarDispatchDasServices objCarDispatchDasServices = new CarDispatchDasServices();

    private string strCallType           = string.Empty;
    private int    intPageSize           = 0;
    private int    intPageNo             = 0;
    private string strCenterCode         = string.Empty;
    private string strCallerType         = string.Empty;
    private string strCallerDetailType   = string.Empty;
    private string strSndTelNo           = string.Empty;
    private string strClientCode         = string.Empty;
    private string strClientAdminID      = string.Empty;
    private string strRefSeqNo           = string.Empty;
    private string strComCode            = string.Empty;
    private string strClassType          = string.Empty;
    private string strCallViewFlag       = string.Empty;
    private string strSeqNo              = string.Empty;
    private string strCompanyMemo        = string.Empty;
    private string strMemoSeqNo          = string.Empty;
    private string strRcvName            = string.Empty;
    private string strRcvTelNo           = string.Empty;
    private string strMobileFlag         = string.Empty;
    private string strAdminPhoneOnlyFlag = string.Empty;
    private string strCallerDetailText   = string.Empty;
    private string strComName            = string.Empty;
    private string strCeoName            = string.Empty;
    private string strName               = string.Empty;

    private HttpContext objHttpContext       = null;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCMAdminPhoneList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMDetailCardList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMDetailInfoList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMDetailCallLogList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMSendMsgList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMCarDispatchRefList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMOrderList,                MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMOrderDispatchList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMOrderPurchaseClosingList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMOrderSaleClosingList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMMemoIns,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCMMemoDel,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCMClassifyIns,              MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCMCallerInfoGet,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCMSendCall,                 MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CMCallDetailHandler");
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
            strCenterCode         = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),       "0");
            strCallerType         = Utils.IsNull(SiteGlobal.GetRequestForm("CallerType"),       "0");
            strCallerDetailType   = Utils.IsNull(SiteGlobal.GetRequestForm("CallerDetailType"), "0");
            strSndTelNo           = SiteGlobal.GetRequestForm("SndTelNo");
            strClientCode         = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strClientAdminID      = SiteGlobal.GetRequestForm("ClientAdminID");
            strRefSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"),  "0");
            strComCode            = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"),   "0");
            strClassType          = Utils.IsNull(SiteGlobal.GetRequestForm("ClassType"), "0");
            strCallViewFlag       = SiteGlobal.GetRequestForm("CallViewFlag");
            strCompanyMemo        = SiteGlobal.GetRequestForm("CompanyMemo");
            strSeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),     "0");
            strMemoSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("MemoSeqNo"), "0");
            strRcvName            = SiteGlobal.GetRequestForm("RcvName");
            strRcvTelNo           = SiteGlobal.GetRequestForm("RcvTelNo");
            strMobileFlag         = SiteGlobal.GetRequestForm("MobileFlag");
            strAdminPhoneOnlyFlag = Utils.IsNull(SiteGlobal.GetRequestForm("AdminPhoneOnlyFlag"), "N");
            strCallerDetailText   = SiteGlobal.GetRequestForm("CallerDetailText");
            strComName            = SiteGlobal.GetRequestForm("ComName");
            strCeoName            = SiteGlobal.GetRequestForm("CeoName");
            strName               = SiteGlobal.GetRequestForm("Name");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
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
                case MethodCMAdminPhoneList:
                    GetCMAdminPhoneList();
                    break;
                case MethodCMDetailCardList:
                    GetCMCallerDetailInfoList();
                    break;
                case MethodCMDetailInfoList:
                    GetCMDetailInfoList();
                    break;
                case MethodCMDetailCallLogList:
                    GetCMDetailCallLogList();
                    break;
                case MethodCMSendMsgList:
                    GetCMMessageSendLogList();
                    break;
                case MethodCMCarDispatchRefList:
                    GetCMCarDispatchRefList();
                    break;
                case MethodCMOrderList:
                    GetCMOrderList();
                    break;
                case MethodCMOrderDispatchList:
                    GetCMOrderDispatchList();
                    break;
                case MethodCMOrderPurchaseClosingList:
                    GetCMOrderPurchaseClosingList();
                    break;
                case MethodCMOrderSaleClosingList:
                    GetCMOrderSaleClosingList();
                    break;
                case MethodCMMemoIns:
                    SetCMMemoIns();
                    break;
                case MethodCMMemoDel:
                    SetCMMemoDel();
                    break;
                case MethodCMClassifyIns:
                    SetCMClassifyIns();
                    break;
                case MethodCMCallerInfoGet:
                    GetCMCallerInfoGet();
                    break;
                case MethodCMSendCall:
                    SetCMSendCall();
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

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 사용자 수신번호 리스트
    /// </summary>
    protected void GetCMAdminPhoneList()
    {
        ReqCMAdminPhoneList                lo_objReqCMAdminPhoneList = null;
        ServiceResult<ResCMAdminPhoneList> lo_objResCMAdminPhoneList = null;
        ReqCMAdminList                     lo_objReqCMAdminList      = null;
        ServiceResult<ResCMAdminList>      lo_objResCMAdminList      = null;
        int                                lo_intPhoneSeqNo          = 0;
        string                             lo_strMainUseFlag         = string.Empty;
        string                             lo_strUseFlag             = "Y";

        try
        {
            lo_objReqCMAdminPhoneList = new ReqCMAdminPhoneList
            {
                AdminID     = objSes.AdminID,
                PhoneSeqNo  = lo_intPhoneSeqNo,
                MainUseFlag = lo_strMainUseFlag,
                UseFlag     = lo_strUseFlag,
                PageSize    = 100,
                PageNo      = 1
            };

            lo_objResCMAdminPhoneList = objCallManageDasServices.GetCMAdminPhoneList(lo_objReqCMAdminPhoneList);

            lo_objReqCMAdminList = new ReqCMAdminList
            {
                AdminID  = objSes.AdminID,
                PageSize = 1,
                PageNo   = 1
            };

            lo_objResCMAdminList = objCallManageDasServices.GetCMAdminList(lo_objReqCMAdminList);

            if (lo_objResCMAdminList.result.ErrorCode.IsSuccess())
            {
                if (lo_objResCMAdminList.data.RecordCnt.Equals(1) && !strAdminPhoneOnlyFlag.Equals("Y"))
                {
                    if (lo_objResCMAdminList.data.list[0].AppUseFlag.Equals("Y"))
                    {
                        lo_objResCMAdminPhoneList.data.list.Add(new CMAdminPhoneModel
                        {
                            AdminID     = objSes.AdminID,
                            PhoneSeqNo  = 0,
                            MainUseFlag = "N",
                            ChannelType = "callmanagerapp",
                            PhoneNo     = lo_objResCMAdminList.data.list[0].AppMobileNo,
                            PhoneMemo   = "콜매니저 휴대폰 연동",
                            UseFlag     = "Y"
                        });
                        lo_objResCMAdminPhoneList.data.RecordCnt++;
                    }
                }
            }

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCMAdminPhoneList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 카드리스트(상세페이지)
    /// </summary>
    protected void GetCMCallerDetailInfoList()
    {
        ReqCMCallerDetailInfoList                lo_objReqCMCallerDetailInfoList = null;
        ServiceResult<ResCMCallerDetailInfoList> lo_objResCMCallerDetailInfoList = null;

        try
        {
            lo_objReqCMCallerDetailInfoList = new ReqCMCallerDetailInfoList
            {
                CenterCode = strCenterCode.ToInt(),
                CustTelNo  = strSndTelNo
            };

            lo_objResCMCallerDetailInfoList = objCallManageDasServices.GetCMCallerDetailInfoList(lo_objReqCMCallerDetailInfoList);

            if (lo_objResCMCallerDetailInfoList.result.ErrorCode.IsSuccess())
            {
                if (lo_objResCMCallerDetailInfoList.data.RecordCnt > 0)
                {
                    lo_objResCMCallerDetailInfoList.data.list.ForEach(u => u.SeqNo      = strSeqNo);
                    lo_objResCMCallerDetailInfoList.data.list.ForEach(u => u.CenterCode = strCenterCode.ToInt());
                    lo_objResCMCallerDetailInfoList.data.list.ForEach(u => u.SndTelNo   = strSndTelNo);
                    lo_objResCMCallerDetailInfoList.data.list.ForEach(u => u.RcvTelNo   = strRcvTelNo);
                }
            }

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCMCallerDetailInfoList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상세페이지 정보목록(오더, 마감 등)
    /// </summary>
    protected void GetCMDetailInfoList()
    {
        ResCMInfoList                          lo_objResCMInfoList           = new ResCMInfoList();
        ReqCMAdminList                         lo_objReqCMAdminList          = null;
        ServiceResult<ResCMAdminList>          lo_objResCMAdminList          = null;
        ReqCMAdminMenuAccessChk                lo_objReqCMAdminMenuAccessChk = null;
        ServiceResult<ResCMAdminMenuAccessChk> lo_objResCMAdminMenuAccessChk = null;

        if (string.IsNullOrWhiteSpace(strCallerType) || strCallerType.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCallerDetailType) || strCallerDetailType.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResCMInfoList.OrderViewFlag    = "N";
            lo_objResCMInfoList.CompanyViewFlag  = "N";
            lo_objResCMInfoList.PurchaseViewFlag = "N";
            lo_objResCMInfoList.SaleViewFlag     = "N";

            //설정정보 조회
            lo_objReqCMAdminList = new ReqCMAdminList
            {
                AdminID  = objSes.AdminID,
                PageSize = 1,
                PageNo   = 1
            };

            lo_objResCMAdminList = objCallManageDasServices.GetCMAdminList(lo_objReqCMAdminList);

            if (lo_objResCMAdminList.result.ErrorCode.IsSuccess())
            {
                if (lo_objResCMAdminList.data.RecordCnt > 0)
                {
                    lo_objResCMInfoList.OrderViewFlag    = lo_objResCMAdminList.data.list[0].OrderViewFlag;
                    lo_objResCMInfoList.CompanyViewFlag  = lo_objResCMAdminList.data.list[0].CompanyViewFlag;
                    lo_objResCMInfoList.PurchaseViewFlag = lo_objResCMAdminList.data.list[0].PurchaseViewFlag;
                    lo_objResCMInfoList.SaleViewFlag     = lo_objResCMAdminList.data.list[0].SaleViewFlag;
                }
            }

            //메뉴 권한 체크
            lo_objReqCMAdminMenuAccessChk = new ReqCMAdminMenuAccessChk
            {
                AdminID   = objSes.AdminID,
                GradeCode = objSes.GradeCode
            };

            lo_objResCMAdminMenuAccessChk = objCallManageDasServices.GetCMAdminMenuAccessChk(lo_objReqCMAdminMenuAccessChk);
            
            lo_objResCMInfoList.OrderViewFlag    = lo_objResCMAdminMenuAccessChk.data.OrderViewFlag.Equals("Y") ? lo_objResCMInfoList.OrderViewFlag : "N";
            lo_objResCMInfoList.CompanyViewFlag  = lo_objResCMAdminMenuAccessChk.data.CompanyViewFlag.Equals("Y") ? lo_objResCMInfoList.CompanyViewFlag : "N";
            lo_objResCMInfoList.PurchaseViewFlag = lo_objResCMAdminMenuAccessChk.data.PurchaseViewFlag.Equals("Y") ? lo_objResCMInfoList.PurchaseViewFlag : "N";
            lo_objResCMInfoList.SaleViewFlag     = lo_objResCMAdminMenuAccessChk.data.SaleViewFlag.Equals("Y") ? lo_objResCMInfoList.SaleViewFlag : "N";

            if (strCallerType.Equals("1")) //기사, 차량업체
            {
                //1. 차량업체 비고 (기사만)
                if (strCallerDetailType.Equals("31") && !string.IsNullOrWhiteSpace(strRefSeqNo) && !strRefSeqNo.Equals("0"))
                {

                    ReqCarDispatchList                lo_objReqCarDispatchList = null;
                    ServiceResult<ResCarDispatchList> lo_objResCarDispatchList = null;

                    lo_objReqCarDispatchList = new ReqCarDispatchList
                    {
                        CenterCode       = strCenterCode.ToInt(),
                        RefSeqNo         = strRefSeqNo.ToInt64(),
                        GradeCode        = objSes.GradeCode,
                        AccessCenterCode = objSes.AccessCenterCode,
                        PageSize         = 1,
                        PageNo           = 1
                    };

                    lo_objResCarDispatchList = objCarDispatchDasServices.GetCarDispatchList(lo_objReqCarDispatchList);

                    if (lo_objResCarDispatchList.data.RecordCnt.Equals(1))
                    {
                        lo_objResCMInfoList.RefNote = lo_objResCarDispatchList.data.list[0].RefNote;
                    }
                }

                //2. 오더현황
                if(lo_objResCMInfoList.OrderViewFlag.Equals("Y"))
                {
                    ReqCMOrderDispatchList                lo_objReqCMOrderDispatchList = null;
                    ServiceResult<ResCMOrderDispatchList> lo_objResCMOrderDispatchList = null;

                    lo_objReqCMOrderDispatchList = new ReqCMOrderDispatchList
                    {
                        CenterCode       = strCenterCode.ToInt(),
                        CallerType       = strCallerType.ToInt(),
                        CallerDetailType = strCallerDetailType.ToInt(),
                        SndTelNo         = strSndTelNo,
                        RefSeqNo         = strRefSeqNo.ToInt64(),
                        ComCode          = strComCode.ToInt64(),
                        AdminID          = objSes.AdminID,
                        AccessCenterCode = objSes.AccessCenterCode,
                        PageSize         = 20,
                        PageNo           = 1
                    };

                    lo_objResCMOrderDispatchList               = objCallManageDasServices.GetCMOrderDispatchList(lo_objReqCMOrderDispatchList);
                    lo_objResCMInfoList.OrderDispatchList      = lo_objResCMOrderDispatchList.data.list;
                    lo_objResCMInfoList.OrderDispatchRecordCnt = lo_objResCMOrderDispatchList.data.RecordCnt;
                }

                //3. 매입마감현황
                if (lo_objResCMInfoList.PurchaseViewFlag.Equals("Y"))
                {
                    ReqCMOrderPurchaseClosingList                lo_objReqCMOrderPurchaseClosingList = null;
                    ServiceResult<ResCMOrderPurchaseClosingList> lo_objResCMOrderPurchaseClosingList = null;

                    lo_objReqCMOrderPurchaseClosingList = new ReqCMOrderPurchaseClosingList
                    {
                        CenterCode       = strCenterCode.ToInt(),
                        CallerType       = strCallerType.ToInt(),
                        CallerDetailType = strCallerDetailType.ToInt(),
                        SndTelNo         = strSndTelNo,
                        RefSeqNo         = strRefSeqNo.ToInt64(),
                        ComCode          = strComCode.ToInt64(),
                        AdminID          = objSes.AdminID,
                        AccessCenterCode = objSes.AccessCenterCode,
                        PageSize         = 20,
                        PageNo           = 1
                    };

                    lo_objResCMOrderPurchaseClosingList               = objCallManageDasServices.GetCMOrderPurchaseClosingList(lo_objReqCMOrderPurchaseClosingList);
                    lo_objResCMInfoList.OrderPurchaseClosingList      = lo_objResCMOrderPurchaseClosingList.data.list;
                    lo_objResCMInfoList.OrderPurchaseClosingRecordCnt = lo_objResCMOrderPurchaseClosingList.data.RecordCnt;
                }

                //4. 차량현황 (업체만)
                if (lo_objResCMInfoList.CompanyViewFlag.Equals("Y"))
                {
                    if ((strCallerDetailType.Equals("32") || strCallerDetailType.Equals("33")) && !string.IsNullOrWhiteSpace(strComCode) && !strComCode.Equals("0"))
                    {
                        ReqCMCarDispatchRefList                lo_objReqCMCarDispatchRefList = null;
                        ServiceResult<ResCMCarDispatchRefList> lo_objResCMCarDispatchRefList = null;

                        lo_objReqCMCarDispatchRefList = new ReqCMCarDispatchRefList
                        {
                            CenterCode       = strCenterCode.ToInt(),
                            CallerType       = strCallerType.ToInt(),
                            CallerDetailType = strCallerDetailType.ToInt(),
                            SndTelNo         = strSndTelNo,
                            RefSeqNo         = strRefSeqNo.ToInt64(),
                            ComCode          = strComCode.ToInt64(),
                            AdminID          = objSes.AdminID,
                            AccessCenterCode = objSes.AccessCenterCode,
                            PageSize         = 20,
                            PageNo           = 1
                        };

                        lo_objResCMCarDispatchRefList               = objCallManageDasServices.GetCMCarDispatchRefList(lo_objReqCMCarDispatchRefList);
                        lo_objResCMInfoList.CarDispatchRefList      = lo_objResCMCarDispatchRefList.data.list;
                        lo_objResCMInfoList.CarDispatchRefRecordCnt = lo_objResCMCarDispatchRefList.data.RecordCnt;
                    }
                }

                //5. 메시지 전송 내역
                ReqCMMessageSendLogList                lo_objReqCMMessageSendLogList = null;
                ServiceResult<ResCMMessageSendLogList> lo_objResCMMessageSendLogList = null;

                lo_objReqCMMessageSendLogList = new ReqCMMessageSendLogList
                {
                    CenterCode       = strCenterCode.ToInt(),
                    RcvNumber        = strSndTelNo,
                    AccessCenterCode = objSes.AccessCenterCode,
                    PageSize         = 20,
                    PageNo           = 1
                };

                lo_objResCMMessageSendLogList               = objCallManageDasServices.GetCMMessageSendLogList(lo_objReqCMMessageSendLogList);
                lo_objResCMInfoList.MessageSendLogList      = lo_objResCMMessageSendLogList.data.list;
                lo_objResCMInfoList.MessageSendLogRecordCnt = lo_objResCMMessageSendLogList.data.RecordCnt;
            }
            else if (strCallerType.Equals("2")) //고객사
            {
                //1. 고객사 비고
                if (!strCallerDetailType.Equals("72") && !string.IsNullOrWhiteSpace(strClientCode) && !strClientCode.Equals("0"))
                {
                    ReqClientList                lo_objReqClientList = null;
                    ServiceResult<ResClientList> lo_objResClientList = null;

                    lo_objReqClientList = new ReqClientList
                    {
                        CenterCode       = strCenterCode.ToInt(),
                        ClientCode       = strClientCode.ToInt(),
                        AccessCenterCode = objSes.AccessCenterCode,
                        PageSize         = 1,
                        PageNo           = 1
                    };

                    lo_objResClientList = objClientDasServices.GetClientList(lo_objReqClientList);

                    if (lo_objResClientList.data.RecordCnt.Equals(1))
                    {
                        lo_objResCMInfoList.ClientNote1 = lo_objResClientList.data.list[0].ClientNote1;
                        lo_objResCMInfoList.ClientNote2 = lo_objResClientList.data.list[0].ClientNote2;
                        lo_objResCMInfoList.ClientNote3 = lo_objResClientList.data.list[0].ClientNote3;
                        lo_objResCMInfoList.ClientNote4 = lo_objResClientList.data.list[0].ClientNote4;
                    }
                }

                //2. 오더현황
                if (lo_objResCMInfoList.OrderViewFlag.Equals("Y"))
                {
                    ReqCMOrderList                lo_objReqCMOrderList = null;
                    ServiceResult<ResCMOrderList> lo_objResCMOrderList = null;

                    lo_objReqCMOrderList = new ReqCMOrderList
                    {
                        CenterCode       = strCenterCode.ToInt(),
                        CallerType       = strCallerType.ToInt(),
                        CallerDetailType = strCallerDetailType.ToInt(),
                        SndTelNo         = strSndTelNo,
                        ClientCode       = strClientCode.ToInt64(),
                        ClientAdminID    = strClientAdminID,
                        AdminID          = objSes.AdminID,
                        AccessCenterCode = objSes.AccessCenterCode,
                        PageSize         = 20,
                        PageNo           = 1
                    };

                    lo_objResCMOrderList               = objCallManageDasServices.GetCMOrderList(lo_objReqCMOrderList);
                    lo_objResCMInfoList.OrderList      = lo_objResCMOrderList.data.list;
                    lo_objResCMInfoList.OrderRecordCnt = lo_objResCMOrderList.data.RecordCnt;
                }

                //3. 매출마감현황
                if (lo_objResCMInfoList.SaleViewFlag.Equals("Y"))
                {
                    if (!strCallerDetailType.Equals("72") && !string.IsNullOrWhiteSpace(strClientCode) && !strClientCode.Equals("0"))
                    {
                        ReqCMOrderSaleClosingList                lo_objReqCMOrderSaleClosingList = null;
                        ServiceResult<ResCMOrderSaleClosingList> lo_objResCMOrderSaleClosingList = null;

                        lo_objReqCMOrderSaleClosingList = new ReqCMOrderSaleClosingList
                        {
                            CenterCode       = strCenterCode.ToInt(),
                            CallerType       = strCallerType.ToInt(),
                            CallerDetailType = strCallerDetailType.ToInt(),
                            SndTelNo         = strSndTelNo,
                            ClientCode       = strClientCode.ToInt64(),
                            ClientAdminID    = strClientAdminID,
                            AdminID          = objSes.AdminID,
                            AccessCenterCode = objSes.AccessCenterCode,
                            PageSize         = 20,
                            PageNo           = 1
                        };

                        lo_objResCMOrderSaleClosingList               = objCallManageDasServices.GetCMOrderSaleClosingList(lo_objReqCMOrderSaleClosingList);
                        lo_objResCMInfoList.OrderSaleClosingList      = lo_objResCMOrderSaleClosingList.data.list;
                        lo_objResCMInfoList.OrderSaleClosingRecordCnt = lo_objResCMOrderSaleClosingList.data.RecordCnt;
                    }
                }
            }

            lo_objResCMInfoList.RetCode = 0;
            lo_objResCMInfoList.ErrMsg  = "OK";
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResCMInfoList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수발신 목록
    /// </summary>
    protected void GetCMDetailCallLogList()
    {

        ReqCMCallLogList                lo_objReqCMCallLogList = null;
        ServiceResult<ResCMCallLogList> lo_objResCMCallLogList = null;

        try
        {
            lo_objReqCMCallLogList = new ReqCMCallLogList
            {
                CenterCode       = strCenterCode.ToInt(),
                SndTelNo         = strSndTelNo,
                CallViewFlag     = strCallViewFlag,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCMCallLogList = objCallManageDasServices.GetCMCallLogList(lo_objReqCMCallLogList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResCMCallLogList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수발신 목록
    /// </summary>
    protected void GetCMMessageSendLogList()
    {

        ReqCMMessageSendLogList                lo_objReqCMMessageSendLogList = null;
        ServiceResult<ResCMMessageSendLogList> lo_objResCMMessageSendLogList = null;

        try
        {
            lo_objReqCMMessageSendLogList = new ReqCMMessageSendLogList
            {
                CenterCode       = strCenterCode.ToInt(),
                RcvNumber        = strSndTelNo,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCMMessageSendLogList = objCallManageDasServices.GetCMMessageSendLogList(lo_objReqCMMessageSendLogList);
            objResMap.strResponse         = "[" + JsonConvert.SerializeObject(lo_objResCMMessageSendLogList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량 목록
    /// </summary>
    protected void GetCMCarDispatchRefList()
    {

        ReqCMCarDispatchRefList                lo_objReqCMCarDispatchRefList = null;
        ServiceResult<ResCMCarDispatchRefList> lo_objResCMCarDispatchRefList = null;

        try
        {
            lo_objReqCMCarDispatchRefList = new ReqCMCarDispatchRefList
            {
                CenterCode       = strCenterCode.ToInt(),
                CallerType       = strCallerType.ToInt(),
                CallerDetailType = strCallerDetailType.ToInt(),
                SndTelNo         = strSndTelNo,
                RefSeqNo         = strRefSeqNo.ToInt64(),
                ComCode          = strComCode.ToInt64(),
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCMCarDispatchRefList = objCallManageDasServices.GetCMCarDispatchRefList(lo_objReqCMCarDispatchRefList);
            objResMap.strResponse         = "[" + JsonConvert.SerializeObject(lo_objResCMCarDispatchRefList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량 오더 목록
    /// </summary>
    protected void GetCMOrderDispatchList()
    {

        ReqCMOrderDispatchList                lo_objReqCMOrderDispatchList = null;
        ServiceResult<ResCMOrderDispatchList> lo_objResCMOrderDispatchList = null;

        try
        {
            lo_objReqCMOrderDispatchList = new ReqCMOrderDispatchList
            {
                CenterCode       = strCenterCode.ToInt(),
                CallerType       = strCallerType.ToInt(),
                CallerDetailType = strCallerDetailType.ToInt(),
                SndTelNo         = strSndTelNo,
                RefSeqNo         = strRefSeqNo.ToInt64(),
                ComCode          = strComCode.ToInt64(),
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCMOrderDispatchList = objCallManageDasServices.GetCMOrderDispatchList(lo_objReqCMOrderDispatchList);
            objResMap.strResponse        = "[" + JsonConvert.SerializeObject(lo_objResCMOrderDispatchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량 매입마감 목록
    /// </summary>
    protected void GetCMOrderPurchaseClosingList()
    {

        ReqCMOrderPurchaseClosingList                lo_objReqCMOrderPurchaseClosingList = null;
        ServiceResult<ResCMOrderPurchaseClosingList> lo_objResCMOrderPurchaseClosingList = null;

        try
        {
            lo_objReqCMOrderPurchaseClosingList = new ReqCMOrderPurchaseClosingList
            {
                CenterCode       = strCenterCode.ToInt(),
                CallerType       = strCallerType.ToInt(),
                CallerDetailType = strCallerDetailType.ToInt(),
                SndTelNo         = strSndTelNo,
                RefSeqNo         = strRefSeqNo.ToInt64(),
                ComCode          = strComCode.ToInt64(),
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCMOrderPurchaseClosingList = objCallManageDasServices.GetCMOrderPurchaseClosingList(lo_objReqCMOrderPurchaseClosingList);
            objResMap.strResponse               = "[" + JsonConvert.SerializeObject(lo_objResCMOrderPurchaseClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 오더 목록
    /// </summary>
    protected void GetCMOrderList()
    {

        ReqCMOrderList                lo_objReqCMOrderList = null;
        ServiceResult<ResCMOrderList> lo_objResCMOrderList = null;

        try
        {
            lo_objReqCMOrderList = new ReqCMOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                CallerType       = strCallerType.ToInt(),
                CallerDetailType = strCallerDetailType.ToInt(),
                SndTelNo         = strSndTelNo,
                ClientCode       = strClientCode.ToInt64(),
                ClientAdminID    = strClientAdminID,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCMOrderList  = objCallManageDasServices.GetCMOrderList(lo_objReqCMOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCMOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 매출마감 목록
    /// </summary>
    protected void GetCMOrderSaleClosingList()
    {

        ReqCMOrderSaleClosingList                lo_objReqCMOrderSaleClosingList = null;
        ServiceResult<ResCMOrderSaleClosingList> lo_objResCMOrderSaleClosingList = null;

        try
        {
            lo_objReqCMOrderSaleClosingList = new ReqCMOrderSaleClosingList
            {
                CenterCode       = strCenterCode.ToInt(),
                CallerType       = strCallerType.ToInt(),
                CallerDetailType = strCallerDetailType.ToInt(),
                SndTelNo         = strSndTelNo,
                ClientCode       = strClientCode.ToInt64(),
                ClientAdminID    = strClientAdminID,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResCMOrderSaleClosingList = objCallManageDasServices.GetCMOrderSaleClosingList(lo_objReqCMOrderSaleClosingList);
            objResMap.strResponse           = "[" + JsonConvert.SerializeObject(lo_objResCMOrderSaleClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 메모 등록
    /// </summary>
    protected void SetCMMemoIns()
    {
        ReqCMMemoIns                lo_objReqCMMemoIns = null;
        ServiceResult<ResCMMemoIns> lo_objResCMMemoIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSndTelNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCompanyMemo))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        try
        {
            lo_objReqCMMemoIns = new ReqCMMemoIns
            {
                CenterCode        = strCenterCode.ToInt(),
                CallNumber        = strSndTelNo,
                CallerType        = strCallerType.ToInt(),
                CallerDetailType  = strCallerDetailType.ToInt(),
                CallerDetailText  = strCallerDetailText,
                CompanyName       = strComName,
                CompanyCeoName    = strCeoName,
                CompanyChargeName = strName,
                CompanyMemo       = strCompanyMemo,
                AdminID           = objSes.AdminID,
                AdminName         = objSes.AdminName
            };

            lo_objResCMMemoIns = objCallManageDasServices.SetCMMemoIns(lo_objReqCMMemoIns);
            objResMap.RetCode  = lo_objResCMMemoIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCMMemoIns.result.ErrorMsg;
                return;
            }

            objResMap.Add("SeqNo", lo_objResCMMemoIns.data.SeqNo.ToString());
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 메모 삭제
    /// </summary>
    protected void SetCMMemoDel()
    {
        ReqCMMemoDel        lo_objReqCMMemoDel = null;
        ServiceResult<bool> lo_objResCMMemoDel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strMemoSeqNo) || strMemoSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCMMemoDel = new ReqCMMemoDel
            {
                CenterCode = strCenterCode.ToInt(),
                SeqNo      = strMemoSeqNo.ToInt(),
                AdminID    = objSes.AdminID
            };

            lo_objResCMMemoDel = objCallManageDasServices.SetCMMemoDel(lo_objReqCMMemoDel);
            objResMap.RetCode  = lo_objResCMMemoDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCMMemoDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 분류 등록
    /// </summary>
    protected void SetCMClassifyIns()
    {
        ReqCMClassifyIns                lo_objReqCMClassifyIns = null;
        ServiceResult<ResCMClassifyIns> lo_objResCMClassifyIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSndTelNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCallType) || strCallType.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCMClassifyIns = new ReqCMClassifyIns
            {
                CenterCode   = strCenterCode.ToInt(),
                CallerNumber = strSndTelNo,
                ClassType    = strClassType.ToInt(),
                AdminID      = objSes.AdminID,
                AdminName    = objSes.AdminName
            };

            lo_objResCMClassifyIns = objCallManageDasServices.SetCMClassifyIns(lo_objReqCMClassifyIns);
            objResMap.RetCode      = lo_objResCMClassifyIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCMClassifyIns.result.ErrorMsg;
                return;
            }

            objResMap.Add("SeqNo",     lo_objResCMClassifyIns.data.SeqNo.ToString());
            objResMap.Add("ClassType", lo_objResCMClassifyIns.data.ClassType.ToString());
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 매출마감 목록
    /// </summary>
    protected void GetCMCallerInfoGet()
    {

        ReqCallerInfoGet                lo_objReqCMCallerInfoGet = null;
        ServiceResult<ResCallerInfoGet> lo_objResCMCallerInfoGet = null;
        ServiceResult<CMJsonParamModel> lo_objCMJsonParamModel   = new ServiceResult<CMJsonParamModel>();

        try
        {
            lo_objReqCMCallerInfoGet = new ReqCallerInfoGet
            {
                CenterCode = strCenterCode.ToInt(),
                CustTelNo  = strSndTelNo
            };

            lo_objResCMCallerInfoGet = objCallManageDasServices.GetCallerInfo(lo_objReqCMCallerInfoGet);

            lo_objCMJsonParamModel.data = new CMJsonParamModel
            {
                SeqNo            = "",
                CenterCode       = strCenterCode.ToInt(),
                SndTelNo         = strSndTelNo,
                RcvTelNo         = strRcvTelNo,
                CallerType       = lo_objResCMCallerInfoGet.data.CallerType,
                CallerDetailType = lo_objResCMCallerInfoGet.data.CallerDetailType,
                CallerDetailText = lo_objResCMCallerInfoGet.data.CallerDetailText,
                RefSeqNo         = lo_objResCMCallerInfoGet.data.RefSeqNo.ToString(),
                ComCode          = lo_objResCMCallerInfoGet.data.ComCode.ToString(),
                ClientCode       = lo_objResCMCallerInfoGet.data.ClientCode.ToString(),
                Name             = lo_objResCMCallerInfoGet.data.Name,
                ComName          = lo_objResCMCallerInfoGet.data.ComName,
                CorpNo           = lo_objResCMCallerInfoGet.data.CorpNo,
                CeoName          = lo_objResCMCallerInfoGet.data.CeoName,
                CarNo            = lo_objResCMCallerInfoGet.data.CarNo,
                CarTon           = lo_objResCMCallerInfoGet.data.CarTon,
                CarType          = lo_objResCMCallerInfoGet.data.CarType,
                PlaceName        = lo_objResCMCallerInfoGet.data.PlaceName,
                PlaceAddr        = lo_objResCMCallerInfoGet.data.PlaceAddr,
                CenterName       = lo_objResCMCallerInfoGet.data.CenterName,
                Position         = lo_objResCMCallerInfoGet.data.Position,
                DeptName         = lo_objResCMCallerInfoGet.data.DeptName,
                TaxMsg           = lo_objResCMCallerInfoGet.data.TaxMsg,
                ClassType        = lo_objResCMCallerInfoGet.data.ClassType,
                ClientAdminID    = lo_objResCMCallerInfoGet.data.ClientAdminID
            };

            lo_objCMJsonParamModel.result = lo_objResCMCallerInfoGet.result;

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objCMJsonParamModel) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 전화걸기
    /// </summary>
    protected void SetCMSendCall()
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
                    MsgType = "CallPhone",
                    Title   = "콜매니저 전화걸기",
                    MsgBody = Utils.SetPhoneNoDashed(strRcvTelNo) + "로 전화걸기 요청합니다.",
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
                    objResMap.ErrMsg  = "어플리케이션 통화요청에 실패했습니다.";
                    return;
                }

                lo_objReqCMLogIns = new ReqCMLogIns
                {
                    CenterCode  = strCenterCode.ToInt(),
                    CallType    = 2,
                    CallKind    = "call",
                    ChannelType = "callmanagerapp",
                    CallNumber  = strRcvTelNo,
                    SendName    = objSes.AdminName,
                    SendNumber  = strSndTelNo,
                    RcvName     = strRcvName,
                    RcvNumber   = strRcvTelNo,
                    Message     = Utils.SetPhoneNoDashed(strRcvTelNo) + "로 전화걸기 요청합니다."
                };
                    
                SetCMLogIns(lo_objReqCMLogIns);

                objResMap.RetCode = 0;
                objResMap.ErrMsg  = "어플리케이션 통화요청에 성공했습니다.";
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
                    kind         = "call",
                    message      = string.Empty,
                    site_code    = "logiman"
                };

                lo_objResCMOutBoundCall = ApiCallManager.InsOutboundCall(lo_objReqCMOutBoundCall);

                if (lo_objResCMOutBoundCall.ResultCode.IsFail())
                {
                    objResMap.RetCode = 9007;
                    objResMap.ErrMsg  = "통화요청에 실패했습니다.";
                    return;
                }

                lo_objReqCMLogIns = new ReqCMLogIns
                {
                    CenterCode  = strCenterCode.ToInt(),
                    CallType    = 2,
                    CallKind    = "call",
                    ChannelType = lo_objResCMAdminPhoneList.data.list[0].ChannelType,
                    CallNumber  = strRcvTelNo,
                    SendName    = objSes.AdminName,
                    SendNumber  = strSndTelNo,
                    RcvName     = strRcvName,
                    RcvNumber   = strRcvTelNo,
                    AuthID      = lo_objResCMAdminPhoneList.data.list[0].AuthID,
                    Message     = Utils.SetPhoneNoDashed(strRcvTelNo) + "로 전화걸기 요청합니다."
                };
                    
                SetCMLogIns(lo_objReqCMLogIns);

                objResMap.RetCode = 0;
                objResMap.ErrMsg  = "통화요청에 성공했습니다.";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
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

            SiteGlobal.WriteLog("CMCallDetailHandler", "Exception",
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