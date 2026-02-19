<%@ WebHandler Language="C#" Class="SaleClosingTaxBillHandler" %>
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
/// FileName        : SaleClosingTaxBillHandler.ashx
/// Description     : 매출마감계산서 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-02
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class SaleClosingTaxBillHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingSale/SaleClosingTaxBillList"; //필수

    // 메소드 리스트
    private const string MethodSaleClosingList     = "SaleClosingList";             //매출 전표 목록
    private const string MethodSaleClosingPayList  = "SaleClosingPayList";          //매출 전표 비용 목록
    private const string MethodClientChargeList    = "ClientChargeList";            //고객사 담당자 조회
    private const string MethodSaleTaxBillList     = "SaleClosingTaxBillList";      //매출 계산서 목록
    private const string MethodSaleTaxBillItemList = "SaleClosingTaxBillItemList";  //매출 계산서 항목 목록
    private const string MethodSaleTaxBillIns      = "SaleClosingTaxBillInsert";    //매출 계산서 발행
    private const string MethodSaleTaxBillModIns   = "SaleClosingTaxBillModInsert"; //매출 계산서 수정 발행
    private const string MethodSaleTaxBillCnl      = "SaleClosingTaxBillCancel";    //매출 계산서 발행 취소

    SaleDasServices     objSaleDasServices   = new SaleDasServices();
    ClientDasServices   objClientDasServices = new ClientDasServices();
    TaxDasServices      objTaxDasServices    = new TaxDasServices();
    private HttpContext objHttpContext       = null;

    private string strCallType         = string.Empty;
    private int    intPageSize         = 0;
    private int    intPageNo           = 0;
    private string strDateType         = string.Empty;
    private string strDateFrom         = string.Empty;
    private string strDateTo           = string.Empty;
    private string strClosingType      = string.Empty;
    private string strCenterCode       = string.Empty;
    private string strCenterCorpNo     = string.Empty;
    private string strReqStatCode      = string.Empty;
    private string strStatCode         = string.Empty;
    private string strCorpName         = string.Empty;
    private string strCorpNo           = string.Empty;
    private string strChargeName       = string.Empty;
    private string strChargeEmail      = string.Empty;
    private string strIssuSeqNo        = string.Empty;
    private string strIssuID           = string.Empty;
    private string strSaleClosingSeqNo = string.Empty;
    private string strClientCode       = string.Empty;
    private string strSELR_CORP_NO     = string.Empty;
    private string strSELR_CORP_NM     = string.Empty;
    private string strSELR_CEO         = string.Empty;
    private string strSELR_ADDR        = string.Empty;
    private string strSELR_TEL         = string.Empty;
    private string strSELR_BUSS_CONS   = string.Empty;
    private string strSELR_BUSS_TYPE   = string.Empty;
    private string strSELR_CHRG_NM     = string.Empty;
    private string strSELR_CHRG_EMAIL  = string.Empty;
    private string strSELR_CHRG_MOBL   = string.Empty;
    private string strBUYR_CORP_NO     = string.Empty;
    private string strBUYR_CORP_NM     = string.Empty;
    private string strBUYR_CEO         = string.Empty;
    private string strBUYR_ADDR        = string.Empty;
    private string strBUYR_TEL         = string.Empty;
    private string strBUYR_BUSS_CONS   = string.Empty;
    private string strBUYR_BUSS_TYPE   = string.Empty;
    private string strBUYR_CHRG_NM     = string.Empty;
    private string strBUYR_CHRG_EMAIL  = string.Empty;
    private string strBUYR_CHRG_MOBL   = string.Empty;
    private string strBUY_DATE         = string.Empty;
    private string strITEM_AMT         = string.Empty;
    private string strITEM_TAX         = string.Empty;
    private string strDTL_BUY_DATE1    = string.Empty;
    private string strDTL_ITEM_NM1     = string.Empty;
    private string strDTL_ITEM_AMT1    = string.Empty;
    private string strDTL_ITEM_TAX1    = string.Empty;
    private string strDTL_ITEM_DESP1   = string.Empty;
    private string strDTL_BUY_DATE2    = string.Empty;
    private string strDTL_ITEM_NM2     = string.Empty;
    private string strDTL_ITEM_AMT2    = string.Empty;
    private string strDTL_ITEM_TAX2    = string.Empty;
    private string strDTL_ITEM_DESP2   = string.Empty;
    private string strDTL_BUY_DATE3    = string.Empty;
    private string strDTL_ITEM_NM3     = string.Empty;
    private string strDTL_ITEM_AMT3    = string.Empty;
    private string strDTL_ITEM_TAX3    = string.Empty;
    private string strDTL_ITEM_DESP3   = string.Empty;
    private string strDTL_BUY_DATE4    = string.Empty;
    private string strDTL_ITEM_NM4     = string.Empty;
    private string strDTL_ITEM_AMT4    = string.Empty;
    private string strDTL_ITEM_DESP4   = string.Empty;
    private string strDTL_ITEM_TAX4    = string.Empty;
    private string strDTL_BUY_DATE5    = string.Empty;
    private string strDTL_ITEM_NM5     = string.Empty;
    private string strDTL_ITEM_AMT5    = string.Empty;
    private string strDTL_ITEM_TAX5    = string.Empty;
    private string strDTL_ITEM_DESP5   = string.Empty;
    private string strDTL_BUY_DATE6    = string.Empty;
    private string strDTL_ITEM_NM6     = string.Empty;
    private string strDTL_ITEM_AMT6    = string.Empty;
    private string strDTL_ITEM_TAX6    = string.Empty;
    private string strDTL_ITEM_DESP6   = string.Empty;
    private string strDTL_BUY_DATE7    = string.Empty;
    private string strDTL_ITEM_NM7     = string.Empty;
    private string strDTL_ITEM_AMT7    = string.Empty;
    private string strDTL_ITEM_TAX7    = string.Empty;
    private string strDTL_ITEM_DESP7   = string.Empty;
    private string strDTL_BUY_DATE8    = string.Empty;
    private string strDTL_ITEM_NM8     = string.Empty;
    private string strDTL_ITEM_AMT8    = string.Empty;
    private string strDTL_ITEM_TAX8    = string.Empty;
    private string strDTL_ITEM_DESP8   = string.Empty;
    private string strDTL_BUY_DATE9    = string.Empty;
    private string strDTL_ITEM_NM9     = string.Empty;
    private string strDTL_ITEM_AMT9    = string.Empty;
    private string strDTL_ITEM_TAX9    = string.Empty;
    private string strDTL_ITEM_DESP9   = string.Empty;
    private string strDTL_BUY_DATE10   = string.Empty;
    private string strDTL_ITEM_NM10    = string.Empty;
    private string strDTL_ITEM_AMT10   = string.Empty;
    private string strDTL_ITEM_TAX10   = string.Empty;
    private string strDTL_ITEM_DESP10  = string.Empty;
    private string strDTL_BUY_DATE11   = string.Empty;
    private string strDTL_ITEM_NM11    = string.Empty;
    private string strDTL_ITEM_AMT11   = string.Empty;
    private string strDTL_ITEM_TAX11   = string.Empty;
    private string strDTL_ITEM_DESP11  = string.Empty;
    private string strDTL_BUY_DATE12   = string.Empty;
    private string strDTL_ITEM_NM12    = string.Empty;
    private string strDTL_ITEM_AMT12   = string.Empty;
    private string strDTL_ITEM_TAX12   = string.Empty;
    private string strDTL_ITEM_DESP12  = string.Empty;
    private string strDTL_BUY_DATE13   = string.Empty;
    private string strDTL_ITEM_NM13    = string.Empty;
    private string strDTL_ITEM_AMT13   = string.Empty;
    private string strDTL_ITEM_TAX13   = string.Empty;
    private string strDTL_ITEM_DESP13  = string.Empty;
    private string strDTL_BUY_DATE14   = string.Empty;
    private string strDTL_ITEM_NM14    = string.Empty;
    private string strDTL_ITEM_AMT14   = string.Empty;
    private string strDTL_ITEM_TAX14   = string.Empty;
    private string strDTL_ITEM_DESP14  = string.Empty;
    private string strDTL_BUY_DATE15   = string.Empty;
    private string strDTL_ITEM_NM15    = string.Empty;
    private string strDTL_ITEM_AMT15   = string.Empty;
    private string strDTL_ITEM_TAX15   = string.Empty;
    private string strDTL_ITEM_DESP15  = string.Empty;
    private string strNOTE1            = string.Empty;
    private string strPOPS_CODE        = string.Empty;
    private string strTOTAL_AMT        = string.Empty;
    private string strMODY_CODE        = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodSaleClosingList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSaleClosingPayList,  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientChargeList,    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSaleTaxBillList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSaleTaxBillItemList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodSaleTaxBillIns,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSaleTaxBillModIns,   MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodSaleTaxBillCnl,      MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("SaleClosingTaxBillHandler");
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
            strCenterCode       = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),  "0");
            strClosingType      = Utils.IsNull(SiteGlobal.GetRequestForm("ClosingType"), "0");
            strDateType         = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),    "0");
            strDateFrom         = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo           = SiteGlobal.GetRequestForm("DateTo");
            strCenterCorpNo     = SiteGlobal.GetRequestForm("CenterCorpNo");
            strReqStatCode      = SiteGlobal.GetRequestForm("ReqStatCode");
            strStatCode         = SiteGlobal.GetRequestForm("StatCode");
            strCorpName         = SiteGlobal.GetRequestForm("CorpName");
            strCorpNo           = SiteGlobal.GetRequestForm("CorpNo");
            strChargeName       = SiteGlobal.GetRequestForm("ChargeName");
            strChargeEmail      = SiteGlobal.GetRequestForm("ChargeEmail");
            strIssuSeqNo        = SiteGlobal.GetRequestForm("IssuSeqNo");
            strIssuID           = SiteGlobal.GetRequestForm("IssuID");
            strSaleClosingSeqNo = SiteGlobal.GetRequestForm("SaleClosingSeqNo");
            strClientCode       = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strSELR_CORP_NO     = SiteGlobal.GetRequestForm("SELR_CORP_NO");
            strSELR_CORP_NM     = SiteGlobal.GetRequestForm("SELR_CORP_NM");
            strSELR_CEO         = SiteGlobal.GetRequestForm("SELR_CEO");
            strSELR_ADDR        = SiteGlobal.GetRequestForm("SELR_ADDR");
            strSELR_TEL         = SiteGlobal.GetRequestForm("SELR_TEL");
            strSELR_BUSS_CONS   = SiteGlobal.GetRequestForm("SELR_BUSS_CONS");
            strSELR_BUSS_TYPE   = SiteGlobal.GetRequestForm("SELR_BUSS_TYPE");
            strSELR_CHRG_NM     = SiteGlobal.GetRequestForm("SELR_CHRG_NM");
            strSELR_CHRG_EMAIL  = SiteGlobal.GetRequestForm("SELR_CHRG_EMAIL");
            strSELR_CHRG_MOBL   = SiteGlobal.GetRequestForm("SELR_CHRG_MOBL");
            strBUYR_CORP_NO     = SiteGlobal.GetRequestForm("BUYR_CORP_NO");
            strBUYR_CORP_NM     = SiteGlobal.GetRequestForm("BUYR_CORP_NM");
            strBUYR_CEO         = SiteGlobal.GetRequestForm("BUYR_CEO");
            strBUYR_ADDR        = SiteGlobal.GetRequestForm("BUYR_ADDR");
            strBUYR_TEL         = SiteGlobal.GetRequestForm("BUYR_TEL");
            strBUYR_BUSS_CONS   = SiteGlobal.GetRequestForm("BUYR_BUSS_CONS");
            strBUYR_BUSS_TYPE   = SiteGlobal.GetRequestForm("BUYR_BUSS_TYPE");
            strBUYR_CHRG_NM     = SiteGlobal.GetRequestForm("BUYR_CHRG_NM");
            strBUYR_CHRG_EMAIL  = SiteGlobal.GetRequestForm("BUYR_CHRG_EMAIL");
            strBUYR_CHRG_MOBL   = SiteGlobal.GetRequestForm("BUYR_CHRG_MOBL");
            strBUY_DATE         = SiteGlobal.GetRequestForm("BUY_DATE");
            strITEM_AMT         = SiteGlobal.GetRequestForm("ITEM_AMT");
            strITEM_TAX         = SiteGlobal.GetRequestForm("ITEM_TAX");
            strDTL_BUY_DATE1    = SiteGlobal.GetRequestForm("DTL_BUY_DATE1");
            strDTL_ITEM_NM1     = SiteGlobal.GetRequestForm("DTL_ITEM_NM1");
            strDTL_ITEM_AMT1    = SiteGlobal.GetRequestForm("DTL_ITEM_AMT1");
            strDTL_ITEM_TAX1    = SiteGlobal.GetRequestForm("DTL_ITEM_TAX1");
            strDTL_ITEM_DESP1   = SiteGlobal.GetRequestForm("DTL_ITEM_DESP1");
            strDTL_BUY_DATE2    = SiteGlobal.GetRequestForm("DTL_BUY_DATE2");
            strDTL_ITEM_NM2     = SiteGlobal.GetRequestForm("DTL_ITEM_NM2");
            strDTL_ITEM_AMT2    = SiteGlobal.GetRequestForm("DTL_ITEM_AMT2");
            strDTL_ITEM_TAX2    = SiteGlobal.GetRequestForm("DTL_ITEM_TAX2");
            strDTL_ITEM_DESP2   = SiteGlobal.GetRequestForm("DTL_ITEM_DESP2");
            strDTL_BUY_DATE3    = SiteGlobal.GetRequestForm("DTL_BUY_DATE3");
            strDTL_ITEM_NM3     = SiteGlobal.GetRequestForm("DTL_ITEM_NM3");
            strDTL_ITEM_AMT3    = SiteGlobal.GetRequestForm("DTL_ITEM_AMT3");
            strDTL_ITEM_TAX3    = SiteGlobal.GetRequestForm("DTL_ITEM_TAX3");
            strDTL_ITEM_DESP3   = SiteGlobal.GetRequestForm("DTL_ITEM_DESP3");
            strDTL_BUY_DATE4    = SiteGlobal.GetRequestForm("DTL_BUY_DATE4");
            strDTL_ITEM_NM4     = SiteGlobal.GetRequestForm("DTL_ITEM_NM4");
            strDTL_ITEM_AMT4    = SiteGlobal.GetRequestForm("DTL_ITEM_AMT4");
            strDTL_ITEM_TAX4    = SiteGlobal.GetRequestForm("DTL_ITEM_TAX4");
            strDTL_ITEM_DESP4   = SiteGlobal.GetRequestForm("DTL_ITEM_DESP4");
            strDTL_BUY_DATE5    = SiteGlobal.GetRequestForm("DTL_BUY_DATE5");
            strDTL_ITEM_NM5     = SiteGlobal.GetRequestForm("DTL_ITEM_NM5");
            strDTL_ITEM_AMT5    = SiteGlobal.GetRequestForm("DTL_ITEM_AMT5");
            strDTL_ITEM_TAX5    = SiteGlobal.GetRequestForm("DTL_ITEM_TAX5");
            strDTL_ITEM_DESP5   = SiteGlobal.GetRequestForm("DTL_ITEM_DESP5");
            strDTL_BUY_DATE6    = SiteGlobal.GetRequestForm("DTL_BUY_DATE6");
            strDTL_ITEM_NM6     = SiteGlobal.GetRequestForm("DTL_ITEM_NM6");
            strDTL_ITEM_AMT6    = SiteGlobal.GetRequestForm("DTL_ITEM_AMT6");
            strDTL_ITEM_TAX6    = SiteGlobal.GetRequestForm("DTL_ITEM_TAX6");
            strDTL_ITEM_DESP6   = SiteGlobal.GetRequestForm("DTL_ITEM_DESP6");
            strDTL_BUY_DATE7    = SiteGlobal.GetRequestForm("DTL_BUY_DATE7");
            strDTL_ITEM_NM7     = SiteGlobal.GetRequestForm("DTL_ITEM_NM7");
            strDTL_ITEM_AMT7    = SiteGlobal.GetRequestForm("DTL_ITEM_AMT7");
            strDTL_ITEM_TAX7    = SiteGlobal.GetRequestForm("DTL_ITEM_TAX7");
            strDTL_ITEM_DESP7   = SiteGlobal.GetRequestForm("DTL_ITEM_DESP7");
            strDTL_BUY_DATE8    = SiteGlobal.GetRequestForm("DTL_BUY_DATE8");
            strDTL_ITEM_NM8     = SiteGlobal.GetRequestForm("DTL_ITEM_NM8");
            strDTL_ITEM_AMT8    = SiteGlobal.GetRequestForm("DTL_ITEM_AMT8");
            strDTL_ITEM_TAX8    = SiteGlobal.GetRequestForm("DTL_ITEM_TAX8");
            strDTL_ITEM_DESP8   = SiteGlobal.GetRequestForm("DTL_ITEM_DESP8");
            strDTL_BUY_DATE9    = SiteGlobal.GetRequestForm("DTL_BUY_DATE9");
            strDTL_ITEM_NM9     = SiteGlobal.GetRequestForm("DTL_ITEM_NM9");
            strDTL_ITEM_AMT9    = SiteGlobal.GetRequestForm("DTL_ITEM_AMT9");
            strDTL_ITEM_TAX9    = SiteGlobal.GetRequestForm("DTL_ITEM_TAX9");
            strDTL_ITEM_DESP9   = SiteGlobal.GetRequestForm("DTL_ITEM_DESP9");
            strDTL_BUY_DATE10   = SiteGlobal.GetRequestForm("DTL_BUY_DATE10");
            strDTL_ITEM_NM10    = SiteGlobal.GetRequestForm("DTL_ITEM_NM10");
            strDTL_ITEM_AMT10   = SiteGlobal.GetRequestForm("DTL_ITEM_AMT10");
            strDTL_ITEM_TAX10   = SiteGlobal.GetRequestForm("DTL_ITEM_TAX10");
            strDTL_ITEM_DESP10  = SiteGlobal.GetRequestForm("DTL_ITEM_DESP10");
            strDTL_BUY_DATE11   = SiteGlobal.GetRequestForm("DTL_BUY_DATE11");
            strDTL_ITEM_NM11    = SiteGlobal.GetRequestForm("DTL_ITEM_NM11");
            strDTL_ITEM_AMT11   = SiteGlobal.GetRequestForm("DTL_ITEM_AMT11");
            strDTL_ITEM_TAX11   = SiteGlobal.GetRequestForm("DTL_ITEM_TAX11");
            strDTL_ITEM_DESP11  = SiteGlobal.GetRequestForm("DTL_ITEM_DESP11");
            strDTL_BUY_DATE12   = SiteGlobal.GetRequestForm("DTL_BUY_DATE12");
            strDTL_ITEM_NM12    = SiteGlobal.GetRequestForm("DTL_ITEM_NM12");
            strDTL_ITEM_AMT12   = SiteGlobal.GetRequestForm("DTL_ITEM_AMT12");
            strDTL_ITEM_TAX12   = SiteGlobal.GetRequestForm("DTL_ITEM_TAX12");
            strDTL_ITEM_DESP12  = SiteGlobal.GetRequestForm("DTL_ITEM_DESP12");
            strDTL_BUY_DATE13   = SiteGlobal.GetRequestForm("DTL_BUY_DATE13");
            strDTL_ITEM_NM13    = SiteGlobal.GetRequestForm("DTL_ITEM_NM13");
            strDTL_ITEM_AMT13   = SiteGlobal.GetRequestForm("DTL_ITEM_AMT13");
            strDTL_ITEM_TAX13   = SiteGlobal.GetRequestForm("DTL_ITEM_TAX13");
            strDTL_ITEM_DESP13  = SiteGlobal.GetRequestForm("DTL_ITEM_DESP13");
            strDTL_BUY_DATE14   = SiteGlobal.GetRequestForm("DTL_BUY_DATE14");
            strDTL_ITEM_NM14    = SiteGlobal.GetRequestForm("DTL_ITEM_NM14");
            strDTL_ITEM_AMT14   = SiteGlobal.GetRequestForm("DTL_ITEM_AMT14");
            strDTL_ITEM_TAX14   = SiteGlobal.GetRequestForm("DTL_ITEM_TAX14");
            strDTL_ITEM_DESP14  = SiteGlobal.GetRequestForm("DTL_ITEM_DESP14");
            strDTL_BUY_DATE15   = SiteGlobal.GetRequestForm("DTL_BUY_DATE15");
            strDTL_ITEM_NM15    = SiteGlobal.GetRequestForm("DTL_ITEM_NM15");
            strDTL_ITEM_AMT15   = SiteGlobal.GetRequestForm("DTL_ITEM_AMT15");
            strDTL_ITEM_TAX15   = SiteGlobal.GetRequestForm("DTL_ITEM_TAX15");
            strDTL_ITEM_DESP15  = SiteGlobal.GetRequestForm("DTL_ITEM_DESP15");
            strNOTE1            = SiteGlobal.GetRequestForm("NOTE1");
            strPOPS_CODE        = SiteGlobal.GetRequestForm("POPS_CODE");
            strTOTAL_AMT        = SiteGlobal.GetRequestForm("TOTAL_AMT");
            strMODY_CODE        = SiteGlobal.GetRequestForm("MODY_CODE");

            strBUY_DATE      = string.IsNullOrWhiteSpace(strBUY_DATE) ? strBUY_DATE : strBUY_DATE.Replace("-", "");
            strDateFrom      = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo        = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
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
                case MethodSaleClosingList:
                    GetSaleClosingList();
                    break;;
                case MethodSaleClosingPayList:
                    GetSaleClosingPayList();
                    break;
                case MethodClientChargeList:
                    GetClientChargeList();
                    break;
                case MethodSaleTaxBillList:
                    GetSaleTaxBillList();
                    break;
                case MethodSaleTaxBillItemList:
                    GetSaleTaxBillItemList();
                    break;
                case MethodSaleTaxBillIns:
                    SetSaleTaxBillIns();
                    break;
                case MethodSaleTaxBillModIns:
                    SetSaleTaxBillModIns();
                    break;
                case MethodSaleTaxBillCnl:
                    SetSaleTaxBillCnl();
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

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매출 전표 목록
    /// </summary>
    protected void GetSaleClosingList()
    {
        ReqSaleClosingList                lo_objReqSaleClosingList = null;
        ServiceResult<ResSaleClosingList> lo_objResSaleClosingList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingList = new ReqSaleClosingList
            {
                SaleClosingSeqNo      = strSaleClosingSeqNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResSaleClosingList = objSaleDasServices.GetSaleClosingList(lo_objReqSaleClosingList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResSaleClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 전표 비용 목록
    /// </summary>
    protected void GetSaleClosingPayList()
    {
        ReqSaleClosingPayList                lo_objReqSaleClosingPayList = null;
        ServiceResult<ResSaleClosingPayList> lo_objResSaleClosingPayList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqSaleClosingPayList = new ReqSaleClosingPayList
            {
                SaleClosingSeqNo = strSaleClosingSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResSaleClosingPayList = objSaleDasServices.GetSaleClosingPayList(lo_objReqSaleClosingPayList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResSaleClosingPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 담당자 검색
    /// </summary>
    protected void GetClientChargeList()
    {
        ReqClientSearchList                lo_objReqClientSearchList = null;
        ServiceResult<ResClientSearchList> lo_objResClientSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strChargeName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientSearchList = new ReqClientSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                UseFlag          = "Y",
                ChargeName       = strChargeName,
                //ChargeBillFlag   = "Y",
                ChargeUseFlag    = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientSearchList = objClientDasServices.GetClientSearchList(lo_objReqClientSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResClientSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }


    /// <summary>
    /// 매출 계산서 목록
    /// </summary>
    protected void GetSaleTaxBillList()
    {
        ReqTaxBillList                lo_objReqTaxBillList = null;
        ServiceResult<ResTaxBillList> lo_objResTaxBillList = null;

        if (string.IsNullOrWhiteSpace(strDateFrom) && string.IsNullOrWhiteSpace(strDateTo) && string.IsNullOrWhiteSpace(strIssuSeqNo) && string.IsNullOrWhiteSpace(strIssuID))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqTaxBillList = new ReqTaxBillList
            {

                ISSU_SEQNO       = strIssuSeqNo,
                ISSU_ID          = strIssuID,
                FROM_YMD         = strDateFrom,
                TO_YMD           = strDateTo,
                STAT_CODE        = strStatCode,
                REQ_STAT_CODE    = strReqStatCode,
                SELR_CORP_NO     = strCenterCorpNo,
                BUYR_CORP_NM     = strCorpName,
                BUYR_CORP_NO     = strCorpNo,
                BUYR_CHRG_NM1    = strChargeName,
                BUYR_CHRG_EMAIL1 = strChargeEmail,
                PAGE_SIZE        = intPageSize,
                PAGE_NO          = intPageNo
                //TAX_TYPES
                //SELR_CORP_NM
                //SELR_CHRG_NM
                //SELR_CHRG_EMAIL
            };

            lo_objResTaxBillList = objTaxDasServices.GetTaxBillList(strCenterCode.ToInt(), lo_objReqTaxBillList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResTaxBillList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 계산서 항목 목록
    /// </summary>
    protected void GetSaleTaxBillItemList()
    {
        ServiceResult<ResTaxBillItemList> lo_objResTaxBillItemList = null;

        if (string.IsNullOrWhiteSpace(strIssuSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResTaxBillItemList = objTaxDasServices.GetTaxBillItemList(strIssuSeqNo);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResTaxBillItemList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 계산서 발행
    /// </summary>
    protected void SetSaleTaxBillIns()
    {
        ReqTaxBillIns             lo_objReqTaxBillIns             = null;
        ServiceResult<bool>       lo_objResTaxBillIns             = null;
        ReqSaleClosingBillInfoUpd lo_objReqSaleClosingBillInfoUpd = null;
        ServiceResult<bool>       lo_objResSaleClosingBillInfoUpd = null;
        string                    lo_strISSU_SEQNO                = string.Empty;
        string                    lo_strNOTE2                     = string.Empty;
        string                    lo_strNOTE3                     = string.Empty;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        lo_strISSU_SEQNO =  CommonConstant.TAX_PREFIX_TMS_SALE;
        lo_strISSU_SEQNO += string.Format("{0:D4}", strCenterCode.ToInt());
        lo_strISSU_SEQNO += strSaleClosingSeqNo + "01";
        lo_strNOTE3      =  strSaleClosingSeqNo;

        strDTL_BUY_DATE1  = strBUY_DATE;
        strDTL_BUY_DATE2  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE2) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE3  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE3) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE4  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE4) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE5  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE5) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE6  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE6) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE7  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE7) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE8  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE8) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE9  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE9) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE10 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE10) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE11 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE11) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE12 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE12) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE13 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE13) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE14 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE14) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE15 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE15) ? string.Empty : strBUY_DATE;

        strDTL_ITEM_AMT1	 = Utils.IsNull(strDTL_ITEM_AMT1, "0");
        strDTL_ITEM_TAX1	 = Utils.IsNull(strDTL_ITEM_TAX1, "0");
        strDTL_ITEM_AMT2	 = Utils.IsNull(strDTL_ITEM_AMT2, "0");
        strDTL_ITEM_TAX2	 = Utils.IsNull(strDTL_ITEM_TAX2, "0");
        strDTL_ITEM_AMT3	 = Utils.IsNull(strDTL_ITEM_AMT3, "0");
        strDTL_ITEM_TAX3	 = Utils.IsNull(strDTL_ITEM_TAX3, "0");
        strDTL_ITEM_AMT4	 = Utils.IsNull(strDTL_ITEM_AMT4, "0");
        strDTL_ITEM_TAX4	 = Utils.IsNull(strDTL_ITEM_TAX4, "0");
        strDTL_ITEM_AMT5	 = Utils.IsNull(strDTL_ITEM_AMT5, "0");
        strDTL_ITEM_TAX5	 = Utils.IsNull(strDTL_ITEM_TAX5, "0");
        strDTL_ITEM_AMT6	 = Utils.IsNull(strDTL_ITEM_AMT6, "0");
        strDTL_ITEM_TAX6	 = Utils.IsNull(strDTL_ITEM_TAX6, "0");
        strDTL_ITEM_AMT7	 = Utils.IsNull(strDTL_ITEM_AMT7, "0");
        strDTL_ITEM_TAX7	 = Utils.IsNull(strDTL_ITEM_TAX7, "0");
        strDTL_ITEM_AMT8	 = Utils.IsNull(strDTL_ITEM_AMT8, "0");
        strDTL_ITEM_TAX8	 = Utils.IsNull(strDTL_ITEM_TAX8, "0");
        strDTL_ITEM_AMT9	 = Utils.IsNull(strDTL_ITEM_AMT9, "0");
        strDTL_ITEM_TAX9	 = Utils.IsNull(strDTL_ITEM_TAX9, "0");
        strDTL_ITEM_AMT10	 = Utils.IsNull(strDTL_ITEM_AMT10, "0");
        strDTL_ITEM_TAX10	 = Utils.IsNull(strDTL_ITEM_TAX10, "0");
        strDTL_ITEM_AMT11	 = Utils.IsNull(strDTL_ITEM_AMT11, "0");
        strDTL_ITEM_TAX11	 = Utils.IsNull(strDTL_ITEM_TAX11, "0");
        strDTL_ITEM_AMT12	 = Utils.IsNull(strDTL_ITEM_AMT12, "0");
        strDTL_ITEM_TAX12	 = Utils.IsNull(strDTL_ITEM_TAX12, "0");
        strDTL_ITEM_AMT13	 = Utils.IsNull(strDTL_ITEM_AMT13, "0");
        strDTL_ITEM_TAX13	 = Utils.IsNull(strDTL_ITEM_TAX13, "0");
        strDTL_ITEM_AMT14	 = Utils.IsNull(strDTL_ITEM_AMT14, "0");
        strDTL_ITEM_TAX14	 = Utils.IsNull(strDTL_ITEM_TAX14, "0");
        strDTL_ITEM_AMT15	 = Utils.IsNull(strDTL_ITEM_AMT15, "0");
        strDTL_ITEM_TAX15	 = Utils.IsNull(strDTL_ITEM_TAX15, "0");

        try
        {
            lo_objReqTaxBillIns = new ReqTaxBillIns
            {
                ISSU_SEQNO      = lo_strISSU_SEQNO,
                TAX_CHG_FLAG    = "N",
                ITEM_AMT        = strITEM_AMT.ToDouble(),
                ITEM_TAX        = strITEM_TAX.ToDouble(),
                BUY_DATE        = strBUY_DATE,
                TAX_TYPE        = "0101", //세금계산서 종류(2자리) : 01(세금계산서), 02(수정세금계산서), 03(계산서), 04(수정계산서) / 세금계산서 분류(2자리) : 01(일반), 02(영세율), 03(위수탁), 04(수입), 05(영세율위수탁)
                POPS_CODE       = strPOPS_CODE,
                //MODY_CODE       = strMODY_CODE, //수정계산서 발행시 세팅
                NOTE1           = strNOTE1,
                NOTE2           = lo_strNOTE2,
                NOTE3           = lo_strNOTE3,
                SELR_CORP_NO    = strSELR_CORP_NO,
                SELR_CORP_NM    = strSELR_CORP_NM,
                SELR_CEO        = strSELR_CEO,
                SELR_ADDR       = strSELR_ADDR,
                SELR_TEL        = strSELR_TEL,
                SELR_BUSS_CONS  = strSELR_BUSS_CONS,
                SELR_BUSS_TYPE  = strSELR_BUSS_TYPE,
                SELR_CHRG_NM    = strSELR_CHRG_NM,
                SELR_CHRG_EMAIL = strSELR_CHRG_EMAIL,
                SELR_CHRG_MOBL  = strSELR_CHRG_MOBL,
                //BANK_NOTE1      = strBANK_NOTE1,
                BUYR_CORP_NO    = strBUYR_CORP_NO,
                BUYR_CORP_NM    = strBUYR_CORP_NM,
                BUYR_CEO        = strBUYR_CEO,
                BUYR_ADDR       = strBUYR_ADDR,
                BUYR_TEL        = strBUYR_TEL,
                BUYR_BUSS_CONS  = strBUYR_BUSS_CONS,
                BUYR_BUSS_TYPE  = strBUYR_BUSS_TYPE,
                BUYR_CHRG_NM    = strBUYR_CHRG_NM,
                BUYR_CHRG_EMAIL = strBUYR_CHRG_EMAIL, 
                BUYR_CHRG_MOBL  = strBUYR_CHRG_MOBL,
                //BROK_CORP_NO    = CommonConstant.TAX_BROK_CORP_NO,
                //BROK_CORP_NM    = CommonConstant.TAX_BROK_CORP_NM,
                //BROK_CEO        = CommonConstant.TAX_BROK_CEO,
                //BROK_ADDR       = CommonConstant.TAX_BROK_ADDR,
                //BROK_TEL        = CommonConstant.TAX_BROK_TEL,
                //BROK_BUSS_CONS  = CommonConstant.TAX_BROK_BUSS_CONS,
                //BROK_BUSS_TYPE  = CommonConstant.TAX_BROK_BUSS_TYPE, 
                //BROK_CHRG_NM    = strBROK_CHRG_NM,
                //BROK_CHRG_EMAIL = strBROK_CHRG_EMAIL,
                //BROK_CHRG_MOBL  = strBROK_CHRG_MOBL,
                BILL_TYPE       = "1", // 1:매출세금계산서, 2:매입세금계산서
                //BFO_ISSU_SEQNO  = strBFO_ISSU_SEQNO, //수정계산서발행시
                DTL_BUY_DATE1   = strDTL_BUY_DATE1,
                DTL_ITEM_NM1    = strDTL_ITEM_NM1,
                //DTL_ITEM_QUNT1  = strDTL_ITEM_QUNT1,
                //DTL_UNIT_PRCE1  = strDTL_UNIT_PRCE1,
                DTL_ITEM_AMT1   = strDTL_ITEM_AMT1.ToDouble(),
                DTL_ITEM_TAX1   = strDTL_ITEM_TAX1.ToDouble(),
                DTL_ITEM_DESP1  = strDTL_ITEM_DESP1,
                DTL_BUY_DATE2   = strDTL_BUY_DATE2,
                DTL_ITEM_NM2    = strDTL_ITEM_NM2,
                //DTL_ITEM_QUNT2  = strDTL_ITEM_QUNT2,
                //DTL_UNIT_PRCE2  = strDTL_UNIT_PRCE2,
                DTL_ITEM_AMT2   = strDTL_ITEM_AMT2.ToDouble(),
                DTL_ITEM_TAX2   = strDTL_ITEM_TAX2.ToDouble(),
                DTL_ITEM_DESP2  = strDTL_ITEM_DESP2,
                DTL_BUY_DATE3   = strDTL_BUY_DATE3,
                DTL_ITEM_NM3    = strDTL_ITEM_NM3,
                //DTL_ITEM_QUNT3  = strDTL_ITEM_QUNT3,
                //DTL_UNIT_PRCE3  = strDTL_UNIT_PRCE3,
                DTL_ITEM_AMT3   = strDTL_ITEM_AMT3.ToDouble(),
                DTL_ITEM_TAX3   = strDTL_ITEM_TAX3.ToDouble(),
                DTL_ITEM_DESP3  = strDTL_ITEM_DESP3,
                DTL_BUY_DATE4   = strDTL_BUY_DATE4,
                DTL_ITEM_NM4    = strDTL_ITEM_NM4,
                //DTL_ITEM_QUNT4  = strDTL_ITEM_QUNT4,
                //DTL_UNIT_PRCE4  = strDTL_UNIT_PRCE4,
                DTL_ITEM_AMT4   = strDTL_ITEM_AMT4.ToDouble(),
                DTL_ITEM_TAX4   = strDTL_ITEM_TAX4.ToDouble(),
                DTL_ITEM_DESP4  = strDTL_ITEM_DESP4,
                DTL_BUY_DATE5   = strDTL_BUY_DATE5,
                DTL_ITEM_NM5    = strDTL_ITEM_NM5,
                //DTL_ITEM_QUNT5  = strDTL_ITEM_QUNT5,
                //DTL_UNIT_PRCE5  = strDTL_UNIT_PRCE5,
                DTL_ITEM_AMT5   = strDTL_ITEM_AMT5.ToDouble(),
                DTL_ITEM_TAX5   = strDTL_ITEM_TAX5.ToDouble(),
                DTL_ITEM_DESP5  = strDTL_ITEM_DESP5,
                DTL_BUY_DATE6   = strDTL_BUY_DATE6,
                DTL_ITEM_NM6    = strDTL_ITEM_NM6,
                //DTL_ITEM_QUNT6  = strDTL_ITEM_QUNT6,
                //DTL_UNIT_PRCE6  = strDTL_UNIT_PRCE6,
                DTL_ITEM_AMT6   = strDTL_ITEM_AMT6.ToDouble(),
                DTL_ITEM_TAX6   = strDTL_ITEM_TAX6.ToDouble(),
                DTL_ITEM_DESP6  = strDTL_ITEM_DESP6,
                DTL_BUY_DATE7   = strDTL_BUY_DATE7,
                DTL_ITEM_NM7    = strDTL_ITEM_NM7,
                //DTL_ITEM_QUNT7  = strDTL_ITEM_QUNT7,
                //DTL_UNIT_PRCE7  = strDTL_UNIT_PRCE7,
                DTL_ITEM_AMT7   = strDTL_ITEM_AMT7.ToDouble(),
                DTL_ITEM_TAX7   = strDTL_ITEM_TAX7.ToDouble(),
                DTL_ITEM_DESP7  = strDTL_ITEM_DESP7,
                DTL_BUY_DATE8   = strDTL_BUY_DATE8,
                DTL_ITEM_NM8    = strDTL_ITEM_NM8,
                //DTL_ITEM_QUNT8  = strDTL_ITEM_QUNT8,
                //DTL_UNIT_PRCE8  = strDTL_UNIT_PRCE8,
                DTL_ITEM_AMT8   = strDTL_ITEM_AMT8.ToDouble(),
                DTL_ITEM_TAX8   = strDTL_ITEM_TAX8.ToDouble(),
                DTL_ITEM_DESP8  = strDTL_ITEM_DESP8,
                DTL_BUY_DATE9   = strDTL_BUY_DATE9,
                DTL_ITEM_NM9    = strDTL_ITEM_NM9,
                //DTL_ITEM_QUNT9  = strDTL_ITEM_QUNT9,
                //DTL_UNIT_PRCE9  = strDTL_UNIT_PRCE9,
                DTL_ITEM_AMT9   = strDTL_ITEM_AMT9.ToDouble(),
                DTL_ITEM_TAX9   = strDTL_ITEM_TAX9.ToDouble(),
                DTL_ITEM_DESP9  = strDTL_ITEM_DESP9,
                DTL_BUY_DATE10  = strDTL_BUY_DATE10,
                DTL_ITEM_NM10   = strDTL_ITEM_NM10,
                //DTL_ITEM_QUNT10 = strDTL_ITEM_QUNT10,
                //DTL_UNIT_PRCE10 = strDTL_UNIT_PRCE10,
                DTL_ITEM_AMT10  = strDTL_ITEM_AMT10.ToDouble(),
                DTL_ITEM_TAX10  = strDTL_ITEM_TAX10.ToDouble(),
                DTL_ITEM_DESP10 = strDTL_ITEM_DESP10,
                DTL_BUY_DATE11  = strDTL_BUY_DATE11,
                DTL_ITEM_NM11   = strDTL_ITEM_NM11,
                //DTL_ITEM_QUNT11 = strDTL_ITEM_QUNT11,
                //DTL_UNIT_PRCE11 = strDTL_UNIT_PRCE11,
                DTL_ITEM_AMT11  = strDTL_ITEM_AMT11.ToDouble(),
                DTL_ITEM_TAX11  = strDTL_ITEM_TAX11.ToDouble(),
                DTL_ITEM_DESP11 = strDTL_ITEM_DESP11,
                DTL_BUY_DATE12  = strDTL_BUY_DATE12,
                DTL_ITEM_NM12   = strDTL_ITEM_NM12,
                //DTL_ITEM_QUNT12 = strDTL_ITEM_QUNT12,
                //DTL_UNIT_PRCE12 = strDTL_UNIT_PRCE12,
                DTL_ITEM_AMT12  = strDTL_ITEM_AMT12.ToDouble(),
                DTL_ITEM_TAX12  = strDTL_ITEM_TAX12.ToDouble(),
                DTL_ITEM_DESP12 = strDTL_ITEM_DESP12,
                DTL_BUY_DATE13  = strDTL_BUY_DATE13,
                DTL_ITEM_NM13   = strDTL_ITEM_NM13,
                //DTL_ITEM_QUNT13 = strDTL_ITEM_QUNT13,
                //DTL_UNIT_PRCE13 = strDTL_UNIT_PRCE13,
                DTL_ITEM_AMT13  = strDTL_ITEM_AMT13.ToDouble(),
                DTL_ITEM_TAX13  = strDTL_ITEM_TAX13.ToDouble(),
                DTL_ITEM_DESP13 = strDTL_ITEM_DESP13,
                DTL_BUY_DATE14  = strDTL_BUY_DATE14,
                DTL_ITEM_NM14   = strDTL_ITEM_NM14,
                //DTL_ITEM_QUNT14 = strDTL_ITEM_QUNT14,
                //DTL_UNIT_PRCE14 = strDTL_UNIT_PRCE14,
                DTL_ITEM_AMT14  = strDTL_ITEM_AMT14.ToDouble(),
                DTL_ITEM_TAX14  = strDTL_ITEM_TAX14.ToDouble(),
                DTL_ITEM_DESP14 = strDTL_ITEM_DESP14,
                DTL_BUY_DATE15  = strDTL_BUY_DATE15,
                DTL_ITEM_NM15   = strDTL_ITEM_NM15,
                //DTL_ITEM_QUNT15 = strDTL_ITEM_QUNT15,
                //DTL_UNIT_PRCE15 = strDTL_UNIT_PRCE15,
                DTL_ITEM_AMT15  = strDTL_ITEM_AMT15.ToDouble(),
                DTL_ITEM_TAX15  = strDTL_ITEM_TAX15.ToDouble(),
                DTL_ITEM_DESP15 = strDTL_ITEM_DESP15,
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

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqSaleClosingBillInfoUpd = new ReqSaleClosingBillInfoUpd
            {
                CenterCode        = strCenterCode.ToInt(),
                SaleClosingSeqNos = strSaleClosingSeqNo,
                BillStatus        = 2,
                BillKind          = 1,
                BillChargeName    = strBUYR_CHRG_NM,
                BillChargeTelNo   = strBUYR_TEL,
                BillChargeEmail   = strBUYR_CHRG_EMAIL,
                BillWrite         = strBUY_DATE,
                BillYMD           = DateTime.Now.ToString("yyyyMMdd"),
                NtsConfirmNum     = string.Empty,
                BillAdminID       = objSes.AdminID,
                BillAdminName     = objSes.AdminName
            };

            lo_objResSaleClosingBillInfoUpd = objSaleDasServices.SetSaleClosingBillInfoUpd(lo_objReqSaleClosingBillInfoUpd);
            objResMap.RetCode = lo_objResSaleClosingBillInfoUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleClosingBillInfoUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 계산서 수정 발행
    /// </summary>
    protected void SetSaleTaxBillModIns()
    {
        ReqTaxBillIns       lo_objReqTaxBillIns = null;
        ServiceResult<bool> lo_objResTaxBillIns = null;
        string              lo_strNOTE2         = string.Empty;
        string              lo_strNOTE3         = string.Empty;
        string              lo_strISSU_SEQNO    = string.Empty;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strIssuSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strMODY_CODE))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        lo_strISSU_SEQNO = strIssuSeqNo.Substring(0, strIssuSeqNo.Length - 2) + "02";

        strDTL_BUY_DATE1  = strBUY_DATE;
        strDTL_BUY_DATE2  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE2) ? string.Empty : strBUY_DATE;
        strDTL_BUY_DATE3  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE3) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE4  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE4) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE5  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE5) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE6  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE6) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE7  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE7) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE8  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE8) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE9  = string.IsNullOrWhiteSpace(strDTL_BUY_DATE9) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE10 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE10) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE11 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE11) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE12 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE12) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE13 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE13) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE14 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE14) ? string.Empty :strBUY_DATE;
        strDTL_BUY_DATE15 = string.IsNullOrWhiteSpace(strDTL_BUY_DATE15) ? string.Empty :strBUY_DATE;

        strDTL_ITEM_AMT1	 = Utils.IsNull(strDTL_ITEM_AMT1, "0");
        strDTL_ITEM_TAX1	 = Utils.IsNull(strDTL_ITEM_TAX1, "0");
        strDTL_ITEM_AMT2	 = Utils.IsNull(strDTL_ITEM_AMT2, "0");
        strDTL_ITEM_TAX2	 = Utils.IsNull(strDTL_ITEM_TAX2, "0");
        strDTL_ITEM_AMT3	 = Utils.IsNull(strDTL_ITEM_AMT3, "0");
        strDTL_ITEM_TAX3	 = Utils.IsNull(strDTL_ITEM_TAX3, "0");
        strDTL_ITEM_AMT4	 = Utils.IsNull(strDTL_ITEM_AMT4, "0");
        strDTL_ITEM_TAX4	 = Utils.IsNull(strDTL_ITEM_TAX4, "0");
        strDTL_ITEM_AMT5	 = Utils.IsNull(strDTL_ITEM_AMT5, "0");
        strDTL_ITEM_TAX5	 = Utils.IsNull(strDTL_ITEM_TAX5, "0");
        strDTL_ITEM_AMT6	 = Utils.IsNull(strDTL_ITEM_AMT6, "0");
        strDTL_ITEM_TAX6	 = Utils.IsNull(strDTL_ITEM_TAX6, "0");
        strDTL_ITEM_AMT7	 = Utils.IsNull(strDTL_ITEM_AMT7, "0");
        strDTL_ITEM_TAX7	 = Utils.IsNull(strDTL_ITEM_TAX7, "0");
        strDTL_ITEM_AMT8	 = Utils.IsNull(strDTL_ITEM_AMT8, "0");
        strDTL_ITEM_TAX8	 = Utils.IsNull(strDTL_ITEM_TAX8, "0");
        strDTL_ITEM_AMT9	 = Utils.IsNull(strDTL_ITEM_AMT9, "0");
        strDTL_ITEM_TAX9	 = Utils.IsNull(strDTL_ITEM_TAX9, "0");
        strDTL_ITEM_AMT10	 = Utils.IsNull(strDTL_ITEM_AMT10, "0");
        strDTL_ITEM_TAX10	 = Utils.IsNull(strDTL_ITEM_TAX10, "0");
        strDTL_ITEM_AMT11	 = Utils.IsNull(strDTL_ITEM_AMT11, "0");
        strDTL_ITEM_TAX11	 = Utils.IsNull(strDTL_ITEM_TAX11, "0");
        strDTL_ITEM_AMT12	 = Utils.IsNull(strDTL_ITEM_AMT12, "0");
        strDTL_ITEM_TAX12	 = Utils.IsNull(strDTL_ITEM_TAX12, "0");
        strDTL_ITEM_AMT13	 = Utils.IsNull(strDTL_ITEM_AMT13, "0");
        strDTL_ITEM_TAX13	 = Utils.IsNull(strDTL_ITEM_TAX13, "0");
        strDTL_ITEM_AMT14	 = Utils.IsNull(strDTL_ITEM_AMT14, "0");
        strDTL_ITEM_TAX14	 = Utils.IsNull(strDTL_ITEM_TAX14, "0");
        strDTL_ITEM_AMT15	 = Utils.IsNull(strDTL_ITEM_AMT15, "0");
        strDTL_ITEM_TAX15	 = Utils.IsNull(strDTL_ITEM_TAX15, "0");

        try
        {
            lo_objReqTaxBillIns = new ReqTaxBillIns
            {
                ISSU_SEQNO      = lo_strISSU_SEQNO,
                TAX_CHG_FLAG    = "Y",
                ITEM_AMT        = strITEM_AMT.ToDouble() * -1,
                ITEM_TAX        = strITEM_TAX.ToDouble() * -1,
                BUY_DATE        = strBUY_DATE,
                TAX_TYPE        = "0201", //세금계산서 종류(2자리) : 01(세금계산서), 02(수정세금계산서), 03(계산서), 04(수정계산서) / 세금계산서 분류(2자리) : 01(일반), 02(영세율), 03(위수탁), 04(수입), 05(영세율위수탁)
                POPS_CODE       = strPOPS_CODE,
                MODY_CODE       = strMODY_CODE, //01 : 기재사항의 착오·정정, 02: 공급가액 변동, 03: 환입, 04 : 계약의 해제, 05 : 내국신용장 사후 개설, 06 : 이중발급
                NOTE1           = strNOTE1,
                NOTE2           = lo_strNOTE2,
                NOTE3           = lo_strNOTE3,
                SELR_CORP_NO    = strSELR_CORP_NO,
                SELR_CORP_NM    = strSELR_CORP_NM,
                SELR_CEO        = strSELR_CEO,
                SELR_ADDR       = strSELR_ADDR,
                SELR_TEL        = strSELR_TEL,
                SELR_BUSS_CONS  = strSELR_BUSS_CONS,
                SELR_BUSS_TYPE  = strSELR_BUSS_TYPE,
                SELR_CHRG_NM    = strSELR_CHRG_NM,
                SELR_CHRG_EMAIL = strSELR_CHRG_EMAIL,
                SELR_CHRG_MOBL  = strSELR_CHRG_MOBL,
                //BANK_NOTE1      = strBANK_NOTE1,
                BUYR_CORP_NO    = strBUYR_CORP_NO,
                BUYR_CORP_NM    = strBUYR_CORP_NM,
                BUYR_CEO        = strBUYR_CEO,
                BUYR_ADDR       = strBUYR_ADDR,
                BUYR_TEL        = strBUYR_TEL,
                BUYR_BUSS_CONS  = strBUYR_BUSS_CONS,
                BUYR_BUSS_TYPE  = strBUYR_BUSS_TYPE,
                BUYR_CHRG_NM    = strBUYR_CHRG_NM,
                BUYR_CHRG_EMAIL = strBUYR_CHRG_EMAIL,
                BUYR_CHRG_MOBL  = strBUYR_CHRG_MOBL,
                //BROK_CORP_NO    = CommonConstant.TAX_BROK_CORP_NO,
                //BROK_CORP_NM    = CommonConstant.TAX_BROK_CORP_NM,
                //BROK_CEO        = CommonConstant.TAX_BROK_CEO,
                //BROK_ADDR       = CommonConstant.TAX_BROK_ADDR,
                //BROK_TEL        = CommonConstant.TAX_BROK_TEL,
                //BROK_BUSS_CONS  = CommonConstant.TAX_BROK_BUSS_CONS,
                //BROK_BUSS_TYPE  = CommonConstant.TAX_BROK_BUSS_TYPE, 
                //BROK_CHRG_NM    = strBROK_CHRG_NM,
                //BROK_CHRG_EMAIL = strBROK_CHRG_EMAIL,
                //BROK_CHRG_MOBL  = strBROK_CHRG_MOBL,
                BILL_TYPE       = "1",          // 1:매출세금계산서, 2:매입세금계산서
                BFO_ISSU_SEQNO  = strIssuSeqNo,  //수정계산서발행시
                DTL_BUY_DATE1   = strDTL_BUY_DATE1,
                DTL_ITEM_NM1    = strDTL_ITEM_NM1,
                //DTL_ITEM_QUNT1  = strDTL_ITEM_QUNT1,
                //DTL_UNIT_PRCE1  = strDTL_UNIT_PRCE1,
                DTL_ITEM_AMT1   = strDTL_ITEM_AMT1.ToDouble() * -1,
                DTL_ITEM_TAX1   = strDTL_ITEM_TAX1.ToDouble() * -1,
                DTL_ITEM_DESP1  = strDTL_ITEM_DESP1,
                DTL_BUY_DATE2   = strDTL_BUY_DATE2,
                DTL_ITEM_NM2    = strDTL_ITEM_NM2,
                //DTL_ITEM_QUNT2  = strDTL_ITEM_QUNT2,
                //DTL_UNIT_PRCE2  = strDTL_UNIT_PRCE2,
                DTL_ITEM_AMT2   = strDTL_ITEM_AMT2.ToDouble() * -1,
                DTL_ITEM_TAX2   = strDTL_ITEM_TAX2.ToDouble() * -1,
                DTL_ITEM_DESP2  = strDTL_ITEM_DESP2,
                DTL_BUY_DATE3   = strDTL_BUY_DATE3,
                DTL_ITEM_NM3    = strDTL_ITEM_NM3,
                //DTL_ITEM_QUNT3  = strDTL_ITEM_QUNT3,
                //DTL_UNIT_PRCE3  = strDTL_UNIT_PRCE3,
                DTL_ITEM_AMT3   = strDTL_ITEM_AMT3.ToDouble() * -1,
                DTL_ITEM_TAX3   = strDTL_ITEM_TAX3.ToDouble() * -1,
                DTL_ITEM_DESP3  = strDTL_ITEM_DESP3,
                DTL_BUY_DATE4   = strDTL_BUY_DATE4,
                DTL_ITEM_NM4    = strDTL_ITEM_NM4,
                //DTL_ITEM_QUNT4  = strDTL_ITEM_QUNT4,
                //DTL_UNIT_PRCE4  = strDTL_UNIT_PRCE4,
                DTL_ITEM_AMT4   = strDTL_ITEM_AMT4.ToDouble() * -1,
                DTL_ITEM_TAX4   = strDTL_ITEM_TAX4.ToDouble() * -1,
                DTL_ITEM_DESP4  = strDTL_ITEM_DESP4,
                DTL_BUY_DATE5   = strDTL_BUY_DATE5,
                DTL_ITEM_NM5    = strDTL_ITEM_NM5,
                //DTL_ITEM_QUNT5  = strDTL_ITEM_QUNT5,
                //DTL_UNIT_PRCE5  = strDTL_UNIT_PRCE5,
                DTL_ITEM_AMT5   = strDTL_ITEM_AMT5.ToDouble() * -1,
                DTL_ITEM_TAX5   = strDTL_ITEM_TAX5.ToDouble() * -1,
                DTL_ITEM_DESP5  = strDTL_ITEM_DESP5,
                DTL_BUY_DATE6   = strDTL_BUY_DATE6,
                DTL_ITEM_NM6    = strDTL_ITEM_NM6,
                //DTL_ITEM_QUNT6  = strDTL_ITEM_QUNT6,
                //DTL_UNIT_PRCE6  = strDTL_UNIT_PRCE6,
                DTL_ITEM_AMT6   = strDTL_ITEM_AMT6.ToDouble() * -1,
                DTL_ITEM_TAX6   = strDTL_ITEM_TAX6.ToDouble() * -1,
                DTL_ITEM_DESP6  = strDTL_ITEM_DESP6,
                DTL_BUY_DATE7   = strDTL_BUY_DATE7,
                DTL_ITEM_NM7    = strDTL_ITEM_NM7,
                //DTL_ITEM_QUNT7  = strDTL_ITEM_QUNT7,
                //DTL_UNIT_PRCE7  = strDTL_UNIT_PRCE7,
                DTL_ITEM_AMT7   = strDTL_ITEM_AMT7.ToDouble() * -1,
                DTL_ITEM_TAX7   = strDTL_ITEM_TAX7.ToDouble() * -1,
                DTL_ITEM_DESP7  = strDTL_ITEM_DESP7,
                DTL_BUY_DATE8   = strDTL_BUY_DATE8,
                DTL_ITEM_NM8    = strDTL_ITEM_NM8,
                //DTL_ITEM_QUNT8  = strDTL_ITEM_QUNT8,
                //DTL_UNIT_PRCE8  = strDTL_UNIT_PRCE8,
                DTL_ITEM_AMT8   = strDTL_ITEM_AMT8.ToDouble() * -1,
                DTL_ITEM_TAX8   = strDTL_ITEM_TAX8.ToDouble() * -1,
                DTL_ITEM_DESP8  = strDTL_ITEM_DESP8,
                DTL_BUY_DATE9   = strDTL_BUY_DATE9,
                DTL_ITEM_NM9    = strDTL_ITEM_NM9,
                //DTL_ITEM_QUNT9  = strDTL_ITEM_QUNT9,
                //DTL_UNIT_PRCE9  = strDTL_UNIT_PRCE9,
                DTL_ITEM_AMT9   = strDTL_ITEM_AMT9.ToDouble() * -1,
                DTL_ITEM_TAX9   = strDTL_ITEM_TAX9.ToDouble() * -1,
                DTL_ITEM_DESP9  = strDTL_ITEM_DESP9,
                DTL_BUY_DATE10  = strDTL_BUY_DATE10,
                DTL_ITEM_NM10   = strDTL_ITEM_NM10,
                //DTL_ITEM_QUNT10 = strDTL_ITEM_QUNT10,
                //DTL_UNIT_PRCE10 = strDTL_UNIT_PRCE10,
                DTL_ITEM_AMT10  = strDTL_ITEM_AMT10.ToDouble() * -1,
                DTL_ITEM_TAX10  = strDTL_ITEM_TAX10.ToDouble() * -1,
                DTL_ITEM_DESP10 = strDTL_ITEM_DESP10,
                DTL_BUY_DATE11  = strDTL_BUY_DATE11,
                DTL_ITEM_NM11   = strDTL_ITEM_NM11,
                //DTL_ITEM_QUNT11 = strDTL_ITEM_QUNT11,
                //DTL_UNIT_PRCE11 = strDTL_UNIT_PRCE11,
                DTL_ITEM_AMT11  = strDTL_ITEM_AMT11.ToDouble() * -1,
                DTL_ITEM_TAX11  = strDTL_ITEM_TAX11.ToDouble() * -1,
                DTL_ITEM_DESP11 = strDTL_ITEM_DESP11,
                DTL_BUY_DATE12  = strDTL_BUY_DATE12,
                DTL_ITEM_NM12   = strDTL_ITEM_NM12,
                //DTL_ITEM_QUNT12 = strDTL_ITEM_QUNT12,
                //DTL_UNIT_PRCE12 = strDTL_UNIT_PRCE12,
                DTL_ITEM_AMT12  = strDTL_ITEM_AMT12.ToDouble() * -1,
                DTL_ITEM_TAX12  = strDTL_ITEM_TAX12.ToDouble() * -1,
                DTL_ITEM_DESP12 = strDTL_ITEM_DESP12,
                DTL_BUY_DATE13  = strDTL_BUY_DATE13,
                DTL_ITEM_NM13   = strDTL_ITEM_NM13,
                //DTL_ITEM_QUNT13 = strDTL_ITEM_QUNT13,
                //DTL_UNIT_PRCE13 = strDTL_UNIT_PRCE13,
                DTL_ITEM_AMT13  = strDTL_ITEM_AMT13.ToDouble() * -1,
                DTL_ITEM_TAX13  = strDTL_ITEM_TAX13.ToDouble() * -1,
                DTL_ITEM_DESP13 = strDTL_ITEM_DESP13,
                DTL_BUY_DATE14  = strDTL_BUY_DATE14,
                DTL_ITEM_NM14   = strDTL_ITEM_NM14,
                //DTL_ITEM_QUNT14 = strDTL_ITEM_QUNT14,
                //DTL_UNIT_PRCE14 = strDTL_UNIT_PRCE14,
                DTL_ITEM_AMT14  = strDTL_ITEM_AMT14.ToDouble() * -1,
                DTL_ITEM_TAX14  = strDTL_ITEM_TAX14.ToDouble() * -1,
                DTL_ITEM_DESP14 = strDTL_ITEM_DESP14,
                DTL_BUY_DATE15  = strDTL_BUY_DATE15,
                DTL_ITEM_NM15   = strDTL_ITEM_NM15,
                //DTL_ITEM_QUNT15 = strDTL_ITEM_QUNT15,
                //DTL_UNIT_PRCE15 = strDTL_UNIT_PRCE15,
                DTL_ITEM_AMT15  = strDTL_ITEM_AMT15.ToDouble() * -1,
                DTL_ITEM_TAX15  = strDTL_ITEM_TAX15.ToDouble() * -1,
                DTL_ITEM_DESP15 = strDTL_ITEM_DESP15
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

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출 계산서 발행 취소
    /// </summary>
    protected void SetSaleTaxBillCnl()
    {
        ServiceResult<bool>       lo_objCnlTaxBill                = null;
        ReqSaleClosingBillInfoUpd lo_objReqSaleClosingBillInfoUpd = null;
        ServiceResult<bool>       lo_objResSaleClosingBillInfoUpd = null;

        if (string.IsNullOrWhiteSpace(strIssuSeqNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNo))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objCnlTaxBill  = objTaxDasServices.SetTaxBillCnl(strIssuSeqNo);
            objResMap.RetCode = lo_objCnlTaxBill.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = lo_objCnlTaxBill.result.ErrorMsg;
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqSaleClosingBillInfoUpd = new ReqSaleClosingBillInfoUpd
            {
                CenterCode        = strCenterCode.ToInt(),
                SaleClosingSeqNos = strSaleClosingSeqNo,
                BillStatus        = 1,
                BillKind          = 99,
                BillChargeName    = string.Empty,
                BillChargeTelNo   = string.Empty,
                BillChargeEmail   = string.Empty,
                BillWrite         = string.Empty,
                BillYMD           = string.Empty,
                NtsConfirmNum     = string.Empty,
                BillAdminID       = objSes.AdminID,
                BillAdminName     = objSes.AdminName
            };

            lo_objResSaleClosingBillInfoUpd = objSaleDasServices.SetSaleClosingBillInfoUpd(lo_objReqSaleClosingBillInfoUpd);
            objResMap.RetCode           = lo_objResSaleClosingBillInfoUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResSaleClosingBillInfoUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("SaleClosingTaxBillHandler", "Exception",
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