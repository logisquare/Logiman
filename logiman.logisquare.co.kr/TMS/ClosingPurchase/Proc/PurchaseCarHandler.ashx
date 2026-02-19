<%@ WebHandler Language="C#" Class="PurchaseCarHandler" %>
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
/// FileName        : PurchaseCarHandler.ashx
/// Description     : 매입마감 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-06
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class PurchaseCarHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingPurchase/PurchaseCarList"; //필수

    // 메소드 리스트
    private const string MethodPurchaseCarCompanyList         = "PurchaseCarCompanyList";         //매입 거래처 목록
    private const string MethodPurchaseCarCompanyListExcel    = "PurchaseCarCompanyListExcel";    //매입 거래처 엑셀
    private const string MethodPurchaseCarCompanyPayList      = "PurchaseCarCompanyPayList";      //매입 비용 목록
    private const string MethodPurchaseCarCompanyPayListExcel = "PurchaseCarCompanyPayListExcel"; //매입 비용 엑셀
    private const string MethodPurchaseCarCompanyInsureCheck  = "PurchaseCarCompanyInsureCheck";  //매입 마감 보험료 체크
    private const string MethodPurchaseClosingIns             = "PurchaseClosingInsert";          //매입 마감
    private const string MethodPurchaseClosingCnl             = "PurchaseClosingCancel";          //매입 마감 취소
    private const string MethodChkAcctNo                      = "ChkAcctNo";                      //계좌번호 체크
    private const string MethodCarComAcctUpd                  = "CarComAcctUpdate";               //계좌번호 수정
    private const string MethodHometaxList                    = "HometaxList";                    //계산서 목록

    PurchaseDasServices    objPurchaseDasServices    = new PurchaseDasServices();
    CargopayDasServices    objCargopayDasServices    = new CargopayDasServices();
    CarDispatchDasServices objCarDispatchDasServices = new CarDispatchDasServices();
    private HttpContext    objHttpContext            = null;

    private string strCallType              = string.Empty;
    private int    intPageSize              = 0;
    private int    intPageNo                = 0;
    private string strCenterCode            = string.Empty;
    private string strDateType              = string.Empty;
    private string strDateFrom              = string.Empty;
    private string strDateTo                = string.Empty;
    private string strTaxWriteDateTo        = string.Empty;
    private string strOrderLocationCodes    = string.Empty;
    private string strDeliveryLocationCodes = string.Empty;
    private string strOrderItemCodes        = string.Empty;
    private string strCarNo                 = string.Empty;
    private string strDriverName            = string.Empty;
    private string strDriverCell            = string.Empty;
    private string strComCode               = string.Empty;
    private string strComName               = string.Empty;
    private string strComCorpNo             = string.Empty;
    private string strCarDivType            = string.Empty;
    private string strCooperatorFlag        = string.Empty;
    private string strClosingFlag           = string.Empty;
    private string strPurchaseOrgAmt        = string.Empty;
    private string strEncAcctNo             = string.Empty;
    private string strAcctNo                = string.Empty;
    private string strBankCode              = string.Empty;
    private string strAcctName              = string.Empty;
    private string strAcctValidFlag         = string.Empty;
    private string strDispatchSeqNos1       = string.Empty;
    private string strDispatchSeqNos2       = string.Empty;
    private string strDispatchSeqNos3       = string.Empty;
    private string strDispatchSeqNos4       = string.Empty;
    private string strDispatchSeqNos5       = string.Empty;
    private string strDispatchSeqNos6       = string.Empty;
    private string strDispatchSeqNos7       = string.Empty;
    private string strDispatchSeqNos8       = string.Empty;
    private string strBillKind              = string.Empty;
    private string strBillWrite             = string.Empty;
    private string strBillYMD               = string.Empty;
    private string strBillDate              = string.Empty;
    private string strIssueTaxAmt           = string.Empty;
    private string strDeductAmt             = string.Empty;
    private string strDeductReason          = string.Empty;
    private string strNtsConfirmNum         = string.Empty;
    private string strNote                  = string.Empty;
    private string strPurchaseClosingSeqNo  = string.Empty;
    private string strPreMatchingFlag       = string.Empty;
    private string strMyOrderFlag           = string.Empty;
    private string strInsureFlag            = string.Empty;
    private string strInsureYMD             = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPurchaseCarCompanyList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseCarCompanyListExcel,    MenuAuthType.All);
        objMethodAuthList.Add(MethodPurchaseCarCompanyPayList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseCarCompanyPayListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodPurchaseCarCompanyInsureCheck,  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseClosingIns,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPurchaseClosingCnl,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodChkAcctNo,                      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarComAcctUpd,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodHometaxList,                    MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("PurchaseCarHandler");
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
            strCenterCode            = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateType              = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom              = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                = SiteGlobal.GetRequestForm("DateTo");
            strTaxWriteDateTo        = SiteGlobal.GetRequestForm("TaxWriteDateTo");
            strOrderLocationCodes    = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strDeliveryLocationCodes = SiteGlobal.GetRequestForm("DeliveryLocationCodes");
            strOrderItemCodes        = SiteGlobal.GetRequestForm("OrderItemCodes");
            strCarNo                 = SiteGlobal.GetRequestForm("CarNo");
            strDriverName            = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell            = SiteGlobal.GetRequestForm("DriverCell");
            strComCode               = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"), "0");
            strComName               = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo             = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarDivType            = Utils.IsNull(SiteGlobal.GetRequestForm("CarDivType"), "0");
            strCooperatorFlag        = SiteGlobal.GetRequestForm("CooperatorFlag");
            strClosingFlag           = SiteGlobal.GetRequestForm("ClosingFlag");
            strPurchaseOrgAmt        = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseOrgAmt"), "0");
            strAcctName              = Utils.IsNull(SiteGlobal.GetRequestForm("AcctName"),       string.Empty);
            strAcctNo                = Utils.IsNull(SiteGlobal.GetRequestForm("AcctNo"),         string.Empty);
            strEncAcctNo             = Utils.IsNull(SiteGlobal.GetRequestForm("EncAcctNo"),      string.Empty);
            strBankCode              = Utils.IsNull(SiteGlobal.GetRequestForm("BankCode"),       string.Empty);
            strAcctValidFlag         = Utils.IsNull(SiteGlobal.GetRequestForm("AcctValidFlag"),  string.Empty);
            strDispatchSeqNos1       = SiteGlobal.GetRequestForm("DispatchSeqNos1");
            strDispatchSeqNos2       = SiteGlobal.GetRequestForm("DispatchSeqNos2");
            strDispatchSeqNos3       = SiteGlobal.GetRequestForm("DispatchSeqNos3");
            strDispatchSeqNos4       = SiteGlobal.GetRequestForm("DispatchSeqNos4");
            strDispatchSeqNos5       = SiteGlobal.GetRequestForm("DispatchSeqNos5");
            strDispatchSeqNos6       = SiteGlobal.GetRequestForm("DispatchSeqNos6");
            strDispatchSeqNos7       = SiteGlobal.GetRequestForm("DispatchSeqNos7");
            strDispatchSeqNos8       = SiteGlobal.GetRequestForm("DispatchSeqNos8");
            strBillKind              = Utils.IsNull(SiteGlobal.GetRequestForm("BillKind"), "0");
            strBillWrite             = SiteGlobal.GetRequestForm("BillWrite");
            strBillYMD               = SiteGlobal.GetRequestForm("BillYMD");
            strBillDate              = SiteGlobal.GetRequestForm("BillDate");
            strIssueTaxAmt           = Utils.IsNull(SiteGlobal.GetRequestForm("IssueTaxAmt"), "0");
            strDeductAmt             = Utils.IsNull(SiteGlobal.GetRequestForm("DeductAmt"),   "0");
            strDeductReason          = SiteGlobal.GetRequestForm("DeductReason");
            strNtsConfirmNum         = SiteGlobal.GetRequestForm("NtsConfirmNum");
            strNote                  = SiteGlobal.GetRequestForm("Note");
            strPurchaseClosingSeqNo  = SiteGlobal.GetRequestForm("PurchaseClosingSeqNo");
            strPreMatchingFlag       = SiteGlobal.GetRequestForm("PreMatchingFlag");
            strMyOrderFlag           = SiteGlobal.GetRequestForm("MyOrderFlag");
            strInsureFlag            = Utils.IsNull(SiteGlobal.GetRequestForm("InsureFlag"), "Y");
            strInsureYMD             = SiteGlobal.GetRequestForm("InsureYMD");

            strDateFrom  = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo    = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
            strTaxWriteDateTo    = string.IsNullOrWhiteSpace(strTaxWriteDateTo) ? strTaxWriteDateTo : strTaxWriteDateTo.Replace("-", "");
            strBillWrite = string.IsNullOrWhiteSpace(strBillWrite) ? strBillWrite : strBillWrite.Replace("-", "");
            strBillYMD   = string.IsNullOrWhiteSpace(strBillYMD) ? strBillYMD : strBillYMD.Replace("-", "");
            strBillDate  = string.IsNullOrWhiteSpace(strBillDate) ? strBillDate : strBillDate.Replace("-", "");
            strInsureYMD  = string.IsNullOrWhiteSpace(strInsureYMD) ? strInsureYMD : strInsureYMD.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
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
                case MethodPurchaseCarCompanyList:
                    GetPurchaseCarCompanyList();
                    break;;
                case MethodPurchaseCarCompanyListExcel:
                    GetPurchaseCarCompanyListExcel();
                    break;
                case MethodPurchaseCarCompanyPayList:
                    GetPurchaseCarCompanyPayList();
                    break;
                case MethodPurchaseCarCompanyPayListExcel:
                    GetPurchaseCarCompanyPayListExcel();
                    break;
                case MethodPurchaseCarCompanyInsureCheck:
                    GetPurchaseCarCompanyInsureCheck();
                    break;
                case MethodPurchaseClosingIns:
                    SetPurchaseClosingIns();
                    break;
                case MethodPurchaseClosingCnl:
                    SetPurchaseClosingCnl();
                    break;
                case MethodChkAcctNo:
                    GetAcctRealName();
                    break;
                case MethodCarComAcctUpd:
                    SetCarCompanyAcctUpd();
                    break;
                case MethodHometaxList:
                    GetHometaxList();
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

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매입 거래처 목록
    /// </summary>
    protected void GetPurchaseCarCompanyList()
    {
        ReqPurchaseCarCompanyList                lo_objReqPurchaseCarCompanyList = null;
        ServiceResult<ResPurchaseCarCompanyList> lo_objResPurchaseCarCompanyList = null;
        ServiceResult<ResNoMatchTaxList>         lo_objResNoMatchTaxList         = null;
        DataTable                                lo_dtTax                        = new DataTable();
        System.Text.StringBuilder                lo_sb                           = new System.Text.StringBuilder();
        string[]                                 lo_arrDataText                  = null;
        string                                   lo_strTrData                    = string.Empty;
        DateTime                                 lo_dtTaxWriteDateTo;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseCarCompanyList = new ReqPurchaseCarCompanyList
            {
                CenterCode            = strCenterCode.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                CarNo                 = strCarNo,
                DriverName            = strDriverName,
                DriverCell            = strDriverCell,
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                CarDivType            = strCarDivType.ToInt(),
                CooperatorFlag        = strCooperatorFlag,
                ClosingFlag           = strClosingFlag,
                MyOrderFlag           = strMyOrderFlag,
                AdminID               = objSes.AdminID,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResPurchaseCarCompanyList = objPurchaseDasServices.GetPurchaseCarCompanyList(lo_objReqPurchaseCarCompanyList);

            if (lo_objResPurchaseCarCompanyList.data.RecordCnt > 0)
            {
                //=======================================================================================================================================
                // 검색 운송사의 카고페이 홈텍스 계산서 최근 2개월 발행 목록에서 사전 매칭이 되어 있지 않은 계산서를 발행 사업자별, 계산서 수를 조회한다
                //=======================================================================================================================================
                lo_dtTaxWriteDateTo = DateTime.ParseExact(strTaxWriteDateTo, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);

                lo_objResNoMatchTaxList = objCargopayDasServices.GetApproveHometaxAPICntGet(strCenterCode.ToInt(), lo_dtTaxWriteDateTo.AddMonths(-2).ToString("yyyyMMdd"), lo_dtTaxWriteDateTo.ToString("yyyyMMdd"));

                if (lo_objResNoMatchTaxList.data.RECORD_CNT > 0)
                {
                    foreach (PurchaseCarCompanyGridModel lo_objPurchaseCarCompany in lo_objResPurchaseCarCompanyList.data.list)
                    {
                        lo_dtTax.Clear();
                        lo_sb.Clear();
                        lo_strTrData = string.Empty;

                        if (lo_objResNoMatchTaxList.data.list.ContainsKey(lo_objPurchaseCarCompany.ComCorpNo))
                        {
                            SiteGlobal.ConvertXmlDataToDataTable(lo_objResNoMatchTaxList.data.list[lo_objPurchaseCarCompany.ComCorpNo].ToString(), ref lo_dtTax);
                            lo_objPurchaseCarCompany.NoMatchTaxCnt = lo_dtTax.Rows.Count;
                            lo_sb.Append("<table><tbody>");

                            for (int lo_intCnt = 1; lo_intCnt <= lo_dtTax.Rows.Count; lo_intCnt++)
                            {
                                lo_arrDataText = lo_dtTax.Rows[lo_intCnt - 1][0].ToString().Split(',');

                                lo_strTrData += $"<td style='font-size:11px;color:{(lo_arrDataText[1].ToInt() > 0 ? "black" : "red")};padding:2px;text-align:right;'>작성일:{DateTime.ParseExact(lo_arrDataText[0], "yyyyMMdd", null):yyyy-MM-dd}</td>" +
                                                $"<td style='color:{(lo_arrDataText[1].ToInt() > 0 ? "black" : "red")};font-size:11px;padding:2px; {(lo_intCnt % 2 != 0  && lo_dtTax.Rows.Count > 1 ? "border-right:1px solid #aaa" : string.Empty)};text-align:right;'>공급가액:{StringExtensions.ConvertMoneyFormat(lo_arrDataText[1])}원</td>";

                                if (lo_intCnt % 2 == 0)
                                {
                                    lo_sb.Append($"<tr>{lo_strTrData}</tr>");
                                    lo_strTrData = string.Empty;
                                }
                            }

                            if (!string.IsNullOrWhiteSpace(lo_strTrData))
                            {
                                lo_sb.Append($"<tr>{lo_strTrData}</tr>");
                                lo_strTrData = string.Empty;
                            }

                            lo_sb.Append("</tbody></table>");
                            lo_objPurchaseCarCompany.NoMatchTaxInfo = lo_sb.ToString();
                        }
                        else
                        {
                            lo_objPurchaseCarCompany.NoMatchTaxCnt  = 0;
                            lo_objPurchaseCarCompany.NoMatchTaxInfo = string.Empty;
                        }
                    }
                }
            }

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseCarCompanyList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 거래처 엑셀
    /// </summary>
    protected void GetPurchaseCarCompanyListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqPurchaseCarCompanyList                lo_objReqPurchaseCarCompanyList = null;
        ServiceResult<ResPurchaseCarCompanyList> lo_objResPurchaseCarCompanyList = null;
        ServiceResult<ResNoMatchTaxList>         lo_objResNoMatchTaxList         = null;
        string                                   lo_strFileName                  = "";
        SpreadSheet                              lo_objExcel                     = null;
        DataTable                                lo_dtData                       = null;
        MemoryStream                             lo_outputStream                 = null;
        byte[]                                   lo_Content                      = null;
        int                                      lo_intColumnIndex               = 0;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseCarCompanyList = new ReqPurchaseCarCompanyList
            {
                CenterCode            = strCenterCode.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                CarNo                 = strCarNo,
                DriverName            = strDriverName,
                DriverCell            = strDriverCell,
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                CarDivType            = strCarDivType.ToInt(),
                CooperatorFlag        = strCooperatorFlag,
                ClosingFlag           = strClosingFlag,
                MyOrderFlag           = strMyOrderFlag,
                AdminID               = objSes.AdminID,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResPurchaseCarCompanyList = objPurchaseDasServices.GetPurchaseCarCompanyList(lo_objReqPurchaseCarCompanyList);
            if (lo_objResPurchaseCarCompanyList.data.RecordCnt > 0)
            {
                DataTable dtTax = new DataTable();

                //=======================================================================================================================================
                // 검색 운송사의 카고페이 홈텍스 계산서 최근 2개월 발행 목록에서 사전 매칭이 되어 있지 않은 계산서를 발행 사업자별, 계산서 수를 조회한다
                //=======================================================================================================================================
                lo_objResNoMatchTaxList = objCargopayDasServices.GetApproveHometaxAPICntGet(strCenterCode.ToInt(), DateTime.Now.AddMonths(-2).ToString("yyyyMMdd"), DateTime.Now.ToString("yyyyMMdd"));
                for (int nLoop = 0; nLoop < lo_objResPurchaseCarCompanyList.data.RecordCnt; nLoop++)
                {
                    dtTax.Clear();

                    if (lo_objResNoMatchTaxList.data.list.ContainsKey(lo_objResPurchaseCarCompanyList.data.list[nLoop].ComCorpNo))
                    {
                        SiteGlobal.ConvertXmlDataToDataTable(lo_objResNoMatchTaxList.data.list[lo_objResPurchaseCarCompanyList.data.list[nLoop].ComCorpNo].ToString(), ref dtTax);
                        lo_objResPurchaseCarCompanyList.data.list[nLoop].NoMatchTaxCnt = dtTax.Rows.Count;
                    }
                    else
                    {
                        lo_objResPurchaseCarCompanyList.data.list[nLoop].NoMatchTaxCnt = 0;
                    }
                }
            }

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("법인여부",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("미매칭계산서",  typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("매입합계",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",     typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("비용건수",    typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("마감비용건수",  typeof(int)));

            lo_dtData.Columns.Add(new DataColumn("사업자상태",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("결제일",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("과세구분",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("협력업체여부",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("은행명",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계좌번호(끝4자리)", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("예금주",        typeof(string)));


            foreach (var row in lo_objResPurchaseCarCompanyList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.ComName,row.ComCorpNo,row.ComKindM,row.NoMatchTaxCnt
                    ,row.PurchaseOrgAmt,row.PurchaseSupplyAmt,row.PurchaseTaxAmt,row.PurchaseCnt,row.ClosingPurchaseCnt
                    ,row.ComStatusM,row.PayDay,row.ComTaxKindM,row.CooperatorFlag,row.BankName
                    ,row.SearchAcctNo,row.AcctName);
            }


            lo_objExcel = new SpreadSheet {SheetName = "PurchaseCarCompanyList"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetFontSize(10, 18);
            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);
            lo_Content = lo_outputStream.ToArray();

            lo_strFileName = $"{lo_objExcel.SheetName}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + lo_strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 비용 목록
    /// </summary>
    protected void GetPurchaseCarCompanyPayList()
    {
        ReqPurchaseCarCompanyPayList                lo_objReqPurchaseCarCompanyPayList = null;
        ServiceResult<ResPurchaseCarCompanyPayList> lo_objResPurchaseCarCompanyPayList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseCarCompanyPayList = new ReqPurchaseCarCompanyPayList
            {
                CenterCode            = strCenterCode.ToInt(),
                ComCode               = strComCode.ToInt64(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                CarNo                 = strCarNo,
                DriverName            = strDriverName,
                DriverCell            = strDriverCell,
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                CarDivType            = strCarDivType.ToInt(),
                CooperatorFlag        = strCooperatorFlag,
                ClosingFlag           = strClosingFlag,
                MyOrderFlag           = strMyOrderFlag,
                AdminID               = objSes.AdminID,
                AccessCenterCode      = objSes.AccessCenterCode
            };

            lo_objResPurchaseCarCompanyPayList = objPurchaseDasServices.GetPurchaseCarCompanyPayList(lo_objReqPurchaseCarCompanyPayList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseCarCompanyPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 비용 엑셀
    /// </summary>
    protected void GetPurchaseCarCompanyPayListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqPurchaseCarCompanyPayList                lo_objReqPurchaseCarCompanyPayList = null;
        ServiceResult<ResPurchaseCarCompanyPayList> lo_objResPurchaseCarCompanyPayList = null;
        string                                      lo_strFileName                     = "";
        SpreadSheet                                 lo_objExcel                        = null;
        DataTable                                   lo_dtData                          = null;
        MemoryStream                                lo_outputStream                    = null;
        byte[]                                      lo_Content                         = null;
        int                                         lo_intColumnIndex                  = 0;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseCarCompanyPayList = new ReqPurchaseCarCompanyPayList
            {
                CenterCode            = strCenterCode.ToInt(),
                ComCode               = strComCode.ToInt64(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                CarNo                 = strCarNo,
                DriverName            = strDriverName,
                DriverCell            = strDriverCell,
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                CarDivType            = strCarDivType.ToInt(),
                CooperatorFlag        = strCooperatorFlag,
                ClosingFlag           = strClosingFlag,
                MyOrderFlag           = strMyOrderFlag,
                AdminID               = objSes.AdminID,
                AccessCenterCode      = objSes.AccessCenterCode
            };

            lo_objResPurchaseCarCompanyPayList = objPurchaseDasServices.GetPurchaseCarCompanyPayList(lo_objReqPurchaseCarCompanyPayList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감여부",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서발행상태", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전표번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감자",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("배송사업장",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("발주처명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총수량",     typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총부피",     typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총중량",     typeof(double)));

            lo_dtData.Columns.Add(new DataColumn("총길이",     typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("매입합계",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",     typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("산재보험대상",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("산재보험신고",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사휴대폰",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("국세청승인번호", typeof(string)));

            foreach (var row in lo_objResPurchaseCarCompanyPayList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.OrderNo,row.ClosingFlag,row.BillStatusM,row.PurchaseClosingSeqNo
                     ,row.ClosingAdminName,row.ClosingDate,row.OrderItemCodeM,row.OrderLocationCodeM,row.DeliveryLocationCodeM
                     ,row.OrderClientName,row.PayClientName,row.ConsignorName,row.PickupYMD,row.PickupPlace
                     ,row.GetYMD,row.GetPlace,row.Volume,row.CBM,row.Weight
                     ,row.Length,row.PurchaseOrgAmt,row.PurchaseSupplyAmt,row.PurchaseTaxAmt,row.InsureTargetFlag
                     ,row.InsureExceptKind,row.CarDivTypeM,row.CarNo,row.DriverName,row.DriverCell
                     ,row.NtsConfirmNum);
            }

            lo_objExcel = new SpreadSheet {SheetName = "PurchaseCarCompanyPayList"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetFontSize(10, 18);
            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);
            lo_Content = lo_outputStream.ToArray();

            lo_strFileName = $"{lo_objExcel.SheetName}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + lo_strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감 보험료 체크
    /// </summary>
    protected void GetPurchaseCarCompanyInsureCheck()
    {
        ReqPurchaseCarCompanyInsureCheck                lo_objReqPurchaseCarCompanyInsureCheck = null;
        ServiceResult<ResPurchaseCarCompanyInsureCheck> lo_objResPurchaseCarCompanyInsureCheck = null;

        
        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDispatchSeqNos1) && string.IsNullOrWhiteSpace(strDispatchSeqNos2) && string.IsNullOrWhiteSpace(strDispatchSeqNos3) && string.IsNullOrWhiteSpace(strDispatchSeqNos4) && string.IsNullOrWhiteSpace(strDispatchSeqNos5) && string.IsNullOrWhiteSpace(strDispatchSeqNos6) && string.IsNullOrWhiteSpace(strDispatchSeqNos7) && string.IsNullOrWhiteSpace(strDispatchSeqNos8))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strInsureYMD))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseCarCompanyInsureCheck = new ReqPurchaseCarCompanyInsureCheck
            {
                CenterCode      = strCenterCode.ToInt(),
                ComCode         = strComCode.ToInt64(),
                InsureYMD       = strInsureYMD,
                DispatchSeqNos1 = strDispatchSeqNos1,
                DispatchSeqNos2 = strDispatchSeqNos2,
                DispatchSeqNos3 = strDispatchSeqNos3,
                DispatchSeqNos4 = strDispatchSeqNos4,
                DispatchSeqNos5 = strDispatchSeqNos5,
                DispatchSeqNos6 = strDispatchSeqNos6,
                DispatchSeqNos7 = strDispatchSeqNos7,
                DispatchSeqNos8 = strDispatchSeqNos8,
                AdminID         = objSes.AdminID
            };

            lo_objResPurchaseCarCompanyInsureCheck = objPurchaseDasServices.GetPurchaseCarCompanyInsureCheck(lo_objReqPurchaseCarCompanyInsureCheck);
                
            objResMap.RetCode = lo_objResPurchaseCarCompanyInsureCheck.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseCarCompanyInsureCheck.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("ApplyFlag",       lo_objResPurchaseCarCompanyInsureCheck.data.ApplyFlag);
            objResMap.Add("SupplyAmt",       lo_objResPurchaseCarCompanyInsureCheck.data.SupplyAmt);
            objResMap.Add("TransAmt",        lo_objResPurchaseCarCompanyInsureCheck.data.TransAmt);
            objResMap.Add("TransCost",       lo_objResPurchaseCarCompanyInsureCheck.data.TransCost);
            objResMap.Add("InsureRateAmt",   lo_objResPurchaseCarCompanyInsureCheck.data.InsureRateAmt);
            objResMap.Add("InsureReduceAmt", lo_objResPurchaseCarCompanyInsureCheck.data.InsureReduceAmt);
            objResMap.Add("InsurePayAmt",    lo_objResPurchaseCarCompanyInsureCheck.data.InsurePayAmt);
            objResMap.Add("CenterInsureAmt", lo_objResPurchaseCarCompanyInsureCheck.data.CenterInsureAmt);
            objResMap.Add("DriverInsureAmt", lo_objResPurchaseCarCompanyInsureCheck.data.DriverInsureAmt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감
    /// </summary>
    protected void SetPurchaseClosingIns()
    {
        ReqPurchaseClosingCarIns                lo_objReqPurchaseClosingCarIns = null;
        ServiceResult<ResPurchaseClosingCarIns> lo_objResPurchaseClosingCarIns = null;
        ReqPreMatchingIns                       lo_objReqPreMatchingIns        = null;
        ServiceResult<bool>                     lo_objResPreMatchingIns        = null;
        ReqPurchaseClosingCnl                   lo_objReqPurchaseClosingCnl    = null;
        ServiceResult<bool>                     lo_objResPurchaseClosingCnl    = null;
        int                                     lo_intBillStatus               = 1;
        string                                  strPurchaseClosingSeqNo        = string.Empty;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDispatchSeqNos1) && string.IsNullOrWhiteSpace(strDispatchSeqNos2) && string.IsNullOrWhiteSpace(strDispatchSeqNos3) && string.IsNullOrWhiteSpace(strDispatchSeqNos4) && string.IsNullOrWhiteSpace(strDispatchSeqNos5) && string.IsNullOrWhiteSpace(strDispatchSeqNos6) && string.IsNullOrWhiteSpace(strDispatchSeqNos7) && string.IsNullOrWhiteSpace(strDispatchSeqNos8))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strNtsConfirmNum) && string.IsNullOrWhiteSpace(strBillWrite))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (!string.IsNullOrWhiteSpace(strNtsConfirmNum))
        {
            if (string.IsNullOrWhiteSpace(strBillKind) || strBillKind.Equals("0"))
            {
                objResMap.RetCode = 9005;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            lo_intBillStatus = 3;
        }
        else
        {
            strBillKind = "99";
        }

        try
        {
            lo_objReqPurchaseClosingCarIns = new ReqPurchaseClosingCarIns
            {
                CenterCode       = strCenterCode.ToInt(),
                DispatchSeqNos1  = strDispatchSeqNos1,
                DispatchSeqNos2  = strDispatchSeqNos2,
                DispatchSeqNos3  = strDispatchSeqNos3,
                DispatchSeqNos4  = strDispatchSeqNos4,
                DispatchSeqNos5  = strDispatchSeqNos5,
                DispatchSeqNos6  = strDispatchSeqNos6,
                DispatchSeqNos7  = strDispatchSeqNos7,
                DispatchSeqNos8  = strDispatchSeqNos8,
                BillStatus       = lo_intBillStatus,
                BillKind         = strBillKind.ToInt(),
                BillWrite        = strBillWrite,
                BillYMD          = strBillYMD,
                BillDate         = strBillDate,
                NtsConfirmNum    = strNtsConfirmNum,
                PurchaseOrgAmt   = strPurchaseOrgAmt.ToDouble(),
                DeductAmt        = strDeductAmt.ToDouble(),
                DeductReason     = strDeductReason,
                IssueTaxAmt      = strIssueTaxAmt.ToDouble(),
                InsureFlag       = strInsureFlag,
                Note             = strNote,
                ClosingAdminID   = objSes.AdminID,
                ClosingAdminName = objSes.AdminName
            };

            lo_objResPurchaseClosingCarIns = objPurchaseDasServices.SetPurchaseClosingCarIns(lo_objReqPurchaseClosingCarIns);
            objResMap.RetCode           = lo_objResPurchaseClosingCarIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseClosingCarIns.result.ErrorMsg;
                return;
            }

            strPurchaseClosingSeqNo = lo_objResPurchaseClosingCarIns.data.PurchaseClosingSeqNo.ToString();
            objResMap.Add("PurchaseClosingSeqNo", lo_objResPurchaseClosingCarIns.data.PurchaseClosingSeqNo.ToString());
            objResMap.Add("PurchaseOrgAmt",       lo_objResPurchaseClosingCarIns.data.PurchaseOrgAmt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        //프리매칭
        if (!string.IsNullOrWhiteSpace(strNtsConfirmNum))
        {
            //매칭처리
            try
            {
                lo_objReqPreMatchingIns = new ReqPreMatchingIns
                {
                    CENTER_CODE     = strCenterCode.ToInt(),
                    CLOSING_SEQ_NO  = strPurchaseClosingSeqNo,
                    NTS_CONFIRM_NUM = strNtsConfirmNum
                };

                lo_objResPreMatchingIns = objCargopayDasServices.SetPreMatchingIns(lo_objReqPreMatchingIns);
                objResMap.RetCode       = lo_objResPreMatchingIns.result.ErrorCode;

                if (objResMap.RetCode.IsSuccess())
                {
                    return;
                }
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }

            //매칭 처리 실패 마감 취소 처리
            try
            {
                lo_objReqPurchaseClosingCnl = new ReqPurchaseClosingCnl
                {
                    CenterCode            = strCenterCode.ToInt(),
                    PurchaseClosingSeqNos = strPurchaseClosingSeqNo,
                    ChkPermFlag           = "Y",
                    CnlAdminID            = objSes.AdminID,
                    CnlAdminName          = objSes.AdminName
                };

                lo_objResPurchaseClosingCnl = objPurchaseDasServices.SetPurchaseClosingCnl(lo_objReqPurchaseClosingCnl);
                objResMap.RetCode           = lo_objResPurchaseClosingCnl.result.ErrorCode;

                if (objResMap.RetCode.IsSuccess())
                {
                    objResMap.RetCode = 8888;
                    objResMap.ErrMsg  = "계산서 매칭에 실패하여 마감이 취소되었습니다.";
                    objResMap.Remove("PurchaseClosingSeqNo");
                    objResMap.Remove("PurchaseOrgAmt");
                }
                else
                {
                    objResMap.ErrMsg = "계산서 매칭에 실패하여 마감 취소를 진행하였으나, 오류가 발생했습니다.(전표번호: "+strPurchaseClosingSeqNo+")";
                }
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }
        }
    }

    /// <summary>
    /// 매입 마감 취소
    /// </summary>
    protected void SetPurchaseClosingCnl()
    {
        ReqPreMatchingDel     lo_objReqPreMatchingDel     = null;
        ServiceResult<bool>   lo_objResPreMatchingDel     = null;
        ReqPurchaseClosingCnl lo_objReqPurchaseClosingCnl = null;
        ServiceResult<bool>   lo_objResPurchaseClosingCnl = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (!string.IsNullOrWhiteSpace(strNtsConfirmNum))
        {
            try
            {
                lo_objReqPreMatchingDel = new ReqPreMatchingDel
                {
                    CENTER_CODE    = strCenterCode.ToInt(),
                    CLOSING_SEQ_NO = strPurchaseClosingSeqNo
                };

                lo_objResPreMatchingDel = objCargopayDasServices.SetPreMatchingDel(lo_objReqPreMatchingDel);
                objResMap.RetCode       = lo_objResPreMatchingDel.result.ErrorCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg  = "계산서 매칭 삭제에 실패했습니다.";
                    return;
                }
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }
        }

        try
        {
            lo_objReqPurchaseClosingCnl = new ReqPurchaseClosingCnl
            {
                CenterCode            = strCenterCode.ToInt(),
                PurchaseClosingSeqNos = strPurchaseClosingSeqNo,
                ChkPermFlag           = "Y",
                CnlAdminID            = objSes.AdminID,
                CnlAdminName          = objSes.AdminName
            };

            lo_objResPurchaseClosingCnl = objPurchaseDasServices.SetPurchaseClosingCnl(lo_objReqPurchaseClosingCnl);
            objResMap.RetCode           = lo_objResPurchaseClosingCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseClosingCnl.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 예금주명 조회
    /// </summary>
    protected void GetAcctRealName()
    {
        ReqGetAcctRealName lo_objReqGetAcctRealName = null;
        ResGetAcctRealName lo_objResGetAcctRealName = null;

        if (string.IsNullOrWhiteSpace(strAcctNo) || string.IsNullOrWhiteSpace(strBankCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        strEncAcctNo = Utils.GetEncrypt(strAcctNo, SiteGlobal.AES2_ENC_IV_VALUE);

        //얘금주명 조회
        try
        {
            lo_objReqGetAcctRealName = new ReqGetAcctRealName
            {
                CorpNo   = strComCorpNo,
                AcctNo   = strAcctNo,
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

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 계좌번호 수정 
    /// </summary>
    protected void SetCarCompanyAcctUpd()
    {
        ReqCarCompanyAcctUpd lo_objReqCarCompanyAcctUpd = null;
        ServiceResult<bool>  lo_objResCarCompanyAcctUpd = null;
        string               lo_strSearchAcctNo         = string.Empty;

        strEncAcctNo       = Utils.GetEncrypt(strAcctNo, SiteGlobal.AES2_ENC_IV_VALUE);
        lo_strSearchAcctNo = strAcctNo.Right(4);

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0") || string.IsNullOrWhiteSpace(strComCorpNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strAcctNo) || string.IsNullOrWhiteSpace(strBankCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarCompanyAcctUpd = new ReqCarCompanyAcctUpd
            {
                CenterCode    = strCenterCode.ToInt(),
                ComCode       = strComCode.ToInt64(),
                ComCorpNo     = strComCorpNo,
                ReqType       = 1,
                BankCode      = strBankCode,
                EncAcctNo     = strEncAcctNo,
                SearchAcctNo  = lo_strSearchAcctNo,
                AcctName      = strAcctName,
                AcctValidFlag = strAcctValidFlag,
                AdminID       = objSes.AdminID
            };

            lo_objResCarCompanyAcctUpd = objCarDispatchDasServices.SetCarCompanyAcctUpd(lo_objReqCarCompanyAcctUpd);

            objResMap.RetCode = lo_objResCarCompanyAcctUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarCompanyAcctUpd.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("EncAcctNo", strEncAcctNo);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 계산서 목록 조회
    /// </summary>
    protected void GetHometaxList()
    {
        ReqApproveHometaxApiList                lo_objReqApproveHometaxApiList = null;
        ServiceResult<ResApproveHometaxApiList> lo_objResApproveHometaxApiList = null;
        string                                  lo_strFROM_YMD                 = string.Empty;
        string                                  lo_strTO_YMD                   = string.Empty;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCorpNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        DateTime dtTaxWriteDateTo = DateTime.ParseExact(strTaxWriteDateTo, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);
        lo_strFROM_YMD = dtTaxWriteDateTo.AddMonths(-2).ToString("yyyyMMdd");
        lo_strTO_YMD = dtTaxWriteDateTo.ToString("yyyyMMdd");

        try
        {
            lo_objReqApproveHometaxApiList = new ReqApproveHometaxApiList
            {
                CENTER_CODE       = strCenterCode.ToInt(),
                INVOICER_CORP_NUM = strComCorpNo,
                DATE_KIND         = "WRITE_DATE",
                FROM_YMD          = lo_strFROM_YMD,
                TO_YMD            = lo_strTO_YMD,
                MATCHING_FLAG     = "N",
                FREIGHT_FLAG      = "Y",
                PRE_MATCHING_FLAG = strPreMatchingFlag,
                PAGE_SIZE         = intPageSize,
                PAGE_NO           = intPageNo
            };

            lo_objResApproveHometaxApiList = objCargopayDasServices.GetApproveHometaxApiList(lo_objReqApproveHometaxApiList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResApproveHometaxApiList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseCarHandler", "Exception",
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