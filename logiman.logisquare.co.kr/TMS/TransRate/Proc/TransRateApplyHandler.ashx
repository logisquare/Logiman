<%@ WebHandler Language="C#" Class="TransRateApplyHandler" %>
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
/// FileName        : TransRateApplyHandler.ashx
/// Description     : 요율표 관련
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2023-03-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class TransRateApplyHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/TransRate/TransRateApplyList"; //필수

    // 메소드 리스트
    private const string MethodTransRateList           = "TransRateList";
    private const string MethodTransRateApplyList      = "TransRateApplyList";
    private const string MethodTransRateApplyListExcel = "TransRateApplyListExcel";
    private const string MethodTransRateApplyHistList  = "TransRateApplyHistList";
    private const string MethodTransRateApplyGet       = "TransRateApplyGet";
    private const string MethodClientList              = "ClientList";
    private const string MethodConsignorList           = "ConsignorList";
    private const string MethodTransRateApplyIns       = "TransRateApplyIns";
    private const string MethodTransRateApplyUpd       = "TransRateApplyUpd";
    private const string MethodOilAvgPriceGet          = "OilAvgPriceGet";
    private const string MethodTransRateApplyDel       = "TransRateApplyDel";

    TransRateDasServices objTransRateDasServices = new TransRateDasServices();
    ClientDasServices    objClientDasServices    = new ClientDasServices();
    ConsignorDasServices objConsignorDasServices = new ConsignorDasServices();
    private HttpContext  objHttpContext          = null;

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string strApplySeqNo              = string.Empty;
    private string strTransSeqNo              = string.Empty;
    private string strCenterCode              = string.Empty;
    private string strRateRegKind             = string.Empty;
    private string strRateType                = string.Empty;
    private string strFTLFlag                 = string.Empty;
    private string strDelFlag                 = string.Empty;
    private string strTransRateName           = string.Empty;
    private string strClientCode              = string.Empty;
    private string strConsignorCode           = string.Empty;
    private string strClientName              = string.Empty;
    private string strConsignorName           = string.Empty;
    private string strOrderItemCode           = string.Empty;
    private string strOrderLocationCode       = string.Empty;
    private string strOrderLocationCodes      = string.Empty;
    private string strFtlSPTransSeqNo         = string.Empty;
    private string strFtlSTransSeqNo          = string.Empty;
    private string strFtlPTransSeqNo          = string.Empty;
    private string strFtlPRateFlag            = string.Empty;
    private string strFtlPurchaseRate         = string.Empty;
    private string strFtlFixedPurchaseRate    = string.Empty;
    private string strFtlRoundAmtKind         = string.Empty;
    private string strFtlRoundType            = string.Empty;
    private string strLtlSPTransSeqNo         = string.Empty;
    private string strLtlSTransSeqNo          = string.Empty;
    private string strLtlPTransSeqNo          = string.Empty;
    private string strLtlPRateFlag            = string.Empty;
    private string strLtlPurchaseRate         = string.Empty;
    private string strLtlFixedPurchaseRate    = string.Empty;
    private string strLtlRoundAmtKind         = string.Empty;
    private string strLtlRoundType            = string.Empty;
    private string strLayoverTransSeqNo       = string.Empty;
    private string strOilTransSeqNo           = string.Empty;
    private string strOilPeriodType           = string.Empty;
    private string strOilSearchArea           = string.Empty;
    private string strOilPrice                = string.Empty;
    private string strOilGetPlace1            = string.Empty;
    private string strOilGetPlace2            = string.Empty;
    private string strOilGetPlace3            = string.Empty;
    private string strOilGetPlace4            = string.Empty;
    private string strOilGetPlace5            = string.Empty;
    private string strOilSaleRoundAmtKind     = string.Empty;
    private string strOilSaleRoundType        = string.Empty;
    private string strOilPurchaseRoundAmtKind = string.Empty;
    private string strOilPurchaseRoundType    = string.Empty;
    private string strOilFixedRoundAmtKind    = string.Empty;
    private string strOilFixedRoundType       = string.Empty;
    private string strStdYMD                  = string.Empty;
    private string strOilType                 = string.Empty;
    private string strAvgType                 = string.Empty;
    private string strSido                    = string.Empty;
    private string strUpdType                 = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodTransRateList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateApplyList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateApplyListExcel, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateApplyGet,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateApplyIns,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodTransRateApplyUpd,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOilAvgPriceGet,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateApplyDel,       MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodTransRateApplyHistList,  MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("TransRateApplyHandler");
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
            strApplySeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("ApplySeqNo"),  "0");
            strTransSeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("TransSeqNo"),  "0");
            strCenterCode              = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"),  "0");
            strRateRegKind             = Utils.IsNull(SiteGlobal.GetRequestForm("RateRegKind"), "0");
            strRateType                = Utils.IsNull(SiteGlobal.GetRequestForm("RateType"),    "0");
            strFTLFlag                 = SiteGlobal.GetRequestForm("FTLFlag");
            strDelFlag                 = SiteGlobal.GetRequestForm("DelFlag");
            strTransRateName           = SiteGlobal.GetRequestForm("TransRateName");
            strClientCode              = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"),    "0");
            strConsignorCode           = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strClientName              = SiteGlobal.GetRequestForm("ClientName");
            strConsignorName           = SiteGlobal.GetRequestForm("ConsignorName");
            strOrderItemCode           = SiteGlobal.GetRequestForm("OrderItemCode");
            strOrderLocationCode       = SiteGlobal.GetRequestForm("OrderLocationCode");
            strOrderLocationCodes      = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strFtlSPTransSeqNo         = Utils.IsNull(SiteGlobal.GetRequestForm("FtlSPTransSeqNo"), "0");
            strFtlSTransSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("FtlSTransSeqNo"),  "0");
            strFtlPTransSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("FtlPTransSeqNo"),  "0");
            strFtlPRateFlag            = SiteGlobal.GetRequestForm("FtlPRateFlag");
            strFtlPurchaseRate         = Utils.IsNull(SiteGlobal.GetRequestForm("FtlPurchaseRate"),      "0");
            strFtlFixedPurchaseRate    = Utils.IsNull(SiteGlobal.GetRequestForm("FtlFixedPurchaseRate"), "0");
            strFtlRoundAmtKind         = Utils.IsNull(SiteGlobal.GetRequestForm("FtlRoundAmtKind"),      "0");
            strFtlRoundType            = SiteGlobal.GetRequestForm("FtlRoundType");
            strLtlSPTransSeqNo         = Utils.IsNull(SiteGlobal.GetRequestForm("LtlSPTransSeqNo"), "0");
            strLtlSTransSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("LtlSTransSeqNo"),  "0");
            strLtlPTransSeqNo          = Utils.IsNull(SiteGlobal.GetRequestForm("LtlPTransSeqNo"),  "0");
            strLtlPRateFlag            = SiteGlobal.GetRequestForm("LtlPRateFlag");
            strLtlPurchaseRate         = Utils.IsNull(SiteGlobal.GetRequestForm("LtlPurchaseRate"),      "0");
            strLtlFixedPurchaseRate    = Utils.IsNull(SiteGlobal.GetRequestForm("LtlFixedPurchaseRate"), "0");
            strLtlRoundAmtKind         = Utils.IsNull(SiteGlobal.GetRequestForm("LtlRoundAmtKind"),      "0");
            strLtlRoundType            = SiteGlobal.GetRequestForm("LtlRoundType");
            strLayoverTransSeqNo       = Utils.IsNull(SiteGlobal.GetRequestForm("LayoverTransSeqNo"), "0");
            strOilTransSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("OilTransSeqNo"),     "0");
            strOilPeriodType           = Utils.IsNull(SiteGlobal.GetRequestForm("OilPeriodType"),     "0");
            strOilSearchArea           = SiteGlobal.GetRequestForm("OilSearchArea");
            strOilPrice                = Utils.IsNull(SiteGlobal.GetRequestForm("OilPrice"), "0");
            strOilGetPlace1            = SiteGlobal.GetRequestForm("OilGetPlace1");
            strOilGetPlace2            = SiteGlobal.GetRequestForm("OilGetPlace2");
            strOilGetPlace3            = SiteGlobal.GetRequestForm("OilGetPlace3");
            strOilGetPlace4            = SiteGlobal.GetRequestForm("OilGetPlace4");
            strOilGetPlace5            = SiteGlobal.GetRequestForm("OilGetPlace5");
            strOilSaleRoundAmtKind     = Utils.IsNull(SiteGlobal.GetRequestForm("OilSaleRoundAmtKind"), "0");
            strOilSaleRoundType        = SiteGlobal.GetRequestForm("OilSaleRoundType");
            strOilPurchaseRoundAmtKind = Utils.IsNull(SiteGlobal.GetRequestForm("OilPurchaseRoundAmtKind"), "0");
            strOilPurchaseRoundType    = SiteGlobal.GetRequestForm("OilPurchaseRoundType");
            strOilFixedRoundAmtKind    = Utils.IsNull(SiteGlobal.GetRequestForm("OilFixedRoundAmtKind"), "0");
            strOilFixedRoundType       = SiteGlobal.GetRequestForm("OilFixedRoundType");
            strStdYMD                  = SiteGlobal.GetRequestForm("StdYMD");
            strOilType                 = Utils.IsNull(SiteGlobal.GetRequestForm("OilType"), "0");
            strAvgType                 = Utils.IsNull(SiteGlobal.GetRequestForm("AvgType"), "0");
            strSido                    = SiteGlobal.GetRequestForm("Sido");
            strUpdType                 = Utils.IsNull(SiteGlobal.GetRequestForm("UpdType"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
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
                case MethodTransRateList:
                    GetTransRateList();
                    break;
                case MethodTransRateApplyList:
                    GetTransRateApplyList();
                    break;
                case MethodTransRateApplyListExcel:
                    GetTransRateApplyListExcel();
                    break;
                case MethodTransRateApplyGet:
                    GetTransRateApplyGet();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodConsignorList:
                    GetConsignorList();
                    break;
                case MethodTransRateApplyIns:
                    GetTransRateApplyIns();
                    break;
                case MethodTransRateApplyUpd:
                    GetTransRateApplyUpd();
                    break;
                case MethodOilAvgPriceGet:
                    GetOilAvgPriceGet();
                    break;
                case MethodTransRateApplyHistList:
                    GetTransRateApplyHistList();
                    break;
                case MethodTransRateApplyDel:
                    SetTransRateApplyDel();
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

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 요율표 적용 리스트
    /// </summary>
    protected void GetTransRateApplyList()
    {
        ReqTransRateApplyList                lo_objReqTransRateApplyList = null;
        ServiceResult<ResTransRateApplyList> lo_objResTransRateApplyList = null;

        try
        {
            lo_objReqTransRateApplyList = new ReqTransRateApplyList
            {
                ApplySeqNo        = strApplySeqNo.ToInt64(),
                ClientCode        = strClientCode.ToInt64(),
                ClientName        = strClientName,
                CenterCode        = strCenterCode.ToInt(),
                ConsignorCode     = strConsignorCode.ToInt64(),
                ConsignorName     = strConsignorName,
                OrderItemCode     = strOrderItemCode,
                OrderLocationCode = strOrderLocationCode,
                DelFlag           = strDelFlag,
                AccessCenterCode  = objSes.AccessCenterCode,
                PageSize          = intPageSize,
                PageNo            = intPageNo
            };

            lo_objResTransRateApplyList = objTransRateDasServices.GetTransRateApplyList(lo_objReqTransRateApplyList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResTransRateApplyList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9101;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 상세 히스토리 리스트
    /// </summary>
    protected void GetTransRateApplyListExcel()
    {
        ReqTransRateApplyList                lo_objReqTransRateApplyList = null;
        ServiceResult<ResTransRateApplyList> lo_objResTransRateApplyList = null;
        string                               lo_strFileName              = "";
        SpreadSheet                          lo_objExcel                 = null;
        DataTable                            lo_dtData                   = null;
        MemoryStream                         lo_outputStream             = null;
        byte[]                               lo_Content                  = null;
        int                                  lo_intColumnIndex           = 0;

        try
        {
            lo_objReqTransRateApplyList = new ReqTransRateApplyList
            {
                ApplySeqNo        = strApplySeqNo.ToInt64(),
                ClientCode        = strClientCode.ToInt64(),
                ClientName        = strClientName,
                CenterCode        = strCenterCode.ToInt(),
                ConsignorCode     = strConsignorCode.ToInt64(),
                ConsignorName     = strConsignorName,
                OrderItemCode     = strOrderItemCode,
                OrderLocationCode = strOrderLocationCode,
                DelFlag           = strDelFlag,
                AccessCenterCode  = objSes.AccessCenterCode,
                PageSize          = intPageSize,
                PageNo            = intPageNo
            };

            lo_objResTransRateApplyList = objTransRateDasServices.GetTransRateApplyList(lo_objReqTransRateApplyList);
            lo_dtData                   = new DataTable();
            lo_strFileName              = "요율표적용관리";
                
            lo_dtData.Columns.Add(new DataColumn("회원사명",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고객사명",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기본요율-독차",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기본요율-혼적",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("추가요율-경유지",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("추가요율-유가연동", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최초등록일",      typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("최초등록자",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최초수정일", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최초수정자", typeof(string)));

            foreach (var row in lo_objResTransRateApplyList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName, row.ClientName, row.ConsignorName, row.OrderItemCodeM, row.OrderLocationCodesM
                                  ,row.FtlYN, row.LtlYN, row.LayoverYN, row.OilYN, row.RegDate
                                  ,row.RegAdminName + "(" + row.RegAdminID + ")", row.UpdDate, row.UpdAdminName + "(" + row.UpdAdminID + ")");
            }

            lo_objExcel = new SpreadSheet {SheetName = lo_strFileName};

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
            objResMap.RetCode = 9151;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 고객사 목록
    /// </summary>
    protected void GetClientList()
    {
        ReqClientList                lo_objReqClientList = null;
        ServiceResult<ResClientList> lo_objResClientList = null;

        try
        {
            lo_objReqClientList = new ReqClientList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientName       = strClientName,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientList   = objClientDasServices.GetClientList(lo_objReqClientList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9102;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    /// <summary>
    /// 화주 목록
    /// </summary>
    protected void GetConsignorList()
    {
        ReqConsignorList                lo_objReqConsignorList = null;
        ServiceResult<ResConsignorList> lo_objResConsignorList = null;

        try
        {
            lo_objReqConsignorList = new ReqConsignorList
            {
                ConsignorCode    = strConsignorCode.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResConsignorList = objConsignorDasServices.GetConsignorList(lo_objReqConsignorList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResConsignorList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9103;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율 적용 중복 체크
    /// </summary>
    protected void GetTransRateApplyGet()
    {
        TransRateModel                lo_objTransRateModel    = null;
        ServiceResult<TransRateModel> lo_objResTransRateModel = null;

        try
        {

            lo_objTransRateModel = new TransRateModel
            {
                ApplySeqNo         = strApplySeqNo.ToInt64(),
                ClientCode         = strClientCode.ToInt64(),
                CenterCode         = strCenterCode.ToInt(),
                ConsignorCode      = strConsignorCode.ToInt64(),
                OrderItemCode      = strOrderItemCode,
                OrderLocationCodes = strOrderLocationCodes
            };

            lo_objResTransRateModel = objTransRateDasServices.GetTransRateApplyGet(lo_objTransRateModel);
            objResMap.RetCode       = lo_objResTransRateModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateModel.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("ApplySeqNo",         lo_objResTransRateModel.data.OutApplySeqNo);
                objResMap.Add("Exists",             lo_objResTransRateModel.data.Exists);
                objResMap.Add("DelFlag",            lo_objResTransRateModel.data.DelFlag);
                objResMap.Add("OrderLocationCodes", lo_objResTransRateModel.data.RegOrderLocationCodes);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9104;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 그룹 리스트
    /// </summary>
    protected void GetTransRateList()
    {
        ReqTransRateList                lo_objReqTransRateList = null;
        ServiceResult<ResTransRateList> lo_objResTransRateList = null;

        try
        {
            lo_objReqTransRateList = new ReqTransRateList
            {
                TransSeqNo       = strTransSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                RateRegKind      = strRateRegKind.ToInt(),
                RateType         = strRateType.ToInt(),
                TransRateName    = strTransRateName,
                FTLFlag          = strFTLFlag,
                DelFlag          = strDelFlag,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResTransRateList = objTransRateDasServices.GetTransRateList(lo_objReqTransRateList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResTransRateList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9105;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율 적용 등록
    /// </summary>
    protected void GetTransRateApplyIns()
    {
        TransRateApplyModel                lo_objTransRateApplyModel    = null;
        ServiceResult<TransRateApplyModel> lo_objResTransRateApplyModel = null;

        try
        {

            lo_objTransRateApplyModel = new TransRateApplyModel
            {
                ClientCode              = strClientCode.ToInt64(),
                CenterCode              = strCenterCode.ToInt(),
                ConsignorCode           = strConsignorCode.ToInt64(),
                OrderItemCode           = strOrderItemCode,
                OrderLocationCodes      = strOrderLocationCodes,
                FtlSPTransSeqNo         = strFtlSPTransSeqNo.ToInt64(),
                FtlSTransSeqNo          = strFtlSTransSeqNo.ToInt64(),
                FtlPTransSeqNo          = strFtlPTransSeqNo.ToInt64(),
                FtlPRateFlag            = strFtlPRateFlag,
                FtlPurchaseRate         = strFtlPurchaseRate.ToDouble(),
                FtlFixedPurchaseRate    = strFtlFixedPurchaseRate.ToDouble(),
                FtlRoundAmtKind         = strFtlRoundAmtKind.ToInt(),
                FtlRoundType            = strFtlRoundType,
                LtlSPTransSeqNo         = strLtlSPTransSeqNo.ToInt64(),
                LtlSTransSeqNo          = strLtlSTransSeqNo.ToInt64(),
                LtlPTransSeqNo          = strLtlPTransSeqNo.ToInt64(),
                LtlPRateFlag            = strLtlPRateFlag,
                LtlPurchaseRate         = strLtlPurchaseRate.ToDouble(),
                LtlFixedPurchaseRate    = strLtlFixedPurchaseRate.ToDouble(),
                LtlRoundAmtKind         = strLtlRoundAmtKind.ToInt(),
                LtlRoundType            = strLtlRoundType,
                LayoverTransSeqNo       = strLayoverTransSeqNo.ToInt64(),
                OilTransSeqNo           = strOilTransSeqNo.ToInt64(),
                OilPeriodType           = strOilPeriodType.ToInt(),
                OilSearchArea           = strOilSearchArea,
                OilPrice                = strOilPrice.ToDouble(),
                OilGetPlace1            = strOilGetPlace1,
                OilGetPlace2            = strOilGetPlace2,
                OilGetPlace3            = strOilGetPlace3,
                OilGetPlace4            = strOilGetPlace4,
                OilGetPlace5            = strOilGetPlace5,
                OilSaleRoundAmtKind     = strOilSaleRoundAmtKind.ToInt(),
                OilSaleRoundType        = strOilSaleRoundType,
                OilPurchaseRoundAmtKind = strOilPurchaseRoundAmtKind.ToInt(),
                OilPurchaseRoundType    = strOilPurchaseRoundType,
                OilFixedRoundAmtKind    = strOilFixedRoundAmtKind.ToInt(),
                OilFixedRoundType       = strOilFixedRoundType,
                RegAdminID              = objSes.AdminID
            };

            lo_objResTransRateApplyModel = objTransRateDasServices.SetTransRateApplyIns(lo_objTransRateApplyModel);
            objResMap.RetCode            = lo_objResTransRateApplyModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateApplyModel.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("ApplySeqNo", lo_objResTransRateApplyModel.data.ApplySeqNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9106;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율 적용 수정
    /// </summary>
    protected void GetTransRateApplyUpd()
    {
        TransRateApplyModel                lo_objTransRateApplyModel    = null;
        ServiceResult<TransRateApplyModel> lo_objResTransRateApplyModel = null;

        try
        {

            lo_objTransRateApplyModel = new TransRateApplyModel
            {
                ApplySeqNo              = strApplySeqNo.ToInt64(),
                CenterCode              = strCenterCode.ToInt(),
                FtlSPTransSeqNo         = strFtlSPTransSeqNo.ToInt64(),
                FtlSTransSeqNo          = strFtlSTransSeqNo.ToInt64(),
                FtlPTransSeqNo          = strFtlPTransSeqNo.ToInt64(),
                FtlPRateFlag            = strFtlPRateFlag,
                FtlPurchaseRate         = strFtlPurchaseRate.ToDouble(),
                FtlFixedPurchaseRate    = strFtlFixedPurchaseRate.ToDouble(),
                FtlRoundAmtKind         = strFtlRoundAmtKind.ToInt(),
                FtlRoundType            = strFtlRoundType,
                LtlSPTransSeqNo         = strLtlSPTransSeqNo.ToInt64(),
                LtlSTransSeqNo          = strLtlSTransSeqNo.ToInt64(),
                LtlPTransSeqNo          = strLtlPTransSeqNo.ToInt64(),
                LtlPRateFlag            = strLtlPRateFlag,
                LtlPurchaseRate         = strLtlPurchaseRate.ToDouble(),
                LtlFixedPurchaseRate    = strLtlFixedPurchaseRate.ToDouble(),
                LtlRoundAmtKind         = strLtlRoundAmtKind.ToInt(),
                LtlRoundType            = strLtlRoundType,
                LayoverTransSeqNo       = strLayoverTransSeqNo.ToInt64(),
                OilTransSeqNo           = strOilTransSeqNo.ToInt64(),
                OilPeriodType           = strOilPeriodType.ToInt(),
                OilSearchArea           = strOilSearchArea,
                OilPrice                = strOilPrice.ToDouble(),
                OilGetPlace1            = strOilGetPlace1,
                OilGetPlace2            = strOilGetPlace2,
                OilGetPlace3            = strOilGetPlace3,
                OilGetPlace4            = strOilGetPlace4,
                OilGetPlace5            = strOilGetPlace5,
                OilSaleRoundAmtKind     = strOilSaleRoundAmtKind.ToInt(),
                OilSaleRoundType        = strOilSaleRoundType,
                OilPurchaseRoundAmtKind = strOilPurchaseRoundAmtKind.ToInt(),
                OilPurchaseRoundType    = strOilPurchaseRoundType,
                OilFixedRoundAmtKind    = strOilFixedRoundAmtKind.ToInt(),
                OilFixedRoundType       = strOilFixedRoundType,
                OrderLocationCodes      = strOrderLocationCodes,
                RegAdminID              = objSes.AdminID
            };

            lo_objResTransRateApplyModel = objTransRateDasServices.SetTransRateApplyUpd(lo_objTransRateApplyModel);
            objResMap.RetCode            = lo_objResTransRateApplyModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateApplyModel.result.ErrorMsg;
                return;
            }

            objResMap.Add("ApplySeqNo", strApplySeqNo);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9107;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 적용 유가 조회
    /// </summary>
    protected void GetOilAvgPriceGet()
    {
        TransRateOilModel                lo_objTransRateOilModel    = null;
        ServiceResult<TransRateOilModel> lo_objResTransRateOilModel = null;

        try
        {

            lo_objTransRateOilModel = new TransRateOilModel
            {
                StdYMD       = strStdYMD,
                OilType      = strOilType.ToInt(),
                AvgType      = strAvgType.ToInt(),
                Sido         = strSido
            };

            lo_objResTransRateOilModel = objTransRateDasServices.GetOilAvgPriceGet(lo_objTransRateOilModel);
            objResMap.RetCode          = lo_objResTransRateOilModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateOilModel.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("AvgPrice", lo_objResTransRateOilModel.data.AvgPrice);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9108;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }

    }

    //요율 적용 삭제
    protected void SetTransRateApplyDel()
    {
        TransRateModel                lo_objTransRateModel    = null;
        ServiceResult<TransRateModel> lo_objResTransRateModel = null;

        try
        {

            lo_objTransRateModel = new TransRateModel
            {
                ApplySeqNo  = strApplySeqNo.ToInt64(),
                CenterCode  = strCenterCode.ToInt(),
                UpdType     = strUpdType.ToInt(),
                RateRegKind = strRateRegKind.ToInt(),
                UpdAdminID  = objSes.AdminID
            };

            lo_objResTransRateModel = objTransRateDasServices.SetTransRateApplyDel(lo_objTransRateModel);
            objResMap.RetCode       = lo_objResTransRateModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResTransRateModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9109;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 적용관리 히스토리 리스트
    /// </summary>
    protected void GetTransRateApplyHistList()
    {
        ReqTransRateApplyList                lo_objReqTransRateApplyList = null;
        ServiceResult<ResTransRateApplyList> lo_objResTransRateApplyList = null;

        try
        {
            lo_objReqTransRateApplyList = new ReqTransRateApplyList
            {
                ApplySeqNo       = strApplySeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResTransRateApplyList = objTransRateDasServices.GetTransRateApplyHistList(lo_objReqTransRateApplyList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResTransRateApplyList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9110;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("TransRateApplyHandler", "Exception",
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