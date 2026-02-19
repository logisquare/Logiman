<%@ WebHandler Language="C#" Class="CenterHandler" %>
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
/// FileName        : CenterHandler.ashx
/// Description     : 회원사 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : ehdus0665@logislab.com, 2022-03-30
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class CenterHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Center/CenterList"; //필수

    // 메소드 리스트
    private const string MethodCenterList              = "CenterList";
    private const string MethodCenterInsert            = "CenterInsert";
    private const string MethodCenterUpdate            = "CenterUpdate";
    private const string MethodCenterHomeTaxDeptInsert = "CenterHomeTaxDeptInsert";
    private const string MethodChkCorpNo               = "ChkCorpNo";
    private const string MethodChkAcctNo               = "ChkAcctNo";

    CenterDasServices    objCenterDasServices = new CenterDasServices();

    private string strCallType      = string.Empty;
    private int    intPageSize      = 0;
    private int    intPageNo        = 0;
    private int    intCenterCode    = 0;
    private string strUseFlag       = string.Empty;
    private string strSearchType    = string.Empty;
    private string strListSearch    = string.Empty;
    private string strCenterID      = string.Empty;
    private string strCenterKey     = string.Empty;
    private string strCenterName    = string.Empty;
    private string strCorpNo        = string.Empty;
    private string strCeoName       = string.Empty;
    private string strBizType       = string.Empty;
    private string strBizClass      = string.Empty;
    private string strTelNo         = string.Empty;
    private string strFaxNo         = string.Empty;
    private string strEmail         = string.Empty;
    private string strAddrPost      = string.Empty;
    private string strAddr          = string.Empty;
    private string strCenterNote    = string.Empty;
    private string strTransSaleRate = string.Empty;
    private string strEncAcctNo     = string.Empty;
    private string strBankCode      = string.Empty;
    private string strAcctName      = string.Empty;
    private string strAcctValidFlag = string.Empty;
    private string strCenterType    = string.Empty;
    private string strContractFlag  = string.Empty;

    /*부서사용자*/
    private string strDeptUserID     = string.Empty;
    private string strEncDeptUserPwd = string.Empty;
    private int    intRegType        = 0;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCenterList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCenterInsert,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCenterUpdate,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCenterHomeTaxDeptInsert, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodChkCorpNo,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodChkAcctNo,               MenuAuthType.ReadWrite);

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
            intPageNo   = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"), "0").ToInt();

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

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CenterHandler");
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
            intCenterCode  = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0").ToInt();

            strUseFlag        = SiteGlobal.GetRequestForm("UseFlag");
            strSearchType     = SiteGlobal.GetRequestForm("SearchType");
            strListSearch     = SiteGlobal.GetRequestForm("ListSearch");
            strCenterID       = SiteGlobal.GetRequestForm("CenterID");
            strCenterKey      = SiteGlobal.GetRequestForm("CenterKey");
            strCenterName     = SiteGlobal.GetRequestForm("CenterName");
            strCorpNo         = SiteGlobal.GetRequestForm("CorpNo").Replace("-", "").Replace(" ", "");
            strCeoName        = SiteGlobal.GetRequestForm("CeoName");
            strBizType        = SiteGlobal.GetRequestForm("BizType");
            strBizClass       = SiteGlobal.GetRequestForm("BizClass");
            strTelNo          = SiteGlobal.GetRequestForm("TelNo").Replace("-", "").Replace(" ", "");
            strFaxNo          = SiteGlobal.GetRequestForm("FaxNo").Replace("-", "").Replace(" ", "");
            strEmail          = SiteGlobal.GetRequestForm("Email");
            strAddrPost       = SiteGlobal.GetRequestForm("AddrPost");
            strAddr           = SiteGlobal.GetRequestForm("Addr");
            strCenterNote     = Utils.IsNull(SiteGlobal.GetRequestForm("CenterNote"),    "");
            strTransSaleRate  = Utils.IsNull(SiteGlobal.GetRequestForm("TransSaleRate"), "0");
            strAcctName       = Utils.IsNull(SiteGlobal.GetRequestForm("AcctName"),      "");
            strEncAcctNo      = Utils.IsNull(SiteGlobal.GetRequestForm("EncAcctNo"),     "");
            strBankCode       = Utils.IsNull(SiteGlobal.GetRequestForm("BankCode"),      "");
            strCenterType     = Utils.IsNull(SiteGlobal.GetRequestForm("CenterType"),    "0");
            strAcctValidFlag  = Utils.IsNull(SiteGlobal.GetRequestForm("AcctValidFlag"), "");
            strContractFlag   = SiteGlobal.GetRequestForm("ContractFlag");
            strDeptUserID     = SiteGlobal.GetRequestForm("DeptUserID");
            strEncDeptUserPwd = SiteGlobal.GetRequestForm("EncDeptUserPwd");
            intRegType        = Utils.IsNull(SiteGlobal.GetRequestForm("RegType "), "0").ToInt();;

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
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
                case MethodCenterList:
                    GetCenterList();
                    break;
                case MethodCenterInsert:
                    InsCenter();
                    break;
                case MethodCenterUpdate:
                    UpdCenter();
                    break;
                case MethodCenterHomeTaxDeptInsert:
                    HomeTaxDeptInsert();
                    break;
                case MethodChkCorpNo:
                    GetChkCorpNo();
                    break;
                case MethodChkAcctNo:
                    GetComGetAcctRealName();
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

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    protected void GetCenterList()
    {
        string lo_strCenterName = string.Empty;
        string lo_strCorpNo = string.Empty;

        ReqCenterList                lo_objReqCenterList = null;
        ServiceResult<ResCenterList> lo_objResCenterList = null;

        try
        {
            switch (strSearchType)
            {
                case "CenterName":
                    lo_strCenterName = strListSearch;
                    break;
                case "CorpNo":
                    lo_strCorpNo = strListSearch;
                    break;
            }

            lo_objReqCenterList = new ReqCenterList
            {
                AdminID    = objSes.AdminID,
                CenterName = lo_strCenterName,
                CorpNo     = lo_strCorpNo,
                PageSize   = intPageSize,
                PageNo     = intPageNo
            };

            lo_objResCenterList    = objCenterDasServices.GetCenterList(lo_objReqCenterList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResCenterList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void InsCenter()
    {
        int                            lo_intCenterCode   = 0;
        CenterViewModel                lo_objReqInsCenter = null;
        ServiceResult<CenterViewModel> lo_objResInsCenter = null;
            
        strContractFlag = Utils.IsNull(strContractFlag, "N");

        if (objSes.GradeCode > 3)
        {
            objResMap.RetCode = 9104;
            objResMap.ErrMsg  = "등록 권한이 없습니다.";
            return;
        }


        try
        {
            lo_objReqInsCenter = new CenterViewModel
            {
                CenterName    = strCenterName,
                CorpNo        = strCorpNo,
                CeoName       = strCeoName,
                BizType       = strBizType,
                BizClass      = strBizClass,
                TelNo         = strTelNo,
                FaxNo         = strFaxNo,
                Email         = strEmail,
                CenterType    = strCenterType.ToInt(),
                TransSaleRate = strTransSaleRate.ToDouble(),
                BankCode      = strBankCode,
                AcctName      = strAcctName,
                EncAcctNo     = Utils.GetEncrypt(strEncAcctNo, SiteGlobal.AES2_ENC_IV_VALUE),
                SearchAcctNo  = strEncAcctNo.Right(4),
                AcctValidFlag = strAcctValidFlag,
                AddrPost      = strAddrPost,
                Addr          = strAddr,
                CenterNote    = strCenterNote,
                ContractFlag  = strContractFlag,
                UseFlag       = strUseFlag,
                RegAdminID    = objSes.AdminID
            };

            InsCenterApi(lo_objReqInsCenter);
            if (!objResMap.RetCode.Equals(0))
            {
                return;
            }

            lo_objReqInsCenter.CenterCode = Convert.ToInt32(objResMap.Get("CenterCode"));
            lo_objReqInsCenter.CenterID   = objResMap.Get("CenterID").ToString();
            lo_objReqInsCenter.CenterKey  = objResMap.Get("CenterKey").ToString();
            lo_objResInsCenter            = objCenterDasServices.InsCenter(lo_objReqInsCenter);
            objResMap.RetCode             = lo_objResInsCenter.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsCenter.result.ErrorMsg;
            }
            else
            {
                lo_intCenterCode = lo_objResInsCenter.data.CenterCode;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void UpdCenter()
    {
        CenterViewModel     lo_objReqUpdCenter = null;
        ServiceResult<bool> lo_objResUpdCenter = null;

        strContractFlag = Utils.IsNull(strContractFlag, "N");

        if (objSes.GradeCode > 4)
        {
            objResMap.RetCode = 9104;
            objResMap.ErrMsg  = "수정 권한이 없습니다.";
            return;
        }

        try
        {
            lo_objReqUpdCenter = new CenterViewModel
            {
                CenterCode    = intCenterCode,
                CenterID      = strCenterID,
                CenterKey     = strCenterKey,
                CenterName    = strCenterName,
                CorpNo        = strCorpNo,
                CeoName       = strCeoName,
                BizType       = strBizType,
                BizClass      = strBizClass,
                TelNo         = strTelNo,
                FaxNo         = strFaxNo,
                Email         = strEmail,
                CenterType    = strCenterType.ToInt(),
                TransSaleRate = strTransSaleRate.ToDouble(),
                BankCode      = strBankCode,
                AcctName      = strAcctName,
                EncAcctNo     = Utils.GetEncrypt(strEncAcctNo, SiteGlobal.AES2_ENC_IV_VALUE),
                SearchAcctNo  = strEncAcctNo.Right(4),
                AcctValidFlag = strAcctValidFlag,
                AddrPost      = strAddrPost,
                Addr          = strAddr,
                CenterNote    = strCenterNote,
                ContractFlag  = strContractFlag,
                UseFlag       = strUseFlag,
                UpdAdminID    = objSes.AdminID
            };

            InsCenterApi(lo_objReqUpdCenter);
            if (!objResMap.RetCode.Equals(0))
            {
                return;
            }
            
            lo_objResUpdCenter = objCenterDasServices.UpdCenter(lo_objReqUpdCenter);
            objResMap.RetCode = lo_objResUpdCenter.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdCenter.result.ErrorMsg;
            }
            else 
            {
                objResMap.Add("CenterCode", intCenterCode);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void HomeTaxDeptInsert()
    {
        CenterViewModel     lo_objReqUpdCenter = null;
        ServiceResult<bool> lo_objResUpdCenter = null;

        try
        {
            lo_objReqUpdCenter = new CenterViewModel
            {
                CenterCode      = intCenterCode,
                DeptUserID      = strDeptUserID,
                EncDeptUserPwd  = strEncDeptUserPwd,
                RegType         = intRegType,
                RegAdminID      = objSes.AdminID
            };

            //lo_objResUpdCenter = objCenterDasServices.UpdCenter(lo_objReqUpdCenter);
            objResMap.RetCode = lo_objResUpdCenter.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResUpdCenter.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetChkCorpNo() {

        if (string.IsNullOrWhiteSpace(strCorpNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            GetChkCenterExistsApi(strCorpNo);
            if (!objResMap.RetCode.Equals(0))
            {
                return;
            }

            if(!objResMap.Get("ExistsFlag").Equals("N"))
            {
                objResMap.RetCode = 9000;
                objResMap.ErrMsg = "운송사 사업자번호로 이미 등록되어 있습니다.";
                return;
            }

            objResMap.Clear();
            GetChkCorpNoApi(strCorpNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 사업자 중복 체크
    /// </summary>
    protected void GetChkCorpNoApi(string lo_strComCorpNo)
    {
        ReqChkCorpNo lo_objReqChkCorpNo = null;
        ResChkCorpNo lo_objResChkCorpNo = null;
        int          lo_intComTaxKind   = 1;

        if (string.IsNullOrWhiteSpace(lo_strComCorpNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //사업자 휴폐업 조회
        try
        {
            lo_objReqChkCorpNo = new ReqChkCorpNo
            {
                CorpNo = lo_strComCorpNo
            };

            lo_objResChkCorpNo = SiteGlobal.ChkCorpNo(lo_objReqChkCorpNo);

            if (lo_objResChkCorpNo.Header.ResultCode.IsFail())
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = lo_objResChkCorpNo.Header.ResultMessage;
                return;
            }

            lo_intComTaxKind = lo_objResChkCorpNo.Payload.CorpCode > 1 ? lo_objResChkCorpNo.Payload.CorpCode : 1;
            objResMap.Add("ComStatus",   lo_objResChkCorpNo.Payload.ServiceCode);
            objResMap.Add("ComCloseYMD", lo_objResChkCorpNo.Payload.CloseDate);
            objResMap.Add("ComUpdYMD",   lo_objResChkCorpNo.Payload.ChangeDate);
            objResMap.Add("ComTaxKind",  lo_intComTaxKind);
            objResMap.Add("ComTaxMsg",   lo_objResChkCorpNo.Payload.CorpCodeMsg);;
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 예금주명 조회
    /// </summary>
    protected void GetComGetAcctRealName()
    {
        ReqGetAcctRealName lo_objReqGetAcctRealName = null;
        ResGetAcctRealName lo_objResGetAcctRealName = null;

        if (string.IsNullOrWhiteSpace(strEncAcctNo) || string.IsNullOrWhiteSpace(strBankCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //얘금주명 조회
        try
        {
            lo_objReqGetAcctRealName = new ReqGetAcctRealName
            {
                CorpNo   = strCorpNo,
                AcctNo   = strEncAcctNo,
                BankCode = strBankCode
            };

            lo_objResGetAcctRealName = SiteGlobal.GetAcctRealName(lo_objReqGetAcctRealName);

            if (lo_objResGetAcctRealName.Header.ResultCode.IsFail())
            {
                objResMap.RetCode = 9020;
                objResMap.ErrMsg  = "예금주명 조회에 실패했습니다.";
                return;
            }

            objResMap.Add("SeqNo",      lo_objResGetAcctRealName.Payload.SeqNo);
            objResMap.Add("BankCode",   lo_objResGetAcctRealName.Payload.BankCode);
            objResMap.Add("AcctNo",     lo_objResGetAcctRealName.Payload.AcctNo);
            objResMap.Add("AcctName",   lo_objResGetAcctRealName.Payload.AcctName);
            objResMap.Add("CorpNo",     lo_objResGetAcctRealName.Payload.CorpNo);
            objResMap.Add("CeoName",    lo_objResGetAcctRealName.Payload.CeoName);
            objResMap.Add("ExistsFlag", lo_objResGetAcctRealName.Payload.ExistsFlag);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// SSO - 사업자번호로 운송사 가입확인
    /// </summary>
    protected void GetChkCenterExistsApi(string lo_strComCorpNo)
    {
        ReqChkCenterExists           lo_objReqChkCenterExists  = null;
        ResChkCenterExists           lo_objResChkCenterExists  = null;

        if (string.IsNullOrWhiteSpace(lo_strComCorpNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //사업자 휴폐업 조회
        try
        {
            lo_objReqChkCenterExists = new ReqChkCenterExists
            {
                CorpNo = lo_strComCorpNo
            };

            lo_objResChkCenterExists = SiteGlobal.ChkCenterExists(lo_objReqChkCenterExists);

            if (lo_objResChkCenterExists.Header.ResultCode.IsFail())
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = lo_objResChkCenterExists.Header.ResultMessage;
                return;
            }

            objResMap.Add("ExistsFlag",   lo_objResChkCenterExists.Payload.ExistsFlag);
            objResMap.Add("OrderType",    lo_objResChkCenterExists.Payload.OrderType);
            objResMap.Add("CenterCode",   lo_objResChkCenterExists.Payload.CenterCode);
            objResMap.Add("CenterName",   lo_objResChkCenterExists.Payload.CenterName);
            objResMap.Add("CenterID",     lo_objResChkCenterExists.Payload.CenterID);
            objResMap.Add("CenterKey",    lo_objResChkCenterExists.Payload.CenterKey);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// SSO - 운송사 등록
    /// </summary>
    protected void InsCenterApi(CenterViewModel objInsCenter)
    {
        ReqInsCenter  lo_objReqInsCenter  = null;
        ResInsCenter  lo_objResInsCenter  = null;
        ReqUpdCenter  lo_objReqUpdCenter  = null;
        ResUpdCenter  lo_objResUpdCenter  = null;

        try
        {
            objInsCenter.OrderType = 1;  // 1:로지맨, 2:카고매니저2.0

            GetChkCenterExistsApi(objInsCenter.CorpNo.Replace("-","").Replace(" ",""));
            if (!objResMap.RetCode.Equals(0))
            {
                return;
            }

            if (objResMap.Get("ExistsFlag").Equals("Y"))
            {
                if (!objInsCenter.CenterCode.Equals(0))
                {
                    if (!objInsCenter.CenterCode.Equals(Convert.ToInt32(objResMap.Get("CenterCode"))))
                    {
                        objResMap.RetCode = 9000;
                        objResMap.ErrMsg = "SSO의 운송사코드와 불일치합니다.";
                        return;
                    }
                }
                else
                {
                    objResMap.RetCode = 9001;
                    objResMap.ErrMsg = "SSO에 이미 등록된 운송 사업자입니다.";
                    return;
                }

                objResMap.Clear();
                lo_objReqUpdCenter = new ReqUpdCenter();
                lo_objReqUpdCenter = JsonConvert.DeserializeObject<ReqUpdCenter>(JsonConvert.SerializeObject(objInsCenter));

                lo_objResUpdCenter = SiteGlobal.UpdCenter(lo_objReqUpdCenter);
                if (lo_objResUpdCenter.Header.ResultCode.IsFail())
                {
                    objResMap.RetCode = 9001;
                    objResMap.ErrMsg  = lo_objResUpdCenter.Header.ResultMessage;
                    return;
                }
            }
            else
            {
                if (!objInsCenter.CenterCode.Equals(0))
                {
                    objResMap.RetCode = 9002;
                    objResMap.ErrMsg = "SSO에는 등록되지 않고, 로지맨에만 등록된 운송사업자입니다. 불일치발생";
                    return;
                }

                objResMap.Clear();

                lo_objReqInsCenter = new ReqInsCenter();
                lo_objReqInsCenter = JsonConvert.DeserializeObject<ReqInsCenter>(JsonConvert.SerializeObject(objInsCenter));

                lo_objResInsCenter = SiteGlobal.InsCenter(lo_objReqInsCenter);
                if (lo_objResInsCenter.Header.ResultCode.IsFail())
                {
                    objResMap.RetCode = 9001;
                    objResMap.ErrMsg  = lo_objResInsCenter.Header.ResultMessage;
                    return;
                }

                objResMap.Add("CenterCode",   lo_objResInsCenter.Payload.CenterCode);
                objResMap.Add("CenterID",     lo_objResInsCenter.Payload.CenterID);
                objResMap.Add("CenterKey",    lo_objResInsCenter.Payload.CenterKey);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CenterHandler", "Exception",
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