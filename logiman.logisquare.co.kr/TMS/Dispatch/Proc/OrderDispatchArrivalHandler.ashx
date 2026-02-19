<%@ WebHandler Language="C#" Class="OrderDispatchArrivalHandler" %>
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
/// FileName        : OrderDispatchArrivalHandler.ashx
/// Description     : 도착보고현황 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-08-08
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderDispatchArrivalHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Dispatch/OrderDispatchArrivalList"; //필수
        
    // 메소드 리스트
    private const string MethodOrderDispatchList                 = "OrderDispatchList";                 //배차현황 목록
    private const string MethodOrderDispatchListExcel            = "OrderDispatchListExcel";            //배차현황 엑셀 목록
    private const string MethodOrderDispatchArrivalWorkListExcel = "OrderDispatchArrivalWorkListExcel"; //도보 작업지시서 엑셀 목록
    private const string MethodOrderDispatchCnl                  = "OrderDispatchCnl";                  //배차취소
    private const string MethodOrderDispatchArrivalPayList       = "OrderDispatchArrivalPayList";       //도착보고 비용등록 리스트
    private const string MethodOrderDispatchPayInsert            = "OrderDispatchPayInsert";            //비용등록
    private const string MethodOrderDispatchPayUpdate            = "OrderDispatchPayUpdate";            //비용수정
    private const string MethodOrderGoodsArrivalIns              = "OrderGoodsArrivalIns";              //도착보고 등록
    private const string MethodOrderGoodsArrivalDocumentUpd      = "OrderGoodsArrivalDocumentUpd";      //서류등록
    private const string MethodOrderDispatchArrivalWorkList      = "OrderDispatchArrivalWorkList";      //도보 작업지시서 업체 목록
    private const string MethodOrderArrivalPayIns                = "OrderArrivalPayIns";                //도착보고 비용등록
    private const string MethodClientChargeList                  = "ClientChargeList";                  //고객사 + 담당자 목록
    private const string MethodArrivalReportNoUpdate             = "ArrivalReportNoUpdate";             //입고 번호 수정
    private const string MethodOrderFileList                     = "OrderFileList";
    private const string MethodOrderFileDownload                 = "OrderFileDownload";

    OrderDispatchDasServices objOrderDispatchDasServices = new OrderDispatchDasServices();
    OrderDasServices         objOrderDasServices         = new OrderDasServices();
    ClientDasServices        objClientDasServices        = new ClientDasServices();
        
    private HttpContext objHttpContext = null;

    private string strCallType                = string.Empty;
    private int    intPageSize                = 0;
    private int    intPageNo                  = 0;
    private string strCenterCode              = string.Empty;
    private string strDateType                = string.Empty;
    private string strDateFrom                = string.Empty;
    private string strDateTo                  = string.Empty;
    private string strOrderLocationCodes      = string.Empty;
    private string strOrderItemCodes          = string.Empty;
    private string strOrderStatuses           = string.Empty;
    private string strSearchClientType        = string.Empty;
    private string strSearchClientText        = string.Empty;
    private string strOrderNo                 = string.Empty;
    private string strOrderNos                = string.Empty;
    private string strClientCode              = string.Empty;
    private string strClientCodes             = string.Empty;
    private string strMyChargeFlag            = string.Empty;
    private string strMyOrderFlag             = string.Empty;
    private string strCarNo                   = string.Empty;
    private string strCarNo2                  = string.Empty;
    private string strCarNo3                  = string.Empty;
    private string strDispatchAdminName       = string.Empty;
    private string strComName                 = string.Empty;
    private string strOrderClientName         = string.Empty;
    private string strPayClientName           = string.Empty;
    private string strConsignorName           = string.Empty;
    private string strGoodsDispatchType       = string.Empty;
    private string strDispatchType            = string.Empty;
    private string strPurchaseItemCode        = string.Empty;
    private string strPurchaseSeqNo           = string.Empty;
    private string strGoodsSeqNo              = string.Empty;
    private string strDispatchSeqNo           = string.Empty;
    private string strPayType                 = string.Empty;
    private string strTaxKind                 = string.Empty;
    private string strItemCode                = string.Empty;
    private string strClientName              = string.Empty;
    private string strSupplyAmt               = string.Empty;
    private string strTaxAmt                  = string.Empty;
    private string strArrivalReportFlag       = string.Empty;
    private string strChargeSeqNo             = string.Empty;
    private string strGoodsSeqNos             = string.Empty;
    private string strArrivalReportNo         = string.Empty;
    private string strCnlFlag                 = string.Empty;
    private string strDispatchSeqNos          = string.Empty;
    private string strPurchaseSeqNos          = string.Empty;
    private string strPurchaseType            = string.Empty;
    private string strListType                = string.Empty;
    private string strDeliveryLocationCodes   = string.Empty;
    private string strGetStandardType         = string.Empty;
    private string strChargeName              = string.Empty;
    private string strClientNames             = string.Empty;
    private string strArrivalReportClientName = string.Empty;
    private string strOrderByPageType         = string.Empty;
    private string strFileNameNew             = string.Empty;
    private string strFileName                = string.Empty;
    private string strTempFlag                = string.Empty;
    private string strFileSeqNo               = string.Empty;
    private string strChargeNames             = string.Empty;
    private string strChargeCells             = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderDispatchList,                 MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderDispatchListExcel,            MenuAuthType.All); ;
        objMethodAuthList.Add(MethodOrderDispatchArrivalWorkListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodOrderDispatchCnl,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderDispatchArrivalPayList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderDispatchPayInsert,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderDispatchPayUpdate,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderGoodsArrivalIns,              MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderGoodsArrivalDocumentUpd,      MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderDispatchArrivalWorkList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderArrivalPayIns,                MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientChargeList,                  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderFileList,                     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderFileDownload,                 MenuAuthType.All);
        objMethodAuthList.Add(MethodArrivalReportNoUpdate,             MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderDispatchArrivalHandler");
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
            strCenterCode              = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strOrderNo                 = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strClientCode              = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strClientCodes             = SiteGlobal.GetRequestForm("ClientCodes");
            strOrderNos                = SiteGlobal.GetRequestForm("OrderNos");
            strDateType                = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "0");
            strDateFrom                = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                  = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes      = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes          = SiteGlobal.GetRequestForm("OrderItemCodes");
            strOrderStatuses           = SiteGlobal.GetRequestForm("OrderStatuses");
            strSearchClientType        = SiteGlobal.GetRequestForm("SearchClientType");
            strSearchClientText        = SiteGlobal.GetRequestForm("SearchClientText");
            strMyChargeFlag            = SiteGlobal.GetRequestForm("MyChargeFlag");
            strMyOrderFlag             = SiteGlobal.GetRequestForm("MyOrderFlag");
            strCarNo                   = SiteGlobal.GetRequestForm("CarNo");
            strCarNo2                  = SiteGlobal.GetRequestForm("CarNo2");
            strCarNo3                  = SiteGlobal.GetRequestForm("CarNo3");
            strDispatchAdminName       = SiteGlobal.GetRequestForm("DispatchAdminName");
            strComName                 = SiteGlobal.GetRequestForm("ComName");
            strGoodsDispatchType       = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsDispatchType"), "0");
            strDispatchType            = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchType"),      "0");
            strPurchaseItemCode        = SiteGlobal.GetRequestForm("PurchaseItemCode");
            strPurchaseSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseSeqNo"), "0");
            strGoodsSeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"),    "0");
            strDispatchSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strPayType                 = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"),       "0");
            strTaxKind                 = Utils.IsNull(SiteGlobal.GetRequestForm("TaxKind"),       "0");
            strItemCode                = SiteGlobal.GetRequestForm("ItemCode");
            strClientName              = SiteGlobal.GetRequestForm("ClientName");
            strSupplyAmt               = Utils.IsNull(SiteGlobal.GetRequestForm("SupplyAmt"), "0");
            strTaxAmt                  = Utils.IsNull(SiteGlobal.GetRequestForm("TaxAmt"),    "0");
            strArrivalReportFlag       = SiteGlobal.GetRequestForm("ArrivalReportFlag");
            strChargeSeqNo             = Utils.IsNull(SiteGlobal.GetRequestForm("ChargeSeqNo"), "0");
            strGoodsSeqNos             = SiteGlobal.GetRequestForm("GoodsSeqNos");
            strArrivalReportNo         = SiteGlobal.GetRequestForm("ArrivalReportNo");
            strCnlFlag                 = SiteGlobal.GetRequestForm("CnlFlag");
            strDispatchSeqNos          = SiteGlobal.GetRequestForm("DispatchSeqNos");
            strPurchaseSeqNos          = SiteGlobal.GetRequestForm("PurchaseSeqNos");
            strPurchaseType            = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseType"), "0");
            strListType                = Utils.IsNull(SiteGlobal.GetRequestForm("ListType"),     "0");
            strDeliveryLocationCodes   = SiteGlobal.GetRequestForm("DeliveryLocationCodes");
            strGetStandardType         = Utils.IsNull(SiteGlobal.GetRequestForm("GetStandardType"), "0");
            strChargeName              = SiteGlobal.GetRequestForm("ChargeName");
            strClientNames             = SiteGlobal.GetRequestForm("ClientNames");
            strArrivalReportClientName = SiteGlobal.GetRequestForm("ArrivalReportClientName");
            strOrderByPageType         = Utils.IsNull(SiteGlobal.GetRequestForm("OrderByPageType"), "0");
            strFileNameNew             = Utils.GetDecrypt(SiteGlobal.GetRequestForm("FileNameNew"));
            strFileName                = SiteGlobal.GetRequestForm("FileName");
            strTempFlag                = SiteGlobal.GetRequestForm("TempFlag");
            strFileSeqNo               = Utils.IsNull(Utils.GetDecrypt(SiteGlobal.GetRequestForm("FileSeqNo")), "0");
            strChargeNames             = SiteGlobal.GetRequestForm("ChargeNames");
            strChargeCells             = SiteGlobal.GetRequestForm("ChargeCells");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", string.Empty);
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", string.Empty);

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
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
                case MethodOrderDispatchList:
                    GetOrderDispatchList();
                    break;
                case MethodOrderDispatchListExcel:
                    GetOrderDispatchListExcel();
                    break;
                case MethodOrderDispatchArrivalWorkListExcel:
                    GetOrderDispatchArrivalWorkListExcel();
                    break;
                case MethodOrderDispatchCnl:
                    SetOrderDispatchCnl();
                    break;
                case MethodOrderDispatchArrivalPayList:
                    GetOrderDispatchArrivalPayList();
                    break;
                case MethodOrderDispatchPayInsert:
                    GetOrderDispatchPayInsert();
                    break;
                case MethodOrderDispatchPayUpdate:
                    GetOrderDispatchPayUpdate();
                    break;
                case MethodOrderGoodsArrivalIns:
                    SetOrderGoodsArrivalIns();
                    break;
                case MethodOrderGoodsArrivalDocumentUpd:
                    SetOrderGoodsArrivalDocumentUpd();
                    break;
                case MethodOrderDispatchArrivalWorkList:
                    GetOrderDispatchArrivalWorkList();
                    break;
                case MethodOrderArrivalPayIns:
                    SetOrderArrivalPayIns();
                    break;
                case MethodClientChargeList:
                    GetClientChargeList();
                    break;
                case MethodOrderFileList:
                    GetFileList();
                    break;
                case MethodOrderFileDownload:
                    SetFileDownload();
                    break;
                case MethodArrivalReportNoUpdate:
                    SetArrivalReportNoUpdate();
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

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 배차 현황 목록
    /// </summary>
    protected void GetOrderDispatchList()
    {
        ReqOrderDispatchList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderList = null;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (!string.IsNullOrWhiteSpace(strSearchClientType) && !string.IsNullOrWhiteSpace(strSearchClientText))
        {
            switch (strSearchClientType)
            {
                case "1":
                    strOrderClientName = strSearchClientText;
                    break;
                case "2":
                    strPayClientName = strSearchClientText;
                    break;
                case "3":
                    strConsignorName = strSearchClientText;
                    break;
            }
        }

        try
        {
            lo_objReqOrderList = new ReqOrderDispatchList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                ListType                = strListType.ToInt(),
                DateType                = strDateType.ToInt(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                GoodsDispatchType       = strGoodsDispatchType.ToInt(),
                DispatchType            = strDispatchType.ToInt(),
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderStatuses           = strOrderStatuses,
                OrderClientName         = strOrderClientName,
                PayClientName           = strPayClientName,
                ConsignorName           = strConsignorName,
                ComName                 = strComName,
                CarNo                   = strCarNo,
                CarNo2                  = strCarNo2,
                CarNo3                  = strCarNo3,
                MyChargeFlag            = strMyChargeFlag,
                MyOrderFlag             = strMyOrderFlag,
                DispatchAdminName       = strDispatchAdminName,
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode,
                ArrivalReportFlag       = strArrivalReportFlag,
                ArrivalReportClientCode = strClientCode.ToInt(),
                ArrivalReportClientName = strArrivalReportClientName,
                DeliveryLocationCodes   = strDeliveryLocationCodes,
                CnlFlag                 = "N",
                OrderByPageType         = strOrderByPageType.ToInt(),
                GetStandardType         = strGetStandardType.ToInt(),
                PageSize                = intPageSize,
                PageNo                  = intPageNo
            };
                
            lo_objResOrderList    = objOrderDispatchDasServices.GetOrderDispatchList(lo_objReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetOrderDispatchListExcel()
    {
        SpreadSheet                         lo_objExcel        = null;
        DataTable                           lo_dtData          = null;
        MemoryStream                        lo_outputStream    = null;
        ReqOrderDispatchList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderList = null;
        string                              lo_strFileName     = string.Empty;
        byte[]                              lo_Content         = null;
        int                                 lo_intColumnIndex  = 0;
        double                              lo_intRevenue      = 0;
        double                              lo_intRevenuePer   = 0.0;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (!string.IsNullOrWhiteSpace(strSearchClientType) && !string.IsNullOrWhiteSpace(strSearchClientText))
        {
            switch (strSearchClientType)
            {
                case "1":
                    strOrderClientName = strSearchClientText;
                    break;
                case "2":
                    strPayClientName = strSearchClientText;
                    break;
                case "3":
                    strConsignorName = strSearchClientText;
                    break;
            }
        }

        try
        {
            lo_objReqOrderList = new ReqOrderDispatchList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                ListType                = strListType.ToInt(),
                DateType                = strDateType.ToInt(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                GoodsDispatchType       = strGoodsDispatchType.ToInt(),
                DispatchType            = strDispatchType.ToInt(),
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderStatuses           = strOrderStatuses,
                OrderClientName         = strOrderClientName,
                PayClientName           = strPayClientName,
                ConsignorName           = strConsignorName,
                ComName                 = strComName,
                CarNo                   = strCarNo,
                CarNo2                  = strCarNo2,
                CarNo3                  = strCarNo3,
                MyChargeFlag            = strMyChargeFlag,
                MyOrderFlag             = strMyOrderFlag,
                DispatchAdminName       = strDispatchAdminName,
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode,
                ArrivalReportFlag       = strArrivalReportFlag,
                ArrivalReportClientCode = strClientCode.ToInt(),
                ArrivalReportClientName = strArrivalReportClientName,
                DeliveryLocationCodes   = strDeliveryLocationCodes,
                CnlFlag                 = "N",
                GetStandardType         = strGetStandardType.ToInt(),
                PageSize                = intPageSize,
                PageNo                  = intPageNo
            };

            lo_objResOrderList = objOrderDispatchDasServices.GetOrderDispatchList(lo_objReqOrderList);
                
            lo_dtData = new DataTable();
                
            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상태",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("이관정보",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(발)담당자",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(발)내선",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(발)전화번호", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(발)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)담당자",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)내선",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구사업장",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("상차요청시간",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차방법",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)우편번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소상세", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)담당자명", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)직급",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)내선",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)전화번호", typeof(string)));
                
            lo_dtData.Columns.Add(new DataColumn("(상)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)지역코드",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)지역명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)특이사항",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청시간",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차방법",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)우편번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)주소",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(하)주소상세",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)담당자명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)직급",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)내선",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)지역코드",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)지역명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)특이사항",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("이단불가",     typeof(string)));
                
            lo_dtData.Columns.Add(new DataColumn("무탑배차", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("FTL",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청톤급", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청차종", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("통관",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("보세",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("서류",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("도착보고", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("면허진행", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("시간엄수", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("특별관제",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차긴급",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("목적국",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("H/AWB",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("M/AWB",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Booking No.", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Invoice No.", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("입고 No.",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더구분",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Trip ID",     typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("총수량",      typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총부피",      typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총중량",      typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총길이",      typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("화물정보",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("비고",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고객전달사항",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(계)업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(계)사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(계)담당자",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(계)전화번호",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(계)이메일",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("배차구분",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("직송차량",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("집하차량",        typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(집하)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("간선차량",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)기사명",     typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(간선)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("배송차량",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수일",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수자명",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최종수정일",       typeof(string))); 

            lo_dtData.Columns.Add(new DataColumn("최종수정자명",      typeof(string)));

            foreach (var row in lo_objResOrderList.data.list)
            {
                lo_dtData.Rows.Add(row.CenterName,row.OrderStatusM,row.OrderNo,row.TransInfo,row.OrderItemCodeM
                                ,row.OrderLocationCodeM,row.OrderClientName,row.OrderClientChargeName,row.OrderClientChargeTelExtNo,row.OrderClientChargeTelNo
                                ,row.OrderClientChargeCell,row.PayClientTypeM,row.PayClientName,row.PayClientChargeName,row.PayClientChargeTelExtNo
                                ,row.PayClientChargeTelNo,row.PayClientChargeCell,row.PayClientChargeLocation,row.ConsignorName,row.PickupYMD
                                ,row.PickupHM,row.PickupWay,row.PickupPlace,row.PickupPlacePost,row.PickupPlaceAddr
                                ,row.PickupPlaceAddrDtl,row.PickupPlaceChargeName,row.PickupPlaceChargePosition,row.PickupPlaceChargeTelExtNo,row.PickupPlaceChargeTelNo
                                ,row.PickupPlaceChargeCell,row.PickupPlaceLocalCode,row.PickupPlaceLocalName,row.PickupPlaceNote,row.GetYMD
                                ,row.GetHM,row.GetWay,row.GetPlace,row.GetPlacePost,row.GetPlaceAddr
                                ,row.GetPlaceAddrDtl,row.GetPlaceChargeName,row.GetPlaceChargePosition,row.GetPlaceChargeTelExtNo,row.GetPlaceChargeTelNo
                                ,row.GetPlaceChargeCell,row.GetPlaceLocalCode,row.GetPlaceLocalName,row.GetPlaceNote,row.NoLayerFlag
                                ,row.NoTopFlag,row.FTLFlag,row.CarTonCodeM,row.CarTypeCodeM,row.CustomFlag
                                ,row.BondedFlag,row.DocumentFlag,row.ArrivalReportFlag,row.LicenseFlag,row.InTimeFlag
                                ,row.ControlFlag,row.QuickGetFlag,row.Nation,row.Hawb,row.Mawb
                                ,row.BookingNo,row.InvoiceNo,row.StockNo,row.GMOrderType,row.GMTripID
                                ,row.Volume,row.CBM,row.Weight,row.Length,row.Quantity
                                ,row.NoteInside,row.NoteClient,row.TaxClientName,row.TaxClientCorpNo,row.TaxClientChargeName
                                ,row.TaxClientChargeTelNo,row.TaxClientChargeEmail,row.GoodsDispatchTypeM,row.DispatchCarNo1,row.CarDivTypeM1
                                ,row.ComName1,row.ComCorpNo1,row.DriverName1,row.DriverCell1,row.DispatchCarNo2
                                ,row.CarDivTypeM2, row.ComName2, row.ComCorpNo2, row.DriverName2, row.DriverCell2
                                ,row.DispatchCarNo3,row.CarDivTypeM3,row.ComName3,row.ComCorpNo3,row.DriverName3
                                ,row.DriverCell3,row.DispatchCarNo4,row.CarDivTypeM4,row.ComName4,row.ComCorpNo4
                                ,row.DriverName4,row.DriverCell4,row.AcceptDate,row.AcceptAdminName,row.UpdDate
                                ,row.UpdAdminName);
            }

            lo_objExcel = new SpreadSheet {SheetName = "DispatchList"};

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
            objResMap.RetCode = 9704;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }


    protected void GetOrderDispatchArrivalWorkListExcel()
    {
        SpreadSheet                                         lo_objExcel                   = null;
        DataTable                                           lo_dtData                     = null;
        DataTable                                           lo_dtDataInfo                 = null;
        MemoryStream                                        lo_outputStream               = null;
        ReqOrderDispatchArrivalWorkExcelList                lo_objReqOrderList            = null;
        ServiceResult<ResOrderDispatchArrivalWorkExcelList> lo_objResOrderList            = null;
        string                                              lo_strFileName                = string.Empty;
        byte[]                                              lo_Content                    = null;
        int                                                 lo_intColumnIndex             = 0;
        string[]                                            lo_strArrClientCode           = strClientCodes.Split(',');
        string[]                                            lo_strArrClientName           = strClientNames.Split(',');
        string[]                                            lo_strArrChargeName           = strChargeNames.Split(',');
        string[]                                            lo_strArrChargeCell           = strChargeCells.Split(',');
        int                                                 lo_intVolumeTotal             = 0;
        double                                              lo_intCBMTotal                = 0;
        double                                              lo_intWeightTotal             = 0;
        int                                                 lo_intNumber                  = 1;

        try
        {
            lo_dtData     = new DataTable();
            lo_dtDataInfo = new DataTable();
                
            lo_dtData.Columns.Add(new DataColumn("No",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("도보",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("서류",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차긴급여부", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("배차구분",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차차량",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사휴대폰",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("수량",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("CBM",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("무게",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차일",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)담당자",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("목적국",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("부킹넘버",     typeof(string)));
                
            lo_dtDataInfo.Columns.Add(new DataColumn("작업지시서",      typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));

            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));

            if (lo_strArrClientCode.Length > 0)
            {
                for (var i = 0; i < lo_strArrClientCode.Length; i++)
                {
                    lo_intVolumeTotal             = 0;
                    lo_intCBMTotal                = 0;
                    lo_intWeightTotal             = 0;
                    lo_intNumber                  = 1;
                    lo_intColumnIndex             = 0;

                    lo_dtData.Rows.Clear();
                    lo_dtDataInfo.Rows.Clear();

                    if (lo_objExcel == null)
                    {
                        lo_objExcel = new SpreadSheet { SheetName = lo_strArrClientName[i] + "-" + lo_strArrChargeName[i] };
                    }
                    else
                    {
                        lo_objExcel.AddWorkSheet(lo_strArrClientName[i] + "-" + lo_strArrChargeName[i]);
                    }

                    lo_objReqOrderList = new ReqOrderDispatchArrivalWorkExcelList
                    {
                        CenterCode              = strCenterCode.ToInt(),
                        DateType                = strDateType.ToInt(),
                        DateFrom                = strDateFrom,
                        DateTo                  = strDateTo,
                        OrderLocationCodes      = strOrderLocationCodes,
                        OrderItemCodes          = strOrderItemCodes,
                        ArrivalReportClientCode = lo_strArrClientCode[i].ToInt(),
                        ArrivalReportChargeName = lo_strArrChargeName[i],
                        AccessCenterCode        = objSes.AccessCenterCode
                    };

                    lo_objResOrderList = objOrderDispatchDasServices.GetOrderDispatchArrivalWorkExcelList(lo_objReqOrderList);

                    foreach (var row in lo_objResOrderList.data.list)
                    {
                        lo_dtData.Rows.Add(lo_intNumber,row.ArrivalReportFlag,row.DocumentFlag,row.QuickGetFlag,row.ConsignorName
                            ,row.DispatchTypeM,row.CarNo,row.DriverCell,row.Volume,row.CBM
                            ,row.Weight,row.GetPlace,row.GetYMD,row.GetPlaceChargeName,row.Nation
                            ,row.BookingNo);

                        lo_intNumber++;
                        lo_intVolumeTotal             += row.Volume;
                        lo_intCBMTotal                += row.CBM;
                        lo_intWeightTotal             += row.Weight;
                    }
                    
                    lo_dtDataInfo.Rows.Add($"DATE : {Utils.ConvertDateFormat(strDateFrom)} ~ {Utils.ConvertDateFormat(strDateTo)}  |  사업자명 : {lo_strArrClientName[i]} (담당자 : {lo_strArrChargeName[i]} / 연락처 : {lo_strArrChargeCell[i]})  |  수량 : {lo_intVolumeTotal}  |  부피 : {lo_intCBMTotal}  |  중량 : {lo_intWeightTotal}"
                        , string.Empty, string.Empty, string.Empty, string.Empty
                        , string.Empty, string.Empty, string.Empty, string.Empty, string.Empty
                        , string.Empty, string.Empty, string.Empty, string.Empty, string.Empty
                        , string.Empty);

                    lo_objExcel.FreezeCell(1);
                    lo_objExcel.MergeColumn(1, 1, 1, 16);
                    lo_objExcel.MergeColumn(2, 1, 2, 16);
                    lo_objExcel.InsertDataTable(lo_dtDataInfo, true, 1, 1, true, false, System.Drawing.Color.White, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
                    lo_objExcel.InsertDataTable(lo_dtData, true, 3, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
                    lo_objExcel.InsertValue(2, 16, "", 14, true, HorizontalAlignmentValues.Center);
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

                    lo_objExcel.SetFontSize(10, 18);
                    lo_objExcel.SetAutoFitRow(lo_strArrClientName[i]);
                    lo_objExcel.SetAutoFitColumn(lo_strArrClientName[i]);
                }
            }

            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);

            lo_Content = lo_outputStream.ToArray();

            lo_strFileName = $"도보작업지시서_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

            objResponse.Clear();
            objResponse.SetCookie(new HttpCookie("fileDownload", "true") { Path = "/", HttpOnly = false });
            objResponse.ContentType = "application/vnd.ms-excel";
            objResponse.AddHeader("content-disposition", "attachment; filename=" + lo_strFileName);
            objResponse.OutputStream.Write(lo_Content, 0, lo_Content.Length);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9704;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 도착보고 비용 목록
    /// </summary>
    protected void GetOrderDispatchArrivalPayList()
    {

        ReqOrderDispatchList                lo_objReqOrderDispatchPayList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderDispatchPayList = null;

        try
        {
            lo_objReqOrderDispatchPayList = new ReqOrderDispatchList
            {
                OrderNo               = strOrderNo.ToInt64(),
                CenterCode            = strCenterCode.ToInt(),
                ListType              = strListType.ToInt(),
                DateType              = strDateType.ToInt(),
                DateFrom              = strDateFrom,
                DateTo                = strDateTo,
                GoodsDispatchType     = strGoodsDispatchType.ToInt(),
                OrderLocationCodes    = strOrderLocationCodes,
                OrderItemCodes        = strOrderItemCodes,
                OrderClientName       = strClientName,
                PurchaseItemCode      = strPurchaseItemCode,
                AccessCenterCode      = objSes.AccessCenterCode,
                CnlFlag               = "N",
                ArrivalReportFlag     = strArrivalReportFlag,
                PageSize              = intPageSize,
                PageNo                = intPageNo,
            };

            lo_objResOrderDispatchPayList = objOrderDispatchDasServices.GetOrderDispatchArrivalPayList(lo_objReqOrderDispatchPayList);
            objResMap.strResponse         = "[" + JsonConvert.SerializeObject(lo_objResOrderDispatchPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    //배차취소
    protected void SetOrderDispatchCnl()
    {
        OrderDispatchModel                lo_objReqOrderDispatchModel = null;
        ServiceResult<OrderDispatchModel> lo_objResOrderDispatchModel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDispatchSeqNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchModel = new OrderDispatchModel
            {
                DispatchSeqNos      = strDispatchSeqNos,
                CenterCode          = strCenterCode.ToInt(),
                AdminID             = objSes.AdminID,
                AdminName           = objSes.AdminName
            };
                
            lo_objResOrderDispatchModel = objOrderDispatchDasServices.UpdOrderDispatchCnl(lo_objReqOrderDispatchModel);
            objResMap.RetCode           = lo_objResOrderDispatchModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9502;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetOrderDispatchPayInsert()
    {
        OrderPayModel                lo_objOrderPayModel  = null;
        ServiceResult<OrderPayModel> lo_objResOrderPayIns = null;

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

        if (!string.IsNullOrWhiteSpace(strPurchaseSeqNo) && !strPurchaseSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "등록할 수 있는 비용이 아닙니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayType) || strPayType.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strTaxKind) || strTaxKind.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strItemCode))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strPayType.Equals("2") || strPayType.Equals("3") || strPayType.Equals("4"))
        {
            if (string.IsNullOrWhiteSpace(strDispatchSeqNo) || strDispatchSeqNo.Equals("0"))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }

        try
        {
            lo_objOrderPayModel = new OrderPayModel
            {
                CenterCode    = strCenterCode.ToInt(),
                OrderNo       = strOrderNo.ToInt64(),
                GoodsSeqNo    = strGoodsSeqNo.ToInt64(),
                DispatchSeqNo = strDispatchSeqNo.ToInt64(),
                PayType       = strPayType.ToInt(),
                TaxKind       = strTaxKind.ToInt(),
                ItemCode      = strItemCode,
                ClientCode    = strClientCode.ToInt64(),
                ClientName    = strClientName,
                SupplyAmt     = strSupplyAmt.ToDouble(),
                TaxAmt        = strTaxAmt.ToDouble(),
                RegAdminID    = objSes.AdminID,
                RegAdminName  = objSes.AdminName
            };
                
            lo_objResOrderPayIns = objOrderDasServices.SetOrderPayIns(lo_objOrderPayModel);
            objResMap.RetCode    = lo_objResOrderPayIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderPayIns.result.ErrorMsg;
            }
            else { 
                objResMap.Add("PurchaseSeqNo", lo_objResOrderPayIns.data.SeqNo);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetOrderDispatchPayUpdate()
    {
        OrderPayModel       lo_objOrderPayModel  = null;
        ServiceResult<bool> lo_objResOrderPayIns = null;

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

        if (string.IsNullOrWhiteSpace(strPurchaseSeqNo) && strPurchaseSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayType) || strPayType.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strTaxKind) || strTaxKind.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strItemCode))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strPayType.Equals("2") || strPayType.Equals("3") || strPayType.Equals("4"))
        {
            if (string.IsNullOrWhiteSpace(strDispatchSeqNo) || strDispatchSeqNo.Equals("0"))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }

        try
        {
            lo_objOrderPayModel = new OrderPayModel
            {
                SeqNo         = strPurchaseSeqNo.ToInt(),
                CenterCode    = strCenterCode.ToInt(),
                OrderNo       = strOrderNo.ToInt64(),
                GoodsSeqNo    = strGoodsSeqNo.ToInt64(),
                DispatchSeqNo = strDispatchSeqNo.ToInt64(),
                PayType       = strPayType.ToInt(),
                TaxKind       = strTaxKind.ToInt(),
                ItemCode      = strItemCode,
                ClientCode    = strClientCode.ToInt64(),
                ClientName    = strClientName,
                SupplyAmt     = strSupplyAmt.ToDouble(),
                TaxAmt        = strTaxAmt.ToDouble(),
                UpdAdminID    = objSes.AdminID,
                UpdAdminName  = objSes.AdminName
            };
                
            lo_objResOrderPayIns = objOrderDasServices.SetOrderPayUpd(lo_objOrderPayModel);
            objResMap.RetCode    = lo_objResOrderPayIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderPayIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    protected void SetOrderGoodsArrivalIns() 
    {
        OrderDispatchModel                lo_objReqOrderDispatchModel = null;
        ServiceResult<OrderDispatchModel> lo_objResOrderDispatchModel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (!strCnlFlag.Equals("Y")) {
            if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
            {
                objResMap.RetCode = 9002;
                objResMap.ErrMsg  = "필요한 값이 없습니다.(업체명)";
                return;
            }

            if (string.IsNullOrWhiteSpace(strChargeSeqNo) || strChargeSeqNo.Equals("0"))
            {
                objResMap.RetCode = 9003;
                objResMap.ErrMsg  = "필요한 값이 없습니다.(업체 담당자)";
                return;
            }
        }

        if (string.IsNullOrWhiteSpace(strGoodsSeqNos))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchModel = new OrderDispatchModel
            {
                CenterCode      = strCenterCode.ToInt(),
                GoodsSeqNos     = strGoodsSeqNos,
                ClientCode      = strClientCode.ToInt(),
                ChargeSeqNo     = strChargeSeqNo.ToInt(),
                ArrivalReportNo = strArrivalReportNo,
                CnlFlag         = strCnlFlag,
                AdminID         = objSes.AdminID
            };
                
            lo_objResOrderDispatchModel = objOrderDispatchDasServices.UpdOrderGoodsArrival(lo_objReqOrderDispatchModel);
            objResMap.RetCode           = lo_objResOrderDispatchModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9807;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void SetOrderArrivalPayIns()
    {
        OrderDispatchModel                lo_objReqOrderDispatchModel = null;
        ServiceResult<OrderDispatchModel> lo_objResOrderDispatchModel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strItemCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchModel = new OrderDispatchModel
            {
                CenterCode     = strCenterCode.ToInt(),
                OrderNos       = strOrderNos,
                PurchaseSeqNos = strPurchaseSeqNos,
                GoodsItemCode  = strItemCode,
                SupplyAmt      = strSupplyAmt.ToDouble(),
                TaxAmt         = strTaxAmt.ToDouble(),
                PurchaseType   = strPurchaseType.ToInt(),
                AdminID        = objSes.AdminID,
                AdminName      = objSes.AdminName
            };
                
            lo_objResOrderDispatchModel = objOrderDispatchDasServices.InsOrderArrivalPay(lo_objReqOrderDispatchModel);
            objResMap.RetCode           = lo_objResOrderDispatchModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9802;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void SetOrderGoodsArrivalDocumentUpd()
    {
        OrderDispatchModel                lo_objReqOrderDispatchModel = null;
        ServiceResult<OrderDispatchModel> lo_objResOrderDispatchModel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGoodsSeqNos))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchModel = new OrderDispatchModel
            {
                CenterCode  = strCenterCode.ToInt(),
                GoodsSeqNos = strGoodsSeqNos,
                OrderNos    = strOrderNos,
                CnlFlag     = strCnlFlag,
                AdminID     = objSes.AdminID
            };
                
            lo_objResOrderDispatchModel = objOrderDispatchDasServices.UpdOrderGoodsArrivalDocument(lo_objReqOrderDispatchModel);
            objResMap.RetCode           = lo_objResOrderDispatchModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9808;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 도착보고 작업지시서 업체목록
    /// </summary>
    protected void GetOrderDispatchArrivalWorkList()
    {
        ReqOrderDispatchArrivalWorkList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchArrivalWorkList> lo_objResOrderList = null;

        try
        {
            lo_objReqOrderList = new ReqOrderDispatchArrivalWorkList
            {
                CenterCode              = strCenterCode.ToInt(),
                ListType                = strListType.ToInt(), //목록 구분(1 : 수출입, 2 : 내수, 3 : 내수+수출입)
                DateType                = strDateType.ToInt(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                ArrivalReportClientName = strClientName,
                AccessCenterCode        = objSes.AccessCenterCode
            };
                
            lo_objResOrderList    = objOrderDispatchDasServices.GetOrderDispatchArrivalWorkList(lo_objReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9709;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    protected void GetClientChargeList()
    {
        ReqClientSearchList                lo_objReqClientList = null;
        ServiceResult<ResClientSearchList> lo_objResClientList = null;

        try
        {
            lo_objReqClientList = new ReqClientSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientName       = strClientName,
                ChargeName       = strChargeName,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientList   = objClientDasServices.GetClientSearchList(lo_objReqClientList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResClientList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9608;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파일목록
    /// </summary>
    protected void GetFileList()
    {
        ReqOrderFileList                lo_objReqOrderFileList = null;
        ServiceResult<ResOrderFileList> lo_objResOrderFileList = null;

        if (string.IsNullOrWhiteSpace(strOrderNo) || string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderFileList = new ReqOrderFileList
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                FileRegType      = 0,
                DelFlag          = "N",
                AccessCenterCode = objSes.AccessCenterCode
            };
                
            lo_objResOrderFileList = objOrderDasServices.GetOrderFileList(lo_objReqOrderFileList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResOrderFileList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파일 다운로드
    /// </summary>
    private void SetFileDownload()
    {
        string                          lo_strFileDir          = string.Empty;
        ReqOrderFileList                lo_objReqOrderFileList = null;
        ServiceResult<ResOrderFileList> lo_objResOrderFileList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9201;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrEmpty(strFileNameNew))
        {
            objResMap.RetCode = 9202;
            objResMap.ErrMsg  = "필요한 값이 없습니다";
            return;
        }

        if (string.IsNullOrEmpty(strFileName))
        {
            objResMap.RetCode = 9203;
            objResMap.ErrMsg  = "필요한 값이 없습니다";
            return;
        }

        if (string.IsNullOrEmpty(strTempFlag))
        {
            objResMap.RetCode = 9204;
            objResMap.ErrMsg  = "필요한 값이 없습니다";
            return;
        }

        if (strTempFlag.Equals("N") && (string.IsNullOrWhiteSpace(strOrderNo) || strCenterCode.Equals("0")))
        {
            objResMap.RetCode = 9205;
            objResMap.ErrMsg  = "필요한 값이 없습니다";
            return;
        }
        
        try
        {
            //파일 정보 불러오기
            if (strTempFlag.Equals("N"))
            {
                lo_objReqOrderFileList = new ReqOrderFileList
                {
                    CenterCode       = strCenterCode.ToInt(),
                    OrderNo          = strOrderNo.ToInt64(),
                    FileSeqNo        = strFileSeqNo.ToInt64(),
                    AccessCenterCode = objSes.AccessCenterCode
                };

                lo_objResOrderFileList = objOrderDasServices.GetOrderFileList(lo_objReqOrderFileList);
                if (!lo_objResOrderFileList.data.RecordCnt.Equals(1))
                {
                    objResMap.RetCode = 9204;
                    objResMap.ErrMsg  = "파일이 존재하지 않습니다.";
                    return;
                }

                lo_strFileDir = lo_objResOrderFileList.data.list[0].FileDir.Replace("/", @"\");

                lo_strFileDir = SiteGlobal.FILE_SERVER_ROOT + lo_strFileDir + @"\";
            }
            else
            {
                lo_strFileDir = SiteGlobal.FILE_SERVER_ROOT + @"\ORDER\Temp\";
            }
            
            if (!File.Exists(lo_strFileDir + strFileNameNew))
            {
                objResMap.RetCode = 9204;
                objResMap.ErrMsg  = strFileNameNew;
                return;
            }
            
            strFileName = Utils.GetConvertFileName(strFileName, "_");

            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "text/plain";
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=" + strFileName + ";");
            HttpContext.Current.Response.TransmitFile(lo_strFileDir + strFileNameNew);
            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.Clear();
        }
        catch (Exception lo_ex)
        {
            SiteGlobal.WriteLog(
                "OrderDispatchArrivalHandler",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9201);
        }
    }
    
    protected void SetArrivalReportNoUpdate()
    {
        OrderDispatchModel                lo_objReqOrderDispatchModel = null;
        ServiceResult<OrderDispatchModel> lo_objResOrderDispatchModel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGoodsSeqNo) || strGoodsSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchModel = new OrderDispatchModel
            {
                CenterCode              = strCenterCode.ToInt(),
                GoodsSeqNo              = strGoodsSeqNo.ToInt64(),
                ArrivalReportNo         = strArrivalReportNo,
                AdminID                 = objSes.AdminID
            };

            lo_objResOrderDispatchModel = objOrderDispatchDasServices.UpdArrivalReportNo(lo_objReqOrderDispatchModel);
            objResMap.RetCode           = lo_objResOrderDispatchModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9907;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchArrivalHandler", "Exception",
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