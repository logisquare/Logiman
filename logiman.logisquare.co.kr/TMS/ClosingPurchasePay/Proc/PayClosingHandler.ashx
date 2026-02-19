<%@ WebHandler Language="C#" Class="PayClosingHandler" %>
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
/// FileName        : PayClosingHandler.ashx
/// Description     : 카고페이송금신청 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-19
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class PayClosingHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingPurchasePay/PayClosingList"; //필수

    // 메소드 리스트
    private const string MethodPayClosingSendList      = "PayClosingSendList";      //매입 전표 송금예정일 내역
    private const string MethodPayClosingSendListExcel = "PayClosingSendListExcel"; //매입 전표 송금예정일 내역 엑셀
    private const string MethodPayClosingList          = "PayClosingList";          //매입 전표 내역
    private const string MethodPayClosingListExcel     = "PayClosingListExcel";     //매입 전표 내역 엑셀
    private const string MethodPayClosingSendUpd       = "PayClosingSendUpdate";    //카고페이송금처리
    private const string MethodChkAcctNo               = "ChkAcctNo";               //계좌번호 체크
    private const string MethodCarComAcctUpd           = "CarComAcctUpdate";        //계좌번호 수정
    private const string MethodPayClosingDeductUpd     = "PayClosingDeductUpdate";  //공제등록
        
    PurchaseDasServices    objPurchaseDasServices    = new PurchaseDasServices();
    CarDispatchDasServices objCarDispatchDasServices = new CarDispatchDasServices();

    private HttpContext objHttpContext       = null;

    private string strCallType              = string.Empty;
    private int    intPageSize              = 0;
    private int    intPageNo                = 0;
    private string strPurchaseClosingSeqNo  = string.Empty;
    private string strCenterCode            = string.Empty;
    private string strDateType              = string.Empty;
    private string strDateFrom              = string.Empty;
    private string strDateTo                = string.Empty;
    private string strOrderLocationCodes    = string.Empty;
    private string strDeliveryLocationCodes = string.Empty;
    private string strOrderItemCodes        = string.Empty;
    private string strComName               = string.Empty;
    private string strComCorpNo             = string.Empty;
    private string strClosingAdminName      = string.Empty;
    private string strComCode               = string.Empty;
    private string strEncAcctNo             = string.Empty;
    private string strAcctNo                = string.Empty;
    private string strBankCode              = string.Empty;
    private string strAcctName              = string.Empty;
    private string strAcctValidFlag         = string.Empty;
    private string strDeductFlag            = string.Empty;
    private string strDeductAmt             = string.Empty;
    private string strInputDeductAmt        = string.Empty;
    private string strDeductReason          = string.Empty;
    private string strInsureFlag            = string.Empty;
    
    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPayClosingSendList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPayClosingSendListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodPayClosingList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPayClosingListExcel,     MenuAuthType.All);
        objMethodAuthList.Add(MethodPayClosingSendUpd,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodChkAcctNo,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarComAcctUpd,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPayClosingDeductUpd,     MenuAuthType.ReadWrite);
        
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

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("PayClosingHandler");
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
            strPurchaseClosingSeqNo  = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseClosingSeqNo"), "0");
            strCenterCode            = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),           "0");
            strDateType              = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),             "0");
            strDateFrom              = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes    = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strDeliveryLocationCodes = SiteGlobal.GetRequestForm("DeliveryLocationCodes");
            strOrderItemCodes        = SiteGlobal.GetRequestForm("OrderItemCodes");
            strComName               = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo             = SiteGlobal.GetRequestForm("ComCorpNo");
            strClosingAdminName      = SiteGlobal.GetRequestForm("ClosingAdminName");
            strComCode               = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"),       "0");
            strAcctName              = Utils.IsNull(SiteGlobal.GetRequestForm("AcctName"),      string.Empty);
            strAcctNo                = Utils.IsNull(SiteGlobal.GetRequestForm("AcctNo"),        string.Empty);
            strEncAcctNo             = Utils.IsNull(SiteGlobal.GetRequestForm("EncAcctNo"),     string.Empty);
            strBankCode              = Utils.IsNull(SiteGlobal.GetRequestForm("BankCode"),      string.Empty);
            strAcctValidFlag         = Utils.IsNull(SiteGlobal.GetRequestForm("AcctValidFlag"), string.Empty);
            strDeductFlag            = SiteGlobal.GetRequestForm("DeductFlag");
            strDeductAmt             = Utils.IsNull(SiteGlobal.GetRequestForm("DeductAmt"), "0");
            strInputDeductAmt        = Utils.IsNull(SiteGlobal.GetRequestForm("InputDeductAmt"), "0");
            strDeductReason          = SiteGlobal.GetRequestForm("DeductReason");
            strInsureFlag            = SiteGlobal.GetRequestForm("InsureFlag");
            
            strDateFrom  = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo    = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
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
                case MethodPayClosingSendList:
                    GetPayClosingSendList();
                    break;
                case MethodPayClosingSendListExcel:
                    GetPayClosingSendListExcel();
                    break;
                case MethodPayClosingList:
                    GetPayClosingList();
                    break;
                case MethodPayClosingListExcel:
                    GetPayClosingListExcel();
                    break;
                case MethodPayClosingSendUpd:
                    SetPayClosingSendUpd();
                    break;
                case MethodChkAcctNo:
                    GetAcctRealName();
                    break;
                case MethodCarComAcctUpd:
                    SetCarCompanyAcctUpd();
                    break;
                case MethodPayClosingDeductUpd:
                    SetPayClosingDeductUpd();
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

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매입 전표 송금예정일 내역
    /// </summary>
    protected void GetPayClosingSendList()
    {
        ReqPurchaseClosingSendList                lo_objReqPurchaseClosingSendList = null;
        ServiceResult<ResPurchaseClosingSendList> lo_objResPurchaseClosingSendList = null;

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
            lo_objReqPurchaseClosingSendList = new ReqPurchaseClosingSendList
            {
                PurchaseClosingSeqNo  = strPurchaseClosingSeqNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                ClosingAdminName      = strClosingAdminName,
                DeductFlag            = strDeductFlag,
                InsureFlag            = strInsureFlag,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResPurchaseClosingSendList = objPurchaseDasServices.GetPurchaseClosingSendList(lo_objReqPurchaseClosingSendList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseClosingSendList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 전표 송금예정일 내역 엑셀
    /// </summary>
    protected void GetPayClosingSendListExcel()
    {
        ReqPurchaseClosingSendList                lo_objReqPurchaseClosingSendList = null;
        ServiceResult<ResPurchaseClosingSendList> lo_objResPurchaseClosingSendList = null;
        string                                    lo_strFileName                   = "";
        SpreadSheet                               lo_objExcel                      = null;
        DataTable                                 lo_dtData                        = null;
        MemoryStream                              lo_outputStream                  = null;
        byte[]                                    lo_Content                       = null;
        int                                       lo_intColumnIndex                = 0;

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
            lo_objReqPurchaseClosingSendList = new ReqPurchaseClosingSendList
            {
                PurchaseClosingSeqNo  = strPurchaseClosingSeqNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                ClosingAdminName      = strClosingAdminName,
                DeductFlag            = strDeductFlag,
                InsureFlag            = strInsureFlag,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResPurchaseClosingSendList = objPurchaseDasServices.GetPurchaseClosingSendList(lo_objReqPurchaseClosingSendList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금예정일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총건수",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총매입",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("미신청건수",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("미신청매입",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("예정건수",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("예정매입",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("완료건수",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("완료매입",   typeof(double)));
            
            foreach (var row in lo_objResPurchaseClosingSendList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.SendPlanYMD,row.AllCnt,row.AllAmt,row.SendCnt1
                                ,row.SendAmt1,row.SendCnt2,row.SendAmt2,row.SendCnt3,row.SendAmt3);
            }
            
            lo_objExcel = new SpreadSheet {SheetName = "PurchaseClosingSendList"};

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);
                
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
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

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 전표 내역
    /// </summary>
    protected void GetPayClosingList()
    {
            
        ReqPurchaseClosingList                lo_objReqPurchaseClosingList = null;
        ServiceResult<ResPurchaseClosingList> lo_objResPurchaseClosingList = null;

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
            lo_objReqPurchaseClosingList = new ReqPurchaseClosingList
            {
                PurchaseClosingSeqNo  = strPurchaseClosingSeqNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                ClosingAdminName      = strClosingAdminName,
                DeductFlag            = strDeductFlag,
                InsureFlag            = strInsureFlag,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResPurchaseClosingList = objPurchaseDasServices.GetPurchaseClosingList(lo_objReqPurchaseClosingList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 전표 내역 엑셀
    /// </summary>
    protected void GetPayClosingListExcel()
    {
        ReqPurchaseClosingList                lo_objReqPurchaseClosingList = null;
        ServiceResult<ResPurchaseClosingList> lo_objResPurchaseClosingList = null;
        string                                lo_strFileName               = "";
        SpreadSheet                           lo_objExcel                  = null;
        DataTable                             lo_dtData                    = null;
        MemoryStream                          lo_outputStream              = null;
        byte[]                                lo_Content                   = null;
        int                                   lo_intColumnIndex            = 0;

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
            lo_objReqPurchaseClosingList = new ReqPurchaseClosingList
            {
                PurchaseClosingSeqNo  = strPurchaseClosingSeqNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                OrderLocationCodes    = strOrderLocationCodes,
                DeliveryLocationCodes = strDeliveryLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                ClosingAdminName      = strClosingAdminName,
                DeductFlag            = strDeductFlag,
                InsureFlag            = strInsureFlag,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResPurchaseClosingList = objPurchaseDasServices.GetPurchaseClosingList(lo_objReqPurchaseClosingList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전표번호",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량업체명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량사업자번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("법인여부",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("대표자명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("업체상태",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("과세구분",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("과세구분상세",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("카드결제동의여부", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("카드결제동의일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("매입합계",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",     typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총공제금액",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공제금액",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공제사유",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("산재보험적용",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("산재보험료",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("송금예정액",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("발행상태",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("발행구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최종상차일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서작성일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서발행일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("국세청승인번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("은행명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계좌번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("예금주",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("결제방식",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("송금상태",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금예정일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("실제송금일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금-은행명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금-계좌번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금-예금주",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금신청자",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금신청일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("메모",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감자",     typeof(string)));
            
            lo_dtData.Columns.Add(new DataColumn("마감일시",    typeof(string)));
            
            foreach (var row in lo_objResPurchaseClosingList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.PurchaseClosingSeqNo,row.ComName,row.ComCorpNo,row.ComKindM
                    ,row.ComCeoName,row.ComStatusM,row.ComTaxKindM,row.ComTaxMsg,row.CardAgreeFlag
                    ,row.CardAgreeYMD,row.OrgAmt,row.SupplyAmt,row.TaxAmt,row.DeductAmt
                    ,row.InputDeductAmt,row.DeductReason,row.InsureFlag,row.DriverInsureAmt,row.SendAmt
                    ,row.BillStatusM,row.BillKindM,row.PickupYMDTo,row.BillWrite,row.BillYMD
                    ,row.NtsConfirmNum,row.BankName,row.AcctNo,row.AcctName,row.SendTypeM
                    ,row.SendStatusM,row.SendPlanYMD,row.SendYMD,row.SendBankName,row.SendAcctNo
                    ,row.SendAcctName,row.SendAdminName,row.SendDate,row.Note,row.ClosingAdminName
                    ,row.ClosingDate);
            }
            
            lo_objExcel = new SpreadSheet {SheetName = "PurchaseClosingList"};

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
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
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

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 카고페이송금처리
    /// </summary>
    protected void SetPayClosingSendUpd()
    {
        ReqPurchaseClosingList                lo_objReqPurchaseClosingList        = null;
        ServiceResult<ResPurchaseClosingList> lo_objResPurchaseClosingList        = null;
        PurchaseClosingGridModel              lo_objPurchaseClosingGridModel      = null;
        ReqInsOrderTMS                        lo_objReqInsOrderTMS                = null;
        ResInsOrderTMS                        lo_objResInsOrderTMS                = null;
        ReqPurchaseClosingSendInfoUpd         lo_objReqPurchaseClosingSendInfoUpd = null;
        ServiceResult<bool>                   lo_objResPurchaseClosingSendInfoUpd = null;
        string                                lo_strAcctNo                        = string.Empty;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo) || strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingList = new ReqPurchaseClosingList
            {
                PurchaseClosingSeqNo  = strPurchaseClosingSeqNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                QuickFlag             = "N",
                AccessCenterCode      = objSes.AccessCenterCode
            };

            lo_objResPurchaseClosingList = objPurchaseDasServices.GetPurchaseClosingList(lo_objReqPurchaseClosingList);
            objResMap.RetCode            = lo_objResPurchaseClosingList.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = "전표 정보를 찾을 수 없습니다.";
                return;
            }
            
            if (!lo_objResPurchaseClosingList.data.RecordCnt.Equals(1))
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "전표 정보를 찾을 수 없습니다.";
                return;
            }

            lo_objPurchaseClosingGridModel = lo_objResPurchaseClosingList.data.list[0];

            if (lo_objPurchaseClosingGridModel == null)
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "전표 정보를 찾을 수 없습니다.";
                return;
            }

            if (lo_objPurchaseClosingGridModel.SendStatus.Equals(2) || lo_objPurchaseClosingGridModel.SendStatus.Equals(3))
            {
                objResMap.RetCode = 9005;
                objResMap.ErrMsg  = "전표 정보를 찾을 수 없습니다.";
                return;
            }

            if (!lo_objPurchaseClosingGridModel.AcctValidFlag.Equals("Y") || string.IsNullOrWhiteSpace(lo_objPurchaseClosingGridModel.EncAcctNo) || string.IsNullOrWhiteSpace(lo_objPurchaseClosingGridModel.SearchAcctNo) || string.IsNullOrWhiteSpace(lo_objPurchaseClosingGridModel.AcctName) || string.IsNullOrWhiteSpace(lo_objPurchaseClosingGridModel.BankCode))
            {
                objResMap.RetCode = 9006;
                objResMap.ErrMsg  = "계좌정보가 올바르지 않습니다.";
                return;
            }

            lo_strAcctNo = Utils.GetDecrypt(lo_objPurchaseClosingGridModel.EncAcctNo);
            if (string.IsNullOrWhiteSpace(lo_strAcctNo)) 
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "계좌정보가 올바르지 않습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(lo_objPurchaseClosingGridModel.SendPlanYMD))
            {
                objResMap.RetCode = 9008;
                objResMap.ErrMsg  = "송금 예정일 정보가 없습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(lo_objPurchaseClosingGridModel.BillWrite))
            {
                objResMap.RetCode = 9009;
                objResMap.ErrMsg  = "계산서 작성일 정보가 없습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        if (lo_objPurchaseClosingGridModel == null) 
        {
            objResMap.RetCode = 9010;
            objResMap.ErrMsg  = "전표 정보를 찾을 수 없습니다.";
            return;
        }
        
        //송금처리
        try
        {
            lo_objReqInsOrderTMS = new ReqInsOrderTMS
            {
                CenterCode   = lo_objPurchaseClosingGridModel.CenterCode,
                SendCost     = lo_objPurchaseClosingGridModel.SendAmt,
                SupplyCost   = lo_objPurchaseClosingGridModel.SupplyAmt,
                TaxCost      = lo_objPurchaseClosingGridModel.TaxAmt,
                PayWay       = 1, // 지불방법 (1:일반결제, 2:빠른입금 (차), 3:빠른입금(운))
                CarPay       = lo_objPurchaseClosingGridModel.OrgAmt,
                CarName      = lo_objPurchaseClosingGridModel.ComName,
                CarBizNo     = lo_objPurchaseClosingGridModel.ComCorpNo,
                CarCeo       = lo_objPurchaseClosingGridModel.ComCeoName,
                CarBankCode  = lo_objPurchaseClosingGridModel.BankCode,
                CarBankName  = lo_objPurchaseClosingGridModel.BankName,
                CarAcctName  = lo_objPurchaseClosingGridModel.AcctName,
                CarAcctNo    = lo_strAcctNo,
                CarNo        = lo_objPurchaseClosingGridModel.CarNo,
                CarDriName   = lo_objPurchaseClosingGridModel.DriverName,
                CarDriCell   = lo_objPurchaseClosingGridModel.DriverCell,
                TaxReceive   = "Y", //계산서 수신여부 (Y/N), 미입력시 Y
                ClosingSeqNo = lo_objPurchaseClosingGridModel.PurchaseClosingSeqNo,
                IssueDate    = lo_objPurchaseClosingGridModel.BillWrite,
                PayPlanDate  = lo_objPurchaseClosingGridModel.SendPlanYMD,
                PartnerFlag  = lo_objPurchaseClosingGridModel.CooperatorFlag,
                PayKind      = 1, //송금유형상세 (1:일반,4:포인트사용)
                UsedPoint    = 0,
                Note         = "로지맨 일반입금 - " + objSes.AdminName
            };

            lo_objResInsOrderTMS = SiteGlobal.InsOrderTMS(lo_objReqInsOrderTMS);
            objResMap.RetCode    = lo_objResInsOrderTMS.Header.ResultCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResInsOrderTMS.Header.ResultMessage;
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        //송금정보 업데이트
        try
        {
            lo_objReqPurchaseClosingSendInfoUpd = new ReqPurchaseClosingSendInfoUpd
            {
                CenterCode           = lo_objPurchaseClosingGridModel.CenterCode,
                PurchaseClosingSeqNo = lo_objPurchaseClosingGridModel.PurchaseClosingSeqNo,
                SendStatus           = 2, //송금 상태 (1: 미송금, 2 :송금신청. 3: 송금완료) 
                SendType             = 2,//결제 유형(1 : 미선택, 2:일반입금, 3: 빠른입금(차), 4:빠른입금(운) - 바로지급, 5:빠른입금(운) - 14일지급, 6:수기송금, 7 : 카드결제)
                ReqYMD               = lo_objPurchaseClosingGridModel.SendPlanYMD,
                ChkPermFlag          = "Y",
                SendAdminID          = objSes.AdminID,
                SendAdminName        = objSes.AdminName
            };
                
            lo_objResPurchaseClosingSendInfoUpd = objPurchaseDasServices.SetPurchaseClosingSendInfoUpd(lo_objReqPurchaseClosingSendInfoUpd);
            objResMap.RetCode       = lo_objResPurchaseClosingSendInfoUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseClosingSendInfoUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
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

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
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

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 공제등록
    /// </summary>
    protected void SetPayClosingDeductUpd()
    {
        ReqPurchaseClosingDeductUpd lo_objReqPurchaseClosingDeductUpd = null;
        ServiceResult<bool>         lo_objResPurchaseClosingDeductUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo) || strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strInputDeductAmt.ToDouble() < 0)
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "공제금액은 0보다 작을 수 없습니다.";
            return;
        }

        if (strInputDeductAmt.ToDouble() > 0 && string.IsNullOrWhiteSpace(strDeductReason))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "공제 사유를 입력하세요.";
            return;
        }

        //송금정보 업데이트
        try
        {
            lo_objReqPurchaseClosingDeductUpd = new ReqPurchaseClosingDeductUpd
            {
                CenterCode           = strCenterCode.ToInt(),
                PurchaseClosingSeqNo = strPurchaseClosingSeqNo.ToInt64(),
                InputDeductAmt       = strInputDeductAmt.ToDouble(),
                DeductReason         = strDeductReason,
                UpdAdminID           = objSes.AdminID,
                UpdAdminName         = objSes.AdminName
            };
                
            lo_objResPurchaseClosingDeductUpd = objPurchaseDasServices.SetPurchaseClosingDeductUpd(lo_objReqPurchaseClosingDeductUpd);
            objResMap.RetCode       = lo_objResPurchaseClosingDeductUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseClosingDeductUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PayClosingHandler", "Exception",
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