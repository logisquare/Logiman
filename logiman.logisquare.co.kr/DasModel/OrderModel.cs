using System.Collections.Generic;
using CommonLibrary.CommonModel;

namespace CommonLibrary.DasServices
{
    public class OrderModel
    {
        public int    CenterCode                { get; set; }
        public long   OrderNo                   { get; set; }
        public long   AddSeqNo                  { get; set; }
        public long   GoodsSeqNo                { get; set; }
        public long   DispatchSeqNo             { get; set; }
        public string OrderItemCode             { get; set; }
        public string OrderLocationCode         { get; set; }
        public long   OrderClientCode           { get; set; }
        public string OrderClientName           { get; set; }
        public string OrderClientChargeName     { get; set; }
        public string OrderClientChargePosition { get; set; }
        public string OrderClientChargeTelExtNo { get; set; }
        public string OrderClientChargeTelNo    { get; set; }
        public string OrderClientChargeCell     { get; set; }
        public long   PayClientCode             { get; set; }
        public string PayClientName             { get; set; }
        public string PayClientChargeName       { get; set; }
        public string PayClientChargePosition   { get; set; }
        public string PayClientChargeTelExtNo   { get; set; }
        public string PayClientChargeTelNo      { get; set; }
        public string PayClientChargeCell       { get; set; }
        public string PayClientChargeLocation   { get; set; }
        public long   ConsignorCode             { get; set; }
        public string ConsignorName             { get; set; }
        public string PickupYMD                 { get; set; }
        public string PickupHM                  { get; set; }
        public string PickupWay                 { get; set; }
        public string PickupPlace               { get; set; }
        public string PickupPlacePost           { get; set; }
        public string PickupPlaceAddr           { get; set; }
        public string PickupPlaceAddrDtl        { get; set; }
        public string PickupPlaceFullAddr       { get; set; }
        public string PickupPlaceChargeName     { get; set; }
        public string PickupPlaceChargePosition { get; set; }
        public string PickupPlaceChargeTelExtNo { get; set; }
        public string PickupPlaceChargeTelNo    { get; set; }
        public string PickupPlaceChargeCell     { get; set; }
        public string PickupPlaceLocalCode      { get; set; }
        public string PickupPlaceLocalName      { get; set; }
        public string PickupPlaceNote           { get; set; }
        public string GetYMD                    { get; set; }
        public string GetHM                     { get; set; }
        public string GetWay                    { get; set; }
        public string GetPlace                  { get; set; }
        public string GetPlacePost              { get; set; }
        public string GetPlaceAddr              { get; set; }
        public string GetPlaceAddrDtl           { get; set; }
        public string GetPlaceFullAddr          { get; set; }
        public string GetPlaceChargeName        { get; set; }
        public string GetPlaceChargePosition    { get; set; }
        public string GetPlaceChargeTelExtNo    { get; set; }
        public string GetPlaceChargeTelNo       { get; set; }
        public string GetPlaceChargeCell        { get; set; }
        public string GetPlaceLocalCode         { get; set; }
        public string GetPlaceLocalName         { get; set; }
        public string GetPlaceNote              { get; set; }
        public string NoteClient                { get; set; }
        public string NoteInside                { get; set; }
        public string CarTonCode                { get; set; } 
        public string CarTypeCode               { get; set; }
        public string NoLayerFlag               { get; set; }
        public string NoTopFlag                 { get; set; }
        public string FTLFlag                   { get; set; }
        public string FTLFlagM                  { get; set; }
        public string ArrivalReportFlag         { get; set; }
        public string CustomFlag                { get; set; }
        public string BondedFlag                { get; set; }
        public string DocumentFlag              { get; set; }
        public string LicenseFlag               { get; set; }
        public string InTimeFlag                { get; set; }
        public string ControlFlag               { get; set; }
        public string QuickGetFlag              { get; set; }
        public string OrderFPISFlag             { get; set; }
        public int    GoodsDispatchType         { get; set; }
        public string GoodsName                 { get; set; }
        public string GoodsItemCode             { get; set; }
        public int    Length                    { get; set; }
        public double CBM                       { get; set; }
        public string Quantity                  { get; set; }
        public int    Volume                    { get; set; }
        public double Weight                    { get; set; }
        public string Nation                    { get; set; }
        public string Hawb                      { get; set; }
        public string Mawb                      { get; set; }
        public string InvoiceNo                 { get; set; }
        public string BookingNo                 { get; set; }
        public string StockNo                   { get; set; }
        public string GMOrderType               { get; set; }
        public string GMTripID                  { get; set; }
        public string GoodsNote                 { get; set; }
        public int    GoodsRunType              { get; set; }
        public string CarFixedFlag              { get; set; } // 2023-03-16 by shadow54 : 자동운임 수정 건
        public string LayoverFlag               { get; set; }
        public int    SamePlaceCount            { get; set; }
        public int    NonSamePlaceCount         { get; set; }
        public string TaxClientName             { get; set; }
        public string TaxClientCorpNo           { get; set; }
        public string TaxClientChargeName       { get; set; }
        public string TaxClientChargeTelNo      { get; set; }
        public string TaxClientChargeEmail      { get; set; }
        public int    OrderRegType              { get; set; }
        public int    OrderStatus               { get; set; }
        public long   RefSeqNo                  { get; set; }
        public int    InsureExceptKind          { get; set; } = 1;
        public long   ReqSeqNo                  { get; set; }
        public long   WoSeqNo                   { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
        public string UpdAdminID                { get; set; }
        public string UpdAdminName              { get; set; }
        public int    QuickType                 { get; set; }
        public long   ChgSeqNo                  { get; set; }
    }

    public class OrderGridModel
    {
        public int    CenterCode                { get; set; }
        public string CenterName                { get; set; }
        public string OrderNo                   { get; set; }
        public string AddSeqNo                  { get; set; }
        public string GoodsSeqNo                { get; set; }
        public string DispatchSeqNo             { get; set; }
        public string OrderItemCode             { get; set; }
        public string OrderItemCodeM            { get; set; }
        public string OrderLocationCode         { get; set; }
        public string OrderLocationCodeM        { get; set; }
        public string OrderClientCode           { get; set; }
        public string OrderClientName           { get; set; }
        public string OrderClientChargeName     { get; set; }
        public string OrderClientChargePosition { get; set; }
        public string OrderClientChargeTelExtNo { get; set; }
        public string OrderClientChargeTelNo    { get; set; }
        public string OrderClientChargeCell     { get; set; }
        public string OrderClientMisuFlag       { get; set; }
        public double OrderClientTotalMisuAmt   { get; set; }
        public double OrderClientMisuAmt        { get; set; }
        public int    OrderClientNoMatchingCnt  { get; set; }
        public string PayClientType             { get; set; }
        public string PayClientTypeM            { get; set; }
        public string PayClientCode             { get; set; }
        public string PayClientName             { get; set; }
        public string PayClientChargeName       { get; set; }
        public string PayClientChargePosition   { get; set; }
        public string PayClientChargeTelExtNo   { get; set; }
        public string PayClientChargeTelNo      { get; set; }
        public string PayClientChargeCell       { get; set; }
        public string PayClientChargeLocation   { get; set; }
        public string PayClientCorpNo           { get; set; }
        public string PayClientInfo             { get; set; }
        public string PayClientMisuFlag         { get; set; }
        public double PayClientTotalMisuAmt     { get; set; }
        public double PayClientMisuAmt          { get; set; }
        public int    PayClientNoMatchingCnt    { get; set; }
        public string ConsignorCode             { get; set; }
        public string ConsignorName             { get; set; }
        public string PickupYMD                 { get; set; }
        public string PickupHM                  { get; set; }
        public string PickupPlace               { get; set; }
        public string PickupWay                 { get; set; }
        public string PickupPlacePost           { get; set; }
        public string PickupPlaceAddr           { get; set; }
        public string PickupPlaceAddrDtl        { get; set; }
        public string PickupPlaceFullAddr       { get; set; }
        public string PickupPlaceChargeName     { get; set; }
        public string PickupPlaceChargePosition { get; set; }
        public string PickupPlaceChargeTelExtNo { get; set; }
        public string PickupPlaceChargeTelNo    { get; set; }
        public string PickupPlaceChargeCell     { get; set; }
        public string PickupPlaceLocalCode      { get; set; }
        public string PickupPlaceLocalName      { get; set; }
        public string PickupPlaceNote           { get; set; }
        public string GetYMD                    { get; set; }
        public string GetHM                     { get; set; }
        public string GetPlace                  { get; set; }
        public string GetWay                    { get; set; }
        public string GetPlacePost              { get; set; }
        public string GetPlaceAddr              { get; set; }
        public string GetPlaceAddrDtl           { get; set; }
        public string GetPlaceFullAddr          { get; set; }
        public string GetPlaceChargeName        { get; set; }
        public string GetPlaceChargePosition    { get; set; }
        public string GetPlaceChargeTelExtNo    { get; set; }
        public string GetPlaceChargeTelNo       { get; set; }
        public string GetPlaceChargeCell        { get; set; }
        public string GetPlaceLocalCode         { get; set; }
        public string GetPlaceLocalName         { get; set; }
        public string GetPlaceNote              { get; set; }
        public string OrderGetTypeM             { get; set; }
        public string NoteClient                { get; set; }
        public string NoteInside                { get; set; }
        public string CarTonCode                { get; set; }
        public string CarTonCodeM               { get; set; }
        public string CarTypeCode               { get; set; }
        public string CarTypeCodeM              { get; set; }
        public string NoLayerFlag               { get; set; }
        public string NoTopFlag                 { get; set; }
        public string FTLFlag                   { get; set; }
        public string ArrivalReportFlag         { get; set; }
        public string CustomFlag                { get; set; }
        public string BondedFlag                { get; set; }
        public string DocumentFlag              { get; set; }
        public string LicenseFlag               { get; set; }
        public string InTimeFlag                { get; set; }
        public string ControlFlag               { get; set; }
        public string QuickGetFlag              { get; set; }
        public string OrderFPISFlag             { get; set; }
        public int    TransType                 { get; set; }
        public string TransTypeM                { get; set; }
        public string TransInfo                 { get; set; }
        public int    TransOrgCenterCode        { get; set; }
        public string TransOrgCenterName        { get; set; }
        public int    TargetCenterCode          { get; set; }
        public string TargetCenterName          { get; set; }
        public string TargetOrderNo             { get; set; }
        public int    GoodsDispatchType         { get; set; }
        public string GoodsDispatchTypeM        { get; set; }
        public string GoodsName                 { get; set; }
        public string GoodsItemCode             { get; set; }
        public string GoodsItemCodeM            { get; set; }
        public int    Length                    { get; set; }
        public double CBM                       { get; set; }
        public string Quantity                  { get; set; }
        public int    Volume                    { get; set; }
        public double Weight                    { get; set; }
        public string Nation                    { get; set; }
        public string Hawb                      { get; set; }
        public string Mawb                      { get; set; }
        public string InvoiceNo                 { get; set; }
        public string BookingNo                 { get; set; }
        public string StockNo                   { get; set; }
        public string BLNo                      { get; set; }
        public string GMOrderType               { get; set; }
        public string GMTripID                  { get; set; }
        public string GoodsNote                 { get; set; }
        public int    GoodsRunType              { get; set; }
        public string GoodsRunTypeM             { get; set; }
        public string CarFixedFlag              { get; set; } // 2023-03-16 by shadow54 : 자동운임 수정 건
        public string CarFixedFlagM             { get; set; }
        public string LayoverFlag               { get; set; }
        public string LayoverFlagM              { get; set; }
        public int    SamePlaceCount            { get; set; }
        public int    NonSamePlaceCount         { get; set; }
        public string TaxClientName             { get; set; }
        public string TaxClientCorpNo           { get; set; }
        public string TaxClientChargeName       { get; set; }
        public string TaxClientChargeTelNo      { get; set; }
        public string TaxClientChargeEmail      { get; set; }
        public string DispatchSeqNo1            { get; set; }
        public string DispatchRefSeqNo1         { get; set; }
        public string DispatchCarNo1            { get; set; }
        public string CarTonCode1               { get; set; }
        public string CarTonCodeM1              { get; set; }
        public string DispatchCarInfo1          { get; set; }
        public string DispatchInfo1             { get; set; }
        public string PickupDT1                 { get; set; }
        public string GetDT1                    { get; set; }
        public string DispatchSupplyAmt1        { get; set; }
        public string DispatchTaxAmt1           { get; set; }
        public string DispatchSeqNo2            { get; set; }
        public string DispatchRefSeqNo2         { get; set; }
        public string DispatchCarNo2            { get; set; }
        public string CarTonCode2               { get; set; }
        public string CarTonCodeM2              { get; set; }
        public string DispatchCarInfo2          { get; set; }
        public string DispatchInfo2             { get; set; }
        public string PickupDT2                 { get; set; }
        public string GetDT2                    { get; set; }
        public string DispatchSupplyAmt2        { get; set; }
        public string DispatchTaxAmt2           { get; set; }
        public string DispatchSeqNo3            { get; set; }
        public string DispatchRefSeqNo3         { get; set; }
        public string DispatchCarNo3            { get; set; }
        public string DispatchCarInfo3          { get; set; }
        public string DispatchInfo3             { get; set; }
        public string DispatchSupplyAmt3        { get; set; }
        public string DispatchTaxAmt3           { get; set; }
        public string DispatchSeqNo4            { get; set; }
        public string DispatchRefSeqNo4         { get; set; }
        public string DispatchCarNo4            { get; set; }
        public string DispatchCarInfo4          { get; set; }
        public string DispatchInfo4             { get; set; }
        public string DispatchSupplyAmt4        { get; set; }
        public string DispatchTaxAmt4           { get; set; }
        public long   SaleSupplyAmt             { get; set; }
        public long   PurchaseSupplyAmt         { get; set; }
        public long   AdvanceSupplyAmt3         { get; set; }
        public long   AdvanceSupplyAmt4         { get; set; }
        public int    FileCnt                   { get; set; }
        public int    OrderStatus               { get; set; }
        public string OrderStatusM              { get; set; }
        public int    OrderRegType              { get; set; }
        public string OrderRegTypeM             { get; set; }
        public string RegDate                   { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
        public string UpdDate                   { get; set; }
        public string UpdAdminID                { get; set; }
        public string UpdAdminName              { get; set; }
        public string AcceptDate                { get; set; }
        public string AcceptAdminID             { get; set; }
        public string AcceptAdminName           { get; set; }
        public string CnlFlag                   { get; set; }
        public string CnlDate                   { get; set; }
        public string CnlAdminID                { get; set; }
        public string CnlAdminName              { get; set; }
        public string CnlReason                 { get; set; }
        public string NetworkNo                 { get; set; }
        public string CargopassOrderNo          { get; set; }
        public string CargopassFlag             { get; set; }
        public string CargopassInfo             { get; set; }
        public int    QuickType                 { get; set; }
        public string QuickTypeM                { get; set; }
        public string TransRateInfo             { get; set; }
        public int    ContractType              { get; set; }
        public string ContractTypeM             { get; set; }
        public int    ContractStatus            { get; set; }
        public string ContractStatusM           { get; set; }
        public string ContractStatusMView       { get; set; }
        public string ContractInfo              { get; set; }
        public double QuickPaySupplyFee         { get; set; }
        public double QuickPayTaxFee            { get; set; }
        public string PickupDispatchCarNo       { get; set; }
        public string PickupCarTonCodeM         { get; set; }
        public string PickupCarDivTypeM         { get; set; }
        public string PickupComName             { get; set; }
        public string PickupComCorpNo           { get; set; }
        public string PickupDriverName          { get; set; }
        public string PickupDriverCell          { get; set; }
        public string PickupPickupDT            { get; set; }
        public string PickupGetDT               { get; set; }
        public string CarDivType1               { get; set; }
        public string CarDivTypeM1              { get; set; }
        public string DriverName1               { get; set; }
        public string DriverCell1               { get; set; }
        public string ComName1                  { get; set; }
        public string ComCorpNo1                { get; set; }
        public string CarDivType2               { get; set; }
        public string CarDivTypeM2              { get; set; }
        public string DriverName2               { get; set; }
        public string DriverCell2               { get; set; }
        public string ComName2                  { get; set; }
        public string ComCorpNo2                { get; set; }
        public string CarDivType3               { get; set; }
        public string CarDivTypeM3              { get; set; }
        public string DriverName3               { get; set; }
        public string DriverCell3               { get; set; }
        public string ComName3                  { get; set; }
        public string ComCorpNo3                { get; set; }
        public string CarDivType4               { get; set; }
        public string CarDivTypeM4              { get; set; }
        public string DriverName4               { get; set; }
        public string DriverCell4               { get; set; }
        public string ComName4                  { get; set; }
        public string ComCorpNo4                { get; set; }
        public string SaleClosingSeqNo          { get; set; }
        public string PurchaseClosingSeqNo      { get; set; }
        public int    InsureExceptKind          { get; set; }
        public string InsureExceptKindM         { get; set; }
    }

