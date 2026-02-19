<%@ WebHandler Language="C#" Class="WebInoutHandler" %>
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
/// FileName        : WebInoutHandler.ashx
/// Description     : 웹오더 관련 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-07-07
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class WebInoutHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/WEB/Inout/WebInoutList"; //필수

    // 메소드 리스트
    private const string MethodWebOrderList             = "WebOrderList";             //웹오더 조회
    private const string MethodWebOrderExcelList        = "WebOrderExcelList";        //웹오더 조회
    private const string MethodConsignorList            = "ConsignorList";            //화주 조회
    private const string MethodPlaceList                = "PlaceList";                //상하차지 조회
    private const string MethodWebOrderInsert           = "WebOrderInsert";           //오더 등록
    private const string MethodWebOrderUpdate           = "WebOrderUpdate";           //오더 수정
    private const string MethodWebInoutDispatchCarList  = "WebInoutDispatchCarList";  //배차차량조회
    private const string MethodWebInoutPayList          = "WebInoutPayList";          //비용 조회
    private const string MethodWebOrderCancel           = "WebOrderCancel";           //요청오더 취소
    private const string MethodWebOrderRequestList      = "WebOrderRequestList";      //오더 원본보기
    private const string MethodWebOrderRequestCnlInsert = "WebOrderRequestCnlInsert"; //오더 변경요청 등록
    private const string MethodWebOrderRequestCnlUpdate = "WebOrderRequestCnlUpdate"; //오더 변경요청 수정
    private const string MethodWebRequestChgList        = "WebRequestChgList";        //오더 변경요청 목록

    WebOrderDasServices objWebOrderDasServices = new WebOrderDasServices();
    OrderDasServices    objOrderDasServices    = new OrderDasServices();

    private string strCallType                  = string.Empty;
    private int    intPageSize                  = 0;
    private int    intPageNo                    = 0;
    private string strCenterCode                = string.Empty;
    private string strOrderNo                   = string.Empty;
    private string strSearchType                = string.Empty;
    private string strSearchText                = string.Empty;
    private string strListType                  = string.Empty;
    private string strDateType                  = string.Empty;
    private string strDateFrom                  = string.Empty;
    private string strDateTo                    = string.Empty;
    private string strOrderStatus               = string.Empty;
    private string strConsignorName             = string.Empty;
    private string strPickupPlace               = string.Empty;
    private string strGetPlace                  = string.Empty;
    private string strGoodsName                 = string.Empty;
    private string strMyOrderFlag               = string.Empty;
    private string strCnlFlag                   = string.Empty;
    private string strOrderRegType              = string.Empty;
    private string strPlaceName                 = string.Empty;
    private string strPickupYMD                 = string.Empty;
    private string strPickupHM                  = string.Empty;
    private string strPickupPlaceChargeName     = string.Empty;
    private string strPickupPlaceChargePosition = string.Empty;
    private string strPickupPlaceChargeTelNo    = string.Empty;
    private string strPickupPlaceChargeTelExtNo = string.Empty;
    private string strPickupPlaceChargeCell     = string.Empty;
    private string strPickupPlacePost           = string.Empty;
    private string strPickupPlaceAddr           = string.Empty;
    private string strPickupPlaceAddrDtl        = string.Empty;
    private string strPickupPlaceFullAddr       = string.Empty;
    private string strPickupPlaceNote           = string.Empty;
    private string strGetYMD                    = string.Empty;
    private string strGetHM                     = string.Empty;
    private string strGetPlaceChargeName        = string.Empty;
    private string strGetPlaceChargePosition    = string.Empty;
    private string strGetPlaceChargeTelNo       = string.Empty;
    private string strGetPlaceChargeTelExtNo    = string.Empty;
    private string strGetPlaceChargeCell        = string.Empty;
    private string strGetPlacePost              = string.Empty;
    private string strGetPlaceAddr              = string.Empty;
    private string strGetPlaceAddrDtl           = string.Empty;
    private string strGetPlaceFullAddr          = string.Empty;
    private string strGetPlaceNote              = string.Empty;
    private string strGoodsItemCode             = string.Empty;
    private string strGoodsRunType              = string.Empty;
    private string strFTLFlag                   = string.Empty; // 2023-03-16 by shadow54 : 자동운임 수정 건
    private string strWeight                    = string.Empty;
    private string strVolume                    = string.Empty;
    private string strNoteClient                = string.Empty;
    private string strOrderItemCode             = string.Empty;
    private string strReqNo                     = string.Empty;
    private string strShuttleEtc                = string.Empty;
    private string strArrivalReportFlag         = string.Empty;
    private string strBondedFlag                = string.Empty;
    private string strReqSeqNo                  = string.Empty;
    private string strGoodsSeqNo                = string.Empty;
    private string strOrderClientName           = string.Empty;
    private string strPayClientName             = string.Empty;
    private string strReqChargeName             = string.Empty;
    private string strReqChargeTeam             = string.Empty;
    private string strReqChargeTel              = string.Empty;
    private string strReqChargeCell             = string.Empty;
    private string strReqStatus                 = string.Empty;
    private string strChgReqContent             = string.Empty;
    private string strChgMessage                = string.Empty;
    private string strChgStatus                 = string.Empty;
    private string strChgSeqNo                  = string.Empty;
    private string strOrderClientCode           = string.Empty;
    private string strQuantity                  = string.Empty;
    private string strNation                    = string.Empty;
    private string strHawb                      = string.Empty;
    private string strMawb                      = string.Empty;
    private string strInvoiceNo                 = string.Empty;
    private string strBookingNo                 = string.Empty;
    private string strStockNo                   = string.Empty;
    private string strCBM                       = string.Empty;
    private string strOrderLocationCode         = string.Empty;
    private string strClientCode                = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodWebOrderList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebOrderExcelList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceList,                MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebOrderInsert,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWebOrderUpdate,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWebInoutDispatchCarList,  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebInoutPayList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebOrderCancel,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWebOrderRequestList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebOrderRequestCnlInsert, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebOrderRequestCnlUpdate, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWebRequestChgList,        MenuAuthType.ReadOnly);

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
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("WebInoutHandler");
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
            strCenterCode                = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderNo                   = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strSearchType                = SiteGlobal.GetRequestForm("SearchType");
            strSearchText                = SiteGlobal.GetRequestForm("SearchText");
            strListType                  = Utils.IsNull(SiteGlobal.GetRequestForm("ListType"), "0");
            strDateType                  = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "0");
            strDateFrom                  = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                    = SiteGlobal.GetRequestForm("DateTo");
            strOrderStatus               = SiteGlobal.GetRequestForm("OrderStatuses");
            strConsignorName             = SiteGlobal.GetRequestForm("ConsignorName");
            strPickupPlace               = SiteGlobal.GetRequestForm("PickupPlace");
            strGetPlace                  = SiteGlobal.GetRequestForm("GetPlace");
            strGoodsName                 = SiteGlobal.GetRequestForm("GoodsName");
            strMyOrderFlag               = SiteGlobal.GetRequestForm("MyOrderFlag");
            strCnlFlag                   = SiteGlobal.GetRequestForm("CnlFlag");
            strOrderRegType              = Utils.IsNull(SiteGlobal.GetRequestForm("OrderRegType"), "5");
            strPlaceName                 = SiteGlobal.GetRequestForm("PlaceName");
            strPickupYMD                 = SiteGlobal.GetRequestForm("PickupYMD");
            strPickupHM                  = SiteGlobal.GetRequestForm("PickupHM");
            strPickupPlaceChargeName     = SiteGlobal.GetRequestForm("PickupPlaceChargeName");
            strPickupPlaceChargePosition = SiteGlobal.GetRequestForm("PickupPlaceChargePosition");
            strPickupPlaceChargeTelNo    = SiteGlobal.GetRequestForm("PickupPlaceChargeTelNo");
            strPickupPlaceChargeTelExtNo = SiteGlobal.GetRequestForm("PickupPlaceChargeTelExtNo");
            strPickupPlaceChargeCell     = SiteGlobal.GetRequestForm("PickupPlaceChargeCell");
            strPickupPlacePost           = SiteGlobal.GetRequestForm("PickupPlacePost");
            strPickupPlaceAddr           = SiteGlobal.GetRequestForm("PickupPlaceAddr");
            strPickupPlaceAddrDtl        = SiteGlobal.GetRequestForm("PickupPlaceAddrDtl");
            strPickupPlaceFullAddr       = SiteGlobal.GetRequestForm("PickupPlaceFullAddr");
            strPickupPlaceNote           = SiteGlobal.GetRequestForm("PickupPlaceNote");
            strGetYMD                    = SiteGlobal.GetRequestForm("GetYMD");
            strGetHM                     = SiteGlobal.GetRequestForm("GetHM");
            strGetPlaceChargeName        = SiteGlobal.GetRequestForm("GetPlaceChargeName");
            strGetPlaceChargePosition    = SiteGlobal.GetRequestForm("GetPlaceChargePosition");
            strGetPlaceChargeTelNo       = SiteGlobal.GetRequestForm("GetPlaceChargeTelNo");
            strGetPlaceChargeTelExtNo    = SiteGlobal.GetRequestForm("GetPlaceChargeTelExtNo");
            strGetPlaceChargeCell        = SiteGlobal.GetRequestForm("GetPlaceChargeCell");
            strGetPlacePost              = SiteGlobal.GetRequestForm("GetPlacePost");
            strGetPlaceAddr              = SiteGlobal.GetRequestForm("GetPlaceAddr");
            strGetPlaceAddrDtl           = SiteGlobal.GetRequestForm("GetPlaceAddrDtl");
            strGetPlaceFullAddr          = SiteGlobal.GetRequestForm("GetPlaceFullAddr");
            strGetPlaceNote              = SiteGlobal.GetRequestForm("GetPlaceNote");
            strGoodsItemCode             = SiteGlobal.GetRequestForm("GoodsItemCode");
            strGoodsRunType              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsRunType"), "1");
            strFTLFlag                   = SiteGlobal.GetRequestForm("FTLFlag"); //2023-03-16byshadow54:자동운임수정건
            strWeight                    = Utils.IsNull(SiteGlobal.GetRequestForm("Weight"), "0");
            strVolume                    = Utils.IsNull(SiteGlobal.GetRequestForm("Volume"), "0");
            strNoteClient                = SiteGlobal.GetRequestForm("NoteClient");
            strOrderItemCode             = SiteGlobal.GetRequestForm("OrderItemCode");
            strReqNo                     = SiteGlobal.GetRequestForm("ReqNo");
            strShuttleEtc                = SiteGlobal.GetRequestForm("ShuttleEtc");
            strArrivalReportFlag         = SiteGlobal.GetRequestForm("ArrivalReportFlag");
            strBondedFlag                = SiteGlobal.GetRequestForm("BondedFlag");
            strReqSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("ReqSeqNo"),   "0");
            strGoodsSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"), "0");
            strOrderClientName           = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientName             = SiteGlobal.GetRequestForm("PayClientName");
            strReqChargeName             = SiteGlobal.GetRequestForm("ReqChargeName");
            strReqChargeTeam             = SiteGlobal.GetRequestForm("ReqChargeTeam");
            strReqChargeTel              = SiteGlobal.GetRequestForm("ReqChargeTel");
            strReqChargeCell             = SiteGlobal.GetRequestForm("ReqChargeCell");
            strReqStatus                 = SiteGlobal.GetRequestForm("ReqStatus");
            strChgReqContent             = SiteGlobal.GetRequestForm("ChgReqContent");
            strChgMessage                = SiteGlobal.GetRequestForm("ChgMessage");
            strChgStatus                 = Utils.IsNull(SiteGlobal.GetRequestForm("ChgStatus"),       "0");
            strChgSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("ChgSeqNo"),        "0");
            strOrderClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("OrderClientCode"), "0");
            strQuantity                  = SiteGlobal.GetRequestForm("Quantity");
            strNation                    = SiteGlobal.GetRequestForm("Nation");
            strHawb                      = SiteGlobal.GetRequestForm("Hawb");
            strMawb                      = SiteGlobal.GetRequestForm("Mawb");
            strInvoiceNo                 = SiteGlobal.GetRequestForm("InvoiceNo");
            strBookingNo                 = SiteGlobal.GetRequestForm("BookingNo");
            strStockNo                   = SiteGlobal.GetRequestForm("StockNo");
            strCBM                       = Utils.IsNull(SiteGlobal.GetRequestForm("CBM"), "0");
            strOrderLocationCode         = SiteGlobal.GetRequestForm("OrderLocationCode");
            strClientCode                = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
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
                case MethodWebOrderList:
                    CallWebOrderList();
                    break;
                case MethodWebOrderExcelList:
                    GetWebOrderExcelList();
                    break;
                case MethodConsignorList:
                    GetConsignorList();
                    break;
                case MethodPlaceList:
                    GetPlaceList();
                    break;
                case MethodWebOrderInsert:
                    SetWebOrderInsert();
                    break;
                case MethodWebOrderUpdate:
                    SetWebOrderUpdate();
                    break;
                case MethodWebInoutDispatchCarList:
                    GetWebInoutDispatchCarList();
                    break;
                case MethodWebInoutPayList:
                    GetWebDomesticPayList();
                    break;
                case MethodWebOrderCancel:
                    GetWebOrderCancel();
                    break;
                case MethodWebOrderRequestList:
                    CallWebOrderRequestList();
                    break;
                case MethodWebOrderRequestCnlInsert:
                    SetWebOrderRequestCnlInsert();
                    break;
                case MethodWebOrderRequestCnlUpdate:
                    SetWebOrderRequestCnlUpdate();
                    break;
                case MethodWebRequestChgList:
                    GetWebRequestChgList();
                    break;
                default:
                    objResMap.RetCode = 9999;
                    objResMap.ErrMsg  = "Wrong Method" + strCallType;
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9203;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 차량업체 엑셀 다운로드
    /// </summary>
    protected void GetWebOrderExcelList()
    {
        WebReqOrderList                lo_objWebReqOrderList = null;
        ServiceResult<WebResOrderList> lo_objWebResOrderList = null;
        string                         lo_strFileName        = "";
        SpreadSheet                    lo_objExcel           = null;
        DataTable                      lo_dtData             = null;
        MemoryStream                   lo_outputStream       = null;
        byte[]                         lo_Content            = null;
        int                            lo_intColumnIndex     = 0;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "ConsignorName":
                    strConsignorName = strSearchText;
                    break;
                case "PickupPlace":
                    strPickupPlace = strSearchText;
                    break;
                case "GetPlace":
                    strGetPlace = strSearchText;
                    break;
                case "GoodsName":
                    strGoodsName = strSearchText;
                    break;
            }
        }

        try
        {
            lo_objWebReqOrderList = new WebReqOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                ListType         = strListType.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom.Replace("-", ""),
                DateTo           = strDateTo.Replace("-", ""),
                OrderStatuses    = strOrderStatus,
                ConsignorName    = strConsignorName,
                PickupPlace      = strPickupPlace,
                GetPlace         = strGetPlace,
                GoodsName        = strGoodsName,
                OrderRegType     = strOrderRegType.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                MyOrderFlag      = strMyOrderFlag,
                CnlFlag          = strCnlFlag,
                AdminID          = objSes.AdminID,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objWebResOrderList    = objWebOrderDasServices.GetWebOrderList(lo_objWebReqOrderList);

            lo_dtData = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("오더구분",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수번호",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더담당자",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더상태",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처담당자", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일",  typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("상차요청시간",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)담당자",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)전화번호",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소상세",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)특이사항",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청시간",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("하차지",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)담당자",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)주소",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)주소상세",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)특이사항",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청톤급",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청차종",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총수량(ea)",  typeof(int)));

            lo_dtData.Columns.Add(new DataColumn("총부피(cbm)", typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총중량(kg)",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("화물정보",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("목적국",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("H/AWB",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("M/AWB",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Invoice No.", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Booking No.", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입고 No.",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("도착보고",       typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("보세",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청사항", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("운송료",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("선급금",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("예수금",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("요청자",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수자",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수일",  typeof(string)));

            foreach (var row in lo_objWebResOrderList.data.list)
            {
                lo_dtData.Rows.Add(row.OrderRegTypeM, row.OrderNo, row.PayClientChargeName, row.OrderStatusM, row.OrderLocationCodeM
                                  ,row.OrderItemCodeM, row.OrderClientName, row.OrderClientChargeName, row.ConsignorName, row.PickupYMD
                                  ,row.PickupHM, row.PickupPlace, row.PickupPlaceChargeName, row.PickupPlaceChargeTelNo ,row.PickupPlaceChargeCell
                                  ,row.PickupPlaceAddr, row.PickupPlaceAddrDtl, row.PickupPlaceNote, row.GetYMD, row.GetHM
                                  ,row.GetPlace, row.GetPlaceChargeName, row.GetPlaceChargeTelNo, row.GetPlaceChargeCell, row.GetPlaceAddr
                                  ,row.GetPlaceAddrDtl, row.GetPlaceNote, row.CarTonCodeM, row.CarTypeCodeM, row.Volume
                                  ,row.CBM, row.Weight, row.Quantity, row.Nation, row.Hawb
                                  ,row.Mawb, row.InvoiceNo, row.BookingNo, row.StockNo, row.ArrivalReportFlag
                                  ,row.BondedFlag, row.NoteClient, row.SaleSupplyAmt, row.AdvanceSupplyAmt3, row.AdvanceSupplyAmt4
                                  ,row.RegAdminName, row.RegDate, row.AcceptAdminName, row.AcceptDate);
            }

            lo_objExcel = new SpreadSheet {SheetName = "수출입운송"};

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
            objResMap.RetCode = 9204;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 웹오더리스트
    /// </summary>
    protected void CallWebOrderList()
    {
        WebReqOrderList                lo_objWebReqOrderList = null;
        ServiceResult<WebResOrderList> lo_objWebResOrderList = null;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "ConsignorName":
                    strConsignorName = strSearchText;
                    break;
                case "PickupPlace":
                    strPickupPlace = strSearchText;
                    break;
                case "GetPlace":
                    strGetPlace = strSearchText;
                    break;
                case "GoodsName":
                    strGoodsName = strSearchText;
                    break;
            }
        }
        try
        {
            lo_objWebReqOrderList = new WebReqOrderList
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                ListType         = strListType.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom.Replace("-", ""),
                DateTo           = strDateTo.Replace("-", ""),
                OrderStatuses    = strOrderStatus,
                ConsignorName    = strConsignorName,
                PickupPlace      = strPickupPlace,
                GetPlace         = strGetPlace,
                GoodsName        = strGoodsName,
                OrderRegType     = strOrderRegType.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                MyOrderFlag      = strMyOrderFlag,
                CnlFlag          = strCnlFlag,
                OrderItemCodes   = strOrderItemCode,
                AdminID          = objSes.AdminID,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objWebResOrderList = objWebOrderDasServices.GetWebOrderList(lo_objWebReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objWebResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 목록 검색
    /// </summary>
    protected void GetConsignorList()
    {
        ReqWebConsignorList                lo_objReqWebConsignorList = null;
        ServiceResult<ResWebConsignorList> lo_objResWebConsignorList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqWebConsignorList = new ReqWebConsignorList
            {
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                UseFlag          = "Y",
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResWebConsignorList = objWebOrderDasServices.GetWebConsignorList(lo_objReqWebConsignorList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResWebConsignorList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 작업지 검색
    /// </summary>
    protected void GetPlaceList()
    {
        ReqClientPlaceChargeList                      lo_objReqClinetPlaceChargeList = null;
        ServiceResult<ResClientPlaceChargeList>       lo_objResClientPlaceChargeList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPlaceName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClinetPlaceChargeList = new ReqClientPlaceChargeList
            {
                CenterCode       = strCenterCode.ToInt(),
                UseFlag          = "Y",
                PlaceName        = strPlaceName,
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientPlaceChargeList = objWebOrderDasServices.GetWebOrderPlaceChargeList(lo_objReqClinetPlaceChargeList);
            objResMap.strResponse          = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void SetWebOrderInsert() {
        WebOrderModel                lo_objWebOrderModel        = null;
        ServiceResult<WebOrderModel> lo_objResWebOrderModel     = null;

        strPickupYMD     = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        strGetYMD        = string.IsNullOrWhiteSpace(strGetYMD) ? strGetYMD : strGetYMD.Replace("-", "");
        strReqChargeTel  = string.IsNullOrWhiteSpace(strReqChargeTel) ? objSes.TelNo : strReqChargeTel.Replace("-", "");
        strReqChargeCell = string.IsNullOrWhiteSpace(strReqChargeCell) ? objSes.MobileNo : strReqChargeCell.Replace("-", "");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupHM) || string.IsNullOrWhiteSpace(strPickupPlace))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetHM) || string.IsNullOrWhiteSpace(strGetPlace))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objWebOrderModel = new WebOrderModel
            {
                CenterCode                = strCenterCode.ToInt(),
                OrderNo                   = strOrderNo.ToInt64(),
                OrderClientCode           = 0,
                PayClientCode             = 0,
                ConsignorName             = strConsignorName,
                OrderLocationCode         = strOrderLocationCode,
                OrderItemCode             = strOrderItemCode,
                ReqNo                     = strReqNo,
                ReqChargeName             = strReqChargeName,
                ReqChargeTeam             = strReqChargeTeam,
                ReqChargePosition         = objSes.Position,
                ReqChargeTel              = strReqChargeTel,
                ReqChargeCell             = strReqChargeCell,
                PickupYMD                 = strPickupYMD,
                PickupHM                  = strPickupHM,
                PickupPlace               = strPickupPlace,
                PickupPlacePost           = strPickupPlacePost,
                PickupPlaceAddr           = strPickupPlaceAddr,
                PickupPlaceAddrDtl        = strPickupPlaceAddrDtl,
                PickupPlaceFullAddr       = strPickupPlaceFullAddr,
                PickupPlaceChargeName     = strPickupPlaceChargeName,
                PickupPlaceChargePosition = strPickupPlaceChargePosition,
                PickupPlaceChargeTelExtNo = strPickupPlaceChargeTelExtNo,
                PickupPlaceChargeTelNo    = strPickupPlaceChargeTelNo,
                PickupPlaceChargeCell     = strPickupPlaceChargeCell,
                PickupPlaceNote           = strPickupPlaceNote,
                GetYMD                    = strGetYMD,
                GetHM                     = strGetHM,
                GetPlace                  = strGetPlace,
                GetPlacePost              = strGetPlacePost,
                GetPlaceAddr              = strGetPlaceAddr,
                GetPlaceAddrDtl           = strGetPlaceAddrDtl,
                GetPlaceFullAddr          = strGetPlaceFullAddr,
                GetPlaceChargeName        = strGetPlaceChargeName,
                GetPlaceChargePosition    = strGetPlaceChargePosition,
                GetPlaceChargeTelExtNo    = strGetPlaceChargeTelExtNo,
                GetPlaceChargeTelNo       = strGetPlaceChargeTelNo,
                GetPlaceChargeCell        = strGetPlaceChargeCell,
                GetPlaceNote              = strGetPlaceNote,
                Nation                    = strNation,
                Hawb                      = strHawb,
                Mawb                      = strMawb,
                InvoiceNo                 = strInvoiceNo,
                BookingNo                 = strBookingNo,
                StockNo                   = strStockNo,
                ArrivalReportFlag         = strArrivalReportFlag,
                BondedFlag                = strBondedFlag,
                NoteClient                = strNoteClient,
                GoodsName                 = strGoodsName,
                GoodsItemCode             = strGoodsItemCode,
                GoodsRunType              = strGoodsRunType.ToInt(),
                FTLFlag                   = strFTLFlag, // 2023-03-16 by shadow54 : 자동운임 수정 건
                CBM                       = strCBM.ToDouble(),
                Volume                    = strVolume.ToInt(),
                Weight                    = strWeight.ToDouble(),
                Quantity                  = strQuantity,
                ShuttleEtc                = strShuttleEtc,
                AdminCorpNo               = objSes.AccessCorpNo,
                RegAdminID                = objSes.AdminID,
                RegAdminName              = objSes.AdminName
            };

            lo_objResWebOrderModel = objWebOrderDasServices.SetWebOrderIns(lo_objWebOrderModel);
            objResMap.RetCode      = lo_objResWebOrderModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResWebOrderModel.result.ErrorMsg;
                return;
            }

            objResMap.Add("OrderNo",  lo_objResWebOrderModel.data.OrderNo.ToString());
            objResMap.Add("ReqSeqNo", lo_objResWebOrderModel.data.ReqSeqNo.ToString());
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void SetWebOrderUpdate()
    {
        WebOrderModel                lo_objWebOrderModel        = null;
        ServiceResult<WebOrderModel> lo_objResWebOrderModel     = null;

        strPickupYMD     = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        strGetYMD        = string.IsNullOrWhiteSpace(strGetYMD) ? strGetYMD : strGetYMD.Replace("-", "");
        strReqChargeTel  = string.IsNullOrWhiteSpace(strReqChargeTel) ? objSes.TelNo : strReqChargeTel.Replace("-", "");
        strReqChargeCell = string.IsNullOrWhiteSpace(strReqChargeCell) ? objSes.MobileNo : strReqChargeCell.Replace("-", "");
        
        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupHM) || string.IsNullOrWhiteSpace(strPickupPlace))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetHM) || string.IsNullOrWhiteSpace(strGetPlace))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objWebOrderModel = new WebOrderModel
            {
                ReqSeqNo                  = strReqSeqNo.ToInt64(),
                CenterCode                = strCenterCode.ToInt(),
                ConsignorName             = strConsignorName,
                OrderItemCode             = strOrderItemCode,
                ReqNo                     = strReqNo,
                ReqChargeName             = strReqChargeName,
                ReqChargeTeam             = strReqChargeTeam,
                ReqChargeTel              = strReqChargeTel,
                ReqChargeCell             = strReqChargeCell,
                PickupYMD                 = strPickupYMD,
                PickupHM                  = strPickupHM,
                PickupPlace               = strPickupPlace,
                PickupPlacePost           = strPickupPlacePost,
                PickupPlaceAddr           = strPickupPlaceAddr,
                PickupPlaceAddrDtl        = strPickupPlaceAddrDtl,
                PickupPlaceFullAddr       = strPickupPlaceFullAddr,
                PickupPlaceChargeName     = strPickupPlaceChargeName,
                PickupPlaceChargePosition = strPickupPlaceChargePosition,
                PickupPlaceChargeTelExtNo = strPickupPlaceChargeTelExtNo,
                PickupPlaceChargeTelNo    = strPickupPlaceChargeTelNo,
                PickupPlaceChargeCell     = strPickupPlaceChargeCell,
                PickupPlaceNote           = strPickupPlaceNote,
                GetYMD                    = strGetYMD,
                GetHM                     = strGetHM,
                GetPlace                  = strGetPlace,
                GetPlacePost              = strGetPlacePost,
                GetPlaceAddr              = strGetPlaceAddr,
                GetPlaceAddrDtl           = strGetPlaceAddrDtl,
                GetPlaceFullAddr          = strGetPlaceFullAddr,
                GetPlaceChargeName        = strGetPlaceChargeName,
                GetPlaceChargePosition    = strGetPlaceChargePosition,
                GetPlaceChargeTelExtNo    = strGetPlaceChargeTelExtNo,
                GetPlaceChargeTelNo       = strGetPlaceChargeTelNo,
                GetPlaceChargeCell        = strGetPlaceChargeCell,
                GetPlaceNote              = strGetPlaceNote,
                Nation                    = strNation,
                Hawb                      = strHawb,
                Mawb                      = strMawb,
                InvoiceNo                 = strInvoiceNo,
                BookingNo                 = strBookingNo,
                StockNo                   = strStockNo,
                ArrivalReportFlag         = strArrivalReportFlag,
                BondedFlag                = strBondedFlag,
                NoteClient                = strNoteClient,
                GoodsName                 = strGoodsName,
                GoodsItemCode             = strGoodsItemCode,
                GoodsRunType              = strGoodsRunType.ToInt(),
                FTLFlag                   = strFTLFlag, // 2023-03-16 by shadow54 : 자동운임 수정 건
                CBM                       = strCBM.ToDouble(),
                Volume                    = strVolume.ToInt(),
                Weight                    = strWeight.ToDouble(),
                Quantity                  = strQuantity,
                ShuttleEtc                = strShuttleEtc,
                UpdAdminID                = objSes.AdminID,
                UpdAdminName              = objSes.AdminName
            };

            lo_objResWebOrderModel = objWebOrderDasServices.SetWebOrderUpd(lo_objWebOrderModel);
            objResMap.RetCode      = lo_objResWebOrderModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResWebOrderModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 배차 목록
    /// </summary>
    protected void GetWebInoutDispatchCarList()
    {
        ServiceResult<ResOrderDispatchCarList> lo_objResOrderDispatchCarList = null;

        if (strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strOrderNo.Equals("0") || string.IsNullOrWhiteSpace(strOrderNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strGoodsSeqNo.Equals("0") || string.IsNullOrWhiteSpace(strGoodsSeqNo))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResOrderDispatchCarList = objOrderDasServices.GetOrderDispatchCarList(strCenterCode.ToInt(), strOrderNo.ToInt64(), strGoodsSeqNo.ToInt64(), objSes.AccessCenterCode);
            objResMap.strResponse         = "[" + JsonConvert.SerializeObject(lo_objResOrderDispatchCarList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9409;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 비용 목록
    /// </summary>
    protected void GetWebDomesticPayList()
    {
        ServiceResult<ResOrderPayList> lo_objResOrderPayList = null;

        if (strOrderNo.Equals("0") || string.IsNullOrWhiteSpace(strOrderNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResOrderPayList = objWebOrderDasServices.GetOrderRequestPayList(strCenterCode.ToInt(), strOrderNo.ToInt64(), strClientCode.ToInt64(), objSes.AccessCenterCode, objSes.AccessCorpNo);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9410;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetWebOrderCancel()
    {
        WebOrderModel                lo_objWebOrderModel        = null;
        ServiceResult<WebOrderModel> lo_objResWebOrderModel     = null;

        if (string.IsNullOrWhiteSpace(strReqSeqNo) || strReqSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objWebOrderModel = new WebOrderModel
            {
                ReqSeqNo     = strReqSeqNo.ToInt64(),
                UpdAdminID   = objSes.AdminID,
                UpdAdminName = objSes.AdminName
            };

            lo_objResWebOrderModel = objWebOrderDasServices.SetWebOrderCancel(lo_objWebOrderModel);
            objResMap.RetCode      = lo_objResWebOrderModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResWebOrderModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 원본오더 조회
    /// </summary>
    protected void CallWebOrderRequestList()
    {
        WebReqOrderList                lo_objWebReqOrderList = null;
        ServiceResult<WebResOrderList> lo_objWebResOrderList = null;

        try
        {
            lo_objWebReqOrderList = new WebReqOrderList
            {
                ReqSeqNo         = strReqSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                DateType         = strDateType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                OrderNo          = strOrderNo.ToInt64(),
                OrderClientName  = strOrderClientName,
                PayClientName    = strPayClientName,
                ConsignorName    = strConsignorName,
                ReqChargeName    = strReqChargeName,
                GoodsName        = strGoodsName,
                ReqStatus        = strReqStatus.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objWebResOrderList = objWebOrderDasServices.GetWebRequestOrderList(lo_objWebReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objWebResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9412;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    protected void SetWebOrderRequestCnlInsert()
    {
        WebOrderModel                lo_objWebOrderModel    = null;
        ServiceResult<WebOrderModel> lo_objResWebOrderModel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objWebOrderModel = new WebOrderModel
            {
                CenterCode      = strCenterCode.ToInt(),
                OrderNo         = strOrderNo.ToInt64(),
                OrderClientCode = strOrderClientCode.ToInt64(),
                ChgReqContent   = strChgReqContent,
                ChgMessage      = strChgMessage,
                ChgStatus       = strChgStatus.ToInt(),
                RegAdminID      = objSes.AdminID,
                RegAdminName    = objSes.AdminName
            };

            lo_objResWebOrderModel = objWebOrderDasServices.SetWebOrderRequestChgIns(lo_objWebOrderModel);
            objResMap.RetCode      = lo_objResWebOrderModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResWebOrderModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void SetWebOrderRequestCnlUpdate()
    {
        WebOrderModel                lo_objWebOrderModel    = null;
        ServiceResult<WebOrderModel> lo_objResWebOrderModel = null;

        if (string.IsNullOrWhiteSpace(strChgSeqNo) || strChgSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objWebOrderModel = new WebOrderModel
            {
                ChgSeqNo      = strChgSeqNo.ToInt64(),
                ChgReqContent = strChgReqContent,
                ChgMessage    = strChgMessage,
                ChgStatus     = strChgStatus.ToInt(),
                UpdAdminID    = objSes.AdminID,
                UpdAdminName  = objSes.AdminName
            };

            lo_objResWebOrderModel = objWebOrderDasServices.SetWebOrderRequestChgUpd(lo_objWebOrderModel);
            objResMap.RetCode      = lo_objResWebOrderModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResWebOrderModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetWebRequestChgList()
    {
        WebReqOrderList                lo_objWebReqOrderList = null;
        ServiceResult<WebResOrderList> lo_objWebResOrderList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objWebReqOrderList = new WebReqOrderList
            {
                ChgSeqNo         = strChgSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                OrderClientCode  = strOrderClientCode.ToInt64(),
                ChgStatus        = strChgStatus.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objWebResOrderList = objWebOrderDasServices.GetWebRequestChgList(lo_objWebReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objWebResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9415;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 배차 목록
    /// </summary>
    protected void GetDomesticDispatchCarList()
    {
        ServiceResult<ResOrderDispatchCarList> lo_objResOrderDispatchCarList = null;

        if (strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strOrderNo.Equals("0") || string.IsNullOrWhiteSpace(strOrderNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strGoodsSeqNo.Equals("0") || string.IsNullOrWhiteSpace(strGoodsSeqNo))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResOrderDispatchCarList = objOrderDasServices.GetOrderDispatchCarList(strCenterCode.ToInt(), strOrderNo.ToInt64(), strGoodsSeqNo.ToInt64(), objSes.AccessCenterCode);
            objResMap.strResponse         = "[" + JsonConvert.SerializeObject(lo_objResOrderDispatchCarList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9416;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WebInoutHandler", "Exception",
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