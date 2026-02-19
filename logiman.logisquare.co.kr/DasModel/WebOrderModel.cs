using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class WebOrderModel
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
        public string TaxClientName             { get; set; }
        public string TaxClientCorpNo           { get; set; }
        public string TaxClientChargeName       { get; set; }
        public string TaxClientChargeTelNo      { get; set; }
        public string TaxClientChargeEmail      { get; set; }
        public int    OrderRegType              { get; set; }
        public int    OrderStatus               { get; set; }
        public long   RefSeqNo                  { get; set; }
        public long   ReqSeqNo                  { get; set; }
        public string RegAdminID                { get; set; }
        public string RegAdminName              { get; set; }
        public string UpdAdminID                { get; set; }
        public string UpdAdminName              { get; set; }
        public int    QuickType                 { get; set; }
        public string ReqNo                     { get; set; }
        public string ReqChargeName             { get; set; }
        public string ReqChargePosition         { get; set; }
        public string ReqChargeTeam             { get; set; }
        public string ReqChargeCell             { get; set; }
        public string ReqChargeTel              { get; set; }
        public string ShuttleEtc                { get; set; }
        public string AdminCorpNo               { get; set; }
        public string ReqTransType              { get; set; }
        public string ChgReqContent             { get; set; }
        public string ChgMessage                { get; set; }
        public int    ChgStatus                 { get; set; }
        public long   ChgSeqNo                  { get; set; }
        public int    InOutType                 { get; set; }
        public string CnlFlag                   { get; set; }
        public string InOutEtc                  { get; set; }
    }

    public class WebOrderGridModel
    {
        public int    CenterCode                { get; set; }
        public string CenterName                { get; set; }
        public string OrderNo                   { get; set; }
        public string ChgSeqNo                  { get; set; }
        public string ReqSeqNo                  { get; set; }
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
        public string NoteClient                { get; set; }
        public string NoteInside                { get; set; }
        public string CarTonCode                { get; set; }
        public string CarTonCodeM               { get; set; }
        public string CarTypeCode               { get; set; }
        public string CarTypeCodeM              { get; set; }
        public string NoLayerFlag               { get; set; }
        public string NoTopFlag                 { get; set; }
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
        public string FTLFlag                   { get; set; }
        public string FTLFlagM                  { get; set; } // 2023-03-16 by shadow54 : 자동운임 수정 건
        public string TaxClientName             { get; set; }
        public string TaxClientCorpNo           { get; set; }
        public string TaxClientChargeName       { get; set; }
        public string TaxClientChargeTelNo      { get; set; }
        public string TaxClientChargeEmail      { get; set; }
        public string DispatchSeqNo1            { get; set; }
        public string DispatchRefSeqNo1         { get; set; }
        public string DispatchCarNo1            { get; set; }
        public string DispatchCarInfo1          { get; set; }
        public string DispatchInfo1             { get; set; }
        public string DispatchSupplyAmt1        { get; set; }
        public string DispatchTaxAmt1           { get; set; }
        public string DispatchSeqNo2            { get; set; }
        public string DispatchRefSeqNo2         { get; set; }
        public string DispatchCarNo2            { get; set; }
        public string DispatchCarInfo2          { get; set; }
        public string DispatchInfo2             { get; set; }
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
        public int    QuickType                 { get; set; }
        public string QuickTypeM                { get; set; }
        public string TransRateInfo             { get; set; }
        public int    ContractType              { get; set; }
        public string ContractTypeM             { get; set; }
        public int    ContractStatus            { get; set; }
        public string ContractStatusM           { get; set; }
        public string ContractInfo              { get; set; }
        public string ReqChargeName             { get; set; }
        public string ReqChargeTeam             { get; set; }
        public string ReqChargeTel              { get; set; }
        public string ReqChargeCell             { get; set; }
        public string ReqRegDate                { get; set; }
        public int    ChgStatus                 { get; set; }
        public string ChgStatusM                { get; set; }
        public string ChgReqContent             { get; set; }
        public string ChgMessage                { get; set; }
        public string InCarDt                   { get; set; }
        public string OutCarDt                  { get; set; }
        public string InOutEtc                  { get; set; }
        public string MooringTime               { get; set; }
        public string YMD                       { get; set; }
    }

    public class WebReqOrderList
    {
        public long   ReqSeqNo                { get; set; }
        public long   ChgSeqNo                { get; set; }
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
        public long   OrderClientCode         { get; set; }
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
        public int    OrderRegType            { get; set; }
        public int    ChgStatus               { get; set; }
        public int    ReqStatus               { get; set; }
        public string ReqChargeName           { get; set; }
        public string AdminID                 { get; set; }
        public string AccessCenterCode        { get; set; }
        public string AccessCorpNo            { get; set; }
        public int    PageSize                { get; set; }
        public int    PageNo                  { get; set; }
    }

    public class WebResOrderList
    {
        public List<WebOrderGridModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class WebReqOrderCnl
    {
        public int    CenterCode       { get; set; }
        public string OrderNos         { get; set; }
        public int    GradeCode        { get; set; }
        public string AccessCenterCode { get; set; }
        public string CnlReason        { get; set; }
        public string CnlAdminID       { get; set; }
        public string CnlAdminName     { get; set; }
    }

    public class WebResOrderCnl
    {
        public int TotalCnt  { get; set; }
        public int CancelCnt { get; set; }
    }

    //비용
    public class WebOrderPayModel
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
        public int    TransRateStatus { get; set; }
    }

    public class WebOrderPayGridModel
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
        public int    TransRateStatus   { get; set; }
        public string TransRateStatusM  { get; set; }
    }

    public class WebResOrderPayList
    {
        public List<OrderPayGridModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class WebOrderPayItemModel
    {
        public long   SeqNo      { get; set; }
        public int    CenterCode { get; set; }
        public long   OrderNo    { get; set; }
        public long   GoodsSeqNo { get; set; }
        public int    PayType    { get; set; }
        public string PayTypeM   { get; set; }
        public string ItemCode   { get; set; }
        public string ItemCodeM  { get; set; }
        public double OrgAmt     { get; set; }
        public double SupplyAmt  { get; set; }
    }

    public class WebReqOrderPayItemList
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

    public class WebResOrderPayItemList
    {
        public List<OrderPayItemModel> list { get; set; }
        public int RecordCnt { get; set; }
    }


    public class WebOrderFileModel
    {
        public long   FileSeqNo   { get; set; }
        public long   ReqSeqNo    { get; set; }
        public int    CenterCode  { get; set; }
        public long   OrderNo     { get; set; }
        public int    FileRegType { get; set; }
        public string FileName    { get; set; }
        public string FileNameNew { get; set; }
        public string FileDir     { get; set; }
        public string DelFlag     { get; set; }
        public string RegAdminID  { get; set; }
        public string DelAdminID  { get; set; }
    }

    public class WebOrderFileGridModel
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

    public class WebReqOrderFileList
    {
        public long   FileSeqNo        { get; set; }
        public long   OrderNo          { get; set; }
        public int    FileRegType      { get; set; }
        public int    CenterCode       { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class WebResOrderFileList
    {
        public List<OrderFileGridModel> list      { get; set; }
        public int                      RecordCnt { get; set; }
    }

    public class WebOrderCopyCalendarModel
    {
        public string YMD         { get; set; }
        public int    WeekMonth   { get; set; }
        public int    WeekNum     { get; set; }
        public string WeekStr     { get; set; }
        public string HolidayFlag { get; set; }
        public string OnOff       { get; set; }
        public string MaxDay      { get; set; }
    }

    public class WebResOrderCopyCalendarList
    {
        public List<OrderCopyCalendarModel> list      { get; set; }
        public int                          RecordCnt { get; set; }
    }
    public class WebReqOrderCopyIns
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
        public string AdminID           { get; set; }
        public string AdminName         { get; set; }
        public string AdminTeamCode     { get; set; }
    }
    
    public class WebOrderDispatchCarGridModel
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
        public string PickupYMD                 { get; set; }
        public string PickupHM                  { get; set; }
        public string GetYMD                    { get; set; }
        public string GetHM                     { get; set; }
        public string DispatchCarInfo           { get; set; }
    }

    public class WebResOrderDispatchCarList
    {
        public List<WebOrderDispatchCarGridModel> list      { get; set; }
        public int                                RecordCnt { get; set; }
    }

    public class WebReqOrderDispatchCarStatusUpd
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

    public class WebOrderSQIModel
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

    public class WebOrderSQIGridModel
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

    public class WebReqOrderSQIList
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

    public class WebResOrderSQIList
    {
        public List<WebOrderSQIGridModel> list      { get; set; }
        public int                        RecordCnt { get; set; }
    }

    public class WebOrderSQIItemModel
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

    public class WebOrderSQIItemGridModel
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

    public class WebReqOrderSQIItemList
    {
        public long   ItemSeqNo        { get; set; }
        public int    CenterCode       { get; set; }
        public string OrderItemCode    { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class WebResOrderSQIItemList
    {
        public List<OrderSQIItemGridModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }

    public class WebOrderSQICommentModel
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

    public class WebOrderSQICommentGridModel
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

    public class WebReqOrderSQICommentList
    {
        public long   SQISeqNo         { get; set; }
        public int    CenterCode       { get; set; }
        public string DelFlag          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class WebResOrderSQICommentList
    {
        public List<OrderSQICommentGridModel> list      { get; set; }
        public int                            RecordCnt { get; set; }
    }

    //정보망
    public class WebOrderNetworkModel
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

    public class WebOrderNetworkGridModel
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

    public class WebReqOrderNetworkList
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

    public class WebResOrderNetworkList
    {
        public List<OrderNetworkGridModel> list      { get; set; }
        public int                         RecordCnt { get; set; }
    }


    public class WebReqOrderNetworkCnl
    {
        public long   NetworkNo    { get; set; }
        public int    CenterCode   { get; set; }
        public string CnlAdminID   { get; set; }
        public string CnlAdminName { get; set; }
    }

    public class WebReqPlanYMDGet
    {
        public string YMD         { get; set; }
        public int    AddDateCnt  { get; set; }
        public string HolidayFlag { get; set; }
    }

    public class WebResPlanYMDGet
    {
        public string PlanYMD { get; set; }
    }
    
    public class WebAdminBookmarkOrderModel
    {
        public int    OrderSeqNo   { get; set; }
        public int    CenterCode   { get; set; }
        public long   OrderNo      { get; set; }
        public string BookmarkName { get; set; }
        public string RegAdminID   { get; set; }
        public string RegAdminName { get; set; }
    }

    public class WebAdminBookmarkOrderGridModel
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

    public class WebReqAdminBookmarkOrderList
    {
        public int    OrderSeqNo   { get; set; }
        public int    CenterCode   { get; set; }
        public string BookmarkName { get; set; }
        public string RegAdminID   { get; set; }
        public int    PageSize     { get; set; }
        public int    PageNo       { get; set; }
    }

    public class ReqOrderSaleClosingList
    { 
        public long SaleClosingSeqNo    { get; set; }
        public int  CenterCode          { get; set; }
        public int DateType             { get; set; }
        public string DateFrom          { get; set; }
        public string DateTo            { get; set; }

        public int BillStatus           { get; set; }
        public int GradeCode            { get; set; }
        public string AccessCenterCode  { get; set; }
        public string AccessCorpNo      { get; set; }
        public int PageSize             { get; set; }
        public int PageNo               { get; set; }
    }

    public class ResOrderSaleClosingList
    {
        public List<OrderSaleClosingListGrid> list          { get; set; }
        public int                            RecordCnt     { get; set; }
        public double                         AdvanceOrgAmt { get; set; }
    }

    public class OrderSaleClosingListGrid
    {
        public string SaleClosingSeqNo { get; set; }
        public int    CenterCode       { get; set; }
        public string CenterName       { get; set; }
        public string TelNo            { get; set; }
        public string FaxNo            { get; set; }
        public string Addr             { get; set; }
        public string BankName         { get; set; }
        public string EncAcctNo        { get; set; }
        public string AcctName         { get; set; }
        public string ClientCode       { get; set; }
        public string ClientCeoName    { get; set; }
        public string ClientCorpNo     { get; set; }
        public string ClientName       { get; set; }
        public string StartYMD         { get; set; }
        public string EndYMD           { get; set; }
        public double OrgAmt           { get; set; }
        public double SupplyAmt        { get; set; }
        public double TaxAmt           { get; set; }
        public int    BillStatus       { get; set; }
        public string BillStatusM      { get; set; }
        public string BillKind         { get; set; }
        public string BillKindM        { get; set; }
        public string BillChargeName   { get; set; }
        public string BillChargeTelNo  { get; set; }
        public string BillChargeEmail  { get; set; }
        public string BillWrite        { get; set; }
        public string BillYMD          { get; set; }
        public string BillAdminID      { get; set; }
        public string BillAdminName    { get; set; }
        public string BillDate         { get; set; }
        public string NtsConfirmNum    { get; set; }
        public string Note             { get; set; }
        public string ClosingKind      { get; set; }
        public string ClosingKindM     { get; set; }
        public string ClosingAdminID   { get; set; }
        public string ClosingAdminName { get; set; }
        public string ClosingYMD       { get; set; }
        public string ClosingDate      { get; set; }
        public int    PayStatus        { get; set; }
        public string PayStatusM       { get; set; }
        public string PayYMD           { get; set; }
        public string PayChargeName    { get; set; }
        public string PayChargeCell    { get; set; }
        public string UpdAdminID       { get; set; }
        public string UpdAdminName     { get; set; }
        public string UpdDate          { get; set; }
        public string BtnBillProc      { get; set; }
        public string BtnCardProc      { get; set; }
        public string AdvanceOrgAmt    { get; set; }
        public string SaleItemCodeM     { get; set; }
        public int    ClosingType      { get; set; }
        public string CardSeqNo        { get; set; }
        public string PGPayNo          { get; set; }

    }

    public class ReqOrderRequestChgList
    {
        public long   ChgSeqNo         { get; set; }
        public int    CenterCode       { get; set; }
        public long   OrderNo          { get; set; }
        public int    OrderClientCode  { get; set; }
        public int    ChgStatus        { get; set; }
        public int    ListType         { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string MyChargeFlag     { get; set; }
        public string AdminID          { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }

    }

    public class ResOrderRequestChgList
    {
        public List<OrderRequestChgListGrid> list      { get; set; }
        public int                           RecordCnt { get; set; }
    }

    public class OrderRequestChgListGrid {
        public string ChgSeqNo        { get; set; }
        public int    CenterCode      { get; set; }
        public string OrderNo         { get; set; }
        public string OrderItemCode   { get; set; }
        public string OrderItemCodeM  { get; set; }
        public string OrderClientCode { get; set; }
        public string ChgReqContent   { get; set; }
        public string ChgMessage      { get; set; }
        public int    ChgStatus       { get; set; }
        public string ChgStatusM      { get; set; }
        public string YMD             { get; set; }
        public string RegDate         { get; set; }
        public string RegAdminID      { get; set; }
        public string RegAdminName    { get; set; }
        public string UpdDate         { get; set; }
        public string UpdAdminID      { get; set; }
        public string UpdAdminName    { get; set; }
    }

    public class ReqWebConsignorList
    {
        public long   SeqNo            { get; set; }
        public int    CenterCode       { get; set; }
        public string ClientName       { get; set; }
        public int    ConsignorCode    { get; set; }
        public string ConsignorName    { get; set; }
        public int    GradeCode        { get; set; }
        public string AccessCenterCode { get; set; }
        public string AccessCorpNo     { get; set; }
        public string UseFlag          { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResWebConsignorList
    {
        public List<WebConsignorModel> list      { get; set; }
        public int                     RecordCnt { get; set; }
    }

    public class WebConsignorModel
    {
        public string ConsignorCode { get; set; }
        public int    CenterCode    { get; set; }
        public string CenterName    { get; set; }
        public string ConsignorName { get; set; }
        public string ConsignorNote { get; set; }
        public string UseFlag       { get; set; }
        public string RegAdminID    { get; set; }
        public string RegDate       { get; set; }
        public string UpdAdminID    { get; set; }
        public string UpdDate       { get; set; }
    }
}