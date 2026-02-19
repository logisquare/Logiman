using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class AppOrderGridModel
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
        public int    OrderStatusNumber         { get; set; }
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
        public int    QuickType                 { get; set; }
        public string QuickTypeM                { get; set; }
        public string TransRateInfo             { get; set; }
        public int    ContractType              { get; set; }
        public string ContractTypeM             { get; set; }
        public int    ContractStatus            { get; set; }
        public string ContractStatusM           { get; set; }
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
        public string TransRateFlag             { get; set; }
        public int    InsureExceptKind          { get; set; }
        public string InsureExceptKindM         { get; set; }
    }
    public class ReqAppOrderList
    {
        public long   OrderNo                 { get; set; }
        public int    CenterCode              { get; set; }
        public int    ListType                { get; set; }
        public int    DateType                { get; set; }
        public string DateYMD                 { get; set; }
        public string OrderLocationCodes      { get; set; }
        public string OrderItemCodes          { get; set; }
        public string OrderClientName         { get; set; }
        public string PayClientName           { get; set; }
        public string ConsignorName           { get; set; }
        public string PickupPlace             { get; set; }
        public string GetPlace                { get; set; }
        public string ComCorpNo               { get; set; }
        public string CarNo                   { get; set; }
        public string DriverName              { get; set; }
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

    public class ResAppOrderList
    {
        public List<AppOrderGridModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class ReqAppOrderDispatchUpd
    {
        public int    CenterCode       { get; set; }
        public long   OrderNo          { get; set; }
        public int    QuickType        { get; set; }
        public int    DispatchType     { get; set; }
        public int    DispatchKind     { get; set; }
        public long   RefSeqNo         { get; set; }
        public int    InsureExceptKind { get; set; } = 1;
        public string UpdAdminID       { get; set; }
        public string UpdAdminName     { get; set; }
    }

    public class AppTransRateOrderModel
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

    public class ReqAppTransRateOrderList
    {
        public int    CenterCode        { get; set; }
        public long   OrderNo           { get; set; }
        public string CarFixedFlag      { get; set; }
        public string AdminID           { get; set; }
    }

    public class ResAppTransRateOrderList
    {
        public List<AppTransRateOrderModel> list       { get; set; }
        public int                          RecordCnt  { get; set; }
        public string                       ApplySeqNo { get; set; }
    }

    public class ReqAppTransRateOrderApplyList
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

    public class ResAppTransRateOrderApplyList
    {
        public List<AppTransRateOrderModel> list       { get; set; }
        public int                          RecordCnt  { get; set; }
        public string                       ApplySeqNo { get; set; }
    }
}