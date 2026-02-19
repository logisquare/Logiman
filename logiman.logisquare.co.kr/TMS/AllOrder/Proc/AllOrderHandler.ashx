<%@ WebHandler Language="C#" Class="AllOrderHandler" %>
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
/// FileName        : AllOrderHandler.ashx
/// Description     : 오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-08-03
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class AllOrderHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/AllOrder/AllOrderList"; //필수

    // 메소드 리스트
    private const string MethodAllOrderList                 = "AllOrderList";                    //오더 목록
    private const string MethodAllOrderListExcel            = "AllOrderListExcel";               //오더 엑셀
    private const string MethodAllOrderCnl                  = "AllOrderCancel";                  //오더 취소
    private const string MethodAllOrderOneCnl               = "AllOneCancel";                    //오더 단건 취소
    private const string MethodAllOrderLocationUpd          = "AllOrderLocationUpdate";          //사업장 변경
    private const string MethodClientCsList                 = "ClientCsList";                    //업무담당조회
    private const string MethodAllOrderDispatchCarList      = "AllOrderDispatchCarList";         //배차차량 목록
    private const string MethodAllOrderDispatchCarStatusUpd = "AllOrderDispatchCarStatusUpdate"; //배차차량 상태 변경

    OrderDasServices             objOrderDasServices             = new OrderDasServices();
    ClientCsDasServices          objClientCsDasServices          = new ClientCsDasServices();
    private HttpContext          objHttpContext                  = null;

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
    private string strSearchPlaceType         = string.Empty;
    private string strSearchPlaceText         = string.Empty;
    private string strSearchChargeType        = string.Empty;
    private string strSearchChargeText        = string.Empty;
    private string strCsAdminType             = string.Empty;
    private string strCsAdminID               = string.Empty;
    private string strCsAdminName             = string.Empty;
    private string strAcceptAdminName         = string.Empty;
    private string strOrderNo                 = string.Empty;
    private string strMyChargeFlag            = string.Empty;
    private string strMyOrderFlag             = string.Empty;
    private string strCnlFlag                 = string.Empty;
    private string strOrderLocationCode       = string.Empty;
    private string strOrderClientName         = string.Empty;
    private string strOrderClientChargeName   = string.Empty;
    private string strPayClientName           = string.Empty;
    private string strPayClientChargeName     = string.Empty;
    private string strPayClientChargeLocation = string.Empty;
    private string strConsignorName           = string.Empty;
    private string strPickupPlace             = string.Empty;
    private string strGetPlace                = string.Empty;
    private string strNoteClient              = string.Empty;
    private string strComName                 = string.Empty;
    private string strComCorpNo               = string.Empty;
    private string strCarNo                   = string.Empty;
    private string strDriverName              = string.Empty;
    private string strOrderNos                = string.Empty;
    private string strCnlReason               = string.Empty;
    private string strGoodsSeqNo              = string.Empty;
    private string strDispatchSeqNo           = string.Empty;
    private string strPickupDT                = string.Empty;
    private string strArrivalDT               = string.Empty;
    private string strGetDT                   = string.Empty;
    private string strSortType                = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodAllOrderList,                 MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAllOrderListExcel,            MenuAuthType.All);
        objMethodAuthList.Add(MethodAllOrderCnl,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAllOrderOneCnl,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAllOrderLocationUpd,          MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodClientCsList,                 MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAllOrderDispatchCarList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAllOrderDispatchCarStatusUpd, MenuAuthType.ReadWrite);

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

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AllOrderHandler");
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
            strDateType                = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateFrom                = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                  = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes      = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes          = SiteGlobal.GetRequestForm("OrderItemCodes");
            strOrderStatuses           = SiteGlobal.GetRequestForm("OrderStatuses");
            strSearchClientType        = SiteGlobal.GetRequestForm("SearchClientType");
            strSearchClientText        = SiteGlobal.GetRequestForm("SearchClientText");
            strSearchPlaceType         = SiteGlobal.GetRequestForm("SearchPlaceType");
            strSearchPlaceText         = SiteGlobal.GetRequestForm("SearchPlaceText");
            strSearchChargeType        = SiteGlobal.GetRequestForm("SearchChargeType");
            strSearchChargeText        = SiteGlobal.GetRequestForm("SearchChargeText");
            strCsAdminType             = Utils.IsNull(SiteGlobal.GetRequestForm("CsAdminType"), "0");
            strCsAdminID               = SiteGlobal.GetRequestForm("CsAdminID");;
            strCsAdminName             = SiteGlobal.GetRequestForm("CsAdminName");
            strMyChargeFlag            = SiteGlobal.GetRequestForm("MyChargeFlag");
            strMyOrderFlag             = SiteGlobal.GetRequestForm("MyOrderFlag");
            strCnlFlag                 = SiteGlobal.GetRequestForm("CnlFlag");
            strOrderLocationCode       = SiteGlobal.GetRequestForm("OrderLocationCode");
            strOrderClientName         = SiteGlobal.GetRequestForm("OrderClientName");
            strOrderClientChargeName   = SiteGlobal.GetRequestForm("OrderClientChargeName");
            strPayClientName           = SiteGlobal.GetRequestForm("PayClientName");
            strPayClientChargeName     = SiteGlobal.GetRequestForm("PayClientChargeName");
            strPayClientChargeLocation = SiteGlobal.GetRequestForm("PayClientChargeLocation");
            strConsignorName           = SiteGlobal.GetRequestForm("ConsignorName");
            strPickupPlace             = SiteGlobal.GetRequestForm("PickupPlace");
            strGetPlace                = SiteGlobal.GetRequestForm("GetPlace");
            strNoteClient              = SiteGlobal.GetRequestForm("NoteClient");
            strNoteClient              = SiteGlobal.GetRequestForm("NoteClient");
            strComName                 = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo               = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarNo                   = SiteGlobal.GetRequestForm("CarNo");
            strDriverName              = SiteGlobal.GetRequestForm("DriverName");
            strOrderNos                = SiteGlobal.GetRequestForm("OrderNos");
            strCnlReason               = SiteGlobal.GetRequestForm("CnlReason");
            strGoodsSeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"),    "0");
            strDispatchSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strPickupDT                = SiteGlobal.GetRequestForm("PickupDT");
            strArrivalDT               = SiteGlobal.GetRequestForm("ArrivalDT");
            strGetDT                   = SiteGlobal.GetRequestForm("GetDT");
            strSortType                = Utils.IsNull(SiteGlobal.GetRequestForm("SortType"), "1");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
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
                case MethodAllOrderList:
                    GetAllOrderList();
                    break;
                case MethodAllOrderListExcel:
                    GetAllOrderListExcel();
                    break;
                case MethodAllOrderLocationUpd:
                    SetAllOrderLocationUpd();
                    break;
                case MethodAllOrderCnl:
                    SetAllOrderCnl();
                    break;
                case MethodAllOrderOneCnl:
                    SetAllOrderOneCnl();
                    break;
                case MethodClientCsList:
                    GetClientCsList();
                    break;
                case MethodAllOrderDispatchCarList:
                    GetAllOrderDispatchCarList();
                    break;
                case MethodAllOrderDispatchCarStatusUpd:
                    SetAllOrderDispatchCarStatusUpd();
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

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 통합 오더 현황 목록
    /// </summary>
    protected void GetAllOrderList()
    {
        ReqOrderList                lo_objReqOrderList = null;
        ServiceResult<ResOrderList> lo_objResOrderList = null;
        int                         lo_intListType     = 3;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        strOrderClientName = string.Empty;
        strPayClientName   = string.Empty;
        strConsignorName   = string.Empty;

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

        strPickupPlace = string.Empty;
        strGetPlace    = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchPlaceType) && !string.IsNullOrWhiteSpace(strSearchPlaceText))
        {
            switch (strSearchPlaceType)
            {
                case "1":
                    strPickupPlace = strSearchPlaceText;
                    break;
                case "2":
                    strGetPlace = strSearchPlaceText;
                    break;
            }
        }

        strOrderClientChargeName   = string.Empty;
        strPayClientChargeName     = string.Empty;
        strPayClientChargeLocation = string.Empty;
        strAcceptAdminName         = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchChargeType) && !string.IsNullOrWhiteSpace(strSearchChargeText))
        {
            switch (strSearchChargeType)
            {
                case "1":
                    strOrderClientChargeName = strSearchChargeText;
                    break;
                case "2":
                    strPayClientChargeName = strSearchChargeText;
                    break;
                case "3":
                    strPayClientChargeLocation = strSearchChargeText;
                    break;
                case "4":
                    strAcceptAdminName = strSearchChargeText;
                    break;
            }
        }

        try
        {
            lo_objReqOrderList = new ReqOrderList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                ListType                = lo_intListType.ToInt(),
                DateType                = strDateType.ToInt(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderStatuses           = strOrderStatuses,
                OrderClientName         = strOrderClientName,
                OrderClientChargeName   = strOrderClientChargeName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                PickupPlace             = strPickupPlace,
                GetPlace                = strGetPlace,
                NoteClient              = strNoteClient,
                ComName                 = strComName,
                ComCorpNo               = strComCorpNo,
                CarNo                   = strCarNo,
                DriverName              = strDriverName,
                CsAdminID               = strCsAdminID,
                AcceptAdminName         = strAcceptAdminName,
                MyChargeFlag            = strMyChargeFlag,
                MyOrderFlag             = strMyOrderFlag,
                CnlFlag                 = strCnlFlag,
                SortType                = strSortType.ToInt(),
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode,
                PageSize                = intPageSize,
                PageNo                  = intPageNo,
            };

            lo_objResOrderList = objOrderDasServices.GetOrderList(lo_objReqOrderList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 통합 오더 현황 엑셀
    /// </summary>
    protected void GetAllOrderListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqOrderList                lo_objReqOrderList        = null;
        ServiceResult<ResOrderList> lo_objResOrderList        = null;
        int                         lo_intListType            = 3;
        string                      lo_strFileName            = "";
        SpreadSheet                 lo_objExcel               = null;
        DataTable                   lo_dtData                 = null;
        MemoryStream                lo_outputStream           = null;
        byte[]                      lo_Content                = null;
        int                         lo_intColumnIndex         = 0;
        double                      lo_intRevenue             = 0;
        double                      lo_intRevenuePer          = 0.0;
        string                      lo_strPickupYMD           = string.Empty;
        string                      lo_strGetYMD              = string.Empty;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        strOrderClientName = string.Empty;
        strPayClientName   = string.Empty;
        strConsignorName   = string.Empty;

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

        strPickupPlace = string.Empty;
        strGetPlace    = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchPlaceType) && !string.IsNullOrWhiteSpace(strSearchPlaceText))
        {
            switch (strSearchPlaceType)
            {
                case "1":
                    strPickupPlace = strSearchPlaceText;
                    break;
                case "2":
                    strGetPlace = strSearchPlaceText;
                    break;
            }
        }

        strOrderClientChargeName   = string.Empty;
        strPayClientChargeName     = string.Empty;
        strPayClientChargeLocation = string.Empty;
        strAcceptAdminName         = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchChargeType) && !string.IsNullOrWhiteSpace(strSearchChargeText))
        {
            switch (strSearchChargeType)
            {
                case "1":
                    strOrderClientChargeName = strSearchChargeText;
                    break;
                case "2":
                    strPayClientChargeName = strSearchChargeText;
                    break;
                case "3":
                    strPayClientChargeLocation = strSearchChargeText;
                    break;
                case "4":
                    strAcceptAdminName = strSearchChargeText;
                    break;
            }
        }

        try
        {
            lo_objReqOrderList = new ReqOrderList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                ListType                = lo_intListType,
                DateType                = strDateType.ToInt(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderStatuses           = strOrderStatuses,
                OrderClientName         = strOrderClientName,
                OrderClientChargeName   = strOrderClientChargeName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                PickupPlace             = strPickupPlace,
                GetPlace                = strGetPlace,
                NoteClient              = strNoteClient,
                ComName                 = strComName,
                ComCorpNo               = strComCorpNo,
                CarNo                   = strCarNo,
                DriverName              = strDriverName,
                AcceptAdminName         = strAcceptAdminName,
                CsAdminID               = strCsAdminID,
                MyChargeFlag            = strMyChargeFlag,
                MyOrderFlag             = strMyOrderFlag,
                CnlFlag                 = strCnlFlag,
                SortType                = strSortType.ToInt(),
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode,
                PageSize                = intPageSize,
                PageNo                  = intPageNo,
            };

            lo_objResOrderList = objOrderDasServices.GetOrderList(lo_objReqOrderList);

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

            lo_dtData.Columns.Add(new DataColumn("(발)휴대폰번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처구분",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처명",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)담당자",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)내선",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)전화번호",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)휴대폰번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구사업장",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차요청일",       typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("상차요청시간",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차방법",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)우편번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소상세", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)적용주소", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)담당자명", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)직급",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)내선",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(상)전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)지역코드",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)지역명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)특이사항",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차구분",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청시간",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차방법",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",      typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(하)우편번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)주소",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)주소상세",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)적용주소",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)담당자명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)직급",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)내선",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)지역코드",  typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(하)지역명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)특이사항", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("이단불가",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("무탑배차",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("FTL(독차여부)",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청톤급",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청차종",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("통관",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("보세",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("서류",      typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("도착보고",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("면허진행",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("시간엄수",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("특별관제",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차긴급",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("목적국",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("H/AWB",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("M/AWB",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Booking No.", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Invoice No.", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("입고 No.",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("Trip ID", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("품목",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("운행구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고정여부",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("경유여부",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("동일지역수",   typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("타지역수",    typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총중량",     typeof(double)));

            lo_dtData.Columns.Add(new DataColumn("총수량",      typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총부피",      typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총길이",      typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("화물명",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화물비고",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화물정보",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("비고",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고객전달사항",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(계)업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(계)사업자번호", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(계)담당자",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(계)전화번호",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(계)이메일",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("배차구분",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(픽업)차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(픽업)차량톤수",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(픽업)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(픽업)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(픽업)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(픽업)기사명",     typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(픽업)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(픽업)상차시간",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(픽업)하차시간",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)차량톤수",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)기사휴대폰",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(직송)상차시간",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)하차시간",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(직송)상하차정보",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량톤수",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)기사휴대폰",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(집하)상차시간",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)하차시간",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)상하차정보",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)상하차정보",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(배송)차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)상하차정보",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("자동운임",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("매출마감전표",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("매출",          typeof(Int64)));

            lo_dtData.Columns.Add(new DataColumn("매입",            typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("수익",            typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("수익률",           typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("선급금",           typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("예수금",           typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("빠른입금수수료(공급가액)", typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("빠른입금수수료(부가세)",  typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("접수일",           typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수자명",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최종수정일",         typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("최종수정자명",        typeof(string)));

            foreach (var row in lo_objResOrderList.data.list)
            {
                lo_intRevenue             = row.SaleSupplyAmt - row.PurchaseSupplyAmt - row.QuickPaySupplyFee;
                lo_intRevenuePer          = row.SaleSupplyAmt.Equals(0) ? 0.0 : lo_intRevenue / row.SaleSupplyAmt * 100;
                lo_strPickupYMD           = Utils.DateFormatter(row.PickupYMD, "yyyyMMdd", "yyyy-MM-dd", row.PickupYMD);
                lo_strGetYMD              = Utils.DateFormatter(row.GetYMD,    "yyyyMMdd", "yyyy-MM-dd", row.GetYMD);

                lo_dtData.Rows.Add(row.CenterName,row.OrderStatusM,row.OrderNo,row.TransInfo,row.OrderItemCodeM
                                ,row.OrderLocationCodeM,row.OrderClientName,row.OrderClientChargeName,row.OrderClientChargeTelExtNo,row.OrderClientChargeTelNo
                                ,row.OrderClientChargeCell,row.PayClientTypeM,row.PayClientName,row.PayClientChargeName,row.PayClientChargeTelExtNo
                                ,row.PayClientChargeTelNo,row.PayClientChargeCell,row.PayClientChargeLocation,row.ConsignorName,lo_strPickupYMD
                                ,row.PickupHM,row.PickupWay,row.PickupPlace,row.PickupPlacePost,row.PickupPlaceAddr
                                ,row.PickupPlaceAddrDtl,row.PickupPlaceFullAddr,row.PickupPlaceChargeName,row.PickupPlaceChargePosition,row.PickupPlaceChargeTelExtNo
                                ,row.PickupPlaceChargeTelNo,row.PickupPlaceChargeCell,row.PickupPlaceLocalCode,row.PickupPlaceLocalName,row.PickupPlaceNote
                                ,row.OrderGetTypeM,lo_strGetYMD,row.GetHM,row.GetWay,row.GetPlace
                                ,row.GetPlacePost,row.GetPlaceAddr,row.GetPlaceAddrDtl,row.GetPlaceFullAddr,row.GetPlaceChargeName
                                ,row.GetPlaceChargePosition,row.GetPlaceChargeTelExtNo,row.GetPlaceChargeTelNo,row.GetPlaceChargeCell,row.GetPlaceLocalCode
                                ,row.GetPlaceLocalName,row.GetPlaceNote,row.NoLayerFlag,row.NoTopFlag,row.FTLFlag
                                ,row.CarTonCodeM,row.CarTypeCodeM,row.CustomFlag,row.BondedFlag,row.DocumentFlag
                                ,row.ArrivalReportFlag,row.LicenseFlag,row.InTimeFlag,row.ControlFlag,row.QuickGetFlag
                                ,row.Nation,row.Hawb,row.Mawb,row.BookingNo,row.InvoiceNo
                                ,row.StockNo,row.GMOrderType,row.GMTripID,row.GoodsItemCodeM,row.GoodsRunTypeM
                                ,row.CarFixedFlag,row.LayoverFlag,row.SamePlaceCount,row.NonSamePlaceCount,row.Weight
                                ,row.Volume,row.CBM,row.Length,row.GoodsName,row.GoodsNote
                                ,row.Quantity,row.NoteInside,row.NoteClient,row.TaxClientName,row.TaxClientCorpNo
                                ,row.TaxClientChargeName,row.TaxClientChargeTelNo,row.TaxClientChargeEmail,row.GoodsDispatchTypeM,row.PickupDispatchCarNo
                                ,row.PickupCarTonCodeM,row.PickupCarDivTypeM,row.PickupComName,row.PickupComCorpNo,row.PickupDriverName
                                ,row.PickupDriverCell,row.PickupPickupDT,row.PickupGetDT,row.DispatchCarNo1
                                ,row.CarTonCodeM1, row.CarDivTypeM1,row.ComName1,row.ComCorpNo1,row.DriverName1
                                ,row.DriverCell1, row.PickupDT1,row.GetDT1,row.DispatchInfo1,row.DispatchCarNo2
                                ,row.CarTonCodeM2,row.CarDivTypeM2,row.ComName2,row.ComCorpNo2,row.DriverName2,row.DriverCell2
                                ,row.PickupDT2,row.GetDT2,row.DispatchInfo2,row.DispatchCarNo3,row.CarDivTypeM3
                                ,row.ComName3,row.ComCorpNo3,row.DriverName3,row.DriverCell3,row.DispatchInfo3
                                ,row.DispatchCarNo4,row.CarDivTypeM4,row.ComName4,row.ComCorpNo4,row.DriverName4
                                ,row.DriverCell4,row.DispatchInfo4,row.TransRateInfo,row.SaleClosingSeqNo,row.SaleSupplyAmt
                                ,row.PurchaseSupplyAmt,lo_intRevenue,lo_intRevenuePer,row.AdvanceSupplyAmt3,row.AdvanceSupplyAmt4
                                ,row.QuickPaySupplyFee, row.QuickPayTaxFee,row.AcceptDate,row.AcceptAdminName,row.UpdDate
                                ,row.UpdAdminName);
            }

            lo_objExcel = new SpreadSheet {SheetName = "AllOrderList"};

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
                
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
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

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

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
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 통합 오더 취소
    /// </summary>
    protected void SetAllOrderCnl()
    {
        ReqOrderCnl                lo_objReqOrderCnl = null;
        ServiceResult<ResOrderCnl> lo_objResOrderCnl = null;

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

        if (string.IsNullOrWhiteSpace(strCnlReason))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderCnl = new ReqOrderCnl
            {
                CenterCode        = strCenterCode.ToInt(),
                OrderNos          = strOrderNos,
                CnlReason         = strCnlReason,
                CnlAdminID        = objSes.AdminID,
                CnlAdminName      = objSes.AdminName,
                GradeCode         = objSes.GradeCode,
                AccessCenterCode  = objSes.AccessCenterCode
            };

            lo_objResOrderCnl = objOrderDasServices.SetOrderCnl(lo_objReqOrderCnl);
            objResMap.RetCode = lo_objResOrderCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderCnl.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("TotalCnt", lo_objResOrderCnl.data.TotalCnt);
                objResMap.Add("CancelCnt", lo_objResOrderCnl.data.CancelCnt);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 통합 오더 단건 취소
    /// </summary>
    protected void SetAllOrderOneCnl()
    {
        ReqOrderOneCnl      lo_objReqOrderOneCnl = null;
        ServiceResult<bool> lo_objResOrderOneCnl = null;

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

        if (string.IsNullOrWhiteSpace(strCnlReason))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderOneCnl = new ReqOrderOneCnl
            {
                CenterCode   = strCenterCode.ToInt(),
                OrderNo      = strOrderNo.ToInt64(),
                CnlReason    = strCnlReason,
                CnlAdminID   = objSes.AdminID,
                CnlAdminName = objSes.AdminName
            };

            lo_objResOrderOneCnl = objOrderDasServices.SetOrderOneCnl(lo_objReqOrderOneCnl);
            objResMap.RetCode    = lo_objResOrderOneCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderOneCnl.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9407;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 업체담당자 검색
    /// </summary>
    protected void GetClientCsList()
    {
        ReqClientCsSearchList                lo_objReqClientCsSearchList = null;
        ServiceResult<ResClientCsSearchList> lo_objResClientCsSearchList = null;

        if (string.IsNullOrWhiteSpace(strCsAdminID) && string.IsNullOrWhiteSpace(strCsAdminName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientCsSearchList = new ReqClientCsSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                CsAdminType      = strCsAdminType.ToInt(),
                CsAdminID        = strCsAdminID,
                CsAdminName      = strCsAdminName,
                DelFlag          = "N",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientCsSearchList = objClientCsDasServices.GetClientCsSearchList(lo_objReqClientCsSearchList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResClientCsSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9408;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 통합 사업장 변경
    /// </summary>
    protected void SetAllOrderLocationUpd()
    {
        ServiceResult<bool> lo_objResOrderLocationUpd = null;

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

        if (string.IsNullOrWhiteSpace(strOrderLocationCode))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResOrderLocationUpd = objOrderDasServices.SetOrderLocationUpd(strOrderNos, strCenterCode.ToInt(), strOrderLocationCode, objSes.AdminID, objSes.AdminName);
            objResMap.RetCode         = lo_objResOrderLocationUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderLocationUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9409;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 오더 배차 목록
    /// </summary>
    protected void GetAllOrderDispatchCarList()
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
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderDispatchCarList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9410;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 오더 배차 상태 변경
    /// </summary>
    protected void SetAllOrderDispatchCarStatusUpd()
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
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AllOrderHandler", "Exception",
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