    public class ReqOrderList
    {
        public long   OrderNo                 { get; set; }
        public int    CenterCode              { get; set; }
        public int    TransCenterCode         { get; set; }
        public int    ContractCenterCode      { get; set; }
        public int    ListType                { get; set; }
        public int    DateType                { get; set; }
        public string DateFrom                { get; set; }
        public string DateTo                  { get; set; }
        public string OrderLocationCodes      { get; set; }
        public string OrderItemCodes          { get; set; }
        public string OrderStatuses           { get; set; }
        public string OrderClientName         { get; set; }
        public string OrderClientChargeName   { get; set; }
        public string PayClientName           { get; set; }
        public string PayClientChargeName     { get; set; }
        public string PayClientChargeLocation { get; set; }
        public string ConsignorName           { get; set; }
        public string PickupPlace             { get; set; }
        public string GetPlace                { get; set; }
        public string NoteClient              { get; set; }
        public string ComName                 { get; set; }
        public string ComCorpNo               { get; set; }
        public string CarNo                   { get; set; }
        public string DriverName              { get; set; }
        public string GoodsName               { get; set; }
        public string AcceptAdminName         { get; set; }
        public string CsAdminID               { get; set; }
        public string MyChargeFlag            { get; set; }
        public string MyOrderFlag             { get; set; }
        public string CnlFlag                 { get; set; }
        public int    SortType                { get; set; }
        public string AdminID                 { get; set; }
        public string AccessCenterCode        { get; set; }
        public int    PageSize                { get; set; }
        public int    PageNo                  { get; set; }
    }

    public class ResOrderList
    {
        public List<OrderGridModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class ReqOrderCnl
    {
        public int    CenterCode       { get; set; }
        public string OrderNos         { get; set; }
        public int    GradeCode        { get; set; }
        public string AccessCenterCode { get; set; }
        public string CnlReason        { get; set; }
        public string CnlAdminID       { get; set; }
        public string CnlAdminName     { get; set; }
    }

    public class ResOrderCnl
    {
        public int TotalCnt  { get; set; }
        public int CancelCnt { get; set; }
    }

    //비용
    public class OrderPayModel
    {
        public long   SeqNo           { get; set; }
        public int    CenterCode      { get; set; }
        public long   OrderNo         { get; set; }
        public long   GoodsSeqNo      { get; set; }
        public long   DispatchSeqNo   { get; set; }
        public int    PayType         { get; set; }
        public int    TaxKind         { get; set; }
        public string ItemCode        { get; set; }
        public long   ClientCode      { get; set; }
        public string ClientName      { get; set; }
        public long   RefSeqNo        { get; set; }
        public int    CarDivType      { get; set; }
        public long   ComCode         { get; set; }
        public long   CarSeqNo        { get; set; }
        public long   DriverSeqNo     { get; set; }
        public double SupplyAmt       { get; set; }
        public double TaxAmt          { get; set; }
        public string RegAdminID      { get; set; }
        public string RegAdminName    { get; set; }
        public string UpdAdminID      { get; set; }
        public string UpdAdminName    { get; set; }
        public long   TransDtlSeqNo   { get; set; } // 2023-03-16 by shadow54 : 자동운임 수정 건
        public long   ApplySeqNo      { get; set; }
        public int    TransRateStatus { get; set; }

        public OrderPayModel()
        {
            TransDtlSeqNo   = 0;
            ApplySeqNo      = 0;
            TransRateStatus = 1;
        }
    }

    public class OrderPayGridModel
    {
        public string PaySeqNo          { get; set; }
        public string SeqNo             { get; set; }
        public int    CenterCode        { get; set; }
        public string OrderNo           { get; set; }
        public string GoodsSeqNo        { get; set; }
        public string DispatchSeqNo     { get; set; }
        public int    PayType           { get; set; }
        public string PayTypeM          { get; set; }
        public int    TaxKind           { get; set; }
        public string TaxKindM          { get; set; }
        public string ItemCode          { get; set; }
        public string ItemCodeM         { get; set; }
        public string ClientCode        { get; set; }
        public string ClientName        { get; set; }
        public string ClientCorpNo      { get; set; }
        public string RefSeqNo          { get; set; }
        public double OrgAmt            { get; set; }
        public double SupplyAmt         { get; set; }
        public double TaxAmt            { get; set; }
        public int    BillStatus        { get; set; }
        public string ClosingFlag       { get; set; }
        public string ClosingSeqNo      { get; set; }
        public string ClosingAdminID    { get; set; }
        public string ClosingAdminName  { get; set; }
        public string ClosingDate       { get; set; }
        public int    SendStatus        { get; set; }
        public string ClientInfo        { get; set; }
        public string DispatchInfo      { get; set; }
        public int    GoodsDispatchType { get; set; }
        public string RegAdminID        { get; set; }
        public string RegAdminName      { get; set; }
        public string RegDate           { get; set; }
        public string UpdAdminID        { get; set; }
        public string UpdAdminName      { get; set; }
        public string UpdDate           { get; set; }
        public long   TransDtlSeqNo     { get; set; } // 2023-03-16 by shadow54 : 자동운임 수정 건
        public long   ApplySeqNo        { get; set; }
        public int    TransRateStatus   { get; set; }
        public string TransRateStatusM  { get; set; }
    }

    public class ResOrderPayList
    {
        public List<OrderPayGridModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class OrderPayItemModel
    {
        public long SeqNo { get; set; }
        public int CenterCode { get; set; }
        public long OrderNo { get; set; }
        public long GoodsSeqNo { get; set; }
        public int PayType { get; set; }
        public string PayTypeM { get; set; }
        public string ItemCode { get; set; }
        public string ItemCodeM { get; set; }
        public double OrgAmt { get; set; }
        public double SupplyAmt { get; set; }
    }

