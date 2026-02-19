<%@ WebHandler Language="C#" Class="DepositHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;
using Newtonsoft.Json;
using System.Data;
using System.IO;
using DocumentFormat.OpenXml.Spreadsheet;

///================================================================
/// <summary>
/// FileName        : DepositHandler.ashx
/// Description     : 미수관리 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-09-26
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class DepositHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/ClosingSaleDeposit/DepositList"; //필수

    // 메소드 리스트
    private const string MethodDepositClientList      = "DepositClientList";      //미수 업체 목록
    private const string MethodDepositClientTotalList = "DepositClientTotalList"; //미수 목록
    private const string MethodDepositSaleList        = "DepositSaleList";        //매출마감 목록
    private const string MethodDepositDetailList      = "DepositDetailList";      //입금 목록
    private const string MethodDepositDetailListExcel = "DepositDetailListExcel"; //입금 목록
    private const string MethodDepositIns             = "DepositInsert";          //입금 등록
    private const string MethodDepositUpd             = "DepositUpdate";          //입금 수정
    private const string MethodDepositMonthUpd        = "DepositMonthUpdate";     //입금 연월 수정
    private const string MethodDepositDel             = "DepositDelete";          //입금 삭제
    private const string MethodClientList             = "ClientList";             //고객사 조회
    private const string MethodClientMisuUpd          = "ClientMisuUpdate";       //고객사 미수금 업데이트
    private const string MethodMatchingIns            = "MatchingInsert";         //매칭 등록
    private const string MethodMatchingDel            = "MatchingDelete";         //매칭 해제
    private const string MethodDepositExcelChk        = "DepositExcelChk";        //입금 엑셀 체크

    DepositDasServices  objDepositDasServices = new DepositDasServices();
    ClientDasServices   objClientDasServices  = new ClientDasServices();
    private HttpContext objHttpContext        = null;

    private string strCallType             = string.Empty;
    private int    intPageSize             = 0;
    private int    intPageNo               = 0;
    private string strCenterCode           = string.Empty;
    private string strClientCode           = string.Empty;
    private string strClientName           = string.Empty;
    private string strDateFrom             = string.Empty;
    private string strDateTo               = string.Empty;
    private string strDepositYMD           = string.Empty;
    private string strDepositYM            = string.Empty;
    private string strDepositAmt           = string.Empty;
    private string strDepositType          = string.Empty;
    private string strDepositNote          = string.Empty;
    private string strDepositClosingSeqNos = string.Empty;
    private string strDepositClosingSeqNo  = string.Empty;
    private string strDepositTypes         = string.Empty;
    private string strChargeOrderFlag      = string.Empty;
    private string strChargePayFlag        = string.Empty;
    private string strChargeBillFlag       = string.Empty;
    private string strClientFlag           = string.Empty;
    private string strChargeFlag           = string.Empty;
    private string strCsAdminName          = string.Empty;
    private string strCsClosingAdminName   = string.Empty;
    private string strSaleClosingSeqNos    = string.Empty;
    private string strSaleClosingSeqNo     = string.Empty;
    private string strMatchingClosingSeqNo = string.Empty;
    private string strNoMatchingFlag       = string.Empty;
    private string strDepositFlag          = string.Empty;
    private string strClientCorpNo         = string.Empty;
    private string strInputYMD             = string.Empty;
    private string strInputYM              = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodDepositClientList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDepositClientTotalList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDepositSaleList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDepositDetailList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDepositDetailListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodDepositIns,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDepositUpd,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDepositMonthUpd,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDepositDel,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientMisuUpd,          MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodMatchingIns,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodMatchingDel,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDepositExcelChk,        MenuAuthType.ReadOnly);
            
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

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("DepositHandler");
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
            strCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strDateFrom             = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo               = SiteGlobal.GetRequestForm("DateTo");
            strClientName           = SiteGlobal.GetRequestForm("ClientName");
            strDepositYMD           = SiteGlobal.GetRequestForm("DepositYMD");
            strDepositYM            = SiteGlobal.GetRequestForm("DepositYM");
            strDepositAmt           = Utils.IsNull(SiteGlobal.GetRequestForm("DepositAmt"), "0");
            strDepositType          = SiteGlobal.GetRequestForm("DepositType");
            strDepositNote          = SiteGlobal.GetRequestForm("DepositNote");
            strDepositClosingSeqNos = SiteGlobal.GetRequestForm("DepositClosingSeqNos");
            strDepositClosingSeqNo  = Utils.IsNull(SiteGlobal.GetRequestForm("DepositClosingSeqNo"), "0");
            strDepositTypes         = SiteGlobal.GetRequestForm("DepositTypes");
            strChargeOrderFlag      = SiteGlobal.GetRequestForm("ChargeOrderFlag");
            strChargePayFlag        = SiteGlobal.GetRequestForm("ChargePayFlag");
            strChargeBillFlag       = SiteGlobal.GetRequestForm("ChargeBillFlag");
            strClientFlag           = SiteGlobal.GetRequestForm("ClientFlag");
            strChargeFlag           = SiteGlobal.GetRequestForm("ChargeFlag");
            strCsAdminName          = SiteGlobal.GetRequestForm("CsAdminName");
            strCsClosingAdminName   = SiteGlobal.GetRequestForm("CsClosingAdminName");
            strSaleClosingSeqNos    = SiteGlobal.GetRequestForm("SaleClosingSeqNos");
            strSaleClosingSeqNo     = Utils.IsNull(SiteGlobal.GetRequestForm("SaleClosingSeqNo"),     "0");
            strMatchingClosingSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("MatchingClosingSeqNo"), "0");
            strNoMatchingFlag       = SiteGlobal.GetRequestForm("NoMatchingFlag");
            strDepositFlag          = Utils.IsNull(SiteGlobal.GetRequestForm("DepositFlag"), "N");
            strClientCorpNo         = SiteGlobal.GetRequestForm("ClientCorpNo");
            strInputYMD             = SiteGlobal.GetRequestForm("InputYMD");
            strInputYM              = SiteGlobal.GetRequestForm("InputYM");
            
            strDateFrom     = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo       = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
            strDepositYMD   = string.IsNullOrWhiteSpace(strDepositYMD) ? strDepositYMD : strDepositYMD.Replace("-", "");
            strDepositYM    = string.IsNullOrWhiteSpace(strDepositYM) ? strDepositYM : strDepositYM.Replace("-", "");
            strClientCorpNo = string.IsNullOrWhiteSpace(strClientCorpNo) ? strClientCorpNo : strClientCorpNo.Replace("-", "");
            strInputYMD     = string.IsNullOrWhiteSpace(strInputYMD) ? strInputYMD : strInputYMD.Replace("-", "");
            strInputYM      = string.IsNullOrWhiteSpace(strInputYM) ? strInputYM : strInputYM.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
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
                case MethodDepositClientList:
                    GetDepositClientList();
                    break;
                case MethodDepositClientTotalList:
                    GetDepositClientTotalList();
                    break;
                case MethodDepositSaleList:
                    GetDepositSaleList();
                    break;
                case MethodDepositDetailList:
                    GetDepositDetailList();
                    break;
                case MethodDepositDetailListExcel:
                    GetDepositDetailListExcel();
                    break;
                case MethodDepositIns:
                    SetDepositIns();
                    break;
                case MethodDepositUpd:
                    SetDepositUpd();
                    break;
                case MethodDepositMonthUpd:
                    SetDepositMonthUpd();
                    break;
                case MethodDepositDel:
                    SetDepositDel();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodClientMisuUpd:
                    SetClientMisuUpd();
                    break;
                case MethodMatchingIns:
                    SetMatchingIns();
                    break;
                case MethodMatchingDel:
                    SetMatchingDel();
                    break;
                case MethodDepositExcelChk:
                    GetDepositExcelChk();
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

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 미수 업체 목록
    /// </summary>
    protected void GetDepositClientList()
    {
        ReqDepositClientList                lo_objReqDepositClientList = null;
        ServiceResult<ResDepositClientList> lo_objResDepositClientList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqDepositClientList = new ReqDepositClientList
            {
                CenterCode         = strCenterCode.ToInt(),
                ClientName         = strClientName,
                CsAdminName        = strCsAdminName,
                CsClosingAdminName = strCsClosingAdminName,
                AccessCenterCode   = objSes.AccessCenterCode
            };

            lo_objResDepositClientList = objDepositDasServices.GetDepositClientList(lo_objReqDepositClientList);
            objResMap.strResponse      = "[" + JsonConvert.SerializeObject(lo_objResDepositClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 미수 목록
    /// </summary>
    protected void GetDepositClientTotalList()
    {
        ReqDepositClientTotalList                lo_objReqDepositClientTotalList = null;
        ServiceResult<ResDepositClientTotalList> lo_objResDepositClientTotalList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqDepositClientTotalList = new ReqDepositClientTotalList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt64(),
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResDepositClientTotalList = objDepositDasServices.GetDepositClientTotalList(lo_objReqDepositClientTotalList);
            objResMap.strResponse           = "[" + JsonConvert.SerializeObject(lo_objResDepositClientTotalList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매출마감 목록
    /// </summary>
    protected void GetDepositSaleList()
    {
        ReqDepositClosingList                lo_objReqDepositClosingList = null;
        ServiceResult<ResDepositClosingList> lo_objResDepositClosingList = null;
        int                                  lo_intDateType              = 9;
        string                               lo_strClosingKinds          = string.Empty;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
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

        strDateFrom = strDateFrom.Substring(0, 6) + "01";
        strDateTo   = strDateTo.Substring(0, 6) + "31";

        try
        {
            lo_objReqDepositClosingList = new ReqDepositClosingList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt64(),
                DateType         = lo_intDateType,
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                ClosingKinds     = lo_strClosingKinds,
                NoMatchingFlag   = strNoMatchingFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResDepositClosingList = objDepositDasServices.GetDepositClosingList(lo_objReqDepositClosingList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResDepositClosingList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 목록
    /// </summary>
    protected void GetDepositDetailList()
    {
        ReqPayDepositList                lo_objReqPayDepositList = null;
        ServiceResult<ResPayDepositList> lo_objResPayDepositList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
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

        strDateFrom = strDateFrom.Substring(0, 6) + "01";
        strDateTo   = strDateTo.Substring(0, 6) + "31";

        try
        {
            lo_objReqPayDepositList = new ReqPayDepositList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt64(),
                DepositTypes     = strDepositTypes,
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                NoMatchingFlag   = strNoMatchingFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResPayDepositList = objDepositDasServices.GetPayDepositList(lo_objReqPayDepositList);
            objResMap.strResponse   = "[" + JsonConvert.SerializeObject(lo_objResPayDepositList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 목록 엑셀
    /// </summary>
    protected void GetDepositDetailListExcel()
    {
        ReqPayDepositList                lo_objReqPayDepositList = null;
        ServiceResult<ResPayDepositList> lo_objResPayDepositList = null;
        string                           lo_strFileName          = "";
        SpreadSheet                      lo_objExcel             = null;
        DataTable                        lo_dtData               = null;
        MemoryStream                     lo_outputStream         = null;
        byte[]                           lo_Content              = null;
        int                              lo_intColumnIndex       = 0;


        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
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

        strDateFrom = strDateFrom.Substring(0, 6) + "01";
        strDateTo   = strDateTo.Substring(0, 6) + "31";

        try
        {
            lo_objReqPayDepositList = new ReqPayDepositList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt64(),
                DepositTypes     = strDepositTypes,
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                NoMatchingFlag   = strNoMatchingFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResPayDepositList = objDepositDasServices.GetPayDepositList(lo_objReqPayDepositList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금전표번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("매칭전표번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금구분",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금액",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("입금업체명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금비고",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금등록일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입금등록자",  typeof(string)));

            foreach (var row in lo_objResPayDepositList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName, row.DepositClosingSeqNo, row.MatchingClosingSeqNo, row.DepositTypeM, row.InputYMD
                    ,row.Amt, row.ClientName, row.Note, row.RegDate, row.RegAdminName);
            }

            lo_objExcel = new SpreadSheet { SheetName = "DepositList" };

            lo_objExcel.FreezeCell(1);
            lo_objExcel.InsertDataTable(lo_dtData, true, 1, 1, true, false, System.Drawing.Color.LightGray,
                HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
            lo_objExcel.SetBorder(BorderStyleValues.Thin, System.Drawing.Color.Black);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
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

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 등록
    /// </summary>
    protected void SetDepositIns()
    {
        PayDepositModel                lo_objPayDepositModel  = null;
        ServiceResult<PayDepositModel> lo_objResPayDepositIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositYMD))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositYM))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositAmt) || strDepositAmt.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositType) || strDepositType.Equals("0"))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objPayDepositModel = new PayDepositModel
            {
                CenterCode        = strCenterCode.ToInt(),
                ClientCode        = strClientCode.ToInt64(),
                ClientName        = strClientName,
                DepositType       = strDepositType.ToInt(),
                InputYMD          = strDepositYMD,
                InputYM           = strDepositYM,
                Amt               = strDepositAmt.ToDouble(),
                Note              = strDepositNote,
                SaleClosingSeqNos = strSaleClosingSeqNos,
                RegAdminID        = objSes.AdminID,
                RegAdminName      = objSes.AdminName
            };

            lo_objResPayDepositIns = objDepositDasServices.SetPayDepositIns(lo_objPayDepositModel);
            objResMap.RetCode      = lo_objResPayDepositIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayDepositIns.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("DepositClosingSeqNo", lo_objResPayDepositIns.data.DepositClosingSeqNo.ToString());
            objResMap.Add("DepositSeqNo",        lo_objResPayDepositIns.data.DepositSeqNo.ToString());
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 수정
    /// </summary>
    protected void SetDepositUpd()
    {
        PayDepositModel     lo_objPayDepositModel  = null;
        ServiceResult<bool> lo_objResPayDepositUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositClosingSeqNo) || strDepositClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositYMD))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositYM))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositAmt) || strDepositAmt.Equals("0"))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositType) || strDepositType.Equals("0"))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objPayDepositModel = new PayDepositModel
            {
                CenterCode          = strCenterCode.ToInt(),
                DepositClosingSeqNo = strDepositClosingSeqNo.ToInt64(),
                ClientCode          = strClientCode.ToInt64(),
                ClientName          = strClientName,
                DepositType         = strDepositType.ToInt(),
                InputYMD            = strDepositYMD,
                InputYM             = strDepositYM,
                Amt                 = strDepositAmt.ToDouble(),
                Note                = strDepositNote,
                UpdAdminID          = objSes.AdminID,
                UpdAdminName        = objSes.AdminName
            };

            lo_objResPayDepositUpd = objDepositDasServices.SetPayDepositUpd(lo_objPayDepositModel);
            objResMap.RetCode      = lo_objResPayDepositUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayDepositUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 연월 수정
    /// </summary>
    protected void SetDepositMonthUpd()
    {
        PayDepositModel     lo_objPayDepositModel       = null;
        ServiceResult<bool> lo_objResPayDepositMonthUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositClosingSeqNo) || strDepositClosingSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositYM))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objPayDepositModel = new PayDepositModel
            {
                CenterCode          = strCenterCode.ToInt(),
                ClientCode          = strClientCode.ToInt64(),
                DepositClosingSeqNo = strDepositClosingSeqNo.ToInt64(),
                InputYM             = strDepositYM,
                UpdAdminID          = objSes.AdminID,
                UpdAdminName        = objSes.AdminName
            };

            lo_objResPayDepositMonthUpd = objDepositDasServices.SetPayDepositMonthUpd(lo_objPayDepositModel);
            objResMap.RetCode           = lo_objResPayDepositMonthUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayDepositMonthUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금 삭제
    /// </summary>
    protected void SetDepositDel()
    {
        PayDepositModel     lo_objPayDepositModel  = null;
        ServiceResult<bool> lo_objResPayDepositDel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositClosingSeqNos))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objPayDepositModel = new PayDepositModel
            {
                CenterCode           = strCenterCode.ToInt(),
                DepositClosingSeqNos = strDepositClosingSeqNos,
                DelAdminID           = objSes.AdminID,
                DelAdminName         = objSes.AdminName
            };

            lo_objResPayDepositDel = objDepositDasServices.SetPayDepositDel(lo_objPayDepositModel);
            objResMap.RetCode      = lo_objResPayDepositDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayDepositDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 목록
    /// </summary>
    protected void GetClientList()
    {
        ReqClientSearchList                lo_objReqClientSearchList = null;
        ServiceResult<ResClientSearchList> lo_objResClientSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientName))
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
                ClientName       = strClientName,
                UseFlag          = "Y",
                ChargeOrderFlag  = strChargeOrderFlag,
                ChargePayFlag    = strChargePayFlag,
                ChargeBillFlag   = strChargeBillFlag,
                ChargeUseFlag    = "Y",
                ClientFlag       = strClientFlag,
                ChargeFlag       = strChargeFlag,
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

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 미수금 업데이트
    /// </summary>
    protected void SetClientMisuUpd()
    {
        ReqClientMisuUpd                lo_objReqClientMisuUpd = null;
        ServiceResult<ResClientMisuUpd> lo_objResClientMisuUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientMisuUpd = new ReqClientMisuUpd
            {
                CenterCode = strCenterCode.ToInt(),
                ClientCode = strClientCode.ToInt64(),
                AdminID    = objSes.AdminID
            };

            lo_objResClientMisuUpd = objClientDasServices.SetClientMisuUpd(lo_objReqClientMisuUpd);
            objResMap.RetCode      = lo_objResClientMisuUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientMisuUpd.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("CenterCode",    strCenterCode);
            objResMap.Add("ClientCode",    strClientCode);
            objResMap.Add("MisuFlag",      lo_objResClientMisuUpd.data.MisuFlag);
            objResMap.Add("TotalMisuAmt",  lo_objResClientMisuUpd.data.TotalMisuAmt);
            objResMap.Add("MisuAmt",       lo_objResClientMisuUpd.data.MisuAmt);
            objResMap.Add("NoMatchingCnt", lo_objResClientMisuUpd.data.NoMatchingCnt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매칭 등록
    /// </summary>
    protected void SetMatchingIns()
    {
        ReqPayMatchingIns                lo_objReqPayMatchingIns = null;
        ServiceResult<ResPayMatchingIns> lo_objResPayMatchingIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSaleClosingSeqNos))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDepositClosingSeqNos))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPayMatchingIns = new ReqPayMatchingIns
            {
                CenterCode           = strCenterCode.ToInt(),
                ClientCode           = strClientCode.ToInt64(),
                SaleClosingSeqNos    = strSaleClosingSeqNos,
                DepositClosingSeqNos = strDepositClosingSeqNos,
                RegAdminID           = objSes.AdminID,
                RegAdminName         = objSes.AdminName
            };

            lo_objResPayMatchingIns = objDepositDasServices.SetPayMatchingIns(lo_objReqPayMatchingIns);
            objResMap.RetCode       = lo_objResPayMatchingIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayMatchingIns.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("MatchingClosingSeqNo", lo_objResPayMatchingIns.data.MatchingClosingSeqNo.ToString());
            objResMap.Add("SaleOrgAmt",           lo_objResPayMatchingIns.data.SaleOrgAmt);
            objResMap.Add("DepositAmt",           lo_objResPayMatchingIns.data.DepositAmt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 매칭 해제
    /// </summary>
    protected void SetMatchingDel()
    {
        ReqPayMatchingDel   lo_objReqPayMatchingDel = null;
        ServiceResult<bool> lo_objResPayMatchingDel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if ((string.IsNullOrWhiteSpace(strMatchingClosingSeqNo) || strMatchingClosingSeqNo.Equals("0"))
            && (string.IsNullOrWhiteSpace(strSaleClosingSeqNo) || strSaleClosingSeqNo.Equals("0"))
            && (string.IsNullOrWhiteSpace(strDepositClosingSeqNo) || strDepositClosingSeqNo.Equals("0")))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPayMatchingDel = new ReqPayMatchingDel
            {
                CenterCode           = strCenterCode.ToInt(),
                ClientCode           = strClientCode.ToInt64(),
                MatchingClosingSeqNo = strMatchingClosingSeqNo.ToInt64(),
                SaleClosingSeqNo     = strSaleClosingSeqNo.ToInt64(),
                DepositClosingSeqNo  = strDepositClosingSeqNo.ToInt64(),
                DepositFlag          = strDepositFlag,
                DelAdminID           = objSes.AdminID, 
                DelAdminName         = objSes.AdminName
            };

            lo_objResPayMatchingDel = objDepositDasServices.SetPayMatchingDel(lo_objReqPayMatchingDel);
            objResMap.RetCode       = lo_objResPayMatchingDel.result.ErrorCode;
            objResMap.ErrMsg        = lo_objResPayMatchingDel.result.ErrorMsg;
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 입금엑셀체크
    /// </summary>
    protected void GetDepositExcelChk()
    {
        ReqPayDepositExcelChk                lo_objReqPayDepositExcelChk = null;
        ServiceResult<ResPayDepositExcelChk> lo_objResPayDepositExcelChk = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strClientCorpNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strInputYMD))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqPayDepositExcelChk = new ReqPayDepositExcelChk
            {
                CenterCode   = strCenterCode.ToInt(),
                ClientCorpNo = strClientCorpNo,
                InputYMD     = strInputYMD,
                AdminID      = objSes.AdminID
            };

            lo_objResPayDepositExcelChk = objDepositDasServices.GetPayDepositExcelChk(lo_objReqPayDepositExcelChk);
            objResMap.RetCode           = lo_objResPayDepositExcelChk.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResPayDepositExcelChk.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("CenterCode",       strCenterCode);
            objResMap.Add("ClientExistsFlag", lo_objResPayDepositExcelChk.data.ClientExistsFlag);
            objResMap.Add("ClientCode",       lo_objResPayDepositExcelChk.data.ClientCode.ToString());
            objResMap.Add("ClientName",       lo_objResPayDepositExcelChk.data.ClientName);
            objResMap.Add("ClientNameSimple", lo_objResPayDepositExcelChk.data.ClientNameSimple);
            objResMap.Add("ClientPayDay",     lo_objResPayDepositExcelChk.data.ClientPayDay);
            objResMap.Add("ClientPayDayM",    lo_objResPayDepositExcelChk.data.ClientPayDayM);
            objResMap.Add("InputYM",          string.IsNullOrWhiteSpace(strInputYM) ? lo_objResPayDepositExcelChk.data.InputYM : strInputYM);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DepositHandler", "Exception",
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
            // ignored
        }
    }
}