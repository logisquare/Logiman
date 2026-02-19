<%@ WebHandler Language="C#" Class="DomesticHandler" %>
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
using System.Linq;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : DomesticHandler.ashx
/// Description     : 내수 오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : sybyun96@logislab.com, 2022-08-03
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class DomesticHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Domestic/DomesticList"; //필수

    // 메소드 리스트
    private const string MethodDomesticCount                = "DomesticCount";                   //오더 현황 카운트
    private const string MethodDomesticList                 = "DomesticList";                    //오더 목록
    private const string MethodDomesticListExcel            = "DomesticListExcel";               //오더 엑셀
    private const string MethodDomesticIns                  = "DomesticInsert";                  //오더 등록
    private const string MethodDomesticUpd                  = "DomesticUpdate";                  //오더 수정
    private const string MethodDomesticCnl                  = "DomesticCancel";                  //오더 취소
    private const string MethodDomesticOneCnl               = "DomesticOneCancel";               //오더 단건 취소
    private const string MethodDomesticPayList              = "DomesticPayList";                 //비용 목록
    private const string MethodDomesticPayIns               = "DomesticPayInsert";               //비용 등록
    private const string MethodDomesticPayUpd               = "DomesticPayUpdate";               //비용 수정
    private const string MethodDomesticPayDel               = "DomesticPayDelete";               //비용 삭제
    private const string MethodDomesticDispatchCarList      = "DomesticDispatchCarList";         //배차차량 목록
    private const string MethodDomesticDispatchCarStatusUpd = "DomesticDispatchCarStatusUpdate"; //배차차량 상태 변경
    private const string MethodDomesticLocationUpd          = "DomesticLocationUpdate";          //사업장 변경
    private const string MethodDomesticCodeList             = "DomesticCodeList";                //회원사별 코드 조회
    private const string MethodClientList                   = "ClientList";                      //고객사(발주/청구처) 조회
    private const string MethodClientChargeList             = "ClientChargeList";                //고객사 담당자 조회
    private const string MethodConsignorIns                 = "ConsignorInsert";                 //화주등록
    private const string MethodConsignorMapList             = "ConsignorMapList";                //화주 조회
    private const string MethodPlaceList                    = "PlaceList";                       //상하차지 조회
    private const string MethodPlaceChargeList              = "PlaceChargeList";                 //상하차지 담당자 조회
    private const string MethodPlaceNote                    = "PlaceNote";                       //상하차지 특이사항 조회
    private const string MethodCarDispatchRefList           = "CarDispatchRefList";              //배차차량 조회
    private const string MethodTransRateOrderList           = "TransRateOrderList";              //요율표 조회(적용후)
    private const string MethodTransRateOrderApplyList      = "TransRateOrderApplyList";         //요율표 조회
    private const string MethodHeadCenterList               = "HeadCenterList";                  //본부 목록 조회
    private const string MethodContractCenterList           = "ContractCenterList";              //본부+계열사+협력사 목록 조회
    private const string MethodDomesticTransIns             = "DomesticTransInsert";             //이관 등록
    private const string MethodDomesticContractIns          = "DomesticContractInsert";          //위탁 등록
    private const string MethodOrderRequestChgUpd           = "OrderRequestChgUpd";              //수정 요청사항 취소 처리
    private const string MethodOrderRequestChgList          = "OrderRequestChgList";             //수정 요청사항 조회
    private const string MethodClientSaleLimit              = "ClientSaleLimit";                 //매출 한도 정보 조회
    private const string MethodOrderTransSaleUpd            = "OrderTransSaleUpdate";            //이관 매출 수정
    private const string MethodOrderDispatchContractCnl     = "OrderDispatchContractCancel";     //직송 위탁 취소
    private const string MethodDomesticTransPayList         = "DomesticTransPayList";            //이관 매출 목록
    private const string MethodCarManageList                = "CarManageList";                   //카고패스 - 관리 및 연계차량 조회
    private const string MethodCarManageIns                 = "CarManageIns";                    //카고패스 - 차량등록
    private const string MethodCarManageDispatchIns         = "CarManageDispatchIns";            //카고패스 - 배차 기록 등록
    private const string MethodAmtRequestOrderList          = "AmtRequestOrderList";             //요청 목록
    private const string MethodAmtRequestIns                = "AmtRequestInsert";                //요청 등록
    private const string MethodAmtRequestCnl                = "AmtRequestCancel";                //요청 삭제
    private const string MethodOrderMisuList                = "OrderMisuList";                   //미수 목록

    OrderDasServices             objOrderDasServices             = new OrderDasServices();
    ClientDasServices            objClientDasServices            = new ClientDasServices();
    ClientPlaceChargeDasServices objClientPlaceChargeDasServices = new ClientPlaceChargeDasServices();
    ConsignorDasServices         objConsignorDasServices         = new ConsignorDasServices();
    CarDispatchDasServices       objCarDispatchDasServices       = new CarDispatchDasServices();
    CenterDasServices            objCenterDasServices            = new CenterDasServices();
    WebOrderDasServices          objWebOrderDasServices          = new WebOrderDasServices();
    ClientSaleLimitDasServices   objClientSaleLimitDasServices   = new ClientSaleLimitDasServices();
    OrderDispatchDasServices     objOrderDispatchDasServices     = new OrderDispatchDasServices();
    CarManageDasServices         objCarManageDasServices         = new CarManageDasServices();
    DepositDasServices           objDepositDasServices           = new DepositDasServices();

    private HttpContext          objHttpContext                  = null;

    private string strCallType                  = string.Empty;
    private int    intPageSize                  = 0;
    private int    intPageNo                    = 0;
    private string strCenterCode                = string.Empty;
    private string strDateType                  = string.Empty;
    private string strDateFrom                  = string.Empty;
    private string strDateTo                    = string.Empty;
    private string strOrderLocationCodes        = string.Empty;
    private string strOrderItemCodes            = string.Empty;
    private string strOrderStatuses             = string.Empty;
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
    private string strConsignorNote             = string.Empty;
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
    private string strPlaceChargeName           = string.Empty;
    private string strComName                   = string.Empty;
    private string strComCorpNo                 = string.Empty;
    private string strCarNo                     = string.Empty;
    private string strDriverName                = string.Empty;
    private string strReqSeqNo                  = string.Empty;
    private string strSupplyAmt                 = string.Empty;
    private string strTaxAmt                    = string.Empty;
    private string strSeqNo                     = string.Empty;
    private string strGoodsSeqNo                = string.Empty;
    private string strDispatchSeqNo             = string.Empty;
    private string strPayType                   = string.Empty;
    private string strTaxKind                   = string.Empty;
    private string strItemCode                  = string.Empty;
    private string strRefSeqNo                  = string.Empty;
    private string strOrderNos                  = string.Empty;
    private string strCnlReason                 = string.Empty;
    private string strPickupDT                  = string.Empty;
    private string strArrivalDT                 = string.Empty;
    private string strGetDT                     = string.Empty;
    private string strQuickType                 = string.Empty;
    private string strTransDtlSeqNo             = string.Empty; // 2023-03-16 by shadow54 : 자동운임 수정 건
    private string strApplySeqNo                = string.Empty;
    private string strTransRateStatus           = string.Empty;
    private string strTransCenterCode           = string.Empty;
    private string strContractCenterCode        = string.Empty;
    private string strTargetCenterCode          = string.Empty;
    private string strDispatchType              = string.Empty;
    private string strSaleOrgAmt                = string.Empty;
    private string strChgSeqNo                  = string.Empty;
    private string strChgReqContent             = string.Empty;
    private string strChgMessage                = string.Empty;
    private string strChgStatus                 = string.Empty;
    private string strListType                  = string.Empty;
    private string strSaleSeqNos                = string.Empty;
    private string strProcTypes                 = string.Empty;
    private string strTaxKinds                  = string.Empty;
    private string strItemCodes                 = string.Empty;
    private string strSupplyAmts                = string.Empty;
    private string strTaxAmts                   = string.Empty;
    private string strSortType                  = string.Empty;
    private string strComCode                   = string.Empty;
    private string strCarSeqNo                  = string.Empty;
    private string strDriverSeqNo               = string.Empty;
    private string strDriverCell                = string.Empty;
    private string strAreaDistance              = string.Empty;
    private string strCarDispatchType           = string.Empty;
    private string strOrgCenterCode             = string.Empty;
    private string strOrgOrderNo                = string.Empty;
    private string strInsureExceptKind          = string.Empty;
    private string strReqStatus                 = string.Empty; 
    private string strReqKind                   = string.Empty;  
    private string strPaySeqNo                  = string.Empty;
    private string strReqReason                 = string.Empty;
    private string strReqSupplyAmt              = string.Empty;
    private string strReqTaxAmt                 = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodDomesticCount,                MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDomesticList,                 MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDomesticListExcel,            MenuAuthType.All);
        objMethodAuthList.Add(MethodDomesticIns,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticUpd,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticCnl,                  MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticOneCnl,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticPayList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDomesticPayIns,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticPayUpd,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticPayDel,               MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticDispatchCarList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDomesticDispatchCarStatusUpd, MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticLocationUpd,          MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticCodeList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,                   MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientChargeList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorIns,                 MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodConsignorMapList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceList,                    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceChargeList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceNote,                    MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarDispatchRefList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateOrderList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodTransRateOrderApplyList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodHeadCenterList,               MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodContractCenterList,           MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDomesticTransIns,             MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticContractIns,          MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderRequestChgUpd,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderRequestChgList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientSaleLimit,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderTransSaleUpd,            MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderDispatchContractCnl,     MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodDomesticTransPayList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarManageList,                MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarManageIns,                 MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodCarManageDispatchIns,         MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAmtRequestOrderList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodAmtRequestIns,                MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodAmtRequestCnl,                MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodOrderMisuList,                MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("DomesticHandler");
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
            strDateFrom                  = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                    = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes        = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes            = SiteGlobal.GetRequestForm("OrderItemCodes");
            strOrderStatuses             = SiteGlobal.GetRequestForm("OrderStatuses");
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
            strOrderClientCode           = Utils.IsNull(SiteGlobal.GetRequestForm("OrderClientCode"), "0");
            strOrderClientName           = SiteGlobal.GetRequestForm("OrderClientName");
            strOrderClientChargeName     = SiteGlobal.GetRequestForm("OrderClientChargeName");
            strOrderClientChargePosition = SiteGlobal.GetRequestForm("OrderClientChargePosition");
            strOrderClientChargeTelExtNo = SiteGlobal.GetRequestForm("OrderClientChargeTelExtNo");
            strOrderClientChargeTelNo    = SiteGlobal.GetRequestForm("OrderClientChargeTelNo");
            strOrderClientChargeCell     = SiteGlobal.GetRequestForm("OrderClientChargeCell");
            strPayClientCode             = Utils.IsNull(SiteGlobal.GetRequestForm("PayClientCode"), "0");
            strPayClientName             = SiteGlobal.GetRequestForm("PayClientName");
            strPayClientChargeName       = SiteGlobal.GetRequestForm("PayClientChargeName");
            strPayClientChargePosition   = SiteGlobal.GetRequestForm("PayClientChargePosition");
            strPayClientChargeTelExtNo   = SiteGlobal.GetRequestForm("PayClientChargeTelExtNo");
            strPayClientChargeTelNo      = SiteGlobal.GetRequestForm("PayClientChargeTelNo");
            strPayClientChargeCell       = SiteGlobal.GetRequestForm("PayClientChargeCell");
            strPayClientChargeLocation   = SiteGlobal.GetRequestForm("PayClientChargeLocation");
            strConsignorCode             = Utils.IsNull(SiteGlobal.GetRequestForm("ConsignorCode"), "0");
            strConsignorName             = SiteGlobal.GetRequestForm("ConsignorName");
            strConsignorNote             = SiteGlobal.GetRequestForm("ConsignorNote");
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
            strVolume                    = Utils.IsNull(SiteGlobal.GetRequestForm("Volume"), "0");
            strCBM                       = Utils.IsNull(SiteGlobal.GetRequestForm("CBM"),    "0");
            strWeight                    = Utils.IsNull(SiteGlobal.GetRequestForm("Weight"), "0");
            strLength                    = Utils.IsNull(SiteGlobal.GetRequestForm("Length"), "0");
            strQuantity                  = SiteGlobal.GetRequestForm("Quantity");
            strGoodsDispatchType         = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsDispatchType"), "0");
            strGoodsName                 = SiteGlobal.GetRequestForm("GoodsName");
            strGoodsNote                 = SiteGlobal.GetRequestForm("GoodsNote", false);
            strGoodsRunType              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsRunType"),      "1"); // 2023-03-16 by shadow54 : 자동운임 수정 건
            strCarFixedFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("CarFixedFlag"),      "Y");
            strLayoverFlag               = Utils.IsNull(SiteGlobal.GetRequestForm("LayoverFlag"),       "N");
            strSamePlaceCount            = Utils.IsNull(SiteGlobal.GetRequestForm("SamePlaceCount"),    "0");
            strNonSamePlaceCount         = Utils.IsNull(SiteGlobal.GetRequestForm("NonSamePlaceCount"), "0");
            strGoodsItemCode             = SiteGlobal.GetRequestForm("GoodsItemCode");
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
            strPlaceChargeName           = SiteGlobal.GetRequestForm("PlaceChargeName");
            strComName                   = SiteGlobal.GetRequestForm("ComName");
            strComCorpNo                 = SiteGlobal.GetRequestForm("ComCorpNo");
            strCarNo                     = SiteGlobal.GetRequestForm("CarNo");
            strDriverName                = SiteGlobal.GetRequestForm("DriverName");
            strReqSeqNo                  = SiteGlobal.GetRequestForm("ReqSeqNo");
            strSupplyAmt                 = Utils.IsNull(SiteGlobal.GetRequestForm("SupplyAmt"),     "0");
            strTaxAmt                    = Utils.IsNull(SiteGlobal.GetRequestForm("TaxAmt"),        "0");
            strSeqNo                     = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),         "0");
            strGoodsSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"),    "0");
            strDispatchSeqNo             = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strPayType                   = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"),       "0");
            strTaxKind                   = Utils.IsNull(SiteGlobal.GetRequestForm("TaxKind"),       "0");
            strItemCode                  = SiteGlobal.GetRequestForm("ItemCode");
            strRefSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"), "0");
            strChgSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("ChgSeqNo"), "0");
            strOrderNos                  = SiteGlobal.GetRequestForm("OrderNos");
            strCnlReason                 = SiteGlobal.GetRequestForm("CnlReason");
            strPickupDT                  = SiteGlobal.GetRequestForm("PickupDT");
            strArrivalDT                 = SiteGlobal.GetRequestForm("ArrivalDT");
            strGetDT                     = SiteGlobal.GetRequestForm("GetDT");
            strQuickType                 = Utils.IsNull(SiteGlobal.GetRequestForm("QuickType"),          "1");
            strTransDtlSeqNo             = Utils.IsNull(SiteGlobal.GetRequestForm("TransDtlSeqNo"),      "0"); // 2023-03-16 by shadow54 : 자동운임 수정 건
            strApplySeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("ApplySeqNo"),         "0");
            strTransRateStatus           = Utils.IsNull(SiteGlobal.GetRequestForm("TransRateStatus"),    "1");
            strTransCenterCode           = Utils.IsNull(SiteGlobal.GetRequestForm("TransCenterCode"),    "0");
            strContractCenterCode        = Utils.IsNull(SiteGlobal.GetRequestForm("ContractCenterCode"), "0");
            strTargetCenterCode          = Utils.IsNull(SiteGlobal.GetRequestForm("TargetCenterCode"),   "0");
            strDispatchType              = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchType"),       "0");
            strSaleOrgAmt                = Utils.IsNull(SiteGlobal.GetRequestForm("SaleOrgAmt"),         "0");
            strAcceptAdminName           = SiteGlobal.GetRequestForm("AcceptAdminName");
            strChgReqContent             = Utils.IsNull(SiteGlobal.GetRequestForm("ChgReqContent"), "");
            strChgMessage                = Utils.IsNull(SiteGlobal.GetRequestForm("ChgMessage"),    "");
            strChgStatus                 = Utils.IsNull(SiteGlobal.GetRequestForm("ChgStatus"),     "0");
            strListType                  = Utils.IsNull(SiteGlobal.GetRequestForm("ListType"),      "0");
            strSaleSeqNos                = SiteGlobal.GetRequestForm("SaleSeqNos");
            strProcTypes                 = SiteGlobal.GetRequestForm("ProcTypes");
            strTaxKinds                  = SiteGlobal.GetRequestForm("TaxKinds");
            strItemCodes                 = SiteGlobal.GetRequestForm("ItemCodes");
            strSupplyAmts                = SiteGlobal.GetRequestForm("SupplyAmts");
            strTaxAmts                   = SiteGlobal.GetRequestForm("TaxAmts");
            strSortType                  = Utils.IsNull(SiteGlobal.GetRequestForm("SortType"),    "1");
            strComCode                   = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"),     "0");
            strCarSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("CarSeqNo"),    "0");
            strDriverSeqNo               = Utils.IsNull(SiteGlobal.GetRequestForm("DriverSeqNo"), "0");
            strDriverCell                = SiteGlobal.GetRequestForm("DriverCell");
            strAreaDistance              = Utils.IsNull(SiteGlobal.GetRequestForm("AreaDistance"),     "0");
            strCarDispatchType           = Utils.IsNull(SiteGlobal.GetRequestForm("CarDispatchType"),  "0");
            strOrgCenterCode             = Utils.IsNull(SiteGlobal.GetRequestForm("OrgCenterCode"),    "0");
            strOrgOrderNo                = Utils.IsNull(SiteGlobal.GetRequestForm("OrgOrderNo"),       "0");
            strInsureExceptKind          = Utils.IsNull(SiteGlobal.GetRequestForm("InsureExceptKind"), "1");
            strReqStatus                 = Utils.IsNull(SiteGlobal.GetRequestForm("ReqStatus"),        "0");
            strReqKind                   = Utils.IsNull(SiteGlobal.GetRequestForm("ReqKind"),          "0");
            strPaySeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("PaySeqNo"),         "0");
            strReqSupplyAmt              = Utils.IsNull(SiteGlobal.GetRequestForm("ReqSupplyAmt"),     "0");
            strReqTaxAmt                 = Utils.IsNull(SiteGlobal.GetRequestForm("ReqTaxAmt"),        "0");
            strReqReason                 = SiteGlobal.GetRequestForm("ReqReason");

            strDateFrom  = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo    = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");
            strPickupYMD = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
            strGetYMD    = string.IsNullOrWhiteSpace(strGetYMD) ? strGetYMD : strGetYMD.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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
                case MethodDomesticCount:
                    GetDomesticCount();
                    break;
                case MethodDomesticList:
                    GetDomesticList();
                    break;
                case MethodDomesticListExcel:
                    GetDomesticListExcel();
                    break;
                case MethodDomesticIns:
                    SetDomesticIns();
                    break;
                case MethodDomesticUpd:
                    SetDomesticUpd();
                    break;
                case MethodDomesticCnl:
                    SetDomesticCnl();
                    break;
                case MethodDomesticOneCnl:
                    SetDomesticOneCnl();
                    break;
                case MethodDomesticPayList:
                    GetDomesticPayList();
                    break;
                case MethodDomesticPayIns:
                    SetDomesticPayIns();
                    break;
                case MethodDomesticPayUpd:
                    SetDomesticPayUpd();
                    break;
                case MethodDomesticPayDel:
                    SetDomesticPayDel();
                    break;
                case MethodDomesticDispatchCarList:
                    GetDomesticDispatchCarList();
                    break;
                case MethodDomesticDispatchCarStatusUpd:
                    SetDomesticDispatchCarStatusUpd();
                    break;
                case MethodDomesticLocationUpd:
                    SetDomesticLocationUpd();
                    break;
                case MethodDomesticCodeList:
                    GetDomesticCodeList();
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
                case MethodTransRateOrderList:
                    GetTransRateOrderList();
                    break;
                case MethodTransRateOrderApplyList:
                    GetTransRateOrderApplyList();
                    break;
                case MethodHeadCenterList:
                    GetHeadCenterList();
                    break;
                case MethodContractCenterList:
                    GetContractCenterList();
                    break;
                case MethodDomesticTransIns:
                    SetDomesticTransIns();
                    break;
                case MethodDomesticContractIns:
                    SetDomesticContractIns();
                    break;
                case MethodOrderRequestChgUpd:
                    SetOrderRequestChgUpd();
                    break;
                case MethodOrderRequestChgList:
                    GetOrderRequestChgList();
                    break;
                case MethodClientSaleLimit:
                    GetClientSaleLimit();
                    break;
                case MethodOrderTransSaleUpd:
                    SetOrderTransSaleUpd();
                    break;
                case MethodOrderDispatchContractCnl:
                    SetOrderDispatchContractCnl();
                    break;
                case MethodDomesticTransPayList:
                    GetDomesticTransPayList();
                    break;
                case MethodCarManageList:
                    GetCarManageList();
                    break;
                case MethodCarManageIns:
                    SetCarManageIns();
                    break;
                case MethodCarManageDispatchIns:
                    SetCarManageDispatchIns();
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
                case MethodOrderMisuList:
                    GetOrderMisuList();
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process


    /// <summary>
    /// 내수 오더 현황 목록
    /// </summary>
    protected void GetDomesticCount()
    {
        ReqDomesticOrderCount                lo_objReqDomesticOrderCount = null;
        ServiceResult<ResDomesticOrderCount> lo_objResDomesticOrderCount = null;

        try
        {
            lo_objReqDomesticOrderCount = new ReqDomesticOrderCount
            {
                AccessCenterCode = objSes.AccessCenterCode,
                AdminID          = objSes.AdminID
            };

            lo_objResDomesticOrderCount = objOrderDasServices.GetDomesticOrderCount(lo_objReqDomesticOrderCount);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResDomesticOrderCount) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 오더 현황 목록
    /// </summary>
    protected void GetDomesticList()
    {
        ReqOrderList                lo_objReqOrderList = null;
        ServiceResult<ResOrderList> lo_objResOrderList = null;
        int                         lo_intListType     = 1;

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
                PageNo                  = intPageNo,
            };

            lo_objResOrderList = objOrderDasServices.GetOrderList(lo_objReqOrderList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 오더 현황 엑셀
    /// </summary>
    protected void GetDomesticListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqOrderList                lo_objReqOrderList        = null;
        ServiceResult<ResOrderList> lo_objResOrderList        = null;
        int                         lo_intListType            = 1;
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
                TransCenterCode         = strTransCenterCode.ToInt(),
                ContractCenterCode      = strContractCenterCode.ToInt(),
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
            lo_dtData.Columns.Add(new DataColumn("이관구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("이관정보",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("위탁구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("위탁정보",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("위탁상태",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",     typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("발주처명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(발)담당자",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(발)내선",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(발)전화번호",  typeof(string)));
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
            lo_dtData.Columns.Add(new DataColumn("상차요청시간",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차방법",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차지",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)우편번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)주소상세",  typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(상)적용주소",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)담당자명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)직급",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)내선",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)지역코드",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)지역명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(상)특이사항",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차구분",     typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("하차요청일",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차요청시간",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차방법",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차지",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)우편번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)주소",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)주소상세", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)적용주소", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)담당자명", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)직급",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(하)내선",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)전화번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)휴대폰번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)지역코드",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)지역명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(하)특이사항",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청톤급",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("요청차종",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("품목",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총중량",      typeof(double)));

            lo_dtData.Columns.Add(new DataColumn("총수량",  typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("총부피",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("총길이",  typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("화물명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화물비고", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("독차여부", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("운행구분", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고정여부", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("경유여부", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("동일지역수",  typeof(int)));

            lo_dtData.Columns.Add(new DataColumn("타지역수",        typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("비고",          typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("고객전달사항",      typeof(string)));
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
            lo_dtData.Columns.Add(new DataColumn("(집하)차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량톤수",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(집하)상차시간",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(집하)하차시간",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(간선)기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)차량업체명",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("(배송)차량사업자번호",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)기사명",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(배송)기사휴대폰",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("자동운임",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("매출마감전표",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("매출",            typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("매입마감전표",        typeof(string)));
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

                lo_dtData.Rows.Add(row.CenterName,row.OrderStatusM,row.OrderNo,row.TransTypeM,row.TransInfo
                    ,row.ContractTypeM,row.ContractInfo,row.ContractStatusMView,row.OrderItemCodeM,row.OrderLocationCodeM
                    ,row.OrderClientName,row.OrderClientChargeName,row.OrderClientChargeTelExtNo,row.OrderClientChargeTelNo,row.OrderClientChargeCell
                    ,row.PayClientTypeM,row.PayClientName,row.PayClientChargeName,row.PayClientChargeTelExtNo,row.PayClientChargeTelNo
                    ,row.PayClientChargeCell,row.PayClientChargeLocation,row.ConsignorName,lo_strPickupYMD,row.PickupHM
                    ,row.PickupWay,row.PickupPlace,row.PickupPlacePost,row.PickupPlaceAddr,row.PickupPlaceAddrDtl
                    ,row.PickupPlaceFullAddr,row.PickupPlaceChargeName,row.PickupPlaceChargePosition,row.PickupPlaceChargeTelExtNo,row.PickupPlaceChargeTelNo
                    ,row.PickupPlaceChargeCell,row.PickupPlaceLocalCode,row.PickupPlaceLocalName,row.PickupPlaceNote,row.OrderGetTypeM
                    ,lo_strGetYMD,row.GetHM,row.GetWay,row.GetPlace,row.GetPlacePost
                    ,row.GetPlaceAddr,row.GetPlaceAddrDtl,row.GetPlaceFullAddr,row.GetPlaceChargeName,row.GetPlaceChargePosition
                    ,row.GetPlaceChargeTelExtNo,row.GetPlaceChargeTelNo,row.GetPlaceChargeCell,row.GetPlaceLocalCode,row.GetPlaceLocalName
                    ,row.GetPlaceNote,row.CarTonCodeM,row.CarTypeCodeM,row.GoodsItemCodeM,row.Weight
                    ,row.Volume,row.CBM,row.Length,row.GoodsName,row.GoodsNote
                    ,row.FTLFlag,row.GoodsRunTypeM,row.CarFixedFlag,row.LayoverFlag,row.SamePlaceCount
                    ,row.NonSamePlaceCount,row.NoteInside,row.NoteClient,row.GoodsDispatchTypeM,row.PickupDispatchCarNo
                    ,row.PickupCarTonCodeM,row.PickupCarDivTypeM,row.PickupComName,row.PickupComCorpNo,row.PickupDriverName
                    ,row.PickupDriverCell,row.PickupPickupDT,row.PickupGetDT,row.DispatchCarNo1,row.CarTonCodeM1
                    ,row.CarDivTypeM1,row.ComName1,row.ComCorpNo1,row.DriverName1,row.DriverCell1
                    ,row.PickupDT1,row.GetDT1,row.DispatchCarNo2,row.CarTonCodeM2,row.CarDivTypeM2
                    ,row.ComName2,row.ComCorpNo2,row.DriverName2,row.DriverCell2,row.PickupDT2
                    ,row.GetDT2,row.DispatchCarNo3,row.CarDivTypeM3,row.ComName3,row.ComCorpNo3
                    ,row.DriverName3,row.DriverCell3,row.DispatchCarNo4,row.CarDivTypeM4,row.ComName4
                    ,row.ComCorpNo4,row.DriverName4,row.DriverCell4,row.TransRateInfo,row.SaleClosingSeqNo
                    ,row.SaleSupplyAmt,row.PurchaseClosingSeqNo,row.PurchaseSupplyAmt,lo_intRevenue,lo_intRevenuePer
                    ,row.AdvanceSupplyAmt3,row.AdvanceSupplyAmt4,row.QuickPaySupplyFee,row.QuickPayTaxFee,row.AcceptDate
                    ,row.AcceptAdminName,row.UpdDate,row.UpdAdminName);
            }

            lo_objExcel = new SpreadSheet {SheetName = "DomesticList"};

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

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
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
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 오더 등록
    /// </summary>
    protected void SetDomesticIns()
    {
        OrderModel                lo_objOrderModel   = null;
        ServiceResult<OrderModel> lo_objResOrderIns  = null;
        int                       lo_intOrderStatus  = 2;
        int                       lo_intOrderRegType = 1;

        strOrderItemCode     = Utils.IsNull(strOrderItemCode,     "OA007");
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

        if (string.IsNullOrWhiteSpace(strGetYMD) || string.IsNullOrWhiteSpace(strGetPlace))
        {
            objResMap.RetCode = 9007;
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
                GoodsRunType              = strGoodsRunType.ToInt(),
                CarFixedFlag              = strCarFixedFlag,
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
                objResMap.Add("OrderNo",       lo_objResOrderIns.data.OrderNo.ToString());
                objResMap.Add("GoodsSeqNo",    lo_objResOrderIns.data.GoodsSeqNo.ToString());
                objResMap.Add("AddSeqNo",      lo_objResOrderIns.data.AddSeqNo.ToString());
                objResMap.Add("DispatchSeqNo", lo_objResOrderIns.data.DispatchSeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 오더 수정
    /// </summary>
    protected void SetDomesticUpd()
    {
        OrderModel                 lo_objOrderModel  = null;
        ServiceResult<ResOrderUpd> lo_objResOrderUpd = null;

        strOrderItemCode     = Utils.IsNull(strOrderItemCode,     "OA007");
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

        if (string.IsNullOrWhiteSpace(strGetYMD) || string.IsNullOrWhiteSpace(strGetPlace))
        {
            objResMap.RetCode = 9007;
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 오더 단건 취소
    /// </summary>
    protected void SetDomesticOneCnl()
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 오더 취소
    /// </summary>
    protected void SetDomesticCnl()
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 비용 목록
    /// </summary>
    protected void GetDomesticPayList()
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 비용 등록
    /// </summary>
    protected void SetDomesticPayIns()
    {
        OrderPayModel                lo_objOrderPayModel  = null;
        ServiceResult<OrderPayModel> lo_objResOrderPayIns = null;

        strGoodsSeqNo    = Utils.IsNull(strGoodsSeqNo,    "0");
        strDispatchSeqNo = Utils.IsNull(strDispatchSeqNo, "0");
        strPayType       = Utils.IsNull(strPayType,       "0");
        strTaxKind       = Utils.IsNull(strTaxKind,       "0");
        strPayType       = Utils.IsNull(strPayType,       "0");

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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 비용 수정
    /// </summary>
    protected void SetDomesticPayUpd()
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 비용 삭제
    /// </summary>
    protected void SetDomesticPayDel()
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderDispatchCarList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 배차 상태 변경
    /// </summary>
    protected void SetDomesticDispatchCarStatusUpd()
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 사업장 변경
    /// </summary>
    protected void SetDomesticLocationUpd()
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 회원사별 항목 조회
    /// </summary>
    protected void GetDomesticCodeList()
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResCarDispatchRefSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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
                CenterCode        = strCenterCode.ToInt(),
                OrderNo           = strOrderNo.ToInt64(),
                CarFixedFlag      = strCarFixedFlag,
                AdminID           = objSes.AdminID
            };

            lo_objResTransRateOrderList = objOrderDasServices.GetTransRateOrderList(lo_objReqTransRateOrderList);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResTransRateOrderList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

        strOrderItemCode   = Utils.IsNull(strOrderItemCode,   "OA007");

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGoodsDispatchType) || strGoodsDispatchType.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strGoodsDispatchType.Equals("3") && string.IsNullOrWhiteSpace(strOrderLocationCode))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strConsignorCode) || strConsignorCode.Equals("0"))
        {
            objResMap.RetCode = 9004;
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

        if (string.IsNullOrWhiteSpace(strFTLFlag) || string.IsNullOrWhiteSpace(strGoodsRunType) || string.IsNullOrWhiteSpace(strCarFixedFlag) || string.IsNullOrWhiteSpace(strLayoverFlag))
        {
            objResMap.RetCode = 9009;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strLayoverFlag.Equals("Y") && strSamePlaceCount.Equals("0") && strNonSamePlaceCount.Equals("0"))
        {
            objResMap.RetCode = 9010;
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

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResTransRateOrderApplyList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 본부 목록 조회
    /// </summary>
    protected void GetHeadCenterList()
    {
        ReqCenterFranchiseList                lo_objReqCenterFranchiseList = null;
        ServiceResult<ResCenterFranchiseList> lo_objResCenterFranchiseList = null;

        try
        {
            lo_objReqCenterFranchiseList = new ReqCenterFranchiseList
            {
                CenterCode       = strCenterCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                AddHeadFlag      = "Y",
                AddBranchFlag    = "N",
                AddContractFlag  = "N"
            };

            lo_objResCenterFranchiseList = objCenterDasServices.GetCenterFranchiseList(lo_objReqCenterFranchiseList);
            if (lo_objResCenterFranchiseList.data.RecordCnt > 0)
            {
                objResMap.Add("RecordCnt", lo_objResCenterFranchiseList.data.RecordCnt);
                objResMap.Add("List",      lo_objResCenterFranchiseList.data.list);
            }
            else
            {
                objResMap.Add("RecordCnt", 0);
                objResMap.Add("List",      null);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 본부+계열사+협력사 목록 조회
    /// </summary>
    protected void GetContractCenterList()
    {
        ReqCenterFranchiseList                lo_objReqCenterFranchiseList = null;
        ServiceResult<ResCenterFranchiseList> lo_objResCenterFranchiseList = null;

        try
        {
            lo_objReqCenterFranchiseList = new ReqCenterFranchiseList
            {
                CenterCode       = strCenterCode.ToInt(),
                AccessCenterCode = objSes.AccessCenterCode,
                AddHeadFlag      = "Y",
                AddBranchFlag    = "Y",
                AddContractFlag  = "Y"
            };

            lo_objResCenterFranchiseList = objCenterDasServices.GetCenterFranchiseList(lo_objReqCenterFranchiseList);
            if (lo_objResCenterFranchiseList.data.RecordCnt > 0)
            {
                objResMap.Add("RecordCnt", lo_objResCenterFranchiseList.data.RecordCnt);
                objResMap.Add("List",      lo_objResCenterFranchiseList.data.list);
            }
            else
            {
                objResMap.Add("RecordCnt", 0);
                objResMap.Add("List",      null);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 이관 등록
    /// </summary>
    protected void SetDomesticTransIns()
    {
        ReqOrderTransIns                lo_objReqOrderTransIns = null;
        ServiceResult<ResOrderTransIns> lo_objResOrderTransIns = null;

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

        if (string.IsNullOrWhiteSpace(strTargetCenterCode) || strTargetCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderTransIns = new ReqOrderTransIns
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                TargetCenterCode = strTargetCenterCode.ToInt(),
                SaleOrgAmt       = strSaleOrgAmt.ToDouble(),
                AdminID          = objSes.AdminID,
                AdminName        = objSes.AdminName,
                AdminTelNo       = objSes.TelNo,
                AdminMobileNo    = objSes.MobileNo
            };

            lo_objResOrderTransIns = objOrderDasServices.SetOrderTransIns(lo_objReqOrderTransIns);
            objResMap.RetCode      = lo_objResOrderTransIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderTransIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 위탁 등록
    /// </summary>
    protected void SetDomesticContractIns()
    {
        ReqOrderContractIns                lo_objReqOrderContractIns = null;
        ServiceResult<ResOrderContractIns> lo_objResOrderContractIns = null;

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

        if (string.IsNullOrWhiteSpace(strContractCenterCode) || strContractCenterCode.Equals("0"))
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

        try
        {
            lo_objReqOrderContractIns = new ReqOrderContractIns
            {
                CenterCode         = strCenterCode.ToInt(),
                OrderNo            = strOrderNo.ToInt64(),
                ContractCenterCode = strContractCenterCode.ToInt(),
                DispatchType       = strDispatchType.ToInt(),
                AdminID            = objSes.AdminID,
                AdminName          = objSes.AdminName,
                AdminTelNo         = objSes.TelNo,
                AdminMobileNo      = objSes.MobileNo
            };

            lo_objResOrderContractIns = objOrderDasServices.SetOrderContractIns(lo_objReqOrderContractIns);
            objResMap.RetCode         = lo_objResOrderContractIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderContractIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 웹수정요청 취소
    /// </summary>
    protected void SetOrderRequestChgUpd()
    {
        WebOrderModel                lo_objWebOrderModel  = null;
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
                ChgSeqNo        = strChgSeqNo.ToInt64(),
                ChgReqContent   = strChgReqContent,
                ChgMessage      = strChgMessage,
                ChgStatus       = strChgStatus.ToInt(),
                RegAdminID      = objSes.AdminID,
                RegAdminName    = objSes.AdminName
            };

            lo_objResWebOrderModel = objWebOrderDasServices.SetWebOrderRequestChgUpd(lo_objWebOrderModel);

            objResMap.RetCode             = lo_objResWebOrderModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResWebOrderModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 수정요청 조회
    /// </summary>
    protected void GetOrderRequestChgList()
    {
        ReqOrderRequestChgList                lo_objReqOrderRequestChgList = null;
        ServiceResult<ResOrderRequestChgList> lo_objResOrderRequestChgList = null;
        strOrderClientCode   = Utils.IsNull(strOrderClientCode,   "0");
        try
        {
            lo_objReqOrderRequestChgList = new ReqOrderRequestChgList
            {
                ChgSeqNo         = strChgSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                OrderClientCode  = strOrderClientCode.ToInt(),
                ChgStatus        = strChgStatus.ToInt(),
                ListType         = strListType.ToInt(),
                DateFrom         = strDateFrom,
                DateTo           = strDateTo,
                MyChargeFlag     = strMyChargeFlag,
                AdminID          = objSes.AdminID,
                AccessCenterCode = objSes.AccessCenterCode,
                PageSize         = intPageSize,
                PageNo           = intPageNo,
            };

            lo_objResOrderRequestChgList = objWebOrderDasServices.GetOrderRequestWeborderChgList(lo_objReqOrderRequestChgList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResOrderRequestChgList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9411;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 이관 매출 수정
    /// </summary>
    protected void SetOrderTransSaleUpd()
    {
        ReqOrderTransSaleUpd lo_objReqOrderTransSaleUpd = null;
        ServiceResult<bool>  lo_objResOrderTransSaleUpd = null;

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

        if (string.IsNullOrWhiteSpace(strSaleSeqNos))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strProcTypes))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strTaxKinds))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strItemCodes))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strSupplyAmts))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strTaxAmts))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqOrderTransSaleUpd = new ReqOrderTransSaleUpd
            {
                CenterCode = strCenterCode.ToInt(),
                OrderNo    = strOrderNo.ToInt64(),
                SaleSeqNos = strSaleSeqNos,
                ProcTypes  = strProcTypes,
                TaxKinds   = strTaxKinds,
                ItemCodes  = strItemCodes,
                SupplyAmts = strSupplyAmts,
                TaxAmts    = strTaxAmts,
                AdminID    = objSes.AdminID,
                AdminName  = objSes.AdminName
            };

            lo_objResOrderTransSaleUpd = objOrderDasServices.SetOrderTransSaleUpd(lo_objReqOrderTransSaleUpd);
            objResMap.RetCode          = lo_objResOrderTransSaleUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderTransSaleUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 직송 위탁 취소
    /// </summary>
    protected void SetOrderDispatchContractCnl()
    {
        OrderDispatchModel                lo_objReqOrderDispatchModel = null;
        ServiceResult<OrderDispatchModel> lo_objResOrderDispatchModel = null;
        int                               lo_intDispatchType          = 1;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
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
                DispatchType = lo_intDispatchType,
                AdminID      = objSes.AdminID,
                AdminName    = objSes.AdminName
            };

            lo_objResOrderDispatchModel = objOrderDispatchDasServices.InsContractMultiReqCnl(lo_objReqOrderDispatchModel);
            objResMap.RetCode = lo_objResOrderDispatchModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResOrderDispatchModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9709;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 내수 이관 매출 목록
    /// </summary>
    protected void GetDomesticTransPayList()
    {
        ServiceResult<ResOrderPayList> lo_objResOrderPayList = null;

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

        try
        {
            lo_objResOrderPayList = objOrderDasServices.GetOrderTransPayList(strCenterCode.ToInt(), strOrderNo.ToInt64(), objSes.AccessCenterCode);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResOrderPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 카고패스 - 관리 및 연계차량 조회
    /// </summary>
    protected void GetCarManageList()
    {
        ReqCarManageSearchList                        lo_objReqCarManageSearchList         = null;
        ServiceResult<ResCarManageSearchList>         lo_objResCarManageSearchList         = null;
        ReqCarManageDispatchSearchList                lo_objReqCarManageDispatchSearchList = null;
        ServiceResult<ResCarManageDispatchSearchList> lo_objResCarManageDispatchSearchList = null;

        if (string.IsNullOrWhiteSpace(strPickupYMD))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strPickupPlaceFullAddr))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGetPlaceFullAddr))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarManageSearchList = new ReqCarManageSearchList
            {
                PickupYMD      = strPickupYMD,
                PickupFullAddr = strPickupPlaceFullAddr,
                GetFullAddr    = strGetPlaceFullAddr,
                AdminID        = objSes.AdminID,
                PageNo         = 1,
                PageSize       = 50
            };

            lo_objResCarManageSearchList = objCarManageDasServices.GetCarManageSearchList(lo_objReqCarManageSearchList);

            if (lo_objResCarManageSearchList.result.ErrorCode.IsFail())
            {
                objResMap.RetCode = 9004;
                objResMap.ErrMsg  = "관리차량 조회에 실패했습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        try
        {
            lo_objReqCarManageDispatchSearchList = new ReqCarManageDispatchSearchList
            {
                CenterCode     = strCenterCode.ToInt(),
                OrderNo        = strOrderNo.ToInt64(),
                PickupYMD      = strPickupYMD,
                PickupFullAddr = strPickupPlaceFullAddr,
                AdminID        = objSes.AdminID,
                PageNo         = 1,
                PageSize       = 50
            };

            lo_objResCarManageDispatchSearchList = objCarManageDasServices.GetCarManageDispatchSearchList(lo_objReqCarManageDispatchSearchList);

            if (lo_objResCarManageDispatchSearchList.result.ErrorCode.IsFail())
            {
                objResMap.RetCode = 9005;
                objResMap.ErrMsg  = "연계차량 조회에 실패했습니다.";
                return;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }

        objResMap.strResponse = "[{\"ErrMsg\":\"\",\"RetCode\":0, \"CarManageList\" : " + JsonConvert.SerializeObject(lo_objResCarManageSearchList.data);
        objResMap.strResponse += ",\"CarManageDispatchList\" : " + JsonConvert.SerializeObject(lo_objResCarManageDispatchSearchList.data) + "}]";
    }

    /// <summary>
    /// 카고패스 - 차량등록
    /// </summary>
    protected void SetCarManageIns()
    {
        int                                 lo_intCarDivType         = 3;//단기용차
        CarDispatchViewModel                lo_objReqCarAllManageIns = null;
        ServiceResult<CarDispatchViewModel> lo_objResCarAllManageIns = null;

        if (string.IsNullOrWhiteSpace(strCenterCode) || strCenterCode.Equals("0"))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0"))
        {
            objResMap.RetCode = 9002;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarSeqNo) || strCarSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strDriverSeqNo) || strDriverSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarDispatchType) || strCarDispatchType.Equals("0"))
        {
            objResMap.RetCode = 9005;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strCarDispatchType.Equals("2"))
        {

            if (string.IsNullOrWhiteSpace(strOrgCenterCode) || strOrgCenterCode.Equals("0"))
            {
                objResMap.RetCode = 9006;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strOrgOrderNo) || strOrgOrderNo.Equals("0"))
            {
                objResMap.RetCode = 9007;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }

        try
        {
            lo_objReqCarAllManageIns = new CarDispatchViewModel
            {
                CenterCode  = strCenterCode.ToInt(),
                CarDivType  = lo_intCarDivType,
                ComCode     = strComCode.ToInt64(),
                CarSeqNo    = strCarSeqNo.ToInt64(),
                DriverSeqNo = strDriverSeqNo.ToInt64(),
                AdminID     = objSes.AdminID
            };

            lo_objResCarAllManageIns = objCarDispatchDasServices.SetCarAllManageIns(lo_objReqCarAllManageIns);
            objResMap.RetCode        = lo_objResCarAllManageIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarAllManageIns.result.ErrorMsg;
            }

            objResMap.Add("RefSeqNo",        lo_objResCarAllManageIns.data.RefSeqNo);
            objResMap.Add("DispatchInfo",    lo_objResCarAllManageIns.data.DispatchInfo);
            objResMap.Add("CarNo",           strCarNo);
            objResMap.Add("AreaDistance",    strAreaDistance);
            objResMap.Add("CarDispatchType", strCarDispatchType);
            objResMap.Add("OrgCenterCode",   strOrgCenterCode);
            objResMap.Add("OrgOrderNo",      strOrgOrderNo);

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 카고패스 - 배차 기록 등록
    /// </summary>
    protected void SetCarManageDispatchIns()
    {
        ReqCarManageDispatchIns lo_objReqCarManageDispatchIns = null;
        ServiceResult<bool>     lo_objResCarManageDispatchIns = null;

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

        if (string.IsNullOrWhiteSpace(strRefSeqNo) || strRefSeqNo.Equals("0"))
        {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strCarDispatchType) || strCarDispatchType.Equals("0"))
        {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (strCarDispatchType.Equals("2"))
        {
            if (string.IsNullOrWhiteSpace(strOrgCenterCode) || strOrgCenterCode.Equals("0"))
            {
                objResMap.RetCode = 9005;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }

            if (string.IsNullOrWhiteSpace(strOrgOrderNo) || strOrgOrderNo.Equals("0"))
            {
                objResMap.RetCode = 9006;
                objResMap.ErrMsg  = "필요한 값이 없습니다.";
                return;
            }
        }

        try
        {
            lo_objReqCarManageDispatchIns = new ReqCarManageDispatchIns
            {
                CarDispatchType = strCarDispatchType.ToInt(),
                RefSeqNo        = strRefSeqNo.ToInt64(),
                OrgCenterCode   = strOrgCenterCode.ToInt(),
                OrgOrderNo      = strOrgOrderNo.ToInt64(),
                CenterCode      = strCenterCode.ToInt(),
                OrderNo         = strOrderNo.ToInt64(),
                AreaDistance    = strAreaDistance.ToDouble(),
                RegAdminID      = objSes.AdminID
            };

            lo_objResCarManageDispatchIns = objCarManageDasServices.SetCarManageDispatchIns(lo_objReqCarManageDispatchIns);
            objResMap.RetCode        = lo_objResCarManageDispatchIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResCarManageDispatchIns.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 비용 수정 요청 목록
    /// </summary>
    protected void GetAmtRequestOrderList()
    {
        ReqOrderAmtRequestOrderList                lo_objReqOrderAmtRequestOrderList = null;
        ServiceResult<ResOrderAmtRequestOrderList> lo_objResOrderAmtRequestOrderList = null;
        int                                        lo_intListType                    = 1;

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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 미수 목록
    /// </summary>
    protected void GetOrderMisuList()
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

            SiteGlobal.WriteLog("DomesticHandler", "Exception",
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