    public class ReqOrderPayItemList
    {
        public long OrderNo { get; set; }
        public int CenterCode { get; set; }
        public string DateFrom { get; set; }
        public string DateTo { get; set; }
        public string OrderLocationCodes { get; set; }
        public string OrderItemCodes { get; set; }
        public string OrderClientName { get; set; }
        public string OrderClientChargeName { get; set; }
        public string PayClientName { get; set; }
        public string PayClientChargeName { get; set; }
        public string PayClientChargeLocation { get; set; }
        public string ConsignorName { get; set; }
        public string ComName { get; set; }
        public string CarNo { get; set; }
        public string PickupPlace { get; set; }
        public string AcceptAdminName { get; set; }
        public string GoodsItemCode { get; set; }
        public string ShippingCompany { get; set; }
        public string CntrNo { get; set; }
        public string BLNo { get; set; }
        public string MyChargeFlag { get; set; }
        public string MyOrderFlag { get; set; }
        public string CnlFlag { get; set; }
        public string AdminID { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResOrderPayItemList
    {
        public List<OrderPayItemModel> list { get; set; }
        public int RecordCnt { get; set; }
    }


    public class OrderFileModel
    {
        public long   FileSeqNo   { get; set; }
        public int    CenterCode  { get; set; }
        public long   OrderNo     { get; set; }
        public int    FileRegType { get; set; }
        public string FileName    { get; set; }
        public string FileNameNew { get; set; }
        public string FileDir     { get; set; }
        public string FullUrl     { get; set; }
        public string DelFlag     { get; set; }
        public string RegAdminID  { get; set; }
        public string DelAdminID  { get; set; }
    }

    public class OrderFileGridModel
    {
        public string FileSeqNo      { get; set; }
        public string EncFileSeqNo   { get; set; }
        public int    CenterCode     { get; set; }
        public string OrderNo        { get; set; }
        public int    FileRegType    { get; set; }
        public string FileName       { get; set; }
        public string FileNameNew    { get; set; }
        public string EncFileNameNew { get; set; }
        public string FileDir        { get; set; }
        public string TempFlag       { get; set; }
        public string DelFlag        { get; set; }
        public string RegAdminID     { get; set; }
        public string RegDate        { get; set; }
        public string DelAdminID     { get; set; }
        public string DelDate        { get; set; }
    }

    public class ReqOrderFileList
    {
        public long   FileSeqNo        { get; set; }
        public long   OrderNo          { get; set; }
        public int    FileRegType      { get; set; }
        public int    CenterCode       { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResOrderFileList
    {
        public List<OrderFileGridModel> list      { get; set; }
        public int                      RecordCnt { get; set; }
    }

    public class OrderCopyCalendarModel
    {
        public string YMD         { get; set; }
        public int    WeekMonth   { get; set; }
        public int    WeekNum     { get; set; }
        public string WeekStr     { get; set; }
        public string HolidayFlag { get; set; }
        public string OnOff       { get; set; }
        public string MaxDay      { get; set; }
    }

    public class ResOrderCopyCalendarList
    {
        public List<OrderCopyCalendarModel> list      { get; set; }
        public int                          RecordCnt { get; set; }
    }
    public class ReqOrderCopyIns
    {
        public int    CenterCode        { get; set; }
        public string OrderNos          { get; set; }
        public int    OrderCnt          { get; set; }
        public string PickupYMDs        { get; set; }
        public int    GetYMDType        { get; set; }
        public string NoteFlag          { get; set; }
        public string NoteClientFlag    { get; set; }
        public string DispatchFlag      { get; set; }
        public string GoodsFlag         { get; set; }
        public string ArrivalReportFlag { get; set; }
        public string CustomFlag        { get; set; }
        public string BondedFlag        { get; set; }
        public string InTimeFlag        { get; set; }
        public string QuickGetFlag      { get; set; }
        public string TaxChargeFlag     { get; set; }
        public string AdminID           { get; set; }
        public string AdminName         { get; set; }
        public string AdminTeamCode     { get; set; }
    }
    
    public class OrderDispatchCarGridModel
    {
        public string DispatchSeqNo             { get; set; }
        public int    CenterCode                { get; set; }
        public string CenterName                { get; set; }
        public string OrderNo                   { get; set; }
        public string GoodsSeqNo                { get; set; }
        public int    DispatchType              { get; set; }
        public string DispatchTypeM             { get; set; }
        public int    DispatchKind              { get; set; }
        public string DispatchKindM             { get; set; }
        public string DeliveryLocationCode      { get; set; }
        public string DeliveryLocationCodeM     { get; set; }
        public string DispatchPickupPlace       { get; set; }
        public string DispatchPickupChargeName  { get; set; }
        public string DispatchPickupChargeTelNo { get; set; }
        public string DispatchPickupNote        { get; set; }
        public string DispatchGetPlace          { get; set; }
        public string DispatchGetChargeName     { get; set; }
        public string DispatchGetChargeTelNo    { get; set; }
        public string DispatchGetNote           { get; set; }
        public string RefSeqNo                  { get; set; }
        public int    CarDivType                { get; set; }
        public string CarDivTypeM               { get; set; }
        public string ComCode                   { get; set; }
        public string ComName                   { get; set; }
        public string ComCeoName                { get; set; }
        public string ComCorpNo                 { get; set; }
        public string CarNo                     { get; set; }
        public string CarTonCode                { get; set; }
        public string CarTypeCode               { get; set; }
        public string DriverName                { get; set; }
        public string DriverCell                { get; set; }
        public string ContractType              { get; set; }
        public string ContractTypeM             { get; set; }
        public string ContractInfo              { get; set; }
        public string ContractCenterCode        { get; set; }
        public string ContractCenterName        { get; set; }
        public string ContractCenterCorpNo      { get; set; }
        public string ContractOrderNo           { get; set; }
        public string ContractDispatchSeqNo     { get; set; }
        public string ContractStatus            { get; set; }
        public string PickupDT                  { get; set; }
        public string ArrivalDT                 { get; set; }
        public string GetDT                     { get; set; }
        public int    QuickType                 { get; set; }
        public string QuickTypeM                { get; set; }
        public string NetworkNo                 { get; set; }
        public string CargopassOrderNo          { get; set; }
        public string DispatchStatus            { get; set; }
        public string DispatchStatusM           { get; set; }
        public string DispatchAdminID           { get; set; }
        public string DispatchAdminName         { get; set; }
        public string DispatchYMD               { get; set; }
        public string DispatchDate              { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
        public string RegDate                   { get; set; }
        public string UpdAdminID                { get; set; }
        public string UpdAdminName              { get; set; }
        public string UpdDate                   { get; set; }
        public string PickupYMD                 { get; set; }
        public string PickupHM                  { get; set; }
        public string PickupPlaceAddr           { get; set; }
        public string PickupPlaceAddrDtl        { get; set; }
        public string GetYMD                    { get; set; }
        public string GetHM                     { get; set; }
        public string DispatchCarInfo           { get; set; }
        public string InsureTargetFlag          { get; set; }
    }

    public class ResOrderDispatchCarList
    {
        public List<OrderDispatchCarGridModel> list      { get; set; }
        public int                             RecordCnt { get; set; }
    }

    public class ReqOrderDispatchCarStatusUpd
    {
        public long   DispatchSeqNo { get; set; }
        public int    CenterCode    { get; set; }
        public long   OrderNo       { get; set; }
        public string PickupDT      { get; set; }
        public string ArrivalDT     { get; set; }
        public string GetDT         { get; set; }
        public string AdminID       { get; set; }
        public string AdminName     { get; set; }
    }

    public class OrderSQIModel
    {
        public long   SQISeqNo     { get; set; }
        public int    CenterCode   { get; set; }
        public long   OrderNo      { get; set; }
        public long   ItemSeqNo    { get; set; }
        public string YMD          { get; set; }
        public string Detail       { get; set; }
        public string Team         { get; set; }
        public string Contents     { get; set; }
        public string Action       { get; set; }
        public string Cause        { get; set; }
        public string FollowUp     { get; set; }
        public string Cost         { get; set; }
        public string Measure      { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
        public string UpdAdminID   { get; set; }
        public string UpdAdminName { get; set; }
        public string DelFlag      { get; set; }
        public string DelAdminID   { get; set; }
        public string DelAdminName { get; set; }

    }

    public class OrderSQIGridModel
    {
        public string SQISeqNo           { get; set; }
        public int    CenterCode         { get; set; }
        public string CenterName         { get; set; }
        public string OrderNo            { get; set; }
        public string YMD                { get; set; }
        public string Detail             { get; set; }
        public string Team               { get; set; }
        public string Contents           { get; set; }
        public string Action             { get; set; }
        public string Cause              { get; set; }
        public string FollowUp           { get; set; }
        public string Cost               { get; set; }
        public string Measure            { get; set; }
        public string RegAdminID         { get; set; }
        public string RegAdminName       { get; set; }
        public string RegDate            { get; set; }
        public string UpdAdminID         { get; set; }
        public string UpdAdminName       { get; set; }
        public string UpdDate            { get; set; }
        public string DelFlag            { get; set; }
        public string DelAdminID         { get; set; }
        public string DelAdminName       { get; set; }
        public string DelDate            { get; set; }
        public string ItemSeqNo          { get; set; }
        public string ItemNo             { get; set; }
        public string ItemName           { get; set; }
        public string ItemDetail         { get; set; }
        public string ItemScore          { get; set; }
        public string OrderItemCode      { get; set; }
        public string OrderItemCodeM     { get; set; }
        public string OrderLocationCode  { get; set; }
        public string OrderLocationCodeM { get; set; }
        public string OrderClientName    { get; set; }
        public string PayClientName      { get; set; }
        public string ConsignorName      { get; set; }
        public string PickupYMD          { get; set; }
        public string PickupHM           { get; set; }
        public string PickupPlace        { get; set; }
        public string GetYMD             { get; set; }
        public string GetHM              { get; set; }
        public string GetPlace           { get; set; }
        public string AcceptDate         { get; set; }
        public string AcceptAdminName    { get; set; }
        public string CsAdminName        { get; set; }
        public int    CommentCnt         { get; set; }
    }

    public class ReqOrderSQIList
    {
        public long   SQISeqNo           { get; set; }
        public int    CenterCode         { get; set; }
        public long   OrderNo            { get; set; }
        public string DateFrom           { get; set; }
        public string DateTo             { get; set; }
        public string OrderLocationCodes { get; set; }
        public string OrderItemCodes     { get; set; }
        public string OrderClientName    { get; set; }
        public string PayClientName      { get; set; }
        public string ConsignorName      { get; set; }
        public int    OrderType          { get; set; }
        public string DelFlag            { get; set; }
        public string AccessCenterCode   { get; set; }
        public int    PageSize           { get; set; }
        public int    PageNo             { get; set; }
    }

    public class ResOrderSQIList
    {
        public List<OrderSQIGridModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class OrderSQIItemModel
    {
        public long   ItemSeqNo     { get; set; }
        public string CenterCode    { get; set; }
        public int    ItemNo        { get; set; }
        public string ItemName      { get; set; }
        public string ItemDetail    { get; set; }
        public string ItemScore     { get; set; }
        public string OrderItemCode { get; set; }
        public string RegAdminID    { get; set; }
        public string RegAdminName  { get; set; }
        public string RegDate       { get; set; }
        public string DelFlag       { get; set; }
        public string DelAdminID    { get; set; }
        public string DelAdminName  { get; set; }
        public string DelDate       { get; set; }
    }

    public class OrderSQIItemGridModel
    {
        public string ItemSeqNo     { get; set; }
        public string CenterCode    { get; set; }
        public int    ItemNo        { get; set; }
        public string ItemName      { get; set; }
        public string ItemDetail    { get; set; }
        public string ItemScore     { get; set; }
        public string OrderItemCode { get; set; }
        public string RegAdminID    { get; set; }
        public string RegAdminName  { get; set; }
        public string RegDate       { get; set; }
        public string DelFlag       { get; set; }
        public string DelAdminID    { get; set; }
        public string DelAdminName  { get; set; }
        public string DelDate       { get; set; }
    }

    public class ReqOrderSQIItemList
    {
        public long   ItemSeqNo        { get; set; }
        public int    CenterCode       { get; set; }
        public string OrderItemCode    { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResOrderSQIItemList
    {
        public List<OrderSQIItemGridModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class OrderSQICommentModel
    {
        public long   CommentSeqNo { get; set; }
        public int    CenterCode   { get; set; }
        public long   SQISeqNo     { get; set; }
        public string Contents     { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
        public string RegDate      { get; set; }
        public string DelFlag      { get; set; }
        public string DelAdminID   { get; set; }
        public string DelAdminName { get; set; }
        public string DelDate      { get; set; }
    }

    public class OrderSQICommentGridModel
    {
        public string CommentSeqNo { get; set; }
        public int    CenterCode   { get; set; }
        public string SQISeqNo     { get; set; }
        public string Contents     { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
        public string RegDate      { get; set; }
        public string DelFlag      { get; set; }
        public string DelAdminID   { get; set; }
        public string DelAdminName { get; set; }
        public string DelDate      { get; set; }
    }

    public class ReqOrderSQICommentList
    {
        public long   SQISeqNo         { get; set; }
        public int    CenterCode       { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResOrderSQICommentList
    {
        public List<OrderSQICommentGridModel> list      { get; set; }
        public int                            RecordCnt { get; set; }
    }

    //정보망
    public class OrderNetworkModel
    {
        public string OrderNos              { get; set; }
        public string DeliveryLocationCode  { get; set; }
        public long   NetworkSeqNo          { get; set; }
        public int    CenterCode            { get; set; }
        public long   NetworkNo             { get; set; }
        public string NetworkOrderNo        { get; set; }
        public int    NetworkKind           { get; set; }
        public string PickupYMD             { get; set; }
        public string PickupHM              { get; set; }
        public string PickupPlace           { get; set; }
        public string PickupAddr            { get; set; }
        public string PickupAddrDtl         { get; set; }
        public string GetYMD                { get; set; }
        public string GetHM                 { get; set; }
        public string GetPlace              { get; set; }
        public string GetAddr               { get; set; }
        public string GetAddrDtl            { get; set; }
        public string CarTon                { get; set; }
        public string CarTruck              { get; set; }
        public string PickupWay             { get; set; }
        public string GetWay                { get; set; }
        public int    Weight                { get; set; }
        public string Note                  { get; set; }
        public string LayerFlag             { get; set; }
        public string UrgentFlag            { get; set; }
        public string ShuttleFlag           { get; set; }
        public int    QuickType             { get; set; }
        public string QuickTypeM            { get; set; }
        public string PayPlanYMD            { get; set; }
        public double SupplyAmt             { get; set; }
        public double TaxAmt                { get; set; }
        public int    NetworkStatus         { get; set; }
        public string NetworkStatusM        { get; set; }
        public string NetworkMsg            { get; set; }
        public string ComCorpNo             { get; set; }
        public string CarNo                 { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public int    DispatchType          { get; set; }
        public string NetworkRenewalFlag    { get; set; }
        public int    RuleSeqNo             { get; set; }
        public int    RuleType              { get; set; }
        public int    RenewalStartMinute    { get; set; }
        public int    RenewalIntervalMinute { get; set; }
        public double RenewalIntervalPrice  { get; set; }
        public double RenewalPurchasePrice  { get; set; }
        public double RenewalLimitPrice     { get; set; }
        public int    RenewalTryCnt         { get; set; }
        public string RenewalUpdDate        { get; set; }
        public int    RenewalModMinute      { get; set; }
        public int    RenewalModTryCnt      { get; set; }
        public string RenewalModUpdDate     { get; set; }
        public string RegNetworkID          { get; set; }
        public string RegAdminID            { get; set; }
        public string RegAdminName          { get; set; }
        public string RegYMD                { get; set; }
        public string RegDate               { get; set; }
        public string UpdAdminID            { get; set; }
        public string UpdAdminName          { get; set; }
        public string UpdDate               { get; set; }
        public string CnlFlag               { get; set; }
        public string CnlAdminID            { get; set; }
        public string CnlAdminName          { get; set; }
        public string CnlDate               { get; set; }
    }

    public class OrderNetworkGridModel
    {
        public string NetworkSeqNo          { get; set; }
        public int    CenterCode            { get; set; }
        public string CenterName            { get; set; }
        public string NetworkNo             { get; set; }
        public string NetworkOrderNo        { get; set; }
        public int    NetworkKind           { get; set; }
        public string NetworkKindM          { get; set; }
        public string PickupYMD             { get; set; }
        public string PickupHM              { get; set; }
        public string PickupPlace           { get; set; }
        public string PickupAddr            { get; set; }
        public string PickupAddrDtl         { get; set; }
        public string PickupAddrHMM         { get; set; }
        public string GetYMD                { get; set; }
        public string GetHM                 { get; set; }
        public string GetPlace              { get; set; }
        public string GetAddr               { get; set; }
        public string GetAddrDtl            { get; set; }
        public string GetAddrHMM            { get; set; }
        public string CarTon                { get; set; }
        public string CarTruck              { get; set; }
        public string PickupWay             { get; set; }
        public string GetWay                { get; set; }
        public string Weight                { get; set; }
        public string Note                  { get; set; }
        public string LayerFlag             { get; set; }
        public string UrgentFlag            { get; set; }
        public string ShuttleFlag           { get; set; }
        public string QuickType             { get; set; }
        public string QuickTypeM            { get; set; }
        public string PayPlanYMD            { get; set; }
        public double SupplyAmt             { get; set; }
        public double TaxAmt                { get; set; }
        public int    NetworkStatus         { get; set; }
        public string NetworkStatusM        { get; set; }
        public string NetworkMsg            { get; set; }
        public string ComCorpNo             { get; set; }
        public string CarNo                 { get; set; }
        public string DriverName            { get; set; }
        public string DriverCell            { get; set; }
        public int    DispatchType          { get; set; }
        public string DispatchTypeM         { get; set; }
        public string DeliveryLocationCode  { get; set; }
        public string DeliveryLocationCodeM { get; set; }
        public string NetworkRenewalFlag    { get; set; }
        public int    RuleSeqNo             { get; set; }
        public string RuleType              { get; set; }
        public string RenewalStartMinute    { get; set; }
        public string RenewalIntervalMinute { get; set; }
        public string RenewalIntervalPrice  { get; set; }
        public string RenewalPurchasePrice  { get; set; }
        public string RenewalTryCnt         { get; set; }
        public string RenewalUpdDate        { get; set; }
        public string RenewalModMinute      { get; set; }
        public string RenewalModTryCnt      { get; set; }
        public string RenewalModUpdDate     { get; set; }
        public string RenewalLimitPrice     { get; set; }
        public string RegNetworkID          { get; set; }
        public string RegAdminID            { get; set; }
        public string RegAdminName          { get; set; }
        public string RegYMD                { get; set; }
        public string RegDate               { get; set; }
        public string UpdAdminID            { get; set; }
        public string UpdAdminName          { get; set; }
        public string UpdDate               { get; set; }
        public string CnlFlag               { get; set; }
        public string CnlAdminID            { get; set; }
        public string CnlAdminName          { get; set; }
        public string CnlDate               { get; set; }
        public int    DispatchCnt           { get; set; }
        public string DispatchOrderClient   { get; set; }
    }

    public class ReqOrderNetworkList
    {
        public long   NetworkNo          { get; set; }
        public int    CenterCode         { get; set; }
        public string DateFrom           { get; set; }
        public string DateTo             { get; set; }
        public int    NetworkStatus      { get; set; }
        public string NetworkRenewalFlag { get; set; }
        public string CarNo              { get; set; }
        public string DriverName         { get; set; }
        public string DriverCell         { get; set; }
        public string RegAdminName       { get; set; }
        public string AccessCenterCode   { get; set; }
        public int    PageSize           { get; set; }
        public int    PageNo             { get; set; }
    }

    public class ResOrderNetworkList
    {
        public List<OrderNetworkGridModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }


    public class ReqOrderNetworkCnl
    {
        public long   NetworkNo    { get; set; }
        public int    CenterCode   { get; set; }
        public string CnlAdminID   { get; set; }
        public string CnlAdminName { get; set; }
    }

    public class ReqPlanYMDGet
    {
        public string YMD         { get; set; }
        public int    AddDateCnt  { get; set; }
        public string HolidayFlag { get; set; }
    }

    public class ResPlanYMDGet
    {
        public string PlanYMD { get; set; }
    }
    
    public class AdminBookmarkOrderModel
    {
        public int    OrderSeqNo   { get; set; }
        public int    CenterCode   { get; set; }
        public long   OrderNo      { get; set; }
        public string BookmarkName { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
    }

    public class AdminBookmarkOrderGridModel
    {
        public int    OrderSeqNo         { get; set; }
        public int    CenterCode         { get; set; }
        public string OrderNo            { get; set; }
        public string BookmarkName       { get; set; }
        public string RegAdminID         { get; set; }
        public string RegAdminName       { get; set; }
        public string RegDate            { get; set; }
        public string OrderItemCodeM     { get; set; }
        public string OrderLocationCodeM { get; set; }
        public string OrderClientName    { get; set; }
        public string ConsignorName      { get; set; }
    }

    public class ReqAdminBookmarkOrderList
    {
        public int    OrderSeqNo   { get; set; }
        public int    CenterCode   { get; set; }
        public string BookmarkName { get; set; }
        public string RegAdminID   { get; set; }
        public int    PageSize     { get; set; }
        public int    PageNo       { get; set; }
    }

    public class ResAdminBookmarkOrderList
    {
        public List<AdminBookmarkOrderGridModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class AdminBookmarkAddrModel
    {
        public int    AddrSeqNo    { get; set; }
        public string AddrName     { get; set; }
        public string Addr         { get; set; }
        public string AddrDtl      { get; set; }
        public string AddrHMM      { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
        public string RegDate      { get; set; }
    }

    public class ReqAdminBookmarkAddrList
    {
        public int    AddrSeqNo  { get; set; }
        public string AddrName   { get; set; }
        public string Addr       { get; set; }
        public string RegAdminID { get; set; }
        public int    PageSize   { get; set; }
        public int    PageNo     { get; set; }
    }

    public class ResAdminBookmarkAddrList
    {
        public List<AdminBookmarkAddrModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class OrderNetworkDispatchCarGridModel
    {
        public string DispatchSeqNo             { get; set; }
        public int    CenterCode                { get; set; }
        public string CenterName                { get; set; }
        public string OrderNo                   { get; set; }
        public string GoodsSeqNo                { get; set; }
        public int    DispatchType              { get; set; }
        public string DispatchTypeM             { get; set; }
        public int    DispatchKind              { get; set; }
        public string DispatchKindM             { get; set; }
        public string DeliveryLocationCode      { get; set; }
        public string DeliveryLocationCodeM     { get; set; }
        public string DispatchPickupPlace       { get; set; }
        public string DispatchPickupChargeName  { get; set; }
        public string DispatchPickupChargeTelNo { get; set; }
        public string DispatchPickupNote        { get; set; }
        public string DispatchGetPlace          { get; set; }
        public string DispatchGetChargeName     { get; set; }
        public string DispatchGetChargeTelNo    { get; set; }
        public string DispatchGetNote           { get; set; }
        public string RefSeqNo                  { get; set; }
        public int    CarDivType                { get; set; }
        public string CarDivTypeM               { get; set; }
        public string ComCode                   { get; set; }
        public string ComName                   { get; set; }
        public string ComCeoName                { get; set; }
        public string ComCorpNo                 { get; set; }
        public string CarNo                     { get; set; }
        public string CarTonCode                { get; set; }
        public string CarTypeCode               { get; set; }
        public string DriverName                { get; set; }
        public string DriverCell                { get; set; }
        public string ContractType              { get; set; }
        public string ContractTypeM             { get; set; }
        public string ContractInfo              { get; set; }
        public string ContractCenterCode        { get; set; }
        public string ContractCenterName        { get; set; }
        public string ContractCenterCorpNo      { get; set; }
        public string ContractOrderNo           { get; set; }
        public string ContractDispatchSeqNo     { get; set; }
        public string ContractStatus            { get; set; }
        public string PickupDT                  { get; set; }
        public string ArrivalDT                 { get; set; }
        public string GetDT                     { get; set; }
        public int    QuickType                 { get; set; }
        public string QuickTypeM                { get; set; }
        public string NetworkNo                 { get; set; }
        public string DispatchStatus            { get; set; }
        public string DispatchStatusM           { get; set; }
        public string DispatchAdminID           { get; set; }
        public string DispatchAdminName         { get; set; }
        public string DispatchYMD               { get; set; }
        public string DispatchDate              { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
        public string RegDate                   { get; set; }
        public string UpdAdminID                { get; set; }
        public string UpdAdminName              { get; set; }
        public string UpdDate                   { get; set; }
        public string OrderItemCode             { get; set; }
        public string OrderItemCodeM            { get; set; }
        public string OrderLocationCode         { get; set; }
        public string OrderLocationCodeM        { get; set; }
        public string OrderClientName           { get; set; }
        public string PayClientName             { get; set; }
        public string ConsignorName             { get; set; }
        public string PickupYMD                 { get; set; }
        public string GetYMD                    { get; set; }
    }

    public class ResOrderNetworkDispatchList
    {
        public List<OrderNetworkDispatchCarGridModel> list      { get; set; }
        public int                                    RecordCnt { get; set; }
    }

    public class OrderAmtRequestModel
    {
        public long   SeqNo        { get; set; }
        public int    CenterCode   { get; set; }
        public long   OrderNo      { get; set; }
        public int    ReqKind      { get; set; }
        public long   PaySeqNo     { get; set; }
        public double ReqOrgAmt    { get; set; }
        public double ReqSupplyAmt { get; set; }
        public double ReqTaxAmt    { get; set; }
        public string ReqReason    { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
    }

    public class ReqOrderAmtRequestStatusUpd
    {
        public long   SeqNo        { get; set; }
        public int    ReqStatus    { get; set; }
        public string UpdAdminID   { get; set; }
        public string UpdAdminName { get; set; }
    }

    public class ReqOrderAmtRequestCnl
    {
        public long   SeqNo        { get; set; }
        public char   CnlFlag      { get; set; }
        public string CnlAdminID   { get; set; }
        public string CnlAdminName { get; set; }
    }

    public class OrderAmtRequestGridModel
    {
        public int    PayType             { get; set; }
        public string PayTypeM            { get; set; }
        public int    CenterCode          { get; set; }
        public string CenterName          { get; set; }
        public string OrderNo             { get; set; }
        public string OrderItemCode       { get; set; }
        public string OrderItemCodeM      { get; set; }
        public string OrderLocationCode   { get; set; }
        public string OrderLocationCodeM  { get; set; }
        public string OrderStatusM        { get; set; }
        public string ConsignorName       { get; set; }
        public string OrderClientName     { get; set; }
        public string PayClientName       { get; set; }
        public string PickupYMD           { get; set; }
        public string PickupPlaceFullAddr { get; set; }
        public string GetYMD              { get; set; }
        public string GetPlaceFullAddr    { get; set; }
        public string AcceptAdminName     { get; set; }
        public string AcceptDate          { get; set; }
        public string CarTonCodeM         { get; set; }
        public string CarTypeCodeM        { get; set; }
        public string CarNo               { get; set; }
        public double UnitAmt             { get; set; }
        public double ExtUnitAmt          { get; set; } // 2023-03-16 by shadow54 : 자동운임 수정 건
        public double FixedUnitAmt        { get; set; }
        public double FixedExtUnitAmt     { get; set; }
        public string PaySeqNo            { get; set; }
        public string ItemCode            { get; set; }
        public string ItemCodeM           { get; set; }
        public double SupplyAmt           { get; set; }
        public double TaxAmt              { get; set; }
        public string ReqSeqNo            { get; set; }
        public double OrgOrgAmt           { get; set; }
        public double OrgSupplyAmt        { get; set; }
        public double OrgTaxAmt           { get; set; }
        public double ReqSupplyAmt        { get; set; }
        public double ReqTaxAmt           { get; set; }
        public int    ReqStatus           { get; set; }
        public string ReqStatusM          { get; set; }
        public string ReqReason           { get; set; }
        public string ReqStatusInfo       { get; set; }
        public string CarFixedFlag        { get; set; }
    }

    public class ReqOrderAmtRequestList
    {
        public long   DtlSeqNo         { get; set; }
        public long   OrderNo          { get; set; }
        public int    CenterCode       { get; set; }
        public int    ListType         { get; set; }
        public int    PayType          { get; set; }
        public int    DateType         { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string ConsignorName    { get; set; }
        public string PayClientName    { get; set; }
        public string CarNo            { get; set; }
        public string MyChargeFlag     { get; set; }
        public string MyOrderFlag      { get; set; }
        public string ReqAdminName     { get; set; }
        public int    ReqStatus        { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResOrderAmtRequestList
    {
        public List<OrderAmtRequestGridModel> list { get; set; }
        public int RecordCnt { get; set; }
    }

    public class OrderAmtRequestOrderGridModel
    {
        public int    SeqNo               { get; set; }
        public int    PayType             { get; set; }
        public string PayTypeM            { get; set; }
        public string ItemCode            { get; set; }
        public string ItemCodeM           { get; set; }
        public int    CenterCode          { get; set; }
        public string CenterName          { get; set; }
        public string OrderNo             { get; set; }
        public string OrderItemCode       { get; set; }
        public string OrderItemCodeM      { get; set; }
        public string OrderStatusM        { get; set; }
        public string ConsignorName       { get; set; }
        public string OrderClientName     { get; set; }
        public string PayClientName       { get; set; }
        public string PickupYMD           { get; set; }
        public string PickupPlaceFullAddr { get; set; }
        public string GetYMD              { get; set; }
        public string GetPlaceFullAddr    { get; set; }
        public string AcceptAdminName     { get; set; }
        public string AcceptDate          { get; set; }
        public string CarTonCodeM         { get; set; }
        public string CarTypeCodeM        { get; set; }
        public string CarNo               { get; set; }
        public double UnitAmt             { get; set; }
        public double ExtUnitAmt          { get; set; } // 2023-03-16 by shadow54 : 자동운임 수정 건
        public double FixedUnitAmt        { get; set; }
        public double FixedExtUnitAmt     { get; set; }
        public string PaySeqNo            { get; set; }
        public double SupplyAmt           { get; set; }
        public double TaxAmt              { get; set; }
        public string ReqSeqNo            { get; set; }
        public double OrgOrgAmt           { get; set; }
        public double OrgSupplyAmt        { get; set; }
        public double OrgTaxAmt           { get; set; }
        public double ReqSupplyAmt        { get; set; }
        public double ReqTaxAmt           { get; set; }
        public int    ReqStatus           { get; set; }
        public string ReqStatusM          { get; set; }
        public string ReqReason           { get; set; }
        public string ReqStatusInfo       { get; set; }
        public string BtnRegRequest       { get; set; }
        public string CarFixedFlag        { get; set; }
    }

    public class ReqOrderAmtRequestOrderList
    {
        public long   SeqNo            { get; set; }
        public long   OrderNo          { get; set; }
        public int    CenterCode       { get; set; }
        public int    ListType         { get; set; }
        public int    PayType          { get; set; }
        public int    DateType         { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string ConsignorName    { get; set; }
        public string PayClientName    { get; set; }
        public string CarNo            { get; set; }
        public string MyChargeFlag     { get; set; }
        public string MyOrderFlag      { get; set; }
        public string ReqAdminName     { get; set; }
        public int    ReqStatus        { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResOrderAmtRequestOrderList
    {
        public List<OrderAmtRequestOrderGridModel> list      { get; set; }
        public int                                 RecordCnt { get; set; }
    }

    public class ReqDomesticOrderCount
    {
        public string AccessCenterCode { get; set; }
        public string AdminID          { get; set; }
    }

    public class ResDomesticOrderCount
    {
        public int WebRegRequestCnt   { get; set; }
        public int WebUpdRequestCnt   { get; set; }
        public int AmtRequestCnt      { get; set; }
        public int NetworkDispatchCnt { get; set; }
    }

    public class ReqInoutOrderCount
    {
        public string AccessCenterCode { get; set; }
    }

    public class ResInoutOrderCount
    {
        public int WebRegRequestCnt { get; set; }
        public int WebUpdRequestCnt { get; set; }
        public int AmtRequestCnt    { get; set; }
    }

    public class ReqOrderTransIns
    {
        public int    CenterCode       { get; set; }
        public long   OrderNo          { get; set; }
        public int    TargetCenterCode { get; set; }
        public double SaleOrgAmt       { get; set; }
        public string AdminID          { get; set; }
        public string AdminName        { get; set; }
        public string AdminTelNo       { get; set; }
        public string AdminMobileNo    { get; set; }
    }

    public class ResOrderTransIns
    {
        public long TargetOrderNo       { get; set; }
        public long TargetDispatchSeqNo { get; set; }
        public long TargetGoodsSeqNo    { get; set; }
        public long TargetAddSeqNo      { get; set; }
    }

    public class ReqOrderContractIns
    {
        public int    CenterCode         { get; set; }
        public long   OrderNo            { get; set; }
        public int    ContractCenterCode { get; set; }
        public int    DispatchType       { get; set; }
        public string AdminID            { get; set; }
        public string AdminName          { get; set; }
        public string AdminTelNo         { get; set; }
        public string AdminMobileNo      { get; set; }
    }

    public class ResOrderContractIns
    {
        public long ContractOrderNo       { get; set; }
        public long ContractDispatchSeqNo { get; set; }
        public long ContractGoodsSeqNo    { get; set; }
        public long ContractSaleSeqNo     { get; set; }
        public long ContractAddSeqNo      { get; set; }
    }

    public class DGFOrderGridModel
    {
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
        public string OrderNo              { get; set; }
        public string GoodsSeqNo           { get; set; }
        public string DispatchSeqNo        { get; set; }
        public string OrderItemCode        { get; set; }
        public string OrderItemCodeM       { get; set; }
        public string OrderLocationCode    { get; set; }
        public string OrderLocationCodeM   { get; set; }
        public string OrderClientCode      { get; set; }
        public string OrderClientName      { get; set; }
        public string PayClientCode        { get; set; }
        public string PayClientName        { get; set; }
        public string PayClientChargeName  { get; set; }
        public string ConsignorCode        { get; set; }
        public string ConsignorName        { get; set; }
        public string PickupYMD            { get; set; }
        public string PickupHM             { get; set; }
        public string PickupPlace          { get; set; }
        public string PickupPlacePost      { get; set; }
        public string PickupPlaceAddr      { get; set; }
        public string PickupPlaceAddrDtl   { get; set; }
        public string PickupPlaceFullAddr  { get; set; }
        public string PickupPlaceSido      { get; set; }
        public string PickupPlaceGugun     { get; set; }
        public string PickupPlaceDong      { get; set; }
        public string PickupPlaceLocalCode { get; set; }
        public string PickupPlaceLocalName { get; set; }
        public string PickupDT             { get; set; }
        public string GetYMD               { get; set; }
        public string GetHM                { get; set; }
        public string GetPlace             { get; set; }
        public string GetPlacePost         { get; set; }
        public string GetPlaceAddr         { get; set; }
        public string GetPlaceAddrDtl      { get; set; }
        public string GetPlaceFullAddr     { get; set; }
        public string GetPlaceSido         { get; set; }
        public string GetPlaceGugun        { get; set; }
        public string GetPlaceDong         { get; set; }
        public string GetPlaceChargeName   { get; set; }
        public string GetPlaceLocalCode    { get; set; }
        public string GetPlaceLocalName    { get; set; }
        public string GetDT                { get; set; }
        public string BondedFlag           { get; set; }
        public int    GoodsDispatchType    { get; set; }
        public string GoodsDispatchTypeM   { get; set; }
        public int    Length               { get; set; }
        public double CBM                  { get; set; }
        public string Quantity             { get; set; }
        public int    Volume               { get; set; }
        public double Weight               { get; set; }
        public double AllSupplyAmt         { get; set; }
        public double DriverSupplyAmt      { get; set; }
        public double WarehouseSupplyAmt   { get; set; }
        public double EtcSupplyAmt         { get; set; }
        public string Nation               { get; set; }
        public string Hawb                 { get; set; }
        public string Mawb                 { get; set; }
        public string CarNo                { get; set; }
        public string DriverName           { get; set; }
        public string DriverCell           { get; set; }
        public string NoteInside           { get; set; }
        public string NoteClient           { get; set; }
        public string RegDate              { get; set; }
        public string RegAdminID           { get; set; }
        public string RegAdminName         { get; set; }
        public string UpdDate              { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdAdminName         { get; set; }
        public string AcceptDate           { get; set; }
        public string AcceptAdminID        { get; set; }
        public string AcceptAdminName      { get; set; }
    }

    public class ReqDGFOrderList
    {
        public int    CenterCode         { get; set; }
        public int    DateType           { get; set; }
        public string DateFrom           { get; set; }
        public string DateTo             { get; set; }
        public string OrderItemCodes     { get; set; }
        public string OrderLocationCodes { get; set; }
        public string PayClientCorpNos   { get; set; }
        public string AccessCenterCode   { get; set; }
        public int    PageSize           { get; set; }
        public int    PageNo             { get; set; }
    }

    public class ResDGFOrderList
    {
        public List<DGFOrderGridModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class GMOrderGridModel
    {
        public int    CenterCode         { get; set; }
        public string CenterName         { get; set; }
        public string OrderNo            { get; set; }
        public string OrderItemCode      { get; set; }
        public string OrderItemCodeM     { get; set; }
        public string OrderLocationCode  { get; set; }
        public string OrderLocationCodeM { get; set; }
        public string OrderClientCode    { get; set; }
        public string OrderClientName    { get; set; }
        public string PayClientCode      { get; set; }
        public string PayClientName      { get; set; }
        public string ConsignorCode      { get; set; }
        public string ConsignorName      { get; set; }
        public string PickupYMD          { get; set; }
        public string PickupHM           { get; set; }
        public string PickupYMDHM        { get; set; }
        public string NoteClient         { get; set; }
        public string GoodsItemCode      { get; set; }
        public string GoodsItemCodeM     { get; set; }
        public int    Length             { get; set; }
        public int    Width             { get; set; }
        public int    Height             { get; set; }
        public double CBM                { get; set; }
        public int    Volume             { get; set; }
        public int    PTVolume           { get; set; }
        public int    CTVolume           { get; set; }
        public double Weight             { get; set; }
        public string Quantity           { get; set; }
        public string Nation             { get; set; }
        public string Hawb               { get; set; }
        public string Mawb               { get; set; }
        public string InvoiceNo          { get; set; }
        public string LocationAlias      { get; set; }
        public string Origin             { get; set; }
        public string Shipper            { get; set; }
    }

    public class ReqGMOrderList
    {
        public int    CenterCode         { get; set; }
        public int    DateType           { get; set; }
        public string DateFrom           { get; set; }
        public string DateTo             { get; set; }
        public string Plant              { get; set; }
        public string LocationAlias      { get; set; }
        public string Shipper            { get; set; }
        public string OrderClientCorpNos { get; set; }
        public string PayClientCorpNos   { get; set; }
        public string AccessCenterCode   { get; set; }
        public int    PageSize           { get; set; }
        public int    PageNo             { get; set; }
    }

    public class ResGMOrderList
    {
        public List<GMOrderGridModel> list      { get; set; }
        public int                    RecordCnt { get; set; }
    }

    public class GMOrderModel
    {
        public int    CenterCode                { get; set; }
        public long   OrderNo                   { get; set; }
        public long   AddSeqNo                  { get; set; }
        public long   GoodsSeqNo                { get; set; }
        public long   DispatchSeqNo             { get; set; }
        public string OrderLocation             { get; set; }
        public string OrderItemCode             { get; set; }
        public string PickupYMD                 { get; set; }
        public string PickupHM                  { get; set; }
        public string GetYMD                    { get; set; }
        public string GetHM                     { get; set; }
        public long   OrderClientCode           { get; set; }
        public string OrderClientName           { get; set; }
        public string OrderClientChargeName     { get; set; }
        public string OrderClientChargePosition { get; set; }
        public string OrderClientChargeTelExtNo { get; set; }
        public string OrderClientChargeTelNo    { get; set; }
        public string OrderClientChargeCell     { get; set; }
        public long   PayClientCode             { get; set; }
        public string PayClientName             { get; set; }
        public string PayClientChargeName       { get; set; }
        public string PayClientChargePosition   { get; set; }
        public string PayClientChargeTelExtNo   { get; set; }
        public string PayClientChargeTelNo      { get; set; }
        public string PayClientChargeCell       { get; set; }
        public string PayClientChargeLocation   { get; set; }
        public string GetPlace                  { get; set; }
        public string GetPlaceChargeName        { get; set; }
        public string GetPlaceChargePosition    { get; set; }
        public string GetPlaceChargeTelExtNo    { get; set; }
        public string GetPlaceChargeTelNo       { get; set; }
        public string GetPlaceChargeCell        { get; set; }
        public string GetPlacePost              { get; set; }
        public string GetPlaceAddr              { get; set; }
        public string GetPlaceAddrDtl           { get; set; }
        public string GetPlaceFullAddr          { get; set; }
        public string GetPlaceLocalCode         { get; set; }
        public string GetPlaceLocalName         { get; set; }
        public string NoteClient                { get; set; }
        public int    Length                    { get; set; }
        public double CBM                       { get; set; }
        public string Quantity                  { get; set; }
        public int    Volume                    { get; set; }
        public double Weight                    { get; set; }
        public string Nation                    { get; set; }
        public string Hawb                      { get; set; }
        public string Mawb                      { get; set; }
        public string InvoiceNo                 { get; set; }
        public string GMOrderType               { get; set; }
        public string GMTripID                  { get; set; }
        public string LocationAlias             { get; set; }
        public string Shipper                   { get; set; }
        public string Origin                    { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
    }

    public class OrderPayItemStatementGridModel
    {
        public int    PaySeqNo            { get; set; }
        public string SeqNo               { get; set; }
        public int    CenterCode          { get; set; }
        public string CenterName          { get; set; }
        public string OrderNo             { get; set; }
        public string GoodsSeqNo          { get; set; }
        public string DispatchSeqNo       { get; set; }
        public int    PayType             { get; set; }
        public string PayTypeM            { get; set; }
        public int    TaxKind             { get; set; }
        public string TaxKindM            { get; set; }
        public string ItemCode            { get; set; }
        public string ItemCodeM           { get; set; }
        public string ClientCode          { get; set; }
        public string ClientName          { get; set; }
        public string CarNo               { get; set; }
        public string ComName             { get; set; }
        public double OrgAmt              { get; set; }
        public double SupplyAmt           { get; set; }
        public double TaxAmt              { get; set; }
        public string PickupYMD           { get; set; }
        public string OrderLocationCode   { get; set; }
        public string OrderLocationCodeM  { get; set; }
        public string OrderItemCode       { get; set; }
        public string OrderItemCodeM      { get; set; }
        public string FTLFlag             { get; set; }
        public int    DispatchType        { get; set; }
        public string DispatchTypeM       { get; set; }
        public string OrderClientCode     { get; set; }
        public string OrderClientName     { get; set; }
        public string PayClientCode       { get; set; }
        public string PayClientName       { get; set; }
        public string PayClientChargeName { get; set; }
        public string ConsignorName       { get; set; }
        public string PickupPlace         { get; set; }
        public string GetPlace            { get; set; }
        public string NoteInside          { get; set; }
        public string AcceptAdminName     { get; set; }
        public string Nation              { get; set; }
        public string Hawb                { get; set; }
        public string Mawb                { get; set; }
        public int    Volume              { get; set; }
        public double Weight              { get; set; }
        public double CBM                 { get; set; }
        public int    Length              { get; set; }
        public string Quantity            { get; set; }
        public string CarTonCodeM         { get; set; }
        public string CarTypeCodeM        { get; set; }
        public string GoodsName           { get; set; }
        public string GoodsItemCodeM      { get; set; }
        public string GoodsRunTypeM       { get; set; }
        public string CarFixedFlagM       { get; set; }
        public string LayoverFlagM        { get; set; }
        public string PickupCY            { get; set; }
        public string GetCY               { get; set; }
        public string BLNo                { get; set; }
        public string ClosingSeqNo        { get; set; }
    }

    public class ReqOrderPayItemStatementList
    {
        public long   OrderNo            { get; set; }
        public int    CenterCode         { get; set; }
        public int    ListType           { get; set; }
        public int    DateType           { get; set; }
        public string DateFrom           { get; set; }
        public string DateTo             { get; set; }
        public string OrderLocationCodes { get; set; }
        public string OrderItemCodes     { get; set; }
        public string OrderClientName    { get; set; }
        public string PayClientName      { get; set; }
        public string ConsignorName      { get; set; }
        public string PayItemCode        { get; set; }
        public int    DispatchType       { get; set; }
        public string CarNo              { get; set; }
        public string AccessCenterCode   { get; set; }
    }

    public class ResOrderPayItemStatementList
    {
        public List<OrderPayItemStatementGridModel> list      { get; set; }
        public int                                  RecordCnt { get; set; }
    }

    public class OrderPayStatementGridModel
    {
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
        public string OrderNo              { get; set; }
        public string OrderItemCode        { get; set; }
        public string OrderItemCodeM       { get; set; }
        public string OrderLocationCode    { get; set; }
        public string OrderLocationCodeM   { get; set; }
        public string OrderClientCode      { get; set; }
        public string OrderClientName      { get; set; }
        public string PayClientCode        { get; set; }
        public string PayClientName        { get; set; }
        public string PayClientChargeName  { get; set; }
        public string ConsignorCode        { get; set; }
        public string ConsignorName        { get; set; }
        public string PickupYMD            { get; set; }
        public string PickupPlace          { get; set; }
        public string PickupPlaceAddr      { get; set; }
        public string PickupPlaceAddrDtl   { get; set; }
        public string PickupPlaceFullAddr  { get; set; }
        public string PickupPlaceLocalCode { get; set; }
        public string PickupPlaceLocalName { get; set; }
        public string PickupPlaceNote      { get; set; }
        public string GetYMD               { get; set; }
        public string GetPlace             { get; set; }
        public string GetPlaceAddr         { get; set; }
        public string GetPlaceAddrDtl      { get; set; }
        public string GetPlaceFullAddr     { get; set; }
        public string GetPlaceLocalCode    { get; set; }
        public string GetPlaceLocalName    { get; set; }
        public string GetPlaceNote         { get; set; }
        public string GoodsSeqNo           { get; set; }
        public int    Length               { get; set; }
        public double CBM                  { get; set; }
        public int    Volume               { get; set; }
        public double Weight               { get; set; }
        public string Quantity             { get; set; }
        public string Nation               { get; set; }
        public string Hawb                 { get; set; }
        public string Mawb                 { get; set; }
        public string NoteInside           { get; set; }
        public string NoteClient           { get; set; }
        public string AcceptAdminName      { get; set; }
        public double TotalSupplyAmt       { get; set; }
        public double ArrivalSupplyAmt     { get; set; }
        public double OP001                { get; set; } = 0;
        public double OP002                { get; set; } = 0;
        public double OP003                { get; set; } = 0;
        public double OP004                { get; set; } = 0;
        public double OP005                { get; set; } = 0;
        public double OP006                { get; set; } = 0;
        public double OP007                { get; set; } = 0;
        public double OP008                { get; set; } = 0;
        public double OP009                { get; set; } = 0;
        public double OP010                { get; set; } = 0;
        public double OP011                { get; set; } = 0;
        public double OP012                { get; set; } = 0;
        public double OP013                { get; set; } = 0;
        public double OP014                { get; set; } = 0;
        public double OP015                { get; set; } = 0;
        public double OP016                { get; set; } = 0;
        public double OP017                { get; set; } = 0;
        public double OP018                { get; set; } = 0;
        public double OP019                { get; set; } = 0;
        public double OP020                { get; set; } = 0;
        public double OP021                { get; set; } = 0;
        public double OP022                { get; set; } = 0;
        public double OP023                { get; set; } = 0;
        public double OP024                { get; set; } = 0;
        public double OP025                { get; set; } = 0;
        public double OP026                { get; set; } = 0;
        public double OP027                { get; set; } = 0;
        public double OP028                { get; set; } = 0;
        public double OP029                { get; set; } = 0;
        public double OP030                { get; set; } = 0;
        public double OP031                { get; set; } = 0;
        public double OP032                { get; set; } = 0;
        public double OP033                { get; set; } = 0;
        public double OP034                { get; set; } = 0;
        public double OP035                { get; set; } = 0;
        public double OP036                { get; set; } = 0;
        public double OP037                { get; set; } = 0;
        public double OP038                { get; set; } = 0;
        public double OP039                { get; set; } = 0;
        public double OP040                { get; set; } = 0;
        public double OP041                { get; set; } = 0;
        public double OP042                { get; set; } = 0;
        public double OP043                { get; set; } = 0;
        public double OP044                { get; set; } = 0;
        public double OP045                { get; set; } = 0;
        public double OP046                { get; set; } = 0;
        public double OP047                { get; set; } = 0;
        public double OP048                { get; set; } = 0;
        public double OP049                { get; set; } = 0;
        public double OP050                { get; set; } = 0;
        public double OP051                { get; set; } = 0;
        public double OP052                { get; set; } = 0;
        public double OP053                { get; set; } = 0;
        public double OP054                { get; set; } = 0;
        public double OP055                { get; set; } = 0;
        public double OP056                { get; set; } = 0;
        public double OP057                { get; set; } = 0;
        public double OP058                { get; set; } = 0;
        public double OP059                { get; set; } = 0;
        public double OP060                { get; set; } = 0;
        public double OP061                { get; set; } = 0;
        public double OP062                { get; set; } = 0;
        public double OP063                { get; set; } = 0;
        public double OP064                { get; set; } = 0;
        public double OP065                { get; set; } = 0;
        public double OP066                { get; set; } = 0;
        public double OP067                { get; set; } = 0;
        public double OP068                { get; set; } = 0;
        public double OP069                { get; set; } = 0;
        public double OP070                { get; set; } = 0;
        public double OP071                { get; set; } = 0;
        public double OP072                { get; set; } = 0;
        public double OP073                { get; set; } = 0;
        public double OP074                { get; set; } = 0;
        public double OP075                { get; set; } = 0;
        public double OP076                { get; set; } = 0;
        public double OP077                { get; set; } = 0;
        public double OP078                { get; set; } = 0;
        public double OP079                { get; set; } = 0;
        public double OP080                { get; set; } = 0;
        public double OP081                { get; set; } = 0;
        public double OP082                { get; set; } = 0;
        public double OP083                { get; set; } = 0;
        public double OP084                { get; set; } = 0;
        public double OP085                { get; set; } = 0;
        public double OP086                { get; set; } = 0;
        public double OP087                { get; set; } = 0;
        public double OP088                { get; set; } = 0;
        public double OP089                { get; set; } = 0;
        public double OP090                { get; set; } = 0;
        public double OP091                { get; set; } = 0;
        public double OP092                { get; set; } = 0;
        public double OP093                { get; set; } = 0;
        public double OP094                { get; set; } = 0;
        public double OP095                { get; set; } = 0;
        public double OP096                { get; set; } = 0;
        public double OP097                { get; set; } = 0;
        public double OP098                { get; set; } = 0;
        public double OP099                { get; set; } = 0;
        public double OP100                { get; set; } = 0;
        public double OP101                { get; set; } = 0;
        public double OP102                { get; set; } = 0;
        public double OP103                { get; set; } = 0;
        public double OP104                { get; set; } = 0;
        public double OP105                { get; set; } = 0;
        public double OP106                { get; set; } = 0;
        public double OP107                { get; set; } = 0;
        public double OP108                { get; set; } = 0;
        public double OP109                { get; set; } = 0;
        public double OP110                { get; set; } = 0;
        public double OP111                { get; set; } = 0;
        public double OP112                { get; set; } = 0;
        public double OP113                { get; set; } = 0;
        public double OP114                { get; set; } = 0;
        public double OP115                { get; set; } = 0;
        public double OP116                { get; set; } = 0;
        public double OP117                { get; set; } = 0;
        public double OP118                { get; set; } = 0;
        public double OP119                { get; set; } = 0;
        public double OP120                { get; set; } = 0;
        public double OP121                { get; set; } = 0;
        public double OP122                { get; set; } = 0;
        public double OP123                { get; set; } = 0;
        public double OP124                { get; set; } = 0;
        public double OP125                { get; set; } = 0;
        public double OP126                { get; set; } = 0;
        public double OP127                { get; set; } = 0;
        public double OP128                { get; set; } = 0;
        public double OP129                { get; set; } = 0;
        public double OP130                { get; set; } = 0;
        public double OP131                { get; set; } = 0;
        public double OP132                { get; set; } = 0;
        public double OP133                { get; set; } = 0;
        public double OP134                { get; set; } = 0;
        public double OP135                { get; set; } = 0;
        public double OP136                { get; set; } = 0;
        public double OP137                { get; set; } = 0;
        public double OP138                { get; set; } = 0;
        public double OP139                { get; set; } = 0;
        public double OP140                { get; set; } = 0;
        public double OP141                { get; set; } = 0;
        public double OP142                { get; set; } = 0;
        public double OP143                { get; set; } = 0;
        public double OP144                { get; set; } = 0;
        public double OP145                { get; set; } = 0;
        public double OP146                { get; set; } = 0;
        public double OP147                { get; set; } = 0;
        public double OP148                { get; set; } = 0;
        public double OP149                { get; set; } = 0;
        public double OP150                { get; set; } = 0;
        public double OP151                { get; set; } = 0;
        public double OP152                { get; set; } = 0;
        public double OP153                { get; set; } = 0;
        public double OP154                { get; set; } = 0;
        public double OP155                { get; set; } = 0;
        public double OP156                { get; set; } = 0;
        public double OP157                { get; set; } = 0;
        public double OP158                { get; set; } = 0;
        public double OP159                { get; set; } = 0;
        public double OP160                { get; set; } = 0;
        public double OP161                { get; set; } = 0;
        public double OP162                { get; set; } = 0;
        public double OP163                { get; set; } = 0;
        public double OP164                { get; set; } = 0;
        public double OP165                { get; set; } = 0;
        public double OP166                { get; set; } = 0;
        public double OP167                { get; set; } = 0;
        public double OP168                { get; set; } = 0;
        public double OP169                { get; set; } = 0;
        public double OP170                { get; set; } = 0;
        public double OP171                { get; set; } = 0;
        public double OP172                { get; set; } = 0;
        public double OP173                { get; set; } = 0;
        public double OP174                { get; set; } = 0;
        public double OP175                { get; set; } = 0;
        public double OP176                { get; set; } = 0;
        public double OP177                { get; set; } = 0;
        public double OP178                { get; set; } = 0;
        public double OP179                { get; set; } = 0;
        public double OP180                { get; set; } = 0;
        public double OP181                { get; set; } = 0;
        public double OP182                { get; set; } = 0;
        public double OP183                { get; set; } = 0;
        public double OP184                { get; set; } = 0;
        public double OP185                { get; set; } = 0;
        public double OP186                { get; set; } = 0;
        public double OP187                { get; set; } = 0;
        public double OP188                { get; set; } = 0;
        public double OP189                { get; set; } = 0;
        public double OP190                { get; set; } = 0;
        public double OP191                { get; set; } = 0;
        public double OP192                { get; set; } = 0;
        public double OP193                { get; set; } = 0;
        public double OP194                { get; set; } = 0;
        public double OP195                { get; set; } = 0;
        public double OP196                { get; set; } = 0;
        public double OP197                { get; set; } = 0;
        public double OP198                { get; set; } = 0;
        public double OP199                { get; set; } = 0;
        public double OP200                { get; set; } = 0;
    }

    public class ReqOrderPayStatementList
    {
        public long   OrderNo             { get; set; }
        public string OrderNos            { get; set; }
        public int    CenterCode          { get; set; }
        public int    PayType             { get; set; }
        public int    ListType            { get; set; }
        public int    DateType            { get; set; }
        public string DateFrom            { get; set; }
        public string DateTo              { get; set; }
        public string OrderLocationCodes  { get; set; }
        public string OrderItemCodes      { get; set; }
        public string OrderClientName     { get; set; }
        public long   PayClientCode       { get; set; }
        public string PayClientName       { get; set; }
        public string ConsignorName       { get; set; }
        public string CsAdminID           { get; set; }
        public string PayClientChargeName { get; set; }
        public string AccessCenterCode    { get; set; }
    }

    public class ResOrderPayStatementList
    {
        public List<OrderPayStatementGridModel> list                  { get; set; }
        public int                              RecordCnt             { get; set; }
        public double                           TotalSupplyAmt        { get; set; }
        public double                           TotalArrivalSupplyAmt { get; set; }
        public double                           TotalTaxAmt           { get; set; }
        public double                           TotalOrgAmt           { get; set; }
    }

    public class OrderPayStatementPayItemGridModel
    {
        public int    CenterCode { get; set; }
        public string OrderNo    { get; set; }
        public string GoodsSeqNo { get; set; }
        public string ItemCode   { get; set; }
        public string ItemCodeM  { get; set; }
        public double OrgAmt     { get; set; }
        public double SupplyAmt  { get; set; }
        public double TaxAmt     { get; set; }
    }

    public class ReqOrderPayStatementPayItemList
    {
        public long   OrderNo             { get; set; }
        public int    CenterCode          { get; set; }
        public int    PayType             { get; set; }
        public int    ListType            { get; set; }
        public int    DateType            { get; set; }
        public string DateFrom            { get; set; }
        public string DateTo              { get; set; }
        public string OrderLocationCodes  { get; set; }
        public string OrderItemCodes      { get; set; }
        public string OrderClientName     { get; set; }
        public long   PayClientCode       { get; set; }
        public string PayClientName       { get; set; }
        public string ConsignorName       { get; set; }
        public string CsAdminID           { get; set; }
        public string OrderNos            { get; set; }
        public string PayClientChargeName { get; set; }
        public string AccessCenterCode    { get; set; }
    }

    public class ResOrderPayStatementPayItemList
    {
        public List<OrderPayStatementPayItemGridModel> list      { get; set; }
        public int                                     RecordCnt { get; set; }
    }
    
    public class ReqOrderOneCnl
    {
        public int    CenterCode       { get; set; }
        public long   OrderNo          { get; set; }
        public string CnlReason        { get; set; }
        public string CnlAdminID       { get; set; }
        public string CnlAdminName     { get; set; }
        public long   ChgSeqNo         { get; set; }
    }

    public class ReqOrderTransSaleUpd
    {
        public int    CenterCode { get; set; }
        public long   OrderNo    { get; set; }
        public string SaleSeqNos { get; set; }
        public string ProcTypes  { get; set; }
        public string TaxKinds   { get; set; }
        public string ItemCodes  { get; set; }
        public string SupplyAmts { get; set; }
        public string TaxAmts    { get; set; }
        public string AdminID    { get; set; }
        public string AdminName  { get; set; }
    }

    public class ReqInoutOrderContract
    {
        public int    CenterCode { get; set; }
        public long   OrderNo    { get; set; }
        public string AdminID    { get; set; }
    }

    public class ResInoutOrderContract
    {
        public int    ContractType          { get; set; }
        public string ContractInfo          { get; set; }
        public int    ContractCenterCode    { get; set; }
        public string ContractOrderNo       { get; set; }
        public string ContractDispatchSeqNo { get; set; }
        public int    ContractStatus        { get; set; }
    }

    public class ResOrderUpd
    {
        public string SaleClosingFlag     { get; set; }
        public string PurchaseClosingFlag { get; set; }

        public ResOrderUpd()
        {
            SaleClosingFlag     = "N";
            PurchaseClosingFlag = "N";
        }
    }

    public class TransRateOrderModel
    {
        public int    CenterCode           { get; set; }
        public string OrderNo              { get; set; }
        public int    RateInfoKind         { get; set; }
        public string TransDtlSeqNo        { get; set; }
        public double SaleUnitAmt          { get; set; }
        public double PurchaseUnitAmt      { get; set; }
        public double FixedPurchaseUnitAmt { get; set; }
        public string RateInfo             { get; set; }
    }

    public class ReqTransRateOrderList
    {
        public int    CenterCode        { get; set; }
        public long   OrderNo           { get; set; }
        public string CarFixedFlag      { get; set; }
        public string AdminID           { get; set; }
    }

    public class ResTransRateOrderList
    {
        public List<TransRateOrderModel> list       { get; set; }
        public int                       RecordCnt  { get; set; }
        public string                    ApplySeqNo { get; set; }
    }


    public class ReqTransRateOrderApplyList
    {
        public int    CenterCode        { get; set; }
        public long   ClientCode        { get; set; }
        public long   ConsignorCode     { get; set; }
        public string OrderItemCode     { get; set; }
        public string OrderLocationCode { get; set; }
        public string FTLFlag           { get; set; }
        public string CarFixedFlag      { get; set; }
        public string FromAddrs         { get; set; }
        public string ToAddrs           { get; set; }
        public int    GoodsRunType      { get; set; }
        public string CarTonCode        { get; set; }
        public string CarTypeCode       { get; set; }
        public string PickupYMD         { get; set; }
        public string PickupHM          { get; set; }
        public string GetYMD            { get; set; }
        public string GetHM             { get; set; }
        public int    Volume            { get; set; }
        public double CBM               { get; set; }
        public double Weight            { get; set; }
        public int    Length            { get; set; }
        public string LayoverFlag       { get; set; }
        public int    SamePlaceCount    { get; set; }
        public int    NonSamePlaceCount { get; set; }
        public string AdminID           { get; set; }
    }

    public class ResTransRateOrderApplyList
    {
        public List<TransRateOrderModel> list       { get; set; }
        public int                       RecordCnt  { get; set; }
        public string                    ApplySeqNo { get; set; }
    }
    
    public class ReqOrderHwaseungIns
    {
        public int    CenterCode               { get; set; }
        public long   OrderClientCode          { get; set; }
        public long   PayClientCode            { get; set; }
        public long   ConsignorCode            { get; set; }
        public string DeliveryType             { get; set; }
        public string PickupYMD                { get; set; }
        public long   PickupPlaceSeqNo         { get; set; }
        public string GetYMD                   { get; set; }
        public long   GetPlaceSeqNo            { get; set; }
        public string NoteInside               { get; set; }
        public string CarTonCode               { get; set; }
        public long   RefSeqNo                 { get; set; }
        public double SaleAmt                  { get; set; }
        public double SaleLayoverAmt           { get; set; }
        public double SaleWaitingAmt           { get; set; }
        public double SaleWorkingAmt           { get; set; }
        public double SaleAreaAmt              { get; set; }
        public double SaleOilDifferenceAmt     { get; set; }
        public double PurchaseAmt              { get; set; }
        public double PurchaseLayoverAmt       { get; set; }
        public double PurchaseWaitingAmt       { get; set; }
        public double PurchaseConservationAmt  { get; set; }
        public double PurchaseOilAmt           { get; set; }
        public double PurchaseAreaAmt          { get; set; }
        public double PurchaseOilDifferenceAmt { get; set; }
        public string RegAdminID               { get; set; }
        public string RegAdminName             { get; set; }
    }

    public class ResOrderHwaseungIns
    {
        public string OrderNo       { get; set; }
        public string AddSeqNo      { get; set; }
        public string GoodsSeqNo    { get; set; }
        public string DispatchSeqNo { get; set; }
    }

    public class ReqOrderHwaseungChk
    {
        public int    CenterCode    { get; set; }
        public string ConsignorName { get; set; }
        public string PickupYMD     { get; set; }
        public string PickupPlace   { get; set; }
        public string DeliveryType  { get; set; }
        public string GetPlace      { get; set; }
        public string CarTon        { get; set; }
        public string CarNo         { get; set; }
        public string DriverName    { get; set; }
        public string DriverCell    { get; set; }
        public long   RefSeqNo      { get; set; }
        public string AdminID       { get; set; }
    }

    public class ResOrderHwaseungChk
    {
        public string CenterFlag       { get; set; }
        public int    CenterCode       { get; set; }
        public string AuthFlag         { get; set; }
        public string ClientFlag       { get; set; }
        public string ClientCode       { get; set; }
        public string PickupYMDFlag    { get; set; }
        public string ConsignorFlag    { get; set; }
        public string ConsignorCode    { get; set; }
        public string PickupPlaceFlag  { get; set; }
        public string PickupPlaceSeqNo { get; set; }
        public string GetPlaceFlag     { get; set; }
        public string GetPlaceSeqNo    { get; set; }
        public string CarTonFlag       { get; set; }
        public string CarTonCode       { get; set; }
        public string CarFlag          { get; set; }
        public int    CarCnt           { get; set; }
        public string RefSeqNo         { get; set; }
    }

    public class OrderPdfLogModel
    {
        public long   SeqNo        { get; set; }
        public string FileName     { get; set; }
        public string FileUrl      { get; set; }
        public string RawData      { get; set; }
        public string ViewData     { get; set; }
        public int    RegType      { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
        public string RegDate      { get; set; }
    }

    public class EdiWorkOrderGridModel
    {
        public string WoSeqNo                         { get; set; }
        public string OriginatorCode                  { get; set; }
        public string ReceiverCode                    { get; set; }
        public string WorkOrderNumber                 { get; set; }
        public string CarrierCode                     { get; set; }
        public string Category                        { get; set; }
        public string CreatedBy                       { get; set; }
        public string WorkOrderDate                   { get; set; }
        public string BookingNumber                   { get; set; }
        public string BillOfLadingNumber              { get; set; }
        public string MasterAirWayBillNumber          { get; set; }
        public string HouseAirWayBillNumber           { get; set; }
        public string PaymentMethodIndicator          { get; set; }
        public string ShipmentReferenceNumber         { get; set; }
        public string OriginatorOnHandNumber          { get; set; }
        public string OriginatorOrderReference        { get; set; }
        public string OriginatorImportReferenceNumber { get; set; }
        public string ExportCutoffDate                { get; set; }
        public string Voyage                          { get; set; }
        public string PortOfLoading                   { get; set; }
        public string Shipper                         { get; set; }
        public string BillTo                          { get; set; }
        public string Comments                        { get; set; }
        public int    CenterCode                      { get; set; }
        public string CenterName                      { get; set; }
        public string OrderNo                         { get; set; }
        public string Accept                          { get; set; }
        public int    AcceptProcState                 { get; set; }
        public string AcceptProcStateM                { get; set; }
        public string ScheduledPickup                 { get; set; }
        public string ScheduledPickupDT               { get; set; }
        public int    ScheduledPickupProcState        { get; set; }
        public string ScheduledPickupProcStateM       { get; set; }
        public string ScheduledDelivery               { get; set; }
        public string ScheduledDeliveryDT             { get; set; }
        public int    ScheduledDeliveryProcState      { get; set; }
        public string ScheduledDeliveryProcStateM     { get; set; }
        public string ActualPickup                    { get; set; }
        public string ActualPickupDT                  { get; set; }
        public int    ActualPickupProcState           { get; set; }
        public string ActualPickupProcStateM          { get; set; }
        public string ActualDelivery                  { get; set; }
        public string ActualDeliveryDT                { get; set; }
        public int    ActualDeliveryProcState         { get; set; }
        public string ActualDeliveryProcStateM        { get; set; }
        public string Reject                          { get; set; }
        public string RejectReasonCode                { get; set; }
        public int    RejectProcState                 { get; set; }
        public string RejectProcStateM                { get; set; }
        public string POD                             { get; set; }
        public int    PODProcState                    { get; set; }
        public string PODProcStateM                   { get; set; }
        public int    WorkOrderStatus                 { get; set; }
        public string WorkOrderStatusM                { get; set; }
        public string RegYMD                          { get; set; }
        public string RegDate                         { get; set; }
        public string UpdDate                         { get; set; }
        public string UpdAdminID                      { get; set; }
        public string OrderRegFlag                    { get; set; }
        public string OrderStatusM                    { get; set; }
        public string AcceptDate                      { get; set; }
        public string AcceptAdminID                   { get; set; }
        public string AcceptAdminName                 { get; set; }
        public string PickupYMD                       { get; set; }
        public string PickupHM                        { get; set; }
        public string PickupPlace                     { get; set; }
        public string GetYMD                          { get; set; }
        public string GetHM                           { get; set; }
        public string GetPlace                        { get; set; }
        public string ClientCode                      { get; set; }
        public string ClientName                      { get; set; }
        public string ClientNameSimple                { get; set; }
        public string ClientCorpNo                    { get; set; }
        public string MisuFlag                        { get; set; }
        public double MisuAmt                         { get; set; }
        public int    NoMatchingCnt                   { get; set; }
        public string DispatchSeqNo                   { get; set; }
        public string EdiPickupYMD                    { get; set; }
    }

    public class ReqEdiWorkOrderList
    {
        public long   WoSeqNo                { get; set; }
        public string WorkOrderNumber        { get; set; }
        public long   OrderNo                { get; set; }
        public int    CenterCode             { get; set; }
        public int    DateType               { get; set; }
        public string DateFrom               { get; set; }
        public string DateTo                 { get; set; }
        public string WorkOrderStatuses      { get; set; }
        public string CreatedBy              { get; set; }
        public string MasterAirWayBillNumber { get; set; }
        public string HouseAirWayBillNumber  { get; set; }
        public string MyOrderFlag            { get; set; }
        public string AdminID                { get; set; }
        public string AccessCenterCode       { get; set; }
        public int    PageSize               { get; set; }
        public int    PageNo                 { get; set; }
    }

    public class ResEdiWorkOrderList
    {
        public List<EdiWorkOrderGridModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class EdiStopGridModel
    {
        public string StSeqNo              { get; set; }
        public string WorkOrderNumber      { get; set; }
        public string StopType             { get; set; }
        public string StopName             { get; set; }
        public int    StopNumber           { get; set; }
        public string StopReferenceNumber  { get; set; }
        public string Address1             { get; set; }
        public string Address2             { get; set; }
        public string City                 { get; set; }
        public string Country              { get; set; }
        public string PostalCode           { get; set; }
        public string ContactName          { get; set; }
        public string ContactPhone         { get; set; }
        public string Comments             { get; set; }
        public string Latitude             { get; set; }
        public string Longitude            { get; set; }
        public string EquipmentTypeCode    { get; set; }
        public string Shipmentnumber       { get; set; }
        public string ScheduledGateInStart { get; set; }
        public string ScheduledGateInForm  { get; set; }
        public string ScheduledGateInEnd   { get; set; }
        public string RegDate              { get; set; }

    }

    public class ReqEdiStopList
    {
        public long   StSeqNo                { get; set; }
        public string WorkOrderNumber        { get; set; }
        public long   OrderNo                { get; set; }
        public int    CenterCode             { get; set; }
        public string StopType               { get; set; }
        public string StopName               { get; set; }
        public string AccessCenterCode       { get; set; }
    }

    public class ResEdiStopList
    {
        public List<EdiStopGridModel> list      { get; set; }
        public int                    RecordCnt { get; set; }
    }

    public class EdiEquipmentGridModel
    {
        public string EqSeqNo            { get; set; }
        public string WorkOrderNumber    { get; set; }
        public string EquipmentNumber    { get; set; }
        public string EquipmentTypeCode  { get; set; }
        public int    PieceCount         { get; set; }
        public double GrossWeight        { get; set; }
        public string WeightUOM          { get; set; }
        public double Volume             { get; set; }
        public string VolumeUOM          { get; set; }
        public string FreightDescription { get; set; }
        public string IsHazmat           { get; set; }
        public string IsOverweight       { get; set; }
        public string Shipmentnumber     { get; set; }
        public double Height             { get; set; }
        public double Width              { get; set; }
        public double Length             { get; set; }
        public string DimensionUOM       { get; set; }
        public string RegDate            { get; set; }
    }

    public class ReqEdiEquipmentList
    {
        public long   EqSeqNo          { get; set; }
        public string WorkOrderNumber  { get; set; }
        public long   OrderNo          { get; set; }
        public int    CenterCode       { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResEdiEquipmentList
    {
        public List<EdiEquipmentGridModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class ReqEdiWorkOrderProcStateUpd
    {
        public int    CenterCode       { get; set; }
        public long   OrderNo          { get; set; }
        public int    ProcType         { get; set; }
        public string PODUrl           { get; set; }
        public string RejectReasonCode { get; set; }
        public string AdminID          { get; set; }
    }

    public class EdiOrderInfo:ResponseCommon
    {
        public int    CenterCode               { get; set; }
        public string OrderItemCode            { get; set; }
        public string OrderLocationCode        { get; set; }
        public string OrderClientCode          { get; set; }
        public string OrderClientName          { get; set; }
        public string OrderClientChargeName    { get; set; }
        public string OrderClientMisuFlag      { get; set; }
        public double OrderClientMisuAmt       { get; set; }
        public int    OrderClientNoMatchingCnt { get; set; }
        public string PayClientCode            { get; set; }
        public string PayClientName            { get; set; }
        public string PayClientCorpNo          { get; set; }
        public string PayClientChargeName      { get; set; }
        public string PayClientMisuFlag        { get; set; }
        public double PayClientMisuAmt         { get; set; }
        public int    PayClientNoMatchingCnt   { get; set; }
        public string ConsignorName            { get; set; }
        public string PickupYMD                { get; set; }
        public string PickupHM                 { get; set; }
        public string PickupPlace              { get; set; }
        public string PickupPlacePost          { get; set; }
        public string PickupPlaceAddr          { get; set; }
        public string PickupPlaceAddrDtl       { get; set; }
        public string PickupPlaceChargeName    { get; set; }
        public string PickupPlaceChargeTelNo   { get; set; }
        public string PickupPlaceLocalName     { get; set; }
        public string PickupPlaceNote          { get; set; }
        public string GetYMD                   { get; set; }
        public string GetHM                    { get; set; }
        public string GetPlace                 { get; set; }
        public string GetPlacePost             { get; set; }
        public string GetPlaceAddr             { get; set; }
        public string GetPlaceAddrDtl          { get; set; }
        public string GetPlaceChargeName       { get; set; }
        public string GetPlaceChargeTelNo      { get; set; }
        public string GetPlaceLocalName        { get; set; }
        public string GetPlaceNote             { get; set; }
        public string NoteClient               { get; set; }
        public int    Length                   { get; set; }
        public double CBM                      { get; set; }
        public string Quantity                 { get; set; }
        public int    Volume                   { get; set; }
        public double Weight                   { get; set; }
        public string Nation                   { get; set; }
        public string Hawb                     { get; set; }
        public string Mawb                     { get; set; }
        public string InvoiceNo                { get; set; }
        public string BookingNo                { get; set; }
        public string StockNo                  { get; set; }
        public string GoodsNote                { get; set; }
        public int    OrderRegType             { get; set; } = 1;
        public int    InsureExceptKind         { get; set; } = 1;
        public string WoSeqNo                  { get; set; }
    }

    public class ReqWmsOrderList
    {
        public long   OrderNo          { get; set; }
        public int    CenterCode       { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string OrderStatuses    { get; set; }
        public string OrderClientName  { get; set; }
        public string PayClientName    { get; set; }
        public string ConsignorName    { get; set; }
        public string PickupPlace      { get; set; }
        public string ComName          { get; set; }
        public string ComCorpNo        { get; set; }
        public string DriverName       { get; set; }
        public string CarNo            { get; set; }
        public string DeliveryNo       { get; set; }
        public string AcceptAdminName  { get; set; }
        public string MyOrderFlag      { get; set; }
        public string CnlFlag          { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class WmsOrderGridModel
    {
        public int    CenterCode                { get; set; }
        public string CenterName                { get; set; }
        public string OrderNo                   { get; set; }
        public string OrderItemCode             { get; set; }
        public string OrderItemCodeM            { get; set; }
        public string OrderClientCode           { get; set; }
        public string OrderClientName           { get; set; }
        public string PayClientCode             { get; set; }
        public string PayClientName             { get; set; }
        public string ConsignorCode             { get; set; }
        public string ConsignorName             { get; set; }
        public string PickupYMD                 { get; set; }
        public string PickupPlace               { get; set; }
        public string PickupPlaceAddr           { get; set; }
        public string PickupPlaceAddrDtl        { get; set; }
        public string PickupPlaceFullAddr       { get; set; }
        public string PickupPlaceChargeName     { get; set; }
        public string PickupPlaceChargePosition { get; set; }
        public string PickupPlaceChargeTelExtNo { get; set; }
        public string PickupPlaceChargeTelNo    { get; set; }
        public string PickupPlaceChargeCell     { get; set; }
        public string PickupPlaceAddrLat        { get; set; }
        public string PickupPlaceAddrLong       { get; set; }
        public int    OrderStatus               { get; set; }
        public string OrderStatusM              { get; set; }
        public int    OrderRegType              { get; set; }
        public string OrderRegTypeM             { get; set; }
        public string RegDate                   { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
        public string UpdDate                   { get; set; }
        public string UpdAdminID                { get; set; }
        public string UpdAdminName              { get; set; }
        public string AcceptDate                { get; set; }
        public string AcceptAdminID             { get; set; }
        public string AcceptAdminName           { get; set; }
        public string CnlFlag                   { get; set; }
        public string CnlAdminID                { get; set; }
        public string CnlAdminName              { get; set; }
        public string CnlDate                   { get; set; }
        public string DispatchSeqNo             { get; set; }
        public string RefSeqNo                  { get; set; }
        public string CarNo                     { get; set; }
        public int    CarDivType                { get; set; }
        public string CarDivTypeM               { get; set; }
        public string CarTonCode                { get; set; }
        public string CarTonCodeM               { get; set; }
        public string ComCorpNo                 { get; set; }
        public string DriverName                { get; set; }
        public string DriverCell                { get; set; }
        public string PickupDT                  { get; set; }
        public string GetDT                     { get; set; }
        public int    TotalQuantity             { get; set; }
        public double TotalWeight               { get; set; }
        public int    BoxQuantity               { get; set; }
        public int    BoxQuantityNoPickup       { get; set; }
        public int    BoxQuantityPickup         { get; set; }
        public int    BoxQuantityDelivery       { get; set; }
        public int    UnitQuantity              { get; set; }
        public int    UnitQuantityNoPickup      { get; set; }
        public int    UnitQuantityPickup        { get; set; }
        public int    UnitQuantityDelivery      { get; set; }
        public int    Quantity                  { get; set; }
        public int    QuantityNoPickup          { get; set; }
        public int    QuantityPickup            { get; set; }
        public int    QuantityDelivery          { get; set; }
        public int    LayoverCnt                { get; set; }
        public int    LayoverPickupCnt          { get; set; }
        public int    LayoverDeliveryCnt        { get; set; }
        public string ThermographFlag           { get; set; }
        public string ThermographDate           { get; set; }
        public string LastPickupDate            { get; set; }
        public string LastDeliveryDate          { get; set; }
    }

    public class ResWmsOrderList
    {

        public List<WmsOrderGridModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class ReqWmsOrderLayoverList
    {
        public long   LayoverSeqNo     { get; set; }
        public long   OrderNo          { get; set; }
        public int    CenterCode       { get; set; }
        public string DeliveryNo       { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class WmsOrderLayoverGridModel
    {
        public string LayoverSeqNo         { get; set; }
        public int    CenterCode           { get; set; }
        public string OrderNo              { get; set; }
        public string DeliveryNo           { get; set; }
        public string TruckNo              { get; set; }
        public string DeliveryName         { get; set; }
        public string DeliveryAddr         { get; set; }
        public string DeliveryAddrLat      { get; set; }
        public string DeliveryAddrLong     { get; set; }
        public string DeliveryCell         { get; set; }
        public string DeliveryTelNo        { get; set; }
        public int    BoxQuantity          { get; set; }
        public int    BoxQuantityNoPickup  { get; set; }
        public int    BoxQuantityPickup    { get; set; }
        public int    BoxQuantityDelivery  { get; set; }
        public int    UnitQuantity         { get; set; }
        public int    UnitQuantityNoPickup { get; set; }
        public int    UnitQuantityPickup   { get; set; }
        public int    UnitQuantityDelivery { get; set; }
        public int    Quantity             { get; set; }
        public int    QuantityNoPickup     { get; set; }
        public int    QuantityPickup       { get; set; }
        public int    QuantityDelivery     { get; set; }
        public double Weight               { get; set; }
        public double Price                { get; set; }
        public string LayoverNote          { get; set; }
        public string LayoverConsignorName { get; set; }
        public string DispatchYMD          { get; set; }
        public string PickupFlag           { get; set; }
        public string PickupFlagM          { get; set; }
        public string PickupDate           { get; set; }
        public string DeliveryFlag         { get; set; }
        public string DeliveryFlagM        { get; set; }
        public string DeliveryDate         { get; set; }
        public int    LayoverSort          { get; set; }
        public int    LayoverFileCnt       { get; set; }
        public int    LayoverGoodsCnt      { get; set; }
        public string RegAdminID           { get; set; }
        public string RegDate              { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdDate              { get; set; }
    }

    public class ResWmsOrderLayoverList
    {

        public List<WmsOrderLayoverGridModel> list      { get; set; }
        public int                            RecordCnt { get; set; }
    }

    public class ReqWmsOrderLayoverFileList
    {
        public long   FileSeqNo        { get; set; }
        public int    CenterCode       { get; set; }
        public long   OrderNo          { get; set; }
        public string DeliveryNo       { get; set; }
        public int    FileType         { get; set; }
        public int    FileGubun        { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class WmsOrderLayoverFileGridModel
    {
        public string FileSeqNo     { get; set; }
        public string CenterCode    { get; set; }
        public string OrderNo       { get; set; }
        public string DeliveryNo    { get; set; }
        public int    FileRegType   { get; set; }
        public string FileRegTypeM  { get; set; }
        public string FileNameNew   { get; set; }
        public int    FileType      { get; set; }
        public string FileTypeM     { get; set; }
        public int    FileGubun     { get; set; }
        public string FileGubunM    { get; set; }
        public string FileDir       { get; set; }
        public string DelFlag       { get; set; }
        public string RegDate       { get; set; }
        public string RegAdminID    { get; set; }
        public string DelDate       { get; set; }
        public string DelAdminID    { get; set; }
        public string PickupYMD     { get; set; }
        public string ConsignorName { get; set; }
    }

    public class ResWmsOrderLayoverFileList
    {

        public List<WmsOrderLayoverFileGridModel> list      { get; set; }
        public int                                RecordCnt { get; set; }
    }

    public class ResWmsOrderReceiptList
    {

        public List<OrderDispatchFileGridModel>   DispatchFileList      { get; set; }
        public int                                DispatchFileRecordCnt { get; set; }
        public List<WmsOrderLayoverFileGridModel> LayoverFileList       { get; set; }
        public int                                LayoverFileRecordCnt  { get; set; }
    }

    public class ReqWmsOrderLayoverGoodsList
    {
        public long   GoodsSeqNo       { get; set; }
        public int    CenterCode       { get; set; }
        public long   OrderNo          { get; set; }
        public string DeliveryNo       { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class WmsOrderLayoverGoodsGridModel
    {
        public string GoodsSeqNo           { get; set; }
        public int    CenterCode           { get; set; }
        public string CenterName           { get; set; }
        public string OrderNo              { get; set; }
        public string DeliveryNo           { get; set; }
        public string GoodsBarcodeNo       { get; set; }
        public string GoodsCode            { get; set; }
        public string GoodsName            { get; set; }
        public double GoodsWeight          { get; set; }
        public string GoodsSpec            { get; set; }
        public string GoodsUnitPrice       { get; set; }
        public string GoodsUnitType        { get; set; }
        public int    GoodsQuantity        { get; set; }
        public double GoodsPrice           { get; set; }
        public int    GoodsPickupStatus    { get; set; }
        public string GoodsPickupStatusM   { get; set; }
        public string GoodsPickupDate      { get; set; }
        public int    GoodsDeliveryStatus  { get; set; }
        public string GoodsDeliveryStatusM { get; set; }
        public string GoodsDeliveryDate    { get; set; }
        public string RegAdminID           { get; set; }
        public string RegDate              { get; set; }
        public string UpdAdminID           { get; set; }
        public string UpdDate              { get; set; }
        public string DispatchYMD          { get; set; }
        public string DeliveryName         { get; set; }
    }
    public class ResWmsOrderLayoverGoodsList
    {
        public List<WmsOrderLayoverGoodsGridModel> list      { get; set; }
        public int                                 RecordCnt { get; set; }
    }

    public class ReqOrderLayoverGoodsStatusUpd
    {
        public long   GoodsSeqNo  { get; set; }
        public int    CenterCode  { get; set; }
        public long   OrderNo     { get; set; }
        public int    StatusType  { get; set; }
        public int    StatusValue { get; set; }
        public string AdminID     { get; set; }
    }
}