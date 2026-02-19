<%@ WebHandler Language="C#" Class="PurchaseQuickHandler" %>
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
/// FileName        : PurchaseQuickHandler.ashx
/// Description     : 빠른입금마감 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-06
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class PurchaseQuickHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingPurchase/PurchaseCarList"; //필수

    // 메소드 리스트
    private const string MethodPurchaseQuickPayList          = "PurchaseQuickPayList";          //매입 운송내역 목록
    private const string MethodPurchaseQuickPayListExcel     = "PurchaseQuickPayListExcel";     //매입 운송내역 엑셀
    private const string MethodHometaxList                   = "HometaxList";                   //계산서 목록
    private const string MethodHometaxListExcel              = "HometaxListExcel";              //계산서 목록 엑셀
    private const string MethodPurchaseClosingIns            = "PurchaseClosingInsert";         //매입 마감
    private const string MethodChkAcctNo                     = "ChkAcctNo";                     //계좌번호 체크
    private const string MethodCarComAcctUpd                 = "CarComAcctUpdate";              //계좌번호 수정
    private const string MethodPurchaseQuickMonthPayList     = "PurchaseQuickMonthPayList";     //미마감내역
    private const string MethodPurchaseCarCompanyInsureCheck = "PurchaseCarCompanyInsureCheck"; //매입 마감 보험료 체크

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
    private string strComName               = string.Empty;
    private string strComCorpNo             = string.Empty;
    private string strQuickType             = string.Empty;
    private string strCarDivType            = string.Empty;
    private string strConsignorName         = string.Empty;
    private string strClosingFlag           = string.Empty;
    private string strComCode               = string.Empty;
    private string strEncAcctNo             = string.Empty;
    private string strAcctNo                = string.Empty;
    private string strBankCode              = string.Empty;
    private string strBankName              = string.Empty;
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
    private string strPurchaseOrgAmt        = string.Empty;
    private string strPurchaseSupplyAmt     = string.Empty;
    private string strPurchaseTaxAmt        = string.Empty;
    private string strYear                  = string.Empty;
    private string strCooperatorFlag        = string.Empty;
    private string strDriverName            = string.Empty;
    private string strDriverCell            = string.Empty;
    private string strComCeoName            = string.Empty;
    private string strAcceptAdminName       = string.Empty;
    private string strDispatchAdminName     = string.Empty;
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
        objMethodAuthList.Add(MethodPurchaseQuickPayList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseQuickPayListExcel,     MenuAuthType.All);
        objMethodAuthList.Add(MethodHometaxList,                   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodHometaxListExcel,              MenuAuthType.All);
        objMethodAuthList.Add(MethodPurchaseClosingIns,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodChkAcctNo,                     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarComAcctUpd,                 MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPurchaseQuickMonthPayList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseCarCompanyInsureCheck, MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("PurchaseQuickHandler");
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
            strComName               = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo             = SiteGlobal.GetRequestForm("ComCorpNo");
            strQuickType             = Utils.IsNull(SiteGlobal.GetRequestForm("QuickType"),  "0");
            strCarDivType            = Utils.IsNull(SiteGlobal.GetRequestForm("CarDivType"), "0");
            strConsignorName         = SiteGlobal.GetRequestForm("ConsignorName");
            strClosingFlag           = SiteGlobal.GetRequestForm("ClosingFlag");
            strComCode               = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"),       "0");
            strAcctName              = Utils.IsNull(SiteGlobal.GetRequestForm("AcctName"),      string.Empty);
            strAcctNo                = Utils.IsNull(SiteGlobal.GetRequestForm("AcctNo"),        string.Empty);
            strEncAcctNo             = Utils.IsNull(SiteGlobal.GetRequestForm("EncAcctNo"),     string.Empty);
            strBankCode              = Utils.IsNull(SiteGlobal.GetRequestForm("BankCode"),      string.Empty);
            strBankName              = Utils.IsNull(SiteGlobal.GetRequestForm("BankName"),      string.Empty);
            strAcctValidFlag         = Utils.IsNull(SiteGlobal.GetRequestForm("AcctValidFlag"), string.Empty);
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
            strPurchaseClosingSeqNo  = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseClosingSeqNo"), "0");
            strPurchaseOrgAmt        = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseOrgAmt"),       "0");
            strPurchaseSupplyAmt     = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseSupplyAmt"),    "0");
            strPurchaseTaxAmt        = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseTaxAmt"),       "0");
            strYear                  = SiteGlobal.GetRequestForm("Year");
            strCooperatorFlag        = SiteGlobal.GetRequestForm("CooperatorFlag");
            strDriverName            = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell            = SiteGlobal.GetRequestForm("DriverCell");
            strComCeoName            = SiteGlobal.GetRequestForm("ComCeoName");
            strAcceptAdminName       = SiteGlobal.GetRequestForm("AcceptAdminName");
            strDispatchAdminName     = SiteGlobal.GetRequestForm("DispatchAdminName");
            strInsureFlag            = Utils.IsNull(SiteGlobal.GetRequestForm("InsureFlag"), "Y");
            strInsureYMD             = SiteGlobal.GetRequestForm("InsureYMD");
            
            strDateFrom       = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo         = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-",         "");
            strTaxWriteDateTo = string.IsNullOrWhiteSpace(strTaxWriteDateTo) ? strTaxWriteDateTo : strTaxWriteDateTo.Replace("-", "");
            strBillWrite      = string.IsNullOrWhiteSpace(strBillWrite) ? strBillWrite : strBillWrite.Replace("-", "");
            strBillYMD        = string.IsNullOrWhiteSpace(strBillYMD) ? strBillYMD : strBillYMD.Replace("-", "");
            strBillDate       = string.IsNullOrWhiteSpace(strBillDate) ? strBillDate : strBillDate.Replace("-", "");
            strInsureYMD      = string.IsNullOrWhiteSpace(strInsureYMD) ? strInsureYMD : strInsureYMD.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
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
                case MethodPurchaseQuickPayList:
                    GetPurchaseQuickPayList();
                    break;;
                case MethodPurchaseQuickPayListExcel:
                    GetPurchaseQuickPayListExcel();
                    break;
                case MethodHometaxList:
                    GetHometaxList();
                    break;
                case MethodHometaxListExcel:
                    GetHometaxListExcel();
                    break;
                case MethodPurchaseClosingIns:
                    SetPurchaseClosingIns();
                    break;
                case MethodChkAcctNo:
                    GetAcctRealName();
                    break;
                case MethodCarComAcctUpd:
                    SetCarCompanyAcctUpd();
                    break;
                case MethodPurchaseQuickMonthPayList:
                    GetPurchaseQuickMonthPayList();
                    break;
                case MethodPurchaseCarCompanyInsureCheck:
                    GetPurchaseCarCompanyInsureCheck();
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

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매입 운송내역 목록
    /// </summary>
    protected void GetPurchaseQuickPayList()
    {
        ReqPurchaseQuickPayList                lo_objReqPurchaseQuickPayList = null;
        ServiceResult<ResPurchaseQuickPayList> lo_objResPurchaseQuickPayList = null;
        ServiceResult<ResNoMatchTaxList>       lo_objResNoMatchTaxList       = null;
        DataTable                              lo_dtTax                      = new DataTable();
        System.Text.StringBuilder              lo_sb                         = new System.Text.StringBuilder();
        string[]                               lo_arrDataText                = null;
        string                                 lo_strTrData                  = string.Empty;
        DateTime                               lo_dtTaxWriteDateTo;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo) || string.IsNullOrWhiteSpace(strTaxWriteDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseQuickPayList = new ReqPurchaseQuickPayList
            {
                CenterCode            = strCenterCode.ToInt(),
                ClosingFlag           = strClosingFlag,
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                QuickType             = strQuickType.ToInt(),
                CarDivType            = strCarDivType.ToInt(),
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                CarNo                 = strCarNo,
                DriverName            = strDriverName,
                DriverCell            = strDriverCell,
                ConsignorName         = strConsignorName,
                AcceptAdminName       = strAcceptAdminName,
                DispatchAdminName     = strDispatchAdminName,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResPurchaseQuickPayList = objPurchaseDasServices.GetPurchaseQuickPayList(lo_objReqPurchaseQuickPayList);

            if (lo_objResPurchaseQuickPayList.data.RecordCnt > 0)
            {
                //=======================================================================================================================================
                // 검색 운송사의 카고페이 홈텍스 계산서 최근 2개월 발행 목록에서 사전 매칭이 되어 있지 않은 계산서를 발행 사업자별, 계산서 수를 조회한다
                //=======================================================================================================================================
                lo_dtTaxWriteDateTo = DateTime.ParseExact(strTaxWriteDateTo, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);

                lo_objResNoMatchTaxList = objCargopayDasServices.GetApproveHometaxAPICntGet(strCenterCode.ToInt(), lo_dtTaxWriteDateTo.AddMonths(-2).ToString("yyyyMMdd"), lo_dtTaxWriteDateTo.ToString("yyyyMMdd"));

                if (lo_objResNoMatchTaxList.data.RECORD_CNT > 0)
                {
                    foreach (PurchaseQuickPayGridModel lo_objPurchaseQuickPay in lo_objResPurchaseQuickPayList.data.list)
                    {
                        lo_dtTax.Clear();
                        lo_sb.Clear();
                        lo_strTrData = string.Empty;

                        if (lo_objResNoMatchTaxList.data.list.ContainsKey(lo_objPurchaseQuickPay.ComCorpNo))
                        {
                            SiteGlobal.ConvertXmlDataToDataTable(lo_objResNoMatchTaxList.data.list[lo_objPurchaseQuickPay.ComCorpNo].ToString(), ref lo_dtTax);
                            lo_objPurchaseQuickPay.NoMatchTaxCnt = lo_dtTax.Rows.Count;
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
                            lo_objPurchaseQuickPay.NoMatchTaxInfo = lo_sb.ToString();
                        }
                        else
                        {
                            lo_objPurchaseQuickPay.NoMatchTaxCnt  = 0;
                            lo_objPurchaseQuickPay.NoMatchTaxInfo = string.Empty;
                        }
                    }
                }
            }

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseQuickPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 운송내역 엑셀
    /// </summary>
    protected void GetPurchaseQuickPayListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqPurchaseQuickPayList                lo_objReqPurchaseQuickPayList = null;
        ServiceResult<ResPurchaseQuickPayList> lo_objResPurchaseQuickPayList = null;
        string                                 lo_strFileName                = "";
        SpreadSheet                            lo_objExcel                   = null;
        DataTable                              lo_dtData                     = null;
        MemoryStream                           lo_outputStream               = null;
        byte[]                                 lo_Content                    = null;
        int                                    lo_intColumnIndex             = 0;

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
            lo_objReqPurchaseQuickPayList = new ReqPurchaseQuickPayList
            {
                CenterCode            = strCenterCode.ToInt(),
                ClosingFlag           = strClosingFlag,
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                QuickType             = strQuickType.ToInt(),
                CarDivType            = strCarDivType.ToInt(),
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                CarNo                 = strCarNo,
                DriverName            = strDriverName,
                DriverCell            = strDriverCell,
                ConsignorName         = strConsignorName,
                AcceptAdminName       = strAcceptAdminName,
                DispatchAdminName     = strDispatchAdminName,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResPurchaseQuickPayList = objPurchaseDasServices.GetPurchaseQuickPayList(lo_objReqPurchaseQuickPayList);

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

            lo_dtData.Columns.Add(new DataColumn("총길이",           typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("매입합계",          typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",          typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",           typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("빠른입금수수료(공급가액)", typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("빠른입금수수료(부가세)",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("산재보험대상",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("산재보험신고",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량구분",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량업체명",         typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("법인여부",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("대표자명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("국세청승인번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수자명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("배차자명",    typeof(string)));

            foreach (var row in lo_objResPurchaseQuickPayList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.OrderNo,row.ClosingFlag,row.BillStatusM,row.PurchaseClosingSeqNo
                    ,row.ClosingAdminName,row.ClosingDate,row.OrderItemCodeM,row.OrderLocationCodeM,row.DeliveryLocationCodeM
                    ,row.OrderClientName,row.PayClientName,row.ConsignorName,row.PickupYMD,row.PickupPlace
                    ,row.GetYMD,row.GetPlace,row.Volume,row.CBM,row.Weight
                    ,row.Length,row.PurchaseOrgAmt,row.PurchaseSupplyAmt,row.PurchaseTaxAmt,row.QuickPaySupplyFee
                    ,row.QuickPayTaxFee,row.InsureTargetFlag,row.InsureExceptKindM,row.CarDivTypeM,row.ComName
                    ,row.ComCorpNo,row.ComKindM,row.ComCeoName,row.CarNo,row.DriverName
                    ,row.DriverCell,row.NtsConfirmNum,row.AcceptAdminName,row.DispatchAdminName);
            }

            lo_objExcel = new SpreadSheet {SheetName = "PurchaseQuickPayList"};

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
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
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

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
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
        string                                  lo_strTO_YMD                   = strTaxWriteDateTo;
        DateTime lo_dtTaxWriteDateTo;
            

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

        if (string.IsNullOrWhiteSpace(strTaxWriteDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_dtTaxWriteDateTo = DateTime.ParseExact(strTaxWriteDateTo, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);

            lo_strFROM_YMD = lo_dtTaxWriteDateTo.AddMonths(-2).ToString("yyyyMMdd");

            lo_objReqApproveHometaxApiList = new ReqApproveHometaxApiList
            {
                CENTER_CODE       = strCenterCode.ToInt(),
                INVOICER_CORP_NUM = strComCorpNo,
                DATE_KIND         = "WRITE_DATE",
                FROM_YMD          = lo_strFROM_YMD,
                TO_YMD            = lo_strTO_YMD,
                NTS_CONFIRM_NUM   = strNtsConfirmNum,
                FREIGHT_FLAG      = "Y",
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

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 계산서 목록 엑셀
    /// </summary>
    protected void GetHometaxListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqApproveHometaxApiList                lo_objReqApproveHometaxApiList = null;
        ServiceResult<ResApproveHometaxApiList> lo_objResApproveHometaxApiList = null;
        string                                  lo_strFROM_YMD                 = string.Empty;
        string                                  lo_strTO_YMD                   = strTaxWriteDateTo;
        string                                  lo_strFileName                 = "";
        SpreadSheet                             lo_objExcel                    = null;
        DataTable                               lo_dtData                      = null;
        MemoryStream                            lo_outputStream                = null;
        byte[]                                  lo_Content                     = null;
        int                                     lo_intColumnIndex              = 0;
        DateTime                                lo_dtTaxWriteDateTo;

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

        if (string.IsNullOrWhiteSpace(strTaxWriteDateTo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_dtTaxWriteDateTo = DateTime.ParseExact(strTaxWriteDateTo, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);
            lo_strFROM_YMD      = lo_dtTaxWriteDateTo.AddMonths(-2).ToString("yyyyMMdd");

            lo_objReqApproveHometaxApiList = new ReqApproveHometaxApiList
            {
                CENTER_CODE       = strCenterCode.ToInt(),
                INVOICER_CORP_NUM = strComCorpNo,
                DATE_KIND         = "WRITE_DATE",
                FROM_YMD          = lo_strFROM_YMD,
                TO_YMD            = lo_strTO_YMD,
                NTS_CONFIRM_NUM   = strNtsConfirmNum,
                FREIGHT_FLAG      = "Y",
                PAGE_SIZE         = intPageSize,
                PAGE_NO           = intPageNo
            };

            lo_objResApproveHometaxApiList = objCargopayDasServices.GetApproveHometaxApiList(lo_objReqApproveHometaxApiList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("국세청승인번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("공급자",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("공급자사업자번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("공급자대표자명", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("공급받는자",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("공급받는자사업자번호",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("공급받는자대표자명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서작성일",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서발행일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서종류",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("합계",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액", typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",  typeof(double)));

            foreach (var row in lo_objResApproveHometaxApiList.data.list)
            {
                lo_dtData.Rows.Add(row.NTS_CONFIRM_NUM,row.INVOICER_CORP_NAME,row.INVOICER_CORP_NUM,row.INVOICER_CEO_NAME,row.INVOICEE_CORP_NAME
                    ,row.INVOICEE_CORP_NUM,row.INVOICEE_CEO_NAME,row.WRITE_DATE,row.ISSUE_DATE,row.INVOICE_KINDM
                    ,row.TOTAL_AMOUNT,row.SUPPLY_COST_TOTAL,row.TAX_TOTAL);
            }

            lo_objExcel = new SpreadSheet {SheetName = "PurchaseQuickBillList"};

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

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

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

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

    }

    /// <summary>
    /// 매입 마감
    /// </summary>
    protected void SetPurchaseClosingIns()
    {
        ReqPurchaseClosingCarIns                lo_objReqPurchaseClosingCarIns      = null;
        ServiceResult<ResPurchaseClosingCarIns> lo_objResPurchaseClosingCarIns      = null;
        ReqPreMatchingIns                       lo_objReqPreMatchingIns             = null;
        ServiceResult<bool>                     lo_objResPreMatchingIns             = null;
        ReqPurchaseClosingCnl                   lo_objReqPurchaseClosingCnl         = null;
        ServiceResult<bool>                     lo_objResPurchaseClosingCnl         = null;
        ReqInsOrderTMS                          lo_objReqInsOrderTMS                = null;
        ResInsOrderTMS                          lo_objResInsOrderTMS                = null;
        ReqPreMatchingDel                       lo_objReqPreMatchingDel             = null;
        ServiceResult<bool>                     lo_objResPreMatchingDel             = null;
        ReqPurchaseClosingSendInfoUpd           lo_objReqPurchaseClosingSendInfoUpd = null;
        ServiceResult<bool>                     lo_objResPurchaseClosingSendInfoUpd = null;
        int                                     lo_intBillStatus                    = 3;
        string                                  lo_strPurchaseClosingSeqNo          = string.Empty;
        string                                  lo_strSendPlanYMD                   = string.Empty;
        string                                  lo_strAcctNo                        = string.Empty;
        string                                  lo_strMatchingSuccessFlag           = "N";
        string                                  lo_strSendSuccessFlag               = "N";

        strCooperatorFlag = Utils.IsNull(strCooperatorFlag, "N");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0") || string.IsNullOrWhiteSpace(strComName) || string.IsNullOrWhiteSpace(strComCorpNo))
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

        if (string.IsNullOrWhiteSpace(strNtsConfirmNum) || string.IsNullOrWhiteSpace(strBillWrite))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strBillKind) || strBillKind.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strEncAcctNo) || string.IsNullOrWhiteSpace(strAcctName) || string.IsNullOrWhiteSpace(strBankCode) || string.IsNullOrWhiteSpace(strBankName))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strQuickType) || strQuickType.Equals("0"))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        lo_strAcctNo = Utils.GetDecrypt(strEncAcctNo);
        if (string.IsNullOrWhiteSpace(lo_strAcctNo))
        {
            objResMap.RetCode = 9008;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strCooperatorFlag.Equals("Y"))
        {
            strCarNo = "협력";
            strDriverName = "협력";
            strDriverCell = "01000000000";
        }

        strCarNo      = Utils.IsNull(strCarNo,      "협력외");
        strDriverName = Utils.IsNull(strDriverName, "협력외");
        strDriverCell = Utils.IsNull(strDriverCell, "01000000000");

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

            lo_strPurchaseClosingSeqNo = lo_objResPurchaseClosingCarIns.data.PurchaseClosingSeqNo.ToString();
            lo_strSendPlanYMD          = lo_objResPurchaseClosingCarIns.data.SendPlanYMD;

            objResMap.Add($"PurchaseClosingSeqNo", lo_objResPurchaseClosingCarIns.data.PurchaseClosingSeqNo.ToString());
            objResMap.Add("PurchaseOrgAmt",       lo_objResPurchaseClosingCarIns.data.PurchaseOrgAmt);
            objResMap.Add("PurchaseDeductAmt",    lo_objResPurchaseClosingCarIns.data.PurchaseDeductAmt);
            objResMap.Add("SendPlanYMD",          lo_objResPurchaseClosingCarIns.data.SendPlanYMD);

            strDeductAmt = lo_objResPurchaseClosingCarIns.data.PurchaseDeductAmt.ToString();
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        //매칭처리
        try
        {
            lo_objReqPreMatchingIns = new ReqPreMatchingIns
            {
                CENTER_CODE     = strCenterCode.ToInt(),
                CLOSING_SEQ_NO  = lo_strPurchaseClosingSeqNo,
                NTS_CONFIRM_NUM = strNtsConfirmNum
            };

            lo_objResPreMatchingIns = objCargopayDasServices.SetPreMatchingIns(lo_objReqPreMatchingIns);
            objResMap.RetCode       = lo_objResPreMatchingIns.result.ErrorCode;

            if (objResMap.RetCode.IsSuccess())
            {
                lo_strMatchingSuccessFlag = "Y";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
        
        //매칭 처리 실패 마감 취소 처리
        if (lo_strMatchingSuccessFlag.Equals("N"))
        {
            try
            {
                objResMap.Remove("PurchaseClosingSeqNo");
                objResMap.Remove("PurchaseOrgAmt");
                objResMap.Remove("PurchaseDeductAmt");
                objResMap.Remove("SendPlanYMD");

                lo_objReqPurchaseClosingCnl = new ReqPurchaseClosingCnl
                {
                    CenterCode            = strCenterCode.ToInt(),
                    PurchaseClosingSeqNos = lo_strPurchaseClosingSeqNo,
                    ChkPermFlag           = "Y",
                    CnlAdminID            = objSes.AdminID,
                    CnlAdminName          = objSes.AdminName
                };

                lo_objResPurchaseClosingCnl = objPurchaseDasServices.SetPurchaseClosingCnl(lo_objReqPurchaseClosingCnl);
                objResMap.RetCode           = lo_objResPurchaseClosingCnl.result.ErrorCode;

                if (objResMap.RetCode.IsSuccess())
                {
                    objResMap.ErrMsg  = "계산서 매칭에 실패하여 마감이 취소되었습니다.";
                }
                else
                {
                    objResMap.ErrMsg = "계산서 매칭에 실패하여 마감 취소를 진행하였으나, 오류가 발생했습니다.(전표번호: " + lo_strPurchaseClosingSeqNo + ")";
                }

                return;
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }
        }

        //송금처리
        try
        {
            lo_objReqInsOrderTMS = new ReqInsOrderTMS
            {
                CenterCode   = strCenterCode.ToInt(),
                SendCost     = strPurchaseOrgAmt.ToDouble() - strDeductAmt.ToDouble(),
                SupplyCost   = strPurchaseSupplyAmt.ToDouble(),
                TaxCost      = strPurchaseTaxAmt.ToDouble(),
                PayWay       = 3, // 지불방법 (1:일반결제, 2:빠른입금 (차), 3:빠른입금(운))
                CarPay       = strPurchaseOrgAmt.ToDouble(),
                CarName      = strComName,
                CarBizNo     = strComCorpNo,
                CarCeo       = strComCeoName,
                CarBankCode  = strBankCode,
                CarBankName  = strBankName,
                CarAcctName  = strAcctName,
                CarAcctNo    = lo_strAcctNo,
                CarNo        = strCarNo,
                CarDriName   = strDriverName,
                CarDriCell   = strDriverCell,
                TaxReceive   = "Y", //계산서 수신여부 (Y/N), 미입력시 Y
                ClosingSeqNo = lo_strPurchaseClosingSeqNo,
                IssueDate    = strBillWrite,
                PayPlanDate  = lo_strSendPlanYMD,
                PartnerFlag  = strCooperatorFlag,
                PayKind      = strQuickType.Equals("3") ? 3 : 1, //송금유형상세 (1:일반,4:포인트사용)
                UsedPoint    = 0,
                Note         = "로지맨 빠른입금(운) - " + (strQuickType.Equals("3") ? "14일입금" : "바로입금") + " " + objSes.AdminName
            };

            lo_objResInsOrderTMS = SiteGlobal.InsOrderTMS(lo_objReqInsOrderTMS);
            objResMap.RetCode    = lo_objResInsOrderTMS.Header.ResultCode;

            if (objResMap.RetCode.IsSuccess())
            {
                lo_strSendSuccessFlag = "Y";
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (lo_strSendSuccessFlag.Equals("Y"))
        {
            //송금정보 업데이트
            try
            {
                lo_objReqPurchaseClosingSendInfoUpd = new ReqPurchaseClosingSendInfoUpd
                {
                    CenterCode           = strCenterCode.ToInt(),
                    PurchaseClosingSeqNo = lo_strPurchaseClosingSeqNo,
                    SendStatus           = 2, //송금 상태 (1: 미송금, 2 :송금신청. 3: 송금완료) 
                    SendType             = strQuickType.Equals("3") ? 5 : 4,//결제 유형(1 : 미선택, 2:일반입금, 3: 빠른입금(차), 4:빠른입금(운) - 바로지급, 5:빠른입금(운) - 14일지급, 6:수기송금, 7 : 카드결제)
                    ReqYMD               = lo_strSendPlanYMD,
                    ChkPermFlag          = "Y",
                    SendAdminID          = objSes.AdminID,
                    SendAdminName        = objSes.AdminName
                };

                lo_objResPurchaseClosingSendInfoUpd = objPurchaseDasServices.SetPurchaseClosingSendInfoUpd(lo_objReqPurchaseClosingSendInfoUpd);
                objResMap.RetCode       = lo_objResPurchaseClosingSendInfoUpd.result.ErrorCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = "카고페이 송금신청은 완료되었으나, 송금상태 업데이트에 실패했습니다.";
                    objResMap.Remove("PurchaseClosingSeqNo");
                    objResMap.Remove("PurchaseOrgAmt");
                    objResMap.Remove("SendPlanYMD");
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
        else
        {
            objResMap.Remove("PurchaseClosingSeqNo");
            objResMap.Remove("PurchaseOrgAmt");
            objResMap.Remove("SendPlanYMD");

            //매칭취소
            try
            {
                lo_objReqPreMatchingDel = new ReqPreMatchingDel
                {
                    CENTER_CODE    = strCenterCode.ToInt(),
                    CLOSING_SEQ_NO = lo_strPurchaseClosingSeqNo
                };

                lo_objResPreMatchingDel = objCargopayDasServices.SetPreMatchingDel(lo_objReqPreMatchingDel);
                objResMap.RetCode       = lo_objResPreMatchingDel.result.ErrorCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = "송금신청에 실패하여 매칭 취소 중에 오류가 발생했습니다.(전표번호: " + lo_strPurchaseClosingSeqNo + ")";
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

            //마감취소
            try
            {
                lo_objReqPurchaseClosingCnl = new ReqPurchaseClosingCnl
                {
                    CenterCode            = strCenterCode.ToInt(),
                    PurchaseClosingSeqNos = lo_strPurchaseClosingSeqNo,
                    ChkPermFlag           = "Y",
                    CnlAdminID            = objSes.AdminID,
                    CnlAdminName          = objSes.AdminName
                };

                lo_objResPurchaseClosingCnl = objPurchaseDasServices.SetPurchaseClosingCnl(lo_objReqPurchaseClosingCnl);
                objResMap.RetCode           = lo_objResPurchaseClosingCnl.result.ErrorCode;

                if (objResMap.RetCode.IsFail())
                {
                    objResMap.ErrMsg = "송금신청에 실패하여 마감 취소 중에 오류가 발생했습니다.(전표번호: " + lo_strPurchaseClosingSeqNo + ")";
                    return;
                }

                objResMap.RetCode = 8888;
                objResMap.ErrMsg  = "송금신청에 실패하여 마감이 취소되었습니다.";
            }
            catch (Exception lo_ex)
            {
                objResMap.RetCode = 9404;
                objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

                SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    objResMap.RetCode);
            }
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

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
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

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 미마감내역
    /// </summary>
    protected void GetPurchaseQuickMonthPayList()
    {
            
        ReqPurchaseClosingPayMonthList                lo_objReqPurchaseClosingPayMonthList = null;
        ServiceResult<ResPurchaseClosingPayMonthList> lo_objResPurchaseClosingPayMonthList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strYear))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingPayMonthList = new ReqPurchaseClosingPayMonthList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClosingFlag      = "N",
                QuickFlag        = "Y",
                Year             = strYear,
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResPurchaseClosingPayMonthList = objPurchaseDasServices.GetPurchaseClosingPayMonthList(lo_objReqPurchaseClosingPayMonthList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseClosingPayMonthList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseQuickHandler", "Exception",
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