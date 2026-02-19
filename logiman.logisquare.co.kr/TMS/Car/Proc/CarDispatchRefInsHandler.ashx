<%@ WebHandler Language="C#" Class="CarDispatchRefInsHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;

///================================================================
/// <summary>
/// FileName        : CarDispatchRefInsHandler.ashx
/// Description     : 차량현황 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-07-11
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class CarDispatchRefInsHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Car/CarDispatchRefIns"; //필수

    // 메소드 리스트
    private const string MethodCarDispatchIns  = "CarDispatchInsert";
    private const string MethodChkCarNo        = "ChkCarNo";
    private const string MethodChkDriver       = "ChkDriver";
    private const string MethodChkCorpNo       = "ChkCorpNo";
    private const string MethodChkAcctNo       = "ChkAcctNo";
    private const string MethodSendKakaoDriver = "SendKakaoDriver"; //주민번호수집 알림톡발송


    CarDispatchDasServices objCarDispatchDasServices = new CarDispatchDasServices();

    private string strCallType         = string.Empty;
    private int    intPageSize         = 0;
    private int    intPageNo           = 0;
    private string strCenterCode       = string.Empty;
    private Int64  intRefSeqNo         = 0;
    private string strCarDivType       = string.Empty;
    private Int64  intCarSeqNo         = 0;
    private string strCarNo            = string.Empty;
    private string strCarTypeCode      = string.Empty;
    private string strCarSubType       = string.Empty;
    private string strCarTonCode       = string.Empty;
    private string strCarBrandCode     = string.Empty;
    private string strCarNote          = string.Empty;
    private Int64  intComCode          = 0;
    private string strComTypeCode      = string.Empty;
    private string strComName          = string.Empty;
    private string strComCeoName       = string.Empty;
    private string strComCorpNo        = string.Empty;
    private string strComBizType       = string.Empty;
    private string strComBizClass      = string.Empty;
    private string strComTelNo         = string.Empty;
    private string strComFaxNo         = string.Empty;
    private string strComEmail         = string.Empty;
    private string strComPost          = string.Empty;
    private string strComAddr          = string.Empty;
    private string strComAddrDtl       = string.Empty;
    private string strComStatus        = string.Empty;
    private string strComTaxKind       = string.Empty;
    private string strComTaxMsg        = string.Empty;
    private string strCardAgreeFlag    = string.Empty;
    private string strCardAgreeYMD     = string.Empty;
    private Int64  intDriverSeqNo      = 0;
    private string strDriverName       = string.Empty;
    private string strDriverCell       = string.Empty;
    private int    intPayDay           = 0;
    private string strBankCode         = string.Empty;
    private string strEncAcctNo        = string.Empty;
    private string strSearchAcctNo     = string.Empty;
    private string strAcctName         = string.Empty;
    private string strAcctValidFlag    = string.Empty;
    private string strCooperatorFlag   = string.Empty;
    private string strChargeName       = string.Empty;
    private string strChargeTelNo      = string.Empty;
    private string strChargeEmail      = string.Empty;
    private string strRefNote          = string.Empty;
    private int    intDtlSeqNo         = 0;
    private string strCargoManFlag     = string.Empty;
    private string strUseFlag          = string.Empty;
    private string strHidMode          = string.Empty;
    private string strInsureTargetFlag = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodCarDispatchIns,  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodChkCarNo,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodChkDriver,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodChkCorpNo,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodChkAcctNo,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSendKakaoDriver, MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("CarDispatchListHandler");
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
            intRefSeqNo         = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"),       "0").ToInt64();
            strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),     "0");
            strCarDivType       = Utils.IsNull(SiteGlobal.GetRequestForm("CarDivType"),     "0");
            intCarSeqNo         = Utils.IsNull(SiteGlobal.GetRequestForm("CarSeqNo"),       "0").ToInt64();
            strCarNo            = Utils.IsNull(SiteGlobal.GetRequestForm("CarNo"),          "");
            strCarTypeCode      = Utils.IsNull(SiteGlobal.GetRequestForm("CarTypeCode"),    "");
            strCarSubType       = Utils.IsNull(SiteGlobal.GetRequestForm("CarSubType"),     "");
            strCarTonCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CarTonCode"),     "");
            strCarBrandCode     = Utils.IsNull(SiteGlobal.GetRequestForm("CarBrandCode"),   "");
            strCarNote          = Utils.IsNull(SiteGlobal.GetRequestForm("CarNote"),        "");
            intComCode          = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"),        "0").ToInt64();
            strComTypeCode      = Utils.IsNull(SiteGlobal.GetRequestForm("ComTypeCode"),    "");
            strComName          = Utils.IsNull(SiteGlobal.GetRequestForm("ComName"),        "");
            strComCeoName       = Utils.IsNull(SiteGlobal.GetRequestForm("ComCeoName"),     "");
            strComCorpNo        = Utils.IsNull(SiteGlobal.GetRequestForm("ComCorpNo"),      "");
            strComBizType       = Utils.IsNull(SiteGlobal.GetRequestForm("ComBizType"),     "");
            strComBizClass      = Utils.IsNull(SiteGlobal.GetRequestForm("ComBizClass"),    "");
            strComTelNo         = Utils.IsNull(SiteGlobal.GetRequestForm("ComTelNo"),       "");
            strComFaxNo         = Utils.IsNull(SiteGlobal.GetRequestForm("ComFaxNo"),       "");
            strComEmail         = Utils.IsNull(SiteGlobal.GetRequestForm("ComEmail"),       "");
            strComPost          = Utils.IsNull(SiteGlobal.GetRequestForm("ComPost"),        "");
            strComAddr          = Utils.IsNull(SiteGlobal.GetRequestForm("ComAddr"),        "");
            strComAddrDtl       = Utils.IsNull(SiteGlobal.GetRequestForm("ComAddrDtl"),     "");
            strComStatus        = Utils.IsNull(SiteGlobal.GetRequestForm("ComStatus"),      "0");
            strComTaxKind       = Utils.IsNull(SiteGlobal.GetRequestForm("ComTaxKind"),     "0");
            strComTaxMsg        = Utils.IsNull(SiteGlobal.GetRequestForm("ComTaxMsg"),      "");
            strCardAgreeFlag    = Utils.IsNull(SiteGlobal.GetRequestForm("CardAgreeFlag"),  "");
            strCardAgreeYMD     = Utils.IsNull(SiteGlobal.GetRequestForm("CardAgreeYMD"),   "");
            intDriverSeqNo      = Utils.IsNull(SiteGlobal.GetRequestForm("DriverSeqNo"),    "0").ToInt64();
            strDriverName       = Utils.IsNull(SiteGlobal.GetRequestForm("DriverName"),     "");
            strDriverCell       = Utils.IsNull(SiteGlobal.GetRequestForm("DriverCell"),     "");
            intPayDay           = Utils.IsNull(SiteGlobal.GetRequestForm("PayDay"),         "0").ToInt();
            strBankCode         = Utils.IsNull(SiteGlobal.GetRequestForm("BankCode"),       "");
            strEncAcctNo        = Utils.IsNull(SiteGlobal.GetRequestForm("EncAcctNo"),      "");
            strSearchAcctNo     = Utils.IsNull(SiteGlobal.GetRequestForm("SearchAcctNo"),   "");
            strAcctName         = Utils.IsNull(SiteGlobal.GetRequestForm("AcctName"),       "");
            strAcctValidFlag    = Utils.IsNull(SiteGlobal.GetRequestForm("AcctValidFlag"),  "");
            strCooperatorFlag   = Utils.IsNull(SiteGlobal.GetRequestForm("CooperatorFlag"), "");
            strChargeName       = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeName"),     "");
            strChargeTelNo      = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeTelNo"),    "");
            strChargeEmail      = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeEmail"),    "");
            strRefNote          = Utils.IsNull(SiteGlobal.GetRequestForm("RefNote"),        "");
            intDtlSeqNo         = Utils.IsNull(SiteGlobal.GetRequestForm("DtlSeqNo"),       "0").ToInt();
            strCargoManFlag     = Utils.IsNull(SiteGlobal.GetRequestForm("CargoManFlag"),   "");
            strUseFlag          = Utils.IsNull(SiteGlobal.GetRequestForm("UseFlag"),        "");
            strHidMode          = Utils.IsNull(SiteGlobal.GetRequestForm("HidMode"),        "");
            strInsureTargetFlag = SiteGlobal.GetRequestForm("InsureTargetFlag");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
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
                case MethodCarDispatchIns:
                    GetCarDispatchRefIns();
                    break;
                case MethodChkCarNo:
                    GetChkCarNo();
                    break;
                case MethodChkDriver:
                    GetChkDriver();
                    break;
                case MethodChkCorpNo:
                    GetChkCorpNo();
                    break;
                case MethodChkAcctNo:
                    GetComGetAcctRealName();
                    break;
                case MethodSendKakaoDriver:
                    SetSendKakaoDriver();
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

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 항목 그룹 목록
    /// </summary>
    protected void GetCarDispatchRefIns()
    {
        CarDispatchViewModel                lo_objReqCarDispatchIns = null;
        ServiceResult<CarDispatchViewModel> lo_objResInsCarDispatch = null;

        strInsureTargetFlag = Utils.IsNull(strInsureTargetFlag, "Y");

        if (string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarDivType))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[차량구분]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[차량번호]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDriverCell))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[기사 휴대폰번호]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDriverName))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[기사명]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCorpNo))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[사업자번호]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComTaxKind))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[과세구분]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComStatus))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[사업자상태]";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComName))
        {
            objResMap.RetCode = 9008;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[업체명]";
            return;
        }

        try
        {
            lo_objReqCarDispatchIns = new CarDispatchViewModel
            {
                RefSeqNo         = intRefSeqNo,
                CenterCode       = strCenterCode.ToInt(),
                CarDivType       = strCarDivType.ToInt(),
                CarSeqNo         = intCarSeqNo,
                CarNo            = strCarNo,
                CarTypeCode      = strCarTypeCode,
                CarSubType       = strCarSubType,
                CarTonCode       = strCarTonCode,
                CarBrandCode     = strCarBrandCode,
                CarNote          = strCarNote,
                ComCode          = intComCode,
                ComTypeCode      = strComTypeCode,
                ComName          = strComName,
                ComCeoName       = strComCeoName,
                ComCorpNo        = strComCorpNo,
                ComBizType       = strComBizType,
                ComBizClass      = strComBizClass,
                ComTelNo         = strComTelNo,
                ComFaxNo         = strComFaxNo,
                ComEmail         = strComEmail,
                ComPost          = strComPost,
                ComAddr          = strComAddr,
                ComAddrDtl       = strComAddrDtl,
                ComStatus        = strComStatus.ToInt(),
                ComTaxKind       = strComTaxKind.ToInt(),
                ComTaxMsg        = strComTaxMsg,
                CardAgreeFlag    = strCardAgreeFlag,
                CardAgreeYMD     = strCardAgreeYMD,
                DriverSeqNo      = intDriverSeqNo,
                DriverName       = strDriverName,
                DriverCell       = strDriverCell,
                PayDay           = intPayDay,
                BankCode         = strBankCode,
                EncAcctNo        = Utils.GetEncrypt(strEncAcctNo, SiteGlobal.AES2_ENC_IV_VALUE),
                SearchAcctNo     = strEncAcctNo.Right(4),
                AcctName         = strAcctName,
                AcctValidFlag    = strAcctValidFlag,
                CooperatorFlag   = strCooperatorFlag,
                ChargeName       = strChargeName,
                ChargeTelNo      = strChargeTelNo,
                ChargeEmail      = strChargeEmail,
                RefNote          = strRefNote,
                DtlSeqNo         = intDtlSeqNo,
                CargoManFlag     = strCargoManFlag,
                InsureTargetFlag = strInsureTargetFlag,
                UseFlag          = strUseFlag,
                AdminID          = objSes.AdminID
            };

            lo_objResInsCarDispatch    = objCarDispatchDasServices.InsCarDispatchRef(lo_objReqCarDispatchIns);
            objResMap.RetCode  = lo_objResInsCarDispatch.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsCarDispatch.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetChkCarNo() {
        ReqCarDispatchList                lo_objReqCarDispatchList = null;
        ServiceResult<ResCarDispatchList> lo_objResCarDispatchList = null;;

        if (string.IsNullOrWhiteSpace(strCarNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[차량번호 누락]";
            return;
        }

        try
        {
            lo_objReqCarDispatchList = new ReqCarDispatchList
            {
                CarNo       = strCarNo,
                PageSize    = intPageSize,
                PageNo      = intPageNo
            };

            lo_objResCarDispatchList        = objCarDispatchDasServices.GetCarList(lo_objReqCarDispatchList);

            objResMap.Add("RecordCnt",      lo_objResCarDispatchList.data.RecordCnt);
            if (lo_objResCarDispatchList.data.RecordCnt > 0)
            {
                objResMap.Add("CarSeqNo",       lo_objResCarDispatchList.data.list[0].CarSeqNo);
                objResMap.Add("CarNo",          lo_objResCarDispatchList.data.list[0].CarNo);
                objResMap.Add("CarTypeCode",    lo_objResCarDispatchList.data.list[0].CarTypeCode);
                objResMap.Add("CarTonCode",     lo_objResCarDispatchList.data.list[0].CarTonCode);
                objResMap.Add("CarBrandCode",   lo_objResCarDispatchList.data.list[0].CarBrandCode);
                objResMap.Add("CarNote",        lo_objResCarDispatchList.data.list[0].CarNote);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetChkDriver() {
        ReqCarDispatchList                lo_objReqCarDispatchList = null;
        ServiceResult<ResCarDispatchList> lo_objResCarDispatchList = null;;

        if (string.IsNullOrWhiteSpace(strDriverCell))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다[휴대폰번호 누락].";
            return;
        }

        try
        {
            lo_objReqCarDispatchList = new ReqCarDispatchList
            {
                DriverCell = strDriverCell,
                PageSize   = intPageSize,
                PageNo     = intPageNo
            };

            lo_objResCarDispatchList        = objCarDispatchDasServices.GetCarDriverList(lo_objReqCarDispatchList);
            objResMap.Add("RecordCnt", lo_objResCarDispatchList.data.RecordCnt);
            if (lo_objResCarDispatchList.data.RecordCnt > 0)
            {
                objResMap.Add("DriverSeqNo", lo_objResCarDispatchList.data.list[0].DriverSeqNo);
                objResMap.Add("DriverName", lo_objResCarDispatchList.data.list[0].DriverName);
                objResMap.Add("DriverCell", lo_objResCarDispatchList.data.list[0].DriverCell);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void GetChkCorpNo()
    {
        ReqCarDispatchList                lo_objReqCarDispatchList = null;
        ServiceResult<ResCarDispatchList> lo_objResCarDispatchList = null;
        Int64                             lo_intComCode            = 0;

        if (string.IsNullOrWhiteSpace(strComCorpNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarDispatchList = new ReqCarDispatchList
            {
                ComCorpNo   = strComCorpNo,
                PageSize    = intPageSize,
                PageNo      = intPageNo
            };

            lo_objResCarDispatchList    = objCarDispatchDasServices.GetCarCompanyList(lo_objReqCarDispatchList);
            objResMap.Add("RecordCnt", lo_objResCarDispatchList.data.RecordCnt);
            if (lo_objResCarDispatchList.data.RecordCnt > 0)
            {
                lo_intComCode = lo_objResCarDispatchList.data.list[0].ComCode;
                objResMap.Add("ComCode",     lo_objResCarDispatchList.data.list[0].ComCode);
                objResMap.Add("ComStatus",   lo_objResCarDispatchList.data.list[0].ComStatus);
                objResMap.Add("ComName",     lo_objResCarDispatchList.data.list[0].ComName);
                objResMap.Add("ComCorpNo",   lo_objResCarDispatchList.data.list[0].ComCorpNo);
                objResMap.Add("ComCeoName",  lo_objResCarDispatchList.data.list[0].ComCeoName);
                objResMap.Add("ComBizType",  lo_objResCarDispatchList.data.list[0].ComBizType);
                objResMap.Add("ComBizClass", lo_objResCarDispatchList.data.list[0].ComBizClass);
                objResMap.Add("ComTelNo",    lo_objResCarDispatchList.data.list[0].ComTelNo);
                objResMap.Add("ComFaxNo",    lo_objResCarDispatchList.data.list[0].ComFaxNo);
                objResMap.Add("ComEmail",    lo_objResCarDispatchList.data.list[0].ComEmail);
                objResMap.Add("ComPost",     lo_objResCarDispatchList.data.list[0].ComPost);
                objResMap.Add("ComAddr",     lo_objResCarDispatchList.data.list[0].ComAddr);
                objResMap.Add("ComAddrDtl",  lo_objResCarDispatchList.data.list[0].ComAddrDtl);
                objResMap.Add("ComCloseYMD", lo_objResCarDispatchList.data.list[0].ComCloseYMD);
                objResMap.Add("ComUpdYMD",   lo_objResCarDispatchList.data.list[0].ComUpdYMD);
                objResMap.Add("ComTaxKind",  lo_objResCarDispatchList.data.list[0].ComTaxKind);
                objResMap.Add("ComTaxMsg",   lo_objResCarDispatchList.data.list[0].ComTaxMsg);
                objResMap.Add("ComKindM",    lo_objResCarDispatchList.data.list[0].ComKindM);

                GetCarCompanyDtl(lo_intComCode, strCenterCode);
            }
            else
            {
                GetChkCorpNoApi(strComCorpNo);
            }

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 업체 상세정보 
    /// </summary>
    protected void GetCarCompanyDtl(Int64 lo_intComCode, string lo_strCenterCode) {
        ReqCarDispatchList                lo_objReqCarDispatchList = null;
        ServiceResult<ResCarDispatchList> lo_objResCarDispatchList = null;;

        if (lo_intComCode.Equals(0))
        {
            objResMap.RetCode = 9701;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(lo_strCenterCode))
        {
            objResMap.RetCode = 9702;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarDispatchList = new ReqCarDispatchList
            {
                ComCode = lo_intComCode,
                CenterCode = lo_strCenterCode.ToInt()
            };

            lo_objResCarDispatchList    = objCarDispatchDasServices.GetCarCompanyDtlList(lo_objReqCarDispatchList);
            objResMap.Add("DtlRecordCnt", lo_objResCarDispatchList.data.RecordCnt);
            if (lo_objResCarDispatchList.data.RecordCnt > 0)
            {
                objResMap.Add("DtlSeqNo",    lo_objResCarDispatchList.data.list[0].DtlSeqNo);
                objResMap.Add("PayDay",  lo_objResCarDispatchList.data.list[0].PayDay);
                objResMap.Add("BankCode",    lo_objResCarDispatchList.data.list[0].BankCode);
                objResMap.Add("EncAcctNo",  Utils.GetDecrypt(lo_objResCarDispatchList.data.list[0].EncAcctNo));

                objResMap.Add("AcctName", lo_objResCarDispatchList.data.list[0].AcctName);
                objResMap.Add("AcctValidFlag", lo_objResCarDispatchList.data.list[0].AcctValidFlag);
                objResMap.Add("CooperatorFlag",lo_objResCarDispatchList.data.list[0].CooperatorFlag);
                objResMap.Add("ChargeName",   lo_objResCarDispatchList.data.list[0].ChargeName);
                objResMap.Add("ChargeTelNo",   lo_objResCarDispatchList.data.list[0].ChargeTelNo);
                objResMap.Add("ChargeEmail",   lo_objResCarDispatchList.data.list[0].ChargeEmail);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9508;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
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
            objResMap.Add("ComTaxMsg",   lo_objResChkCorpNo.Payload.CorpCodeMsg);
            objResMap.Add("ComKindM",    lo_objResChkCorpNo.Payload.CorpNo.Substring(3, 1).Equals("8") ? "법인" : "개인");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    /// <summary>
    /// 고객사 예금주명 조회
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
                CorpNo   = strComCorpNo,
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ClientHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 주민번호 수집 알림톡 발송
    /// </summary>
    protected void SetSendKakaoDriver()
    {
        CarDriverKakaoModel                lo_objReqCarDriverKakaoModel = null;
        ServiceResult<CarDriverKakaoModel> lo_objResCarDriverKakaoModel = null;
        int                                lo_intSendType               = 1;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[회원사]";
            return;
        }

        if (intDriverSeqNo.Equals(0))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[기사정보]";
            return;
        }

        if (intRefSeqNo.Equals(0))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.[배차차량정보]";
            return;
        }

        try
        {
            lo_objReqCarDriverKakaoModel = new CarDriverKakaoModel
            {
                CenterCode  = strCenterCode.ToInt(),
                SendType    = lo_intSendType,
                RefSeqNo    = intRefSeqNo,
                DriverSeqNo = intDriverSeqNo,
                RegAdminID  = objSes.AdminID
            };

            lo_objResCarDriverKakaoModel = objCarDispatchDasServices.SetCarDriverKakaoIns(lo_objReqCarDriverKakaoModel);
            objResMap.RetCode            = lo_objResCarDriverKakaoModel.result.ErrorCode;
            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarDriverKakaoModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("CarDispatchListHandler", "Exception",
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