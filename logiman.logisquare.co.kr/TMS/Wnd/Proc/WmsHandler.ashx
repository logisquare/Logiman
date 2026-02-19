<%@ WebHandler Language="C#" Class="WmsHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : WmsHandler.ashx
/// Description     : 배송 오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2025-08-23
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class WmsHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Wnd/WmsList"; //필수

    // 메소드 리스트
    private const string MethodWmsOrderList                  = "WmsOrderList";                  //배송 오더 목록
    private const string MethodWmsOrderLayoverList           = "WmsOrderLayoverList";           //배송지 목록
    private const string MethodWmsOrderReceiptList           = "WmsOrderReceiptList";           //증빙 조회
    private const string MethodWmsOrderReceiptFileDownload   = "WmsOrderReceiptFileDownload";   //파일 다운로드
    private const string MethodWmsOrderLayoverGoodsList      = "WmsOrderLayoverGoodsList";      //화물 목록
    private const string MethodWmsOrderLayoverGoodsStatusUpd = "WmsOrderLayoverGoodsStatusUpd"; //화물 상태 변경
    private const string MethodWmsCodeList                   = "WmsCodeList";                   //회원사별 코드 조회
    private const string MethodWmsList                       = "WmsList";                       //오더 목록
    private const string MethodWmsUpd                        = "WmsUpdate";                     //오더 수정
    private const string MethodWmsOneCnl                     = "WmsOneCancel";                  //오더 단건 취소
    private const string MethodWmsPayList                    = "WmsPayList";                    //비용 목록
    private const string MethodWmsPayIns                     = "WmsPayInsert";                  //비용 등록
    private const string MethodWmsPayUpd                     = "WmsPayUpdate";                  //비용 수정
    private const string MethodWmsPayDel                     = "WmsPayDelete";                  //비용 삭제
    private const string MethodWmsDispatchCarList            = "WmsDispatchCarList";            //배차차량 목록
    private const string MethodClientSaleLimit               = "ClientSaleLimit";               //매출 한도 정보 조회
    private const string MethodClientList                    = "ClientList";                    //고객사(발주/청구처) 조회
    private const string MethodClientChargeList              = "ClientChargeList";              //고객사 담당자 조회
    private const string MethodConsignorIns                  = "ConsignorInsert";               //화주등록
    private const string MethodConsignorMapList              = "ConsignorMapList";              //화주 조회
    private const string MethodPlaceList                     = "PlaceList";                     //상하차지 조회
    private const string MethodPlaceChargeList               = "PlaceChargeList";               //상하차지 담당자 조회
    private const string MethodPlaceNote                     = "PlaceNote";                     //상하차지 특이사항 조회
    private const string MethodCarDispatchRefList            = "CarDispatchRefList";            //배차차량 조회

    OrderDasServices             objOrderDasServices             = new OrderDasServices();
    OrderDispatchDasServices     objOrderDispatchDasServices     = new OrderDispatchDasServices();
    ClientSaleLimitDasServices   objClientSaleLimitDasServices   = new ClientSaleLimitDasServices();
    ClientDasServices            objClientDasServices            = new ClientDasServices();
    ClientPlaceChargeDasServices objClientPlaceChargeDasServices = new ClientPlaceChargeDasServices();
    ConsignorDasServices         objConsignorDasServices         = new ConsignorDasServices();
    CarDispatchDasServices       objCarDispatchDasServices       = new CarDispatchDasServices();

    private HttpContext objHttpContext = null;

    private string strCallType                  = string.Empty;
    private int    intPageSize                  = 0;
    private int    intPageNo                    = 0;
    private string strOrderNo                   = string.Empty;
    private string strCenterCode                = string.Empty;
    private string strDateFrom                  = string.Empty;
    private string strDateTo                    = string.Empty;
    private string strOrderStatuses             = string.Empty;
    private string strOrderClientName           = string.Empty;
    private string strPayClientName             = string.Empty;
    private string strConsignorName             = string.Empty;
    private string strPickupPlace               = string.Empty;
    private string strComName                   = string.Empty;
    private string strComCorpNo                 = string.Empty;
    private string strDriverName                = string.Empty;
    private string strCarNo                     = string.Empty;
    private string strDeliveryNo                = string.Empty;
    private string strAcceptAdminName           = string.Empty;
    private string strMyOrderFlag               = string.Empty;
    private string strCnlFlag                   = string.Empty;
    private string strLayoverSeqNo              = string.Empty;
    private string strFileSeqNo                 = string.Empty;
    private string strDispatchSeqNo             = string.Empty;
    private string strFileType                  = string.Empty;
    private string strFileGubun                 = string.Empty;
    private string strDelFlag                   = string.Empty;
    private string strFileUrl                   = string.Empty;
    private string strFileName                  = string.Empty;
    private string strReceiptType               = string.Empty;
    private string strGoodsSeqNo                = string.Empty;
    private string strStatusType                = string.Empty;
    private string strStatusValue               = string.Empty;
    private string strDateType                  = string.Empty;
    private string strOrderLocationCodes        = string.Empty;
    private string strOrderItemCodes            = string.Empty;
    private string strOrderClientChargeName     = string.Empty;
    private string strPayClientChargeName       = string.Empty;
    private string strPayClientChargeLocation   = string.Empty;
    private string strGetPlace                  = string.Empty;
    private string strNoteClient                = string.Empty;
    private string strTransCenterCode           = string.Empty;
    private string strContractCenterCode        = string.Empty;
    private string strCsAdminID                 = string.Empty;
    private string strMyChargeFlag              = string.Empty;
    private string strSortType                  = string.Empty;
    private string strPickupYMD                 = string.Empty;
    private string strPayClientCode             = string.Empty;
    private string strClientName                = string.Empty;
    private string strChargeBillFlag            = string.Empty;
    private string strClientFlag                = string.Empty;
    private string strChargeFlag                = string.Empty;
    private string strChargeName                = string.Empty;
    private string strClientCode                = string.Empty;
    private string strConsignorNote             = string.Empty;
    private string strPlaceName                 = string.Empty;
    private string strPlaceChargeName           = string.Empty;
    private string strSeqNo                     = string.Empty;
    private string strPayType                   = string.Empty;
    private string strTaxKind                   = string.Empty;
    private string strItemCode                  = string.Empty;
    private string strSupplyAmt                 = string.Empty;
    private string strTaxAmt                    = string.Empty;
    private string strTransDtlSeqNo             = string.Empty;
    private string strApplySeqNo                = string.Empty;
    private string strTransRateStatus           = string.Empty;
    private string strOrderItemCode             = string.Empty;
    private string strReqSeqNo                  = string.Empty;
    private string strNoLayerFlag               = string.Empty;
    private string strNoTopFlag                 = string.Empty;
    private string strArrivalReportFlag         = string.Empty;
    private string strCustomFlag                = string.Empty;
    private string strBondedFlag                = string.Empty;
    private string strDocumentFlag              = string.Empty;
    private string strLicenseFlag               = string.Empty;
    private string strInTimeFlag                = string.Empty;
    private string strControlFlag               = string.Empty;
    private string strQuickGetFlag              = string.Empty;
    private string strOrderFPISFlag             = string.Empty;
    private string strGoodsDispatchType         = string.Empty;
    private string strOrderLocationCode         = string.Empty;
    private string strConsignorCode             = string.Empty;
    private string strOrderClientCode           = string.Empty;
    private string strOrderClientChargePosition = string.Empty;
    private string strOrderClientChargeTelExtNo = string.Empty;
    private string strOrderClientChargeTelNo    = string.Empty;
    private string strOrderClientChargeCell     = string.Empty;
    private string strPayClientChargePosition   = string.Empty;
    private string strPayClientChargeTelExtNo   = string.Empty;
    private string strPayClientChargeTelNo      = string.Empty;
    private string strPayClientChargeCell       = string.Empty;
    private string strPickupHM                  = string.Empty;
    private string strPickupWay                 = string.Empty;
    private string strPickupPlacePost           = string.Empty;
    private string strPickupPlaceAddr           = string.Empty;
    private string strPickupPlaceAddrDtl        = string.Empty;
    private string strPickupPlaceFullAddr       = string.Empty;
    private string strPickupPlaceChargeTelExtNo = string.Empty;
    private string strPickupPlaceChargeTelNo    = string.Empty;
    private string strPickupPlaceChargeCell     = string.Empty;
    private string strPickupPlaceChargeName     = string.Empty;
    private string strPickupPlaceChargePosition = string.Empty;
    private string strPickupPlaceLocalCode      = string.Empty;
    private string strPickupPlaceLocalName      = string.Empty;
    private string strPickupPlaceNote           = string.Empty;
    private string strGetYMD                    = string.Empty;
    private string strGetHM                     = string.Empty;
    private string strGetWay                    = string.Empty;
    private string strGetPlacePost              = string.Empty;
    private string strGetPlaceAddr              = string.Empty;
    private string strGetPlaceAddrDtl           = string.Empty;
    private string strGetPlaceFullAddr          = string.Empty;
    private string strGetPlaceChargeTelExtNo    = string.Empty;
    private string strGetPlaceChargeTelNo       = string.Empty;
    private string strGetPlaceChargeCell        = string.Empty;
    private string strGetPlaceChargeName        = string.Empty;
    private string strGetPlaceChargePosition    = string.Empty;
    private string strGetPlaceLocalCode         = string.Empty;
    private string strGetPlaceLocalName         = string.Empty;
    private string strGetPlaceNote              = string.Empty;
    private string strCarTonCode                = string.Empty;
    private string strCarTypeCode               = string.Empty;
    private string strFTLFlag                   = string.Empty;
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
    private string strGoodsItemCode             = string.Empty;
    private string strGoodsRunType              = string.Empty;
    private string strCarFixedFlag              = string.Empty;
    private string strLayoverFlag               = string.Empty;
    private string strSamePlaceCount            = string.Empty;
    private string strNonSamePlaceCount         = string.Empty;
    private string strGoodsName                 = string.Empty;
    private string strGoodsNote                 = string.Empty;
    private string strNoteInside                = string.Empty;
    private string strTaxClientName             = string.Empty;
    private string strTaxClientCorpNo           = string.Empty;
    private string strTaxClientChargeName       = string.Empty;
    private string strTaxClientChargeTelNo      = string.Empty;
    private string strTaxClientChargeEmail      = string.Empty;
    private string strQuickType                 = string.Empty;
    private string strRefSeqNo                  = string.Empty;
    private string strInsureExceptKind          = string.Empty;
    private string strChgSeqNo                  = string.Empty;
    private string strCnlReason                 = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodWmsOrderList,                  MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWmsOrderLayoverList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWmsOrderReceiptList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWmsOrderReceiptFileDownload,   MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWmsOrderLayoverGoodsList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWmsOrderLayoverGoodsStatusUpd, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWmsCodeList,                   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWmsList,                       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWmsUpd,                        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWmsOneCnl,                     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWmsPayList,                    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodWmsPayIns,                     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWmsPayUpd,                     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWmsPayDel,                     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodWmsDispatchCarList,            MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientSaleLimit,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,                    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientChargeList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorIns,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodConsignorMapList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceList,                     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceChargeList,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceNote,                     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarDispatchRefList,            MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("WmsHandler");
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
            strOrderNo                   = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"),    "0");
            strCenterCode                = Utils.IsNull(SiteGlobal.GetRequestForm("CenterCode"), "0");
            strDateFrom                  = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                    = SiteGlobal.GetRequestForm("DateTo");
            strOrderStatuses             = SiteGlobal.GetRequestForm("OrderStatuses");
            strOrderClientName           = SiteGlobal.GetRequestForm("OrderClientName");
            strPayClientName             = SiteGlobal.GetRequestForm("PayClientName");
            strConsignorName             = SiteGlobal.GetRequestForm("ConsignorName");
            strPickupPlace               = SiteGlobal.GetRequestForm("PickupPlace");
            strComName                   = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo                 = SiteGlobal.GetRequestForm("ComCorpNo");
            strDriverName                = SiteGlobal.GetRequestForm("DriverName");
            strCarNo                     = SiteGlobal.GetRequestForm("CarNo");
            strDeliveryNo                = SiteGlobal.GetRequestForm("DeliveryNo");
            strAcceptAdminName           = SiteGlobal.GetRequestForm("AcceptAdminName");
            strMyOrderFlag               = SiteGlobal.GetRequestForm("MyOrderFlag");
            strCnlFlag                   = SiteGlobal.GetRequestForm("CnlFlag");
            strLayoverSeqNo              = Utils.IsNull(SiteGlobal.GetRequestForm("LayoverSeqNo"),  "0");
            strDispatchSeqNo             = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strFileSeqNo                 = Utils.IsNull(SiteGlobal.GetRequestForm("FileSeqNo"),     "0");
            strFileType                  = Utils.IsNull(SiteGlobal.GetRequestForm("FileType"),      "0");
            strFileGubun                 = Utils.IsNull(SiteGlobal.GetRequestForm("FileGubun"),     "0");
            strDelFlag                   = Utils.IsNull(SiteGlobal.GetRequestForm("DelFlag"),       "N");
            strFileUrl                   = SiteGlobal.GetRequestForm("FileUrl");
            strFileName                  = SiteGlobal.GetRequestForm("FileName");
            strReceiptType               = Utils.IsNull(SiteGlobal.GetRequestForm("ReceiptType"), "0");
            strGoodsSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"),  "0");
            strStatusType                = Utils.IsNull(SiteGlobal.GetRequestForm("StatusType"),  "0");
            strStatusValue               = Utils.IsNull(SiteGlobal.GetRequestForm("StatusValue"), "0");
            strGetPlace                  = SiteGlobal.GetRequestForm("GetPlace");
            strDateType                  = Utils.IsNull(SiteGlobal.GetRequestForm("DateType"), "0");
            strOrderLocationCodes        = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes            = SiteGlobal.GetRequestForm("OrderItemCodes");
            strOrderClientChargeName     = SiteGlobal.GetRequestForm("OrderClientChargeName");
            strPayClientChargeName       = SiteGlobal.GetRequestForm("PayClientChargeName");
            strPayClientChargeLocation   = SiteGlobal.GetRequestForm("PayClientChargeLocation");
            strNoteClient                = SiteGlobal.GetRequestForm("NoteClient", false);
            strTransCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("TransCenterCode"),    "0");
            strContractCenterCode        = Utils.IsNull(SiteGlobal.GetRequestForm("ContractCenterCode"), "0");
            strCsAdminID                 = SiteGlobal.GetRequestForm("CsAdminID");
            strMyChargeFlag              = SiteGlobal.GetRequestForm("MyChargeFlag");
            strSortType                  = Utils.IsNull(SiteGlobal.GetRequestForm("SortType"), "1");
            strPickupYMD                 = SiteGlobal.GetRequestForm("PickupYMD");
            strPayClientCode             = Utils.IsNull(SiteGlobal.GetRequestForm("PayClientCode"), "0");
            strClientName                = SiteGlobal.GetRequestForm("ClientName"); //검색용
            strChargeBillFlag            = SiteGlobal.GetRequestForm("ChargeBillFlag");
            strClientFlag                = SiteGlobal.GetRequestForm("ClientFlag");
            strChargeFlag                = SiteGlobal.GetRequestForm("ChargeFlag");
            strChargeName                = SiteGlobal.GetRequestForm("ChargeName");
            strClientCode                = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strPlaceName                 = SiteGlobal.GetRequestForm("PlaceName");
            strPlaceChargeName           = SiteGlobal.GetRequestForm("PlaceChargeName");
            strConsignorNote             = SiteGlobal.GetRequestForm("ConsignorNote");
            strSeqNo                     = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),   "0");
            strPayType                   = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"), "0");
            strTaxKind                   = Utils.IsNull(SiteGlobal.GetRequestForm("TaxKind"), "0");
            strItemCode                  = SiteGlobal.GetRequestForm("ItemCode");
            strSupplyAmt                 = Utils.IsNull(SiteGlobal.GetRequestForm("SupplyAmt"),       "0");
            strTaxAmt                    = Utils.IsNull(SiteGlobal.GetRequestForm("TaxAmt"),          "0");
            strTransDtlSeqNo             = Utils.IsNull(SiteGlobal.GetRequestForm("TransDtlSeqNo"),   "0");
            strApplySeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("ApplySeqNo"),      "0");
            strTransRateStatus           = Utils.IsNull(SiteGlobal.GetRequestForm("TransRateStatus"), "1");
            strOrderItemCode             = SiteGlobal.GetRequestForm("OrderItemCode");
            strReqSeqNo                  = SiteGlobal.GetRequestForm("ReqSeqNo");
            strNoLayerFlag               = Utils.IsNull(SiteGlobal.GetRequestForm("NoLayerFlag"),       "N");
            strNoTopFlag                 = Utils.IsNull(SiteGlobal.GetRequestForm("NoTopFlag"),         "N");
            strArrivalReportFlag         = Utils.IsNull(SiteGlobal.GetRequestForm("ArrivalReportFlag"), "N");
            strCustomFlag                = Utils.IsNull(SiteGlobal.GetRequestForm("CustomFlag"),        "N");
            strBondedFlag                = Utils.IsNull(SiteGlobal.GetRequestForm("BondedFlag"),        "N");
            strDocumentFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("DocumentFlag"),      "N");
            strLicenseFlag               = Utils.IsNull(SiteGlobal.GetRequestForm("LicenseFlag"),       "N");
            strInTimeFlag                = Utils.IsNull(SiteGlobal.GetRequestForm("InTimeFlag"),        "N");
            strControlFlag               = Utils.IsNull(SiteGlobal.GetRequestForm("ControlFlag"),       "N");
            strQuickGetFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("QuickGetFlag"),      "N");
            strOrderFPISFlag             = Utils.IsNull(SiteGlobal.GetRequestForm("OrderFPISFlag"),     "N");
            strGoodsDispatchType         = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsDispatchType"), "0");
            strOrderLocationCode         = SiteGlobal.GetRequestForm("OrderLocationCode");
            strConsignorCode             = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"),   "0");
            strOrderClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("OrderClientCode"), "0");
            strOrderClientChargePosition = SiteGlobal.GetRequestForm("OrderClientChargePosition");
            strOrderClientChargeTelExtNo = SiteGlobal.GetRequestForm("OrderClientChargeTelExtNo");
            strOrderClientChargeTelNo    = SiteGlobal.GetRequestForm("OrderClientChargeTelNo");
            strOrderClientChargeCell     = SiteGlobal.GetRequestForm("OrderClientChargeCell");
            strPayClientChargePosition   = SiteGlobal.GetRequestForm("PayClientChargePosition");
            strPayClientChargeTelExtNo   = SiteGlobal.GetRequestForm("PayClientChargeTelExtNo");
            strPayClientChargeTelNo      = SiteGlobal.GetRequestForm("PayClientChargeTelNo");
            strPayClientChargeCell       = SiteGlobal.GetRequestForm("PayClientChargeCell");
            strPickupHM                  = SiteGlobal.GetRequestForm("PickupHM");
            strPickupWay                 = SiteGlobal.GetRequestForm("PickupWay");
            strPickupPlacePost           = SiteGlobal.GetRequestForm("PickupPlacePost");
            strPickupPlaceAddr           = SiteGlobal.GetRequestForm("PickupPlaceAddr");
            strPickupPlaceAddrDtl        = SiteGlobal.GetRequestForm("PickupPlaceAddrDtl");
            strPickupPlaceFullAddr       = SiteGlobal.GetRequestForm("PickupPlaceFullAddr");
            strPickupPlaceChargeTelExtNo = SiteGlobal.GetRequestForm("PickupPlaceChargeTelExtNo");
            strPickupPlaceChargeTelNo    = SiteGlobal.GetRequestForm("PickupPlaceChargeTelNo");
            strPickupPlaceChargeCell     = SiteGlobal.GetRequestForm("PickupPlaceChargeCell");
            strPickupPlaceChargeName     = SiteGlobal.GetRequestForm("PickupPlaceChargeName");
            strPickupPlaceChargePosition = SiteGlobal.GetRequestForm("PickupPlaceChargePosition");
            strPickupPlaceLocalCode      = SiteGlobal.GetRequestForm("PickupPlaceLocalCode");
            strPickupPlaceLocalName      = SiteGlobal.GetRequestForm("PickupPlaceLocalName");
            strPickupPlaceNote           = SiteGlobal.GetRequestForm("PickupPlaceNote", false);
            strGetYMD                    = SiteGlobal.GetRequestForm("GetYMD");
            strGetHM                     = SiteGlobal.GetRequestForm("GetHM");
            strGetWay                    = SiteGlobal.GetRequestForm("GetWay");
            strGetPlacePost              = SiteGlobal.GetRequestForm("GetPlacePost");
            strGetPlaceAddr              = SiteGlobal.GetRequestForm("GetPlaceAddr");
            strGetPlaceAddrDtl           = SiteGlobal.GetRequestForm("GetPlaceAddrDtl");
            strGetPlaceFullAddr          = SiteGlobal.GetRequestForm("GetPlaceFullAddr");
            strGetPlaceChargeTelExtNo    = SiteGlobal.GetRequestForm("GetPlaceChargeTelExtNo");
            strGetPlaceChargeTelNo       = SiteGlobal.GetRequestForm("GetPlaceChargeTelNo");
            strGetPlaceChargeCell        = SiteGlobal.GetRequestForm("GetPlaceChargeCell");
            strGetPlaceChargeName        = SiteGlobal.GetRequestForm("GetPlaceChargeName");
            strGetPlaceChargePosition    = SiteGlobal.GetRequestForm("GetPlaceChargePosition");
            strGetPlaceLocalCode         = SiteGlobal.GetRequestForm("GetPlaceLocalCode");
            strGetPlaceLocalName         = SiteGlobal.GetRequestForm("GetPlaceLocalName");
            strGetPlaceNote              = SiteGlobal.GetRequestForm("GetPlaceNote", false);
            strCarTonCode                = SiteGlobal.GetRequestForm("CarTonCode");
            strCarTypeCode               = SiteGlobal.GetRequestForm("CarTypeCode");
            strFTLFlag                   = Utils.IsNull(SiteGlobal.GetRequestForm("FTLFlag"), "N");
            strNation                    = SiteGlobal.GetRequestForm("Nation");
            strHawb                      = SiteGlobal.GetRequestForm("Hawb", false);
            strMawb                      = SiteGlobal.GetRequestForm("Mawb", false);
            strInvoiceNo                 = SiteGlobal.GetRequestForm("InvoiceNo");
            strBookingNo                 = SiteGlobal.GetRequestForm("BookingNo");
            strStockNo                   = SiteGlobal.GetRequestForm("StockNo");
            strGMOrderType               = SiteGlobal.GetRequestForm("GMOrderType");
            strGMTripID                  = SiteGlobal.GetRequestForm("GMTripID");
            strVolume                    = Utils.IsNull(SiteGlobal.GetRequestForm("Volume"), "0");
            strCBM                       = Utils.IsNull(SiteGlobal.GetRequestForm("CBM"),    "0");
            strWeight                    = Utils.IsNull(SiteGlobal.GetRequestForm("Weight"), "0");
            strLength                    = Utils.IsNull(SiteGlobal.GetRequestForm("Length"), "0");
            strQuantity                  = SiteGlobal.GetRequestForm("Quantity");
            strGoodsItemCode             = SiteGlobal.GetRequestForm("GoodsItemCode");            
            strGoodsRunType              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsRunType"),      "1"); // 2023-03-16 by shadow54 : 자동운임 수정 건
            strCarFixedFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("CarFixedFlag"),      "Y");
            strLayoverFlag               = Utils.IsNull(SiteGlobal.GetRequestForm("LayoverFlag"),       "N");
            strSamePlaceCount            = Utils.IsNull(SiteGlobal.GetRequestForm("SamePlaceCount"),    "0");
            strNonSamePlaceCount         = Utils.IsNull(SiteGlobal.GetRequestForm("NonSamePlaceCount"), "0");
            strGoodsName                 = SiteGlobal.GetRequestForm("GoodsName");
            strGoodsNote                 = SiteGlobal.GetRequestForm("GoodsNote",  false);
            strNoteInside                = SiteGlobal.GetRequestForm("NoteInside", false);
            strTaxClientName             = SiteGlobal.GetRequestForm("TaxClientName");
            strTaxClientCorpNo           = SiteGlobal.GetRequestForm("TaxClientCorpNo");
            strTaxClientChargeName       = SiteGlobal.GetRequestForm("TaxClientChargeName");
            strTaxClientChargeTelNo      = SiteGlobal.GetRequestForm("TaxClientChargeTelNo");
            strTaxClientChargeEmail      = SiteGlobal.GetRequestForm("TaxClientChargeEmail");
            strQuickType                 = Utils.IsNull(SiteGlobal.GetRequestForm("QuickType"),        "1");
            strRefSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"),         "0");
            strInsureExceptKind          = Utils.IsNull(SiteGlobal.GetRequestForm("InsureExceptKind"), "1");
            strChgSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("ChgSeqNo"),         "0");
            strCnlReason                 = SiteGlobal.GetRequestForm("CnlReason");

            strDateFrom  = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo    = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
            strPickupYMD = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
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
                case MethodWmsOrderList:
                    GetWmsOrderList();
                    break;
                case MethodWmsOrderLayoverList:
                    GetWmsOrderLayoverList();
                    break;
                case MethodWmsOrderReceiptList:
                    GetWmsOrderReceiptList();
                    break;
                case MethodWmsOrderReceiptFileDownload:
                    SetWmsOrderReceiptFileDownload();
                    break;
                case MethodWmsOrderLayoverGoodsList:
                    GetWmsOrderLayoverGoodsList();
                    break;
                case MethodWmsOrderLayoverGoodsStatusUpd:
                    SetWmsOrderLayoverGoodsStatusUpd();
                    break;
                case MethodWmsCodeList:
                    GetWmsCodeList();
                    break;
                case MethodClientSaleLimit:
                    GetClientSaleLimit();
                    break;
                case MethodClientList:
                    GetClientList();
                    break;
                case MethodClientChargeList:
                    GetClientChargeList();
                    break;
                case MethodConsignorIns:
                    SetConsignorIns();
                    break;
                case MethodConsignorMapList:
                    GetConsignorMapList();
                    break;
                case MethodPlaceList:
                    GetPlaceList();
                    break;
                case MethodPlaceChargeList:
                    GetPlaceChargeList();
                    break;
                case MethodPlaceNote:
                    GetPlaceNote();
                    break;
                case MethodCarDispatchRefList:
                    GetCarDispatchRefList();
                    break;
                case MethodWmsList:
                    GetWmsList();
                    break;
                case MethodWmsUpd:
                    SetWmsUpd();
                    break;
                case MethodWmsOneCnl:
                    SetWmsOneCnl();
                    break;
                case MethodWmsPayList:
                    GetWmsPayList();
                    break;
                case MethodWmsPayIns:
                    SetWmsPayIns();
                    break;
                case MethodWmsPayUpd:
                    SetWmsPayUpd();
                    break;
                case MethodWmsPayDel:
                    SetWmsPayDel();
                    break;
                case MethodWmsDispatchCarList:
                    GetWmsDispatchCarList();
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    /// <summary>
    /// 배송 오더 목록
    /// </summary>
    protected void GetWmsOrderList()
    {
        ReqWmsOrderList                lo_objReqWmsOrderList = null;
        ServiceResult<ResWmsOrderList> lo_objResWmsOrderList = null;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqWmsOrderList = new ReqWmsOrderList
            {
                OrderNo          = strOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                OrderStatuses    = strOrderStatuses,
                OrderClientName  = strOrderClientName,
                PayClientName    = strPayClientName,
                ConsignorName    = strConsignorName,
                PickupPlace      = strPickupPlace,
                ComName          = strComName,
                ComCorpNo        = strComCorpNo,
                DriverName       = strDriverName,
                CarNo            = strCarNo,
                DeliveryNo       = strDeliveryNo,
                AcceptAdminName  = strAcceptAdminName,
                MyOrderFlag      = strMyOrderFlag,
                CnlFlag          = strCnlFlag,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo,
            };

            lo_objResWmsOrderList = objOrderDasServices.GetWmsOrderList(lo_objReqWmsOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResWmsOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 배송 오더 목록
    /// </summary>
    protected void GetWmsOrderLayoverList()
    {
        ReqWmsOrderLayoverList                lo_objReqWmsOrderLayoverList = null;
        ServiceResult<ResWmsOrderLayoverList> lo_objResWmsOrderLayoverList = null;
        intPageNo   = 1;
        intPageSize = 10000;

        if (string.IsNullOrWhiteSpace(strCenterCode) && strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }


        if (string.IsNullOrWhiteSpace(strOrderNo) && strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqWmsOrderLayoverList = new ReqWmsOrderLayoverList
            {
                LayoverSeqNo     = strLayoverSeqNo.ToInt64(),
                OrderNo          = strOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                DeliveryNo       = strDeliveryNo,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResWmsOrderLayoverList = objOrderDasServices.GetWmsOrderLayoverList(lo_objReqWmsOrderLayoverList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResWmsOrderLayoverList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 증빙 조회
    /// </summary>
    protected void GetWmsOrderReceiptList()
    {
        ReqDispatchOrderFileList                  lo_objReqDispatchOrderFileList   = null;
        ServiceResult<ResDispatchOrderFileList>   lo_objResDispatchOrderFileList   = null;
        ReqWmsOrderLayoverFileList                lo_objReqWmsOrderLayoverFileList = null;
        ServiceResult<ResWmsOrderLayoverFileList> lo_objResWmsOrderLayoverFileList = null;
        ServiceResult<ResWmsOrderReceiptList>     lo_objResWmsOrderReceiptList     = new ServiceResult<ResWmsOrderReceiptList>();

        try
        {
            if (string.IsNullOrWhiteSpace(strReceiptType) || strReceiptType.Equals("0"))
            {
                objResMap.RetCode = 9301;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
            {
                objResMap.RetCode = 9302;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strOrderNo) || strOrderNo.Equals("0"))
            {
                objResMap.RetCode = 9303;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            lo_objResWmsOrderReceiptList.data = new ResWmsOrderReceiptList
            {
                DispatchFileList      = new List<OrderDispatchFileGridModel>(),
                DispatchFileRecordCnt = 0,
                LayoverFileList       = new List<WmsOrderLayoverFileGridModel>(),
                LayoverFileRecordCnt  = 0
            };

            if (strReceiptType.Equals("1") || strReceiptType.Equals("3"))
            {
                lo_objReqDispatchOrderFileList = new ReqDispatchOrderFileList
                {
                    FileSeqNo        = strFileSeqNo.ToInt64(),
                    OrderNo          = strOrderNo.ToInt64(),
                    DispatchSeqNo    = strDispatchSeqNo.ToInt64(),
                    CenterCode       = strCenterCode.ToInt(),
                    FileType         = strFileType.ToInt(),
                    FileGubun        = strFileGubun.ToInt(),
                    DelFlag          = strDelFlag,
                    AccessCenterCode = objSes.AccessCenterCode,
                    PageSize         = intPageSize,
                    PageNo           = intPageNo
                };

                lo_objResDispatchOrderFileList = objOrderDispatchDasServices.GetOrderDispatchFile(lo_objReqDispatchOrderFileList);
                if (lo_objResDispatchOrderFileList.result.ErrorCode.IsFail())
                {
                    objResMap.RetCode = lo_objResDispatchOrderFileList.result.ErrorCode;
                    objResMap.ErrMsg  = lo_objResDispatchOrderFileList.result.ErrorMsg;
                    return;
                }

                lo_objResWmsOrderReceiptList.data.DispatchFileRecordCnt = lo_objResDispatchOrderFileList.data.RecordCnt;
                lo_objResWmsOrderReceiptList.data.DispatchFileList      = lo_objResDispatchOrderFileList.data.list;
            }

            if (strReceiptType.Equals("2") || strReceiptType.Equals("3"))
            {
                lo_objReqWmsOrderLayoverFileList = new ReqWmsOrderLayoverFileList
                {
                    FileSeqNo        = strFileSeqNo.ToInt64(),
                    CenterCode       = strCenterCode.ToInt(),
                    OrderNo          = strOrderNo.ToInt64(),
                    DeliveryNo       = strDeliveryNo,
                    FileType         = strFileType.ToInt(),
                    FileGubun        = strFileGubun.ToInt(),
                    DelFlag          = strDelFlag,
                    AccessCenterCode = objSes.AccessCenterCode,
                    PageSize         = intPageSize,
                    PageNo           = intPageNo
                };

                lo_objResWmsOrderLayoverFileList = objOrderDasServices.GetWmsOrderLayoverFileList(lo_objReqWmsOrderLayoverFileList);
                if (lo_objResWmsOrderLayoverFileList.result.ErrorCode.IsFail())
                {
                    objResMap.RetCode = lo_objResWmsOrderLayoverFileList.result.ErrorCode;
                    objResMap.ErrMsg  = lo_objResWmsOrderLayoverFileList.result.ErrorMsg;
                    return;
                }

                lo_objResWmsOrderReceiptList.data.LayoverFileRecordCnt = lo_objResWmsOrderLayoverFileList.data.RecordCnt;
                lo_objResWmsOrderReceiptList.data.LayoverFileList      = lo_objResWmsOrderLayoverFileList.data.list;
            }

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResWmsOrderReceiptList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 파일 다운로드
    /// </summary>
    protected void SetWmsOrderReceiptFileDownload()
    {

        int    lo_intRetVal = 0;
        string lo_strErrMsg = string.Empty;

        if (string.IsNullOrWhiteSpace(strFileUrl))
        {
            objResMap.RetCode = 9301;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strFileName))
        {
            objResMap.RetCode = 9302;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_intRetVal = SiteGlobal.DownloadWebUrlToFile(strFileUrl, strFileName, ref lo_strErrMsg);

            if(lo_intRetVal.IsFail())
            {
                objResMap.RetCode = 9303;
                objResMap.ErrMsg  = lo_strErrMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 배송지 화물 목록
    /// </summary>
    protected void GetWmsOrderLayoverGoodsList()
    {
        ReqWmsOrderLayoverGoodsList                lo_objReqWmsOrderLayoverGoodsList = null;
        ServiceResult<ResWmsOrderLayoverGoodsList> lo_objResWmsOrderLayoverGoodsList = null;

        intPageNo   = 1;
        intPageSize = 10000;

        if (string.IsNullOrWhiteSpace(strCenterCode) && strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strOrderNo) && strOrderNo.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqWmsOrderLayoverGoodsList = new ReqWmsOrderLayoverGoodsList
            {
                OrderNo          = strOrderNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                DeliveryNo       = strDeliveryNo,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResWmsOrderLayoverGoodsList = objOrderDasServices.GetWmsOrderLayoverGoodsList(lo_objReqWmsOrderLayoverGoodsList);
            objResMap.strResponse             = "[" + JsonConvert.SerializeObject(lo_objResWmsOrderLayoverGoodsList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화물 상태 수정
    /// </summary>
    protected void SetWmsOrderLayoverGoodsStatusUpd()
    {
        ReqOrderLayoverGoodsStatusUpd lo_objReqOrderLayoverGoodsStatusUpd = null;
        ServiceResult<bool>           lo_objResOrderLayoverGoodsStatusUpd = null;
            
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
            
        if (string.IsNullOrWhiteSpace(strGoodsSeqNo) || strGoodsSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        if (string.IsNullOrWhiteSpace(strStatusType) || strStatusType.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
            
        if (string.IsNullOrWhiteSpace(strStatusValue) || strStatusValue.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
                
            lo_objReqOrderLayoverGoodsStatusUpd = new ReqOrderLayoverGoodsStatusUpd
            {
                GoodsSeqNo  = strGoodsSeqNo.ToInt64(),
                OrderNo     = strOrderNo.ToInt64(),
                CenterCode  = strCenterCode.ToInt(),
                StatusType  = strStatusType.ToInt(),
                StatusValue = strStatusValue.ToInt(),
                AdminID     = objSes.AdminID
            };

            lo_objResOrderLayoverGoodsStatusUpd = objOrderDasServices.SetOrderLayoverGoodsStatusUpd(lo_objReqOrderLayoverGoodsStatusUpd);
            objResMap.RetCode                   = lo_objResOrderLayoverGoodsStatusUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderLayoverGoodsStatusUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /*******************************************************/
    /// <summary>
    /// 회원사별 항목 조회
    /// </summary>
    protected void GetWmsCodeList()
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
                    ItemName     = dr.Field<string>("ItemName")
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 등록
    /// </summary>
    protected void SetConsignorIns()
    {
        ConsignorModel                lo_objConsignorModel  = null;
        ServiceResult<ConsignorModel> lo_objResConsignorIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0") || string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objConsignorModel = new ConsignorModel
            {
                CenterCode    = strCenterCode.ToInt(),
                ConsignorName = strConsignorName,
                ConsignorNote = strConsignorNote,
                RegAdminID    = objSes.AdminID
            };

            lo_objResConsignorIns = objConsignorDasServices.SetConsignorIns(lo_objConsignorModel);
            objResMap.RetCode     = lo_objResConsignorIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResConsignorIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("ConsignorCode", lo_objResConsignorIns.data.ConsignorCode);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 화주 목록 검색
    /// </summary>
    protected void GetConsignorMapList()
    {
        ReqConsignorMapSearchList                lo_objReqConsignorMapSearchList = null;
        ServiceResult<ResConsignorMapSearchList> lo_objResConsignorMapSearchList = null;

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
            lo_objReqConsignorMapSearchList = new ReqConsignorMapSearchList
            {
                CenterCode       = strCenterCode.ToInt(),
                ConsignorName    = strConsignorName,
                UseFlag          = "Y",
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };

            lo_objResConsignorMapSearchList = objConsignorDasServices.GetConsignorMapSearchList(lo_objReqConsignorMapSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResConsignorMapSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 상하차지 특이사항 조회
    /// </summary>
    protected void GetPlaceNote()
    {
        ReqClientPlaceNote                lo_objReqClientPlaceNote = null;
        ServiceResult<ResClientPlaceNote> lo_objResClientPlaceNote = null;

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
            lo_objReqClientPlaceNote = new ReqClientPlaceNote
            {
                CenterCode = strCenterCode.ToInt(),
                PlaceName  = strPlaceName,
                AdminID    = objSes.AdminID
            };

            lo_objResClientPlaceNote = objClientPlaceChargeDasServices.GetClientPlaceNote(lo_objReqClientPlaceNote);
            objResMap.strResponse    = "[" + JsonConvert.SerializeObject(lo_objResClientPlaceNote) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
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
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo
            };
                
            lo_objResCarDispatchRefSearchList = objCarDispatchDasServices.GetCarDispatchRefSearchList(lo_objReqCarDispatchRefSearchList);
            objResMap.strResponse             = "[" + JsonConvert.SerializeObject(lo_objResCarDispatchRefSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 오더 상세정보
    /// </summary>
    protected void GetWmsList()
    {
        ReqOrderList                lo_objReqOrderList = null;
        ServiceResult<ResOrderList> lo_objResOrderList = null;
        int                         lo_intListType     = 4;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        strOrderClientName = string.Empty;
        strPayClientName   = string.Empty;
        strConsignorName   = string.Empty;
        strPickupPlace     = string.Empty;
        strGetPlace        = string.Empty;

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
                TransCenterCode         = strTransCenterCode.ToInt(),
                ContractCenterCode      = strContractCenterCode.ToInt(),
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

            lo_objResOrderList    = objOrderDasServices.GetOrderList(lo_objReqOrderList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 오더 수정
    /// </summary>
    protected void SetWmsUpd()
    {
        OrderModel                 lo_objOrderModel  = null;
        ServiceResult<ResOrderUpd> lo_objResOrderUpd = null;

        strOrderItemCode     = Utils.IsNull(strOrderItemCode,     "OA010");
        strReqSeqNo          = Utils.IsNull(strReqSeqNo,          "0");
        strNoLayerFlag       = Utils.IsNull(strNoLayerFlag,       "N");
        strNoTopFlag         = Utils.IsNull(strNoTopFlag,         "N");
        strArrivalReportFlag = Utils.IsNull(strArrivalReportFlag, "N");
        strCustomFlag        = Utils.IsNull(strCustomFlag,        "N");
        strBondedFlag        = Utils.IsNull(strBondedFlag,        "N");
        strDocumentFlag      = Utils.IsNull(strDocumentFlag,      "N");
        strLicenseFlag       = Utils.IsNull(strLicenseFlag,       "N");
        strInTimeFlag        = Utils.IsNull(strInTimeFlag,        "N");
        strControlFlag       = Utils.IsNull(strControlFlag,       "N");
        strQuickGetFlag      = Utils.IsNull(strQuickGetFlag,      "N");
        strOrderFPISFlag     = Utils.IsNull(strOrderFPISFlag,     "Y");

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

        if (string.IsNullOrWhiteSpace(strGoodsDispatchType) || (!strGoodsDispatchType.Equals("2") && !strGoodsDispatchType.Equals("3")))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strGoodsDispatchType.Equals("3") && string.IsNullOrWhiteSpace(strOrderLocationCode))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0") || string.IsNullOrWhiteSpace(strConsignorName))
        {
            objResMap.RetCode = 9005;
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

        if (string.IsNullOrWhiteSpace(strPickupYMD) || string.IsNullOrWhiteSpace(strPickupPlace))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (!strGoodsDispatchType.Equals("3"))
        {
            strOrderLocationCode = string.Empty;
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
                GoodsRunType              = strGoodsRunType.ToInt(),
                CarFixedFlag              = strCarFixedFlag, // 2023-03-16 by shadow54 : 자동운임 수정 건
                LayoverFlag               = strLayoverFlag,
                SamePlaceCount            = strSamePlaceCount.ToInt(),
                NonSamePlaceCount         = strNonSamePlaceCount.ToInt(),
                GoodsName                 = strGoodsName,
                GoodsNote                 = strGoodsNote,
                NoteClient                = strNoteClient,
                NoteInside                = strNoteInside,
                TaxClientName             = strTaxClientName,
                TaxClientCorpNo           = strTaxClientCorpNo,
                TaxClientChargeName       = strTaxClientChargeName,
                TaxClientChargeTelNo      = strTaxClientChargeTelNo,
                TaxClientChargeEmail      = strTaxClientChargeEmail,
                QuickType                 = strQuickType.ToInt(),
                RefSeqNo                  = strRefSeqNo.ToInt64(),
                InsureExceptKind          = strInsureExceptKind.ToInt(),
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 오더 단건 취소
    /// </summary>
    protected void SetWmsOneCnl()
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
                CnlAdminName = objSes.AdminName,
                ChgSeqNo     = strChgSeqNo.ToInt64()
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 비용 목록
    /// </summary>
    protected void GetWmsPayList()
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
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    ///  비용 등록
    /// </summary>
    protected void SetWmsPayIns()
    {
        OrderPayModel                lo_objOrderPayModel  = null;
        ServiceResult<OrderPayModel> lo_objResOrderPayIns = null;

        strGoodsSeqNo    = Utils.IsNull(strGoodsSeqNo,    "0");
        strDispatchSeqNo = Utils.IsNull(strDispatchSeqNo, "0");
        strPayType       = Utils.IsNull(strPayType,       "0");
        strTaxKind       = Utils.IsNull(strTaxKind,       "0");

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

        if (strPayType.Equals("2"))
        {
            if ((string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0")) && (string.IsNullOrWhiteSpace(strDispatchSeqNo) || strDispatchSeqNo.Equals("0")))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }
        else if (strPayType.Equals("3") || strPayType.Equals("4"))
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
                DispatchSeqNo   = strDispatchSeqNo.ToInt64(),
                PayType         = strPayType.ToInt(),
                TaxKind         = strTaxKind.ToInt(),
                ItemCode        = strItemCode,
                ClientCode      = strClientCode.ToInt64(),
                ClientName      = strClientName,
                SupplyAmt       = strSupplyAmt.ToDouble(),
                TaxAmt          = strTaxAmt.ToDouble(),
                TransDtlSeqNo   = strTransDtlSeqNo.ToInt64(), // 2023-03-16 by shadow54 : 자동운임 수정 건
                ApplySeqNo      = strApplySeqNo.ToInt64(),
                TransRateStatus = strTransRateStatus.ToInt(),
                RegAdminID      = objSes.AdminID,
                RegAdminName    = objSes.AdminName
            };
                
            lo_objResOrderPayIns = objOrderDasServices.SetOrderPayIns(lo_objOrderPayModel);
            objResMap.RetCode    = lo_objResOrderPayIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderPayIns.result.ErrorMsg;
                return;
            }
            
            objResMap.Add("SeqNo", lo_objResOrderPayIns.data.SeqNo.ToString());
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    ///  비용 수정
    /// </summary>
    protected void SetWmsPayUpd()
    {
        OrderPayModel       lo_objOrderPayModel  = null;
        ServiceResult<bool> lo_objResOrderPayUpd = null;

        strGoodsSeqNo    = Utils.IsNull(strGoodsSeqNo,    "0");
        strDispatchSeqNo = Utils.IsNull(strDispatchSeqNo, "0");
        strPayType       = Utils.IsNull(strPayType,       "0");
        strTaxKind       = Utils.IsNull(strTaxKind,       "0");

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

        if (strPayType.Equals("2"))
        {
            if ((string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0")) && (string.IsNullOrWhiteSpace(strDispatchSeqNo) || strDispatchSeqNo.Equals("0")))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }
        else if (strPayType.Equals("3") || strPayType.Equals("4"))
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
                DispatchSeqNo   = strDispatchSeqNo.ToInt64(),
                PayType         = strPayType.ToInt(),
                TaxKind         = strTaxKind.ToInt(),
                ItemCode        = strItemCode,
                ClientCode      = strClientCode.ToInt64(),
                ClientName      = strClientName,
                SupplyAmt       = strSupplyAmt.ToDouble(),
                TaxAmt          = strTaxAmt.ToDouble(),
                TransDtlSeqNo   = strTransDtlSeqNo.ToInt64(), // 2023-03-16 by shadow54 : 자동운임 수정 건
                ApplySeqNo      = strApplySeqNo.ToInt64(),
                TransRateStatus = strTransRateStatus.ToInt(),
                UpdAdminID      = objSes.AdminID,
                UpdAdminName    = objSes.AdminName
            };
                
            lo_objResOrderPayUpd = objOrderDasServices.SetOrderPayUpd(lo_objOrderPayModel);
            objResMap.RetCode    = lo_objResOrderPayUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderPayUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    ///  비용 삭제
    /// </summary>
    protected void SetWmsPayDel()
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }


    /// <summary>
    ///  배차 목록
    /// </summary>
    protected void GetWmsDispatchCarList()
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

            SiteGlobal.WriteLog("WmsHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    #endregion

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