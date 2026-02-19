<%@ WebHandler Language="C#" Class="InoutHandler" %>
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
/// FileName        : InoutHandler.ashx
/// Description     : APP 수출입오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemAdminHandler
/// Author          : sybyun96@logislab.com, 2023-01-12
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class InoutHandler : AppAshxBaseHandler
{
    //상수 선언

    // 메소드 리스트
    private const string MethodInoutContract             = "InoutContract";                //오더 위수탁 정보
    private const string MethodInoutList                 = "InoutList";                    //오더 목록
    private const string MethodInoutIns                  = "InoutInsert";                  //오더 등록
    private const string MethodInoutUpd                  = "InoutUpdate";                  //오더 수정
    private const string MethodInoutOneCnl               = "InoutOneCancel";               //오더 단건 취소
    private const string MethodInoutPayList              = "InoutPayList";                 //비용 목록
    private const string MethodInoutPayIns               = "InoutPayInsert";               //비용 등록
    private const string MethodInoutPayUpd               = "InoutPayUpdate";               //비용 수정
    private const string MethodInoutPayDel               = "InoutPayDelete";               //비용 삭제
    private const string MethodInoutDispatchCarList      = "InoutDispatchCarList";         //배차차량 목록
    private const string MethodInoutLocationUpd          = "InoutLocationUpdate";          //사업장 변경
    private const string MethodInoutCodeList             = "InoutCodeList";                //회원사별 코드 조회
    private const string MethodClientList                = "ClientList";                   //고객사(발주/청구처) 조회
    private const string MethodClientChargeList          = "ClientChargeList";             //고객사 담당자 조회
    private const string MethodConsignorList             = "ConsignorList";                //화주 조회
    private const string MethodPlaceList                 = "PlaceList";                    //상하차지 조회
    private const string MethodPlaceChargeList           = "PlaceChargeList";              //상하차지 담당자 조회
    private const string MethodClientSaleLimit           = "ClientSaleLimit";              //매출 한도 정보 조회
        
    AppOrderDasServices          objAppOrderDasServices          = new AppOrderDasServices();
    OrderDasServices             objOrderDasServices             = new OrderDasServices();
    ClientDasServices            objClientDasServices            = new ClientDasServices();
    ClientPlaceChargeDasServices objClientPlaceChargeDasServices = new ClientPlaceChargeDasServices();
    ConsignorDasServices         objConsignorDasServices         = new ConsignorDasServices();
    ClientSaleLimitDasServices   objClientSaleLimitDasServices   = new ClientSaleLimitDasServices();

    private HttpContext          objHttpContext                  = null;

    private string strCallType                  = string.Empty;
    private int    intPageSize                  = 0;
    private int    intPageNo                    = 0;
    private string strCenterCode                = string.Empty;
    private string strDateType                  = string.Empty;
    private string strDateYMD                   = string.Empty;
    private string strOrderLocationCodes        = string.Empty;
    private string strOrderItemCodes            = string.Empty;
    private string strSearchClientType          = string.Empty;
    private string strSearchClientText          = string.Empty;
    private string strSearchPlaceType           = string.Empty;
    private string strSearchPlaceText           = string.Empty;
    private string strCsAdminID                 = string.Empty;
    private string strAcceptAdminName           = string.Empty;
    private string strOrderNo                   = string.Empty;
    private string strMyChargeFlag              = string.Empty;
    private string strMyOrderFlag               = string.Empty;
    private string strCnlFlag                   = string.Empty;
    private string strCarTonCode                = string.Empty;
    private string strCarTypeCode               = string.Empty;
    private string strNoLayerFlag               = string.Empty;
    private string strNoTopFlag                 = string.Empty;
    private string strFTLFlag                   = string.Empty;
    private string strArrivalReportFlag         = string.Empty;
    private string strCustomFlag                = string.Empty;
    private string strBondedFlag                = string.Empty;
    private string strDocumentFlag              = string.Empty;
    private string strLicenseFlag               = string.Empty;
    private string strInTimeFlag                = string.Empty;
    private string strControlFlag               = string.Empty;
    private string strQuickGetFlag              = string.Empty;
    private string strOrderFPISFlag             = string.Empty;
    private string strOrderLocationCode         = string.Empty;
    private string strOrderItemCode             = string.Empty;
    private string strOrderClientCode           = string.Empty;
    private string strOrderClientName           = string.Empty;
    private string strOrderClientChargeName     = string.Empty;
    private string strOrderClientChargePosition = string.Empty;
    private string strOrderClientChargeTelExtNo = string.Empty;
    private string strOrderClientChargeTelNo    = string.Empty;
    private string strOrderClientChargeCell     = string.Empty;
    private string strPayClientCode             = string.Empty;
    private string strPayClientName             = string.Empty;
    private string strPayClientChargeName       = string.Empty;
    private string strPayClientChargePosition   = string.Empty;
    private string strPayClientChargeTelExtNo   = string.Empty;
    private string strPayClientChargeTelNo      = string.Empty;
    private string strPayClientChargeCell       = string.Empty;
    private string strPayClientChargeLocation   = string.Empty;
    private string strConsignorCode             = string.Empty;
    private string strConsignorName             = string.Empty;
    private string strPickupYMD                 = string.Empty;
    private string strPickupHM                  = string.Empty;
    private string strPickupWay                 = string.Empty;
    private string strPickupPlace               = string.Empty;
    private string strPickupPlaceChargeName     = string.Empty;
    private string strPickupPlaceChargePosition = string.Empty;
    private string strPickupPlaceChargeTelExtNo = string.Empty;
    private string strPickupPlaceChargeTelNo    = string.Empty;
    private string strPickupPlaceChargeCell     = string.Empty;
    private string strPickupPlacePost           = string.Empty;
    private string strPickupPlaceAddr           = string.Empty;
    private string strPickupPlaceAddrDtl        = string.Empty;
    private string strPickupPlaceFullAddr       = string.Empty;
    private string strPickupPlaceNote           = string.Empty;
    private string strPickupPlaceLocalCode      = string.Empty;
    private string strPickupPlaceLocalName      = string.Empty;
    private string strGetYMD                    = string.Empty;
    private string strGetHM                     = string.Empty;
    private string strGetWay                    = string.Empty;
    private string strGetPlace                  = string.Empty;
    private string strGetPlaceChargeName        = string.Empty;
    private string strGetPlaceChargePosition    = string.Empty;
    private string strGetPlaceChargeTelExtNo    = string.Empty;
    private string strGetPlaceChargeTelNo       = string.Empty;
    private string strGetPlaceChargeCell        = string.Empty;
    private string strGetPlacePost              = string.Empty;
    private string strGetPlaceAddr              = string.Empty;
    private string strGetPlaceAddrDtl           = string.Empty;
    private string strGetPlaceFullAddr          = string.Empty;
    private string strGetPlaceNote              = string.Empty;
    private string strGetPlaceLocalCode         = string.Empty;
    private string strGetPlaceLocalName         = string.Empty;
    private string strNation                    = string.Empty;
    private string strHawb                      = string.Empty;
    private string strMawb                      = string.Empty;
    private string strInvoiceNo                 = string.Empty;
    private string strBookingNo                 = string.Empty;
    private string strStockNo                   = string.Empty;
    private string strGMOrderType               = string.Empty;
    private string strGMTripID                  = string.Empty;
    private string strVolume                    = string.Empty;
    private string strCBM                       = string.Empty;
    private string strWeight                    = string.Empty;
    private string strLength                    = string.Empty;
    private string strQuantity                  = string.Empty;
    private string strGoodsDispatchType         = string.Empty;
    private string strGoodsName                 = string.Empty;
    private string strGoodsNote                 = string.Empty;
    private string strGoodsRunType              = string.Empty;
    private string strCarFixedFlag              = string.Empty; // 2023-03-16 by shadow54 : 자동운임 수정 건
    private string strLayoverFlag               = string.Empty;
    private string strSamePlaceCount            = string.Empty;
    private string strNonSamePlaceCount         = string.Empty;
    private string strGoodsItemCode             = string.Empty;
    private string strNoteInside                = string.Empty;
    private string strNoteClient                = string.Empty;
    private string strTaxClientName             = string.Empty;
    private string strTaxClientCorpNo           = string.Empty;
    private string strTaxClientChargeName       = string.Empty;
    private string strTaxClientChargeTelNo      = string.Empty;
    private string strTaxClientChargeEmail      = string.Empty;
    private string strClientCode                = string.Empty; //검색용
    private string strClientName                = string.Empty;
    private string strChargeName                = string.Empty;
    private string strChargeBillFlag            = string.Empty;
    private string strClientFlag                = string.Empty;
    private string strChargeFlag                = string.Empty;
    private string strPlaceName                 = string.Empty;
    private string strComCorpNo                 = string.Empty;
    private string strCarNo                     = string.Empty;
    private string strDriverName                = string.Empty;
    private string strReqSeqNo                  = string.Empty;
    private string strSupplyAmt                 = string.Empty;
    private string strTaxAmt                    = string.Empty;
    private string strSeqNo                     = string.Empty;
    private string strGoodsSeqNo                = string.Empty;
    private string strPayType                   = string.Empty;
    private string strTaxKind                   = string.Empty;
    private string strItemCode                  = string.Empty;
    private string strOrderNos                  = string.Empty;
    private string strCnlReason                 = string.Empty;
    private string strChgSeqNo                  = string.Empty;
    private string strPlaceChargeName           = string.Empty;
    private string strSortType                  = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        /*
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodInoutContract,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutList,                 MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutIns,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutUpd,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutOneCnl,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutPayList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutPayIns,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutPayUpd,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutPayDel,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutDispatchCarList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodInoutLocationUpd,          MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodInoutCodeList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,                MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientChargeList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorIns,              MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPlaceList,                 MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceChargeList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceNote,                 MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientSaleLimit,           MenuAuthType.ReadOnly);
        */

        base.ProcessRequest(context);

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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("AppInoutHandler");
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
            strDateType                  = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"),   "0");
            strDateYMD                   = SiteGlobal.GetRequestForm("DateYMD");
            strOrderLocationCodes        = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes            = SiteGlobal.GetRequestForm("OrderItemCodes");
            strSearchClientType          = SiteGlobal.GetRequestForm("SearchClientType");
            strSearchClientText          = SiteGlobal.GetRequestForm("SearchClientText");
            strSearchPlaceType           = SiteGlobal.GetRequestForm("SearchPlaceType");
            strSearchPlaceText           = SiteGlobal.GetRequestForm("SearchPlaceText");
            strCsAdminID                 = SiteGlobal.GetRequestForm("CsAdminID");
            strMyChargeFlag              = SiteGlobal.GetRequestForm("MyChargeFlag");
            strMyOrderFlag               = SiteGlobal.GetRequestForm("MyOrderFlag");
            strCnlFlag                   = SiteGlobal.GetRequestForm("CnlFlag");
            strCarTonCode                = SiteGlobal.GetRequestForm("CarTonCode");
            strCarTypeCode               = SiteGlobal.GetRequestForm("CarTypeCode");
            strNoLayerFlag               = Utils.IsNull(SiteGlobal.GetRequestForm("NoLayerFlag"),       "N");
            strNoTopFlag                 = Utils.IsNull(SiteGlobal.GetRequestForm("NoTopFlag"),         "N");
            strFTLFlag                   = Utils.IsNull(SiteGlobal.GetRequestForm("FTLFlag"),           "N");
            strArrivalReportFlag         = Utils.IsNull(SiteGlobal.GetRequestForm("ArrivalReportFlag"), "N");
            strCustomFlag                = Utils.IsNull(SiteGlobal.GetRequestForm("CustomFlag"),        "N");
            strBondedFlag                = Utils.IsNull(SiteGlobal.GetRequestForm("BondedFlag"),        "N");
            strDocumentFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("DocumentFlag"),      "N");
            strLicenseFlag               = Utils.IsNull(SiteGlobal.GetRequestForm("LicenseFlag"),       "N");
            strInTimeFlag                = Utils.IsNull(SiteGlobal.GetRequestForm("InTimeFlag"),        "N");
            strControlFlag               = Utils.IsNull(SiteGlobal.GetRequestForm("ControlFlag"),       "N");
            strQuickGetFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("QuickGetFlag"),      "N");
            strOrderFPISFlag             = Utils.IsNull(SiteGlobal.GetRequestForm("OrderFPISFlag"),     "N");
            strOrderLocationCode         = SiteGlobal.GetRequestForm("OrderLocationCode");
            strOrderItemCode             = SiteGlobal.GetRequestForm("OrderItemCode");
            strOrderClientCode           = SiteGlobal.GetRequestForm("OrderClientCode");
            strOrderClientName           = SiteGlobal.GetRequestForm("OrderClientName");
            strOrderClientChargeName     = SiteGlobal.GetRequestForm("OrderClientChargeName");
            strOrderClientChargePosition = SiteGlobal.GetRequestForm("OrderClientChargePosition");
            strOrderClientChargeTelExtNo = SiteGlobal.GetRequestForm("OrderClientChargeTelExtNo");
            strOrderClientChargeTelNo    = SiteGlobal.GetRequestForm("OrderClientChargeTelNo");
            strOrderClientChargeCell     = SiteGlobal.GetRequestForm("OrderClientChargeCell");
            strPayClientCode             = SiteGlobal.GetRequestForm("PayClientCode");
            strPayClientName             = SiteGlobal.GetRequestForm("PayClientName");
            strPayClientChargeName       = SiteGlobal.GetRequestForm("PayClientChargeName");
            strPayClientChargePosition   = SiteGlobal.GetRequestForm("PayClientChargePosition");
            strPayClientChargeTelExtNo   = SiteGlobal.GetRequestForm("PayClientChargeTelExtNo");
            strPayClientChargeTelNo      = SiteGlobal.GetRequestForm("PayClientChargeTelNo");
            strPayClientChargeCell       = SiteGlobal.GetRequestForm("PayClientChargeCell");
            strPayClientChargeLocation   = SiteGlobal.GetRequestForm("PayClientChargeLocation");
            strConsignorCode             = SiteGlobal.GetRequestForm("ConsignorCode");
            strConsignorName             = SiteGlobal.GetRequestForm("ConsignorName");
            strPickupYMD                 = SiteGlobal.GetRequestForm("PickupYMD");
            strPickupHM                  = SiteGlobal.GetRequestForm("PickupHM");
            strPickupWay                 = SiteGlobal.GetRequestForm("PickupWay");
            strPickupPlace               = SiteGlobal.GetRequestForm("PickupPlace");
            strPickupPlaceChargeName     = SiteGlobal.GetRequestForm("PickupPlaceChargeName");
            strPickupPlaceChargePosition = SiteGlobal.GetRequestForm("PickupPlaceChargePosition");
            strPickupPlaceChargeTelExtNo = SiteGlobal.GetRequestForm("PickupPlaceChargeTelExtNo");
            strPickupPlaceChargeTelNo    = SiteGlobal.GetRequestForm("PickupPlaceChargeTelNo");
            strPickupPlaceChargeCell     = SiteGlobal.GetRequestForm("PickupPlaceChargeCell");
            strPickupPlacePost           = SiteGlobal.GetRequestForm("PickupPlacePost");
            strPickupPlaceAddr           = SiteGlobal.GetRequestForm("PickupPlaceAddr");
            strPickupPlaceAddrDtl        = SiteGlobal.GetRequestForm("PickupPlaceAddrDtl");
            strPickupPlaceFullAddr       = SiteGlobal.GetRequestForm("PickupPlaceFullAddr");
            strPickupPlaceNote           = SiteGlobal.GetRequestForm("PickupPlaceNote", false);
            strPickupPlaceLocalCode      = SiteGlobal.GetRequestForm("PickupPlaceLocalCode");
            strPickupPlaceLocalName      = SiteGlobal.GetRequestForm("PickupPlaceLocalName");
            strGetYMD                    = SiteGlobal.GetRequestForm("GetYMD");
            strGetHM                     = SiteGlobal.GetRequestForm("GetHM");
            strGetWay                    = SiteGlobal.GetRequestForm("GetWay");
            strGetPlace                  = SiteGlobal.GetRequestForm("GetPlace");
            strGetPlaceChargeName        = SiteGlobal.GetRequestForm("GetPlaceChargeName");
            strGetPlaceChargePosition    = SiteGlobal.GetRequestForm("GetPlaceChargePosition");
            strGetPlaceChargeTelExtNo    = SiteGlobal.GetRequestForm("GetPlaceChargeTelExtNo");
            strGetPlaceChargeTelNo       = SiteGlobal.GetRequestForm("GetPlaceChargeTelNo");
            strGetPlaceChargeCell        = SiteGlobal.GetRequestForm("GetPlaceChargeCell");
            strGetPlacePost              = SiteGlobal.GetRequestForm("GetPlacePost");
            strGetPlaceAddr              = SiteGlobal.GetRequestForm("GetPlaceAddr");
            strGetPlaceAddrDtl           = SiteGlobal.GetRequestForm("GetPlaceAddrDtl");
            strGetPlaceFullAddr          = SiteGlobal.GetRequestForm("GetPlaceFullAddr");
            strGetPlaceNote              = SiteGlobal.GetRequestForm("GetPlaceNote", false);
            strGetPlaceLocalCode         = SiteGlobal.GetRequestForm("GetPlaceLocalCode");
            strGetPlaceLocalName         = SiteGlobal.GetRequestForm("GetPlaceLocalName");
            strNoteInside                = SiteGlobal.GetRequestForm("NoteInside", false);
            strNoteClient                = SiteGlobal.GetRequestForm("NoteClient", false);
            strGoodsSeqNo                = SiteGlobal.GetRequestForm("GoodsSeqNo");
            strNation                    = SiteGlobal.GetRequestForm("Nation");
            strHawb                      = SiteGlobal.GetRequestForm("Hawb", false);
            strMawb                      = SiteGlobal.GetRequestForm("Mawb", false);
            strInvoiceNo                 = SiteGlobal.GetRequestForm("InvoiceNo");
            strBookingNo                 = SiteGlobal.GetRequestForm("BookingNo");
            strStockNo                   = SiteGlobal.GetRequestForm("StockNo");
            strGMOrderType               = SiteGlobal.GetRequestForm("GMOrderType");
            strGMTripID                  = SiteGlobal.GetRequestForm("GMTripID");
            strVolume                    = SiteGlobal.GetRequestForm("Volume");
            strCBM                       = SiteGlobal.GetRequestForm("CBM");
            strWeight                    = SiteGlobal.GetRequestForm("Weight");
            strLength                    = SiteGlobal.GetRequestForm("Length");
            strQuantity                  = SiteGlobal.GetRequestForm("Quantity");
            strGoodsDispatchType         = SiteGlobal.GetRequestForm("GoodsDispatchType");
            strGoodsName                 = SiteGlobal.GetRequestForm("GoodsName");
            strGoodsNote                 = SiteGlobal.GetRequestForm("GoodsNote", false);
            strGoodsRunType              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsRunType"), "1");// 2023-03-16 by shadow54 : 자동운임 수정 건
            strCarFixedFlag              = SiteGlobal.GetRequestForm("CarFixedFlag");
            strLayoverFlag               = SiteGlobal.GetRequestForm("LayoverFlag");
            strSamePlaceCount            = Utils.IsNull(SiteGlobal.GetRequestForm("SamePlaceCount"), "0");
            strNonSamePlaceCount         = Utils.IsNull(SiteGlobal.GetRequestForm("NonSamePlaceCount"), "0");
            strTaxClientName             = SiteGlobal.GetRequestForm("TaxClientName");
            strTaxClientCorpNo           = SiteGlobal.GetRequestForm("TaxClientCorpNo");
            strTaxClientChargeName       = SiteGlobal.GetRequestForm("TaxClientChargeName");
            strTaxClientChargeTelNo      = SiteGlobal.GetRequestForm("TaxClientChargeTelNo");
            strTaxClientChargeEmail      = SiteGlobal.GetRequestForm("TaxClientChargeEmail");
            strClientCode                = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0"); //검색용
            strClientName                = SiteGlobal.GetRequestForm("ClientName");
            strChargeName                = SiteGlobal.GetRequestForm("ChargeName");
            strChargeBillFlag            = SiteGlobal.GetRequestForm("ChargeBillFlag");
            strClientFlag                = SiteGlobal.GetRequestForm("ClientFlag");
            strChargeFlag                = SiteGlobal.GetRequestForm("ChargeFlag");
            strPlaceName                 = SiteGlobal.GetRequestForm("PlaceName");
            strComCorpNo                 = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarNo                     = SiteGlobal.GetRequestForm("CarNo");
            strDriverName                = SiteGlobal.GetRequestForm("DriverName");
            strReqSeqNo                  = SiteGlobal.GetRequestForm("ReqSeqNo");
            strSupplyAmt                 = Utils.IsNull(SiteGlobal.GetRequestForm("SupplyAmt"),     "0");
            strTaxAmt                    = Utils.IsNull(SiteGlobal.GetRequestForm("TaxAmt"),        "0");
            strSeqNo                     = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),         "0");
            strGoodsSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"),    "0");
            strPayType                   = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"),       "0");
            strTaxKind                   = Utils.IsNull(SiteGlobal.GetRequestForm("TaxKind"),       "0");
            strItemCode                  = SiteGlobal.GetRequestForm("ItemCode");
            strChgSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("ChgSeqNo"),    "0");
            strOrderNos                  = SiteGlobal.GetRequestForm("OrderNos");
            strCnlReason                 = SiteGlobal.GetRequestForm("CnlReason");
            strPlaceChargeName           = SiteGlobal.GetRequestForm("PlaceChargeName");
            strSortType                  = Utils.IsNull(SiteGlobal.GetRequestForm("SortType"), "1");

            strDateYMD = string.IsNullOrWhiteSpace(strDateYMD) ? strDateYMD : strDateYMD.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
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
                case MethodInoutIns:
                    SetInoutIns();
                    break;
                case MethodInoutUpd:
                    SetInoutUpd();
                    break;
                case MethodInoutOneCnl:
                    SetInoutOneCnl();
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
                case MethodInoutDispatchCarList:
                    GetInoutDispatchCarList();
                    break;
                case MethodInoutLocationUpd:
                    SetInoutLocationUpd();
                    break;
                case MethodInoutCodeList:
                    GetInoutCodeList();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodClientChargeList:
                    GetClientChargeList();
                    break;
                case MethodConsignorList:
                    GetConsignorList();
                    break;
                case MethodPlaceList:
                    GetPlaceList();
                    break;
                case MethodPlaceChargeList:
                    GetPlaceChargeList();
                    break;
                case MethodClientSaleLimit:
                    GetClientSaleLimit();
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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    

    #region Handler Process

    /// <summary>
    /// 수출입 오더 현황 카운트
    /// </summary>
    protected void GetInoutCount()
    {
        ReqInoutOrderCount                lo_objReqInoutOrderCount = null;
        ServiceResult<ResInoutOrderCount> lo_objResInoutOrderCount = null;

        try
        {
            lo_objReqInoutOrderCount = new ReqInoutOrderCount
            {
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResInoutOrderCount = objOrderDasServices.GetInoutOrderCount(lo_objReqInoutOrderCount);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResInoutOrderCount) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 오더 현황 목록
    /// </summary>
    protected void GetInoutList()
    {
        ReqAppOrderList                lo_objReqAppOrderList = null;
        ServiceResult<ResAppOrderList> lo_objResAppOrderList = null;
        int                            lo_intListType        = 2;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateYMD)))
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

        try
        {
            lo_objReqAppOrderList = new ReqAppOrderList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                ListType                = lo_intListType.ToInt(),
                DateType                = strDateType.ToInt(),
                DateYMD                 = strDateYMD,
                OrderLocationCodes      = strOrderLocationCodes.Replace("^", ","),
                OrderItemCodes          = strOrderItemCodes.Replace("^", ","),
                OrderClientName         = strOrderClientName,
                PayClientName           = strPayClientName,
                ConsignorName           = strConsignorName,
                PickupPlace             = strPickupPlace,
                GetPlace                = strGetPlace,
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
                PageNo                  = intPageNo
            };

            lo_objResAppOrderList = objAppOrderDasServices.GetAppOrderList(lo_objReqAppOrderList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResAppOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 오더 등록
    /// </summary>
    protected void SetInoutIns()
    {
        OrderModel                lo_objOrderModel   = null;
        ServiceResult<OrderModel> lo_objResOrderIns  = null;
        int                       lo_intOrderStatus  = 2;
        int                       lo_intOrderRegType = 1;

        strOrderClientCode   = Utils.IsNull(strOrderClientCode,   "0");
        strPayClientCode     = Utils.IsNull(strPayClientCode,     "0");
        strConsignorCode     = Utils.IsNull(strConsignorCode,     "0");
        strGoodsDispatchType = Utils.IsNull(strGoodsDispatchType, "1");
        strGoodsRunType      = Utils.IsNull(strGoodsRunType,      "1");
        strVolume            = Utils.IsNull(strVolume,            "0");
        strWeight            = Utils.IsNull(strWeight,            "0");
        strLength            = Utils.IsNull(strLength,            "0");
        strCBM               = Utils.IsNull(strCBM,               "0");
        strReqSeqNo          = Utils.IsNull(strReqSeqNo,          "0");
        strPickupYMD         = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        strGetYMD            = string.IsNullOrWhiteSpace(strGetYMD) ? strGetYMD : strGetYMD.Replace("-", "");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderLocationCode) || string.IsNullOrWhiteSpace(strOrderItemCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderClientCode) || strOrderClientCode.Equals("0") || string.IsNullOrWhiteSpace(strOrderClientName))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0") || string.IsNullOrWhiteSpace(strPayClientName))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0") || string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMD) || string.IsNullOrWhiteSpace(strPickupPlace))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetYMD) || string.IsNullOrWhiteSpace(strGetPlace))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //strWeight = Math.Ceiling(strWeight.ToDouble()) + string.Empty;

        try
        {
            lo_objOrderModel = new OrderModel
            {
                CenterCode                = strCenterCode.ToInt(),
                OrderItemCode             = strOrderItemCode,
                OrderLocationCode         = strOrderLocationCode,
                OrderClientCode           = strOrderClientCode.ToInt64(),
                OrderClientName           = strOrderClientName,
                OrderClientChargeName     = strOrderClientChargeName,
                OrderClientChargePosition = strOrderClientChargePosition,
                OrderClientChargeTelExtNo = strOrderClientChargeTelExtNo,
                OrderClientChargeTelNo    = strOrderClientChargeTelNo,
                OrderClientChargeCell     = strOrderClientChargeCell,
                PayClientCode             = strPayClientCode.ToInt64(),
                PayClientName             = strPayClientName,
                PayClientChargeName       = strPayClientChargeName,
                PayClientChargePosition   = strPayClientChargePosition,
                PayClientChargeTelExtNo   = strPayClientChargeTelExtNo,
                PayClientChargeTelNo      = strPayClientChargeTelNo,
                PayClientChargeCell       = strPayClientChargeCell,
                PayClientChargeLocation   = strPayClientChargeLocation,
                ConsignorCode             = strConsignorCode.ToInt64(),
                ConsignorName             = strConsignorName,
                PickupYMD                 = strPickupYMD,
                PickupHM                  = strPickupHM,
                PickupWay                 = strPickupWay,
                PickupPlace               = strPickupPlace,
                PickupPlacePost           = strPickupPlacePost,
                PickupPlaceAddr           = strPickupPlaceAddr,
                PickupPlaceAddrDtl        = strPickupPlaceAddrDtl,
                PickupPlaceFullAddr       = strPickupPlaceFullAddr,
                PickupPlaceChargeTelExtNo = strPickupPlaceChargeTelExtNo,
                PickupPlaceChargeTelNo    = strPickupPlaceChargeTelNo,
                PickupPlaceChargeCell     = strPickupPlaceChargeCell,
                PickupPlaceChargeName     = strPickupPlaceChargeName,
                PickupPlaceChargePosition = strPickupPlaceChargePosition,
                PickupPlaceLocalCode      = strPickupPlaceLocalCode,
                PickupPlaceLocalName      = strPickupPlaceLocalName,
                PickupPlaceNote           = strPickupPlaceNote,
                GetYMD                    = strGetYMD,
                GetHM                     = strGetHM,
                GetWay                    = strGetWay,
                GetPlace                  = strGetPlace,
                GetPlacePost              = strGetPlacePost,
                GetPlaceAddr              = strGetPlaceAddr,
                GetPlaceAddrDtl           = strGetPlaceAddrDtl,
                GetPlaceFullAddr          = strGetPlaceFullAddr,
                GetPlaceChargeTelExtNo    = strGetPlaceChargeTelExtNo,
                GetPlaceChargeTelNo       = strGetPlaceChargeTelNo,
                GetPlaceChargeCell        = strGetPlaceChargeCell,
                GetPlaceChargeName        = strGetPlaceChargeName,
                GetPlaceChargePosition    = strGetPlaceChargePosition,
                GetPlaceLocalCode         = strGetPlaceLocalCode,
                GetPlaceLocalName         = strGetPlaceLocalName,
                GetPlaceNote              = strGetPlaceNote,
                CarTonCode                = strCarTonCode,
                CarTypeCode               = strCarTypeCode,
                NoLayerFlag               = strNoLayerFlag,
                NoTopFlag                 = strNoTopFlag,
                FTLFlag                   = strFTLFlag,
                ArrivalReportFlag         = strArrivalReportFlag,
                CustomFlag                = strCustomFlag,
                BondedFlag                = strBondedFlag,
                DocumentFlag              = strDocumentFlag,
                LicenseFlag               = strLicenseFlag,
                InTimeFlag                = strInTimeFlag,
                ControlFlag               = strControlFlag,
                QuickGetFlag              = strQuickGetFlag,
                OrderFPISFlag             = strOrderFPISFlag,
                Nation                    = strNation,
                Hawb                      = strHawb,
                Mawb                      = strMawb,
                InvoiceNo                 = strInvoiceNo,
                BookingNo                 = strBookingNo,
                StockNo                   = strStockNo,
                GMOrderType               = strGMOrderType,
                GMTripID                  = strGMTripID,
                Volume                    = strVolume.ToInt(),
                CBM                       = strCBM.ToDouble(),
                Weight                    = strWeight.ToDouble(),
                Length                    = strLength.ToInt(),
                Quantity                  = strQuantity,
                GoodsItemCode             = strGoodsItemCode,
                GoodsDispatchType         = strGoodsDispatchType.ToInt(),
                GoodsName                 = strGoodsName,
                GoodsNote                 = strGoodsNote,
                GoodsRunType              = strGoodsRunType.ToInt(),
                CarFixedFlag              = strCarFixedFlag,
                LayoverFlag               = strLayoverFlag,
                SamePlaceCount            = strSamePlaceCount.ToInt(),
                NonSamePlaceCount         = strNonSamePlaceCount.ToInt(),
                NoteClient                = strNoteClient,
                NoteInside                = strNoteInside,
                TaxClientName             = strTaxClientName,
                TaxClientCorpNo           = strTaxClientCorpNo,
                TaxClientChargeName       = strTaxClientChargeName,
                TaxClientChargeTelNo      = strTaxClientChargeTelNo,
                TaxClientChargeEmail      = strTaxClientChargeEmail,
                RegAdminID                = objSes.AdminID,
                RegAdminName              = objSes.AdminName,
                ReqSeqNo                  = strReqSeqNo.ToInt64(),
                OrderRegType              = lo_intOrderRegType,
                OrderStatus               = lo_intOrderStatus
            };

            lo_objResOrderIns = objOrderDasServices.SetOrderIns(lo_objOrderModel);
            objResMap.RetCode = lo_objResOrderIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("OrderNo",    lo_objResOrderIns.data.OrderNo.ToString());
                objResMap.Add("GoodsSeqNo", lo_objResOrderIns.data.GoodsSeqNo.ToString());
                objResMap.Add("AddSeqNo",   lo_objResOrderIns.data.AddSeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 오더 수정
    /// </summary>
    protected void SetInoutUpd()
    {
        OrderModel                 lo_objOrderModel  = null;
        ServiceResult<ResOrderUpd> lo_objResOrderUpd = null;

        strOrderClientCode   = Utils.IsNull(strOrderClientCode,   "0");
        strPayClientCode     = Utils.IsNull(strPayClientCode,     "0");
        strConsignorCode     = Utils.IsNull(strConsignorCode,     "0");
        strGoodsDispatchType = Utils.IsNull(strGoodsDispatchType, "1");
        strGoodsRunType      = Utils.IsNull(strGoodsRunType,      "1");
        strVolume            = Utils.IsNull(strVolume,            "0");
        strWeight            = Utils.IsNull(strWeight,            "0");
        strLength            = Utils.IsNull(strLength,            "0");
        strCBM               = Utils.IsNull(strCBM,               "0");
        strReqSeqNo          = Utils.IsNull(strReqSeqNo,          "0");
        strPickupYMD         = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        strGetYMD            = string.IsNullOrWhiteSpace(strGetYMD) ? strGetYMD : strGetYMD.Replace("-", "");

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

        if (string.IsNullOrWhiteSpace(strOrderLocationCode) || string.IsNullOrWhiteSpace(strOrderItemCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderClientCode) || strOrderClientCode.Equals("0") || string.IsNullOrWhiteSpace(strOrderClientName))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPayClientCode) || strPayClientCode.Equals("0") || string.IsNullOrWhiteSpace(strPayClientName))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0") || string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupYMD) || string.IsNullOrWhiteSpace(strPickupPlace))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetYMD) || string.IsNullOrWhiteSpace(strGetPlace))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //strWeight = Math.Ceiling(strWeight.ToDouble()) + string.Empty;

        try
        {
            lo_objOrderModel = new OrderModel
            {
                CenterCode                = strCenterCode.ToInt(),
                OrderNo                   = strOrderNo.ToInt64(),
                OrderItemCode             = strOrderItemCode,
                OrderLocationCode         = strOrderLocationCode,
                OrderClientCode           = strOrderClientCode.ToInt64(),
                OrderClientName           = strOrderClientName,
                OrderClientChargeName     = strOrderClientChargeName,
                OrderClientChargePosition = strOrderClientChargePosition,
                OrderClientChargeTelExtNo = strOrderClientChargeTelExtNo,
                OrderClientChargeTelNo    = strOrderClientChargeTelNo,
                OrderClientChargeCell     = strOrderClientChargeCell,
                PayClientCode             = strPayClientCode.ToInt64(),
                PayClientName             = strPayClientName,
                PayClientChargeName       = strPayClientChargeName,
                PayClientChargePosition   = strPayClientChargePosition,
                PayClientChargeTelExtNo   = strPayClientChargeTelExtNo,
                PayClientChargeTelNo      = strPayClientChargeTelNo,
                PayClientChargeCell       = strPayClientChargeCell,
                PayClientChargeLocation   = strPayClientChargeLocation,
                ConsignorCode             = strConsignorCode.ToInt64(),
                ConsignorName             = strConsignorName,
                PickupYMD                 = strPickupYMD,
                PickupHM                  = strPickupHM,
                PickupWay                 = strPickupWay,
                PickupPlace               = strPickupPlace,
                PickupPlacePost           = strPickupPlacePost,
                PickupPlaceAddr           = strPickupPlaceAddr,
                PickupPlaceAddrDtl        = strPickupPlaceAddrDtl,
                PickupPlaceFullAddr       = strPickupPlaceFullAddr,
                PickupPlaceChargeTelExtNo = strPickupPlaceChargeTelExtNo,
                PickupPlaceChargeTelNo    = strPickupPlaceChargeTelNo,
                PickupPlaceChargeCell     = strPickupPlaceChargeCell,
                PickupPlaceChargeName     = strPickupPlaceChargeName,
                PickupPlaceChargePosition = strPickupPlaceChargePosition,
                PickupPlaceLocalCode      = strPickupPlaceLocalCode,
                PickupPlaceLocalName      = strPickupPlaceLocalName,
                PickupPlaceNote           = strPickupPlaceNote,
                GetYMD                    = strGetYMD,
                GetHM                     = strGetHM,
                GetWay                    = strGetWay,
                GetPlace                  = strGetPlace,
                GetPlacePost              = strGetPlacePost,
                GetPlaceAddr              = strGetPlaceAddr,
                GetPlaceAddrDtl           = strGetPlaceAddrDtl,
                GetPlaceFullAddr          = strGetPlaceFullAddr,
                GetPlaceChargeTelExtNo    = strGetPlaceChargeTelExtNo,
                GetPlaceChargeTelNo       = strGetPlaceChargeTelNo,
                GetPlaceChargeCell        = strGetPlaceChargeCell,
                GetPlaceChargeName        = strGetPlaceChargeName,
                GetPlaceChargePosition    = strGetPlaceChargePosition,
                GetPlaceLocalCode         = strGetPlaceLocalCode,
                GetPlaceLocalName         = strGetPlaceLocalName,
                GetPlaceNote              = strGetPlaceNote,
                CarTonCode                = strCarTonCode,
                CarTypeCode               = strCarTypeCode,
                NoLayerFlag               = strNoLayerFlag,
                NoTopFlag                 = strNoTopFlag,
                FTLFlag                   = strFTLFlag,
                ArrivalReportFlag         = strArrivalReportFlag,
                CustomFlag                = strCustomFlag,
                BondedFlag                = strBondedFlag,
                DocumentFlag              = strDocumentFlag,
                LicenseFlag               = strLicenseFlag,
                InTimeFlag                = strInTimeFlag,
                ControlFlag               = strControlFlag,
                QuickGetFlag              = strQuickGetFlag,
                OrderFPISFlag             = strOrderFPISFlag,
                GoodsSeqNo                = strGoodsSeqNo.ToInt(),
                Nation                    = strNation,
                Hawb                      = strHawb,
                Mawb                      = strMawb,
                InvoiceNo                 = strInvoiceNo,
                BookingNo                 = strBookingNo,
                StockNo                   = strStockNo,
                GMOrderType               = strGMOrderType,
                GMTripID                  = strGMTripID,
                Volume                    = strVolume.ToInt(),
                CBM                       = strCBM.ToDouble(),
                Weight                    = strWeight.ToDouble(),
                Length                    = strLength.ToInt(),
                Quantity                  = strQuantity,
                GoodsItemCode             = strGoodsItemCode,
                GoodsDispatchType         = strGoodsDispatchType.ToInt(),
                GoodsName                 = strGoodsName,
                GoodsNote                 = strGoodsNote,
                GoodsRunType              = strGoodsRunType.ToInt(),
                CarFixedFlag              = strCarFixedFlag, // 2023-03-16 by shadow54 : 자동운임 수정 건
                LayoverFlag               = strLayoverFlag,
                SamePlaceCount            = strSamePlaceCount.ToInt(),
                NonSamePlaceCount         = strNonSamePlaceCount.ToInt(),
                NoteClient                = strNoteClient,
                NoteInside                = strNoteInside,
                TaxClientName             = strTaxClientName,
                TaxClientCorpNo           = strTaxClientCorpNo,
                TaxClientChargeName       = strTaxClientChargeName,
                TaxClientChargeTelNo      = strTaxClientChargeTelNo,
                TaxClientChargeEmail      = strTaxClientChargeEmail,
                ChgSeqNo                  = strChgSeqNo.ToInt64(),
                UpdAdminID                = objSes.AdminID,
                UpdAdminName              = objSes.AdminName
            };

            lo_objResOrderUpd = objOrderDasServices.SetOrderUpd(lo_objOrderModel);
            objResMap.RetCode = lo_objResOrderUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderUpd.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SaleClosingFlag",     lo_objResOrderUpd.data.SaleClosingFlag);
                objResMap.Add("PurchaseClosingFlag", lo_objResOrderUpd.data.PurchaseClosingFlag);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 오더 단건 취소
    /// </summary>
    protected void SetInoutOneCnl()
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
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                CnlReason        = strCnlReason,
                CnlAdminID       = objSes.AdminID,
                CnlAdminName     = objSes.AdminName,
                ChgSeqNo         = strChgSeqNo.ToInt64()
            };

            lo_objResOrderOneCnl = objOrderDasServices.SetOrderOneCnl(lo_objReqOrderOneCnl);
            objResMap.RetCode = lo_objResOrderOneCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderOneCnl.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
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
                CenterCode    = strCenterCode.ToInt(),
                OrderNo       = strOrderNo.ToInt64(),
                GoodsSeqNo    = strGoodsSeqNo.ToInt64(),
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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
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
                SeqNo         = strSeqNo.ToInt64(),
                CenterCode    = strCenterCode.ToInt(),
                OrderNo       = strOrderNo.ToInt64(),
                GoodsSeqNo    = strGoodsSeqNo.ToInt64(),
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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 배차 목록
    /// </summary>
    protected void GetInoutDispatchCarList()
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수출입 사업장 변경
    /// </summary>
    protected void SetInoutLocationUpd()
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 회원사별 항목 조회
    /// </summary>
    protected void GetInoutCodeList()
    {
        string    lo_strLocationGroupName = string.Empty;
        DataTable lo_objLocationCodeTable = null;
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
            lo_objLocationCodeTable = Utils.GetItemList(objHttpContext, "OL", strCenterCode, objSes.AdminID, out lo_strLocationGroupName);
            if (lo_objLocationCodeTable != null)
            {
                objResMap.Add("LocationCode", lo_objLocationCodeTable.Rows.OfType<DataRow>().Select(dr => new {
                    ItemFullCode = dr.Field<string>("ItemFullCode"),
                    ItemName   = dr.Field<string>("ItemName")
                }).ToList());
            }

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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 담당자 검색
    /// </summary>
    protected void GetClientChargeList()
    {
        ReqClientSearchList                lo_objReqClientSearchList = null;
        ServiceResult<ResClientSearchList> lo_objResClientSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strChargeName))
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
                ClientCode       = strClientCode.ToInt(),
                UseFlag          = "Y",
                ChargeName       = strChargeName,
                ChargeUseFlag    = "Y",
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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 목록 검색
    /// </summary>
    protected void GetConsignorList()
    {
        ReqConsignorSearchList                lo_objReqConsignorSearchList = null;
        ServiceResult<ResConsignorSearchList> lo_objResConsignorSearchList = null;

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
            lo_objReqConsignorSearchList = new ReqConsignorSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ClientCode       = strClientCode.ToInt(),
                ConsignorName    = strConsignorName,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResConsignorSearchList = objConsignorDasServices.GetConsignorSearchList(lo_objReqConsignorSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResConsignorSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상하차지 검색
    /// </summary>
    protected void GetPlaceList()
    {
        ReqClientPlaceSearchList                lo_objReqClientPlaceSearchList = null;
        ServiceResult<ResClientPlaceSearchList> lo_objResClientPlaceSearchList = null;
        int                                     lo_intPageSize                 = 300;
        int                                     lo_intPageNo                   = 1;

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
            lo_objReqClientPlaceSearchList = new ReqClientPlaceSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                PlaceName        = strPlaceName,
                UseFlag          = "Y",
                ChargeUseFlag    = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = lo_intPageSize,
                PageNo           = lo_intPageNo
            };

            lo_objResClientPlaceSearchList = objClientPlaceChargeDasServices.GetClientPlaceSearchList(lo_objReqClientPlaceSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상하차지 담당자검색
    /// </summary>
    protected void GetPlaceChargeList()
    {
        ReqClientPlaceChargeSearchList                lo_objReqClientPlaceChargeSearchList = null;
        ServiceResult<ResClientPlaceChargeSearchList> lo_objResClientPlaceChargeSearchList = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPlaceChargeName))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqClientPlaceChargeSearchList = new ReqClientPlaceChargeSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ChargeName       = strPlaceChargeName,
                UseFlag          = "Y",
                ChargeUseFlag    = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResClientPlaceChargeSearchList = objClientPlaceChargeDasServices.GetClientPlaceChargeSearchList(lo_objReqClientPlaceChargeSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceChargeSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
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

            SiteGlobal.WriteLog("AppInoutHandler", "Exception",
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