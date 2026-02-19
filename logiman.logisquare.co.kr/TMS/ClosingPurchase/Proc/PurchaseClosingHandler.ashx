<%@ WebHandler Language="C#" Class="PurchaseClosingHandler" %>
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
/// FileName        : PurchaseClosingHandler.ashx
/// Description     : 매입마감현황 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class PurchaseClosingHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingPurchase/PurchaseClosingList"; //필수
        
    // 메소드 리스트
    private const string MethodPurchaseClosingList               = "PurchaseClosingList";               //매입 전표 목록
    private const string MethodPurchaseClosingListExcel          = "PurchaseClosingListExcel";          //매입 전표 엑셀
    private const string MethodPurchaseClosingPayList            = "PurchaseClosingPayList";            //매입 전표 오더 목록
    private const string MethodPurchaseClosingPayListExcel       = "PurchaseClosingPayListExcel";       //매입 전표 오더 엑셀
    private const string MethodPurchaseClosingNoteUpd            = "PurchaseClosingNoteUpdate";         //매입 마감 메모 수정
    private const string MethodPurchaseClosingSendPlanYMDUpd     = "PurchaseClosingSendPlanYMDUpdate";  //매입 마감 송금예정일 등록
    private const string MethodPurchaseClosingOtherPayUpd        = "PurchaseClosingOtherPayUpdate";     //매입 마감 별도 송금 등록
    private const string MethodPurchaseClosingOtherPayCnl        = "PurchaseClosingOtherPayCancel";     //매입 마감 별도 송금 취소
    private const string MethodChkAcctNo                         = "ChkAcctNo";                         //계좌번호 체크
    private const string MethodCarComAcctUpd                     = "CarComAcctUpdate";                  //계좌번호 수정
    private const string MethodHometaxList                       = "HometaxList";                       //계산서 목록
    private const string MethodHometaxPreMatching                = "HometaxPreMatching";                //계산서 매칭
    private const string MethodPurchaseClosingClientPayList      = "PurchaseClosingClientPayList";      //업체 매입 전표 오더 목록
    private const string MethodPurchaseClosingClientPayListExcel = "PurchaseClosingClientPayListExcel"; //업체 매입 전표 오더 엑셀

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
    private string strOrderLocationCodes    = string.Empty;
    private string strDeliveryLocationCodes = string.Empty;
    private string strOrderItemCodes        = string.Empty;
    private string strSendStatus            = string.Empty;
    private string strSendType              = string.Empty;
    private string strComName               = string.Empty;
    private string strComCorpNo             = string.Empty;
    private string strCarNo                 = string.Empty;
    private string strDriverName            = string.Empty;
    private string strDriverCell            = string.Empty;
    private string strPurchaseClosingSeqNo  = string.Empty;
    private string strNote                  = string.Empty;
    private string strPurchaseClosingSeqNos = string.Empty;
    private string strSendPlanYMD           = string.Empty;
    private string strComCode               = string.Empty;
    private string strPurchaseOrgAmt        = string.Empty;
    private string strEncAcctNo             = string.Empty;
    private string strAcctNo                = string.Empty;
    private string strBankCode              = string.Empty;
    private string strAcctName              = string.Empty;
    private string strAcctValidFlag         = string.Empty;
    private string strBillKind              = string.Empty;
    private string strBillWrite             = string.Empty;
    private string strBillYMD               = string.Empty;
    private string strNtsConfirmNum         = string.Empty;
    private string strComCeoName            = string.Empty;
    private string strComBizType            = string.Empty;
    private string strComBizClass           = string.Empty;
    private string strComTelNo              = string.Empty;
    private string strComFaxNo              = string.Empty;
    private string strComEmail              = string.Empty;
    private string strComAddr               = string.Empty;
    private string strComAddrDtl            = string.Empty;
    private string strComPost               = string.Empty;
    private string strPreMatchingFlag       = string.Empty;
    private string strInsureFlag            = string.Empty;
    private string strClosingAdminName      = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodPurchaseClosingList,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseClosingListExcel,          MenuAuthType.All);
        objMethodAuthList.Add(MethodPurchaseClosingPayList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseClosingPayListExcel,       MenuAuthType.All);
        objMethodAuthList.Add(MethodPurchaseClosingNoteUpd,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPurchaseClosingSendPlanYMDUpd,     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPurchaseClosingOtherPayUpd,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPurchaseClosingOtherPayCnl,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodChkAcctNo,                         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarComAcctUpd,                     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodHometaxList,                       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodHometaxPreMatching,                MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPurchaseClosingClientPayList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPurchaseClosingClientPayListExcel, MenuAuthType.All);

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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("PurchaseClosingHandler");
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
            strOrderLocationCodes    = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strDeliveryLocationCodes = SiteGlobal.GetRequestForm("DeliveryLocationCodes");
            strOrderItemCodes        = SiteGlobal.GetRequestForm("OrderItemCodes");
            strSendStatus            = Utils.IsNull(SiteGlobal.GetRequestForm("SendStatus"), "0");
            strSendType              = Utils.IsNull(SiteGlobal.GetRequestForm("SendType"),   "0");
            strComName               = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo             = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarNo                 = SiteGlobal.GetRequestForm("CarNo");
            strDriverName            = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell            = SiteGlobal.GetRequestForm("DriverCell");
            strPurchaseClosingSeqNo  = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseClosingSeqNo"), "0");
            strNote                  = SiteGlobal.GetRequestForm("Note");
            strPurchaseClosingSeqNos = SiteGlobal.GetRequestForm("PurchaseClosingSeqNos");
            strSendPlanYMD           = SiteGlobal.GetRequestForm("SendPlanYMD");
            strComCode               = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"),        "0");
            strPurchaseOrgAmt        = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseOrgAmt"), "0");
            strAcctName              = Utils.IsNull(SiteGlobal.GetRequestForm("AcctName"),       string.Empty);
            strAcctNo                = Utils.IsNull(SiteGlobal.GetRequestForm("AcctNo"),         string.Empty);
            strEncAcctNo             = Utils.IsNull(SiteGlobal.GetRequestForm("EncAcctNo"),      string.Empty);
            strBankCode              = Utils.IsNull(SiteGlobal.GetRequestForm("BankCode"),       string.Empty);
            strAcctValidFlag         = Utils.IsNull(SiteGlobal.GetRequestForm("AcctValidFlag"),  string.Empty);
            strBillKind              = Utils.IsNull(SiteGlobal.GetRequestForm("BillKind"),       "0");
            strBillWrite             = SiteGlobal.GetRequestForm("BillWrite");
            strBillYMD               = SiteGlobal.GetRequestForm("BillYMD");
            strNtsConfirmNum         = SiteGlobal.GetRequestForm("NtsConfirmNum");
            strComCeoName            = SiteGlobal.GetRequestForm("ComCeoName");
            strComBizType            = SiteGlobal.GetRequestForm("ComBizType");
            strComBizClass           = SiteGlobal.GetRequestForm("ComBizClass");
            strComTelNo              = SiteGlobal.GetRequestForm("ComTelNo");
            strComFaxNo              = SiteGlobal.GetRequestForm("ComFaxNo");
            strComEmail              = SiteGlobal.GetRequestForm("ComEmail");
            strComAddr               = SiteGlobal.GetRequestForm("ComAddr");
            strComAddrDtl            = SiteGlobal.GetRequestForm("ComAddrDtl");
            strComPost               = SiteGlobal.GetRequestForm("ComPost");
            strPreMatchingFlag       = SiteGlobal.GetRequestForm("PreMatchingFlag");
            strInsureFlag            = SiteGlobal.GetRequestForm("InsureFlag");
            strClosingAdminName      = SiteGlobal.GetRequestForm("ClosingAdminName");

            strDateFrom    = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo      = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
            strSendPlanYMD = string.IsNullOrWhiteSpace(strSendPlanYMD) ? strSendPlanYMD : strSendPlanYMD.Replace("-", "");
            strBillWrite   = string.IsNullOrWhiteSpace(strBillWrite) ? strBillWrite : strBillWrite.Replace("-", "");
            strBillYMD     = string.IsNullOrWhiteSpace(strBillYMD) ? strBillYMD : strBillYMD.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
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
                case MethodPurchaseClosingList:
                    GetPurchaseClosingList();
                    break;
                case MethodPurchaseClosingListExcel:
                    GetPurchaseClosingListExcel();
                    break;
                case MethodPurchaseClosingPayList:
                    GetPurchaseClosingPayList();
                    break;
                case MethodPurchaseClosingPayListExcel:
                    GetPurchaseClosingPayListExcel();
                    break;
                case MethodPurchaseClosingNoteUpd:
                    SetPurchaseClosingNoteUpd();
                    break;
                case MethodPurchaseClosingSendPlanYMDUpd:
                    SetPurchaseClosingSendPlanYMDUpd();
                    break;
                case MethodPurchaseClosingOtherPayUpd:
                    SetPurchaseClosingOtherPayUpd();
                    break;
                case MethodPurchaseClosingOtherPayCnl:
                    SetPurchaseClosingOtherPayCnl();
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
                case MethodHometaxPreMatching:
                    SetHometaxPreMatching();
                    break;
                case MethodPurchaseClosingClientPayList:
                    GetPurchaseClosingClientPayList();
                    break;
                case MethodPurchaseClosingClientPayListExcel:
                    GetPurchaseClosingClientPayListExcel();
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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 매입 전표 목록
    /// </summary>
    protected void GetPurchaseClosingList()
    {
        ReqPurchaseClosingList                lo_objReqPurchaseClosingList = null;
        ServiceResult<ResPurchaseClosingList> lo_objResPurchaseClosingList = null;

        if(objSes.GradeCode > 2){
            if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
            {
                objResMap.RetCode = 9001;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
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
                SendType              = strSendType.ToInt(),
                SendStatus            = strSendStatus.ToInt(),
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                CarNo                 = strCarNo,
                DriverName            = strDriverName,
                DriverCell            = strDriverCell,
                ClosingAdminName      = strClosingAdminName,
                InsureFlag            = strInsureFlag,
                AccessCenterCode      = objSes.AccessCenterCode,
                PageSize              = intPageSize,
                PageNo                = intPageNo
            };

            lo_objResPurchaseClosingList = objPurchaseDasServices.GetPurchaseClosingList(lo_objReqPurchaseClosingList);
            objResMap.strResponse        = "[" + JsonConvert.SerializeObject(lo_objResPurchaseClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 전표 목록 엑셀
    /// </summary>
    protected void GetPurchaseClosingListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

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
                SendType              = strSendType.ToInt(),
                SendStatus            = strSendStatus.ToInt(),
                ComName               = strComName,
                ComCorpNo             = strComCorpNo,
                CarNo                 = strCarNo,
                DriverName            = strDriverName,
                DriverCell            = strDriverCell,
                ClosingAdminName      = strClosingAdminName,
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
            lo_dtData.Columns.Add(new DataColumn("과세변경일",   typeof(string)));

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
            lo_dtData.Columns.Add(new DataColumn("최종상차일",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발행상태",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발행구분",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서작성일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서발행일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("국세청승인번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("은행명",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계좌번호(끝4자리)", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("예금주",        typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("결제방식",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금상태",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금예정일",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("실제송금일",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금-은행명",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금-계좌번호(끝4자리)", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금-예금주",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("메모",            typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감자",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감일시",          typeof(string)));
            
            foreach (var row in lo_objResPurchaseClosingList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.PurchaseClosingSeqNo,row.ComName,row.ComCorpNo,row.ComKindM
                    ,row.ComCeoName,row.ComStatusM,row.ComTaxKindM,row.ComTaxMsg,row.ComUpdYMD
                    ,row.CardAgreeFlag,row.CardAgreeYMD,row.OrgAmt,row.SupplyAmt,row.TaxAmt
                    ,row.DeductAmt,row.InputDeductAmt,row.DeductReason,row.InsureFlag,row.DriverInsureAmt
                    ,row.SendAmt,row.PickupYMDTo,row.BillStatusM,row.BillKindM,row.BillWrite
                    ,row.BillYMD,row.NtsConfirmNum,row.BankName,row.SearchAcctNo,row.AcctName
                    ,row.SendTypeM,row.SendStatusM,row.SendPlanYMD,row.SendYMD,row.SendBankName
                    ,row.SendSearchAcctNo,row.SendAcctName,row.Note,row.ClosingAdminName,row.ClosingDate);
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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 전표 오더 목록
    /// </summary>
    protected void GetPurchaseClosingPayList()
    {
        ReqPurchaseClosingPayList                lo_objReqPurchaseClosingPayList = null;
        ServiceResult<ResPurchaseClosingPayList> lo_objResPurchaseClosingPayList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo) || strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingPayList = new ReqPurchaseClosingPayList
            {
                CenterCode           = strCenterCode.ToInt(),
                PurchaseClosingSeqNo = strPurchaseClosingSeqNo.ToInt64(),
                AccessCenterCode     = objSes.AccessCenterCode
            };

            lo_objResPurchaseClosingPayList = objPurchaseDasServices.GetPurchaseClosingPayList(lo_objReqPurchaseClosingPayList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseClosingPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 전표 오더 엑셀
    /// </summary>
    protected void GetPurchaseClosingPayListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqPurchaseClosingPayList                lo_objReqPurchaseClosingPayList = null;
        ServiceResult<ResPurchaseClosingPayList> lo_objResPurchaseClosingPayList = null;
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

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo) || strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingPayList = new ReqPurchaseClosingPayList
            {
                CenterCode           = strCenterCode.ToInt(),
                PurchaseClosingSeqNo = strPurchaseClosingSeqNo.ToInt64(),
                AccessCenterCode     = objSes.AccessCenterCode
            };

            lo_objResPurchaseClosingPayList = objPurchaseDasServices.GetPurchaseClosingPayList(lo_objReqPurchaseClosingPayList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서발행상태", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서종류",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("국세청승인번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("결제방식",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금상태",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금예정일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("실제송금일",   typeof(string)));
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

            lo_dtData.Columns.Add(new DataColumn("하차요청일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("H/AWB",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("M/AWB",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총수량",     typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총부피",     typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총중량",     typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("매입합계",      typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",     typeof(double)));
                
            lo_dtData.Columns.Add(new DataColumn("산재보험대상", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("산재보험신고", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량구분",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량업체명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업자번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량번호",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사휴대폰",  typeof(string)));

            foreach (var row in lo_objResPurchaseClosingPayList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName, row.OrderNo, row.BillStatusM, row.BillKindM, row.NtsConfirmNum
                    ,row.SendTypeM,row.SendStatusM,row.SendPlanYMD,row.SendYMD,row.PurchaseClosingSeqNo
                    ,row.ClosingAdminName,row.ClosingDate,row.OrderItemCodeM,row.OrderLocationCodeM,row.DeliveryLocationCodeM
                    ,row.OrderClientName,row.PayClientName,row.ConsignorName,row.PickupYMD,row.PickupPlace
                    ,row.GetYMD,row.GetPlace,row.Hawb,row.Mawb,row.Volume
                    ,row.CBM,row.Weight,row.PurchaseOrgAmt,row.PurchaseSupplyAmt,row.PurchaseTaxAmt
                    ,row.InsureTargetFlag,row.InsureExceptKindM,row.CarDivTypeM,row.ComName,row.ComCorpNo
                    ,row.CarNo,row.DriverName,row.DriverCell
                );
            }

            lo_objExcel = new SpreadSheet {SheetName = "PurchaseClosingPayList"};

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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감 메모 등록
    /// </summary>
    protected void SetPurchaseClosingNoteUpd()
    {
        ReqPurchaseClosingNoteUpd lo_objReqPurchaseClosingNoteUpd = null;
        ServiceResult<bool>       lo_objResPurchaseClosingNoteUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo) || strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingNoteUpd = new ReqPurchaseClosingNoteUpd
            {
                CenterCode           = strCenterCode.ToInt(),
                PurchaseClosingSeqNo = strPurchaseClosingSeqNo.ToInt64(),
                Note                 = strNote,
                UpdAdminID           = objSes.AdminID,
                UpdAdminName         = objSes.AdminName
            };

            lo_objResPurchaseClosingNoteUpd = objPurchaseDasServices.SetPurchaseClosingNoteUpd(lo_objReqPurchaseClosingNoteUpd);
            objResMap.RetCode         = lo_objResPurchaseClosingNoteUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPurchaseClosingNoteUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감 송금예정일 등록
    /// </summary>
    protected void SetPurchaseClosingSendPlanYMDUpd()
    {
        ReqPurchaseClosingSendInfoUpd lo_objReqPurchaseClosingSendInfoUpd = null;
        ServiceResult<bool>           lo_objResPurchaseClosingSendInfoUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSendPlanYMD))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingSendInfoUpd = new ReqPurchaseClosingSendInfoUpd
            {
                CenterCode           = strCenterCode.ToInt(),
                PurchaseClosingSeqNo = strPurchaseClosingSeqNos,
                SendStatus           = 1, //송금 상태 (1: 미송금, 2 :송금신청. 3: 송금완료) 
                SendType             = 1, //결제 유형(1 : 미선택, 2:일반입금, 3: 빠른입금(차), 4:빠른입금(운) - 바로지급, 5:빠른입금(운) - 14일지급, 6:수기송금, 7 : 카드결제)
                ReqYMD               = strSendPlanYMD,
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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감 별도 송금
    /// </summary>
    protected void SetPurchaseClosingOtherPayUpd()
    {
        ReqPurchaseClosingSendInfoUpd lo_objReqPurchaseClosingSendInfoUpd = null;
        ServiceResult<bool>           lo_objResPurchaseClosingSendInfoUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSendPlanYMD))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingSendInfoUpd = new ReqPurchaseClosingSendInfoUpd
            {
                CenterCode           = strCenterCode.ToInt(),
                PurchaseClosingSeqNo = strPurchaseClosingSeqNos,
                SendStatus           = 3, //송금 상태 (1: 미송금, 2 :송금신청. 3: 송금완료) 
                SendType             = 6, //결제 유형(1 : 미선택, 2:일반입금, 3: 빠른입금(차), 4:빠른입금(운) - 바로지급, 5:빠른입금(운) - 14일지급, 6:수기송금, 7 : 카드결제)
                ReqYMD               = strSendPlanYMD,
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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매입 마감 별도 송금 취소
    /// </summary>
    protected void SetPurchaseClosingOtherPayCnl()
    {
        ReqPurchaseClosingSendInfoUpd lo_objReqPurchaseClosingSendInfoUpd = null;
        ServiceResult<bool>           lo_objResPurchaseClosingSendInfoUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingSendInfoUpd = new ReqPurchaseClosingSendInfoUpd
            {
                CenterCode           = strCenterCode.ToInt(),
                PurchaseClosingSeqNo = strPurchaseClosingSeqNos,
                SendStatus           = 1, //송금 상태 (1: 미송금, 2 :송금신청. 3: 송금완료) 
                SendType             = 1, //결제 유형(1 : 미선택, 2:일반입금, 3: 빠른입금(차), 4:빠른입금(운) - 바로지급, 5:빠른입금(운) - 14일지급, 6:수기송금, 7 : 카드결제)
                ReqYMD               = string.Empty,
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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
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
        string                                  lo_strFROM_YMD                 = DateTime.Now.AddMonths(-2).ToString("yyyyMMdd");
        string                                  lo_strTO_YMD                   = DateTime.Now.ToString("yyyyMMdd");

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
                PAGE_NO           = intPageNo,
                ORG_AMT           = strPurchaseOrgAmt.ToDouble()
            };

            lo_objResApproveHometaxApiList = objCargopayDasServices.GetApproveHometaxApiList(lo_objReqApproveHometaxApiList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResApproveHometaxApiList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 계산서 매칭
    /// </summary>
    protected void SetHometaxPreMatching()
    {
        ReqPreMatchingIns             lo_objReqPreMatchingIns             = null;
        ServiceResult<bool>           lo_objResPreMatchingIns             = null;
        ReqPurchaseClosingBillInfoUpd lo_objReqPurchaseClosingBillInfoUpd = null;
        ServiceResult<bool>           lo_objResPurchaseClosingBillInfoUpd = null;
            
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

        if (string.IsNullOrWhiteSpace(strNtsConfirmNum))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

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

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPreMatchingIns.result.ErrorMsg;
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqPurchaseClosingBillInfoUpd = new ReqPurchaseClosingBillInfoUpd
            {
                CenterCode            = strCenterCode.ToInt(),
                PurchaseClosingSeqNos = strPurchaseClosingSeqNo,
                BillStatus            = 3,
                BillKind              = strBillKind.ToInt(),
                BillWrite             = strBillWrite,
                BillYMD               = strBillYMD,
                NtsConfirmNum         = strNtsConfirmNum,
                ChkPermFlag           = "Y",
                UpdAdminID            = objSes.AdminID,
                UpdAdminName          = objSes.AdminName
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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    

    /// <summary>
    /// 업체 매입 전표 오더 목록 
    /// </summary>
    protected void GetPurchaseClosingClientPayList()
    {
        ReqPurchaseClosingClientPayList                lo_objReqPurchaseClosingClientPayList = null;
        ServiceResult<ResPurchaseClosingClientPayList> lo_objResPurchaseClosingClientPayList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo) || strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingClientPayList = new ReqPurchaseClosingClientPayList
            {
                CenterCode           = strCenterCode.ToInt(),
                PurchaseClosingSeqNo = strPurchaseClosingSeqNo.ToInt64(),
                AccessCenterCode     = objSes.AccessCenterCode
            };

            lo_objResPurchaseClosingClientPayList = objPurchaseDasServices.GetPurchaseClosingClientPayList(lo_objReqPurchaseClosingClientPayList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResPurchaseClosingClientPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 업체매입 전표 오더 엑셀
    /// </summary>
    protected void GetPurchaseClosingClientPayListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;
            
        ReqPurchaseClosingClientPayList                lo_objReqPurchaseClosingClientPayList = null;
        ServiceResult<ResPurchaseClosingClientPayList> lo_objResPurchaseClosingClientPayList = null;
        string                                         lo_strFileName                        = "";
        SpreadSheet                                    lo_objExcel                           = null;
        DataTable                                      lo_dtData                             = null;
        MemoryStream                                   lo_outputStream                       = null;
        byte[]                                         lo_Content                            = null;
        int                                            lo_intColumnIndex                     = 0;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPurchaseClosingSeqNo) || strPurchaseClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPurchaseClosingClientPayList = new ReqPurchaseClosingClientPayList
            {
                CenterCode           = strCenterCode.ToInt(),
                PurchaseClosingSeqNo = strPurchaseClosingSeqNo.ToInt64(),
                AccessCenterCode     = objSes.AccessCenterCode
            };

            lo_objResPurchaseClosingClientPayList = objPurchaseDasServices.GetPurchaseClosingClientPayList(lo_objReqPurchaseClosingClientPayList);

            lo_dtData = new DataTable();
            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서발행상태", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("계산서종류",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("국세청승인번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("결제방식",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금상태",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("송금예정일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("실제송금일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("전표번호",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("마감자",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("마감일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청일", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("하차지",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("H/AWB", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("M/AWB", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총수량",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총부피",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총중량",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("매입합계",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("공급가액",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("부가세",   typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("사업자명",  typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("사업자번호", typeof(string)));

            foreach (var row in lo_objResPurchaseClosingClientPayList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName, row.OrderNo, row.BillStatusM, row.BillKindM, row.NtsConfirmNum
                    ,row.SendTypeM,row.SendStatusM,row.SendPlanYMD,row.SendYMD,row.PurchaseClosingSeqNo
                    ,row.ClosingAdminName,row.ClosingDate,row.OrderItemCodeM,row.OrderLocationCodeM,row.OrderClientName
                    ,row.PayClientName,row.ConsignorName,row.PickupYMD,row.PickupPlace,row.GetYMD
                    ,row.GetPlace,row.Hawb,row.Mawb,row.Volume,row.CBM
                    ,row.Weight,row.PurchaseOrgAmt,row.PurchaseSupplyAmt,row.PurchaseTaxAmt,row.ClientName
                    ,row.ClientCorpNo
                );
            }

            lo_objExcel = new SpreadSheet {SheetName = "PurchaseClosingClientPayList"};

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

            SiteGlobal.WriteLog("PurchaseClosingHandler", "Exception",
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