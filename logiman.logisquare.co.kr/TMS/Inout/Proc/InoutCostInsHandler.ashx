<%@ WebHandler Language="C#" Class="InoutCostInsHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : InoutCostInsHandler.ashx
/// Description     : 수출입 비용등록 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-08-03
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class InoutCostInsHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink  = "/TMS/Inout/InoutCostIns"; //필수

    // 메소드 리스트
    private const string MethodInoutContract           = "InoutContract";           //오더 위수탁 정보
    private const string MethodInoutList               = "InoutList";               //오더 목록
    private const string MethodInoutPayList            = "InoutPayList";            //비용 목록
    private const string MethodInoutPayIns             = "InoutPayInsert";          //비용 등록
    private const string MethodInoutPayUpd             = "InoutPayUpdate";          //비용 수정
    private const string MethodInoutPayDel             = "InoutPayDelete";          //비용 삭제
    private const string MethodInoutCodeList           = "InoutCodeList";           //회원사별 코드 조회
    private const string MethodClientList              = "ClientList";              //고객사 조회
    private const string MethodClientCsList            = "ClientCsList";            //업무담당조회
    private const string MethodClientNote              = "ClientNote";              //청구처 특이사항
    private const string MethodClientSaleLimit         = "ClientSaleLimit";         //매출 한도 정보 조회
    private const string MethodTransRateOrderList      = "TransRateOrderList";      //요율표 조회(적용후)
    private const string MethodTransRateOrderApplyList = "TransRateOrderApplyList"; //요율표 조회
    private const string MethodAmtRequestOrderList     = "AmtRequestOrderList";     //요청 목록
    private const string MethodAmtRequestIns           = "AmtRequestInsert";        //요청 등록
    private const string MethodAmtRequestCnl           = "AmtRequestCancel";        //요청 삭제

    OrderDasServices           objOrderDasServices           = new OrderDasServices();
    ClientDasServices          objClientDasServices          = new ClientDasServices();
    ClientCsDasServices        objClientCsDasServices        = new ClientCsDasServices();
    ClientSaleLimitDasServices objClientSaleLimitDasServices = new ClientSaleLimitDasServices();
    private HttpContext        objHttpContext                = null;

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
    private string strOrderClientName         = string.Empty;
    private string strOrderClientChargeName   = string.Empty;
    private string strPayClientName           = string.Empty;
    private string strPayClientChargeName     = string.Empty;
    private string strPayClientChargeLocation = string.Empty;
    private string strConsignorName           = string.Empty;
    private string strPickupPlace             = string.Empty;
    private string strGetPlace                = string.Empty;
    private string strNoteClient              = string.Empty;
    private string strClientCode              = string.Empty; //검색용
    private string strClientName              = string.Empty;
    private string strChargeOrderFlag         = string.Empty;
    private string strChargePayFlag           = string.Empty;
    private string strChargeBillFlag          = string.Empty;
    private string strClientFlag              = string.Empty;
    private string strChargeFlag              = string.Empty;
    private string strComName                 = string.Empty;
    private string strComCorpNo               = string.Empty;
    private string strCarNo                   = string.Empty;
    private string strDriverName              = string.Empty;
    private string strSupplyAmt               = string.Empty;
    private string strTaxAmt                  = string.Empty;
    private string strSeqNo                   = string.Empty;
    private string strGoodsSeqNo              = string.Empty;
    private string strPayType                 = string.Empty;
    private string strTaxKind                 = string.Empty;
    private string strItemCode                = string.Empty;
    private string strPickupYMD               = string.Empty;
    private string strPayClientCode           = string.Empty;
    private string strSortType                = string.Empty;
    private string strApplySeqNo              = string.Empty;
    private string strTransDtlSeqNo           = string.Empty;
    private string strTransRateStatus         = string.Empty;
    private string strReqKind                 = string.Empty;
    private string strPaySeqNo                = string.Empty;
    private string strReqSupplyAmt            = string.Empty;
    private string strReqTaxAmt               = string.Empty;
    private string strReqReason               = string.Empty;
    private string strConsignorCode           = string.Empty;
    private string strOrderItemCode           = string.Empty;
    private string strOrderLocationCode       = string.Empty;
    private string strFTLFlag                 = string.Empty;
    private string strCarTonCode              = string.Empty;
    private string strCarTypeCode             = string.Empty;
    private string strPickupHM                = string.Empty;
    private string strPickupPlaceFullAddr     = string.Empty;
    private string strGetYMD                  = string.Empty;
    private string strGetHM                   = string.Empty;
    private string strGetPlaceFullAddr        = string.Empty;
    private string strVolume                  = string.Empty;
    private string strCBM                     = string.Empty;
    private string strWeight                  = string.Empty;
    private string strLength                  = string.Empty;
    private string strCarFixedFlag            = string.Empty;
    private string strGoodsRunType            = string.Empty;
    private string strLayoverFlag             = string.Empty;
    private string strSamePlaceCount          = string.Empty;
    private string strNonSamePlaceCount       = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodInoutContract,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutList,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutPayList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutPayIns,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutPayUpd,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutPayDel,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutCodeList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientCsList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientNote,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientSaleLimit,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateOrderList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateOrderApplyList, MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAmtRequestOrderList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAmtRequestIns,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAmtRequestCnl,           MenuAuthType.ReadWrite);
        
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

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("InoutCostInsHandler");
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
            strOrderClientName         = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientName           = SiteGlobal.GetRequestForm("PayClientName");
            strPayClientChargeLocation = SiteGlobal.GetRequestForm("PayClientChargeLocation");
            strConsignorName           = SiteGlobal.GetRequestForm("ConsignorName");
            strPickupPlace             = SiteGlobal.GetRequestForm("PickupPlace");
            strGetPlace                = SiteGlobal.GetRequestForm("GetPlace");
            strNoteClient              = SiteGlobal.GetRequestForm("NoteClient");
            strGoodsSeqNo              = SiteGlobal.GetRequestForm("GoodsSeqNo");
            strNoteClient              = SiteGlobal.GetRequestForm("NoteClient");
            strClientCode              = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0"); //검색용
            strClientName              = SiteGlobal.GetRequestForm("ClientName");
            strChargeOrderFlag         = SiteGlobal.GetRequestForm("ChargeOrderFlag");
            strChargePayFlag           = SiteGlobal.GetRequestForm("ChargePayFlag");
            strChargeBillFlag          = SiteGlobal.GetRequestForm("ChargeBillFlag");
            strClientFlag              = SiteGlobal.GetRequestForm("ClientFlag");
            strChargeFlag              = SiteGlobal.GetRequestForm("ChargeFlag");
            strComName                 = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo               = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarNo                   = SiteGlobal.GetRequestForm("CarNo");
            strDriverName              = SiteGlobal.GetRequestForm("DriverName");
            strSupplyAmt               = Utils.IsNull(SiteGlobal.GetRequestForm("SupplyAmt"),  "0");
            strTaxAmt                  = Utils.IsNull(SiteGlobal.GetRequestForm("TaxAmt"),     "0");
            strSeqNo                   = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),      "0");
            strGoodsSeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"), "0");
            strPayType                 = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"),    "0");
            strTaxKind                 = Utils.IsNull(SiteGlobal.GetRequestForm("TaxKind"),    "0");
            strItemCode                = SiteGlobal.GetRequestForm("ItemCode");
            strPickupYMD               = SiteGlobal.GetRequestForm("PickupYMD");
            strPayClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("PayClientCode"),   "0");
            strSortType                = Utils.IsNull(SiteGlobal.GetRequestForm("SortType"),        "1");
            strApplySeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("ApplySeqNo"),      "0");
            strTransDtlSeqNo           = Utils.IsNull(SiteGlobal.GetRequestForm("TransDtlSeqNo"),   "0");
            strTransRateStatus         = Utils.IsNull(SiteGlobal.GetRequestForm("TransRateStatus"), "1");
            strReqKind                 = Utils.IsNull(SiteGlobal.GetRequestForm("ReqKind"),         "0");
            strPaySeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("PaySeqNo"),        "0");
            strReqSupplyAmt            = Utils.IsNull(SiteGlobal.GetRequestForm("ReqSupplyAmt"),    "0");
            strReqTaxAmt               = Utils.IsNull(SiteGlobal.GetRequestForm("ReqTaxAmt"),       "0");
            strReqReason               = SiteGlobal.GetRequestForm("ReqReason");
            strConsignorCode           = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strOrderItemCode           = SiteGlobal.GetRequestForm("OrderItemCode");
            strOrderLocationCode       = SiteGlobal.GetRequestForm("OrderLocationCode");
            strFTLFlag                 = SiteGlobal.GetRequestForm("FTLFlag");
            strCarTonCode              = SiteGlobal.GetRequestForm("CarTonCode");
            strCarTypeCode             = SiteGlobal.GetRequestForm("CarTypeCode");
            strPickupHM                = SiteGlobal.GetRequestForm("PickupHM");
            strPickupPlaceFullAddr     = SiteGlobal.GetRequestForm("PickupPlaceFullAddr");
            strGetYMD                  = SiteGlobal.GetRequestForm("GetYMD");
            strGetHM                   = SiteGlobal.GetRequestForm("GetHM");
            strGetPlaceFullAddr        = SiteGlobal.GetRequestForm("GetPlaceFullAddr");
            strVolume                  = SiteGlobal.GetRequestForm("Volume");
            strCBM                     = SiteGlobal.GetRequestForm("CBM");
            strWeight                  = SiteGlobal.GetRequestForm("Weight");
            strLength                  = SiteGlobal.GetRequestForm("Length");
            strCarFixedFlag            = SiteGlobal.GetRequestForm("CarFixedFlag");
            strGoodsRunType            = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsRunType"), "1"); // 2023-03-16 by shadow54 : 자동운임 수정 건
            strLayoverFlag             = SiteGlobal.GetRequestForm("LayoverFlag");
            strSamePlaceCount          = Utils.IsNull(SiteGlobal.GetRequestForm("SamePlaceCount"),    "0");
            strNonSamePlaceCount       = Utils.IsNull(SiteGlobal.GetRequestForm("NonSamePlaceCount"), "0");

            
            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
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
                case MethodInoutContract:
                    GetInoutContract();
                    break;
                case MethodInoutList:
                    GetInoutList();
                    break;
                case MethodInoutPayList:
                    GetInoutPayList();
                    break;
                case MethodInoutPayIns:
                    SetInoutPayIns();
                    break;
                case MethodInoutPayUpd:
                    SetInoutPayUpd();
                    break;
                case MethodInoutPayDel:
                    SetInoutPayDel();
                    break;
                case MethodInoutCodeList:
                    GetInoutCodeList();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodClientCsList:
                    GetClientCsList();
                    break;
                case MethodClientNote:
                    GetClientNote();
                    break;
                case MethodClientSaleLimit:
                    GetClientSaleLimit();
                    break;
                case MethodTransRateOrderList:
                    GetTransRateOrderList();
                    break;
                case MethodTransRateOrderApplyList:
                    GetTransRateOrderApplyList();
                    break;
                case MethodAmtRequestOrderList:
                    GetAmtRequestOrderList();
                    break;
                case MethodAmtRequestIns:
                    SetAmtRequestIns();
                    break;
                case MethodAmtRequestCnl:
                    SetAmtRequestCnl();
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

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process


    /// <summary>
    /// 오더 위수탁 정보
    /// </summary>
    protected void GetInoutContract()
    {
        ReqInoutOrderContract                lo_objReqInoutOrderContract = null;
        ServiceResult<ResInoutOrderContract> lo_objResInoutOrderContract = null;
            

        if (strCenterCode.Equals("0") && string.IsNullOrWhiteSpace(strCenterCode))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strOrderNo.Equals("0") && string.IsNullOrWhiteSpace(strOrderNo))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqInoutOrderContract = new ReqInoutOrderContract
            {
                CenterCode = strCenterCode.ToInt(),
                OrderNo    = strOrderNo.ToInt64(),
                AdminID    = objSes.AdminID
            };

            lo_objResInoutOrderContract = objOrderDasServices.GetInoutOrderContract(lo_objReqInoutOrderContract);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResInoutOrderContract) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 오더 현황 목록
    /// </summary>
    protected void GetInoutList()
    {
        ReqOrderList                lo_objReqOrderList = null;
        ServiceResult<ResOrderList> lo_objResOrderList = null;
        int                         lo_intListType     = 2;

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

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 비용 목록
    /// </summary>
    protected void GetInoutPayList()
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
            lo_objResOrderPayList = objOrderDasServices.GetOrderPayList(0, strOrderNo.ToInt64(), objSes.AccessCenterCode);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 비용 등록
    /// </summary>
    protected void SetInoutPayIns()
    {
        OrderPayModel                lo_objOrderPayModel  = null;
        ServiceResult<OrderPayModel> lo_objResOrderPayIns = null;

        strGoodsSeqNo = Utils.IsNull(strGoodsSeqNo, "0");
        strPayType    = Utils.IsNull(strPayType,    "0");
        strTaxKind    = Utils.IsNull(strTaxKind,    "0");
        strPayType    = Utils.IsNull(strPayType,    "0");
        
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
        
        if (!string.IsNullOrWhiteSpace(strSeqNo) && !strSeqNo.Equals("0"))
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
            if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
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
                CenterCode      = strCenterCode.ToInt(),
                OrderNo         = strOrderNo.ToInt64(),
                GoodsSeqNo      = strGoodsSeqNo.ToInt64(),
                PayType         = strPayType.ToInt(),
                TaxKind         = strTaxKind.ToInt(),
                ItemCode        = strItemCode,
                ClientCode      = strClientCode.ToInt64(),
                ClientName      = strClientName,
                SupplyAmt       = strSupplyAmt.ToDouble(),
                TaxAmt          = strTaxAmt.ToDouble(),
                ApplySeqNo      = strApplySeqNo.ToInt64(),
                TransDtlSeqNo   = strTransDtlSeqNo.ToInt64(),
                TransRateStatus = strTransRateStatus.ToInt(),
                RegAdminID      = objSes.AdminID,
                RegAdminName    = objSes.AdminName
            };

            lo_objResOrderPayIns = objOrderDasServices.SetOrderPayIns(lo_objOrderPayModel);
            objResMap.RetCode  = lo_objResOrderPayIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderPayIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SeqNo",    lo_objResOrderPayIns.data.SeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 비용 수정
    /// </summary>
    protected void SetInoutPayUpd()
    {
        OrderPayModel       lo_objOrderPayModel  = null;
        ServiceResult<bool> lo_objResOrderPayUpd = null;

        strGoodsSeqNo = Utils.IsNull(strGoodsSeqNo, "0");
        strPayType    = Utils.IsNull(strPayType,    "0");
        strTaxKind    = Utils.IsNull(strTaxKind,    "0");
        
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
        
        if (string.IsNullOrWhiteSpace(strSeqNo) || strSeqNo.Equals("0"))
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
            if (string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
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
                SeqNo           = strSeqNo.ToInt64(),
                CenterCode      = strCenterCode.ToInt(),
                OrderNo         = strOrderNo.ToInt64(),
                GoodsSeqNo      = strGoodsSeqNo.ToInt64(),
                PayType         = strPayType.ToInt(),
                TaxKind         = strTaxKind.ToInt(),
                ItemCode        = strItemCode,
                ClientCode      = strClientCode.ToInt64(),
                ClientName      = strClientName,
                SupplyAmt       = strSupplyAmt.ToDouble(),
                TaxAmt          = strTaxAmt.ToDouble(),
                ApplySeqNo      = strApplySeqNo.ToInt64(),
                TransDtlSeqNo   = strTransDtlSeqNo.ToInt64(),
                TransRateStatus = strTransRateStatus.ToInt(),
                UpdAdminID      = objSes.AdminID,
                UpdAdminName    = objSes.AdminName
            };

            lo_objResOrderPayUpd = objOrderDasServices.SetOrderPayUpd(lo_objOrderPayModel);
            objResMap.RetCode  = lo_objResOrderPayUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderPayUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 비용 삭제
    /// </summary>
    protected void SetInoutPayDel()
    {
        ServiceResult<bool> lo_objResOrderPayDel = null;

        strGoodsSeqNo = Utils.IsNull(strGoodsSeqNo, "0");
        strPayType    = Utils.IsNull(strPayType,    "0");
        
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
        
        if (string.IsNullOrWhiteSpace(strSeqNo) || strSeqNo.Equals("0"))
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
        
        try
        {
            lo_objResOrderPayDel = objOrderDasServices.SetOrderPayDel(strSeqNo.ToInt64(), strCenterCode.ToInt(), strOrderNo.ToInt64(), strPayType.ToInt(), objSes.AdminID, objSes.AdminName);
            objResMap.RetCode    = lo_objResOrderPayDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderPayDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 회원사별 항목 조회
    /// </summary>
    protected void GetInoutCodeList()
    {
        string    lo_strPayItemGroupName  = string.Empty;
        DataTable lo_objPayItemCodeTable  = null;

        if(string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        try
        {
            lo_objPayItemCodeTable = Utils.GetItemList(objHttpContext, "OP", strCenterCode, objSes.AdminID, out lo_strPayItemGroupName);
            if (lo_objPayItemCodeTable != null)
            {
                objResMap.Add("PayItemCode", lo_objPayItemCodeTable.Rows.OfType<DataRow>().Select(dr => new
                {
                    ItemFullCode = dr.Field<string>("ItemFullCode"),
                    ItemName     = dr.Field<string>("ItemName")
                }).ToList());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 고객사(발주처, 청구처, 업체명) 목록
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

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    
    /// <summary>
    /// 업체 정보 & 비고
    /// </summary>
    protected void GetClientNote()
    {   
        ReqClientList                   lo_objReqClientList    = null;
        ServiceResult<ResClientList>    lo_objResClientList    = null;

        if(string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientList = new ReqClientList
            {
                ClientCode       = strClientCode.ToInt(),
                CenterCode       = strCenterCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = 0,
                PageNo           = 0
            };

            lo_objResClientList   = objClientDasServices.GetClientList(lo_objReqClientList);
            if (lo_objResClientList.result.ErrorCode.IsFail())
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "고객사 정보를 찾지 못했습니다.";
                return;
            }
            
            if (!lo_objResClientList.data.RecordCnt.Equals(1))
            {
                objResMap.RetCode = 9005;
                objResMap.ErrMsg  = "고객사 정보를 찾지 못했습니다.";
                return;
            }
            
            objResMap.Add("CenterCode", lo_objResClientList.data.list[0].CenterCode);
            objResMap.Add("ClientName", lo_objResClientList.data.list[0].ClientName);
            objResMap.Add("ClientNote", lo_objResClientList.data.list[0].ClientNote2);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 거래처 매출 한도 및 원가율 조회
    /// </summary>
    protected void GetClientSaleLimit()
    {
        ReqClientSaleLimit                lo_objReqClientSaleLimit = null;
        ServiceResult<ResClientSaleLimit> lo_objResClientSaleLimit = null;

        strPickupYMD = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        
        if (string.IsNullOrWhiteSpace(strPickupYMD))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientSaleLimit = new ReqClientSaleLimit
            {
                YMD        = strPickupYMD,
                CenterCode = strCenterCode.ToInt(),
                ClientCode = strPayClientCode.ToInt64(),
                OrderNo    = strOrderNo.ToInt64()
            };

            lo_objResClientSaleLimit = objClientSaleLimitDasServices.GetClientSaleLimit(lo_objReqClientSaleLimit);
            objResMap.RetCode        = lo_objResClientSaleLimit.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResClientSaleLimit.result.ErrorMsg;
                return;
            }

            objResMap.Add("ClientBusinessStatus", lo_objResClientSaleLimit.data.ClientBusinessStatus);
            objResMap.Add("LimitCheckFlag",       lo_objResClientSaleLimit.data.LimitCheckFlag);
            objResMap.Add("LimitAvailFlag",       lo_objResClientSaleLimit.data.LimitAvailFlag);
            objResMap.Add("SaleLimitAmt",         lo_objResClientSaleLimit.data.SaleLimitAmt);
            objResMap.Add("LimitAvailAmt",        lo_objResClientSaleLimit.data.LimitAvailAmt);
            objResMap.Add("RevenueLimitPer",      lo_objResClientSaleLimit.data.RevenueLimitPer);
            objResMap.Add("TotalSaleAmt",         lo_objResClientSaleLimit.data.TotalSaleAmt);
            objResMap.Add("TotalPurchaseAmt",     lo_objResClientSaleLimit.data.TotalPurchaseAmt);
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 조회(적용후)
    /// </summary>
    protected void GetTransRateOrderList()
    {
        ReqTransRateOrderList                lo_objReqTransRateOrderList = null;
        ServiceResult<ResTransRateOrderList> lo_objResTransRateOrderList = null;

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

        if (string.IsNullOrWhiteSpace(strCarFixedFlag))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqTransRateOrderList = new ReqTransRateOrderList
            {
                CenterCode   = strCenterCode.ToInt(),
                OrderNo      = strOrderNo.ToInt64(),
                CarFixedFlag = strCarFixedFlag,
                AdminID      = objSes.AdminID
            };
                
            lo_objResTransRateOrderList = objOrderDasServices.GetTransRateOrderList(lo_objReqTransRateOrderList);
            objResMap.strResponse       = "[" + JsonConvert.SerializeObject(lo_objResTransRateOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 요율표 조회
    /// </summary>
    protected void GetTransRateOrderApplyList()
    {
        ReqTransRateOrderApplyList                lo_objReqTransRateOrderApplyList = null;
        ServiceResult<ResTransRateOrderApplyList> lo_objResTransRateOrderApplyList = null;
        string                                    lo_strFromAddr1                  = string.Empty;
        string                                    lo_strFromAddr2                  = string.Empty;
        string                                    lo_strFromAddr3                  = string.Empty;
        string                                    lo_strToAddr1                    = string.Empty;
        string                                    lo_strToAddr2                    = string.Empty;
        string                                    lo_strToAddr3                    = string.Empty;

        strGoodsRunType      = "1"; //운행구분 (1:편도, 2:왕복, 3:기타)
        strLayoverFlag       = "N"; //경유여부
        strSamePlaceCount    = "0";
        strNonSamePlaceCount = "0";
        strVolume            = Utils.IsNull(strVolume, "0");
        strWeight            = Utils.IsNull(strWeight, "0");
        strLength            = Utils.IsNull(strLength, "0");
        strCBM               = Utils.IsNull(strCBM,    "0");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderItemCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderLocationCode) )
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMD) || string.IsNullOrWhiteSpace(strPickupPlaceFullAddr))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetYMD) || string.IsNullOrWhiteSpace(strGetPlaceFullAddr))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarTonCode) || string.IsNullOrWhiteSpace(strCarTypeCode))
        {
            objResMap.RetCode = 9008;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strFTLFlag))
        {
            objResMap.RetCode = 9009;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_strFromAddr1 = strPickupPlaceFullAddr.Split(' ')[0];
            lo_strFromAddr2 = strPickupPlaceFullAddr.Split(' ')[1];
            lo_strFromAddr3 = strPickupPlaceFullAddr.Split(' ').Length.Equals(4) ? strPickupPlaceFullAddr.Split(' ')[2] : string.Empty;
            lo_strToAddr1   = strGetPlaceFullAddr.Split(' ')[0];
            lo_strToAddr2   = strGetPlaceFullAddr.Split(' ')[1];
            lo_strToAddr3   = strGetPlaceFullAddr.Split(' ').Length.Equals(4) ? strGetPlaceFullAddr.Split(' ')[2] : string.Empty;

            strPickupPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strFromAddr1) ? ("," + lo_strFromAddr1) : string.Empty;
            strPickupPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strFromAddr2) ? (","  + lo_strFromAddr1 + " " + lo_strFromAddr2) : string.Empty;
            strPickupPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strFromAddr3) ? (","  + lo_strFromAddr1 + " " + lo_strFromAddr2 + " " + lo_strFromAddr3) : string.Empty;
            strGetPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strToAddr1) ? ("," + lo_strToAddr1) : string.Empty;
            strGetPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strToAddr2) ? ("," + lo_strToAddr1 + " " + lo_strToAddr2) : string.Empty;
            strGetPlaceFullAddr += !string.IsNullOrWhiteSpace(lo_strToAddr3) ? ("," + lo_strToAddr1 + " " + lo_strToAddr2 + " " + lo_strToAddr3) : string.Empty;

            lo_objReqTransRateOrderApplyList = new ReqTransRateOrderApplyList
            {
                CenterCode        = strCenterCode.ToInt(),
                ClientCode        = strPayClientCode.ToInt64(),
                ConsignorCode     = strConsignorCode.ToInt64(),
                OrderItemCode     = strOrderItemCode,
                OrderLocationCode = strOrderLocationCode,
                FTLFlag           = strFTLFlag,
                CarFixedFlag      = strCarFixedFlag,
                FromAddrs         = strPickupPlaceFullAddr,
                ToAddrs           = strGetPlaceFullAddr,
                GoodsRunType      = strGoodsRunType.ToInt(),
                CarTonCode        = strCarTonCode,
                CarTypeCode       = strCarTypeCode,
                PickupYMD         = strPickupYMD,
                PickupHM          = strPickupHM,
                GetYMD            = strGetYMD,
                GetHM             = strGetHM,
                Volume            = strVolume.ToInt(),
                CBM               = strCBM.ToDouble(),
                Weight            = strWeight.ToDouble(),
                Length            = strLength.ToInt(),
                LayoverFlag       = strLayoverFlag,
                SamePlaceCount    = strSamePlaceCount.ToInt(),
                NonSamePlaceCount = strNonSamePlaceCount.ToInt(),
                AdminID           = objSes.AdminID
            };

            lo_objResTransRateOrderApplyList = objOrderDasServices.GetTransRateOrderApplyList(lo_objReqTransRateOrderApplyList);
            objResMap.strResponse            = "[" + JsonConvert.SerializeObject(lo_objResTransRateOrderApplyList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 오더 비용 목록
    /// </summary>
    protected void GetAmtRequestOrderList()
    {
        ReqOrderAmtRequestOrderList                lo_objReqOrderAmtRequestOrderList = null;
        ServiceResult<ResOrderAmtRequestOrderList> lo_objResOrderAmtRequestOrderList = null;
        int                                        lo_intListType                    = 2;

        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderAmtRequestOrderList = new ReqOrderAmtRequestOrderList
            {
                OrderNo          = strOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                ListType         = lo_intListType,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResOrderAmtRequestOrderList = objOrderDasServices.GetOrderAmtRequestOrderList(lo_objReqOrderAmtRequestOrderList);
            objResMap.strResponse             = "[" + JsonConvert.SerializeObject(lo_objResOrderAmtRequestOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
        
    /// <summary>
    /// 비용 수정요청 등록
    /// </summary>
    protected void SetAmtRequestIns()
    {
        OrderAmtRequestModel                lo_objOrderAmtRequestModel  = null;
        ServiceResult<OrderAmtRequestModel> lo_objResOrderAmtRequestIns = null;
            
        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strReqKind) || strReqKind.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strPaySeqNo) || strPaySeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        if (string.IsNullOrWhiteSpace(strReqReason))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objOrderAmtRequestModel = new OrderAmtRequestModel
            {
                CenterCode   = strCenterCode.ToInt(),
                OrderNo      = strOrderNo.ToInt64(),
                ReqKind      = strReqKind.ToInt(),
                PaySeqNo     = strPaySeqNo.ToInt64(),
                ReqSupplyAmt = strReqSupplyAmt.ToDouble(),
                ReqTaxAmt    = strReqTaxAmt.ToDouble(),
                ReqReason    = strReqReason,
                RegAdminID   = objSes.AdminID,
                RegAdminName = objSes.AdminName
            };

            lo_objResOrderAmtRequestIns = objOrderDasServices.SetOrderAmtRequestIns(lo_objOrderAmtRequestModel);
            objResMap.RetCode           = lo_objResOrderAmtRequestIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderAmtRequestIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SeqNo", lo_objResOrderAmtRequestIns.data.SeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 비용 수정요청 취소
    /// </summary>
    protected void SetAmtRequestCnl()
    {
        ReqOrderAmtRequestCnl lo_objReqOrderAmtRequestCnl = null;
        ServiceResult<bool>   lo_objResOrderAmtRequestCnl = null;
            
        if (string.IsNullOrWhiteSpace(strSeqNo) || strSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderAmtRequestCnl = new ReqOrderAmtRequestCnl
            {
                SeqNo        = strSeqNo.ToInt(),
                CnlAdminID   = objSes.AdminID,
                CnlAdminName = objSes.AdminName
            };

            lo_objResOrderAmtRequestCnl = objOrderDasServices.SetOrderAmtRequestCnl(lo_objReqOrderAmtRequestCnl);
            objResMap.RetCode           = lo_objResOrderAmtRequestCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderAmtRequestCnl.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("InoutCostInsHandler", "Exception",
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