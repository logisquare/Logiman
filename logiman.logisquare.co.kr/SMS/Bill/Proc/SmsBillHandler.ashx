<%@ WebHandler Language="C#" Class="SmsBillHandler" %>
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
/// FileName        : SmsBillHandler.ashx
/// Description     : 알림톡 계산서발행 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2023-06-20
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SmsBillHandler : AshxSmsBaseHandler
{
    // 메소드 리스트
    private const string MethodParamChk               = "ParamChk";               //No 체크
    private const string MethodParamChkWithJoin       = "ParamChkWithJoin";       //No 체크
    private const string MethodSmsPurchaseClosingList = "SmsPurchaseClosingList"; //매입마감 목록
    private const string MethodSmsPurchaseTaxBillIns  = "SmsPurchaseTaxBillIns";  //매입마감 계산서 발행

    SmsDasServices      objSmsDasServices      = new SmsDasServices();
    PurchaseDasServices objPurchaseDasServices = new PurchaseDasServices();
    TaxDasServices      objTaxDasServices      = new TaxDasServices();

    private string strCallType       = string.Empty;
    private int    intPageSize       = 0;
    private int    intPageNo         = 0;
    private string strDateType       = string.Empty;
    private string strDateFrom       = string.Empty;
    private string strDateTo         = string.Empty;
    private string strNo             = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodParamChk,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodParamChkWithJoin,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSmsPurchaseClosingList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSmsPurchaseTaxBillIns,  MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SmsBillHandler");
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
            strDateType       = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom       = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo         = SiteGlobal.GetRequestForm("DateTo");
            strNo             = SiteGlobal.GetRequestForm("No");
            strDateFrom       = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo         = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
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
                case MethodParamChk:
                    GetParamChk();
                    break;
                case MethodParamChkWithJoin:
                    GetParamChkWithJoin();
                    break;
                case MethodSmsPurchaseClosingList:
                    GetSmsPurchaseClosingList();
                    break;
                case MethodSmsPurchaseTaxBillIns:
                    SetSmsPurchaseTaxBillIns();
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

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 파라메터 체크 
    /// </summary>
    protected void GetParamChk()
    {
        SmsBillModel lo_objSmsBillModel = null;
        string       lo_strDecNo        = string.Empty;
        string       lo_strEncNo        = string.Empty;
        DateTime     lo_objDateTime;
        TimeSpan     lo_objTimeDiff;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsBillModel = JsonConvert.DeserializeObject<SmsBillModel>(lo_strDecNo);

            if (lo_objSmsBillModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            DateTime.TryParse(lo_objSmsBillModel.TimeStamp, out lo_objDateTime);
            lo_objTimeDiff = DateTime.Now - lo_objDateTime;
            objResMap.Add("TimeOutFlag", lo_objTimeDiff.TotalDays > 45 ? "Y" : "N");

            lo_objSmsBillModel.CorpNoChkPassFlag = "Y";
            lo_strEncNo                          = Utils.GetEncrypt(JsonConvert.SerializeObject(lo_objSmsBillModel));
            objResMap.Add("No", lo_strEncNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파라메터 체크 + 가입체크
    /// </summary>
    protected void GetParamChkWithJoin()
    {
        SmsBillModel        lo_objSmsBillModel        = null;
        ReqGetCardAgreeInfo lo_objReqGetCardAgreeInfo = null;
        ResGetCardAgreeInfo lo_objResGetCardAgreeInfo = null;
        string              lo_strDecNo               = string.Empty;
        DateTime            lo_objDateTime;
        TimeSpan            lo_objTimeDiff;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsBillModel = JsonConvert.DeserializeObject<SmsBillModel>(lo_strDecNo);

            if (lo_objSmsBillModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqGetCardAgreeInfo = new ReqGetCardAgreeInfo
            {
                CorpNo = lo_objSmsBillModel.ComCorpNo
            };

            lo_objResGetCardAgreeInfo = SiteGlobal.GetCardAgreeInfo(lo_objReqGetCardAgreeInfo);

            if (lo_objResGetCardAgreeInfo.Header.ResultCode.IsFail())
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "카드결제 동의정보 조회에 실패했습니다.(API)";
                return;
            }

            objResMap.Add("CardAgreeExists", lo_objResGetCardAgreeInfo.Payload.ExistsFlag);

            DateTime.TryParse(lo_objSmsBillModel.TimeStamp, out lo_objDateTime);
            lo_objTimeDiff = DateTime.Now - lo_objDateTime;
            objResMap.Add("TimeOutFlag", lo_objTimeDiff.TotalDays > 45 ? "Y" : "N");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감 목록
    /// </summary>
    protected void GetSmsPurchaseClosingList()
    {
        SmsBillModel                              lo_objSmsBillModel               = null;
        ReqSmsPurchaseClosingList                lo_objReqSmsPurchaseClosingList = null;
        ServiceResult<ResSmsPurchaseClosingList> lo_objResSmsPurchaseClosingList = null;
        string                                   lo_strCenterCode                = string.Empty;
        string                                   lo_strPurchaseClosingSeqNo      = string.Empty;
        string                                   lo_strComCorpNo                 = string.Empty;
        string                                   lo_strDecNo                     = string.Empty;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsBillModel = JsonConvert.DeserializeObject<SmsBillModel>(lo_strDecNo);

            if (lo_objSmsBillModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_strCenterCode           = Utils.IsNull(lo_objSmsBillModel.CenterCode.ToString(), "0");
            lo_strPurchaseClosingSeqNo = Utils.IsNull(lo_objSmsBillModel.PurchaseClosingSeqNo.ToString(), "0");
            lo_strComCorpNo            = Utils.IsNull(lo_objSmsBillModel.ComCorpNo,                       string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (string.IsNullOrWhiteSpace(lo_strCenterCode) || lo_strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(lo_strPurchaseClosingSeqNo) || lo_strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(lo_strComCorpNo))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSmsPurchaseClosingList = new ReqSmsPurchaseClosingList
            {
                PurchaseClosingSeqNo = lo_strPurchaseClosingSeqNo.ToInt64(),
                CenterCode           = lo_strCenterCode.ToInt(),
                DateType             = strDateType.ToInt(),
                DateFrom             = strDateFrom,
                DateTo               = strDateTo,
                ComCorpNo            = lo_strComCorpNo,
                PageSize             = intPageSize,
                PageNo               = intPageNo
            };

            lo_objResSmsPurchaseClosingList = objSmsDasServices.GetSmsPurchaseClosingList(lo_objReqSmsPurchaseClosingList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResSmsPurchaseClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감 계산서 발행
    /// </summary>
    protected void SetSmsPurchaseTaxBillIns()
    {
        SmsBillModel                             lo_objSmsBillModel                  = null;
        ReqSmsPurchaseClosingList                lo_objReqSmsPurchaseClosingList     = null;
        ServiceResult<ResSmsPurchaseClosingList> lo_objResSmsPurchaseClosingList     = null;
        SmsPurchaseClosingGridModel              lo_objSmsPurchaseClosingGridModel   = null;
        string                                   lo_strCenterCode                    = string.Empty;
        string                                   lo_strPurchaseClosingSeqNo          = string.Empty;
        string                                   lo_strComCorpNo                     = string.Empty;
        string                                   lo_strDecNo                         = string.Empty;
        ReqTaxBillIns                            lo_objReqTaxBillIns                 = null;
        ServiceResult<bool>                      lo_objResTaxBillIns                 = null;
        string                                   lo_strISSU_SEQNO                    = string.Empty;
        string                                   lo_strNOTE1                         = string.Empty;
        string                                   lo_strNOTE2                         = string.Empty;
        string                                   lo_strNOTE3                         = string.Empty;
        ReqPurchaseClosingBillInfoUpd            lo_objReqPurchaseClosingBillInfoUpd = null;
        ServiceResult<bool>                      lo_objResPurchaseClosingBillInfoUpd = null;

        if (string.IsNullOrWhiteSpace(strNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strDecNo = Utils.GetDecrypt(strNo);

            if (string.IsNullOrWhiteSpace(lo_strDecNo))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_objSmsBillModel = JsonConvert.DeserializeObject<SmsBillModel>(lo_strDecNo);

            if (lo_objSmsBillModel == null)
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전송된 값이 올바르지 않습니다.";
                return;
            }

            lo_strCenterCode           = Utils.IsNull(lo_objSmsBillModel.CenterCode.ToString(),           "0");
            lo_strPurchaseClosingSeqNo = Utils.IsNull(lo_objSmsBillModel.PurchaseClosingSeqNo.ToString(), "0");
            lo_strComCorpNo            = Utils.IsNull(lo_objSmsBillModel.ComCorpNo,                       string.Empty);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (string.IsNullOrWhiteSpace(lo_strCenterCode) || lo_strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(lo_strPurchaseClosingSeqNo) || lo_strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(lo_strComCorpNo))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSmsPurchaseClosingList = new ReqSmsPurchaseClosingList
            {
                PurchaseClosingSeqNo = lo_strPurchaseClosingSeqNo.ToInt64(),
                CenterCode           = lo_strCenterCode.ToInt(),
                DateType             = strDateType.ToInt(),
                DateFrom             = strDateFrom,
                DateTo               = strDateTo,
                ComCorpNo            = lo_strComCorpNo,
                PageSize             = intPageSize,
                PageNo               = intPageNo
            };

            lo_objResSmsPurchaseClosingList = objSmsDasServices.GetSmsPurchaseClosingList(lo_objReqSmsPurchaseClosingList);


            if (lo_objResSmsPurchaseClosingList.result.ErrorCode.IsFail())
            {
                objResMap.RetCode = lo_objResSmsPurchaseClosingList.result.ErrorCode;
                objResMap.ErrMsg  = lo_objResSmsPurchaseClosingList.result.ErrorMsg;
                return;
            }

            if (!lo_objResSmsPurchaseClosingList.data.RecordCnt.Equals(1))
            {
                objResMap.RetCode = 9008;
                objResMap.ErrMsg  = "올바른 전표정보가 아닙니다.";
                return;
            }

            if (!string.IsNullOrWhiteSpace(lo_objResSmsPurchaseClosingList.data.list[0].ComUpdYMD))
            {
                if (lo_objResSmsPurchaseClosingList.data.list[0].ComTaxKindM.Equals("면세") || lo_objResSmsPurchaseClosingList.data.list[0].ComTaxKindM.Equals("간이") || lo_objResSmsPurchaseClosingList.data.list[0].ComTaxKindM.Equals("영세"))
                {
                    if (lo_objResSmsPurchaseClosingList.data.list[0].BillWrite.ToInt() >= lo_objResSmsPurchaseClosingList.data.list[0].ComUpdYMD.ToInt())
                    {
                        objResMap.RetCode = 9011;
                        objResMap.ErrMsg  = $"{lo_objResSmsPurchaseClosingList.data.list[0].ComTaxKindM}과세자는 계산서를 발행하실 수 없습니다.";
                        return;
                    }
                }
                else
                {
                    if (lo_objResSmsPurchaseClosingList.data.list[0].BillWrite.ToInt() < lo_objResSmsPurchaseClosingList.data.list[0].ComUpdYMD.ToInt())
                    {
                        objResMap.RetCode = 9011;
                        objResMap.ErrMsg  = $"작성일이 [{Utils.DateFormatter(lo_objResSmsPurchaseClosingList.data.list[0].ComUpdYMD, "yyyyMMdd", "yyyy.MM.dd", lo_objResSmsPurchaseClosingList.data.list[0].ComUpdYMD)}]이전 전표는 계산서를 발행하실 수 없습니다.";
                        return;
                    }
                }
            }
            else
            {
                if (lo_objResSmsPurchaseClosingList.data.list[0].ComTaxKindM.Equals("면세") || lo_objResSmsPurchaseClosingList.data.list[0].ComTaxKindM.Equals("간이") || lo_objResSmsPurchaseClosingList.data.list[0].ComTaxKindM.Equals("영세"))
                {
                    objResMap.RetCode = 9011;
                    objResMap.ErrMsg  = $"{lo_objResSmsPurchaseClosingList.data.list[0].ComTaxKindM}과세자는 계산서를 발행하실 수 없습니다.";
                    return;
                }
            }

            if (lo_objResSmsPurchaseClosingList.data.list[0].BillStatus > 1)
            {
                objResMap.RetCode = 9009;
                objResMap.ErrMsg = "이미 발행 처리된 전표입니다.";
                return;
            }

            if (lo_objResSmsPurchaseClosingList.data.list[0].SendStatus > 1)
            {
                objResMap.RetCode = 9010;
                objResMap.ErrMsg  = "이미 송금 처리된 전표입니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        lo_objSmsPurchaseClosingGridModel = lo_objResSmsPurchaseClosingList.data.list[0];

        lo_strISSU_SEQNO =  CommonConstant.TAX_PREFIX_TMS_PURCHASE;
        lo_strISSU_SEQNO += string.Format("{0:D4}", lo_objSmsPurchaseClosingGridModel.CenterCode.ToInt());
        lo_strISSU_SEQNO += lo_objSmsPurchaseClosingGridModel.PurchaseClosingSeqNo + "02";
        lo_strNOTE1      =  "송금액 : " + lo_objSmsPurchaseClosingGridModel.OrgAmt + " " + lo_objSmsPurchaseClosingGridModel.PurchaseClosingSeqNo;
        lo_strNOTE2      =  string.Empty;
        lo_strNOTE3      =  lo_strISSU_SEQNO;

        try
        {
            lo_objReqTaxBillIns = new ReqTaxBillIns
            {
                ISSU_SEQNO      = lo_strISSU_SEQNO,
                TAX_CHG_FLAG    = "N",
                ITEM_AMT        = lo_objSmsPurchaseClosingGridModel.SupplyAmt,
                ITEM_TAX        = lo_objSmsPurchaseClosingGridModel.TaxAmt,
                BUY_DATE        = lo_objSmsPurchaseClosingGridModel.BillWrite,
                TAX_TYPE        = "0103", //세금계산서 종류(2자리) : 01(세금계산서), 02(수정세금계산서), 03(계산서), 04(수정계산서) / 세금계산서 분류(2자리) : 01(일반), 02(영세율), 03(위수탁), 04(수입), 05(영세율위수탁)
                POPS_CODE       = "02", //청구/영수(01:영수, 02:청구)
                //MODY_CODE       = strMODY_CODE, //수정계산서 발행시 세팅
                NOTE1           = lo_strNOTE1,
                NOTE2           = lo_strNOTE2,
                NOTE3           = lo_strNOTE3,
                SELR_CORP_NO    = lo_objSmsPurchaseClosingGridModel.ComCorpNo,
                SELR_CORP_NM    = lo_objSmsPurchaseClosingGridModel.ComName,
                SELR_CEO        = lo_objSmsPurchaseClosingGridModel.ComCeoName,
                SELR_ADDR       = lo_objSmsPurchaseClosingGridModel.ComAddr,
                SELR_TEL        = lo_objSmsPurchaseClosingGridModel.ComTelNo,
                SELR_BUSS_CONS  = lo_objSmsPurchaseClosingGridModel.ComBizClass,
                SELR_BUSS_TYPE  = lo_objSmsPurchaseClosingGridModel.ComBizType,
                SELR_CHRG_NM    = lo_objSmsPurchaseClosingGridModel.DriverName,
                SELR_CHRG_EMAIL = lo_objSmsPurchaseClosingGridModel.ComEmail,
                SELR_CHRG_MOBL  = lo_objSmsPurchaseClosingGridModel.DriverCell,
                //BANK_NOTE1      = strBANK_NOTE1,
                BUYR_CORP_NO    = lo_objSmsPurchaseClosingGridModel.CorpNo,
                BUYR_CORP_NM    = lo_objSmsPurchaseClosingGridModel.CenterName,
                BUYR_CEO        = lo_objSmsPurchaseClosingGridModel.CeoName,
                BUYR_ADDR       = lo_objSmsPurchaseClosingGridModel.Addr,
                BUYR_TEL        = lo_objSmsPurchaseClosingGridModel.TelNo,
                BUYR_BUSS_CONS  = lo_objSmsPurchaseClosingGridModel.BizClass,
                BUYR_BUSS_TYPE  = lo_objSmsPurchaseClosingGridModel.BizType,
                //BUYR_CHRG_NM    = strBUYR_CHRG_NM,
                //BUYR_CHRG_EMAIL = strBUYR_CHRG_EMAIL, 
                //BUYR_CHRG_MOBL  = strBUYR_CHRG_MOBL,
                BROK_CORP_NO    = CommonConstant.TAX_BROK_CORP_NO,
                BROK_CORP_NM    = CommonConstant.TAX_BROK_CORP_NM,
                BROK_CEO        = CommonConstant.TAX_BROK_CEO,
                BROK_ADDR       = CommonConstant.TAX_BROK_ADDR,
                BROK_TEL        = CommonConstant.TAX_BROK_TEL,
                BROK_BUSS_CONS  = CommonConstant.TAX_BROK_BUSS_CONS,
                BROK_BUSS_TYPE  = CommonConstant.TAX_BROK_BUSS_TYPE,
                //BROK_CHRG_NM    = strBROK_CHRG_NM,
                //BROK_CHRG_EMAIL = strBROK_CHRG_EMAIL,
                //BROK_CHRG_MOBL  = strBROK_CHRG_MOBL,
                BILL_TYPE       = "1", // 1:매출세금계산서, 2:매입세금계산서
                //BFO_ISSU_SEQNO  = strBFO_ISSU_SEQNO, //수정계산서발행시
                DTL_BUY_DATE1   = lo_objSmsPurchaseClosingGridModel.BillWrite,
                DTL_ITEM_NM1    = "운송료",
                //DTL_ITEM_QUNT1  = strDTL_ITEM_QUNT1,
                //DTL_UNIT_PRCE1  = strDTL_UNIT_PRCE1,
                DTL_ITEM_AMT1   = lo_objSmsPurchaseClosingGridModel.SupplyAmt,
                DTL_ITEM_TAX1   = lo_objSmsPurchaseClosingGridModel.TaxAmt,
                DTL_ITEM_DESP1  = string.Empty
            };

            lo_objResTaxBillIns = objTaxDasServices.SetTaxBillIns(lo_objReqTaxBillIns);
            objResMap.RetCode   = lo_objResTaxBillIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = lo_objResTaxBillIns.result.ErrorMsg;
                return;
            }

            objResMap.Add("IssuSeqNo", lo_strISSU_SEQNO);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqPurchaseClosingBillInfoUpd = new ReqPurchaseClosingBillInfoUpd
            {
                CenterCode            = lo_objSmsPurchaseClosingGridModel.CenterCode,
                PurchaseClosingSeqNos = lo_objSmsPurchaseClosingGridModel.PurchaseClosingSeqNo,
                BillStatus            = 2,
                BillKind              = 2,
                BillWrite             = lo_objSmsPurchaseClosingGridModel.BillWrite,
                BillYMD               = DateTime.Now.ToString("yyyyMMdd"),
                ChkPermFlag           = "N",
                UpdAdminID            = lo_objSmsPurchaseClosingGridModel.DriverCell,
                UpdAdminName          = lo_objSmsPurchaseClosingGridModel.DriverName + "(알림톡)"
            };

            lo_objResPurchaseClosingBillInfoUpd = objPurchaseDasServices.SetPurchaseClosingBillInfoUpd(lo_objReqPurchaseClosingBillInfoUpd);
            objResMap.RetCode                   = lo_objResPurchaseClosingBillInfoUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseClosingBillInfoUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SmsBillHandler", "Exception",
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