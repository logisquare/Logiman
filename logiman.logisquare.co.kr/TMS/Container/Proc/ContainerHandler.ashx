<%@ WebHandler Language="C#" Class="ContainerHandler" %>
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
/// FileName        : ContainerHandler.ashx
/// Description     : 컨테이너오더 Process Handler
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.ItemContainerHandler
/// Author          : sybyun96@logislab.com, 2022-07-20
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class ContainerHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/TMS/Container/ContainerList"; //필수

    // 메소드 리스트
    private const string MethodContainerCount         = "ContainerCount";          //오더 현황 카운트
    private const string MethodContainerList          = "ContainerList";           //오더 목록
    private const string MethodContainerListExcel     = "ContainerListExcel";      //오더 엑셀
    private const string MethodContainerCostListExcel = "ContainerCostListExcel";  //오더 비용 엑셀
    private const string MethodContainerIns           = "ContainerInsert";         //오더 등록
    private const string MethodContainerUpd           = "ContainerUpdate";         //오더 수정
    private const string MethodContainerCnl           = "ContainerCancel";         //오더 취소
    private const string MethodContainerOneCnl        = "ContainerOneCancel";      //오더 단건 취소
    private const string MethodContainerPayList       = "ContainerPayList";        //비용 목록
    private const string MethodContainerPayIns        = "ContainerPayInsert";      //비용 등록
    private const string MethodContainerPayUpd        = "ContainerPayUpdate";      //비용 수정
    private const string MethodContainerPayDel        = "ContainerPayDelete";      //비용 삭제
    private const string MethodContainerLocationUpd   = "ContainerLocationUpdate"; //사업장 변경
    private const string MethodContainerCodeList      = "ContainerCodeList";       //회원사별 코드 조회
    private const string MethodClientList             = "ClientList";              //고객사(발주/청구처) 조회
    private const string MethodClientChargeList       = "ClientChargeList";        //고객사 담당자 조회
    private const string MethodConsignorList          = "ConsignorList";           //화주 조회
    private const string MethodConsignorIns           = "ConsignorInsert";         //화주등록
    private const string MethodPlaceList              = "PlaceList";               //작업지 조회
    private const string MethodPlaceChargeList        = "PlaceChargeList";         //작업지 담당자 조회
    private const string MethodPlaceNote              = "PlaceNote";               //작업지 특이사항 조회
    private const string MethodCarDispatchRefList     = "CarDispatchRefList";      //배차차량 조회
    private const string MethodCarCompanyList         = "CarCompanyList";          //차량 업체 조회
    private const string MethodCarList                = "CarList";                 //차량 조회
    private const string MethodDriverList             = "DriverList";              //기사 조회(휴대폰, 기사명)
    private const string MethodClientSaleLimit        = "ClientSaleLimit";         //매출 한도 정보 조회
    private const string MethodOrderMisuList          = "OrderMisuList";           //미수 목록
        
    OrderDasServices             objOrderDasServices             = new OrderDasServices();
    ContainerDasServices         objContainerDasServices         = new ContainerDasServices();
    ClientDasServices            objClientDasServices            = new ClientDasServices();
    ClientPlaceChargeDasServices objClientPlaceChargeDasServices = new ClientPlaceChargeDasServices();
    ConsignorDasServices         objConsignorDasServices         = new ConsignorDasServices();
    CarDispatchDasServices       objCarDispatchDasServices       = new CarDispatchDasServices();
    ClientSaleLimitDasServices   objClientSaleLimitDasServices   = new ClientSaleLimitDasServices();
    DepositDasServices           objDepositDasServices           = new DepositDasServices();
    private HttpContext          objHttpContext                  = null;

    private string strCallType                  = string.Empty;
    private int    intPageSize                  = 0;
    private int    intPageNo                    = 0;
    private string strCenterCode                = string.Empty;
    private string strDateFrom                  = string.Empty;
    private string strDateTo                    = string.Empty;
    private string strOrderLocationCodes        = string.Empty;
    private string strOrderItemCodes            = string.Empty;
    private string strSearchClientType          = string.Empty;
    private string strSearchClientText          = string.Empty;
    private string strSearchChargeType          = string.Empty;
    private string strSearchChargeText          = string.Empty;
    private string strGoodsItemCode             = string.Empty;
    private string strSearchType                = string.Empty;
    private string strSearchText                = string.Empty;
    private string strAcceptAdminName           = string.Empty;
    private string strOrderNo                   = string.Empty;
    private string strMyChargeFlag              = string.Empty;
    private string strMyOrderFlag               = string.Empty;
    private string strCnlFlag                   = string.Empty;
    private string strCustomFlag                = string.Empty;
    private string strBondedFlag                = string.Empty;
    private string strDocumentFlag              = string.Empty;
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
    private string strPickupPlaceLocalCode      = string.Empty;
    private string strPickupPlaceLocalName      = string.Empty;
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
    private string strNoteInside                = string.Empty;
    private string strNoteClient                = string.Empty;
    private string strVolume                    = string.Empty;
    private string strWeight                    = string.Empty;
    private string strBookingNo                 = string.Empty;
    private string strGoodsOrderNo              = string.Empty;
    private string strCntrNo                    = string.Empty;
    private string strSealNo                    = string.Empty;
    private string strDONo                      = string.Empty;
    private string strBLNo                      = string.Empty;
    private string strGoodsRunType              = string.Empty; // 2023-03-16 by shadow54 : 자동운임 수정 건
    private string strCarFixedFlag              = string.Empty;
    private string strLayoverFlag               = string.Empty;
    private string strSamePlaceCount            = string.Empty;
    private string strNonSamePlaceCount         = string.Empty;
    private string strPort                      = string.Empty;
    private string strShippingCompany           = string.Empty;
    private string strShippingShipName          = string.Empty;
    private string strShippingCharge            = string.Empty;
    private string strShippingTelNo             = string.Empty;
    private string strShipmentPort              = string.Empty;
    private string strShipmentYMD               = string.Empty;
    private string strEnterYMD                  = string.Empty;
    private string strPickupCY                  = string.Empty;
    private string strPickupCYCharge            = string.Empty;
    private string strPickupCYTelNo             = string.Empty;
    private string strGetCY                     = string.Empty;
    private string strGetCYCharge               = string.Empty;
    private string strGetCYTelNo                = string.Empty;
    private string strItem                      = string.Empty;
    private string strConsignor                 = string.Empty;
    private string strShipCode                  = string.Empty;
    private string strShipName                  = string.Empty;
    private string strDivCode                   = string.Empty;
    private string strCargoClosingTime          = string.Empty;
    private string strClientName                = string.Empty;
    private string strClientCode                = string.Empty;
    private string strChargeName                = string.Empty;
    private string strClientFlag                = string.Empty;
    private string strChargeFlag                = string.Empty;
    private string strPlaceName                 = string.Empty;
    private string strComName                   = string.Empty;
    private string strCarNo                     = string.Empty;
    private string strDriverName                = string.Empty;
    private string strDriverCell                = string.Empty;
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
    private string strCarDivType                = string.Empty;
    private string strComCode                   = string.Empty;
    private string strCarSeqNo                  = string.Empty;
    private string strDriverSeqNo               = string.Empty;
    private string strOrderNos                  = string.Empty;
    private string strCnlReason                 = string.Empty;
    private string strPlaceChargeName           = string.Empty;
    private string strSortType                  = string.Empty;
    private string strInsureExceptKind          = string.Empty;

    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodContainerCount,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodContainerList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodContainerListExcel,     MenuAuthType.All);
        objMethodAuthList.Add(MethodContainerCostListExcel, MenuAuthType.All);
        objMethodAuthList.Add(MethodContainerIns,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerUpd,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerCnl,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerOneCnl,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerPayList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodContainerPayIns,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerPayUpd,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerPayDel,        MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerLocationUpd,   MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodContainerCodeList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientChargeList,       MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorList,          MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodConsignorIns,           MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodPlaceList,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceChargeList,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodPlaceNote,              MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarDispatchRefList,     MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarCompanyList,         MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodCarList,                MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodDriverList,             MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodClientSaleLimit,        MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodOrderMisuList,          MenuAuthType.ReadOnly);

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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("ContainerHandler");
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
            strDateFrom                  = SiteGlobal.GetRequestForm("DateFrom");
            strDateTo                    = SiteGlobal.GetRequestForm("DateTo");
            strOrderLocationCodes        = SiteGlobal.GetRequestForm("OrderLocationCodes");
            strOrderItemCodes            = SiteGlobal.GetRequestForm("OrderItemCodes");
            strSearchClientType          = SiteGlobal.GetRequestForm("SearchClientType");
            strSearchClientText          = SiteGlobal.GetRequestForm("SearchClientText");
            strSearchChargeType          = SiteGlobal.GetRequestForm("SearchChargeType");
            strSearchChargeText          = SiteGlobal.GetRequestForm("SearchChargeText");
            strGoodsItemCode             = SiteGlobal.GetRequestForm("GoodsItemCode");
            strSearchType                = SiteGlobal.GetRequestForm("SearchType");
            strSearchText                = SiteGlobal.GetRequestForm("SearchText");
            strMyChargeFlag              = SiteGlobal.GetRequestForm("MyChargeFlag");
            strMyOrderFlag               = SiteGlobal.GetRequestForm("MyOrderFlag");
            strCnlFlag                   = SiteGlobal.GetRequestForm("CnlFlag");
            strCustomFlag                = Utils.IsNull(SiteGlobal.GetRequestForm("CustomFlag"),   "N");
            strBondedFlag                = Utils.IsNull(SiteGlobal.GetRequestForm("BondedFlag"),   "N");
            strDocumentFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("DocumentFlag"), "N");
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
            strConsignorNote             = SiteGlobal.GetRequestForm("ConsignorNote");
            strPickupYMD                 = SiteGlobal.GetRequestForm("PickupYMD");
            strPickupHM                  = SiteGlobal.GetRequestForm("PickupHM");
            strPickupPlaceLocalCode      = SiteGlobal.GetRequestForm("PickupPlaceLocalCode");
            strPickupPlaceLocalName      = SiteGlobal.GetRequestForm("PickupPlaceLocalName");
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
            strNoteInside                = SiteGlobal.GetRequestForm("NoteInside",      false);
            strNoteClient                = SiteGlobal.GetRequestForm("NoteClient",      false);
            strGoodsSeqNo                = SiteGlobal.GetRequestForm("GoodsSeqNo");
            strGoodsItemCode             = SiteGlobal.GetRequestForm("GoodsItemCode");
            strVolume                    = SiteGlobal.GetRequestForm("Volume");
            strWeight                    = SiteGlobal.GetRequestForm("Weight");
            strBookingNo                 = SiteGlobal.GetRequestForm("BookingNo");
            strGoodsOrderNo              = SiteGlobal.GetRequestForm("GoodsOrderNo");
            strCntrNo                    = SiteGlobal.GetRequestForm("CntrNo");
            strSealNo                    = SiteGlobal.GetRequestForm("SealNo");
            strDONo                      = SiteGlobal.GetRequestForm("DONo");
            strBLNo                      = SiteGlobal.GetRequestForm("BLNo");
            strGoodsRunType              = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsRunType"),      "1");   // 2023-03-16 by shadow54 : 자동운임 수정 건
            strCarFixedFlag              = SiteGlobal.GetRequestForm("CarFixedFlag");
            strLayoverFlag               = SiteGlobal.GetRequestForm("LayoverFlag");
            strSamePlaceCount            = Utils.IsNull(SiteGlobal.GetRequestForm("SamePlaceCount"),    "0");
            strNonSamePlaceCount         = Utils.IsNull(SiteGlobal.GetRequestForm("NonSamePlaceCount"), "0");
            strPort                      = SiteGlobal.GetRequestForm("Port");
            strShippingCompany           = SiteGlobal.GetRequestForm("ShippingCompany");
            strShippingShipName          = SiteGlobal.GetRequestForm("ShippingShipName");
            strShippingCharge            = SiteGlobal.GetRequestForm("ShippingCharge");
            strShippingTelNo             = SiteGlobal.GetRequestForm("ShippingTelNo");
            strShipmentPort              = SiteGlobal.GetRequestForm("ShipmentPort");
            strShipmentYMD               = SiteGlobal.GetRequestForm("ShipmentYMD");
            strEnterYMD                  = SiteGlobal.GetRequestForm("EnterYMD");
            strPickupCY                  = SiteGlobal.GetRequestForm("PickupCY");
            strPickupCYCharge            = SiteGlobal.GetRequestForm("PickupCYCharge");
            strPickupCYTelNo             = SiteGlobal.GetRequestForm("PickupCYTelNo");
            strGetCY                     = SiteGlobal.GetRequestForm("GetCY");
            strGetCYCharge               = SiteGlobal.GetRequestForm("GetCYCharge");
            strGetCYTelNo                = SiteGlobal.GetRequestForm("GetCYTelNo");
            strItem                      = SiteGlobal.GetRequestForm("Item");
            strConsignor                 = SiteGlobal.GetRequestForm("Consignor");
            strShipCode                  = SiteGlobal.GetRequestForm("ShipCode");
            strShipName                  = SiteGlobal.GetRequestForm("ShipName");
            strDivCode                   = SiteGlobal.GetRequestForm("DivCode");
            strCargoClosingTime          = SiteGlobal.GetRequestForm("CargoClosingTime");
            strClientName                = SiteGlobal.GetRequestForm("ClientName"); //검색용
            strClientCode                = Utils.IsNull(SiteGlobal.GetRequestForm("ClientCode"), "0");
            strChargeName                = SiteGlobal.GetRequestForm("ChargeName");
            strClientFlag                = SiteGlobal.GetRequestForm("ClientFlag");
            strChargeFlag                = SiteGlobal.GetRequestForm("ChargeFlag");
            strPlaceName                 = SiteGlobal.GetRequestForm("PlaceName");
            strComName                   = SiteGlobal.GetRequestForm("ComName");
            strCarNo                     = SiteGlobal.GetRequestForm("CarNo");
            strDriverName                = SiteGlobal.GetRequestForm("DriverName");
            strDriverCell                = SiteGlobal.GetRequestForm("DriverCell");
            strReqSeqNo                  = SiteGlobal.GetRequestForm("ReqSeqNo");
            strSupplyAmt                 = Utils.IsNull(SiteGlobal.GetRequestForm("SupplyAmt"),     "0");
            strTaxAmt                    = Utils.IsNull(SiteGlobal.GetRequestForm("TaxAmt"),        "0");
            strSeqNo                     = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"),         "0");
            strGoodsSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("GoodsSeqNo"),    "0");
            strDispatchSeqNo             = Utils.IsNull(SiteGlobal.GetRequestForm("DispatchSeqNo"), "0");
            strPayType                   = Utils.IsNull(SiteGlobal.GetRequestForm("PayType"),       "0");
            strTaxKind                   = Utils.IsNull(SiteGlobal.GetRequestForm("TaxKind"),       "0");
            strItemCode                  = SiteGlobal.GetRequestForm("ItemCode");
            strRefSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("RefSeqNo"),    "0");
            strCarDivType                = Utils.IsNull(SiteGlobal.GetRequestForm("CarDivType"),  "0");
            strComCode                   = Utils.IsNull(SiteGlobal.GetRequestForm("ComCode"),     "0");
            strCarSeqNo                  = Utils.IsNull(SiteGlobal.GetRequestForm("CarSeqNo"),    "0");
            strDriverSeqNo               = Utils.IsNull(SiteGlobal.GetRequestForm("DriverSeqNo"), "0");
            strOrderNos                  = SiteGlobal.GetRequestForm("OrderNos");
            strCnlReason                 = SiteGlobal.GetRequestForm("CnlReason");
            strPlaceChargeName           = SiteGlobal.GetRequestForm("PlaceChargeName");
            strSortType                  = Utils.IsNull(SiteGlobal.GetRequestForm("SortType"), "1");
            strInsureExceptKind          = Utils.IsNull(SiteGlobal.GetRequestForm("InsureExceptKind"), "1");

            strDateFrom = string.IsNullOrWhiteSpace(strDateFrom) ? strDateFrom : strDateFrom.Replace("-", "");
            strDateTo   = string.IsNullOrWhiteSpace(strDateTo) ? strDateTo : strDateTo.Replace("-", "");

        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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
                case MethodContainerCount:
                    GetContainerCount();
                    break;
                case MethodContainerList:
                    GetContainerList();
                    break;
                case MethodContainerListExcel:
                    GetContainerListExcel();
                    break;
                case MethodContainerCostListExcel:
                    GetContainerCostListExcel();
                    break;
                case MethodContainerIns:
                    SetContainerIns();
                    break;
                case MethodContainerUpd:
                    SetContainerUpd();
                    break;
                case MethodContainerCnl:
                    SetContainerCnl();
                    break;
                case MethodContainerOneCnl:
                    SetContainerOneCnl();
                    break;
                case MethodContainerPayList:
                    GetContainerPayList();
                    break;
                case MethodContainerPayIns:
                    SetContainerPayIns();
                    break;
                case MethodContainerPayUpd:
                    SetContainerPayUpd();
                    break;
                case MethodContainerPayDel:
                    SetContainerPayDel();
                    break;
                case MethodContainerLocationUpd:
                    SetContainerLocationUpd();
                    break;
                case MethodContainerCodeList:
                    GetContainerCodeList();
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
                case MethodConsignorIns:
                    SetConsignorIns();
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
                case MethodCarCompanyList:
                    GetCarCompanyList();
                    break;
                case MethodCarList:
                    GetCarList();
                    break;
                case MethodDriverList:
                    GetDriverList();
                    break;
                case MethodClientSaleLimit:
                    GetClientSaleLimit();
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process
    
    /// <summary>
    /// 컨테이너 오더 현황 목록
    /// </summary>
    protected void GetContainerCount()
    {
        ReqContainerOrderCount                lo_objReqContainerOrderCount = null;
        ServiceResult<ResContainerOrderCount> lo_objResContainerOrderCount = null;
            
        try
        {
            lo_objReqContainerOrderCount = new ReqContainerOrderCount
            {
                AccessCenterCode = objSes.AccessCenterCode
            };

            lo_objResContainerOrderCount = objContainerDasServices.GetContainerOrderCount(lo_objReqContainerOrderCount);

            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResContainerOrderCount) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 오더 현황 목록
    /// </summary>
    protected void GetContainerList()
    {
        ReqContainerList                lo_objReqContainerList = null;
        ServiceResult<ResContainerList> lo_objResContainerList = null;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        strOrderClientName = string.Empty;
        strPayClientName   = string.Empty;
        strConsignorName   = string.Empty;
        strComName         = string.Empty;
        strCarNo           = string.Empty;
        strPickupPlace     = string.Empty;

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
                case "4":
                    strComName = strSearchClientText;
                    break;
                case "5":
                    strCarNo = strSearchClientText;
                    break;
                case "6":
                    strPickupPlace = strSearchClientText;
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
        
        strShippingCompany = string.Empty;
        strCntrNo          = string.Empty;
        strBLNo            = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "1":
                    strShippingCompany = strSearchText;
                    break;
                case "2":
                    strCntrNo = strSearchText;
                    break;
                case "3":
                    strBLNo = strSearchText;
                    break;
            }
        }

        try
        {
            lo_objReqContainerList = new ReqContainerList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderClientName         = strOrderClientName,
                OrderClientChargeName   = strOrderClientChargeName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                ComName                 = strComName,
                CarNo                   = strCarNo,
                PickupPlace             = strPickupPlace,
                AcceptAdminName         = strAcceptAdminName,
                GoodsItemCode           = strGoodsItemCode,
                ShippingCompany         = strShippingCompany,
                CntrNo                  = strCntrNo,
                BLNo                    = strBLNo,
                MyChargeFlag            = strMyChargeFlag,
                MyOrderFlag             = strMyOrderFlag,
                CnlFlag                 = strCnlFlag,
                SortType                = strSortType.ToInt(),
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode,
                PageSize                = intPageSize,
                PageNo                  = intPageNo,
            };

            lo_objResContainerList = objContainerDasServices.GetContainerList(lo_objReqContainerList);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResContainerList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 오더 현황 엑셀
    /// </summary>
    protected void GetContainerListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqContainerList                lo_objReqContainerList = null;
        ServiceResult<ResContainerList> lo_objResContainerList = null;
        string                          lo_strFileName         = "";
        SpreadSheet                     lo_objExcel            = null;
        DataTable                       lo_dtData              = null;
        MemoryStream                    lo_outputStream        = null;
        byte[]                          lo_Content             = null;
        int                             lo_intColumnIndex      = 0;
        double                          lo_intRevenue          = 0;
        double                          lo_intRevenuePer       = 0.0;
        string                          lo_strPickupYMD        = string.Empty;

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        strOrderClientName = string.Empty;
        strPayClientName   = string.Empty;
        strConsignorName   = string.Empty;
        strComName         = string.Empty;
        strCarNo           = string.Empty;
        strPickupPlace     = string.Empty;

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
                case "4":
                    strComName = strSearchClientText;
                    break;
                case "5":
                    strCarNo = strSearchClientText;
                    break;
                case "6":
                    strPickupPlace = strSearchClientText;
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
        
        strShippingCompany = string.Empty;
        strCntrNo          = string.Empty;
        strBLNo            = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "1":
                    strShippingCompany = strSearchText;
                    break;
                case "2":
                    strCntrNo = strSearchText;
                    break;
                case "3":
                    strBLNo = strSearchText;
                    break;
            }
        }
            
        try
        {
            lo_objReqContainerList = new ReqContainerList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderClientName         = strOrderClientName,
                OrderClientChargeName   = strOrderClientChargeName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                ComName                 = strComName,
                CarNo                   = strCarNo,
                PickupPlace             = strPickupPlace,
                AcceptAdminName         = strAcceptAdminName,
                GoodsItemCode           = strGoodsItemCode,
                ShippingCompany         = strShippingCompany,
                CntrNo                  = strCntrNo,
                BLNo                    = strBLNo,
                MyChargeFlag            = strMyChargeFlag,
                MyOrderFlag             = strMyOrderFlag,
                CnlFlag                 = strCnlFlag,
                SortType                = strSortType.ToInt(),
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode,
                PageSize                = intPageSize,
                PageNo                  = intPageNo
            };

            lo_objResContainerList = objContainerDasServices.GetContainerList(lo_objReqContainerList);

            lo_dtData              = new DataTable();

            lo_dtData.Columns.Add(new DataColumn("회원사명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상태",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(발)담당자",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)담당자",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)전화번호", typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("화주명",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("DOOR요청일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("DOOR요청시간", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("작업지",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("DOOR지역코드", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("DOOR지역명",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(작)우편번호",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(작)주소",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(작)주소상세",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(작)적용주소",  typeof(string)));
                
            lo_dtData.Columns.Add(new DataColumn("매출",   typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("매입",   typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("수익",   typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("수익률",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("선급금",  typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("예수금",  typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("품목",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("총수량",  typeof(Int64)));
            lo_dtData.Columns.Add(new DataColumn("총중량",  typeof(double)));
            lo_dtData.Columns.Add(new DataColumn("비고",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("픽업CY",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차/반납CY", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("부킹 No",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("CNTR No", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("SEAL No", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("D/O No",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("BL No",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("선적항",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("선사",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("선명",      typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("배차자명",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량구분",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량업체명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량사업자번호", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량번호",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("차량톤수",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사명",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("기사휴대폰",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상차시간",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차시간",   typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("접수일",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("접수자명",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최종수정일",  typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("최종수정자명", typeof(string)));

            foreach (var row in lo_objResContainerList.data.list)
            {
                lo_intRevenue    = row.SaleSupplyAmt - row.PurchaseSupplyAmt;
                lo_intRevenuePer = row.SaleSupplyAmt.Equals(0) ? 0.0 : lo_intRevenue / row.SaleSupplyAmt * 100;
                lo_strPickupYMD  = Utils.DateFormatter(row.PickupYMD, "yyyyMMdd", "yyyy-MM-dd", row.PickupYMD);

                lo_dtData.Rows.Add(row.CenterName, row.OrderStatusM, row.OrderNo, row.OrderItemCodeM, row.OrderLocationCodeM
                                , row.OrderClientName, row.OrderClientChargeName,row.PayClientName, row.PayClientChargeName, row.PayClientChargeTelNo
                                , row.ConsignorName, lo_strPickupYMD, row.PickupHM, row.PickupPlace, row.PickupPlaceLocalCode
                                , row.PickupPlaceLocalName, row.PickupPlacePost,row.PickupPlaceAddr, row.PickupPlaceAddrDtl, row.PickupPlaceFullAddr
                                , row.SaleSupplyAmt, row.PurchaseSupplyAmt, lo_intRevenue,lo_intRevenuePer, row.AdvanceSupplyAmt3
                                , row.AdvanceSupplyAmt4, row.GoodsItemCodeM, row.Volume,row.Weight, row.NoteInside
                                , row.PickupCY, row.GetCY, row.BookingNo,row.CntrNo, row.SealNo
                                , row.DONo, row.BLNo, row.ShipmentPort,row.ShippingCompany, row.ShippingShipName
                                , row.DispatchAdminName, row.CarDivTypeM, row.ComName, row.ComCorpNo,row.CarNo
                                , row.CarTonCodeM, row.DriverName, row.DriverCell, row.PickupDT, row.GetDT
                                , row.AcceptDate, row.AcceptAdminName, row.UpdDate, row.UpdAdminName);

            }

            lo_objExcel = new SpreadSheet {SheetName = "ContainerList"};

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

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0.##");
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);

            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
            lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, string.Empty);
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 오더현황 비용 엑셀
    /// </summary>
    protected void GetContainerCostListExcel()
    {
        HttpContext.Current.Server.ScriptTimeout = 300;

        ReqContainerList                       lo_objReqContainerList        = null;
        ServiceResult<ResContainerList>        lo_objResContainerList        = null;
        ReqContainerPayItemList                lo_objReqContainerPayItemList = null;
        ServiceResult<ResContainerPayItemList> lo_objResContainerPayItemList = null;
        string                                 lo_strFileName                = "";
        SpreadSheet                            lo_objExcel                   = null;
        DataTable                              lo_dtData                     = null;
        DataTable                              lo_dtPayItem                  = new DataTable();
        DataRow                                lo_dtRow                      = null;
        MemoryStream                           lo_outputStream               = null;
        byte[]                                 lo_Content                    = null;
        int                                    lo_intColumnIndex             = 0;
        int                                    lo_intCnt                     = 1;
        string                                 lo_strPickupYMD               = string.Empty;

        lo_dtPayItem.Columns.Add("PayType",   typeof(int));
        lo_dtPayItem.Columns.Add("PayTypeM",   typeof(string));
        lo_dtPayItem.Columns.Add("ItemCode",  typeof(string));
        lo_dtPayItem.Columns.Add("ItemCodeM", typeof(string));

        if (strOrderNo.Equals("0") && (string.IsNullOrWhiteSpace(strDateFrom) || string.IsNullOrWhiteSpace(strDateTo)))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        
        strOrderClientName = string.Empty;
        strPayClientName   = string.Empty;
        strConsignorName   = string.Empty;
        strComName         = string.Empty;
        strCarNo           = string.Empty;
        strPickupPlace     = string.Empty;

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
                case "4":
                    strComName = strSearchClientText;
                    break;
                case "5":
                    strCarNo = strSearchClientText;
                    break;
                case "6":
                    strPickupPlace = strSearchClientText;
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
        
        strShippingCompany = string.Empty;
        strCntrNo          = string.Empty;
        strBLNo            = string.Empty;

        if (!string.IsNullOrWhiteSpace(strSearchType) && !string.IsNullOrWhiteSpace(strSearchText))
        {
            switch (strSearchType)
            {
                case "1":
                    strShippingCompany = strSearchText;
                    break;
                case "2":
                    strCntrNo = strSearchText;
                    break;
                case "3":
                    strBLNo = strSearchText;
                    break;
            }
        }
            
        try
        {
            lo_objReqContainerList = new ReqContainerList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderClientName         = strOrderClientName,
                OrderClientChargeName   = strOrderClientChargeName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                ComName                 = strComName,
                CarNo                   = strCarNo,
                PickupPlace             = strPickupPlace,
                AcceptAdminName         = strAcceptAdminName,
                GoodsItemCode           = strGoodsItemCode,
                ShippingCompany         = strShippingCompany,
                CntrNo                  = strCntrNo,
                BLNo                    = strBLNo,
                MyChargeFlag            = strMyChargeFlag,
                MyOrderFlag             = strMyOrderFlag,
                CnlFlag                 = strCnlFlag,
                SortType                = strSortType.ToInt(),
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode,
                PageSize                = intPageSize,
                PageNo                  = intPageNo
            };

            lo_objResContainerList = objContainerDasServices.GetContainerList(lo_objReqContainerList);

            lo_objReqContainerPayItemList = new ReqContainerPayItemList
            {
                CenterCode              = strCenterCode.ToInt(),
                OrderNo                 = strOrderNo.ToInt64(),
                DateFrom                = strDateFrom,
                DateTo                  = strDateTo,
                OrderLocationCodes      = strOrderLocationCodes,
                OrderItemCodes          = strOrderItemCodes,
                OrderClientName         = strOrderClientName,
                OrderClientChargeName   = strOrderClientChargeName,
                PayClientName           = strPayClientName,
                PayClientChargeName     = strPayClientChargeName,
                PayClientChargeLocation = strPayClientChargeLocation,
                ConsignorName           = strConsignorName,
                ComName                 = strComName,
                CarNo                   = strCarNo,
                PickupPlace             = strPickupPlace,
                AcceptAdminName         = strAcceptAdminName,
                GoodsItemCode           = strGoodsItemCode,
                ShippingCompany         = strShippingCompany,
                CntrNo                  = strCntrNo,
                BLNo                    = strBLNo,
                MyChargeFlag            = strMyChargeFlag,
                MyOrderFlag             = strMyOrderFlag,
                CnlFlag                 = strCnlFlag,
                AdminID                 = objSes.AdminID,
                AccessCenterCode        = objSes.AccessCenterCode
            };

            lo_objResContainerPayItemList = objContainerDasServices.GetContainerPayItemList(lo_objReqContainerPayItemList);
            if (lo_objResContainerPayItemList.data.RecordCnt > 0)
            {
                foreach (var row in lo_objResContainerPayItemList.data.list)
                {
                    if (lo_dtPayItem.Select("PayType = '" + row.PayType + "' AND ItemCode = '" + row.ItemCode + "'").Length.Equals(0))
                    {
                        lo_dtPayItem.Rows.Add(row.PayType, row.PayTypeM, row.ItemCode, row.ItemCodeM);
                    }
                }
            }

            lo_dtData              = new DataTable();
                
            lo_dtData.Columns.Add(new DataColumn("OrderNo",    typeof(long)));
            lo_dtData.Columns.Add(new DataColumn("CenterCode", typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("GoodsSeqNo", typeof(long)));

            lo_dtData.Columns.Add(new DataColumn("No",         typeof(int)));
            lo_dtData.Columns.Add(new DataColumn("회원사명",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("오더번호",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("상품",         typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("사업장",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("발주처명",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("청구처명",       typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("(청)담당자",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("화주명",        typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("DOOR요청일",    typeof(string)));

            lo_dtData.Columns.Add(new DataColumn("작업지",     typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("품목",      typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("픽업CY",    typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("하차/반납CY", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("CNTR No", typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("BL No",   typeof(string)));
            lo_dtData.Columns.Add(new DataColumn("비고",      typeof(string)));

            foreach (DataRow row in lo_dtPayItem.Rows)
            {
                lo_dtData.Columns.Add(new DataColumn(row["PayTypeM"] +"-"+ row["ItemCodeM"], typeof(double)));
            }
            
            foreach (var row in lo_objResContainerList.data.list)
            {
                lo_strPickupYMD = Utils.DateFormatter(row.PickupYMD, "yyyyMMdd", "yyyy-MM-dd", row.PickupYMD);

                lo_dtData.Rows.Add(row.OrderNo, row.CenterCode, row.GoodsSeqNo
                                , lo_intCnt, row.CenterName, row.OrderNo, row.OrderItemCodeM, row.OrderLocationCodeM
                                , row.OrderClientName, row.PayClientName, row.PayClientChargeName, row.ConsignorName, lo_strPickupYMD
                                , row.PickupPlace, row.GoodsItemCodeM, row.PickupCY, row.GetCY, row.CntrNo
                                , row.BLNo, row.NoteInside);
                lo_intCnt++;
            }

            if (lo_objResContainerPayItemList.data.RecordCnt > 0)
            {
                foreach (DataRow row in lo_dtData.Rows)
                {
                    foreach (var subRow in lo_objResContainerPayItemList.data.list.FindAll(r=> r.CenterCode.Equals(row["CenterCode"])).FindAll(r=> r.OrderNo.Equals(row["OrderNo"])).FindAll(r=> r.GoodsSeqNo.Equals(row["GoodsSeqNo"])))
                    {
                        row[subRow.PayTypeM +"-"+ subRow.ItemCodeM] = subRow.SupplyAmt;
                    }
                }
            }

            lo_dtData.Columns.Remove("OrderNo");
            lo_dtData.Columns.Remove("CenterCode");
            lo_dtData.Columns.Remove("GoodsSeqNo");

            lo_objExcel = new SpreadSheet {SheetName = "ContainerPayList"};
            
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

            foreach (var row in lo_dtPayItem.Rows)
            {
                lo_objExcel.SetColumnFormat(++lo_intColumnIndex, 0, "#,##0");
            }

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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 오더 등록
    /// </summary>
    protected void SetContainerIns()
    {
        ContainerModel                lo_objContainerModel  = null;
        ServiceResult<ContainerModel> lo_objResContainerIns = null;
        int                           lo_intOrderStatus     = 2;
        int                           lo_intOrderRegType    = 1;

        strOrderClientCode = Utils.IsNull(strOrderClientCode, "0");
        strPayClientCode   = Utils.IsNull(strPayClientCode,   "0");
        strConsignorCode   = Utils.IsNull(strConsignorCode,   "0");
        strVolume          = Utils.IsNull(strVolume,          "0");
        strWeight          = Utils.IsNull(strWeight,          "0");
        strReqSeqNo        = Utils.IsNull(strReqSeqNo,        "0");
        strPickupYMD       = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        strEnterYMD        = string.IsNullOrWhiteSpace(strEnterYMD) ? strEnterYMD : strEnterYMD.Replace("-", "");
        strShipmentYMD     = string.IsNullOrWhiteSpace(strShipmentYMD) ? strShipmentYMD : strShipmentYMD.Replace("-", "");
        
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

        if (string.IsNullOrWhiteSpace(strGoodsItemCode) || string.IsNullOrWhiteSpace(strVolume) || strVolume.Equals("0"))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //strWeight = Math.Ceiling(strWeight.ToDouble()) + string.Empty;
        
        try
        {
            lo_objContainerModel = new ContainerModel
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
                NoteClient                = strNoteClient,
                NoteInside                = strNoteInside,
                CustomFlag                = strCustomFlag,
                BondedFlag                = strBondedFlag,
                DocumentFlag              = strDocumentFlag,
                OrderStatus               = lo_intOrderStatus,
                OrderRegType              = lo_intOrderRegType,
                Item                      = strItem,
                Port                      = strPort,
                CargoClosingTime          = strCargoClosingTime,
                EnterYMD                  = strEnterYMD,
                ShipmentYMD               = strShipmentYMD,
                ShipmentPort              = strShipmentPort,
                ShippingCompany           = strShippingCompany,
                ShippingShipName          = strShippingShipName,
                ShippingCharge            = strShippingCharge,
                ShippingTelNo             = strShippingTelNo,
                PickupCY                  = strPickupCY,
                PickupCYCharge            = strPickupCYCharge,
                PickupCYTelNo             = strPickupCYTelNo,
                GetCY                     = strGetCY,
                GetCYCharge               = strGetCYCharge,
                GetCYTelNo                = strGetCYTelNo,
                Consignor                 = strConsignor,
                ShipCode                  = strShipCode,
                ShipName                  = strShipName,
                DivCode                   = strDivCode,
                GoodsItemCode             = strGoodsItemCode,
                Volume                    = strVolume.ToInt(),
                Weight                    = strWeight.ToDouble(),
                BookingNo                 = strBookingNo,
                CntrNo                    = strCntrNo,
                SealNo                    = strSealNo,
                DONo                      = strDONo,
                GoodsOrderNo              = strGoodsOrderNo,
                BLNo                      = strBLNo,
                GoodsRunType              = strGoodsRunType.ToInt(), // 2023-03-16 by shadow54 : 자동운임 수정 건
                CarFixedFlag              = strCarFixedFlag,
                LayoverFlag               = strLayoverFlag,
                SamePlaceCount            = strSamePlaceCount.ToInt(),
                NonSamePlaceCount         = strNonSamePlaceCount.ToInt(),
                ReqSeqNo                  = strReqSeqNo.ToInt64(),
                RegAdminID                = objSes.AdminID,
                RegAdminName              = objSes.AdminName
            };

            lo_objResContainerIns = objContainerDasServices.SetContainerIns(lo_objContainerModel);
            objResMap.RetCode  = lo_objResContainerIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResContainerIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("OrderNo",    lo_objResContainerIns.data.OrderNo.ToString());
                objResMap.Add("GoodsSeqNo", lo_objResContainerIns.data.GoodsSeqNo.ToString());
                objResMap.Add("AddSeqNo",   lo_objResContainerIns.data.AddSeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 오더 수정
    /// </summary>
    protected void SetContainerUpd()
    {
        ContainerModel                 lo_objContainerModel  = null;
        ServiceResult<ResContainerUpd> lo_objResContainerUpd = null;

        strOrderClientCode = Utils.IsNull(strOrderClientCode, "0");
        strPayClientCode   = Utils.IsNull(strPayClientCode,   "0");
        strConsignorCode   = Utils.IsNull(strConsignorCode,   "0");
        strVolume          = Utils.IsNull(strVolume,          "0");
        strWeight          = Utils.IsNull(strWeight,          "0");
        strReqSeqNo        = Utils.IsNull(strReqSeqNo,        "0");
        strPickupYMD       = string.IsNullOrWhiteSpace(strPickupYMD) ? strPickupYMD : strPickupYMD.Replace("-", "");
        strEnterYMD        = string.IsNullOrWhiteSpace(strEnterYMD) ? strEnterYMD : strEnterYMD.Replace("-", "");
        strShipmentYMD     = string.IsNullOrWhiteSpace(strShipmentYMD) ? strShipmentYMD : strShipmentYMD.Replace("-", "");
        
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

        if (string.IsNullOrWhiteSpace(strPickupPlace))
        {
            objResMap.RetCode = 9006;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        if (string.IsNullOrWhiteSpace(strGoodsItemCode) || string.IsNullOrWhiteSpace(strVolume) || strVolume.Equals("0"))
        {
            objResMap.RetCode = 9007;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        //strWeight = Math.Ceiling(strWeight.ToDouble()) + string.Empty;

        try
        {
            lo_objContainerModel = new ContainerModel
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
                NoteClient                = strNoteClient,
                NoteInside                = strNoteInside,
                CustomFlag                = strCustomFlag,
                BondedFlag                = strBondedFlag,
                DocumentFlag              = strDocumentFlag,
                Item                      = strItem,
                Port                      = strPort,
                CargoClosingTime          = strCargoClosingTime,
                EnterYMD                  = strEnterYMD,
                ShipmentYMD               = strShipmentYMD,
                ShipmentPort              = strShipmentPort,
                ShippingCompany           = strShippingCompany,
                ShippingShipName          = strShippingShipName,
                ShippingCharge            = strShippingCharge,
                ShippingTelNo             = strShippingTelNo,
                PickupCY                  = strPickupCY,
                PickupCYCharge            = strPickupCYCharge,
                PickupCYTelNo             = strPickupCYTelNo,
                GetCY                     = strGetCY,
                GetCYCharge               = strGetCYCharge,
                GetCYTelNo                = strGetCYTelNo,
                Consignor                 = strConsignor,
                ShipCode                  = strShipCode,
                ShipName                  = strShipName,
                DivCode                   = strDivCode,
                GoodsItemCode             = strGoodsItemCode,
                Volume                    = strVolume.ToInt(),
                Weight                    = strWeight.ToDouble(),
                BookingNo                 = strBookingNo,
                CntrNo                    = strCntrNo,
                SealNo                    = strSealNo,
                DONo                      = strDONo,
                GoodsOrderNo              = strGoodsOrderNo,
                BLNo                      = strBLNo,
                GoodsRunType              = strGoodsRunType.ToInt(), // 2023-03-16 by shadow54 : 자동운임 수정 건
                CarFixedFlag              = strCarFixedFlag,
                LayoverFlag               = strLayoverFlag,
                SamePlaceCount            = strSamePlaceCount.ToInt(),
                NonSamePlaceCount         = strNonSamePlaceCount.ToInt(),
                UpdAdminID                = objSes.AdminID,
                UpdAdminName              = objSes.AdminName
            };

            lo_objResContainerUpd = objContainerDasServices.SetContainerUpd(lo_objContainerModel);
            objResMap.RetCode     = lo_objResContainerUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResContainerUpd.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SaleClosingFlag",     lo_objResContainerUpd.data.SaleClosingFlag);
                objResMap.Add("PurchaseClosingFlag", lo_objResContainerUpd.data.PurchaseClosingFlag);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 오더 취소
    /// </summary>
    protected void SetContainerCnl()
    {
        ReqContainerCnl                lo_objReqContainerCnl = null;
        ServiceResult<ResContainerCnl> lo_objResContainerCnl = null;
        
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
            lo_objReqContainerCnl = new ReqContainerCnl
            {
                CenterCode        = strCenterCode.ToInt(),
                OrderNos          = strOrderNos,
                CnlReason         = strCnlReason,
                CnlAdminID        = objSes.AdminID,
                CnlAdminName      = objSes.AdminName,
                GradeCode         = objSes.GradeCode,
                AccessCenterCode  = objSes.AccessCenterCode
            };

            lo_objResContainerCnl = objContainerDasServices.SetContainerCnl(lo_objReqContainerCnl);
            objResMap.RetCode     = lo_objResContainerCnl.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResContainerCnl.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("TotalCnt", lo_objResContainerCnl.data.TotalCnt);
                objResMap.Add("CancelCnt", lo_objResContainerCnl.data.CancelCnt);
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 오더 단건 취소
    /// </summary>
    protected void SetContainerOneCnl()
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
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 비용 목록
    /// </summary>
    protected void GetContainerPayList()
    {
        ServiceResult<ResContainerPayList> lo_objResContainerPayList = null;

        if (strOrderNo.Equals("0") || string.IsNullOrWhiteSpace(strOrderNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objResContainerPayList = objContainerDasServices.GetContainerPayList(0, strOrderNo.ToInt64(), objSes.AccessCenterCode);

            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResContainerPayList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 비용 등록
    /// </summary>
    protected void SetContainerPayIns()
    {
        ContainerPayModel                lo_objContainerPayModel  = null;
        ServiceResult<ContainerPayModel> lo_objResContainerPayIns = null;

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

        if (strPayType.Equals("2")) //매입
        {
            if ((string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0")) && (string.IsNullOrWhiteSpace(strCarDivType) || strCarDivType.Equals("0")|| string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0")|| string.IsNullOrWhiteSpace(strCarSeqNo) || strCarSeqNo.Equals("0")|| string.IsNullOrWhiteSpace(strDriverSeqNo) || strDriverSeqNo.Equals("0")) && (string.IsNullOrWhiteSpace(strRefSeqNo) || strRefSeqNo.Equals("0")))
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
            lo_objContainerPayModel = new ContainerPayModel
            {
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                GoodsSeqNo       = strGoodsSeqNo.ToInt64(),
                DispatchSeqNo    = strDispatchSeqNo.ToInt64(),
                PayType          = strPayType.ToInt(),
                TaxKind          = strTaxKind.ToInt(),
                ItemCode         = strItemCode,
                ClientCode       = strClientCode.ToInt64(),
                ClientName       = strClientName,
                RefSeqNo         = strRefSeqNo.ToInt64(),
                CarDivType       = strCarDivType.ToInt(),
                ComCode          = strComCode.ToInt64(),
                CarSeqNo         = strCarSeqNo.ToInt64(),
                DriverSeqNo      = strDriverSeqNo.ToInt64(),
                SupplyAmt        = strSupplyAmt.ToDouble(),
                TaxAmt           = strTaxAmt.ToDouble(),
                InsureExceptKind = strInsureExceptKind.ToInt(),
                RegAdminID       = objSes.AdminID,
                RegAdminName     = objSes.AdminName
            };

            lo_objResContainerPayIns = objContainerDasServices.SetContainerPayIns(lo_objContainerPayModel);
            objResMap.RetCode  = lo_objResContainerPayIns.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResContainerPayIns.result.ErrorMsg;
            }
            else
            {
                objResMap.Add("SeqNo",    lo_objResContainerPayIns.data.SeqNo.ToString());
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 비용 수정
    /// </summary>
    protected void SetContainerPayUpd()
    {
        ContainerPayModel   lo_objContainerPayModel  = null;
        ServiceResult<bool> lo_objResContainerPayUpd = null;

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

        if (strPayType.Equals("2")) //매입
        {
            if ((string.IsNullOrWhiteSpace(strClientCode) || strClientCode.Equals("0")) && (string.IsNullOrWhiteSpace(strCarDivType) || strCarDivType.Equals("0")|| string.IsNullOrWhiteSpace(strComCode) || strComCode.Equals("0")|| string.IsNullOrWhiteSpace(strCarSeqNo) || strCarSeqNo.Equals("0")|| string.IsNullOrWhiteSpace(strDriverSeqNo) || strDriverSeqNo.Equals("0")) && (string.IsNullOrWhiteSpace(strRefSeqNo) || strRefSeqNo.Equals("0")))
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
            lo_objContainerPayModel = new ContainerPayModel
            {
                SeqNo            = strSeqNo.ToInt64(),
                CenterCode       = strCenterCode.ToInt(),
                OrderNo          = strOrderNo.ToInt64(),
                GoodsSeqNo       = strGoodsSeqNo.ToInt64(),
                DispatchSeqNo    = strDispatchSeqNo.ToInt64(),
                PayType          = strPayType.ToInt(),
                TaxKind          = strTaxKind.ToInt(),
                ItemCode         = strItemCode,
                ClientCode       = strClientCode.ToInt64(),
                ClientName       = strClientName,
                RefSeqNo         = strRefSeqNo.ToInt64(),
                CarDivType       = strCarDivType.ToInt(),
                ComCode          = strComCode.ToInt64(),
                CarSeqNo         = strCarSeqNo.ToInt64(),
                DriverSeqNo      = strDriverSeqNo.ToInt64(),
                SupplyAmt        = strSupplyAmt.ToDouble(),
                TaxAmt           = strTaxAmt.ToDouble(),
                InsureExceptKind = strInsureExceptKind.ToInt(),
                UpdAdminID       = objSes.AdminID,
                UpdAdminName     = objSes.AdminName
            };

            lo_objResContainerPayUpd = objContainerDasServices.SetContainerPayUpd(lo_objContainerPayModel);
            objResMap.RetCode  = lo_objResContainerPayUpd.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResContainerPayUpd.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 비용 삭제
    /// </summary>
    protected void SetContainerPayDel()
    {
        ServiceResult<bool> lo_objResContainerPayDel = null;

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
            lo_objResContainerPayDel = objContainerDasServices.SetContainerPayDel(strSeqNo.ToInt64(), strCenterCode.ToInt(), strOrderNo.ToInt64(), strPayType.ToInt(), objSes.AdminID, objSes.AdminName);
            objResMap.RetCode        = lo_objResContainerPayDel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResContainerPayDel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 컨테이너 사업장 변경
    /// </summary>
    protected void SetContainerLocationUpd()
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 회원사별 항목 조회
    /// </summary>
    protected void GetContainerCodeList()
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 작업지 검색
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 작업지 담당자검색
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량 업체 검색
    /// </summary>
    protected void GetCarCompanyList()
    {
        ReqCarCompanySearchList                lo_objReqCarCompanySearchList = null;
        ServiceResult<ResCarCompanySearchList> lo_objResCarCompanySearchList = null;

        if (string.IsNullOrWhiteSpace(strComName))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarCompanySearchList = new ReqCarCompanySearchList
            {
                ComName  = strComName,
                UseFlag  = "Y",
                PageSize = intPageSize,
                PageNo   = intPageNo
            };

            lo_objResCarCompanySearchList = objCarDispatchDasServices.GetCarCompanySearchList(lo_objReqCarCompanySearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResCarCompanySearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 차량정보 검색
    /// </summary>
    protected void GetCarList()
    {
        ReqCarSearchList                lo_objReqCarSearchList = null;
        ServiceResult<ResCarSearchList> lo_objResCarSearchList = null;

        if (string.IsNullOrWhiteSpace(strCarNo))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarSearchList = new ReqCarSearchList
            {
                CarNo  = strCarNo,
                UseFlag  = "Y",
                PageSize = intPageSize,
                PageNo   = intPageNo
            };

            lo_objResCarSearchList = objCarDispatchDasServices.GetCarSearchList(lo_objReqCarSearchList);
            objResMap.strResponse     = "[" + JsonConvert.SerializeObject(lo_objResCarSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 기사 검색
    /// </summary>
    protected void GetDriverList()
    {
        ReqCarDriverSearchList                lo_objReqCarDriverSearchList = null;
        ServiceResult<ResCarDriverSearchList> lo_objResCarDriverSearchList = null;

        if (string.IsNullOrWhiteSpace(strDriverName) && string.IsNullOrWhiteSpace(strDriverCell))
        {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objReqCarDriverSearchList = new ReqCarDriverSearchList
            {
                DriverName = strDriverName,
                DriverCell = strDriverCell,
                UseFlag    = "Y",
                PageSize   = intPageSize,
                PageNo     = intPageNo
            };

            lo_objResCarDriverSearchList = objCarDispatchDasServices.GetCarDriverSearchList(lo_objReqCarDriverSearchList);
            objResMap.strResponse  = "[" + JsonConvert.SerializeObject(lo_objResCarDriverSearchList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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

            SiteGlobal.WriteLog("ContainerHandler", "Exception",
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