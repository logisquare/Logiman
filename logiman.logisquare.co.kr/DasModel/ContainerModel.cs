using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ContainerModel
    {
        public int    CenterCode                { get; set; }
        public long   OrderNo                   { get; set; }
        public long   AddSeqNo                  { get; set; }
        public long   GoodsSeqNo                { get; set; }
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
        public string PickupPlace               { get; set; }
        public string PickupPlacePost           { get; set; }
        public string PickupPlaceAddr           { get; set; }
        public string PickupPlaceAddrDtl        { get; set; }
        public string PickupPlaceFullAddr       { get; set; }
        public string PickupPlaceChargeTelExtNo { get; set; }
        public string PickupPlaceChargeTelNo    { get; set; }
        public string PickupPlaceChargeCell     { get; set; }
        public string PickupPlaceChargeName     { get; set; }
        public string PickupPlaceChargePosition { get; set; }
        public string PickupPlaceLocalCode      { get; set; }
        public string PickupPlaceLocalName      { get; set; }
        public string PickupPlaceNote           { get; set; }
        public string NoteClient                { get; set; }
        public string NoteInside                { get; set; }
        public string CustomFlag                { get; set; }
        public string BondedFlag                { get; set; }
        public string DocumentFlag              { get; set; }
        public int    OrderStatus               { get; set; }
        public int    OrderRegType              { get; set; }
        public string Item                      { get; set; }
        public string Port                      { get; set; }
        public string CargoClosingTime          { get; set; }
        public string EnterYMD                  { get; set; }
        public string ShipmentYMD               { get; set; }
        public string ShipmentPort              { get; set; }
        public string ShippingCompany           { get; set; }
        public string ShippingShipName          { get; set; }
        public string ShippingCharge            { get; set; }
        public string ShippingTelNo             { get; set; }
        public string PickupCY                  { get; set; }
        public string PickupCYCharge            { get; set; }
        public string PickupCYTelNo             { get; set; }
        public string GetCY                     { get; set; }
        public string GetCYCharge               { get; set; }
        public string GetCYTelNo                { get; set; }
        public string Consignor                 { get; set; }
        public string ShipCode                  { get; set; }
        public string ShipName                  { get; set; }
        public string DivCode                   { get; set; }
        public string GoodsItemCode             { get; set; }
        public int    Volume                    { get; set; }
        public double Weight                    { get; set; }
        public string BookingNo                 { get; set; }
        public string CntrNo                    { get; set; }
        public string SealNo                    { get; set; }
        public string DONo                      { get; set; }
        public string GoodsOrderNo              { get; set; }
        public string BLNo                      { get; set; }
        public int    GoodsRunType              { get; set; } // 2023-03-16 by shadow54 : 자동운임 수정 건
        public string CarFixedFlag              { get; set; }
        public string LayoverFlag               { get; set; }
        public int    SamePlaceCount            { get; set; }
        public int    NonSamePlaceCount         { get; set; }
        public long   ReqSeqNo                  { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
        public string UpdAdminID                { get; set; }
        public string UpdAdminName              { get; set; }
    }

    public class ContainerGridModel
    {
        public int    CenterCode                { get; set; }
        public string CenterName                { get; set; }
        public string OrderNo                   { get; set; }
        public string AddSeqNo                  { get; set; }
        public string GoodsSeqNo                { get; set; }
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
        public string PayClientCode             { get; set; }
        public string PayClientName             { get; set; }
        public string PayClientChargeName       { get; set; }
        public string PayClientChargePosition   { get; set; }
        public string PayClientChargeTelExtNo   { get; set; }
        public string PayClientChargeTelNo      { get; set; }
        public string PayClientChargeCell       { get; set; }
        public string PayClientChargeLocation   { get; set; }
        public string PayClientCorpNo           { get; set; }
        public string PayClientMisuFlag         { get; set; }
        public double PayClientTotalMisuAmt     { get; set; }
        public double PayClientMisuAmt          { get; set; }
        public int    PayClientNoMatchingCnt    { get; set; }
        public string PayClientInfo             { get; set; }
        public string ConsignorCode             { get; set; }
        public string ConsignorName             { get; set; }
        public string PayClientType             { get; set; }
        public string PayClientTypeM            { get; set; }
        public string PickupYMD                 { get; set; }
        public string PickupHM                  { get; set; }
        public string PickupPlace               { get; set; }
        public string PickupPlacePost           { get; set; }
        public string PickupPlaceAddr           { get; set; }
        public string PickupPlaceAddrDtl        { get; set; }
        public string PickupPlaceFullAddr       { get; set; }
        public string PickupPlaceChargeTelExtNo { get; set; }
        public string PickupPlaceChargeTelNo    { get; set; }
        public string PickupPlaceChargeCell     { get; set; }
        public string PickupPlaceChargeName     { get; set; }
        public string PickupPlaceChargePosition { get; set; }
        public string PickupPlaceLocalCode      { get; set; }
        public string PickupPlaceLocalName      { get; set; }
        public string PickupPlaceNote           { get; set; }
        public string NoteClient                { get; set; }
        public string NoteInside                { get; set; }
        public string CustomFlag                { get; set; }
        public string BondedFlag                { get; set; }
        public string DocumentFlag              { get; set; }
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
        public string Item                      { get; set; }
        public string Port                      { get; set; }
        public string CargoClosingTime          { get; set; }
        public string EnterYMD                  { get; set; }
        public string ShipmentYMD               { get; set; }
        public string ShipmentPort              { get; set; }
        public string ShippingCompany           { get; set; }
        public string ShippingShipName          { get; set; }
        public string ShippingCharge            { get; set; }
        public string ShippingTelNo             { get; set; }
        public string PickupCY                  { get; set; }
        public string PickupCYCharge            { get; set; }
        public string PickupCYTelNo             { get; set; }
        public string GetCY                     { get; set; }
        public string GetCYCharge               { get; set; }
        public string GetCYTelNo                { get; set; }
        public string Consignor                 { get; set; }
        public string ShipCode                  { get; set; }
        public string ShipName                  { get; set; }
        public string DivCode                   { get; set; }
        public string GoodsItemCode             { get; set; }
        public string GoodsItemCodeM            { get; set; }
        public int    Volume                    { get; set; }
        public double Weight                    { get; set; }
        public string BookingNo                 { get; set; }
        public string CntrNo                    { get; set; }
        public string SealNo                    { get; set; }
        public string DONo                      { get; set; }
        public string GoodsOrderNo              { get; set; }
        public string BLNo                      { get; set; }
        public double SaleSupplyAmt             { get; set; }
        public double PurchaseSupplyAmt         { get; set; }
        public double AdvanceSupplyAmt3         { get; set; }
        public double AdvanceSupplyAmt4         { get; set; }
        public string DispatchSeqNo             { get; set; }
        public int    DispatchType              { get; set; }
        public string DispatchTypeM             { get; set; }
        public string RefSeqNo                  { get; set; }
        public int    CarDivType                { get; set; }
        public string CarDivTypeM               { get; set; }
        public string ComCode                   { get; set; }
        public string ComName                   { get; set; }
        public string ComCeoName                { get; set; }
        public string ComCorpNo                 { get; set; }
        public string CarNo                     { get; set; }
        public string CarTonCode                { get; set; }
        public string CarTonCodeM               { get; set; }
        public string CarTypeCode               { get; set; }
        public string CarTypeCodeM              { get; set; }
        public string DriverName                { get; set; }
        public string DriverCell                { get; set; }
        public string DispatchAdminName         { get; set; }
        public string PickupDT                  { get; set; }
        public string GetDT                     { get; set; }
    }

    public class ReqContainerList
    {
        public long   OrderNo                 { get; set; }
        public int    CenterCode              { get; set; }
        public string DateFrom                { get; set; }
        public string DateTo                  { get; set; }
        public string OrderLocationCodes      { get; set; }
        public string OrderItemCodes          { get; set; }
        public string OrderClientName         { get; set; }
        public string OrderClientChargeName   { get; set; }
        public string PayClientName           { get; set; }
        public string PayClientChargeName     { get; set; }
        public string PayClientChargeLocation { get; set; }
        public string ConsignorName           { get; set; }
        public string ComName                 { get; set; }
        public string CarNo                   { get; set; }
        public string PickupPlace             { get; set; }
        public string AcceptAdminName         { get; set; }
        public string GoodsItemCode           { get; set; }
        public string ShippingCompany         { get; set; }
        public string CntrNo                  { get; set; }
        public string BLNo                    { get; set; }
        public string MyChargeFlag            { get; set; }
        public string MyOrderFlag             { get; set; }
        public string CnlFlag                 { get; set; }
        public int    SortType                { get; set; }
        public string AdminID                 { get; set; }
        public string AccessCenterCode        { get; set; }
        public int    PageSize                { get; set; }
        public int    PageNo                  { get; set; }
    }

    public class ResContainerList
    {
        public List<ContainerGridModel> list      { get; set; }
        public int                      RecordCnt { get; set; }
    }

    public class ReqContainerCnl
    { 
        public int    CenterCode       { get; set; }
        public string OrderNos         { get; set; }
        public int    GradeCode        { get; set; }
        public string AccessCenterCode { get; set; }
        public string CnlReason        { get; set; }
        public string CnlAdminID       { get; set; }
        public string CnlAdminName     { get; set; }
    }

    public class ResContainerCnl
    {
        public int TotalCnt { get; set; }
        public int CancelCnt { get; set; }
    }

    //비용
    public class ContainerPayModel
    {
        public long   SeqNo            { get; set; }
        public int    CenterCode       { get; set; }
        public long   OrderNo          { get; set; }
        public long   GoodsSeqNo       { get; set; }
        public long   DispatchSeqNo    { get; set; }
        public int    PayType          { get; set; }
        public int    TaxKind          { get; set; }
        public string ItemCode         { get; set; }
        public long   ClientCode       { get; set; }
        public string ClientName       { get; set; }
        public long   RefSeqNo         { get; set; }
        public int    CarDivType       { get; set; }
        public long   ComCode          { get; set; }
        public long   CarSeqNo         { get; set; }
        public long   DriverSeqNo      { get; set; }
        public double SupplyAmt        { get; set; }
        public double TaxAmt           { get; set; }
        public int    InsureExceptKind { get; set; } = 1;
        public string RegAdminID       { get; set; }
        public string RegAdminName     { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdAdminName     { get; set; }
    }

    public class ContainerPayGridModel
    {
        public string PaySeqNo         { get; set; }
        public string SeqNo            { get; set; }
        public int    CenterCode       { get; set; }
        public string OrderNo          { get; set; }
        public string GoodsSeqNo       { get; set; }
        public string DispatchSeqNo    { get; set; }
        public int    PayType          { get; set; }
        public string PayTypeM         { get; set; }
        public int    TaxKind          { get; set; }
        public string TaxKindM         { get; set; }
        public string ItemCode         { get; set; }
        public string ItemCodeM        { get; set; }
        public string ClientCode       { get; set; }
        public string ClientName       { get; set; }
        public string ClientCorpNo     { get; set; }
        public string RefSeqNo         { get; set; }
        public double OrgAmt           { get; set; }
        public double SupplyAmt        { get; set; }
        public double TaxAmt           { get; set; }
        public int    BillStatus       { get; set; }
        public string ClosingFlag      { get; set; }
        public string ClosingSeqNo     { get; set; }
        public string ClosingAdminID   { get; set; }
        public string ClosingAdminName { get; set; }
        public string ClosingDate      { get; set; }
        public int    SendStatus       { get; set; }
        public string ClientInfo       { get; set; }
        public string DispatchInfo     { get; set; }
        public int    InsureExceptKind { get; set; }
        public string RegAdminID       { get; set; }
        public string RegAdminName     { get; set; }
        public string RegDate          { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdAdminName     { get; set; }
        public string UpdDate          { get; set; }
    }

    public class ResContainerPayList
    {
        public List<ContainerPayGridModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class ContainerPayItemModel
    {
        public long   SeqNo        { get; set; }
        public int    CenterCode   { get; set; }
        public long   OrderNo      { get; set; }
        public long   GoodsSeqNo   { get; set; }
        public int    PayType      { get; set; }
        public string PayTypeM     { get; set; }
        public string ItemCode     { get; set; }
        public string ItemCodeM    { get; set; }
        public double OrgAmt    { get; set; }
        public double SupplyAmt    { get; set; }
    }

    public class ReqContainerPayItemList
    {
        public long   OrderNo                 { get; set; }
        public int    CenterCode              { get; set; }
        public string DateFrom                { get; set; }
        public string DateTo                  { get; set; }
        public string OrderLocationCodes      { get; set; }
        public string OrderItemCodes          { get; set; }
        public string OrderClientName         { get; set; }
        public string OrderClientChargeName   { get; set; }
        public string PayClientName           { get; set; }
        public string PayClientChargeName     { get; set; }
        public string PayClientChargeLocation { get; set; }
        public string ConsignorName           { get; set; }
        public string ComName                 { get; set; }
        public string CarNo                   { get; set; }
        public string PickupPlace             { get; set; }
        public string AcceptAdminName         { get; set; }
        public string GoodsItemCode           { get; set; }
        public string ShippingCompany         { get; set; }
        public string CntrNo                  { get; set; }
        public string BLNo                    { get; set; }
        public string MyChargeFlag            { get; set; }
        public string MyOrderFlag             { get; set; }
        public string CnlFlag                 { get; set; }
        public string AdminID                 { get; set; }
        public string AccessCenterCode        { get; set; }
    }

    public class ResContainerPayItemList
    {
        public List<ContainerPayItemModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }


    public class ReqContainerOrderCount
    {
        public string AccessCenterCode { get; set; }
    }

    public class ResContainerOrderCount
    {
        public int WebRegRequestCnt { get; set; }
        public int WebUpdRequestCnt { get; set; }
    }

    public class ResContainerUpd
    {
        public string SaleClosingFlag     { get; set; }
        public string PurchaseClosingFlag { get; set; }

        public ResContainerUpd()
        {
            SaleClosingFlag     = "N";
            PurchaseClosingFlag = "N";
        }
    }
}