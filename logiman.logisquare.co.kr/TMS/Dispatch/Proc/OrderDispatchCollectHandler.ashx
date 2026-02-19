<%@ WebHandler Language="C#" Class="OrderDispatchCollectHandler" %>
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
/// FileName        : OrderDispatchCollectHandler.ashx
/// Description     : 집하/간선 현황 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2024-02-13
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class OrderDispatchCollectHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Dispatch/OrderDispatchCollectList"; //필수

    // 메소드 리스트
    private const string MethodOrderDispatchCount                = "OrderDispatchCount";                //배차현황 카운트
    private const string MethodOrderDispatchList                 = "OrderDispatchList";                 //배차현황 목록
    private const string MethodOrderDispatchListExcel            = "OrderDispatchListExcel";            //배차현황 엑셀 목록
    private const string MethodCarDispatchRefSearch              = "CarDispatchRefSearch";              //차량업체 목록
    private const string MethodOrderDispatchInsert               = "OrderDispatchInsert";               //배차등록
    private const string MethodOrderDispatchCnl                  = "OrderDispatchCnl";                  //배차취소
    private const string MethodOrderDispatchTypeUpd              = "OrderDispatchTypeUpd";              //배차구분 수정
    private const string MethodOrderDeliveryLocationReqIns       = "OrderDeliveryLocationReqIns";       //배송 요청
    private const string MethodOrderDispatchCollectPayList       = "OrderDispatchCollectPayList";       //집하/간선 비용목록
    private const string MethodOrderDispatchCollectPayIns        = "OrderDispatchCollectPayIns";        //집하/간선 비용등록
    private const string MethodOrderDispatchContractCnl          = "OrderDispatchContractCnl";          //위탁취소
    private const string MethodOrderDispatchCarList              = "OrderDispatchCarList";              //화물실적신고 엑셀
    private const string MethodOrderDispatchCarStatusUpd         = "OrderDispatchCarStatusUpdate";      //배차차량 상태 변경
    private const string MethodOrderDispatchCollectWorkListExcel = "OrderDispatchCollectWorkListExcel"; //간선 작업지시서 엑셀 목록
    private const string MethodOrderDispatchCollectWorkCarList   = "OrderDispatchCollectWorkCarList";   //간선 차량목록
    private const string MethodOrderFileList                     = "OrderFileList";
    private const string MethodOrderFileDownload                 = "OrderFileDownload";
        
    OrderDispatchDasServices objOrderDispatchDasServices = new OrderDispatchDasServices();
    CarDispatchDasServices   objCarDispatchDasServices   = new CarDispatchDasServices();
    OrderDasServices         objOrderDasServices         = new OrderDasServices();
        
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
    private string strLocationCode            = string.Empty;
    private string strPurchaseSupplyAmt       = string.Empty;
    private string strGoodsSeqNo              = string.Empty;
    private string strDispatchSeqNo           = string.Empty;
    private string strRefSeqNo                = string.Empty;
    private string strQuickType               = string.Empty;
    private string strArrivalReportFlag       = string.Empty;
    private string strCnlFlag                 = string.Empty;
    private string strDispatchSeqNos          = string.Empty;
    private string strProcType                = string.Empty;
    private string strDispatchInfo            = string.Empty;
    private string strListType                = string.Empty;
    private string strDeliveryLocationCodes   = string.Empty;
    private string strGetStandardType         = string.Empty;
    private string strArrivalReportClientName = string.Empty;
    private string strOrderByPageType         = string.Empty;
    private string strInsureExceptKind        = string.Empty;
    private string strPickupDT                = string.Empty;
    private string strArrivalDT               = string.Empty;
    private string strGetDT                   = string.Empty;
    private string strFileNameNew             = string.Empty;
    private string strFileName                = string.Empty;
    private string strTempFlag                = string.Empty;
    private string strFileSeqNo               = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodOrderDispatchCount,                MenuAuthType.ReadOnly);  //배차현황 카운트
        objMethodAuthList.Add(MethodOrderDispatchList,                 MenuAuthType.ReadOnly);  //배차현황 목록
        objMethodAuthList.Add(MethodOrderDispatchListExcel,            MenuAuthType.All);       //배차현황 엑셀 목록
        objMethodAuthList.Add(MethodCarDispatchRefSearch,              MenuAuthType.ReadOnly);  //차량업체 목록
        objMethodAuthList.Add(MethodOrderDispatchInsert,               MenuAuthType.ReadWrite); //배차등록
        objMethodAuthList.Add(MethodOrderDispatchCnl,                  MenuAuthType.ReadWrite); //배차취소
        objMethodAuthList.Add(MethodOrderDispatchTypeUpd,              MenuAuthType.ReadWrite); //배차구분 수정
        objMethodAuthList.Add(MethodOrderDeliveryLocationReqIns,       MenuAuthType.ReadWrite); //배송 요청
        objMethodAuthList.Add(MethodOrderDispatchCollectPayList,       MenuAuthType.ReadOnly);  //집하/간선 비용목록
        objMethodAuthList.Add(MethodOrderDispatchCollectPayIns,        MenuAuthType.ReadWrite); //집하/간선 비용등록
        objMethodAuthList.Add(MethodOrderDispatchContractCnl,          MenuAuthType.ReadWrite); //위탁취소
        objMethodAuthList.Add(MethodOrderDispatchCarList,              MenuAuthType.ReadOnly);  //화물실적신고 엑셀
        objMethodAuthList.Add(MethodOrderDispatchCarStatusUpd,         MenuAuthType.ReadWrite); //배차차량 상태 변경
        objMethodAuthList.Add(MethodOrderDispatchCollectWorkListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodOrderDispatchCollectWorkCarList,   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderFileList,                     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderFileDownload,                 MenuAuthType.All);

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

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("OrderDispatchCollectHandler");
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
            strLocationCode            = SiteGlobal.GetRequestForm("LocationCode");
            strPurchaseSupplyAmt       = Utils.IsNull(SiteGlobal.GetRequestForm("PurchaseSupplyAmt"), "0");
            strGoodsSeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"),        "0");
            strDispatchSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"),     "0");
            strRefSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"),          "0");
            strQuickType               = Utils.IsNull(SiteGlobal.GetRequestForm("QuickType"),         "0");
            strArrivalReportFlag       = SiteGlobal.GetRequestForm("ArrivalReportFlag");
            strCnlFlag                 = SiteGlobal.GetRequestForm("CnlFlag");
            strDispatchSeqNos          = SiteGlobal.GetRequestForm("DispatchSeqNos");
            strProcType                = Utils.IsNull(SiteGlobal.GetRequestForm("ProcType"), "0");
            strDispatchInfo            = SiteGlobal.GetRequestForm("DispatchInfo");
            strListType                = Utils.IsNull(SiteGlobal.GetRequestForm("ListType"), "0");
            strDeliveryLocationCodes   = SiteGlobal.GetRequestForm("DeliveryLocationCodes");
            strGetStandardType         = Utils.IsNull(SiteGlobal.GetRequestForm("GetStandardType"), "0");
            strArrivalReportClientName = SiteGlobal.GetRequestForm("ArrivalReportClientName");
            strOrderByPageType         = Utils.IsNull(SiteGlobal.GetRequestForm("OrderByPageType"),  "0");
            strInsureExceptKind        = Utils.IsNull(SiteGlobal.GetRequestForm("InsureExceptKind"), "1");
            strPickupDT                = SiteGlobal.GetRequestForm("PickupDT");
            strArrivalDT               = SiteGlobal.GetRequestForm("ArrivalDT");
            strGetDT                   = SiteGlobal.GetRequestForm("GetDT");
            strFileNameNew             = Utils.GetDecrypt(SiteGlobal.GetRequestForm("FileNameNew"));
            strFileName                = SiteGlobal.GetRequestForm("FileName");
            strTempFlag                = SiteGlobal.GetRequestForm("TempFlag");
            strFileSeqNo               = Utils.IsNull(Utils.GetDecrypt(SiteGlobal.GetRequestForm("FileSeqNo")), "0");
            strConsignorName           = SiteGlobal.GetRequestForm("ConsignorName");
            strOrderClientName         = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientName           = SiteGlobal.GetRequestForm("PayClientName");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", string.Empty);
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", string.Empty);

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
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
                case MethodOrderDispatchCount:
                    GetOrderDispatchCount();
                    break;
                case MethodOrderDispatchList:
                    GetOrderDispatchList();
                    break;
                case MethodOrderDispatchListExcel:
                    GetOrderDispatchListExcel();
                    break;
                case MethodCarDispatchRefSearch:
                    GetCarDispatchRefList();
                    break;
                case MethodOrderDispatchInsert:
                    SetOrderDispatchInsert();
                    break;
                case MethodOrderDispatchCnl:
                    SetOrderDispatchCnl();
                    break;
                case MethodOrderDispatchTypeUpd:
                    SetOrderDispatchTypeUpd();
                    break;
                case MethodOrderDeliveryLocationReqIns:
                    GetOrderDeliveryLocationReqIns();
                    break;
                case MethodOrderDispatchCollectPayList:
                    GetOrderDispatchCollectPayList();
                    break;
                case MethodOrderDispatchCollectPayIns:
                    SetOrderCollectPayIns();
                    break;
                case MethodOrderDispatchContractCnl:
                    SetOrderDispatchContractCnl();
                    break;
                case MethodOrderDispatchCarList:
                    GetOrderDispatchCarList();
                    break;
                case MethodOrderDispatchCarStatusUpd:
                    SetOrderDispatchCarStatusUpd();
                    break;
                case MethodOrderDispatchCollectWorkListExcel:
                    GetOrderDispatchCollectWorkListExcel();
                    break;
                case MethodOrderDispatchCollectWorkCarList:
                    GetOrderDispatchCollectWorkCarList();
                    break;
                case MethodOrderFileList:
                    GetFileList();
                    break;
                case MethodOrderFileDownload:
                    SetFileDownload();
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

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 배차현황 카운트
    /// </summary>
    protected void GetOrderDispatchCount()
    {
        ReqOrderDispatchCount                lo_objReqOrderDispatchCount = null;
        ServiceResult<ResOrderDispatchCount> lo_objResOrderDispatchCount = null;

        try
        {
            lo_objReqOrderDispatchCount = new ReqOrderDispatchCount
            {
                AccessCenterCode = objSes.AccessCenterCode,
                AdminID          = objSes.AdminID
            };

            lo_objResOrderDispatchCount = objOrderDispatchDasServices.GetOrderDispatchCount(lo_objReqOrderDispatchCount);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderDispatchCount) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
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

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
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

            lo_dtData              = new DataTable();
                
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
            lo_dtData.Columns.Add(new DataColumn("(집하)카고패스",        typeof(string)));
            
            lo_dtData.Columns.Add(new DataColumn("집하차량",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)카고패스",    typeof(string)));
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
            lo_dtData.Columns.Add(new DataColumn("매출",          typeof(Int64)));

            lo_dtData.Columns.Add(new DataColumn("매입",          typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("수익",          typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("수익률",    typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("선급금",    typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("예수금",    typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("접수일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수자명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최종수정일",  typeof(string)));
            
            lo_dtData.Columns.Add(new DataColumn("최종수정자명", typeof(string)));

            foreach (var row in lo_objResOrderList.data.list)
            {
                lo_intRevenue           = row.SaleSupplyAmt - row.PurchaseSupplyAmt;
                lo_intRevenuePer        = row.SaleSupplyAmt.Equals(0) ? 0.0 : row.PurchaseSupplyAmt / row.SaleSupplyAmt * 100;

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
                                ,row.ComName1,row.ComCorpNo1,row.DriverName1,row.DriverCell1,row.JCargopassFlag
                                ,row.DispatchCarNo2,row.CarDivTypeM2, row.ComName2, row.ComCorpNo2, row.DriverName2
                                ,row.DriverCell2,row.GCargopassFlag,row.DispatchCarNo3,row.CarDivTypeM3,row.ComName3
                                ,row.ComCorpNo3,row.DriverName3,row.DriverCell3,row.DispatchCarNo4,row.CarDivTypeM4
                                ,row.ComName4,row.ComCorpNo4,row.DriverName4,row.DriverCell4,row.SaleSupplyAmt
                                ,row.PurchaseSupplyAmt,lo_intRevenue,lo_intRevenuePer,row.AdvanceSupplyAmt3,row.AdvanceSupplyAmt4
                                ,row.AcceptDate,row.AcceptAdminName,row.UpdDate,row.UpdAdminName);
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
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
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
            objResMap.RetCode = 9704;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }


    /// <summary>
    /// 배차 차량검색
    /// </summary>
    protected void GetCarDispatchRefList()
    {
        ReqCarDispatchRefSearchList                lo_objReqCarDispatchRefSearchList = null;
        ServiceResult<ResCarDispatchRefSearchList> lo_objResCarDispatchRefSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarDispatchRefSearchList = new ReqCarDispatchRefSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                CarNo            = strCarNo,
                UseFlag          = "Y",
                GradeCode        = objSes.GradeCode,
                AccessCenterCode = objSes.AccessCenterCode,
                AccessCorpNo     = objSes.AccessCorpNo,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResCarDispatchRefSearchList = objCarDispatchDasServices.GetCarDispatchRefSearchList(lo_objReqCarDispatchRefSearchList);
            objResMap.strResponse             = "[" + JsonConvert.SerializeObject(lo_objResCarDispatchRefSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9502;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    
    //배차등록
    protected void SetOrderDispatchInsert()
    {
        OrderDispatchModel                lo_objReqOrderDispatchModel = null;
        ServiceResult<OrderDispatchModel> lo_objResOrderDispatchModel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strRefSeqNo) || strRefSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDispatchType) || strDispatchType.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strQuickType) || strQuickType.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchModel = new OrderDispatchModel
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNos         = strOrderNos,
                RefSeqNo         = strRefSeqNo.ToInt64(),
                DispatchType     = strDispatchType.ToInt(),
                QuickType        = strQuickType.ToInt(),
                InsureExceptKind = strInsureExceptKind.ToInt(),
                AdminID          = objSes.AdminID,
                AdminName        = objSes.AdminName
            };
                
            lo_objResOrderDispatchModel = objOrderDispatchDasServices.InsOrderDispatchMulti(lo_objReqOrderDispatchModel);
            objResMap.RetCode           = lo_objResOrderDispatchModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9501;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
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
                DispatchSeqNos = strDispatchSeqNos,
                CenterCode     = strCenterCode.ToInt(),
                AdminID        = objSes.AdminID,
                AdminName      = objSes.AdminName
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

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    
    //배차구분
    protected void SetOrderDispatchTypeUpd()
    {
        ReqOrderDispatchUpd                lo_objReqOrderDispatchUpd = null;
        ServiceResult<ResOrderDispatchUpd> lo_objResOrderDispatchUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        if (string.IsNullOrWhiteSpace(strOrderNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        if (string.IsNullOrWhiteSpace(strGoodsDispatchType))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchUpd = new ReqOrderDispatchUpd
            {
                OrderNos          = strOrderNos,
                CenterCode        = strCenterCode.ToInt(),
                GoodsDispatchType = strGoodsDispatchType.ToInt(),
                AdminID           = objSes.AdminID,
                AdminName         = objSes.AdminName
            };
                
            lo_objResOrderDispatchUpd = objOrderDispatchDasServices.UpdDispatchType(lo_objReqOrderDispatchUpd);
            objResMap.RetCode         = lo_objResOrderDispatchUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    
    protected void GetOrderDeliveryLocationReqIns()
    {
        ReqOrderDispatchUpd                lo_objReqOrderDispatchUpd = null;
        ServiceResult<ResOrderDispatchUpd> lo_objResOrderDispatchUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchUpd = new ReqOrderDispatchUpd
            {
                OrderNos             = strOrderNos,
                CenterCode           = strCenterCode.ToInt(),
                DeliveryLocationCode = strLocationCode,
                AdminID              = objSes.AdminID,
                AdminName            = objSes.AdminName
            };
                
            lo_objResOrderDispatchUpd = objOrderDispatchDasServices.UpdOrderDeliveryLocationReq(lo_objReqOrderDispatchUpd);
            objResMap.RetCode         = lo_objResOrderDispatchUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9602;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void GetOrderDispatchCollectPayList()
    {
        ReqOrderDispatchList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderList = null;

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
                CenterCode         = strCenterCode.ToInt(),
                ListType           = strListType.ToInt(),
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                GoodsDispatchType  = strGoodsDispatchType.ToInt(),
                DispatchType       = strDispatchType.ToInt(),
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                OrderClientName    = strOrderClientName,
                PayClientName      = strPayClientName,
                ConsignorName      = strConsignorName,
                ComName            = strComName,
                CarNo              = strCarNo,
                DispatchAdminName  = strDispatchAdminName,
                AdminID            = objSes.AdminID,
                AccessCenterCode   = objSes.AccessCenterCode,
                CnlFlag            = "N",
                PageSize           = intPageSize,
                PageNo             = intPageNo
            };

            lo_objResOrderList    = objOrderDispatchDasServices.GetCollectPayList(lo_objReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9704;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    protected void SetOrderCollectPayIns()
    {
        OrderDispatchModel                lo_objReqOrderDispatchUpd = null;
        ServiceResult<OrderDispatchModel> lo_objResOrderDispatchUpd = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDispatchInfo))
        {
            objResMap.RetCode = 9002;
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
            lo_objReqOrderDispatchUpd = new OrderDispatchModel
            {
                CenterCode         = strCenterCode.ToInt(),
                ListType           = strListType.ToInt(),
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                GoodsDispatchType  = strGoodsDispatchType.ToInt(),
                DispatchType       = strDispatchType.ToInt(),
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                OrderClientName    = strOrderClientName,
                PayClientName      = strPayClientName,
                ConsignorName      = strConsignorName,
                ComName            = strComName,
                CarNo              = strCarNo,
                CnlFlag            = strCnlFlag,
                DispatchAdminName  = strDispatchAdminName,
                AccessCenterCode   = objSes.AccessCenterCode,
                DispatchInfo       = strDispatchInfo,
                PurchaseSupplyAmt  = strPurchaseSupplyAmt.ToDouble(),
                ProcType           = strProcType.ToInt(),
                AdminID            = objSes.AdminID,
                AdminName          = objSes.AdminName
            };
                
            lo_objResOrderDispatchUpd = objOrderDispatchDasServices.InsCarLoadPay(lo_objReqOrderDispatchUpd);
            objResMap.RetCode         = lo_objResOrderDispatchUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9706;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    
    protected void SetOrderDispatchContractCnl() 
    {
        OrderDispatchModel                lo_objReqOrderDispatchModel = null;
        ServiceResult<OrderDispatchModel> lo_objResOrderDispatchModel = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDispatchType) || strDispatchType.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNos))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchModel = new OrderDispatchModel
            {
                CenterCode   = strCenterCode.ToInt(),
                OrderNos     = strOrderNos,
                DispatchType = strDispatchType.ToInt(),
                AdminID      = objSes.AdminID,
                AdminName    = objSes.AdminName
            };
                
            lo_objResOrderDispatchModel = objOrderDispatchDasServices.InsContractMultiReqCnl(lo_objReqOrderDispatchModel);
            objResMap.RetCode           = lo_objResOrderDispatchModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9709;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 배차 목록
    /// </summary>
    protected void GetOrderDispatchCarList()
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 배차 상태 변경
    /// </summary>
    protected void SetOrderDispatchCarStatusUpd()
    {
        ReqOrderDispatchCarStatusUpd lo_objReqOrderDispatchCarStatusUpd = null;
        ServiceResult<bool>          lo_objResOrderDispatchCarStatusUpd = null;

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

        if (strDispatchSeqNo.Equals("0") || string.IsNullOrWhiteSpace(strDispatchSeqNo))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderDispatchCarStatusUpd = new ReqOrderDispatchCarStatusUpd
            {
                CenterCode    = strCenterCode.ToInt(),
                OrderNo       = strOrderNo.ToInt64(),
                DispatchSeqNo = strDispatchSeqNo.ToInt64(),
                PickupDT      = strPickupDT,
                ArrivalDT     = strArrivalDT,
                GetDT         = strGetDT,
                AdminID       = objSes.AdminID,
                AdminName     = objSes.AdminName,
            };

            lo_objResOrderDispatchCarStatusUpd = objOrderDasServices.SetOrderDispatchCarStatusUpd(lo_objReqOrderDispatchCarStatusUpd);
            objResMap.RetCode = lo_objResOrderDispatchCarStatusUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchCarStatusUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    
    protected void GetOrderDispatchCollectWorkListExcel() 
    {
        SpreadSheet                         lo_objExcel        = null;
        DataTable                           lo_dtData          = null;
        DataTable                           lo_dtDataInfo      = null;
        MemoryStream                        lo_outputStream    = null;
        ReqOrderDispatchList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderList = null;
        string                              lo_strFileName     = string.Empty;
        byte[]                              lo_Content         = null;
        int                                 lo_intColumnIndex  = 0;
        string[]                            lo_strArrCarNo     = strCarNo.Split(',');
        int                                 lo_intNumber       = 1;
        int                                 lo_intVolumeTotal  = 0;
        double                              lo_intCBMTotal     = 0;
        double                              lo_intWeightTotal  = 0;
        string                              lo_strCarNo3       = string.Empty;
        string                              lo_strDriverName3  = string.Empty;
        string                              lo_strDriverCell3  = string.Empty;

        try
        {
            lo_dtData     = new DataTable();
            lo_dtDataInfo = new DataTable();
                
            lo_dtData.Columns.Add(new DataColumn("No",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("서류",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("보세여부",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차긴급여부", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총수량",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총부피",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총중량",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(하)담당자", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)전화번호",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)휴대폰",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("목적국",            typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("집하차량",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("H/AWB",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지특이사항",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화물정보",           typeof(string)));

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
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));
            lo_dtDataInfo.Columns.Add(new DataColumn(string.Empty, typeof(string)));

            if (lo_strArrCarNo.Length > 0)
            {
                foreach (string lo_strCarNo in lo_strArrCarNo)
                {
                    lo_intNumber      = 1;
                    lo_intVolumeTotal = 0;
                    lo_intCBMTotal    = 0;
                    lo_intWeightTotal = 0;
                    lo_strCarNo3      = string.Empty;
                    lo_strDriverName3 = string.Empty;
                    lo_strDriverCell3 = string.Empty;
                    lo_intColumnIndex = 0;

                    lo_dtDataInfo.Rows.Clear();
                    lo_dtData.Rows.Clear();

                    if (lo_objExcel == null)
                    {
                        lo_objExcel = new SpreadSheet { SheetName = lo_strCarNo };
                    }
                    else
                    {
                        lo_objExcel.AddWorkSheet(lo_strCarNo);
                    }

                    lo_objReqOrderList = new ReqOrderDispatchList
                    {
                        CenterCode         = strCenterCode.ToInt(),
                        OrderNo            = strOrderNo.ToInt64(),
                        ListType           = strListType.ToInt(),
                        DateType           = strDateType.ToInt(),
                        DateFrom           = strDateFrom,
                        DateTo             = strDateTo,
                        CarNo              = lo_strCarNo,
                        DispatchType       = strDispatchType.ToInt(),
                        OrderByPageType    = 1, //발주처 기준
                        OrderLocationCodes = strOrderLocationCodes,
                        OrderItemCodes     = strOrderItemCodes,
                        ComName            = strComName,
                        AccessCenterCode   = objSes.AccessCenterCode,
                        CnlFlag            = "N",
                        PageSize           = intPageSize,
                        PageNo             = intPageNo
                    };

                    lo_objResOrderList = objOrderDispatchDasServices.GetOrderDispatchList(lo_objReqOrderList);

                    foreach (var row in lo_objResOrderList.data.list)
                    {
                        lo_dtData.Rows.Add(lo_intNumber,row.DocumentFlag,row.BondedFlag,row.QuickGetFlag,row.OrderClientName
                            ,row.ConsignorName,row.Volume,row.CBM,row.Weight,row.GetPlace
                            ,row.GetPlaceChargeName,row.GetPlaceChargeTelNo,row.GetPlaceChargeCell,row.Nation,row.GetHM
                            ,row.DispatchCarNo2,row.Hawb,row.GetPlaceNote,row.Quantity
                        );

                        lo_intNumber++;
                        
                        lo_intVolumeTotal += row.Volume;
                        lo_intCBMTotal    += row.CBM;
                        lo_intWeightTotal += row.Weight;
                        lo_strCarNo3      =  row.DispatchCarNo3;
                        lo_strDriverName3 =  row.DriverName3;
                        lo_strDriverCell3 =  row.DriverCell3;
                    }
                    
                    lo_dtDataInfo.Rows.Add($"DATE : {Utils.ConvertDateFormat(strDateFrom)} ~ {Utils.ConvertDateFormat(strDateTo)}  |  차량번호 : {lo_strCarNo3} / 기사명 : {lo_strDriverName3} / 연락처 : {lo_strDriverCell3}  |  수량 : {lo_intVolumeTotal}  |  부피 : {lo_intCBMTotal}  |  중량 : {lo_intWeightTotal}"
                        , string.Empty, string.Empty, string.Empty, string.Empty
                        , string.Empty, string.Empty, string.Empty, string.Empty, string.Empty
                        , string.Empty, string.Empty, string.Empty, string.Empty, string.Empty
                        , string.Empty, string.Empty, string.Empty, string.Empty);

                    lo_objExcel.FreezeCell(1);
                    lo_objExcel.MergeColumn(1, 1, 1, 19);
                    lo_objExcel.MergeColumn(2, 1, 2, 19);
                    lo_objExcel.InsertDataTable(lo_dtDataInfo, true, 1, 1, true, false, System.Drawing.Color.White, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
                    lo_objExcel.InsertDataTable(lo_dtData, true, 3, 1, true, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Center, HorizontalAlignmentValues.Center);
                    lo_objExcel.InsertValue(2, 19, "", 14, true, HorizontalAlignmentValues.Center);
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

                    lo_objExcel.SetFontSize(10, 18);
                    lo_objExcel.SetAutoFitRow(lo_strCarNo);
                    lo_objExcel.SetAutoFitColumn(lo_strCarNo);
                }
            }

            lo_objExcel.SaveExcelStream(true, true, out lo_outputStream);

            lo_Content = lo_outputStream.ToArray();

            lo_strFileName = $"간선작업지시서_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

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

            SiteGlobal.WriteLog("OrderDispatchCollectHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    
    protected void GetOrderDispatchCollectWorkCarList()
    {
        ReqOrderDispatchList                lo_objReqOrderList = null;
        ServiceResult<ResOrderDispatchList> lo_objResOrderList = null;

        try
        {
            lo_objReqOrderList = new ReqOrderDispatchList
            {
                CenterCode         = strCenterCode.ToInt(),
                ListType           = strListType.ToInt(), //목록 구분(1 : 수출입, 2 : 내수, 3 : 내수+수출입)
                DateType           = strDateType.ToInt(),
                DateFrom           = strDateFrom,
                DateTo             = strDateTo,
                DispatchType       = strDispatchType.ToInt(),
                OrderLocationCodes = strOrderLocationCodes,
                OrderItemCodes     = strOrderItemCodes,
                CarNo              = strCarNo,
                DispatchAdminName  = strDispatchAdminName,
                AdminID            = objSes.AdminID,
                AccessCenterCode   = objSes.AccessCenterCode,
                CnlFlag            = "N"
            };
                
            lo_objResOrderList    = objOrderDispatchDasServices.GetOrderDispatchCollectWorkCarList(lo_objReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9709;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("OrderDispatchDeliveryHandler", "Exception",
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

            SiteGlobal.WriteLog("OrderDispatchDeliveryHandler", "Exception",
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
                "OrderDispatchDeliveryHandler",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                9201);
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